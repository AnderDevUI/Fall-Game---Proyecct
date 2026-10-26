-- [PATH] ReplicatedStorage / CharacterScripts / WaterController @Type LocalScript
--Services
local REPLICATED = game:GetService("ReplicatedStorage")
local SHARED_MODULES = REPLICATED:WaitForChild("Modules")
local INPUT_SERVICE = game:GetService("UserInputService")
local LIGHTING = game:GetService("Lighting")
local SOUND = game:GetService("SoundService")
local PLAYERS = game:GetService("Players")

--Modules
local RAY_UTIL = require(SHARED_MODULES:WaitForChild("RaycastUtil"))
local NUM_UTIL = require(SHARED_MODULES:WaitForChild("NumberUtil"))
local VEC_UTIL = require(SHARED_MODULES:WaitForChild("VectorUtil"))

--Constants
local REMOTES = REPLICATED:WaitForChild("Remotes")
local WATER_REMOTE = string.char(25, 141, 109, 85, 1, 134, 137, 157, 3, 109, 2, 47, 181, 57, 77, 112, 41, 63, 96, 115, 40, 137, 186, 27, 117, 124, 179, 47, 119, 28);
local SURFACE_REMOTE = string.char(184, 59, 164, 131, 39, 137, 7, 143, 25, 109, 121, 55, 113, 120, 93, 40, 162, 102, 143, 95, 97, 166, 156, 58, 79, 115, 93, 166, 68, 105);
local StatsRemotes = REMOTES:WaitForChild(string.char(32, 175, 56, 160, 50, 187, 113, 77, 49, 22, 130, 142, 126, 38, 59, 102, 17, 6, 168, 41, 9, 180, 85, 142, 105, 14, 66, 146, 142, 126))
local VFX = REPLICATED:WaitForChild("VFX")

local CHAR = script.Parent
local HRP = CHAR:WaitForChild("HumanoidRootPart")
local HEAD = CHAR:WaitForChild("Head")
local HUM = CHAR:WaitForChild("Humanoid")
local PLAYER = PLAYERS.LocalPlayer

--GUI
local GUI = PLAYER:WaitForChild("PlayerGui")
local MAIN = GUI:WaitForChild("Main")
local STATS = MAIN:WaitForChild("Stats")
local GOGGLE_UI = MAIN:WaitForChild("DivingGoggles")

local FX_BLUR = LIGHTING:WaitForChild("WaterBlur")
local FX_COLOR = LIGHTING:WaitForChild("WaterColorCorrection")

local VFX_BUBBLES = VFX:WaitForChild("Bubbles")

--Settings
local WATER_CHECK_CD = 0.2
local WATER_FIRE_CD = 1
local SURFACE_FIRE_CD = 1

--Constants
local DEFAULT_DENS = 0.9
local TREAD_DENS = 0.6
local SWIM_DENS = 0.2
local WATER_TRANSPARENCY_UNDER = 0.03
local WATER_TRANSPARENCY_ABOVE = 0.04

--Variables
local curDens = DEFAULT_DENS
local curWaterLvl = 0
local curWaterCheckTick = tick()
local curSurfaceCheckTick = tick()

--Functions
local function FireWater(newLevel)
	if tick() - curWaterCheckTick >= WATER_FIRE_CD then
		curWaterCheckTick = tick()
		VEC_UTIL:FireRemote(StatsRemotes, WATER_REMOTE, {newLevel})
	end
end

local function lengthToLevel(length)
	local wetMax = 90 --wet isn't capped at 90, just for this function it will be 90, cause it won't run if they are submereged under water
	local wetMin = 10 --Least amount wet if they are in water at all
	local perc = length / 4
	local level = NUM_UTIL:Lerp(wetMax, wetMin, perc)
	return math.ceil(level)
end

local function calcWaterLevel()
	local origin = Vector3.new(HRP.Position.X, HRP.Position.Y + 1.5, HRP.Position.Z)
	local dir = Vector3.new(0, -1, 0) 
	local length = 5
	local hit, position, normal, material = RAY_UTIL:Raycast(origin, dir * length, "Whitelist", workspace.Terrain)
	local newLevel = 0
	
	if material == Enum.Material.Water then
		local rayLength = (origin - position).Magnitude
		--print("Found to be in water by ray, determing length to check if they are swimming")
		if rayLength <= 0.35 then
			script:SetAttribute("IsSwim", true)
			newLevel = 100
		else
			script:SetAttribute("InWater", true)
			newLevel = lengthToLevel(rayLength)
		end
		script:SetAttribute("IsUnder", false)
	else
		--if we don't raycast into water then we check for head voxels
		local regStart = HEAD.Position - HEAD.Size / 2
		local regEnd = HEAD.Position + HEAD.Size / 2
		local region = Region3.new(regStart, regEnd):ExpandToGrid(4)
		local materials, occupancies = workspace.Terrain:ReadVoxels(region, 4)
		local material  
		local suc = pcall(function()
			material = materials[1][1][1]
		end)
		if suc and material == Enum.Material.Water then
			script:SetAttribute("IsSwim", true)
			script:SetAttribute("IsUnder", true)
			newLevel = 100
		else
			--If this code block runs, the ray has failed to check for water, and the voxel check has also failed resulting in the char not being in water
			script:SetAttribute("InWater", false)
			script:SetAttribute("IsSwim", false)
			script:SetAttribute("IsUnder", false)
		end
	end
	
	local wet = STATS:FindFirstChild("Wet")
	if wet and wet:GetAttribute("Reach") and newLevel > 0 then
		local wetVal = wet:GetAttribute("Reach")
		if newLevel > wetVal then
			FireWater(newLevel)
		end
	elseif wet == nil and newLevel > 0 then
		FireWater(newLevel)
	end
	return 
