-- [PATH] ReplicatedStorage / CharacterScripts / BuildController @Type LocalScript
--[[
	BuildController
	by ChickenBagelz
	February 11, 2023
	
	Handles the rotating and placing of stuff locally
]]


-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")

-- Folders
local Remotes = Replicated:WaitForChild("Remotes")
local Modules = Replicated:WaitForChild("Modules")
local Benches = Replicated:WaitForChild("Benches")
local Values = Replicated:WaitForChild("Values")
local Bases = workspace:WaitForChild("Bases")
local VFX_PARTS = workspace:WaitForChild("VFX")
local VFX_BENCHES = VFX_PARTS:WaitForChild("Benches")

-- Player Variables
local Player = Players.LocalPlayer
local Char = script.Parent
local Hum = Char:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- Dependencies
local InventoryController = Char:WaitForChild("InventoryController")
local WheelController = Char:WaitForChild("WheelController")
local CameraController = Char:WaitForChild("CameraController")
local InteractController = Char:WaitForChild("InteractController")
local EquipController = Char:WaitForChild("EquipController")

-- Modules
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"))
local Items = require(Modules:WaitForChild("Items"))
local BenchInfo = require(Modules:WaitForChild("BenchInfo"))
local RecipeModule = require(Modules:WaitForChild("RecipeModule"))
local BasePartInfo = require(Modules:WaitForChild("BasePartInfo"))
local VectorUtil = require(Modules:WaitForChild("VectorUtil"))

-- Bindables
local Equip = script:WaitForChild("EquipBench")

-- Remotes
local BuildRemotes = Remotes:WaitForChild(string.char(75, 121, 79, 188, 126, 63, 141, 137, 5, 132, 117, 32, 190, 12, 68, 117, 78, 118, 140, 65, 50, 109, 56, 50, 110, 58, 36, 182, 159, 121))
local PlaceRemote = string.char(79, 142, 119, 97, 58, 167, 123, 111, 23, 3, 159, 15, 11, 179, 50, 145, 9, 2, 100, 102, 64, 125, 111, 95, 113, 88, 112, 179, 104, 70)
local ChangeBaseRemote = string.char(172, 58, 85, 34, 15, 1, 172, 16, 57, 91, 101, 87, 7, 2, 26, 53, 18, 135, 188, 124, 173, 148, 27, 119, 24, 7, 38, 70, 179, 13)

-- Settings
local upgradeAvailability = {
	Twig = {"Wood", "Stone", "Metal", "Steel"};
	Wood = {"Stone", "Metal", "Steel"};
	Stone = {"Metal", "Steel"};
	Metal = {"Steel"};
	Steel = {};
}

-- Local Variables
local currentModel, hitboxModel, placeConnection, lastAvailableCF, lastCF, lastAvailableHit, benchInfo, hasCabinetAccess
local canPlace = false
local lastCollisionCheck = 0
local placeOffset = CFrame.new() 
local offsetAmounts = 0
local basePartSelected = "Foundation"
local snapBenchSelected
local lastBenchName
local snaps = {}
local lastSnapUpdate
local snappedBench
local snappedTable = {}
local baseCons = {}
local faceAway = false
local canBag = true
local lastPlace = 0
local snapThread
local lastUpdate = 0
local supportedSnapBenches = {}
local queueSnapUpdate = false


-- Functions
local function GetEquipped(index)
	local containers = InventoryController.Fetch:Invoke()
	if not containers then return end
	local toolbar = containers.Toolbar
	if not toolbar then return end
	local equipped = toolbar[index or script:GetAttribute("Equipped")]
	return (equipped ~= nil and equipped ~= 0 and equipped)
end

