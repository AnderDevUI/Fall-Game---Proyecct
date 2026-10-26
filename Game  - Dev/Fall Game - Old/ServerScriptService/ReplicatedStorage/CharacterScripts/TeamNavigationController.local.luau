-- [PATH] ReplicatedStorage / CharacterScripts / TeamNavigationController @Type LocalScript
--nedder & chicken YO WTF HARD R U GOTTA SAY NEDDA
--april 23 2023
--controls all team and navigation functions such as map, compass, team markers, clan shit. etc.

--Services
local PLAYERS = game:GetService("Players")
local REPLICATED = game:GetService("ReplicatedStorage")
local USERINPUT = game:GetService("UserInputService")

-- Folders
local MODULES = REPLICATED:WaitForChild("Modules")
local Values = REPLICATED:WaitForChild("Values")

-- Modules
local GuiUtil = require(MODULES:WaitForChild("GuiUtil"))
local RaycastUtil = require(MODULES:WaitForChild("RaycastUtil"))
local NumberUtil = require(MODULES:WaitForChild("NumberUtil"))
local VectorUtil = require(MODULES:WaitForChild("VectorUtil"))

--Constants
local PLR = PLAYERS.LocalPlayer
local CHAR = (PLR.Character or script.Parent)
local HUM = CHAR:WaitForChild("Humanoid")
local ROOTPART = CHAR:WaitForChild("HumanoidRootPart")
local CAMERA = workspace.CurrentCamera
local GUI = PLR:WaitForChild("PlayerGui")
local MAINGUI = GUI:WaitForChild("Main")
local COMPASS = MAINGUI:WaitForChild("Compass")
local MAP = MAINGUI:WaitForChild("Map")
local MAP_FRAME = MAP:WaitForChild("Frame")
local MAP_CONTAINER = MAP_FRAME:WaitForChild("Map")
local PLR_MAP_CURSOR = MAP_CONTAINER:WaitForChild("PlayerCursor")
local TEAM_FRAME = MAINGUI:WaitForChild("Team")
local INVITE_UI = {TEAM_FRAME:WaitForChild("Accept"), TEAM_FRAME:WaitForChild("Decline"), TEAM_FRAME:WaitForChild("Inviter")}
local CREATE_LEAVE_TEAM = TEAM_FRAME:WaitForChild("CreateLeaveTeam")
local TEAM_LIST = TEAM_FRAME:WaitForChild("TeamList")
local TEAM_LIST_TEMPLATE = TEAM_LIST:WaitForChild("c")
local HIGHLIGHT = script:WaitForChild("Highlight")

--Controllers
local INVENTORY_CONTROLLER = CHAR:WaitForChild("InventoryController")

--Remotes
local Remotes = REPLICATED:WaitForChild("Remotes")
local TeamRemotes = Remotes:WaitForChild(string.char(149, 144, 135, 163, 152, 20, 5, 101, 129, 106, 188, 34, 14, 164, 92, 64, 3, 175, 168, 73, 101, 118, 174, 169, 173, 33, 117, 181, 149, 132))
local UpdateTeam = string.char(11, 187, 142, 116, 49, 56, 50, 81, 31, 27, 57, 140, 113, 136, 67, 76, 111, 125, 125, 28, 150, 13, 80, 62, 40, 100, 65, 91, 114, 8)

--Settings
local TEAM_LIST_Y_INCREASE = 0.03
local TEAM_RAY_CHECK_TIMER = 0.4
local TEAM_TAG_CHECK_TIMER = 0.2
local TEAM_TAG_REMOVER_CHECK = 1
local TEAM_HIGHLIGHT_RANGE = 100
local TEAM_LIST_MAX_LENGTH = 8 -- added by yours truly

-- Map Variables
local MAP_MAX_BOUNDS = 3750

