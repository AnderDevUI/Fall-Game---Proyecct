-- [PATH] ServerStorage / Modules / BenchModule @Type ModuleScript
--[[
	BenchModule
	by ChickenBagelz
	February 12, 2023
	
	Holds all logic for different types of benches
	
	
	DOCUMENTATION:
	
	nice documentation lil bro
]]


-- Services
local ServerScripts = game:GetService("ServerScriptService")
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local Players = game:GetService("Players")
local Users = game:GetService("UserService")
local Text = game:GetService("TextService")

-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")
local InteractService = ServerScripts:WaitForChild("InteractService")
local InventoryService = ServerScripts:WaitForChild("InventoryService")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")
local Scripts = Storage:WaitForChild("Scripts")
local Signs = Replicated:WaitForChild("Signs")
local VFX_STORAGE = Replicated:WaitForChild("VFX")
local VFX_PARTS = workspace:WaitForChild("VFX")
local Drops = workspace:WaitForChild("Drops")
local Plants = workspace:WaitForChild("Plants")


-- Modules
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local LootTableModule = require(ServerModules:WaitForChild("LootTableModule"))
local BenchInfo = require(SharedModules:WaitForChild("BenchInfo"))
local Items = require(SharedModules:WaitForChild("Items"))
local DamageModule = require(ServerModules:WaitForChild("DamageModule"))
local ItemClass = require(SharedModules:WaitForChild("ItemClass"))
local ServerModule = require(ServerModules:WaitForChild("ServerModule"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local RecipeModule = require(SharedModules:WaitForChild("RecipeModule"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))

-- Remotes
local BenchRemotes = Remotes:WaitForChild(string.char(80, 174, 145, 85, 122, 27, 174, 146, 106, 51, 133, 27, 138, 20, 188, 5, 143, 181, 154, 67, 20, 136, 79, 62, 36, 5, 34, 30, 25, 108))
local ChatRemotes = Remotes:WaitForChild(string.char(96, 35, 40, 91, 98, 164, 149, 39, 30, 15, 96, 175, 70, 174, 182, 135, 163, 50, 76, 163, 104, 183, 141, 3, 50, 142, 28, 14, 48, 109))
local VFXRemotes = Remotes:WaitForChild(string.char(117, 120, 9, 96, 94, 13, 91, 23, 14, 148, 185, 74, 28, 140, 96, 114, 26, 142, 147, 134, 186, 127, 154, 150, 62, 16, 83, 53, 24, 157))
local AllRemotes = {
	Change = string.char(101, 174, 125, 80, 107, 99, 116, 157, 132, 169, 40, 119, 37, 163, 5, 18, 93, 127, 108, 101, 116, 179, 178, 121, 123, 32, 131, 88, 93, 77);
	Message = string.char(113, 112, 81, 144, 109, 55, 138, 180, 22, 36, 121, 67, 5, 157, 74, 71, 60, 141, 148, 82, 79, 115, 10, 151, 83, 101, 91, 78, 50, 108);
	Visualize = string.char(103, 133, 9, 154, 39, 163, 146, 21, 57, 183, 145, 92, 150, 21, 92, 2, 189, 66, 182, 45, 146, 49, 108, 138, 183, 131, 181, 117, 142, 7);
}

-- Local Variables
local viewFilterFunc = RaycastUtil:FilterFunction("View")
local hitFilterFunc = RaycastUtil:FilterFunction("Hit")

function AddWheelInfo(wheelInfo: any, name: string, image: string, desc: string?, cost: string?)
	table.insert(wheelInfo, {
		Image = image;
		Name = name;
		Description = (desc or "");
		Cost = (cost or "");
		Selectable = true;
		SelectFirst = (#wheelInfo <= 0);
	})
end

local Functions --Variable that stores all bench module functions

Functions = {
	Initialize = {
		Campfire = function(...)
			local bench, args, _, benchData = ...
			Functions.Initialize.Container(...)
			
			local benchModel = bench.Model
			if args.Comfort then
				benchModel:SetAttribute("Comfort", args.Comfort)
			end
			bench.Heat = args.Heat and args.Heat or nil
			bench.On = (benchData ~= nil and benchData.B == 1)
			bench.FuelMult = args.FuelMult
			bench.InputMult = args.InputMult
			local damageParts = benchModel:FindFirstChild("DamageParts")
			if not damageParts then return end
			local damageHandler = Scripts.DamageHandler:Clone()
			damageHandler:SetAttribute("On", bench.On)
			damageHandler:SetAttribute("Bleed", 0)
			damageHandler:SetAttribute("IsFire", true)
			damageHandler.Parent = damageParts
			damageHandler.Enabled = true
		end;
		Comfort = function(...)
			local bench, args, _, benchData = ...
			Functions.Initialize.Container(...)

			local benchModel = bench.Model
			if args.Comfort then
				benchModel:SetAttribute("Comfort", args.Comfort)
			end
		end;
		Shredder = function(...)
			local bench, args, _, benchData = ...
			Functions.Initialize.Container(...)
			bench.On = (benchData ~= nil and benchData.B == 1)
		end;
		PowerCell = function(...)
			local bench, args, _, benchData = ...
			Functions.Initialize.Container(...)
			bench.On = (benchData ~= nil and benchData.B == 1)
			bench.AutoTurnOn = true
		end;
		Button = function(...)
			local bench, args, _, benchData = ...
			bench.ButtonPressed = 0
		end;
		Damager = function(...)
			local bench, args = ...
			local benchModel = bench.Model
			local damageParts = benchModel:FindFirstChild("DamageParts")
			if not damageParts then return end
			local damageHandler = Scripts.DamageHandler:Clone()
			damageHandler:SetAttribute("Damage", args.Damage)
			damageHandler:SetAttribute("Bleed", args.Bleed)
			damageHandler:SetAttribute("HitTick", args.HitTick)
			damageHandler.Parent = damageParts
			damageHandler.Enabled = true
		end,
		BaseCabinet = function(...)
			local bench, args, user, benchData, isFirst = ...
			Functions.Initialize.Container(...)
			
			local benchModel = bench.Model
			benchModel:SetAttribute("Placed", (benchData and benchData.M or tick()))
			bench.TotalUpkeep = {
				{
					ID = 1; -- Wood Log
					Benches = {};
				};
				{
					ID = 26; -- Stone
					Benches = {};
				};
				{
					ID = 45; -- Iron Shards
					Benches = {};
				};
				{
					ID = 46; -- Steel Metal
					Benches = {};
				};
			}
			bench:UpdateUpkeepCost()
			bench:UpdateUpkeepTime()
			local authorized = (benchData and benchData.J or {})
			bench.Authorized = authorized
			if user then
				local player = user.Player
				if player then
					--print("adding player who placed BC to authorized", player)
					table.insert(authorized, player.UserId)
				end
			end
			if not isFirst then
				for _, u in pairs(shared.Users) do
					u:UpdateBenchClientInfo(false, bench)
				end
			end
		end;
		Container = function(...)
			local bench, args, _, benchData = ...
			local benchModel = bench.Model
			local lootTable
			if args.LootTable then
				lootTable = LootTableModule:GetLootTable(unpack(args.LootTable))
			end
			local containerData = (benchData and benchData.C)
			local slots = args.Slots
			local container = {}
			local isLocal = args.LocalContainer
			if containerData then
				for index = 1, #slots do
					local item = 0
					local itemData = containerData[tostring(index)]
					if itemData and itemData ~= 0 then
						item = ItemClass.new(itemData, ServerModule.DecodeItemData)
						--print("loaded item", item:GetComponents())
					end
					container[index] = {
						Type = slots[index];
						Item = item;
					}
				end
			else
				local gatherMult = (args.IgnoreGatherMult and 1 or ServerService:GetAttribute("GatherMult"))
				local luckMult = (ServerService:GetAttribute("LuckMult"))
				local items = (lootTable and lootTable:Roll(gatherMult, luckMult, args.CombineItems) or {})
				--[[if lootTable then
					print(benchModel, luckMult, gatherMult, lootTable:Roll(gatherMult, luckMult, args.CombineItems, true))
				end]]
				if args.ShuffleItems then
					local j, temp
					for i = #items, 1, -1 do
						j = math.random(i)
						temp = items[i]
						items[i] = items[j]
						items[j] = temp
					end
				end
				local totalSlots = (args.ResizeDynamically and math.min(#items, #slots) or #slots)
				for index = 1, totalSlots do
					container[index] = {
						Type = slots[index];
						Item = (items[index] or 0);
					}
				end
			end
			if isLocal then
				bench.BackupContainer = container
				bench.Container = {}
			else
				bench.Container = container
			end
			bench.LootTable = lootTable
			bench.UI = args.UI
			bench.Players = {}
			bench.DestroyOnEmpty = args.DestroyOnEmpty
			bench.IsLocal = isLocal
			bench.MaxStack = args.MaxStack
			if args.OnePersonOnly then
				benchModel:SetAttribute("Occupied", false)
			end
			local benchPrim = benchModel.PrimaryPart
			if benchPrim and benchModel.Name ~= "Body Bag" and benchModel.Name ~= "Contents" and benchModel.Name ~= "Sleeper" then
				local parentCon; parentCon = benchPrim:GetPropertyChangedSignal("Parent"):Connect(function()
					if benchPrim.Parent then return end
					bench:CreateBenchBag(benchPrim.Position)
					parentCon:Disconnect()
				end)
			end
			if benchPrim and benchModel.Name == "Christmas Tree" then
				for _, attachment in pairs(benchPrim:GetChildren()) do
					for _, fx in pairs(attachment:GetChildren()) do
						fx.Enabled = true
					end
				end
			end
		end;
		Door = function(...)
			Functions.Initialize.Damager(...)
			local bench, args, _, benchData = ...
			
			local benchModel = bench.Model
			bench.OpenStart = (args.Open == true)
			if benchData then
				benchModel:SetAttribute("Open", (benchData.A == 1))
			else
				benchModel:SetAttribute("Open", bench.OpenStart)
			end
			benchModel:SetAttribute("Moving", false)
			bench.MoveTime = args.MoveTime
			bench.OpenDegrees = args.OpenDegrees
			bench.MoveFunction = args.MoveFunction
			bench.Logic = args.Logic
			bench.ChangeCollideWhenMoving = args.ChangeCollideWhenMoving
		end;
		Bed = function(...)
			local bench, args, user, benchData, isFirst = ...
			local benchModel = bench.Model
			bench.BedTimer = args.Timer * ServerService:GetAttribute("RespawnTimeMult")
			--[[local authorized = (benchData and benchData.J or {})
			bench.Authorized = authorized]]
			-- TODO: set the bed's name and last respawn time from the saved bench data
			local ownerId, bedName
			local lastRespawn = os.time()
			if user then
				local player = user.Player
				if player then
					ownerId = player.UserId
				end
			end
			ownerId = (ownerId or (benchData and benchData.K))
			local beds
			if ownerId then
				bench.Owner = ownerId
				beds = shared.Beds[ownerId]
				if not beds then
					beds = {}
					shared.Beds[ownerId] = beds
				end
				local index  = 0
				while true do
					index += 1
					local bed = beds[index]
					if bed and bed.Parent then continue end
					beds[index] = benchModel
					bedName = "Unnamed Bag "..index
					break
				end
				bench.BedTableReference = beds
				--print(shared.Beds)
			else
				warn("Bed placed with unavailable UserId.")
				return
			end
			local bedInfo = (benchData and benchData.L)
			if type(bedInfo) == "string" then
				local encodedLastRespawn, encodedBedName = unpack(string.split(bedInfo, "/"))
				lastRespawn = ServerModule:DecodeNumber(encodedLastRespawn)
				bedName = ((encodedBedName == nil or encodedBedName == "") and bedName or encodedBedName)
			end
			bench.LastRespawn = lastRespawn
			benchModel:SetAttribute("BedName", bedName or "Unnamed Bag")
			if ownerId and beds then
				local ownerPlayer = Players:GetPlayerByUserId(ownerId)
				if ownerPlayer then
					local ownerUser = shared.Users[ownerPlayer]
					if ownerUser then
						ownerUser:UpdateBedInfos(beds)
					end
				end
			end
			if not isFirst then
				for _, u in pairs(shared.Users) do
					u:UpdateBenchClientInfo(false, bench)
				end
			end
		end;
		Destroyable = function(...)
			local bench, args = ...
			local benchModel = bench.Model
			local health = (args.Health or 0)
			benchModel:SetAttribute("MaxHealth", health)
			benchModel:SetAttribute("Health", health)
			local lootTable = args.LootTable
			if lootTable then
				bench.BreakLootTable = LootTableModule:GetLootTable(unpack(lootTable))
				--print(bench.BreakLootTable)
			end
		end;
		LockedContainer = function(...)
			Functions.Initialize.Container(...)
			local bench, args = ...
			local benchModel = bench.Model
			local health = (args.Health or 0)
			benchModel:SetAttribute("MaxHealth", health)
			benchModel:SetAttribute("Health", health)
			benchModel:SetAttribute("BreakLocked", true)
		end;
		Sleeper = function(...)
			Functions.Initialize.Container(...)
			local bench, args, user, benchData = ...
			local benchModel = bench.Model
			--print(user, benchData)
			if user then
				local inventory = user.Inventory
				local containers = inventory:GetInv()
				local benchIndex = 0
				for _, containerName in pairs({"Inventory", "Toolbar", "Armor"}) do
					local container = containers[containerName]
					for index, containerItem in pairs(container) do
						benchIndex += 1
						local itemTable = bench.Container[benchIndex]
						itemTable.Item = (containerItem or 0)
					end
				end
			end
			local sleeperInfo = (benchData and benchData.N)
			while (not sleeperInfo) and user do
				local player = user.Player
				if not (player and (user.LastHealth or 0) > 0) then break end
				local userStats = user.Stats:GetStats()
				sleeperInfo = {
					user.UserId,
					(user.WentDown and 0 or user.LastHealth),
					userStats.Hunger,
					userStats.Thirst,
					(userStats.Bleed or 0),
					(userStats.Radiation or 0),
				}
				break
			end
			if not sleeperInfo then
				warn("SLEEPER CREATED WITHOUT PROPER SLEEPERINFO, DELETING")
				ModUtil:SafeDestroy(benchModel)
				bench:Delete()
				return
			end
			bench.SleeperInfo = sleeperInfo
			local userId = sleeperInfo[1]
			local health = sleeperInfo[2]
			local sleepAnim = benchModel:FindFirstChild("SleepAnim")
			local humanoid = benchModel:FindFirstChild("Humanoid")
			if sleepAnim and humanoid then
				local anim = humanoid:LoadAnimation(sleepAnim)
				anim:Play()
			end
			if humanoid then
				humanoid.Health = health
			end
			local suc, results = pcall(function()
				return Users:GetUserInfosByUserIdsAsync({userId})
			end)
			if benchModel.Parent then
				local nameTag = benchModel:FindFirstChild("NameTag")
				if nameTag then
					local setText = false
					for _, userInfo in pairs(suc and results or {}) do
						nameTag.Label.Text = userInfo.DisplayName
						setText = true
					end
					if not setText then
						nameTag.Label.Text = "[ERR]"
					end
				end
				if humanoid.Parent and humanoid.Health <= 0 then
					print("sleeper created with 0 health, killing")
					task.defer(function()
						DamageModule:DestroyBench(benchModel, nil, nil, nil, nil, true)
					end)
					return
				end
				pcall(function() -- TODO: fix error lol
					local regStart = (benchModel:GetPivot() * CFrame.new(-0.5, 0, -1)).Position
					local regEnd = (benchModel:GetPivot() * CFrame.new(0.5, 0, 1)).Position
					local region = Region3.new(regStart, regEnd):ExpandToGrid(4)
					local materials = workspace.Terrain:ReadVoxels(region, 4)
					for _, x in pairs(materials) do
						if type(x) ~= "table" then continue end
						for _, y in pairs(x) do
							for _, material in pairs(y) do
								if material ~= Enum.Material.Water then continue end
								bench.InWater = true
								return
							end
						end
					end
				end)
			end
		end;
		Sign = function(...)
			local bench, args, _, benchData = ...
			local benchModel = bench.Model
			benchModel:SetAttribute("MaxCharacters", args.MaxCharacters)
			local text = (benchData and benchData.O or "")
			local gui = VFX_STORAGE[benchModel.Name]:Clone()
			local guiReference = Instance.new("ObjectValue")
			guiReference.Name = "GuiReference"
			guiReference.Value = gui
			guiReference.Parent = benchModel
			gui.Adornee = benchModel:FindFirstChild("SignPart")
			gui.Parent = Signs
			bench:SetSign(text, gui)
		end;
		Turret = function(...)
			local bench, args, user, benchData = ...
			Functions.Initialize.Container(...)
			bench.TurretStats = {
				Damage = args.Damage;
				Bleed = args.Bleed;
				BulletRadius = args.BulletRadius;
				BulletRange = args.BulletRange;
				DamageRange = args.DamageRange;
				BulletCount = args.BulletCount;
				Cooldown = args.Cooldown;
			}
			for index, itemTable in pairs(bench.Container) do
				local item = itemTable.Item
				local typ = itemTable.Type
				if not item or item == 0 or item.Amount <= 0 then continue end
				bench:SetupTurret() -- We only want to setup the turret if it isn't empty
				break
			end
		end;
		Trap = function(...)
			local bench, args, user, benchData = ...
			local benchModel = bench.Model
			if benchModel.Name == "Bear Trap" then
				bench:ToggleTrap(false, 0)
				if not (benchData and benchData.P == 1) then
					bench.Arming = true
					task.delay(1.25, function()
						if not benchModel.Parent then return end
						bench:ToggleTrap(true, 0.6)
						task.wait(0.75)
						if not benchModel.Parent then return end
						bench.Arming = false
					end)
				end
			else
				benchModel:SetAttribute("Armed", true)
				if type(user) == "table" and user.Player ~= nil then
					bench.Arming = true
					task.delay(2, function()
						if not benchModel.Parent then return end
						bench.Arming = false
						benchModel.PrimaryPart.Step:Play()
					end)
				else
					bench.Arming = false
				end
			end
			local collision = benchModel:FindFirstChild("TouchCollision")
			local isBearTrap = (benchModel.Name == "Bear Trap")
			if not collision then return end
			collision.Touched:Connect(function(part)
				if bench.Arming or not benchModel:GetAttribute("Armed") then return end
				if not part then return end
				local character = part.Parent
				if not character then return end
				local humanoid = character:FindFirstChild("Humanoid")
				if not (humanoid and humanoid.Health > 0) then return end
				if isBearTrap then
					bench.Arming = true
					bench:ToggleTrap(false)
					DamageModule:Damage(part, Vector3.new(), Vector3.new(), nil, {
						Chest = args.Damage;
						Head = args.Damage;
						Legs = args.Damage;
						Arms = args.Damage;
						Bleed = args.Bleed;
					}, {Start = 1000, End = 1000}, nil, nil, "Bear Trap")
					task.wait(1)
					bench.Arming = false
				else
					bench.CurrentlyStepped = character
					benchModel:SetAttribute("Armed", false)
					bench:ChangeOptions()
					local sound = benchModel.PrimaryPart.Step
					sound.PlaybackSpeed = 1
					sound:Play()
					local overlaps = OverlapParams.new()
					overlaps.FilterType = Enum.RaycastFilterType.Include
					overlaps.FilterDescendantsInstances = {character}
					while task.wait(0.1) do
						if not collision or not collision.Parent then return end
						local touchingParts = workspace:GetPartsInPart(collision, overlaps)
						local isInside = false
						for _, touchingPart in pairs(touchingParts) do
							if touchingPart.Parent ~= character then continue end
							--print("touching", touchingPart.Name)
							isInside = true
							break
						end
						if isInside then continue end
						local cf = collision.CFrame
						local exploInfo = args.Explosive
						local objectDamages = args.ObjectDamages
						local damagedHum = DamageModule:ExplosionDamage(cf.Position, cf.UpVector, objectDamages, exploInfo)--, nil, nil, benchModel:GetAttribute("ID"))
						ModUtil:FireAllClients(VFXRemotes, AllRemotes.Visualize, "CreateExplosion", cf, exploInfo.ShakeStrength, exploInfo.Duration, exploInfo.SoundName)
						ModUtil:SafeDestroy(benchModel)
						break
					end
					bench.CurrentlyStepped = nil
				end
			end)
		end;
		
	};
	Interact = {
		Default = function(bench, user)
			local benchModel = bench.Model
			local benchInfo = BenchInfo[benchModel.Name]
			local pickup = benchInfo.PickupBehavior
			local wheelInfo = {}
			local canPickup = true
			local container = bench.Container
			if container then
				for index, itemTable in pairs(container) do
					local item = itemTable.Item
					if (not item) or item == 0 then continue end
					canPickup = false
					break
				end
			end
			local armed = benchModel:GetAttribute("Armed")
			local curStepped = bench.CurrentlyStepped
			if (user and bench.Owner ~= nil and bench.Owner ~= user.Player.UserId) or armed == true then
				canPickup = false
			elseif curStepped and user and user.Player then
				local character = user.Player.Character
				if character and curStepped == character then
					canPickup = false
				end
			end
			if canPickup then
				local lock = bench:GetAddon("Lock")
				if lock then
					canPickup = false
				end
			end
			local isBuildBlocked = "b"
			for i = 1, 2 do
				if i == 2 then
					local canDoOptions, lockWheelInfo = bench:GetLockOptions(user, true)
					if canDoOptions then
						if container then
							local canOpen = (benchModel.Name ~= "Shotgun Turret")
							if not canOpen then
								if isBuildBlocked == "b" then
									isBuildBlocked = bench:IsBuildingBlocked(user)
								end
								canOpen = not isBuildBlocked
							end
							if canOpen then
								AddWheelInfo(wheelInfo, "Open", "rbxassetid://15635568292", "Take a look at the contents inside.")
							end
						end
						if bench.On ~= nil and bench:Function("CanRun") and not bench.AutoTurnOn then
							AddWheelInfo(wheelInfo, "Turn "..(bench.On and "Off" or "On"), "rbxassetid://15635568292", "Toggle the bench "..(bench.On and "off." or "on."))
						end
						if benchModel:GetAttribute("BedName") ~= nil then
							AddWheelInfo(wheelInfo, "Rename Bed", "rbxassetid://5595830734", "Change the name of this bed.")
						end
						if user and bench.Owner ~= nil then
							local player = user.Player
							if player.UserId == bench.Owner then
								AddWheelInfo(wheelInfo, "Give To Friend", "rbxassetid://10885655986", "Hand the ownership of the bed to someone else.")
							end
						end
						if bench.ButtonPressed ~= nil then
							AddWheelInfo(wheelInfo, "Press", "rbxassetid://4767736370", "Activates the button.")
						end
						if user and bench.Text ~= nil then
							if isBuildBlocked == "b" then
								isBuildBlocked = bench:IsBuildingBlocked(user)
							end
							if not isBuildBlocked then
								AddWheelInfo(wheelInfo, "Edit Sign", "rbxassetid://5595830734", "Set the text of the sign or add an image to it.")
							end
						end
						if armed == false and benchModel.Name == "Bear Trap" then
							AddWheelInfo(wheelInfo, "Rearm Trap", "rbxassetid://4767736370", "Rearms the trap.")
						end
					end
					for _, info in pairs(lockWheelInfo) do
						AddWheelInfo(wheelInfo, unpack(info))
					end
				end
				if pickup and user and canPickup then
					local equipped = user.Equipped
					if isBuildBlocked == "b" then
						isBuildBlocked = bench:IsBuildingBlocked(user)
					end
					if ((pickup ~= "HammerOnly" and i == 2) or (pickup == "HammerOnly" and i == 1 and equipped.Item and equipped.Item.ID == 31)) and not isBuildBlocked then
						AddWheelInfo(wheelInfo, "Pick Up", "rbxassetid://6322707158", "Pick up the bench and add it to your inventory.")
					end
				end
			end
			return wheelInfo
		end;
		BaseCabinet = function(bench, user)
			local wheelInfo = {}
			local player = (user and user.Player)
			local isAuthorized = (player and table.find(bench.Authorized, player.UserId))
			local canDoOptions, lockWheelInfo = bench:GetLockOptions(user, false)
			if canDoOptions then
				if isAuthorized then
					AddWheelInfo(wheelInfo, "Open", "rbxassetid://15635568292", "Take a look at the contents inside.")
					AddWheelInfo(wheelInfo, "Deauthorize", "rbxassetid://15635462646", "Removes yourself from the authorized list.")
					AddWheelInfo(wheelInfo, "Clear Authorized", "rbxassetid://2009433275", "Removes everyone authorized to this Base Cabinet.")
				else
					AddWheelInfo(wheelInfo, "Authorize", "rbxassetid://15635471035", "Gives you full authorization to the Base Cabinet.")
				end
			end
			for _, info in pairs(lockWheelInfo) do
				AddWheelInfo(wheelInfo, unpack(info))
			end
			return wheelInfo
		end;
		Door = function(bench, user)
			local benchModel = bench.Model
			local benchInfo = BenchInfo[benchModel.Name]
			local lock = bench:GetAddon("Lock")
			local wheelInfo = {}
			local isOpen = benchModel:GetAttribute("Open")
			local canPickup = (benchInfo.PickupBehavior ~= false and isOpen and user ~= nil and not lock)
			if canPickup then
				local equipped = user.Equipped
				canPickup = (equipped.Item and equipped.Item.ID == 31)
			end
			local canDoOptions, lockWheelInfo = bench:GetLockOptions(user, true)
			if canDoOptions then
				AddWheelInfo(wheelInfo, (isOpen and "Close" or "Open"), "rbxassetid://6322457168", (isOpen and "Close" or "Open").." the door.")
			end
			for _, info in pairs(lockWheelInfo) do
				AddWheelInfo(wheelInfo, unpack(info))
			end
			AddWheelInfo(wheelInfo, "Knock", "rbxassetid://6322423560", "Knock on the door.")
			if canPickup then
				local isBuildBlocked = bench:IsBuildingBlocked(user)
				if not isBuildBlocked then
					AddWheelInfo(wheelInfo, "Pick Up", "rbxassetid://6322707158", "Pick up the bench and add it to your inventory.")
				end
			end
			return wheelInfo
		end;
	};
	Action = {
		Default = function(bench, user, action, ...)
			local benchModel = bench.Model
			local benchInfo = BenchInfo[benchModel.Name]
			local maxDist = (benchInfo.InteractDistance or InteractService:GetAttribute("DefaultDistance")) + 1
			local players = bench.Players
			local authorized = bench.Authorized
			local player = (user and user.Player)
			local userId = (player and player.UserId)
			local bedName = benchModel:GetAttribute("BedName")
			local owner = bench.Owner
			local beds = shared.Beds[userId]
			--print(bench, user, action, bedName, ...)
			if (action == "Turn Off" or action == "Turn On") and bench.On ~= nil and not bench.AutoTurnOn then
				bench.On = (bench:Function("CanRun") == true and action == "Turn On")
				bench:Update()
			elseif action == "Pick Up" then
				bench:Pickup(user)
			elseif action == "Press" and bench.ButtonPressed ~= nil then
				bench:Press(user)
			elseif action == "Rearm Trap" and benchModel:GetAttribute("Armed") == false and bench.Arming == false then
				bench.Arming = true
				bench:ToggleTrap(true)
				task.delay(1, function()
					if not benchModel.Parent then return end
					bench.Arming = false
				end)
			elseif action == "Open" and players and player and not benchModel:GetAttribute("BreakLocked") then
				local inventory = user.Inventory
				local curBench = user.Bench
				if curBench and curBench.Parent then return end
				if players == nil or table.find(players, player) or benchModel:GetAttribute("Occupied") == true then return end
				local belongsTo = benchModel:GetAttribute("BelongsTo")
				if belongsTo or benchModel.Name == "Sleeper" then
					local _, isSafeZone = RaycastUtil:GetBaseCabinetUnder(benchModel.PrimaryPart.Position)
					if isSafeZone and (belongsTo == nil or belongsTo ~= player.UserId) then return end
				end
				user.Bench = benchModel
				table.insert(players, player)
				if benchModel:GetAttribute("Occupied") ~= nil then
					benchModel:SetAttribute("Occupied", true)
				end
				local updates = inventory:UpdateBenchContainer(bench)
				inventory:UpdateClient(benchModel, "Bench"..bench.UI, unpack(bench:GetUpdates()), unpack(updates))
				task.defer(function()
					local doReturn = false
					while true do
						if (benchModel and benchModel.Parent and user.Bench and user.Bench.Parent and user.Bench ~= benchModel) or not (player and player.Parent and user) then 
							doReturn = true
							break
						end
						local character = player.Character
						if not (benchModel and benchModel.Parent and user.Bench and character and character.PrimaryPart and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 and benchModel.PrimaryPart and user.Bench == benchModel) then break end
						if not NumberUtil:IsWithin(benchModel.PrimaryPart.Position, character.PrimaryPart.Position, maxDist) then break end
						task.wait(1/20)
					end
					--print("server container loop broken")
					for index, value in pairs(players) do
						if value ~= player then continue end
						table.remove(players, index)
						if not doReturn then
							ModUtil:FireClient(BenchRemotes, AllRemotes.Change, player, "Close", bench.UI)
						end
						break
					end
					if benchModel.Parent and benchModel:GetAttribute("Occupied") ~= nil then
						benchModel:SetAttribute("Occupied", false)
					end
					if doReturn then return end
					inventory:UpdateBenchContainer()
					user.Bench = nil
				end)
			elseif action == "Authorize" and authorized and player and not table.find(authorized, userId) then
				table.insert(authorized, userId)
				user:UpdateBenchClientInfo(false, bench)
				--print("authorized", player, authorized)
			elseif action == "Deauthorize" and authorized and player then
				for index, authId in pairs(authorized) do
					if authId ~= userId then continue end
					table.remove(authorized, index)
					user:UpdateBenchClientInfo(false, bench)
					--print("deauthorized", player, authorized)
					break
				end
			elseif action == "Clear Authorized" and authorized and player and table.find(authorized, userId) then
				bench.Authorized = {}
				for _, authId in pairs(authorized) do
					local authPlayer = Players:GetPlayerByUserId(authId)
					if not authPlayer then continue end
					local authUser = shared.Users[authPlayer]
					if not authUser then continue end
					authUser:UpdateBenchClientInfo(false, bench)
				end
				--print("cleared authorized")
			elseif action == "Edit Sign" and player and bench.Text then
				local actualText = ...
				if actualText then
					print(actualText)
					bench:SetSign(actualText)
				end
			elseif action == "Rename Bed" and player and bedName then
				local newBedName = ...
				if newBedName then
					--print("SUCCESSFULLY RENAMED BED FROM", bedName, newBedName)
					benchModel:SetAttribute("BedName", newBedName)
					if beds then
						user:UpdateBedInfos(beds)
					end
				end
			elseif action == "Give To Friend" and player and owner and owner == userId then
				local newOwner = ...
				if type(newOwner) == "number" then
					--[[
					local beds = (shared.Beds[player.UserId] or {})
					local totalBeds = 0
					local maxAllowedBeds = ServerService:GetAttribute("MaxAllowedBeds")
					for _, bed in pairs(beds) do
						if not (bed and bed.Parent) then continue end
						totalBeds += 1
						if totalBeds >= maxAllowedBeds then warn("PLACING FAILED - MAX ALLOWED NUMBER OF BEDS REACHED ("..maxAllowedBeds..")") return "BED LIMIT ("..maxAllowedBeds..") REACHED" end
					end]]
					local newBeds = shared.Beds[newOwner]
					local totalBeds = 0
					local maxAllowedBeds = ServerService:GetAttribute("MaxAllowedBeds")
					if newBeds then
						for _, bed in pairs(newBeds) do
							if not (bed and bed.Parent) then continue end
							totalBeds += 1
							if totalBeds >= maxAllowedBeds then break end
						end
					end
					if totalBeds < maxAllowedBeds then
						--print("GAVE BED OWNERSHIP FROM ", userId, "TO", newOwner)
						bench.Owner = newOwner
						if beds then
							local oldIndex = table.find(beds, benchModel)
							if oldIndex and oldIndex > 0 then
								beds[oldIndex] = nil
								user:UpdateBedInfos(beds)
								--print("updating")
							end
						end
						if not newBeds then
							newBeds = {}
							shared.Beds[newOwner] = newBeds
						end
						local newIndex = 0
						while true do
							newIndex += 1
							local newBed = newBeds[newIndex]
							if not (newBed and newBed.Parent) then
								newBeds[newIndex] = benchModel
								break
							end
						end
						bench.BedTableReference = newBeds
						local newPlayer = Players:GetPlayerByUserId(newOwner)
						if newPlayer then
							local newUser = shared.Users[newPlayer]
							if newUser then
								newUser:UpdateBedInfos(newBeds)
								newUser:UpdateBenchClientInfo(false, bench)
							end
						end
						--print(shared.Beds)
						user:UpdateBenchClientInfo(false, bench)
						bench:ChangeOptions()
					else
						ModUtil:FireClient(ChatRemotes, AllRemotes.Message, player, {
							Message = "CANNOT BAG PLAYER - THEIR BAG LIMIT ("..maxAllowedBeds..") WAS REACHED";
							Channel = "System";
							DisplayName = "SERVER";
						})
					end
				end
			else
				bench:LockAction(action, user, ...)
			end
		end;
		Door = function(bench, user, action, ...)
			local benchModel = bench.Model
			local isLocked = bench.Locked
			local benchPrim = benchModel.PrimaryPart
			if (action == "Open" or action == "Close") and user then
				local player = user.Player
				local team = player.Team
				local code = bench.Code
				local hasAccess = table.find((bench.Access or {}), player.UserId)
				local hasGuest = table.find((bench.Guests or {}), player.UserId)
				if isLocked then
					if not (hasAccess or hasGuest) and not ((code == "14789" and team and team.Name == "Attackers") or (code == "25888" and team and team.Name == "Defenders")) then
						local deniedSound = benchPrim.Denied
						if not deniedSound.IsPlaying then
							deniedSound.PlaybackSpeed = math.random(136, 144) / 100
							deniedSound:Play()
						end
						return 
					end
					if not benchModel:GetAttribute("Moving") then
						local lock = bench:GetAddon("Lock")
						if lock and lock.Name == "Combination Lock" then
							local beepSound = benchPrim.Beep
							beepSound:Stop()
							beepSound.PlaybackSpeed = math.random(135, 145) / 100
							beepSound:Play()
						end
					end
				end
				bench[bench.Logic](bench)
			elseif action == "Knock" and benchPrim then
				local knockSound = benchPrim:FindFirstChild("Knock")
				if not (knockSound and not knockSound.IsPlaying) then return end
				knockSound.PlaybackSpeed = math.random(90, 110) / 100
				knockSound:Play()
			elseif action == "Pick Up" then
				bench:Pickup(user)
			else
				bench:LockAction(action, user, ...)
			end
		end;
	};
	CanRun = {
		RequiresWood = function(bench)
			for index, itemTable in pairs(bench.Container) do
				local item = itemTable.Item
				local typ = itemTable.Type
				if not (typ and typ:find("Fuel") and item and item ~= 0 and item.ID == 1 and item.Amount >= 1) then continue end
				return true
			end
		end;
		IsEmpty = function(bench)
			for index, itemTable in pairs(bench.Container) do
				local item = itemTable.Item
				local typ = itemTable.Type
				if not typ:find("Input") then continue end
				if not (item ~= 0 and item.Amount >= 0) then continue end
				return true
			end
		end;
		PowerCell = function(bench)
			for index, itemTable in pairs(bench.Container) do
				local item = itemTable.Item
				local typ = itemTable.Type
				if not typ:find("Input") then continue end
				if not (item ~= 0 and item.Amount == 1 and item.Durability > 0) then continue end
				return true
			end
		end;
	};
	Running = {
		Smelt = function(bench, step)
			local updateIndexes = {}
			local benchModel = bench.Model
			local turnOff = false
			local container = bench.Container
			--print(container)
			local didFuel = false
			for index, itemTable in pairs(container) do
				local item = itemTable.Item
				local typ = itemTable.Type
				--print(index, item, typ)
				local isFuel = typ:find("Fuel")
				if typ:find("Output") or not (item and item ~= 0 and item.Amount > 0) or (isFuel and didFuel) then continue end
				local itemInfo = Items[item.ID]
				local smeltInfo = itemInfo.SmeltInfo
				local lootTable = LootTableModule:GetLootTable(unpack(smeltInfo.LootTable or {}))
				local cookTimes = (item.CookTimes or {0, smeltInfo.Time * (isFuel and bench.FuelMult or (bench.InputMult or 1))})
				--print(item.Amount)
				if item.Amount <= 0 then continue end
				if isFuel then
					didFuel = true
				end
				cookTimes[1] += step * ServerService:GetAttribute("SmeltSpeedMult")
				while cookTimes[1] >= cookTimes[2] and item.Amount > 0 and not turnOff do
					local oldItemAmount = item.Amount
					item.Amount = math.max(item.Amount - smeltInfo.Amount, 0)
					local amountRatio = (oldItemAmount - item.Amount) / smeltInfo.Amount
					cookTimes[1] -= cookTimes[2]
					if not lootTable then continue end
					local itemsGiven = lootTable:Roll(amountRatio, ServerService:GetAttribute("LuckMult"))
					for _, itemGiven in pairs(itemsGiven) do
						local givenInfo = Items[itemGiven.ID]
						for p = 1, 2 do
							for outputIndex, outputItemTable in pairs(container) do
								local outputItem = outputItemTable.Item
								local outputTyp = outputItemTable.Type
								--print(outputVal, outputItem, outputTyp)
								if not outputTyp:find("Output") then continue end
								local maxStack = (givenInfo.MaxStack == 1 and 1 or math.round(givenInfo.MaxStack * ServerService:GetAttribute("MaxStackMult")))
								if not ((p == 1 and outputItem ~= 0 and outputItem.Amount > 0 and outputItem.ID == itemGiven.ID and outputItem.Amount < maxStack and (outputItem.Durability or 0) == (itemGiven.Durability or 0)) or (p == 2 and outputItem == 0)) then continue end
								local amount = (outputItem == 0 and 0 or outputItem.Amount)
								local fitAmount = math.min(amount + itemGiven.Amount, maxStack)
								local totalFit = fitAmount - amount
								local newAmount = math.max(itemGiven.Amount - totalFit, 0)
								updateIndexes[outputIndex] = true
								if outputItem == 0 then
									itemGiven.Amount = totalFit
									bench:UpdateSlot(outputIndex, itemGiven)
								else
									outputItem.Amount += totalFit
									bench:UpdateSlot(outputIndex, outputItem)
								end
								itemGiven.Amount = newAmount
								if newAmount <= 0 then break end
							end
							if itemGiven.Amount <= 0 then break end
						end
						if itemGiven.Amount <= 0 then continue end
						InventoryService.DropItem:Invoke(benchModel.PrimaryPart.CFrame * CFrame.new(0, 1, 0), itemGiven, itemGiven.Amount, nil, true)
						turnOff = true
					end
				end
				if item ~= 0 then
					if item.Amount > 0 then
						item.CookTimes = cookTimes
					else
						item = 0
					end
				end
				updateIndexes[index] = true
				bench:UpdateSlot(index, item)
			end
			local updates = {}
			for index, _ in pairs(updateIndexes) do
				local itemTable = bench:GetSlot(index)
				local item = itemTable.Item
				table.insert(updates, {"Bench", index, item})
			end
			if #updates > 0 then
				bench:UpdatePlayers(updates)
			end
			return turnOff
		end;
		Shredder = function(bench, step)
			local updateIndexes = {}
			local benchModel = bench.Model
			local turnOff = false
			local container = bench.Container
			bench.LastUse = (bench.LastUse or 0) + step * ServerService:GetAttribute("ShredderSpeedMult")
			local cooldown = 4
			while bench.LastUse >= cooldown do
				bench.LastUse -= cooldown
				for index, itemTable in pairs(container) do
					local item = itemTable.Item
					local typ = itemTable.Type
					--print(index, item, typ)
					if typ:find("Output") or not (item and item ~= 0 and item.Amount > 0) then continue end
					local recipe = (RecipeModule:GetRecipesForItem(item.ID) or {})[1]
					if not recipe then continue end
					local durability = item.Durability or 0
					local iinfo = Items[item.ID]
					local shredAmount = math.min((recipe.ShredAmount or 1), item.Amount)
					item.Amount -= shredAmount
					if item.Amount < 0 then
						item = 0
					end
					updateIndexes[index] = true
					bench:UpdateSlot(index, item)
					local durMult = (iinfo.MaxDurability and 0.2 + math.clamp(durability / iinfo.MaxDurability, 0, 1) * 0.8 or 1)
					local costs = RecipeModule:CalculateTotalCost(recipe, shredAmount * 0.5 * durMult / recipe.ReceiveAmount, false, recipe.ShredIgnore)
					for _, cost in pairs(costs) do
						local roundedAmount = NumberUtil:RoundNumber(cost.Amount)
						local actualAmount = NumberUtil:NumberToInteger(roundedAmount)
						--print(Items[cost.ID].Name, cost.Amount, roundedAmount, actualAmount, durMult)
						if actualAmount <= 0 then continue end
						local costInfo = Items[cost.ID]
						for p = 1, 2 do
							for outputIndex, outputItemTable in pairs(container) do
								local outputItem = outputItemTable.Item
								local outputTyp = outputItemTable.Type
								--print(outputVal, outputItem, outputTyp)
								if not outputTyp:find("Output") then continue end
								local maxStack = (costInfo.MaxStack == 1 and 1 or math.round(costInfo.MaxStack * ServerService:GetAttribute("MaxStackMult")))
								if not ((p == 1 and outputItem ~= 0 and outputItem.Amount > 0 and outputItem.ID == cost.ID and outputItem.Amount < maxStack) or (p == 2 and outputItem == 0)) then continue end
								local amount = (outputItem == 0 and 0 or outputItem.Amount)
								local fitAmount = math.min(amount + actualAmount, maxStack)
								local totalFit = fitAmount - amount
								local newAmount = math.max(actualAmount - totalFit, 0)
								updateIndexes[outputIndex] = true
								if outputItem == 0 then
									bench:UpdateSlot(outputIndex, ItemClass.new(cost.ID, totalFit))
								else
									outputItem.Amount += totalFit
									bench:UpdateSlot(outputIndex, outputItem)
								end
								actualAmount = newAmount
								if actualAmount <= 0 then break end
							end
							if actualAmount <= 0 then break end
						end
						if actualAmount <= 0 then continue end
						InventoryService.DropItem:Invoke(benchModel.PrimaryPart.CFrame * CFrame.new(0, 1, 0), ItemClass.new(cost.ID, actualAmount), actualAmount, nil, true)
						turnOff = true
					end
					break
				end
			end
			--print(container)
			local updates = {}
			for index, _ in pairs(updateIndexes) do
				local itemTable = bench:GetSlot(index)
				local item = itemTable.Item
				table.insert(updates, {"Bench", index, item})
			end
			if #updates > 0 then
				bench:UpdatePlayers(updates)
			end
			return turnOff
		end;
		PowerCell = function(bench, step)
			local updateIndexes = {}
			local benchModel = bench.Model
			local turnOff = true
			local container = bench.Container
			for index, itemTable in pairs(container) do
				local item = itemTable.Item
				local typ = itemTable.Type
				--print(index, item, typ)
				if typ:find("Output") or not (item and item ~= 0 and item.Amount > 0) then continue end
				local newDur = math.max(item.Durability - step, 0)
				item.Durability = newDur
				updateIndexes[index] = true
				turnOff = (newDur <= 0)
				break
			end
			local updates = {}
			for index, _ in pairs(updateIndexes) do
				local itemTable = bench:GetSlot(index)
				local item = itemTable.Item
				table.insert(updates, {"Bench", index, item})
			end
			if #updates > 0 then
				bench:UpdatePlayers(updates)
			end
			--[[if not turnOff then
				print("POWER CELL ACTIVE")
			end]]
			return turnOff
		end;
	};
}

local BenchModule = {
	Misc = {
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
	Damager = {
		Initialize = Functions.Initialize.Damager;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
	Container = {
		Initialize = Functions.Initialize.Container;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
	Campfire = {
		Initialize = Functions.Initialize.Campfire;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
		CanRun = Functions.CanRun.RequiresWood;
		Running = Functions.Running.Smelt;
	};
	Shredder = {
		Initialize = Functions.Initialize.Shredder;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
		CanRun = Functions.CanRun.IsEmpty;
		Running = Functions.Running.Shredder;
	};
	PowerCell = {
		Initialize = Functions.Initialize.PowerCell;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
		CanRun = Functions.CanRun.PowerCell;
		Running = Functions.Running.PowerCell;
	};
	Button = {
		Initialize = Functions.Initialize.Button;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
	Door = {
		Initialize = Functions.Initialize.Door;
		Interact = Functions.Interact.Door;
		Action = Functions.Action.Door;
	};
	BaseCabinet = {
		Initialize = Functions.Initialize.BaseCabinet;
		Interact = Functions.Interact.BaseCabinet;
		Action = Functions.Action.Default;
	};
	Bed = {
		Initialize = Functions.Initialize.Bed;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
	Destroyable = {
		Initialize = Functions.Initialize.Destroyable;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
	LockedContainer = {
		Initialize = Functions.Initialize.LockedContainer;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
	Sleeper = {
		Initialize = Functions.Initialize.Sleeper;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
	Sign = {
		Initialize = Functions.Initialize.Sign;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
	Turret = {
		Initialize = Functions.Initialize.Turret;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
	Trap = {
		Initialize = Functions.Initialize.Trap;
		Interact = Functions.Interact.Default;
		Action = Functions.Action.Default;
	};
}

return BenchModule