-- [PATH] ServerScriptService / ServerService @Type Script
--[[
	ServerService
	by ChickenBagelz
	September 7th
	
	Handles all general server logic
]]

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local TextChat = game:GetService("TextChatService")
local ServerScripts = game:GetService("ServerScriptService")
local Storage = game:GetService("ServerStorage")
local Run = game:GetService("RunService")
local Stat = game:GetService("Stats")

if not Run:IsStudio() then
	local Points = game:GetService("PointsService")
	Points.Name = "CoreGui"
end
local Test = game:GetService("TestService")
Test.Name = "Workspace"

local StarterGui = game:GetService("StarterGui")
local UIs = Replicated:WaitForChild("UIs")
StarterGui:WaitForChild("Main")
StarterGui:WaitForChild("Loading")
for _, ui in pairs(StarterGui:GetChildren()) do
	if not ui.ResetOnSpawn then continue end
	ui.Parent = UIs
end

-- Setup server type preset
local ServerModules = Storage:WaitForChild("Modules")
local Values = Replicated:WaitForChild("Values")

local serverScripts = script:GetChildren()
for _, serverScript in pairs(serverScripts) do
	serverScript.Parent = ServerScripts
end
while not shared.Users do task.wait() end

-- Constants
local ChatWindowConfig = TextChat:WaitForChild("ChatWindowConfiguration")

-- Folders
local Remotes = Replicated:WaitForChild("Remotes")