--Variables
local lastRayCheck = tick()
local lastTagCheck = tick()
local lastTagRemoverCheck = tick()
local previousCamLookVector --for the compass
local compassThreshold = 45 --compass degree threshold
local compassAngleSpacing = 5 -- degrees that each compass tick is spaced by
local angleOffsets = {0, -360, 360} --angle offsets for the compass
local createLeaveBuffer = false --if this is true, don't show the create leave team button
local inTeam = false --this variable is used to determine if the user is in a team or not, the client will change this variable based on info recieved from the server
local invState = INVENTORY_CONTROLLER:GetAttribute("CurOpen") --this variable is tied to the inventory controller CurOpen attribute. Which reads the current tab open : "None", "Inventory", "Crafting"
local invite = false --This is set to false, OR a user id from the player that invited
local teamMembers = { --this table caches the users ids of your team mates
	--[[ ex:
	userid, "userid", userid, etc..
				  ^^ team leader
	]]
}
local cachedTeamModels = { --this table caches the models of your teammates
	--[[ ex:
	[userId] = model --true and false is for determining if the highlight is currently active or not
	[userId] = model
	etc..
	]]
}
local angleInformation = {
	[0] = "N";
	[45] = "NE";
	[90] = "E";
	[135] = "SE";
	[180] = "S";
	[225] = "SW";
	[270] = "W";
	[315] = "NW";
}
local nameTagSettings = {
	MaxDistance = {
		Default = 20;
		Team = 750;
	};
	TextColor3 = {
		Default = Color3.fromRGB(255, 255, 255);
		Team = Color3.fromRGB(30, 158, 255);
	};
}
local viewFilterFunc = RaycastUtil:FilterFunction("View")

--Create all frames for the compass ui
local frames = {} 
for displayAngle = 0, 355, compassAngleSpacing do
	local tickAngle = ((displayAngle - 90) - ((displayAngle - 90) > 180 and 360 or 0))
	local angleInfo = angleInformation[displayAngle]
	local templateName = nil
	if angleInfo then
		templateName = (angleInfo:len() > 1 and "TemplateMedium" or "TemplateLarge") -- angleInfo:len() is the same as string.len(angleInfo)
	end
	if not templateName then
		templateName = (displayAngle % 10 == 0 and "TemplateMedium" or (displayAngle % 5 == 0 and "TemplateSmall")) -- (displayAngle % 5 == 0 and "TemplateSmall" or nil) can just be replaced to this lol
	end
	if not templateName then continue end

	local frame = COMPASS:FindFirstChild(templateName):Clone()
	local label = frame:FindFirstChildOfClass("TextLabel")
	if label then 
		label.Text = angleInfo and angleInfo or tostring(displayAngle)
		label.TextTransparency = angleInfo and 0 or label.TextTransparency
		label.TextStrokeTransparency = angleInfo and 0.7 or label.TextStrokeTransparency
	end
	frame.Name = "Angle" .. tickAngle
	frame.BackgroundTransparency = angleInfo and 0 or frame.BackgroundTransparency
	frame.BorderColor3 = angleInfo and frame.BorderColor3 or Color3.fromRGB(132, 132, 132)
	frame.Parent = COMPASS
	table.insert(frames, frame) -- Save all the created frames into an easily-accessible table for looping through, instead of having to call :GetChildren() every time which causes unnecessary lag
end
local frameCount = #frames
local maxCompassTicksInFrame = compassThreshold * 2 / compassAngleSpacing -- Calculate the maximum amount of compass ticks that can be visible on the screen with our current settings
local maxCompassTicksNotInFrame = frameCount - maxCompassTicksInFrame

--print(frameCount, maxCompassTicksInFrame, maxCompassTicksNotInFrame)

--Functions
local function IsAlive()
	return (HUM and HUM.Parent and HUM.Health > 0)
end

