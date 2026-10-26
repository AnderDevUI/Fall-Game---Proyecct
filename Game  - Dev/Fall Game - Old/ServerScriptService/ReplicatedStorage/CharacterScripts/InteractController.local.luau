-- [PATH] ReplicatedStorage / CharacterScripts / InteractController @Type LocalScript
--[[
	InteractController
	by ChickenBagelz
	August 26, 2022
	
	Handles interactivity between items in the world
]]

-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Http = game:GetService("HttpService")
local UserInput = game:GetService("UserInputService")
local Users = game:GetService("UserService")
local Marketplace = game:GetService("MarketplaceService")

-- Folders
local Drops = workspace:WaitForChild("Drops")
local Bases = workspace:WaitForChild("Bases")
local Animals = workspace:WaitForChild("Animals")
local Plants = workspace:WaitForChild("Plants")
local Vegetation = workspace:WaitForChild("Vegetation")
local Modules = Replicated:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")
local VFX_PARTS = workspace:WaitForChild("VFX")
local VFX_STORAGE = Replicated:WaitForChild("VFX")
local Values = Replicated:WaitForChild("Values")

-- Remotes
local InteractRemotes = Remotes:WaitForChild(string.char(60, 12, 5, 117, 173, 26, 48, 16, 174, 61, 181, 117, 1, 115, 39, 143, 91, 146, 18, 3, 41, 181, 157, 74, 180, 31, 46, 57, 187, 151))
local BenchRemotes = Remotes:WaitForChild(string.char(80, 174, 145, 85, 122, 27, 174, 146, 106, 51, 133, 27, 138, 20, 188, 5, 143, 181, 154, 67, 20, 136, 79, 62, 36, 5, 34, 30, 25, 108))
local BenchRemote = string.char(69, 158, 103, 31, 151, 49, 145, 49, 110, 75, 182, 63, 158, 153, 114, 34, 159, 171, 119, 72, 22, 128, 92, 190, 34, 24, 31, 56, 111, 13)
local PickupItemRemote = string.char(184, 127, 15, 56, 117, 126, 58, 170, 16, 2, 173, 153, 144, 111, 129, 51, 95, 5, 45, 1, 176, 179, 114, 21, 106, 56, 20, 17, 148, 70)
local DoLockRemote = string.char(53, 168, 9, 5, 136, 150, 150, 60, 116, 42, 80, 146, 177, 56, 86, 31, 104, 135, 126, 45, 119, 152, 98, 122, 23, 28, 138, 172, 93, 174)
local ReviveRemote = string.char(48, 1, 181, 179, 133, 46, 24, 83, 64, 116, 74, 164, 97, 3, 137, 102, 131, 185, 73, 24, 101, 9, 42, 133, 141, 93, 156, 98, 114, 28)
local FilterRemote = string.char(78, 139, 104, 169, 46, 30, 88, 175, 129, 102, 37, 38, 69, 45, 14, 97, 32, 154, 28, 163, 50, 124, 15, 110, 4, 108, 160, 180, 154, 125)
local InteractRemote = string.char(153, 1, 138, 33, 185, 173, 98, 25, 178, 72, 188, 62, 148, 105, 47, 28, 12, 37, 44, 60, 97, 24, 125, 64, 31, 166, 115, 118, 157, 127)
local DigUpRemote = string.char(58, 32, 91, 124, 39, 146, 80, 83, 118, 66, 77, 58, 136, 138, 101, 22, 1, 105, 50, 126, 30, 183, 118, 17, 42, 30, 69, 165, 15, 57)

local TeamRemotes = Remotes:WaitForChild(string.char(149, 144, 135, 163, 152, 20, 5, 101, 129, 106, 188, 34, 14, 164, 92, 64, 3, 175, 168, 73, 101, 118, 174, 169, 173, 33, 117, 181, 149, 132))
local UpdateTeam = string.char(11, 187, 142, 116, 49, 56, 50, 81, 31, 27, 57, 140, 113, 136, 67, 76, 111, 125, 125, 28, 150, 13, 80, 62, 40, 100, 65, 91, 114, 8)
local StatsRemotes = Remotes:WaitForChild(string.char(32, 175, 56, 160, 50, 187, 113, 77, 49, 22, 130, 142, 126, 38, 59, 102, 17, 6, 168, 41, 9, 180, 85, 142, 105, 14, 66, 146, 142, 126))

-- Modules
local Items = require(Modules:WaitForChild("Items"))
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"))
local TweenUtil = require(Modules:WaitForChild("TweenUtil"))
local BenchInfo = require(Modules:WaitForChild("BenchInfo"))
local ButtonClass = require(Modules:WaitForChild("ButtonClass"))
local VectorUtil = require(Modules:WaitForChild("VectorUtil"))
local VFXModule = require(Modules:WaitForChild("VFXModule"))

-- Player Variables
local Player = Players.LocalPlayer
local Character = script.Parent
local PlayerGui = Player:WaitForChild("PlayerGui")
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- Dependencies
local InventoryController = Character:WaitForChild("InventoryController")
local EquipController = Character:WaitForChild("EquipController")
local WheelController = Character:WaitForChild("WheelController")
local CameraController = Character:WaitForChild("CameraController")
local TeamNavController = Character:WaitForChild("TeamNavigationController")
local WaterController = Character:WaitForChild("WaterController")

-- Bindables
local GetSelected = script:WaitForChild("GetSelected")

-- UI
local MainGui = PlayerGui:WaitForChild("Main")
local HoverDot = MainGui:WaitForChild("Hover")
local Codelock = MainGui:WaitForChild("Codelock")
local LockControls = Codelock:WaitForChild("Controls")
local Info = VFX_STORAGE:WaitForChild("Info")
local RenameBed = MainGui:WaitForChild("RenameBed")
local RenameBox = RenameBed:WaitForChild("TextBox")
local GiveBed = MainGui:WaitForChild("GiveBed")
local GiveBox = GiveBed:WaitForChild("TextBox")
local GiveBedFound = GiveBed:WaitForChild("FoundUser")
local EditSign = MainGui:WaitForChild("EditSign")

