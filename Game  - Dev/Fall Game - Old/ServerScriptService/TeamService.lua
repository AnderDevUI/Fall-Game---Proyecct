-- [PATH] ServerScriptService / ServerService / TeamService @Type Script
--Team Service
--neddleduck
--april 27 2023
--manages storing of all team data and relative team server functions

--Services
local REPLICATED = game:GetService("ReplicatedStorage")
local STORAGE = game:GetService("ServerStorage")
local PLAYERS = game:GetService("Players")

-- Folders
local Values = REPLICATED:WaitForChild("Values")

--Constants
--Settings
local INVITE_TIMER = 30 --After 30 seconds, the invite will be expired and you will no longer be able to join the team.
local INVITE_CHECK_TIMER = 6 --Time in seconds that the loop will yield for before checking the outgoing invites.
local CLIENT_UPDATE_TIMER = 2.5 --Time in seconds that the loop will fire and update the positions of the players team members to the client

--Modules
local MODULES = STORAGE:WaitForChild("Modules")
local ModUtil = require(MODULES:WaitForChild("ModUtil"))

--Remotes
local Remotes = REPLICATED.Remotes
local AllRemotes = {
	UpdateTeam = string.char(11, 187, 142, 116, 49, 56, 50, 81, 31, 27, 57, 140, 113, 136, 67, 76, 111, 125, 125, 28, 150, 13, 80, 62, 40, 100, 65, 91, 114, 8);
}
local TeamRemotes = Remotes:WaitForChild(string.char(149, 144, 135, 163, 152, 20, 5, 101, 129, 106, 188, 34, 14, 164, 92, 64, 3, 175, 168, 73, 101, 118, 174, 169, 173, 33, 117, 181, 149, 132))

--Variables
local invites = { --stores the current invites from players to another player
	--[[
		this table stores invites from players to another player.
		the invites are stored like:
		{
			{
				Time = tick() --The time the invite happened at. Used to remove old invites from the table.
				Inviter_Id = userid
				Invited_Id = userid
			}	
		}
	]]
}
--[[
--create teams table on server start 

this table uses fifo and the index of the table the user is in is stored on their user class, the funcs automatically set the ids
for the leader of a team, their userid is stored as a string, while the others are stored as numbers, the userid that is a string is the leader. There can only be one leader.
ex:
{
	[1]={userid, "userid", etc}, [2]={"userid", etc}	
}				           ^^ team leader
]]
while not shared.Teams do task.wait() end -- The server has to load any saved team data first before continuing

--Functions
function UpdateClient(user : {}, extraInfo : {}?, forceChange: boolean)
	local teamTable = shared.Teams[user.TeamIndex]
	ModUtil:FireClient(TeamRemotes, AllRemotes.UpdateTeam, user.Player, "Update", teamTable or {}, extraInfo, forceChange)
end

function UpdateTeamIndex(teamIndex : number) --updates all the users of the teamIndex
	for _, userId in pairs(shared.Teams[teamIndex]) do
		local user = shared.Users[PLAYERS:GetPlayerByUserId(userId)]
		if not user then continue end
		UpdateClient(user)
	end
end

function GetInviteIndexFromInviterUserId(inviterUserId : number)
	for index, invite in pairs(invites) do
		if invite.Inviter_Id == inviterUserId then 
			return index
		end
	end
end

function GetAvailableTeamIndex()
	local highestIndex = 0
	for index, _ in pairs(shared.Teams) do
		highestIndex = math.max(highestIndex, index)
	end
	for index = 1, highestIndex do
		local value = shared.Teams[index]
		if not value then
			return index
		end
	end
	--If this line runs, then we did not return a valid empty index, so take the highest index + 1
	return highestIndex + 1
end

function CreateTeam(user : {}) --Creates a team from user
	--Insert a table into the shared.Teams table, making the player who called the team create the leader.
	if user.TeamIndex > 0 then return end --Make sure they are not already in a team currently
	local newTeamIndex = GetAvailableTeamIndex() --Find an available index
	user.TeamIndex = newTeamIndex --Assign their new team
	local newTeam = {tostring(user.Player.UserId)}
	shared.Teams[newTeamIndex] = newTeam --Create and place the new team
end

function LeaveTeam(user : {}) --Leaves the user team
	--If the team is a team that the user cannot leave then team[1] == "CantLeave" and this function won't work
	local oldIndex = user.TeamIndex
	local teamTable = shared.Teams[oldIndex]
	local userId = user.Player.UserId
	if teamTable[1] == "CantLeave" then return end --Do not run this function and leave their team if the table is setup to "CantLeave"
	user.TeamIndex = 0 --set their index to 0
	--Writing my own table.find loop, because the userId could be a string, and then that means they were the leader, and we need to set a new leader
	local foundIndex
	local leaderLeave = false
	for index, foundUserId in pairs(teamTable) do
		local wasLeader = typeof(foundUserId) == "string"
		foundUserId = wasLeader and tonumber(foundUserId) or foundUserId
		if foundUserId ~= userId then continue end
		foundIndex = index
		leaderLeave = wasLeader
		break
	end
	table.remove(teamTable, foundIndex) -- remove them from the team table
	
	if #teamTable > 0 then 
		teamTable[1] = tostring(teamTable[1]) --assign a new leader
	else
		shared.Teams[oldIndex] = nil --otherwise delete the team
	end 
