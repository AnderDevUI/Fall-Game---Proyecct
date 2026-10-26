-- [PATH] ServerScriptService / ServerService / MilitaryService @Type Script
--[[
	Military Service
	by neddleduck
	July 12th, 2023
	
	Handles the managing of military ai and military ai events. 
	
	NPCs created under the military class are stored here like:
	shared.npcs = {}
	
	--temp code
	local isWithin, distSquared = NumberUtil:IsWithin(aiPos, playerPos, distance)
	if isWithin then
	local dist = math.sqrt(distSquared)
end
]]
--Services
local STORAGE = game:GetService("ServerStorage")
local REPLICATED = game:GetService("ReplicatedStorage")
local PLAYERS = game:GetService("Players")

--Constants
local MILITARY_FOLDER = workspace:WaitForChild("Military")
local BINDABLE_SPAWNMILITARY = script:WaitForChild("SpawnMilitary")
local BINDABLE_DAMAGEMILITARY = script:WaitForChild("DamageMilitary")
local BINDABLE_SPAWNMILITARYGROUP = script:WaitForChild("SpawnMilitaryGroup")

--Modules
local MODULES = STORAGE:WaitForChild("Modules")
local SHARED_MODULES = REPLICATED:WaitForChild("Modules")
local MODERATION = require(MODULES:WaitForChild("ModUtil"))
local MILITARY_CLASS = require(MODULES:WaitForChild("MilitaryClass"))
local NUMBER_UTIL = require(SHARED_MODULES:WaitForChild("NumberUtil"))

--Settings
local ROAMER_CAPACITY = 10;
local TARGET_RANGE = 250;
local LOOP_CD_UNACTIVE = 3;
local LOOP_CD_ACTIVE = 1;
local TARGET_UPDATE_DELAY = 3
local PRESET_RESPAWN_TIME = (16 * 60) --first number in minutes it takes to respawn AI 
local PRESET_SPAWNER_PLAYER_DISTANCE = 1200 --If any player is in this radius from a monument preset spawn location, the AI will not respawn there
local AVAILABLE_GUNS = {"Salvaged AK74u", "Military M4A1"} -- Table of the available guns the military can spawn with

--Variables
local currentWideSearchCount = 0

local monumentLastPresetSpawns = {
	--[MonumentName] = tick()
}

for _, monumentSpawnFolder in pairs(MILITARY_FOLDER:GetChildren()) do
	if not monumentSpawnFolder:FindFirstChild("PresetSpawns") then continue end
	monumentLastPresetSpawns[monumentSpawnFolder.Name] = 0
end

shared.npcs = {
	--[[
	[aiModel] = {
			MilitaryClass = militaryClass;
			Monument = monumentName;
		}
	[aiModel] = {
			MilitaryClass = militaryClass;
			Monument = monumentName;
		}
	etc..
	]]
}

function SpawnNPC(weaponName, spawnFolder, monumentName) --Function for creating a new npc object and spawning an NPC in a spawnFolder
	local npc, model = MILITARY_CLASS.new(weaponName, spawnFolder, monumentName)
	shared.npcs[model] = {MilitaryClass = npc, Monument = monumentName}
end

--Events
BINDABLE_SPAWNMILITARY.Event:Connect(function(weaponName : string, monumentName : string) 
	local monumentFold = MILITARY_FOLDER[monumentName]
	local spawnFolderParent = weaponName == "Bruno's M4A1" and monumentFold.BrunoSpawns or monumentFold
	local spawnFolder = spawnFolderParent:GetChildren()[math.random(1, #spawnFolderParent:GetChildren())]
	SpawnNPC(weaponName, spawnFolder, monumentName)
end)

BINDABLE_SPAWNMILITARYGROUP.Event:Connect(function(monumentName : string)
	print("SPAWNING GROUP " .. monumentName)
	local monumentFolder = MILITARY_FOLDER[monumentName]
	--Delete any old AI
	for _, ai in pairs(monumentFolder:GetChildren()) do
		local aiReference = shared.npcs[ai]
		if aiReference then
			local militaryClass = aiReference.MilitaryClass
			if militaryClass and militaryClass.Model and militaryClass.Model.Name ~= "Bruno" then
				militaryClass.State = "delete"
			end
		end
		if ai:IsA("Model") and ai.Name ~= "Bruno" then
			ai:Destroy()
		end
	end
	--Spawn new AI here
	for _, presetSpawn in pairs(monumentFolder.PresetSpawns:GetChildren()) do
		if not presetSpawn:IsA("Folder") then continue end
		local gunToUse = AVAILABLE_GUNS[math.random(1, #AVAILABLE_GUNS)]
		SpawnNPC(gunToUse, presetSpawn, monumentName)
		task.wait(math.random(0.1, 1.5))
	end
end)

BINDABLE_DAMAGEMILITARY.Event:Connect(function(aiModel : Model, targetPlayer : Player, damageDealt : number) --This event just adds or updates if the target already exists the damage dealt to the target
	local target = targetPlayer.Character
	if not aiModel or not target or not target.Head then return end
	local militaryClass = shared.npcs[aiModel].MilitaryClass
	if militaryClass.Targets[target] then
		militaryClass.Targets[target][2] = militaryClass.Targets[target][2] + damageDealt
	else
		militaryClass.Targets[target] = {target.Head, damageDealt, false}
	end
end)

--[[ shit ass loop bruh
while true do --Server lifetime loop for military service
	--Preset AI Respawner
		
	for monumentName, lastPresetSpawnTick in pairs(monumentLastPresetSpawns) do
		--print(lastPresetSpawnTick)
		--yeprint(PRESET_RESPAWN_TIME)
		if tick() - lastPresetSpawnTick >= PRESET_RESPAWN_TIME then
			monumentLastPresetSpawns[monumentName] = tick()
			--Check for people in radius
			local inRadius = false
			for _, player in pairs(PLAYERS:GetChildren()) do
				if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then continue end --if char or root part doesn't exist or hum dead skip
				if not MILITARY_FOLDER[monumentName]:FindFirstChild("Radius") then print("NO RADIUS") continue end --if there is no radius part, skip (no spawning ai there)
				local monumentRadiusPart = MILITARY_FOLDER[monumentName].Radius
				--If people are in radius, set the last preset spawn to wait another 20 secs for this monument to check again
				if NUMBER_UTIL:IsWithin(monumentRadiusPart.Position, player.Character.HumanoidRootPart.Position, PRESET_SPAWNER_PLAYER_DISTANCE) then
					inRadius = true
					break
				end
			end
			if inRadius then
				print("SETTING 20 SECS AHEAD")
				monumentLastPresetSpawns[monumentName] = tick() + 20 -- Set the tick to be 20 seconds ahead to check 20 seconds later, people are here right now
			else
				--Nobody was in the radius, delete the old ai first, then respawn the AI on the parts
				for index, npc in pairs(shared.npcs) do --Delete Old
					if npc.Monument ~= monumentName then continue end
					local militaryClass = npc.MilitaryClass
					if militaryClass.Model and militaryClass.Model.Name == "Bruno" then continue end
					militaryClass.State = "delete"
					shared.npcs[index] = nil
				end
				--Spawn new
				for _, presetSpawn in pairs(MILITARY_FOLDER[monumentName].PresetSpawns:GetChildren()) do
					if not presetSpawn:IsA("Folder") then continue end
					local gunToUse = AVAILABLE_GUNS[math.random(1, #AVAILABLE_GUNS)]
					SpawnNPC(gunToUse, presetSpawn, monumentName)
					task.wait(math.random(0.1, 1.5))
				end
			end
		end
	end
	
	task.wait(2)
end]]