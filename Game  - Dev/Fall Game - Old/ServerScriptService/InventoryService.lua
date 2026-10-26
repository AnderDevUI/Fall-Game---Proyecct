-- [PATH] ServerScriptService / ServerService / InventoryService @Type Script
--[[
	InventoryService
	by ChickenBagelz
	July 16, 2022
]]

-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local Http = game:GetService("HttpService")
local ServerScripts = game:GetService("ServerScriptService")

-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")

-- Folders
local Remotes = Replicated:WaitForChild("Remotes")
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local InventoryRemotes = Remotes:WaitForChild(string.char(112, 17, 107, 22, 65, 146, 120, 135, 75, 57, 109, 34, 79, 105, 140, 153, 152, 95, 159, 125, 83, 96, 185, 108, 168, 132, 159, 28, 114, 103))
local ItemModels = Storage:WaitForChild("Items")
local Drops = workspace:WaitForChild("Drops")
local VFX_STORAGE = Replicated:WaitForChild("VFX")
local VFX_PARTS = workspace:WaitForChild("VFX")

-- Modules
local Items = require(SharedModules:WaitForChild("Items"))
local ItemClass = require(SharedModules:WaitForChild("ItemClass"))
local WeldModule = require(SharedModules:WaitForChild("WeldModule"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local LootTableModule = require(ServerModules:WaitForChild("LootTableModule"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local TableUtil = require(SharedModules:WaitForChild("TableUtil"))
local SoundModule = require(ServerModules:WaitForChild("SoundModule"))

-- Local Variables
local DroppedItems = {}
local viewFilterFunc = RaycastUtil:FilterFunction("View")


-- Global Functions
shared.AddDroppedItem = function(itemModel)
	if not (itemModel and itemModel.Parent) then return end
	local despawnTick, item = GetDespawnTick(itemModel)
	local id, skin, durability
	if item then
		local info = Items[item.ID]
		if info.MaxStack > 1 then
			id, skin, durability = item.ID, item.Skin, item.Durability
		end
	end
	local itemTable = {
		Model = itemModel;
		DespawnTick = despawnTick;
		ID = id;
		Skin = skin;
		Durability = durability;
	}
	table.insert(DroppedItems, itemTable)
	UpdateDroppedItems(itemModel)
	return itemTable
end

shared.UpdateDroppedItem = function(itemModel, despawnTick)
	if not (itemModel and itemModel.Parent) then return end
	for _, itemTable in pairs(DroppedItems) do
		if itemTable.Model ~= itemModel then continue end
		itemTable.DespawnTick = math.min((despawnTick or GetDespawnTick(itemModel)), itemTable.DespawnTick)
		return
	end
end

shared.SetupDrop = function(itemTable, setOwner)
	local itemModel = itemTable.Model
	local id, skin, durability = itemTable.ID, itemTable.Skin, itemTable.Durability
	if not (itemModel and itemModel.Parent) then return end
	local prim = itemModel.PrimaryPart
	local itemVal = itemModel:FindFirstChild("Item")
	if not prim then return end
	while itemModel:GetAttribute("IsThrow") do
		itemModel:GetAttributeChangedSignal("IsThrow"):Wait()
		task.wait()
	end
	if not (itemModel and itemModel.Parent) then return end
	--print("preparing to anchor", itemModel)
	prim.Anchored = false
	if setOwner then
		prim:SetNetworkOwner(nil)
	end
	DisconnectDropConnections(itemTable)
	local lastPos
	local waitTime = 1
	local dropMergeDist = script:GetAttribute("DropMergeDistance")
	local closeMergeDist = script:GetAttribute("DropCloseMergeDistance")
	while itemModel and itemModel.Parent do
		local pos = prim.Position
		if lastPos then
			if id and itemVal then
				for _, drop in pairs(DroppedItems) do
					local dropModel = drop.Model
					if not (dropModel ~= itemModel and drop.ID == id and dropModel and dropModel.Parent and (drop.Durability or 0) == (durability or 0) and (drop.Skin or "Default") == (skin or "Default")) then continue end
					local dropItemVal = dropModel:FindFirstChild("Item")
					local dropPrim = dropModel.PrimaryPart
					if not (dropPrim and dropItemVal) then continue end
					local dropPos = dropPrim.Position
					local dir = dropPos - pos
					local dropDist = dir.Magnitude
					if dropDist > dropMergeDist then continue end
					local hit = RaycastUtil:Raycast(pos, dir, "Blacklist", {itemModel, VFX_PARTS}, false, function(h)
						local filter = viewFilterFunc(h)
						if filter then
							return filter
						elseif h:IsDescendantOf(Drops) and not h:IsDescendantOf(dropModel) then
							return h.Parent
						end						
					end)
					if ((not hit) and dropDist >= closeMergeDist) or (hit and not hit:IsDescendantOf(dropModel)) then continue end
					local dropItem = Http:JSONDecode(dropItemVal.Value)
					local item = Http:JSONDecode(itemVal.Value)
					dropItem.Amount += item.Amount
					drop.DespawnTick = GetDespawnTick(dropModel)
					dropItemVal.Value = Http:JSONEncode(dropItem)
					--print(item.Amount, "merged into", dropModel, dropItem.Amount)
					ModUtil:SafeDestroy(itemModel)
					return
				end
			end
			if NumberUtil:IsWithin(pos, lastPos, 0.25) then
				local touchingParts = (itemModel:FindFirstChild("Collision") or prim):GetTouchingParts()
				prim.Anchored = true
				local connections = {}
				for _, touching in pairs(touchingParts) do
					if not (touching and touching.Parent and not touching:IsA("Terrain")) then continue end
					local conFired = false
					local con; con = touching:GetPropertyChangedSignal("Parent"):Connect(function()
						if conFired or (touching and touching.Parent) then return end
						conFired = true
						--print("touching part removed, unanchoring")
						task.wait()
						shared.SetupDrop(itemTable, true)
					end)
					table.insert(connections, con)
				end
				itemTable.Connections = connections
				--print(itemModel, "anchored", touchingParts)
				break
			end
		end
		lastPos = pos
		task.wait(waitTime)
		waitTime = 0.5
	end
end

-- Functions
function GetDespawnTick(itemModel)
	local despawnTime = 3
	local itemVal = itemModel:FindFirstChild("Item")
	local item
	if itemVal then
		item = Http:JSONDecode(itemVal.Value)
		local info = Items[item.ID]
		if info and info.DespawnTime then
			despawnTime = info.DespawnTime
		end
	else
		local bench = shared.Benches[itemModel]
		if bench then
			local container = bench.Container
			if container then
				despawnTime = 0
				for index, itemTable in pairs(container) do
					local containerItem = itemTable.Item
					if not (containerItem and containerItem ~= 0) then continue end
					local itemInfo = Items[containerItem.ID]
					if not itemInfo then continue end
					despawnTime = math.max((itemInfo.DespawnTime or 0), despawnTime)
				end
			end
		end
	end
	return tick() + despawnTime * 60 / script:GetAttribute("DespawnTimeMult"), item
end

function DisconnectDropConnections(itemTable)
	local connections = itemTable.Connections
	if connections then
		for _, con in pairs(connections) do
			con:Disconnect()
		end
	end
	itemTable.Connections = nil
end

function UpdateDroppedItems(ignore)
	local totalDrops = 0
	for index, itemTable in pairs(DroppedItems) do
		local itemModel = itemTable.Model
		if not itemModel then continue end
		if not itemModel.Parent then
			DisconnectDropConnections(itemTable)
			table.remove(DroppedItems, index)
			continue
		end
		totalDrops += 1
	end
	local maxDropCount = script:GetAttribute("MaxDropCount")
	if totalDrops <= maxDropCount then return end
	local currentTick = tick()
	table.sort(DroppedItems, function(a, b)
		local despawnTimeA = a.DespawnTick - currentTick
		local despawnTimeB = b.DespawnTick - currentTick
		return (despawnTimeA > despawnTimeB)
	end)
	print("max drop count reached", "("..totalDrops.." > "..maxDropCount..")", DroppedItems)
	for index = #DroppedItems, 1, -1 do
		local itemTable = DroppedItems[index]
		if not itemTable then continue end
		local itemModel = itemTable.Model
		if itemModel == ignore then continue end
		--print("clearing ", itemModel, "("..itemTable.DespawnTick - currentTick.." seconds left until despawn)")
		ModUtil:SafeDestroy(itemModel)
		DisconnectDropConnections(itemTable)
		table.remove(DroppedItems, index)
		totalDrops -= 1
		if totalDrops <= maxDropCount then break end
	end
end

function DropItem(typ, item, amount, direction, ignoreVel, customModel)
	local cf = (typeof(typ) == "CFrame" and typ)
	local player
	if not cf then
		player = typ
		local char = player.Character
		if char then
			local prim = char.PrimaryPart
			local hum = char:FindFirstChild("Humanoid")
			if prim then
				cf = prim.CFrame
			end
		end
	end
	--print(player, typ, cf)
	if not cf then return end
	local info = Items[item.ID]
	local itemModel = (customModel or ItemModels:FindFirstChild(info.Name) or ItemModels:FindFirstChild("Default"))
	if itemModel:IsA("Folder") then
		itemModel = (itemModel:FindFirstChild(item.Skin or "Default") or itemModel:FindFirstChild("Default"))
	end
	itemModel = ModUtil:SafeClone(itemModel)
	itemModel.Name = info.Name
	local itemInfo = Instance.new("StringValue")
	itemInfo.Name = "Item"
	local oldAmount = item.Amount
	item.Amount = amount
	itemInfo.Value = Http:JSONEncode(item)
	item.Amount = oldAmount
	itemInfo.Parent = itemModel
	itemModel.PrimaryPart = (itemModel:FindFirstChild("Main") or itemModel:FindFirstChild("Handle"))
	--[[local highlight = ModUtil:SafeClone(VFX_STORAGE.Highlight)
	highlight.Parent = itemModel]]
	itemModel.Parent = Drops
	local attachmentFolder = itemModel:FindFirstChild("Attachments")
	if attachmentFolder and item.Attachments then
		WeldModule:WeldAttachments(itemModel, item)
	end
	for _, model in pairs({itemModel, (attachmentFolder and unpack(attachmentFolder:GetChildren()))}) do
		if not (model and model.Parent) then continue end
		for _, part in pairs(model:GetChildren()) do
			if not part:IsA("BasePart") then continue end
			if part.Transparency == 1 and part.Name ~= "FlashPart" and part.Name ~= "Hitbox" and part.Name ~= "Handle" and part.Name ~= "RocketRoot" and part.Name ~= "Arrow" and part.Name ~= "Wood Spear" and not part.Name:find("Main") then
				--print("deleting", part)
				part:Destroy()
				continue
			end
			part.CanCollide = true
			part.Anchored = false
			part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 2, 0.5)
			part.CollisionGroup = "Items"
		end
	end
	itemModel.PrimaryPart:SetNetworkOwner(player)
	if not ignoreVel then
		itemModel.PrimaryPart.AssemblyLinearVelocity = (direction or cf).LookVector * 15
		task.delay(0.1, function()
			if not (itemModel and itemModel.Parent == Drops and itemModel.PrimaryPart) then return end
			itemModel.PrimaryPart.AssemblyLinearVelocity = Vector3.new()
		end)
	end
	itemModel:PivotTo(cf)
	local itemTable = shared.AddDroppedItem(itemModel)
	if itemTable then
		task.defer(shared.SetupDrop, itemTable)
	end
	return itemModel
end

-- Bindables
script.DropItem.OnInvoke = DropItem

-- Remotes
local AllRemotes = {
	Fetch = string.char(16, 19, 29, 113, 24, 175, 14, 3, 182, 41, 116, 77, 11, 175, 50, 140, 128, 42, 4, 128, 146, 2, 117, 135, 37, 129, 145, 54, 134, 135);
	Inventory = string.char(53, 11, 104, 88, 159, 158, 138, 46, 60, 39, 122, 104, 25, 110, 176, 190, 84, 79, 104, 16, 3, 115, 180, 167, 55, 106, 24, 128, 170, 167);
	Update = string.char(46, 140, 60, 189, 147, 36, 171, 98, 122, 54, 166, 1, 67, 35, 73, 113, 83, 148, 150, 187, 151, 41, 183, 1, 10, 173, 51, 78, 26, 85);
}
ModUtil:SetupRemotes(InventoryRemotes, {
	[AllRemotes.Fetch] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if user then
				if #args > 0 then
					return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
				end
				return user.Inventory:GetInv(), user.ResearchLevels, user.Skins
			end
		end;
	};
	[AllRemotes.Inventory] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local hum = user.Humanoid
			if not (hum and hum.Health > 0 and not hum:GetAttribute("Downed")) or os.clock() - (user.IgnoreInv or 0) < 2 then return end
			local char = hum.Parent
			if not char then return end
			for index, arg in pairs(args) do
				if arg ~= "none" then continue end
				args[index] = nil
			end
			local inventory = user.Inventory
			local containers = inventory:GetInv()
			local equipped = user.Equipped
			local fromContainer = args[1]
			local fromIndex = args[2]
			--print(unpack(args))
			local from = containers[fromContainer]
			if type(fromContainer) ~= "string" or type(fromIndex) ~= "number" or (from and (fromIndex < 0 or fromIndex % 1 ~= 0)) then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			if not (from and fromIndex > 0 and fromIndex <= #from) then return end
			local benchModel = user.Bench
			local bench
			if benchModel then
				bench = shared.Benches[benchModel]
			end
			if fromContainer == "Bench" and (not bench or bench.DenyAccess) then return end
			local maxStackMult = ServerService:GetAttribute("MaxStackMult")
			if args[3] == "QuickStack" or args[3] == "UnloadAmmo" or args[3] == "ItemDrop" then
				if #args > 3 then
					return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
				end
				local fromItem = from[fromIndex]
				if fromItem and fromItem ~= 0 then
					if fromIndex == 0 then return end
					if fromItem.Amount <= 0 then
						from[fromIndex] = 0
						inventory:UpdateClient({fromContainer, fromIndex, from[fromIndex]})
						return
					end
					local fromInfo = Items[fromItem.ID]
					local updates = {}
					local armorIndexCheck
					if args[3] == "QuickStack" then
						local fromMaxStack = (fromInfo.MaxStack == 1 and 1 or math.round(fromInfo.MaxStack * maxStackMult))
						if fromItem.Amount > fromMaxStack then return end
						local isToolbar = fromItem:IsToolbar()
						local containerFits = (bench and ((fromContainer == "Inventory" or fromContainer == "Toolbar") and "Bench" or {(isToolbar and "Toolbar" or "Inventory"), (isToolbar and "Inventory" or "Toolbar")}) or (fromContainer == "Armor" and {"Inventory", "Toolbar"} or (fromInfo.Type == "Armor" and "Armor" or (fromContainer == "Inventory" and "Toolbar" or "Inventory"))))
						local amountToAdd = 0
						if containerFits == "Bench" then
							if not bench or bench.DenyAccess then return end
							if bench and bench.MaxStack and fromItem.Amount > bench.MaxStack then
								amountToAdd = fromItem.Amount - bench.MaxStack
								fromItem.Amount = bench.MaxStack
							end
						end
						--print(containerFits)
						local intoArmor = (containerFits == "Armor")
						if intoArmor then -- We are right clicking armor from our inventory to our armor slots, we need custom logic to avoid it being full and it not working
							inventory:CheckArmor(nil, fromItem)
						end
						local left, found = inventory:CanFitItem(fromItem, containerFits)
						if left < fromItem.Amount then
							updates = inventory:FitItem(fromItem, found)
							if amountToAdd > 0 then
								fromItem.Amount += amountToAdd
							end
							if fromItem.Amount <= 0 then
								from[fromIndex] = 0
							end
							--print("quick-stacked "..fromContainer..fromIndex.." to", from[fromIndex])
							table.insert(updates, {fromContainer, fromIndex, from[fromIndex]})
						elseif amountToAdd > 0 then
							fromItem.Amount += amountToAdd
						end
						if not intoArmor then
							for _, update in pairs(updates) do
								if update[1] ~= "Armor" then continue end
								armorIndexCheck = update[2]
								break
							end
						end
						inventory:UpdateClient(unpack(updates))
					elseif args[3] == "UnloadAmmo" then
						local ammo = fromItem.Ammo
						if ammo and ammo.Amount > 0 then
							--print("unloaded ammo of", fromContainer, fromIndex)
							local left, found = inventory:CanFitItem(ammo, {"Inventory", "Toolbar"})
							updates = inventory:FitItem(ammo, found)
							if ammo.Amount > 0 then
								if script:GetAttribute("ItemDropEnabled") then
									DropItem(player, ammo, ammo.Amount)
								end
								ammo:SetAmount(0)
							end
							table.insert(updates, {fromContainer, fromIndex, from[fromIndex], (equipped.Item == from[fromIndex] and "LocalAmmo")})
							inventory:UpdateClient(unpack(updates))
						end
					else
						local dropInfo = fromInfo.DropInfo
						if dropInfo then
							--print(dropInfo)
							local lootTable = LootTableModule:GetLootTable(unpack(dropInfo.LootTable))
							if lootTable then
								--print(lootTable)
								fromItem.Amount -= 1
								if fromItem.Amount <= 0 then
									from[fromIndex] = 0
								end
								table.insert(updates, {fromContainer, fromIndex, from[fromIndex]})
								inventory:UpdateClient(unpack(updates))
								local itemsGiven = lootTable:Roll(ServerService:GetAttribute("GatherMult"), ServerService:GetAttribute("LuckMult"))
								for _, itemGiven in pairs(itemsGiven) do
									inventory:AddItem(itemGiven)
								end
							end
						end
					end
					if armorIndexCheck then
						inventory:CheckArmor(armorIndexCheck)
					end
				end
			else
				--print(unpack(args))
				local fromAmount = args[3]
				local toContainer = args[4]
				local toIndex = args[5]
				local extra = args[6]
				local attachmentIndex = args[7]
				local dropDir = args[8]
				local to = containers[toContainer]
				local isDrop = (toContainer == "Drop")
				--print(isDrop == true, typeof(dropDir))
				if (to == nil or toIndex > #to) and not isDrop then return end
				if (fromAmount ~= nil and type(fromAmount) ~= "number") or type(toContainer) ~= "string" or 
					(isDrop == false and type(toIndex) ~= "number") or (isDrop == false and (toIndex < 0 or toIndex % 1 ~= 0)) or 
					(isDrop == true and typeof(dropDir) ~= "CFrame") or (isDrop == false and dropDir) or (extra and type(extra) ~= "string") or args[9] ~= nil or 
					(attachmentIndex ~= nil and (type(attachmentIndex) ~= "number" or attachmentIndex < 1 or attachmentIndex > 4 or attachmentIndex % 1 ~= 0)) then
					return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
				end
				if (isDrop == false and toIndex <= 0) or (toContainer == "Bench" and (not bench or bench.DenyAccess)) then return end
				if isDrop or to then
					local fromItem = from[fromIndex]
					local toItem
					if not isDrop then
						toItem = to[toIndex]
					end
					-- THIS IS FOR DELETING ANY ITEMS WITH AMOUNT == 0
					if fromItem and fromItem ~= 0 then 
						if fromIndex == 0 then return end
						if fromItem.Amount <= 0 then
							from[fromIndex] = 0
							inventory:UpdateClient({fromContainer, fromIndex, from[fromIndex]})
							return
						end
					end
					if toItem and toItem ~= 0 then
						if toItem.Amount <= 0 then
							to[toIndex] = 0
							inventory:UpdateClient({toContainer, toIndex, to[toIndex]})
							return
						end
					end
					if fromItem and fromItem ~= 0 and (isDrop or toItem) then
						local fromInfo = Items[fromItem.ID]
						local checkItem = fromItem
						if extra == "RemoveAttachment" then
							checkItem = fromItem.Attachments[attachmentIndex]
							if not checkItem then
								return 
							end
						end
						local checkInfo = Items[checkItem.ID]
						fromAmount = (fromAmount == nil and checkItem.Amount or fromAmount)
						if fromAmount < 0 or fromAmount % 1 ~= 0 then return end -- used to ban, idk it would false every once in a while
						fromAmount = math.min(fromAmount, checkItem.Amount)
						if (toContainer == "Bench" and bench and bench.MaxStack) then
							fromAmount = math.min(fromAmount, bench.MaxStack)
						end
						if fromAmount <= 0 then return end
						local toEmpty = (toItem == 0)
						local isWholeStack = (checkItem.Amount == fromAmount)
						local did = false
						if isDrop or toEmpty or (toItem.ID == checkItem.ID and checkInfo.MaxStack > 1 and (toItem.Durability or 0) == (checkItem.Durability or 0)) then
							if (toContainer == "Bench" and bench and not bench:CanFitItemInSlot(checkItem, toIndex, player.UserId)) or (toContainer == "Armor" and checkInfo.Type ~= "Armor") then return end
							did = true
							local ignore = false
							local checkMaxStack = (checkInfo.MaxStack == 1 and 1 or math.round(checkInfo.MaxStack * maxStackMult))
							if isDrop or toEmpty then
								if isWholeStack then
									if isDrop then
										--print("dropping full stack")
										if script:GetAttribute("ItemDropEnabled") then
											DropItem(player, checkItem, fromAmount, dropDir)
										end
									else
										--print("dragging onto empty slot")
										to[toIndex] = checkItem
									end
									if extra then
										fromItem:RemoveAttachment(attachmentIndex)
									else
										from[fromIndex] = 0
									end
									ignore = true
								else
									--if checkItem.Amount > checkMaxStack then return end
									if isDrop then
										--print("dropping partial stack")
									else
										--print("dragging partial stack to empty slot")
										toItem = inventory:CreateItem(toContainer, toIndex, checkItem:GetComponents(5))
										toItem:SetAmount(0)
									end
								end
							end
							if (not ignore) and (isDrop or toItem.Amount < checkMaxStack) then
								local changeAmount
								if isDrop then
									changeAmount = fromAmount
								else
									local before = toItem.Amount
									toItem:ChangeAmount(fromAmount, maxStackMult)
									changeAmount = toItem.Amount - before
								end
								checkItem:ChangeAmount(-changeAmount, math.max(maxStackMult, checkItem.Amount))
								if checkItem.Amount <= 0 then
									if extra then
										fromItem:RemoveAttachment(attachmentIndex)
									else
										from[fromIndex] = 0
									end
								end
								if isDrop and changeAmount > 0 then
									if script:GetAttribute("ItemDropEnabled") then
										DropItem(player, checkItem, changeAmount, dropDir)
									end
								--[[else
									print("left "..checkItem.Amount.." on old stack, "..toItem.Amount.." on new stack")]]
								end
							end
						elseif isWholeStack then
							--print("swapping slots")
							local toInfo = Items[toItem.ID]
							local attachments = toInfo.Attachments
							if checkInfo.Type == "Attachment" and attachments then
								local attachmentType = checkInfo.AttachmentType
								if table.find(attachments, attachmentType) then
									local found = false
									for _, attachment in pairs(toItem.Attachments) do
										local attachmentInfo = Items[attachment.ID]
										if attachmentInfo.AttachmentType == attachmentType then
											found = true
											break
										end
									end
									if not found then
										--print("added attachment")
										checkItem:ChangeAmount(-1, maxStackMult)
										if checkItem.Amount <= 0 then
											checkItem:SetAmount(1)
											if extra then
												fromItem:RemoveAttachment(attachmentIndex)
											else
												from[fromIndex] = 0
											end
											toItem:AddAttachment(checkItem)
										else
											local oldAmount = checkItem.Amount
											checkItem:SetAmount(1)
											toItem:AddAttachment(ItemClass.new(TableUtil:CloneTable(checkItem)))
											checkItem:SetAmount(oldAmount)
										end
										SoundModule:PlayLocalSound(player, "AttachmentEquip")
									end
								end
								did = true
							end
							if not (did or extra) then
								if (toContainer == "Bench" and bench and not bench:CanFitItemInSlot(fromItem, toIndex, player.UserId)) or (toContainer == "Armor" and fromInfo.Type ~= "Armor") then return end
								if (fromContainer == "Bench" and bench and not bench:CanFitItemInSlot(toItem, fromIndex, player.UserId)) or (fromContainer == "Armor" and toInfo.Type ~= "Armor") then return end
								to[toIndex] = fromItem
								from[fromIndex] = toItem
								did = true
							end
						end
						if did then
							local toSend
							if not isDrop then
								toSend = {toContainer, toIndex, to[toIndex], "Save"}
							end
							if fromContainer == "Armor" and toContainer ~= "Armor" then
								inventory:CheckArmor(fromIndex)
							elseif toContainer == "Armor" and fromContainer ~= "Armor" then
								inventory:CheckArmor(toIndex)
							end
							for i = 1, 2 do
								if i == 2 and (isDrop or not to or not toIndex) then break end
								local item = (i == 1 and from[fromIndex] or to[toIndex])
								if type(item) ~= "table" or not item.Attachments then continue end
								local configs = {}
								for index, attachment in pairs(item.Attachments) do
									configs[index] = (attachment and attachment.ID)
								end
								user.AttachmentConfigs[item.ID] = configs
								--print("set attachment configs of", Items[item.ID].Name, "to", configs)
							end
							inventory:UpdateClient(toSend, {fromContainer, fromIndex, from[fromIndex], "Drag"})
							if equipped.Model and equipped.Item and (equipped.Item == fromItem or equipped.Item == toItem) and equipped.Index and equipped.Index > 0 then
								WeldModule:WeldAttachments(equipped.Model, equipped.Item)
							end
						end
					end
				end
			end
		end;
	};
	[AllRemotes.Update] = { -- Nobody should be firing this unless it's anticheat doing so
		Function = function(remote, player, args)
			return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
		end;
	};
})

while task.wait(script:GetAttribute("DropDespawnCheck")) do
	local count = 0
	for index = #DroppedItems, 1, -1 do
		local itemTable = DroppedItems[index]
		if not itemTable then continue end
		count += 1
		if tick() >= itemTable.DespawnTick then
			local itemModel = itemTable.Model
			--print("despawning ", itemModel)
			if itemModel and itemModel.Parent then
				ModUtil:SafeDestroy(itemModel)
			end
			DisconnectDropConnections(itemTable)
			table.remove(DroppedItems, index)
		end
		if count % 50 ~= 0 then continue end
		task.wait()
	end
end