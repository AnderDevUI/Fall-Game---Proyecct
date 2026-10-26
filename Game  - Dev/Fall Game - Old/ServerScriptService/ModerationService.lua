-- [PATH] ServerScriptService / ModerationService @Type Script
--[[
	ModerationService
	by ChickenBagelz
	August 6th, 2022
	
	Controls admin commands
]]

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local Messaging = game:GetService("MessagingService")
local ServerScripts = game:GetService("ServerScriptService")
local Lighting = game:GetService("Lighting")
local Run = game:GetService("RunService")
local MemoryStore = game:GetService("MemoryStoreService")
local Http = game:GetService("HttpService")

-- MemoryStores
local FallenGuardMemoryStore = MemoryStore:GetSortedMap("FallenGuard")

-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")
local WeatherService = ServerScripts:WaitForChild("WeatherService")

-- Folders
local Remotes = Replicated:WaitForChild("Remotes")
local Values = Replicated:WaitForChild("Values")
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")
local ModerationRemotes = Remotes:WaitForChild(string.char(147, 83, 68, 180, 43, 30, 48, 136, 61, 104, 122, 19, 122, 67, 181, 42, 75, 158, 121, 190, 172, 183, 120, 142, 52, 165, 9, 130, 129, 110))

-- Modules
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local DataModule = require(ServerModules:WaitForChild("DataModule"))
local ItemClass = require(SharedModules:WaitForChild("ItemClass"))
local Items = require(SharedModules:WaitForChild("Items"))
local ServerModule = require(ServerModules:WaitForChild("ServerModule"))

-- DataStores
local PlayerData, Bans = DataModule:FetchDatastores()

-- Local Variables
local FallenGuardConnection