end

function CalculatePositions(user, team)
	local positions = {}
	for index, userId in pairs(team) do
		userId = tonumber(userId)
		if not userId or userId == user.UserId then continue end
		local player = PLAYERS:GetPlayerByUserId(userId)
		if not player then continue end
		local character = player.Character
		if not character then continue end
		local charPrim = character.PrimaryPart
		if not charPrim then continue end
		local charPos = charPrim.Position
		positions[tostring(index)] = Vector2.new(charPos.X, charPos.Z)
	end
	return positions
end

--Events
ModUtil:SetupRemotes(TeamRemotes, {
	[AllRemotes.UpdateTeam] = {
		Function = function(remote, player, args) --args[1] =
			local UpdateType = args[1] --"Create", "Join", or "Leave", or "Invite"
			--Ban checks
			if #args >= 3 or type(args[1]) ~= "string" or (args[1] ~= "Create/Leave" and args[1] ~= "Join" and args[1] ~= "Invite") then
				ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			
			local user = shared.Users[player]
			local plrId = player.UserId
			if not user then return end
			local teamIndex = user.TeamIndex
			
			if UpdateType == "Create/Leave" then	--Find the team the player is currently in, remove them from the team and update their client, if the team goes empty, delete the team
				--determine if create or leave
				if teamIndex > 0 then --leave team
					LeaveTeam(user, {})
					UpdateClient(user, {})
				else --create team
					CreateTeam(user)
					UpdateClient(user)
				end
			elseif UpdateType == "Invite" then
				local invitedUser = shared.Users[PLAYERS:GetPlayerByUserId(args[2])]
				if invitedUser.TeamIndex > 0 then return end --If they are in a team, return
				--An inviter can only send out one invite at a time. Find and delete their invite if they have one
				local oldInviteIndex = GetInviteIndexFromInviterUserId(plrId)
				if oldInviteIndex then
					table.remove(invites, oldInviteIndex)
				end
				
				local newInvite = { --Then create new invite and insert it and signal to the invited that they have the invite
					Time = tick();
					Inviter_Id = plrId;
					Invited_Id = args[2];
				}
				table.insert(invites, newInvite)
				ModUtil:FireClient(TeamRemotes, AllRemotes.UpdateTeam, invitedUser.Player, "Invite", {plrId})--now signal to the invited that they have the invite
			elseif UpdateType == "Join" then --Verify that the invite exists, that the inviter and invited match, if it doesnt return, if it does exist then delete the invite and insert the user into the teamindex that they are joining
				local inviter = args[2]
				local inviterPlayer = PLAYERS:GetPlayerByUserId(inviter)
				local invitedUser = shared.Users[player]
				local inviteIndex = GetInviteIndexFromInviterUserId(inviter)
				local invite = inviteIndex and invites[inviteIndex]
				local joiningTeamIndex = shared.Users[inviterPlayer].TeamIndex

				if not invite or invite.Inviter_Id ~= inviter or invite.Invited_Id ~= plrId then return end
				local team = shared.Teams[joiningTeamIndex]
				if (not team) or #team >= Values.TeamSize.Value then return end
				invitedUser.TeamIndex = joiningTeamIndex
				table.insert(shared.Teams[joiningTeamIndex], plrId) --insert the joiner into the table
				UpdateTeamIndex(joiningTeamIndex)--update all the team members team ui
			end
		end;
	};
})

--Team Service Loop
local lastInviteCheck = tick()
local lastClientUpdate = tick()
while true do
	
	if tick() - lastInviteCheck >= INVITE_CHECK_TIMER then
		lastInviteCheck = tick()
		for  index, invite in pairs(invites) do
			if tick() - invite.Time >= INVITE_TIMER then
				--delete the invite from the table after updating the invited client team to nothing
				--make sure to update the client to remove the invite from their screen
			end
		end
	end
	
	if tick() - lastClientUpdate >= CLIENT_UPDATE_TIMER then
		lastClientUpdate = tick()
		--Update clients with their teams info, this mainly exists because we need to send their team mates positions to them for the map
		for _, user in pairs(shared.Users) do
			local teamIndex = user.TeamIndex
			if teamIndex <= 0 then continue end
			local team = shared.Teams[teamIndex]
			if not team then continue end
			local positions = CalculatePositions(user, team)
			UpdateClient(user, positions, team[1] == "CantLeave")
		end
	end
	
	task.wait(0.25)
end