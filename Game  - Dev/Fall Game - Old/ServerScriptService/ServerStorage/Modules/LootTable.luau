-- [PATH] ServerStorage / Modules / LootTable @Type ModuleScript
--[[
	LootTable
	by ChickenBagelz
	February 7, 2023
	
	Creates a new LootTable class, used for picking random items from a table (like items) fast and efficiently
	
	
	EXAMPLE LOOT TABLES:
	-- This loot table below will always give:
	-- 2 Scrap
	-- Either 2 Mushrooms, a Stone Spear with 80% durability and repaired once, or an Assault Rifle (10-20% durability, Holo Sight and Lasersight, with 20% chance of 4-6 HV Rifle Ammo or 80% chance of 4-6 regular Rifle Ammo)
	-- 10% chance of giving a random muzzle attachment with 100% durability
	LootTable.new(
		{
			Rolls = 1;
			Loot = {{ -- Total weight of 1. 100% pick rate.
				Weight = 1;
				Type = "Item";
				ID = 1; -- Scrap
				Amount = 2;
			}};
		},
		{
			Rolls = 1;
			Loot = { -- Total weight of 3. Each item has an equal probability of 1/3 chance of being picked.
				{
					Weight = 1;
					Type = "Item";
					ID = 10; -- Mushroom
					Amount = {2, 3};
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 20; -- Stone Spear
					Amount = 1;
					Durability = 0.8; -- 80%
					Repair = 0.2; -- 20%
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 5; -- Assault Rifle
					Amount = 1;
					Durability = {0.1, 0.2}; -- 10-20%
					Ammo = LootTable.new({ -- 20% chance of HV Heavy Ammo
						Rolls = 1;
						Loot = {
							{
								Weight = 4;
								Type = "Item";
								ID = 4; -- Heavy Ammo
								Amount = {4, 6};
							};
							{
								Weight = 1;
								Type = "Item";
								ID = 11; -- HV Heavy Ammo
								Amount = {4, 6};
							};
						};
					});
					Attachments = LootTable.new(
						{
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 7; -- Holo Sight
								Amount = 1;
							}};
						},
						{
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 15; -- Salvaged Lasersight
								Amount = 1;
							}};
						}
					)
				};
				{ -- 33%
					Weight = 1;
					Type = "Item";
					ID = 10; -- Mushroom
					Amount = {2, 3};
				};
			}
		},
		{
			Rolls = 1.1; -- 10% chance to roll twice
			Loot = { -- Total weight of 30
				{ -- 90%
					Weight = 27;
					Type = "Nothing";
					LuckAffected = true;
				};
				{ -- 3.33%
					Weight = 1;
					Type = "Item";
					ID = 8; -- Silencer
					Amount = 1;
					Durability = 1; -- 100%
				};
				{ -- 3.33%
					Weight = 1;
					Type = "Item";
					ID = 13; -- Muzzle Boost
					Amount = 1;
					Durability = 1; -- 100%
				};
				{ -- 3.33%
					Weight = 1;
					Type = "Item";
					ID = 14; -- Muzzle Brake
					Amount = 1;
					Durability = 1; -- 100%
				};
			};
		}
	)
	
	LootTable.new(
		{
			Rolls = 1;
			Worth = 0.5;
			Loot = {{ -- Total weight of 1
				Weight = 1;
				Type = "Item";
				ID = 24; -- Cloth
				Amount = 12;
			}};
		},
		{
			Rolls = 1;
			Worth = 0.5;
			Loot = {{ -- Total weight of 1
				Weight = 1;
				Type = "Item";
				ID = 25; -- Cactus Flesh
				Amount = 2;
			}};
		},
	)
]]


-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local ServerScripts = game:GetService("ServerScriptService")

-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")

