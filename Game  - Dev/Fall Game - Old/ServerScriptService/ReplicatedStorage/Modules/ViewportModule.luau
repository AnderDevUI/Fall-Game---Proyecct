-- [PATH] ReplicatedStorage / Modules / ViewportModule @Type ModuleScript
--[[
	ViewportModule
	by ChickenBagelz
	March 30, 2023
	
	Easy creation and control of ViewportFrames
]]


-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")

-- Folders
local Modules = Replicated:WaitForChild("Modules")

-- Modules
local ArmorModule = require(Modules:WaitForChild("ArmorModule"))

-- Children
local IdleAnim = script:WaitForChild("Idle")
local SelectedDecal = script:WaitForChild("Selected")

-- Player Variables
local Player = Players.LocalPlayer

-- Local Variables
local defaultSpinSpeed = Vector3.new(0, 0, 0)
local viewports = {}


local ViewportModule = {}

function ViewportModule:ShowCharacter(viewport, char, hitboxes, armors)
	if not (viewport and viewport.Parent) then return end
	self:ClearViewport(viewport)
	local viewportCam = Instance.new("Camera")
	viewportCam.Parent = viewport
	viewport.CurrentCamera = viewportCam
	local worldModel = Instance.new("WorldModel")
	worldModel.Parent = viewport
	char.Archivable = true
	local started = tick()
	while tick() - started < 30 and not char.PrimaryPart do
		task.wait()
	end
	local charCopy = char:Clone()
	char.Archivable = false
	for _, child in pairs(charCopy:GetChildren()) do
		if child:IsA("BasePart") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("Humanoid") or child.Name:sub(1, 6) == "Armor_" or child.Name == "Hair" then
			for _, descendant in pairs(child:GetChildren()) do
				if not descendant:IsA("BillboardGui") then continue end
				descendant:Destroy()
			end
			continue
		end
		child:Destroy()
	end
	charCopy.Parent = worldModel
	local copyHum = charCopy:WaitForChild("Humanoid")
	local idle = copyHum:LoadAnimation(IdleAnim)
	idle:Play()
	local idle = nil
	local faceFeatures = {}
	local connections = {}
	local t = {
		Camera = viewportCam;
		Object = charCopy;
		Delta = defaultSpinSpeed;
		Held = false;
		Anims = {
			Idle = idle;
		};
		Char = char;
		Hitboxes = hitboxes;
		Connections = connections;
		FaceFeatures = faceFeatures;
	}
	viewports[viewport] = t 
	local head = char:FindFirstChild("Head")
	if head then
		local headCopy = charCopy:FindFirstChild("Head")
		table.insert(connections, head.ChildAdded:Connect(function(child)
			if not child:IsA("Decal" and headCopy and headCopy.Parent) then return end
			local clone = child:Clone()
			clone.Parent = headCopy
			faceFeatures[child] = clone
		end))
		table.insert(connections, head.ChildRemoved:Connect(function(child)
			if not child:IsA("Decal") then return end
			local clone = faceFeatures[child]
			if not (clone and clone.Parent) then return end
			clone:Destroy()
		end))
		if headCopy then
			for _, child in pairs(head:GetChildren()) do
				if not child:IsA("Decal") then continue end
				local clone = headCopy:FindFirstChild(child.Name)
				if not clone then continue end
				table.insert(connections, child.Changed:Connect(function(prop)
					if not (clone and clone.Parent) then return end
					local value = child[prop]
					clone[prop] = value
				end))
			end
		end
	end
	self:AddSpin(viewport)
	local prim = charCopy:WaitForChild("HumanoidRootPart")
	charCopy:PivotTo(CFrame.new())
	viewportCam.CFrame = CFrame.new((prim.CFrame * CFrame.new(0, 1, -5)).Position, prim.Position + Vector3.new(0, 0.1, 0))
	if armors then
		self:UpdateArmors(viewport, armors)
	end
	return t
end

function ViewportModule:UpdateArmors(viewport, armors)
	local t = viewports[viewport]
	if not t then return end
	ArmorModule:UpdateArmors(t.Object, armors)
end

function ViewportModule:ClearViewport(viewport)
	viewport:ClearAllChildren()
	local t = viewports[viewport]
	if t and t.Connections then
		for _, con in pairs(t.Connections) do
			con:Disconnect()
		end
	end
	viewports[viewport] = nil
end

