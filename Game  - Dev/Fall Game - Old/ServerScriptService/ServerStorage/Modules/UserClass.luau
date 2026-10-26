-- [PATH] ServerStorage / Modules / UserClass @Type ModuleScript

--[[
	UserClass
	by ChickenBagelz
	July 16, 2022
	
	Holds all ItemClasses in your inventory and controls different inventory interactions
]]


-- Services
local Players = game:GetService("Players")
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage")
local ScriptService = game:GetService("ServerScriptService")
local Marketplace = game:GetService("MarketplaceService")

-- Dependencies
local InventoryService = ScriptService:WaitForChild("InventoryService")
local StatsService = ScriptService:WaitForChild("StatsService")
local UserService = ScriptService:WaitForChild("UserService")
local ServerService = ScriptService:WaitForChild("ServerService")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local Animations = Storage:WaitForChild("Animations")
local SharedModules = Replicated:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")
local ItemModels = Storage:WaitForChild("Items")
local VMs = Replicated:WaitForChild("VMs")
local Values = Replicated:WaitForChild("Values")
local Benches = Replicated:WaitForChild("Benches")
local PlayerSounds = Replicated:WaitForChild("PlayerSounds")
local Bases = workspace:WaitForChild("Bases")
local PreSpawns = workspace:WaitForChild("PreSpawns")
local RepPart = Storage:WaitForChild("ReplicationPart")

-- Remotes/Events
local VFXRemotes = Remotes:WaitForChild(string.char(117, 120, 9, 96, 94, 13, 91, 23, 14, 148, 185, 74, 28, 140, 96, 114, 26, 142, 147, 134, 186, 127, 154, 150, 62, 16, 83, 53, 24, 157))
local BenchRemotes = Remotes:WaitForChild(string.char(80, 174, 145, 85, 122, 27, 174, 146, 106, 51, 133, 27, 138, 20, 188, 5, 143, 181, 154, 67, 20, 136, 79, 62, 36, 5, 34, 30, 25, 108))
local StatsRemotes = Remotes:WaitForChild(string.char(32, 175, 56, 160, 50, 187, 113, 77, 49, 22, 130, 142, 126, 38, 59, 102, 17, 6, 168, 41, 9, 180, 85, 142, 105, 14, 66, 146, 142, 126))
local AllRemotes = {
	Visualize = string.char(103, 133, 9, 154, 39, 163, 146, 21, 57, 183, 145, 92, 150, 21, 92, 2, 189, 66, 182, 45, 146, 49, 108, 138, 183, 131, 181, 117, 142, 7);	
	ActiveBenches = string.char(139, 69, 112, 34, 135, 187, 185, 110, 102, 27, 11, 71, 142, 94, 63, 149, 48, 11, 174, 74, 123, 167, 169, 90, 182, 183, 188, 116, 61, 158);
	SendStats = string.char(79, 32, 52, 90, 156, 106, 154, 4, 122, 24, 35, 31, 152, 159, 32, 108, 184, 86, 28, 97, 6, 28, 22, 147, 8, 79, 15, 125, 32, 45);
	Beds = string.char(164, 108, 132, 60, 36, 116, 108, 123, 186, 188, 156, 154, 99, 105, 140, 181, 54, 76, 125, 29, 107, 74, 18, 9, 116, 100, 167, 132, 87, 163);
	Death = string.char(9, 22, 168, 81, 70, 44, 80, 82, 21, 44, 34, 11, 168, 8, 173, 95, 40, 87, 1, 136, 61, 24, 133, 13, 171, 31, 160, 67, 170, 23);
}

local EVENT_HEALTH_CHANGED = StatsService.HealthChanged