-- Folders
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local Items = require(SharedModules:WaitForChild("Items"))
local ItemClass = require(SharedModules:WaitForChild("ItemClass"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local TableUtil = require(SharedModules:WaitForChild("TableUtil"))


local LootTable = {}
LootTable.__index = LootTable

function LootTable.new(...)
	local args = {...}
	local isHit = (args[1] == "HitTable")
	local typ = (isHit and "HitTable" or "LootTable")
	
	local self = setmetatable({}, LootTable)
	
	self.Type = typ
	if isHit then
		self:CreateHitTable(args[2])
	else
		self.Tables = args
	end
		
	return self
end

function LootTable:DoHit(r, player, addToStats, doMults)
	if self.Type ~= "HitTable" then return end
	local hitTable = self.HitTable
	local hit = r * 100
	while hit > 0 do
		local found = {}
		for index, t in pairs(hitTable) do
			if t.Hit >= t.MaxHit then continue end
			table.insert(found, index)
		end
		if #found <= 0 then break end
		local chosenIndex = found[math.random(1, #found)]
		local chosen = hitTable[chosenIndex]
		local lastHit = chosen.Hit
		chosen.Hit = math.min(chosen.Hit + hit, chosen.MaxHit)
		local change = chosen.Hit - lastHit
		hit -= change
		if hit <= 0.00001 then
			hit = 0
		end
		--print(hit, change, lastHit, chosen.Hit)
		task.wait()
	end
	if not player then return end
	self:HitGiveItems(player, addToStats, doMults)
end

function LootTable:GetHealth()
	if self.Type ~= "HitTable" then return end
	local hitTable = self.HitTable
	local maxHealth = 1
	for index, t in pairs(hitTable) do
		local item = t.Item
		local amount = math.max((item and item.Amount or 0), 1)
		local change = math.floor(amount * (t.Hit / t.MaxHit)) / amount * t.Table.Worth
		maxHealth = math.max(maxHealth - change, 0)
	end
	if maxHealth < self.MaxHealth then
		self.MaxHealth = maxHealth
	end
	return self.MaxHealth
end

function LootTable:UpdateHitTable(gatherMult, luckMult)
	if self.Type ~= "HitTable" then return end
	local hitTable = self.HitTable
	local lootTable = self.LootTable
	if self.GatherMult == gatherMult and self.LuckMult == luckMult then return end
	self.GatherMult = gatherMult
	self.LuckMult = luckMult
	for _, t in pairs(hitTable) do
		local items = lootTable:RollIndividual(t.Table, gatherMult, luckMult, true)
		local extraAmount = 0
		for index, item in pairs(items) do
			if index < #items then
				extraAmount += item.Amount
				continue
			end
			item.Amount += extraAmount
			t.Item = item
		end
	end
end

function LootTable:CreateHitTable(lootTable)
	if self.Type ~= "HitTable" then return end
	self.LootTable = lootTable
	self.MaxHealth = 1
	local hitTable = {}
	local tables = lootTable.Tables
	for index, t in pairs(tables) do
		local worth = (t.Worth or 1 / #tables)
		t.Worth = worth
		hitTable[index] = {
			Table = t;
			MaxHit = worth * 100;
			Hit = 0;
			LastGive = 0;
		}
	end
	self.HitTable = hitTable
end

function LootTable:HitGiveItems(player, addToStats, doMults)
	if self.Type ~= "HitTable" then return end
	local user = shared.Users[player]
	if not user then return end
	local userStats = user.UserStats
	local inventory = user.Inventory
	local hitTable = self.HitTable
	--local mult = (doMults and ServerService:GetAttribute("GatherMult") or 1)
	for index, t in pairs(hitTable) do
		local item = t.Item
		if not item then continue end
		local amount = item.Amount
		local lastAmount = math.floor(amount * (t.LastGive / t.MaxHit))
		local nextAmount = math.floor(amount * (t.Hit / t.MaxHit))
		if nextAmount <= lastAmount then continue end
		local newItemTable = TableUtil:CloneTable(item)
		local newAmount = nextAmount - lastAmount
		newItemTable.Amount = newAmount
		t.LastGive = t.Hit
		local newItem = ItemClass.new(newItemTable)
		inventory:AddItem(newItem)
		if not addToStats then continue end
		userStats:Synchronize("AddResourceGathered", newItem.ID, newAmount)
	end
end

function LootTable:Roll(gatherMult, luckMult, combineItems, printOnly)
	if self.Type ~= "LootTable" then return end
	gatherMult = (gatherMult or 1)
	luckMult = (luckMult or 1)
	local chosenRolls = {}
	local chosenChances = {}
	for _, t in pairs(self.Tables) do
		local rolls, chances = self:RollIndividual(t, gatherMult, luckMult, nil, printOnly)
		for _, item in pairs(rolls) do
			table.insert(chosenRolls, item)
		end
		for _, chance in pairs(chances) do
			table.insert(chosenChances, chance)
		end
	end
	if printOnly then
		print(chosenChances)
	end
	if combineItems then
		local maxStackMult = ServerService:GetAttribute("MaxStackMult")
		local foundItems = {}
		for _, item in pairs(chosenRolls) do
			local id = item.ID
			local info = Items[id]
			local maxStack = (info.MaxStack == 1 and 1 or math.round(info.MaxStack * maxStackMult))
			local foundItem = foundItems[id]
			if not foundItem then
				foundItem = {item}
				foundItems[item.ID] = foundItem
				continue
			end
			for _, stackedItem in pairs(foundItem) do
				if stackedItem.Amount >= maxStack then continue end
				local newAmount = math.min(stackedItem.Amount + item.Amount, maxStack)
				local amountDiff = newAmount - stackedItem.Amount
				item.Amount -= amountDiff
				stackedItem.Amount = newAmount
				if item.Amount <= 0 then break end
			end
			if item.Amount <= 0 then continue end
			table.insert(foundItem, item)
		end
		for index = #chosenRolls, 1, -1 do
			local item = chosenRolls[index]
			if item and item ~= 0 and item.Amount > 0 then continue end
			table.remove(chosenRolls, index)
		end
	end
	return chosenRolls
end

function LootTable:RollIndividual(t, gatherMult, luckMult, oneStack, printOnly)
	local fullRolls = self:ChooseTotalRolls(t, gatherMult)
	local totalRolls = math.ceil(fullRolls)
	local totalWeight = self:GetTotalWeight(t, luckMult)
	local chosenRolls = {}
	local chances = {}
	for rollIndex = 1, totalRolls do
		local amountMult = ((rollIndex == totalRolls and totalRolls ~= fullRolls) and fullRolls - math.floor(fullRolls) or 1)
		local roll = math.random(1, totalWeight)
		local total = 0
		for _, loot in pairs(t.Loot) do
			local weight = self:CalculateWeight(loot, luckMult)
			total = total + weight
			table.insert(chances, (loot.Type ~= "Item" and loot.Type or Items[loot.ID].Name).." = "..(math.floor(weight / totalWeight * 100000) / 1000).."%")
			if printOnly or roll > total then continue end
			local typ = loot.Type
			if typ == "Item" then
				local items = self:GenerateItems(loot, luckMult, amountMult, oneStack)
				for _, item in pairs(items) do
					table.insert(chosenRolls, item)
				end
			end
			break
		end
	end
	return chosenRolls, chances
end

function LootTable:GenerateItems(loot, luckMult, amountMult, oneStack)
	if self.Type ~= "LootTable" then return end
	luckMult = (luckMult or 1)
	amountMult = (amountMult or 1)
	local itemId = loot.ID
	local itemInfo = Items[itemId]
	local rawAmount = TableUtil:TableRandom(loot.Amount, amountMult)
	local amount = NumberUtil:NumberToInteger(rawAmount)
	--print(itemInfo.Name, loot.Amount, amountMult, rawAmount, amount)
	local items = {}
	if amount <= 0 then return items end
	local itemDurability, itemRepair, itemAmmo, itemAttachments
	local itemSkin = loot.Skin
	local dur = loot.Durability
	if dur then
		itemDurability = tostring(TableUtil:TableRandom(dur))
	end
	local rep = loot.Repair
	if rep then
		itemRepair = TableUtil:TableRandom(rep)
	end
	local ammo = loot.Ammo
	if ammo then
		itemAmmo = ammo:Roll(1, luckMult)[1]
	end
	local attachments = loot.Attachments
	if attachments then
		itemAttachments = attachments:Roll(1, luckMult)
	end
	local maxStack = (itemInfo.MaxStack == 1 and 1 or math.round(itemInfo.MaxStack * ServerService:GetAttribute("MaxStackMult")))
	for i = 1, math.ceil(amount / maxStack) do
		local itemAmount = (oneStack and amount or math.min(amount - maxStack * (i - 1), maxStack))
		table.insert(items, ItemClass.new(itemId, itemAmount, itemSkin, itemDurability, itemRepair, itemAmmo, itemAttachments))
		if oneStack then break end
	end
	return items
end

function LootTable:GetTotalWeight(t, luck)
	if self.Type ~= "LootTable" then return end
	local total = 0
	for _, loot in pairs(t.Loot) do
		total = total + self:CalculateWeight(loot, luck)
	end
	return total
end

function LootTable:ChooseTotalRolls(t, mult)
	if self.Type ~= "LootTable" then return end
	local rolls = TableUtil:TableRandom(t.Rolls, mult)
	return rolls
end

function LootTable:CalculateWeight(loot, luck)
	if self.Type ~= "LootTable" then return end
	return math.floor(loot.Weight / (loot.LuckAffected and luck or 1))
end

function LootTable:Cleanup()
	setmetatable(self, nil)
	self = nil
end

return LootTable