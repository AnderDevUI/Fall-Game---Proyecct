-- [PATH] ServerStorage / Modules / ServerTypePresets @Type ModuleScript
--[[
	ServerTypePresets
	by ChickenBagelz
	September 25, 2023
	
	Holds functions corresponding to different ServerTypes. These will run on server bootup and can be used to set attributes of scripts and stuff
]]


-- Services
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

-- Folders
local Values = Replicated:WaitForChild("Values")
local ServerModules = Storage:WaitForChild("Modules")
local CombatEssentials = Storage:WaitForChild("CombatServerEssentials")
local MonumentBlock = workspace:WaitForChild("MonumentBuildBlock")

-- Modules
local CombatArenaClass = require(ServerModules:WaitForChild("CombatArenaClass"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))


local ServerTypePresets = {
	TeamCombat = function()
		ServerScripts.ServerService:SetAttribute("DurabilityDecreaseMult", 0)
		ServerScripts.ServerService:SetAttribute("MaxStackMult", 10)
		ServerScripts.ServerService:SetAttribute("SleepersEnabled", false)
		ServerScripts.UserService:SetAttribute("DeathBagsEnabled", false)
		ServerScripts.UserService:SetAttribute("DropToolsOnDeath", false)
		ServerScripts.WeatherService:SetAttribute("Speed", 0)
		ServerScripts.BenchService:SetAttribute("DisableSpawns", true)
		Values.CraftingEnabled.Value = false
		Values.MapEnabled.Value = false
		Lighting.ClockTime = 13
		ServerScripts.ServerService:SetAttribute("SavingEnabled", false)
		ServerScripts.StatsService:SetAttribute("RadiationEnabled", false)
		ServerScripts.EventService:SetAttribute("EventsEnabled", false)
		
		ServerScripts.UserService:SetAttribute("SpawnRangeThreshold", 4)
		Storage.CombatArenaStuff.CombatWalls.Parent = workspace
		Storage.CombatArenaStuff.TeamSpawns.Parent = workspace
		workspace.SpawnParts:Destroy()
		Storage.CombatArenaStuff.SpawnParts.Parent = workspace
	end;
	Combat = function()
		ServerScripts.ServerService:SetAttribute("DurabilityDecreaseMult", 0)
		ServerScripts.ServerService:SetAttribute("MaxStackMult", 10)
		ServerScripts.ServerService:SetAttribute("SleepersEnabled", false)
		ServerScripts.UserService:SetAttribute("DeathBagsEnabled", false)
		ServerScripts.UserService:SetAttribute("DropToolsOnDeath", false)
		ServerScripts.WeatherService:SetAttribute("Speed", 0)
		ServerScripts.BenchService:SetAttribute("DisableSpawns", true)
		Values.CraftingEnabled.Value = false
		Values.MapEnabled.Value = false
		Lighting.ClockTime = 13
		ServerScripts.ServerService:SetAttribute("SavingEnabled", false)
		ServerScripts.StatsService:SetAttribute("RadiationEnabled", false)
		ServerScripts.EventService:SetAttribute("EventsEnabled", false)

		ServerScripts.UserService:SetAttribute("SpawnRangeThreshold", 4)
		ServerScripts.UserService:SetAttribute("SpawnPartCooldown", nil)
		Values.TeamSize.Value = 0
		ServerScripts.UserService:SetAttribute("PersistentRagdolls", false)
		ServerScripts.InventoryService:SetAttribute("ItemDropEnabled", false)
		ServerScripts.ServerService:SetAttribute("PlayerDowningEnabled", false)
		Values.InstantRespawn.Value = true
		ServerScripts.BuildService:SetAttribute("DecayDamageMult", 0)
		ServerScripts.SpawnAreaService:SetAttribute("SpawnsEnabled", false)
		MonumentBlock:WaitForChild("Base"):WaitForChild("Base Cabinet"):ClearAllChildren()
		ServerScripts.CombatService:SetAttribute("WeaponBenchDamageMult", 4)
		
		local CombatServerRemote = Instance.new("RemoteEvent")
		CombatServerRemote.Name = "CombatServerRemote"
		CombatServerRemote.Parent = Replicated
		
		CombatServerRemote.OnServerEvent:Connect(function(player, remoteType, ...)
			local user = shared.Users[player]
			if not user then return end
			local humanoid = user.Humanoid
			if not (humanoid and humanoid.Parent and humanoid.Health > 0) then return end
			local clock = os.clock()
			local args = {remoteType, ...}
			if remoteType == "EnterPass" then
				if clock - (user.LastPassEnter or 0) < 1.8 then return end
				user.LastPassEnter = clock
				local password = ...
				if type(password) ~= "string" or password:len() <= 0 or password:len() > 20 then
					return ModUtil:BanPlayer(player.Name, "001", nil, CombatServerRemote, args)
				end
				local combatArena = user:IsInCombatArena()
				if not combatArena or user.AttemptingPassword == nil then return end
				if combatArena.Password == password then
					--print("CORRECT PASSWORD")
					user.AttemptingPassword = true
				else
					--print("INCORRECT PASSWORD")
					CombatServerRemote:FireClient(player, "ChangeTextPrivate", "INCORRECT PASSWORD. PLEASE TRY AGAIN:")
				end
			elseif remoteType == "CancelPass" then
				if not user:IsInCombatArena() or user.AttemptingPassword == nil then return end
				user.AttemptingPassword = nil
			elseif remoteType == "UpdateSettings" or remoteType == "ClearWalls" or remoteType == "FetchPlayerList" or remoteType == "ShuffleTeams" then
				if remoteType ~= "FetchPlayerList" and clock - (user.LastPassEnter or 0) < 1.8 then return end
				user.LastPassEnter = clock
				local combatArena = user:IsInCombatArena(true)
				if not combatArena or combatArena.Owner ~= player then return end
				if remoteType == "UpdateSettings" then
					local newSettings, setPass = ...
					if type(newSettings) ~= "table" or #newSettings ~= 6 or type(newSettings[4]) ~= "boolean" or type(newSettings[5]) ~= "boolean" or type(newSettings[6]) ~= "boolean" or 
						(setPass ~= nil and (type(setPass) ~= "string" or setPass:len() < 0 or setPass:len() > 20)) then
						return ModUtil:BanPlayer(player.Name, "001", nil, CombatServerRemote, args)
					end
					for i = 1, 3 do
						local index = newSettings[i]
						if type(index) ~= "number" or index <= (i == 3 and -1 or 0) or index % 1 ~= 0 or 
							(i <= 2 and index > #shared[`{i == 1 and "Weapon" or "Armor"}Kits`]) or 
							(i > 2 and index > 10) then
							return ModUtil:BanPlayer(player.Name, "001", nil, CombatServerRemote, args)
						end
					end
					local newPassword
					if combatArena.Public == true and newSettings[4] == false then -- If arena was originally public and is attempted to be set to private, gotta make sure we have password arg
						if not setPass or setPass:len() <= 0 then return end
						newPassword = setPass
					end
					print("applied new settings", newSettings, newPassword)
					combatArena:ApplySettings(newSettings, newPassword)
					CombatServerRemote:FireClient(player, "UpdateSettings", newSettings)
				elseif remoteType == "ClearWalls" then
					combatArena:ClearPlaceables()
				elseif remoteType == "ShuffleTeams" then
					combatArena:ShuffleTeams()
				else
					combatArena:UpdatePlayerList()
				end
			elseif remoteType == "ForceStart" then
				shared.ChatFunction(nil, player, {"/forcestart", "COMMAND"})
			elseif remoteType == "PlayerList" then
				if clock - (user.LastPassEnter or 0) < 1.8 then return end
				user.LastPassEnter = clock
				local plr, action = ...
				if typeof(plr) ~= "Instance" or not plr:IsA("Player") then return end
				local usr = shared.Users[plr]
				if not usr then return end
				local combatArena = user:IsInCombatArena(true)
				local isSwap = (action == "Swap")
				if not combatArena or (isSwap and combatArena:HasStarted()) or combatArena.Owner ~= player or usr:IsInCombatArena(true) ~= combatArena then return end
				if not isSwap and plr == player then return end
				if action == "Kick" or isSwap then
					local oldTeam = plr.Team
					local newTeam = ((oldTeam and oldTeam.Name == "Attackers") and "Blue" or "Red")
					if isSwap and #combatArena[`Players{newTeam}`] >= 10 then return end
					usr:LeaveCombatArena(false, isSwap)
					if isSwap then
						usr:JoinCombatArena(combatArena, newTeam)
					end
					local hum = usr.Humanoid
					if hum and hum.Parent and hum.Health > 0 then
						hum.Health = 0
					end
				end
			end
		end)
		
		CombatEssentials.Lobby.Parent = workspace
		workspace:WaitForChild("SpawnParts"):Destroy()
		CombatEssentials.SpawnParts.Parent = workspace
		local Arenas = Instance.new("Folder")
		Arenas.Name = "Arenas"
		Arenas.Parent = workspace
		local joiners = CombatEssentials.ArenaJoin
		joiners.Parent = workspace
		shared.CombatArenas = {}
		local nameIndexes = {}
		for arenaIndex = 1, #joiners:GetChildren() do
			local joiner = joiners:FindFirstChild(`Lobby{arenaIndex}`)
			if not joiner then continue end
			local arenaType = ((arenaIndex <= 2 or arenaIndex == 13 or arenaIndex == 19) and "Large" or ((arenaIndex <= 12 or arenaIndex >= 17) and "Small"))
			local arenaCF, arenaNameExtra
			local isVIP = (arenaIndex >= 14)
			local isAuto = (arenaIndex >= 12 and arenaIndex <= 13)
			if not arenaType then -- Is terrain arena
				local terrainIndex = arenaIndex - 13
				arenaType = `Terrain{terrainIndex}`
				arenaNameExtra = `#{terrainIndex} `
				--print(arenaIndex, "TERRAIN", arenaType, terrainIndex)
			else -- Is arena in the sky
				local isSmall = (arenaType == "Small")
				local nameIndex = (nameIndexes[arenaType] or 0) + 1
				nameIndexes[arenaType] = nameIndex
				arenaCF = (isSmall and CFrame.new(0, 225, -3200 + (nameIndex - 1) * 750) or CFrame.new(-3490, 225, -3000 + (nameIndex - 1) * 1500))
				arenaNameExtra = `#{isAuto and 1 or nameIndex} `
				--print(arenaIndex, "FLAT", arenaType, nameIndex)
			end
			arenaNameExtra ..= (isAuto and "Public " or "Custom ")
			shared.CombatArenas[arenaIndex] = CombatArenaClass.new(arenaIndex, arenaType, joiner, arenaCF, arenaNameExtra, isVIP, isAuto)
		end
	end;
	GunGame = function()
		ServerScripts.ServerService:SetAttribute("DurabilityDecreaseMult", 0)
		ServerScripts.ServerService:SetAttribute("MaxStackMult", 10)
		ServerScripts.ServerService:SetAttribute("SleepersEnabled", false)
		ServerScripts.UserService:SetAttribute("DeathBagsEnabled", false)
		ServerScripts.UserService:SetAttribute("DropToolsOnDeath", false)
		ServerScripts.WeatherService:SetAttribute("Speed", 0)
		ServerScripts.BenchService:SetAttribute("DisableSpawns", true)
		Values.CraftingEnabled.Value = false
		Values.MapEnabled.Value = false
		Lighting.ClockTime = 13
		ServerScripts.ServerService:SetAttribute("SavingEnabled", false)
		ServerScripts.StatsService:SetAttribute("RadiationEnabled", false)
		ServerScripts.EventService:SetAttribute("EventsEnabled", false)
		
		Values.TeamSize.Value = 0
		ServerScripts.UserService:SetAttribute("SpawnPartCooldown", nil)
		ServerScripts.UserService:SetAttribute("PersistentRagdolls", false)
		ServerScripts.InventoryService:SetAttribute("ItemDropEnabled", false)
		ServerScripts.CombatService:SetAttribute("WeaponHumanoidDamageMult", 0)
		ServerScripts.ServerService:SetAttribute("PlayerDowningEnabled", false)
		Values.InstantRespawn.Value = true
		Storage.CombatArenaStuff.CombatWalls.Parent = workspace
		local newSpawns = Storage.CombatArenaStuff.AllSpawns
		newSpawns.Parent = workspace
		workspace.SpawnParts:Destroy()
		newSpawns.Name = "SpawnParts"
		--workspace.BASEPLATE:Destroy()
		
		shared.GunGameWeapons = {
			[1] = {
				Weapon = 11, -- Salvaged P250
				Armor = 5
			};
			[2] = {
				Weapon = 38, -- Salvaged Skorpion
				Armor = 5
			};
			[3] = {
				Weapon = 17, -- Salvaged Python
				Armor = 5
			};
			[4] = {
				Weapon = 34, -- AA12 (Buckshot)
				Armor = 5
			};
			[5] = {
				Weapon = 32, -- Pump Action (Buckshot)
				Armor = 5
			};
			[6] = {
				Weapon = 9, -- Break Action (Buckshot + Slugs)
				Armor = 6
			};
			[7] = {
				Weapon = 19, -- Salvaged SMG
				Armor = 5
			};
			[8] = {
				Weapon = 21, -- Salvaged M14
				Armor = 5
			};
			[9] = {
				Weapon = 23, -- Salvaged AK74u
				Armor = 5
			};
			[10] = {
				Weapon = 25, -- Salvaged AK47
				Armor = 5
			};
			[11] = {
				Weapon = 36, -- Military M4A1
				Armor = 5
			};
			[12] = {
				Weapon = 44, -- Military PKM
				Armor = 5
			};
			[13] = {
				Weapon = 35, -- AA12 (Slugs)
				Armor = 5
			};
			[14] = {
				Weapon = 33, -- Pump Action (Slugs)
				Armor = 5
			};
			[15] = {
				Weapon = 40, -- Military Barrett
				Armor = 5
			};
			[16] = {
				Weapon = 13, -- Salvaged Pipe Rifle
				Armor = 6
			};
			[17] = {
				Weapon = 4, -- Crossbow
				Armor = 5
			};
			[18] = {
				Weapon = 3, -- Bow
				Armor = 5
			};
			[19] = {
				Weapon = 28, -- Salvaged RPG (Swifts)
				Armor = 5
			};
			[20] = {
				Weapon = 5, -- Nail Gun
				Armor = 5
			};
			[21] = {
				Weapon = 50, -- ez shovel
				Armor = 5
			};
		}
		task.delay(6, function()
			while not shared.ChatFunction do task.wait() end
			while true do
				--print("Gun game starting")
				shared.ChatFunction(nil, "SERVER", {"/reset", "COMMAND"})
				while not shared.GunGameWon do task.wait() end
				--print("Gun game ended")
				task.wait(10)
			end
		end)
	end;
	Custom = function()
		ServerScripts.AnimalService.Enabled = true
		workspace.SpawnParts:Destroy()
		local spawns = Storage.CombatArenaStuff.BaseplateSpawnParts
		spawns.Name = "SpawnParts"
		spawns.Parent = workspace
	end,
	Default = function(serverInfo)
		local info = serverInfo[6] or {}
		--workspace.BASEPLATE:Destroy()
		ServerScripts.AnimalService.Enabled = true
		
		Values.TeamSize.Value = (info.TeamSize or 5)
		ServerScripts.ServerService:SetAttribute("GatherMult", (info.GatherMult or 1))
		ServerScripts.ServerService:SetAttribute("MaxStackMult", (info.MaxStackMult or 1))
		ServerScripts.ServerService:SetAttribute("ShredderSpeedMult", (info.ShredderSpeedMult or 1))
		ServerScripts.ServerService:SetAttribute("SmeltSpeedMult", (info.SmeltSpeedMult or 1))
		Values.CraftSpeedMult.Value = (info.CraftSpeedMult or 1)
		ServerScripts.InventoryService:SetAttribute("DespawnTimeMult", (info.DespawnTimeMult or 1))
		ServerScripts.BuildService:SetAttribute("DecayDamageMult", (info.DecayDamageMult or 1))
		
		--[[ServerScripts.ServerService:SetAttribute("LuckMult", 0.75)
		ServerScripts.ServerService:SetAttribute("MaxStackMult", 3)
		ServerScripts.ServerService:SetAttribute("ShredderSpeedMult", 2)
		ServerScripts.ServerService:SetAttribute("SmeltSpeedMult", 2)
		Values.CraftSpeedMult.Value = 2]]
	end,
}

return ServerTypePresets