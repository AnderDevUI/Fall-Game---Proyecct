-- [PATH] ServerStorage / Modules / DamageModule @Type ModuleScript
--[[
	DamageModule
	by ChickenBagelz                                   :P
	September 9th, 2022
	
	Handles damaging math (and base logic too now lol)
]]


-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local ServerScripts = game:GetService("ServerScriptService")
local Debris = game:GetService("Debris")
local Run = game:GetService("RunService")

-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")
local BuildService = ServerScripts:WaitForChild("BuildService")
local InventoryService = ServerScripts:WaitForChild("InventoryService")
local BenchService = ServerScripts:WaitForChild("BenchService")
local CombatService = ServerScripts:WaitForChild("CombatService")
local MilitaryService = ServerScripts:WaitForChild("MilitaryService")

-- Folders
local Nodes = workspace:WaitForChild("Nodes")
local Trees = workspace:WaitForChild("Trees")
local Vegetation = workspace:WaitForChild("Vegetation")
local VFX_PARTS = workspace:WaitForChild("VFX")
local Bases = workspace:WaitForChild("Bases")
local Animals = workspace:WaitForChild("Animals")
local Drops = workspace:WaitForChild("Drops")
local Plants = workspace:WaitForChild("Plants")
local Military = workspace:WaitForChild("Military")
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local Environment = Storage:WaitForChild("Environment")
local Remotes = Replicated:WaitForChild("Remotes")
local Benches = Replicated:WaitForChild("Benches")
local GlobalSounds = Storage:WaitForChild("GlobalSounds")
local Values = Replicated:WaitForChild("Values")

-- Remotes
local VFXRemotes = Remotes:WaitForChild(string.char(117, 120, 9, 96, 94, 13, 91, 23, 14, 148, 185, 74, 28, 140, 96, 114, 26, 142, 147, 134, 186, 127, 154, 150, 62, 16, 83, 53, 24, 157))
local BuildRemotes = Remotes:WaitForChild(string.char(75, 121, 79, 188, 126, 63, 141, 137, 5, 132, 117, 32, 190, 12, 68, 117, 78, 118, 140, 65, 50, 109, 56, 50, 110, 58, 36, 182, 159, 121))
local CombatRemotes = Remotes:WaitForChild(string.char(136, 151, 150, 79, 83, 47, 12, 43, 83, 127, 29, 120, 155, 32, 59, 102, 175, 55, 75, 15, 144, 155, 96, 107, 90, 79, 115, 186, 42, 82))
local StatsRemotes = Remotes:WaitForChild(string.char(32, 175, 56, 160, 50, 187, 113, 77, 49, 22, 130, 142, 126, 38, 59, 102, 17, 6, 168, 41, 9, 180, 85, 142, 105, 14, 66, 146, 142, 126))
local AllRemotes = {
	Visualize = string.char(103, 133, 9, 154, 39, 163, 146, 21, 57, 183, 145, 92, 150, 21, 92, 2, 189, 66, 182, 45, 146, 49, 108, 138, 183, 131, 181, 117, 142, 7);
	Place = string.char(79, 142, 119, 97, 58, 167, 123, 111, 23, 3, 159, 15, 11, 179, 50, 145, 9, 2, 100, 102, 64, 125, 111, 95, 113, 88, 112, 179, 104, 70);
	Hit = string.char(63, 185, 85, 143, 181, 42, 176, 169, 42, 28, 185, 69, 146, 23, 65, 25, 81, 156, 122, 115, 80, 75, 175, 156, 99, 9, 117, 72, 112, 120);
	Respawn = string.char(21, 54, 128, 117, 144, 74, 114, 58, 57, 133, 153, 4, 99, 105, 92, 58, 142, 91, 73, 106, 155, 168, 85, 5, 16, 140, 31, 77, 120, 13);
}

