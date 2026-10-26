-- [PATH] ServerScriptService / ServerService / StatsService @Type Script
--[[
	StatsService
	by neddleduck
	August 27, 2022
	
	StatsService manages the depletion of hunger and thirst, aswell as holding the remotes for updating the client and requesting to eat food
]]

--Services--
local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

--Settings--
local COOLDOWN_CONSUMABLE = 0.8

--Constants--
local SharedModules = Replicated:WaitForChild("Modules")
local Modules = Storage:WaitForChild("Modules")
local Values = Replicated:WaitForChild("Values")
local EVENT_HEALTH_CHANGED = script:WaitForChild("HealthChanged")
local ServerService = game.ServerScriptService:WaitForChild("ServerService")
local RAY_PARTS = workspace:WaitForChild("RayParts")
local BIOME_PARTS = workspace:WaitForChild("SpawnAreas")

local VFX = Replicated:WaitForChild("VFX")
local BLEED_FX = VFX:WaitForChild("Bleed")

local Remotes = Replicated.Remotes
local AllRemotes = {
	Consume = string.char(27, 172, 20, 5, 103, 62, 136, 82, 35, 178, 177, 27, 40, 69, 51, 169, 95, 77, 172, 4, 97, 63, 55, 189, 180, 173, 72, 135, 187, 25);
	SendStats = string.char(79, 32, 52, 90, 156, 106, 154, 4, 122, 24, 35, 31, 152, 159, 32, 108, 184, 86, 28, 97, 6, 28, 22, 147, 8, 79, 15, 125, 32, 45);
	Water = string.char(25, 141, 109, 85, 1, 134, 137, 157, 3, 109, 2, 47, 181, 57, 77, 112, 41, 63, 96, 115, 40, 137, 186, 27, 117, 124, 179, 47, 119, 28);
	Surface = string.char(184, 59, 164, 131, 39, 137, 7, 143, 25, 109, 121, 55, 113, 120, 93, 40, 162, 102, 143, 95, 97, 166, 156, 58, 79, 115, 93, 166, 68, 105);
	Pickup = string.char(131, 48, 148, 184, 91, 1, 106, 50, 100, 47, 39, 105, 95, 145, 161, 7, 93, 92, 85, 49, 70, 28, 166, 135, 74, 145, 82, 20, 88, 34);
	Respawn = string.char(21, 54, 128, 117, 144, 74, 114, 58, 57, 133, 153, 4, 99, 105, 92, 58, 142, 91, 73, 106, 155, 168, 85, 5, 16, 140, 31, 77, 120, 13);
	Revive = string.char(48, 1, 181, 179, 133, 46, 24, 83, 64, 116, 74, 164, 97, 3, 137, 102, 131, 185, 73, 24, 101, 9, 42, 133, 141, 93, 156, 98, 114, 28);
	Death = string.char(9, 22, 168, 81, 70, 44, 80, 82, 21, 44, 34, 11, 168, 8, 173, 95, 40, 87, 1, 136, 61, 24, 133, 13, 171, 31, 160, 67, 170, 23);
}
local StatsRemotes = Remotes:WaitForChild(string.char(32, 175, 56, 160, 50, 187, 113, 77, 49, 22, 130, 142, 126, 38, 59, 102, 17, 6, 168, 41, 9, 180, 85, 142, 105, 14, 66, 146, 142, 126))