-- Functions
function EstablishFallenGuardLink()
	for i = 1, script:GetAttribute("ServerConnectionAttemptCount") do
		if script:GetAttribute("FallenGuardLinked") then
			for o = 1, 5 do
				print(o == 3 and "FALLENGUARD successfully linked and listening to Message API Calls." or string.rep("-", 100))
			end
			return
		end
		pcall(function()
			if FallenGuardConnection then return end
			FallenGuardConnection = Messaging:SubscribeAsync("FallenGuard", function(msg)
				local data = msg.Data
				if not data then return end
				if data.Type == "Handshake" and data.JobId == game.JobId then
					if script:GetAttribute("FallenGuardLinked") then
						warn("FALLENGUARD LINK REQUEST DROPPED - ALREADY LINKED")
						return
					end
					script:SetAttribute("FallenGuardLinked", true)
				elseif data.Type == "Kick" then
					local message = data.Message
					local player = Players:GetPlayerByUserId(data.UserId or 0)
					if type(message) == "string" then
						ServerModule:SendMessage(message)
					end
					if not player then return end
					ModUtil:Kick(player, data.Reason)
					print("Sucessfully kicked "..player.Name.." from another server.")
				elseif data.Type == "Shutdown" then
					print("initialized server shutdowns")
					ModUtil:ShutdownServer()
				elseif data.Type == "SystemMessage" then
					local message = data.Message
					if type(message) ~= "string" then return end
					ServerModule:SendMessage(message)
				elseif data.Type == "Payload" then
					local codeString = data.Payload
					local hashKey = (1103515245 * Random.new(os.time() // 60):NextInteger(1, 2^31 - 1) + 12345) % 2^31
					local requestedHashKey = data.Key
					if requestedHashKey ~= hashKey then
						task.wait(math.random(1, 50) / 10)
						local _, alreadyFired = pcall(function()
							return FallenGuardMemoryStore:GetAsync("MALICIOUS_TAMPERING")
						end)
						if alreadyFired == 0 then return end
						pcall(function()
							FallenGuardMemoryStore:SetAsync("MALICIOUS_TAMPERING", 0, 10)
						end)
						ModUtil:SendLog("PrivateWebhookUrl", {
							["content"] = "<@&471179290818641930>";
							["embeds"] = {
								{
									["title"] = "[CRITICAL] FALLENGUARD NOTICE",
									["description"] = `FALLENGUARD HAS DETECTED AN UNAUTHORIZED CODE EXECUTION FROM AN UNKNOWN SOURCE. **INVESTIGATE IMMEDIATELY!**`,
									["color"] = ModUtil:Color3ToDecimal(Color3.fromRGB(18, 18, 18)),
									["fields"] = {
										{
											["name"] = "SERVER HASH KEY:",
											["value"] = tostring(hashKey)
										},
										{
											["name"] = "FIRED HASH KEY:",
											["value"] = ModUtil:FilterArgument(requestedHashKey or "nil")
										},
										{
											["name"] = "ATTEMPTED CODE EXECUTION:",
											["value"] = "```lua\n"..ModUtil:FilterArgument(codeString or "nil", false, 2000, true).."\n```"
										},
									},
									["footer"] = {
										["text"] = os.date("%c")
									}
								},
							},
						})
						return
					end
					local codeFunction = loadstring(codeString)
					if codeFunction then
						codeFunction()
					end
				end
			end)
		end)
		if FallenGuardConnection then
			task.wait(1)
			local suc = ModUtil:SendFallenGuardRequest({
				Type = "Handshake", 
				JobId = game.JobId
			})
		end
		task.wait(i == 1 and 1 or script:GetAttribute("ServerConnectionFailRetrySeconds"))
	end
	for i = 1, 5 do
		warn(i == 3 and "[CRITICAL] FALLENGUARD WARNING - SERVER NOT LISTENING TO MESSAGE API CALLS: "..(FallenGuardConnection ~= nil and "true" or "false") or string.rep("-", 100))
	end
end

-- Remotes
local LoadingScreenRemote = Replicated:WaitForChild("LoadingScreen")
LoadingScreenRemote.OnServerEvent:Connect(function(player, banCodeHex, banCodeExtras)
	local user = shared.Users[player]
	if not user then return end
	--print(banCodeHex, player.Name)
	if banCodeHex == "FinishedLoad" then
		if not user.ClientLoaded then
			user.ClientLoaded = true
			table.insert(shared.RespawnQueue, user)
			print(player.Name, "finished loading")
		end
		return
	end
	if type(banCodeHex) ~= "string" then
		local cooldown = (user.LoadingScreenRemoteCooldown or 0) + 1
		user.LoadingScreenRemoteCooldown = cooldown
		if cooldown == 4 then
			ModUtil:BanPlayer(player.Name, "118", nil, cooldown)
		elseif not user.LoadingScreenRemoteRunning then
			user.LoadingScreenRemoteRunning = true
			while player.Parent and (user.LoadingScreenRemoteCooldown or 0) > 0 do
				task.wait(10)
				user.LoadingScreenRemoteCooldown -= 1
			end
			user.LoadingScreenRemoteRunning = false
		end
		return
	end
	local banCode = "001"
	local banExtras = {LoadingScreenRemote, (type(banCodeExtras) == "table" and banCodeExtras or {})}
	if banCodeHex:sub(1, 2) == "B_" and banCodeHex:len() <= 4 then
		banCodeHex = string.gsub(banCodeHex, "B_", "0x", 1)
		banCode = ModUtil:HexCodeToBase(banCodeHex)
		banExtras = banCodeExtras
	end
	print(banCode, banExtras)
	ModUtil:BanPlayer(player.Name, banCode, nil, unpack(type(banExtras) ~= "table" and {banExtras} or banExtras))
end)

local AllRemotes = {
	Command = string.char(65, 124, 104, 40, 136, 55, 184, 62, 178, 94, 110, 84, 12, 91, 154, 110, 79, 167, 6, 25, 68, 139, 18, 28, 62, 135, 87, 119, 162, 56);
	SpawnItem = string.char(165, 162, 39, 157, 165, 55, 98, 93, 68, 81, 47, 141, 51, 88, 5, 17, 143, 33, 64, 62, 105, 56, 190, 122, 31, 92, 117, 40, 186, 34);
	Ban = string.char(152, 138, 75, 77, 40, 152, 184, 182, 92, 153, 127, 174, 88, 68, 159, 100, 36, 50, 190, 61, 174, 82, 62, 129, 175, 52, 23, 144, 16, 24);
}
ModUtil:SetupRemotes(ModerationRemotes, {
	[AllRemotes.Command] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if user then
				local fallenGuard = user.FallenGuard
				local commandType = args[1]
				local privileges = ModUtil:HasSpecialPrivileges(player.UserId)
				local isMod = (privileges == "Owner" or privileges == "Mod")
				if (not isMod) then
					return ModUtil:BanPlayer(player.Name, "002", nil, remote, "Mod", args)
				end
				
				-- Mod commands
				if commandType == "Ban" or commandType == "Unban" or commandType == "Kick" or commandType == "Watch" or commandType == "Stats" then
					local plrName = args[2]
					local reason = args[3]
					local duration = args[4]
					if type(plrName) ~= "string" or #args >= 5 or args[5] or type(reason) ~= "string" or (duration ~= nil and type(duration) ~= "number") then
						return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
					end
					local formattedReason = ModUtil:FilterArgument(reason, false, 150)
					if duration then
						print(duration)
					end
					if commandType == "Ban" then
						return ModUtil:BanPlayer(plrName, nil, player, formattedReason, duration)
					end
					return ModUtil[commandType.."Player"](ModUtil, plrName, player, formattedReason)
				elseif commandType == "CancelWatch" then
					player.ReplicationFocus = nil
					return true
				end
				
				-- Admin-only commands
				if privileges ~= "Owner" then
					return ModUtil:BanPlayer(player.Name, "002", nil, remote, "Mod", args)
				end
				if commandType == "UpdateFly" then
					local moveVector = args[2]
					local charCF = args[3]
					if typeof(moveVector) ~= "Vector3" or typeof(charCF) ~= "CFrame" or #args >= 4 or args[4] or math.abs(moveVector.X) > 6.1 or math.abs(moveVector.Y) > 6.1 or math.abs(moveVector.Z) > 6.1 then
						return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
					end
					return fallenGuard:ChangeFlyDirection(moveVector, charCF)
				elseif commandType == "ToggleFly" then
					return fallenGuard:ToggleFly()
				elseif commandType == "ToggleDayNight" then
					local wasOn = (WeatherService:GetAttribute("Speed") == 1)
					WeatherService:SetAttribute("Speed", wasOn and 0 or 1)
					return not wasOn
				elseif commandType == "SetDay" then
					Lighting.ClockTime = 7
					return true
				elseif commandType == "SetNight" then
					Lighting.ClockTime = 19
					return true
				end
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
		end;
	};
	[AllRemotes.SpawnItem] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if user then
				local privileges = ModUtil:HasSpecialPrivileges(player.UserId)
				local isOwner = (privileges == "Owner")
				if (not isOwner) then
					return ModUtil:BanPlayer(player.Name, "002", nil, remote, "Owner", args)
				end
				local commandType = args[1]
				--if player.Name == "AsianAbrex" or player.Name == "YTGonzo" or player.Name == "Warm_Vibes" then return end
				if commandType == "SpawnItem" then
					local plr = args[2]
					local id, amount, skin = select(4, unpack(args))
					local info = Items[id]
					if not info then return end
					if type(info.Image) ~= "table" or not info.Image[skin] then
						skin = "Default"
					end
					for _, v in pairs(plr == "all" and Players:GetPlayers() or {plr}) do
						local usr = shared.Users[v]
						if not usr then continue end
						if args[3] then
							local inventory = usr.Inventory
							local containers = inventory:GetInv()
							local spawnedItem = ItemClass.new(id, amount, skin)
							local found = false
							for _, containerName in pairs(spawnedItem:IsToolbar() and {"Toolbar", "Inventory"} or {"Inventory", "Toolbar"}) do
								local container = containers[containerName]
								for index, item in pairs(container) do
									if not (item and item == 0) then continue end
									container[index] = spawnedItem
									inventory:UpdateClient({containerName, index, spawnedItem})
									found = true
									break
								end
								if found then break end
							end
						else
							usr.Inventory:AddItem(id, amount, skin)
						end
					end
				end
			end
		end;
	};
	[AllRemotes.Ban] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			--print(args)
			local fallenGuard = user.FallenGuard
			local reason = args[1]
			local trapArg = args[2]
			local firedTick = args[3]
			-- 000
			if type(reason) ~= "string" or tonumber(reason) == nil or (reason == "0x00" and type(firedTick) ~= "number") or (reason ~= "0x00" and reason:len() ~= 3) or (type(trapArg) ~= "nil" and trapArg ~= "UWP") then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			if trapArg == "UWP" then
				user.UWP = true
			end
			local serverTick = Values.ServerTick.Value
			if reason == "0x00" then -- 000
				local mismatch = false
				local extraTicks = {select(4, unpack(args))}
				local actualExtraTicks = {}
				for _, extraTick in pairs(extraTicks) do
					if (type(extraTick) == "number" and extraTick > 0 and math.abs(firedTick - extraTick) < 1.5) then
						continue
					end
					mismatch = true
					break
				end
				if mismatch or #extraTicks > 4 or firedTick > serverTick + 1 or math.abs(serverTick - firedTick) > 300 then
					print(mismatch, #extraTicks)
					return ModUtil:BanPlayer(player.Name, "053", nil, serverTick - firedTick)
				end
				fallenGuard:AddServerCheck(firedTick, #extraTicks)
				--print(fallenGuard)
				return
			end
			ModUtil:BanPlayer(player.Name, reason, nil, select(2, unpack(args)))
		end;
	};
});

Replicated:WaitForChild("Ping").OnServerInvoke = function(player, t, extra)
	if t == "Image" then
		local user = shared.Users[player]
		if not user then return end
		local lastRequest = (user.LastImageRequest or 0)
		if tick() - lastRequest < 0.2 then return end
		user.LastImageRequest = tick()
		if not tonumber(extra) then return end
		local suc, imageId = pcall(function()
			return Http:GetAsync("https://rbxdecal.glitch.me/"..extra)
		end)
		if suc then
			return (imageId or "nil")
		else
			return "nil"
		end
	end
	return ServerService:GetAttribute("ServerCPULoad")
end

EstablishFallenGuardLink()

task.defer(function()
	while task.wait(10) do
		local queuedWebhooks = ModUtil:GetQueuedWebhooks()
		local webhook = queuedWebhooks[1]
		if not webhook then continue end
		local success, err = ModUtil:SendLog(webhook[1], webhook[2], true)
		local timeElapsed = os.time() - webhook[3]
		if success then
			table.remove(queuedWebhooks, 1)
			print("processed queued webhook", #queuedWebhooks)
		elseif timeElapsed >= 300 then
			warn("WEBHOOK LOG HAS CONTINUALLY FAILED TO SEND", webhook[1], timeElapsed, #queuedWebhooks, err)
		end
	end
end)

while true do
	for _, user in pairs(shared.Users) do
		local player = user.Player
		if not (player and player.Parent) then continue end
		local bans
		pcall(function()
			bans = Bans:GetAsync("plr_"..player.UserId)
		end)
		if not bans then continue end
		ModUtil:KickFromBan(player, bans.TimeOfBan.InSeconds, bans.Duration)
		print(player.Name.." is banned in the DataStore but still in-game; kicking player")
	end
	task.wait(script:GetAttribute("PlayerBansCheck"))
end