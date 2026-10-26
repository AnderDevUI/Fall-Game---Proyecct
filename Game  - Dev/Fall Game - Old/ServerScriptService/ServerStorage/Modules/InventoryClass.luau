-- [PATH] ServerStorage / Modules / InventoryClass @Type ModuleScript
--[[
	InventoryClass
	by ChickenBagelz
	July 16, 2022
	
	Holds all ItemClasses in your inventory and controls different inventory interactions
]]

-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local ServerScripts = game:GetService("ServerScriptService")
local Sound = game:GetService("SoundService")

-- Dependencies
local InventoryService = ServerScripts:WaitForChild("InventoryService")
local ServerService = ServerScripts:WaitForChild("ServerService")

-- Folders
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")
local InventoryRemotes = Remotes:WaitForChild(string.char(112, 17, 107, 22, 65, 146, 120, 135, 75, 57, 109, 34, 79, 105, 140, 153, 152, 95, 159, 125, 83, 96, 185, 108, 168, 132, 159, 28, 114, 103))
local EquipRemotes = Remotes:WaitForChild(string.char(48, 32, 92, 99, 132, 71, 174, 29, 30, 26, 187, 7, 15, 97, 74, 158, 136, 71, 94, 130, 105, 30, 61, 94, 189, 126, 122, 164, 159, 188))

-- Remotes
local AllRemotes = {
	Update = string.char(46, 140, 60, 189, 147, 36, 171, 98, 122, 54, 166, 1, 67, 35, 73, 113, 83, 148, 150, 187, 151, 41, 183, 1, 10, 173, 51, 78, 26, 85);
	Equip = string.char(12, 24, 129, 111, 133, 84, 169, 122, 127, 1, 125, 129, 159, 123, 134, 132, 189, 66, 19, 177, 43, 98, 73, 179, 94, 189, 188, 3, 146, 44);
	Pickup = string.char(131, 48, 148, 184, 91, 1, 106, 50, 100, 47, 39, 105, 95, 145, 161, 7, 93, 92, 85, 49, 70, 28, 166, 135, 74, 145, 82, 20, 88, 34);
}
local StatsRemotes = Remotes:WaitForChild(string.char(32, 175, 56, 160, 50, 187, 113, 77, 49, 22, 130, 142, 126, 38, 59, 102, 17, 6, 168, 41, 9, 180, 85, 142, 105, 14, 66, 146, 142, 126))

-- Modules
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local Items = require(SharedModules:WaitForChild("Items"))
local ItemClass = require(SharedModules:WaitForChild("ItemClass"))
local ArmorModule = require(SharedModules:WaitForChild("ArmorModule"))
local TableUtil = require(SharedModules:WaitForChild("TableUtil"))

local InventoryClass = {}
InventoryClass.__index = InventoryClass

function InventoryClass.new(player)
	local self = setmetatable({}, InventoryClass)
	self.Player = player
	self.Containers = {}
	self:ClearInventory()
	
	return self
end

function InventoryClass:CreateItem(container, slot, ...)
	local args = {...}
	local t = self.Containers[container]
	if t and t[slot] then
		local item = ItemClass.new(...)
		t[slot] = item
		return item
	end
end

function InventoryClass:FindItem(amount, containers, funcArgs, func)
	func = (func or function(item, args)
		return item.ID == args[1]
	end)
	local left = amount
	local found = {}
	for _, containerName in pairs(containers) do
		local container = self.Containers[containerName]
		for index, item in pairs(container) do
			if item ~= 0 and item.Amount > 0 and func(item, funcArgs) then
				local last = left
				left = math.max(left - item.Amount, 0)
				table.insert(found, {containerName, index, last - left})
				if left <= 0 then
					break
				end
			end
		end
		if left <= 0 then
			break
		end
	end
	return left <= 0, found, left
end

function InventoryClass:RemoveFoundItems(founds, amount, saveInfo)
	local containers = self:GetInv()
	local player = self.Player
	local update = {}
	local foundItems = {}
	local savedInfo
	for _, found in pairs(founds) do
		local containerName = found[1]
		local foundIndex = found[2]
		local container = containers[containerName]
		local foundItem = container[foundIndex]
		local id = foundItem.ID
		local dur = foundItem.Durability
		local foundInfo = Items[id]
		local foundName = foundInfo.Name
		local old = foundItem.Amount
		foundItem.Amount = math.max(foundItem.Amount - amount, 0)
		local change = (old - foundItem.Amount)
		amount -= change
		if foundItem.Amount <= 0 then
			container[foundIndex] = 0
		end
		if not foundItems[foundName] then
			foundItems[foundName] = 0
		end
		if saveInfo then
			local info = Items[id]
			if info.MaxDurability and dur then
				savedInfo = savedInfo or {}
				for _ = 1, change do
					table.insert(savedInfo, {id, (foundItem.Skin or "Default"), dur, (foundItem.Repair or 0)}) -- might need to add more like ammos and attachments
				end
			end
		end
		foundItems[foundName] += change
		table.insert(update, {containerName, foundIndex, container[foundIndex]})
		if amount <= 0 then break end
	end
	for itemName, amountRemoved in pairs(foundItems) do
		ModUtil:FireClient(StatsRemotes, AllRemotes.Pickup, player, {
			"Drop"..itemName,
			amountRemoved
		}) --Send
	end
	return update, amount, savedInfo
