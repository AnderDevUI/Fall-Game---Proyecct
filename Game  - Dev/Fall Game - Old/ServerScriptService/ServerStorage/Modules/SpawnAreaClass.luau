-- [PATH] ServerStorage / Modules / SpawnAreaClass @Type ModuleScript
--[[
	SpawnAreaClass
	by ChickenBagelz
	January 29, 2023
]]


-- Services
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")
local Http = game:GetService("HttpService")

-- Dependencies
local SpawnAreaService = ServerScripts:WaitForChild("SpawnAreaService")
local ServerService = ServerScripts:WaitForChild("ServerService")

-- Folders
local Benches = Replicated:WaitForChild("Benches")
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local Environment = Storage:WaitForChild("Environment")
local Scripts = Storage:WaitForChild("Scripts")
local SpawnAreas = workspace:WaitForChild("SpawnAreas")
local Drops = workspace:WaitForChild("Drops")
local VFXParts = workspace:WaitForChild("VFX")
local Nodes = workspace:WaitForChild("Nodes")
local Trees = workspace:WaitForChild("Trees")
local Vegetation = workspace:WaitForChild("Vegetation")
local Plants = workspace:WaitForChild("Plants")
local Bases = workspace:WaitForChild("Bases")

-- Objects
local Terrain = workspace:WaitForChild("Terrain")

-- Remotes
local LoadingScreenRemote = Replicated:WaitForChild("LoadingScreen")

