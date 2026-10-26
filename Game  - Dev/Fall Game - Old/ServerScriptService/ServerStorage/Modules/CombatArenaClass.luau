-- [PATH] ServerStorage / Modules / CombatArenaClass @Type ModuleScript
--[[
	CombatArenaClass
	by ChickenBagelz
	March 25, 2024
]]


-- Services
local Players = game:GetService("Players")
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage")
local Marketplace = game:GetService("MarketplaceService")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")
local CombatEssentials = Storage:WaitForChild("CombatServerEssentials")

-- Modules
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local ServerModule = require(ServerModules:WaitForChild("ServerModule"))

-- Remotes
local LoadingScreenRemote = Replicated:WaitForChild("LoadingScreen")

-- Local Variables
local teamOrder = {"Red", "Blue"}


local CombatArenaClass = {}
CombatArenaClass.__index = CombatArenaClass

function CombatArenaClass.new(arenaIndex: number, arenaType: string, lobbyJoiner: BasePart, arenaCF: CFrame, arenaNameExtra: string, isVIP: boolean, autoArena: boolean)
	local self = setmetatable({}, CombatArenaClass)

	local arena = CombatEssentials[`Arena{arenaType}`]:Clone()
	arena.Name = `Arena{arenaIndex}`
	if arenaCF then
		arena:PivotTo(arenaCF)
	end
	arena.Parent = workspace:WaitForChild("Arenas")
	self.Arena = arena
	self.SpawnParts = arena:WaitForChild("SpawnParts")

	for _, part in pairs(arena:GetDescendants()) do
		if not (part:IsA("BasePart") or part.Name == "_Floor") then continue end
		shared.GiveInstanceId(part)
	end

	self.Auto = autoArena
	self.AutoStart = false
	self.Type = arenaType
	self.Index = arenaIndex
	self.ArenaNameExtra = (arenaNameExtra or "")
	self.VIP = isVIP
	self.PlayersRed = {}
	self.PlayersBlue = {}
	self.Owner = nil
	self.CurrentWeaponKit = 25 -- Salvaged AK47
	self.CurrentArmorKit = 7 -- Steel Set
	self.WoodWallCount = 2
	self.Public = true
	self.Password = ""
	self.HealthRegen = false
	self.Status = "Waiting"
	self.WallId = 101 -- External Wooden Wall
	self.TimeLimit = nil
	self.TimeoutKickTime = 300
	self.Closed = false
	
	if autoArena then
		self.AutoStart = true
		self.WallId = 197 -- Metal Barricade
		self.WoodWallCount = 3
		self.HealthRegen = true
		
		self.WeaponCycles = {
			{26, 7}, -- AK47 Attachments 
			{24, 7}, -- AK74u Attachments
			{18, 5}, -- Python Attachments 
			{6, 3}, -- Crossy + Bow 
			{37, 7}, -- M4A1 Attachments 
			{22, 6}, -- M14 Attachments 
			{20, 5}, -- SMG Attachments 
			{7, 3}, -- Crossy + Nailgun
			{46, 8}, -- AK47 + Barrett Attachments 
			{45, 8}, -- PKM Attachments  
			{14, 4}, -- Pipe Rifle + Break Action 
			{47, 7}, -- M4A1 + Barrett Attachments
			{12, 4}, -- P250 Attachments 
			{8, 3}, -- Bow + Nailgun 
			{2, 2}, -- Spears
			{39, 5}, -- Skorpion Attachments 
		}
		self.CurrentWeaponCycle = -1
		self.WeaponCycleIndex = 1
	end
	
	self.Placeables = {}
	self.Drops = {}
	self.Fires = {}

	self.UIBlue = {}
	self.UIRed = {}

	self.LobbyJoiner = lobbyJoiner
	self.JoinerUI = lobbyJoiner:WaitForChild("List")
	lobbyJoiner.Touched:Connect(function(hit)
		if not hit or self.Closed then return end
		local character = hit.Parent
		if not character then return end
		local humanoid = character:FindFirstChild("Humanoid")
		if not (humanoid and humanoid.Health > 0) then return end
		local player = Players:GetPlayerFromCharacter(character)
		if not player then return end
		local user = shared.Users[player]
		if not user or user:IsInCombatArena() then return end
		if self.VIP and not player:GetAttribute("VIP") then
			if not self.TouchedVIP then
				user.TouchedVIP = true
				pcall(function()
					Marketplace:PromptGamePassPurchase(player, 667913153)
					task.wait(10)
					if not player.Parent then return end
					local _, ownsPass = pcall(function()
						return Marketplace:UserOwnsGamePassAsync(player.UserId, 667913153)
					end)
					if not player.Parent then return end
					if ownsPass == true then
						player:SetAttribute("VIP", true)
					end
				end)
				task.wait(5)
				user.TouchedVIP = nil
			end
			return
		end
		local totalCount, maxCount = self:GetPlayerCounts()
		if totalCount >= maxCount then return end
		user:JoinCombatArena(self)
	end)

	local redTeamTable = {"CantLeave"}
	local blueTeamTable = {"CantLeave"}
	local redTeamIndex = arenaIndex * 2 - 1
	local blueTeamIndex = arenaIndex * 2
	self.RedTeam = redTeamTable
	self.BlueTeam = blueTeamTable
	self.RedTeamIndex = redTeamIndex
	self.BlueTeamIndex = blueTeamIndex

	task.defer(function()
		while true do
			self.Status = "Waiting"
			local waitingTotal = 0
			print("WAITING FOR EVERYONE TO READY UP IN ARENA")
			while true do
				local step = task.wait(1)
				if self.AutoStart then
					self:ReadyEveryone()
				end
				local readyCounts, totalCounts = {}, {}
				for _, team in pairs(teamOrder) do
					local players = self[`Players{team}`]
					local ready = 0
					for _, player in pairs(players) do
						if not player then continue end
						player:SetAttribute("DamageDisabled", true)
						if not player:GetAttribute("CombatReady") then continue end
						ready += 1
					end
					totalCounts[team] = #players
					readyCounts[team] = ready
				end
				if (totalCounts.Red > 0 or totalCounts.Blue > 0) then
					if self.Auto then
						-- Shuffle team if teams are too unbalanced
						if math.abs(#self.PlayersRed - #self.PlayersBlue) > 1 then
							print("shuffling teams")
							self:FireLoadingScreen("SetExtraText", `TEAMS UNEVEN - SHUFFLING TEAMS`)
							self:ShuffleTeams()
							task.wait(3)
						end
					else
						waitingTotal += step
					end
				else
					waitingTotal = 0
				end
				if readyCounts.Red >= totalCounts.Red and readyCounts.Blue >= totalCounts.Blue and (totalCounts.Red > 0 and totalCounts.Blue > 0) then
					break
				end
				if waitingTotal >= self.TimeoutKickTime then
					self:CloseArena()
					waitingTotal = 0
					continue
				end
				self:FireLoadingScreen("SetExtraText", `Waiting to start - <font color="rgb(255, 0, 0)">RED: </font>{readyCounts.Red}/{totalCounts.Red} READY | <font color="rgb(0, 0, 255)">BLUE: </font>{readyCounts.Blue}/{totalCounts.Blue} READY`)
			end
			print("STARTING ARENA")
			self.Status = "Started"
			
			if self.Auto then
				-- Cycle weapons if it's an auto lobby
				local cycles = self.WeaponCycles
				self.CurrentWeaponCycle += 1
				if self.CurrentWeaponCycle >= 2 then
					self.CurrentWeaponCycle = 0
					self.WeaponCycleIndex += 1
					if self.WeaponCycleIndex > #cycles then
						self.WeaponCycleIndex = 1
					end
				end
				local currentKit = cycles[self.WeaponCycleIndex]
				self.CurrentWeaponKit = currentKit[1]
				self.CurrentArmorKit = currentKit[2]
				self:UpdateJoiner()
				print("current public kit", currentKit, self.WeaponCycleIndex, self.CurrentWeaponCycle)
			end
			
			for i = 5, 1, -1 do
				self:FireLoadingScreen("SetExtraText", `MATCH STARTING IN {i}`)
				task.wait(1)
			end
			self:ClearPlaceables()
			self:ClearDrops()
			self:ClearFires()
			self:StartMatch()
			if self.Auto then
				local totalPlayers = #self.PlayersRed + #self.PlayersBlue + 2
				self.TimeLimit = 90 + math.ceil(math.min(totalPlayers / 20, 20) * 180)
			end
			print("STARTED ARENA", self.TimeLimit)
			local doTimer = (self.TimeLimit ~= nil)
			local started = os.clock()
			while true do
				local timeLimit = (self.TimeLimit or 1)
				local timeLeft = doTimer and math.max(math.ceil(timeLimit - (os.clock() - started)), 1)
				local aliveCounts, totalCounts = {}, {}
				for _, team in pairs(teamOrder) do
					local players = self[`Players{team}`]
					local alive = 0
					local users = {}
					for _, player in pairs(players) do
						local user = shared.Users[player]
						if not user then continue end
						local isAlive = user.CombatAlive
						if isAlive == nil then continue end
						table.insert(users, user)
						alive += (isAlive and 1 or 0)
					end
					totalCounts[team] = users
					aliveCounts[team] = alive
				end

				self:FireLoadingScreen("SetExtraText", `{doTimer and NumberUtil:FormatTime(timeLeft, "Minutes", "Seconds").." " or ""}<font color="rgb(255, 0, 0)">RED: </font>{aliveCounts.Red}/{#totalCounts.Red} Alive | <font color="rgb(0, 0, 255)">BLUE: </font>{aliveCounts.Blue}/{#totalCounts.Blue} Alive`)
				task.wait(1)
				local teamWon
				if aliveCounts.Red == 0 and aliveCounts.Blue == 0 then
					self:FireLoadingScreen("SetExtraText", "TIE, NO WINNERS.")
				elseif aliveCounts.Blue == 0 then
					self:FireLoadingScreen("SetExtraText", '<font color="rgb(255, 0, 0)">RED TEAM</font> WINS!')
					teamWon = "Red"
				elseif aliveCounts.Red == 0 then
					self:FireLoadingScreen("SetExtraText", '<font color="rgb(0, 0, 255)">BLUE TEAM</font> WINS!')
					teamWon = "Blue"
				elseif doTimer and timeLeft <= 0 then
					-- Time ran out, team with most players should win
					if aliveCounts.Red == aliveCounts.Blue then
						self:FireLoadingScreen("SetExtraText", `TIME RAN OUT. GAME TIED, BOTH TEAMS EQUAL # PLAYERS ALIVE ({aliveCounts.Red} TO {aliveCounts.Blue})`)
					elseif aliveCounts.Red > aliveCounts.Blue then
						self:FireLoadingScreen("SetExtraText", `<font color="rgb(255, 0, 0)">RED TEAM</font> WINS! ({aliveCounts.Red} TO {aliveCounts.Blue})`)
						teamWon = "Red"
					elseif aliveCounts.Red < aliveCounts.Blue then
						self:FireLoadingScreen("SetExtraText", `<font color="rgb(0, 0, 255)">BLUE TEAM</font> WINS! ({aliveCounts.Red} TO {aliveCounts.Blue})`)
						teamWon = "Blue"
					end
				else
					continue
				end
				for _, user in pairs(totalCounts[teamWon] or {}) do
					if not (user and user.Player and user.Player.Parent) then continue end
					user.CombatWins += 1
					--print(user.Player, "won!")
				end
				break
			end
			print("FINISHED ARENA")
			for _, team in pairs(teamOrder) do
				local players = self[`Players{team}`]
				local ready = 0
				for _, player in pairs(players) do
					if not (player and player.Parent) then continue end
					player:SetAttribute("CombatReady", false)
					player:SetAttribute("DamageDisabled", true)
				end
			end
			self:UpdatePlayerList()
			self.Status = "Finished"
			task.wait(5)
		end
	end)
	
	self:UpdateJoiner()

	return self
end

function CombatArenaClass:FetchSettings()
	return {
		self.CurrentWeaponKit,
		self.CurrentArmorKit,
		self.WoodWallCount,
		self.Public,
		self.AutoStart,
		self.HealthRegen
	}
end

function CombatArenaClass:ApplySettings(sett, pass)
	self.CurrentWeaponKit = sett[1]
	self.CurrentArmorKit = sett[2]
	self.WoodWallCount = sett[3]
	self.Public = sett[4]
	if pass then
		self.Password = pass
	end
	
	self.AutoStart = sett[5]
	self.HealthRegen = sett[6]

	self:UpdateJoiner()
end

function CombatArenaClass:FireLoadingScreen(...)
	for _, team in pairs(teamOrder) do
		local players = self[`Players{team}`]
		for _, player in pairs(players) do
			if not (player and player.Parent) then continue end
			LoadingScreenRemote:FireClient(player, ...)
		end
	end
end

function CombatArenaClass:SendMessage(msg: string, teamOnly: string?)
	for _, team in pairs(teamOrder) do
		if teamOnly and team ~= teamOnly then continue end
		local players = self[`Players{team}`]
		for _, player in pairs(players) do
			if not (player and player.Parent) then continue end
			--print("sending msg to", player.Name, msg)
			ServerModule:SendPlayerMessage(player, msg)
		end
	end
end

function CombatArenaClass:ReadyEveryone()
	for _, team in pairs(teamOrder) do
		local players = self[`Players{team}`]
		for _, player in pairs(players) do
			if not (player and player.Parent) then continue end
			player:SetAttribute("CombatReady", "Force")
		end
	end
	self:UpdatePlayerList()
	--print("force started arena")
end

function CombatArenaClass:UpdateJoiner()
	local ui = self.JoinerUI
	local arenaType = self.Type
	local isVIP = self.VIP
	local joiner = self.LobbyJoiner
	local kit = shared.WeaponKits[self.CurrentWeaponKit]
	local totalCount, maxCount = self:GetPlayerCounts()
	
	for _, frame in pairs(ui:GetChildren()) do
		if frame.Name == "BP" or frame.Name == "RP" or frame:GetAttribute("Ignore") then continue end
		frame[frame:IsA("Frame") and "BackgroundColor3" or "TextColor3"] = (isVIP and Color3.fromRGB(255, 204, 0) or Color3.new(0, 0, 0))
	end
	ui.JoinDetail.Text = `{isVIP and "[VIP ONLY] " or ""}STEP INSIDE TO JOIN`
	
	joiner.Color = (totalCount > 0 and Color3.fromRGB(255, 89, 89) or (isVIP and Color3.fromRGB(255, 204, 0) or Color3.fromRGB(94, 226, 23)))
	
	local arenaName = `{arenaType:gsub("%d+", "")} Arena {self.ArenaNameExtra}`
	ui.Title.Text = `{arenaName}- {totalCount}/{maxCount} Players`
	ui.Status.Text = `Status: {self.Public and "PUBLIC" or "PRIVATE"}`
	ui.Kit.Text = `Current Kit: {kit.Name}`
	for _, team in pairs(teamOrder) do
		local players = self[`Players{team}`]
		local uiTeam = self[`UI{team}`]
		if #players < #uiTeam then
			for i = #players + 1, #uiTeam do
				local frame = uiTeam[i]
				uiTeam[i] = nil
				if not (frame and frame.Parent) then continue end
				frame:Destroy()
			end
		elseif #players > #uiTeam then
			for i = #uiTeam + 1, #players do
				local frame = ui[`{team:sub(1, 1)}P`]:Clone()
				frame:SetAttribute("Ignore", true)
				frame.Name = `{team}Player{i}`
				frame.Position = UDim2.new((team == "Blue" and 0.5 or 0), 0, 0.12 + (i - 1) * 0.05, 0)
				frame.Parent = ui
				frame.Visible = true
				uiTeam[i] = frame
			end
		end
		for index, frame in pairs(uiTeam) do
			local player = players[index]
			frame.Text = `<font color="rgb(0,0,0)">{index}.</font> {player ~= nil and player.Name or "[NIL]"}`
			if not player then continue end
			player:SetAttribute("ArenaName", arenaName)
		end
		--print(#players, "in list", team)
	end
	--print("updated arena list", totalCount, maxCount, self)
end

function CombatArenaClass:GetPlayerCounts(): (number, number, number, number)
	local playersR = self.PlayersRed
	local playersB = self.PlayersBlue
	local arenaType = self.Type
	local maxCount = (arenaType == "Small" and 10 or 20)
	return (#playersR + #playersB), maxCount, #playersR, #playersB
end

function CombatArenaClass:IsRestricted()
	return (not self.Public and self.Password ~= "")
end

function CombatArenaClass:AddPlayer(player: Player, user, team: string)
	if not user then
		user = shared.Users[player]
	end
	if not user then return end
	local userId = player.UserId
	if self:IsRestricted() and not team then
		if user.AttemptingPassword ~= nil then return end
		user.AttemptingPassword = false
		Replicated.CombatServerRemote:FireClient(player, "ShowPrivate")
		while player.Parent and user.AttemptingPassword == false do
			task.wait(1)
		end
		if not player.Parent then return end
		if user.AttemptingPassword == nil then -- Player canceled password input, don't add them to arena
			print("canceled password enter")
			user.CombatArenaIndex = nil
			return
		end
		user.AttemptingPassword = nil
	end
	local playersR = self.PlayersRed
	local playersB = self.PlayersBlue
	if table.find(playersR, player) or table.find(playersB, player) then return end

	--Replicated.CombatServerRemote:FireClient(player, "HidePrivate")
	player:SetAttribute("CombatReady", false)
	if not team then
		task.defer(function()
			if not player.Parent then return end
			player:LoadCharacter()
		end)
	end

	team = (team or (#playersR <= #playersB and "Red" or "Blue"))
	table.insert(self[`Players{team}`], player)
	local teamTable = self[`{team}Team`]
	local teamIndex = self[`{team}TeamIndex`]
	if not table.find(teamTable, userId) then
		table.insert(teamTable, userId)
	end
	if shared.Teams then
		shared.Teams[teamIndex] = teamTable
		--print("teamIndex", teamIndex)
	end
	user.TeamIndex = teamIndex
	player.Team = game.Teams[team == "Red" and "Attackers" or "Defenders"]
	--print("added", player, "to", team, "team")

	local owner = self.Owner
	if not self.Auto and not (owner and owner.Parent) then
		self:TransferOwnership(player)
	end

	self:UpdateJoiner()
	self:UpdatePlayerList()
end

function CombatArenaClass:ShuffleTeams()
	local allPlayers = table.clone(self.PlayersRed)
	for _, player in pairs(self.PlayersBlue) do
		table.insert(allPlayers, player)
	end
	local teams = {{}, {}}
	while #allPlayers > 0 do
		local n = math.random(1, #allPlayers)
		local player = allPlayers[n]
		table.remove(allPlayers, n)
		local index = (#teams[2] < #teams[1] and 2 or 1)
		local team = teams[index]
		table.insert(team, player)
		print("shuffle", index, player.Name)
	end
	for index, players in pairs(teams) do
		local team = teamOrder[index]
		local teamTable = {"CantLeave"}
		local teamIndex = self[`{team}TeamIndex`]
		for _, player in pairs(players) do
			local user = shared.Users[player]
			user.TeamIndex = teamIndex
			player.Team = game.Teams[team == "Red" and "Attackers" or "Defenders"]
			table.insert(teamTable, player.UserId)
			local humanoid = user.Humanoid
			if not humanoid or not humanoid.Parent or humanoid.Health <= 0 then continue end
			humanoid.Health = 0
		end
		self[`Players{team}`] = players
		self[`{team}Team`] = teamTable
		if shared.Teams then
			shared.Teams[teamIndex] = teamTable
		end
		print("SHUFFLE", index, team, teamIndex)
		print(unpack(players))
		print(unpack(teamTable))
	end
	
	self:UpdateJoiner()
	self:UpdatePlayerList()
end

function CombatArenaClass:RemovePlayer(player: Player, ignoreUpdate: boolean)
	local playersR = self.PlayersRed
	local playersB = self.PlayersBlue
	local foundRed = table.find(playersR, player)
	if foundRed then
		table.remove(playersR, foundRed)
		--print("removed", player, "from red team")
	end
	local foundBlue = table.find(playersB, player)
	if foundBlue then
		table.remove(playersB, foundBlue)
		--print("removed", player, "from blue team")
	end
	if ignoreUpdate then return end
	local owner = self.Owner
	if owner and owner == player then
		--print("original arena owner left, randomly assigning new owner")
		self:TransferOwnership()
	end
	self:UpdateJoiner()
	self:UpdatePlayerList()
end

function CombatArenaClass:UpdatePlayerList()
	local owner = self.Owner
	if not owner or not owner.Parent then return end
	local playersR = self.PlayersRed
	local playersB = self.PlayersBlue
	--print("updating player list for", owner, playersR, playersB)
	Replicated.CombatServerRemote:FireClient(owner, "PlayerList", playersR, playersB)
end

function CombatArenaClass:TransferOwnership(newOwner: Player?)
	local curOwner = self.Owner
	local playersR = self.PlayersRed
	local playersB = self.PlayersBlue
	if curOwner and curOwner == newOwner then return end
	if curOwner then
		curOwner:SetAttribute("IsArenaOwner", nil)
		self.Owner = nil
		self.Public = true
		self.Password = ""
		print("removed current arena owner and reset lobby to public")
	end
	if not (newOwner and newOwner.Parent) then
		-- Give ownership to random player (if possible)
		local totalPlayers = #playersR + #playersB
		if totalPlayers <= 0 then return end
		local chosenIndex = math.random(1, totalPlayers)
		newOwner = (chosenIndex <= #playersR and playersR[chosenIndex] or playersB[chosenIndex - #playersR])
	end
	if not newOwner then return end
	self.Owner = newOwner
	newOwner:SetAttribute("IsArenaOwner", true)
	print("set", newOwner, "as new owner")
end

function CombatArenaClass:HasStarted()
	local status = self.Status
	return (status == "Started")
end

function CombatArenaClass:StartMatch()
	local arena = self.Arena
	local weaponIndex = self.CurrentWeaponKit
	local armorIndex = self.CurrentArmorKit
	local woodWallCount = self.WoodWallCount
	for _, team in pairs(teamOrder) do
		local players = self[`Players{team}`]
		local spawns = arena[`Spawns{team}`]:GetChildren()
		for _, player in pairs(players) do
			local user = shared.Users[player]
			if not user then continue end
			local inventory = user.Inventory
			if not inventory then continue end
			local wasAlive = user.CombatAlive
			user.CombatAlive = false
			local char = player.Character
			if not char then continue end
			local highlight = char:FindFirstChild("CombatHighlight")
			if highlight then
				highlight:Destroy()
			end
			local charPrim = char.PrimaryPart
			if not charPrim then continue end
			local hum = char:FindFirstChild("Humanoid")
			if not hum and hum.Health > 0 then continue end
			local spawnPart = spawns[1]
			table.remove(spawns, 1)
			local oldCF = not wasAlive and charPrim.CFrame
			local spawnCFrame = spawnPart.CFrame * CFrame.new(0, 3, 0)
			user:ToggleMovementChecks(false)
			user:ToggleFallDamage(false)
			char:PivotTo(spawnCFrame)
			user.Stats:SetHp(100)
			user:ApplyKits(weaponIndex, armorIndex)
			if woodWallCount > 0 then
				inventory:AddItem(self.WallId, woodWallCount) -- External Wooden Wall
			end
			local attachmentConfigs = user.AttachmentConfigs
			local containers = inventory:GetInv()
			local updates = {}
			local toolbar = inventory:GetToolbar()
			for index, item in pairs(toolbar) do
				if type(item) ~= "table" then continue end
				local id = item.ID
				local configs = attachmentConfigs[id]
				if not configs then continue end
				for _, attachId in pairs(configs) do
					local has, founds = inventory:FindItem(1, {"Inventory", "Toolbar"}, {attachId})
					if not has then continue end
					local found = founds[1]
					if not found then continue end
					local containerName = found[1]
					local containerIndex = found[2]
					local container = containers[containerName]
					if not container then continue end
					local attachment = container[containerIndex]
					if type(attachment) ~= "table" then continue end
					item:AddAttachment(attachment)
					container[containerIndex] = 0
					table.insert(updates, {containerName, containerIndex, container[containerIndex]})
					--print("added saved attachment to item", item, attachment)
				end
				table.insert(updates, {"Toolbar", index, toolbar[index]})
			end
			if #updates > 0 then
				inventory:UpdateClient(unpack(updates))
			end
			user.CombatAlive = true
			player:SetAttribute("DamageDisabled", nil)
			task.delay(1, function()
				if not (player and player.Parent) then return end
				if charPrim and charPrim.Parent and oldCF then
					local curCF = charPrim.CFrame
					if curCF.Position.Y >= oldCF.Position.Y - 8 then
						warn(player.Name, "STILL ON TOP - ATTEMPTING TO TELEPORT AGAIN")
						task.wait(5)
						if not charPrim.Parent then return end
						charPrim.Parent:PivotTo(spawnCFrame)
						task.wait(1)
						if not (player and player.Parent) then return end
					end
				end
				user:ToggleMovementChecks(true)
				user:ToggleFallDamage(true)
			end)
		end
	end
end

function CombatArenaClass:ClearPlaceables()
	for _, benchModel in pairs(self.Placeables) do
		shared.Benches[benchModel] = nil
		benchModel:Destroy()
	end
	self.Placeables = {}
end

function CombatArenaClass:ClearDrops()
	for _, drop in pairs(self.Drops) do
		if not (drop and drop.Parent) then continue end
		drop:Destroy()
	end
	self.Drops = {}
end

function CombatArenaClass:ClearFires()
	for _, firePart in pairs(self.Fires) do
		if not (firePart and firePart.Parent) then continue end
		firePart:Destroy()
	end
	self.Fires = {}
end

function CombatArenaClass:CloseArena()
	print("KICKING EVERYONE FROM ARENA")
	self.Closed = true
	local suc, err = pcall(function()
		for _, team in pairs(teamOrder) do
			local players = self[`Players{team}`]
			for _, player in pairs(players) do
				local user = shared.Users[player]
				if not user then continue end
				user:LeaveCombatArena(false, false)
				local humanoid = user.Humanoid
				if humanoid and humanoid.Parent and humanoid.Health > 0 then
					humanoid.Health = 0
				end
			end
		end
	end)
	if not suc then
		warn("Error closing arena - ", err)
	end
	task.wait(3)
	self.Closed = false
end

return CombatArenaClass