local function MouseButton1DownFunc()
	if not (canPlace and currentModel and currentModel.Parent and benchInfo) then return end
	local equipped = GetEquipped()
	if not (equipped and equipped.ID) then return end
	--[[local ignoreBlock = benchInfo.IgnoreBuildBlock
	if (not ignoreBlock) and hasCabinetAccess == false then return end]]
	if hasCabinetAccess == false then return end
	local isBlueprint = (equipped.ID == 30)
	local placedOn = (isBlueprint and (snappedBench or "none") or (snappedBench or lastAvailableHit or "none"))
	--print(placedOn)
	local actualFaceAway = faceAway
	if snappedTable.Index and offsetAmounts % 2 == 1 then -- TODO AIDS FUCKIN FIX IDC TOO LAZY
		actualFaceAway = not actualFaceAway
	end
	if equipped.ID == 190 then -- TODO AIDS FIX
		offsetAmounts = (offsetAmounts % 3 == 2 and 1 or (offsetAmounts % 3 == 1 and 2) or offsetAmounts % 3)
	end
	if tick() - lastPlace < 0.05 then return end
	lastPlace = tick()
	VectorUtil:FireRemote(BuildRemotes, PlaceRemote, {
		[1] = actualFaceAway,
		[2] = (snappedTable.Index or 0),
		[3] = basePartSelected,
		[4] = offsetAmounts,
		[5] = currentModel.PrimaryPart.CFrame,
		[6] = placedOn
	})
end

local function UpdateSnap(bench, prim, index, snapTable)
	--if not (bench and bench.Parent and bench:IsA("Model")) then return end
	--[[local started = tick()
	while bench and not bench.PrimaryPart do
		local passed = tick() - started
		if passed >= 0.2 then break end
		task.wait()
	end]]
	local t = snaps[bench]
	if t and t[index] then return end
	if not t then
		t = {}
		snaps[bench] = t
	end
	t[index] = prim.CFrame * snapTable.Offset
	return true
end

local cachedSortedSnaps = {}
local function _UpdateSnaps(updates)
	if not (Hum and Hum.Parent and Char and Char.Parent and Char.PrimaryPart) then return end
	local charPos = Char.PrimaryPart.Position
	lastSnapUpdate = charPos
	if not updates then
		snaps = {}
	end
	local sortedSnaps = cachedSortedSnaps[snapBenchSelected]
	if not sortedSnaps then
		local info = BenchInfo[snapBenchSelected]
		if not info then return end
		local snapPoints = info.SnapPoints
		if not snapPoints then return end
		sortedSnaps = {}
		for index, snapTable in pairs(snapPoints) do
			if snapTable.Unsnappable then continue end
			local benchNames = snapTable.BenchNames
			local attachmentIndex = snapTable.AttachmentIndex
			for _, benchName in pairs(benchNames) do
				local snapInfos = sortedSnaps[benchName]
				if not snapInfos then
					snapInfos = {}
					sortedSnaps[benchName] = snapInfos
				end
				local indexInfo = snapInfos[attachmentIndex]
				if not indexInfo then
					indexInfo = {}
					snapInfos[attachmentIndex] = indexInfo
				end
				table.insert(indexInfo, {
					Index = index;
					SnapTable = snapTable;
				})
			end
		end
		cachedSortedSnaps[snapBenchSelected] = sortedSnaps
		--print(cachedSortedSnaps)
	end
	local snapTotal = 0
	local failTotal = 0
	local started = tick()
	local skippedBases = {}
	--print("starting")
	for _, base in pairs(Bases:GetChildren()) do
		if base.Name == "Loners" or not base.Parent then continue end
		local baseCabinet = base:FindFirstChild("Base Cabinet")
		if baseCabinet then
			baseCabinet = baseCabinet:FindFirstChild("Base Cabinet")
			if baseCabinet and not NumberUtil:IsWithin(baseCabinet:GetPivot().Position, charPos, 750) then
				failTotal += 1
				if failTotal % 120 == 0 then task.wait() end
				continue 
			end
		end
		for benchName, snapInfos in pairs(sortedSnaps) do
			local folder = base:FindFirstChild(benchName)
			if not folder then 
				failTotal += 1
				if failTotal % 120 == 0 then task.wait() end
				continue 
			end
			for _, bench in pairs(folder:GetChildren()) do
				if not bench.Parent then continue end
				local prim = bench.PrimaryPart
				if not prim then
					failTotal += 1
					if failTotal % 120 == 0 then task.wait() end
					continue 
				end
				local cf = prim.CFrame
				if NumberUtil:IsWithin(cf.Position, charPos, 100) then
					local ignoreIndexes = {}
					for attachmentIndex, snapInfo in pairs(snapInfos) do
						local conVal = prim:FindFirstChild("Connection"..attachmentIndex)
						if conVal and conVal.Value and conVal.Value.Parent then
							failTotal += 1
							if failTotal % 120 == 0 then task.wait() end
							continue 
						end
						for _, info in pairs(snapInfo) do
							local snapIndex = info.Index
							--if ignoreIndexes[snapIndex] then continue end
							local didSnap = UpdateSnap(bench, prim, snapIndex, info.SnapTable)
							--[[if not didSnap then
								ignoreIndexes[snapIndex] = true
							end]]
						end
					end
				end
				snapTotal += 1
				if snapTotal % 80 == 0 then task.wait() end
			end
		end
	end
	--print("updated", snapTotal, "snaps in", math.ceil((tick() - started) * 100) / 100, "seconds")
	--[[local skippedBases = {}
	for index, snapTable in pairs(snapPoints) do
		if snapTable.Unsnappable then continue end
		for _, benchName in pairs(snapTable.BenchNames) do
			print(benchName)
			if updates then
				for _, bench in pairs(updates) do
					if not (bench and bench.Parent and bench.Name == benchName) then continue end
					snaps[bench] = nil
					UpdateSnap(bench, index, snapTable, charPos)
					total += 1
					if total % 30 == 0 then task.wait() end
				end
				continue
			end
			for _, base in pairs(Bases:GetChildren()) do
				if base.Name == "Loners" or skippedBases[base] then continue end
				local baseCabinet = base:FindFirstChild("Base Cabinet")
				if baseCabinet then
					baseCabinet = baseCabinet:FindFirstChild("Base Cabinet")
					if baseCabinet and not NumberUtil:IsWithin(baseCabinet:GetPivot().Position, charPos, 750) then
						skippedBases[base] = true
						continue 
					end
				end
				local folder = base:FindFirstChild(benchName)
				if not folder then continue end
				for _, bench in pairs(folder:GetChildren()) do
					UpdateSnap(bench, index, snapTable, charPos)
					total += 1
					if total % 20 == 0 then task.wait() end
				end
			end
		end
	end]]
	--print(snaps)
