-- [PATH] ServerStorage / Modules / LootTableModule @Type ModuleScript
--[[
	LootTableModule
	by ChickenBagelz
	February 7, 2023
	
	Holds all of the game's different LootTables | no it dont lol
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
local LootTable = require(ServerModules:WaitForChild("LootTable"))
local Items = require(SharedModules:WaitForChild("Items"))

shared.LootTables = {}
for _, module in pairs(script:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
	shared.LootTables[module.Name] = require(module)
end

-- Local Variables
local HitLootTables = {}


local LootTableModule = {}

function LootTableModule:ApplyLootTableToPlayer(player, lootTable, addToStats, useMults, setSkins)
	local user = shared.Users[player]
	if not user then return end
	local userStats = user.UserStats
	local inventory = user.Inventory
	local skins = user.Skins or {}
	local chosenItems = lootTable:Roll(useMults or 1, useMults and ServerService:GetAttribute("LuckMult") or 1, true)
	for _, item in pairs(chosenItems) do
		if setSkins and item.Skin == "Default" then
			local info = Items[item.ID]
			local allSkins = info.Image
			if type(allSkins) == "table" then
				local ownedSkins = {}
				for skin, _ in pairs(allSkins) do
					if skin == "Default" or not table.find(skins, info.Name.."/"..skin) then continue end
					table.insert(ownedSkins, skin)
				end
				if #ownedSkins > 0 then
					item.Skin = ownedSkins[math.random(1, #ownedSkins)]
				end
			end
		end
		local oldAmount = item.Amount
		inventory:AddItem(item)
		if not addToStats then continue end
		userStats:Synchronize("AddResourceGathered", item.ID, oldAmount)
	end
end

function LootTableModule:GetLootTable(...)
	local last = shared.LootTables
	for _, index in pairs({...}) do
		local value = last[index]
		if not value then return end
		last = value
	end
	return last
end

function LootTableModule:FetchLootTables()
	return shared.LootTables
end

function LootTableModule:GetHitLootTable(object, lootTablePath, gatherMult, luckMult)
	local hitLootTable = HitLootTables[object]
	if not hitLootTable then
		hitLootTable = LootTable.new("HitTable", self:GetLootTable(unpack(lootTablePath)))
		HitLootTables[object] = hitLootTable
	end
	if not hitLootTable then return end
	hitLootTable:UpdateHitTable(gatherMult, luckMult)
	return hitLootTable
end

function LootTableModule:RemoveHitLootTable(object)
	local hitLootTable = HitLootTables[object]
	if hitLootTable then
		hitLootTable:Cleanup()
	end
	HitLootTables[object] = nil
end

return LootTableModule