local function UpdateCompass()
	local camCF = CAMERA.CFrame
	local camPos = camCF.Position
	local camLV = camCF.LookVector
	local cf = CFrame.new(camPos, camPos + Vector3.new(camLV.X, 0, camLV.Z)) -- Since the Y component messes with the LookVector, just get rid of it for calculation
	local camLookVector = cf.LookVector
	local playerMapPin = GUI:GetAttribute("PlayerMapPin")
	local isSame = (previousCamLookVector == camLookVector)
	if isSame and not playerMapPin then return end
	local camLookAngle = math.deg(math.atan2(camLookVector.Z, camLookVector.X))
	if playerMapPin then
		local pos = Vector2.new(camPos.X, camPos.Z) - playerMapPin
		local orientation = math.deg(({camCF:ToOrientation()})[2])
		local pinRot = -math.deg(math.atan2(pos.X, pos.Y)) - 90 -- + orientation
		pinRot += (pinRot < 0 and 360 or 0)
		local found = false
		for _, angleOffset in pairs(angleOffsets) do
			local offset = pinRot + angleOffset - camLookAngle
			if math.abs(offset) > compassThreshold then continue end
			--print(offset)
			COMPASS.Pin.Position = UDim2.new(0.5 + offset / (compassThreshold * 2), 0, 0.04, 0)
			found = true
			break
		end
		COMPASS.Pin.Visible = found
	end
	if isSame then return end
	previousCamLookVector = camLookVector
	local totalVisible = 0
	local foundFirst = false
	local foundAfter = false
	local skipAmount
	for index, frame in pairs(frames) do
		if totalVisible < maxCompassTicksInFrame then
			if skipAmount and skipAmount > 0 then
				skipAmount -= 1
				frame.Visible = false
				continue
			end
			local name = frame.Name
			local value = tonumber(name:sub(6)) -- you were doing some gsub bullshit when you can just grab the 6th character and onwards
			local found = foundAfter
			for _, angleOffset in pairs(angleOffsets) do -- instead of checking for -360, 0, then 360, check for 0, -360, and then 360 since the angle is more likely to not require an offset anyways
				if found == false and math.abs(camLookAngle + angleOffset - value) > compassThreshold then continue end -- More guard clausing
				--show and pos tick
				frame.Visible = true
				local lookVector = (cf * CFrame.Angles(0, math.rad(value), 0)).LookVector 
				local lookAngle = math.deg(math.atan2(lookVector.Z, lookVector.X)) * -1
				frame.Position = UDim2.new(0.5 + lookAngle / 90, 0, (frame:FindFirstChild("Label") and 0.25 or 0.125), 0) -- FindFirstChild is more efficient than FirstChildChildOfClass
				found = true
				totalVisible += 1
				break
			end
			if found then 
				if index == 1 then
					foundFirst = true
				elseif not foundFirst then
					foundAfter = true
				end
				continue 
			end
		end
		-- hide tick
		frame.Visible = false
		if foundFirst and not skipAmount then
			skipAmount = maxCompassTicksNotInFrame - 1
		end
	end
end

