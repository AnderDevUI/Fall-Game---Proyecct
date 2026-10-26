-- [PATH] ServerStorage / Modules / DataModule @Type ModuleScript
--[[
	DataModule
	by ChickenBagelz
	January 28, 2023
	
	Holds all DataStores and functions for adding/removing from them
]]

--[[local DataStore = game:GetService("DataStoreService")
local PlayerData = DataStore:GetDataStore("PlayerData_13")
local keysPage = PlayerData:ListKeysAsync("plr_")
local lol = require(game.ServerStorage.Modules.UserStatsClass)
while true do
	local keys = keysPage:GetCurrentPage()
	for _, keyObj in pairs(keys) do
		local key = keyObj.KeyName
		local userId = tonumber(key:sub(5))
		if not userId then continue end
		local suc, userName = pcall(function()
			return game.Players:GetNameFromUserIdAsync(userId)
		end)
		if not (suc and userName) then print("failed to fetch username for", userId) continue end
		local suc, data = pcall(function()
			return PlayerData:GetAsync(key)
		end)
		if not suc then print("failed to fetch data for", userName) continue end
		local userStats = lol.new(nil, data.UserStats)
		local deaths = userStats:GetStats("Deaths")
		local userIds = {}
		local t = {"Salvaged AK47", "Salvaged AK74u"}
		for i, gunName in pairs(t) do
			local gunDeaths = deaths[gunName]
			if not gunDeaths then continue end
			for userId, death in pairs(gunDeaths) do
				userId = tonumber(userId)
				if not (userId and death and death > 0) then continue end
				local z = userIds[userId]
				if not z then
					z = {}
					userIds[userId] = z
				end
				z[i] = (z[i] or 0) + death 
			end
		end
		local highestId, highest
		for userId, death in pairs(userIds) do
			local total = (death[1] or 0) + (death[2] or 0)
			if highest and highest > total then continue end
			highestId = userId
			highest = total
		end
		local mostKilled = userIds[highestId]
		local extra = ""
		if mostKilled then
			local suc, killer = pcall(function()
				return game.Players:GetNameFromUserIdAsync(highestId)
			end)
			if suc and killer then
				local y = (mostKilled[1] or 0) > (mostKilled[2] or 0)
				extra = `\n`..
					`DIED MOST TO: {killer}({highestId}) - KILLED YOU {highest} TIMES\n`..
					`THEIR FAVORITE WEAPON TO KILL YOU WITH: {y and t[1] or t[2]} (DIED TO IT {y and mostKilled[1] or mostKilled[2]} TIMES)\n`
			end
		end
		print(`\n`..
			`------------------------------------------------\n`..
			"```STATS FOR "..userName.."("..userId.."):\n"..
			`TOTAL COMBAT WINS: {data.CombatWins or 0}\n`..
			`\n`..
			`AK47 KILLS: {userStats:GetKills("Salvaged AK47")}\n`..
			`AK47 DOWNS: {userStats:GetDowns("Salvaged AK47")}\n`..
			`AK47 ACCURACY: {userStats:CalculateTotalAccuracy("Salvaged AK47")}\n`..
			`AK47 HEADSHOT RATE: {userStats:CalculateLimbPercentageAccuracies("Salvaged AK47").Head}\n`..
			`DEATHS FROM AK47: {userStats:GetDeaths("Salvaged AK47")}\n`..
			`\n`..
			`AK74u KILLS: {userStats:GetKills("Salvaged AK74u")}\n`..
			`AK74u DOWNS: {userStats:GetDowns("Salvaged AK74u")}\n`..
			`AK74u ACCURACY: {userStats:CalculateTotalAccuracy("Salvaged AK74u")}\n`..
			`AK74u HEADSHOT RATE: {userStats:CalculateLimbPercentageAccuracies("Salvaged AK74u").Head}\n`..
			`DEATHS FROM AK74u: {userStats:GetDeaths("Salvaged AK74u")}\n`..
			extra.."```\n"..
			`------------------------------------------------`
		)
	end
	if keysPage.IsFinished then break end
	keysPage:AdvanceToNextPageAsync()
end
print("done")

local data = game:GetService("DataStoreService"):GetDataStore("PlayerData_14"):GetAsync("plr_65924100").UserStats
local userStats = require(game.ServerStorage.Modules.UserStatsClass).new(nil, data)
print(userStats)

local DataStore = game:GetService("DataStoreService")
local PlayerData = DataStore:GetDataStore("PlayerData_14")
local lol = require(game.ServerStorage.Modules.UserStatsClass)
local key = "plr_51281722"
		local userId = tonumber(key:sub(5))
		if not userId then return end
		local suc, userName = pcall(function()
			return game.Players:GetNameFromUserIdAsync(userId)
		end)
		if not (suc and userName) then print("failed to fetch username for", userId) return end
		local suc, data = pcall(function()
			return PlayerData:GetAsync(key)
		end)
		if not suc then print("failed to fetch data for", userName) return end
		local userStats = lol.new(nil, data.UserStats)
		local deaths = userStats:GetStats("Deaths")
		local userIds = {}
		local t = {"Salvaged AK47", "Salvaged AK74u"}
		for i, gunName in pairs(t) do
			local gunDeaths = deaths[gunName]
			if not gunDeaths then continue end
			for userId, death in pairs(gunDeaths) do
				userId = tonumber(userId)
				if not (userId and death and death > 0) then continue end
				local z = userIds[userId]
				if not z then
					z = {}
					userIds[userId] = z
				end
				z[i] = (z[i] or 0) + death 
			end
		end
		local highestId, highest
		for userId, death in pairs(userIds) do
			local total = (death[1] or 0) + (death[2] or 0)
			if highest and highest > total then continue end
			highestId = userId
			highest = total
		end
		local mostKilled = userIds[highestId]
		local extra = ""
		if mostKilled then
			local suc, killer = pcall(function()
				return game.Players:GetNameFromUserIdAsync(highestId)
			end)
			if suc and killer then
				local y = (mostKilled[1] or 0) > (mostKilled[2] or 0)
				extra = `\n`..
					`DIED MOST TO: {killer}({highestId}) - KILLED YOU {highest} TIMES\n`..
					`THEIR FAVORITE WEAPON TO KILL YOU WITH: {y and t[1] or t[2]} (DIED TO IT {y and mostKilled[1] or mostKilled[2]} TIMES)\n`
			end
		end
		print(`\n`..
			`------------------------------------------------\n`..
			"```STATS FOR "..userName.."("..userId.."):\n"..
			`TOTAL COMBAT WINS: {data.CombatWins or 0}\n`..
			`\n`..
			`AK47 KILLS: {userStats:GetKills("Salvaged AK47")}\n`..
			`AK47 DOWNS: {userStats:GetDowns("Salvaged AK47")}\n`..
			`AK47 ACCURACY: {userStats:CalculateTotalAccuracy("Salvaged AK47")}\n`..
			`AK47 HEADSHOT RATE: {userStats:CalculateLimbPercentageAccuracies("Salvaged AK47").Head}\n`..
			`DEATHS FROM AK47: {userStats:GetDeaths("Salvaged AK47")}\n`..
			`\n`..
			`AK74u KILLS: {userStats:GetKills("Salvaged AK74u")}\n`..
			`AK74u DOWNS: {userStats:GetDowns("Salvaged AK74u")}\n`..
			`AK74u ACCURACY: {userStats:CalculateTotalAccuracy("Salvaged AK74u")}\n`..
			`AK74u HEADSHOT RATE: {userStats:CalculateLimbPercentageAccuracies("Salvaged AK74u").Head}\n`..
			`DEATHS FROM AK74u: {userStats:GetDeaths("Salvaged AK74u")}\n`..
			extra.."```\n"..
			`------------------------------------------------`
		)
print("done")]]

