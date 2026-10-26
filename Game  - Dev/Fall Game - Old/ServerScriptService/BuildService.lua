-- [PATH] ServerScriptService / ServerService / BuildService @Type Script
--[[
	BuildService
	by ChickenBagelz
	February 11, 2023
	
	Handles placement requests by the client, doing sanity checks along the way
]]


-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local ServerScripts = game:GetService("ServerScriptService")

-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")

-- Folders
local SharedModules = Replicated:WaitForChild("Modules")
local Benches = Replicated:WaitForChild("Benches")
local ServerModules = Storage:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")
local Bases = workspace:WaitForChild("Bases")
local VFX_PARTS = workspace:WaitForChild("VFX")
local BaseParts = Storage:WaitForChild("BaseParts")
local GlobalSounds = Storage:WaitForChild("GlobalSounds")
local Signs = Replicated:WaitForChild("Signs")
local Values = Replicated:WaitForChild("Values")

-- Modules
local BenchInfo = require(SharedModules:WaitForChild("BenchInfo"))
local Items = require(SharedModules:WaitForChild("Items"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local Thread = require(SharedModules:WaitForChild("Thread"))
local DamageModule = require(ServerModules:WaitForChild("DamageModule"))
local RecipeModule = require(SharedModules:WaitForChild("RecipeModule"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))

-- Remotes
local BuildRemotes = Remotes:WaitForChild(string.char(75, 121, 79, 188, 126, 63, 141, 137, 5, 132, 117, 32, 190, 12, 68, 117, 78, 118, 140, 65, 50, 109, 56, 50, 110, 58, 36, 182, 159, 121))
local ChatRemotes = Remotes:WaitForChild(string.char(96, 35, 40, 91, 98, 164, 149, 39, 30, 15, 96, 175, 70, 174, 182, 135, 163, 50, 76, 163, 104, 183, 141, 3, 50, 142, 28, 14, 48, 109))
local AllRemotes = {
	Place = string.char(79, 142, 119, 97, 58, 167, 123, 111, 23, 3, 159, 15, 11, 179, 50, 145, 9, 2, 100, 102, 64, 125, 111, 95, 113, 88, 112, 179, 104, 70);
	ChangeBase = string.char(172, 58, 85, 34, 15, 1, 172, 16, 57, 91, 101, 87, 7, 2, 26, 53, 18, 135, 188, 124, 173, 148, 27, 119, 24, 7, 38, 70, 179, 13);
	Message = string.char(113, 112, 81, 144, 109, 55, 138, 180, 22, 36, 121, 67, 5, 157, 74, 71, 60, 141, 148, 82, 79, 115, 10, 151, 83, 101, 91, 78, 50, 108);
}

-- Settings
local upgradeAvailability = {
	Twig = {"Wood", "Stone", "Metal", "Steel"};
	Wood = {"Stone", "Metal", "Steel"};
	Stone = {"Metal", "Steel"};
	Metal = {"Steel"};
	Steel = {};
}


-- Local Variables
local rayCounter = 0
local buildPrivCheckFunc = RaycastUtil:FilterFunction("BuildingPrivCheck")
local viewFilterFunc = RaycastUtil:FilterFunction("View")

-- Functions
function ConnectBenches(toBench, fromBench, toIndex, ignoreTo, instant)
	local fromPrim = fromBench.PrimaryPart
	local toPrim = toBench.PrimaryPart
	local conTo
	if not (toIndex and fromPrim:FindFirstChild("Connection"..toIndex)) then
		conTo = Instance.new("ObjectValue")
		conTo.Name = "Connection"..(toIndex or "")
		conTo.Value = toBench
		conTo.Parent = fromPrim
		--print("creating connection to", fromBench)
	end
	--[[if not toPrim:FindFirstChild("FoundationFrom") then
		local foundationVal = fromPrim:FindFirstChild("FoundationFrom")
		local foundation = (fromBench.Name:find("Foundation") and fromBench or (foundationVal and foundationVal.Value))
		if foundation then
			local foundationFrom = Instance.new("ObjectValue")
			foundationFrom.Name = "FoundationFrom"
			foundationFrom.Value = foundation
			foundationFrom.Parent = toPrim
		end
	end]]
	local connectedBenches = {}
	if not ignoreTo then
		local toInfo = BenchInfo[toBench.Name]
		local toAttachChecks = toInfo.AttachmentChecks
		local cf = toBench.PrimaryPart.CFrame
		if toAttachChecks then
			local base = toBench:FindFirstAncestor("Base")
			if not base then return end
			for _, checkTable in pairs(toAttachChecks) do
				local cons = UpdateConnections(toBench, checkTable, instant)
				--print(toBench, "has new connections:", unpack(cons or {}))
				if not cons then continue end
				for _, con in pairs(cons) do
					table.insert(connectedBenches, con)
				end
			end
		end
		if #connectedBenches <= 0 then
			local found = false
			for _, con in pairs(toPrim:GetChildren()) do
				if not (con.Name == "Connection" and con:IsA("ObjectValue") and con.Value == fromBench) then continue end
				found = true
				break
			end
			if not found then
				local conFrom = Instance.new("ObjectValue")
				conFrom.Name = "Connection"
				conFrom.Value = fromBench
				conFrom.Parent = toPrim
				if toAttachChecks then
					warn("BASE SNAP FAILED TO CONNECT FULLY", toBench.Name, fromBench.Name)
				end
			end
		end
	end
	return conTo, connectedBenches
end

function UpdateConnections(bench, checkTable, instant, yes)
	yes = (yes or 25)
	local showRays = (script:GetAttribute("DebugShowStabilityRays") and "GreenRay")
	--print("doing attachment checks for", bench)
	local prim = bench.PrimaryPart
	local connectedBenches = {}
	local didWait = false
	for _, check in pairs(checkTable.Checks) do
		local attachmentIndex = check.AttachmentIndex
		local conVal = prim:FindFirstChild("Connection"..attachmentIndex)
		if conVal and conVal.Value and conVal.Value.Parent then continue end
		local passed = true
		local hitBench
		for _, rayInfo in pairs(check.Rays) do
			local origin = prim.CFrame * rayInfo.Offset
			local hitFolder
			local rayHit = RaycastUtil:Raycast(origin.Position, origin.LookVector * rayInfo.Length, "Blacklist", {VFX_PARTS, workspace.Terrain, bench}, showRays, function(hit)
				local hitBase = hit:FindFirstAncestor("Base")
				if not hitBase then
					return hit.Parent
				end
				for _, checkName in pairs(checkTable.BenchNames) do
					local checkFolder = hitBase:FindFirstChild(checkName)
					if checkFolder and hit:IsDescendantOf(checkFolder) then
						hitFolder = checkFolder
						return
					end
				end
				return hit.Parent
			end)
			if rayHit and hitFolder and (hitBench == nil or rayHit:IsDescendantOf(hitBench)) then
				hitBench = rayHit:FindFirstAncestor(hitFolder.Name)
				continue 
			end
			passed = false
			break 
		end
		--print(passed, attachmentIndex, hitBench, bench, hitBench == bench)
		if passed and hitBench and hitBench.Parent then
			ConnectBenches(hitBench, bench, attachmentIndex, true)
			table.insert(connectedBenches, hitBench)
		end
		if instant then continue end
		rayCounter += 1
		--print(rayCounter)
		if rayCounter >= yes then
			didWait = true
			rayCounter = 0
			task.wait()
		end
	end
	return connectedBenches, didWait
end

shared.UpdateBaseConnections = function(base, ignoreDist, bench, placedOnModel)
	local count = 0
	local count2 = 0
	local count3 = 0
	--local benchUpdates = {}
	for _, folder in pairs(base:GetChildren()) do
		local checkInfo = BenchInfo[folder.Name]
		if not checkInfo then continue end
		local checkAttachChecks = checkInfo.AttachmentChecks
		if not checkAttachChecks then continue end
		for _, checkTable in pairs(checkAttachChecks) do
			local checkFolders = {}
			for _, benchName in pairs(checkTable.BenchNames) do
				local benchFolder = base:FindFirstChild(benchName)
				if not benchFolder then continue end
				table.insert(checkFolders, benchFolder)
			end
			for _, checkBench in pairs(folder:GetChildren()) do
				--[[count2 += 1
				if ignoreDist and count2 % 100 == 0 then task.wait() end]]
				count += 1
				if count % 100 == 0 then task.wait() end
				if checkBench == bench or checkBench == placedOnModel or not checkBench:IsA("Model") then continue end
				local checkPrim = checkBench.PrimaryPart
				if not checkPrim then continue end
				if ignoreDist or NumberUtil:IsWithin(checkPrim.Position, bench.PrimaryPart.Position, checkTable.MaxRange) then
					local connections, didWait = UpdateConnections(checkBench, checkTable, false, (ignoreDist and 80))
					if ignoreDist then continue end
					--[[for _, conBench in pairs(connections) do
						if table.find(benchUpdates, conBench) then continue end
						table.insert(benchUpdates, conBench)
					end]]
					if didWait then continue end
				end
			end
		end
	end
	return count
end

function shared.UpgradeBasePart(basePart, upgradeType, healthRatio)
	healthRatio = (healthRatio or 1)
	local benchName = basePart.Name
	local basePrim = basePart.PrimaryPart
	local typeContainer = BaseParts:FindFirstChild(upgradeType)
	if not typeContainer then return end
	local upgrade = typeContainer:FindFirstChild(benchName)
	if not upgrade then return end
	local upgradedBasePart = ModUtil:SafeClone(upgrade)
	upgradedBasePart.PrimaryPart = upgradedBasePart:FindFirstChild("Main")
	upgradedBasePart:PivotTo(basePrim.CFrame)
	local connections = {}
	for _, part in pairs(basePart:GetChildren()) do
		if part.Name == "BuildingPriv" or not part:IsA("BasePart") then continue end
		if part == basePrim then
			for _, val in pairs(basePrim:GetChildren()) do
				if not val.ClassName:find("Value") then continue end
				table.insert(connections, val)
				val.Parent = nil
			end
		end
		ModUtil:SafeDestroy(part)
	end
	for _, part in pairs(upgradedBasePart:GetChildren()) do
		if not part:IsA("BasePart") then continue end
		part.Parent = basePart
		if part.Name ~= "Main" then continue end
		basePart.PrimaryPart = part
		for _, val in pairs(connections) do
			val.Parent = part
		end
	end
	basePart:SetAttribute("Upgraded", math.floor(tick()))
	basePart:SetAttribute("DamageType", upgradeType)
	local newMaxHealth = (upgradeType == "Steel" and 2000 or (upgradeType == "Metal" and 1000 or (upgradeType == "Stone" and 500 or (upgradeType == "Wood" and 250 or 10))))
	basePart:SetAttribute("MaxHealth", newMaxHealth)
	basePart:SetAttribute("Health", newMaxHealth * healthRatio)
	upgradedBasePart:Destroy()
end

ModUtil:SetupRemotes(BuildRemotes, {
	[AllRemotes.Place] = {
		Cooldown = 0.04;
		AllowedCallsBeforeThrottle = 12;
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local inventory = user.Inventory
			local placedOn = args[1]
			local placeCFrame = args[2]
			local rotateAmount = args[3]
			local basePartName = args[4]
			local snapIndex = args[5]
			local faceAway = args[6]
			if #args >= 7 or args[7] or (placedOn and type(placedOn) ~= "string" and typeof(placedOn) ~= "Instance") or typeof(placeCFrame) ~= "CFrame" or type(rotateAmount) ~= "number" or rotateAmount % 1 ~= 0 or rotateAmount < 0 or type(faceAway) ~= "boolean" then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			if type(placedOn) == "string" then
				--print("was none")
				placedOn = nil 
			end
			local equipped = user.Equipped
			local inventory = user.Inventory
			local toolbar = inventory:GetToolbar()
			local item = toolbar[equipped.Index]
			if not (item and item ~= 0 and item.Amount > 0) then return end
			local humanoid = user.Humanoid
			if not (humanoid and humanoid.Health > 0 and not humanoid:GetAttribute("Downed")) then return end
			local character = humanoid.Parent
			if not character then return end
			local rootPart = character.PrimaryPart
			local itemInfo = Items[item.ID]
			local isBlueprint = (item.ID == 30)
			if not (rootPart and itemInfo and (itemInfo.Type == "Bench" or isBlueprint) and item.Amount > 0 and (itemInfo.MaxDurability == nil or item.Durability > 0)) then return end
			if user:CheckLastMovementDetection(character, humanoid, rootPart, 2) then return end
			if isBlueprint and (type(basePartName) ~= "string" or type(snapIndex) ~= "number" or snapIndex < 0 or snapIndex % 1 ~= 0) then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			local benchName = (isBlueprint and basePartName or itemInfo.Name)
			local benchInfo = BenchInfo[benchName]
			local benchFolder = Benches:FindFirstChild(benchName)
			if not (benchFolder and benchInfo) then return end
			local benchModel = (isBlueprint and benchFolder or (benchFolder:FindFirstChild(item.Skin) or benchFolder:FindFirstChild("Default")))
			if not benchModel then return end
			local systemMsg = (function()
				local recipe = RecipeModule:FetchRecipe("Twig", benchName)
				local costs = (recipe and recipe.Costs)
				local cost = (costs and costs[1])
				local hasCosts, costFound
				if cost then
					hasCosts, costFound = inventory:FindItem(cost.Amount, {"Inventory", "Toolbar"}, {cost.ID})
					if not hasCosts then return "NOT ENOUGH RESOURCES" end
				end
				local base, placedOnModel
				local isSnap = false
				--print((placedOn and placedOn:GetFullName()))
				local snapPoints = benchInfo.SnapPoints
				local faceAwayOffset = benchInfo.OffsetSnappedFacingAway
				local snapOnly = benchInfo.SnapOnly
				local isFoundation = (benchName == "Foundation" or benchName == "Triangle Foundation")
				if placedOn and placedOn:IsDescendantOf(workspace) then
					placedOnModel = (placedOn.ClassName == "Model" and placedOn or placedOn:FindFirstAncestorOfClass("Model"))
					--print(placedOnModel, snapIndex, benchName)
					if placedOn.Parent.Name == "_Floor" then
						base = Bases.Loners
					elseif placedOnModel then
						if snapIndex > 0 then
							--[[print("ha")
							local placedBenchInfo = BenchInfo[placedOnModel.Name]
							if not placedBenchInfo then return end]]
							--print("ha")
							if not snapPoints then return end
							--print("haha")
							local snapOffset = snapPoints[snapIndex]
							if not (snapOffset and table.find(snapOffset.BenchNames, placedOnModel.Name)) then return end
							--print("hahaha")
							local prim = placedOnModel.PrimaryPart
							local conVal = prim:FindFirstChild("Connection"..snapOffset.AttachmentIndex)
							if conVal and conVal.Value and conVal.Value.Parent then return end
							--print("hahahaha")
							local rotateOffset = CFrame.new()
							for i = 1, rotateAmount % 8 do
								rotateOffset *= benchInfo.RotateOffset
							end
							--print(rotateAmount, rotateOffset, faceAway)
							placeCFrame = prim.CFrame * snapOffset.Offset * benchInfo.Offset * rotateOffset * (faceAway and faceAwayOffset or CFrame.new())
							isSnap = true
						end
						base = (placedOnModel:FindFirstAncestor("Base") or (placedOnModel:IsDescendantOf(Bases.Loners) and Bases.Loners))
					else
						base = Bases.Loners
					end
				elseif isBlueprint and isFoundation then
					local deg = math.deg(math.acos(placeCFrame.UpVector.Y))
					if math.abs((benchName == "Triangle Foundation" and 90 or 0) - deg) >= 1 then
						return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
					end
					base = "new"
				elseif snapOnly then
					return
				end
				local isWithin, squaredDist = NumberUtil:IsWithin(rootPart.Position, placeCFrame.Position, script:GetAttribute("MaxPlaceRange") + (benchInfo.PlaceExtraDistance or 0))
				if not isWithin then 
					print("PLACING FAILED - PLAYER TOO FAR AWAY ("..math.sqrt(squaredDist).." STUDS)") 
					return true 
				end
				--print(7)
				if (not base) or (isBlueprint and base == Bases.Loners) then warn("PLACING FAILED - ARGUMENTS INCORRECT", placedOn, base, isBlueprint, placeCFrame) return true end
				local maxPerBase = benchInfo.MaxPerBase
				if maxPerBase and placedOn and not isSnap then
					local baseOn = placedOn:FindFirstAncestor("Base")
					if baseOn then
						local folderOn = baseOn:FindFirstChild(benchName)
						if not (folderOn == nil or #folderOn:GetChildren() < maxPerBase) then warn("PLACING FAILED - MAX AMOUNT OF BENCH PER BASE REACHED ("..maxPerBase..")") return "MAX_PER_BASE_FUNC1 ("..maxPerBase..")" end
					end
				end
				if benchInfo.Type == "Bed" then
					local beds = (shared.Beds[player.UserId] or {})
					local totalBeds = 0
					local maxAllowedBeds = ServerService:GetAttribute("MaxAllowedBeds")
					for _, bed in pairs(beds) do
						if not (bed and bed.Parent) then continue end
						totalBeds += 1
						if totalBeds >= maxAllowedBeds then print("PLACING FAILED - MAX ALLOWED NUMBER OF BEDS REACHED ("..maxAllowedBeds..")") return "BED LIMIT ("..maxAllowedBeds..") REACHED" end
					end
				end
				if not benchInfo.PlacingFunc() then
					local hit, pos, nor = RaycastUtil:Raycast(placeCFrame.Position, placeCFrame[benchInfo.RayCheckVector or "UpVector"] * -benchInfo.RayCheckLength, "Blacklist", {VFX_PARTS, character}, false, viewFilterFunc, true)
					nor = (nor or Vector3.new(0, 1, 0))
					local placeAngle = math.deg(math.acos(nor.Y))
					if not benchInfo.PlacingFunc(benchName, hit, placeAngle, placedOn) then warn("PLACING FAILED - PLACING PREREQUISITES NOT MET", placedOn, hit, nor, placeAngle) return "INVALID SURFACE" end
				end
				local ignoreBlock = benchInfo.IgnoreBuildBlock
				if benchName == "Base Cabinet" then
					local privHit = RaycastUtil:Raycast(Vector3.new(placeCFrame.Position.X, 225.6, placeCFrame.Position.Z), Vector3.new(0, -0.2, 0), "Blacklist", {VFX_PARTS}, false, buildPrivCheckFunc)
					if privHit then warn("PLACING FAILED - BASE CABINET ATTEMPTED TO BE PLACED INSIDE ALREADY EXISTING BASE") return "MAX_PER_BASE_FUNC2" end
				else
					local baseCabinet = RaycastUtil:GetBaseCabinetUnder(placeCFrame.Position, ignoreBlock)
					if baseCabinet and baseCabinet:GetAttribute("Monument") then print("PLACING FAILED - PLAYER TOO CLOSE TO MONUMENT") return "TOO CLOSE TO MONUMENT" end
					if not ignoreBlock then
						local cabinet = shared.Benches[baseCabinet]
						if cabinet and not table.find(cabinet.Authorized or {}, player.UserId) then print("PLACING FAILED - PLAYER IS BUILDING BLOCKED") return "USER BUILDING BLOCKED" end
					end
				end
				
				local placeRegion = Region3.new(placeCFrame.Position - Vector3.new(15, 15, 15), placeCFrame.Position + Vector3.new(15, 3, 15)):ExpandToGrid(4)
				local placeMats = workspace.Terrain:ReadVoxels(placeRegion, 4)
				for x = 1, placeMats.Size.X, 1 do
					for y = 1, placeMats.Size.Y, 1 do
						for z = 1, placeMats.Size.Z, 1 do
							if placeMats[x][y][z] ~= Enum.Material.Asphalt then continue end
							print("PLACING FAILED - CAN'T BUILD NEAR ROADS")
							return "TOO CLOSE TO ROAD"
						end
					end
				end
				
				local testBench = benchModel:Clone()
				testBench.PrimaryPart = testBench:FindFirstChild("Main")
				for _, child in pairs(testBench:GetChildren()) do
					if testBench.PrimaryPart == child or child.Name == "RayParts" or child.Name == "CollisionParts" or child.Name == "BaseCollisionParts" or child.Name == "NonBaseCollisionParts" or child.Name == "Pole" then continue end
					child:Destroy()
				end
				testBench:PivotTo(placeCFrame)
				local snapPoints = benchInfo.SnapPoints
				if not (isBlueprint and isFoundation) then
					local total = 0
					local addedOccupancies = 0
					local hasLand = false
					for _, collisionPart in pairs(testBench.CollisionParts:GetChildren()) do
						local cf = collisionPart.CFrame
						local size = collisionPart.Size
						local region = Region3.new((cf * CFrame.new(size / 2)).Position, (cf * CFrame.new(size / 2)).Position):ExpandToGrid(4)
						--[[
						if not regionPart then
							regionPart = Instance.new("Part")
							regionPart.Parent = VFX_PARTS
							regionPart.Anchored = true
							regionPart.CanCollide = false
							regionPart.BrickColor = BrickColor.new("Bright red")
							regionPart.Transparency = 0.5
						end
						regionPart.CFrame = region.CFrame
						regionPart.Size = region.Size
						
						if material == Enum.Material.Asphalt then
										testBench:Destroy()
										warn("PLACING FAILED - CAN'T BUILD NEAR ROADS")
										return "TOO CLOSE TO ROAD"
									end
						]]
						local materials, occupancies = workspace.Terrain:ReadVoxels(region, 4)
						for x = 1, materials.Size.X do
							for y = 1, materials.Size.Y do
								for z = 1, materials.Size.Z do
									local material = materials[x][y][z]
									total += 1
									addedOccupancies += occupancies[x][y][z]
									if material == Enum.Material.Water then continue end
									hasLand = true
								end
							end
						end
					end
					local averageOccupancy = addedOccupancies / total
					if averageOccupancy >= 0.7 and (not isBlueprint or hasLand) then
						testBench:Destroy()
						print("PLACING FAILED - TERRAIN OCCUPANCY TOO HIGH", averageOccupancy, total) 
						return "BENCH OBSTRUCTED"
					end
				end
				local didNonBaseCheck = ((benchName == "Foundation" or benchName == "Triangle Foundation") and not isSnap)
				local nonBaseCheckFunc = benchInfo.NonBaseCollisionFunc
				if not benchInfo.CollisionFunc(testBench, didNonBaseCheck, (isSnap and placedOnModel)) then
					testBench:Destroy()
					print("PLACING FAILED - COLLISION CHECKS FAILED")
					return "BENCH OBSTRUCTED"
				end
				testBench:Destroy()
				local updates = (costFound and inventory:RemoveFoundItems(costFound, cost.Amount) or {})
				if not isBlueprint then
					item.Amount -= 1
					local itemDoing = item
					if item.Amount <= 0 then
						toolbar[equipped.Index] = 0
						equipped.Item = nil
						itemDoing = nil
					end
					table.insert(updates, {"Toolbar", equipped.Index, (itemDoing or 0)})
				end
				if #updates > 0 then
					inventory:UpdateClient(unpack(updates))
				end
				if base == "new" then
					base = Instance.new("Folder")
					base.Name = "Base"
					base.Parent = Bases
				end
				if not base:FindFirstChild(benchName) then
					local benchesFolder = Instance.new("Folder")
					benchesFolder.Name = benchName
					benchesFolder.Parent = base
				end
				local health = item.Durability
				local maxHealth = itemInfo.MaxDurability
				if isBlueprint then
					maxHealth = 10
					health = maxHealth
				end
				local bench = shared.CreateBench(benchModel, ((not isBlueprint) and item.ID or benchName), placeCFrame, (base:FindFirstChild(benchName) or base), health, maxHealth, item.Repair, user)
				if isBlueprint then
					local autoUpgrade = user.BlueprintAutoUpgrade
					if autoUpgrade then
						shared.UpgradeBasePart(bench, autoUpgrade)
					end
				end
				if bench then
					--[[if not base:FindFirstChild("_First") then
						local firstVal = Instance.new("ObjectValue")
						firstVal.Name = "_First"
						firstVal.Value = bench
						firstVal.Parent = base
					end]]
					if faceAway then
						bench:SetAttribute("FaceAway", true)
					end
					if rotateAmount > 0 then
						bench:SetAttribute("RotateAmount", rotateAmount % 8)
					end
					local didArena = false
					if typeof(placedOn) == "Instance" and placedOn.Parent then
						local _floor = placedOn:FindFirstAncestor("_Floor")
						if _floor and _floor.Parent and _floor.Parent.Parent and _floor.Parent.Parent.Name == "Arenas" then
							for _, combatArena in pairs(shared.CombatArenas or {}) do
								if combatArena.Arena ~= _floor.Parent then continue end
								table.insert(combatArena.Placeables, bench)
								didArena = true
								break
							end
						end
					end
					if not didArena and Values.ServerType.Value == "Combat" then
						local combatArena = user:IsInCombatArena(true)
						if combatArena then
							table.insert(combatArena.Placeables, bench)
						end
					end
					local connectedBenches
					if placedOnModel then
						local fromCon, conBenches = ConnectBenches(bench, placedOnModel, (snapPoints and snapPoints[snapIndex].AttachmentIndex), false, true)
						connectedBenches = conBenches
						if fromCon then
							fromCon:SetAttribute("From", true)
						end
						local bcFound = {}
						for _, val in pairs(bench.PrimaryPart:GetChildren()) do
							if not (val.Name:sub(1, 10) == "Connection" and val:IsA("ObjectValue")) then continue end
							local connection = val.Value
							if not (connection and connection.Parent) then continue end
							local conBase = connection:FindFirstAncestor("Base")
							if not conBase then continue end
							local conBaseCabinets = conBase:FindFirstChild("Base Cabinet")
							if not conBaseCabinets then continue end
							for _, bc in pairs(conBaseCabinets:GetChildren()) do
								if table.find(bcFound, bc) then continue end
								table.insert(bcFound, bc)
							end
							if #bcFound > 1 then
								warn("TOO MANY BASE CABINETS DETECTED IN A BASE (FOUND "..#bcFound..")")
								DamageModule:DestroyBench(bench, true)
								return "MAX_PER_BASE_FUNC3 ("..#bcFound..")"
							end
						end
						DamageModule:CalculateStability(bench)
						if not (bench and bench.Parent) then return end
					end
					if snapPoints then
						local benchUpdates = {bench, placedOnModel}
						if isSnap then
							--DamageModule:UpdateBaseFolder(base)
							for _, connection in pairs(connectedBenches) do
								local conPar = connection.Parent
								if not (conPar and not connection:IsDescendantOf(base)) then continue end
								--print("parenting another connected base to current one")
								local otherBase = conPar.Parent
								for _, otherFolder in pairs(otherBase:GetChildren()) do
									local targetFolder = base:FindFirstChild(otherFolder.Name)
									if targetFolder then
										for index, otherBench in pairs(otherFolder:GetChildren()) do
											--if index % 200 == 0 then task.wait() end
											if not (otherBench and otherBench.Parent) then continue end
											otherBench.Parent = targetFolder
										end
									else
										otherFolder.Parent = base
									end
								end
								ModUtil:SafeDestroy(otherBase)
							end
							local started = tick()
							local count = shared.UpdateBaseConnections(base, false, bench, placedOnModel)
							--print("SERVER - DONE UPDATING BASE CONNECTIONS IN", math.ceil((tick() - started) * 100) / 100, "SECONDS FOR", base, "/ BENCHES CHECKED:", count)
						end
						if isSnap then
							--DamageModule:UpdateBaseFolder(base)
							if nonBaseCheckFunc and didNonBaseCheck == false then
								local nonBaseCheck = nonBaseCheckFunc(bench, placedOnModel, true)
								if not nonBaseCheck then
									DamageModule:DestroyBench(bench)
									return "ANOTHER BASE TOO CLOSE TO PART"
								end
							end
							DamageModule:CheckBaseStability(base, bench)
							DamageModule:UpdateBaseCost(base)
						end
						--ModUtil:FireAllClients(BuildRemotes, AllRemotes.Place, "UpdateSnaps", benchUpdates, #benchUpdates)
					end
					if not (bench and bench.Parent and bench.PrimaryPart) then return end
					local placeSounds = {}
					if isBlueprint then
						local placeSound = GlobalSounds.BaseParts.Twig:Clone()
						placeSound.Parent = bench.PrimaryPart
						table.insert(placeSounds, placeSound)
					else
						for _, sound in pairs(bench.PrimaryPart:GetChildren()) do
							if not (sound.Name == "Place" and sound:IsA("Sound")) then continue end
							table.insert(placeSounds, sound)
						end
					end
					if #placeSounds <= 0 then return end
					for _, sound in pairs(placeSounds) do
						sound.PlaybackSpeed += math.random(-50, 50) / 1000
						sound:Play()
					end
					task.wait(5)
					for _, sound in pairs(placeSounds) do
						if not (sound and sound.Parent) then continue end
						sound:Destroy()
					end
				end 
			end)()
			if not systemMsg then return end
			ModUtil:FireClient(ChatRemotes, AllRemotes.Message, player, {
				Message = "FAILED TO PLACE"..(systemMsg == true and "" or ": "..systemMsg);
				Channel = "System";
				DisplayName = "SERVER";
			})
		end;
	};
	[AllRemotes.ChangeBase] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local basePart = args[1]
			local action = args[2]
			if args[3] or #args >= 3 or (basePart and typeof(basePart) ~= "Instance" and typeof(basePart) ~= "string") or type(action) ~= "number" or action % 1 ~= 0 or action < 1 or action > 6 then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			if not (typeof(basePart) == "Instance" and basePart.Parent and basePart:IsA("Model") and basePart:IsDescendantOf(Bases)) then return end
			local base = basePart:FindFirstAncestor("Base")
			local inventory = user.Inventory
			local name = basePart.Name
			local benchInfo = BenchInfo[name]
			local basePrim = basePart.PrimaryPart
			if name == "Wall Block" or not (benchInfo and basePrim and base) then return end
			local rotateOffset = benchInfo.RotateOffset
			local attachmentChecks = benchInfo.AttachmentChecks
			local rotateIgnores = (benchInfo.RotateIgnores or {})
			local humanoid = user.Humanoid
			if not (humanoid and humanoid.Health > 0 and not humanoid:GetAttribute("Downed")) then return end
			local character = humanoid.Parent
			if not character then return end
			local rootPart = character.PrimaryPart
			if not rootPart then return end
			local isWithin, squaredDist = NumberUtil:IsWithin(rootPart.Position, basePrim.Position, script:GetAttribute("MaxBaseChangeRange"))
			if not isWithin then 
				print("BASE CHANGING FAILED - PLAYER TOO FAR AWAY ("..math.sqrt(squaredDist).." STUDS)") 
				return 
			end
			if user:CheckLastMovementDetection(character, humanoid, rootPart, 2) then return end
			local lastDamaged = basePart:GetAttribute("LastDamaged")
			local damageType = basePart:GetAttribute("DamageType")
			local health = basePart:GetAttribute("Health")
			local maxHealth = basePart:GetAttribute("MaxHealth")
			local t = tick()
			if t - (lastDamaged or 0) < 60 then print("BASE CHANGING FAILED - PART WAS RECENTLY DAMAGED") return end
			local baseCabinet = RaycastUtil:GetBaseCabinetUnder(basePrim.Position)
			if baseCabinet and baseCabinet:GetAttribute("Monument") then print("BASE CHANGING FAILED - TOO CLOSE TO MONUMENT") return end
			local cabinet = shared.Benches[baseCabinet]
			local hasAuth = (cabinet and table.find(cabinet.Authorized or {}, player.UserId))
			if cabinet and not hasAuth then print("BASE CHANGING FAILED - PLAYER IS BUILDING BLOCKED") return end
			if action >= 5 then
				local actionType = (action == 5 and "Upgraded" or "Placed")
				if t - (basePart:GetAttribute(actionType) or t - 0.01) >= 600 then print("BASE CHANGING FAILED - PART TOO OLD TO BE "..actionType:upper()) return end
				if action == 5 then
					if not (rotateOffset and rotateOffset ~= CFrame.new() and attachmentChecks) then return end
					basePart:SetAttribute("RotateAmount", ((basePart:GetAttribute("RotateAmount") or 0) + 1) % 8)
					for _, val in pairs(basePrim:GetChildren()) do
						if not val.Name:find("Connection") then continue end
						local n = tonumber(val.Name:sub(11))
						if not (n and not table.find(rotateIgnores, n)) then continue end
						val:Destroy()
					end
					basePart:PivotTo(basePrim.CFrame * rotateOffset)
					for _, checkTable in pairs(attachmentChecks) do
						UpdateConnections(basePart, checkTable, true)
					end
				elseif not hasAuth then
					return
				else
					DamageModule:DestroyBench(basePart)
					DamageModule:UpdateBaseCost(base)
				end
			else
				local costTyp = upgradeAvailability.Twig[action]
				if not table.find(upgradeAvailability[damageType or "Twig"], costTyp) then return end
				local recipe = RecipeModule:FetchRecipe(costTyp, name)
				if not recipe then return end
				local cost = recipe.Costs[1]
				if not cost then return end
				local costAmt = cost.Amount
				local costId = cost.ID
				local costInfo = Items[costId]
				local hasCosts, costFound = inventory:FindItem(costAmt, {"Inventory", "Toolbar"}, {costId})
				if not hasCosts then print("BASE UPGRADING FAILED - MISSING MATERIALS ("..costAmt.." "..costInfo.Name..")") return end
				local collisionParts = basePart:FindFirstChild("CollisionParts")
				if (name == "Foundation" or name == "Triangle Foundation") and collisionParts and not basePart:FindFirstChild("Fill") then
					local overlapParms = OverlapParams.new()
					overlapParms.FilterType = Enum.RaycastFilterType.Exclude
					overlapParms.FilterDescendantsInstances = {VFX_PARTS, Bases}
					for _, collisionPart in pairs(collisionParts:GetChildren()) do
						if not collisionPart:IsA("BasePart") then continue end
						local parts = workspace:GetPartsInPart(collisionPart, overlapParms)
						for _, part in pairs(parts) do
							if not part then continue end
							local parent = part.Parent
							if not parent then continue end
							local hum = parent:FindFirstChild("Humanoid")
							if hum then print("BASE UPGRADING FAILED - OBJECT IS OBSTRUCTING FOUNDATION") return end
						end
					end
				end
				local updates = inventory:RemoveFoundItems(costFound, costAmt)
				inventory:UpdateClient(unpack(updates))
				shared.UpgradeBasePart(basePart, costTyp, health / maxHealth)
				local basePrim = basePart.PrimaryPart
				local upgradeSound
				if basePrim and basePrim.Parent then
					upgradeSound = GlobalSounds.BaseParts[costTyp]:Clone()
					upgradeSound.PlaybackSpeed += math.random(-50, 50) / 1000
					upgradeSound.Parent = basePrim
					upgradeSound:Play()
				end
				DamageModule:UpdateBaseCost(base)
				task.wait(2)
				if not (upgradeSound and upgradeSound.Parent) then return end
				upgradeSound:Destroy()
			end
		end;
	};
})

script:SetAttribute("LastDecay", tick())
while task.wait(0.5) do
	local count = 0
	local extraTime = script:GetAttribute("DecayExtraTime")
	local decayCheckTime = script:GetAttribute("DecayCheckTime")
	if extraTime or tick() - script:GetAttribute("LastDecay") >= decayCheckTime then
		script:SetAttribute("DecayExtraTime", nil)
		local started = tick()
		local addedMultiplier = math.floor((extraTime or 0) / decayCheckTime)
		local addedTime = ((extraTime or 0) - (addedMultiplier * decayCheckTime))
		script:SetAttribute("LastDecay", started - addedTime)
		if extraTime then
			print(extraTime, addedMultiplier, addedTime)
		end
		local loopedAmount = 0
		for benchModel, bench in pairs(shared.Benches) do
			loopedAmount += 1
			if loopedAmount % 200 == 0 then task.wait() end
			if benchModel and benchModel.Parent then continue end
			shared.Benches[benchModel] = nil
			shared.ActiveBenches[benchModel] = nil
		end
		for _, sign in pairs(Signs:GetChildren()) do
			loopedAmount += 1
			if loopedAmount % 200 == 0 then task.wait() end
			if sign and sign.Parent and sign.Adornee and sign.Adornee.Parent then continue end
			print("cleared old sign")
			sign:Destroy()
		end
		addedMultiplier += 1
		local decayDmgMult = script:GetAttribute("DecayDamageMult")
		local sleeperDmgMult = script:GetAttribute("SleeperDecayDamageMult")
		for extraIndex = 1, addedMultiplier do
			for _, base in pairs(Bases:GetChildren()) do
				local bcCF, baseCabinet, totalUpkeep
				if base.Name ~= "Loners" then
					local bcFolder = base:FindFirstChild("Base Cabinet")
					if bcFolder then
						local bc = bcFolder:FindFirstChild("Base Cabinet")
						if bc and bc.PrimaryPart then
							bcCF = bc.PrimaryPart.CFrame
							baseCabinet = shared.Benches[bc]
							if baseCabinet then
								totalUpkeep = baseCabinet.TotalUpkeep
								local updates = {}
								for _, cost in pairs(totalUpkeep) do
									local upkeep = cost.Amount / 144
									local remainder = (cost.Remainder or 0) + upkeep
									cost.Remainder = remainder
									local upkeepAmount = math.floor(remainder)
									--print(cost.ID, upkeep, upkeepAmount, remainder)
									if upkeepAmount > 0 and cost.Found > 0 then
										cost.Remainder = math.max(remainder - upkeepAmount, 0)
										local container = baseCabinet.Container
										for index, itemTable in pairs(container) do
											local item = itemTable.Item
											if not (item and item ~= 0 and item.ID == cost.ID) then continue end
											local amount = item.Amount
											if amount <= 0 then continue end
											item.Amount = math.max(amount - upkeepAmount, 0)
											upkeepAmount = math.max(upkeepAmount - (amount - item.Amount), 0)
											item = (item.Amount <= 0 and 0 or item)
											baseCabinet:UpdateSlot(index, item)
											table.insert(updates, {"Bench", index, item})
											if upkeepAmount <= 0 then break end
										end
									end
								end
								baseCabinet:UpdatePlayers(updates)
							end
						end
					end
				end
				local distDecayBenches = {}
				local highestDist
				local destroyedBench = false
				for _, benchFolder in pairs(base:GetChildren()) do
					local name = benchFolder.Name
					local benchInfo = BenchInfo[name]
					if not benchInfo then continue end
					local decayType = benchInfo.DecayType
					if decayType == "Never" then continue end
					local isSleeper = (benchFolder.Name == "Sleeper")
					for _, bench in pairs(benchFolder:GetChildren()) do
						if not (bench and bench.Parent) then continue end
						local benchPrim = bench.PrimaryPart
						if not benchPrim then continue end
						local health = bench:GetAttribute("Health")
						local maxHealth = bench:GetAttribute("MaxHealth")
						if isSleeper == false and (not health or not maxHealth or maxHealth <= 0) then continue end
						local primPos = benchPrim.Position
						local amount = maxHealth / -25 * decayDmgMult
						local damageType = bench:GetAttribute("DamageType")
						local benchName = (benchInfo.Type == "BasePart" and (damageType or "Twig") or "")..name
						if decayType == "UnderBase" then
							local privHit = RaycastUtil:Raycast(Vector3.new(primPos.X, 225.6, primPos.Z), Vector3.new(0, -0.2, 0), "Blacklist", {VFX_PARTS}, false, buildPrivCheckFunc)
							if privHit and privHit:IsDescendantOf(Bases) then continue end
						elseif decayType == "Upkeep" and totalUpkeep then
							local highestMult = 0
							for _, upkeep in pairs(totalUpkeep) do
								if not table.find(upkeep.Benches, benchName) then continue end 
								highestMult = math.max(highestMult, upkeep.DamageMult)
							end
							if highestMult > 0 then
								if bcCF then
									local dist = (bcCF.Position - benchPrim.Position).Magnitude
									highestDist = math.max((highestDist or 0), dist)
									distDecayBenches[bench] = {
										Distance = dist;
										DamageMult = highestMult;
									}
									continue
								end
							else
								amount = maxHealth / 15 * decayDmgMult
							end
						elseif decayType == "Sleeper" then
							local benchTable = shared.Benches[bench]
							if not benchTable then continue end
							local sleeperInfo = benchTable.SleeperInfo
							local shouldDrown = false
							local userId
							if benchTable.InWater then
								shouldDrown = true
							elseif sleeperInfo then
								userId = sleeperInfo[1]
								local baseCabinet = RaycastUtil:GetBaseCabinetUnder(primPos)
								local cabinet = shared.Benches[baseCabinet]
								if cabinet and table.find(cabinet.Authorized or {}, userId) then continue end
							end
							local dmg = (shouldDrown and 60 or 10) * sleeperDmgMult
							--print(`dealing {dmg} to sleeper {userId}`, bench)
							DamageModule:Damage(bench:FindFirstChild("Head"), Vector3.new(), Vector3.new(), nil, {
								Head = dmg;
								Bleed = 0;
							}, {Start = 1000, End = 1000}, nil, nil, shouldDrown and "Drowning" or "Oversleeping")
							continue
						end
						if amount <= 0 or tick() - (bench:GetAttribute("LastDamaged") or 0) >= decayCheckTime * 0.8 then
							local newHealth = math.clamp(health + amount, 0, maxHealth)
							bench:SetAttribute("Health", newHealth)
							--print("DECAYING", benchName, "FOR", amount, "HEALTH")
							if newHealth <= 0.01 then
								DamageModule:DestroyBench(bench)
								destroyedBench = true
							end
						end
						count += 1
						if count % 40 == 0 and not extraTime then task.wait() end
					end
				end
				if not highestDist then continue end
				--print(distDecayBenches)
				for bench, info in pairs(distDecayBenches) do
					if not (bench and bench.Parent) then continue end
					local distMult = (info.Distance / highestDist)
					local damageMult = info.DamageMult
					local amount = bench:GetAttribute("MaxHealth") / 40 * decayDmgMult * damageMult * distMult
					local newHealth = math.max(bench:GetAttribute("Health") - amount, 0)
					bench:SetAttribute("Health", newHealth)
					--print("DISTANCE DECAYING", bench, "FOR", amount, damageMult, distMult)
					if newHealth <= 0.01 then
						DamageModule:DestroyBench(bench)
						destroyedBench = true
					end
					count += 1
					if count % 20 == 0 and not extraTime then task.wait() end
				end
				if not (destroyedBench and baseCabinet and baseCabinet.Model and baseCabinet.Model.Parent) then continue end
				baseCabinet:UpdateUpkeepCost()
			end
			if extraIndex % 2 ~= 0 then continue end
			task.wait()
		end
		print("DECAY CHECK COMPLETE - TOTAL DAMAGED: "..count.." TIME ELAPSED: "..(tick() - started))
	end
	local amount = script:GetAttribute("FoundationCheckAmount")
	if amount <= 0 then continue end
	script:SetAttribute("FoundationCheckAmount", amount - 1)
	for _, base in pairs(Bases:GetChildren()) do
		if base.Name == "Loners" then continue end
		local found = false
		for _, folder in pairs(base:GetChildren()) do
			if folder.Name ~= "Foundation" and folder.Name ~= "Triangle Foundation" then continue end
			found = true
			break
		end
		if not found then
			DamageModule:SlowDestroy(base)
		end
		count += 1
		if count % 20 == 0 then task.wait() end
	end
end