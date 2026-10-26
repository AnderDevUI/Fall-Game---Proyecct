-- [PATH] ReplicatedStorage / CharacterScripts / StateController @Type LocalScript
--[[
	PlayerService
	by neddleduck
	July 16, 2022
	
	Takes the users input and sets the attributes which are :
	Direction
	IsShift
	IsCrouch
]]

-- Services
local InputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")

-- Folders
local Modules = Replicated:WaitForChild("Modules")
local Drops = workspace:WaitForChild("Drops")
local VFX = workspace:WaitForChild("VFX")
local Animals = workspace:WaitForChild("Animals")
local Plants = workspace:WaitForChild("Plants")

-- Modules
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"))

-- Player Variables
local Player = Players.LocalPlayer
local PlayerScripts = Player:WaitForChild("PlayerScripts")
local Char = script.Parent
local Hum = Char:WaitForChild("Humanoid")
local RootPart = Char:WaitForChild("HumanoidRootPart")

-- Dependencies
local ViewmodelController = Char:WaitForChild("ViewmodelController")
local InventoryController = Char:WaitForChild("InventoryController")
local WaterController = Char:WaitForChild("WaterController")
local WeatherController = PlayerScripts:WaitForChild("WeatherController")

--Settings
local WATERCHECK_CD = 0.4

-- Local Variables
local canSprint = false
local origHipHeight = 1.75
local crouchObstructed = false
local waterCheckTick = tick()
local belowCeiling = false

--Functions

local function CalculateAttributes()
	local direction = ""
	local holdingForward = InputService:IsKeyDown(Enum.KeyCode.W) or InputService:IsKeyDown(Enum.KeyCode.Up)
	local holdingBackward = InputService:IsKeyDown(Enum.KeyCode.S) or InputService:IsKeyDown(Enum.KeyCode.Down)
	if holdingForward and not holdingBackward then
		direction = direction .. "Forward"
	elseif holdingBackward and not holdingForward then
		direction = direction .. "Backward"
	end
	
	if InputService:IsKeyDown(Enum.KeyCode.A) and not InputService:IsKeyDown(Enum.KeyCode.D) then
		direction = direction .. "Left"
	elseif InputService:IsKeyDown(Enum.KeyCode.D) and not InputService:IsKeyDown(Enum.KeyCode.A) then
		direction = direction .. "Right"
	end
	local invOpen = InventoryController:GetAttribute("Open")
	local forwardThreshold = direction == "Forward"--(invOpen and direction == "Forward") or (invOpen ~= true and direction:find("Forward"))
	if InputService:IsKeyDown(Enum.KeyCode.LeftShift) then
		canSprint = true
	elseif not forwardThreshold then
		canSprint = false
	end
	
	local aiming = ViewmodelController:GetAttribute("Aiming")
	local using = ViewmodelController:GetAttribute("Using")
	local isSwimming = WaterController:GetAttribute("IsSwim")
	local crouching = (crouchObstructed or InputService:IsKeyDown(Enum.KeyCode.C) or InputService:IsKeyDown(Enum.KeyCode.LeftControl))
	local sprinting = (canSprint and forwardThreshold and not (crouching or aiming or (using and not ViewmodelController:GetAttribute("CanUse")) or isSwimming or script:GetAttribute("IsClimbing")))
	local isSlowed = (Hum:GetAttribute("DamageConnections") or 0) > 0
	script:SetAttribute("Direction", direction)
	script:SetAttribute("IsSprint", sprinting)
	script:SetAttribute("IsCrouch", crouching)
	script:SetAttribute("IsSlowed", isSlowed)
	--print(sprinting)
	--print((Player:GetAttribute("Armor_HasFlippers") and (WaterController:GetAttribute("IsSwim") and 1.5 or 0.5) or 1))
	Hum.WalkSpeed = (Hum:GetAttribute("Downed") and 0 or (crouching and 6.5 or (sprinting and 18 or 11)) * (aiming and 0.8 or 1) * (isSlowed and 0.3 or 1)) * (ViewmodelController:GetAttribute("SReduction") or 1) * (Player:GetAttribute("Armor_HasFlippers") and (isSwimming and 1.5 or 0.5) or 1)
	Hum.HipHeight = (crouching and 1.1 or origHipHeight)
	Hum.MaxSlopeAngle = (isSwimming and 80 or 55)
	Hum.JumpHeight = (isSlowed and 0 or 3.25)
	RootPart.Size = Vector3.new(2, (crouching and 2.1 or 2.5), 2)