local function UpdateTeamMembers(newTeamTable, forceChange)
	--Update the team member frame with the info from the team variables
	local changed = false
	if #newTeamTable ~= #teamMembers then --Check if the team table has been changed by checking length
		changed = true
	else
		for index, userId in pairs(newTeamTable) do --Check if the team table has been changed by checking members, if it has, update the team member list
			if teamMembers[index] ~= userId then
				changed = true
				break
			end
		end
	end
	teamMembers = newTeamTable
	if not changed and not forceChange then return end 
	--update script attributes
	local inTeam = #teamMembers > 0
	script:SetAttribute("InTeam", inTeam)
	script:SetAttribute("CanInvite", #teamMembers >= Values.TeamSize.Value or teamMembers[1] ~= "CantLeave")
	script:SetAttribute("CanInvite", teamMembers[1] ~= "CantLeave")
	--If there was a change then clear all items in TeamList that have "Member"
	--Using the list template create all the new members and display them accordingly
	for _, listItem in pairs(TEAM_LIST:GetChildren()) do --Clear old member names
		if listItem.Name:find("Member") then
			listItem:Destroy()
		end
	end
	local index = 0
	for _, userId in pairs(teamMembers) do --Create the team mate label for each team member
		if userId == "CantLeave" then continue end
		index += 1
		local isMaxSize = (index == TEAM_LIST_MAX_LENGTH + 1)
		local isLeader = typeof(userId) == "string" and not isMaxSize
		local name
		if not isMaxSize then
			userId = tonumber(userId)
			pcall(function() 
				name = PLAYERS:GetNameFromUserIdAsync(userId)
			end)
			name = name or userId .. "_ERROR"
		else
			name = "..."
		end
		local template = TEAM_LIST_TEMPLATE:Clone()
		template.Name = "Member" .. index
		template.Position = UDim2.new(template.Position.X.Scale, 0, template.Position.Y.Scale + (0.03 * (index - 1)))
		template.Text = name
		template.TextColor3 = isLeader and template.TextColor3 or Color3.fromRGB(255,255,255) --Add a check for when the team mates are down, dead, not in the game. Change their template text color
		template.Parent = TEAM_LIST
		template.Visible = true
		if isMaxSize then break end
	end
	TEAM_LIST.Visible = (inTeam and (INVENTORY_CONTROLLER:GetAttribute("CurOpen") ~= "Crafting"))
end

local function VectorToMap(vec: Vector3|Vector2): UDim2 -- returns a UI position based on the Vector3 passed
	-- origin of 0, 0 should be equal to 0.5, 0.5
	local x = 0.5 + vec.X / (MAP_MAX_BOUNDS * 2)
	local y = 0.5 + (typeof(vec) == "Vector3" and vec.Z or vec.Y) / (MAP_MAX_BOUNDS * 2)
	return UDim2.new(x, 0, y, 0)
end

local function UDim2ToVector2(udim: UDim2)
	local x = (udim.X.Scale - 0.5) * (MAP_MAX_BOUNDS * 2)
	local y = (udim.Y.Scale - 0.5) * (MAP_MAX_BOUNDS * 2)
	return Vector2.new(x, y)
end

local teamCursors = {}
local function UpdateMapPositions(teamPositions : {}, team: {})
	--This is where we would update the team member positions on the map, aswell as your own.
	if teamPositions then --update team positions
		local found = {}
		-- Add any new players as cursors
		for index, userId in pairs(team) do
			userId = tonumber(userId)
			if not userId then continue end
			local plr = PLAYERS:GetPlayerByUserId(userId)
			if not plr then continue end
			found[userId] = true
			local dispName = plr.Name
			local cursor = teamCursors[userId]
			local newPos = teamPositions[tostring(index)]
			if newPos and not cursor then
				cursor = MAP_CONTAINER.TeamCursor:Clone()
				cursor.Name = dispName
				cursor.Parent = MAP_CONTAINER
				cursor.Visible = true
				teamCursors[userId] = cursor
			end
			if not cursor then continue end
			cursor.PlayerName.Text = dispName
			if not newPos then continue end
			cursor.Position = VectorToMap(newPos)
		end
		-- Remove any cursors that don't have a corresponding player anymore
		for userId, cursor in pairs(teamCursors) do
			if found[userId] then continue end
			cursor:Destroy()
			teamCursors[userId] = nil
		end
	end
	if ROOTPART and ROOTPART.Parent then
		--update your own position
		local rootCF = ROOTPART.CFrame
		local lookVector = rootCF.LookVector 
		local lookAngle = math.deg(math.atan2(-lookVector.Z, lookVector.X)) * -1
		PLR_MAP_CURSOR.Position = VectorToMap(rootCF.Position)
		PLR_MAP_CURSOR.Rotator.Rotation = lookAngle
	end
	PLR_MAP_CURSOR.Visible = IsAlive()
end

local function ToggleInviteUI(b: boolean)
	for _, ui in pairs(INVITE_UI) do
		ui.Visible = b
	end
end

local function ToggleMap(b: boolean)
	if MAP:GetAttribute("Locked") or (b and not Values.MapEnabled.Value) then return end
	MAP.Visible = b
	if not INVENTORY_CONTROLLER:GetAttribute("Open") or b then
		USERINPUT.MouseBehavior = Enum.MouseBehavior[b and "Default" or "LockCenter"]
		USERINPUT.MouseIconEnabled = b
	end
	script:SetAttribute("MapOpen", b)
end

-- Setup map
GuiUtil:AddScrollToFrame(MAP, 1, 4, 0.15, 1.1)

MAP.MouseButton2Down:Connect(function()
	if not script:GetAttribute("MapOpen") then return end
	local map = MAP.Frame.Map
	local mousePos = USERINPUT:GetMouseLocation() - (map.AbsolutePosition + Vector2.new(0, 36))
	local udim = UDim2.new(mousePos.X / map.AbsoluteSize.X, 0, mousePos.Y / map.AbsoluteSize.Y, 0)
	local pinVector = UDim2ToVector2(udim)
	map.Pin.Position = udim
	map.Pin.Visible = true
	GUI:SetAttribute("PlayerMapPin", pinVector)
	UpdateCompass()
end)

HUM:GetAttributeChangedSignal("AttemptRespawn"):Connect(function()
	GuiUtil:ClearScrollFrame(MAP)
end)
HUM:GetAttributeChangedSignal("Downed"):Connect(function()
	ToggleMap(false)
end)
HUM.Died:Connect(function()
	if not ROOTPART.Parent then return end
	local charPos = ROOTPART.Position
	local deathPos = Vector2.new(charPos.X, charPos.Z)
	GUI:SetAttribute("LastDeathPin", deathPos)
	local pin = MAP.Frame.Map.DeathMarker
	pin.Position = VectorToMap(deathPos)
	pin.Visible = true
end)

USERINPUT.InputBegan:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	if notProcessed or USERINPUT:GetFocusedTextBox() or inputType ~= Enum.UserInputType.Keyboard or HUM:GetAttribute("Downed") or not IsAlive() then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.G then
		ToggleMap(true)
	end
end)
USERINPUT.InputEnded:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	if inputType ~= Enum.UserInputType.Keyboard or USERINPUT:GetFocusedTextBox() then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.G then
		ToggleMap(false)
	end