end

local function UpdateSnaps(skipLastUpdate, ...)
	--[[local c = os.clock()
	if c - lastUpdate < 0.03 and not skipLastUpdate then
		lastUpdate = c
		return
	end
	lastUpdate = c]]
	if snapThread then
		coroutine.close(snapThread)
		snapThread = nil
	end
	if not (currentModel and currentModel.Parent) then
		queueSnapUpdate = true
		return 
	end
	snapThread = coroutine.create(_UpdateSnaps, ...)
	coroutine.resume(snapThread)
end

local function CloseBench()
	--print("closed bench")
	benchInfo = nil
	canPlace = false
	script:SetAttribute("Equipped", 0)
	if placeConnection then
		placeConnection:Disconnect()
		placeConnection = nil
	end
	if currentModel and currentModel.Parent then
		currentModel:Destroy()
		currentModel = nil
	end
	if hitboxModel and hitboxModel.Parent then
		hitboxModel:Destroy()
		hitboxModel = nil
	end
end

local function EquipBench(equippedIndex)
	--print("equipped bench")
	local equipped = GetEquipped(equippedIndex)
	local itemInfo = (equipped and Items[equipped.ID])
	local currentEquipped = script:GetAttribute("Equipped")
	local wasAblePlaced = canPlace
	if currentEquipped > 0 and currentModel and (currentEquipped ~= equippedIndex or (itemInfo and currentModel.Name ~= itemInfo.Name)) then
		CloseBench()
	end
	if not equipped then return end
	local isBlueprint = (equipped.ID == 30)
	local benchName = (isBlueprint and basePartSelected or itemInfo.Name)
	local folder = Benches:FindFirstChild(benchName)
	benchInfo = BenchInfo[benchName]
	if not (benchInfo and folder) then return end
	script:SetAttribute("Equipped", equippedIndex)
	if not (lastBenchName == benchName and wasAblePlaced) then
		placeOffset = CFrame.new()
		offsetAmounts = 0
		lastAvailableCF, lastCF, lastAvailableHit = nil, nil, nil
		lastCollisionCheck = 0
		canPlace = false
		snappedBench = nil
		snappedTable = {}
	end
	local storageBench = (isBlueprint and folder or (folder:FindFirstChild(equipped.Skin) or folder:FindFirstChild("Default")))
	local bench = storageBench:Clone()
	bench.Name = benchName
	bench.PrimaryPart = bench:FindFirstChild("Main")
	for _, child in pairs(bench:GetDescendants()) do
		if not (child and child.Parent) then continue end
		if child:IsA("BasePart") and child.Parent:IsA("Model") then
			child.Anchored = true
			child.CanCollide = false
			child.CastShadow = false
			child.Color = script:GetAttribute("PlaceUnavailableColor")
			child.Material = Enum.Material.ForceField
			--child.Transparency += 0.2
			if not child:IsA("MeshPart") then continue end
			child.TextureID = ""
		elseif child:IsA("Highlight") or child.Name == "NonBaseCollisionParts" or child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") or child.Name == "DetailDeleter" then
			child:Destroy()
		elseif child:IsA("Folder") then
			for _, part in pairs(child:GetChildren()) do
				if not part:IsA("BasePart") then continue end
				part.Transparency = 1
				part.CanCollide = false
				part.Anchored = true
			end
		end
	end
	bench.Parent = VFX_BENCHES
	currentModel = bench
	hitboxModel = storageBench:Clone()
	hitboxModel.Name = benchName
	hitboxModel.PrimaryPart = hitboxModel:FindFirstChild("Main")
	for _, child in pairs(hitboxModel:GetChildren()) do
		if child ~= hitboxModel.PrimaryPart then
			if child.Name == "CollisionParts" or child.Name == "RayParts" or child.Name == "BaseCollisionParts" or child.Name == "NonBaseCollisionParts" then
				for _, part in pairs(child:GetChildren()) do
					if not part:IsA("BasePart") then continue end
					part.Transparency = 1
					part.CanCollide = false
					part.Anchored = true
				end
			elseif child.Name ~= "Pole" then
				child:Destroy()
				continue
			end
		end
		if not child:IsA("BasePart") then continue end
		child.Transparency = 1
		child.CanCollide = false
	end
	hitboxModel.Parent = VFX_BENCHES
	local snapPoints = benchInfo.SnapPoints
	local oldSnapBench = snapBenchSelected
	snapBenchSelected = benchName
	if queueSnapUpdate or lastBenchName ~= snapBenchSelected or not oldSnapBench then
		--print("first update")
		UpdateSnaps()
	end
	lastBenchName = benchName
	local rotFaceAway = benchInfo.OffsetSnappedFacingAway
	local maxPerBase = benchInfo.MaxPerBase
	if placeConnection then
		placeConnection:Disconnect()
	end
	placeConnection = Run.Heartbeat:Connect(function(step)
		if not (currentModel == bench and hitboxModel and Char and Char.PrimaryPart and Hum and Hum.Health > 0) then
			CloseBench()
			return
		end
		local doCheck = (tick() - lastCollisionCheck >= 0.1)
		local primPos = Char.PrimaryPart.Position + Vector3.new(0, 1.5, 0)
		local camCF = (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame)
		local extraPlaceDist = (benchInfo.PlaceExtraDistance or 0)
		local mouseHit, mousePos, mouseNor = RaycastUtil:Raycast(primPos, camCF.LookVector * (8 + extraPlaceDist), "Blacklist", {Char, VFX_PARTS}, false, RaycastUtil:FilterFunction("View"), true)
		--local mousePos, mouseHit, mouseNor = RaycastUtil:MouseRaycast(, {Char, VFX_PARTS}, 8)
		mouseNor = (mouseNor or Vector3.new(0, 1, 0))
		local placeAngle = math.deg(math.acos(mouseNor.Y))
		local desiredCF
		for i = 14, 8, -1.5 do
			if snapPoints then
				desiredCF = CFrame.new((camCF * CFrame.new(0, 0, -(i + extraPlaceDist))).Position)
			elseif benchInfo.RotateOnSurface then
				local function getRotationBetween(u, v, axis)
					local dot, uxv = u:Dot(v), u:Cross(v)
					if (dot < -0.99999) then return CFrame.fromAxisAngle(axis, math.pi) end
					return CFrame.new(0, 0, 0, uxv.x, uxv.y, uxv.z, 1 + dot)
				end
				
				local testCF = CFrame.new(mousePos, mousePos + Vector3.new(0, 1, 0))
				local rotateToFloorCFrame = getRotationBetween(testCF.UpVector, mouseNor, Vector3.new(1, 0, 0))
				local goalCF = rotateToFloorCFrame * testCF
				desiredCF = (goalCF.Rotation + testCF.Position) * CFrame.Angles(math.rad(90), 0, 0)
			else
				desiredCF = CFrame.new(mousePos, mousePos + Vector3.new(0, 1, 0))
			end
			if doCheck and snapPoints then
				local closest, closestDist, closestTable
				for from, snapTable in pairs(snaps) do
					for snapIndex, snapOffset in pairs(snapTable) do
						local isWithin, squaredDist = NumberUtil:IsWithin(desiredCF.Position, snapOffset.Position, 4)
						if not isWithin then continue end
						local dist = math.sqrt(squaredDist)
						if closestDist and dist > closestDist then continue end
						closestDist = dist
						closestTable = {
							Index = snapIndex,
							Offset = snapOffset
						}
						closest = from
					end
				end
				if closest then
					snappedBench = closest
					snappedTable = closestTable
					break
				else
					snappedBench = nil
					snappedTable = {}
					if i ~= 8 then continue end
					desiredCF = CFrame.new((camCF * CFrame.new(0, 0, -(14 + extraPlaceDist))).Position)
				end
			else
				break
			end
		end
		local isSnapped = false
		if snappedBench and snappedBench.Parent and snappedTable.Offset then
			isSnapped = true
			desiredCF = snappedTable.Offset
		end
		desiredCF *= benchInfo.Offset
		local r1, r2, r3 = ((benchInfo.FaceCamera and not isSnapped) and CFrame.new(desiredCF.Position, Vector3.new(primPos.X, desiredCF.Position.Y, primPos.Z)) or CFrame.new()):ToEulerAnglesXYZ()
		desiredCF *= CFrame.Angles(r1, r2, r3) * (((snapPoints ~= nil and not isSnapped) or (snapPoints == nil and not mouseHit)) and benchInfo.UnsnappedOffset or CFrame.new())
		local finalCF = lastCF
		local extraOffset = placeOffset:Lerp(CFrame.new(), ((isSnapped and benchInfo.RotateOffset == CFrame.Angles(0, math.rad(90), 0)) and 0.5 or 0)) -- TODO another aids fix
		desiredCF *= extraOffset
		if not finalCF then
			local curCF = desiredCF
			faceAway = false
			if isSnapped and rotFaceAway then
				local dirUnit = (primPos - curCF.Position).Unit
				local lookAngle = dirUnit:Dot(curCF.LookVector)
				if lookAngle < 0 then
					curCF *= rotFaceAway
					faceAway = true
				end
			end
			finalCF = curCF * (isSnapped and extraOffset or CFrame.new())
		end
		local oldHitboxCF = hitboxModel.PrimaryPart.CFrame
		local changedHitboxCF = false
		hitboxModel:SetPrimaryPartCFrame(finalCF)
		if doCheck then
			canBag = true
			local beds = shared.Beds
			if beds and benchInfo.Type == "Bed" then
				for _, bed in pairs(beds) do
					local bedPos = Vector3.new(bed.Position.X, finalCF.Position.Y, bed.Position.Z)
					if NumberUtil:IsWithin(finalCF.Position, bedPos, 150) then
						canBag = false
						break
					end
				end
			end
			local placeAvailable = benchInfo.PlacingFunc(benchName, mouseHit, placeAngle, mouseHit)
			local doNonBase = ((benchName == "Foundation" or benchName == "Triangle Foundation") and not isSnapped)
			lastCollisionCheck = tick()
			local passedCollisions = benchInfo.CollisionFunc(hitboxModel, doNonBase)
			canPlace = (placeAvailable and passedCollisions)
			if canPlace then
				--print("can current place")
				lastAvailableCF = desiredCF
				lastAvailableHit = mouseHit
			end
			if (canPlace == false and lastAvailableCF and lastAvailableHit and lastAvailableHit.Parent) then
				--print("can't place, checking last available position")
				if not lastCF then
					--print("snapping quickly")
					lastCollisionCheck = 0
				end
				lastCF = lastAvailableCF
				if not NumberUtil:IsWithin(lastCF.Position, desiredCF.Position, 0.4) then
					--print("too far from original pos, resetting")
					lastAvailableCF = nil
					lastAvailableHit = nil
					lastCF = nil
				end
			end
			if lastCF then
				changedHitboxCF = true
				--print("check")
				hitboxModel:SetPrimaryPartCFrame(desiredCF)
				local newCanPlace = (placeAvailable and benchInfo.CollisionFunc(hitboxModel, doNonBase))
				if newCanPlace then
					--print("new pos available, snapping back to it")
					lastAvailableCF = desiredCF
					lastAvailableHit = mouseHit
					lastCF = nil
					finalCF = desiredCF
					canPlace = true
				elseif passedCollisions then
					--print("last pos available")
					canPlace = true
				end
			end
			if benchInfo.SnapOnly and canPlace then
				canPlace = isSnapped
			end
			if canPlace and maxPerBase and lastAvailableHit and not isSnapped then
				local baseOn = lastAvailableHit:FindFirstAncestor("Base")
				if baseOn then
					local folderOn = baseOn:FindFirstChild(benchName)
					canPlace = (folderOn == nil or #folderOn:GetChildren() < maxPerBase)
				end
			end
			hasCabinetAccess = nil
			if canPlace then
				if benchName == "Base Cabinet" then
					local privHit = RaycastUtil:Raycast(Vector3.new(finalCF.Position.X, 225.6, finalCF.Position.Z), Vector3.new(0, -0.2, 0), "Blacklist", {VFX_PARTS}, false, RaycastUtil:FilterFunction("BuildingPrivCheck"))
					canPlace = (privHit == nil)
				else
					local baseCabinet = RaycastUtil:GetBaseCabinetUnder(finalCF.Position, benchInfo.IgnoreBuildBlock)
					if baseCabinet and baseCabinet:GetAttribute("Monument") then
						hasCabinetAccess = false
					elseif benchInfo.IgnoreBuildBlock then
						hasCabinetAccess = nil
					else
						local cabinetInfo = shared.ActiveBenches[baseCabinet]
						if cabinetInfo then
							hasCabinetAccess = cabinetInfo.Access
						end
					end
					canPlace = (hasCabinetAccess ~= false)
				end
			end
		end
		currentModel:SetPrimaryPartCFrame(finalCF)
		for _, part in pairs(currentModel:GetDescendants()) do
			if not (part:IsA("BasePart") and part.Parent:IsA("Model")) then continue end
			part.Color = script:GetAttribute(canPlace and ((hasCabinetAccess == false or not canBag) and "PlaceBlockedColor" or "PlaceAvailableColor") or "PlaceUnavailableColor")
		end
		if not changedHitboxCF then
			hitboxModel:SetPrimaryPartCFrame(oldHitboxCF)
		end
		if lastSnapUpdate and not NumberUtil:IsWithin(primPos, lastSnapUpdate, 75) then
			UpdateSnaps()
		end
	end)
end

local function RotateFunc()
	if not benchInfo then return end
	placeOffset *= benchInfo.RotateOffset
	offsetAmounts += 1
	--[[lastAvailableCF = nil
	lastAvailableHit = nil]]
end

local function MouseButton2DownFunc()
	if InventoryController:GetAttribute("Open") then return end
	local equipped = GetEquipped(EquipController:GetAttribute("Equipped"))
	if equipped then
		local invInfo = InventoryController.Fetch:Invoke()
		local itemAmounts = {}
		for _, containerName in pairs({"Inventory", "Toolbar"}) do
			local container = invInfo[containerName]
			for _, item in pairs(container) do
				if item == 0 then continue end
				if not itemAmounts[item.ID] then
					itemAmounts[item.ID] = 0
				end
				itemAmounts[item.ID] += item.Amount
			end
		end
		if equipped.ID == 30 then
			local wheelInfos = BasePartInfo:Fetch()
			for _, wheelInfo in pairs(wheelInfos) do
				local na = wheelInfo.Name:gsub(" ", "_"):gsub("-", "_")
				wheelInfo.Image = script:GetAttribute("Build"..na)
				local recipe = RecipeModule:FetchRecipe("Twig", wheelInfo.Name)
				if not recipe then continue end
				local cost = recipe.Costs[1]
				if not cost then continue end
				local costInfo = Items[cost.ID]
				wheelInfo.Selectable = true
				wheelInfo.SelectFirst = (basePartSelected == wheelInfo.Name)
				wheelInfo.Cost = NumberUtil:FormatNumber(cost.Amount).." "..costInfo.Name.." ("..NumberUtil:FormatNumber(itemAmounts[cost.ID] or 0).." Left)"
			end
			local chosenIndex = WheelController.Open:Invoke(wheelInfos, "Blueprint", false)
			if not chosenIndex then return end
			local chosen = wheelInfos[chosenIndex]
			if not chosen then return end
			basePartSelected = chosen.Name
			EquipBench(script:GetAttribute("Equipped"))
		elseif equipped.ID == 31 then
			local selected = InteractController.GetSelected:Invoke()
			if not (selected and selected.Parent) then return end
			local name = selected.Name
			if name == "Wall Block" then return end
			local selectedInfo = BenchInfo[name]
			local selectedMain = selected.PrimaryPart
			if not (selectedInfo and selectedMain) then return end
			local storagePart = Benches:FindFirstChild(name)
			if not (storagePart and storagePart:IsA("Model")) then return end
			local rotateOffset = selectedInfo.RotateOffset
			local serverTick = Values.ServerTick.Value
			local damageType = selected:GetAttribute("DamageType")
			local lastDamaged = selected:GetAttribute("LastDamaged")
			if serverTick - (lastDamaged or 0) < 60 then return end
			local baseCabinet = RaycastUtil:GetBaseCabinetUnder(selectedMain.Position)
			if baseCabinet and baseCabinet:GetAttribute("Monument") then return end
			local cabinetInfo = shared.ActiveBenches[baseCabinet]
			if cabinetInfo and cabinetInfo.Access == false then return end
			local wheelInfos = {
				[1] = {
					Image = script:GetAttribute("HammerWoodIcon");
					Name = "Upgrade to Wood";
					Description = "Cheap way to fortify your base. Vulnerable to fire attacks.";
				};
				[2] = {
					Image = script:GetAttribute("HammerStoneIcon");
					Name = "Upgrade to Stone";
					Description = "Hard and durable. Stronger than Wood.";
				};
				[3] = {
					Image = script:GetAttribute("HammerMetalIcon");
					Name = "Upgrade to Metal";
					Description = "Resistant to explosive attacks. Stronger than Stone.";
				};
				[4] = {
					Image = script:GetAttribute("HammerSteelIcon");
					Name = "Upgrade to Steel";
					Description = "Expensive but resilient material. Stronger than Metal.";
				};
				[5] = {
					Image = script:GetAttribute("HammerRotateIcon");
					Name = "Rotate";
					Description = "Flip any misplaced parts.";
				};
				[6] = {
					Image = script:GetAttribute("HammerDemolishIcon");
					Name = "Demolish";
					Description = "Get rid of selected base part.";
				};
			}
			for _, wheelInfo in pairs(wheelInfos) do
				local infoName = wheelInfo.Name
				if infoName:sub(1, 7) == "Upgrade" then
					local upgradeType = infoName:sub(12)
					local recipe = RecipeModule:FetchRecipe(upgradeType, name)
					if recipe then
						local cost = recipe.Costs[1]
						local costInfo = Items[cost.ID]
						wheelInfo.Cost = NumberUtil:FormatNumber(cost.Amount).." "..costInfo.Name.." ("..NumberUtil:FormatNumber(itemAmounts[cost.ID] or 0).." Left)"
					end
					wheelInfo.Selectable = (table.find(upgradeAvailability[damageType or "Twig"], upgradeType) ~= nil)
				else
					wheelInfo.Selectable = ((serverTick - (selected:GetAttribute(infoName == "Demolish" and "Placed" or "Upgraded") or serverTick - 0.01) < 600) and ((infoName == "Demolish" and cabinetInfo ~= nil and cabinetInfo.Access) or (infoName == "Rotate" and rotateOffset and rotateOffset ~= CFrame.new())))
				end
				wheelInfo.SelectFirst = false
			end
			local chosenIndex = WheelController.Open:Invoke(wheelInfos, "Hammer", true)
			if not chosenIndex then return end
			local chosen = wheelInfos[chosenIndex]
			if not chosen then return end
			VectorUtil:FireRemote(BuildRemotes, ChangeBaseRemote, {
				[1] = chosenIndex,
				[2] = (selected or "none")
			})
		end
	else
		RotateFunc()
	end
end

local function MouseButton2UpFunc()
	WheelController.Close:Invoke("Blueprint")
	WheelController.Close:Invoke("Hammer")
end

local function ConnectBench(bench)
	--print(bench)
	if not (bench and bench.Parent and bench:IsA("Model")) then return end
	bench:GetPropertyChangedSignal("PrimaryPart"):Connect(function()
		if not bench.PrimaryPart then return end
		UpdateSnaps()
	end)
	if not bench.PrimaryPart then return end
	UpdateSnaps()
	--[[local started = tick()
	while tick() - started >= 0.5 do
		if not (bench and bench.Parent) then return end
		local prim = bench.PrimaryPart
		if prim then break end
		Run.Heartbeat:Wait()
	end
	task.wait(0.1)
	--print(tick() - started, "time to load primpart")]]
	
end

local function ConnectBenchFolder(folder)
	--print(folder)
	if not folder:IsA("Folder") or not supportedSnapBenches[folder.Name] then return end
	folder.ChildAdded:Connect(ConnectBench)
	for _, bench in pairs(folder:GetChildren()) do
		ConnectBench(bench)
	end
end

local function ConnectBase(base)
	--print(base)
	if not (base:IsA("Folder") and base.Name == "Base") then return end
	base.ChildAdded:Connect(ConnectBenchFolder)
	for _, benchFolder in pairs(base:GetChildren()) do
		ConnectBenchFolder(benchFolder)
	end
end

-- Events
UserInput.InputBegan:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	local textBox = UserInput:GetFocusedTextBox()
	if textBox or notProcessed then return end
	if inputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		if key == Enum.KeyCode.R then
			RotateFunc()
		end
	elseif inputType == Enum.UserInputType.MouseButton1 then
		MouseButton1DownFunc()
	elseif inputType == Enum.UserInputType.MouseButton2 then 
		MouseButton2DownFunc()
	end
end)