-- Modules
local InventoryClass = require(ServerModules:WaitForChild("InventoryClass"))
local CharacterAppearanceClass = require(ServerModules:WaitForChild("CharacterAppearanceClass"))
local StatsClass = require(ServerModules:WaitForChild("StatsClass"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local FallenGuard = require(ServerModules:WaitForChild("FallenGuard"))
local Items = require(SharedModules:WaitForChild("Items"))
local ToolInfo = require(SharedModules:WaitForChild("ToolInfo"))
local WeldModule = require(SharedModules:WaitForChild("WeldModule"))
local ItemClass = require(SharedModules:WaitForChild("ItemClass"))
local LootTableModule = require(ServerModules:WaitForChild("LootTableModule"))
local ArmorModule = require(SharedModules:WaitForChild("ArmorModule"))
local UserStatsClass = require(ServerModules:WaitForChild("UserStatsClass"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local CrafterClass = require(ServerModules:WaitForChild("CrafterClass"))
local ResearchModule = require(SharedModules:WaitForChild("ResearchModule"))
local DataModule = require(ServerModules:WaitForChild("DataModule"))

-- Gamepasses
local Gamepasses = {
	ImageFrames = 667425168;
	VIP = 667913153;
	LegacyVIP = 6484559;
}

--CONSTANTS
local NAME_TAG = Storage:WaitForChild("NameTag")

-- Local Variables
local allSpawnParts
local availableSpawns
local usedSpawns = {}

-- Global Functions
shared.CreateDeathBag = function(character, userId, displayName, containers, fallenGuard, ignoreAttribute)
	if ignoreAttribute ~= true and not UserService:GetAttribute("DeathBagsEnabled") then return end
	local primPart = character.PrimaryPart
	local bagCF
	if not primPart then
		if fallenGuard then
			bagCF = fallenGuard.LastCFrame
		end
	else
		bagCF = primPart.CFrame
	end
	if bagCF then
		local benches = Bases.Loners:FindFirstChild("Body Bag")
		if not benches then
			benches = Instance.new("Folder")
			benches.Name = "Body Bag"
			benches.Parent = Bases.Loners
		end
		local benchModel, bench = shared.CreateBench(Benches["Body Bag"].Default, "Body Bag", bagCF, benches, 0, 0)
		benchModel:SetAttribute("OwnerName", displayName) -- player.DisplayName
		benchModel:SetAttribute("BelongsTo", userId)
		local benchContainer = bench.Container
		if fallenGuard then
			local benchIndex = 0
			for _, containerName in pairs({"Inventory", "Toolbar", "Armor"}) do
				local container = containers[containerName]
				--print(container)
				for index, containerItem in pairs(container) do
					benchIndex += 1
					local itemTable = benchContainer[benchIndex]
					itemTable.Item = (containerItem or 0)
				end
			end
		elseif containers then
			for index, itemTable in pairs(benchContainer) do
				local sleeperItemTable = containers[index]
				if not sleeperItemTable then continue end
				itemTable.Item = sleeperItemTable.Item
				sleeperItemTable.Item = 0
			end
		end
		benchContainer[38].Item = ItemClass.new(107, 1, "Default", 0, 0, nil, nil, nil, userId) -- player.UserId
		local dropTable = shared.AddDroppedItem(benchModel)
		task.defer(shared.SetupDrop, dropTable, true)
		--print(bench)
	end
end


local UserClass = {}
UserClass.__index = UserClass

function UserClass.new(player, data, _userData)
	local self = setmetatable({}, UserClass)
	self.Player = player
	self.UserId = player.UserId
	self.FirstSpawn = true

	local userData = self:DecodeUserData(_userData)

	-- Inventory
	local inventory = InventoryClass.new(player)
	self.Inventory = inventory

	-- Crafter
	self.Crafter = CrafterClass.new(player)
	self.ResearchLevels = (userData[1] or {})

	--Character Appearance
	self.CharacterAppearance = CharacterAppearanceClass.new(player, data.CharacterAppearance)

	--Team
	self.TeamIndex = 0
	task.defer(function()
		while not shared.Teams do task.wait() end
		local teamIndex = 0
		for index, team in pairs(shared.Teams) do
			for _, userId in pairs(team) do
				if tonumber(userId) ~= player.UserId then continue end
				teamIndex = index
				break
			end
			if teamIndex > 0 then break end
		end
		self.TeamIndex = teamIndex
	end)

	--Spawn Index
	self.SpawnIndex = 0 --used for indexing which bag they spawned on, or 0 if random

	--StatsClass
	self.Stats = StatsClass.new(player)

	--UserStatsClass
	local userStats = UserStatsClass.new(player, data.UserStats)
	self.UserStats = userStats

	self.Skins = data.Skins
	
	self.BottleCaps = data.BottleCaps
	self.Bundles = data.Bundles
	
	self.DailyInfo = data.DailyInfo
	
	self.TotalPlayTime = data.TotalPlayTime
	self.LastFlags = data.LastFlags
	self.StartTime = os.time()
	self.Equipped = {}
	self.BulletQueue = {}
	self.ReloadIndex = 0

	self.CombatWins = (data.CombatWins or 0)

	local fallenGuard = FallenGuard.new(player)
	self.FallenGuard = fallenGuard

	self.Bench = nil
	self.Died = false
	--self.BlueprintAutoUpgrade = "Stone"
	
	self.AttachmentConfigs = {}
	
	self.OwnedPasses = {}

	-- Character setup
	
	--local first = true
	player.CharacterAdded:Connect(function(character)
		--[[if not first then return end
		first = false]]
		self.Died = false
		fallenGuard:RefreshMoveStates()
		self.Equipped = {
			Index = 0;
			Item = nil;
			Model = nil;
		}
		self.LoadedSounds = {}
		self.NearbyBenches = {}
		self.Holster = nil
		self.JumpId = 0
		self.KilledBy = nil
		self.CauseOfDeath = nil
		self.Digging = false
		self.LastDamagedByUserId = nil
		self.LastDamagedByItem = nil
		self.LastAttacks = {}
		self.Biome = nil
		local spawnTime = os.time()
		self.LastSpawn = spawnTime
		inventory:ClearInventory()
		local spawnedFromSleeper = false
		local spawnCFrame, spawnHealth, spawnHunger, spawnThirst, spawnBleed, spawnRad
		if self.FirstSpawn then
			self.FirstSpawn = nil
			local sleepers = Bases.Loners:FindFirstChild("Sleeper")
			if sleepers then
				local count = 0
				local balls = tick()
				for _, benchModel in pairs(sleepers:GetChildren()) do
					count += 1
					if count % 50 == 0 then task.wait() end
					if not (benchModel and benchModel.Parent) then continue end
					local bench = shared.Benches[benchModel]
					if not bench then continue end
					local sleeperInfo = bench.SleeperInfo
					if not sleeperInfo then continue end
					local userId = sleeperInfo[1]
					if userId ~= player.UserId then continue end
					spawnHealth = benchModel.Humanoid.Health
					if spawnHealth > 0 then
						spawnCFrame = benchModel.PrimaryPart.CFrame
						spawnHunger = sleeperInfo[3]
						spawnThirst = sleeperInfo[4]
						spawnBleed = sleeperInfo[5]
						spawnRad = sleeperInfo[6]
						spawnedFromSleeper = true
					end
					ModUtil:SafeDestroy(benchModel)
					if spawnHealth > 0 then
						for index, itemTable in pairs(bench.Container) do
							local item = itemTable.Item
							if not (item and item ~= 0 and item.Amount > 0) then continue end
							local container = inventory:GetInv()[index <= 24 and "Inventory" or (index <= 30 and "Toolbar" or "Armor")]
							container[index <= 24 and index or (index <= 30 and index - 24 or index - 30)] = item
						end
					else
						spawnHealth = nil
					end
					bench:Delete()
					print(tick() - balls, "secs to find sleeper")
					break
				end
			end
		end
		self.Stats:CreateStats(spawnHunger, spawnThirst, spawnBleed, spawnRad)
		local desiredSpawn = (self.DesiredSpawn or 0)
		while desiredSpawn > 0 and not spawnedFromSleeper do
			local beds = shared.Beds[player.UserId]
			if not beds then break end
			local bed = beds[desiredSpawn]
			if not (bed and bed.Parent) then break end
			local prim = bed.PrimaryPart
			if not prim then break end
			spawnCFrame = CFrame.new((prim.CFrame * CFrame.new(0, 3, 0)).Position)
			break
		end
		self.DesiredSpawn = nil
		spawnCFrame = (spawnCFrame or (function()
			local spawnPart
			local spawnCooldown = UserService:GetAttribute("SpawnPartCooldown")
			if spawnCooldown then
				if not allSpawnParts then
					allSpawnParts = workspace.SpawnParts:GetChildren()
				end
				if not availableSpawns then
					availableSpawns = workspace.SpawnParts:GetChildren()
				end
				-- new spawning algorithm
				if #availableSpawns <= 0 then
					spawnPart = allSpawnParts[math.random(1, #allSpawnParts)]
				else
					local chosenIndex = math.random(1, #availableSpawns)
					spawnPart = availableSpawns[chosenIndex]
					table.remove(availableSpawns, chosenIndex)
				end
				local respawnThread = usedSpawns[spawnPart]
				if respawnThread then
					warn("overwriting spawn cooldown")
					local suc, err = pcall(function()
						task.cancel(respawnThread)
					end)
					if not suc then
						warn("ERROR REFRESHING SPAWN COOLDOWN - "..err)
					end
				end
				usedSpawns[spawnPart] = task.delay(spawnCooldown, function()
					table.insert(availableSpawns, spawnPart)
					usedSpawns[spawnPart] = nil
					--print("cooldown finished", availableSpawns, usedSpawns)
				end)
				--print("starting cooldown", availableSpawns, usedSpawns)
			else
				-- outdated spawning algorithm
				local combatArena = self:IsInCombatArena(true)
				local spawnParts
				if combatArena and combatArena.SpawnParts then
					spawnParts = combatArena.SpawnParts:GetChildren()
				else
					spawnParts = workspace.SpawnParts:GetChildren()
				end
				local positions = {}
				local farthestSpawn, farthestDistSquared
				local rangeThreshold = UserService:GetAttribute("SpawnRangeThreshold")
				for index = 1, #spawnParts do
					local n = math.random(1, #spawnParts)
					local part = spawnParts[n]
					table.remove(spawnParts, n)
					local spawnPos = part.Position
					local closestDist
					for plr, pos in pairs(index == 1 and shared.Users or positions) do
						if index == 1 then
							if plr == player then continue end
							local hum = pos.Humanoid
							if not (hum and hum.Parent and hum.Health > 0) then continue end
							local char = hum.Parent
							local charPrim = char.PrimaryPart
							if not charPrim then continue end
							pos = charPrim.Position
							table.insert(positions, pos)
						end
						local isClose, distSquared = NumberUtil:IsWithin(spawnPos, pos, rangeThreshold)
						if (not isClose) or (closestDist and distSquared > closestDist) then continue end
						closestDist = distSquared
					end
					if not closestDist then
						spawnPart = part
						--print("found isolated spawn", spawnPart, index, #positions)
						break
					end
					task.wait()
					if farthestSpawn and farthestDistSquared < closestDist then continue end
					farthestSpawn = part
					farthestDistSquared = closestDist
				end
				if not spawnPart then
					spawnPart = farthestSpawn
					print("all spawns occupied - going to farthest", spawnPart, farthestDistSquared, #positions)
				end
			end
			return CFrame.new(spawnPart.Position + Vector3.new(0, 3, 0))	
		end)())
		--local replicationPart = self.ReplicationPart
		--if not (replicationPart and replicationPart.Parent) then
		--	replicationPart = RepPart:Clone()
		--	self.ReplicationPart = replicationPart
		--	replicationPart.CFrame = spawnCFrame
		--	replicationPart.Parent = PreSpawns
		--else
		--	replicationPart.CFrame = spawnCFrame
		--end
		--player.ReplicationFocus = replicationPart
		
		if not spawnedFromSleeper then
			if Values.ServerType.Value == "GunGame" then
				--armorTable[1] = ItemClass.new(60, 1) -- Hazmat Suit
				spawnHealth = 100
				local gunLevel = shared.GunGameWeapons[math.min((player:GetAttribute("Points") or 0) + 1, #shared.GunGameWeapons)]
				self:ApplyKits(gunLevel.Weapon, gunLevel.Armor)
				LootTableModule:ApplyLootTableToPlayer(self.Player, shared.WeaponKits[50].Items, nil, nil, true) -- golden shovel
			elseif Values.ServerType.Value ~= "TeamCombat" then
				local armorTable = inventory:GetInv().Armor
				if Values.ServerType.Value == "Custom" then
					armorTable[1] = ItemClass.new(141, 1) -- Steel Helmet
					armorTable[2] = ItemClass.new(142, 1) -- Steel Chestplate
					armorTable[3] = ItemClass.new(143, 1) -- Steel Leggings
					armorTable[4] = ItemClass.new(59, 1) -- Hoodie
					armorTable[5] = ItemClass.new(63, 1) -- Pants
					armorTable[6] = ItemClass.new(111, 1) -- Boots
					armorTable[7] = ItemClass.new(155, 1) -- Salvaged Gloves
				else
					--armorTable[1] = ItemClass.new(207, 1) -- Santa Hat
					--armorTable[1] = ItemClass.new(224, 1) -- Bunny Ears
				end
				if Values.ServerType.Value ~= "Combat" then
					LootTableModule:ApplyLootTableToPlayer(player, LootTableModule:GetLootTable("SpawnLoot"), nil, nil, true)
				end
			end
			--inventory.Containers.Toolbar[3] = ItemClass.new(92, 0)
		end
		if not character:IsDescendantOf(workspace) then
			local ancestryChanged = false
			local thread = task.spawn(function()
				character.AncestryChanged:Wait()
				ancestryChanged = true
			end)
			local started = tick()
			repeat
				task.wait(0.2)
				if self.Left or self.Banned or not player.Parent then 
					task.cancel(thread) 
					return 
				end
			until ancestryChanged or tick() - started >= 60
			local suc, err = pcall(function()
				task.cancel(thread)
			end)
			if not suc then
				warn("ERROR CANCELLING PLAYER SPAWN THREAD - ", err)
			end
			--print(ancestryChanged)
			--character.AncestryChanged:Wait()
		end
		--character.Parent = shared.Characters
		local hum = character:WaitForChild("Humanoid")
		if not hum then return end
		self.Humanoid = hum
		--print(spawnHealth)
		hum.Health = (spawnHealth or math.random(51, 59))
		local connections = {}
		self.Connections = connections
		self.LastHealth = hum.Health
		self.WentDown = false
		table.insert(connections, hum.HealthChanged:Connect(function(hp)
			self.LastHealth = hp
			EVENT_HEALTH_CHANGED:Fire(character, self.Head, hp, self.CharacterAppearance.Mouth)
			self.Stats:UpdateClient()
			--self:CheckDeath(hum)
		end))
		table.insert(connections, hum.StateChanged:Connect(function(state)
			--if state ~= Enum.HumanoidStateType.StrafingNoPhysics and (state ~= Enum.HumanoidStateType.Swimming or os.time() - spawnTime < 30) then return end
			if state ~= Enum.HumanoidStateType.StrafingNoPhysics then return end
			ModUtil:BanPlayer(player.Name, "018", nil, state.Name)
		end))
		table.insert(connections, hum:GetAttributeChangedSignal("Downed"):Connect(function()
			local isDown = hum:GetAttribute("Downed")
			self.WentDown = isDown
			shared.SetModelCollision(character, isDown and "Bodies" or "Players", nil, ((not isDown) and "PlayersTop"))
		end))
		hum.BreakJointsOnDeath = false
		for _, anim in pairs(Animations:GetChildren()) do
			anim:Clone().Parent = hum
		end
		self.CharacterAppearance:LoadAppearance()
		shared.SetModelCollision(character, "Players", nil, "PlayersTop")
		local head = character:WaitForChild("Head")
		if not head then return end
		self.Head = head
		local rootPart = character:WaitForChild("HumanoidRootPart")
		if not rootPart then return end
		head:SetAttribute("Cuts", 0)
		--head.CanCollide = true
		rootPart.Size = Vector3.new(2, 2.5, 2)
		local loadedArea = false
		local posChangeAmount = 0
		local posChangeCon
		local spawningIn = false
		local function spawnChar()
			if spawningIn then return end
			spawningIn = true
			local started = tick()
			while not loadedArea do
				if tick() - started >= 60 then
					if posChangeCon then
						posChangeCon:Disconnect()
					end
					return 
				end
				task.wait(0.1) 
			end
			task.wait(0.1)
			--print("doing tp")
			--player.ReplicationFocus = nil
			--if replicationPart and replicationPart.Parent then
			--	replicationPart:Destroy()
			--end
			fallenGuard.LastCFrame = spawnCFrame
			character:PivotTo(spawnCFrame)
			fallenGuard.Spawned = true
			posChangeCon:Disconnect()
		end
		posChangeCon = rootPart:GetPropertyChangedSignal("Position"):Connect(function()
			posChangeAmount += 1
			--print("changed pos")
			if posChangeAmount ~= 2 then return end
			spawnChar()
		end)
		table.insert(connections, posChangeCon)
		local insertName = NAME_TAG:Clone()
		insertName.Label.Text = player.DisplayName
		insertName.PlayerToHideFrom = player
		insertName.Adornee = rootPart
		insertName.Parent = rootPart.Parent
		self:UpdateArmors()
		self:UpdateHolsters()
		EVENT_HEALTH_CHANGED:Fire(character, head, hum.Health, self.CharacterAppearance.Mouth) --Update characters mouth and eyes to reflect hp
		-- Reapply tags
		task.delay(1, function()
			if not (character and character.Parent) then return end
			for _, part in pairs(character:GetChildren()) do
				if not part:IsA("BasePart") then continue end
				shared.GiveInstanceId(part)
			end
			shared.GiveInstanceId(character)
			spawnChar()
			task.wait(5)
			if not (character and character.Parent and rootPart.Parent) then return end
			if not NumberUtil:IsWithin(PreSpawns:GetPivot().Position, rootPart.Position, 50) then return end
			warn("failsafe teleporting player")
			self:ToggleMovementChecks(false)
			self:ToggleFallDamage(false)
			character:PivotTo(spawnCFrame)
			task.wait(1)
			self:ToggleMovementChecks(true)
			self:ToggleFallDamage(true)
		end)
		--print("loading area")
		player:RequestStreamAroundAsync(spawnCFrame.Position, 10)
		loadedArea = true
		--print("area finished")
	end)

	player:GetPropertyChangedSignal("Team"):Connect(function()
		local team = player.Team
		if team == nil or (team.Name ~= "Attackers" and team.Name ~= "Defenders") then return end
		local targetCode = (team.Name == "Attackers" and "14789" or "25888")
		local userId = player.UserId
		local count = 0
		for benchModel, bench in pairs(shared.Benches) do
			if not (benchModel and benchModel.Parent) then continue end
			count += 1
			if count % 300 == 0 then task.wait() end
			local code = bench.Code
			local guests = bench.Guests
			if code == targetCode and guests and not table.find(guests, userId) then
				table.insert(guests, userId)
			end
		end
		print("ADDED CODE", targetCode, "TO ALL APPLICABLE BENCHES")
	end)

	-- Mod menu setup
	local privileges = ModUtil:HasSpecialPrivileges(player.UserId)
	if privileges == "Owner" or privileges == "Mod" then
		task.delay(5, function()
			if not (player and player.Parent) then return end
			local adminMenu = Storage.AdminMenu:Clone()
			adminMenu.Parent = player.PlayerGui
		end)
	end

	-- Update active benches to player
	task.defer(function()
		while Values.Loading.Value or not ServerService:GetAttribute("BasesLoaded") do task.wait(1) end
		task.wait(5)
		if not (player and player.Parent) then return end
		local beds = shared.Beds[player.UserId]
		if beds then
			self:UpdateBedInfos(beds)
		end
		self:RefreshActiveBenches()
	end)
	
	task.defer(function()
		if not (self:OwnsPass("VIP") or self:OwnsPass("LegacyVIP")) then return end
		player:SetAttribute("VIP", true)
	end)

	return self
end

function UserClass:RefreshActiveBenches()
	local clientInfos = {}
	local player = self.Player
	local total = 0
	for benchModel, bench in pairs(shared.ActiveBenches) do
		total += 1
		if total % 60 == 0 then task.wait() end
		if not benchModel then continue end
		if not benchModel.Parent then
			shared.ActiveBenches[benchModel] = nil
			continue
		end
		local clientInfo = bench:GetClientInfo(player)
		if not clientInfo then continue end
		table.insert(clientInfos, clientInfo)
	end
	--print(clientInfos)
	if #clientInfos > 0 then
		self:UpdateBenchClientInfo(true, unpack(clientInfos))
	end
end

function UserClass:CheckDeath(humanoid)
	humanoid = (humanoid or self.Humanoid)
	if not (humanoid and humanoid.Parent and humanoid.Health <= 0 and not self.Died) then return end
	local player = self.Player
	local character = humanoid.Parent
	if not character then return end 
	--print(player.Name, "died on server")
	if self.CombatAlive then
		self.CombatAlive = false
	end
	self.Died = true
	self.LastHealth = 0
	self.WentDown = false
	local fallenGuard = self.FallenGuard
	local userStats = self.UserStats
	local inventory = self.Inventory
	local connections = self.Connections
	local crafter = self.Crafter
	for _, connection in pairs(connections) do
		connection:Disconnect()
	end
	fallenGuard:ClearJumpThreads()
	self.Connections = nil
	if humanoid:GetAttribute("Downed") ~= true then
		if not self:DropHeldItem() then
			self:Equip(0)
		end
	end
	crafter:CancelAllCrafts()
	local containers = {}
	for index, value in pairs(inventory:GetInv()) do
		containers[index] = value
	end
	inventory:ClearInventory()
	local causeOfDeath = self.CauseOfDeath
	local deathFrom, killedBy
	if type(causeOfDeath) == "number" then
		killedBy = (self.KilledBy or 0)
		local itemInfo = Items[causeOfDeath]
		if itemInfo then
			deathFrom = itemInfo.Name
		end
	end
	userStats:Synchronize("AddDeath", (deathFrom or causeOfDeath or "Unknown"), killedBy)
	ModUtil:FireClient(StatsRemotes, AllRemotes.Death, player, os.time() - self.LastSpawn, causeOfDeath, self.KilledBy)
	-- Drop death bag
	shared.CreateDeathBag(character, player.UserId, player.DisplayName, containers, fallenGuard)
end

function UserClass:Equip(index)
	local equipped = self.Equipped
	local inventory = self.Inventory
	local containers = inventory:GetInv()
	local toolbar = containers.Toolbar
	local item = toolbar[index]
	local curIndex = equipped.Index
	local curItem = equipped.Item
	if curIndex ~= index or curItem ~= item then
		equipped.OldIndex = curIndex
		equipped.OldItem = curItem
		local itemInfo = (type(item) == "table" and Items[item.ID])
		local canEquip = (type(item) == "table" and (itemInfo.Type == "Tool" or itemInfo.Type == "Gun" or itemInfo.Type == "Bench") and (itemInfo.MaxDurability == nil or item.Durability > 0))
		equipped.Index = (canEquip and index or 0)
		equipped.Item = (canEquip and item)
		--print("updated equipped", equipped, canEquip)
		return self:UpdateEquippedTool()
	end
end

function UserClass:UpdateEquippedTool()
	local player = self.Player
	local char = player.Character
	if not (char and char.Parent) then return end

	local charPrim = char.PrimaryPart
	if not charPrim then return end

	local equipped = self.Equipped
	local inventory = self.Inventory
	local containers = inventory:GetInv()
	local toolbar = containers.Toolbar
	local item = equipped.Item
	local loadedSounds = (self.LoadedSounds or {})
	--print(equipped.Index, item, equipped.OldItem)
	if equipped.Index == 0 or equipped.OldItem ~= item then-- or toolbar[equipped.Index] ~= item then
		local model = equipped.Model
		if model and model.Parent then
			model:Destroy()
		end
	end
	repeat
		if not (item and item ~= 0 and item.Amount > 0) then continue end
		local itemInfo = Items[item.ID]
		local itemName = (itemInfo.Type == "Bench" and "Blueprint" or itemInfo.Name)
		local toolInfo = ToolInfo[itemName]
		if not toolInfo then continue end
		local offsets = toolInfo.Offsets
		local itemModel = ItemModels:FindFirstChild(itemName)
		if not itemModel then continue end
		if itemModel:IsA("Folder") then
			itemModel = (itemModel:FindFirstChild(item.Skin or "Default") or itemModel:FindFirstChild("Default"))
		end
		if not loadedSounds[itemName] then
			local soundFolder = PlayerSounds:FindFirstChild(itemName)
			if soundFolder then
				loadedSounds[itemName] = true
				for _, sound in pairs(soundFolder:GetChildren()) do
					local name = sound.Name
					local newSound = ModUtil:SafeClone(sound)
					newSound.Name = itemName..name
					if name == "Shoot" then
						local backupTag = Instance.new("ObjectValue")
						backupTag.Name = "Backup"
						backupTag.Value = sound
						backupTag.Parent = newSound
					end
					newSound.Parent = charPrim
				end
				--print("loaded sounds for", itemName)
			end
		end
		itemModel = ModUtil:SafeClone(itemModel)
		itemModel.Name = itemInfo.Name
		itemModel.PrimaryPart = (itemModel:FindFirstChild("Main") or itemModel:FindFirstChild("Handle"))
		itemModel.Parent = char
		WeldModule:WeldAttachments(itemModel, item)
		local weld = WeldModule:WeldModelToPart(itemModel, char:FindFirstChild("RightHand"), ((offsets and offsets.Global) or CFrame.new()), false)
		weld.Parent = itemModel.PrimaryPart
		equipped.Model = itemModel
		self:UpdateAttachments()

	until true
	--print("updated server tool", equipped)
	self:UpdateHolsters()
	return true
end

function UserClass:DropHeldItem(ignoreAttribute: boolean)
	if ignoreAttribute ~= true and not UserService:GetAttribute("DropToolsOnDeath") then return end
	self.IgnoreInv = os.clock()
	local player = self.Player
	local character = player.Character
	if not character then return end
	local charPrim = character.PrimaryPart
	if not (charPrim and charPrim.Parent) then return end
	local equipped = self.Equipped
	local inventory = self.Inventory
	local toolbar = inventory:GetToolbar()
	local equippedModel = equipped.Model
	local equippedIndex = equipped.Index
	if not (equipped.Item and equippedModel) then return end
	local equippedItem = toolbar[equippedIndex]
	if not equippedItem or equippedItem == 0 or equippedItem.Amount <= 0 then return end
	local equippedInfo = Items[equippedItem.ID]
	if not equippedInfo then return end
	local equippedToolInfo = ToolInfo[equippedInfo.Name]
	if not equippedToolInfo then return end
	--self:Equip(0)
	toolbar[equippedIndex] = 0
	inventory:UpdateClient({"Toolbar", equippedIndex, toolbar[equippedIndex], "UpdateEquipped"})
	InventoryService.DropItem:Invoke(player, equippedItem, equippedItem.Amount, charPrim.CFrame)
	--print("dropping", toolbar)
	return true
end

function UserClass:UpdateAttachments()
	local equipped = self.Equipped
	local player = self.Player
	local toolbar = self.Inventory:GetToolbar()
	local equippedItem = toolbar[equipped.Index]
	local equippedModel = equipped.Model
	if not (equippedItem and equippedModel) then return end
	local attachments = (equippedItem.Attachments or {})
	for _, attachment in pairs(attachments) do
		local attachmentInfo = Items[attachment.ID]
		local attachmentStats = attachmentInfo.AttachmentStats
		local attachmentFolder = equippedModel:FindFirstChild("Attachments")
		if not (attachmentFolder and attachmentStats and attachmentStats.Toggle) then continue end
		local attachmentModel = attachmentFolder:FindFirstChild(attachmentInfo.Name)
		if not attachmentModel then continue end
		local isOn = attachment.On
		if attachmentInfo.Name == "Weapon Flashlight" then
			attachmentModel.Base.Light.Enabled = isOn
			attachmentModel.Base.Extender.Light1.Enabled = isOn
			attachmentModel.Base.Extender.Light2.Enabled = isOn
			attachmentModel.Base.Glare.PlayerToHideFrom = player
			attachmentModel.Base.Glare.Enabled = isOn
		elseif attachmentInfo.Name:find(" Lasersight") then
			local laser = attachmentModel.Laser
			laser.Laser.Enabled = isOn
			if not isOn then continue end
			for _, plr in pairs(Players:GetPlayers()) do
				if plr == player then continue end
				ModUtil:FireClient(VFXRemotes, AllRemotes.Visualize, plr, "InitializeLaser", equippedModel)
			end
		end
	end
end

function UserClass:UpdateHolsters()
	--print("updating holsters")
	local player = self.Player
	local character = player.Character
	local equipped = self.Equipped
	local inventory = self.Inventory
	local containers = inventory:GetInv()
	local found = {}
	for _, containerName in pairs({"Toolbar", "Inventory"}) do
		local container = containers[containerName]
		for index, item in pairs(container) do
			if item == 0 or item.Amount <= 0 then continue end
			local itemInfo = Items[item.ID]
			local itemWorth = itemInfo.ItemWorth
			local weldInfo = itemInfo.WeldInfo
			if (containerName == "Toolbar" and equipped.Index == index) or (itemInfo.MaxDurability and (item.Durability or 0) <= 0) or not (itemWorth and weldInfo) then continue end
			table.insert(found, {containerName, index, itemWorth})
		end
	end
	table.sort(found, function(a, b)
		return a[3] > b[3]
	end)
	--print(found)
	if not (character and character.Parent) then return end
	local chosen = found[1]
	local containerName = (chosen and chosen[1])
	local itemIndex = (chosen and chosen[2])
	local container = (chosen and containers[containerName])
	local item = (chosen and container[itemIndex])	
	local itemInfo = (chosen and Items[item.ID])
	local itemName = (chosen and itemInfo.Name)
	local currentHolster = character:FindFirstChild("HolsterModel")
	local currentItem = self.Holster
	--print(item, currentItem, item == currentItem)
	if currentHolster and (chosen == nil or currentItem ~= item) then
		--print("deleting old holster")
		currentHolster:Destroy()
		currentHolster = nil
		self.Holster = nil
	end
	if not itemName then return end
	local itemModel
	if not currentHolster then
		local weldInfo = itemInfo.WeldInfo
		itemModel = ItemModels:FindFirstChild(itemName)
		local weldPart = character:FindFirstChild(weldInfo.Part)
		if not (itemModel and weldPart) then return end
		if itemModel:IsA("Folder") then
			itemModel = (itemModel:FindFirstChild(item.Skin or "Default") or itemModel:FindFirstChild("Default"))
		end
		itemModel = ModUtil:SafeClone(itemModel)
		itemModel.Name = "HolsterModel"
		--print("creating new holster", itemName)
		itemModel.PrimaryPart = (itemModel:FindFirstChild("Main") or itemModel:FindFirstChild("Handle"))
		for _, part in pairs(itemModel:GetChildren()) do
			for _, weld in pairs(part:GetChildren()) do
				if not (weld:IsA("Motor6D") or weld:IsA("Weld")) then continue end
				weld:Destroy()
			end
		end
		itemModel.Parent = character
		self.Holster = item
		local weld = WeldModule:WeldModelToPart(itemModel, weldPart, weldInfo.Offset, true)
	end
	if (currentHolster and item ~= currentItem) then return end
	--print("updating holster appearance")
	WeldModule:WeldAttachments((currentHolster or itemModel), item, true, true)
end

function UserClass:UpdateArmors()
	local player = self.Player
	local character = player.Character
	if not character then return end
	local inventory = self.Inventory
	local allArmors = inventory:GetArmor()
	local didUpdate = ArmorModule:UpdateArmors(character, allArmors, player)
	if not didUpdate then return end
	local armors = ArmorModule:GetArmors(allArmors)
	-- There was an update for armors, update the stats and fire them to the client
	--apply armors to stats
	local newStats = self.Stats:ApplyArmorTable(armors)
	--Send newStats to client to update bars
	ModUtil:FireClient(StatsRemotes, AllRemotes.SendStats, self.Player, nil, newStats)
end

function UserClass:SendBenchInfo(skipLoop: boolean, ...)
	local player = self.Player
	local clientInfos
	if not skipLoop then
		clientInfos = {}
		for _, bench in pairs({...}) do
			local benchModel = bench.Model
			if not (benchModel and benchModel.Parent) then continue end
			local clientInfo = bench:GetClientInfo(player)
			if not clientInfo then continue end
			table.insert(clientInfos, clientInfo)
		end
	else
		clientInfos = {...}
	end
	if #clientInfos <= 0 then return end
	ModUtil:FireClient(BenchRemotes, AllRemotes.ActiveBenches, player, clientInfos)
end

function UserClass:UpdateBenchClientInfo(skipLoop: boolean, ...)
	if Values.Loading.Value then
		local args = {...}
		task.defer(function()
			while Values.Loading.Value do
				task.wait(1)
			end
			self:SendBenchInfo(skipLoop, unpack(args))
		end)
	else
		self:SendBenchInfo(skipLoop, ...)
	end
end

function UserClass:UpdateBedInfos(beds)
	local player = self.Player
	local bedInfos = {}
	for index, bed in pairs(beds) do
		if not (bed and bed.Parent) then continue end
		local bench = shared.ActiveBenches[bed]
		local benchPrim = bed.PrimaryPart
		if not (bench and benchPrim) then continue end
		local bedName = bed:GetAttribute("BedName")
		table.insert(bedInfos, {
			Index = index;
			LastRespawn = (bench.LastRespawn or 0);
			BedTimer = bench.BedTimer;
			Position = benchPrim.Position;
			Name = bedName;
			ID = bed:GetAttribute("ID");
		})
	end
	ModUtil:FireClient(BenchRemotes, AllRemotes.Beds, player, bedInfos)
end

function UserClass:CreateSleeper(ignoreAttribute: boolean)
	if ignoreAttribute ~= true and not ServerService:GetAttribute("SleepersEnabled") then return end
	--print("attempting to create sleeper")
	if self.Dead or (self.LastHealth or 0) <= 0 then return end
	local player = self.Player
	if not player then return end
	--[[local character = player.Character
	if not character then return end
	local charPrim = character.PrimaryPart
	if not charPrim then return end
	local humanoid = character:WaitForChild("Humanoid")
	if not (humanoid and humanoid.Health > 0) then return end]]
	local primCF = self.FallenGuard.LastCFrame
	if not primCF then return end
	local sleepers = Bases.Loners:FindFirstChild("Sleeper")
	if not sleepers then
		sleepers = Instance.new("Folder")
		sleepers.Name = "Sleeper"
		sleepers.Parent = Bases.Loners
	end
	--print("creating sleeper", player)
	local benchModel, bench = shared.CreateBench(Benches.Sleeper.Default, "Sleeper", primCF, sleepers, 0, 0, nil, self, nil, nil, nil, nil)
	--print(benchModel, bench)
end

function UserClass:ApplyKits(weaponKitIndex, armorKitIndex)
	local armorKit = shared.ArmorKits[armorKitIndex]
	local inventory = self.Inventory:GetInv()
	local updates = {}
	local skins = self.Skins or {}
	if armorKit then
		--local armorSkins = {}
		local indexWithSkins = {}
		local uniqueSkins = {}
		local armorTable = inventory.Armor
		for index, _ in pairs(armorTable) do
			local armorId = armorKit.Armors[index]
			local item = (armorId and ItemClass.new(armorId, 1) or 0)
			if type(item) == "table" and item.Skin == "Default" then
				local info = Items[item.ID]
				local allSkins = info.Image
				if type(allSkins) == "table" then
					--local ownedSkins = {}
					local hasSkins = false
					for skin, _ in pairs(allSkins) do
						if skin == "Default" or not table.find(skins, info.Name.."/"..skin) then continue end
						--table.insert(ownedSkins, skin)
						if not hasSkins then
							table.insert(indexWithSkins, index)
							hasSkins = true
						end
						local uniques = uniqueSkins[skin]
						if not uniques then
							uniques = {}
							uniqueSkins[skin] = uniques
						end
						table.insert(uniques, index)
					end
					--armorSkins[armorId] = ownedSkins
				end
			end
			armorTable[index] = item
			table.insert(updates, {"Armor", index, item})
		end
		--print(uniqueSkins)
		while #indexWithSkins > 0 do
			local n = math.random(1, #indexWithSkins)
			local index = indexWithSkins[n]
			local prioritySkins = {}
			local regularSkins = {}
			for skin, indexes in pairs(uniqueSkins) do
				if not table.find(indexes, index) then continue end
				table.insert((#indexes > 1 and prioritySkins or regularSkins), skin)
			end
			local isPrio = math.random(1, 4) <= 3
			if isPrio and #prioritySkins <= 0 then
				isPrio = false
			elseif not isPrio and #regularSkins <= 0 then
				isPrio = true
			end
			local skinsToChoose = (isPrio and prioritySkins or regularSkins)
			if #skinsToChoose > 0 then
				local chosen = math.random(1, #skinsToChoose)
				local skin = skinsToChoose[chosen]
				--print(index, prioritySkins, regularSkins, isPrio, skin, #uniqueSkins[skin], indexWithSkins)
				for _, armorIndex in pairs(uniqueSkins[skin]) do
					local item = armorTable[armorIndex]
					if type(item) ~= "table" or ((item.ID == 141 or item.ID == 145) and math.random(1, 6) == 1) then continue end -- Steel and Salvaged Helmet
					item.Skin = skin
				end
			end
			table.remove(indexWithSkins, n)
		end
	end
	for _, containerName in pairs({"Inventory", "Toolbar"}) do
		local container = inventory[containerName]
		for i, v in pairs(container) do
			container[i] = 0
			table.insert(updates, {containerName, i, 0})
		end
	end
	if #updates > 0 then
		self.Inventory:UpdateClient(unpack(updates))
	end
	local weaponKit = shared.WeaponKits[weaponKitIndex]
	if weaponKit then
		LootTableModule:ApplyLootTableToPlayer(self.Player, weaponKit.Items, nil, nil, true)
	end
	self:UpdateArmors()
	self:UpdateHolsters()
end

function UserClass:CheckLastMovementDetection(character: Model, humanoid: Humanoid, rootPart: Part, mult: number, ignoreRay: boolean)
	local fallenGuard = self.FallenGuard
	local player = self.Player
	if not fallenGuard then return end
	local wasDetected = (tick() - fallenGuard.LastSnapBack <= fallenGuard:FetchAttribute("MovementDetectionCallDropDuration") * (mult or 1))
	--[[if wasDetected then
		warn(player.Name.." CALL WAS DROPPED - REMOTE FIRED WHILE BEING RECENTLY DETECTED FOR MOVEMENT HACK")
	end]]
	local detection = fallenGuard:MovementCheck(0.15, false, self, character, humanoid, rootPart)
	if detection == "Noclip" then
		warn(player.Name.." CALL WAS DROPPED - REMOTE FIRED WHILE BEING RECENTLY DETECTED FOR NOCLIP")
		return "Noclip"
	end
	return wasDetected
end

function UserClass:ToggleFallDamage(b: boolean)
	local fallenGuard = self.FallenGuard
	if not fallenGuard then return end
	fallenGuard.FallDamageEnabled = b
end

function UserClass:ToggleMovementChecks(b: boolean)
	local fallenGuard = self.FallenGuard
	if not fallenGuard then return end
	fallenGuard:SetMovementChecks(b)
end

function UserClass:GetMoveStates()
	local fallenGuard = self.FallenGuard
	if not fallenGuard then return end
	return fallenGuard.MoveStates
end

function UserClass:GetData(saveFriendly, banFriendly)
	local t = {
		Skins = self.Skins;
		BottleCaps = self.BottleCaps;
		Bundles = self.Bundles;
	}
	if saveFriendly then
		t.StartTime = self.StartTime
		t.TotalPlayTime = self.TotalPlayTime + (os.time() - self.StartTime)
		t.LastFlags = self.LastFlags
		t.CharacterAppearance = self.CharacterAppearance:GetData()
		t.UserStats = self.UserStats:GetData()
		t.CombatWins = self.CombatWins
		t.DailyInfo = self.DailyInfo
		t.QueueIndex = self.QueueIndex
	end
	if banFriendly then
		t.Inventory = self.Inventory.Containers
	end
	return t
end

function UserClass:GetUserData()
	local researchLevels = self.ResearchLevels
	local saveableLevels = {}
	local canSave = false
	for benchName, level in pairs(researchLevels) do
		local _, index = ResearchModule:GetInfoFromName(benchName)
		if not (index and index > 0) then continue end
		saveableLevels[tostring(index)] = level
		canSave = true
	end

	return {saveableLevels}, canSave
end

function UserClass:DecodeUserData(userData)
	userData = userData or {}
	local researchLevels = {}
	for index, level in pairs(userData[1] or {}) do
		local researchInfo = ResearchModule:GetInfoFromIndex(tonumber(index))
		if not researchInfo then continue end
		researchLevels[researchInfo.Name] = level
	end
	return {researchLevels}
end

function UserClass:OwnsPass(passName: string)
	local ownedPasses = self.OwnedPasses
	local lastPassOwned = ownedPasses[passName]
	if lastPassOwned and os.time() - lastPassOwned < 30 then
		return true
	end
	local userId = self.UserId
	local passId = Gamepasses[passName]
	if not passId then return end
	local suc, ownsPass = DataModule:SafeFunctionCall(3, 1, function()
		return Marketplace:UserOwnsGamePassAsync(userId, passId)
	end)
	if not suc then
		warn(`Error checking for gamepass {userId} {passName}`)
		return
	end
	return ownsPass
end

function UserClass:GetAllGamepasses()
	return Gamepasses
end

function UserClass:JoinCombatArena(combatArena, team)
	local player = self.Player
	self.CombatArenaIndex = combatArena.Index
	self.CombatAlive = false
	player:SetAttribute("DamageDisabled", true)
	combatArena:AddPlayer(player, self, team)
end

function UserClass:LeaveCombatArena(isDisconnect: boolean, ignoreUpdate: boolean)
	local combatArena = self:IsInCombatArena(true)
	if not combatArena then return end
	local player = self.Player
	if not isDisconnect then
		player.Team = nil
		player:SetAttribute("CombatReady", nil)
		player:SetAttribute("DamageDisabled", true)
		player:SetAttribute("ArenaName", nil)
	end
	local teamTable = shared.Teams[self.TeamIndex]
	if teamTable then
		local foundIndex = table.find(teamTable, self.UserId)
		if foundIndex then
			table.remove(teamTable, foundIndex)
		end			
	end
	self.TeamIndex = 0
	self.CombatArenaIndex = nil
	self.CombatAlive = nil
	combatArena:RemovePlayer(player, ignoreUpdate)
	return true
end

function UserClass:IsInCombatArena(needsPass: boolean)
	local combatArenas = shared.CombatArenas
	if not combatArenas then return end
	local combatArena = combatArenas[self.CombatArenaIndex]
	if combatArena and needsPass and self.AttemptingPassword ~= nil then
		return false
	end
	return combatArena
end

return UserClass