end)
ToggleMap(false)

--Events
INVENTORY_CONTROLLER:GetAttributeChangedSignal("CurOpen"):Connect(function()
	--if "Inventory" then we want to move the team ui down 0.4, and figure out which buttons we want to open based on our team variables
	--if "None" then position team ui to its proper spot and hide buttons
	--if "Crafting" then hide everything
	local value = INVENTORY_CONTROLLER:GetAttribute("CurOpen")
	if value == invState then return end
	invState = value
	local showButtons = value == "Inventory"
	local inTeam = script:GetAttribute("InTeam")
	TEAM_LIST.Visible = (inTeam and (value ~= "Crafting"))
	TEAM_LIST.Position = UDim2.new(0, 0, (showButtons and 0.04 or 0), 0)
	CREATE_LEAVE_TEAM.Label.Text = inTeam and "LEAVE TEAM" or "CREATE TEAM"
	CREATE_LEAVE_TEAM.Visible = not createLeaveBuffer and showButtons
	if not invite and showButtons then return end --if no invite and trying to show buttons, return
	ToggleInviteUI(showButtons)
end)

-- Remotes
VectorUtil:SetupRemote(TeamRemotes, UpdateTeam, function(updateType : string, info : {}, teamPositions : {}, forceChange: boolean) --UpdateTeam
	if updateType == "Update" then --General team info update, updating the map, check how long its been since the last time we have fired the ray to check for our team mates behind walls, updating our teammates nametags, highlight, etc
		--info = teamTable
		UpdateTeamMembers(info, forceChange) --Update teammembers table immediatly

		if teamPositions then --if team positions exists then update their positions on the map.
			UpdateMapPositions(teamPositions, info)
		end
	elseif updateType == "Invite" then
		invite = info[1]
		local senderUserName
		pcall(function()
			senderUserName = PLAYERS:GetNameFromUserIdAsync(invite)
		end)
		senderUserName = senderUserName or invite .. "_ERROR"
		--Update the textlabel of the invite and play a sound signalling you got the invite<- TODO
		INVITE_UI[3].Text = "Join " .. senderUserName .. "'s Team"
		if INVENTORY_CONTROLLER:GetAttribute("CurOpen") ~= "Inventory" then return end
		ToggleInviteUI(true)
	end
end)