--[[local DataStore = game:GetService("DataStoreService")
local PlayerData = DataStore:GetDataStore("Bans_27")
print(PlayerData:GetAsync("plr_"..game.Players:GetUserIdFromNameAsync("lolaslasd3")))]]

--[[local DataStore = game:GetService("DataStoreService")
local PlayerData = DataStore:GetDataStore("Bans_27")
local keysPage = PlayerData:ListKeysAsync("plr_")
while true do
	local keys = keysPage:GetCurrentPage()
	for _, keyObj in pairs(keys) do
		local key = keyObj.KeyName
		local suc, data = pcall(function()
			return PlayerData:GetAsync(key)
		end)
		if not suc then print("failed to fetch data", key) continue end
		if data and data.BanCode == "045" then
			pcall(function()
				PlayerData:RemoveAsync(key)
			end)
			print("UNBANNED")
		end
	end
	if keysPage.IsFinished then break end
	keysPage:AdvanceToNextPageAsync()
end
print("DONE")]]

-- Services
local DataStore = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local Run = game:GetService("RunService")

-- DataStores
local PlayerData = DataStore:GetDataStore("PlayerData_14")
local Bans = DataStore:GetDataStore("Bans_27")

-- Local Variables
local DataModule = {}

-- Functions
function DataModule:CreateNewData() -- Creates the default data table
	return {
		Skins = {};
		StartTime = os.time();
		TotalPlayTime = 0;
		LastFlags = {};
	}
