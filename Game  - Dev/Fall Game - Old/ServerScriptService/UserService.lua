-- [PATH] ServerScriptService / UserService @Type Script
--[[
	UserService
	by ChickenBagelz
	July 16, 2022
	
	Sets up any players that join and leave the game, and initializes characters for setup
]]

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local ServerScripts = game:GetService("ServerScriptService")

-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")
local SpawnAreaService

-- Folders
local Remotes = Replicated:WaitForChild("Remotes")
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")
local Values = Replicated:WaitForChild("Values")

-- Modules
local UserClass = require(ServerModules:WaitForChild("UserClass"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local DataModule = require(ServerModules:WaitForChild("DataModule"))
local ServerModule = require(ServerModules:WaitForChild("ServerModule"))
local Guard = ServerModules:WaitForChild("FallenGuard")

-- Global Variables
shared.Users = {}
shared.UserLeaveTempContainer = {}
shared.RespawnQueue = {}

-- Local Variables
local doingRespawn = false
local settingUpPlayers = {}
local lastCountUpdate = tick()
local countUpdateQueued = false
local deathStep = 0

-- Functions
function UpdatePlayerCount()
	local serverId = shared.ServerId
	if not serverId then return end
	local timeLeft = tick() - lastCountUpdate
	if timeLeft > 5 then
		lastCountUpdate = tick()
		ServerModule:UpdatePlayerCount()
	elseif not countUpdateQueued then
		countUpdateQueued = true
		task.wait(5 - timeLeft)
		ServerModule:UpdatePlayerCount()
		lastCountUpdate = tick()
		countUpdateQueued = false
	end
end

function SetupPlayer(player)
	if settingUpPlayers[player] then return end
	settingUpPlayers[player] = true
	if ModUtil:CheckForShutdown(player) then player:Kick(shared.ShutdownKickMessage or "Failed to join: joined during shutdown in progress.") return end

	local playerData, bans = DataModule:LoadData(player)
	if playerData == false then
		player:Kick("Data failed to load, please rejoin the game. If this issue persists, report it to a developer.")
		return
	elseif bans ~= nil then
		ModUtil:KickFromBan(player, bans.TimeOfBan.InSeconds, bans.Duration)
		return
	end
	
	print("starting setup for", player.Name)
	
	while true do
		if not (settingUpPlayers[player] and player.Parent) then return end
		if shared.UserDatas then break end
		task.wait() 
	end
	
	print("setting up player", player.Name)

	local user = UserClass.new(player, playerData, shared.UserDatas[tostring(player.UserId)])
	shared.Users[player] = user
	
	task.wait(1)
	UpdatePlayerCount()
end

-- Events
Players.PlayerAdded:Connect(SetupPlayer)

Players.PlayerRemoving:Connect(function(player)
	settingUpPlayers[player] = nil
	local user = shared.Users[player]
	if user then
		task.delay(1, UpdatePlayerCount)
		user.Left = true
		local userData, shouldSave = user:GetUserData()
		if not shouldSave then
			shared.UserDatas[tostring(user.UserId)] = nil
		else
			shared.UserDatas[tostring(user.UserId)] = userData
		end
		local replicationPart = user.ReplicationPart
		if replicationPart then
			replicationPart:Destroy()
		end
		user:LeaveCombatArena(true)
		shared.UserLeaveTempContainer[player] = user
		local started = os.clock()
		user.Crafter:CancelAllCrafts()
		shared.Users[player] = nil
		local userCons = user.Connections
		if userCons then
			for _, con in pairs(userCons) do
				con:Disconnect()
			end
		end
		local fallenGuard = user.FallenGuard
		if fallenGuard then
			fallenGuard:ClearJumpThreads()
		end
		user:CreateSleeper()
		DataModule:SaveData(user, "PlayerData", user:GetData(true))
		task.wait(math.max(20 - (os.clock() - started), 0))
		shared.UserLeaveTempContainer[player] = nil
	end
end)

-- Setup any players that might've been missed before Players.PlayerAdded was connected to
task.spawn(function()
	for _, player in pairs(Players:GetPlayers()) do
		SetupPlayer(player)
	end
end)

print("STARTING USERSERVICE")

local currentStep = 0
local lastDetectionChecks = tick()
while true do
	local step = task.wait(1/10)
	currentStep += step
	deathStep += step
	local first = shared.RespawnQueue[1]
	if not (first and first.Player and first.Player.Parent) then
		table.remove(shared.RespawnQueue, 1)
	end
	if not SpawnAreaService then
		SpawnAreaService = ServerScripts:FindFirstChild("SpawnAreaService")
	end
	local finishedTick = (SpawnAreaService and SpawnAreaService:GetAttribute("LoadingFinished") or 0)
	local resetStep = false
	local ti = tick()
	local checkDetections = false
	if ti - lastDetectionChecks >= script:GetAttribute("MovementCheckTime") then
		checkDetections = true
		lastDetectionChecks = ti
	end
	local useBlockcast = Guard:GetAttribute("FloorChecksUseBlockcast")
	local flyhackDetectionThreshold = Guard:GetAttribute("FlyhackDetectionsBeforeSnapBack")
	local detectThresholdFlyhack = Guard:GetAttribute("DetectionThresholdFlyhack")
	for player, user in pairs(shared.Users) do
		if user == shared.RespawnQueue[1] and not (doingRespawn or Values.Loading.Value) then
			print("respawning")
			doingRespawn = true
			table.remove(shared.RespawnQueue, 1)
			task.defer(function()
				player:LoadCharacter()
				task.wait(0.5)
				doingRespawn = false
			end)
		end
		local fallenGuard = user.FallenGuard
		if not fallenGuard then continue end
		local character, humanoid, rootPart = fallenGuard:FlyChecks(user, useBlockcast, flyhackDetectionThreshold, detectThresholdFlyhack)
		if deathStep >= 1 then 
			user:CheckDeath() 
		end
		if checkDetections then
			local didBan = fallenGuard:DoLoopChecks(finishedTick <= 0, character, rootPart, humanoid, user)
			if didBan then continue end
		end
		
		if currentStep >= 0.2 then
			resetStep = true
			if humanoid and rootPart then
				fallenGuard:MovementCheck(currentStep, true, user, character, humanoid, rootPart)
			end
		end
	end
	if resetStep then
		currentStep = 0
	end
	if deathStep >= 1 then
		deathStep = 0
	end
end