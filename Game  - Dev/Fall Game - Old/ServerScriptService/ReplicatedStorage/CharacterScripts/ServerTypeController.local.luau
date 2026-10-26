-- [PATH] ReplicatedStorage / CharacterScripts / ServerTypeController @Type LocalScript
--[[
	ServerTypeController
	by ChickenBagelz
	March 25, 2024
	
	Handles different server-specific UI/functions on the client.
	Current server types it supports are:
	
	Combat
]]


-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local UserInput = game:GetService("UserInputService")

-- Folders
local Values = Replicated:WaitForChild("Values")
local Modules = Replicated:WaitForChild("Modules")

-- Modules
local ButtonClass = require(Modules:WaitForChild("ButtonClass"))
local TableUtil = require(Modules:WaitForChild("TableUtil"))

-- Player Variables
local Player = Players.LocalPlayer
local Character = script.Parent
local PlayerGui = Player:WaitForChild("PlayerGui")
local Humanoid = Character:WaitForChild("Humanoid")

-- UI Variables
local MainGui = PlayerGui:WaitForChild("Main")
local CombatFrame = MainGui:WaitForChild("CombatServer")
local Private = CombatFrame:WaitForChild("Private")
local PrivPassword: TextBox = Private:WaitForChild("Password")
local SettingFrame = CombatFrame:WaitForChild("Settings")
local Settings = SettingFrame:WaitForChild("MainFrame")
local WallInput: TextBox = Settings:WaitForChild("WallInput")
local PlayerList = Settings:WaitForChild("PlayerList")

-- Local Variables
local serverType = Values:WaitForChild("ServerType").Value
local lastPassword = os.clock()
local didKits = false
local settingVisible = false
local kitButtons = {}
local curSettings = {}
local lastSettings = {}
local kitOrder = {"Weapon", "Armor"}
local teamOrder = {"Red", "Blue"}
local lastWallText = ""
local playerListButtons = {}

-- Functions
local function HidePrivate()
	UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInput.MouseIconEnabled = false
	Private.Visible = false
	if PrivPassword:IsFocused() then
		PrivPassword:ReleaseFocus()
	end
end

local function UpdateCombatSettings(newSettings)
	for index, typ in pairs(kitOrder) do
		local kitIndex = newSettings[index]
		local frames = Settings[`{typ}Kits`]
		local frame = frames:FindFirstChild(`Kit{kitIndex}`)
		if frame then
			local button = kitButtons[frame]
			if button and not button:IsToggled() then
				task.defer(button.ToggleButton, button, true)
			end
		end
		local oldIndex = curSettings[index]
		if not oldIndex or newSettings[index] == oldIndex then continue end
		local oldFrame = frames:FindFirstChild(`Kit{oldIndex}`)
		if not oldFrame then continue end
		local oldButton = kitButtons[oldFrame]
		if not oldButton or not oldButton:IsToggled() then continue end
		task.defer(oldButton.ToggleButton, oldButton, false)
	end
	local wallCount = newSettings[3]
	Settings.WallInput.Text = tostring(wallCount)
	local isPublic = newSettings[4]
	if not isPublic and curSettings[4] then -- Was last public
		Settings.PasswordInput.Text = ""
	end
	if lastSettings[4] == false then
		Settings.PasswordExtra.Visible = true
		Settings.PasswordInput.Visible = false
	else
		Settings.PasswordExtra.Visible = false
		Settings.PasswordInput.Visible = not isPublic
	end
	
	Settings.Public.Text = `Arena Status: <font color="{ isPublic and 'rgb(0, 255, 0)">PUBLIC' or 'rgb(255, 0, 0)">PRIVATE' }</font>`
	Settings.AutoStart.Text = `Auto Start: <font color="{ newSettings[5] and 'rgb(0, 255, 0)">ON' or 'rgb(255, 0, 0)">OFF' }</font>`
	Settings.HealthRegen.Text = `Health Regen on Kill: <font color="{ newSettings[6] and 'rgb(0, 255, 0)">ON' or 'rgb(255, 0, 0)">OFF' }</font>`
	--print("updated client combat settings", newSettings, curSettings)
	if type(wallCount) == "number" and wallCount >= 0 and wallCount <= 10 and (isPublic or lastSettings[4] == isPublic or Settings.PasswordInput.Text ~= "") then
		SettingFrame.Apply.Visible = not TableUtil:CompareTables(lastSettings, newSettings)
	else
		SettingFrame.Apply.Visible = false
	end
	curSettings = newSettings
end