end

function InventoryClass:FindItemFromTable(item)
	for container, t in pairs(self.Containers) do
		for index, v in pairs(container) do
			if v == item then
				return container, index
			end
		end
	end
end

function InventoryClass:CanFitItem(fitItem, containers)
	local player = self.Player
	local user = shared.Users[player]
	local benchModel = user.Bench
	local bench
	if benchModel then
		bench = shared.Benches[benchModel]
	end
	local left = fitItem.Amount
	local info = Items[fitItem.ID]
	local maxStack = (info.MaxStack == 1 and 1 or math.round(info.MaxStack * ServerService:GetAttribute("MaxStackMult")))
	local found = {}
	for p = 1, 2 do
		for _, containerName in pairs(type(containers) == "string" and {containers} or containers) do
			local container = self.Containers[containerName]
			for index, item in pairs(container or {}) do
				if containerName == "Bench" and bench and not bench:CanFitItemInSlot(fitItem, index, player.UserId) then continue end
				if (p == 1 and item ~= 0 and item.Amount > 0 and item.ID == fitItem.ID and item.Amount < maxStack and (item.Durability or 0) == (fitItem.Durability or 0)) or (p == 2 and item == 0) then
					local amount = (item == 0 and 0 or item.Amount)
					local fitAmount = math.min(amount + left, maxStack)
					local totalFit = fitAmount - amount
					left = math.max(left - totalFit, 0)
					table.insert(found, {containerName, index, totalFit})
					if left <= 0 then
						break
					end
				end
			end
			if left <= 0 then
				break
			end
		end
		if left <= 0 then
			break
		end
	end
	return left, found
end

function InventoryClass:FitItem(fitItem, found)
	local update = {}
	local maxStackMult = ServerService:GetAttribute("MaxStackMult")
	for _, t in pairs(found) do
		local containerName = t[1]
		local index = t[2]
		local totalFit = t[3]
		local container = self.Containers[containerName]
		if container then
			local item = container[index]
			if item then
				if item == 0 then
					item = ItemClass.new(TableUtil:CloneTable(fitItem))
					container[index] = item
					item.Amount = 0
				end
				--print("added "..totalFit.." to "..containerName..index.." (now "..(item.Amount + totalFit)..")")
				item:ChangeAmount(totalFit, maxStackMult)
				fitItem:ChangeAmount(-totalFit, maxStackMult)
				table.insert(update, {containerName, index, item})
			end
		end
	end
	return update
end

function InventoryClass:AddItem(...)
	local player = self.Player
	local args = {...}
	local item = (type(args[1]) == "table" and args[1] or ItemClass.new(...))
	local origAmount = item.Amount
	if origAmount <= 0 then return end
	local isToolbar = item:IsToolbar()
	local left, found = self:CanFitItem(item, {(isToolbar and "Toolbar" or "Inventory"), (isToolbar and "Inventory" or "Toolbar")})
	local updates = self:FitItem(item, found)
	if left > 0 then
		InventoryService.DropItem:Invoke(player, item, left)
	end
	local amountPickedUp = origAmount - left
	local itemName = Items[item.ID].Name
	self:UpdateClient(unpack(updates))
	local pickupInfo = {
		"Pickup"..itemName, amountPickedUp
	}
	ModUtil:FireClient(StatsRemotes, AllRemotes.Pickup, player, pickupInfo) --Send
end

function InventoryClass:UpdateBenchContainer(bench)
	local containers = self.Containers
	local player = self.Player
	local updates = {}
	if bench == nil then
		containers.Bench = nil
	else
		local items = {}
		local benchContainer = bench.Container
		local isLocal = bench.IsLocal
		local container = benchContainer
		if isLocal then
			container = benchContainer[player.UserId]
			if not container then
				--print("CREATED NEW CONTAINER FOR", player.Name)
				container = {}
				benchContainer[player.UserId] = container
				for index, itemTable in pairs(bench.BackupContainer) do
					container[index] = {
						Type = itemTable.Type;
						Item = 0;
					}
				end
			end
		end
		for index, itemTable in pairs(container) do
			local item = (itemTable.Item or 0)
			table.insert(items, item)
			table.insert(updates, {"Bench", index, item})
		end
		containers.Bench = items
	end
	return updates