-- Modules
local ServerModule = require(ServerModules:WaitForChild("ServerModule"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local DamageModule = require(ServerModules:WaitForChild("DamageModule"))
local UserStatsClass = require(ServerModules:WaitForChild("UserStatsClass"))
local KitModule = require(ServerModules:WaitForChild("KitModule"))

-- Local Variables
local iTick = 60
local iCPUStart = os.clock()
local iCPUTime, iPhysicsTime
local lastServerSave = 0
local lastServerSaveCheck = 0
local savedNearMemoryLimit = false

-- Functions
function SaveServer(gracePeriod: number)
	print("AUTOSAVING SERVER (TIME SINCE LAST SAVE: "..lastServerSave..") (GRACE PERIOD ELAPSED: "..tostring(gracePeriod)..")")
	lastServerSave = 0
	task.spawn(ServerModule.Save, ServerModule, nil, false)
end

--[[if not Run:IsStudio() then
	local serverExists = game:GetService("DataStoreService"):GetDataStore("z"):GetAsync("z")
	if serverExists then
		ModUtil:ShutdownServer(nil, "ANOTHER TESTING SERVER DETECTED - JOIN THAT ONE INSTEAD")
		return
	end
	game:GetService("DataStoreService"):GetDataStore("z"):SetAsync("z", true)
end]]

-- Setup
game:BindToClose(function()
	--[[if not Run:IsStudio() then
		game:GetService("DataStoreService"):GetDataStore("z"):SetAsync("z", false)
	end]]
	if script:GetAttribute("BasesLoaded") then
		ServerModule:Save(nil, true)
	end
	ServerModule:UpdatePlayerCount(0)
	while ModUtil:IsShuttingDown() == true do
		task.wait()
	end
end)
shared.ServerStats = UserStatsClass.new(nil)
KitModule:Initialize()

if not script:GetAttribute("SavingEnabled") then
	warn("[WARNING] SAVING IS DISABLED - ENABLE IT IF NECESSARY")
end

-- Load the server
--local ServerModule = require(game.ServerStorage:WaitForChild("Modules"):WaitForChild("ServerModule"))
local dataStoreStartedTime = os.clock()
local serializedServerString, keysLoaded, serverInformation = ServerModule:LoadServerSave()
local firstThread
if serializedServerString == false and (Run:IsStudio() or game.PlaceId == 15334341098 or game.PlaceId == 16632672949) then
	serializedServerString = ""
end
--print(serializedServerString, Run:IsStudio())
if serializedServerString == false then
	return ModUtil:ShutdownServer(keysLoaded, serverInformation)
else
	serverInformation = (serverInformation or {})
	local serverExtraInfo = serverInformation[6] or {}
	local serverName = serverInformation[1]
	if serverExtraInfo.ServerType then
		Values.ServerType.Value = serverExtraInfo.ServerType
	end
	if serverName then
		Values.ServerName.Value = serverName
	end
	
	--[[while #Players:GetPlayers() < 1 do task.wait() end
	if Players:GetPlayers()[1].Name == "ChickenBagelz" then
		Values.ServerType.Value = "Combat"
	end]]
	--Values.ServerType.Value = "Combat"
	
	local ServerTypePresets = require(ServerModules:WaitForChild("ServerTypePresets"))
	local setupFunction = ServerTypePresets[Values.ServerType.Value]
	if setupFunction then
		local suc, err = pcall(setupFunction, serverInformation)
		if not suc then
			warn("[CRITICAL] ERROR DOING SERVER TYPE SETUP FUNCTION -", err)
		end
	end
	for _, serverScript in pairs(serverScripts) do
		serverScript.Enabled = true
	end
	firstThread = task.defer(function()
		local didLoad = false
		while true do
			if not didLoad then
				local loaded = true
				for _, remotes in pairs(Remotes:GetChildren()) do
					if remotes:GetAttribute("Loaded") then continue end
					--print(string.byte(remotes.Name:sub(1, 1)), string.byte(remotes.Name:sub(2, 2)), string.byte(remotes.Name:sub(3, 3)))
					loaded = false
					break
				end
				if loaded then
					script:SetAttribute("AllServicesLoaded", true)
					for _, remotes in pairs(Remotes:GetChildren()) do
						remotes:SetAttribute("Loaded", nil)
					end
					local newCount = #Remotes:GetDescendants()
					Remotes:SetAttribute("Count", newCount)
					print("ALL SERVICES FULLY INITIALIZED - SET COUNT TO ", newCount)
					didLoad = true
				end
			else
				ChatWindowConfig:SetAttribute("_", tick())
			end
			task.wait()
		end
	end)
	if serializedServerString == "" then
		print("NO PREVIOUS SERVER SAVE DATA FOUND - LOADING FRESHLY WIPED SERVER")
		script:SetAttribute("BasesLoaded", true)
		shared.SpawnAreaDatas = {}
		shared.UserDatas = {}
		shared.Teams = {}
		shared.ServerStarted = os.time()
	else
		task.spawn(function()
			print("waiting for create bench")
			while not shared.CreateBench do task.wait() end
			print("found create bench")
			local serverTable, err = ServerModule:Load(serializedServerString, keysLoaded, dataStoreStartedTime, true)
			if serverTable == false then
				return ModUtil:ShutdownServer(err)
			end
			script:SetAttribute("BasesLoaded", true)
		end)
	end
end

-- Loops
while true do
	local passed = task.wait()
	local servicesLoaded = script:GetAttribute("AllServicesLoaded")
	local t = tick()
	if servicesLoaded then
		if firstThread then
			task.cancel(firstThread)
			firstThread = nil
		end
		ChatWindowConfig:SetAttribute("_", t)
	end

	Values.ServerTick.Value = t
	Values.ServerOS.Value = os.time()

	if iTick > 0 then
		iTick -= 1
	else
		iCPUTime = math.round(((1 - ((60 / (os.clock() - iCPUStart))) / 60)) * 50)
		iPhysicsTime = math.round(((1 - (workspace:GetRealPhysicsFPS()) / 60)) * 50)
		iCPUTime = math.clamp(iCPUTime + iPhysicsTime, 0, 100)
		script:SetAttribute("ServerCPULoad", iCPUTime)
		iTick = 60
		iCPUStart = os.clock()

		local serverLifetime = os.time() - (shared.ServerStarted or os.time())
		local lootStart = script:GetAttribute("HoursFullLootStart")
		local luckMult = lootStart + (1 - lootStart) * (serverLifetime / 3600) / script:GetAttribute("HoursBeforeFullLoot")
		--script:SetAttribute("LuckMult", luckMult)
		script:SetAttribute("SetLuck", true)
	end

	if servicesLoaded then
		lastServerSaveCheck += passed
		lastServerSave += passed
		if lastServerSaveCheck < 1 then continue end
		lastServerSaveCheck = 0
		if not script:GetAttribute("BasesLoaded") then continue end
		local serverMemoryMb = Stat:GetTotalMemoryUsageMb()
		if serverMemoryMb >= script:GetAttribute("ServerMemoryForWarningMB") and not savedNearMemoryLimit then
			savedNearMemoryLimit = true
			ServerModule:SendMessage("HIGH SERVER MEMORY DETECTED - SPEEDING UP AUTOSAVING")
			SaveServer()
			continue
		end
		local savingSpeed = (savedNearMemoryLimit and script:GetAttribute("ServerMemoryWarningSavingSpeed") or 1)
		local autoSaveMin = script:GetAttribute("ServerAutoSaveIntervalMinimum") / savingSpeed
		-- Check if we meet the minimum auto save interval
		if lastServerSave < autoSaveMin then continue end
		-- Check if enough time has passed since a player has been damaged
		local autoSaveMax = script:GetAttribute("ServerAutoSaveIntervalMaximum") / savingSpeed
		local lastPlayerDamage = DamageModule:GetLastPlayerDamage()
		local gracePeriod = (1 - math.clamp((lastServerSave - autoSaveMin) / (autoSaveMax - autoSaveMin), 0, 1)) * (script:GetAttribute("ServerAutoSaveGraceAllowed") / savingSpeed)
		if os.clock() - lastPlayerDamage < gracePeriod then continue end
		-- Check if every player is grounded
		local eligible = true
		for _, user in pairs(shared.Users) do
			local moveStates = user:GetMoveStates()
			if not moveStates.Grounded then
				eligible = false
				break
			end
		end
		if lastServerSave >= (script:GetAttribute("ServerAutoSaveForce") / savingSpeed) or eligible then
			-- If all these checks pass, autosave
			SaveServer(gracePeriod)
		end
		continue 
	end
end