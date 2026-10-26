-- [PATH] ReplicatedStorage / Modules / ArmorModule @Type ModuleScript
--[[
	ArmorModule
	by ChickenBagelz
	March 30, 2023
	
	Holds all armor functions that can be accessed by both client and server
]]


-- Contains every possible ArmorType and which other ArmorTypes it isn't compatible with (armors with the same ArmorTypes are automatically incompatible with each other)
local ArmorTypes = { 
	All = {"Helmet", "Face", "Hat", "Chestplate", "Wetsuit", "Shirt", "Kilt", "Pants", "Boots", "Gloves"};
	Helmet = {"Face", "Hat", "All"};
	Hat = {"Helmet", "All"};
	Face = {"Helmet", "All"};
	Chestplate = {"All"};
	Wetsuit = {"Shirt", "Pants", "All"};
	Shirt = {"All", "Wetsuit"};
	Kilt = {"All"};
	Pants = {"All", "Wetsuit"};
	Boots = {"All"};
	Gloves = {"All"}
}

-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Folders
local Modules = Replicated:WaitForChild("Modules")
local Armors = Replicated:WaitForChild("Armors")
local Sleeves = Replicated:WaitForChild("Sleeves")

-- Modules
local WeldModule = require(Modules:WaitForChild("WeldModule"))
local Items = require(Modules:WaitForChild("Items"))

-- Constants
local Player = Players.LocalPlayer


local ArmorModule = {}

function ArmorModule:UpdateArmors(character, armors, updatePlayer)
	if not (character and character.Parent) then return end
	local foundArmors = {}
	for _, model in pairs(character:GetChildren()) do
		local name = model.Name
		if not (model:IsA("Model") and name:sub(1, 6) == "Armor_") then continue end
		local slash = string.find(name, "/")
		if not slash then continue end
		local id = tonumber(name:sub(7, slash - 1))
		if not id then continue end
		local skin = name:sub(slash + 1)
		local foundArmor = foundArmors[id]
		if not foundArmor then
			foundArmor = {
				Skin = skin;
				Models = {};
			}
			foundArmors[id] = foundArmor
		end
		table.insert(foundArmor.Models, model)
	end
	local didUpdate = false
	local newArmors = self:GetArmors(armors)
	for id, foundTable in pairs(foundArmors) do
		local skin = foundTable.Skin
		local found = false
		for _, armor in pairs(newArmors) do
			if not (armor.ID == id and armor.Skin == skin) then continue end
			armor.Found = true
			found = true
			break
		end
		if found then continue end
		didUpdate = true
		local models = foundTable.Models
		for _, model in pairs(models) do
			model:Destroy()
		end
	end
	local hideHair = false
	local allSleeves = {}
	local allSleeveTypes = {}
	local hasChestplate = false
	local attributes = {}
	for _, armor in pairs(newArmors) do
		local id = armor.ID
		local skin = armor.Skin
		local armorInfo = Items[id]
		if not armorInfo then continue end
		local armorType = armorInfo.ArmorType
		local armorName = armorInfo.Name
		while Player do
			local sleeveFolder = Sleeves:FindFirstChild(armorName)
			if not sleeveFolder then break end
			local sleeves = sleeveFolder:FindFirstChild(skin)
			if not sleeves then break end
			if armorType == "Chestplate" then
				for index = #allSleeves, 1, -1 do
					local sleeveType = allSleeveTypes[index]
					if sleeveType ~= "Shirt" then continue end
					table.remove(allSleeves, index)
					table.remove(allSleeveTypes, index)
				end
				hasChestplate = true
			elseif armorType == "Shirt" and hasChestplate then
				break
			end
			table.insert(allSleeves, armorName.."/"..skin)
			table.insert(allSleeveTypes, armorType)
			break
		end
		if armorInfo.HideHair then
			hideHair = true
		end
		local armorAttribute = armorInfo.Attribute
		if updatePlayer and armorAttribute and not table.find(attributes, armorAttribute) then
			table.insert(attributes, "Armor_"..armorAttribute)
		end
		if armor.Found then
			armor.Found = nil
			continue
		end
		didUpdate = true
		local armorFolder = Armors:FindFirstChild(armorName)
		if not armorFolder then continue end
		local armorModel = armorFolder:FindFirstChild(skin)
		if not armorModel then continue end
		armorModel = armorModel:Clone()
		local models = WeldModule:FullyWeldModels(armorModel, character, true)
		for _, model in pairs(models) do
			model.Name = "Armor_"..id.."/"..skin
		end
	end
	for _, hair in pairs(character:GetChildren()) do
		if not (hair.Name == "Hair" and hair:IsA("Model")) then continue end
		local hairPart = hair:FindFirstChild("HairPart")
		if not hairPart then continue end
		hairPart.Transparency = (hideHair and 1 or 0)
	end
	if Player then -- Set the LocalPlayer's vm sleeve attribute for when an item gets equipped
		Player:SetAttribute("ArmorSleeves", table.concat(allSleeves, "^"))
	end
	if updatePlayer then
		--print("updating armor")
		for attribute, value in pairs(updatePlayer:GetAttributes()) do
			if attribute:sub(1, 6) ~= "Armor_" then continue end
			if value then
				local index = table.find(attributes, attribute)
				if index then
					table.remove(attributes, index)
					continue 
				end
			end
			updatePlayer:SetAttribute(attribute, nil)
		end
		for _, attribute in pairs(attributes) do
			updatePlayer:SetAttribute(attribute, true)
		end
	end
	return didUpdate
end

function ArmorModule:GetArmors(armors, resistanceType : string?, attribute : string?)
	if not armors then return end
	local equippedArmors = {}
	local equippedIndexes = {}
	for index, armor in pairs(armors) do
		if not (armor and armor ~= 0 and armor.Amount > 0) then continue end
		local armorInfo = Items[armor.ID]
		if armorInfo == nil or (armorInfo.MaxDurability and (armor.Durability or 0) <= 0) then continue end
		local resistances = armorInfo.Resistances
		if resistanceType then
			if not resistances then continue end
			local resistance = resistances[resistanceType]
			if not resistance then continue end
			local found = false
			for _, value in pairs(type(resistance) == "table" and resistance or {resistance}) do
				if value <= 0 then continue end
				found = true
				break
			end
			if not found then continue end
		end
		local armorAttribute = armorInfo.Attribute
		if attribute and (armorAttribute == nil or not armorAttribute:find(attribute)) then continue end
		table.insert(equippedArmors, armor)
		table.insert(equippedIndexes, index)
	end
	return equippedArmors, equippedIndexes
end

function ArmorModule:GetArmorTypes()
	return ArmorTypes
end

return ArmorModule