end

function InventoryClass:UpdateFire(...)
	local player = self.Player
	ModUtil:FireClient(InventoryRemotes, AllRemotes.Update, player, ...)
end

function InventoryClass:UpdateClient(...)
	local player = self.Player
	local char = player.Character
	local user = shared.Users[player]
	if not user then return end
	local benchModel = user.Bench
	local bench
	if benchModel then
		bench = shared.Benches[benchModel]
	end
	local equipped = user.Equipped
	local equipType = 0
	local equipItem
	local benchUpdates = {}
	local ignoreEquipUpd = false
	--print(...)
	local args = {...}
	local processedArgs = {}
	for i, t in pairs(args) do
		if t == "IgnoreEquipUpdate" then
			ignoreEquipUpd = true
		end
		if type(t) ~= "table" then
			table.insert(processedArgs, t)
			continue 
		end
		local container = t[1]
		if not container then
			table.insert(processedArgs, t)
			continue 
		end
		local index = t[2]
		local item = t[3]
		if index == 0 then
			if type(item) == "table" then
				warn("ITEM FOUND IN FIRST SLOT", item.ID)
			end
			continue 
		end
		table.insert(processedArgs, t)
		if container == "Bench" then
			if bench then
				bench:UpdateSlot(index, item, player.UserId)
				table.insert(benchUpdates, t)
			end
		elseif item and item ~= 0 then
			item.CookTimes = nil
		end
		if not (container == "Toolbar" and equipped.Index == index) then continue end
		local info = Items[(item and item ~= 0 and item.Amount > 0) and item.ID]
		if item == nil or item == 0 or item.Amount <= 0 or (info and info.MaxDurability and item.Durability <= 0) then
			equipType = 1
		elseif item ~= equipped.Item then
			equipType = 2
		end
		equipItem = item
		--print(equipItem)
	end
	--print("inv update", args, processedArgs)
	if bench and #benchUpdates > 0 then
		bench:UpdatePlayers(benchUpdates, player)
	end
	if equipType > 0 then
		table.insert(processedArgs, 1, "IgnoreVMUpdate")
	end
	if #processedArgs > 0 then
		self:UpdateFire(unpack(processedArgs))
	end
	if equipType == 0 then
		user:UpdateHolsters()
		user:UpdateArmors()
		return 
	end
	if equipType == 1 then
		--print("change in inv: unequip")
		user:Equip(0)
	elseif equipType == 2 then
		--print("change in inv: change equipped", equipped.Item, equipItem)
		equipped.OldItem = equipped.Item
		equipped.Item = equipItem
		user:UpdateEquippedTool()
	end
	if not ignoreEquipUpd then
		self:UpdateEquipped(equipped.Index)
	end
	user:UpdateHolsters()
	user:UpdateArmors()
end

function InventoryClass:UpdateEquipped(index)
	ModUtil:FireClient(EquipRemotes, AllRemotes.Equip, self.Player, index)
end

function InventoryClass:CheckArmor(armorIndex, armorItem)
	local armor = self:GetArmor()
	armorItem = (armorItem or armor[armorIndex])
	if not (armorItem and armorItem ~= 0 and armorItem.Amount > 0) then return end
	local armorInfo = Items[armorItem.ID]
	if not armorInfo then return end
	local armorTypes = ArmorModule:GetArmorTypes()
	local armorType = armorInfo.ArmorType
	local armorIgnores = {}
	for _, ignore in pairs(armorTypes[armorType] or {}) do
		table.insert(armorIgnores, ignore)
	end
	table.insert(armorIgnores, armorType)
	local updates = {}
	for index, item in pairs(armor) do
		if not (index ~= armorIndex and item and item ~= 0) then continue end
		local info = Items[item.ID]
		if not (info and table.find(armorIgnores, info.ArmorType)) then continue end
		armor[index] = 0
		self:AddItem(item)
		table.insert(updates, {"Armor", index, armor[index]})
	end
	if #updates <= 0 then return end
	self:UpdateClient(unpack(updates))
end

function InventoryClass:ClearInventory()
	local containers = self.Containers
	containers.Toolbar = {0, 0, 0, 0, 0, 0} -- 6
	containers.Inventory = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} -- 24
	containers.Armor = {0, 0, 0, 0, 0, 0, 0} -- 7
	containers.Bench = nil
end

function InventoryClass:GetInv()
	return self.Containers
end

function InventoryClass:GetToolbar()
	return self.Containers.Toolbar
end

function InventoryClass:GetArmor()
	return self.Containers.Armor
end

return InventoryClass