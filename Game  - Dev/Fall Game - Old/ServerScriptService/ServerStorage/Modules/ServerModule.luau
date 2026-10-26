-- [PATH] ServerStorage / Modules / ServerModule @Type ModuleScript
--[[
	ServerModule
	by ChickenBagelz
	April 26, 2023
	
	Used for serializing instances such as player bases into saveable data, and loading such data as well
]]


-- Services
local Http = game:GetService("HttpService")
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local DataStore = game:GetService("DataStoreService")
local ServerScripts = game:GetService("ServerScriptService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local MemoryStore = game:GetService("MemoryStoreService")
local Run = game:GetService("RunService")
local Messaging = game:GetService("MessagingService")

-- DataStores
local Servers = DataStore:GetDataStore("Servers_004") -- 13 == RAID SIM, 37 == first 3x wipe, 001 = CURRENT WIPE

-- MemoryStores
local ServerCache = MemoryStore:GetSortedMap("ServerCache")
local ServerIds = MemoryStore:GetSortedMap("ServerIds")

-- Dependencies
local SpawnAreaService = ServerScripts:WaitForChild("SpawnAreaService")
local BuildService = ServerScripts:WaitForChild("BuildService")
local ServerService = ServerScripts:WaitForChild("ServerService")
local WeatherService = ServerScripts:WaitForChild("WeatherService")

-- Folders
local Benches = Replicated:WaitForChild("Benches")
local SharedModules = Replicated:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")
local ServerModules = Storage:WaitForChild("Modules")
local BaseParts = Storage:WaitForChild("BaseParts")
local Bases = workspace:WaitForChild("Bases")

-- Modules
local BasePartInfo = require(SharedModules:WaitForChild("BasePartInfo"))
local BenchInfo = require(SharedModules:WaitForChild("BenchInfo"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local Items = require(SharedModules:WaitForChild("Items"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local DamageModule = require(ServerModules:WaitForChild("DamageModule"))
local Compression = require(ServerModules:WaitForChild("Compression"))
local DataModule = require(ServerModules:WaitForChild("DataModule"))
local Base64 = require(ServerModules:WaitForChild("Base64"))
local UserStatsClass = require(ServerModules:WaitForChild("UserStatsClass"))
local RegionModule = require(ServerModules:WaitForChild("RegionModule"))

-- Remotes
local LoadingScreenRemote = Replicated:WaitForChild("LoadingScreen")
local ChatRemotes = Remotes:WaitForChild(string.char(96, 35, 40, 91, 98, 164, 149, 39, 30, 15, 96, 175, 70, 174, 182, 135, 163, 50, 76, 163, 104, 183, 141, 3, 50, 142, 28, 14, 48, 109))
local AllRemotes = {
	Message = string.char(113, 112, 81, 144, 109, 55, 138, 180, 22, 36, 121, 67, 5, 157, 74, 71, 60, 141, 148, 82, 79, 115, 10, 151, 83, 101, 91, 78, 50, 108);
}

-- Local Variables
local NumberAlphabet = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "$", "&", "(", ")", "+", "?", "!", "@", "#", "^", "*", "|", "~", " ", ";"}


Test = {}

local ServerModule = {}

function ServerModule:EncodeNumber(num)-- :3
	local isFloat = (num % 1 ~= 0)
	if num == 0 then
		return "0"
	elseif isFloat then
		num = math.floor(num / 0.001 + 0.5)
	end
	local result = ""
	local quotient = math.abs(num)
	local remainder = -1
	while quotient ~= 0 do
		local dec = quotient - 1
		remainder = dec % #NumberAlphabet
		quotient = math.floor(dec / #NumberAlphabet)
		result = NumberAlphabet[remainder + 1]..result
	end
	return (result == "-0" and "0" or (isFloat and (num < 0 and "=" or ".") or (num < 0 and "-" or ""))..result)
end

function ServerModule:DecodeNumber(str)
	if str == "0" or str == "-0" then
		return 0
	end
	local first = str:sub(1, 1)
	local isFloat = (first == "=" or first == ".")
	local encodedNum = str:sub((isFloat or first == "-") and 2 or 1)
	local sum = 0
	local index = 0
	for i = encodedNum:len(), 1, -1 do
		local c = encodedNum:sub(i, i)
		sum += table.find(NumberAlphabet, c) * (#NumberAlphabet) ^ index
		index += 1
	end
	local decodedNum = (isFloat and sum * 0.001 or sum)
	return decodedNum * ((first == "=" or first == "-") and -1 or 1)
end

function ServerModule:EncodeIntTable(t)
	local str = ""
	for index, num in pairs(t) do
		local encodedNum = self:EncodeNumber(num or 0)
		str = str..encodedNum..(index == #t and "" or "/")
	end
	return str
end

function ServerModule:DecodeIntTable(str)
	--print(str)
	local encodedIntegers = string.split(str, "/")
	local decodedIntegers = {}
	for index, value in pairs(encodedIntegers) do
		if value == "" then continue end
		table.insert(decodedIntegers, self:DecodeNumber(value))
	end
	return decodedIntegers
end

function ServerModule:EncodeCFrame(cf, rotOnly)
	local components = (rotOnly and {cf:ToEulerAnglesXYZ()} or {cf.X, cf.Y, cf.Z, cf:ToEulerAnglesXYZ()})
	local str = ""
	for index, num in pairs(components) do
		local isRot = (index > (rotOnly and 0 or 3))
		local encodedNum = ((isRot and num >= 3.14) and "p" or ((isRot and num <= -3.14) and "-p" or self:EncodeNumber(num)))
		str = str..encodedNum..(index == #components and "" or "/")
	end
	return str
end

function ServerModule:DecodeCFrame(str, rotOnly)
	local components = string.split(str, "/")
	for index, value in pairs(components) do
		components[index] = (value == "p" and math.pi or (value == "-p" and -math.pi or self:DecodeNumber(value)))
	end
	return (rotOnly and CFrame.Angles(unpack(components)) or  CFrame.new(unpack(components, 1, 3)) * CFrame.Angles(unpack(components, 4, 6)))
end

function ServerModule:EncodeItemData(item)
	local id = item.ID
	local amount, skin, durability, repair, ammo, attachments, owner
	local info = Items[id]
	local maxStack = info.MaxStack
	if item.Amount ~= maxStack then
		amount = item.Amount
	end
	if item.Skin ~= "Default" then
		skin = item.Skin
	end
	if item.Durability > 0 then
		durability = math.ceil(item.Durability)
	end
	if item.Repair > 0 then
		repair = item.Repair
	end
	if item.Ammo then
		ammo = self:EncodeItemData(item.Ammo)
	end
	if item.Attachments then
		local savedAttachments = {}
		for index, attachment in pairs(item.Attachments) do
			savedAttachments[index] = self:EncodeItemData(attachment)
		end
		attachments = savedAttachments
	end
	if item.Owner then
		owner = item.Owner
	end
	local itemData = {
		(amount and self:EncodeNumber(id).."/"..self:EncodeNumber(amount) or id),
	}
	if skin or durability or repair then
		table.insert(itemData, (durability and self:EncodeNumber(durability) or "").."/"..(repair and repair * 10 - 1 or "").."/"..(skin or ""))
	end
	if ammo then
		table.insert(itemData, ammo)
	end
	if attachments then
		table.insert(itemData, attachments)
	end
	if owner then
		table.insert(itemData, self:EncodeNumber(owner))
	end
	--print("encoded item", item, itemData)
	return itemData
end

function ServerModule.DecodeItemData(item)
	local itemCore = item[1]
	local id, amount
	if type(itemCore) == "string" then
		local encodedId, encodedAmount = unpack(string.split(itemCore, "/"))
		id = ServerModule:DecodeNumber(encodedId)
		amount = ServerModule:DecodeNumber(encodedAmount)
	else
		id = itemCore
	end
	local info = Items[id]
	local skin = "Default"
	local durability = 0
	local repair = 0
	for index, itemExtra in pairs(item) do
		if not (index and type(index) == "number" and index % 1 == 0 and index ~= 1) then continue end
		if type(itemExtra) == "string" then
			if itemExtra:find("/") then
				local encodedDur, encodedRepair, encodedSkin = unpack(string.split(itemExtra, "/"))
				durability = (encodedDur == "" and durability or ServerModule:DecodeNumber(encodedDur))
				repair = (encodedRepair == "" and repair or (encodedRepair + 1) / 10)
				skin = (encodedSkin == "" and skin or encodedSkin)
			else
				item.Owner = ServerModule:DecodeNumber(itemExtra)
			end
		elseif type(itemExtra) == "table" then
			local tableType = type(itemExtra[1])
			if tableType == "string" then
				item.Ammo = itemExtra
			else
				item.Attachments = itemExtra
			end
		end
	end
	item.ID = id
	item.Amount = (amount or info.MaxStack)
	item.Durability = durability
	item.Skin = skin
	item.Repair = repair
	for index = 10, 1, -1 do
		item[index] = nil
	end
	--print("decoded item", item)
end

function ServerModule:ConvertBenchToTable(benchModel, fromBench, snapInfo)
	local primPart = benchModel.PrimaryPart
	local benchTable
	if not (primPart and primPart.Parent) then return end
	local primCF = primPart.CFrame
	local fromPrim = (fromBench and fromBench.PrimaryPart)
	local benchName = benchModel.Name
	local benchInfo = BenchInfo[benchName]
	if not benchInfo then return end
	local benchType = benchInfo.Type
	local id = benchModel:GetAttribute("ID")
	local isBasePart = (benchType == "BasePart")
	local damageType = benchModel:GetAttribute("DamageType")
	local benchId = (id or "B"..BasePartInfo:GetIndexFromName(benchName)..((isBasePart and damageType) and "_"..(damageType == "Wood" and 1 or (damageType == "Stone" and 2 or (damageType == "Metal" and 3 or 4))) or ""))
	if benchId == "B" or (type(benchId) == "string" and benchId:sub(benchId:len()) == "_") or (type(id) == "number" and id <= 0) then
		warn("BENCH SERIALIZATION FAILED - INVALID BENCH ID ("..benchName..")")
		return
	end
	local health = benchModel:GetAttribute("Health")
	local maxHealth = benchModel:GetAttribute("MaxHealth")
	local skin = benchModel:GetAttribute("Skin")
	local healthSaved, skinSaved
	if health and maxHealth and health > 0 and maxHealth > 0 and health / maxHealth < 0.98 then
		healthSaved = self:EncodeNumber(math.ceil(health))
	end
	if skin and skin ~= "Default" then
		skinSaved = skin
	end
	local bench = shared.Benches[benchModel]
	local benchSaved
	--print(benchModel, bench)
	if bench then
		local benchData = bench:EncodeBenchData()
		--print(benchData)
		if type(benchData) == "table" or type(benchData) == "string" then
			benchSaved = benchData
		end
	end
	benchTable = {
		benchId,
		(snapInfo or self:EncodeCFrame((fromPrim and fromPrim.CFrame or CFrame.new()):ToObjectSpace(primCF)))
	}
	if healthSaved or skinSaved then
		table.insert(benchTable, (healthSaved or "").."/"..(skinSaved or ""))
	end
	if benchSaved then
		table.insert(benchTable, benchSaved)
	end
	return benchTable, bench
end

function ServerModule:SaveBenchConnections(benchModel, count, snapIndex, ignore, fromBench, fromTable, notDoneCons, totalFailed)
	local dones
	if allDone and benchModel and benchModel.Parent then
		local base = benchModel:FindFirstAncestor("Base")
		if not base then
			base = Bases.Loners
		end
		dones = allDone[base]
		if not dones then
			dones = {}
			allDone[base] = dones
		end
		if dones[benchModel] then 
			return nil, totalFailed, count
		else
			for key, value in pairs(allDone) do
				if key == base or not value[benchModel] then continue end
				return nil, totalFailed, count
			end
		end
	end
	local wasFirst = (notDoneCons == nil)
	ignore = (ignore or {})
	notDoneCons = (notDoneCons or {})
	totalFailed = (totalFailed or 0)
	count = (count or 0) + 1
	--print(benchModel, count, snapIndex, ignore, fromBench, fromTable, notDoneCons, totalFailed)
	local primPart = benchModel.PrimaryPart
	if count % 80 == 0 then task.wait() end
	local snapInfo
	if snapIndex then
		local rotateSaved, faceSaved
		local faceAway = benchModel:GetAttribute("FaceAway")
		local rotateAmount = benchModel:GetAttribute("RotateAmount")
		if rotateAmount and rotateAmount > 0 then
			rotateSaved = rotateAmount
		end
		if faceAway then
			faceSaved = 1
		end
		snapInfo = ((rotateSaved or faceSaved) and snapIndex.."_"..(rotateSaved or 0)..(faceSaved or 0) or snapIndex)
	end
	local benchTable, benchClass = self:ConvertBenchToTable(benchModel, fromBench, snapInfo)
	if benchTable then
		local primCF = primPart.CFrame
		local benchConnections = {}
		local fromPrim = (fromBench and fromBench.PrimaryPart)
		table.insert(ignore, benchModel)
		if notDoneCons[benchModel] then
			notDoneCons[benchModel] = false
		end
		if dones then
			dones[benchModel] = true
		end
		for _, connection in pairs(primPart:GetChildren()) do
			local name = connection.Name
			if not (connection:IsA("ObjectValue") and name:sub(1, 10) == "Connection") then continue end
			local con = connection.Value
			if not (con and con.Parent and con.Name ~= "Wall Block" and not table.find(ignore, con)) then continue end
			local conPrim = con.PrimaryPart
			if not conPrim then continue end
			if not connection:GetAttribute("From") then
				local notDoneTable = notDoneCons[con]
				if notDoneTable == nil or notDoneTable[1] == nil or notDoneTable[2] == nil then
					notDoneCons[con] = {fromBench, fromTable, #benchTable + 1}
				end
				continue
			end
			local attachmentIndex = tonumber(name:sub(11))
			local savedIndex
			if attachmentIndex then
				local snapPoints = BenchInfo[con.Name].SnapPoints
				if snapPoints then
					local closestDist = 0.1
					for index, snapPoint in pairs(snapPoints) do
						if not (table.find(snapPoint.BenchNames, benchModel.Name) and snapPoint.AttachmentIndex == attachmentIndex) then continue end
						local offset = primCF * snapPoint.Offset
						local dist = (offset.Position - conPrim.Position).Magnitude
						if closestDist and dist >= closestDist then continue end
						closestDist = dist
						savedIndex = index
					end
				end
			end
			local conBenchTable, _, newCount = self:SaveBenchConnections(con, count, savedIndex, ignore, benchModel, benchTable, notDoneCons, totalFailed)
			count = math.max(newCount, count)
			if not conBenchTable then continue end
			table.insert(benchConnections, conBenchTable)
		end
		--if #benchConnections > 0 then
		table.insert(benchTable, benchConnections)
		--end
		if wasFirst and notDoneCons then
			print("STARTING NOT CONNECTIONS")
			for conBench, conInfo in pairs(notDoneCons) do
				if not (conInfo and conBench and conBench.Parent) then continue end
				local conFromBench = conInfo[1]
				local conTable = conInfo[2]
				local conIndex = conInfo[3]
				--print("step1", conTable, conIndex)
				if not (conFromBench and conFromBench.Parent and conTable and conTable[conIndex]) then
					totalFailed += 1
					warn("ERROR SAVING NON-CONNECTED BASEPART - NO VALID PREVIOUS BENCH")
					print(conTable)
					continue
				end
				if table.find(ignore, conBench) then continue end
				local connections = conTable[conIndex]
				local conSaveTable, _, newCount = self:SaveBenchConnections(conBench, count, nil, ignore, conFromBench, conTable, nil, totalFailed)
				print(conBench.Name.." BENCH HAD NO EASILY-SAVEABLE CONNECTION OFFSETS, CREATING CUSTOM ONE")
				count = math.max(newCount, count)
				if not conSaveTable then continue end
				if type(connections) ~= "table" then
					connections = conTable[conIndex + 1]
				end 
				--print(conIndex, connections)
				table.insert(connections, conSaveTable)
			end
		end
	end
	return benchTable, totalFailed, count, benchClass
end

function ServerModule:LoadBenchFromTable(benchTable, base, fromBench, count): Model
	count = (count or 0) + 1
	if count % 40 == 0 then task.wait() end
	local savedId = benchTable[1]
	local isBasePart = (type(savedId) == "string")
	local damageType, maxHealth, benchName, storageBench, benchSkin, benchId, rotateAmount, faceAway, snapPoint, placeCFrame, benchData, connections
	if savedId == "S" then
		maxHealth = 0
		benchName = "Sleeper"
		storageBench = Benches.Sleeper.Default
	elseif isBasePart then
		local underscore = string.find(savedId, "_")
		local basePartIndex = tonumber(savedId:sub(2, (underscore and underscore - 1 or savedId:len())))
		if not basePartIndex then
			warn("ERROR LOADING BASE PART - INVALID BENCHID ("..savedId..")")
			return
		end
		if underscore then
			local upgradeType = tonumber(savedId:sub(underscore + 1))
			damageType = (upgradeType == 4 and "Steel" or (upgradeType == 3 and "Metal" or (upgradeType == 2 and "Stone" or "Wood")))
		end
		maxHealth = (damageType == "Wood" and 250 or (damageType == "Stone" and 500 or (damageType == "Metal" and 1000 or (damageType == "Steel" and 2000 or 10))))
		benchName = BasePartInfo:GetNameFromIndex(basePartIndex)
		if not benchName then
			warn("ERROR LOADING BASE PART - INVALID BASE PART INDEX ("..basePartIndex..")")
			return
		end
		storageBench = Benches:FindFirstChild(benchName)
	else
		--return
		benchId = savedId
		local itemInfo = Items[benchId]
		if not itemInfo then
			warn("ERROR LOADING BENCH - NO ITEMINFO FOUND ("..savedId..")")
			return
		end
		maxHealth = itemInfo.MaxDurability
		benchName = itemInfo.Name
		benchSkin = "Default"
	end
	local health = maxHealth
	local benchInfo = BenchInfo[benchName]
	if not benchInfo then
		warn("ERROR LOADING BENCH - NO BENCHINFO FOUND ("..benchName..")")
		return
	end
	local fromPrim = (fromBench and fromBench.PrimaryPart)
	local snapInfo = benchTable[2]
	local isIndex = (type(snapInfo) == "number")
	local isSnap = (isIndex or snapInfo:find("_"))
	if isSnap then
		local snapIndex = snapInfo
		if not isIndex then
			local encodedIndex, encodedExtra = unpack(snapInfo:split("_"))
			snapIndex = tonumber(encodedIndex)
			rotateAmount = tonumber(encodedExtra:sub(1, 1))
			faceAway = (encodedExtra:sub(2, 2) == "1")
		end
		local snapPoints = benchInfo.SnapPoints
		if not (fromPrim and snapPoints) then
			warn("ERROR LOADING BENCH - NO VALID BENCH TO PLACE ATTACHED BENCH TO ("..benchName..snapIndex..")")
			return
		end
		snapPoint = snapPoints[snapIndex]
		if not snapPoint then
			warn("ERROR LOADING BENCH - NO VALID SNAP POINT TO PLACE INTO ("..benchName..snapIndex..")")
			return
		end
		local rotateOffset = CFrame.new()
		for i = 1, (rotateAmount or 0) do
			rotateOffset *= (benchInfo.RotateOffset or CFrame.new())
		end
		local offset = fromPrim.CFrame * snapPoint.Offset * benchInfo.Offset
		placeCFrame = offset * rotateOffset * (faceAway and benchInfo.OffsetSnappedFacingAway or CFrame.new())
	else
		placeCFrame = (fromPrim and fromPrim.CFrame or CFrame.new()) * self:DecodeCFrame(snapInfo)
	end
	for i, data in pairs(benchTable) do
		if not (i and data and i > 2) then continue end
		if type(data) == "string" then
			local encodedHealth, encodedSkin = unpack(data:split("/"))
			health = (encodedHealth == "" and health or self:DecodeNumber(encodedHealth))
			benchSkin = (encodedSkin == "" and benchSkin or encodedSkin)
		elseif i == #benchTable then
			connections = data
		else
			benchData = data
		end
	end
	if benchSkin and not storageBench then
		storageBench = Benches[benchName]:FindFirstChild(benchSkin)
	end
	if not storageBench then
		warn("ERROR LOADING BENCH - BENCH NOT FOUND INSIDE OF REPLICATEDSTORAGE.BENCHES ("..benchName..")")
		return
	end
	local benchFolder = base:FindFirstChild(benchName)
	if not benchFolder then
		benchFolder = Instance.new("Folder")
		benchFolder.Name = benchName
		benchFolder.Parent = base
	end
	local benchModel, bench = shared.CreateBench(storageBench, (isBasePart and benchName or benchId), placeCFrame, benchFolder, health, maxHealth, nil, nil, benchData, nil, nil, nil, nil, true)
	if not benchModel then return end
	if damageType then
		local upgrade = BaseParts[damageType]:FindFirstChild(benchName)
		if not upgrade then
			warn("ERROR LOADING BASE PART - UPGRADED VERSION NOT FOUND IN SERVERSTORAGE.BASEPARTS ("..damageType..benchName..")")
			return
		end
		local upgradedBasePart = ModUtil:SafeClone(upgrade)
		upgradedBasePart.PrimaryPart = upgradedBasePart:FindFirstChild("Main")
		upgradedBasePart:SetPrimaryPartCFrame(placeCFrame)
		for _, part in pairs(benchModel:GetChildren()) do
			if part.Name == "BuildingPriv" or not part:IsA("BasePart") then continue end
			ModUtil:SafeDestroy(part)
		end
		for _, part in pairs(upgradedBasePart:GetChildren()) do
			if not part:IsA("BasePart") then continue end
			part.Parent = benchModel
			if part.Name ~= "Main" then continue end
			benchModel.PrimaryPart = part
		end
		benchModel:SetAttribute("DamageType", damageType)
		upgradedBasePart:Destroy()
	end
	local benchPrim = benchModel.PrimaryPart
	if benchPrim and fromPrim and not isBasePart then
		local conFrom = Instance.new("ObjectValue")
		conFrom.Name = "Connection"
		conFrom.Value = fromBench
		conFrom.Parent = benchPrim
	end
	if rotateAmount then
		benchModel:SetAttribute("RotateAmount", rotateAmount)
	end
	if faceAway then
		benchModel:SetAttribute("FaceAway", faceAway)
	end
	if fromPrim then
		local conTo = Instance.new("ObjectValue")
		conTo.Name = "Connection"..(snapPoint and snapPoint.AttachmentIndex or "")
		conTo.Value = benchModel
		conTo.Parent = fromPrim
		conTo:SetAttribute("From", true)
	end
	--[[for _, v in pairs(benchFolder:GetChildren()) do
		if v == benchModel then continue end
		local dist = (benchPrim.Position - v.PrimaryPart.Position).Magnitude
		if dist > 0.1 then continue end
		warn("LOADING BASEPART DETECTED IN SAME POSITION AS ANOTHER")
		table.insert(Test, benchModel)
		break
	end]]
	--print(benchModel, benchTable, fromBench)
	if benchModel and connections then 
		for _, connection in pairs(connections) do
			local _, newCount = self:LoadBenchFromTable(connection, base, benchModel, count)
			count = math.max((newCount or 0), count)
		end
	end
	return benchModel, count, bench
end

function ServerModule:ConvertBaseToTable(base: Folder): string
	local foundations = (base:FindFirstChild("Foundation") and base.Foundation:GetChildren() or {})
	local triFoundations = (base:FindFirstChild("Triangle Foundation") and base["Triangle Foundation"]:GetChildren() or {})
	for _, foundation in pairs(triFoundations) do
		table.insert(foundations, foundation)
	end
	table.sort(foundations, function(a, b)
		return (a:GetAttribute("FoundationIndex") or 0) < (b:GetAttribute("FoundationIndex") or 0)
	end)
	local usedFoundations = {}
	local longestFound, longestLen
	local lastCount = 0
	local totalFails = 0
	local amount = 0
	while base and base.Parent do
		amount += 1
		local firstFoundation
		for _, foundation in pairs(foundations) do
			if table.find(usedFoundations, foundation) then continue end
			firstFoundation = foundation
			break
		end
		if not firstFoundation then break end
		local baseTable, fails, count = self:SaveBenchConnections(firstFoundation, lastCount)
		fails = (fails or 1)
		if fails <= 0 then
			if totalFails > 0 then
				print("SUCCESSFULLY SERIALIZED BASE (TOTAL FAILS: "..totalFails..") (FOUNDATIONS CHECKED: "..#usedFoundations..")")
			end
			return baseTable
		end
		if amount % 2 == 0 then task.wait() end
		if count then
			lastCount = count
		end
		totalFails += fails
		table.insert(usedFoundations, firstFoundation)
		if allDone then
			allDone[base] = nil
		end
		if type(baseTable) ~= "table" then continue end
		local encodedTable = Http:JSONEncode(baseTable)
		local encodedLen = encodedTable:len()
		if longestFound and longestLen > encodedLen then continue end
		longestFound = baseTable
		longestLen = encodedLen
	end
	if not longestFound then
		warn("ERROR SERIALIZING BASE - NO VALID FOUNDATIONS FOUND")
		return
	end
	warn("FAILED TO SERIALIZE THE ENTIRE BASE - RETURNING BEST POSSIBLE OPTION FOUND (TOTAL FAILS: "..totalFails..") (FOUNDATIONS CHECKED: "..#usedFoundations..")")
	return longestFound
end

function ServerModule:EncodeBase(base: Folder): string
	local started = os.clock()
	local baseString = self:ConvertBaseToString(base)
	if not baseString then return end
	print(baseString)
	local compressedBaseString = Compression.Zlib.Compress(baseString, {
		level = 5; -- integer 0 -> 9 where 0 is no compression and 9 is most compression
		strategy = "dynamic" -- "huffman_only", "fixed", "dynamic"
	})
	local baseStringLen = baseString:len()
	local base64String = Base64.Encode(baseStringLen <= compressedBaseString:len() and baseString or compressedBaseString)
	print("COMPRESSED BASE STRING FROM "..NumberUtil:FormatNumber(baseStringLen).." TO "..NumberUtil:FormatNumber(base64String:len()).." (TIME ELAPSED: "..(os.clock() - started)..")")
	return base64String
end

function ServerModule:DecodeBase(base64String: string): Folder
	local started = os.clock()
	local compressedBaseString = Base64.Decode(base64String)
	local baseTable
	if not pcall(function()
			baseTable = Http:JSONDecode(compressedBaseString)
		end) then
		local baseString = Compression.Zlib.Decompress(compressedBaseString)
		baseTable = Http:JSONDecode(baseString)
	end
	local base = Instance.new("Folder")
	base.Name = "Base"
	base.Parent = Bases
	local firstBench = self:LoadBenchFromTable(baseTable, base)
	local count = shared.UpdateBaseConnections(base, true)
	DamageModule:CheckBaseStability(base, firstBench)
	DamageModule:UpdateBaseCost(base, true)
	print("SUCCESSFULLY LOADED BASE (TIME ELAPSED: "..os.clock() - started..")")
	return base, baseTable
end

function ServerModule:Save(dataStoreKey: string?, isClosing: boolean, forceSave: boolean)
	dataStoreKey = (dataStoreKey or shared.ServerId)
	if not dataStoreKey then
		warn("Save attempt ignored; datastore key is nil")
		return 
	end
	if not (ServerService:GetAttribute("SavingEnabled") or forceSave) then
		warn("Save attempt ignored; saving is currently disabled. To enable, set ServerService's SavingEnabled attribute to true.")
		return
	end
	local started = os.clock()
	--[[if isClosing then
		print("Waiting for all players to leave")
		local started = os.clock()
		while #Players:GetPlayers() > 0 do
			if os.clock() - started >= 10 then
				warn("SERVER TOOK TOO LONG FOR ALL PLAYERS TO LEAVE BEFORE INITIALIZING SAVE")
			end
			task.wait()
		end
		print("Done waiting for players")
	end]]
	local didUserDatas = {}
	print("SAVING 1")
	for i = 1, 2 do
		if not shared.UserDatas then
			warn("[CRITICAL] SERVER SAVED WITHOUT USERDATA TABLE IN MEMORY - USER DATA LOSS POSSIBLE")
			break 
		end
		for player, user in pairs(i == 1 and shared.Users or shared.UserLeaveTempContainer) do
			local userId = tostring(user.UserId)
			if didUserDatas[userId] then continue end
			didUserDatas[userId] = true
			local userData, shouldSave = user:GetUserData()
			if not shouldSave then
				shared.UserDatas[userId] = nil
				continue
			end
			shared.UserDatas[userId] = userData
		end
	end
	--print("USER DATAS:", shared.UserDatas)
	allDone = {}
	local bases = {}
	print("SAVING 2")
	for i, base in pairs(Bases:GetChildren()) do
		if i % 10 == 0 then task.wait() end
		if base.Name == "Loners" then continue end
		local baseTable = self:ConvertBaseToTable(base)
		if not baseTable then warn(base, "BASETABLE NOT FETCHABLE") continue end
		table.insert(bases, baseTable)
	end
	local didSaves = {}
	local playerInfos = {}
	local containerNames = {"Inventory", "Toolbar", "Armor"}
	print("SAVING 3")
	if ServerService:GetAttribute("SleepersEnabled") then
		for i = 1, 2 do
			for player, user in pairs(i == 1 and shared.Users or shared.UserLeaveTempContainer) do
				--print(i, "attempting to save", player, "player data")
				local userId = user.UserId
				if i == 1 then
					local character = player.Character
					if not character then continue end
					local charPrim = character.PrimaryPart
					if not charPrim then continue end
					local humanoid = character:FindFirstChild("Humanoid")
					if not (humanoid and humanoid.Health > 0) then continue end
				elseif didSaves[userId] then continue end
				didSaves[userId] = true
				local userStats = user.Stats:GetStats()
				local inventory = user.Inventory
				local primCF = user.FallenGuard.LastCFrame
				if not primCF then continue end
				local health = (user.WentDown and 0 or user.LastHealth)
				local notEmpty = false
				local invIndex = 0
				local savedInv = {}
				for _, containerName in pairs(containerNames) do
					local container = inventory:GetInv()[containerName]
					for _, item in pairs(container) do
						invIndex += 1
						if not (item and item ~= 0 and item.Amount > 0) then continue end
						notEmpty = true
						savedInv[tostring(invIndex)] = ServerModule:EncodeItemData(item)
					end
				end
				local suc, playerInfo = pcall(function()
					return {
						ServerModule:EncodeCFrame(primCF),
						ServerModule:EncodeIntTable({
							userId,
							(health or 0),
							(userStats.Hunger or 0),
							(userStats.Thirst or 0),
							(userStats.Bleed or 0),
							(userStats.Radiation or 0),
						}),
					}
				end)
				if not suc or not playerInfo then
					warn("COULD NOT SAVE SLEEPER OF", userId, playerInfo)
					continue
				end
				if notEmpty then
					table.insert(playerInfo, savedInv)
				end
				table.insert(playerInfos, playerInfo)
			end
			task.wait()
		end
	end
	local loners = {}
	local count = 0
	--print(didSaves)
	print("SAVING 4")
	for _, benchFolder in pairs(Bases.Loners:GetChildren()) do
		for _, bench in pairs(benchFolder:GetChildren()) do
			count += 1
			if count % 150 == 0 then task.wait() end
			if not bench:GetAttribute("ID") then continue end
			local benchPrim = bench.PrimaryPart
			if not benchPrim then continue end
			if bench.Name == "Sleeper" then
				local benchClass = shared.Benches[bench]
				--print(benchClass)
				if not benchClass then continue end
				local sleeperInfo = benchClass.SleeperInfo
				if not sleeperInfo then continue end
				local userId = sleeperInfo[1]
				if didSaves[userId] then continue end
				local humanoid = bench:FindFirstChild("Humanoid")
				if humanoid then
					sleeperInfo[2] = humanoid.Health
				end
			end
			local foundNonFromCon = false
			for _, con in pairs(benchPrim:GetChildren()) do
				if con.Name:sub(1, 10) ~= "Connection" then continue end
				local conVal = con.Value
				if not (conVal and conVal.Parent and not con:GetAttribute("From")) then continue end
				foundNonFromCon = conVal
				break
			end
			if foundNonFromCon then print("SKIPPED", bench, "ON INDIVIDUAL LONER SAVE AS ITS CONNECTED TO ANOTHER PART", foundNonFromCon) continue end
			local benchTable = self:SaveBenchConnections(bench)
			--local benchTable = self:ConvertBenchToTable(bench)
			if not benchTable then warn(bench, "BENCHTABLE NOT FETCHABLE") continue end
			table.insert(loners, benchTable)
			--[[if benchClass then
				local sleeperInfo = benchClass.SleeperInfo
				if sleeperInfo then
					local userId = sleeperInfo[1]
					didSaves[userId] = true
				end
			end]]
		end
	end
	allDone = nil
	print("SAVING 5")
	local serverStats = shared.ServerStats:GetData()
	local extras = {
		ShutdownTime = (isClosing and self:EncodeNumber(os.time())),
		ClockTime = self:EncodeNumber(Lighting.ClockTime),
		ServerStarted = shared.ServerStarted,
	}
	local spawnAreaDatas = {}
	--[[
	for spawns, spawnAreaClass in pairs(shared.SpawnAreas) do
		spawnAreaDatas[spawns.Name:gsub("Spawns", "")] = spawnAreaClass:GetData()
	end]]
	local serverId = shared.ServerId
	if serverId then
		pcall(function()
			local serverInfo = ServerCache:GetAsync(serverId)
			if not serverInfo then return end
			serverInfo[4] = #Players:GetPlayers()
			Servers:SetAsync(`Server_{serverId}`, serverInfo)
			print("set server datastore")
		end)
	end
	local serverTable = {bases, loners, serverStats, extras, spawnAreaDatas, playerInfos, shared.UserDatas, shared.Teams}
	local serverString = Http:JSONEncode(serverTable)
	local serverSaveSize = serverString:len()
	print("SAVING 6")
	local encodedServerString = Compression.Zlib.Compress(serverString, {
		level = 7; -- integer 0 -> 9 where 0 is no compression and 9 is most compression
		strategy = "dynamic" -- "huffman_only", "fixed", "dynamic"
	})
	print("SAVING 7")
	local serialServerString = Base64.Encode(encodedServerString)
	print("SAVING 8")
	--local serialServerString = Compression2.Compress(serverString)
	local dataStoreStarted = os.clock()
	local newServerSaveSize = serialServerString:len()
	local keyMaxSize = script:GetAttribute("KeyMaxSize")
	local keysNeeded = math.ceil(newServerSaveSize / keyMaxSize)
	local fileSize = NumberUtil:BytesToKB(newServerSaveSize)
	for index = 1, keysNeeded do
		local suc, err = DataModule:SafeFunctionCall(3, 5, function()
			Servers:SetAsync(dataStoreKey.."_"..index, serialServerString:sub((index - 1) * keyMaxSize + 1, math.min(index * keyMaxSize, newServerSaveSize)))
		end)
		if suc then continue end
		warn("[CRITICAL] ERROR SAVING SERVER (KEY "..index.."/"..keysNeeded..") (SIZE: "..fileSize.." KB) - ", err, serverTable)
		return
	end
	local clockTime = os.clock()
	print("SUCCESSFULLY SAVED THE SERVER (ORIGINAL SIZE: "..NumberUtil:BytesToKB(serverSaveSize).." KB) (UPLOAD SIZE: "..NumberUtil:BytesToKB(newServerSaveSize).." KB) (KEYS NEEDED: "..keysNeeded..") (ENCODING TIME ELAPSED: "..(dataStoreStarted - started)..") (DATASTORE TIME ELAPSED: "..(clockTime - dataStoreStarted)..")")
	self:SendMessage(`SAVED THE SERVER ({fileSize} KB)`)
	return serialServerString, serverTable
end

function ServerModule:SendMessage(msg: string)
	ModUtil:FireAllClients(ChatRemotes, AllRemotes.Message, {
		Message = msg;
		Channel = "System";
		DisplayName = "SERVER";
	})
end

function ServerModule:SendPlayerMessage(player: Player, msg: string)
	ModUtil:FireClient(ChatRemotes, AllRemotes.Message, player, {
		Message = msg;
		Channel = "System";
		DisplayName = "SERVER";
	})
end

function ServerModule:LoadServerSave(dataStoreKey: string?)
	local serverInformation
	if not dataStoreKey then
		local accessCode = game.PrivateServerId
		if not accessCode or accessCode == "" then
			local errorCode = "PRIVATE ACCESS CODE IS NIL"
			warn(`[CRITICAL] {errorCode}`)
			return false, errorCode
		end
		local suc, serverId = DataModule:SafeFunctionCall(5, 1, function()
			return ServerIds:GetAsync(accessCode)
		end)
		if suc and serverId then
			local suc, serverInfo = DataModule:SafeFunctionCall(5, 1, function()
				return ServerCache:GetAsync(serverId)
			end)
			if suc and serverInfo then
				local suc, locationData = DataModule:SafeFunctionCall(5, 1, function()
					return Http:GetAsync("https://www.iplocation.net/myip")
				end)
				local failed = true
				if suc and locationData then
					local _, locationStart = locationData:find("myipIcon/countries.png")
					if locationStart then
						local locationEnd = string.find(locationData, "<", locationStart + 9, true)
						if locationEnd then
							failed = false
							local country = locationData:sub(locationStart + 9, locationEnd - 1)
							local currentRegion, currentCountry
							for _, countryInfo in pairs(RegionModule.Countries) do
								if countryInfo.name:lower() ~= country:lower() then continue end
								currentCountry = countryInfo.code
								for region, countries in pairs(RegionModule.Regions) do
									if not table.find(countries, currentCountry) then continue end
									currentRegion = RegionModule.CombinedRegions[region]
									break
								end
								if currentRegion then break end
							end
							local targetRegion = serverInfo[3]
							if targetRegion == currentRegion then
								shared.ServerId = serverId
								shared.CurrentCountry = currentCountry
								dataStoreKey = serverId
								serverInformation = serverInfo
								task.defer(function()
									DataModule:SafeFunctionCall(3, 2, function()
										local newServerInfo = ServerCache:UpdateAsync(serverId, function(value, sortKey)
											value[11] = currentCountry
											return value, sortKey
										end, script:GetAttribute("MaxKeyExpiration"))
										--print(newServerInfo)
										if newServerInfo then
											Servers:SetAsync(`Server_{serverId}`, newServerInfo)
										end
										ServerModule:SendServerUpdate("Country", serverId, shared.CurrentCountry)
									end)
								end)
							else
								local errorCode = `SERVER CREATED IN WRONG REGION (SERVER REGION IS {tostring(targetRegion)}, FOUND REGION IS {tostring(currentRegion)} {tostring(currentCountry)}) {tostring(serverId)}`
								warn(`[CRITICAL] {errorCode}`)
								return false, errorCode, string.format(script:GetAttribute("ServerWrongRegionKickMessage"), tostring(currentRegion), tostring(targetRegion))
							end
						end
					end
				end
				if failed then
					local errorCode = `ERROR FETCHING SERVER LOCATION ON STARTUP FOR {tostring(serverId)} {tostring(serverInfo)}`
					warn(`[CRITICAL] {errorCode}`)
					return false, errorCode
				end
			else
				local errorCode = `ERROR FETCHING SERVERINFO ON STARTUP FOR {tostring(serverId)} {tostring(serverInfo)}`
				warn(`[CRITICAL] {errorCode}`)
				return false, errorCode
			end
		else
			local errorCode = `ERROR FETCHING SERVERID {tostring(accessCode)} {tostring(serverId)}`
			warn(`[CRITICAL] {errorCode}`)
			return false, errorCode
		end
	end
	--dataStoreKey = "Test"
	local serialServerString = ""
	local index = 0
	while true do
		index += 1
		local suc, serverStringSnippet = DataModule:SafeFunctionCall(3, 5, function()
			return Servers:GetAsync(dataStoreKey.."_"..index)
		end)
		if not suc then
			warn("[CRITICAL] ERROR LOADING SERVER (SUCCESSFUL KEYS LOADED: "..(index - 1)..") (LOADED SIZE: "..NumberUtil:BytesToKB(serialServerString:len())..") - ", serverStringSnippet)
			return false
		elseif serverStringSnippet == nil then
			break
		end
		serialServerString = serialServerString..serverStringSnippet
	end
	return serialServerString, index - 1, serverInformation
end

function ServerModule:UpdatePlayerCount(playerCount)
	local serverId = shared.ServerId
	local count = (playerCount or #Players:GetPlayers())
	local suc, err = pcall(function()
		return ServerCache:UpdateAsync(serverId, function(serverInfo, sortKey)
			serverInfo[4] = count
			serverInfo[11] = shared.CurrentCountry
			return serverInfo, sortKey
		end, 3888000)
	end)
	if not suc then return end
	ServerModule:SendServerUpdate("CountryAndCount", serverId, {count, shared.CurrentCountry})
end

function ServerModule:SendServerUpdate(typ: string, serverId: number, value: any)
	local suc, err = pcall(function()
		Messaging:PublishAsync("ServerUpdates", {
			Type = typ,
			Id = serverId,
			Value = value
		})
	end)
	if not suc then
		warn("ERROR SENDING SERVER UPDATE -", err)
	else
		print("sent update", typ, serverId, value)
	end
end

function ServerModule:Load(serialServerString, keysLoaded, dataStoreStarted, first)
	local basesLoadedCount = 0
	local thread, basesTotalCount
	if first then
		thread = task.defer(function()
			while true do
				if basesTotalCount then 
					LoadingScreenRemote:FireAllClients("Update", "Bases", basesLoadedCount, basesTotalCount)
					task.wait(0.5)
				else
					task.wait()
				end
			end
		end)
	end
	local started = os.clock()
	local decodeSuc, serverString = pcall(function()
		local encodedServerString = Base64.Decode(serialServerString)

		return Compression.Zlib.Decompress(encodedServerString)
		--return Compression2.Decompress(serialServerString)
	end)
	local packetSize = serialServerString:len()
	local errorCodeExtra = " (KEYS LOADED: "..keysLoaded..") (DOWNLOAD SIZE: "..NumberUtil:BytesToKB(packetSize).." KB) - "
	if not decodeSuc then
		local errorCode = "[CRITICAL] ERROR DECODING SERVER STRING"..errorCodeExtra..tostring(serverString)
		warn(errorCode)
		if thread then task.cancel(thread) end
		return false, errorCode
	end
	local serverTable
	local loadSuc, err = pcall(function()
		serverTable = Http:JSONDecode(serverString)
		local bases = serverTable[1]
		local loners = serverTable[2]
		local serverStatsData = serverTable[3]
		local extras = serverTable[4]
		local spawnAreaDatas = serverTable[5]
		local sleeperInfos = serverTable[6] or {}
		local userDatas = serverTable[7] or {}
		local savedTeams = serverTable[8] or {}
		--local spawnAreaDatas = {}
		
		shared.ServerStarted = (extras.ServerStarted or os.time())
		
		local count = 0
		for userId, userData in pairs(userDatas) do
			count += 1
			if count % 1000 == 0 then task.wait() end
			if type(userId) == "string" then continue end
			local combined = {}
			for id, value in pairs(userData[1] or {}) do
				combined[id] = math.max(combined[id] or 0, value)
			end
			local stringUserData = userDatas[tostring(userId)]
			if stringUserData then
				for id, value in pairs(stringUserData[1] or {}) do
					combined[id] = math.max(combined[id] or 0, value)
				end
			end
			userDatas[tostring(userId)] = {combined}
		end
		shared.UserDatas = userDatas
		
		shared.SpawnAreaDatas = spawnAreaDatas
		shared.ServerStats = UserStatsClass.new(nil, serverStatsData)
		shared.Teams = savedTeams
		--print(shared.Teams)
		
		Lighting.ClockTime = self:DecodeNumber(extras.ClockTime)
		local shutdownTime = (type(extras.ShutdownTime) == "string" and self:DecodeNumber(extras.ShutdownTime))
		local passedTime
		if shutdownTime then
			passedTime = math.max(os.time() - shutdownTime, 0)
			WeatherService:SetAttribute("ExtraTime", passedTime)
		end

		local baseCount = #bases --
		local lonerCount = #loners
		basesTotalCount = baseCount * 2 + lonerCount
		--print(baseCount, lonerCount)
		
		local newBases = {}
		for _, baseTable in pairs(bases) do
			local base = Instance.new("Folder")
			base.Name = "Base"
			base.Parent = Bases
			local firstBench = self:LoadBenchFromTable(baseTable, base)
			--[[for _, v in pairs(Test or {}) do
				DamageModule:DisconnectBench(v)
				ModUtil:SafeDestroy(v)
			end]]
			basesLoadedCount += 1
			table.insert(newBases, {base, firstBench})
		end
		
		for _, baseTable in pairs(newBases) do
			local base = baseTable[1]
			local firstBench = baseTable[2]
			local count = shared.UpdateBaseConnections(base, true)
			DamageModule:CheckBaseStability(base, firstBench)
			DamageModule:UpdateBaseCost(base, true)
			basesLoadedCount += 1
			task.wait()
		end
		
		
		local sleepers = {}
		for index, benchTable in pairs(loners) do
			--table.insert(benchTable, {})
			local _, _, bench = self:LoadBenchFromTable(benchTable, Bases.Loners)
			if bench then
				local sleeperInfo = bench.SleeperInfo
				if sleeperInfo then
					local sleeperId = sleeperInfo[1]
					sleepers[sleeperId] = true
				end
			end
			basesLoadedCount += 1
			if index % 200 == 0 then task.wait() end
		end
		for _, encodedSleeperInfo in pairs(sleeperInfos or {}) do
			count += 1
			if count % 1000 == 0 then task.wait() end
			local sleeperInfo = ServerModule:DecodeIntTable(encodedSleeperInfo[2])
			local sleeperId = sleeperInfo[1]
			if sleepers[sleeperId] then continue end -- If a saved sleeper was detected, don't create another one
			local sleeperCF = ServerModule:DecodeCFrame(encodedSleeperInfo[1])
			local sleeperFolder = Bases.Loners:FindFirstChild("Sleeper")
			if not sleeperFolder then
				sleeperFolder = Instance.new("Folder")
				sleeperFolder.Name = "Sleeper"
				sleeperFolder.Parent = Bases.Loners
			end
			local benchData = {}
			benchData.N = sleeperInfo
			local savedInv = encodedSleeperInfo[3]
			if savedInv then
				benchData.C = savedInv
			end
			local benchModel, bench = shared.CreateBench(Benches.Sleeper.Default, "Sleeper", sleeperCF, sleeperFolder, 0, 0, nil, nil, {"_SKIPDECODE", benchData}, nil, nil, nil, nil, true)
		end
		
		--print(shared.UserDatas)

		-- Make sure benches catch up if server was shut down
		print(6)
		if passedTime then
			for benchModel, bench in pairs(shared.Benches) do
				bench:Update(true)
				count += 1
				if count % 200 == 0 then task.wait() end
				if bench.On ~= true then continue end
				bench.ExtraStep = passedTime
			end
			task.wait(3)
			BuildService:SetAttribute("DecayExtraTime", passedTime)
		end
		print(7)
	end)
	if not loadSuc then
		local errorCode = "[CRITICAL] ERROR INTIALIZING LOADED SERVER DATA"..errorCodeExtra..tostring(err)
		warn(errorCode)
		if thread then task.cancel(thread) end
		return false, errorCode
	end
	local clockTime = os.clock()
	print("SUCCESSFULLY LOADED THE SERVER (KEYS LOADED: "..keysLoaded..") (DOWNLOAD SIZE: "..NumberUtil:BytesToKB(packetSize).." KB) (DECODING TIME ELAPSED: "..(clockTime - started)..") (DATASTORE TIME ELAPSED: "..(started - dataStoreStarted)..")")
	if thread then task.cancel(thread) end
	return serverTable, serialServerString
end

return ServerModule