--Settings
local INVITE_DELAY = 2
local REVIVE_TIME = 4

-- Local Variables
local selected, benchHolding, lastBench, benchEditing
local reviving = false
local revivingChar = nil
local lastInvite = tick()
local holdingInteract = false
local infoProps = {}
local currentCode = ""
local keyNamesToNum = {
	One = "1";
	Two = "2";
	Three = "3";
	Four = "4";
	Five = "5";
	Six = "6";
	Seven = "7";
	Eight = "8";
	Nine = "9";
	Zero = "0";
}
local lastRenameText = ""
local lastGiveBedId = 0
local lastWaterDrink = 0
local mousePos
local lastCodeThread
local signMaxChars
local imageLabelsPass = 667425168
local cachedImages = {}
local lastPickupItemFire = 0
local lastReviveFire = 0
local lastInteractFire = 0
local lastBenchFire = 0

-- Functions
local function GetEquipped(index)
	local containers = InventoryController.Fetch:Invoke()
	if not containers then return end
	local toolbar = containers.Toolbar
	if not toolbar then return end
	local equipped = toolbar[index or EquipController:GetAttribute("Equipped")]
	return (equipped ~= nil and equipped ~= 0 and equipped)
end

local function UpdateLock()
	local digits = currentCode:len()
	local displayCode = string.rep("* ", math.min(digits, 5))
	LockControls.Display.Code.Text = displayCode:sub(1, displayCode:len() - 1)
	if digits >= 5 then
		Replicated:SetAttribute("LastCode", currentCode:sub(1, 5))
		task.delay(0.1, ToggleLock, false)
	end
end

function ToggleLock(b)
	if b then
		currentCode = ""
		UpdateLock()
	end
	UserInput.MouseBehavior = Enum.MouseBehavior[b and "Default" or "LockCenter"]
	UserInput.MouseIconEnabled = b
	Codelock.Visible = b
	if lastCodeThread then
		task.cancel(lastCodeThread)
	end
end

local function InputKeyCode(keyName)
	if keyName == "Clear" then
		if lastCodeThread then
			task.cancel(lastCodeThread)
		end
		currentCode = ""
	elseif keyName == "Last" then
		local lastCode = Replicated:GetAttribute("LastCode")
		if lastCode then
			if lastCodeThread then
				task.cancel(lastCodeThread)
			end
			currentCode = ""
			lastCodeThread = task.spawn(function()
				for i = 1, 5 do
					currentCode = lastCode:sub(1, i)
					UpdateLock()
					task.wait(0.4)
				end
				lastCodeThread = nil
			end)
		end
	else
		if lastCodeThread then
			task.cancel(lastCodeThread)
		end
		if currentCode:len() < 5 then
			currentCode = currentCode..keyName
		end
	end
	UpdateLock()
end

local function UpdateSign()
	--print("updating sign")
	local lastPassOwned = Replicated:GetAttribute("LabelsOwned")
	local ownsPass = false
	if lastPassOwned and os.time() - lastPassOwned < 30 then
		ownsPass = true
	else
		local suc, ret = pcall(function()
			return Marketplace:UserOwnsGamePassAsync(Player.UserId, imageLabelsPass)
		end)
		if not suc then
			warn(`Client error checking for gamepass {Player.Name} {imageLabelsPass}`)
		else
			ownsPass = ret
		end
	end
	EditSign.Locked.Visible = not ownsPass
	EditSign.Unlocked.Visible = ownsPass
	EditSign.ConfirmImage.Visible = ownsPass
end