function ViewportModule:AddSpin(viewport)
	local t = viewports[viewport]
	local lastMousePos
	local buttons = {viewport, unpack(t.Hitboxes or {})}
	for _, button in pairs(buttons) do
		table.insert(t.Connections, button.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			lastMousePos = input.Position
			t.Held = true
		end))
	end
	table.insert(t.Connections, UserInput.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and t.Held) then return end
		local newPos = input.Position
		t.Delta = (newPos - lastMousePos) * 0.8
		self:SpinViewport(viewport)
		lastMousePos = newPos
	end))
	table.insert(t.Connections, UserInput.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and t.Held) then return end
		t.Held = false
		if input.Position == lastMousePos then
			t.Delta = Vector3.new()
		end
		while not t.Held do
			t.Delta = t.Delta:Lerp(defaultSpinSpeed, 0.1)
			Run.Heartbeat:Wait()
		end
	end))
end

function ViewportModule:SpinViewport(viewport)
	local t = viewports[viewport]
	if not t then return end
	local object = t.Object
	if not object then return end
	local primPart = object.PrimaryPart
	if not primPart then return end
	object:SetPrimaryPartCFrame(primPart.CFrame * CFrame.Angles(0, math.rad(t.Delta.X), 0))
	return true
end

function ViewportModule:HighlightCharArea(viewport, areaName)
	local t = viewports[viewport]
	if not t then return end
	local limbs = (areaName == "Head" and {"Head"} or 
		(areaName == "Legs" and {"RightUpperLeg", "RightLowerLeg", "RightFoot", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot"} or 
		(areaName == "Chest" and {"RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperArm", "LeftLowerArm", "LeftHand", "UpperTorso", "LowerTorso"}
		or {})))
	for _, limb in pairs(t.Object:GetChildren()) do
		local limbName = limb.Name
		local isModel = (limbName:sub(1, 6) == "Armor_" or limbName == "Hair") and limb:IsA("Model")
		if limb.Name == "HumanoidRootPart" or not (limb:IsA("BasePart") or isModel) then continue end
		local parts = {}
		if isModel then
			for _, part in pairs(limb:GetChildren()) do
				if part == limb.PrimaryPart then
					limbName = part.Name
				end
				if not (part:IsA("BasePart") and part.Transparency < 1) then continue end
				table.insert(parts, part)
			end
		else
			parts[1] = limb
		end
		local doSelect = table.find(limbs, limbName)
		for _, part in pairs(parts) do
			local selected = part:FindFirstChild("Selected")
			if doSelect then
				if not selected then
					for _, face in pairs(Enum.NormalId:GetEnumItems()) do
						local decal = SelectedDecal:Clone()
						decal.Face = face
						decal.Parent = part
					end
					continue
				end
			elseif not selected then
				continue
			end
			for _, decal in pairs(part:GetChildren()) do
				if not (decal.Name == "Selected" and decal:IsA("Decal")) then continue end
				decal.Transparency = (doSelect and SelectedDecal.Transparency or 1)
			end
		end
		--[[if limb.Name == "HumanoidRootPart" or not limb:IsA("BasePart") then continue end
		local parts = {limb}
		for _, weld in pairs(limb:GetChildren()) do
			if not weld:IsA("Weld") then continue end
			local part1 = weld.Part1
			if not part1 then continue end
			if not part1.Parent then
				weld:Destroy()
				continue
			end
			if part1.Name ~= limb.Name then continue end
			local armor = part1.Parent
			if not (armor.Name:sub(1, 6) == "Armor_" or armor.Name == "Hair") then continue end
			for _, armorPart in pairs(armor:GetChildren()) do
				if not (armorPart:IsA("BasePart") and armorPart.Transparency < 1) then continue end
				table.insert(parts, armorPart)
			end
		end
		local doSelect = table.find(limbs, limb.Name)
		for _, part in pairs(parts) do
			local selected = part:FindFirstChild("Selected")
			if doSelect then
				if not selected then
					for _, face in pairs(Enum.NormalId:GetEnumItems()) do
						local decal = SelectedDecal:Clone()
						decal.Face = face
						decal.Parent = part
					end
					continue
				end
			elseif not selected then
				continue
			end
			for _, decal in pairs(part:GetChildren()) do
				if not (decal.Name == "Selected" and decal:IsA("Decal")) then continue end
				decal.Transparency = (doSelect and SelectedDecal.Transparency or 1)
			end
		end]]
	end
end

-- Events
Run.Heartbeat:Connect(function()
	for viewport, t in pairs(viewports) do
		local object = t.Object
		if not (object and object:IsDescendantOf(Player)) then
			viewports[viewport] = nil
			continue
		end
		if t.Held or ViewportModule:SpinViewport(viewport) then continue end
		if object then
			object:Destroy()
		end
		viewports[viewport] = nil
	end
end)

return ViewportModule