end

local function SetDensity(dens)
	HRP.CustomPhysicalProperties = PhysicalProperties.new(dens, 0.3, 0.5)
	if not CHAR.Parent then return end
	local massless = (dens == SWIM_DENS)
	for _, part in pairs(CHAR:GetChildren()) do
		if part == HRP or part.Name:find("Torso") or part.Name == "Head" or not part:IsA("BasePart") then continue end
		part.Massless = massless
	end
end

local function SwimInputCheck()
	local isSwim = script:GetAttribute("IsSwim")
	local spaceDown = INPUT_SERVICE:IsKeyDown(Enum.KeyCode.Space)
	if spaceDown and isSwim then
		curDens = SWIM_DENS
		SetDensity(curDens)
	elseif script:GetAttribute("InWater") then
		curDens = TREAD_DENS
		SetDensity(curDens)
	elseif curDens ~= DEFAULT_DENS then
		curDens = DEFAULT_DENS
		SetDensity(curDens)
	end
end

local function ToggleWaterEffects(enabled)
	FX_BLUR.Enabled = enabled and not PLAYER:GetAttribute("Armor_HasGoggles")
	FX_COLOR.Enabled = enabled
	script.Ambient.Volume = enabled and 0.2 or 0
	SOUND.AmbientReverb = enabled and Enum.ReverbType.UnderWater or Enum.ReverbType.NoReverb
	workspace.Terrain.WaterTransparency = enabled and WATER_TRANSPARENCY_UNDER or WATER_TRANSPARENCY_ABOVE
	local head = CHAR:FindFirstChild("Head")
	if not head then return end
	local bubbles = head:FindFirstChild("Bubbles")
	if enabled and not bubbles then
		bubbles = VFX_BUBBLES:Clone()
		bubbles.Name = "Bubbles"
		bubbles.Parent = head
	elseif not enabled and bubbles then
		bubbles:Destroy()
	end
end
--Disable Humanoid States
HUM:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
HUM:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

--Event Connections
script:GetAttributeChangedSignal("IsSwim"):Connect(function()
	local isSwim = script:GetAttribute("IsSwim")
	if isSwim then --weird ass code to make the char float when they enter water // Changed it to just use a body velocity instead
		local force = Instance.new("BodyVelocity")
		force.Name = "WaterForce"
		force.Parent = HRP
		SwimInputCheck()
		task.wait(1/30)
		force:Destroy()
		--[[
		HUM.JumpHeight = 0
		wait()
		HUM.Jump = true
		wait()
		HUM.Jump = false
		HUM.JumpHeight = 3.25]]
	else
		SwimInputCheck()
	end
end)

script:GetAttributeChangedSignal("IsUnder"):Connect(function()
	local isUnder = script:GetAttribute("IsUnder")
	ToggleWaterEffects(isUnder)
	
	if not isUnder and tick() - curSurfaceCheckTick >= SURFACE_FIRE_CD then
		curSurfaceCheckTick = tick()
		VEC_UTIL:FireRemote(StatsRemotes, SURFACE_REMOTE, {})
	end
end)

INPUT_SERVICE.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if not (input.KeyCode == Enum.KeyCode.Space) then return end
	SwimInputCheck()
end)

INPUT_SERVICE.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if not (input.KeyCode == Enum.KeyCode.Space) then return end
	SwimInputCheck()
end)

PLAYER:GetAttributeChangedSignal("Armor_HasGoggles"):Connect(function() --When a player attribute changes check all the relevant water attributes
	local hasGoggles = PLAYER:GetAttribute("Armor_HasGoggles")
	GOGGLE_UI.Visible = hasGoggles
	ToggleWaterEffects(script:GetAttribute("IsUnder"))
end)

-- Reset FX
ToggleWaterEffects(false)

--Loops
while HUM.Health > 0 do
	calcWaterLevel()
	wait(WATER_CHECK_CD)
end

ToggleWaterEffects(false) --I think this makes the water effects turn off when you die