local function InteractDownFunc()
	if Codelock.Visible or not (selected and selected.Parent and not InventoryController:GetAttribute("Open")) then return end
	local isDigPile = (selected.Name == "DigPile" and selected.Parent == Vegetation)
	if selected:IsA("Terrain") then
		if tick() - lastWaterDrink < 2 then return end
		lastWaterDrink = tick()
		VectorUtil:FireRemote(InteractRemotes, InteractRemote, {
			[1] = mousePos;
			[2] = selected;
		})
	elseif isDigPile or selected:IsDescendantOf(Bases) then
		local benchInfo = BenchInfo[selected.Name]
		if holdingInteract or not (benchInfo or isDigPile) then return end
		local press = tick()
		if press - lastInteractFire < 0.125 then return end
		lastInteractFire = press
		local maxDist = (isDigPile and 10 or (benchInfo.InteractDistance or script:GetAttribute("DefaultDistance")))
		holdingInteract = true
		local bench = selected
		benchHolding = bench
		local digTime
		if isDigPile then
			digTime = VectorUtil:FireRemote(InteractRemotes, DigUpRemote, {
				[1] = bench;
				[2] = "Start";
			}, true)
			--print("starting dig client", digTime)
			if not digTime then
				holdingInteract = false
				benchHolding = nil
				return
			end
		end
		local total = 0
		local first = true
		local oldPileCF, pileTween
		local equipped = GetEquipped()
		local itemModel = false
		if equipped and equipped ~= 0 then
			local equippedInfo = Items[equipped.ID]
			if equippedInfo and (equippedInfo.MaxDurability == nil or (equipped.Durability and equipped.Durability > 0)) then
				local equippedName = equippedInfo.Name
				if equippedName == "Steel Shovel" or equippedName == "Salvaged Shovel" then
					itemModel = Character:FindFirstChild(equippedName)
				end
			end
		end
		local failedCheck
		local nextGibs = 0
		while total < (digTime or 0.4) do
			local step = Run.Heartbeat:Wait()
			failedCheck = not (holdingInteract and Character and Character.Parent and Character.PrimaryPart and Humanoid and Humanoid.Health > 0 and bench and bench.Parent and ((itemModel and itemModel.Parent) or itemModel == false))
			if failedCheck then break end
			local charPrim = Character.PrimaryPart
			local benchPrim = bench.PrimaryPart
			if InventoryController:GetAttribute("Open") or not NumberUtil:IsWithin(charPrim.Position, benchPrim.Position, maxDist) then
				total = 0
				if isDigPile then break end
			else
				total += step
			end
			if isDigPile then
				if first then
					--print("starting tween")
					HoverDot.Bar.Fill.Size = UDim2.new(0, 0, 1, 0)
					TweenUtil:Tween(HoverDot.Bar.Fill, "Size", UDim2.new(1, 0, 1, 0), digTime, "Sine", "In")
					oldPileCF = bench:GetPivot()
					script.Value.Value = oldPileCF
					pileTween = TweenUtil:Tween(script.Value, "Value", oldPileCF * CFrame.new(0, -0.75, 0), digTime, "Quart", "In")
					HoverDot.Bar.Visible = true
					benchPrim.Smoke.Enabled = true
					script:SetAttribute("Digging", true)
				elseif pileTween then
					local cf = script.Value.Value
					bench:PivotTo(cf * CFrame.new(math.random(-10, 10) / 7 * step, 0, math.random(-10, 10) / 7 * step))
					if total >= nextGibs then
						nextGibs += 0.25
						task.defer(VFXModule.CreateGibs, VFXModule, "DigGibs", cf * CFrame.Angles(math.rad(90), 0, 0), 3, 3, 0.25, 60, 60, 60, 20, 25, true)
					end
				end
			end
			first = false
			--print(total) 
		end
		if isDigPile then
			local wasHolding = holdingInteract
			holdingInteract = false
			benchHolding = nil
			HoverDot.Bar.Visible = false
			script:SetAttribute("Digging", false)
			if bench.Parent then
				bench.Dirt.Smoke.Enabled = false
				--print(bench.PrimaryPart, oldPileCF, wasHolding)
				if pileTween then
					pileTween:Cancel()
				end
				--[[if oldPileCF then
					bench:PivotTo(oldPileCF)
				end]]
				if failedCheck or total == 0 then
					--print("stopped digging client")
					VectorUtil:FireRemote(InteractRemotes, DigUpRemote, {
						[1] = bench;
						[2] = "Cancel";
					}, true)
				end
			end
			return
		end
		--print("FIRING TO SERVER")
		local wheelInfo = VectorUtil:FireRemote(InteractRemotes, BenchRemote, {
			[1] = (total >= 0.4 and 0 or 1),
			[2] = bench
		}, true)
		local renameBed = (wheelInfo == "Rename Bed")
		local giveToFriend = (wheelInfo == "Give To Friend")
		local editSign = (wheelInfo == "Edit Sign")
		if type(wheelInfo) == "table" then
			task.defer(function()
				while holdingInteract or Codelock.Visible do
					if not (bench and bench.Parent and Character and Character.Parent and Character.PrimaryPart and Humanoid and Humanoid.Health > 0 and NumberUtil:IsWithin(Character.PrimaryPart.Position, bench.PrimaryPart.Position, maxDist)) then
						WheelController.Close:Invoke("Bench")
						benchHolding = nil
						break 
					end
					task.wait()
				end
				ToggleLock(false)
				--print("client bench sanity check loop broken")
			end)
			local chosen = WheelController.Open:Invoke(wheelInfo, "Bench", true)
			local chosenInfo = wheelInfo[chosen]
			if chosenInfo and chosenInfo.Name == "Rename Bed" then
				renameBed = true
				holdingInteract = false
				benchHolding = nil
			elseif chosenInfo and chosenInfo.Name == "Give To Friend" then
				giveToFriend = true
				holdingInteract = false
				benchHolding = nil
			elseif chosenInfo and chosenInfo.Name == "Edit Sign" then
				editSign = true
				holdingInteract = false
				benchHolding = nil
			else
				--[[if chosenInfo and chosenInfo.Name == "Enter Combination" then
					chosenInfo.Name = "Open"
				end]]
				task.defer(function()
					local didCode = false
					if chosenInfo and chosenInfo.Name:find("Combination") then
						if not (bench and bench.Parent) then return end
						--print("opening codelock ui")
						didCode = true
						ToggleLock(true)
						while Codelock.Visible do
							task.wait()
						end
						--print("codelock ui closed")
					end
					local wasHoldingInteract = holdingInteract
					holdingInteract = false
					benchHolding = nil
					if not (chosen and bench and bench.Parent) then return end
					if didCode and currentCode:len() == 5 then
						--print("firing bench + code to server")
						VectorUtil:FireRemote(InteractRemotes, BenchRemote, {
							[1] = currentCode,
							[2] = chosen,
							[3] = bench
						}, true)
					elseif wasHoldingInteract then
						--print("firing bench to server")
						VectorUtil:FireRemote(InteractRemotes, BenchRemote, {
							[1] = chosen,
							[2] = bench
						}, true)
					end
				end)
			end
		else
			holdingInteract = false
			benchHolding = nil
		end
		if renameBed then
			benchEditing = bench
			RenameBed.Rename.Visible = false
			lastRenameText = (bench:GetAttribute("BedName") or "")
			RenameBox.Text = lastRenameText
			RenameBed.Visible = true
			while UserInput:IsKeyDown(Enum.KeyCode.E) and RenameBed.Visible do
				task.wait()
			end
			UserInput.MouseBehavior = Enum.MouseBehavior.Default
			UserInput.MouseIconEnabled = true
			RenameBox:CaptureFocus()
		elseif giveToFriend then
			benchEditing = bench
			GiveBedFound.Visible = false
			GiveBed.Give.Visible = false
			GiveBed.TextBox.Text = ""
			GiveBed.Visible = true
			while UserInput:IsKeyDown(Enum.KeyCode.E) and GiveBed.Visible do
				task.wait()
			end
			UserInput.MouseBehavior = Enum.MouseBehavior.Default
			UserInput.MouseIconEnabled = true
			GiveBox:CaptureFocus()
		elseif editSign then
			local guiReference = bench:FindFirstChild("GuiReference")
			local gui = (guiReference ~= nil and guiReference.Value)
			signMaxChars = bench:GetAttribute("MaxCharacters")
			if typeof(gui) == "Instance" and gui.Parent and signMaxChars then
				benchEditing = bench
				if gui.TextLabel.Visible then
					EditSign.TextBox.Text = gui.TextLabel.Text
					EditSign.Unlocked.Selected.Image = ""
					EditSign.Unlocked.TextBox.Text = ""
				else
					EditSign.TextBox.Text = ""
					local imageContent = gui.ImageLabel.Image
					local imageNumbers = imageContent:gsub("%D", "")
					local imageId = tonumber(imageNumbers)
					EditSign.Unlocked.Selected.Image = (imageId and "rbxassetid://"..imageId or "")
					EditSign.Unlocked.TextBox.Text = (imageId and tostring(imageId) or "")
				end
				UpdateSign()
				EditSign.Visible = true
				while UserInput:IsKeyDown(Enum.KeyCode.E) and EditSign.Visible do
					task.wait()
				end
				UserInput.MouseBehavior = Enum.MouseBehavior.Default
				UserInput.MouseIconEnabled = true
			end
		end
	elseif Players:FindFirstChild(selected.Name) then
		local revivedChar = Players[selected.Name].Character
		if not (revivedChar or revivedChar.Humanoid or revivedChar.Humanoid.Health > 0) then return end
		
		if revivedChar.Humanoid:GetAttribute("Downed") then --REVIVE THEM
			local press = tick()
			if press - lastReviveFire < 0.2 then return end
			lastReviveFire = press
			script:SetAttribute("Reviving", true)
			script:SetAttribute("ReviveStart", press)
			--print("REVIVE BOY")
			VectorUtil:FireRemote(StatsRemotes, ReviveRemote, {
				[1] = revivedChar;
			})
			task.delay(REVIVE_TIME, function()
				if script:GetAttribute("Reviving") then
					--check time on the interact controller make sure that its bigger than or equal to the revive time if it isnt just return
					if tick() - script:GetAttribute("ReviveStart") < REVIVE_TIME then return end
					--print("REVIVE FINISH")
					script:SetAttribute("Reviving", false)
				end
			end)
		else --INVITE TO TEAM
			if tick() - lastInvite <= INVITE_DELAY then return end
			lastInvite = tick()
			local invitedId = Players[selected.Name].UserId 
			VectorUtil:FireRemote(TeamRemotes, UpdateTeam, {
				[2] = "Invite";
				[1] = invitedId;
			})
		end
	else
		local press = tick()
		if press - lastPickupItemFire < 0.15 then return end
		lastPickupItemFire = press
		VectorUtil:FireRemote(InteractRemotes, PickupItemRemote, {selected})
	end
