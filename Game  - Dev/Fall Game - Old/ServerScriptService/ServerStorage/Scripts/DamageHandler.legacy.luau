-- [PATH] ServerStorage / Scripts / DamageHandler @Type Script
--[[
	DamageHandler
	by ChickenBagelz
	February 7, 2023
	
	Controls the damaging of a certain group of parts when a player enters them
]]


-- Services
local Players = game:GetService("Players")
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage") -- :3
local Debris = game:GetService("Debris")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")
local DamageSounds = Storage:WaitForChild("GlobalSounds"):WaitForChild("Damages")

-- Modules
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local DamageModule = require(ServerModules:WaitForChild("DamageModule"))
local Thread = require(SharedModules:WaitForChild("Thread"))

-- Constants
local DamageParts = script.Parent
local Object = DamageParts.Parent

-- Local Variables
local hitHums = {}
local loopRunning = false

-- Functions 
function RemoveHum(hum)
	hum:SetAttribute("DamageConnections", math.max(hum:GetAttribute("DamageConnections") - 1, 0))
	hitHums[hum] = nil
end

Object.Destroying:Connect(function()
	--print("removing humanoids")
	for hum, _ in pairs(hitHums) do
		if not (hum and hum.Parent) then continue end
		RemoveHum(hum)
	end
end)

for _, part in pairs(DamageParts:GetChildren()) do
	if not part:IsA("BasePart") then continue end
	part.Touched:Connect(function(hit)
		local char = hit.Parent
		if not (char and script:GetAttribute("On")) then return end
		local hum = char:FindFirstChild("Humanoid")
		if not hum or hitHums[hum] then return end
		if not Players:GetPlayerFromCharacter(char) then return end
		hitHums[hum] = 0
		hum:SetAttribute("DamageConnections", (hum:GetAttribute("DamageConnections") or 0) + 1)
		if loopRunning then return end
		loopRunning = true
		while true do
			local found = false
			for humanoid, _ in pairs(hitHums) do
				if not humanoid then continue end
				local character = humanoid.Parent
				if not (script:GetAttribute("On") and character and character.PrimaryPart and humanoid.Health > 0) then
					RemoveHum(humanoid)
					continue
				end
				found = true
			end
			if not found then break end
			for humanoid, lastDamaged in pairs(hitHums) do
				local character = humanoid.Parent
				local overlapParams = OverlapParams.new()
				overlapParams.FilterDescendantsInstances = {character}
				overlapParams.FilterType = Enum.RaycastFilterType.Include
				local partInside
				for _, damagePart in pairs(DamageParts:GetChildren()) do
					if not damagePart:IsA("BasePart") then continue end
					local parts = workspace:GetPartBoundsInBox(damagePart.CFrame, damagePart.Size, overlapParams)
					for _, p in pairs(parts) do
						if p.Parent ~= character then continue end
						partInside = damagePart
						break
					end
					if partInside then break end
				end
				if not partInside then
					RemoveHum(humanoid)
					continue
				end
				local ti = tick()
				if ti - lastDamaged < script:GetAttribute("HitTick") then continue end
				--print("damaging")
				local isFire = script:GetAttribute("IsFire")
				local upperTorso = character:FindFirstChild("UpperTorso")
				DamageModule:Damage(upperTorso, Vector3.new(), Vector3.new(), partInside.CFrame, {
					Chest = script:GetAttribute("Damage");
					Bleed = NumberUtil:NumberToInteger(script:GetAttribute("Bleed"));
				}, {Start = 1000, End = 1000}, nil, nil, (isFire and "Fire" or Object.Name))
				hitHums[humanoid] = ti
				local sound = DamageSounds[isFire and "Burn" or "Cut"]:Clone()
				sound.PlaybackSpeed += math.random(-50, 50) / 1000
				sound.Parent = upperTorso
				sound:Play()
				Debris:AddItem(sound, 2.5)
			end
			task.wait()
		end
		loopRunning = false
	end)
end