local function UpdateCombatPlayers(...)
	local args = {...}
	for _, button in pairs(playerListButtons) do
		button:Destroy()
	end
	playerListButtons = {}
	for _, frame in pairs(PlayerList:GetChildren()) do
		if frame.Name == "Red" or frame.Name == "Blue" then continue end
		frame:Destroy()
	end
	for index, team in pairs(teamOrder) do
		local players = args[index]
		local count = 0
		for _, player in pairs(players) do
			if not player or not player.Parent then continue end
			count += 1
			local frame = PlayerList[team]:Clone()
			frame.Name = `{team}{count}`
			frame.Label.Text = player.Name
			frame.Label.TextColor3 = (player:GetAttribute("CombatReady") and Color3.fromRGB(0, 255, 0) or Color3.new(1, 1, 1))
			frame.Position = UDim2.new((index == 1 and 0 or 0.5), 0, (count - 1) * 0.1, 0)
			frame.Parent = PlayerList
			frame.Visible = true
			table.insert(playerListButtons, ButtonClass.new(frame.Kick, "BackgroundColor3", function()
				local clock = os.clock()
				if clock - lastPassword < 2 then return end
				lastPassword = clock
				Replicated.CombatServerRemote:FireServer("PlayerList", player, "Kick")
			end, 1.3, 1.5))
			table.insert(playerListButtons, ButtonClass.new(frame.Swap, "BackgroundColor3", function()
				local clock = os.clock()
				if clock - lastPassword < 2 then return end
				lastPassword = clock
				Replicated.CombatServerRemote:FireServer("PlayerList", player, "Swap")
			end, 1.3, 1.5))
		end
	end
end

local function ToggleCombatSettings(b: boolean)
	settingVisible = b
	SettingFrame.Visible = b
	if b then
		UserInput.MouseBehavior = Enum.MouseBehavior.Default
		UserInput.MouseIconEnabled = true
	else
		UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInput.MouseIconEnabled = false
	end
end

local function UpdateCombatReady()
	local isReady = Player:GetAttribute("CombatReady")
	CombatFrame.Ready.Text = (isReady and "Ready: YES" or (isReady == false and "Ready: NO" or ""))
	CombatFrame.Ready.TextColor3 = (isReady and Color3.fromRGB(0, 255, 64) or Color3.fromRGB(255, 82, 82))
end

local function UpdateCombatOwner()
	local isOwner = Player:GetAttribute("IsArenaOwner")
	CombatFrame.IsOwner.Visible = (isOwner == true)
end

local function UpdateArenaName()
	CombatFrame.ArenaName.Text = (Player:GetAttribute("ArenaName") or "")
end