end

local function InteractUpFunc()
	holdingInteract = false
	WheelController.Close:Invoke("Bench")
	
	if script:GetAttribute("Reviving") then
		script:SetAttribute("Reviving", false)
		VectorUtil:FireRemote(StatsRemotes, ReviveRemote, {
			[1] = false;
		})
	end
end

local function MouseButton1DownFunc()
	local equippedIndex = EquipController:GetAttribute("Equipped")
	local equipped = GetEquipped(equippedIndex)
	if not (selected and selected.Parent and equipped and equipped.Amount > 0) then return end
	local equippedInfo = Items[equipped.ID]
	if not equippedInfo then return end
	local equippedType = equippedInfo.Type
	if equippedType ~= "Lock" then return end
	VectorUtil:FireRemote(InteractRemotes, DoLockRemote, {
		[1] = equippedIndex;
		[2] = selected;
	})
end

local function ToggleAddons(typ: string, bench: Model, lockName: string?)
	local locks = bench:FindFirstChild("Lock", true)
	if not locks then return end
	local hasLock = false
	for _, lock in pairs(locks:GetChildren()) do
		if not lock:GetAttribute("On") then continue end
		hasLock = true
		break
	end
	if hasLock then return end
	for _, lock in pairs(locks:GetChildren()) do
		for _, part in pairs(lock:GetChildren()) do
			if not part:IsA("BasePart") then continue end
			part.Color = Color3.fromRGB(0, 113, 165)
			part.Transparency = (lock.Name == lockName and 0 or 1)
		end
	end
end

local function FireBenchRemote(args)
	local press = tick()
	if press - lastBenchFire < 0.2 then return end
	lastBenchFire = press
	VectorUtil:FireRemote(InteractRemotes, BenchRemote, args, true)
	return true
end


-- Events
UserInput.InputBegan:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	local textBox = UserInput:GetFocusedTextBox()
	if textBox then return end
	if inputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		if key == Enum.KeyCode.E and not notProcessed then
			InteractDownFunc()
		elseif key == Enum.KeyCode.Tab and Codelock.Visible then
			ToggleLock(false)
		elseif Codelock.Visible then
			local num = keyNamesToNum[key.Name]
			if not num then return end
			InputKeyCode(num)
		end
	elseif inputType == Enum.UserInputType.MouseButton1 and not notProcessed then
		MouseButton1DownFunc()
	end
end)

UserInput.InputEnded:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	local textBox = UserInput:GetFocusedTextBox()
	if inputType ~= Enum.UserInputType.Keyboard or textBox or notProcessed then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.E then
		InteractUpFunc()
	end
end)

