-- [PATH] ServerScriptService / ServerService / InteractService @Type Script
--[[
	InteractService
	by ChickenBagelz
	August 26, 2022
	
	Handles all server-sided interactions with items or benches
]]

-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local Http = game:GetService("HttpService")
local Text = game:GetService("TextService")
local Debris = game:GetService("Debris")
local Tween = game:GetService("TweenService")

-- Folders
local Remotes = Replicated:WaitForChild("Remotes")
local InteractRemotes = Remotes:WaitForChild(string.char(60, 12, 5, 117, 173, 26, 48, 16, 174, 61, 181, 117, 1, 115, 39, 143, 91, 146, 18, 3, 41, 181, 157, 74, 180, 31, 46, 57, 187, 151))
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local Drops = workspace:WaitForChild("Drops")
local Plants = workspace:WaitForChild("Plants")
local VFX_PARTS = workspace:WaitForChild("VFX")
local Terrain = workspace:WaitForChild("Terrain")
local Animals = workspace:WaitForChild("Animals")
local Vegetation = workspace:WaitForChild("Vegetation")

-- Modules
local Items = require(SharedModules:WaitForChild("Items"))
local ItemClass = require(SharedModules:WaitForChild("ItemClass"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local SoundModule = require(ServerModules:WaitForChild("SoundModule"))
local TweenUtil = require(SharedModules:WaitForChild("TweenUtil"))
local ResearchModule = require(SharedModules:WaitForChild("ResearchModule"))
local RecipeModule = require(SharedModules:WaitForChild("RecipeModule"))

-- Local Variables
local viewFilterFunc = RaycastUtil:FilterFunction("View")
local hitNoMeleeMouseFilterFunc = RaycastUtil:FilterFunction("HitNoMeleeMouse")

-- Functions
function CheckCodeIntegrity(code)
	local numCode = (type(code) == "string" and tonumber(code))
	if (not numCode) or code:len() ~= 5 or numCode % 1 ~= 0 or numCode < 0 or numCode > 99999 then
		return false
	end
	for i = 1, code:len() do
		local s = code:sub(i, i)
		if tonumber(s) then continue end
		return false
	end
	return true
end

-- Remotes
local AllRemotes = {
	PickupItem = string.char(184, 127, 15, 56, 117, 126, 58, 170, 16, 2, 173, 153, 144, 111, 129, 51, 95, 5, 45, 1, 176, 179, 114, 21, 106, 56, 20, 17, 148, 70);
	Bench = string.char(69, 158, 103, 31, 151, 49, 145, 49, 110, 75, 182, 63, 158, 153, 114, 34, 159, 171, 119, 72, 22, 128, 92, 190, 34, 24, 31, 56, 111, 13);
	DoLock = string.char(53, 168, 9, 5, 136, 150, 150, 60, 116, 42, 80, 146, 177, 56, 86, 31, 104, 135, 126, 45, 119, 152, 98, 122, 23, 28, 138, 172, 93, 174);
	Interact = string.char(153, 1, 138, 33, 185, 173, 98, 25, 178, 72, 188, 62, 148, 105, 47, 28, 12, 37, 44, 60, 97, 24, 125, 64, 31, 166, 115, 118, 157, 127);
	DigUp = string.char(58, 32, 91, 124, 39, 146, 80, 83, 118, 66, 77, 58, 136, 138, 101, 22, 1, 105, 50, 126, 30, 183, 118, 17, 42, 30, 69, 165, 15, 57);
}
ModUtil:SetupRemotes(InteractRemotes, {
	[AllRemotes.PickupItem] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local inventory = user.Inventory
			local object = args[1]
			if object and typeof(object) ~= "Instance" and typeof(object) ~= "string" then
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
				return
			end
			if not (typeof(object) == "Instance" and object:IsA("Model") and (object.Parent == Drops or object.Parent == Plants)) then return end
			local humanoid = user.Humanoid
			if not (humanoid and humanoid.Parent and humanoid.Health > 0 and not humanoid:GetAttribute("Downed")) then return end
			local character = humanoid.Parent
			if not character then return end
			local charPrim = character.PrimaryPart
			local objPrim = object.PrimaryPart
			if not (charPrim and objPrim) then return end
			local itemValue = object:FindFirstChild("Item")
			if not itemValue then return end
			local charPos = charPrim.Position
			local headPos = charPos + Vector3.new(0, 1.5, 0)
			local objPos = objPrim.Position
			if not NumberUtil:IsWithin(objPos, charPos, script:GetAttribute("DefaultDistance") + 2) then print("ITEM PICKUP FAILED - ITEM TOO FAR AWAY:", object.Name) return end
			if user:CheckLastMovementDetection(character, humanoid, charPrim, 1.25, true) then return end
			local headHit = RaycastUtil:Raycast(charPos, Vector3.new(0, 1.6, 0), "Exclude", {VFX_PARTS, character, Drops, Plants, Animals}, nil, viewFilterFunc, true)
			if headHit then return end
			local hit = RaycastUtil:Raycast(headPos, objPos - headPos, "Blacklist", {VFX_PARTS, character, Drops, Plants, Animals, Terrain}, false, viewFilterFunc, true)
			if hit then print("ITEM PICKUP FAILED - PLAYER VIEW FROM ITEM IS OBSTRUCTED (OBJECT HIT:"..hit:GetFullName()..")") return end
			local hasFuse = object:GetAttribute("HasFuse")
			if hasFuse then
				if hasFuse == 1 then return end
				local canPickup = (math.random(1, 2) == 1)
				object:SetAttribute("HasFuse", 1)
				if not canPickup then return end
			end
			local item = ItemClass.new(Http:JSONDecode(itemValue.Value))
			if object.Parent == Plants then
				local containerTable = shared.ContainerReferences[object]
				if containerTable then
					shared.ContainerReferences[object] = nil
					containerTable[1]:RemoveFromContainer(containerTable[2], object)
				end
			end
			ModUtil:SafeDestroy(object, true)
			inventory:AddItem(item)
			SoundModule:PlayItemSound(player, item.ID, "Drag")
		end;
	};
	[AllRemotes.Bench] = {
		ArgumentsIgnoreBan = {3};
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local benchModel = args[1]
			local chosen = args[2]
			--print(benchModel, chosen)
			if args[4] or #args >= 4 or (benchModel ~= nil and typeof(benchModel) ~= "Instance") or (type(chosen) == "number" and (chosen % 1 ~= 0 or chosen < 0)) or (type(chosen) ~= "number" and chosen ~= "Turn On" and chosen ~= "Turn Off" and chosen ~= "Rename Bed" and chosen ~= "Give To Friend" and chosen ~= "Upgrade" and chosen ~= "Repair1" and chosen ~= "Repair2" and chosen ~= "Edit Sign") then
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
				return
			end
			if not benchModel then return end
			if benchModel:GetAttribute("Locked") then return end
			local bench = shared.Benches[benchModel]
			--print(bench)
			if not bench then return end
			if chosen == "Upgrade" then
				if not (user.Bench and user.Bench == benchModel) then return end
				local researchInfo = ResearchModule:GetInfoFromName(benchModel.Name)
				if not researchInfo then return end
				local researchLevels = user.ResearchLevels
				local upgradeLevel = researchLevels[benchModel.Name] or 0
				local tiers = researchInfo.Tiers
				local nextCosts = tiers[upgradeLevel + 1]
				if not nextCosts then return end
				local inventory = user.Inventory
				local foundItems = {}
				for _, cost in pairs(nextCosts) do
					local costAmount = cost.Amount
					local hasEnough, found = inventory:FindItem(costAmount, {"Inventory", "Toolbar"}, {cost.ID})
					if not hasEnough then return end
					table.insert(foundItems, found)
				end
				researchLevels[benchModel.Name] = upgradeLevel + 1
				shared.UserDatas[tostring(user.UserId)] = user:GetUserData()
				local allUpdates = {{RL = researchLevels}}
				for index, cost in pairs(nextCosts) do
					local costId = cost.ID
					local costAmount = cost.Amount
					local found = foundItems[index]
					local updates = inventory:RemoveFoundItems(found, costAmount)
					for _, update in pairs(updates) do
						table.insert(allUpdates, update)
					end
				end
				--print(`UPGRADED {benchModel.Name} TO LEVEL {upgradeLevel + 1}`)
				inventory:UpdateClient(unpack(allUpdates))
			elseif chosen == "Repair1" or chosen == "Repair2" then
				if not (user.Bench and user.Bench == benchModel and bench) then return end
				local itemTable = bench:GetSlot(1, player.UserId)
				if not itemTable then return end
				local item = itemTable.Item
				if not item or item == 0 or item.Amount <= 0 then return end
				local itemInfo = Items[item.ID]
				if not itemInfo then return end
				if chosen == "Repair1" then
					local maxDur = itemInfo.MaxDurability
					if not maxDur or (item.Durability or 0) >= maxDur * (1 - item.Repair) - 0.01 or item.Repair >= 1 then return end
					local recipe = (RecipeModule:GetRecipesForItem(item.ID) or {})[1]
					if not recipe then return end
					local researchLevels = user.ResearchLevels
					local benchNeeded = recipe.BenchNeeded
					local tierNeeded = recipe.TierNeeded
					local mult = 0.5
					if (tierNeeded or 0) > 0 then
						local researchInfo = ResearchModule:GetInfoFromName(benchNeeded)
						if researchInfo then
							local currentTier = researchLevels[benchNeeded] or 0
							local maxTier = #researchInfo.Tiers
							local tierDiff = tierNeeded - currentTier
							mult = tierDiff <= 4 and (tierDiff <= 0 and 0.5 or tierDiff)
						end
					end
					if not mult then return end
					local costs = RecipeModule:CalculateTotalCost(recipe, mult, true, {6, 68, 179})
					local inventory = user.Inventory
					local foundItems = {}
					for _, cost in pairs(costs) do
						local costAmount = math.ceil(cost.Amount)
						local hasEnough, found = inventory:FindItem(costAmount, {"Inventory", "Toolbar"}, {cost.ID})
						if not hasEnough then print("NOT ENOUGH", Items[cost.ID].Name, costAmount) return end
						table.insert(foundItems, found)
					end
					item.Repair = math.min(item.Repair + 0.1, 1)
					item.Durability = maxDur * (1 - item.Repair)
					bench:UpdateSlot(1, item)
					print("REPAIRED ITEM", item, "WITH", mult, "MULT")
					local allUpdates = {{"Bench", 1, item}}
					for index, cost in pairs(costs) do
						local costAmount = math.ceil(cost.Amount)
						local found = foundItems[index]
						local updates = inventory:RemoveFoundItems(found, costAmount)
						for _, update in pairs(updates) do
							table.insert(allUpdates, update)
						end
					end
					bench:UpdatePlayers(allUpdates)
				elseif type(args[3]) == "string" then
					local skinIndex = itemInfo.Name.."/"..args[3]
					if args[3] ~= "Default" and not table.find(user.Skins, skinIndex) then return end
					--print("CHANGED ITEM SKIN TO", args[3])
					item.Skin = args[3]
					bench:UpdateSlot(1, item)
					bench:UpdatePlayers({{"Bench", 1, item}})
				end
			end
			local wheelInfos = bench:Function("Interact", user)
			--print(chosen, wheelInfos)
			if wheelInfos == nil or #wheelInfos <= 0 then return end
			if chosen == 0 then
				return wheelInfos
			end
			local chosenInfo = wheelInfos[chosen]
			if (not chosenInfo) and type(chosen) == "string" then
				for index, info in pairs(wheelInfos) do
					if info.Name ~= chosen then continue end
					chosenInfo = info
					break
				end
			end
			if not chosenInfo then return end
			local chosenType = chosenInfo.Name
			--[[if chosenType == "Enter Combination" then
				chosenType = "Open"
			end]]
			local isOpen = benchModel:GetAttribute("Open")
			if (chosenType == "Open" and isOpen == nil) or chosenType == "Pick Up" or chosenType == "Authorize" then
				local humanoid = user.Humanoid
				if not humanoid then return end
				local character = humanoid.Parent
				if not character then return end
				local rootPart = character.PrimaryPart
				if not rootPart then return end
				if user:CheckLastMovementDetection(character, humanoid, rootPart, 2) then return end
			end
			local extra = args[3]
			if extra then
				if chosen == "Rename Bed" then
					if type(extra) ~= "string" or extra:len() > 20 then
						ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
						return
					else
						extra = extra:gsub("/", ""):gsub([[\]], "")
						if extra:len() <= 0 then return end
					end
					local filteredText
					local suc, err = pcall(function()
						local textObject = Text:FilterStringAsync(extra, player.UserId)
						filteredText = textObject:GetNonChatStringForBroadcastAsync()
					end)
					extra = (filteredText or "ERROR")
				elseif chosen == "Give To Friend" then
					if type(extra) ~= "number" or extra % 1 ~= 0 or extra < 0 then
						ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
						return
					end
				elseif chosen == "Edit Sign" then
					local isBuildBlocked = bench:IsBuildingBlocked(user)
					if not isBuildBlocked then
						local actualText
						if type(extra) == "number" then
							if #tostring(extra) > 30 then
								ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
								return
							end
							local ownsPass = user:OwnsPass("ImageFrames")
							if ownsPass then
								actualText = extra
							end
						elseif type(extra) == "string" then
							if extra:len() > 300 then
								ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
								return
							end
							local filteredText
							local suc, err = pcall(function()
								local textObject = Text:FilterStringAsync(extra, player.UserId)
								filteredText = textObject:GetNonChatStringForBroadcastAsync()
							end)
							if filteredText then
								actualText = filteredText
							end
						end
						--print(extra, actualText)
						if not actualText then return end
						extra = actualText
					end
				elseif not CheckCodeIntegrity(extra) then
					ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
					return
				end
			end
			--print(extra)
			bench:Interact(chosenType, user, nil, extra)
			return chosenType
		end;
	};
	[AllRemotes.DoLock] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local benchModel = args[1]
			if benchModel == nil then return end
			local toolbarIndex = args[2]
			if args[3] or #args >= 3 or (type(benchModel) ~= "string" and typeof(benchModel) ~= "Instance") or type(toolbarIndex) ~= "number" or toolbarIndex % 1 ~= 0 or toolbarIndex < 1 or toolbarIndex > 6 then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			if not (typeof(benchModel) == "Instance" and benchModel.Parent and benchModel:IsA("Model")) then return end
			local inventory = user.Inventory
			local toolbar = inventory:GetToolbar()
			local item = toolbar[toolbarIndex]
			if not (item and item ~= 0 and item.Amount > 0) then return end
			local bench = shared.Benches[benchModel]
			local itemInfo = Items[item.ID]
			if not itemInfo then return end
			local itemType = itemInfo.Type
			local itemName = itemInfo.Name
			if itemType ~= "Lock" then return end
			local locks = benchModel:FindFirstChild(itemType, true)
			if not locks then return end
			for _, lock in pairs(locks:GetChildren()) do
				if not lock:GetAttribute("On") then continue end
				return
			end
			local lock = locks:FindFirstChild(itemName)
			if not lock then return end
			local isBuildBlocked = bench:IsBuildingBlocked(user)
			if isBuildBlocked then return end
			item.Amount -= 1
			if item.Amount <= 0 then
				toolbar[toolbarIndex] = 0
			end
			inventory:UpdateClient({"Toolbar", toolbarIndex, toolbar[toolbarIndex]})
			lock:SetAttribute("On", true)
			for _, part in pairs(lock:GetChildren()) do
				if not part:IsA("BasePart") then continue end
				local oldColor = part.Color
				part.Color = Color3.new()
				part.Transparency = 0
				part.Color = oldColor
			end
			if itemName == "Wooden Lock" then
				bench:LockAction("Lock", user)
			else
				bench:ChangeLockAppearance(lock, false)
			end
		end;
	};
	[AllRemotes.Interact] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			if tick() - (user.LastDrink or 0) < 1.9 then return end
			local object = args[1]
			local position = args[2]
			if (object and typeof(object) ~= "Instance" and typeof(object) ~= "string") or typeof(position) ~= "Vector3" then
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
				return
			end
			local userStats = user.Stats
			if not (typeof(object) == "Instance" and object:IsA("Terrain")) then return end
			local humanoid = user.Humanoid
			if not (humanoid and humanoid.Parent and humanoid.Health > 0 and not humanoid:GetAttribute("Downed")) then return end
			local character = humanoid.Parent
			if not character then return end
			local charPrim = character.PrimaryPart
			if not charPrim then return end
			local charPos = charPrim.Position
			if not NumberUtil:IsWithin(position, charPos, script:GetAttribute("DefaultDistance") + 4) then return end
			local hit, _, _, mat = RaycastUtil:Raycast(charPos, position - charPos, "Blacklist", {VFX_PARTS, character}, false, hitNoMeleeMouseFilterFunc)
			if not (hit and hit:IsA("Terrain")) then return end -- warn("TERRAIN INTERACTION FAILED - SERVER RAY MISMATCHES CLIENT (OBJECT HIT:"..(hit and hit:GetFullName() or "nil")..")") return end
			if mat == Enum.Material.Water then
				user.LastDrink = tick()
				local eatSound = charPrim:FindFirstChild("Gulp")
				if eatSound then
					eatSound:Play()
				end
				if position.Y <= 0.01 then
					-- Salt water
					userStats:ApplyConsumableTable({
						Thirst = -7;
						Health = -3;
					})
				else
					userStats:ApplyConsumableTable({
						Thirst = 8
					})
				end
				userStats:UpdateClient()
			end
		end;
	};
	[AllRemotes.DigUp] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local action = args[1]
			local object = args[2]
			if (object and typeof(object) ~= "Instance" and typeof(object) ~= "string") or (action ~= "Cancel" and action ~= "Start") then
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
				return
			end
			local isPile = (typeof(object) == "Instance" and object.Name == "DigPile" and object.Parent == Vegetation)
			if action == "Cancel" then
				if isPile then
					local did = (not object:GetAttribute("a"))
					object:SetAttribute("a", did)
					object:PivotTo(object:GetPivot() * CFrame.new(0, did and -0.01 or 0.01, 0))
				end
				local digThread = user.Digging
				if digThread then
					task.cancel(digThread)
					user.Digging = false
				end
				return
			end
			if not isPile then return end
			local benches = (shared.DigPiles or {})[object]
			if not benches then return end
			local primPart = object.PrimaryPart
			if not primPart then return end
			local humanoid = user.Humanoid
			if not (humanoid and humanoid.Parent and humanoid.Health > 0 and not humanoid:GetAttribute("Downed")) then return end
			local character = humanoid.Parent
			if not character then return end
			local humPrim = character.PrimaryPart
			if not humPrim then return end
			local digThread = user.Digging
			if digThread then
				task.cancel(digThread)
				user.Digging = false
			end
			local inventory = user.Inventory
			local toolbar = inventory:GetToolbar()
			local equippedItem = toolbar[user.Equipped.Index]
			local digTime = 6
			local shovel, missingDur, equippedIndex
			if equippedItem and equippedItem ~= 0 and equippedItem.Amount > 0 then
				local equippedInfo = Items[equippedItem.ID]
				missingDur = (equippedInfo ~= nil and equippedInfo.MaxDurability == nil)
				if equippedInfo and (missingDur or (equippedItem.Durability and equippedItem.Durability > 0)) then
					local equippedName = equippedInfo.Name
					if equippedName == "Salvaged Shovel" or equippedName == "Steel Shovel" then
						shovel = equippedItem
						equippedIndex = user.Equipped.Index
						digTime = (equippedName == "Salvaged Shovel" and 2.5 or 1)
					end
				end
			end
			local thread; thread = task.spawn(function()
				local passed = 0
				--print("dig loop started")
				while true do
					passed += task.wait(0.1)
					if not (player.Parent and humanoid.Parent and humanoid.Health > 0 and humPrim.Parent and primPart.Parent and (shovel == nil or (user.Equipped.Item == shovel and (missingDur or shovel.Durability > 0))) and NumberUtil:IsWithin(humPrim.Position, primPart.Position, 11)) then break end
					if passed >= digTime then
						--print("DIGGING SUCCESSFUL")
						if shovel and equippedIndex and not missingDur then
							shovel.Durability = math.max(shovel.Durability - 1, 0)
							user.Inventory:UpdateClient({"Toolbar", user.Equipped.Index, toolbar[user.Equipped.Index]})
						end
						object.Parent = VFX_PARTS
						local posCFs = {}
						for index, bench in pairs(benches) do
							local benchModel = bench.Model
							if not (benchModel and benchModel.Parent) then continue end
							posCFs[index] = object["Pos"..(index - 1)].CFrame
						end
						object:PivotTo(object:GetPivot() * CFrame.new(0, -0.75, 0))
						for _, part in pairs(object:GetChildren()) do
							if not part:IsA("BasePart") then continue end
							part.CanCollide = false
							part.CanQuery = false
							--[[if part.Transparency >= 1 then continue end
							TweenUtil:Tween(part, "Transparency", 1, 1, "Quart", "Out")]]
						end
						task.defer(function()
							local tweens = {}
							for index, bench in pairs(benches) do
								local benchModel = bench.Model
								if not (benchModel and benchModel.Parent) then continue end
								benchModel.PrimaryPart = benchModel.Main
								local desiredHealth = benchModel:GetAttribute("DesiredHealth")
								if desiredHealth then
									benchModel:SetAttribute("Health", desiredHealth)
									benchModel:SetAttribute("MaxHealth", desiredHealth)
									benchModel:SetAttribute("DesiredHealth", nil)
								end
								local posCF = posCFs[index]
								local hit, pos, nor = RaycastUtil:Raycast(posCF.Position, posCF.UpVector * -5, "Include", Terrain)
								if not hit then continue end
								local cf = CFrame.new(pos, pos + nor) * CFrame.Angles(math.rad(-90), math.rad(math.random(-179, 179)), 0)
								tweens[benchModel] = {benchModel.Main.CFrame, cf * CFrame.new(0, math.max(benchModel.Main.Size.Y / 2 - 0.1, 0), 0)}
							end
							local passed = 0
							local moveTime = 1
							repeat
								passed = math.min(passed + task.wait(1/30), moveTime)
								for obj, t in pairs(tweens) do
									if not obj.Parent then
										tweens[obj] = nil
										continue
									end
									local origin = t[1]
									local target = t[2]
									local x = passed / moveTime
									local y = Tween:GetValue(x, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
									obj:PivotTo(origin:Lerp(target, y))
								end
							until passed >= moveTime
							passed = 0
							local despawnTime = 150
							repeat
								passed += task.wait(math.min(despawnTime - passed + 1, 10))
								if not object.Parent then return end
							until passed >= despawnTime
							local pileTable = (shared.DigPiles or {})[object]
							if not pileTable then return end
							for index = #pileTable, 1, -1 do
								local bench = pileTable[index]
								local benchModel = bench.Model
								if not benchModel then continue end
								bench.MadeBenchBag = true
								bench:Delete()
								if benchModel.Parent then
									ModUtil:SafeDestroy(benchModel, true)
								end
							end
							--[[local terrainInfo = pileTable[1]
							Terrain:WriteVoxels(terrainInfo[1], 4, terrainInfo[2], terrainInfo[3])
							for _, bench in pairs(pileTable) do
								local spawnArea = bench.SpawnArea
								if not spawnArea then continue end
								print("FOUND LOL")
								spawnArea:RemoveFromContainer("DigPiles", object)
								break
							end
							digPiles[object] = nil
							object:Destroy()]]
							--[[if not object.Parent then return end
							object:Destroy()]]
						end)
						break
					end
				end
				--print("dig loop ended")
				if user.Digging == thread then
					user.Digging = false
				end
			end)
			user.Digging = thread
			return digTime
		end;
	};
})