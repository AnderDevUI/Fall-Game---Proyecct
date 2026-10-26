-- [PATH] ServerStorage / Modules / FallenGuard @Type ModuleScript
--[[
FallenGuard
by ChickenBagelz
January 27, 2023
Protected class responsible for holding any important anticheat information about a player and checking for exploits on the server.
]]
-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local Run = game:GetService("RunService")
local ServerScripts = game:GetService("ServerScriptService")
-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")
-- Folders
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local VFX_PARTS = workspace:WaitForChild("VFX")
local Drops = workspace:WaitForChild("Drops")
local Animals = workspace:WaitForChild("Animals")
local Plants = workspace:WaitForChild("Plants")
-- Objects
local Terrain = workspace:WaitForChild("Terrain")
-- Modules
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local DamageModule = require(ServerModules:WaitForChild("DamageModule"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
-- Local Variables
local integrityProps = {"Position", "AssemblyLinearVelocity", "AssemblyAngularVelocity"}
local flyStep = 1/10
local viewFilterFunc = RaycastUtil:FilterFunction("View")
local blacklistParts = {
	-- Bunker
	["Meshes/Door_Cube.005"] = true;
	["Meshes/arch_Cube.014"] = true;
	["Meshes/Modular Shaft_Cube.003"] = true;
	["Meshes/FallenShippingContainer_Cube.001"] = true;
	["Meshes/intersections_Cube.008"] = true;
	-- Submarine
	["SubmarineCollision"] = true;
	["SubmarineSupportPosts"] = true;
	["SubmarineHeadBumpPrevention"] = true;
	["Meshes/Computer_low_ComputerBot_low"] = true;
	["Meshes/FallenSubmarineShell_Cylinder.004"] = true;
	["Meshes/FallenSubmarineShell_Cylinder.029"] = true;
	["Meshes/FallenSubmarineShell_Cylinder"] = true;
}
local attributes = {
	SpeedCheckMaxAllowedDistMult = false;
	ServerLoadPercentageDivider = false;
	StrengthenedNoclipCheckDuration = false;
	ShowNoclipRays = false;
	UpwardsMaxAllowedDistance = false;
	NoclipSnapBackDistSubtract = false;
	CFrameHistoryMaxSize = false;
}
-- Local Functions
local noclipFunc = function(h)
	if h.Name == "PRESPAWNBLOCK" then return end
	local filter = viewFilterFunc(h)
	if filter then
		return filter
	end
	local parent = h.Parent
	if h.CollisionGroup == "Items" or not h.CanCollide or blacklistParts[h.Name] then
		return h
	elseif parent and parent:GetAttribute("Moving") == true then
		return parent
	elseif parent.Parent and parent.Parent:GetAttribute("Moving") == true then
		--print("hit opening part")
		return parent.Parent
	end
end
local groundFunc = function(h)
	if h.CollisionGroup == "Items" or not h.CanCollide then
		return h
	end
end
local FallenGuard = {}
FallenGuard.__index = FallenGuard
function FallenGuard.new(player)
	local self = setmetatable({}, FallenGuard)
	self.Player = player
	self.RemoteInfos = {}
	self.DoingRemoteFlag = false
	self.LastRemoteFlag = 0
	self.FallDamageEnabled = true
	self.LastNoclipChecked = false
	self.JumpThreads = {}
	self.MovementDetections = {
		Flyhack = 0;
		Speedhack = 0;
		Noclip = 0;
	}
	self:RefreshMoveStates()
	self:RefreshFlyTable()
	self:RefreshClientToServerTable()
	self:SetMovementChecks(true)
	return self
end
function FallenGuard:EnableFly()
	local player = self.Player
	local flyTable = self.Fly
	flyTable.Enabled = true
	self:SetMovementChecks(false)
	if not flyTable.Connection then
		flyTable.Connection = Run.Stepped:Connect(function(_, step)
			local did = false
			repeat
				local character = player.Character
				if not character then continue end
				local prim = character.PrimaryPart
				local humanoid = character:FindFirstChild("Humanoid")
				if not (prim and humanoid and humanoid.Health > 0) then continue end
				prim.Anchored = true
				local offset = CFrame.new(flyTable.MoveVector * step * 30)
				flyTable.Offset = flyTable.Offset:Lerp(offset, step * 20)
				local r1, r2, r3 = flyTable.Rotation:ToEulerAnglesXYZ()
				local newCF = CFrame.new(prim.Position) * CFrame.Angles(r1, r2, r3) * flyTable.Offset
				character:SetPrimaryPartCFrame(newCF)
				--self:UpdateRoundedPos(prim, newCF.Position)
				did = true
			until true
			if did then return end
			self:DisableFly()
		end)
	end
end
function FallenGuard:DisableFly()
	local player = self.Player
	local flyTable = self.Fly
	self:SetMovementChecks(true)
	local connection = flyTable.Connection
	if connection then
		connection:Disconnect()
		flyTable.Connection = nil
	end
	self:RefreshFlyTable()
	local character = player.Character
	if not character then return end
	local prim = character.PrimaryPart
	if not prim then return end
	prim.Anchored = false
end
function FallenGuard:ToggleFly()
	local player = self.Player
	local flyTable = self.Fly
	local flying = (not flyTable.Enabled)
	if flying then
		self:EnableFly()
	else
		self:DisableFly()
	end
	return flying
end
function FallenGuard:ChangeFlyDirection(moveVector, rotation)
	local flyTable = self.Fly
	if not flyTable.Enabled then return end
	flyTable.MoveVector = moveVector
	flyTable.Rotation = rotation
end
function FallenGuard:DoLoopChecks(setTick, character, rootPart, hum, user)
	local serverChecks = self.ClientToServerChecks
	if setTick then --
		serverChecks.LastFired = tick()
	end
	local didBan = self:CheckThreshold("LOOP")
	if didBan then return true end
	didBan = self:CheckMovementDetections()
	if didBan then return true end
	if character and hum then
		didBan = self:CheckAnims(user, character, hum)
		if didBan then return true end
	end
	if rootPart then
		return self:CheckRootPartIntegrity(character, rootPart)
	end
end
function FallenGuard:CalculateSnapback(character, firstCF)
	local chosenCF
	local lastCFrameHistory = self.LastCFrameHistory
	local maxNum = #lastCFrameHistory + 1
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = {VFX_PARTS, character, Drops, Animals, Plants}
	--print("snapback detected", lastCFrameHistory, maxNum)
	for index = maxNum, 1, -1 do
		local isFirst = (index == maxNum)
		local checkCF = (isFirst and firstCF or lastCFrameHistory[index])
		local parts = workspace:GetPartBoundsInBox(checkCF, Vector3.new(1, 2.1, 1), overlapParams)
		local isObstructed = nil
		for index, part in pairs(parts) do
			if noclipFunc(part) then
				print("added to filter", part)
				overlapParams:AddToFilter(part)
				continue
			end
			isObstructed = part
			break
		end
		if isObstructed then
			print((isFirst and "first" or index), "is obstructed by", isObstructed:GetFullName())
			if not isFirst then
				table.remove(lastCFrameHistory, index)
			end
			continue
		end
		chosenCF = checkCF
		--print("chose", (isFirst and "first" or index))
		break
	end
	if chosenCF then
		return chosenCF
	else
		warn(> [WARNING] {self.Player.Name} WAS UNABLE TO BE SNAPPED IN ANY LOCATION - DISCARDING SNAPBACK)
	end
end
function FallenGuard:MovementCheck(step, doSpeedCheck, user, character, humanoid, primPart)
	local player = self.Player
	local userStats = user.UserStats
	local moveDetects = self.MovementDetections
	local lastCF = self.LastCFrame
	local noclipChecked = self.LastNoclipChecked
	local desiredSnapBack = self.DesiredSnapBack
	local lastCFrameHistory = self.LastCFrameHistory
	local primCF = primPart.CFrame
	local detection = ""
	--local detectionLoopDuration = attributes["StrengthenedNoclipCheckDuration"]
	local changeCF = false
	if desiredSnapBack then
		self.DesiredSnapBack = nil
		primCF = desiredSnapBack
		changeCF = true
	end
	if self.MovementChecksEnabled and self.Spawned and lastCF and primCF.Position ~= lastCF.Position then
		local showNoclipRay = (attributes["ShowNoclipRays"] and "GreenRay")
		if doSpeedCheck then
			local moveStates = self.MoveStates
			local heightDist = primCF.Position.Y - lastCF.Position.Y
			local maxAllowedHeight = attributes["UpwardsMaxAllowedDistance"]
--[[if self.FirstGrounded and heightDist > 0.01 then
self.FirstGrounded = false
end]]
			if heightDist > maxAllowedHeight then
				local heightDiff = heightDist - maxAllowedHeight
				print(">", player.Name, "GOING UPWARDS TOO FAST - SNAPPING BACK (HEIGHT DIFF: "..heightDiff..")")
				local t = tick()
				self.LastSnapBack = t
				moveDetects.Flyhack += 1
				if t - self.LastFlyHack > 0.05 then
					primCF = primCF + Vector3.new(0, -heightDiff, 0)
					changeCF = true
				end
			end
			local primPos = Vector2.new(primCF.Position.X, primCF.Position.Z)
			local lastPos = Vector2.new(lastCF.Position.X, lastCF.Position.Z)
			local moveDist = (primPos - lastPos).Magnitude
			userStats:GetStats("General").StudsWalked += moveDist
--[[local newWalkSpeed = (((moveStates.Swimming or moveStates.StatSwimming) and moveStates.Grounded) and 20 or (moveStates.Crouching and 11 or (moveStates.Sprinting and 18 or 11)))
local walkSpeed = self.DesiredWalkSpeed
if newWalkSpeed >= walkSpeed then
walkSpeed = newWalkSpeed
self.SameWalkSpeedCount = 0
else
self.SameWalkSpeedCount += 1
if self.SameWalkSpeedCount >= 10 then
walkSpeed = newWalkSpeed
self.SameWalkSpeedCount = 0
end
end
self.DesiredWalkSpeed = walkSpeed]]
			local walkSpeed = 18
			local serverLoadMult = self:GetServerLoadMultiplier()
			local playerPing = math.min(player:GetNetworkPing() * 1.25, 0.5)
			local maxAllowedDist = walkSpeed * step * (serverLoadMult + playerPing)
			if moveDist > maxAllowedDist then
				print(">", player.Name, "MOVING TOO FAST - SNAPPING BACK (SPEED DIFF: "..moveDist - maxAllowedDist..")", walkSpeed, step, serverLoadMult, playerPing)
				local rot1, rot2, rot3 = primCF:ToEulerAnglesXYZ()
				local snappedCF = CFrame.new(Vector3.new(lastPos.X, 0, lastPos.Y), Vector3.new(primPos.X, 0, primPos.Y)) * CFrame.new(0, 0, -maxAllowedDist)
				local fixedCF = CFrame.new(Vector3.new(snappedCF.Position.X, primCF.Position.Y, snappedCF.Position.Z)) * CFrame.Angles(rot1, rot2, rot3)
				self.LastSnapBack = tick()
				moveDetects.Speedhack += 1
				primCF = fixedCF
				changeCF = true
			end
		end
		if not (noclipChecked and doSpeedCheck) then
			local primSize = primPart.Size
			local closestHitDist
			local closestHit
			for i = -1, 1, 2 do
				local offset = CFrame.new(primSize.X * 0.2 * i, primSize.Y * 0.4 * i, primSize.Z * 0.2 * i)
				local origin = (lastCF * offset).Position
				local target = (primCF * offset).Position
				local hit, pos = RaycastUtil:Raycast(origin, target - origin, "Blacklist", {VFX_PARTS, character, Drops, Animals, Plants}, showNoclipRay, noclipFunc, true)
				if not hit then continue end
				local dist = (lastCF.Position - pos).Magnitude
				if closestHitDist and dist > closestHitDist then continue end
				closestHit = hit
				closestHitDist = dist
			end
			if closestHitDist then
--[[if not noclipChecked then
self.LastNoclipChecked = true
task.spawn(function()
local noDetectionCount = 0
while noDetectionCount < detectionLoopDuration do
print("loop running", noDetectionCount)
local passed = task.wait(0.05)
local state = self:MovementCheck(passed, false, character, humanoid)
if not state then break end
if state == "Noclip" then
noDetectionCount = 0
continue
end
noDetectionCount += passed
end
print("loop finished")
self.LastNoclipChecked = false
end)
end]]
				detection = "Noclip"
				closestHitDist = math.max(closestHitDist - attributes["NoclipSnapBackDistSubtract"], 0)
				if closestHitDist > 0 then
					local rot1, rot2, rot3 = lastCF:ToEulerAnglesXYZ()
					local unobstructedCF = CFrame.new((CFrame.new(lastCF.Position, primCF.Position) * CFrame.new(0, 0, -closestHitDist)).Position) * CFrame.Angles(rot1, rot2, rot3)
					primCF = unobstructedCF
				else
--[[if closestHit and closestHit.Parent then
local benchModel = closestHit.Parent
if not benchModel.Name:find("Jail ") then
benchModel = benchModel.Parent
end
if benchModel.Name:find("Jail ") then
local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Include
--overlapParams.FilterDescendantsInstances = {VFX_PARTS, character, Drops, Animals, Plants}
overlapParams.FilterDescendantsInstances = {benchModel}
local parts = workspace:GetPartBoundsInBox(lastCF, Vector3.new(0.1, 2, 0.1), overlapParams)
for index, part in pairs(parts) do
if (not part.CanCollide) or viewFilterFunc(part) then
if index == #parts then
self.BenchStuckOn = nil
end
continue
end
if self.BenchStuckOn ~= benchModel or tick() - (self.LastBenchStuck or 0) >= 0.4 then
self.BenchStuckCount = 0
self.BenchStuckOn = benchModel
end
self.BenchStuckCount += 1
self.LastBenchStuck = tick()
if self.BenchStuckCount >= 6 then
self.BenchStuckOn = nil
warn(">", player.Name, "POSSIBLY STUCK INSIDE AN OPENABLE BENCH - CANCELLING NOCLIP SNAPBACK", part:GetFullName())
self.LastCFrame = primCF
return ""
end
break
end
end
end]]
					primCF = lastCF
				end
				print(">", player.Name, "POSSIBLE NOCLIP DETECTED - SNAPPING BACK (DISTANCE SNAP BACK: "..closestHitDist..")")
				changeCF = true
				self.LastSnapBack = tick()
				moveDetects.Noclip += 1
			end
		end
	end
	if changeCF then
		primPart.AssemblyLinearVelocity = Vector3.new()
		primPart.AssemblyAngularVelocity = Vector3.new()
		local chosenCF = self:CalculateSnapback(character, primCF)
		if chosenCF then
			primCF = chosenCF
			character:PivotTo(primCF)
		end
--[[elseif not ignorePosChange then
self.LastCFrame = primCF]]
	else
		local maxSize = attributes["CFrameHistoryMaxSize"]
		local lastHistoryCF = lastCFrameHistory[#lastCFrameHistory]
		local didReplace = false
		if lastHistoryCF and #lastCFrameHistory >= maxSize / 2 then
			local isWithin = NumberUtil:IsWithin(lastHistoryCF.Position, primCF.Position, 0.4)
			if isWithin then
				lastCFrameHistory[#lastCFrameHistory] = primCF
				didReplace = true
				--print("replacing last cframe in history with new one", lastCFrameHistory)
			end
		end
		if not didReplace then
			table.insert(lastCFrameHistory, primCF)
			if #lastCFrameHistory > maxSize then
				table.remove(lastCFrameHistory, 1)
--[[print("adding new cframe to history [FULL]", lastCFrameHistory)
else
print("adding new cframe to history", lastCFrameHistory)]]
			end
		end
	end
	self.LastCFrame = primCF
	--print(primCF)
	return detection
end
function FallenGuard:CheckForClimbing(humanoid, primCF)
	local curState = humanoid:GetState()
	--print(curState.Name)
	if curState == Enum.HumanoidStateType.Climbing then-- or curState == Enum.HumanoidStateType.Freefall then
		local climbPart = RaycastUtil:Raycast(primCF.Position - Vector3.new(0, 2.5, 0), primCF.LookVector * 3.5, "Blacklist", {VFX_PARTS, humanoid.Parent, Terrain, Drops, Animals, Plants}, false, nil, true)
		if climbPart and (climbPart:IsA("TrussPart") or climbPart.Parent.Name == "Hatch" or climbPart.Parent.Name == "Ladder" or climbPart.Name == "ClimbPart") then
			--print(humanoid.Parent.Name, "flyhack detected but properly climbing")
			return true
			--isGrounded = true
		end
	end
end
function FallenGuard:FlyChecks(user, useBlockcast, flyhackDetectionThreshold, detectThresholdFlyhack)
	local humanoid = user.Humanoid
	local head = user.Head
	if not (humanoid and humanoid.Parent and humanoid.Health > 0 and head and head.Parent) then return end
	local character = humanoid.Parent
	if not character then return end
	local primPart = character.PrimaryPart
	if not primPart then return end
	local moveDetects = self.MovementDetections
	local primCF = primPart.CFrame
	local lastCF = self.LastCFrame
	local moveStates = self.MoveStates
	local fly = self.Fly
	local isGrounded = false
	if lastCF then
		if useBlockcast then
			local floorParams = RaycastParams.new()
			floorParams.FilterType = Enum.RaycastFilterType.Exclude
			floorParams.FilterDescendantsInstances = {VFX_PARTS, character, Drops, Animals, Plants}
			local floorResults = workspace:Blockcast(primCF * CFrame.new(0, -1.5, 0), Vector3.new(2, 0, 2), Vector3.new(0, -2.5, 0), floorParams)
			isGrounded = (floorResults ~= nil and floorResults.Instance ~= nil)
		else
			local origin = primPart.Position - Vector3.new(0, 1.5, 0)
			local floorPart = RaycastUtil:Raycast(origin, Vector3.new(0, -2.5, 0), "Blacklist", {VFX_PARTS, character, Drops, Animals, Plants}, nil, (not self.FirstGrounded and viewFilterFunc), true)
			isGrounded = (floorPart ~= nil)
			if not isGrounded then
				--print("doing floormaterial check")
				local floorMaterial = humanoid.FloorMaterial
				isGrounded = (floorMaterial ~= nil and floorMaterial ~= Enum.Material.Air and self.FirstGrounded)
			end
		end
		if self.FirstGrounded then
			if not isGrounded then
				--print("player in air, doing check")
				isGrounded = self:CheckForClimbing(humanoid, primCF)
			end
			if (not isGrounded) and (moveStates.Swimming or moveStates.StatSwimming) then
				--print("swimming")
				isGrounded = self:CheckForWater(head)
			end
		end
		if isGrounded ~= moveStates.Grounded and self.FirstGrounded and self.Spawned and not isGrounded then
			--print("grounded changed", isGrounded)
			self.JumpId = (self.JumpId >= 100 and 0 or self.JumpId + 1)
			local currentId = self.JumpId
			--print(currentId)
			local started = 0
			local lastDiff = 0
			local diffThreshold = 0.05
			local diffThresholdChange = 0
			local flyhackDetections = 0
			local jumpThread; jumpThread = task.defer(function()
				local firstSavedCF = lastCF
				local curDetects = 0
				local highestY
				while curDetects < detectThresholdFlyhack do
					local passed = task.wait(flyStep)
					if not (humanoid.Health > 0 and character.Parent) then break end
					local prim = character.PrimaryPart
					if not prim then break end
					local priCF = prim.CFrame
					local posY = priCF.Position.Y
					local landed = (self.JumpId ~= currentId or self.MoveStates.Grounded)
					if self.FallDamageEnabled and not fly.Enabled then
						highestY = (highestY and math.max(highestY, posY) or posY)
						--print(highestY)
						if landed then
							local heightDiff = highestY - posY
							local fallDamage = math.max(heightDiff - 15, 0) * 2.2
							if fallDamage > 0 and not (self:CheckForWater(head) or self:CheckForClimbing(humanoid, priCF)) then
								--print(player, "TOOK", fallDamage, "FALL DAMAGE")
								prim.Crunch:Play()
								DamageModule:Damage(character:FindFirstChild("UpperTorso"), Vector3.new(), Vector3.new(), nil, {
									Chest = fallDamage;
									Bleed = 1 + math.ceil(fallDamage / 9);
								}, {Start = 1000, End = 1000}, nil, nil, "Fall Damage")
							end
							break
						end
					elseif landed then
						break
					end
					if self.MovementChecksEnabled and (not fly.Enabled) and (not fly.LandQueued) then
						started += passed
						local serverLoadMult = self:GetServerLoadMultiplier()
						if started >= 0.27 * serverLoadMult then
							local diff = firstSavedCF.Position.Y - posY
							local deltaTime = passed / flyStep
							diffThresholdChange = math.min(diffThresholdChange + 0.0005, 0.01)
							diffThreshold -= diffThresholdChange / serverLoadMult / deltaTime
							local change = lastDiff - diff
							--print(math.ceil(change * 1000) / 1000, diffThreshold)
							if diffThreshold < 0 and change >= diffThreshold then
								flyhackDetections += 1
								if flyhackDetections >= flyhackDetectionThreshold then
									print(">", character.Name, "FLYHACK DETECTED, SNAPPING BACK (HEIGHT THRESHOLD: "..diffThreshold..") (ACTUAL HEIGHT: "..change..")")
									--self.DesiredSnapBack = lastCF
									moveDetects.Flyhack += 1
									curDetects += 1
									self.LastSnapBack = tick()
									self.LastFlyHack = tick()
									local chosenCF = self:CalculateSnapback(character, lastCF)
									if chosenCF then
										local landHit, landPos = RaycastUtil:Raycast({CF = chosenCF, Size = Vector3.new(2, 0, 2), Type = "Block"}, Vector3.new(0, -1023, 0), "Exclude", {character, VFX_PARTS, Animals, Drops, Plants}, false, groundFunc, true)
										--print(landHit)
										local groundedCF = chosenCF - (chosenCF.Position - landPos) + Vector3.new(0, 2.5, 0)
										self.LastCFrame = groundedCF
										character:PivotTo(groundedCF)
										flyhackDetections = 0
--[[if landHit then
break
end]]
									else
										break
									end
									--break
--[[else
print(">", player.Name, "POSSIBLE FLYHACK DETECTION FIRE (HEIGHT THRESHOLD: "..diffThreshold..") (ACTUAL HEIGHT: "..change..")")]]
								end
							end
							lastDiff = diff
						end
					end
				end
				local threadIndex = table.find(self.JumpThreads, jumpThread)
				if not threadIndex then return end
				table.remove(self.JumpThreads, threadIndex)
			end)
			table.insert(self.JumpThreads, jumpThread)
		end
	end
	moveStates.Grounded = isGrounded
	if isGrounded then
		self.FirstGrounded = true
		fly.LandQueued = false
	elseif fly.Enabled then
		fly.LandQueued = true
	end
	return character, humanoid, primPart
end
function FallenGuard:GetServerLoadMultiplier()
	return attributes["SpeedCheckMaxAllowedDistMult"] * (1 + ServerService:GetAttribute("ServerCPULoad") / attributes["ServerLoadPercentageDivider"])
end
function FallenGuard:CheckForWater(head)
	local headPos = head.Position
	local headSize = head.Size / 2
	local regStart = headPos - headSize - Vector3.new(0, 4.1, 0)
	local regEnd = headPos + headSize
	local region = Region3.new(regStart, regEnd):ExpandToGrid(4)
	local materials = Terrain:ReadVoxels(region, 4)
	for _, x in pairs(materials) do
		if type(x) ~= "table" then continue end
		for _, y in pairs(x) do
			for _, material in pairs(y) do
				if material ~= Enum.Material.Water then continue end
				return true
			end
		end
	end
	return false
end
function FallenGuard:CheckMovementDetections()
	local player = self.Player
	local moveDetects = self.MovementDetections
	for detection, detects in pairs(moveDetects) do
		if detects < script:GetAttribute("DetectionThreshold"..detection) then continue end
		local speedhacks = moveDetects.Speedhack
		local noclips = moveDetects.Noclip
		local flyhacks = moveDetects.Flyhack
		local highestName = ""
		local highestAmount = 0
		for detection, detects in pairs(moveDetects) do
			moveDetects[detection] = 0
			if highestName == "" or detects > highestAmount then
				highestName = detection
				highestAmount = detects
			end
		end
		task.defer(function()
			ModUtil:BanPlayer(player.Name, "108", nil, speedhacks, noclips, flyhacks)
		end)
		return true
	end
	for detection, detects in pairs(moveDetects) do
		moveDetects[detection] = 0
	end
end
function FallenGuard:AddServerCheck(firedTick, amountExtraTicks)
	local serverChecks = self.ClientToServerChecks
	serverChecks.LastFired = tick()
	if math.abs(serverChecks.LastTick - firedTick) <= 5 then
		serverChecks.SimilarTicksCount += 1
		self:CheckThreshold("UNCHANGED_TICK")
	else
		serverChecks.SimilarTicksCount = 0
	end
	if serverChecks.LastExtraTicks == amountExtraTicks then
		serverChecks.SimilarExtraTicksCount += 1
		self:CheckThreshold("EQ_TICK_EXTRA")
	else
		serverChecks.SimilarExtraTicksCount = 0
	end
	serverChecks.LastExtraTicks = amountExtraTicks
	serverChecks.LastTick = firedTick
end
function FallenGuard:CheckThreshold(extra)
	local serverChecks = self.ClientToServerChecks
	local player = self.Player
	local current = tick()
	local countCheck = (serverChecks.SimilarTicksCount >= 3)
	local extraTicksCheck = (serverChecks.SimilarExtraTicksCount >= 20)
	local tickDifference = current - serverChecks.LastFired
	--print(serverChecks)
	--print(tickDifference)
	if countCheck or extraTicksCheck then
		task.defer(function()
			self:RefreshClientToServerTable()
			ModUtil:BanPlayer(player.Name, (countCheck and "054" or "067"), nil, serverChecks[countCheck and "LastTick" or "LastExtraTicks"])
		end)
		return true
	elseif tickDifference > 60 then
		local user = shared.Users[player]
		if not (user.ClientLoaded and tick() - (user.LastSoundPlayed or 0) <= 2) then return end
		task.defer(function()
			self:RefreshClientToServerTable()
			ModUtil:BanPlayer(player.Name, "055", nil, extra..math.ceil(tickDifference))
		end)
		return true
	end
end
function FallenGuard:CheckAnims(user, character, humanoid)
	local moveStates = self.MoveStates
	moveStates.Crouching = false
	moveStates.Sprinting = false
	moveStates.Swimming = false
	local ranBan = false
	for _, anim in pairs(humanoid:GetPlayingAnimationTracks()) do
		local animation = anim.Animation
		--print(animation.AnimationId, animation.AnimationId ~= "rbxassetid://12295196614")
		if animation == nil then continue end
		local animId = animation.AnimationId
		if animId == "rbxassetid://12295196614" and not ranBan then
			ranBan = true
			if ModUtil:HasSpecialPrivileges(user.UserId) ~= "Owner" and not user.Banned then
				task.defer(function()
					ModUtil:BanPlayer(self.Player.Name, "056", nil)
				end)
			end
		elseif animId == "rbxassetid://2904653470" then
			moveStates.Crouching = true
		elseif animId == "rbxassetid://10976869491" or animId == "rbxassetid://2128761345" or animId == "rbxassetid://2128762025" then
			moveStates.Sprinting = true
		elseif animId == "rbxassetid://913384386" or animId == "rbxassetid://913389285" then
			moveStates.Swimming = true
		end
	end
	return ranBan
end
function FallenGuard:CheckRootPartIntegrity(character, rootPart)
	local doBan = false
	for _, prop in pairs(integrityProps) do
		local value = rootPart[prop]
		local t = {value.X, value.Y, value.Z}
		for index, num in pairs(t) do
			if ModUtil:IsRealNumber(num) then continue end
			t[index] = 0
			if doBan ~= false then continue end
			doBan = true
		end
		if doBan == true then
			doBan = "Banned"
			if prop == "Position" and self.LastCFrame then
				character:PivotTo(self.LastCFrame)
			else
				rootPart[prop] = Vector3.new(unpack(t))
			end
			task.defer(function()
				ModUtil:BanPlayer(self.Player.Name, "109", nil, prop, tostring(value))
			end)
		end
--[[if prop == "Position" then
local pos = rootPart[prop]
self:UpdateRoundedPos(rootPart, pos)
end]]
	end
	return doBan
end
function FallenGuard:UpdateRoundedPos(rootPart, pos)
	local serverPosValue = self.ServerPosValue
	if not serverPosValue then
		for _, child in pairs(rootPart:GetChildren()) do
			if child.Name ~= "RoundedPos" then continue end
			child:Destroy()
		end
		serverPosValue = Instance.new("Vector3Value")
		self.ServerPosValue = serverPosValue
		serverPosValue.Name = "RoundedPos"
		serverPosValue.Parent = rootPart
	end
	serverPosValue.Value = Vector3.new(math.round(pos.X), math.round(pos.Y), math.round(pos.Z))
end
function FallenGuard:FetchAttribute(attr)
	return script:GetAttribute(attr)
end
function FallenGuard:RefreshClientToServerTable()
	self.ClientToServerChecks = {
		LastFired = tick();
		LastTick = 0;
		SimilarTicksCount = 0;
		LastExtraTicks = 0;
		SimilarExtraTicksCount = 0;
	}
end
function FallenGuard:RefreshFlyTable()
	local flyTable = (self.Fly or {})
	local landQueued = flyTable.LandQueued
	local connection = flyTable.Connection
	if connection then
		connection:Disconnect()
	end
	self.Fly = {
		Enabled = false;
		Connection = nil;
		MoveVector = Vector3.new();
		Offset = CFrame.new();
		Rotation = CFrame.new();
		LandQueued = (landQueued == true);
	}
end
function FallenGuard:RefreshMoveStates()
	self.Spawned = false
	self.LastCFrame = nil
	self.LastCFrameHistory = {}
	self.LastSnapBack = 0
	self.LastFlyHack = 0
	self.DesiredWalkSpeed = 10
	self.SameWalkSpeedCount = 0
	self.DesiredSnapBack = nil
	self.JumpId = 0
	self.FirstGrounded = false
	self.MoveStates = {
		Crouching = false;
		Sprinting = false;
		Grounded = true;
		Swimming = false;
		StatSwimming = false;
	}
	self.ServerPosValue = nil
end
function FallenGuard:FetchRemoteInfo(folderName, remoteName)
	local remoteInfos = self.RemoteInfos
	local folderRemoteInfos = remoteInfos[folderName]
	if not folderRemoteInfos then
		folderRemoteInfos = {}
		remoteInfos[folderName] = folderRemoteInfos
	end
	local remoteInfo = folderRemoteInfos[remoteName]
	if not remoteInfo then
		remoteInfo = {
			CallLogs = {};
			ThrottleQueue = {};
			ThrottleTotal = 0;
			TotalCallsDropped = 0;
			CurrentCallsDropped = 0;
			CallsBeforeCooldown = 0;
			SimilarEncryptedArgCount = 0;
			SameEncryptedArgTotal = 0;
			TotalEncryptedArgs = 0;
			FirstSimilarEncryptedCheckTime = 0;
			SameRemoteCallCount = 0;
			FirstSameRemoteCallTime = 0;
			LastCallDropped = 0;
		}
		folderRemoteInfos[remoteName] = remoteInfo
	end
	return remoteInfo
end
function FallenGuard:FetchAllRemoteInfos()
	return self.RemoteInfos
end
function FallenGuard:SetMovementChecks(b: boolean)
	local player = self.Player
	self.MovementChecksEnabled = b
	if b then
		player:SetAttribute("Loading", nil)
	else
		player:SetAttribute("Loading", false)
	end
end
function FallenGuard:ClearJumpThreads()
	local jumpThreads = self.JumpThreads
	for _, thread in pairs(jumpThreads) do
		local suc, err = pcall(function()
			task.cancel(thread)
		end)
		if not suc then
			warn("COULDN'T CANCEL JUMP THREAD - "..err)
		end
	end
	self.JumpThreads = {}
end
function FallenGuard:GetPartBlacklist()
	return blacklistParts
end
for attribute, _ in pairs(attributes) do
	script:GetAttributeChangedSignal(attribute):Connect(function()
		local value = script:GetAttribute(attribute)
		print("attr change made to", attribute, value)
		attributes[attribute] = value
	end)
	attributes[attribute] = script:GetAttribute(attribute)
end
return FallenGuard