RenameBox.FocusLost:Connect(function()
	shared.LastTextBoxFocused = tick()
	local filteredText = VectorUtil:FireRemote(BenchRemotes, FilterRemote, {
		[1] = RenameBox.Text
	}, true)
	lastRenameText = filteredText
	RenameBox.Text = filteredText
	RenameBed.Rename.Visible = true
	task.wait()
	if not RenameBed.Visible then return end
	UserInput.MouseBehavior = Enum.MouseBehavior.Default
	UserInput.MouseIconEnabled = true
end)
RenameBox:GetPropertyChangedSignal("Text"):Connect(function()
	RenameBox.Text = RenameBox.Text:sub(1, 20):gsub("/", ""):gsub("`", ""):gsub([[\]], "")
	local text = RenameBox.Text
	if text:len() <= 0 or text ~= lastRenameText then
		RenameBed.Rename.Visible = false
		RenameBox.Text = text
		lastRenameText = text
	end
end)
ButtonClass.new(RenameBed.Cancel, "BackgroundColor3", function()
	task.wait()
	benchEditing = nil
	UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInput.MouseIconEnabled = false
	RenameBed.Visible = false
end, 1.5)
ButtonClass.new(RenameBed.Rename, "BackgroundColor3", function()
	task.wait()
	UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInput.MouseIconEnabled = false
	RenameBed.Visible = false
	if not (benchEditing and benchEditing.Parent) then
		benchEditing = nil
		return 
	end
	FireBenchRemote({
		[1] = RenameBox.Text,
		[2] = "Rename Bed",
		[3] = benchEditing
	})
end, 1.5)

GiveBox.FocusLost:Connect(function()
	shared.LastTextBoxFocused = tick()
	GiveBedFound.Visible = false
	GiveBed.Give.Visible = false
	local text = GiveBox.Text
	local userId = tonumber(text)
	if not userId then
		local suc, err = pcall(function()
			userId = Players:GetUserIdFromNameAsync(text)
		end)
		if not (suc and userId) then return end
	end
	
	if userId == lastGiveBedId then 
		GiveBedFound.Visible = true
		GiveBed.Give.Visible = true
		return 
	end
	local success, result = pcall(function()
		return Users:GetUserInfosByUserIdsAsync({userId})
	end)
	if not success then return end
	for _, user in pairs(result) do
		lastGiveBedId = user.Id
		GiveBedFound.DispName.Text = user.DisplayName
		GiveBedFound.UserName.Text = "@"..user.Username
		GiveBedFound.UserID.Text = "ID: "..user.Id
		local isFriend = Player:IsFriendsWith(user.Id)
		GiveBedFound.IsFriend.Text = (isFriend and "YES" or "NO")
		GiveBedFound.IsFriend.TextColor3 = GiveBedFound.IsFriend:GetAttribute("Color"..(isFriend and "Yes" or "No"))
		GiveBedFound.Visible = true
		GiveBed.Give.Visible = true
		local suc, userThumbnail = pcall(function()
			return Players:GetUserThumbnailAsync(user.Id, Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size420x420)
		end)
		GiveBedFound.Avatar.Image = (suc and userThumbnail or "")
		break
	end
	
	if not GiveBed.Visible then return end
	UserInput.MouseBehavior = Enum.MouseBehavior.Default
	UserInput.MouseIconEnabled = true
end)
GiveBox:GetPropertyChangedSignal("Text"):Connect(function()
	-- We want to filter out this textbox to only contain alphanumeric characters (underscore as well)
	local text = GiveBox.Text
	local newText = ""
	for i = 1, text:len() do
		local s = text:sub(i, i)
		local byte = s:byte()
		if not (byte == 32 or (byte >= 48 and byte <= 57) or (byte >= 65 and byte <= 90) or byte == 95 or (byte >= 97 and byte <= 122)) then continue end
		newText = newText..s
	end
	GiveBox.Text = newText
end)
ButtonClass.new(GiveBed.Cancel, "BackgroundColor3", function()
	task.wait()
	benchEditing = nil
	UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInput.MouseIconEnabled = false
	GiveBed.Visible = false
end, 1.5)
ButtonClass.new(GiveBed.Give, "BackgroundColor3", function()
	task.wait()
	UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInput.MouseIconEnabled = false
	GiveBed.Visible = false
	if not (benchEditing and benchEditing.Parent) then
		benchEditing = nil
		return 
	end
	FireBenchRemote({
		[1] = lastGiveBedId,
		[2] = "Give To Friend",
		[3] = benchEditing
	})
end, 1.5)

ButtonClass.new(EditSign.Cancel, "BackgroundColor3", function()
	--task.wait()
	benchEditing = nil
	UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInput.MouseIconEnabled = false
	EditSign.Visible = false
end, 1.5)
EditSign.TextBox.FocusLost:Connect(function()
	shared.LastTextBoxFocused = tick()
	local filteredText = VectorUtil:FireRemote(BenchRemotes, FilterRemote, {
		[1] = EditSign.TextBox.Text
	}, true)
	EditSign.TextBox.Text = filteredText or ""
end)
EditSign.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
	if not signMaxChars then return end
	local newText = EditSign.TextBox.Text:sub(1, signMaxChars):gsub("`", "")
	EditSign.TextBox.Text = newText
	EditSign.CharLimit.Text = #newText.."/"..signMaxChars
end)
EditSign.Unlocked.TextBox.FocusLost:Connect(function()
	shared.LastTextBoxFocused = tick()
	if EditSign.Unlocked.Applying.Visible then return end
	EditSign.Unlocked.Applying.Visible = true
	local currentId = EditSign.Unlocked.TextBox.Text
	local imageId = cachedImages[currentId]
	if not imageId then
		imageId = Replicated.Ping:InvokeServer("Image", currentId)
		imageId = ((imageId == 0 or imageId == "0") and "nil" or imageId)
		print(imageId)
		if imageId then
			if imageId == "nil" then
				imageId = currentId
				cachedImages[currentId] = currentId
			else
				cachedImages[currentId] = tostring(imageId)
			end
		end
	else
		print("is cached", currentId, imageId)
	end
	if imageId then
		currentId = tostring(imageId)
		currentId = (currentId == "0" and "" or currentId)
		EditSign.Unlocked.TextBox.Text = currentId
	end
	EditSign.Unlocked.Selected.Image = (currentId ~= "" and "rbxassetid://"..currentId or "")
	EditSign.Unlocked.Applying.Visible = false
end)
EditSign.Unlocked.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
	if not signMaxChars then return end
	EditSign.Unlocked.TextBox.Text = EditSign.Unlocked.TextBox.Text:sub(1, 30):gsub("%D", "")
