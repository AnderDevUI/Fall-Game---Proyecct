-- [PATH] ServerStorage / Modules / BenchClass @Type ModuleScript
--[[
	BenchClass
	by ChickenBagelz
	February 12, 2023
	
	All bench logic and information is kept here
]]


-- Services
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")
local Run = game:GetService("RunService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Dependencies
local InteractService = ServerScripts:WaitForChild("InteractService")
local BuildService = ServerScripts:WaitForChild("BuildService")
local BenchService = ServerScripts:WaitForChild("BenchService")

-- Folders
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local VFX_PARTS = workspace:WaitForChild("VFX")
local Remotes = Replicated:WaitForChild("Remotes")
local Bases = workspace:WaitForChild("Bases")
local Benches = Replicated:WaitForChild("Benches")
local Terrain = workspace:WaitForChild("Terrain")
local Keycards = workspace:WaitForChild("Keycards")
local Drops = workspace:WaitForChild("Drops")
local Animals = workspace:WaitForChild("Animals")
local Plants = workspace:WaitForChild("Plants")

-- Modules
local BenchInfo = require(SharedModules:WaitForChild("BenchInfo"))
local BenchModule = require(ServerModules:WaitForChild("BenchModule"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local SlotTypeModule = require(ServerModules:WaitForChild("SlotTypeModule"))
local Items = require(SharedModules:WaitForChild("Items"))
local ItemClass = require(SharedModules:WaitForChild("ItemClass"))
local DamageModule = require(ServerModules:WaitForChild("DamageModule"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local RecipeModule = require(SharedModules:WaitForChild("RecipeModule"))
local ServerModule = require(ServerModules:WaitForChild("ServerModule"))
local TableUtil = require(SharedModules:WaitForChild("TableUtil"))
local TweenUtil = require(SharedModules:WaitForChild("TweenUtil"))

-- Bindables
local PopulateEvent = BenchService:WaitForChild("Populate")

-- Local Variables
local viewBenchFilterFunc = RaycastUtil:FilterFunction("ViewBench")
local viewFilterFunc = RaycastUtil:FilterFunction("View")
local hitFilterFunc = RaycastUtil:FilterFunction("Hit")


local BenchClass = {}
BenchClass.__index = BenchClass

function BenchClass.new(benchModel, user, benchData, spawnGroup, pileObj, spawnArea, spawnPart, isFirst)
	local self = setmetatable({}, BenchClass)
	self.Model = benchModel

	local benchName = benchModel.Name
	local benchInfo = BenchInfo[benchName]
	--print(benchName)
	if benchInfo.ClientFunction then
		shared.ActiveBenches[benchModel] = self
	end

	local benchFuncs = BenchModule[benchInfo.Type]
	local initialize = benchFuncs.Initialize
	local decodedData
	if benchData then
		decodedData = (benchData[1] == "_SKIPDECODE" and benchData[2] or self:DecodeBenchData(benchData))
	end
	if initialize then
		local typeArgs = benchInfo.TypeArguments(benchModel)
		if spawnPart then
			for attr, value in pairs(spawnPart:GetAttributes()) do
				typeArgs[attr] = value
			end
		end
		local inIndex = typeArgs.PowerInIndex
		local outIndex = typeArgs.PowerOutIndex
		benchModel:SetAttribute("PowerOutIndex", outIndex)
		benchModel:SetAttribute("PowerInIndex", inIndex)
		if inIndex then
			shared.PowerSystems[benchModel] = (shared.PowerSystems[inIndex] or {})
			shared.PowerSystems[inIndex] = nil
		end
		if outIndex then
			local outTable = shared.PowerSystems[outIndex]
			if not outTable then
				for model, t in pairs(shared.PowerSystems) do
					if typeof(model) == "Instance" and model:GetAttribute("PowerInIndex") == outIndex then
						outTable = t
						break
					end
				end
				if not outTable then
					outTable = {}
					shared.PowerSystems[outIndex] = outTable
				end
			end
			table.insert(outTable, benchModel)
		end
		local cardIndex = typeArgs.KeycardIndex
		if cardIndex then
			if inIndex then -- keycard door
				local cardSwiper = Keycards:FindFirstChild(tostring(cardIndex))
				if cardSwiper then
					shared.DoorIndexes[cardIndex] = self
					cardSwiper.Light:SetAttribute("LightColor", cardSwiper.Light.Color)
					self.Swiper = cardSwiper
					self:ToggleKeycardDoor(false)
				end
			else -- door button
				self.DoorIndex = cardIndex
			end
		end
		local spawnGroupName = typeArgs.SpawnGroup
		if spawnGroupName then
			local spawnGroup = workspace.BenchSpawnGroups:FindFirstChild(spawnGroupName)
			if spawnGroup then
				spawnGroup:GetAttributeChangedSignal("Respawned"):Connect(function()
					if not spawnGroup:GetAttribute("Respawned") then return end
					spawnGroup:SetAttribute("Respawned", false)
					if not self.Swiped then return end
					self.Swiped = false
					self:ToggleKeycardDoor(false, true)
				end)
			end
		end
		self.PressLength = typeArgs.PressLength
		local plinkoIndex = typeArgs.PlinkoIndex
		if plinkoIndex then
			local plinko = workspace:FindFirstChild("Plinko"..plinkoIndex)
			if plinko then
				self.Plinko = plinko
				benchModel:SetAttribute("PlinkoIndex", plinkoIndex)
			end
		end
		initialize(self, typeArgs, user, decodedData, isFirst)
	end
	self:LoadData(decodedData)
	--print("created bench class", self)
	if not isFirst then
		self:Update(true)
	end
	self.SpawnGroup = spawnGroup
	self.PileObject = pileObj
	self.SpawnArea = spawnArea

	return self
end

function BenchClass:Update(doDefer, skipUpdate)
	if not skipUpdate then
		self:UpdatePlayers(self:GetUpdates(), nil, true)
	end
	local benchModel = self.Model
	local isOn = (self.On == true)
	local particleOn = (isOn == (benchModel.Name ~= "Power Cell Box"))
	for _, child in pairs(benchModel:GetChildren()) do
		if child.Name == "FirePart" then
			child.Color = (particleOn and Color3.fromRGB(184, 130, 103) or Color3.fromRGB(21, 21, 21))
			child.Material = Enum.Material[particleOn and "Neon" or "SmoothPlastic"]
		end
		local particles = child:FindFirstChild("ParticleHolder")
		if not particles then continue end
		for _, particle in pairs(particles:GetChildren()) do
			if particle:IsA("Sound") then
				if particleOn and not particle.IsPlaying then
					particle:Play()
				elseif particle.IsPlaying and not particleOn then
					particle:Stop()
				end
				continue
			end
			particle.Enabled = particleOn
		end
	end
	local damageParts = benchModel:FindFirstChild("DamageParts")
	if damageParts and self.On ~= nil then
		damageParts.DamageHandler:SetAttribute("On", isOn)
	end
	self:ChangeOptions()
	if isOn and not self.Running then
		self.Running = true
		local runFunc = function()
			local turnOff = false
			while true do
				local step = task.wait(1)
				if not (self and benchModel and benchModel.Parent) then return end
				local extraStep = self.ExtraStep
				if extraStep then
					step += extraStep
					--print(benchModel, step)
					self.ExtraStep = nil
				end
				if not self.On then break end --
				if not self:Function("CanRun") then
					--print("no more fuel")
					turnOff = true
					break 
				end
				if self:Function("Running", step) then
					--print("run function requested loop break")
					turnOff = true
					break
				end
			end
			if turnOff then
				--print("turning off")
				self:Interact("Turn Off")
			end
			self.Running = false
		end
		if doDefer then
			task.defer(runFunc)
		else
			runFunc()
		end
	end
end

function BenchClass:Function(funcName, ...)
	local benchModel = self.Model
	local benchInfo = BenchInfo[benchModel.Name]
	local benchFuncs = BenchModule[benchInfo.Type]
	return benchFuncs[funcName](self, ...)
end

function BenchClass:UpdatePlayers(updates, playerToIgnore, ignoreContainer)
	updates = (updates or {})
	local newUpdates = {}
	if self.TotalUpkeep then
		self:UpdateUpkeepTime()
		newUpdates = self:GetUpdates()
	end
	if self.AutoTurnOn then
		local oldOn = self.On
		self.On = (self:Function("CanRun") == true)
		if oldOn ~= self.On then
			self:Update(true, true)
		end
	end
	local container = self.Container
	local isLocal = self.IsLocal
	if container and not ignoreContainer then
		local benchModel = self.Model
		if self.DestroyOnEmpty then
			if benchModel and benchModel.Parent and not self.IsDestroying then
				local isEmpty = true
				for _, itemTable in pairs(container) do
					local item = itemTable.Item
					if not (item and item ~= 0 and item.Amount > 0) then continue end
					isEmpty = false
					break
				end
				if isEmpty then
					self.IsDestroying = true
					self.DenyAccess = true
					task.delay(0.3, function()
						local spawnGroup = self.SpawnGroup
						if spawnGroup then
							PopulateEvent:Fire(spawnGroup, benchModel)
						end
						--print("container is empty; deleting", spawnGroup)
						ModUtil:SafeDestroy(benchModel, true)
						self:Delete()
					end)
					return
				end
			end
		end
		if benchModel and benchModel.Parent and (benchModel.Name == "Body Bag" or benchModel.Name == "Contents") then
			shared.UpdateDroppedItem(benchModel)
		end
	end
	if container then
		local benchModel = self.Model
		if benchModel and benchModel.Name == "Shotgun Turret" then
			local isEmpty = true
			for index, itemTable in pairs(container) do
				local item = itemTable.Item
				local typ = itemTable.Type
				if not item or item == 0 or item.Amount <= 0 then continue end
				isEmpty = false
				break
			end
			if isEmpty and self.TouchConnection then
				self.TouchConnection:Disconnect()
				self.TouchConnection = nil
				print("DISCONNECTED TOUCH EVENT")
			elseif not isEmpty and not self.TouchConnection then
				self:SetupTurret()
			end
		end
	end
	local players = self.Players
	for index, player in pairs(players or {}) do
		if not (player and player.Parent) then
			table.remove(players, index)
			continue
		end
		if isLocal and playerToIgnore and player ~= playerToIgnore then continue end
		local user = shared.Users[player]
		if not user then continue end
		local inventory = user.Inventory
		if player == playerToIgnore then
			if #newUpdates > 0 then
				inventory:UpdateFire(unpack(newUpdates))
			end
			continue
		else
			if not ignoreContainer then
				inventory:UpdateBenchContainer(self)
			end
			inventory:UpdateFire(unpack(newUpdates), unpack(updates))
		end
	end
	if not ignoreContainer then
		self:ChangeOptions()
	end
end

function BenchClass:GetUpdates()
	local updates = {}
	local on = self.On
	local totalUpkeep = self.TotalUpkeep
	local upkeepTick = self.UpkeepTick
	if on ~= nil then
		table.insert(updates, {On = on})
	end
	if totalUpkeep then
		local upkeepUpdate = {}
		for _, upkeep in pairs(totalUpkeep) do
			local amount = upkeep.Amount
			if amount <= 0 then continue end
			table.insert(upkeepUpdate, {
				ID = upkeep.ID;
				Amount = amount;
			})
		end
		table.insert(updates, {
			UpkeepTick = upkeepTick;
			Upkeep = upkeepUpdate;
		})
	end
	return updates
end

function BenchClass:ChangeOptions()
	local benchModel = self.Model
	local wheelInfos = (self:Function("Interact") or {})
	--print(wheelInfos)
	benchModel:SetAttribute("FirstAction", (wheelInfos[1] or {}).Name)
	benchModel:SetAttribute("TotalActions", #wheelInfos)
end

function BenchClass:UpdateSlot(index, item, userId)
	local itemTable = self:GetSlot(index, userId)
	if not itemTable then return end
	if item and item ~= 0 and item.Amount > 0 then
		local newItem = ItemClass.new(TableUtil:CloneTable(item))
		itemTable.Item = newItem
	else
		itemTable.Item = 0
	end
end

function BenchClass:CanFitItemInSlot(item, index, userId)
	local itemTable = self:GetSlot(index, userId)
	if not itemTable then return end
	local itemAccepted = SlotTypeModule[itemTable.Type]
	if not itemAccepted then return end
	local b = itemAccepted(item, itemTable.Item)
	--[[if not b then
		warn("ITEM NOT ACCEPTED:", item, index)
	end]]
	return b
end

function BenchClass:GetSlot(index, userId)
	local containers = self.Container
	if not containers then return end
	local container = containers
	if self.IsLocal then
		container = containers[userId]
	end
	return (container or {})[index]
end

function BenchClass:Interact(action, user, maxDist, ...)
	local benchModel = self.Model
	if not (benchModel and benchModel.Parent) then return end
	local benchInfo = BenchInfo[benchModel.Name]
	local benchFuncs = BenchModule[benchInfo.Type]
	if user then
		local interactDist = maxDist
		if not interactDist then
			interactDist = (benchInfo.InteractDistance or InteractService:GetAttribute("DefaultDistance")) + 1
		end
		local humanoid = user.Humanoid
		if not (humanoid and humanoid.Health > 0 and not humanoid:GetAttribute("Downed")) then return end
		local character = humanoid.Parent
		if not character then return end
		local prim = character.PrimaryPart
		if not prim then return end
		local benchPos = benchModel.PrimaryPart.Position
		local primPos = prim.Position + Vector3.new(0, 0.5, 0)
		local headHit = RaycastUtil:Raycast(prim.Position, Vector3.new(0, 1.6, 0), "Exclude", {VFX_PARTS, character, Drops, Plants, Animals, benchModel}, nil, viewFilterFunc, true)
		if headHit then return end
		local hit = RaycastUtil:Raycast(primPos, (benchPos - primPos).Unit * interactDist, "Blacklist", {character, VFX_PARTS}, false, function(h)
			local filter = viewBenchFilterFunc(h)
			if filter then
				return filter
			elseif h.Parent and h.Parent:IsA("Model") and h:IsDescendantOf(Bases) and not h.Parent.Name:find("Wall") and not h:IsDescendantOf(benchModel) and h.Parent.Name ~= "Doorway" and not h.Parent.Name:find("Foundation") and h.Parent.Name ~= "Window" then
				return h.Parent
			elseif h and h.Parent and h:IsA("BasePart") and h.Transparency >= 1 and not h.CanCollide and not h:IsDescendantOf(benchModel) then
				--print("hit invis part that doesn't belong to bench", h, benchModel)
				return h
			end
		end)
		--print(hit)
		if not (hit and hit:IsDescendantOf(benchModel)) then return end
	end
	--print("action successful")
	benchFuncs.Action(self, user, action, ...)
end

function BenchClass:IsBuildingBlocked(user)
	if not user then return end
	local player = user.Player
	local model = self.Model
	if not (player and model) then return end
	local benchPrim = model.PrimaryPart
	local baseCabinet = RaycastUtil:GetBaseCabinetUnder(benchPrim.Position)
	if baseCabinet and baseCabinet:GetAttribute("Monument") then return end
	local cabinet = shared.Benches[baseCabinet]
	return (cabinet and not table.find(cabinet.Authorized or {}, player.UserId))
end

function BenchClass:Pickup(user)
	local benchModel = self.Model
	local benchInfo = BenchInfo[benchModel.Name]
	if not (benchInfo and user) then return end
	local inventory = user.Inventory
	local id = benchModel:GetAttribute("ID")
	local info = Items[id]
	if not info then return end
	local isBuildBlocked = self:IsBuildingBlocked(user)
	if isBuildBlocked then return end
	local item = ItemClass.new(id, 1, benchModel:GetAttribute("Skin"), (benchModel:GetAttribute("Health") or 0), benchModel:GetAttribute("Repair"))
	local durDecrease = (benchInfo and benchInfo.DurabilityDecrease or 0)	
	local maxDurability = info.MaxDurability
	if maxDurability then
		item.Durability = math.max(item.Durability - maxDurability * durDecrease, 0)
	end
	local bench = shared.Benches[benchModel]
	if bench then
		bench:Delete()
	end
	local benchBase = benchModel:FindFirstAncestor("Base")
	DamageModule:DisconnectBench(benchModel)
	ModUtil:SafeDestroy(benchModel, true)
	inventory:AddItem(item)
	if not (benchBase and benchBase.Parent) then return end
	DamageModule:UpdateBaseCost(benchBase)
end

function BenchClass:OpenDoor(speed)
	local benchModel = self.Model
	if benchModel:GetAttribute("Moving") then return end
	benchModel:SetAttribute("Moving", true)
	local isOpen = (not benchModel:GetAttribute("Open"))
	benchModel:SetAttribute("Open", isOpen)
	if not speed then
		local openSound = benchModel.PrimaryPart[isOpen and "Open" or "Close"]
		openSound.PlaybackSpeed = math.random(95, 105) / 100
		openSound:Play()
	end
	self:ChangeOptions()
	local pivots = {}
	local changeCollide = self.ChangeCollideWhenMoving
	for _, door in pairs(benchModel:GetChildren()) do
		if not (door:IsA("Model") and door.Name:find("Door")) then continue end
		local prim = door.PrimaryPart
		if not prim then continue end
		if changeCollide then
			prim.CanCollide = false
		end
		local startPivot = prim.CFrame * CFrame.new(prim.Size.X / -2, 0, 0)
		table.insert(pivots, {
			Door = door;
			Start = startPivot;
			End = startPivot * CFrame.Angles(0, math.rad(self.OpenDegrees) * (isOpen and 1 or -1), 0);
			Offset = startPivot:ToObjectSpace(prim.CFrame)
		})
	end
	local x = 0
	speed = (speed or 1 / self.MoveTime)
	local moveFunc = self.MoveFunction
	task.defer(function()
		while x < 1 do
			local _, step = Run.Stepped:Wait()
			if not (benchModel and benchModel.Parent) then return end
			x = math.clamp(x + step * speed, 0, 1)
			local y = moveFunc(x)
			local alpha = y
			for _, pivot in pairs(pivots) do
				local door = pivot.Door
				if not (door and door.Parent) then continue end
				if changeCollide then
					door.Main.CanCollide = (x >= 0.5)
				end
				door:SetPrimaryPartCFrame(pivot.Start:Lerp(pivot.End, alpha) * pivot.Offset)
			end
		end 
		benchModel:SetAttribute("Moving", false)
	end)
end

function BenchClass:OpenHatch(speed)
	local benchModel = self.Model
	if benchModel:GetAttribute("Moving") then return end
	local door = benchModel:FindFirstChild("Hatch")
	local ladderParts = benchModel:FindFirstChild("Ladder")
	if not (door and ladderParts) then return end
	local top = door:FindFirstChild("Top")
	local middle = door:FindFirstChild("Middle")
	local bottom = door:FindFirstChild("Bottom")
	if not (top and middle and bottom) then return end
	benchModel:SetAttribute("Moving", true)
	local isOpen = (not benchModel:GetAttribute("Open"))
	benchModel:SetAttribute("Open", isOpen)
	if not speed then
		local openSound = benchModel.PrimaryPart.Open
		openSound.PlaybackSpeed = math.random(95, 105) / 100
		openSound:Play()
	end
	self:ChangeOptions()
	speed = (speed or 1 / (self.MoveTime / 2))
	local moveFunc = self.MoveFunction
	task.defer(function()
		if not isOpen then
			for _, part in pairs(ladderParts:GetChildren()) do
				if not (part and part.Parent and part:IsA("BasePart")) then continue end
				part.CanCollide = false
				part.CanQuery = false
			end
		end
		local dir = (isOpen and -1 or 1)
		for i = (isOpen and 2 or 1), (isOpen and 1 or 2), dir do
			local x = 0
			if i == 1 then
				local startPivot = top.CFrame * CFrame.new(0, top.Size.Y / 2.2, -0.25)
				local endPivot = startPivot * CFrame.Angles(math.rad(-180.01) * dir, 0, 0);
				local offset = startPivot:ToObjectSpace(top.CFrame)
				while x < 1 do
					local _, step = Run.Stepped:Wait()
					if not (benchModel and benchModel.Parent) then return end
					x = math.clamp(x + step * speed, 0, 1)
					local y = moveFunc(x)
					local alpha = y
					top.CanCollide = (x >= 0.5)
					top.CFrame = startPivot:Lerp(endPivot, alpha) * offset
				end
				continue
			end
			local startPivot = bottom.CFrame * CFrame.new(0, bottom.Size.Y / 2.5, 0)
			local endPivot = startPivot * CFrame.Angles(math.rad(90) * dir, 0, 0);
			local startSlide = CFrame.new(0, 0, 0)
			local endSlide = CFrame.new(0, top.Size.Y / -2.2 * dir, 0)
			local bottomOffset = startPivot:ToObjectSpace(bottom.CFrame)
			local topOffset = bottom.CFrame:ToObjectSpace(top.CFrame)
			local middleOffset = bottom.CFrame:ToObjectSpace(middle.CFrame)
			while x < 1 do
				local _, step = Run.Stepped:Wait()
				if not (benchModel and benchModel.Parent) then return end
				x = math.clamp(x + step * speed, 0, 1)
				local y = moveFunc(x)
				local alpha = y
				top.CanCollide = (x >= 0.5)
				bottom.CanCollide = (x >= 0.5)
				middle.CanCollide = (x >= 0.5)
				door:SetPrimaryPartCFrame(startPivot:Lerp(endPivot, alpha) * bottomOffset)
				local slide = startSlide:Lerp(endSlide, alpha)
				top.CFrame = bottom.CFrame * topOffset * slide
				middle.CFrame = bottom.CFrame * middleOffset * slide:Inverse()
			end
		end
		if isOpen then
			for _, part in pairs(ladderParts:GetChildren()) do
				if not (part and part.Parent and part:IsA("BasePart")) then continue end
				part.CanQuery = true
				part.CanCollide = true
			end
		end
		benchModel:SetAttribute("Moving", false)
	end)
end

function BenchClass:OpenGarage(speed)
	local benchModel = self.Model
	if benchModel:GetAttribute("Moving") then return end
	local top = benchModel:FindFirstChild("Top")
	if not top then return end
	benchModel:SetAttribute("Moving", true)
	local isOpen = (not benchModel:GetAttribute("Open"))
	benchModel:SetAttribute("Open", isOpen)
	if not speed then
		local openSound = benchModel.PrimaryPart.Open
		openSound:Play()
	end
	self:ChangeOptions()
	local x = (isOpen and 0 or 1)
	speed = (speed or 1 / self.MoveTime) * (isOpen and 1 or -1)
	local parts = {}
	for _, part in pairs(benchModel:GetChildren()) do
		if part.Name:sub(1, 4) ~= "Part" then continue end
		table.insert(parts, part)
		if isOpen then continue end
	end
	local moveFunc = self.MoveFunction
	task.defer(function()
		local lastY = moveFunc(x)
		while (isOpen and x < 1 or (isOpen == false and x > 0)) do
			local _, step = Run.Stepped:Wait()
			if not (benchModel and benchModel.Parent) then return end
			x = math.clamp(x + step * speed, 0, 1)
			local y = moveFunc(x)
			for _, part in pairs(parts) do
				part.CFrame *= CFrame.new(0, y - lastY, 0)
				if part.Transparency == (isOpen and 1 or 0) then continue end
				local offset = top.CFrame:ToObjectSpace(part.CFrame)
				if isOpen then
					if offset.Position.Y < 0 then continue end
				elseif offset.Position.Y > 0 then continue end
				part.Transparency = (isOpen and 1 or 0)
				part.CanCollide = not isOpen
				part.CanTouch = not isOpen
				part.CanQuery = not isOpen
			end
			lastY = y
		end 
		benchModel:SetAttribute("Moving", false)
	end)
end

function BenchClass:OpenJail(speed)
	local benchModel = self.Model
	if benchModel:GetAttribute("Moving") then return end
	local bars = benchModel:FindFirstChild("Bars")
	local main = benchModel:FindFirstChild("Main")
	if not (bars and main) then return end
	benchModel:SetAttribute("Moving", true)
	local isOpen = (not benchModel:GetAttribute("Open"))
	benchModel:SetAttribute("Open", isOpen)
	self:ChangeOptions()
	if not speed then
		local openSound = benchModel.PrimaryPart[isOpen and "Open" or "Close"]
		openSound.PlaybackSpeed = math.random(95, 105) / 100
		openSound:Play()
	end
	speed = (speed or 1 / self.MoveTime)
	local moveFunc = self.MoveFunction
	local start = CFrame.new(-0.0954437256, -0.139404297, 2.02260971, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	local en = CFrame.new(-0.0954437256, -0.139404297, -2.23251724, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	local startCFrame = main.CFrame * (isOpen and start or en)
	local endCFrame = main.CFrame * (isOpen and en or start)
	local x = 0
	task.defer(function()
		while x < 1 do
			local _, step = Run.Stepped:Wait()
			if not (benchModel and benchModel.Parent) then return end
			x = math.clamp(x + step * speed, 0, 1)
			local y = moveFunc(x)
			local alpha = y
			bars:SetPrimaryPartCFrame(startCFrame:Lerp(endCFrame, alpha))
		end 
		benchModel:SetAttribute("Moving", false)
	end)
end

function BenchClass:Press(user)
	local benchModel = self.Model
	local button = benchModel:FindFirstChild("Button")
	local main = benchModel.PrimaryPart
	local lastPressed = self.ButtonPressed
	local curTick = tick()
	if not (button and main and lastPressed and curTick - lastPressed >= 0.5 and not self.Powered) then return end
	local doorIndex = self.DoorIndex
	local doorBench
	if doorIndex then
		doorBench = shared.DoorIndexes[doorIndex]
		if not doorBench then return end
		local doorModel = doorBench.Model
		if not (doorModel.Parent and not doorModel:GetAttribute("Open") and not doorModel:GetAttribute("Moving")) then return end
	else
		local isPowered = self:CheckForPower()
		if not isPowered then return end
	end
	self.ButtonPressed = curTick
	main.Press:Play()
	self.Powered = true
	local offset = CFrame.new(0.008, -0.219, 0.233)
	TweenUtil:Tween(button, "CFrame", main.CFrame * offset * CFrame.new(0, 0, -0.1), 0.4, "Quart", "Out")
	if doorBench then
		doorBench:OpenDoor()
	else
		self:UpdatePower()
	end
	local started = tick()
	local pressLength = (doorIndex and 5 or (self.PressLength or 30))
	task.defer(function()
		while tick() - started < pressLength and benchModel.Parent do
			if doorBench then
				if not (doorBench.Model.Parent and doorBench.Model:GetAttribute("Open")) then break end
			elseif not self:CheckForPower() then
				break
			end
			task.wait(1)
		end
		self.Powered = false
		if doorIndex then
			doorBench:ToggleKeycardDoor(false, true)
		else
			self:UpdatePower()
		end
		if not benchModel.Parent then return end
		TweenUtil:Tween(button, "CFrame", main.CFrame * offset, 0.4, "Quart", "Out")
	end)
end

function BenchClass:CheckForPower()
	local powerSystem = shared.PowerSystems[self.Model]
	--print(powerSystem, shared.PowerSystems)
	if not powerSystem then return end
	for _, powerModel in pairs(powerSystem) do
		if not powerModel.Parent then continue end
		local powerBench = shared.Benches[powerModel]
		if powerBench and powerBench.On == true then continue end
		return false
	end
	return true
end

function BenchClass:UpdatePower()
	for powerModel, t in pairs(shared.PowerSystems) do
		if not table.find(t, self.Model) then continue end
		local powerBench = shared.Benches[powerModel]
		if powerBench then
			powerBench:ToggleKeycardDoor(self.Powered)
		end
		break
	end
end

function BenchClass:ToggleKeycardDoor(powered, skipSet)
	--print(powered)
	local swiper = self.Swiper
	if not (swiper and swiper.Parent) then return end
	local benchModel = self.Model
	swiper.Light.Color = (powered and swiper.Light:GetAttribute("LightColor") or Color3.fromRGB(17, 17, 17))
	swiper.Detail.Color = swiper.Light.Color
	swiper.Light.Light.Enabled = powered
	if not skipSet then
		self.Powered = powered
	end
	--print(benchModel:GetAttribute("Open"))
	if powered then
		if not self.Swiped or benchModel:GetAttribute("Open") then return end
	else
		if not benchModel:GetAttribute("Open") then return end
	end
	while true do
		--print("ya")
		if not benchModel.Parent then return end
		if not benchModel:GetAttribute("Moving") then break end
		task.wait()
	end
	task.wait(math.random() / 2)
	if not benchModel.Parent or benchModel:GetAttribute("Moving") or benchModel:GetAttribute("Open") == powered then return end
	self:OpenDoor()
end

function BenchClass:GetAddon(typ)
	local benchModel = self.Model
	local addons = benchModel:FindFirstChild(typ, true)
	if not addons then return false end
	for _, addon in pairs(addons:GetChildren()) do
		if not addon:GetAttribute("On") then continue end
		return addon
	end
end

function BenchClass:ChangeLockAppearance(lock, locked)
	if lock.Name == "Combination Lock" then
		lock.On.Color = (locked and Color3.new(0, 0.2, 0) or Color3.new(0, 1, 0))
		lock.On.Material = (locked and Enum.Material.Glass or Enum.Material.Neon)
		lock.Off.Color = (locked and Color3.new(1, 0, 0) or Color3.new(0.2, 0, 0))
		lock.Off.Material = (locked and Enum.Material.Neon or Enum.Material.Glass)
	else
		lock.State.BrickColor = (locked and BrickColor.new("Bright red") or BrickColor.new("Bright green"))
	end
end

function BenchClass:LockAction(action, user, ...)
	local args = {...}
	if not user then return end
	local inventory = user.Inventory
	local player = user.Player
	local userId = player.UserId
	local benchModel = self.Model
	local benchPrim = benchModel.PrimaryPart
	local lock = self:GetAddon("Lock")
	local humanoid = user.Humanoid
	local head = user.Head
	if not (humanoid and humanoid.Health > 0 and humanoid.Parent and head and head.Parent and lock) then return end
	local isCodeLock = (lock.Name == "Combination Lock")
	local isLocked = self.Locked
	local access = (self.Access or {})
	local guests = (self.Guests or {})
	local incorrectTries = self.IncorrectTries
	local hasAccess = table.find(access, userId)
	local hasGuest = table.find(guests, userId)
	local code = self.Code
	local guestCode = self.GuestCode
	if action == "Lock" and lock and (not isLocked) and ((not isCodeLock and #access <= 0) or (isCodeLock and code)) then
		self.Locked = true
		if not (hasAccess or isCodeLock) then
			table.insert(access, userId)
		end
		self.Access = access
		if not incorrectTries then
			incorrectTries = {}
			self.IncorrectTries = incorrectTries
		end
		self:ChangeLockAppearance(lock, true)
		self:ChangeOptions()
		--print("locked")
	elseif action == "Remove Lock" and lock and not isLocked then
		for _, part in pairs(lock:GetChildren()) do
			if not part:IsA("BasePart") then continue end
			part.Transparency = 1
		end
		self.Access = {}
		self.Guests = {}
		self.IncorrectTries = {}
		self.Code = nil
		self.GuestCode = nil
		lock:SetAttribute("On", nil)
		local item = ItemClass.new((lock.Name == "Wooden Lock" and 48 or 49), 1)
		inventory:AddItem(item)
		self:ChangeOptions()
		--print("removed lock")
	elseif action == "Unlock" and isLocked and hasAccess then
		self.Locked = false
		if not isCodeLock then
			self.Access = {}
		end
		self:ChangeLockAppearance(lock, false)
		self:ChangeOptions()
		--print("unlocked")
	elseif action == "Change Combination" and isCodeLock and ((not code) or hasAccess) then
		local inputCode = args[1]
		if inputCode == code or type(inputCode) ~= "string" then return end
		self.Code = inputCode
		access = {userId}
		self.Access = access
		--[[if not guestCode then
			guestCode = {}
			self.GuestCode = guestCode
		end]]
		if not code then
			self:LockAction("Lock", user)
		else
			table.insert(access, userId)
		end
		--print(player.Name, "set new Master code to", inputCode, self.Access)
	elseif action == "Enter Combination" and isCodeLock then
		local inputCode = args[1]
		if type(inputCode) ~= "string" then return end
		if inputCode == code and not hasAccess then
			incorrectTries[userId] = nil
			table.insert(access, userId)
			--print(player.Name, "correctly inputted Master code:", inputCode, self.Access)
		elseif guestCode and inputCode == guestCode and not hasGuest then
			table.insert(guests, userId)
			--print(player.Name, "correctly inputted Guest code:", inputCode, self.Guests)
		else
			local tries = (incorrectTries[userId] or 0) + 1
			incorrectTries[userId] = tries
			--print(tries, inputCode)
			DamageModule:Damage(head, Vector3.new(), Vector3.new(), benchPrim.CFrame, {
				Head = (tries == 1 and 10 or (tries == 2 and 30 or (tries == 3 and 80 or 200)));
			}, {Start = 1000, End = 1000}, nil, nil, "Combination Lock")
			--print(player.Name, "failed to guess code (total fails:", tries..") (code inputted:", inputCode..") (Master code:", (code or "")..") (Guest code:", (guestCode or "")..")")
		end
	elseif action == "Set Guest Combination" and isCodeLock and hasAccess then
		local inputCode = args[1]
		if inputCode == guestCode or type(inputCode) ~= "string" then return end
		self.GuestCode = inputCode
		self.Guests = {}
		--print(player.Name, "set Guest code to", inputCode)
	end
end

function BenchClass:GetLockOptions(user, hasGuestCodeOption)
	local wheelInfo = {}
	local player = (user and user.Player)
	local isLocked = self.Locked
	local access = (self.Access or {})
	local guests = (self.Guests or {})
	local code = self.Code
	local hasAccess = (player ~= nil and table.find(access, player.UserId))
	local hasGuest = (player ~= nil and table.find(guests, player.UserId))
	local lock = self:GetAddon("Lock")
	local isCodeLock = (lock and lock.Name == "Combination Lock")
	local isBuildBlocked = self:IsBuildingBlocked(user)
	if player and lock then
		if not isLocked then
			if isCodeLock then
				table.insert(wheelInfo, {"Change Combination", "rbxassetid://6322423778", "Input the combination required to use the lock."})
			end
			if (not isCodeLock) or code then
				table.insert(wheelInfo, {"Lock", "rbxassetid://5614732823", "Secure the bench by locking it."})
			end
			if isCodeLock and code and hasGuestCodeOption then
				table.insert(wheelInfo, {"Set Guest Combination", "rbxassetid://10885655986", "Anyone with the guest combination can open the bench, but not tamper with the lock."})
			end
			if not isBuildBlocked then
				table.insert(wheelInfo, {"Remove Lock", "rbxassetid://6322707158", "Remove the current lock and add it to your inventory."})
			end
		elseif hasAccess then
			table.insert(wheelInfo, {"Unlock", "rbxassetid://5614732932", "Allows anyone to access the lock and removal of the lock."})
		elseif isCodeLock then
			table.insert(wheelInfo, {"Enter Combination", "rbxassetid://6322423778", "This bench is locked. Enter the correct combination for access."})
		end
	end
	return (not player) or (not isLocked) or hasAccess or (isCodeLock and hasGuest), wheelInfo
end

function BenchClass:UpdateUpkeepCost()
	local benchModel = self.Model
	local totalUpkeep = self.TotalUpkeep
	local base = benchModel:FindFirstAncestor("Base")
	if not base then return end
	local started = os.clock()
	local count = 0
	for _, upkeep in pairs(totalUpkeep) do
		upkeep.Amount = 0
	end
	local allCounts = {}
	local total = 0
	for _, benchFolder in pairs(base:GetChildren()) do
		local name = benchFolder.Name
		local benchInfo = BenchInfo[name]
		if not (benchInfo and benchInfo.DecayType == "Upkeep") then continue end
		local recipes
		local children = benchFolder:GetChildren()
		local isBasePart = (benchInfo.Type == "BasePart")
		for index, bench in pairs(children) do
			if not bench.Parent then continue end
			local id = bench:GetAttribute("ID")
			if id and index == 1 then
				local counts = allCounts[name]
				if not counts then
					local recipe = (RecipeModule:GetRecipesForItem(id) or {})[1]
					if not recipe then break end
					counts = {recipe, 0}
					allCounts[name] = counts
				end
				counts[2] += #children
				total += #children
				--print("fast calculation", bench)
				break
			elseif isBasePart then
				if not recipes then
					recipes = RecipeModule:GetRecipesForItem(name)
					if not (recipes and #recipes > 0) then break end
				end
				local damageType = bench:GetAttribute("DamageType")
				for _, recipe in pairs(recipes) do
					if isBasePart and recipe.Category ~= (damageType or "Twig") then continue end
					local benchName = (damageType or "Twig")..name
					local counts = allCounts[benchName]
					if not counts then
						counts = {recipe, 0}
						allCounts[benchName] = counts
					end
					counts[2] += 1
					total += 1
					break
				end
				count += 1
				if count % 200 ~= 0 then continue end
				task.wait()
			else
				warn("UNKNOWN BENCH COULDN'T HAVE ITS UPKEEP CALCULATED", name, benchFolder)
				break
			end
		end
	end
	local sizeMult = (total >= 200 and 0.2 or (total >= 100 and 0.15 or 0.1))
	--[[if sizeMult ~= 0.1 then
		print(`BASE UPKEEP MULTIPLIER INCREASED TO {sizeMult} (BASE SIZE: {total})`)
	end]]
	for benchName, counts in pairs(allCounts) do
		local recipe = counts[1]
		local amount = counts[2]
		--print(benchName, amount)
		local costs = RecipeModule:CalculateTotalCost(recipe, sizeMult * amount, true, {6, 68})
		for _, cost in pairs(costs) do
			for _, upkeep in pairs(totalUpkeep) do
				if upkeep.ID ~= cost.ID then continue end
				upkeep.Amount += math.ceil(cost.Amount)
				local benches = upkeep.Benches
				if not table.find(benches, benchName) then
					table.insert(benches, benchName)
				end
				break
			end
		end
	end
	self:UpdatePlayers(self:GetUpdates(), nil, true)
	--print("DONE UPDATING BASE COST IN "..os.clock() - started)
end

function BenchClass:UpdateUpkeepTime()
	local totalUpkeep = self.TotalUpkeep
	for _, cost in pairs(totalUpkeep) do
		cost.Found = 0
		cost.DamageMult = 1
	end
	for index, itemTable in pairs(self.Container) do
		local item = itemTable.Item
		if not (item and item ~= 0) then continue end
		for _, cost in pairs(totalUpkeep) do
			if cost.ID ~= item.ID then continue end
			cost.Found += item.Amount
		end
	end
	local lowestRatio = 99
	local count = 0
	for _, cost in pairs(totalUpkeep) do
		count += 1
		if count % 100 == 0 then task.wait() end
		if cost.Amount <= 0 then continue end
		local r = math.max(cost.Found - (cost.Remainder or 0), 0)
		cost.DamageMult = 1 - math.min(r / (cost.Amount / 144), 1)
		lowestRatio = math.min(lowestRatio, r / cost.Amount)
	end
	self.UpkeepTick = BuildService:GetAttribute("LastDecay") + lowestRatio * BuildService:GetAttribute("DecayCheckTime") * 144
end

function BenchClass:CreateBenchBag(position)
	local benchModel = self.Model
	if position and benchModel and benchModel.Name ~= "Sleeper" and not self.MadeBenchBag then
		local container = self.Container
		if container then
			self.MadeBenchBag = true
			local foundItems = {}
			for _, itemTable in pairs(container) do
				local item = itemTable.Item
				if not (item and item ~= 0 and item.Amount > 0) then continue end
				table.insert(foundItems, item)
			end
			if #foundItems > 0 then
				local benches = Bases.Loners:FindFirstChild("Contents")
				if not benches then
					benches = Instance.new("Folder")
					benches.Name = "Contents"
					benches.Parent = Bases.Loners
				end
				local bagModel, bagBench = shared.CreateBench(Benches["Contents"].Default, "Contents", CFrame.new(position), benches, 0, 0)
				bagModel:SetAttribute("BenchName", benchModel.Name:upper())
				local bagContainer = bagBench.Container
				for index, itemTable in pairs(bagContainer) do
					local foundItem = foundItems[index]
					if foundItem then
						itemTable.Item = foundItem
						continue
					end
					bagContainer[index] = nil
				end
				local dropTable = shared.AddDroppedItem(bagModel)
				task.defer(shared.SetupDrop, dropTable, true)
			end
		end
	end
end

function BenchClass:SetSign(newText: string|number, gui: SurfaceGui)
	local benchModel = self.Model
	if not gui then
		local guiReference = benchModel:FindFirstChild("GuiReference")
		if guiReference then
			gui = guiReference.Value
		end
	end
	--print(newText, gui)
	if not gui then return end
	self.Text = newText
	--print(self)
	if type(newText) == "number" then
		gui.TextLabel.Text = ""
		gui.TextLabel.Visible = false
		gui.ImageLabel.Image = (newText == 0 and "" or "rbxassetid://"..newText)
		gui.ImageLabel.Visible = true
	elseif type(newText) == "string" then
		gui.ImageLabel.Image = ""
		gui.ImageLabel.Visible = false
		gui.TextLabel.Text = newText
		gui.TextLabel.Visible = true
	end
end

function BenchClass:EncodeBenchData()
	local benchData = {}
	local benchModel = self.Model
	if benchModel and benchModel.Parent then
		local open = benchModel:GetAttribute("Open")
		if open ~= nil then
			benchData.A = (open and 1 or 0)
		end
	end
	if self.On then
		benchData.B = 1
	end
	local container = self.Container
	local savedContainer
	if container and #container > 0 and not self.IsLocal then
		savedContainer = {}
		local did = false
		for index, itemTable in pairs(container) do
			if not (index and itemTable) then continue end
			local item = itemTable.Item
			if not (item and item ~= 0 and item.Amount > 0) then continue end
			did = true
			savedContainer[tostring(index)] = ServerModule:EncodeItemData(item)
		end
		if did then
			benchData.C = savedContainer
		end
	end
	local lock = self:GetAddon("Lock")
	if lock and lock.Parent then
		benchData.D = (lock.Name == "Wooden Lock" and 1 or 2)
		benchData.E = self.Code
		benchData.F = self.GuestCode
		local access, guests
		if self.Access and #self.Access > 0 then
			access = ServerModule:EncodeIntTable(self.Access)
		end
		if self.Guests and #self.Guests > 0 then
			guests = ServerModule:EncodeIntTable(self.Guests)
		end
		benchData.G = access
		benchData.H = guests
		if self.Locked then
			benchData.I = 1
		end
	end
	local authorized = self.Authorized
	if authorized then
		benchData.J = ServerModule:EncodeIntTable(authorized)
		benchData.M = ServerModule:EncodeNumber(benchModel:GetAttribute("Placed"))
	end
	local owner = self.Owner
	if owner then
		benchData.K = ServerModule:EncodeNumber(owner)
	end
	local lastRespawn = self.LastRespawn
	local bedName = benchModel:GetAttribute("BedName")
	if lastRespawn and bedName then
		benchData.L = ServerModule:EncodeNumber(lastRespawn).."/"..bedName
	end
	local sleeperInfo = self.SleeperInfo
	if sleeperInfo then
		benchData.N = ServerModule:EncodeIntTable(sleeperInfo)
	end
	local text = self.Text
	if text then
		benchData.O = text
	end
	local armed = benchModel:GetAttribute("Armed")
	if armed == false and benchModel.Name == "Bear Trap" then
		benchData.P = 1
	end
	local highestByte = 0
	for index, _ in pairs(benchData) do
		highestByte = math.max(highestByte, string.byte(index))
	end
	local encodedString = ""
	local container
	for byte = 65, highestByte do
		local index = string.char(byte)
		local value = benchData[index]
		local encodedValue = (value or "")
		if type(value) == "table" and not container then
			container = value
			encodedValue = "_"
		end
		encodedString = encodedString..encodedValue..(byte == highestByte and "" or "<")
	end
	local encodedData = {encodedString}
	if container then
		table.insert(encodedData, container)
	end
	for index, value in pairs(benchData) do
		if not (index and value) then continue end
		--print("compressed bench data for", benchModel.Name, benchData, encodedData)
		return (Http:JSONEncode(encodedData):len() < Http:JSONEncode(benchData):len() and encodedData or benchData)
	end
end

function BenchClass:DecodeBenchData(encodedData)
	if type(encodedData) == "table" then
		local benchData = {}
		local encodedString = encodedData[1]
		local container = encodedData[2]
		for encodedIndex, encodedValue in pairs(encodedString and string.split(encodedString, "<") or encodedData) do
			local index = (encodedString and string.char(65 + (encodedIndex - 1)) or encodedIndex)
			local value = ((index == "A" or index == "B" or index == "D" or index == "I" or index == "P") and tonumber(encodedValue) or encodedValue)
			if index == "C" then
				if encodedString then
					if value ~= "_" then continue end
					value = container
				else
					value = encodedValue
				end
			elseif index == "G" or index == "H" or index == "J" or index == "N" then
				value = ServerModule:DecodeIntTable(encodedValue)
			elseif index == "K" or index == "M" then
				value = ServerModule:DecodeNumber(encodedValue)
			end
			if encodedString and value == "" then continue end
			benchData[index] = value
		end
		if benchData.J ~= nil then
			--print("decoded bench data", benchData)
		end
		return benchData
	end
	return encodedData
end

function BenchClass:LoadData(benchData)
	if not benchData then return end
	local benchModel = self.Model
	local lockType = benchData.D
	if lockType then
		local locks = benchModel:FindFirstChild("Lock", true)
		if locks then
			local lock = locks:FindFirstChild(lockType == 1 and "Wooden Lock" or "Combination Lock")
			if lock then
				local code = benchData.E
				local guestCode = benchData.F
				local access = benchData.G
				local guests = benchData.H
				local locked = (benchData.I == 1)

				lock:SetAttribute("On", true)
				for _, part in pairs(lock:GetChildren()) do
					if not part:IsA("BasePart") then continue end
					part.Transparency = 0
				end
				self:ChangeLockAppearance(lock, locked)

				self.Locked = locked
				self.Code = code
				self.GuestCode = guestCode
				self.Access = access
				self.Guests = guests
				self.IncorrectTries = {}
				
				--[[if code then
					print(code, guestCode)
				end]]
			end
		end
	end
	--print("loading data for", benchModel.Name, benchData, self)
	if not (benchModel and benchModel.Parent) then return end
	local open = benchModel:GetAttribute("Open")
	if open ~= nil and open ~= self.OpenStart then
		local openFunc = self[self.Logic]
		if openFunc then
			benchModel:SetAttribute("Open", (not benchModel:GetAttribute("Open")))
			task.defer(openFunc, self, 100000)
		end
	end
	self.OpenStart = nil
end

function BenchClass:GetClientInfo(player: Player)
	local benchModel = self.Model
	local authorized = self.Authorized
	local owner = self.Owner
	local info = {}
	local clientInfo = {Info = info}
	if authorized then
		info.Access = (table.find(authorized, player.UserId) ~= nil)
	elseif owner then
		info.Owned = (owner == player.UserId)
	else
		return
	end
	clientInfo.Bench = benchModel
	return clientInfo
end

function BenchClass:Delete(offset)
	local pileObj = self.PileObject
	local spawnArea = self.SpawnArea
	local benchModel = self.Model
	if pileObj then
		local digPiles = (shared.DigPiles or {})
		local pileTable = digPiles[pileObj]
		if pileTable then
			local foundIndex = table.find(pileTable, self)
			if foundIndex then
				table.remove(pileTable, foundIndex)
				if #pileTable <= 1 then
					local terrainInfo = pileTable[1]
					digPiles[pileObj] = nil
					if spawnArea then
						spawnArea:RemoveFromContainer("DigPiles", pileObj)
					end
					--print("DIG PILE FULLY LOOTED", spawnArea)
					task.delay(math.random(5, 10), function()
						Terrain:WriteVoxels(terrainInfo[1], 4, terrainInfo[2], terrainInfo[3])
						pileObj:Destroy()
					end)
				end													
			end
		end
	elseif spawnArea then
		--print("YES")
		spawnArea:RemoveFromContainer(benchModel.Name, benchModel)
	end
	local benchPrim = benchModel.PrimaryPart
	if benchPrim and offset then
		self:CreateBenchBag((benchPrim.CFrame * CFrame.new(offset)).Position)
	end
	if self.Text and benchModel then
		local guiReference = benchModel:FindFirstChild("GuiReference")
		local signGui = guiReference ~= nil and guiReference.Value
		if typeof(signGui) == "Instance" then
			signGui:Destroy()
		end
	end
	shared.Benches[benchModel] = nil
	shared.ActiveBenches[benchModel] = nil
	local beds = self.BedTableReference
	local ownerId = self.Owner
	if beds and ownerId then
		local bedIndex = table.find(beds, benchModel)
		if bedIndex and bedIndex > 0 then
			beds[bedIndex] = nil
			local ownerPlayer = Players:GetPlayerByUserId(ownerId)
			local ownerUser = (ownerPlayer ~= nil and shared.Users[ownerPlayer])
			if ownerUser then
				ownerUser:UpdateBedInfos(beds)
			end
			--print(shared.Beds)
		end
	end
	self = nil
end

function BenchClass:ToggleTrap(b: boolean, tweenDuration: number?)
	local benchModel = self.Model
	if not benchModel then return end
	local centerCF = benchModel.TouchCollision.CFrame
	local rightClamp = benchModel:FindFirstChild("RightClamp")
	if not rightClamp then return end
	local leftClamp = benchModel:FindFirstChild("LeftClamp")
	if not leftClamp then return end
	tweenDuration = (tweenDuration or 0.4)
	if tweenDuration ~= 0 then
		benchModel.PrimaryPart[b and "Open" or "Close"]:Play()
	end
	benchModel:SetAttribute("Armed", b)
	local direction = (b and -1 or 1)
	local rightClampCF = rightClamp.CFrame
	local leftClampCF = leftClamp.CFrame
	local offsetRight = centerCF:ToObjectSpace(rightClampCF)
	local offsetLeft = centerCF:ToObjectSpace(leftClampCF)
	local cfRight = centerCF * CFrame.Angles(0, 0, math.rad(80 * direction)) * offsetRight
	local cfLeft = centerCF * CFrame.Angles(0, 0, math.rad(-80 * direction)) * offsetLeft
	TweenUtil:Tween(rightClamp, "CFrame", cfRight, tweenDuration, "Bounce", "Out")
	TweenUtil:Tween(leftClamp, "CFrame", cfLeft, tweenDuration, "Bounce", "Out")
	self:ChangeOptions()	
end

function BenchClass:SetupTurret()
	--print("yes")
	local benchModel = self.Model
	if not benchModel then return end
	local collision = benchModel:FindFirstChild("TouchCollision")
	if not collision then return end
	local gun = benchModel:FindFirstChild("Gun")
	if not gun then return end
	local effects = gun:FindFirstChild("ParticleHolder")
	if not effects then return end
	local shootFrom = gun:FindFirstChild("ShootFrom")
	if not shootFrom then return end
	local doingLoop = false
	local currentChars = {}
	local oldTouchCon = self.TouchConnection
	if oldTouchCon then
		oldTouchCon:Disconnect()
	end
	--print("SETUP TOUCH EVENT")
	local lastCheck = 0
	local authorized
	local touchCon; touchCon = collision.Touched:Connect(function(hit)
		local c = os.clock()
		if c - lastCheck >= 2 then
			lastCheck = c
			authorized = nil
			local baseCabinet = RaycastUtil:GetBaseCabinetUnder(benchModel.PrimaryPart.Position)
			if baseCabinet and not baseCabinet:GetAttribute("Monument") then
				local cabinet = shared.Benches[baseCabinet]
				if cabinet then--and #cabinet.Authorized > 0 then --if this is enabled, will only shoot once at least 1 person has auth
					authorized = cabinet.Authorized
					--authorized = {} --enabling this will make it so it shoots anyone
				end
			end
			--print("updated turret auth", authorized)
		end
		if not hit or not authorized or hit.Name:find("Arm") or hit.Name:find("Hand") then return end
		local character = hit.Parent
		if not character or currentChars[character] or not character:IsA("Model") then return end
		local humanoid = character:FindFirstChild("Humanoid")
		local charPrim = character.PrimaryPart
		if not (humanoid and humanoid.Health > 0 and charPrim) then return end
		local player = Players:GetPlayerFromCharacter(character)
		if player and table.find(authorized, player.UserId) then return end
		-- Add the player and start loop
		currentChars[character] = {humanoid, player}
		--print("added", character, "to table")
		if doingLoop then return end
		local shootSound = benchModel.PrimaryPart.Shoot
		--print("starting loop")
		doingLoop = true
		while benchModel.Parent do
			local characters = {}
			for char, t in pairs(currentChars) do
				local hum = t[1]
				local plr = t[2]
				if not (char.Parent and hum and hum.Parent and hum.Health > 0 and char.PrimaryPart and not (plr and table.find(authorized, plr.UserId))) then
					currentChars[char] = nil
					continue
				end
				table.insert(characters, char)
			end
			if #characters <= 0 then break end
			local params = OverlapParams.new()
			params.FilterType = Enum.RaycastFilterType.Include
			params.FilterDescendantsInstances = characters
			params.CollisionGroup = "Players"
			local parts = workspace:GetPartsInPart(collision, params)
			local shootCF = shootFrom.WorldCFrame
			local shootPos = shootCF.Position
			local doShoot = false
			local isOccupied = false
			local charsInside = {}
			for _, part in pairs(parts) do
				if part.Name:find("Arm") or part.Name:find("Hand") then continue end
				local char = part.Parent
				if not char or charsInside[char] then continue end
				local t = currentChars[char]
				if not t or not t[1] or not t[1].Parent then continue end
				local prim = char.PrimaryPart
				if not prim then continue end
				isOccupied = true
				charsInside[char] = t
				--print("checking for", char)
				local isObstructed = RaycastUtil:Raycast(shootPos, prim.Position - shootPos, "Exclude", {VFX_PARTS, Drops, Plants, char, benchModel}, false, viewFilterFunc, true)
				if isObstructed then continue end
				doShoot = true
				break
			end
			currentChars = charsInside
			local turretStats = self.TurretStats
			if doShoot then
				local foundAmmo = false
				local container = self.Container
				local updates = {}
				for index, itemTable in pairs(container) do
					local item = itemTable.Item
					local typ = itemTable.Type
					if not item or item == 0 or item.Amount <= 0 then continue end
					item.Amount -= 1
					if item.Amount <= 0 then
						item = 0
					end
					self:UpdateSlot(index, item)
					table.insert(updates, {"Bench", index, item})
					foundAmmo = true
					break
				end
				if not foundAmmo then
					touchCon:Disconnect()
					return
				end
				local allEffects = effects:GetChildren()
				for _, effect in pairs(allEffects) do
					effect.Enabled = true
				end
				shootSound:Stop()
				shootSound.PlaybackSpeed = 1.5 + math.random(-8, 8) / 100
				shootSound:Play()
				for i = 1, turretStats.BulletCount do
					local offset = turretStats.BulletRadius * math.sqrt(math.random())
					local rotation = math.random() * 2 * math.pi
					local aimTo = (shootCF * CFrame.new(turretStats.BulletRange, 0, 0) * CFrame.Angles(rotation, 0, 0) * CFrame.new(0, offset, 0)).Position
					local bulletHit, bulletPos, bulletNor, bulletMat = RaycastUtil:Raycast(shootPos, aimTo - shootPos, "Exclude", {VFX_PARTS, Drops, Plants, benchModel}, false, hitFilterFunc, true)
					local hitPos = (bulletHit and bulletHit.CFrame:PointToObjectSpace(bulletPos))
					local rawDamage = turretStats.Damage
					local dropoff = turretStats.DamageRange
					DamageModule:Damage(bulletHit, hitPos, bulletNor, shootCF, {
						Head = rawDamage * 1.5;
						Chest = rawDamage;
						Arms = rawDamage;
						Legs = rawDamage * 0.75;
						Bleed = turretStats.Bleed;
					}, {Start = dropoff[1], End = dropoff[2]}, nil, nil, "Shotgun Turret", nil, "Bullet")
				end
				task.delay(0.1, function()
					if not effects.Parent then return end
					for _, effect in pairs(allEffects) do
						effect.Enabled = false
					end
				end)
				if #updates > 0 then
					self:UpdatePlayers(updates)
				end
			elseif not isOccupied then
				break
			end
			task.wait(turretStats.Cooldown)
		end
		if not benchModel.Parent then return end
		--print("ended loop")
		doingLoop = false
	end)
	self.TouchConnection = touchCon
	return touchCon
end

return BenchClass