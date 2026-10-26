-- [PATH] ServerStorage / Modules / ModUtil @Type ModuleScript
--[[
	ModUtil
	by ChickenBagelz
	August 13, 2022
	
	Useful internal functions involving game security and moderation
]]


-- Services
local Players = game:GetService("Players")
local Http = game:GetService("HttpService")
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local Collection = game:GetService("CollectionService")
local Run = game:GetService("RunService")
local Messaging = game:GetService("MessagingService")
local ServerScripts = game:GetService("ServerScriptService")
local Marketplace = game:GetService("MarketplaceService")
local UserService = game:GetService("UserService")

-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")

-- Folders
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")
local Values = Replicated:WaitForChild("Values")
local Benches = Replicated:WaitForChild("Benches")
local RemoteNames = Storage:WaitForChild("RemoteNames")
local Bases = workspace:WaitForChild("Bases")

-- Modules
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local DataModule = require(ServerModules:WaitForChild("DataModule"))
local UserStatsClass = require(ServerModules:WaitForChild("UserStatsClass"))
local SheetDatabase = (Run:IsRunning() and require(ServerModules:WaitForChild("SheetDatabase")))

-- Google sheet database
local banCodesDatabase = (SheetDatabase and SheetDatabase:GetDatabase("BanCodes"))

-- Local Variables
local RemoteFunctions = {}
local BannedPlayers = {}
local serverShutdown = false
local queuedWebhooks = {}


local ModUtil = {}

-- Functions
function ModUtil:SendLog(webhookName, logData, ignoreQueue)
	local webhookUrl = script:GetAttribute(webhookName)
	local hookData = Http:JSONEncode(logData)
	--[[local hookData = Http:JSONEncode({
		["WebhookURL"] = webhookUrl,
		["WebhookData"] = logData,
	})]]
	local success, err
	for i = 1, script:GetAttribute("WebhookFailRetries") do
		if i > 1 then
			task.wait(script:GetAttribute("WebhookFailRetrySeconds"))
		end
		success, err = pcall(function()
			Http:PostAsync(webhookUrl, hookData)
			--Http:PostAsync("https://bloxrank.net/api/webhook/", hookData, Enum.HttpContentType.ApplicationJson)
		end)
		if success then break end
	end
	if not success and not ignoreQueue then
		--warn("ERROR SENDING LOG FOR "..webhookName..":", err)
		table.insert(queuedWebhooks, 1, {webhookName, logData, os.time()})
	end
	return success, err
end

function ModUtil:FilterArgument(arg, formatNumbers, maxStringLength, discordFriendly)
	local suc, ret = pcall(function()
		local typ = typeof(arg)
		if typ == "number" then
			local n = math.clamp(arg, -1e10, 1e10)
			return (formatNumbers and NumberUtil:FormatNumber(n) or tostring(n))
		elseif typ == "string" then
			local str = ""
			for i = 1, math.min(arg:len(), (maxStringLength or 50)) do
				local s = arg:sub(i, i)
				local byte
				local suc, err = pcall(function()
					byte = string.byte(s)
				end)
				str = str..((suc == false or byte < 32 or byte > 126 or (s == [[\]] and arg:sub(i + 1, i + 1) ~= "n")) and "?" or s)
			end
			if discordFriendly then
				str = str:gsub("*", "?"):gsub("_", "?"):gsub("`", "?"):gsub("~~", "??"):gsub("||", "??"):gsub("> ", "??")
			end
			return str
		elseif typ == "Instance" then
			local fullName = arg:GetFullName()
			return self:FilterArgument(fullName, formatNumbers, fullName:len() + 1, discordFriendly)
		elseif typ == "boolean" then
			return (arg and "true" or "false")
		end
	end)
	return (suc and ret or "N/A")
end

function ModUtil:JSONFriendlyTable(t, stack, ignoreStack) -- Turns all incompatible data types into strings for JSON to encode
	local newT = {}
	if (stack or 0) < 2 or ignoreStack then
		for i, v in pairs(t) do
			local iT = typeof(i)
			local vT = typeof(v)
			i = (iT == "Instance" and i:GetFullName() or i)
			local value = (vT == "Vector3" and "Vector3.new("..v.X..", "..v.Y..", "..v.Z..")" or (vT == "Vector2" and "Vector2.new("..v.X..", "..v.Y..")" or (vT == "Color3" and "Color3.new("..math.ceil(v.R * 255)..", "..math.ceil(v.G * 255)..", "..math.ceil(v.B * 255)..")" or self:FilterArgument(v, false, 50, true))))
			if vT == "CFrame" then
				local newV = "CFrame.new("
				local comps = {v:GetComponents()}
				for index, comp in pairs(comps) do
					newV = newV..comp..(index == #comps and ")" or ", ")
				end
				value = newV
			elseif vT == "table" then
				task.wait()
				value = self:JSONFriendlyTable(v, (stack or 0) + 1, ignoreStack)
			end
			newT[i] = value
		end
	end
	return newT
end

function ModUtil:TruncateString(str, maxLength)
	maxLength = (maxLength or 1000)
	return str:sub(1, maxLength)..(str:len() > maxLength and " [[TEXT TRUNCATED]]" or "")
end

function ModUtil:HasSpecialPrivileges(userid)
	for attribute, value in pairs(script:GetAttributes()) do
		if attribute:sub(1, 1) == "_" and userid == value then
			return (attribute:find("Owner") and "Owner" or (attribute:find("Mod") and "Mod"))
		end
	end
end

function ModUtil:Color3ToDecimal(color3)
	local hex = "0x"..string.format("%02x%02x%02x", color3.R * 255, color3.G * 255, color3.B * 255)
	local dec = tonumber(hex)
	return dec
end

function ModUtil:UnbanPlayer(given, admin, reason)
	if not (admin and admin.Parent and reason) then return end
	local userId = (type(given) == "number" and given)
	local userName = (type(given) ~= "number" and given)
	if not userId then
		local success, error = pcall(function()
			userId = Players:GetUserIdFromNameAsync(given)
		end)
		if not (success and userId) then
			warn("FAILED TO UNBAN PLAYER", given, error)
			return false
		end
	else
		local success, error = pcall(function()
			userName = Players:GetNameFromUserIdAsync(given)
		end)
		if not (success and userName) then
			warn("FAILED TO UNBAN PLAYER", given, error)
			return false
		end
	end
	if not (userId and userName) then return end
	local privileges = self:HasSpecialPrivileges(userId)
	local adminPrivileges = self:HasSpecialPrivileges(admin.UserId)
	local playerData, bans = DataModule:LoadData(userId)
	if not (playerData and bans) then 
		return false, "Can't unban: player isn't banned."
	end
	local success = DataModule:RemoveData(userId, "Bans")
	if success then
		local modAdminBanned = (adminPrivileges == "Owner" and privileges == "Mod")
		bans.PlayTime = 0
		warn("@"..userName..":"..userId.." WAS UNBANNED BY "..admin.DisplayName.."(@"..admin.Name.."):"..admin.UserId.." FOR ["..reason.."].")
		ModUtil:CreateFallenGuardLog({
			WebhookName = (modAdminBanned and "PrivateWebhookUrl" or "WebhookUrl");
			UserId = userId;
			BanInfo = bans; 			
			Title = "ADMIN UNBAN";
			Color = ModUtil:Color3ToDecimal(script:GetAttribute("AdminUnbanLogColor"));
			Fields = {
				{
					["name"] = "UNBANNED BY:",
					["value"] = "**"..admin.DisplayName.."([@"..admin.Name.."](https://www.roblox.com/users/"..admin.UserId.."/profile)):"..admin.UserId.."**"
				},
				{
					["name"] = "REASON:",
					["value"] = reason
				}
			};
		})
	end
	return success
end

function ModUtil:KickPlayer(given, admin, reason)
	if not (admin and admin.Parent and reason) then return end
	local userId = (type(given) == "number" and given)
	local userName = (type(given) ~= "number" and given)
	if not userId then
		local success, error = pcall(function()
			userId = Players:GetUserIdFromNameAsync(given)
		end)
		if not (success and userId) then
			warn("FAILED TO KICK PLAYER", given, error)
			return false
		end
	else
		local success, error = pcall(function()
			userName = Players:GetNameFromUserIdAsync(given)
		end)
		if not (success and userName) then
			warn("FAILED TO KICK PLAYER", given, error)
			return false
		end
	end
	if not (userId and userName) then return end
	local privileges = self:HasSpecialPrivileges(userId)
	local adminPrivileges = self:HasSpecialPrivileges(admin.UserId)
	local immune = (privileges == "Owner" or (privileges == "Mod" and adminPrivileges ~= "Owner"))
	if immune then return end
	local player = Players:FindFirstChild(userName)
	if player then
		local user
		pcall(function()
			user = shared.Users[player]
		end)
		local playerData = (user and user:GetData(true, true))
		local isUWP = (user ~= nil and user.UWP)
		local displayName = player.DisplayName
		local accountAge = player.AccountAge
		self:Kick(player, script:GetAttribute("KickMessage"))
		warn("@"..userName..":"..userId.." WAS KICKED BY "..admin.DisplayName.."(@"..admin.Name.."):"..admin.UserId.." FOR ["..reason.."].")
		ModUtil:CreateFallenGuardLog({
			WebhookName = "WebhookUrl";
			UserId = userId;
			BanInfo = self:GeneratePlayerInfo(userName, displayName, accountAge, playerData, true, reason);
			InServer = `{tostring(shared.ServerId)} ({tostring(Values.ServerName.Value)})`;
			IsUWP = isUWP;
			Title = "ADMIN KICK";
			Color = ModUtil:Color3ToDecimal(script:GetAttribute("AdminKickLogColor"));
			Footer = os.date("%c");
			Fields = {
				{
					["name"] = "KICKED BY:",
					["value"] = "**"..admin.DisplayName.."([@"..admin.Name.."](https://www.roblox.com/users/"..admin.UserId.."/profile)):"..admin.UserId.."**"
				},
				{
					["name"] = "REASON:",
					["value"] = reason
				}
			};
		})
	end
	return (player ~= nil)
end

function ModUtil:WatchPlayer(userName, admin, reason)
	if not (admin and admin.Parent) then return end
	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(userName)
	end)
	if not (success and userId) then
		warn("FAILED TO WATCH PLAYER", userName, error)
		return false
	end
	local privileges = self:HasSpecialPrivileges(userId)
	local adminPrivileges = self:HasSpecialPrivileges(admin.UserId)
	local immune = (privileges == "Owner" or (privileges == "Mod" and adminPrivileges ~= "Owner"))
	if immune and adminPrivileges ~= "Owner" then 
		return false, "Player is immune to spectating."
	end
	local player = Players:FindFirstChild(userName)
	if player then
		local character = player.Character
		if character then
			local primPart = character.PrimaryPart
			local humanoid = character:FindFirstChild("Humanoid")
			if primPart and humanoid then
				task.defer(function()
					local user
					pcall(function()
						user = shared.Users[player]
					end)
					local playerData = (user and user:GetData(true, true))
					local isUWP = (user ~= nil and user.UWP)
					local displayName = player.DisplayName
					local accountAge = player.AccountAge
					ModUtil:CreateFallenGuardLog({
						WebhookName = (adminPrivileges == "Owner" and "PrivateWebhookUrl" or "WebhookUrl");
						UserId = userId;
						BanInfo = self:GeneratePlayerInfo(userName, displayName, accountAge, playerData, true, reason);
						InServer = `{tostring(shared.ServerId)} ({tostring(Values.ServerName.Value)})`;
						IsUWP = isUWP;
						Title = "ADMIN SPECTATE";
						Color = ModUtil:Color3ToDecimal(script:GetAttribute("AdminWatchLogColor"));
						Footer = os.date("%c");
						Fields = {
							{
								["name"] = "MODERATOR:",
								["value"] = "**"..admin.DisplayName.."([@"..admin.Name.."](https://www.roblox.com/users/"..admin.UserId.."/profile)):"..admin.UserId.."**"
							},
							{
								["name"] = "REASON:",
								["value"] = reason
							}
						};
					})
				end)
				admin.ReplicationFocus = primPart
				return true, humanoid
			else
				return false, "Selected player isn't currently spawned in."
			end
		else
			return false, "Selected player has no valid character."
		end
	else
		return false, "Seleted player not in server."
	end