end)
ButtonClass.new(EditSign.Locked.Buy, "BackgroundColor3", function()
	local suc, err = pcall(function()
		Marketplace:PromptGamePassPurchase(Player, imageLabelsPass)
	end)
	if not suc then
		warn(err)
	end
end, 1.5)
ButtonClass.new(EditSign.ConfirmText, "BackgroundColor3", function()
	task.wait()
	UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInput.MouseIconEnabled = false
	EditSign.Visible = false
	if not (benchEditing and benchEditing.Parent) then
		benchEditing = nil
		return 
	end
	FireBenchRemote({
		[1] = EditSign.TextBox.Text,
		[2] = "Edit Sign",
		[3] = benchEditing
	})
end, 1.5)
ButtonClass.new(EditSign.ConfirmImage, "BackgroundColor3", function()
	task.wait()
	UserInput.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInput.MouseIconEnabled = false
	EditSign.Visible = false
	if not (benchEditing and benchEditing.Parent) then
		benchEditing = nil
		return 
	end
	local imageId = EditSign.Unlocked.TextBox.Text
	FireBenchRemote({
		[1] = (tonumber(imageId) or 0),
		[2] = "Edit Sign",
		[3] = benchEditing
	})
end, 1.5)
Replicated:GetAttributeChangedSignal("LabelsOwned"):Connect(UpdateSign)

-- Bindables
GetSelected.OnInvoke = function()
	return selected
end

-- Loops :3
for _, ui in pairs(Info:GetDescendants()) do
	if not ui:IsA("GuiObject") then continue end
	local props = (ui:IsA("Frame") and {"BackgroundTransparency"} or {"TextTransparency", "TextStrokeTransparency"})
	local values = {}
	for index, prop in pairs(props) do
		values[index] = ui[prop]
	end
	infoProps[ui.Name] = {
		Properties = props;
		Values = values;
	}
end

for _, key in pairs(LockControls.Keys:GetChildren()) do
	local name = key.Name
	ButtonClass.new(key, "BackgroundColor3", function()
		InputKeyCode(name)
	end, 1.3, 1.3)
end

