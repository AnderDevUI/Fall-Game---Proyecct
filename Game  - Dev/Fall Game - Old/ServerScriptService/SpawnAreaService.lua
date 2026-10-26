-- [PATH] ServerScriptService / ServerService / SpawnAreaService @Type Script
--[[
	SpawnAreaService
	by ChickenBagelz
	January 29, 2023
	
	Handles the spawning of nodes, trees, and other randomly-generated structures
]]


-- Services
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local SpawnAreas = workspace:WaitForChild("SpawnAreas")
local Values = Replicated:WaitForChild("Values")

-- Modules
local _SpawnAreaModule = ServerModules:WaitForChild("SpawnAreaModule")
if not script:GetAttribute("SpawnsEnabled") then
	_SpawnAreaModule:SetAttribute("GameSpawnMult", 0)
	_SpawnAreaModule:SetAttribute("StudioSpawnMult", 0)
	warn("[WARNING] SPAWNAREACLASS IS CURRENTLY DISABLED")
end
local SpawnAreaModule = require(_SpawnAreaModule)
SpawnAreaModule:Initialize()
local SpawnAreaClass = require(ServerModules:WaitForChild("SpawnAreaClass"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))

-- Remotes
local LoadingScreenRemote = Replicated:WaitForChild("LoadingScreen")

-- Local Variables
local spawnAreas = {}
shared.SpawnAreas = spawnAreas

while task.wait() do
	if ModUtil:IsShuttingDown() then return end
	if not ServerService:GetAttribute("BasesLoaded") or not shared.CreateBench then continue end
	local spawnAreaDatas = shared.SpawnAreaDatas
	if spawnAreaDatas then
		shared.SpawnAreaDatas = nil
		local rng = Random.new(0)
		local orderedSpawnAreas = {}
		for _, spawnInfo in pairs(SpawnAreaModule:FetchSpawnInfos()) do
			if ModUtil:IsShuttingDown() then return end
			local name, info = unpack(spawnInfo)
			--local spawnAreaData = (spawnAreaDatas[name:gsub("Spawns", "")] or {})
			local spawns = SpawnAreas:FindFirstChild(name)
			if not spawns then continue end
			for index, spawnPart in pairs(spawns:GetChildren()) do
				spawnPart.Transparency = 1
				spawnPart.Position += Vector3.new(0, 100, 0)
				spawnPart.Name = "Spawn"..index
			end
			local spawnArea = SpawnAreaClass.new(spawns, rng)
			spawnAreas[spawns] = spawnArea
			--print(spawnAreaData)
			spawnArea:SpawnObjects(nil, true, nil, true)
			table.insert(orderedSpawnAreas, spawnArea)
		end
		for _, spawnArea in pairs(orderedSpawnAreas) do
			spawnArea:SpawnObjects(nil, true, nil, false) -- third argument = spawn area data
			print(spawnArea)
		end
		script:SetAttribute("SpawnAreasLoaded", true)
		break
	end
end

repeat
	task.wait()
until ServerService:GetAttribute("AllServicesLoaded") and ServerService:GetAttribute("BasesLoaded")
script:SetAttribute("LoadingFinished", tick())
Values.Loading.Value = false
task.defer(function()
	for i = 1, 10 do
		LoadingScreenRemote:FireAllClients("Toggle", false)
		task.wait(3)
	end
end)

local SpawnParts = workspace:FindFirstChild("SpawnParts")
local overlap = OverlapParams.new()
overlap.FilterType = Enum.RaycastFilterType.Include
overlap.FilterDescendantsInstances = {workspace.Vegetation}
if SpawnParts then
	for _, spawnPart in pairs(SpawnParts:GetChildren()) do
		local parts = workspace:GetPartsInPart(spawnPart, overlap)
		for _, part in pairs(parts) do
			if part.Name ~= "BoulderPart" or not part.Parent or not part.Parent:IsA("Model") then continue end
			print("DELETING BOULDER - OBSTRUCTING SPAWN PART")
			part.Parent:Destroy()
		end
	end
end
for _, v in pairs(workspace.Vegetation:GetChildren()) do
	if not v.Name:find("Boulder") then continue end
	local overlap = OverlapParams.new()
	overlap.FilterType = Enum.RaycastFilterType.Exclude
	overlap.FilterDescendantsInstances = {v}
	for _, c in pairs(v:GetChildren()) do
		if not c:IsA("MeshPart") then continue end
		for _, part in pairs(workspace:GetPartsInPart(c, overlap)) do
			if part.Transparency >= 1 and not part.CanCollide then continue end
			print("DESTROYED OBSTRUCTED ROCK")
			v:Destroy()
			break
		end
		if not v.Parent then break end
	end
end

local lastSpawns = tick()
while task.wait(1) do
	if not script:GetAttribute("SpawnsEnabled") or tick() - lastSpawns < script:GetAttribute("ResourceRefreshRate") then continue end
	lastSpawns = tick()
	for spawns, spawnArea in pairs(spawnAreas) do
		spawnArea:SpawnObjects(nil)
		task.wait(script:GetAttribute("SpawnAreaWaitTime"))
	end
end