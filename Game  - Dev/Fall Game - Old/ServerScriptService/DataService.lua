-- [PATH] ServerScriptService / ServerService / DataService @Type Script
--[[
	DataService
	by ChickenBagelz
	August 6th, 2022
	
	Handles datastores, player data loading and saving
]]

-- Services
local Players = game:GetService("Players")
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local DataModule = require(ServerModules:WaitForChild("DataModule"))

-- Loops
while wait(script:GetAttribute("AutoSaveInterval")) do
	for player, user in pairs(shared.Users) do
		if not player:IsDescendantOf(Players) then -- To prevent any memory leaks
			shared.Users[player] = nil
			continue
		end
		DataModule:SaveData(user, "PlayerData", user:GetData(true))
	end
end