while task.wait(1/20) do
	local equipped = GetEquipped()
	local equippedInfo = (equipped and Items[equipped.ID])
	local equippedName = (equippedInfo and equippedInfo.Name)
	local equippedType = (equippedInfo and equippedInfo.Type)
	local hasHammer = (equipped and equipped.ID == 31)
	local did = false
	local lastSelected = selected
	local newSelected
	local isSaltWater = false
	local isDigPile = false
	if Character and Character.Parent then
		if Character.PrimaryPart and Humanoid and Humanoid.Parent and Humanoid.Health > 0 then
			local cf = Camera.CFrame--(CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame)
			local mouseHit, _mousePos, mouseNor, mouseMat = RaycastUtil:Raycast(cf.Position, cf.LookVector * 30, "Blacklist", {VFX_PARTS, Character}, false, RaycastUtil:FilterFunction("HitNoMeleeMouse"), true)
			mousePos = _mousePos
			local prim
			if mouseHit and mouseHit.Parent then
				local target = mouseHit.Parent
				local item = ((target.Parent == Drops or target.Parent == Plants or target.Parent == game) and target or target.Parent)
				local health = target:GetAttribute("Health")
				if (item.Parent == Drops or item.Parent == Plants) and item:IsA("Model") and item.PrimaryPart then
					prim = item.PrimaryPart
				elseif target:IsDescendantOf(Bases) then
					if not health then
						target = target.Parent
					end
					health = target:GetAttribute("Health")
					local maxHealth = target:GetAttribute("MaxHealth")
					local benchInfo = BenchInfo[target.Name]
					if health and maxHealth and (benchInfo == nil or benchInfo.DisplayHealthOnly == false or hasHammer or health <= maxHealth * 0.75) then
						prim = target.PrimaryPart
					end
				elseif target:IsDescendantOf(Animals) then
					if health then
						prim = target.PrimaryPart
					else
						target = target.Parent
						if target:GetAttribute("Health") then
							prim = target.PrimaryPart
						end
					end
				elseif target.Name == "DigPile" and target.Parent == Vegetation then
					prim = target.PrimaryPart
					isDigPile = true
				elseif target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 and target.Humanoid:GetAttribute("Downed") then
					prim = target.PrimaryPart
				elseif TeamNavController:GetAttribute("InTeam") and TeamNavController:GetAttribute("CanInvite") and Players:FindFirstChild(target.Name) then --TODO MAKE SURE THEY AREN'T IN UR TEAM
					prim = target.PrimaryPart
				end
			end
			if not prim then
				mouseHit, _mousePos, mouseNor, mouseMat = RaycastUtil:Raycast(cf.Position, cf.LookVector * 8, "Blacklist", {VFX_PARTS, Character}, false, RaycastUtil:FilterFunction("HitNoMeleeMouse"))
				mousePos = _mousePos
				if mouseHit and mouseHit:IsA("Terrain") and mouseMat == Enum.Material.Water and not WaterController:GetAttribute("IsSwim") then
					newSelected = mouseHit
					isSaltWater = (mousePos.Y <= 0.01)
					--[[local region = Region3.new(Vector3.new(mousePos.X - 2, -54, mousePos.Z - 2), Vector3.new(mousePos.X + 2, -46, mousePos.Z + 2)):ExpandToGrid(4)
					local materials = mouseHit:ReadVoxels(region, 4)
					for x = 1, materials.Size.X do
						for y = 1, materials.Size.Y do
							for z = 1, materials.Size.Z do
								local material = materials[x][y][z]
								if material ~= Enum.Material.CrackedLava then continue end
								isSaltWater = false
								break
							end
							if not isSaltWater then break end
						end
						if not isSaltWater then break end
					end]]
					--print(mousePos.Y)
				end
			end
			if prim then
				newSelected = prim.Parent
			end
		end
	end
	local currentBench = InventoryController.GetBench:Invoke()
	if currentBench and currentBench.Parent then
		--print("doing bench")
		newSelected = currentBench
	else
		if lastBench ~= currentBench then
			--print("removing bench holding")
			benchHolding = nil
		end
		if InventoryController:GetAttribute("Open") then
			if lastSelected and lastSelected.Parent then
				newSelected = lastSelected
			else
				newSelected = nil
			end
		elseif benchHolding and benchHolding.Parent then
			newSelected = benchHolding
		end
	end
	lastBench = currentBench
	if newSelected then
		local charPrim = Character.PrimaryPart
		if charPrim then
			if (not newSelected:IsA("Model")) or newSelected.PrimaryPart then
				local benchInfo = BenchInfo[newSelected.Name]
				local maxDist = (isDigPile and 10 or ((benchInfo and newSelected.Parent ~= Drops) and benchInfo.InteractDistance or script:GetAttribute((newSelected:IsDescendantOf(Animals) and "Animal" or "Default").."Distance")))
				--print(maxDist + math.random() / 100)
				did = NumberUtil:IsWithin((newSelected:IsA("Terrain") and mousePos or newSelected.PrimaryPart.Position), charPrim.Position, maxDist)
			end
		end
	end
	if did then
		selected = newSelected
	else
		selected = nil
	end
	if selected ~= lastSelected then
		-- Unselect
		--print("unselecting", lastSelected)
		TweenUtil:Tween(HoverDot, "ImageTransparency", 1, 0.3, "Quart", "In")
		TweenUtil:Tween(HoverDot.Action, "TextTransparency", 1, 0.3, "Quart", "In")
		if lastSelected and lastSelected.Parent then
			local highlight = lastSelected:FindFirstChild("Highlight")
			local stability = lastSelected:GetAttribute("Stability")
			if highlight then
				highlight.DepthMode = Enum.HighlightDepthMode.Occluded
				highlight:SetAttribute("Vis", false)
				--TweenUtil:Tween(highlight, {"FillTransparency", "OutlineColor", "OutlineTransparency"}, {1, (stability and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)), (stability and 1 or 0)}, 0.3, "Quart", "In")
				TweenUtil:Tween(highlight, {"FillTransparency", "OutlineTransparency"}, {1, 1}, 0.3, "Quart", "In")
				task.delay(0.31, function()
					if not (highlight and highlight.Parent and not highlight:GetAttribute("Vis")) then return end
					highlight:Destroy()
				end)
			end
			local info = lastSelected:FindFirstChild("Info")
			if info then
				for name, t in pairs(infoProps) do
					local ui = info:FindFirstChild(name, true)
					if not ui then continue end
					TweenUtil:Tween(ui, t.Properties, table.create(#t.Values, 1), 0.3, "Quart", "In")
				end
				TweenUtil:Tween(info, "StudsOffset", (info:GetAttribute("OrigOffset") or Vector3.new()), 0.3, "Quart", "In")
				task.delay(0.31, function()
					if not (info and info.Parent and info:FindFirstChild("NameLabel") and info.NameLabel.TextTransparency >= 0.99) then return end
					info:Destroy()
				end)
			end
			ToggleAddons(equippedType, lastSelected)
		end
	end
	if selected then
		-- Select
		if selected:IsA("Terrain") or isDigPile then
			HoverDot.Action.Text = (isSaltWater and "SALT WATER" or "[E] "..(isDigPile and "DIG UP PILE" or "DRINK WATER"))
			HoverDot.Image = script:GetAttribute((isSaltWater and "Unavailable" or "Default").."DotImage")
			if lastSelected ~= selected then
				TweenUtil:Tween(HoverDot, "ImageTransparency", 0, 0.2, "Quart", "Out")
				TweenUtil:Tween(HoverDot.Action, "TextTransparency", 0, 0.2, "Quart", "Out")
			end
			continue
		end
		local benchInfo = BenchInfo[selected.Name]
		local isItem = (selected ~= nil and selected.Parent == Drops)
		local isPlant = (selected ~= nil and selected.Parent == Plants)
		local isAnimal = (selected ~= nil and selected.Parent == Animals)
		local isPlayer = (selected ~= nil and Players:GetPlayerFromCharacter(selected) and not isAnimal)
		local infoPos = (selected ~= nil and (isItem and Vector3.new() or (benchInfo and benchInfo.GuiOffset or Vector3.new())))
		local info = selected:FindFirstChild("Info")
		local health = selected:GetAttribute("Health")
		local maxHealth = selected:GetAttribute("MaxHealth")
		local stability = selected:GetAttribute("Stability")
		local stabilityLoss = selected:GetAttribute("StabilityLoss")
		local highlight = selected:FindFirstChild("Highlight")
		local humanoid = selected:FindFirstChild("Humanoid")
		local hum = ((not isPlayer) and humanoid)
		local baseCabinet = RaycastUtil:GetBaseCabinetUnder(selected.PrimaryPart.Position)
		local isBuildBlocked
		if baseCabinet then
			isBuildBlocked = baseCabinet:GetAttribute("Monument")
			if not isBuildBlocked then
				local cabinetInfo = shared.ActiveBenches[baseCabinet]
				isBuildBlocked = (cabinetInfo ~= nil and cabinetInfo.Access == false)
			end
		end
		local onlyShowHealth = (isAnimal or selected.Name == "Wall Block" or (benchInfo and benchInfo.DisplayHealthOnly and not (hasHammer or isItem)))
		local showHammerOptions = (stability and hasHammer and selected.Name ~= "Wall Block" and not isBuildBlocked)
		if lastSelected ~= selected then
			--print("selecting", selected)
			TweenUtil:Tween(HoverDot, "ImageTransparency", 0, 0.2, "Quart", "Out")
			TweenUtil:Tween(HoverDot.Action, "TextTransparency", 1, 0.3, "Quart", "In")
			if not highlight then
				highlight = VFX_STORAGE.Highlight:Clone()
				highlight.OutlineColor = Color3.new(1, 1, 1)
				highlight.OutlineTransparency = 1
				highlight.Parent = selected
			end
			--TweenUtil:Tween(highlight, {"FillTransparency", "OutlineColor", "OutlineTransparency"}, {0.5, Color3.new(1, 1, 1), 0}, 0.2, "Quart", "Out")
			if not info then
				info = Info:Clone()
				for name, t in pairs(infoProps) do
					local ui = info:FindFirstChild(name, true)
					if not ui then continue end
					for _, prop in pairs(t.Properties) do
						ui[prop] = 1
					end
				end
				info.StudsOffset = infoPos - Vector3.new(0, 2, 0)
				info:SetAttribute("OrigOffset", info.StudsOffset)
				info.Parent = selected
			end
			if info then
				for name, t in pairs(infoProps) do
					local ui = info:FindFirstChild(name, true)
					if not ui then continue end
					TweenUtil:Tween(ui, t.Properties, t.Values, 0.3, "Quart", "Out")
				end
				TweenUtil:Tween(info, "StudsOffset", infoPos, 0.2, "Quart", "Out")
			end
		end
		if highlight then
			highlight.Adornee = selected
			highlight.DepthMode = Enum.HighlightDepthMode[isItem and "AlwaysOnTop" or "Occluded"]
			local vis = highlight:GetAttribute("Vis")
			if onlyShowHealth or isPlayer then
				if vis then
					--print("highlight off")
					highlight:SetAttribute("Vis", false)
					TweenUtil:Tween(highlight, {"FillTransparency", "OutlineTransparency"}, {1, 1}, 0.3, "Quart", "In")
				end
			elseif not vis then
				--print("highlight on")
				highlight:SetAttribute("Vis", true)
				TweenUtil:Tween(highlight, {"FillTransparency", "OutlineTransparency"}, {0.7, 0}, 0.2, "Quart", "Out")
			end
			local lastDamaged = selected:GetAttribute("LastDamaged")
			local highColor = ((Values.ServerTick.Value - (lastDamaged or 0) >= 60 or not hasHammer) and Color3.new(1, 1, 1) or script:GetAttribute("DamagedBenchOutlineColor"))
			highlight.FillColor = highColor
			highlight.OutlineColor = highColor
		end
		if info then
			HoverDot.Image = script:GetAttribute((selected:GetAttribute("Occupied") and "Unavailable" or "Default").."DotImage")
			local isBreakLocked = selected:GetAttribute("BreakLocked")
			local clientFunc = (benchInfo and benchInfo.ClientFunction or function() end)
			local firstAction, totalActions = clientFunc(selected)
			firstAction = (firstAction or selected:GetAttribute("FirstAction"))
			totalActions = (totalActions or selected:GetAttribute("TotalActions") or 0)
			local showPickup = (benchInfo and totalActions <= 0 and benchInfo.Type ~= "BasePart" and (benchInfo.PickupBehavior == true or (benchInfo.PickupBehavior == "HammerOnly" and hasHammer)))
			local item = ((isItem and selected:FindFirstChild("Item")) and Http:JSONDecode(selected.Item.Value))
			local actionName = (selected:GetAttribute("Armed") == true and "" or (isPlayer and ((humanoid and humanoid:GetAttribute("Downed")) and "REVIVE" or "INVITE TO TEAM") or (showHammerOptions and "REPAIR" or ((isItem or showPickup) and "PICK UP" or (isPlant and "HARVEST" or (firstAction or ""):upper())))))
			info.NameLabel.Text = ((onlyShowHealth or isPlayer) and "" or (selected.Name:find(" Trophy") and "BONE TROPHY" or selected.Name:gsub("Locked ", (isBreakLocked == false and "Unlocked " or "Locked ")):upper()) ..((item and (item.Amount or 0) > 1) and " x"..NumberUtil:FormatNumber(item.Amount) or ""))
			info.Action.Text = [[<font color="rgb(176, 176, 176)">]].."["..(isBreakLocked and "BREAK OPEN TO VIEW CONTENTS" or (stability and "MB1" or "E")).."]"..[[</font>]]..(isBreakLocked and "" or " "..actionName)
			info.Action.Visible = (actionName ~= "")
			info.Options.Text = (showHammerOptions and "HOLD [MB2] FOR MORE OPTIONS" or (totalActions > 1 and "HOLD [E] FOR MORE OPTIONS" or ""))
			info.Bar.Visible = ((hum ~= nil and hum ~= false and not selected:GetAttribute("BenchName")) or (health ~= nil and maxHealth ~= nil and maxHealth > 0)) and selected.Name ~= "Sleeper" 
			info.Adornee = (selected:FindFirstChild("Door") and selected.Door.PrimaryPart or selected.PrimaryPart)
			if info.Bar.Visible then
				local displayHealth = (health or (hum and hum.Health) or 0)
				local displayMaxHealth = (maxHealth or (hum and hum.MaxHealth) or 0)
				if displayMaxHealth ~= 0 then
					info.Bar.StatLabel.Text = NumberUtil:FormatNumber(math.ceil(displayHealth)).."/"..NumberUtil:FormatNumber(math.floor(displayMaxHealth))
					info.Bar.Fill.Size = UDim2.new(displayHealth / displayMaxHealth, 0, 1, 0)
					info.Bar.StabilityLabel.Text = ((stability and stabilityLoss) and math.ceil(math.clamp(stability - stabilityLoss, 0, 1) * 100).."% STABLE" or "")
				end
			end
		end
		ToggleAddons(equippedType, selected, ((not isBuildBlocked) and equippedName))
	end
	--print(selected) :D
end