end

function DataModule:SafeFunctionCall(totalTries, retrySeconds, func)
	local suc, ret
	for i = 1, totalTries do
		suc, ret = pcall(func)
		if suc or i == totalTries then break end
		task.wait(retrySeconds)
	end
	return suc, ret
end

function DataModule:SaveData(user, dataStore, data, playerName)
	local userid = (type(user) == "number" and user or user.Player.UserId)
	playerName = (playerName or user.Player.Name)
	local success, error = pcall(function()
		(dataStore == "PlayerData" and PlayerData or Bans):SetAsync("plr_"..userid, data)
	end)
	if success then
		print("Successfully saved "..playerName.."'s "..dataStore.." data", data)
		return true
	else
		warn("ERROR SAVING "..dataStore.." DATASTORE OF "..playerName..": "..error)
		return false
	end
end

function DataModule:LoadData(player, playername)
	local userid = (type(player) == "number" and player or player.UserId)
	local playerName
	if player == userid and not playername then
		local suc, err = pcall(function()
			playerName = Players:GetNameFromUserIdAsync(userid)
		end)
		if not suc then return end
	end
	playerName = (playerName or playername or player.Name)
	local playerData, bans
	local success, error = pcall(function()
		if not playername then
			bans = Bans:GetAsync("plr_"..userid)
			if bans then
				local duration = bans.Duration
				local timeOfBan = bans.TimeOfBan
				if duration and timeOfBan and (timeOfBan.InSeconds + duration) - os.time() <= 0 then
					print("Ban has expired")
					bans = nil
					Bans:RemoveAsync("plr_"..userid)
				end
			end
		end
		playerData = PlayerData:GetAsync("plr_"..userid)
	end)
	if success or Run:IsStudio() then
		print("Successfully loaded "..playerName.."'s data", playerData, bans)
		local newData = self:CreateNewData()
		if playerData then
			for index, value in pairs(newData) do
				if not playerData[index] then
					playerData[index] = value
				end
			end
		end
		return (playerData or newData), bans
		--return DataService:CreateNewData()
	else
		warn("ERROR LOADING DATASTORE OF "..playerName..": "..error)
		return false
	end
end

function DataModule:RemoveData(userId, dataStore)
	local suc, err = pcall(function()
		(dataStore == "PlayerData" and PlayerData or Bans):RemoveAsync("plr_"..userId)
	end)
	return suc
end

function DataModule:FetchDatastores()
	return PlayerData, Bans
end

return DataModule