if serverType == "Combat" then
	local Remote: RemoteEvent = Replicated:WaitForChild("CombatServerRemote")
	
	PrivPassword.FocusLost:Connect(function()
		shared.LastTextBoxFocused = tick()
		if not Private.Visible then return end
		UserInput.MouseBehavior = Enum.MouseBehavior.Default
		UserInput.MouseIconEnabled = true
	end)
	PrivPassword:GetPropertyChangedSignal("Text"):Connect(function()
		local password = PrivPassword.Text:sub(1, 20)
		PrivPassword.Text = password
		Private.Enter.Visible = (password:len() > 0)
	end)
	
	ButtonClass.new(Private.Enter, "BackgroundColor3", function()
		local password = PrivPassword.Text
		local clock = os.clock()
		if password:len() <= 0 or password:len() > 20 or clock - lastPassword < 2 then return end
		lastPassword = clock
		Private.Detail.Text = "..."
		Remote:FireServer("EnterPass", password)
	end, 1.3, 1.5)
	ButtonClass.new(Private.Cancel, "BackgroundColor3", function()
		Remote:FireServer("CancelPass")
		task.wait()
		HidePrivate()
	end, 1.3, 1.5)
	
	ButtonClass.new(SettingFrame.Close, "BackgroundColor3", function()
		ToggleCombatSettings(false)
	end, 1.3, 1.5)
	
	ButtonClass.new(SettingFrame.Apply, "BackgroundColor3", function()
		if #curSettings == 0 then return end
		local clock = os.clock()
		if clock - lastPassword < 2 then return end
		lastPassword = clock
		Remote:FireServer("UpdateSettings", curSettings, Settings.PasswordInput.Text)
	end, 1.3, 1.5)
	
	ButtonClass.new(Settings.ClearWalls, "BackgroundColor3", function()
		local clock = os.clock()
		if clock - lastPassword < 2 then return end
		lastPassword = clock
		Remote:FireServer("ClearWalls")
	end, 1.3, 1.5)
	
	ButtonClass.new(Settings.ForceStart, "BackgroundColor3", function()
		Remote:FireServer("ForceStart")
	end, 1.3, 1.5)
	
	ButtonClass.new(Settings.ShuffleTeams, "BackgroundColor3", function()
		local clock = os.clock()
		if clock - lastPassword < 2 then return end
		lastPassword = clock
		Remote:FireServer("ShuffleTeams")
	end, 1.3, 1.5)
	
	ButtonClass.new(Settings.Public, "BackgroundColor3", function()
		local newSettings = table.clone(curSettings)
		newSettings[4] = not newSettings[4]
		UpdateCombatSettings(newSettings)
	end, 1.3, 1.5)
	ButtonClass.new(Settings.AutoStart, "BackgroundColor3", function()
		local newSettings = table.clone(curSettings)
		newSettings[5] = not newSettings[5]
		UpdateCombatSettings(newSettings)
	end, 1.3, 1.5)
	ButtonClass.new(Settings.HealthRegen, "BackgroundColor3", function()
		local newSettings = table.clone(curSettings)
		newSettings[6] = not newSettings[6]
		UpdateCombatSettings(newSettings)
	end, 1.3, 1.5)
	
	Settings:WaitForChild("PasswordInput"):GetPropertyChangedSignal("Text"):Connect(function()
		local password = Settings.PasswordInput.Text:sub(1, 20)
		Settings.PasswordInput.Text = password
	end)
	Settings.PasswordInput.FocusLost:Connect(function()
		shared.LastTextBoxFocused = tick()
		if not settingVisible then return end
		UserInput.MouseBehavior = Enum.MouseBehavior.Default
		UserInput.MouseIconEnabled = true
		UpdateCombatSettings(curSettings)
	end)
	
	WallInput:GetPropertyChangedSignal("Text"):Connect(function()
		local text = WallInput.Text
		if text == "" then
			lastWallText = text
			return
		end
		local count = tonumber(text)
		if not count then
			WallInput.Text = lastWallText
			return
		end
		count = tostring(math.clamp(math.floor(count), 0, 10))
		WallInput.Text = count
		lastWallText = count
	end)
	WallInput.FocusLost:Connect(function()
		shared.LastTextBoxFocused = tick()
		if not settingVisible then return end
		UserInput.MouseBehavior = Enum.MouseBehavior.Default
		UserInput.MouseIconEnabled = true
		local newCount = tonumber(WallInput.Text)
		if not newCount then return end
		local newSettings = table.clone(curSettings)
		newSettings[3] = newCount
		UpdateCombatSettings(newSettings)
	end)
	
	Remote.OnClientEvent:Connect(function(remoteType, ...)
		if remoteType == "ShowPrivate" then
			Private.Detail.Text = "THIS ARENA IS PRIVATED WITH A PASSWORD. PLEASE ENTER IT TO JOIN:"
			Private.Password.Text = ""
			UserInput.MouseBehavior = Enum.MouseBehavior.Default
			UserInput.MouseIconEnabled = true
			Private.Visible = true
			--PrivPassword:CaptureFocus()
		elseif remoteType == "HidePrivate" then
			HidePrivate()
		elseif remoteType == "ChangeTextPrivate" then
			local text = ...
			Private.Detail.Text = text
		elseif remoteType == "ShowSettings" then
			local newSettings, allKits = ...
			if type(allKits) == "table" and not didKits then
				didKits = true
				for index, typ in pairs(kitOrder) do
					local frames = Settings[`{typ}Kits`]
					for i = 1, #allKits[index] do
						local frame = (i == 1 and frames.Kit1)
						if not frame then
							frame = frames.Kit1:Clone()
							frame.Name = `Kit{i}`
							frame.Parent = frames
							frame.Visible = true
						end
						frame.Text = allKits[index][i]
						kitButtons[frame] = ButtonClass.new(frame, "BackgroundColor3", function()
							if #curSettings == 0 then return end
							local newSettings = table.clone(curSettings)
							newSettings[index] = i
							UpdateCombatSettings(newSettings)
						end, 1.3, Color3.fromRGB(0, 83, 127))
					end
				end
			end
			if didKits and newSettings and #curSettings == 0 then
				lastSettings = table.clone(newSettings)
				UpdateCombatSettings(newSettings)
			end
			ToggleCombatSettings(not settingVisible)
		elseif remoteType == "UpdateSettings" then
			local newSettings = ...
			if type(newSettings) ~= "table" then return end
			lastSettings = table.clone(newSettings)
			UpdateCombatSettings(newSettings)
		elseif remoteType == "PlayerList" then
			local redTeam, blueTeam = ...
			--print("updated player list")
			if not redTeam or not blueTeam then return end
			UpdateCombatPlayers(redTeam, blueTeam)
		end
	end)
	
	Player:GetAttributeChangedSignal("CombatReady"):Connect(UpdateCombatReady)
	Player:GetAttributeChangedSignal("IsArenaOwner"):Connect(UpdateCombatOwner)
	Player:GetAttributeChangedSignal("ArenaName"):Connect(UpdateArenaName)
	
	Remote:FireServer("FetchPlayerList")
	
	UpdateCombatReady()
	UpdateCombatOwner()
	UpdateArenaName()
	ToggleCombatSettings(false)
	CombatFrame.Visible = true
end