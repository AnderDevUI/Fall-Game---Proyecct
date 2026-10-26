-- [PATH] ReplicatedStorage / CharacterScripts / WheelController @Type LocalScript
--[[
	WheelController
	by ChickenBagelz
	September 21, 2022
	
	Controls the framework of the wheel and gives it functionality
]]


-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")

-- Folders
local Modules = Replicated:WaitForChild("Modules")

-- Modules
local TweenUtil = require(Modules:WaitForChild("TweenUtil"))
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))

-- Bindables
local Open = script:WaitForChild("Open")
local Close = script:WaitForChild("Close")

-- Player Variables
local Player = Players.LocalPlayer
local Character = script.Parent
local PlayerGui = Player:WaitForChild("PlayerGui")
local Humanoid = Character:WaitForChild("Humanoid")

-- UI
local MainGui = PlayerGui:WaitForChild("Main")
local Wheel = MainGui:WaitForChild("Wheel")

-- Local Variables
local curWheel, origSize, redTween, wheelInfos
local curSelected = 0
local wheelCons = {}
local wheelTrans = 1
local firstWheel = true
local lastAbsSize
local currentWheelTrans = 1


-- Functions
local function SetWheelTransparency(r, willShow)
	currentWheelTrans = r
	for _, v in pairs(Wheel:GetChildren()) do
		for _, ui in pairs(curWheel == v and {v.Red, unpack(v.Icon:GetChildren())} or (v:IsA("Frame") and {} or {v})) do
			if ui.Name == "Red" and (curSelected == 0 and (willShow or ui.ImageTransparency == 1)) then continue end
			--[[if ui.Name == "Red" then
				print("y")
			end]]
			local prop = (ui:IsA("TextLabel") and "Text" or (ui:IsA("ImageLabel") and "Image" or "Background")).."Transparency"
			ui[prop] = NumberUtil:Lerp((ui.Name == "BG" and 0.2 or 0), 1, r)
		end
	end
	Wheel.Visible = (r < 1)
end

local function ToggleWheel(willShow)
	if willShow then
		Wheel.Size = NumberUtil:MultUDim2ByNum(origSize, 1.3)
		--firstWheel = false
	end
	Wheel:TweenSize(NumberUtil:MultUDim2ByNum(origSize, (willShow and 1 or 1.3)), (willShow and "Out" or "In"), "Quart", 0.175, true)
	local started = tick()
	local speed = 0.1
	local targetTrans = (willShow and 0 or 1)
	if redTween and not willShow then
		redTween:Cancel()
	end
	if wheelTrans ~= targetTrans then
		wheelTrans = targetTrans
		while true do
			local passed = tick() - started
			local r = math.min(passed / speed, 1)
			local trans = (willShow and (1 - r) or r)
			SetWheelTransparency(trans, willShow)
			if passed >= speed then
				break
			end
			Run.Heartbeat:Wait()
		end
	end
end

local function UpdateWheel(info)
	Wheel.SelectedImage.Image = (info and info.Image or "")
	Wheel.SelectedName.Text = (info and info.Name or "")
	Wheel.SelectedDesc.Text = (info and info.Description or "")
	Wheel.SelectedCost.Text = (info and (type(info.Cost) == "function" and info.Cost() or (info.Cost or "")) or "")
	if not curWheel then return end
	if info then
		redTween = TweenUtil:Tween(curWheel.Red, "ImageTransparency", 0, 0.2, "Quart")
	else
		curWheel.Red.ImageTransparency = 1
	end
	for _, icon in pairs(curWheel.Icon:GetChildren()) do
		local num = tonumber(icon.Name:sub(2))
		local curInfo = wheelInfos[num]
		icon.ImageColor3 = script:GetAttribute(num == curSelected and "IconSelectedColor" or ((curInfo ~= nil and curInfo.Selectable) and "IconUnselectedColor" or "IconUnavailableColor"))
	end
end

local function SelectWheel(n, info)
	if not (curWheel and curSelected ~= n) then return end
	local total = tonumber(curWheel.Name:sub(6))
	TweenUtil:Tween(curWheel.Red, "Rotation", 360 / total * (n - 1), (curSelected == 0 and 0 or 0.2), "Quart")
	curSelected = n
	UpdateWheel(info)
end

local function RemoveConnections()
	for _, v in pairs(wheelCons) do
		v:Disconnect()
	end
	wheelCons = {}
end

local function OpenWheel(wheelInfo, typ, clickOnly)
	script:SetAttribute("Open", true)
	script:SetAttribute("WheelType", typ)
	RemoveConnections()
	if curWheel then
		curWheel.Visible = false
	end
	curWheel = Wheel:FindFirstChild("Wheel"..#wheelInfo)
	curSelected = 0
	wheelInfos = wheelInfo
	UpdateWheel()
	local clicked = false
	for index, info in pairs(wheelInfo) do
		local hitbox = curWheel.Hitbox["Q"..index]
		local icon = curWheel.Icon["Q"..index]
		icon.Image = info.Image
		if info.Selectable then
			table.insert(wheelCons, hitbox.MouseEnter:Connect(function()
				SelectWheel(index, info)
			end))
		end
		if info.SelectFirst then
			SelectWheel(index, info)
		end
	end
	table.insert(wheelCons, UserInput.InputBegan:Connect(function(input)
		local inputType = input.UserInputType
		if inputType ~= Enum.UserInputType.MouseButton1 then return end
		task.wait()
		clicked = true
		script:SetAttribute("Open", false)
	end))
	curWheel.Visible = true
	UserInput.MouseBehavior = Enum.MouseBehavior.Default
	UserInput.MouseIconEnabled = true
	task.spawn(ToggleWheel, true)
	while script:GetAttribute("Open") do
		Run.Heartbeat:Wait()
	end
	if script:GetAttribute("WheelType") == typ then
		RemoveConnections()
		UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInput.MouseIconEnabled = false
		task.spawn(ToggleWheel, false)
	end
	if (not clickOnly) or clicked then
		return curSelected
	end
end

local function CloseWheel(typ)
	if typ and typ ~= script:GetAttribute("WheelType") then return end
	script:SetAttribute("Open", false)
end

local function RescaleWheel()
	local absSize = Wheel.AbsoluteSize.Y
	if absSize == lastAbsSize or currentWheelTrans % 1 ~= 0 then return end
	lastAbsSize = absSize
	origSize = UDim2.new(0, absSize, 0.7, 0)
	Wheel.Size = origSize
end

-- Events
Wheel:GetPropertyChangedSignal("AbsoluteSize"):Connect(RescaleWheel)

-- Bindables
Open.OnInvoke = OpenWheel
Close.OnInvoke = CloseWheel

origSize = Wheel.Size
SetWheelTransparency(1)
Wheel.Visible = false
RescaleWheel()