--GUI EVENT CONNECTIONS
INVITE_UI[1].MouseButton1Click:Connect(function() --ACCEPT TEAM BUTTON
	--To accept the invite, send a signal to the server, saying your user ID is accepting an invite, from the inviter.
	if not invite then return end --this shouldn't be false if theyre clicking it but oh well

	ToggleInviteUI(false)
	VectorUtil:FireRemote(TeamRemotes, UpdateTeam, { --Args are flipped on client
		[2] = "Join"; --Type
		[1] = invite; --Inviter user id
	})
	invite = false
end)

INVITE_UI[2].MouseButton1Click:Connect(function() --DECLINE TEAM BUTTON
	--To decline a team on the client, all we do is wipe the invite info on our client, and hide the invite frame, the server will delete it over time.
	invite = false
	ToggleInviteUI(false)
end)

CREATE_LEAVE_TEAM.MouseButton1Click:Connect(function() --CREATE/LEAVE TEAM BUTTON
	--CREATE/LEAVE TEAM is fired to the server using "Create/Leave" the server will determine if they are leaving, or creating the team
	createLeaveBuffer = true
	CREATE_LEAVE_TEAM.Visible = false --After they press this button, hide it for 3 seconds
	VectorUtil:FireRemote(TeamRemotes, UpdateTeam, {
		[1] = "Create/Leave" --Type
	})

	task.delay(2, function()
		createLeaveBuffer = false
		if INVENTORY_CONTROLLER:GetAttribute("CurOpen") ~= "Inventory" then return end --don't show if its not supposed to be shown
		CREATE_LEAVE_TEAM.Label.Text = #teamMembers > 0 and "LEAVE TEAM" or "CREATE TEAM"
		CREATE_LEAVE_TEAM.Visible = true
	end)
end)

-- Create map pins
local playerMapPin = GUI:GetAttribute("PlayerMapPin")
if playerMapPin then
	local pin = MAP.Frame.Map.Pin
	pin.Position = VectorToMap(playerMapPin)
	pin.Visible = true
end
local lastDeathPin = GUI:GetAttribute("LastDeathPin")
if lastDeathPin then
	local pin = MAP.Frame.Map.DeathMarker
	pin.Position = VectorToMap(lastDeathPin)
	pin.Visible = true
end

CAMERA:GetPropertyChangedSignal("CFrame"):Connect(UpdateCompass)
UpdateCompass()

-- Set player cursor name
PLR_MAP_CURSOR.PlayerName.Text = PLR.Name

