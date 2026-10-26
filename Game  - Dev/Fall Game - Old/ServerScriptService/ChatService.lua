-- [PATH] ServerScriptService / ServerService / ChatService @Type Script
--[[
	Chat Service
	by neddleduck
	May 23rd, 2023
]]

--Services
local REPLICATED = game:GetService("ReplicatedStorage")
local STORAGE = game:GetService("ServerStorage")
local PLAYERS = game:GetService("Players")
local TEXT = game:GetService("TextService")
local CHAT = game:GetService("Chat")
local SERVERSCRIPTS = game:GetService("ServerScriptService")

-- Dependencies
local SERVERSERVICE = SERVERSCRIPTS:WaitForChild("ServerService")
local COMBATSERVICE = SERVERSCRIPTS:WaitForChild("CombatService")

--Constants

--Remotes
local REMOTES = REPLICATED:WaitForChild("Remotes")
local CHAT_REMOTES = REMOTES:WaitForChild(string.char(96, 35, 40, 91, 98, 164, 149, 39, 30, 15, 96, 175, 70, 174, 182, 135, 163, 50, 76, 163, 104, 183, 141, 3, 50, 142, 28, 14, 48, 109))
local ALL_REMOTES = {
	MESSAGE = string.char(113, 112, 81, 144, 109, 55, 138, 180, 22, 36, 121, 67, 5, 157, 74, 71, 60, 141, 148, 82, 79, 115, 10, 151, 83, 101, 91, 78, 50, 108)
}
local LoadingScreenRemote = REPLICATED:WaitForChild("LoadingScreen")

--Modules
local SHARED_MODULES = REPLICATED:WaitForChild("Modules")
local MODULES = STORAGE:WaitForChild("Modules")
local MOD_UTIL = require(MODULES:WaitForChild("ModUtil"))
local DMG_MOD = require(MODULES:WaitForChild("DamageModule"))
local ItemClass = require(SHARED_MODULES:WaitForChild("ItemClass"))
local LootTableModule = require(MODULES:WaitForChild("LootTableModule"))

-- Local Variables
local combatThread
local allKits

--functions
local function FindPlayerFromName(name: string)
	for _, player in pairs(PLAYERS:GetChildren()) do
		if player.Name:lower() == name or player.DisplayName:lower() == name then
			return player
		end
	end
end

local function SendSystemMessage(player, msg)
	if player == "SERVER" then return end
	MOD_UTIL:FireClient(CHAT_REMOTES, ALL_REMOTES.MESSAGE, player, {
		Channel = "System",
		Message = msg,
		DisplayName = "SYSTEM"
	})
end