UserInput.InputEnded:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	if inputType == Enum.UserInputType.MouseButton2 then 
		MouseButton2UpFunc()
	end
end)

Bases.ChildAdded:Connect(ConnectBase)
for _, base in pairs(Bases:GetChildren()) do
	ConnectBase(base)
end

-- Bindables
Equip.Event:Connect(function(...)
	local args = {...}
	local index = args[1]
	if index and index > 0 then
		--print("opening viewmodel", index)
		EquipBench(...)
	else
		--print("closing viewmodel")
		WheelController.Close:Invoke("Blueprint")
		WheelController.Close:Invoke("Hammer")
		if basePartSelected ~= snapBenchSelected then
			snapBenchSelected = nil
		end
		CloseBench()
	end
end)

-- Remotes
VectorUtil:SetupRemote(BuildRemotes, PlaceRemote, function(typ, ...)
	local args = {...}
	if typ == "UpdateSnaps" then
		
		local updates = args[1]
		local amount = args[2]
		UpdateSnaps(true)--#updates == amount and updates)
	end
end)

-- Go through every available benchinfo to see which ones support snapping
for _, benchInfo in pairs(BenchInfo) do
	local snapPoints = benchInfo.SnapPoints
	if not snapPoints then continue end
	for _, snapPoint in pairs(snapPoints) do
		local benchNames = snapPoint.BenchNames
		if not benchNames then continue end
		for _, benchName in pairs(benchNames) do
			supportedSnapBenches[benchName] = true
		end
	end
end

-- Cleanup any leftover build parts
VFX_BENCHES:ClearAllChildren()

--print(supportedSnapBenches)