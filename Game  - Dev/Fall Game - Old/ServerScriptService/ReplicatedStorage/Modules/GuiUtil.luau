-- [PATH] ReplicatedStorage / Modules / GuiUtil @Type ModuleScript
--[[
	GuiUtil
	by ChickenBagelz
	April 25, 2023
	
	Holds useful functions for different UI elements
]]


-- Services
local UserInput = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Replicated = game:GetService("ReplicatedStorage")

-- Folders
local Modules = Replicated:WaitForChild("Modules")

-- Modules
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))

-- Local Variables
local zoomFrames = {}

local GuiUtil = {}

function GuiUtil:AddScrollToFrame(ui: GuiBase2d, minimumZoom: number, maximumZoom: number, zoomMult: number?, startZoom: number?)
	local frame = assert(ui:FindFirstChild("Frame"), '"FRAME" COMPONENT NOT FOUND')
	startZoom = (startZoom or 1)
	zoomMult = (zoomMult or 0.1)
	local lastMousePos
	local connections = {}
	local info = {
		Connections = connections;
		Held = false;
		Delta = Vector3.new();
		Looping = false;
		Frame = frame;
		Scale = startZoom;
		TargetScale = startZoom;
	}
	frame.Size = UDim2.new(info.Scale, 0, info.Scale, 0)
	table.insert(connections, ui.InputBegan:Connect(function(input)
		if not ui.Visible then return end
		local inputType = input.UserInputType
		if inputType == Enum.UserInputType.MouseButton1 and not info.Held then
			--print("mouse held")
			lastMousePos = input.Position
			info.Held = true
			self:StartZoomLoop(ui)
		end
	end))
	table.insert(connections, UserInput.InputChanged:Connect(function(input)
		if not (ui.Visible and ui.Parent) then return end
		local inputType = input.UserInputType
		if inputType == Enum.UserInputType.MouseMovement and info.Held then
			--print("mouse changed")
			local newPos = input.Position
			info.Delta = (newPos - lastMousePos)
			lastMousePos = newPos
		elseif inputType == Enum.UserInputType.MouseWheel then
			local scrollDir = input.Position.Z
			info.TargetScale = math.clamp(info.TargetScale + scrollDir * zoomMult, minimumZoom, maximumZoom)
			self:StartZoomLoop(ui)
		end
	end))
	table.insert(connections, UserInput.InputEnded:Connect(function(input)
		local inputType = input.UserInputType
		if not (inputType == Enum.UserInputType.MouseButton1 and info.Held) then return end
		--print("mouse let go")
		info.Held = false
		info.Delta = (input.Position == lastMousePos and Vector3.new() or info.Delta)
	end))
	zoomFrames[ui] = info
end

function GuiUtil:StartZoomLoop(ui: GuiBase2d)
	local info = zoomFrames[ui]
	if (not info) or info.Looping then return end
	info.Looping = true
	local lastDelta
	--print("scroll/zoom loop started")
	while info.Held or info.Scale ~= info.TargetScale or info.Delta.Magnitude >= 0.01 do
		lastDelta = info.Delta
		local step = Run.Heartbeat:Wait()
		--print("loop running")
		local frame = info.Frame
		if not (frame and frame.Parent) then return end
		local doMovement = (info.Delta ~= lastDelta)
		if not info.Held then
			info.Delta = info.Delta:Lerp(Vector3.new(), step * 10)
			doMovement = true
		end
		local doScale = (info.Scale ~= info.TargetScale)
		if doScale then
			info.Scale = (math.abs(info.Scale - info.TargetScale) <= 0.01 and info.TargetScale or NumberUtil:Lerp(info.Scale, info.TargetScale, step * 15))
			frame.Size = UDim2.new(info.Scale, 0, info.Scale, 0)
			doScale = true
		end
		if not (doMovement or doScale) then continue end
		local pos = frame.Position
		local scale = info.Scale
		local delta = info.Delta
		local absSize = ui.AbsoluteSize
		local scaleFactor = scale * 0.5 - 0.5
		local minScale = 0.5 - scaleFactor
		local maxScale = 0.5 + scaleFactor
		local factor = ((doScale and not doMovement) and 0 or 1)
		frame.Position = UDim2.new(math.clamp(pos.X.Scale + delta.X / absSize.X * factor, minScale, maxScale), 0, math.clamp(pos.Y.Scale + delta.Y / absSize.Y * factor, minScale, maxScale), 0)
	end
	--print("scroll/zoom loop ended")
	info.Looping = false
end

function GuiUtil:ClearScrollFrame(ui: GuiBase2d)
	local info = zoomFrames[ui]
	if not info then return end
	info.Delta = Vector3.new()
	info.Held = false
	for _, con in pairs(info.Connections) do
		con:Disconnect()
	end
	zoomFrames[ui] = nil
end

return GuiUtil