local function ChatFunc(remote, player, args) -- :3
	local user = shared.Users[player]
	if player ~= "SERVER" and not user then return end

	local message = args[1]
	local channel = args[2] --If channel is a whisper, channel will be the players username/display name they are trying to message, it could be either or, try to find either
	if channel == "COMMAND" then
		if message == "/kill" then
			local char = player.Character
			if not char then return end
			local upperTorso = char:FindFirstChild("UpperTorso")
			if not upperTorso then return end
			DMG_MOD:Damage(upperTorso, Vector3.new(), Vector3.new(), nil, {
				Chest = 1000000;
				Bleed = 0
			}, {Start = 1000, End = 1000}, nil, nil, "Reset")
		else
			local serverType = REPLICATED.Values.ServerType.Value
			if message == "/toggleafk" and player ~= "SERVER" and serverType == "TeamCombat" then
				local isAFK = not player:GetAttribute("IgnoreTeam")
				player:SetAttribute("IgnoreTeam", isAFK)
				SendSystemMessage(player, isAFK and "You've been marked as AFK. Rerun command to undo." or "AFK setting successfully removed.")
				return
			elseif (message == "/leave" or message == "/l") and player ~= "SERVER" and serverType == "Combat" then
				if user:LeaveCombatArena() then
					SendSystemMessage(player, "Successfully left Arena.")
					local humanoid = user.Humanoid
					if humanoid and humanoid.Parent and humanoid.Health > 0 then
						humanoid.Health = 0
					end
				else
					SendSystemMessage(player, "You're currently not in an Arena.")
				end
				return
			elseif (message == "/ready" or message == "/r") and player ~= "SERVER" and serverType == "Combat" then
				local combatArena = user:IsInCombatArena(true)
				if combatArena then
					local isReady = player:GetAttribute("CombatReady")
					if combatArena:HasStarted() or isReady == "Force" then
						SendSystemMessage(player, "Round has already started.")
					else 
						isReady = not isReady
						player:SetAttribute("CombatReady", isReady)
						SendSystemMessage(player, (isReady and "Now ready. Run again to unready." or "Now unready. Run again to ready up."))
						combatArena:UpdatePlayerList()
					end
				else
					SendSystemMessage(player, "You're currently not in an Arena.")
				end
				return
			elseif (message == "/forcestart" or message == "/fs") and player ~= "SERVER" and serverType == "Combat" then
				local combatArena = user:IsInCombatArena(true)
				if combatArena then
					if combatArena.Owner == player then
						if combatArena:HasStarted() or player:GetAttribute("CombatReady") == "Force" then
							SendSystemMessage(player, "Round has already started.")
						else
							SendSystemMessage(player, "Successfully force-started the round.")
							combatArena:ReadyEveryone()
						end
					else
						SendSystemMessage(player, "You're not the owner of this Arena.")
					end
				else
					SendSystemMessage(player, "You're currently not in an Arena.")
				end
				return
			elseif (message == "/settings" or message == "/s") and player ~= "SERVER" and serverType == "Combat" then
				local combatArena = user:IsInCombatArena(true)
				if combatArena then
					if combatArena.Owner == player then
						if not allKits then
							allKits = {{}, {}}
							for index, kit in pairs(shared.WeaponKits) do
								if index > 49 then continue end
								allKits[1][index] = kit.Name
							end
							for index, kit in pairs(shared.ArmorKits) do
								allKits[2][index] = kit.Name
							end
						end
						REPLICATED.CombatServerRemote:FireClient(player, "ShowSettings", combatArena:FetchSettings(), allKits)
					else
						SendSystemMessage(player, "You're not the owner of this Arena.")
					end
				else
					SendSystemMessage(player, "You're currently not in an Arena.")
				end
			end
			if player ~= "SERVER" and MOD_UTIL:HasSpecialPrivileges(player.UserId) ~= "Owner" then return end
			if message == "/shuffle" then
				local players = PLAYERS:GetPlayers()
				local teams = {{}, {}}
				while #players > 0 do
					local n = math.random(1, #players)
					local plr = players[n]
					table.remove(players, n)
					if plr:GetAttribute("IgnoreTeam") then continue end
					local team = teams[#teams[2] < #teams[1] and 2 or 1]
					table.insert(team, plr)
				end
				for index, team in pairs(teams) do
					local teamTable = {"CantLeave"}
					shared.Teams[index] = teamTable
					for _, plr in pairs(team) do
						local usr = shared.Users[plr]
						usr.TeamIndex = index
						plr.Team = game.Teams[index == 1 and "Attackers" or "Defenders"]
						table.insert(teamTable, plr.UserId)
					end
				end
				SendSystemMessage(player, `Successfully shuffled teams into ({#teams[1]}/{#teams[2]}).`)
			elseif message == "/highlightplayers" then
				for plr, usr in pairs(shared.Users) do
					local char = plr.Character
					local team = plr.Team
					if not (char and team and usr.CombatAlive) then continue end
					local hum = char:FindFirstChild("Humanoid")
					if not (hum and hum.Health > 0) then continue end
					local highlight = Instance.new("Highlight")
					highlight.FillTransparency = 1
					highlight.Name = "CombatHighlight"
					highlight.OutlineColor = team.TeamColor.Color
					highlight.Parent = char
					highlight.Adornee = char
				end
				SendSystemMessage(player, `Showing all players still alive.`)
			elseif message == "/armorkit" then
				local kitIndex = args[3]
				local armorKit = shared.ArmorKits[kitIndex]
				if not armorKit then
					SendSystemMessage(player, "Invalid kit index.")
					return
				end
				SERVERSERVICE:SetAttribute("KitArmorIndex", kitIndex)
				SendSystemMessage(player, `Successfully set armor kit to {armorKit.Name}.`)
			elseif message == "/weaponkit" then
				local kitIndex = args[3]
				local armorKit = shared.WeaponKits[kitIndex]
				if not armorKit then
					SendSystemMessage(player, "Invalid kit index.")
					return
				end
				SERVERSERVICE:SetAttribute("KitWeaponIndex", kitIndex)
				SendSystemMessage(player, `Successfully set weapon kit to {armorKit.Name}.`)
			elseif message == "/start" and serverType == "TeamCombat" then
				if combatThread then
					task.cancel(combatThread)
				end
				local spawnParts = {}
				for _, folder in pairs(workspace.TeamSpawns:GetChildren()) do
					spawnParts[folder.Name] = folder:GetChildren()
				end
				for plr, usr in pairs(shared.Users) do
					usr.CombatAlive = nil
					if plr:GetAttribute("IgnoreTeam") then continue end
					local char = plr.Character
					if not char then continue end
					local highlight = char:FindFirstChild("CombatHighlight")
					if highlight then
						highlight:Destroy()
					end
					local team = plr.Team
					if not team then continue end
					local spawns = spawnParts[team.Name]
					local charPrim = char.PrimaryPart
					if not (charPrim and spawns) then continue end
					local hum = char:FindFirstChild("Humanoid")
					if not (hum and hum.Health > 0) then continue end
					local spawnPart = spawns[1]
					table.remove(spawns, 1)
					local spawnCFrame = spawnPart.CFrame * CFrame.new(0, 3, 0)
					usr:ToggleMovementChecks(false)
					usr:ToggleFallDamage(false)
					char:PivotTo(spawnCFrame)
					usr.Stats:SetHp(100)
					usr:ApplyKits(SERVERSERVICE:GetAttribute("KitWeaponIndex"), SERVERSERVICE:GetAttribute("KitArmorIndex"))
					usr.CombatAlive = true
					task.delay(1, function()
						if not (plr and plr.Parent) then return end
						usr:ToggleMovementChecks(true)
						usr:ToggleFallDamage(true)
					end)
				end
				for _, itemModel in pairs(workspace.Drops:GetChildren()) do
					MOD_UTIL:SafeDestroy(itemModel)
				end
				workspace.VFX.Ragdolls:ClearAllChildren()
				combatThread = task.spawn(function()
					while true do
						local alives = {0, 0}
						local totals = {{}, {}}
						for plr, usr in pairs(shared.Users) do
							local team = plr.Team
							local isAlive = usr.CombatAlive
							if isAlive == nil or not team then continue end
							local index = (team.Name == "Attackers" and 1 or (team.Name == "Defenders" and 2 or 0))
							if index == 0 then continue end
							table.insert(totals[index], usr)
							alives[index] += (isAlive and 1 or 0)
						end

						LoadingScreenRemote:FireAllClients("SetExtraText", `<font color="rgb(255, 0, 0)">TEAM 1: </font>{alives[1]}/{#totals[1]} Left | <font color="rgb(0, 0, 255)">TEAM 2: </font>{alives[2]}/{#totals[2]} Left`)
						task.wait(1)
						local teamWon
						if alives[1] == 0 and alives[2] == 0 then
							LoadingScreenRemote:FireAllClients("SetExtraText", "TIE, NO WINNERS.")
						elseif alives[2] == 0 then
							LoadingScreenRemote:FireAllClients("SetExtraText", '<font color="rgb(255, 0, 0)">TEAM 1</font> WINS!')
							teamWon = 1
						elseif alives[1] == 0 then
							LoadingScreenRemote:FireAllClients("SetExtraText", '<font color="rgb(0, 0, 255)">TEAM 2</font> WINS!')
							teamWon = 2
						else
							continue
						end
						for _, usr in pairs(totals[teamWon] or {}) do
							if not (usr and usr.Player and usr.Player.Parent) then continue end
							usr.CombatWins += 1
						end
						task.wait(10)
						LoadingScreenRemote:FireAllClients("SetExtraText", "")
						break
					end
				end)
				SendSystemMessage(player, `Combat arena match started.`)
			elseif message == "/reset" and serverType == "GunGame" then
				if combatThread then
					task.cancel(combatThread)
				end
				shared.GunGameWon = nil
				for _, itemModel in pairs(workspace.Drops:GetChildren()) do
					MOD_UTIL:SafeDestroy(itemModel)
				end
				workspace.VFX.Ragdolls:ClearAllChildren()
				for plr, usr in pairs(shared.Users) do
					plr:SetAttribute("Points", 0)
					plr:LoadCharacter()
					task.wait(1)
				end
				COMBATSERVICE:SetAttribute("WeaponHumanoidDamageMult", 1)
				combatThread = task.spawn(function()
					while not shared.GunGameWon do
						LoadingScreenRemote:FireAllClients("GunGameStats", true)
						task.wait(0.5)
					end
					COMBATSERVICE:SetAttribute("WeaponHumanoidDamageMult", 0)
					local started = tick()
					while tick() - started < 5 do
						local gunGameWon = shared.GunGameWon
						if not gunGameWon then break end
						LoadingScreenRemote:FireAllClients("SetExtraText", gunGameWon.." WON EZ!!!!!!!")
						task.wait(1)
					end
				end)
				SendSystemMessage(player, `Gun Game successfully reset.`)
			end
		end
		return
	end
	
	if player == "SERVER" then return end

	if not CHAT:CanUserChatAsync(player.UserId) then --If they can't chat, don't chat
		SendSystemMessage(player, "Failed to send message. Your account settings do not allow chatting.")
		return
	end

	-- Remove any unwanted < or > from the message
	message = message:gsub("<", ""):gsub(">", "")

	local filteredTextResult
	--filter the message
	local suc, err = pcall(function()
		local textFilter = channel == "GLOBAL" and Enum.TextFilterContext.PublicChat or Enum.TextFilterContext.PrivateChat
		filteredTextResult = TEXT:FilterStringAsync(message, player.UserId, textFilter)
	end)
	if not suc then return end

	local messageInfo = {
		Channel = channel;
		DisplayName = player.DisplayName;
		Message = message;
		Sender = player
	}

	if channel == "GLOBAL" then
		for _, loopPlayer in pairs(PLAYERS:GetChildren()) do
			local thisPlayerMessageInfo 
			local suc = pcall(function()
				thisPlayerMessageInfo = {
					Channel = messageInfo.Channel;
					DisplayName = messageInfo.DisplayName;
					Message = filteredTextResult:GetChatForUserAsync(loopPlayer.UserId);
					Sender = player;
				}
			end)
			if suc then
				MOD_UTIL:FireClient(CHAT_REMOTES, ALL_REMOTES.MESSAGE, loopPlayer, thisPlayerMessageInfo)
			end
		end
	elseif channel == "TEAM" then
		local teamIndex = user.TeamIndex
		if teamIndex == 0 then
			SendSystemMessage(player, "Failed to send message. You are not currently in a team.")
			return
		else
			local team = shared.Teams[user.TeamIndex or 0]
			if not team then return end
			for _, userId in pairs(team) do
				local plr = PLAYERS:GetPlayerByUserId(tonumber(userId))
				if not plr then continue end
				local thisPlayerMessageInfo 
				local suc = pcall(function()
					thisPlayerMessageInfo = {
						Channel = messageInfo.Channel;
						DisplayName = messageInfo.DisplayName;
						Message = filteredTextResult:GetChatForUserAsync(plr.UserId);
						Sender = player;
					}
				end)
				if suc then
					MOD_UTIL:FireClient(CHAT_REMOTES, ALL_REMOTES.MESSAGE, plr, thisPlayerMessageInfo)
				end
			end
		end
		--get the users team members, and fire to all members in the team the message, filtering the message
	elseif channel == "CLAN" then
		--if not inClan then
		SendSystemMessage(player, "Failed to send message. You are not currently in a clan.")
		return
			--end
			--get the users clan members, and fire to all the members in the clan the message, filtering the message
	else
		local sendToPlayer = FindPlayerFromName(channel)
		if sendToPlayer then
			messageInfo.DisplayName = "from " .. messageInfo.DisplayName
			messageInfo.Channel = "Whisper"
			messageInfo.Message = filteredTextResult:GetChatForUserAsync(sendToPlayer.UserId)
			MOD_UTIL:FireClient(CHAT_REMOTES, ALL_REMOTES.MESSAGE, sendToPlayer, messageInfo)
		end
	end
end

shared.ChatFunction = ChatFunc

--Remote Events
MOD_UTIL:SetupRemotes(CHAT_REMOTES, {
	[ALL_REMOTES.MESSAGE] = {
		ArgumentsIgnoreBan = {1};
		Function = ChatFunc
	}
})