-- Modules
local Items = require(SharedModules:WaitForChild("Items"))
local ToolInfo = require(SharedModules:WaitForChild("ToolInfo"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local VFXModule = require(SharedModules:WaitForChild("VFXModule"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local LootTableModule = require(ServerModules:WaitForChild("LootTableModule"))
local BenchInfo = require(SharedModules:WaitForChild("BenchInfo"))
local RecipeModule = require(SharedModules:WaitForChild("RecipeModule"))
local ArmorModule = require(SharedModules:WaitForChild("ArmorModule"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local TweenUtil = require(SharedModules:WaitForChild("TweenUtil"))
local SoundModule = require(ServerModules:WaitForChild("SoundModule"))

-- Bindables
local PopulateEvent = BenchService:WaitForChild("Populate")

-- Global Functions
shared.ReplicateGibs = function(benchModel)
	local name = benchModel.Name
	local primPart = benchModel.PrimaryPart
	if not (primPart and benchModel:IsDescendantOf(Bases)) then return end
	local damageType = benchModel:GetAttribute("DamageType")
	local storageBench = Benches:FindFirstChild(name)
	if not storageBench then return end
	local gibName = (storageBench:IsA("Model") and damageType or "")..name
	--print("creating gibs for", gibName)
	ModUtil:FireAllClients(VFXRemotes, AllRemotes.Visualize, "CreateBenchGibs", gibName, primPart.CFrame)
end

--Settings
local MIN_DOWN_TIME = 15
local MAX_DOWN_TIME = 30

-- Local Variables
local lastPlayerDamage = 0

-- Raycast Filter Functions
local viewFilterFunc = RaycastUtil:FilterFunction("View")
local hitIgnoreFilterFunc = RaycastUtil:FilterFunction("HitIgnore")


local DamageModule = {}

function DamageModule:HitLimbType(name)
	return (name == "Head" and "Head" or (name:find("Torso") and "Chest" or ((name:find("Foot") or name:find("Leg")) and "Legs" or ((name:find("Hand") or name:find("Arm")) and "Arms" or "Unknown"))))
end

function DamageModule:Damage(hit: BasePart, pos: Vector3, normal: Vector3, firedCF: CFrame, damages: {}, dropoff: {Start: number, End: number}, ammoStats: {}, item: {}|number, attacker: Player, softSideMult: number, resistance: string, ignoreResources: boolean, durabilities: {}, useDamages: boolean?): Instance
	--print(hit, pos, normal, firedCF, damages, dropoff, ammoStats, item, attacker, softSideMult, resistance, ignoreResources, durabilities)
	if not (hit and hit.Parent) then return end
	local parent = hit.Parent
	local position = (hit.CFrame * CFrame.new(pos)).Position
	local object = parent
	local currentHealth = object:GetAttribute("Health")
	local humanoid = object:FindFirstChild("Humanoid")
	if not (currentHealth or humanoid) then
		object = object.Parent
		currentHealth = object:GetAttribute("Health")
		humanoid = object:FindFirstChild("Humanoid")
	end
	local benchInfo = BenchInfo[object.Name]
	local maxHealth = object:GetAttribute("MaxHealth")
	local damageType = object:GetAttribute("DamageType")
	local objectBase = object:FindFirstAncestor("Base")
	local plr, attackUser
	if attacker == "Bleeding" or attacker == "Unknown" then
		plr = Players:GetPlayerFromCharacter(object)
		local user = shared.Users[plr]
		if plr and user then
			local lastDamagedId = user.LastDamagedByUserId
			local lastDamagedItem = user.LastDamagedByItem
			if lastDamagedId and type(lastDamagedItem) == "number" then
				local lastDamagedBy = Players:GetPlayerByUserId(lastDamagedId)
				attackUser = shared.Users[lastDamagedBy]
				if attackUser then
					item = lastDamagedItem
					print("FOUND LAST DAMAGED PLAYER", lastDamagedBy, lastDamagedItem)
				end
			end
		end
	end
	attackUser = (attackUser or shared.Users[attacker])
	local itemInfo = (item and (type(item) == "number" and Items[item] or Items[item.ID]))
	local toolInfo = (itemInfo and ToolInfo[itemInfo.Name])
	local objectDamages = (toolInfo and toolInfo.ObjectDamages)
	local exploInfo = (ammoStats and ammoStats.Explosive)
	local isBoss = (object.Name == "BTR")
	local damageTable = (useDamages and damages or ((benchInfo ~= nil and objectDamages and (not humanoid or isBoss)) and objectDamages.Benches or damages))
	local didFirst = false
	local durType, hitLimb, distance
	local isNaturalDamage = (type(attacker) == "string")
	local attackerUserStats = (attackUser ~= nil and attackUser.UserStats)
	local durDecreaseMult = ServerService:GetAttribute("DurabilityDecreaseMult")
	if humanoid or (benchInfo and currentHealth and maxHealth) then
		--apply bleeds to users
		local attachmentStats = (type(item) == "table" and item:AttachmentStats() or {})
		plr = (plr or Players:GetPlayerFromCharacter(object))
		hitLimb = self:HitLimbType(hit.Name)
		local user
		if attackUser and not isNaturalDamage and (attacker:GetAttribute("SafeZone") or attacker:GetAttribute("DamageDisabled")) and object.Name == "Sleeper" then return end
		local wepDmgMult = (type(item) == "table" and (humanoid and CombatService:GetAttribute("WeaponHumanoidDamageMult") or CombatService:GetAttribute("WeaponBenchDamageMult")) or 1)
		if plr then
			user = shared.Users[plr]
			if (not user) or ((plr:GetAttribute("SafeZone") or plr:GetAttribute("DamageDisabled")) and not isNaturalDamage) or (not isNaturalDamage and attackUser and attackUser ~= user and (attacker:GetAttribute("SafeZone") or attacker:GetAttribute("DamageDisabled") or (attacker.Team ~= nil and plr.Team ~= nil and plr.Team == attacker.Team))) then return end
			local bleed = (damages.Bleed or 0) * (ammoStats and ammoStats.BleedMult or 1)
			local rawBleed = NumberUtil:NumberToInteger(bleed * (hitLimb == "Head" and 1.5 or hitLimb == "Legs" and 0.75 or 1) * wepDmgMult)
			local userStats = user.Stats
			if userStats:IsLoaded() then
				userStats.Values["Bleed"] += rawBleed
			end
			if type(item) == "table" and hitLimb == "Head" then
				SoundModule:PlayLocalSound(plr, "HitHead")
			end
		end
		distance = (firedCF ~= nil and (position - firedCF.Position).Magnitude or 0)
		local rangeMult = (1 + (attachmentStats.RangeMult or 0)) * (ammoStats and ammoStats.RangeMult or 1)
		local damageMult = math.max((ammoStats and ammoStats.DamageMult or 1) + (attachmentStats.DamageMult or 0), 0) * (1 + (ammoStats and ammoStats.HeadshotDamageMult or 0))
		local dropStart = dropoff.Start * rangeMult
		local dropEnd = dropoff.End * rangeMult
		local dropDiff = dropEnd - dropStart
		-- 1 - math.min(math.max(distance - dropStart, 0) / dropDiff, 1)
		local distMult = (dropDiff <= 0 and (distance > dropStart and 0 or 1) or math.max(0, 1 - math.max((distance - dropStart) / dropDiff, 0) ^ 5)  )
		local tableIndex = damageType or (benchInfo ~= nil and benchInfo.DamageType or (hitLimb == "Unknown" and "Arms" or hitLimb))
		local hitDamage = (type(damages) == "number" and damages or damageTable[tableIndex]) or 0
		local isSoftSide = (benchInfo ~= nil and RaycastUtil:NormalToFace(normal, hit) == (benchInfo.SoftSide ~= nil and Enum.NormalId[benchInfo.SoftSide]))
		local rawDamage = hitDamage * damageMult * distMult * (isSoftSide and softSideMult or 1) * wepDmgMult * ((resistance == "Melee" and benchInfo ~= nil) and benchInfo.MeleeResistance or 1)
		--print(hitDamage, rawDamage, rangeMult, damageMult, distMult, isSoftSide, tableIndex, damageTable, humanoid, currentHealth, benchInfo, object, hit, exploInfo)
		--print(distance, distMult, rawDamage)
		if rawDamage > 0 then
			if humanoid and not isBoss then
				local protMult = 1
				local armorPenMult = (ammoStats and ammoStats.ArmorPenMult or 1)
				if user and resistance then
					local userStats = user.Stats
					local inventory = user.Inventory
					if inventory and userStats and userStats:IsLoaded() then
						local resistances = userStats.Resistances
						local stat = resistances[resistance]
						local allArmors = inventory:GetArmor()
						local armors, indexes
						if stat then
							armors, indexes = ArmorModule:GetArmors(allArmors, resistance)
						else
							local resistanceType = (hitLimb == "Arms" and "Chest" or hitLimb)
							stat = (resistances[resistanceType] or {})[resistance]
							armors, indexes = ArmorModule:GetArmors(allArmors, resistanceType)
						end
						local updates = {}
						for index, armor in pairs(armors) do
							local armorInfo = Items[armor.ID]
							local dur = armor.Durability
							if not (armorInfo and dur and armorInfo.MaxDurability) then continue end
							local armorIndex = indexes[index]
							armor.Durability = math.max(dur - rawDamage * durDecreaseMult, 0)
							--print(armorInfo.Name, armor.Durability)
							table.insert(updates, {"Armor", armorIndex, armor})
						end
						if #updates > 0 then
							inventory:UpdateClient(unpack(updates))
						end
						if stat then
							protMult = math.max(1 - stat * armorPenMult / 100, 0)
						end
					end
				end
				local actualDamage = NumberUtil:RoundNumber(rawDamage * protMult, 1, true)
				--print(resistance, rawDamage, protMult, armorPenMult, actualDamage)
				if actualDamage > 0 then
					if user then
						if user.Stats and user.Stats:IsLoaded() then
							local statValues = user.Stats.Values
							if statValues.HQueue > 0 then
								--[[local newHQueue = math.max(statValues.HQueue - actualDamage * 2, 0)
								local newActualDamage = math.max(actualDamage - (statValues.HQueue - newHQueue) / 2, 0)
								actualDamage = newActualDamage
								print(statValues.HQueue, newHQueue, actualDamage, newActualDamage)
								statValues.HQueue = newHQueue]]
								statValues.HQueue = math.max(statValues.HQueue - actualDamage, 0)
								user.Stats:UpdateClient()
							end
						end
						ModUtil:FireClient(StatsRemotes, AllRemotes.Respawn, plr, actualDamage, attacker, (firedCF ~= nil and firedCF.Position))
					end
					local health = humanoid.Health
					local newHealth = health - actualDamage
					local healthToDown = 0 -- must be less than 5
					local healthToKill = 25
					local lastDown = humanoid:GetAttribute("LastDown")
					if health >= 50 and lastDown then
						humanoid:SetAttribute("LastDown", nil)
						lastDown = nil
					end
					local canDown = (newHealth <= healthToDown and health > healthToDown and attackUser and ServerService:GetAttribute("PlayerDowningEnabled") and os.clock() - (lastDown or 0) > 45)
					local actualHealth = NumberUtil:RoundNumber(canDown and (1 - math.max((healthToDown - newHealth) / healthToKill, 0)) * 5 or math.max(newHealth, 0), 1, true)
					local userStats = (user ~= nil and user.Stats)
					local userEquipped = (user ~= nil and user.Equipped.Model)
					local userWepEquipped = ((userEquipped and userEquipped.Name ~= "Blueprint") and userEquipped.Name)
					if attackUser and not isNaturalDamage then
						lastPlayerDamage = os.clock()
						if plr and user and item then
							user.LastDamagedByUserId = attackUser.Player.UserId
							user.LastDamagedByItem = (type(item) == "table" and item.ID or item)
							print(plr, "last damaged by", attackUser.Player, user.LastDamagedByItem)
						end
					end
					if canDown and actualHealth > 0 and plr and userStats and humanoid and humanoid.Parent then
						humanoid.Health = actualHealth
						--MAKE THE PLAYER DOWN (CHECK IF THEY AREN'T DOWNED, RUN IN A SEPARATE THREAD)
						--print(plr, "WAS DOWNED WITH", actualHealth, "HP LEFT")
						if attackerUserStats and itemInfo then
							attackerUserStats:Synchronize("AddWeaponStat", "Downs", itemInfo.Name, userWepEquipped)
						end
						userStats.Values.Bleed = 0 --remove their bleeds
						if not user:DropHeldItem() then
							user:Equip(0)
						end
						humanoid:SetAttribute("Downed", true)
						humanoid:SetAttribute("LastDown", os.clock())
						object.PrimaryPart.Anchored = true
						task.defer(function() --Run another thread to run their lifetime while they are downed
							local loopTimer = 1
							local secondsDown = 0
							local downTime = math.random(MIN_DOWN_TIME, MAX_DOWN_TIME)
							local getUp = math.random(1, 100) <= 10
							while true do
								task.wait(loopTimer)
								if not (humanoid and humanoid.Parent) then return end
								if humanoid:GetAttribute("Reviving") == true then continue end
								if humanoid:GetAttribute("Downed") == false then break end --user was revived
								if secondsDown >= downTime then
									if getUp then
										object.PrimaryPart.Anchored = false
										humanoid:SetAttribute("Downed", false) --Revive the player
									else
										DamageModule:Damage(hit, Vector3.new(), Vector3.new(), nil, {
											Head = 10000;
											Chest = 10000;
											Arms = 10000;
											Legs = 10000;
											Bleed = 0;
										}, {Start = 1000, End = 1000}, nil, nil, "Unknown")
									end
									break --break loop and end thread
								end
								secondsDown += 1
							end
						end)
					elseif health > 0 and actualHealth <= 0 then
						if user then
							if itemInfo then
								user.CauseOfDeath = (type(item) == "table" and item.ID or item)
							end
							if attackUser then
								user.KilledBy = attackUser.Player.UserId
							elseif isNaturalDamage then
								user.CauseOfDeath = attacker
							end
						end
						humanoid.Health = actualHealth
						if attackerUserStats and itemInfo and plr and user then
							local attackPlayer = attackUser.Player
							attackerUserStats:Synchronize("AddWeaponStat", "Kills", itemInfo.Name, userWepEquipped)
							if Values.ServerType.Value == "GunGame" and not shared.GunGameWon then
								pcall(function()
									attackUser.Stats:SetHp(math.min(attackUser.Stats:GetHp() + 75, 100))
								end)
								local points = (attackPlayer:GetAttribute("Points") or 0) + 1
								if not itemInfo.Name:find("ez shovel") then
									attackPlayer:SetAttribute("Points", points)
									if points >= #shared.GunGameWeapons then
										--print(attacker, "won without shovel")
										shared.GunGameWon = attackPlayer.DisplayName
									else
										local gunLevel = shared.GunGameWeapons[points + 1]
										attackUser:ApplyKits(gunLevel.Weapon, gunLevel.Armor)
										LootTableModule:ApplyLootTableToPlayer(attackPlayer, shared.WeaponKits[50].Items, nil, nil, true) -- golden shovel
										attackUser:Equip(1)
										attackUser.Inventory:UpdateEquipped(1)
									end
								else
									if points >= #shared.GunGameWeapons then
										--print(attacker, "won using shovel")
										shared.GunGameWon = attackPlayer.DisplayName
									else
										plr:SetAttribute("Points", math.max(plr:GetAttribute("Points") - 1, 0))
									end
								end
							elseif Values.ServerType.Value == "Combat" then
								local combatArena = attackUser:IsInCombatArena(true)
								if type(combatArena) == "table" and combatArena:HasStarted() then
									local attackPlayer = attackUser.Player
									local attackerColor = (attackPlayer.Team and attackPlayer.Team.TeamColor.Color:ToHex():upper() or "FFFFFF")
									local plrColor = (plr.Team and plr.Team.TeamColor.Color:ToHex():upper() or "FFFFFF")
									--print("SHOULD SEND MESSAGE", attacker, plr, attackerColor, plrColor)
									local fromCause = (type(itemInfo) == "table" and ` USING <font color="#FFD3D3">{itemInfo.Name:upper()}</font>` or "")
									local extraCause = isNaturalDamage and `{fromCause == "" and "USING UNKNOWN" or fromCause:sub(2)}, PLAYER BLED OUT` or `{math.ceil(distance)} STUDS, HIT {hit ~= nil and hit.Name:upper() or "UNKNOWN"}{fromCause}`
									combatArena:SendMessage(
										`<font color="#{attackerColor}">{attackPlayer.DisplayName}</font> KILLED <font color="#{plrColor}">{plr.DisplayName}</font> ({extraCause})`
										, false)
									if combatArena.HealthRegen then
										pcall(function()
											attackUser.Stats:SetHp(math.min(attackUser.Stats:GetHp() + 60, 100))
										end)
									end
								end
							end
						end
						if object.Name == "Sleeper" then
							task.defer(function()
								DamageModule:DestroyBench(object, nil, nil, nil, nil, true)
							end)
						end
					else
						humanoid.Health = actualHealth
						if actualHealth > 0 and attackUser and attacker and not plr and object:IsDescendantOf(Military) then
							MilitaryService.DamageMilitary:Fire(object, attacker, actualDamage)
						end
					end
				end
				durType = "Humanoid"
				didFirst = true
			elseif benchInfo ~= nil then
				rawDamage = NumberUtil:RoundNumber(rawDamage, 1, true)
				if maxHealth and maxHealth > 0 and not exploInfo then
					local newHealth = currentHealth - rawDamage
					object:SetAttribute("Health", math.max(newHealth, 0))
					object:SetAttribute("LastDamaged", math.floor(tick()))
					
					if object:GetAttribute("Armed") and object.Name == "Bear Trap" then
						local bench = shared.Benches[object]
						if bench and not bench.Arming then
							bench.Arming = true
							bench:ToggleTrap(false)
							task.delay(1, function()
								if not object.Parent then return end
								bench.Arming = false
							end)
						end
					end
					
					if newHealth <= 0 then
						if object:GetAttribute("BreakLocked") then
							object:SetAttribute("MaxHealth", 0)
							object:SetAttribute("BreakLocked", false)
							object.PrimaryPart.ChainBreak:Play()
							object.PrimaryPart.ChainRattle:Play()
							TweenUtil:Tween(object.Chains, {"Transparency", "CFrame"}, {1, object.Chains.CFrame * CFrame.new(0, -1, 0)}, 0.5, "Cubic", "In")
						elseif not isBoss then
							task.defer(function()
								self:DestroyBench(object, false, nil, true, pos)
								self:UpdateBaseCost(objectBase)
							end)
						end
					end
				end
				durType = (object:GetAttribute("Stability") and "BasePart" or "Bench")
				didFirst = true
			end
		end
	end
	if exploInfo then
		local damagedHum = DamageModule:ExplosionDamage(position, normal, objectDamages, exploInfo, attacker, nil, item)
		if damagedHum and attackUser and attacker.Parent and not (humanoid and didFirst) then
			ModUtil:FireClient(CombatRemotes, AllRemotes.Hit, attacker, "HitMarker", "Hit")
		end
	end
	if type(item) == "table" and maxHealth then
		local isBreakable = (itemInfo and toolInfo and currentHealth and objectDamages and attackUser) and not didFirst
		if isBreakable and not durType then
			durType = "Breakable"
		end
		if durabilities and attackUser and itemInfo.MaxDurability then
			local userEquipped = attackUser.Equipped
			local userInventory = attackUser.Inventory
			local toolbar = userInventory:GetToolbar()
			local dur = (durabilities[durType] or 1)
			item.Durability = math.max(item.Durability - dur * durDecreaseMult, 0)
			--print("did", dur, "durability", durType)
			if not ignoreResources and toolbar then
				userInventory:UpdateClient({"Toolbar", userEquipped.Index, toolbar[userEquipped.Index]})
				--userInventory:UpdateClient({"Toolbar", userEquipped.Index, item})
			end
		end
		local nodeDamages = objectDamages.Nodes
		local treeDamages = objectDamages.Trees
		local cactusDamages = objectDamages.Cactus
		local logDamages = objectDamages.Logs
		local animalDamages = objectDamages.Animals
		local typ, damageInfo, lootTablePath, lootTableFinish
		local name = object.Name
		if object.Parent == Nodes and nodeDamages and not ignoreResources then
			local nodeType = object.Name:sub(1, object.Name:len() - 5)
			damageInfo = nodeDamages[nodeType]
			lootTablePath = {"Nodes", nodeType, "Start"}
			lootTableFinish = LootTableModule:GetLootTable("Nodes", nodeType, "Finish")
			typ = "Node"
		elseif object.Parent == Trees and treeDamages and not ignoreResources then
			local treeType = (name:find("Desert") and "Desert" or (name:find("Small") and "Small" or (name:find("Giant") and "Giant" or "Medium")))
			damageInfo = treeDamages[treeType]
			lootTablePath = {"Trees", treeType, "Start"}
			lootTableFinish = LootTableModule:GetLootTable("Trees", treeType, "Finish")
			typ = "Tree"
		elseif name:find("Cactus") and object.Parent == Vegetation and cactusDamages and not ignoreResources then
			local cactusType = (name:find("Small") and "Small" or (name:find("Large") and "Large" or "Medium"))
			damageInfo = cactusDamages[cactusType]
			lootTablePath = {"Cacti", cactusType}
			typ = "Cactus"
		elseif name:find("Log") and object.Parent == Vegetation and logDamages and not ignoreResources then
			damageInfo = logDamages
			lootTablePath = {"Logs"}
			typ = "Log"
		elseif object.Parent == Animals and animalDamages and not ignoreResources then
			damageInfo = animalDamages[name]
			lootTablePath = {"Animals", name}
			typ = "Animal"
		end
		if not (damageInfo and lootTablePath) then
			typ = nil
		end
		if typ then
			local pivot = object:GetPivot()
			local isSpark = (parent.Name == "NodeSpark" or parent.Name == "TreeX")
			local rawDamage = 1 / damageInfo.HitsToBreak * (isSpark and damageInfo.SparkMult or 1)
			local gatherMult = damageInfo.Mult * ServerService:GetAttribute("GatherMult")
			local luckMult = ServerService:GetAttribute("LuckMult")
			local hitLootTable = LootTableModule:GetHitLootTable(object, lootTablePath, gatherMult, luckMult)
			if type(hitLootTable) == "table" and hitLootTable.DoHit then
				hitLootTable:DoHit(rawDamage, attacker, true, true)
				local r = hitLootTable:GetHealth()
				local isZero = r <= 0.0001
				--print(hitLootTable, r)
				object:SetAttribute("Health", maxHealth * r)
				if isZero then
					if lootTableFinish then
						LootTableModule:ApplyLootTableToPlayer(attacker, lootTableFinish, true, gatherMult, false)
					end
					LootTableModule:RemoveHitLootTable(object)
				end
				if typ == "Node" then
					local main = object:FindFirstChild("Main")
					local particles = parent:FindFirstChild("ParticleHolder")
					local currentState = object:GetAttribute("State")
					local newState = (isZero and 0 or ((r <= 0.2 and currentState > 1) and 1 or ((r <= 0.4 and currentState > 2) and 2 or ((r <= 0.65 and currentState > 3) and 3 or 4))))
					if isSpark and particles then
						local sparkSound = GlobalSounds.Node[isZero and "SparkFinish" or "Spark"]:Clone()
						sparkSound.Parent = particles
						parent.Parent = VFX_PARTS
						sparkSound:Play()
						for _, particle in pairs(particles:GetChildren()) do
							if particle:IsA("Sound") then continue end
							particle.Enabled = (particle.Name ~= "Shine")
						end
						task.delay(0.25, function()
							if not (particles and particles.Parent) then return end
							for _, particle in pairs(particles:GetChildren()) do
								if particle:IsA("Sound") then continue end
								particle.Enabled = false
							end
							task.wait(1.75)
							if not (particles and particles.Parent) then return end
							parent:Destroy()
						end)
						task.wait(0.4)
					end
					local change = (currentState > newState)
					if change then
						--print("changing node state", currentState, newState)
						object:SetAttribute("State", newState)
						local newSize = Environment[name]:FindFirstChild("Size"..newState)
						main.Transparency = 1
						main.CanCollide = false
						for _, particle in pairs(main.ParticleHolder:GetChildren()) do
							if particle.Name == "Finish" and not isZero then continue end
							particle.Enabled = true
						end
						main.Parent = VFX_PARTS
						if newSize then
							newSize = ModUtil:SafeClone(newSize)
							newSize:SetPrimaryPartCFrame(pivot)
							newSize.PrimaryPart:Destroy()
							for _, v in pairs(newSize:GetChildren()) do
								v.Parent = object
							end
							shared.SetModelCollision(object, "Nodes", true)
							newSize:Destroy()
						end
					end
					local curSpark = object:FindFirstChild("NodeSpark")
					if (not isZero) and (curSpark == nil or change) then
						local sparkPos
						if curSpark then
							sparkPos = curSpark.Main.Position
							curSpark:Destroy()
						end
						local didSpark = false
						for i = -30, 30, 4 do
							local line = CFrame.new((sparkPos or position), pivot.Position) * CFrame.new(math.random(-40, 40) / 10, math.random(i, 30) / 10, 5)
							local offset = line.Position - pivot.Position
							local hit, hitPos = RaycastUtil:Raycast(line.Position, (pivot.Position - line.Position), "Whitelist", object)
							local offset = pivot:PointToObjectSpace(hitPos)
							--print(offset.Y)
							if not (hit and offset.Y > 0) then continue end
							didSpark = true
							local spark = ModUtil:SafeClone(Environment.NodeSpark)
							spark:SetPrimaryPartCFrame(CFrame.new(hitPos, pivot.Position))
							for _, particle in pairs(spark.ParticleHolder:GetChildren()) do
								particle.Enabled = (particle.Name == "Shine")
							end
							spark.Parent = object
							break
						end
						if not didSpark then
							warn("SPARK CREATION FAILED")
						end
					elseif isZero and curSpark then
						curSpark:Destroy()
					end
					if change and main and main.Parent then
						local changeSound = GlobalSounds.Node[isZero and "Finish" or "Crumble"]:Clone()
						changeSound.Parent = main
						changeSound:Play()
						ModUtil:FireAllClients(VFXRemotes, AllRemotes.Visualize, "CreateGibs", name.."Gibs", pivot * CFrame.Angles(math.rad(90), 0, 0), 10, 12, 0.5, 20, 20, 60, 10, 15, true)
						task.wait(0.15)
						if main and main.Parent then
							for _, particle in pairs(main.ParticleHolder:GetChildren()) do
								particle.Enabled = false
							end
						end
						task.wait(1.4)
						if main and main.Parent then
							main:Destroy()
						end
					end
				elseif typ == "Tree" then
					local main = object:FindFirstChild("Main")
					local particles = hit:FindFirstChild("ParticleHolder")
					if isSpark and particles then
						parent.Parent = VFX_PARTS
						for _, particle in pairs(particles:GetChildren()) do
							if particle.Name == "Spawn" then continue end
							particle.Enabled = true
						end
						task.defer(function()
							local started = tick()
							local lastTran = parent.Main.X.Transparency
							while true do
								if not (parent and parent.Parent and parent:FindFirstChild("Main")) then return end
								local passed = tick() - started
								local tran = math.clamp(passed / 0.1, 0, 1)
								if parent.Main.X.Transparency == lastTran then
									parent.Main.X.Transparency = tran
									lastTran = tran
								end
								if passed >= 0.2 then break end
								task.wait(0.05)
							end
							for _, particle in pairs(particles:GetChildren()) do
								particle.Enabled = false
							end
							task.wait(1)
							if not (parent and parent.Parent) then return end
							parent:Destroy()
						end)
						task.wait(0.2)
					end
					local curSpark = object:FindFirstChild("TreeX")
					local direction = (object:GetAttribute("XDirection") or math.random(1, 2) * 2 - 3)
					local rotPivot = (object:GetAttribute("Rot") or pivot)
					object:SetAttribute("XDirection", direction)
					if (not isZero) and not curSpark then
						if curSpark then
							curSpark:Destroy()
						end
						local firstPos = object:GetAttribute("FirstPos")
						local sparkPos = (firstPos or position)
						object:SetAttribute("FirstPos", sparkPos)
						local didSpark = false
						for i = -10, 10, 1 do
							if not firstPos then
								rotPivot = CFrame.new(rotPivot.Position, Vector3.new(position.X, rotPivot.Position.Y, position.Z)) * CFrame.Angles(0, math.pi / 2, 0)
							end
							local offsetPos = rotPivot:PointToObjectSpace(sparkPos)
							rotPivot *= (firstPos and CFrame.Angles(0, math.rad(math.random(200, 500) / 10) * (direction * (math.random(1, 20) == 1 and -1 or 1)), 0) or CFrame.new())
							object:SetAttribute("Rot", rotPivot)
							local newOffset = rotPivot * CFrame.new(offsetPos) * CFrame.new(0, math.random(i, 10) / 12, 5)
							local origin = newOffset.Position
							local target = Vector3.new(rotPivot.Position.X, origin.Y, rotPivot.Position.Z)
							local hit, hitPos, hitNor = RaycastUtil:Raycast(origin, target - origin, "Whitelist", {object:FindFirstChild("Bark"), object:FindFirstChild("Main")})
							if not (hit and offsetPos.Y > 0) then continue end
							didSpark = true
							local spark = ModUtil:SafeClone(Environment.TreeX)
							spark:SetPrimaryPartCFrame(CFrame.new(hitPos, hitPos + hitNor))
							spark.Main.X.Transparency = 1
							spark.Main.ParticleHolder.Spawn.Enabled = true
							task.defer(function()
								local started = tick()
								local lastTran = spark.Main.X.Transparency
								while true do
									if not (spark and spark.Parent and spark:FindFirstChild("Main") and spark.Main.X.Transparency == lastTran) then return end
									local tran = 1 - math.clamp((tick() - started) / 0.1, 0, 1)
									spark.Main.X.Transparency = tran
									lastTran = tran
									if tran <= 0 then break end
									Run.Stepped:Wait()
								end
								task.wait(0.1)
								if not (spark and spark.Parent) then return end
								spark.Main.ParticleHolder.Spawn.Enabled = false
							end)
							spark.Parent = object
							break
						end
						if not didSpark then
							warn("TREE X CREATION FAILED")
						end
					elseif isZero and curSpark then
						curSpark:Destroy()
					end
				end
				if isZero and object and object.Parent then
					local containerTable = shared.ContainerReferences[object]
					if containerTable then
						shared.ContainerReferences[object] = nil
						containerTable[1]:RemoveFromContainer(containerTable[2], object)
					end
					if typ == "Tree" then
						for _, part in pairs(object:GetChildren()) do
							if not part:IsA("BasePart") then continue end
							part.CanCollide = false
						end
						local objPrim = object.Main
						local treeFallSound = GlobalSounds.Tree.Fall:Clone()
						local treeFallStartSound = GlobalSounds.Tree.FallStart:Clone()
						treeFallSound.Parent = objPrim
						treeFallStartSound.Parent = objPrim
						treeFallStartSound:Play()
						task.delay(3, function()
							if not (treeFallSound and treeFallSound.Parent) then return end
							treeFallSound:Play()
						end)
						object.Parent = VFX_PARTS
						local speed = 0
						local acceleration = 0
						local totalRot = 0
						local origin = object:GetAttribute("Rot")
						local bounces = 0
						local rayStart = (origin * CFrame.new(0, 20, -5)).Position
						local rayHit, rayPos = RaycastUtil:Raycast(rayStart, Vector3.new(0, -50, 0), "Whitelist", workspace.Terrain, false, nil, true)
						local maxRot = math.deg(CFrame.lookAt(origin.Position, rayPos):ToOrientation())
						maxRot = math.rad(90 - maxRot)
						while bounces < 6 do
							local waited = task.wait(1/20)
							if not (object and object.Parent) then return end
							local mult = (1 + bounces)
							acceleration = math.min(acceleration + 0.015 * (mult * 1.25), 4 * mult)
							speed = math.min(speed + acceleration * waited, 5)
							totalRot = math.min(totalRot + math.rad(speed), maxRot)
							object:PivotTo(origin * CFrame.Angles(-totalRot, 0, 0))
							--print(totalRot, maxRot)
							if totalRot >= maxRot then
								bounces += 1
								speed *= -0.4
							end
						end
						task.wait(5)
					end
					ModUtil:SafeDestroy(object)
				end
			end
		end	
	end
	if didFirst then return object, hitLimb, distance, humanoid end
end

local explosionParams = OverlapParams.new()
explosionParams.FilterType = Enum.RaycastFilterType.Exclude
explosionParams.FilterDescendantsInstances = {VFX_PARTS, Drops, Plants}
function DamageModule:ExplosionDamage(position: Vector3, normal: Vector3, objectDamages: any, exploInfo: any, attacker: Player, ignoreParts: any, item: {}|number)
	local expRadius = exploInfo.Radius
	local humMaxDamage = exploInfo.HumanoidMaxDamage
	local dmgPrefix = exploInfo.DamagePrefix
	local humOnly = exploInfo.HumanoidOnly
	local useDistForBenches = exploInfo.DistanceBenchDamage
	local expPos = position + normal * 0.5
	--[[
	local debugPart = Instance.new("Part")
	debugPart.CanCollide = false
	debugPart.Anchored = true
	debugPart.Transparency = 0.75
	debugPart.Color = Color3.new(1, 0, 0)
	debugPart.Material = Enum.Material.SmoothPlastic
	debugPart.Shape = Enum.PartType.Ball
	debugPart.Size = Vector3.new(expRadius, expRadius, expRadius) * 2
	debugPart.Position = expPos
	debugPart.Parent = VFX_PARTS
	Debris:AddItem(debugPart, 1)
	]]
	local hitHums = {}
	local hitBenches = {}
	local parts = workspace:GetPartBoundsInRadius(expPos, expRadius, explosionParams)
	for _, expHit in pairs(parts) do
		if not expHit then continue end
		local expParent = expHit.Parent
		if not expParent then continue end
		if hitIgnoreFilterFunc(expHit) then continue end
		local expObject = expParent
		if expObject:FindFirstChild("Humanoid") or expObject:GetAttribute("Health") then
			expObject = expParent
		else
			expObject = expObject.Parent
			if not (expObject:GetAttribute("Health") or expObject:FindFirstChild("Humanoid")) then continue end
		end
		if ignoreParts then
			local found = false
			for _, ignore in pairs(ignoreParts) do
				if not (ignore and ignore.Parent and ignore:IsDescendantOf(expObject)) then continue end
				found = true
				break
			end
			if found then continue end
		end
		local expHum
		if not (expObject.Name == "BTR") then
			expHum = expObject:FindFirstChild("Humanoid")
		end
		if (not expHum) and (humOnly or hitBenches[expObject]) then continue end
		local hitPos = expHit.Position
		local rayHit, rayPosition, rayNor, rayMat = RaycastUtil:Raycast(expPos, (hitPos - expPos), "Blacklist", {VFX_PARTS, Drops, Plants}, false, hitIgnoreFilterFunc, true)
		if not (rayHit and rayHit:IsDescendantOf(expObject)) then continue end
		local rayPos = rayHit.CFrame:PointToObjectSpace(rayPosition)
		local dist = (rayPosition - expPos).Magnitude
		local hitInfo = {
			Hit = rayHit;
			Position = rayPos;
			Normal = rayNor;
			Material = rayMat;
			Distance = dist;
		}
		if expHum then
			local hitHum = hitHums[expHum]
			if (not hitHum) or dist < hitHum.Distance then
				hitHums[expHum] = hitInfo
			end
		else
			hitBenches[expObject] = hitInfo
		end
	end
	local humDamages = {
		Head = humMaxDamage;
		Chest = humMaxDamage;
		Arms = humMaxDamage;
		Legs = humMaxDamage;
	}
	local benchDamages = {}
	for index, value in pairs(objectDamages ~= nil and objectDamages.Benches or {}) do
		if dmgPrefix == "" or index:sub(1, dmgPrefix:len()) == dmgPrefix then
			benchDamages[index:sub(dmgPrefix:len() + 1)] = value
			--[[elseif not benchDamages[index] then
				benchDamages[index] = value]]
		end
	end
	--print(benchDamages)
	local damagedHum = false
	for i, tbl in pairs({hitHums, hitBenches}) do
		--print((i == 1 and "doing hum dmgs" or "doing bench dmgs"), tbl)
		for index, hitInfo in pairs(tbl) do
			local hitPos = hitInfo.Position
			local hitNor = hitInfo.Normal
			local hitMat = hitInfo.Material
			local hitHum = (index:IsA("Humanoid") and index)
			if hitHum then
				damagedHum = true
				for _, plr in pairs(Players:GetPlayers()) do
					ModUtil:FireClient(VFXRemotes, AllRemotes.Visualize, plr, "HitVFX", hitInfo.Hit, CFrame.new(hitPos), hitNor, hitMat)
				end
			end
			local object = (hitHum and hitHum.Parent or index)
			local hitDropoff = ((hitHum or useDistForBenches) and {Start = 0, End = exploInfo.Radius} or {Start = 1000, End = 1000})
			local hitDamages = (hitHum and humDamages or benchDamages)
			--print("EXPLOSION HIT", object, hitInfo, benchDamages)
			DamageModule:Damage(hitInfo.Hit, hitPos, hitNor, CFrame.new(expPos), hitDamages, hitDropoff, nil, item, attacker, exploInfo.SoftSideMult, "Explosive", true, nil, true)
		end
	end
	return damagedHum
end

function DamageModule:DestroyBench(benchModel, ignore, orderedBaseParts, damageBased, pos, doSleeper)
	local bench = shared.Benches[benchModel]
	local breakLootTable, spawnGroup
	if bench then
		breakLootTable = bench.BreakLootTable
		spawnGroup = bench.SpawnGroup
		local sleeperInfo = bench.SleeperInfo
		if sleeperInfo and doSleeper then
			local userId = sleeperInfo[1]
			local displayName = "[ERR]"
			local nameTag = benchModel:FindFirstChild("NameTag")
			if nameTag then
				displayName = nameTag.Label.Text
			end
			shared.CreateDeathBag(benchModel, userId, displayName, bench.Container)
		end
		bench:Delete(pos or Vector3.new())
	end
	local base = benchModel:FindFirstAncestor("Base")
	local startingBaseParts = orderedBaseParts
	local startingStep
	if base and ((not ignore) or startingBaseParts) then
		if not startingBaseParts then
			startingBaseParts = self:GetBasePartOrders(base)
		end
		--print(orderedBaseParts, benchModel)
		for index, baseParts in pairs(startingBaseParts) do
			if not table.find(baseParts, benchModel) then continue end
			startingStep = index
			break
		end
	end
	local benchName = benchModel.Name
	local benchInfo = BenchInfo[benchName]
	local blockOffset = (benchInfo and benchInfo.WallBlockOffset)
	local createdWallBlock = false
	if blockOffset and base and damageBased and benchModel.PrimaryPart then
		local baseCabinet = RaycastUtil:GetBaseCabinetUnder(benchModel.PrimaryPart.Position, true)
		if baseCabinet then
			createdWallBlock = true
			shared.ReplicateGibs(benchModel)
			local wallBlock = ModUtil:SafeClone(Benches["Wall Block"])
			wallBlock.PrimaryPart = wallBlock:FindFirstChild("Main")
			wallBlock:SetPrimaryPartCFrame(benchModel.PrimaryPart.CFrame * blockOffset)
			for _, child in pairs(benchModel:GetChildren()) do
				if child == benchModel.PrimaryPart then
					for _, connection in pairs(child:GetChildren()) do
						local name = connection.Name
						if not (name:sub(1, 10) == "Connection" and connection:IsA("ObjectValue")) then continue end
						local connectionIndex = tonumber(name:sub(11))
						if connectionIndex and connectionIndex <= 2 then
							connection.Parent = wallBlock.PrimaryPart
						elseif connectionIndex == 4 then
							connection.Name = "Connection3"
							connection.Parent = wallBlock.PrimaryPart
						else
							local connectionTo = connection.Value
							local skipDestroy = false
							if connectionTo and connectionTo.Parent then
								local connectionPrim = connectionTo.PrimaryPart
								if connectionPrim then
									for _, con in pairs(connectionPrim:GetChildren()) do
										if not (con.Name:sub(1, 10) == "Connection" and con:IsA("ObjectValue") and con.Value == benchModel) then continue end
										if name == "Connection" and con.Name ~= "Connection" then
											skipDestroy = true
											break
										end
										con:Destroy()
									end
								end
							end
							if skipDestroy then
								connection.Parent = wallBlock.PrimaryPart
								continue
							end
							connection:Destroy()
						end
					end
				end
				if not (child and child.Parent and child:IsA("BasePart") or child:IsA("Folder") or child:IsA("Model")) then continue end
				ModUtil:SafeDestroy(child)
			end
			for _, child in pairs(wallBlock:GetChildren()) do
				child.Parent = benchModel
			end
			benchModel.Name = "Wall Block"
			benchModel.PrimaryPart = benchModel:FindFirstChild("Main")
			benchModel:SetAttribute("Health", 50)
			benchModel:SetAttribute("MaxHealth", 50)
			benchModel:SetAttribute("DamageType", "Wood")
			benchModel:SetAttribute("Placed", 0)
			benchModel:SetAttribute("FirstAction", nil)
			benchModel:SetAttribute("TotalActions", 0)
			local wallBlocks = base:FindFirstChild("Wall Block")
			if not wallBlocks then
				wallBlocks = Instance.new("Folder")
				wallBlocks.Name = "Wall Block"
				wallBlocks.Parent = base
			end
			benchModel.Parent = wallBlocks
			wallBlock:Destroy()
			task.delay(60, function()
				if not (benchModel and benchModel.Parent) then return end
				self:DestroyBench(benchModel)
			end)
		end
	end
	if not createdWallBlock then
		local benchUpdates = self:DisconnectBench(benchModel)
		if benchModel:IsDescendantOf(Bases.Loners) then
			--print("deleting connected benches")
			for _, connected in pairs(benchUpdates) do
				if not (connected and connected.Parent) then continue end
				self:DestroyBench(connected, false, nil, false, nil)
			end
		end
		--print("DELETING BENCH", bench)
		if breakLootTable and benchModel.PrimaryPart then
			print(breakLootTable)
			local primPos = benchModel.PrimaryPart.Position
			local itemDrops = breakLootTable:Roll(ServerService:GetAttribute("GatherMult"), ServerService:GetAttribute("LuckMult"), true)
			for _, itemDrop in pairs(itemDrops) do
				InventoryService.DropItem:Invoke(CFrame.new(primPos + Vector3.new(math.random(-10, 10) / 10, math.random(0, 5) / 10, math.random(-10, 10) / 10)), itemDrop, itemDrop.Amount, nil, true)
			end
			if spawnGroup then
				PopulateEvent:Fire(spawnGroup, benchModel)
			end
		end
		local oldParent = benchModel.Parent
		ModUtil:SafeDestroy(benchModel)
		if oldParent and oldParent.Parent and #oldParent:GetChildren() <= 0 then
			if base and #base:GetChildren() <= 1 then
				ModUtil:SafeDestroy(base)
			else
				ModUtil:SafeDestroy(oldParent)
			end
		end
	end
	--[[if #benchUpdates > 0 then
		ModUtil:FireAllClients(BuildRemotes, AllRemotes.Place, "UpdateSnaps", benchUpdates, #benchUpdates)
	end]]
	if ignore or (orderedBaseParts and startingStep) then
		return startingStep
	end
	if not (base and base.Parent) then return end
	self:CheckBaseStability(base, nil, startingStep, startingBaseParts)
	if base and base.Parent then
		self:UpdateBaseFolder(base)
	end
	BuildService:SetAttribute("FoundationCheckAmount", 2)
end

function DamageModule:DisconnectBench(bench)
	local benchUpdates = {}
	local prim = bench.PrimaryPart
	if prim then
		for _, connectionVal in pairs(prim:GetChildren()) do
			if not connectionVal:IsA("ObjectValue") then continue end
			local connection = connectionVal.Value
			if not (connection and connection.Parent) then continue end
			local conPrim = connection.PrimaryPart
			if not conPrim then continue end
			if connectionVal:GetAttribute("From") then
				table.insert(benchUpdates, connection)
			end
			for _, child in pairs(conPrim:GetChildren()) do
				if not (child:IsA("ObjectValue") and child.Value == bench) then continue end
				child:Destroy()
			end
		end
	end
	return benchUpdates
end

function DamageModule:RepairBench(hit, player)
	if not hit:IsDescendantOf(Bases) then return end
	local user = shared.Users[player]
	local object = hit.Parent
	local health = object:GetAttribute("Health")
	local maxHealth = object:GetAttribute("MaxHealth")
	if not (health and maxHealth) then
		object = object.Parent
		health = object:GetAttribute("Health")
		maxHealth = object:GetAttribute("MaxHealth")
	end
	if not (health and maxHealth) then return end
	--print("should repair", object)
	local name = object.Name
	local damageType = object:GetAttribute("DamageType")
	local stability = object:GetAttribute("Stability")
	local lastDamaged = object:GetAttribute("LastDamaged")
	local benchId = object:GetAttribute("ID")
	if tick() - (lastDamaged or 0) < 60 then return end
	local upgradeAmount = 0.1
	if user then
		local inventory = user.Inventory
		local recipe = RecipeModule:FetchRecipe((stability and (damageType or "Twig") or "Build"), (benchId or name))
		if not recipe then return end
		local costs, actualUpgradeAmount = RecipeModule:GetCostDifferences(recipe, health / maxHealth, upgradeAmount, 0.5, true, {6, 68})
		upgradeAmount = actualUpgradeAmount
		for _, cost in pairs(costs) do
			local hasCosts, costFound = inventory:FindItem(math.ceil(cost.Amount), {"Inventory", "Toolbar"}, {cost.ID})
			if not hasCosts then return end
			cost.CostFound = costFound
		end
		local updates = {}
		for _, cost in pairs(costs) do
			for _, update in pairs(inventory:RemoveFoundItems(cost.CostFound, math.ceil(cost.Amount))) do
				table.insert(updates, update)
			end
		end
		inventory:UpdateClient(unpack(updates))
	end
	object:SetAttribute("Health", math.min(health + maxHealth * upgradeAmount, maxHealth))
end

function DamageModule:CalculateStability(bench, orderedBaseParts)
	local prim = bench.PrimaryPart
	if not prim then return end
	local benchName = bench.Name
	local benchInfo = BenchInfo[benchName]
	local stabilityInfo = benchInfo.StabilityInfo
	local isBasePart = Benches:FindFirstChild(benchName)
	isBasePart = (isBasePart:IsA("Model"))
	local stability = 1
	local extraStabilityLoss = 0
	--print("checking stability for", bench)
	if stabilityInfo then
		repeat
			local lossPerHeight = stabilityInfo.LossPerHeight
			local foundationFromVal = prim:FindFirstChild("Connection4")
			if not (lossPerHeight and foundationFromVal) then continue end
			local foundationFrom = foundationFromVal.Value
			if not (foundationFrom and foundationFrom.Parent) then continue end
			local fromPrim = foundationFrom.PrimaryPart
			if not fromPrim then continue end
			local diffY = math.max(prim.Position.Y - fromPrim.Position.Y, 0)
			extraStabilityLoss = math.clamp((diffY - lossPerHeight.Start) * (lossPerHeight.PerStud / 100) + 0.001, 0, 1)
		until true
		stability = 0
		for i, check in pairs(stabilityInfo.Checks) do
			local stabilityLosses = check.StabilityLoss
			local connections = {}
			for index, attachmentIndex in pairs(check.Connections) do
				local val = prim:FindFirstChild("Connection"..attachmentIndex)
				if not val then continue end
				local connection = val.Value
				if not (connection and connection.Parent) then continue end
				local benchNames = check.BenchNames
				if benchNames and not table.find(benchNames, connection.Name) then continue end
				table.insert(connections, connection)
			end
			--print(i, #connections, connections)
			if #connections <= 0 then continue end
			local totalStability = 0
			local totalConnections = 0
			for _, connection in pairs(connections) do
				local stab = connection:GetAttribute("Stability")
				local stabLoss = connection:GetAttribute("StabilityLoss")
				if not (stab and stabLoss) then continue end
				totalConnections += 1
				totalStability += (stab - stabLoss)
			end
			--print(totalStability, totalConnections)
			if totalConnections <= 0 then continue end
			local averageStability = totalStability / totalConnections
			local lostStability = stabilityLosses[math.min(totalConnections, #stabilityLosses)] / 100
			--print(averageStability, lostStability)
			stability = math.clamp(averageStability - lostStability, 0, 1)
			break
		end
	elseif not isBasePart then
		stability = 0
		for _, val in pairs(prim:GetChildren()) do
			if not (val.Name == "Connection" and val:IsA("ObjectValue")) then continue end
			local connection = val.Value
			if not (connection and connection.Parent) then continue end
			stability = 1
			break
		end
	end
	if isBasePart then
		bench:SetAttribute("Stability", stability)
		bench:SetAttribute("StabilityLoss", extraStabilityLoss)
	end
	local actualStability = stability - extraStabilityLoss
	--print(bench, "FINAL STABILITY:", math.ceil(actualStability * 100))
	if actualStability <= 0 then
		task.wait(1/10)
		return self:DestroyBench(bench, true, orderedBaseParts)
	end
end

function DamageModule:CheckBaseStability(base, startBench, startingStep, orderedBaseParts, started, count)
	if base.Name == "Loners" then return end
	local showPath = BuildService:GetAttribute("DebugShowStabilityPath")
	started = (started or tick())
	count = (count or 0)
	if not orderedBaseParts then
		orderedBaseParts = self:GetBasePartOrders(base)
	end
	--print(orderedBaseParts)
	local lowestIndex = math.huge
	for index, baseParts in pairs(orderedBaseParts) do
		if table.find(baseParts, startBench) and not startingStep then 
			startingStep = index
		end
		if not (startingStep and index >= startingStep) then continue end
		--print("starting", index)
		for _, basePart in pairs(baseParts) do
			if not (basePart and basePart.Parent) then continue end
			if showPath then
				if not basePart:GetAttribute("OrigTrans") then
					basePart:SetAttribute("OrigTrans", basePart.PrimaryPart.Transparency)
				end
				basePart.PrimaryPart.Transparency = 0.5
			end
			count += 1
			local partIndex = self:CalculateStability(basePart, orderedBaseParts)
			--print(index, partIndex)
			lowestIndex = math.min(lowestIndex, (partIndex or math.huge))
			if count % 75 ~= 0 then continue end
			task.wait()
			if not (showPath and basePart and basePart.Parent and basePart.PrimaryPart) then continue end
			basePart.PrimaryPart.Transparency = basePart:GetAttribute("OrigTrans")
		end
	end
	if lowestIndex ~= math.huge then
		return self:CheckBaseStability(base, nil, lowestIndex, orderedBaseParts, started, count)
	end
	--print("DONE CHECKING STABILITY - BASE PARTS CHECKED:", count, "TIME ELAPSED:", tick() - started)
	ModUtil:FireAllClients(BuildRemotes, AllRemotes.Place, "UpdateSnaps")
end

function DamageModule:UpdateBaseFolder(base)
	local started = os.clock()
	local bases = {}
	local allParts = {}
	local nonParents = {}
	local folders = base:GetChildren()
	local count = 0
	local totalAmount = 0
	for _, folder in pairs(folders) do
		if not folder:IsA("Folder") then continue end
		local baseParts = folder:GetChildren()
		local totalParts = #baseParts
		if totalParts <= 0 then
			ModUtil:SafeDestroy(folder)
			continue
		end
		totalAmount += totalParts
		allParts[folder] = {baseParts, totalParts, totalParts, table.clone(baseParts)}
	end
	local counts = {0, totalAmount}
	allParts._ = counts
	local ran = 0
	for folder, t in pairs(allParts) do
		if type(folder) == "string" then continue end
		local allBaseParts = t[4]
		for _, bench in pairs(allBaseParts) do
			ran += 1
			if ran % 200 == 0 then task.wait() end
			if not (bench and bench.Parent and bench:IsA("Model")) then continue end
			local connections, newCount = self:GetAllConnected(bench, allParts, nonParents, base, count)
			--print(connections, newCount)
			if type(connections) == "table" then
				table.insert(bases, connections)
				count = math.max(newCount, count)
			end
			if t[3] <= 0 then break end
		end
		if counts[1] >= totalAmount then break end
	end
	if #bases == 1 and #nonParents > 0 then
		--print("adding all non-connected parts to", base)
		self:ReparentParts(nonParents, base)
	elseif #bases >= 2 then
		--print("splitting base folder", #bases)
		local didOrig = false
		for _, baseParts in pairs(bases) do
			local baseFolder = ((baseParts[1] and baseParts[1]:IsDescendantOf(base)) and base)
			if baseFolder and baseFolder.Parent and not didOrig then
				didOrig = true
				--print("adding to existing folder")
			else
				--print("creating new base folder")
				baseFolder = Instance.new("Folder")
				baseFolder.Name = "Base"
				baseFolder.Parent = Bases
			end
			self:ReparentParts(baseParts, baseFolder)
			--task.wait()
		end
	end
	--print("DONE CHECKING BASE PART FOLDERS (", #bases, #nonParents, ") IN "..os.clock() - started)
	if base and base.Parent and #base:GetChildren() > 0 then return end
	ModUtil:SafeDestroy(base)
end

function DamageModule:GetAllConnected(bench, allParts, nonParent, base, count)
	count = (count or 0) + 1
	--print(count)
	--print(bench, allParts, nonParent, base, count)
	if count % 75 == 0 then task.wait() end
	local ignore = allParts[bench.Parent]
	if not ignore then return end
	local baseParts = ignore[1]
	local foundIndex = table.find(baseParts, bench)
	if not foundIndex then return end
	local totalParts = ignore[2]
	local counts = allParts._
	table.remove(baseParts, foundIndex)
	ignore[3] -= 1
	counts[1] += 1
	if base and base.Parent and not bench:IsDescendantOf(base) then
		table.insert(nonParent, bench)
	end
	local found = {bench}
	if counts[1] < counts[2] then
		for _, conVal in pairs(bench.PrimaryPart:GetChildren()) do
			local name = conVal.Name
			if not (name:sub(1, 10) == "Connection" and conVal:IsA("ObjectValue")) then continue end
			local connection = conVal.Value
			if not (connection and connection.Parent) then continue end
			local connections, newCount = self:GetAllConnected(connection, allParts, nonParent, base, count)
			if not connections then continue end
			count = math.max(newCount, count)
			for _, con in pairs(connections) do
				if not (con and con.Parent) then continue end
				table.insert(found, con)
			end
		end
	--[[else
		print("REACHED MAX OF", counts[1], ", STOPPING RECURSION")]]
	end
	return found, count
end

function DamageModule:ReparentParts(baseParts, base)
	local count = 0
	for _, bench in pairs(baseParts) do
		if not (bench and bench.Parent) then continue end
		local benchFolder = base:FindFirstChild(bench.Name)
		if not benchFolder then
			benchFolder = Instance.new("Folder")
			benchFolder.Name = bench.Name
			benchFolder.Parent = base
		end
		local oldParent = bench.Parent
		bench.Parent = benchFolder
		if #oldParent:GetChildren() <= 0 then
			if #oldParent.Parent:GetChildren() <= 1 then
				ModUtil:SafeDestroy(oldParent.Parent)
			else
				ModUtil:SafeDestroy(oldParent)
			end
		end
		count += 1
		--if count % 100 == 0 then task.wait() end
	end
	local foundations = base:FindFirstChild("Foundation")
	local triangleFoundations = base:FindFirstChild("Triangle Foundation")
	if not ((foundations and #foundations:GetChildren() > 0) or (triangleFoundations and #triangleFoundations:GetChildren() > 0)) then
		self:SlowDestroy(base)
	end
end

function DamageModule:SlowDestroy(base)
	if not (base and base.Parent) then return end
	local count = 0
	for _, folder in pairs(base:GetChildren()) do
		for _, bench in pairs(folder:GetChildren()) do
			if not (bench and bench.Parent) then continue end
			ModUtil:SafeDestroy(bench)
			count += 1
			if count % 10 == 0 then task.wait() end
		end
		if not (folder and folder.Parent) then continue end
		ModUtil:SafeDestroy(folder)
	end
	if not (base and base.Parent) then return end
	ModUtil:SafeDestroy(base)
end

function DamageModule:GetBasePartOrders(base)
	if base.Name == "Loners" then return end
	local currentParts = {}
	local allParts = {}
	local stepBaseParts = {}
	local foundations = base:FindFirstChild("Foundation")
	local triFoundations = base:FindFirstChild("Triangle Foundation")
	for _, folder in pairs({foundations, triFoundations}) do
		if not (folder and typeof(folder) == "Instance") then continue end
		for _, basePart in pairs(folder:GetChildren()) do
			table.insert(currentParts, basePart)
			allParts[basePart] = true
		end
	end
	local steps = 0
	local totalParts = 0
	local started = tick()
	while #currentParts > 0 do
		steps += 1
		local nextParts = {}
		for _, basePart in pairs(currentParts) do
			if not (basePart and basePart.Parent and basePart:IsA("Model")) then continue end
			local prim = basePart.PrimaryPart
			if not prim then continue end
			local partName = basePart.Name
			local benchInfo = BenchInfo[partName]
			if not benchInfo then continue end
			local nextCons = (benchInfo.NextConnections or {})
			totalParts += 1
			--print("lol", basePart)
			for _, connection in pairs(prim:GetChildren()) do
				local conName = connection.Name
				--print(connection)
				if conName:sub(1, 10) ~= "Connection" then continue end
				local nextPart = connection.Value
				if not (nextPart and nextPart.Parent) then
					connection:Destroy()
					continue
				end
				--print(nextPart, allParts[nextPart])
				if allParts[nextPart] then continue end
				local num = tonumber(conName:sub(11))
				--print(num, table.find(nextCons, num))
				if num == nil or table.find(nextCons, num) then
					table.insert(nextParts, nextPart)
					allParts[nextPart] = true
				end
			end
			if totalParts % 120 ~= 0 then continue end
			task.wait()
		end
		--print(steps, currentParts, nextParts)
		stepBaseParts[steps] = currentParts
		currentParts = nextParts
	end
	--print("DONE CHECKING ALL BASE PARTS FOR", base, "TOTAL STEPS:", steps, "TOTAL BASE PARTS:", totalParts, "TIME ELAPSED:", tick() - started)
	return stepBaseParts
end

function DamageModule:UpdateBaseCost(base, updateTime)
	if not (base and base.Parent and base.Name ~= "Loners") then return end
	local baseCabinets = base:FindFirstChild("Base Cabinet")
	if not baseCabinets then return end
	local baseCabinet = baseCabinets:FindFirstChild("Base Cabinet")
	if not baseCabinet then return end
	local bench = shared.Benches[baseCabinet]
	if not bench then return end
	bench:UpdateUpkeepCost()
	if not updateTime then return end
	bench:UpdateUpkeepTime()
end

function DamageModule:GetLastPlayerDamage()
	return lastPlayerDamage
end

return DamageModule