end

--Events

InputService.InputBegan:Connect(function(input)
	local inputType = input.UserInputType
	local textBox = InputService:GetFocusedTextBox()
	if inputType == Enum.UserInputType.Keyboard and not textBox then
		CalculateAttributes()
	end
end)
InputService.InputEnded:Connect(function(input)
	local inputType = input.UserInputType
	local textBox = InputService:GetFocusedTextBox()
	if inputType == Enum.UserInputType.Keyboard and not textBox then
		CalculateAttributes()
	end
end)

ViewmodelController.AttributeChanged:Connect(function(attr)
	if attr ~= "Aiming" and attr ~= "Using" and attr ~= "SReduction" then return end
	CalculateAttributes()
end)
Hum.AttributeChanged:Connect(function(attr)
	if attr ~= "DamageConnections" then return end
	CalculateAttributes()
end)
Hum.StateChanged:Connect(function(oldState, newState)
	local wasClimbing = script:GetAttribute("IsClimbing")
	if oldState == Enum.HumanoidStateType.Climbing or newState ~= Enum.HumanoidStateType.Climbing then
		script:SetAttribute("IsClimbing", false)
		if wasClimbing then
			CalculateAttributes()
		end
		return
	end
	script:SetAttribute("IsClimbing", true)
	if not wasClimbing then
		CalculateAttributes()
	end
end)

while task.wait(1/30) do
	if not (RootPart and RootPart.Parent) then break end
	local filter = {VFX, Drops, Animals, Plants}
	for _, player in pairs(Players:GetPlayers()) do
		local char = player.Character
		if char and char.Parent then
			table.insert(filter, char)
		end
	end
	
	local isCrouched = script:GetAttribute("IsCrouch") --Crouch raycast
	local crouchThreshold = (isCrouched and 2.6 or 1.75)
	local charPos = RootPart.Position
	local hit, pos = RaycastUtil:Raycast(charPos, Vector3.new(0, 100, 0), "Blacklist", filter, false, RaycastUtil:FilterFunction("View"), true)
	local isBelow = (hit ~= nil and hit.Parent ~= nil and (hit.CanCollide or hit.Transparency < 1))
	if isBelow ~= belowCeiling then
		belowCeiling = isBelow
		WeatherController:SetAttribute("BelowCeiling", isBelow)
	end
	local isObstructed = (isBelow and pos.Y - charPos.Y <= crouchThreshold)
	if isObstructed ~= crouchObstructed then
		crouchObstructed = isObstructed
		CalculateAttributes()
	end
	if tick() - waterCheckTick >= WATERCHECK_CD then --Check if theyre in water
		waterCheckTick = tick()
		local head = Char:WaitForChild("Head")
		local regStart = head.Position - (.5 * head.Size) - Vector3.new(0, 3, 0)
		local regEnd = head.Position + (.5 * head.Size) - Vector3.new(0, 3, 0)
		local region = Region3.new(regStart, regEnd):ExpandToGrid(4)
		local materials, occupancies = workspace.Terrain:ReadVoxels(region, 4)
		local material = materials[1][1][1]
		if material == Enum.Material.Water then
			script:SetAttribute("IsWater", true)
		else
			script:SetAttribute("IsWater", false)
		end
	end
end