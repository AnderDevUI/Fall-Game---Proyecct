-- [PATH] ServerStorage / Modules / SlotTypeModule @Type ModuleScript
--[[
	SlotTypeModule
	by ChickenBagelz
	February 13, 2023
	
	Holds functions to determine the interactability of slots
	
	DOCUMENTATION:
	All current available SlotTypes are:
		Default = Accepts any item into the slot
		Output = No items can be added to the slot
		FuelWood = Only Wood Logs are accepted into the slot
		Resources = Only accepts items whos types are set to Resource
		InputCampfire = Only items with an available LootTable inside Smelt.Campfire are accepted
		BuildingTools = Only accepts Hammers or Blueprints
]]


-- Services
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")

-- Modules
local LootTableModule = require(ServerModules:WaitForChild("LootTableModule"))
local Items = require(SharedModules:WaitForChild("Items"))
local RecipeModule = require(SharedModules:WaitForChild("RecipeModule"))


local SlotTypeModule = {
	Default = function()
		return true
	end;
	Output = function()
		return false
	end;
	FuelWood = function(item)
		return (item ~= 0 and item.ID == 1)
	end;
	BuildingTools = function(item)
		return (item ~= 0 and (item.ID == 30 or item.ID == 31))
	end,
	Shotgun = function(item)
		return (item ~= 0 and (item.ID == 138 or item.ID == 140))
	end,
	Resources = function(item)
		if item == 0 then return end
		local itemInfo = Items[item.ID]
		return (itemInfo and itemInfo.Type == "Resource")
	end,
	InputCampfire = function(item)
		if item == 0 then return end
		local itemInfo = Items[item.ID]
		local smeltInfo = itemInfo.SmeltInfo
		if not smeltInfo then return end
		local lootTable = smeltInfo.LootTable
		return (lootTable ~= nil and lootTable[1] == "Smelt" and lootTable[2] == "Campfire")
	end;
	InputFurnace = function(item)
		if item == 0 then return end
		local itemInfo = Items[item.ID]
		local smeltInfo = itemInfo.SmeltInfo
		if not smeltInfo then return end
		local lootTable = smeltInfo.LootTable
		return (lootTable ~= nil and lootTable[1] == "Smelt" and lootTable[2] == "Furnace")
	end;
	InputPetroleum = function(item)
		if item == 0 then return end
		local itemInfo = Items[item.ID]
		local smeltInfo = itemInfo.SmeltInfo
		if not smeltInfo then return end
		local lootTable = smeltInfo.LootTable
		return (lootTable ~= nil and lootTable[1] == "Smelt" and lootTable[2] == "PetroleumRefinery")
	end;
	InputShredder = function(item)
		if item == 0 then return end
		local recipes = RecipeModule:GetRecipesForItem(item.ID)
		return (recipes ~= nil and #recipes == 1)
	end,
	InputCaps = function(item)
		return (type(item) == "table" and item.ID == 6)
	end;
	InputPowerCell = function(item)
		return (type(item) == "table" and item.ID == 78 and (item.Durability or 0) > 0)-- and item.Amount == 1 and (type(benchItem) ~= "table" or benchItem.Amount > 1))
	end;
	InputRepair = function(item)
		if item == 0 then return end
		local id = item.ID
		local recipes = RecipeModule:GetRecipesForItem(id)
		if not recipes or #recipes ~= 1 then return end
		local itemInfo = Items[id]
		local itemType = (itemInfo and itemInfo.Type)
		return (itemType == "Gun" or itemType == "Tool" or itemType == "Armor" or itemType == "Attachment" or itemType == "Bench")
	end,
}

return SlotTypeModule