-- Modules
local SpawnAreaModule = require(ServerModules:WaitForChild("SpawnAreaModule"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local ServerModule = require(ServerModules:WaitForChild("ServerModule"))
local ItemClass = require(SharedModules:WaitForChild("ItemClass"))

-- Global Variables
shared.ContainerReferences = {}

-- Local Variables
local placementDefaultFilterFunc = RaycastUtil:FilterFunction("PlacementDefault")
local buildingPrivFilterFunc = RaycastUtil:FilterFunction("BuildingPrivCheck")

local SpawnAreaClass = {}
SpawnAreaClass.__index = SpawnAreaClass

local fails = 0

function SpawnAreaClass:SpawnObjects(limits, first, data, saveablesOnly)
	local spawns = self.Spawns
	local rng = self.RNG
	local spawnName = spawns.Name
	local spawnInfo = SpawnAreaModule:GetSpawnInfo(spawnName)
	local started = os.clock()
	local lastFired = tick()
	local totalObjectsNeeded = 0
	local needed = {}
	local homesNeeded = 0
	for _, t in pairs(spawnInfo.Counts) do
		if (saveablesOnly == true and t.Saveable ~= true) or (saveablesOnly == false and t.Saveable == true) then continue end
		local countType = (t.Subtype or t.Type)
		local container = self:GetContainer(countType)
		local savedPositions = (data and data[countType])
		--print(data, savedPositions, countType)
		if savedPositions then
			local spawnedAmount = 0
			for i, encodedPos in pairs(savedPositions) do
				local x, z = unpack(string.split(encodedPos, "/"))
				local start = Vector3.new(ServerModule:DecodeNumber(x), 1000, ServerModule:DecodeNumber(z))
				local hit, pos, nor, mat = RaycastUtil:Raycast(start, Vector3.new(0, -2000, 0), "Whitelist", {Terrain})
				if not hit then continue end
				self:SpawnObject(pos, nor, t, encodedPos)
				spawnedAmount += 1
				if spawnedAmount >= t.Count then break end
				if spawnedAmount % 300 == 0 then task.wait() end
			end
		end
		local objects = container.Instances
		local objectsNeeded = math.min(t.Count - #objects, (limits ~= nil and limits[t.Type] or math.huge))
		--print(t, objectsNeeded)
		if objectsNeeded <= 0 then continue end
		table.insert(needed, {objectsNeeded, t, container})
		homesNeeded += #container.Homes
		totalObjectsNeeded += objectsNeeded
	end
	if first then
		local loadingType = spawnName:gsub("Spawns", ""):gsub("_", " ")
		loadingType = loadingType..(loadingType:sub(loadingType:len()) ~= "s" and "s" or "")
		SpawnAreaService:SetAttribute("LoadingType", loadingType)
		SpawnAreaService:SetAttribute("LoadingTotal", totalObjectsNeeded)
	end
	local totalSpawned = 0
	local filters = {Drops, VFXParts}
	for _, spawnFolder in pairs(SpawnAreas:GetChildren()) do
		if spawns ~= spawnFolder and (spawnFolder.Name:find("Forest") or spawnFolder.Name:find("Plain")) then continue end
		table.insert(filters, spawnFolder)
	end
	while not shared.SetModelCollision do task.wait() end
	local attemptSpawn = function(need, index, pos, nor, mat, isHome)
		local t = need[2]
		local hitAngle = math.deg(math.acos(nor.Y))
		if hitAngle > (t.MaxAngle or 60) then return end
		if (t.Blacklist and t.Blacklist[mat.Name]) or (t.Whitelist and not t.Whitelist[mat.Name]) then return end 
		fails = 0
		--[[local isNode = t.Type:find("Node")
		local isTree = t.Type:find("Tree")]]
		if (t.Blacklist and t.CantSpawnUnderBase ~= false) or t.CantSpawnUnderBase then
			local privCheckPos = Vector3.new(pos.X, 225.6, pos.Z)
			if t.Saveable then
				local baseCabinet = RaycastUtil:GetBaseCabinetUnder(privCheckPos, true)
				if baseCabinet and baseCabinet:GetAttribute("Monument") then return end
			else
				local privHit = RaycastUtil:Raycast(privCheckPos, Vector3.new(0, -0.2, 0), "Blacklist", {VFXParts}, false, buildingPrivFilterFunc)
				if privHit then return end
			end
		end
		totalSpawned += 1
		need[1] -= 1
		if need[1] <= 0 then
			table.remove(needed, index)
		end
		SpawnAreaService:SetAttribute("LoadingAmount", totalSpawned)
		if tick() - lastFired >= 0.5 and first then
			lastFired = tick()
			LoadingScreenRemote:FireAllClients("Update", SpawnAreaService:GetAttribute("LoadingType"), SpawnAreaService:GetAttribute("LoadingAmount"), SpawnAreaService:GetAttribute("LoadingTotal"))
		end
		return self:SpawnObject(pos, nor, t)
	end
	while totalSpawned < totalObjectsNeeded do
		if ModUtil:IsShuttingDown() then return end
		fails += 1
		if fails >= 100 then fails = 0 task.wait() end
		local doSkip = false
		if not first then
			local randomOffset
			for index, need in pairs(needed) do
				local container = need[3]
				local homes = container.Homes
				if #homes <= 0 then continue end
				need[4] = (need[4] or 0) + 1
				if need[4] <= 100 then
					doSkip = true
					local homePos = homes[1]
					local r = (need[2].Type == "DigPiles" and 50 or 300) * math.sqrt(rng:NextNumber(0, 1))
					--print("doing home spawn", #homes, need[4])
					local theta = rng:NextNumber(0, 1) * 2 * math.pi
					local x = homePos.X + r * math.cos(theta)
					local y = homePos.Z + r * math.sin(theta)
					local start = Vector3.new(x, self.AverageHeight + 150, y)
					local hit, pos, nor, mat = RaycastUtil:Raycast(start, Vector3.new(0, -2000, 0), "Blacklist", filters, false, placementDefaultFilterFunc)
					if hit ~= Terrain then continue end
					local object = attemptSpawn(need, index, pos, nor, mat)
					if not object then continue end
					container.ConnectedHomes[object] = homePos
				else
					warn(`HOME LOCATION FOR {need[2].Subtype or need[2].Type} OBSTRUCTED, GENERATING NEW HOME`)
				end
				need[4] = 0
				table.remove(homes, 1)
			end
		end
		if not doSkip then
			local start = self:GetRandomPoint() + Vector3.new(0, 150, 0)
			local hit, pos, nor, mat = RaycastUtil:Raycast(start, Vector3.new(0, -2000, 0), "Blacklist", filters, false, placementDefaultFilterFunc)
			if hit ~= Terrain then continue end
			for index, need in pairs(needed) do
				local object = attemptSpawn(need, index, pos, nor, mat)
				if object then break end
			end
		end
		if totalSpawned % (first and 150 or 10) ~= 0 then continue end
		task.wait()
	end
	if totalObjectsNeeded <= 0 then return end
	print(spawnName:upper()..": DONE SPAWNING", totalObjectsNeeded, " OBJECTS IN THE SPAN OF", os.clock() - started, "SECONDS", saveablesOnly)
end

function SpawnAreaClass:SpawnObject(pos, nor, t)
	local rng = self.RNG
	local object, maxHealth
	local isPile = (t.Type == "DigPiles")
	local isGift = (t.Type:find("Gift"))
	local isEgg = (t.Type:find("Egg"))
	if t.Type:find("Node") then
		object = ModUtil:SafeClone(Environment.Node)
		local nodeDetail = ModUtil:SafeClone(Environment[t.Type].Size4)
		nodeDetail:SetPrimaryPartCFrame(object.PrimaryPart.CFrame)
		nodeDetail.PrimaryPart:Destroy()
		for _, part in pairs(nodeDetail:GetChildren()) do
			part.Parent = object
		end
		nodeDetail:Destroy()
		maxHealth = 1
		object:SetAttribute("State", 4)
		object.Name = t.Type
		object.Parent = Nodes
		shared.SetModelCollision(object, "Nodes", true)
	elseif t.Type:find("Tree") then
		local allTrees = Environment.Trees[t.Type]:GetChildren()
		object = ModUtil:SafeClone(allTrees[rng:NextInteger(1, #allTrees)])
		object.Parent = Trees
		nor = Vector3.new(0, 1, 0)
		maxHealth = 1
	elseif t.Type == "Plants" then
		object = ModUtil:SafeClone(Environment.Plants[t.Subtype].Level1)
		object.Name = t.Subtype
		object.Parent = Plants
		local itemInfo = Instance.new("StringValue")
		itemInfo.Name = "Item"
		itemInfo.Value = Http:JSONEncode(ItemClass.new(24, math.ceil(10 * ServerService:GetAttribute("GatherMult"))))
		itemInfo.Parent = object
	elseif isPile then
		local digPiles = Environment.DigPiles:GetChildren()
		object = ModUtil:SafeClone(digPiles[math.random(1, #digPiles)])
		object.Name = "DigPile"
		object.Parent = Vegetation
	elseif isGift or isEgg then
		local benches = Bases.Loners:FindFirstChild(t.Type)
		if not benches then
			benches = Instance.new("Folder")
			benches.Name = t.Type
			benches.Parent = Bases.Loners
		end
		local benchModel, bench = shared.CreateBench(Benches[t.Type].Default, t.Type, nil, benches, 0, 0, nil, nil, nil, nil, nil, self)
		object = benchModel
	elseif t.Subtype then
		local allObjects = Environment[t.Type][t.Subtype]:GetChildren()
		object = ModUtil:SafeClone(allObjects[rng:NextInteger(1, #allObjects)])
		object.Parent = Vegetation
		if t.Subtype == "Cactus" or t.Subtype == "Log" then
			maxHealth = 1
		end
	end
	if maxHealth then
		object:SetAttribute("MaxHealth", maxHealth)
		object:SetAttribute("Health", maxHealth)
	end
	if isPile then
		local chosenPos = pos
		local chosenNor = nor
		for i = 1, 25 do
			local newHit, newPos, newNor, newMat = RaycastUtil:Raycast(pos + Vector3.new(rng:NextInteger(7, 20) * (rng:NextInteger(1, 2) * 2 - 3), 10, rng:NextInteger(5, 15) * (rng:NextInteger(1, 2) * 2 - 3)), Vector3.new(0, -20, 0), "Include", Terrain)
			if not (newHit and newMat ~= Enum.Material.Asphalt and newMat ~= Enum.Material.Water) then 
				if i == 25 then print("couldn't find dig spot, defaulting to first") end 
				continue 
			end
			chosenPos = newPos
			chosenNor = newNor
			break
		end
		local cf = CFrame.new(chosenPos, chosenPos + chosenNor) * CFrame.Angles(math.rad(-90), rng:NextNumber(0, math.pi * 2), 0) * CFrame.new(0, 0.3, 0)
		object:PivotTo(cf)
		local region = Region3.new(cf.Position + Vector3.new(-10, -8, -10), cf.Position + Vector3.new(10, 4, 10)):ExpandToGrid(4)
		local materials, occupancies = Terrain:ReadVoxels(region, 4)
		Terrain:ReplaceMaterial(region, 4, Enum.Material.Grass, Enum.Material.CrackedLava)
		local benchNames = table.create((math.random(1, 5) == 1 and 2 or 3), "Trash Can")
		if math.random(1, 5) <= 4 then
			benchNames[math.random(1, #benchNames)] = (math.random(1, 10) <= 3 and "Food Crate" or "Oil Barrel")
		end
		if math.random(1, 8) <= 3 then
			benchNames[benchNames[1] ~= "Trash Can" and 2 or 1] = (math.random(1, 3) == 1 and "Locked Wooden Crate" or "Wooden Crate")
		end 
		while not shared.CreateBench do task.wait() end
		local digPiles = shared.DigPiles
		if not digPiles then
			digPiles = {}
			shared.DigPiles = digPiles
		end
		local benchTable = {{region, materials, occupancies}}
		for index, benchName in pairs(benchNames) do
			local benchCF = object["Pos"..index].CFrame
			local benches = Bases.Loners:FindFirstChild(benchName)
			if not benches then
				benches = Instance.new("Folder")
				benches.Name = benchName
				benches.Parent = Bases.Loners
			end
			local benchModel, bench = shared.CreateBench(Benches[benchName].Default, benchName, benchCF, benches, 0, 0, nil, nil, nil, nil, object, self)
			benchModel.PrimaryPart = nil
			local maxHealth = benchModel:GetAttribute("MaxHealth")
			if maxHealth then
				benchModel:SetAttribute("DesiredHealth", maxHealth)
				benchModel:SetAttribute("MaxHealth", 0)
				benchModel:SetAttribute("Health", 0)
			end
			table.insert(benchTable, bench)
		end
		local test = shared.NAMES
		if not test then
			test = {}
			shared.NAMES = test
		end
		table.sort(benchNames)
		local TEST = table.concat(benchNames, "/")
		test[TEST] = (test[TEST] or 0) + 1
		digPiles[object] = benchTable
	else
		local cf = CFrame.new(pos, pos + nor) * CFrame.Angles(math.rad(-90), rng:NextNumber(0, math.pi * 2), 0)
		object.PrimaryPart = object.PosPart
		object:SetPrimaryPartCFrame(cf)
		object.PosPart:Destroy()
		object.PrimaryPart = nil
		object.WorldPivot = cf
	end
	self:AddToContainer((t.Subtype or t.Type), object, pos)
	local damageParts = object:FindFirstChild("DamageParts")
	if damageParts then
		local damageHandler = Scripts.DamageHandler:Clone()
		damageHandler.Parent = damageParts
		damageHandler.Enabled = true
	end
	if t.Type == "Plants" or isGift or isEgg then
		object.PrimaryPart = object.Main
	end
	return object
	--object.PrimaryPart = (object:FindFirstChild("Main") or object:FindFirstChild("Bark") or object:FindFirstChildWhichIsA("BasePart"))
end

function SpawnAreaClass.new(spawns, rng)
	local self = setmetatable({}, SpawnAreaClass)
	self.Spawns = spawns
	self.TotalArea = 0
	self.AreaParts = {}
	self.RNG = rng
	self.AverageHeight = spawns.Spawn1.Position.Y

	local name = spawns.Name
	local info = SpawnAreaModule:GetSpawnInfo(name)
	if not info then
		warn(spawns, "is missing a specified table in ServerStorage.Modules.SpawnAreaModule")
		return
	end
	
	self:CalculateTotalArea()
	
	local containers = {}
	for _, count in pairs(info.Counts) do
		containers[count.Subtype or count.Type] = {
			Instances = {};
			Positions = {};
			Homes = {};
			ConnectedHomes = {};
			Saveable = count.Saveable;
		}
	end
	self.Containers = containers

	return self
end

function SpawnAreaClass:GetRandomPoint()
	local rng = self.RNG
	local totalArea = math.floor(self.TotalArea * 10)
	local n = rng:NextInteger(1, totalArea)
	local current = 0
	for _, areaInfo in pairs(self.AreaParts) do
		local areaPart, area = unpack(areaInfo)
		current += area * 10
		if current < n then continue end
		local cf = areaPart.CFrame
		local size = areaPart.Size
		return (cf * (self:IsCircle(areaPart) and CFrame.Angles(0, rng:NextNumber(0, math.pi * 2), 0) * CFrame.new(0, 0, rng:NextNumber(-size.X, size.X) / 2) or CFrame.new(rng:NextNumber(-size.X, size.X) / 2, 0, rng:NextNumber(-size.Z, size.Z) / 2))).Position
	end
end

function SpawnAreaClass:CalculateTotalArea()
	local spawns = self.Spawns
	local areaParts = {}
	local parts = spawns:GetChildren()
	for index = 1, #parts do
		local part = spawns["Spawn"..index]
		local area = self:GetArea(part)
		self.TotalArea += area
		table.insert(areaParts, {part, area})
	end
	self.AreaParts = areaParts
	--print(self.AreaParts)
end

function SpawnAreaClass:GetArea(part)
	local size = part.Size
	return (self:IsCircle(part) and math.pi * (size.X / 2) ^ 2 or size.X * size.Z)
end

function SpawnAreaClass:IsCircle(part)
	return part:FindFirstChild("Circle") ~= nil
end

function SpawnAreaClass:AddToContainer(containerName, obj, pos, encodedPos)
	local container = self:GetContainer(containerName)
	if not container then return end
	local instances = container.Instances
	table.insert(instances, obj)
	local positions = container.Positions
	table.insert(positions, (encodedPos or ServerModule:EncodeNumber(pos.X).."/"..ServerModule:EncodeNumber(pos.Z)))
	shared.ContainerReferences[obj] = {self, containerName}
end

function SpawnAreaClass:RemoveFromContainer(containerName, obj)
	local container = self:GetContainer(containerName)
	if not container then return end
	local instances = container.Instances
	local positions = container.Positions
	local foundIndex = table.find(instances, obj)
	if not foundIndex then return end
	table.remove(instances, foundIndex)
	table.remove(positions, foundIndex)
	if not (containerName == "DigPiles" or containerName:find("Plant") or containerName:find("Node") or containerName:find("_Trees", 1, true)) then return end
	local homePos = container.ConnectedHomes[obj]
	if homePos then
		container.ConnectedHomes[obj] = nil
	elseif obj.PrimaryPart then
		homePos = obj.PrimaryPart.Position
	else
		homePos = obj:GetPivot().Position
	end
	if not homePos then return end
	table.insert(container.Homes, homePos)
end

function SpawnAreaClass:GetContainer(containerName)
	local containers = self.Containers
	return containers[containerName]
end

function SpawnAreaClass:GetData()
	local containers = self.Containers
	local data = {}
	for spawnType, container in pairs(containers) do
		if not container.Saveable then continue end
		local positions = container.Positions
		data[spawnType] = positions
	end
	return data
end

return SpawnAreaClass