end

function ModUtil:StatsPlayer(userName, admin)
	if not (admin and admin.Parent) then return end
	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(userName)
	end)
	if not (success and userId) then
		warn("FAILED TO FETCH ADMIN STATS FOR PLAYER", userName, error)
		return false
	end
	local player = Players:FindFirstChild(userName)
	local playerData
	if player then
		local userStats
		local user
		pcall(function()
			user = shared.Users[player]
		end)
		playerData = (user and user:GetData(true, true))
		--print(playerData)
	else
		playerData = DataModule:LoadData(userId)
		--print(playerData)
	end
	if playerData and playerData.UserStats then
		local userStats = UserStatsClass.new(nil, playerData.UserStats)
		return true, {
			GeneralStats = `General Stats:\nKills: {userStats:GetKills()}\nDeaths: {userStats:GetDeaths() - userStats:GetDeaths("Reset")}`
		}
	end
	return (playerData ~= nil)
end

function ModUtil:BanPlayer(plrname, bancode, admin, ...)
	local args = {...}
	local player = Players:FindFirstChild(plrname)
	local userid
	if not player then
		local success, error = pcall(function()
			userid = Players:GetUserIdFromNameAsync(plrname)
		end)
		if not success then
			warn("FAILED TO BAN PLAYER", plrname, error)
			return false
		end
	else
		userid = player.UserId
	end
	if userid then
		local wasBanned = BannedPlayers[userid]
		local privileges = self:HasSpecialPrivileges(userid)
		local adminPrivileges = (admin and self:HasSpecialPrivileges(admin.UserId))
		local banDuration = (admin ~= nil and args[2])
		local immune = (privileges == "Owner" or (admin and privileges == "Mod" and adminPrivileges ~= "Owner"))
		local isFlag = ((bancode == "029" and not script:GetAttribute("BanFor029")) or (bancode == "025" and not script:GetAttribute("BanFor025")) or bancode == "036" or bancode == "050" or bancode == "082" or bancode == "111" or bancode == "034" or bancode == "031" or bancode == "008") -- bancode == "047"
		local isKick = (bancode == "055" or bancode == "066" or bancode == "108")
		local isDelayedBan = (bancode == "052" or bancode == "056")
		local isPlayerRequired = (bancode == "055" or bancode == "117")
		local user
		if player then
			user = shared.Users[player]
		end
		if isPlayerRequired and ((not user) or user.Left == true) then
			warn(player.Name, "BAN DROPPED - NOT IN GAME", bancode)
			return false, "Ban attempt dropped. [1]"
		end
		if isDelayedBan and user then
			if user.Banned or user.DelayedBan then
				warn(player.Name, "NEW BAN REQUEST DROPPED", bancode)
				return false, "Ban attempt dropped. [2]"
			else
				warn(player.Name, "DELAYED BAN FOR", bancode)
				user.DelayedBan = bancode
				local passed = 0
				local waitTime = 15
				while passed < waitTime do
					passed += task.wait(math.min(0.1, waitTime - passed))
					if (not user) or user.Banned or not player or not player.Parent then
						if user and user.DelayedBan == bancode then
							user.DelayedBan = nil
						end
						warn(player.Name, "DELAYED BAN DROPPED", bancode)
						return false, "Ban attempt dropped. [3]"
					end
				end
				user.DelayedBan = nil
			end
		end
		local playerData, bans, displayname, accountage, isUWP
		if bancode == "025" and isFlag and player and user then
			local minPlayTime = script:GetAttribute("BanFor025LowPlayTime")
			local sessionTime = os.time() - user.StartTime
			if (minPlayTime or 0) > 0 and sessionTime < minPlayTime then
				isFlag = false
				print("PLAY TIME TOO LOW, BANNING INSTEAD", bancode)
			elseif sessionTime >= script:GetAttribute("BanFor025MaxTime") then
				print("DROPPING FLAG - PLAYTIME TOO HIGH", bancode)
				return false, "Ban attempt dropped. [4]"
			end
		end
		if not (wasBanned or isFlag) then
			BannedPlayers[userid] = true
			task.delay(20, function()
				BannedPlayers[userid] = nil
			end)
		end
		local changedToKick = false
		if (bancode == "024" and args[1] == "SurfaceGui" and args[2] == "VRBlurScreen") or 
			(bancode == "117" and ((args[1] == 1 and args[2]:find("WLPERR")) or (args[1] == 0 and args[2] == "N/A"))) then
			if not player then
				return false, "Ban attempt dropped. [5]"
			end
			changedToKick = true
			isKick = true
		elseif bancode == "008" and args[2] ~= "MALICIOUS FIRERATE" then
			isFlag = false
		end
		if player then
			if user and not (isFlag or isKick or immune) then
				user.Banned = true
			end
			displayname = player.DisplayName
			accountage = player.AccountAge
			playerData = (user and user:GetData(true, true))
			isUWP = (user ~= nil and user.UWP)
			if not (immune or isFlag) then
				if isKick then
					self:Kick(player, (script:GetAttribute(`Kick{bancode or " "}Message`) or script:GetAttribute("KickDefaultMessage")))
				else
					self:KickFromBan(player, os.time(), banDuration)
				end
			end
		elseif not wasBanned then
			playerData, bans = DataModule:LoadData(userid)
		end
		if bans then return false, "Player is already banned." end
		local tim = os.time()
		if isFlag and playerData and bancode then
			local curFlag = playerData.LastFlags[bancode]
			wasBanned = (curFlag ~= nil and tim - curFlag < 120)
			if user and not wasBanned then
				user.LastFlags[bancode] = tim
			end
		end
		local inServer = (player ~= nil and player:IsDescendantOf(Players) and `{tostring(shared.ServerId)} ({tostring(Values.ServerName.Value)})`)
		local privileges = (self:HasSpecialPrivileges(userid) or "None")
		local banInfo = self:GeneratePlayerInfo(plrname, displayname, accountage, playerData, inServer, args[1], bancode, admin, banDuration)
		local banSuccess = false
		local flagPriorityOverride
		if not wasBanned then
			--if not immune then
			local extras
			if bancode then
				extras = {}
				if bancode == "001" or bancode == "002" or bancode == "003" or bancode == "006" or bancode == "080" or bancode == "081" then
					local wantedValue
					local suc, err = pcall(function()
						wantedValue = (args[1]:IsDescendantOf(Remotes) and args[1].Parent.Parent.Name.."."..self:DecryptRemoteName(args[1].Parent.Name).."."..self:DecryptRemoteName(args[1].Name) or args[1]:GetFullName())
					end)
					if suc then
						table.insert(extras, {
							["name"] = "REMOTE:",
							["value"] = (wantedValue or self:FilterArgument(args[1]))
						})
						if bancode == "002" then
							table.insert(extras, {
								["name"] = "PERMISSION LEVEL:",
								["value"] = privileges.." ("..args[2].." permission or higher required.)"
							})
						elseif bancode == "080" or bancode == "081" then
							table.insert(extras, {
								["name"] = "TIME SINCE FIRST DETECTION:",
								["value"] = self:FilterArgument(args[2])
							})
							table.insert(extras, {
								["name"] = (bancode == "080" and "SIMILARITY CHECKS:" or "REMOTE INSTANCE INDEX:"),
								["value"] = self:FilterArgument(args[3])
							})
						end
						if bancode == "006" then
							table.insert(extras, {
								["name"] = "ARGUMENT INDEX:",
								["value"] = self:FilterArgument(args[2])
							})
							table.insert(extras, {
								["name"] = "DECRYPTED ARGUMENT:",
								["value"] = "`"..self:FilterArgument(args[3], false, 400).."`"
							})
						else
							table.insert(extras, {
								["name"] = (bancode == "003" and "DECRYPTION ERROR:" or "ARGUMENTS PASSED:"),
								["value"] = (bancode == "003" and self:FilterArgument(args[2], false, 750, true) or "```lua\n"..self:TruncateString(Http:JSONEncode(self:JSONFriendlyTable(args[(bancode == "080" or bancode == "081") and 4 or (bancode == "002" and 3 or 2)]))).."\n```")
							})
						end
					else
						table.insert(extras, {
							["name"] = "ATTEMPTED BAN CODE:",
							["value"] = tostring(bancode)
						})
						table.insert(extras, {
							["name"] = "FUNCTION ARGUMENTS:",
							["value"] = "```lua\n"..self:TruncateString(Http:JSONEncode(self:JSONFriendlyTable(args))).."\n```"
						})
						bancode = "078"
					end
				elseif bancode == "082" then
					table.insert(extras, {
						["name"] = "TOTAL REMOTE CALLS DROPPED:",
						["value"] = self:FilterArgument(args[1], true)
					})
					local remoteInfos = ""
					local totalAmount = 0
					local suspicious = false
					for _, info in pairs(type(args[2]) == "table" and args[2] or {}) do
						local remoteName = info.RemoteName
						--[[if remoteName == "Equip" or remoteName == "Consume" or remoteName == "PickupItem" or remoteName == "Bench" or remoteName == "DigUp" then
							if info.CurrentDrops >= 250 then
								suspicious = true
							end
						else
							suspicious = true
						end]]
						if info.CurrentDrops >= 500 then
							suspicious = true
						end
						totalAmount += 1
						local curThrottle = (type(info.CurrentThrottles) == "table" and info.CurrentThrottles or {})
						remoteInfos = remoteInfos.."**"..self:FilterArgument(info.FolderName).."."..self:FilterArgument(remoteName)..":**\n"
						remoteInfos = remoteInfos.."CALLS DROPPED: "..self:FilterArgument(info.CurrentDrops, true).." (total of "..self:FilterArgument(info.AllDrops, true)..")\n"
						remoteInfos = remoteInfos.."CALLS THROTTLED: "..self:FilterArgument(#curThrottle, true).." (total of "..self:FilterArgument(info.AllThrottles, true)..")\n"
						remoteInfos = remoteInfos.."THROTTLE QUEUE:```lua\n"..self:TruncateString(Http:JSONEncode(self:JSONFriendlyTable(curThrottle, nil, true)), 750).."```\n"
					end
					if totalAmount > 1 then
						flagPriorityOverride = totalAmount * 40
					elseif suspicious then
						flagPriorityOverride = 60
					end
					table.insert(extras, {
						["name"] = "REMOTE INFORMATION:",
						["value"] = remoteInfos
					})
				elseif bancode == "008" or bancode == "053" or bancode == "054" or bancode == "067" then
					table.insert(extras, {
						["name"] = (bancode == "054" and "LAST FIRED TICK:" or (bancode == "067" and "LAST EXTRA TICKS AMOUNT:" or "INFO:")),
						["value"] = self:FilterArgument(tostring(args[1]), false, 100)
					})
					if bancode == "008" then
						table.insert(extras, {
							["name"] = "DETECTION TYPE:",
							["value"] = self:FilterArgument(tostring(args[2]))
						})
					end
				elseif bancode == "010" or bancode == "011" or bancode == "012" or bancode == "014" or bancode == "015" or bancode == "022" then
					table.insert(extras, {
						["name"] = "LOCAL PROPERTY VALUE:",
						["value"] = self:FilterArgument(args[1], true)
					})
				elseif bancode == "016" then
					table.insert(extras, {
						["name"] = "HUMANOID INSTANCE CHANGE:",
						["value"] = (args[1] == 0 and "A foreign Humanoid instance was added." or "Current Character's Humanoid was deleted or moved unknowingly.")
					})
				elseif bancode == "017" then
					table.insert(extras, {
						["name"] = "PROPERTY:",
						["value"] = (args[1] == 0 and "Sit" or "PlatformStand")
					})
				elseif bancode == "020" or bancode == "021" or bancode == "023" or bancode == "024" or bancode == "026" or bancode == "061" then
					table.insert(extras, {
						["name"] = "INSTANCE CLASSNAME:",
						["value"] = self:FilterArgument(args[1])
					})
					table.insert(extras, {
						["name"] = ((bancode == "020" or bancode == "021") and "INSTANCE PARENT:" or "INSTANCE NAME:"),
						["value"] = self:FilterArgument(args[2], false, 150)
					})
					if bancode == "026" then
						table.insert(extras, {
							["name"] = "INSTANCE PARENT:",
							["value"] = self:FilterArgument(args[3], false, 150)
						})
					end
				elseif bancode == "027" or bancode == "036" or bancode == "106" then
					table.insert(extras, {
						["name"] = (bancode == "027" and "BLACKLISTED NAME:" or (bancode == "036" and "DETECTIONS SINCE LAST FIRE:" or "SPOOFED POSITION DISTANCE:")),
						["value"] = self:FilterArgument(args[1])
					})
					table.insert(extras, {
						["name"] = (bancode == "027" and "INSTANCE PATH:" or (bancode == "036" and "FARTHEST CAMERA DISTANCE:" or "SPOOFED ROTATION DISTANCE:")),
						["value"] = self:FilterArgument(args[2], false, 150)
					})
				elseif bancode == "028" or bancode == "040" or bancode == "052" or bancode == "064" or bancode == "068" or bancode == "072" or bancode == "075" or bancode == "076" or bancode == "077" or bancode == "079" or bancode == "083" or bancode == "085" or bancode == "086" or bancode == "087" or bancode == "088" or bancode == "090" or bancode == "092" or bancode == "094" or bancode == "095" or bancode == "099" or bancode == "101" or bancode == "105" then
					table.insert(extras, {
						["name"] = (bancode == "094" and "SPOOFED LOCAL VALUE:" or "ERROR:"),
						["value"] = (bancode == "094" and self:FilterArgument(args[1], true) or "`"..self:FilterArgument(args[1], false, 250, true).."`")
					})
					if bancode == "028" then
						table.insert(extras, {
							["name"] = "STACK TRACE:",
							["value"] = "`"..self:FilterArgument(args[2], false, 600, true).."`"
						})
					elseif bancode == "083" or bancode == "092" or bancode == "099" or bancode == "105" then
						table.insert(extras, {
							["name"] = (bancode == "083" and "FUNCTION CHECK INDEX:" or "HOOK DETECTION METHOD INDEX:"),
							["value"] = self:FilterArgument(args[2])
						})
					elseif bancode == "085" or bancode == "086" or bancode == "088" or bancode == "094" then
						table.insert(extras, {
							["name"] = "HOOKED PROPERTY INDEX:",
							["value"] = self:FilterArgument(args[2])
						})
					elseif bancode == "090" then
						table.insert(extras, {
							["name"] = "PARENT:",
							["value"] = self:FilterArgument(args[2], false, 150)
						})
					end
					if bancode == "028" then
						table.insert(extras, {
							["name"] = "SCRIPT NAME:",
							["value"] = self:FilterArgument(args[3])
						})
						table.insert(extras, {
							["name"] = "SCRIPT PARENT:",
							["value"] = self:FilterArgument(args[4], false, 150)
						})
					end
				elseif bancode == "025" then
					table.insert(extras, {
						["name"] = "TOTAL MEMORY CHANGE:",
						["value"] = self:FilterArgument(args[1])
					})
					table.insert(extras, {
						["name"] = "UNREFERENCED MEMORY VALUES:",
						["value"] = "`"..self:FilterArgument(args[2]).."`"
					})
					table.insert(extras, {
						["name"] = "AVERAGE FPS:",
						["value"] = self:FilterArgument(args[3], true)
					})
					table.insert(extras, {
						["name"] = "CHANGE DURATION:",
						["value"] = self:FilterArgument(args[4])
					})
				elseif bancode == "029" then
					table.insert(extras, {
						["name"] = "DETECTED BY:",
						["value"] = (args[1] == 0 and "MessageOut" or "GetLogHistory")
					})
					table.insert(extras, {
						["name"] = "MESSAGE TYPE:",
						["value"] = self:FilterArgument(args[2])
					})
					table.insert(extras, {
						["name"] = "PRINTED MESSAGE:",
						["value"] = "`"..self:FilterArgument(args[3], false, 500).."`"
					})
					table.insert(extras, {
						["name"] = "EXTRA INFO:",
						["value"] = (args[4] == 1 and "Remote container name found in message" or (args[4] == 2 and "Remote name found in message" or "None"))
					})
				elseif bancode == "034" then
					local argument = (self:FilterArgument(args[1]) or "")
					local assetIdString = argument:gsub("%D", "")
					local assetId = tonumber(assetIdString)
					if assetId == 0 then
						isFlag = false
					end
					table.insert(extras, {
						["name"] = "ASSET LOADED:",
						["value"] = (assetId and `[{argument}](https://www.roblox.com/library/{assetId})` or argument)
					})
					local did = false
					local err = "N/A"
					if assetId then
						local suc, productInfo = pcall(function()
							return Marketplace:GetProductInfo(assetId, Enum.InfoType.Asset)
						end)
						if suc and productInfo then
							local creator = productInfo.Creator
							local creatorId = creator.CreatorTargetId
							if creatorId == 643466848 or creatorId == 1905862832 or creatorId == 2402872884 or creatorId == 124828424 or creatorId == 164495910 or creatorId == 2018144535 or creatorId == 687980758 or creatorId == 147631672 or creatorId == 87601985 or creatorId == 1225770177 or creatorId == 121074257 or creatorId == 28002028 or creatorId == 87924253 or creatorId == 86835535 or creatorId == 448748429 or creatorId == 22343458 or creatorId == 871689195 or creatorId == 459750931 or creatorId == 3384796209 or creatorId == 9517042 or creatorId == 818731954 or creatorId == 843654028 or creatorId == 65597744 or creatorId == 2668291135 or creatorId == 2050262468 or creatorId == 1887256 or creatorId == 24502450 or creatorId == 355617324 or creatorId == 1124979438 or creatorId == 497924410 or creatorId == 77061962 or creatorId == 483409820 or creatorId == 1060663132 or creatorId == 3252278885 or creatorId == 5694167977 or creatorId == 116245874 or creatorId == 459116921 then
								isFlag = false
							end
								if productInfo.IsForSale or productInfo.IsPublicDomain or productInfo.Name:sub(1, 7) == "Images/" or productInfo.Name == "Image" or creator.HasVerifiedBadge or creator.CreatorType == "Group" or creatorId == 1 or creatorId == 16681869 or creatorId == 15680821 or creatorId == 25548179 or creatorId == 363101315 or creatorId == 174212818 or creatorId == 1063692972 or creatorId == 89117302 or creatorId == 19618897 or creatorId == 77554513 then
								return false, "null exception"
							end
							local assetTypeId = productInfo.AssetTypeId
							local assetType = "N/A"
							for _, enumItem in pairs(Enum.AssetType:GetEnumItems()) do
								if enumItem.Value ~= assetTypeId then continue end
								assetType = enumItem.Name
								break
							end
							if assetTypeId ~= 1 and assetTypeId ~= 13 then
								flagPriorityOverride = 80
							end
							table.insert(extras, {
								["name"] = "ASSET TYPE:",
								["value"] = assetType
							})
							table.insert(extras, {
								["name"] = "CREATOR:",
								["value"] = `([@{creator.Name}](https://www.roblox.com/users/{creatorId}/profile)):{creatorId}`
							})
							did = true
						else
							err = productInfo
						end
					end
					if not did then
						flagPriorityOverride = 60
						table.insert(extras, {
							["name"] = "ASSET FETCH ERROR:",
							["value"] = "`"..err.."`"
						})
					end
				elseif bancode == "045" or bancode == "073" or bancode == "074" or bancode == "109" then
					table.insert(extras, {
						["name"] = (bancode == "045" and "LAST DETECTED LOOP STAGE:" or "PROPERTY NAME:"),
						["value"] = self:FilterArgument(args[1])
					})
					if bancode == "045" then
						table.insert(extras, {
							["name"] = "LOOP INDEX:",
							["value"] = self:FilterArgument(args[2])
						})
					end
					local argToUse = args[bancode == "045" and 3 or 2]
					table.insert(extras, {
						["name"] = ((bancode == "074" or bancode == "109") and "VALUE:" or "ERROR:"),
						["value"] = (bancode == "074" and self:FilterArgument(argToUse, true) or "`"..self:FilterArgument(argToUse, false, 400, true).."`")
					})
				elseif bancode == "043" or bancode == "047" or bancode == "048" or bancode == "096" or bancode == "102" or bancode == "110" or bancode == "118" then
					table.insert(extras, {
						["name"] = (bancode == "043" and "GC DIFFERENCE:" or (bancode == "047" and "SELECTED DURATION:" or (bancode == "048" and "VARIABLE NAME:" or (bancode == "096" and "MEMORY DIFFERENCE:" or (bancode == "102" and "SPOOFED VALUE:" or (bancode == "110" and "SPOOFED POSITION DISTANCE:" or "FIRE COUNT:")))))),
						["value"] = self:FilterArgument(args[1], true)
					})
				elseif bancode == "041" or bancode == "050" or bancode == "111" then
					table.insert(extras, {
						["name"] = (bancode == "041" and "GC SPIKE:" or (bancode == "050" and "DETECTIONS SINCE LAST:" or "MEDIAN DISTANCE MISMATCH:")),
						["value"] = self:FilterArgument(args[1], true)
					})
					table.insert(extras, {
						["name"] = (bancode == "041" and "GC CLIENT THRESHOLD:" or (bancode == "050" and "TOTAL DETECTIONS:" or "FARTHEST DISTANCE MISMATCH:")),
						["value"] = self:FilterArgument(args[2], true)
					})
				elseif bancode == "044" or bancode == "049" then
					table.insert(extras, {
						["name"] = (bancode == "044" and "CONSTANT GC:" or "SCRIPT:"),
						["value"] = self:FilterArgument(args[1], true, 150)
					})
					table.insert(extras, {
						["name"] = (bancode == "044" and "LOWEST GC:" or "ATTRIBUTE NAME:"),
						["value"] = self:FilterArgument(args[2], true)
					})
					table.insert(extras, {
						["name"] = (bancode == "044" and "HIGHEST GC:" or "LOCAL ATTRIBUTE VALUE:"),
						["value"] = self:FilterArgument(args[3], true)
					})
				elseif bancode == "057" or bancode == "084" then
					table.insert(extras, {
						["name"] = "DETECTION INDEX:",
						["value"] = self:FilterArgument(args[1])
					})
					if bancode == "057" then
						table.insert(extras, {
							["name"] = "EXTRA INFORMATION:",
							["value"] = "`"..self:FilterArgument(args[2], false, 300, true).."`"
						})
					end
				elseif bancode == "060" then
					table.insert(extras, {
						["name"] = "LOCAL USERID VALUE:",
						["value"] = self:FilterArgument(args[1])
					})
					table.insert(extras, {
						["name"] = "SAVED USERID:",
						["value"] = self:FilterArgument(args[2])
					})
				elseif bancode == "073" or bancode == "069" or bancode == "070" or bancode == "071" or bancode == "107" then
					table.insert(extras, {
						["name"] = "INSTANCE PATH:",
						["value"] = self:FilterArgument(args[1], false, 100)
					})
					if bancode == "107" then
						table.insert(extras, {
							["name"] = "WEAKTABLE LENGTH:",
							["value"] = self:FilterArgument(args[2])
						})
					else
						table.insert(extras, {
							["name"] = "EVENT NAME:",
							["value"] = self:FilterArgument(args[2])
						})
						table.insert(extras, {
							["name"] = ((bancode == "063" or bancode == "069") and "ERROR:" or (bancode == "070" and "CONNECTION CALL:" or "STACK ORDER:")),
							["value"] = ((bancode == "063" or bancode == "069") and "`"..self:FilterArgument(args[3], false, 400, true).."`" or self:FilterArgument(args[3], true))
						})
					end
					if bancode == "070" then
						table.insert(extras, {
							["name"] = "CONNECTION TYPE:",
							["value"] = self:FilterArgument(args[4])
						})
					end
				elseif bancode == "004" or bancode == "089" or bancode == "093" or bancode == "097" or bancode == "100" or bancode == "104" then
					table.insert(extras, {
						["name"] = (bancode == "089" and "TRAP METAMETHOD INDEX:" or ((bancode == "097" or bancode == "004") and "METAMETHOD INDEX:" or "METAMETHOD PARAMETER COUNT:")),
						["value"] = self:FilterArgument(args[1])
					})
					if bancode == "093" or bancode == "100" or bancode == "104" then
						table.insert(extras, {
							["name"] = "METAMETHOD IS VARIADIC:",
							["value"] = self:FilterArgument(args[2])
						})
					end
				elseif bancode == "091" or bancode == "098" or bancode == "103" or bancode == "112" then
					table.insert(extras, {
						["name"] = (bancode == "112" and "DETECTION METHOD INDEX:" or "FUNCTION CACHE MISMATCH:"),
						["value"] = self:FilterArgument(args[1])
					})
					table.insert(extras, {
						["name"] = (bancode == "112" and "PRELOADASYNC ERROR:" or "METAMETHOD SOURCE:"),
						["value"] = (bancode == "112" and "`"..self:FilterArgument(args[2], false, 400, true).."`" or self:FilterArgument(args[2]))
					})
					table.insert(extras, {
						["name"] = (bancode == "112" and "EXTRA INFO:" or "LINE NUMBER:"),
						["value"] = self:FilterArgument(args[3])
					})
					if bancode ~= "112" then
						table.insert(extras, {
							["name"] = "METAMETHOD FUNCTION TYPE:",
							["value"] = self:FilterArgument(args[4])
						})
					end
				elseif bancode == "108" then
					table.insert(extras, {
						["name"] = "SPEEDHACK DETECTIONS:",
						["value"] = self:FilterArgument(args[1], true)
					})
					table.insert(extras, {
						["name"] = "NOCLIP DETECTIONS:",
						["value"] = self:FilterArgument(args[2], true)
					})
					table.insert(extras, {
						["name"] = "FLYHACK DETECTIONS:",
						["value"] = self:FilterArgument(args[3], true)
					})
				elseif bancode == "117" then
					table.insert(extras, {
						["name"] = "LAST DETECTED LOOP STAGE:",
						["value"] = self:FilterArgument(args[1])
					})
					table.insert(extras, {
						["name"] = "ERROR:",
						["value"] ="`"..self:FilterArgument(args[2], false, 400, true).."`"
					})
					table.insert(extras, {
						["name"] = "TIMES ELAPSED:",
						["value"] = self:FilterArgument(args[3])
					})
					--[[table.insert(extras, {
						["name"] = "FALLENGUARD PATH:",
						["value"] = self:FilterArgument(args[4], false, 150, true)
					})]]
				elseif bancode == "018" or bancode == "030" or bancode == "055" or bancode == "066" then
					table.insert(extras, {
						["name"] = (bancode == "055" and "CHECK IDENTIFIER:" or (bancode == "018" and "HUMANOID STATE:" or (bancode == "030" and "UNPROCESSED MALICIOUS KEYS PRESSED:" or "CLIENT VERSION:"))),
						["value"] = self:FilterArgument(args[1])
					})
				elseif bancode == "119" then
					table.insert(extras, {
						["name"] = "REMOTE PATH:",
						["value"] = self:FilterArgument(args[1], false, 100)
					})
				end
				local dataExtras = {}
				for _, extra in pairs(extras) do
					table.insert(dataExtras, {extra.name, (extra.value or "N/A")})
				end
				banInfo.BanCodeReason = dataExtras
			end
			if not (isFlag or immune or isKick) then
				local systemMessage
				if bancode and userid and privileges == "None" then
					local infoFetchSuc, infoFetch = pcall(function()
						return UserService:GetUserInfosByUserIdsAsync({userid})
					end)
					local dispName
					if infoFetchSuc and infoFetch[1] then
						dispName = infoFetch[1].DisplayName
					end
					systemMessage = ((dispName ~= nil or dispName == plrname) and `@{plrname}` or `{dispName}(@{plrname})`).." WAS BANNED BY FALLENGUARD"
				end
				banSuccess = DataModule:SaveData(userid, "Bans", banInfo, plrname)
				if not inServer then
					self:SendFallenGuardRequest({
						Type = "Kick",
						UserId = userid,
						Message = systemMessage
					})
				elseif systemMessage then
					self:SendFallenGuardRequest({
						Type = "SystemMessage",
						Message = systemMessage
					})
				end
			end
			if extras then
				--print(bancode, args)
				local codeReason = (banCodesDatabase:GetAsync("`"..bancode) or "N/A")
				local isCriticalCode = (bancode == "002" or bancode == "045" or bancode == "056" or bancode == "067" or bancode == "077" or bancode == "078")
				local isCritical = (privileges == "Mod" or isCriticalCode) and not isKick
				ModUtil:CreateFallenGuardLog({
					WebhookName = "PrivateWebhookUrl";
					UserId = userid;
					BanInfo = banInfo;
					InServer = inServer;
					IsUWP = isUWP;
					Content = (isCritical and "||<@&398233437988716550>||");
					Title = (isCritical and "**[CRITICAL] **" or "").."FALLENGUARD "..(isFlag and "FLAG" or (isKick and "KICK" or "BAN"));
					Color = ModUtil:Color3ToDecimal(isCritical and script:GetAttribute("Critical"..(isFlag and "Flag" or "Ban").."LogColor") or script:GetAttribute(`AntiCheat{isFlag and "Flag" or (isKick and "Kick" or "Ban")}LogColor`));
					Fields = {
						{
							["name"] = "CODE: "..bancode,
							["value"] = "Description: "..codeReason:sub((isFlag and bancode ~= "029" and bancode ~= "025" and bancode ~= "008" and bancode ~= "034") and 11 or ((isCriticalCode or (isKick and not changedToKick)) and 12 or 1))
						},
						unpack(extras)
					};
				})
			end
			local modAdminBanned = (adminPrivileges == "Owner" and privileges == "Mod")
			if modAdminBanned or (not immune and not (bancode and privileges == "Mod")) then
				local flagPriority = 1
				local flagMsg
				if bancode == "029" then
					flagPriority = (args[4] ~= 0 and 100 or (args[1] ~= 0 and 60 or 20))
				--[[elseif bancode == "030" then
					flagPriority = 45
					flagMsg = "Player was detected by new FallenGuard detection (030) that was added in Build 1.091. Currently only flagging people, so they can all get banned later at once."]]
				elseif bancode == "031" or bancode == "025" then
					flagMsg = "Investigate this user further. Only take action with definitive proof. Shorter session times generally mean more suspicion regarding this flag."
					flagPriority = 40
				elseif bancode == "034" then
					flagPriority = (flagPriorityOverride or 20)
				elseif bancode == "036" then
					flagPriority = (type(args[2]) ~= "number" and 100 or args[2] * 4)
					flagMsg = "Investigate this user further. Check for any irregularities in their movement. Long periods of idling or erratic behavior should be reported."
				elseif bancode == "082" then
					flagPriority = (flagPriorityOverride or 30)
					flagMsg = "Investigate this user further. People with very poor internet connection are more prone to being false flagged by this."
				elseif bancode == "050" then -- CURRENTLY DISABLED
					flagPriority = 100
				elseif bancode == "111" then
					flagPriority = (math.max((args[1] or 0) - 250, 0) / 5) -- Median distance of 400+ = severe priority
					flagMsg = "Investigate this user further. Check for any irregularities in their movement. Long periods of idling or erratic behavior should be reported."
				end
				local priorityLevel = (flagPriority <= 20 and "LOW" or (flagPriority <= 40 and "MEDIUM" or (flagPriority <= 60 and "HIGH" or (flagPriority <= 80 and "VERY HIGH" or "SEVERE"))))
				ModUtil:CreateFallenGuardLog({
					WebhookName = (modAdminBanned and "PrivateWebhookUrl" or "WebhookUrl");
					UserId = userid;
					BanInfo = banInfo; 
					InServer = inServer; 
					IsUWP = isUWP;
					Content = ((isFlag and not immune and flagPriority >= 50) and "||<@&398233437988716550>||");
					Title = (admin and "ADMIN" or "FALLENGUARD").." "..(isFlag and "FLAG" or (isKick and "KICK" or "BAN"));
					Color = ModUtil:Color3ToDecimal(admin and script:GetAttribute("AdminBanLogColor") or script:GetAttribute(`AntiCheat{isFlag and "Flag" or (isKick and "Kick" or "Ban")}LogColor`));
					Fields = {
						{
							["name"] = (admin and "BANNED BY:" or (isFlag and "PRIORITY: "..priorityLevel or `{isKick and "KICK" or "BAN"} CODE:`)),
							["value"] = (admin and "**"..admin.DisplayName.."([@"..admin.Name.."](https://www.roblox.com/users/"..admin.UserId.."/profile)):"..admin.UserId.."**" or (isFlag and (flagMsg or "This flag can vary greatly in severity. Contact the developers for a final saying in whether or not to take moderation action against this user.") or bancode))
						},
						(admin and {
							["name"] = "DURATION:",
							["value"] = (banInfo.Duration ~= nil and NumberUtil:FormatTime(banInfo.Duration, "Days", "Hours", true) or "PERMANENT")
						}),
						(admin and {
							["name"] = "REASON:",
							["value"] = banInfo.AdminReason
						})
					};
				})
			end
		end
		--end
		if immune or not wasBanned then
			warn(banInfo.DisplayName.."(@"..banInfo.Name.."):"..userid..(immune and " WOULD BE" or " WAS").." "..(isFlag and "FLAGGED" or (isKick and "KICKED" or "BANNED")).." FOR ["..(admin and banInfo.AdminReason or bancode)..(immune and "] BUT THEY'RE IMMUNE." or "]."), banInfo, args)
		end
		return banSuccess
	end
end

function ModUtil:CreateFallenGuardLog(args)
	local banInfo = args.BanInfo
	local privileges = (self:HasSpecialPrivileges(args.UserId) or "None")
	local playerInfo = "**"..banInfo.DisplayName.."([@"..banInfo.Name.."](https://www.roblox.com/users/"..args.UserId.."/profile)):"..args.UserId.."**"
	local isUWP = (args.IsUWP and "false" or "true")
	local accountInfo = {
		["name"] = "ACCOUNT INFORMATION:",
		["value"] = "**Account Age:** "..(banInfo.AccountAge and NumberUtil:FormatNumber(banInfo.AccountAge).." Days Old" or "N/A")..
			"\n**Current Session Time:** "..(banInfo.PlayTime and NumberUtil:FormatTime(banInfo.PlayTime, "Hours") or "N/A")..
			"\n**Total Time Played:** "..(banInfo.TotalPlayTime and NumberUtil:FormatTime(banInfo.TotalPlayTime, "Hours") or "N/A")..
			"\n**In Server:** "..tostring(args.InServer)..
			"\n**Permission Level:** "..privileges..
			"\n**Windows Client:** "..isUWP
	}
	local content
	if args.Content then
		content = args.Content
	end
	self:SendLog(args.WebhookName, {
		["content"] = content,
		["embeds"] = {
			{
				["title"] = args.Title,
				["description"] = (args.Description or playerInfo),
				["color"] = args.Color,
				["fields"] = {
					accountInfo,
					unpack(args.Fields)
				},
				["footer"] = {
					["text"] = (args.Footer or banInfo.TimeOfBan.Formatted)
				}
			},
		},
	})
end

function ModUtil:GeneratePlayerInfo(plrname, displayname, accountage, playerData, inServer, reason, bancode, admin, banDuration)
	local tim = os.time()
	return {
		BanCode = bancode;
		Admin = (admin and admin.UserId);
		AdminReason = (admin ~= nil and (reason or "Unspecified."));
		Name = plrname;
		DisplayName = (displayname or "");
		AccountAge = accountage;
		TimeOfBan = {
			InSeconds = tim;
			Formatted = os.date("%c");
		};
		PlayTime = (playerData and (inServer and tim - playerData.StartTime or 0));
		TotalPlayTime = (playerData and playerData.TotalPlayTime);
		Inventory = (playerData and playerData.Inventory);
		Duration = banDuration;
	}
end

function ModUtil:Kick(player, reason)
	task.defer(function()
		if player.Name == "tonybolony22" and not reason then task.wait(5) end
		for _= 1, 3 do
			player:Kick(reason or script:GetAttribute("BanMessage"))
			task.wait(3)
		end
		player:Destroy()
	end)
end

function ModUtil:SendFallenGuardRequest(data)
	local suc, err = pcall(function()
		Messaging:PublishAsync("FallenGuard", data)
	end)
	if suc then return true end
	warn("ERROR SENDING FALLENGUARD REQUEST:", err, data.Type, data)
	return false
end

function ModUtil:DecryptString(str, ignoreLength)
	local origLength = str:len()
	local maxLength = (ignoreLength and 15000 or 1000)
	if origLength > maxLength and not ignoreLength then
		return false, `Encrypted argument is maliciously long and cannot be decrypted. [{origLength}/{maxLength}]`
	end
	str = str:gsub(string.char(29), "")
	local total = #str / 3
	if math.floor(total) ~= total then
		return false, "Encrypted argument string isn't in multiples of three. [ARG LENGTH: "..#str.."]"
	end
	local decrypted = ""
	for i = 1, total do
		local byte = 0
		for o = 1, 3 do
			local l = (i - 1) * 3 + o
			local s = str:sub(l, l)
			local b
			local suc, err = pcall(function()
				b = string.byte(s)
			end)
			if not (suc and b) then
				return false, "Decryption errored whilst trying to get the byte of a specific character. [ERROR: "..err.."] [CURRENT DECRYPTED: "..decrypted.."]"
			end
			local add = b - 30
			if add <= 0 then
				return false, "string.byte returned a value <= 0. [FAILED BYTE: "..add.."] [CURRENT DECRYPTED: "..decrypted.."]"
			end
			byte += add
		end
		local s = string.char(byte)
		decrypted = decrypted..s
	end
	local start = string.find(decrypted, [[`]])
	if not start then
		return false, 'No symbol indicator "`" for start of string detected. [CURRENT DECRYPTED: '..decrypted.."]"
	end
	for _ = 1, start - 1 do
		decrypted = (decrypted..decrypted:sub(1, 1)):sub(2, decrypted:len() + 1)
	end
	if origLength > 1000 and not ignoreLength then
		return false, `Encrypted argument is too long ({origLength}/1000) [DECRYPTED ARG: {decrypted}]`
	end
	return decrypted
end

function ModUtil:IsRealNumber(num)
	return (typeof(num) == "number" and num == num and math.abs(num) ~= math.huge)
end

function ModUtil:DecryptArguments(val, ignoreLength)
	local newArgs = {}
	--local doFlip = true
	local maxTickDiff = script:GetAttribute("RemoteArgMaxTickDifference")
	local tickDiffDrop = script:GetAttribute("RemoteArgTickDifferenceForDrop")
	local shouldDrop = false
	if (#val >= 10 and #val <= 94) or #val > 100 then
		return false, `Total arguments table has way too many arguments. [{#val}]`
	end
	for index, arg in pairs(val) do
		local t = typeof(arg)
		local newIndex = index
		--[[if type(index) == "string" then
			local decrypted, error = self:DecryptString(index)
			if not decrypted then
				return decrypted, error
			end
			newIndex = decrypted:sub(2)
			if newIndex:sub(1, 1) == "^" then
				local instance = Collection:GetTagged(newIndex)
				if instance and instance[1] then
					newIndex = instance[1]
				end
			end
			--doFlip = false
		end]]
		if type(index) ~= "number" then
			return false, 'A non-numeric index value detected. [INDEX TYPE: '..type(index).."]"
		end
		if t == "string" then
			if arg == ".void" then continue end
			--print("before decrypting:", arg)
			local decrypted, error = self:DecryptString(arg, ignoreLength)
			if not decrypted then
				return decrypted, error
			end
			--print("after decrypting:", decrypted)
			local slash = string.find(decrypted, "|")
			if not slash then
				return false, 'No symbol indicator "|" for end of tick fired detected. [DECRYPTED ARG: '..decrypted.."]" 
			end
			local serverTick = math.ceil(tick())
			local firedTick = tonumber(decrypted:sub(2, slash - 1))
			if type(firedTick) ~= "number" then
				return false, "Argument's fired tick was unable to be fetched. [DECRYPTED ARG: "..decrypted.."]"
			end
			local tickDiff = serverTick - firedTick
			if tickDiff < -1 or tickDiff > maxTickDiff then
				return false, "Argument's fired tick is expired. [ARG TICK: "..firedTick.."] [SERVER TICK: "..serverTick.."] [DECRYPTED ARG: "..decrypted.."]"
			elseif tickDiff > tickDiffDrop then
				shouldDrop = true
			end
			local underscore = string.find(decrypted, "_")
			if not underscore then
				return false, 'No symbol indicator "_" for end of value type detected. [DECRYPTED ARG: '..decrypted.."]"    
			end
			local typ = decrypted:sub(slash + 1, underscore - 1)
			--[[
			local slashesFound = -1
			local extraStr = string.gsub(decrypted:sub(underscore), "_", function()
				slashesFound += 1
				return (decrypted:sub(underscore + slashesFound, underscore + slashesFound) == "_" and "" or "_")
			end)]]
			local extraStr = ""
			for i = underscore + 1, decrypted:len() do
				local s = decrypted:sub(i, i)
				if s == "_" then continue end
				extraStr = decrypted:sub(i)
				break
			end
			local output
			if typ == "string" then
				output = extraStr
			elseif typ == "number" then
				output = tonumber(extraStr)
				if not self:IsRealNumber(output) then
					return index, decrypted
				end
			elseif typ == "boolean" then
				if extraStr == "true" then
					output = true
				elseif extraStr == "false" then
					output = false
				end
			elseif typ == "Instance" then
				output = Collection:GetTagged(extraStr)
				if output then
					output = output[1]
				end
			elseif typ ~= "nil" then
				local extras = string.split(extraStr, "/")
				for i, v in pairs(extras) do
					extras[i] = ((typ == "CFrame" and i >= 4) and (v == "p" and math.pi or (v == "-p" and -math.pi)) or tonumber(v))
				end
				for i, v in pairs(extras) do
					if self:IsRealNumber(v) then continue end
					return index, decrypted
				end
				local valueType = getfenv()[typ]
				if valueType then
					local success, error = pcall(function()
						if typ == "CFrame" then
							output = CFrame.new(unpack(extras, 1, 3)) * CFrame.Angles(unpack(extras, 4, 6))
						else
							output = valueType.new(unpack(extras))
						end
					end)
					if not success then
						return false, "Value type failed to be properly constructed. [VALUE TYPE: "..typ.."] [ERROR: "..error.."] [DECRYPTED ARG: "..decrypted.."]"
					end
				else
					return false, "An argument value type isn't compatible to be decrypted. [VALUE TYPE: "..typ.."] [DECRYPTED ARG: "..decrypted.."]"
				end
			end
			if output == nil and typ ~= "nil" and typ ~= "Instance" then
				return false, "An argument was unable to be properly decrypted. [DECRYPTED ARG: "..decrypted.."]"
			end
			newArgs[newIndex] = output
		--[[elseif t == "table" then
			local success, decryptedTable, wasDropped = self:DecryptArguments(arg)
			if success == true then
				newArgs[newIndex] = decryptedTable
				if wasDropped then
					shouldDrop = true
				end
			else
				return success, decryptedTable
			end]]
		elseif t ~= nil then
			return false, "A passed argument meant to be decrypted isn't a compatible decryptable value type. [VALUE TYPE: "..t.."]"
		end
	end
	local ret = {}
	--[[if doFlip then
		for i = 1, #newArgs do
			ret[#newArgs - (i - 1)] = newArgs[i]
		end
	else]]
	ret = newArgs
	--end
	return true, ret, shouldDrop
end

function ModUtil:GetSavedRemote(parent, remote)
	local savedValue = parent:FindFirstChild(remote.Name)
	if not savedValue then
		local chars = {}
		for i = 1, 30 do
			table.insert(chars, math.random(1, 190))
		end
		savedValue = Instance.new("StringValue")
		savedValue.Name = remote.Name
		savedValue.Value = string.char(unpack(chars))
		savedValue.Parent = parent
	end
	remote.Name = savedValue.Value
	return savedValue
end

function ModUtil:EncryptRemotes(seed)
	local t = {}
	local toPrint = {}
	for _, folder in pairs(Remotes:GetChildren()) do
		if not folder:IsA("Folder") then continue end
		local folderValue = self:GetSavedRemote(RemoteNames, folder)
		toPrint[folderValue.Name] = folderValue.Value
		for _, remote in pairs(folder:GetChildren()) do
			if not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then continue end
			local remoteValue = self:GetSavedRemote(folderValue, remote)
			toPrint[remoteValue.Name] = remoteValue.Value
		end
	end
	for _, v in pairs(RemoteNames:GetDescendants()) do
		if v:IsA("StringValue") and toPrint[v.Name] then continue end
		v:Destroy()
	end
	for oldName, newName in pairs(toPrint) do
		local bytes = {}
		for i = 1, newName:len() do
			table.insert(bytes, string.byte(newName:sub(i, i)))
		end
		print(oldName, "string.char("..table.concat(bytes, ", ")..")")
	end
end

function ModUtil:DecryptRemoteName(name)
	for _, value in pairs(RemoteNames:GetDescendants()) do
		if not (value:IsA("StringValue") and value.Value == name) then continue end
		return value.Name
	end
end

function ModUtil:DecryptRemotes()
	for _, child in pairs(Remotes:GetDescendants()) do
		local name = self:DecryptRemoteName(child.Name)
		if not name then continue end
		child.Name = name
	end
end

function ModUtil:HexCodeToBase(banCode: string): string
	local numArg = tonumber(banCode)
	return tostring((numArg <= 9 and "00" or (numArg <= 99 and "0" or ""))..numArg)
end

function ModUtil:SetupRemotes(remotesFolder, remotesTable)
	local actualFolderName = self:DecryptRemoteName(remotesFolder.Name)
	local remoteFunctions = {}
	local didRemotes = {}
	RemoteFunctions[actualFolderName] = remoteFunctions
	for remoteName, remoteSettings in pairs(remotesTable) do
		local remote = remotesFolder:WaitForChild(remoteName)
		local actualRemoteName = self:DecryptRemoteName(remoteName)
		local remoteInstances = {remote}
		for i = 1, 4 do
			local remoteClone = self:SafeClone(remote)
			remoteClone.Parent = remotesFolder
			table.insert(remoteInstances, remoteClone)
		end
		local func = remoteSettings.Function
		local cooldown = (remoteSettings.Cooldown or 0.05)
		local callsBeforeThrottle = (remoteSettings.AllowedCallsBeforeThrottle or 5)
		local maxThrottleQueue = (remoteSettings.ThrottleQueueMaxSize or 15)
		local argsIgnore = remoteSettings.ArgumentsIgnoreBan
		local ignoreDecryption = remoteSettings.IgnoreDecryption
		local throttleCallbackFunc = (remoteSettings.ThrottleQueueFullCallback or function(firedRemote, player, remoteInfo)
			local user = shared.Users[player]
			if not user then return end
			local fallenGuard = user.FallenGuard
			local flagged = (tick() - fallenGuard.LastRemoteFlag <= 60)
			if not flagged then
				remoteInfo.CurrentCallsDropped += 1
			end
			warn(actualFolderName.."."..actualRemoteName.." DROPPED "..player.Name.."'S CALL - QUEUE SIZE IS FULL. CURRENT DROPPED: "..remoteInfo.CurrentCallsDropped.." TOTAL DROPPED:"..remoteInfo.TotalCallsDropped.." THROTTLED AMOUNT:"..remoteInfo.ThrottleTotal)
			if fallenGuard.DoingRemoteFlag or flagged then return end
			--print("starting flag check")
			fallenGuard.DoingRemoteFlag = true
			task.wait(10)
			if not (player and player.Parent) then return end
			local remoteInfos = fallenGuard:FetchAllRemoteInfos()
			local totalCallDrops = 0
			local flaggedRemotes = {}
			for folderName, folderRemoteInfos in pairs(remoteInfos) do
				for name, info in pairs(folderRemoteInfos) do
					local callsDropped = info.CurrentCallsDropped
					totalCallDrops += callsDropped
					if callsDropped <= 0 then continue end
					local curThrottles = {}
					local count = 0
					for index = #info.ThrottleQueue, 1, -1 do
						count += 1
						local queue = info.ThrottleQueue[index]
						local newQueue = {}
						for key, value in pairs(queue) do
							if key == "Throttled" or key == "Remote" then continue end
							local newValue = (type(value) == "number" and math.floor(value * 100) / 100 or value)
							newQueue[key:sub(1, 1)] = newValue
						end
						curThrottles[count] = newQueue
					end
					table.insert(flaggedRemotes, {
						CurrentDrops = callsDropped;
						AllDrops = info.TotalCallsDropped;
						AllThrottles = info.ThrottleTotal;
						CurrentThrottles = curThrottles;
						FolderName = folderName;
						RemoteName = name;
					})
					remoteInfo.CurrentCallsDropped = 0
				end
			end
			--print("ending flag check", totalCallDrops, remoteInfos, flaggedRemotes)
			fallenGuard.DoingRemoteFlag = false
			if totalCallDrops >= 10 then
				fallenGuard.LastRemoteFlag = tick()
				self:BanPlayer(player.Name, "082", nil, totalCallDrops, flaggedRemotes)
			end
		end)
		remoteFunctions[actualRemoteName] = function(player, ...)
			return func(remote, player, {...})
		end
		for remoteIndex, remoteInstance in pairs(remoteInstances) do
			table.insert(didRemotes, remoteInstance)
			local remoteFunc = function(player, ...)
				local args = {...}
				local user = shared.Users[player]
				if not user then return end
				local fallenGuard = user.FallenGuard
				--print(actualFolderName.."."..actualRemoteName.." WAS FIRED")
				--print("BEFORE DECRYPTION:", args)
				local didDecrypt, decryptedArgs, dropped = self:DecryptArguments(args, actualRemoteName == "Ban")
				local ignoreDec = false
				if didDecrypt ~= true then
					if not didDecrypt then
						if not ignoreDecryption then
							self:BanPlayer(player.Name, "003", nil, remoteInstance, decryptedArgs)
							return
						else
							decryptedArgs = args
							ignoreDec = true
						end
					else
						self:BanPlayer(player.Name, "006", nil, remoteInstance, didDecrypt, decryptedArgs)
						return
					end
				end
				--print("AFTER DECRYPTION:", decryptedArgs)
				if not ignoreDec then
					for index, arg in pairs(decryptedArgs) do
						if argsIgnore and table.find(argsIgnore, index) then continue end
						if type(arg) == "string" and self:IsRealNumber(tonumber(arg)) then
							local banCode
							if arg:len() == 3 then
								banCode = arg
							elseif arg:len() == 4 and arg:sub(1, 2) == "0x" and arg ~= "0x00" then -- 000
								banCode = self:HexCodeToBase(arg)
								decryptedArgs[index] = banCode
							end
							if not banCode then continue end
							self:BanPlayer(player.Name, banCode, nil, select(index + 1, unpack(decryptedArgs)))
							return
						end
					end
					if dropped then
						warn(player.Name.."'S CALL FOR "..actualFolderName.."."..actualRemoteName.." CONTAINED EXPIRED ARGUMENTS AND WAS DROPPED")
						return
					end
				end
				local remoteInfo = fallenGuard:FetchRemoteInfo(actualFolderName, actualRemoteName)
				local callLogs = remoteInfo.CallLogs
				local throttleQueue = remoteInfo.ThrottleQueue
				local lastRemoteCall = callLogs[1]
				local t = tick()
				local doThrottle = false
				if lastRemoteCall then
					--print(lastRemoteCall)
					local lastRemote = lastRemoteCall.Remote
					if remoteInstance == lastRemote then
						local remoteCallCount = (remoteInfo.SameRemoteCallCount + 1)
						remoteInfo.SameRemoteCallCount = remoteCallCount
						if remoteCallCount == 1 then
							remoteInfo.FirstSameRemoteCallTime = t
						end
						if remoteCallCount >= script:GetAttribute("RemoteSameInstanceCallsAllowed") then
							self:BanPlayer(player.Name, "081", nil, remoteInstance, (t - remoteInfo.FirstSameRemoteCallTime), remoteIndex, decryptedArgs)
							return
						end
					else
						remoteInfo.SameRemoteCallCount = 0
					end
					local sameEncryptedArgCount = 0
					if not ignoreDec then
						for _, encryptedArg in pairs(args) do
							if not (encryptedArg ~= ".void" and table.find(lastRemoteCall.Encrypted, encryptedArg)) then continue end
							sameEncryptedArgCount += 1
						end
					end
					if sameEncryptedArgCount > 0 then
						local similarEncryptedArgCount = remoteInfo.SimilarEncryptedArgCount + 1
						local sameEncryptedArgTotal = remoteInfo.SameEncryptedArgTotal + sameEncryptedArgCount
						local totalEncryptedArgs = remoteInfo.TotalEncryptedArgs + #args
						remoteInfo.SimilarEncryptedArgCount = similarEncryptedArgCount
						remoteInfo.SameEncryptedArgTotal = sameEncryptedArgTotal
						remoteInfo.TotalEncryptedArgs = totalEncryptedArgs
						if similarEncryptedArgCount == 1 then
							remoteInfo.FirstSimilarEncryptedCheckTime = t
						end
						if similarEncryptedArgCount >= script:GetAttribute("RemoteSimilarEncryptAllowedCount") then
							self:BanPlayer(player.Name, "080", nil, remoteInstance, (t - remoteInfo.FirstSimilarEncryptedCheckTime), sameEncryptedArgTotal.." / "..totalEncryptedArgs, decryptedArgs)
							return
						end
					else
						remoteInfo.SimilarEncryptedArgCount = 0
						remoteInfo.SameEncryptedArgTotal = 0
						remoteInfo.TotalEncryptedArgs = 0
					end
					if t - lastRemoteCall.Fired < cooldown then
						remoteInfo.CallsBeforeCooldown += 1
						doThrottle = (remoteInfo.CallsBeforeCooldown > callsBeforeThrottle)
					else
						remoteInfo.CallsBeforeCooldown = 0
					end
				end
				local remoteCall = {
					Fired = t;
					Remote = remoteInstance;
					Decrypted = decryptedArgs;
					Encrypted = args;
					Throttled = doThrottle;
				}
				--print(actualFolderName.."."..actualRemoteName, "ENCRYPTED:", args)
				--print(actualFolderName.."."..actualRemoteName)
				table.insert(callLogs, 1, remoteCall)
				local maxSize = script:GetAttribute("RemoteCallLogMaxSize")
				if #callLogs > maxSize then
					table.remove(callLogs, maxSize + 1)
				end
				if doThrottle then
					remoteInfo.ThrottleTotal += 1
					local dropDebounce = (t - remoteInfo.LastCallDropped >= script:GetAttribute("RemoteThrottleFullInstantDrop"))
					if #throttleQueue < maxThrottleQueue and dropDebounce then
						--warn(player.Name.."'S CALL TO "..actualFolderName.."."..actualRemoteName.." ADDED TO QUEUE", remoteInfo)
						table.insert(throttleQueue, remoteCall)
						if #throttleQueue == 1 then
							task.defer(function()
								--print("RUNNING QUEUE LOOP")
								while player and player.Parent do
									local curQueue = throttleQueue[1]
									curQueue.DoFire = true
									table.remove(throttleQueue, 1)
									if #throttleQueue <= 0 then break end
									task.wait(cooldown)
								end
								--print("NO MORE CALLS IN QUEUE")
							end)
						end
					else
						remoteInfo.TotalCallsDropped += 1
						if dropDebounce then
							--print("reset time")
							remoteInfo.LastCallDropped = t
						--[[elseif #throttleQueue < maxThrottleQueue then
							print("DROP CALLED DUE TO NOT ENOUGH TIME BEING ELAPSED", t - remoteInfo.LastCallDropped)]]
						end
						throttleCallbackFunc(remoteInstance, player, remoteInfo)
						return
					end
					while not remoteCall.DoFire do 
						if not player or not player.Parent then return end
						task.wait() 
					end
					--print("FIRING FROM QUEUE")
				end
				return func(remoteInstance, player, decryptedArgs)
			end
			if remoteInstance:IsA("RemoteEvent") then
				remoteInstance.OnServerEvent:Connect(remoteFunc)
			else
				remoteInstance.OnServerInvoke = remoteFunc
			end
		end
	end
	remotesFolder:SetAttribute("Loaded", true)
end

function ModUtil:FireClient(remoteFolder: Folder, remoteName: string, plr: Player, ...)
	for _, remote in pairs(remoteFolder:GetChildren()) do
		if remote.Name ~= remoteName then continue end
		remote:FireClient(plr, ...)
	end
end

function ModUtil:FireAllClients(remoteFolder: Folder, remoteName: string, ...)
	for _, remote in pairs(remoteFolder:GetChildren()) do
		if remote.Name ~= remoteName then continue end
		remote:FireAllClients(...)
	end
end

function ModUtil:RemoveInstanceTags(instance)
	for _, tag in pairs(Collection:GetTags(instance)) do
		if tag:sub(1, 1) == "^" then
			Collection:RemoveTag(instance, tag)
		end		
	end
	for _, child in pairs(instance:GetChildren()) do
		self:RemoveInstanceTags(child)
	end
end

function ModUtil:SafeClone(instance)
	local newInstance = instance:Clone()
	self:RemoveInstanceTags(instance)
	while not shared.GiveInstanceId do task.wait() end
	shared.GiveInstanceId(newInstance)
	for _, child in pairs(newInstance:GetDescendants()) do
		shared.GiveInstanceId(child)
	end
	return newInstance
end

function ModUtil:SafeDestroy(instance, ignoreGib)
	ignoreGib = (ignoreGib or not ServerService:GetAttribute("BasesLoaded"))
	--print("SAFEDESTROYING", instance)
	if instance:IsA("Model") then
		instance:SetAttribute("IsThrow", nil)
		if not ignoreGib then
			shared.ReplicateGibs(instance)
		end
	end
	instance:Destroy()
end

function ModUtil:ShutdownServer(errorMsgToReport, kickMsg)
	if serverShutdown then return end
	warn("SHUTTING DOWN SERVER INSTANCE", tostring(kickMsg))
	if kickMsg then
		shared.ShutdownKickMessage = kickMsg
	end
	serverShutdown = true
	local players = Players:GetPlayers()
	local playerCount = #players
	for _, player in pairs(players) do
		self:Kick(player, (kickMsg or script:GetAttribute("FailedLoadKickMessage")))
	end
	if not errorMsgToReport then return end
	self:SendLog("PrivateWebhookUrl", {
		["embeds"] = {
			{
				["title"] = "SERVER INITIALIZATION ERROR",
				["description"] = `**SERVER ID: {shared.ServerId or "nil"}**`,
				["color"] = ModUtil:Color3ToDecimal(script:GetAttribute("ServerErrorLogColor")),
				["fields"] = {
					{
						["name"] = "ERROR:",
						["value"] = "`"..ModUtil:FilterArgument(errorMsgToReport, false, 500, true).."`"
					},
					{
						["name"] = "# PLAYERS ON SHUTDOWN:",
						["value"] = NumberUtil:FormatNumber(playerCount)
					}
				},
				["footer"] = {
					["text"] = os.date("%c")
				}
			},
		},
	})
	serverShutdown = "Done"
end

function ModUtil:CheckForShutdown(player)
	if not serverShutdown then return end
	self:Kick(player, script:GetAttribute("FailedLoadKickMessage"))
	return true
end

function ModUtil:KickFromBan(player, banTime, banAmount)
	local kickMsg
	if banAmount then
		local banDur = banTime + banAmount
		kickMsg = string.format(script:GetAttribute("TempBanMessage"), os.date("%x", banDur), os.date("%X", banDur)) 
	end
	ModUtil:Kick(player, kickMsg)
end

function ModUtil:FetchAttribute(attr)
	return script:GetAttribute(attr)
end

function ModUtil:IsShuttingDown()
	return serverShutdown
end

function ModUtil:GetRemoteFunctions()
	return RemoteFunctions
end

function ModUtil:GetBannedPlayers()
	return BannedPlayers
end

function ModUtil:GetQueuedWebhooks()
	return queuedWebhooks
end

return ModUtil