--Modules--
local ModUtil = require(Modules:WaitForChild("ModUtil"))
local Items = require(SharedModules:WaitForChild("Items"))
local SoundModule = require(Modules:WaitForChild("SoundModule"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local AppearanceModule = require(Modules:WaitForChild("AppearanceModule"))
local RagdollModule =require(Modules:WaitForChild("RagdollModule"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local ArmorModule = require(SharedModules:WaitForChild("ArmorModule"))
local DamageModule = require(Modules:WaitForChild("DamageModule"))
local WeatherModule = require(Modules:WaitForChild("WeatherModule"))

--SETTINGS
local CHARACTER_LUNG_CAPACITY = 5.5
local REVIVE_TIME = 4
local reviveLoopCheckCooldown = 0.25

--Variables--
local lastTick = tick()
local drownTable = {} --[[
drownTable = {
	[plr] = tick()
	[plr] = tick()
	etc...
}]]
local reviveTable = {} --[[
	[PLR_REVIVING] = [PLR_REVIVED]
	etc..
]]

-- We want to find the lowest and highest ray part so we can cap our ray's minumum starting and maximum ending positions
local highestRayPos, lowestRayPos = 0, math.huge
for _, part in pairs(RAY_PARTS:GetChildren()) do
	if not part:IsA("BasePart") then continue end
	local pos = part.Position
	highestRayPos = math.max(pos.Y, highestRayPos)
	lowestRayPos = math.min(pos.Y, lowestRayPos)
end
highestRayPos += 1
lowestRayPos -= 1

local highestBiomeRayPos = 650
local lowestBiomeRayPos = 170


--Functions--
local viewFilterFunc = RaycastUtil:FilterFunction("View")

local function RemoveInstanceFromTable(tabl, instance)
	local index = table.find(tabl, instance)
	if not index then return end
	table.remove(tabl, index)
end

local function IsUnderWater(head)
	local regZone = Vector3.new(head.Size.X, head.Size.Y, head.Size.Z)
	local regPos = Vector3.new(head.Position.X, head.Position.Y + 3, head.Position.Z)
	local regStart = regPos + - regZone / 2
	local regEnd = regPos + regZone / 2
	local region = Region3.new(regStart, regEnd):ExpandToGrid(4)
	local materials, occupancies = workspace.Terrain:ReadVoxels(region, 4)
	local material  
	local suc = pcall(function()
		material = materials[1][1][1]
	end)
	return (suc and material == Enum.Material.Water)
end

--Holds all information for server tick functions
--These functions run once per user on the given timer, keep them easy to compute
local TickActions = {

	["Hunger"] = { --This is the function to starve and kill players once they are starving
		Timer = 50;
		LastCall = tick();
		Action = function (user, userStats, char, hum, primPart)
			userStats.Values.Hunger = math.max(userStats.Values.Hunger - 1, 0) --Increase 1.75x if they are sprinting when that is added and a proper server side check can be done
			return true
		end;
	};
	
	["Thirst"] = { --This is the function to dehydrate and kill players once they are dehydrated
		Timer = 60;
		LastCall = tick(); --I want the hunger and thirst functions to run 15 seconds apart, mainly just so they arent running at the same time for performance reasons lol
		Action = function(user, userStats, char, hum, primPart)
			userStats.Values.Thirst = math.max(userStats.Values.Thirst - 1, 0) --Increase 2x if they are sprinting when that is added and a proper server side check can be done
			return true
		end;
	};
	
	["HQueue"] = { --This is the function to update health queues for players
		Timer = 2;
		LastCall = tick();
		Action = function(user, userStats, char, hum, primPart)
			if userStats.Values.HQueue <= 0 or userStats:GetHp() >= 100 then userStats.Values.HQueue = 0 return end
			
			userStats.Values.HQueue -= 1
			userStats:SetHp(userStats:GetHp() + 1) 
			return true
		end;
	};
	
	["BleedingRadiation"] = { --This is the function to decrease health based on bleeding and radiation
		Timer = 4;
		LastCall = tick();
		Action = function(user, userStats, char, hum, primPart)
			local dmgToDeal = 0
			local dmgSource
			local bleedIndexPath = {
				"LowerArm",
				"WristRigAttachment"
			}
			local rightArm = char:FindFirstChild("Right"..bleedIndexPath[1])
			local leftArm = char:FindFirstChild("Left" .. bleedIndexPath[1])
			if not rightArm or not leftArm then return end
			local rightParent = rightArm:FindFirstChild("Right"..bleedIndexPath[2])
			local leftParent = leftArm:FindFirstChild("Left"..bleedIndexPath[2])
			
			--Calcluate Users Bleed
			if userStats.Values.Bleed > 0 then 
				userStats.Values.Bleed -= 1
				--userStats:SetHp(userStats:GetHp() - 1)
			
				dmgToDeal += 1
				dmgSource = "Bleeding"
			end
			
			--Calculate the users blood FX to be displayed on their character(the blood dripping)
			local bleeds = userStats.Values.Bleed > 0 and (userStats.Values.Bleed > 8 and 2 or 1) or 0
			local bleed1 = rightParent:FindFirstChildOfClass("ParticleEmitter")
			local bleed2 = leftParent:FindFirstChildOfClass("ParticleEmitter")
			if bleeds >= 1 then --2 or 1 bleeds
				if not bleed1 then
					local newBleed = ModUtil:SafeClone(BLEED_FX)
					newBleed.Parent = rightParent
				end
				
				if bleeds > 1 and not bleed2 then
					local newBleed = ModUtil:SafeClone(BLEED_FX)
					newBleed.Parent = leftParent
				end
			else --0 bleeds
				local bleed1 = rightParent:FindFirstChildOfClass("ParticleEmitter") --bleed1 is always the rightarm, it starts with right, going to left if theres 2 bleeds, so its safe to assume if there is no bleed in the right, there is none in the left
				if bleed1 then
					bleed1:Destroy()
					local bleed2 = leftParent:FindFirstChildOfClass("ParticleEmitter")
					if bleed2 then
						bleed2:Destroy()
					end
				end
			end
			
			--Calculate Users Radiation
			if userStats.Values.Radiation > 0 then
				local wet = userStats.Values.Wet
				local radAm = userStats.Values.Radiation
				local radMult = math.ceil((radAm + 1) / 15)
				local subtractAmnt = math.max(math.ceil(radMult / 2), 1) * (wet >= 90 and 3 or 1) --amount to subtract based on if user is underwater or not, kinda, technically its if their wet :P
				local newAmnt = math.clamp(radAm - subtractAmnt, 0, 499)
				userStats.Values.Radiation = newAmnt
				--userStats:SetHp(userStats:GetHp() - 1)
				dmgToDeal += radMult
				dmgSource = dmgSource or "Radiation"
			end
			
			-- Damage if player is starving or dehydrated
			local starving = userStats.Values.Hunger <= 0
			local dehydrated = userStats.Values.Thirst <= 0
			if starving or dehydrated then
				dmgToDeal += (starving and 1 or 0) + (dehydrated and 1 or 0)
				dmgSource = dmgSource or (starving and "Starvation" or "Dehydration")
			end
			
			if dmgToDeal > 0 then
				DamageModule:Damage(rightArm, Vector3.new(), Vector3.new(), nil, {
					Arms = dmgToDeal;
					Bleed = 0;
				}, {Start = 1000, End = 1000}, nil, nil, dmgSource)
				return true
			end
		end;
	};
	
	["RadiationRay"] = { --This is the function to detect radiation parts in the sky
		Timer = 1;
		LastCall = tick();
		Action = function(user, userStats, char, hum, primPart)
			if not script:GetAttribute("RadiationEnabled") then return end
			-- Set variables beforehand
			local start = primPart.Position
			start = Vector3.new(start.X, lowestRayPos, start.Z)
			local dir = Vector3.new(0, highestRayPos - lowestRayPos, 0)
			
			local rayResult, rayPos = RaycastUtil:Raycast(start, dir, "Whitelist", RAY_PARTS)
			--If there is no ray result, its empty and we can stop the thread
			if not rayResult then return end
			if rayResult.Name == "RadiationPart" then --RADIATION APPLY CALCULATION
				local radStrength = rayResult:GetAttribute("Strength")
				local radResistance = rayResult:GetAttribute("ProtectionResistance")
				local userResistance = userStats.Resistances.Radiation or 0
				local toApply = math.max(math.min(radResistance - userResistance, radStrength), 0)
				userStats.Values.Radiation += toApply
				--print(`doing {toApply} radiation to {user.Player.Name} ({userResistance}% RAD DEFENSE)`)
				if toApply == 0 then return end
				return true
			end
		end;
	};
	
	--[[["Comfort"] = {
		Timer = 4.5;
		LastCall = tick();
		Action = function(user, userStats, char, hum, primPart)
			local userStats = user.Stats
			if not (userStats and userStats:IsLoaded()) then return end
			
			local char = user.Player.Character
			if not (char and char.PrimaryPart) then return end
			
			local changed = false --Variable for updating the client if something was changed in stats
		end;
	};]]
	
	["DrownAndWet"] = {
		Timer = 2;
		LastCall = tick();
		Action = function(user, userStats, char, hum, primPart, head)
			local plr = user.Player
			local changed
			local underWater = IsUnderWater(head)
			local inTable = drownTable[plr] ~= nil
			local previousDrowning = userStats.Values.Drowning
			local drownTime = drownTable[plr]
			local armorItems, armorIndexes = ArmorModule:GetArmors(user.Inventory:GetArmor(), nil, "HasTank")
			local tankItem, tankIndex = armorItems[1], armorIndexes[1]
			
			local start = primPart.Position
			local dir = Vector3.new(0, 100, 0)
			local rayResult, rayPos = RaycastUtil:Raycast(start, dir, "Blacklist", {RAY_PARTS, char, workspace.MonumentBuildBlock, workspace.Vegetation, workspace.VFX})
			local underRain = (Values.Raining.Value >= 0.8 and not rayResult)
			--print(underRain)
			--First remove the wet // Or add if underRain
			userStats.Values.Wet = math.clamp(userStats.Values.Wet - (underRain and -3 or 6), 0, 100)
			--Insert/Remove from drown table
			if underWater then
				userStats.Values.Wet = plr:GetAttribute("Armor_ResistWet") and userStats.Values.Wet or 100 --If the player has a wetsuit or hazmat on then do not get them wet
				if inTable then 
				else
					drownTable[plr] = tick()
				end
				
			elseif inTable then
				drownTable[plr] = nil
				userStats.Values.Drowning = 0
			end
			
			local moveStates = user:GetMoveStates()
			local isSwimming = userStats.Values.Wet >= 99
			moveStates.StatSwimming = isSwimming
			
			--Check for diving tank
			if tankItem and tankItem.Durability and tankItem.Durability > 0 then
				tankItem.Durability = math.max(tankItem.Durability - 3, 0)
				user.Inventory:UpdateClient({"Armor", tankIndex, tankItem})
			else
				--Set Drown State
				if underWater and drownTime ~= nil and tick() - drownTime >= CHARACTER_LUNG_CAPACITY then
					userStats.Values.Drowning = 1
					DamageModule:Damage(head, Vector3.new(), Vector3.new(), nil, {
						Head = math.random(12, 20);
						Bleed = 0;
					}, {Start = 1000, End = 1000}, nil, nil, "Drowning")
					primPart.Drown:Play()
					changed = true
				else
					userStats.Values.Drowning = 0
				end
				changed = changed or (previousDrowning ~= userStats.Values.Drowning)
				if changed then
					return true
				end
			end
		end;
	};
	
	["BaseCabinet"] = { --This is the function that runs on each player to update the client to display their base cabinet info
		Timer = 2;
		LastCall = tick();
		Action = function(user, userStats, char, hum, primPart)
			local userStats = user.Stats
			if not (userStats and userStats:IsLoaded()) then return end
			
			local hrpPosition = primPart.Position
			local plr = user.Player
			
			local baseCabinet, isSafeZone = RaycastUtil:GetBaseCabinetUnder(hrpPosition) --Grab base cabinet if there is one
			isSafeZone = (isSafeZone == true)
			local hasAuth = false
			local cabinet
			local wasSafeZone = plr:GetAttribute("SafeZone")
			if not wasSafeZone and isSafeZone then
				--print("PLAYER IN SAFEZONE - UNEQUIPPING")
				user:Equip(0)
				user.Inventory:UpdateEquipped(0)
			end
			plr:SetAttribute("SafeZone", isSafeZone)
			if baseCabinet and not baseCabinet:GetAttribute("Monument") then
				cabinet = shared.Benches[baseCabinet]
				hasAuth = (cabinet and table.find(cabinet.Authorized or {}, plr.UserId))
			end
			
			local upkeepTick, tickLeft
			if cabinet then 
				upkeepTick = cabinet.UpkeepTick
				tickLeft = math.max(upkeepTick - tick(), 0)
			end
			
			if not baseCabinet then
				userStats.Values.BCAccess = 0
				userStats.Values.BCDenied = 0
				userStats.Values.Decay = 0
			elseif hasAuth then
				userStats.Values.BCAccess = tickLeft == 0 and -1 or tickLeft
				userStats.Values.BCDenied = 0
				userStats.Values.Decay = tickLeft == 0 and 1 or 0
			else
				userStats.Values.BCAccess = 0
				userStats.Values.BCDenied = 1
				userStats.Values.Decay = 0
			end
			
			return true
		end;
	};
	
	["NaturalRegen"] = { --Function for naturally regening characters
		Timer = 8.5;
		LastCall = tick();
		Action = function(user, userStats, char, hum, primPart)
			local hp = userStats:GetHp()
			if userStats.Values.Hunger >= 75 and userStats.Values.Thirst >= 75 and hp < 100 then
				userStats.Values.Hunger -= 0.25
				userStats.Values.Thirst -= 0.15
				userStats:SetHp(hp + 1)
				return true
			end
		end,
	};
	
	["TemperatureAndComfort"] = { --Function for determining users temperature, and some other things like the biome they are in
		Timer = 4;
		LastCall = tick();
		Action = function(user, userStats, char, hum, primPart)
			--Get the biome they are in
			local biome = (function()
				local start = primPart.Position
				start = Vector3.new(start.X, lowestBiomeRayPos, start.Z)
				local dir = Vector3.new(0, highestBiomeRayPos - lowestBiomeRayPos, 0) 
				local rayResult, rayPos = RaycastUtil:Raycast(start, dir, "Whitelist", BIOME_PARTS, true)
				if rayResult then
					return rayResult.Parent.Name
				end
			end)()
			local temp = WeatherModule.BiomeTemperatureFromClock(biome, Lighting.ClockTime) --temp will be heavily modified
			--calc temp based on wet and biome
			
			--Modify temp based on how wet
			local wet = userStats.Values.Wet
			if wet < 0 and wet <= 20 then
				temp -= 4
			elseif wet <= 40 then
				temp -= 7
			elseif wet <= 60 then
				temp -= 10
			elseif wet <= 80 then
				temp -= 13
			elseif wet <= 100 then
				temp -= 15
			end
			
			--Modify temp based on armor temp resistance
			
			--calculate their temperature based on armor stats
			
			--Get nearby heat sources (campfire and furnace), and apply to their temperature
			local totalHeat = (function()
				local heat = 0
				for _, bench in pairs(user.NearbyBenches) do
					if not bench.Heat then continue end
					heat += bench.Heat
				end
				return heat
			end)()
			--Remove some wet based on total heat near the user
			
			--Get comfort amount
			--first make sure we can be comfortable (not too cold or too hot)
			
			
			--todo
			for _, bench in pairs(user.NearbyBenches) do
				local benchClass = shared.Benches[bench]
				print(benchClass)
			end
			
			return true
		end,
	};
} 

--Events--

EVENT_HEALTH_CHANGED.Event:Connect(function(char, head, hp, mouthIndex) --This event applies different facial effects based on the characters hp
	if not (head and head.Parent) then return end
	local cuts = head:GetAttribute("Cuts")
	if not cuts then return end
	
	local eyes = head:FindFirstChild("Eyes")
	local mouth = head:FindFirstChild("Mouth")
	if not eyes or not mouth then return end
	
	if hp <= 0 then
		--RAGDOLL THEIR PLAYER, THEY DIED
		RagdollModule.RagdollCharacter(char)
		return
	end
	
	--Change eyes/mouth
	if hp <= 15 then
		eyes.Texture = AppearanceModule.Eyes[3]
		mouth.Texture = AppearanceModule.Mouth[mouthIndex][3]
	elseif hp <= 65 then
		eyes.Texture = AppearanceModule.Eyes[2]
		mouth.Texture = AppearanceModule.Mouth[mouthIndex][2]
	else
		eyes.Texture = AppearanceModule.Eyes[1]
		mouth.Texture = AppearanceModule.Mouth[mouthIndex][1]
	end
	
	--Put cuts on
	if hp <= 30 and cuts < 1 then 
		head:SetAttribute("Cuts", cuts + 1)
		local scuff = Instance.new("Decal")
		scuff.Name = "Scuff"
		scuff.Texture = AppearanceModule.Scuff[math.random(1, #AppearanceModule.Scuff)]
		scuff.Parent = head
	end
	if hp <= 15 and cuts < 2 then
		head:SetAttribute("Cuts", cuts + 1)
		local bruise = Instance.new("Decal")
		bruise.Name = "Bruise"
		bruise.Texture = AppearanceModule.Bruise[math.random(1, #AppearanceModule.Scuff)]
		bruise.Parent = head
	end
	
	--Take cuts off
	if hp >= 16 and cuts >= 2 then
		head:SetAttribute("Cuts", cuts - 1)
		local bruise = head:FindFirstChild("Bruise")
		if bruise then
			bruise:Destroy()
		end
	end
	if hp >= 31 and cuts >= 1 then
		head:SetAttribute("Cuts", 0)
		for _, v in pairs(head:GetChildren()) do
			if not v:IsA("Decal") then continue end
			if v.Name == "Bruise" or v.Name == "Scuff" then 
				v:Destroy()
			end
		end
	end
	
end)

--Remotes--

ModUtil:SetupRemotes(StatsRemotes, {
	[AllRemotes.Consume] = {
		Function = function(remote, player, args) --Event for when a player consumes an item
			local user = shared.Users[player]
			if not user then return end
			
			local char = player.Character
			if not char then return end
			local prim = char.PrimaryPart
			if not prim then return end
			
			--Ban checks
			local containerName = args[1]
			local slotIndex = args[2]
			if #args >= 3 or args[3] or type(containerName) ~= "string" or type(slotIndex) ~= "number" or slotIndex <= 0 or slotIndex % 1 ~= 0 then
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			
			--Cooldown checks
			if tick() - user.Stats.LastConsumable >= COOLDOWN_CONSUMABLE then
				user.Stats.LastConsumable = tick()
			else
				return
			end
			
			--Food Sanity Checks
			
			local inventory = user.Inventory:GetInv()
			local container = inventory[containerName]
			if not container then return end
			local item = container[slotIndex]
			if not (item and item ~= 0 and item.Amount > 0) then return end
			local info = Items[item.ID]
			if not info then return end
			
			if item.Amount > 0 then --If item exists and it has an amount remove one from the amount and eat it
				--Eat Code
				item.Amount -= 1
				local eatSound = prim:FindFirstChild(info.Name == "Water Bottle" and "Gulp" or "Eat")
				if eatSound and info.ConsumableStats.Hunger ~= nil then
					eatSound:Play()
				end
				user.Stats:ApplyConsumableTable(info.ConsumableStats)
			end
			
			if item.Amount <= 0 then
				container[slotIndex] = 0
			end
			
			--Update client inventory
			user.Inventory:UpdateClient({containerName, slotIndex, container[slotIndex]})
			--Update client stats
			user.Stats:UpdateClient()
		end;
	};
	
	[AllRemotes.Water] = {
		Function = function(remote, player, args) --Event for when a player consumes an item
			local user = shared.Users[player]
			if not user then return end
			local userStats = user.Stats
			if not (userStats and userStats:IsLoaded()) then return end

			--Ban checks
			local wetLevel = args[1]
			if type(wetLevel) ~= "number" or wetLevel < 0 or wetLevel > 100 or wetLevel % 1 ~= 0 then
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			
			local moveStates = user:GetMoveStates()
			if moveStates then
				local isSwimming = (wetLevel >= 99)
				moveStates.StatSwimming = isSwimming
			end
			
			--Apply water level code
			if not player:GetAttribute("Armor_ResistWet") and wetLevel > userStats.Values.Wet then
				userStats.Values.Wet = math.clamp(wetLevel, 0, 100)
			end
		end;
	};
	
	[AllRemotes.Surface] = {
		Function = function(remote, player, args) --Event for when a player was drowning, but has surfaced and wants to check
			local user = shared.Users[player]
			if not user then return end
			local userStats = user.Stats
			if not (userStats and userStats:IsLoaded()) then return end

			local char = player.Character
			local head = user.Head
			if not (char and head and head.Parent) then return end

			--Ban checks
			if #args > 0 then
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end

			local isUnder = IsUnderWater(head)
			if not isUnder then
				drownTable[player] = nil
			end
		end;
	};
	
	[AllRemotes.SendStats] = { -- this fires from the client once client has finished initializing
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			if #args > 0 then -- This should never have any arguments accompanying it
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			local userStats = user.Stats
			if not (userStats and userStats:IsLoaded()) then return end
			userStats:UpdateClient()
			--ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
		end;
	};
	
	[AllRemotes.Pickup] = { --no client should fire this
		Function = function(remote, player, args)
			ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
		end;
	};
	
	[AllRemotes.Death] = { --no client should fire this
		Function = function(remote, player, args)
			ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
		end;
	};
	
	[AllRemotes.Respawn] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local desiredSpawn = user.DesiredSpawn
			if desiredSpawn then return end -- Don't let them respawn if they're on respawn queue/about to respawn
			local userStats = user.Stats
			if not (userStats and userStats:IsLoaded()) then return end
			
			local respawnIndex = args[1] --a number from 0 - 5 that references the index of their sleeping bag. If 0, respawn randomly
			--print(respawnIndex)
			if #args ~= 1 or respawnIndex < 0 or respawnIndex > ServerService:GetAttribute("MaxAllowedBeds") or respawnIndex % 1 ~= 0 then 
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			
			local character = player.Character
			if character then
				local humanoid = user.Humanoid
				if humanoid and humanoid.Parent and humanoid.Health > 0 then return end
			end
			
			if respawnIndex > 0 then -- if they're trying to spawn on a bed, check if bed is eligible
				local beds = shared.Beds[player.UserId]
				if not beds then return end
				local bed = beds[respawnIndex]
				if not (bed and bed.Parent) then return end
				local bench = shared.ActiveBenches[bed]
				local bedPrim = bed.PrimaryPart
				if not (bedPrim and bench) then return end
				local curTime = os.time()
				local timePassed = curTime - (bench.LastRespawn or 0)
				if timePassed < bench.BedTimer then return end
				for _, currentModel in pairs(beds) do
					if not (currentModel and currentModel.Parent) then continue end
					local prim = currentModel.PrimaryPart
					if not prim then continue end
					local currentBench
					local dist = 0
					if currentModel ~= bed then
						if not NumberUtil:IsWithin(Vector2.new(prim.Position.X, prim.Position.Z), Vector2.new(bedPrim.Position.X, bedPrim.Position.Z), 150) then continue end
						currentBench = shared.ActiveBenches[currentModel]
						if not currentBench then continue end
					else
						currentBench = bench
					end
					currentBench.LastRespawn = curTime
					--print("setting timer of", currentModel, "dist of", math.floor(dist), "studs")
				end
				user:UpdateBedInfos(beds)
			end
			user.DesiredSpawn = respawnIndex
			table.insert(shared.RespawnQueue, user)
			if character then
				RagdollModule.CreateVFXRagdoll(character)
			end
		end;
	};
	
	[AllRemotes.Revive] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			
			local toRevive = args[1]
			
			if type(toRevive) == "string" then return end -- Anticheat sometimes returns a string when the instance passed to the server is nil, so just return
			
			--Ban check
			if #args >= 2 or args[2] or (toRevive and typeof(toRevive) ~= "Instance") then 
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			
			--Cancel revive check
			if toRevive == false then
				--make sure they are removed from revive table
				reviveTable[player] = nil
				return
			elseif not (toRevive and toRevive.Parent) then
				return
			end
			
			--Start revive
			local revivingHum = user.Humanoid
			if not (revivingHum and revivingHum.Parent and revivingHum.Health > 0 and not revivingHum:GetAttribute("Downed")) then return end
			local revivingChar = revivingHum.Parent
			
			local revivedChar = toRevive
			local revivedHum = revivedChar:FindFirstChild("Humanoid")
			local revivedPlayer = Players:GetPlayerFromCharacter(revivedChar)
			
			--Make sure a revive doesn't already exist from the reviver if it does, return
			for revivingPlayer, revivedPlayer in pairs(reviveTable) do --i loop through this again yeah, whatever its not like they ever will both run together, its either or. only had to type it out twice
				if revivingPlayer == player then
					return
				end
			end
			--Add them to the revive table, set their humanoid to be reviving and start the loop and start the loop
			reviveTable[player] = revivedPlayer
			revivedHum:SetAttribute("Reviving", true)
			
			--start the revive loop
			local startTime = tick()
			while true do
				-- There were no checks if the existing characters even exist still, loop could've kept infinitely running
				if not (revivingChar.Parent and revivedChar.Parent) then break end
				local revivingPrim = revivingChar.PrimaryPart
				local revivedPrim = revivedChar.PrimaryPart
				if not (revivingPrim and revivedPrim) then break end
				local origin = revivingPrim.Position
				local dir = revivedPrim.Position
				if reviveTable[player] == nil then break end --If they were removed from the revive table, break (this happens when the reviver cancels their revive)
				local isObstructed = RaycastUtil:Raycast(origin, dir - origin, "Blacklist", {workspace.VFX, workspace.Drops, workspace.Plants, revivingChar, revivedChar, workspace.Animals}, false, viewFilterFunc, true)
				if isObstructed then break end --If there is no sight of the person you are trying to revive, break
				local reviveCompleted = tick() - startTime >= REVIVE_TIME
				if reviveCompleted then --The revive finished, revive the player
					reviveTable[player] = nil
					revivedHum:SetAttribute("Reviving", false)
					revivedHum:SetAttribute("Downed", false)
					revivedChar.PrimaryPart.Anchored = false
					break
				end
				task.wait(reviveLoopCheckCooldown)
			end
		end;
	};
})

--Server Loop-- 		NOTE : Maybe make the functions call in a pcall
while Values.Loading.Value do wait() end

while true do 
	
	-- To optimize the code, we wanna check what actions are available to run so that we don't reloop over users
	local tickActions = {}
	local currentTick = tick()
	for name, tickAction in pairs(TickActions) do
		if currentTick - tickAction.LastCall < tickAction.Timer then continue end
		table.insert(tickActions, tickAction)
		tickAction.LastCall = currentTick
	end
	
	-- Now we check all users if there is any tick actions to complete
	if #tickActions > 0 then
		for player, user in pairs(shared.Users) do
			if user.Left or not (player and player.Parent) then continue end
			local userStats = user.Stats
			local char = player.Character
			local hum = user.Humanoid
			local head = user.Head
			-- Check if player is even eligible for having a stat update
			if not userStats:IsLoaded() or not char or not char.Parent or not hum or not hum.Parent or not head or not head.Parent then continue end
			local primPart = char.PrimaryPart
			if not primPart then continue end
			local doUpdate = false
			for _, tickAction in pairs(tickActions) do
				local updated = tickAction.Action(user, userStats, char, hum, primPart, head)
				if not updated then continue end
				doUpdate = true -- If any stats were changed, update to client once instead of multiple times over
			end
			if not doUpdate then continue end
			userStats:UpdateClient()
		end
	end
	
	
	
	--Drown Table Loop
	--If a player were to leave the game while under water, I suspect that there could be a memory leak in the drownTable, this check will see if a tick() has been there for unreasonably long
	
	for index, drownTick in pairs(drownTable) do
		if tick() - drownTick >= 600 then
			drownTable[index] = nil
			--print("STATS SERVICE CLEANED MEMORY LEAK FROM DROWN TABLE, REASON: PLAYER LEFT GAME UNDERWATER")
		end
	end
	
	task.wait(0.1) -- loop doesn't need to be running every framer
end