--Navigation Controller Main Loop
while true do
	--Check for updates and ticks
	--\\HIGHLIGHT & NAMETAG CREATE & UPDATER\\--
	--First check is to make the highlights and name tags visible on the players
	if tick() - lastTagCheck >= TEAM_TAG_CHECK_TIMER then
		lastTagCheck = tick()
		checkRay = ((tick() - lastRayCheck) >= TEAM_RAY_CHECK_TIMER)
		TEAM_LIST.DetailLabel.TextColor3 = (PLR.Team and PLR.Team.TeamColor.Color or Color3.new(1, 1, 1))
		for _, userId in pairs(teamMembers) do
			if userId == "CantLeave" then continue end
			userId = tonumber(userId)
			if userId == PLR.UserId then continue end
			local teamMatePlayer = PLAYERS:GetPlayerByUserId(userId)
			local teamMateCharacter = teamMatePlayer and teamMatePlayer.Character
			local cachedModel = cachedTeamModels[userId] --Retrieve cached model
			if not cachedModel or cachedModel.Parent == nil then -- or cache the model and update the nametag to team, and clone the highlight
				if not teamMatePlayer or not teamMateCharacter then continue end --THE TEAMMATE IS OFFLINE/DEAD
				cachedTeamModels[userId] = teamMateCharacter
			end
			local nameTag = teamMateCharacter:FindFirstChild("NameTag")
			local highlight = teamMateCharacter:FindFirstChild("Highlight")
			if not highlight then
				highlight = HIGHLIGHT:Clone()
				highlight.Parent = teamMateCharacter
			end
			local plrTeam = (teamMatePlayer and teamMatePlayer.Team)
			local teamMateTeamColor = (plrTeam and plrTeam.TeamColor.Color)
			if teamMateTeamColor then
				highlight.FillColor = teamMateTeamColor
				highlight.OutlineColor = teamMateTeamColor
			end
			if nameTag then
				local tagLabel = nameTag:FindFirstChild("Label")
				if tagLabel then
					nameTag.MaxDistance = nameTagSettings.MaxDistance.Team
					nameTag.AlwaysOnTop = true
					nameTag.Label.TextColor3 = (teamMateTeamColor or nameTagSettings.TextColor3.Team)
				end
			end
			if checkRay then
				lastRayCheck = tick()
				local origin = CHAR:FindFirstChild("Head")
				local target = teamMateCharacter:FindFirstChild("Head")
				if not origin or not target then continue end
				--if not NumberUtil:IsWithin(target.Position, origin.Position, 1000) then highlight.Enabled = false continue end --if the distance is greater than 80, disable the highlight and continue
				local dir = target.Position - origin.Position
				local behindWall = RaycastUtil:Raycast(origin.Position, dir, "Blacklist", {CHAR, teamMateCharacter, workspace.VFX, workspace.Animals, workspace.Drops, workspace.Plants}, false, viewFilterFunc, true)
				highlight.FillTransparency = (behindWall and 0.5 or 1)
				highlight.OutlineTransparency = (behindWall and 0 or 0.5)
				highlight.Enabled = true
			end
		end
	end

	--\\HIGHLIGHT & NAMETAG REMOVER\\--
	if tick() - lastTagRemoverCheck >= TEAM_TAG_REMOVER_CHECK then
		lastTagRemoverCheck = tick()
		for userId, cachedModel in pairs(cachedTeamModels) do
			if cachedModel.Parent == nil then cachedTeamModels[userId] = nil continue end --If the cached model parent is nil, then wipe it from the cache and continue
			local leftTeam = (function()
				for _, checkingUserId in pairs(teamMembers) do
					if userId ~= tonumber(checkingUserId) then continue end
					return false
				end
				return true
			end)()
			if not leftTeam then continue end
			cachedTeamModels[userId] = nil
			local nameTag = cachedModel:FindFirstChild("NameTag")
			if nameTag then
				nameTag.MaxDistance = nameTagSettings.MaxDistance.Default
				nameTag.AlwaysOnTop = false
				local tagLabel = nameTag:FindFirstChild("Label")
				if tagLabel then
					nameTag.Label.TextColor3 = nameTagSettings.TextColor3.Default
				end
			end
			local highlight = cachedModel:FindFirstChild("Highlight")
			if highlight then highlight:Destroy() end
		end
	end

	UpdateMapPositions()
	task.wait(1/10)
end