-- [PATH] ReplicatedStorage / CharacterScripts / StatsController @Type LocalScript
--[[
	StatsController
	by neddleduck
	August 28th, 2022
	
	Controls the display of stats and effects
	This script holds a table of recent pickups, and manages all the logic here after recieving the signal from the server that something has been picked up
	
	This script could possibly be optimized by removing the pickup while loop and instead running the loop in the numberutil :GetRemote() function on each individual item when its added, breaking the loop if the number were to change
]]

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local UserInput = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- Folders
local Modules = Replicated:WaitForChild("Modules")

-- Modules
local Items = require(Modules:WaitForChild("Items"))
local TweenUtil = require(Modules:WaitForChild("TweenUtil"))
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))
local Thread = require(Modules:WaitForChild("Thread"))
local StatusClass = require(Modules:WaitForChild("StatusClass"))
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"))
local ViewportModule = require(Modules:WaitForChild("ViewportModule"))
local VectorUtil = require(Modules:WaitForChild("VectorUtil"))

--Constants
local BLUR = Lighting:WaitForChild("Blur")
local COLOR_CORRECTION = Lighting:WaitForChild("ColorCorrection")
local RAY_PARTS_TABLE = workspace:WaitForChild("RayParts"):GetChildren()
local RADIATION_SND = script:WaitForChild("Radiation")
local BINDABLE_CRAFTUPDATE = script:WaitForChild("CraftUpdate")

--Remotes
local Remotes = Replicated:WaitForChild("Remotes")
local StatsRemotes = Remotes:WaitForChild(string.char(32, 175, 56, 160, 50, 187, 113, 77, 49, 22, 130, 142, 126, 38, 59, 102, 17, 6, 168, 41, 9, 180, 85, 142, 105, 14, 66, 146, 142, 126))
local SendStats = string.char(79, 32, 52, 90, 156, 106, 154, 4, 122, 24, 35, 31, 152, 159, 32, 108, 184, 86, 28, 97, 6, 28, 22, 147, 8, 79, 15, 125, 32, 45)
local Pickup = string.char(131, 48, 148, 184, 91, 1, 106, 50, 100, 47, 39, 105, 95, 145, 161, 7, 93, 92, 85, 49, 70, 28, 166, 135, 74, 145, 82, 20, 88, 34)
local Water = string.char(25, 141, 109, 85, 1, 134, 137, 157, 3, 109, 2, 47, 181, 57, 77, 112, 41, 63, 96, 115, 40, 137, 186, 27, 117, 124, 179, 47, 119, 28);

-- Player Variables
local Player = Players.LocalPlayer
local Character = script.Parent
local PlayerGui = Player:WaitForChild("PlayerGui")
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- UI
--stats ui
local MainGui = PlayerGui:WaitForChild("Main")
local StatsFrame = MainGui:WaitForChild("Stats")
local HealthFrame = StatsFrame:WaitForChild("Health")
local HungerFrame = StatsFrame:WaitForChild("Hunger")
local ThirstFrame = StatsFrame:WaitForChild("Thirst")

--Inv ui
local INVENTORY = MainGui:WaitForChild("Inventory")
local ARMOR_FRAME = INVENTORY:WaitForChild("Armor")
local VIEWPORT_FRAME = ARMOR_FRAME:WaitForChild("ViewportFrame")
local VP_HITBOX_HEAD = ARMOR_FRAME:WaitForChild("HitboxHead")
local VP_HITBOX_CHEST = ARMOR_FRAME:WaitForChild("HitboxChest")
local VP_HITBOX_LEGS = ARMOR_FRAME:WaitForChild("HitboxLegs")
local BULLET_BARS = ARMOR_FRAME:WaitForChild("BulletBars")
local BULLET_DETAIL = ARMOR_FRAME:WaitForChild("BulletDetail")
local MELEE_BARS = ARMOR_FRAME:WaitForChild("MeleeBars")
local MELEE_DETAIL = ARMOR_FRAME:WaitForChild("MeleeDetail")

--Status Effects Container
local StatusEffects = StatusClass.new()

-- Settings
local PICKUP_LOOP_COOLDOWN = 0.5 --Time in seconds the while loop will pause each iteration
local PICKUP_LIFETIME = 5 --Time in seconds it takes for the pickup UI to be destroyed
local PICKUP_COOLDOWN = 0.2 --Time in seconds it takes for the next pickup to appear in the stats ui
local STAT_NUM_UPD_TIME = 0.06
local STAT_NUM_LERP_PERC = 0.45
local statMax = {
	Health = 100;
	Hunger = 100;
	Thirst = 100;
	Bleeding = 100;
	Radiation = 499;
	Comfort = 100;
	Wet = 100;
	Temperature = 40;
}
local statSettings = {
	--Name = {icon, color}
	--Remove = a string that will be removed the stat name
	--Name = a hard coded name that the stat will use, unless the name is Craft then it won't update the name, it will use the one created by the event
	BCAccess = {
		Color = Color3.fromRGB(89, 148, 64);
		Name = "Building Privilege"
	};
	BCDenied = {
		Color = Color3.fromRGB(255, 66, 69);
		Name = "Building Blocked"
	};
	Safezone = {
		Color = Color3.fromRGB(89, 148, 64);
		Name = "Safezone!"
	};
	Recipes = {
		Color = Color3.fromRGB(89, 148, 64);
		Name = "Recipes Available"
	};
	Comfort = {
		Color = Color3.fromRGB(89, 148, 64);
	};
	Craft = {
		Color = Color3.fromRGB(89, 148, 64);
		Name = "Craft"
	};
	Wet = {
		Color = Color3.fromRGB(255, 66, 69);
	};
	Drowning = {
		Color = Color3.fromRGB(255, 66, 69);
	};
	Temperature = {
		Color = Color3.fromRGB(255, 66, 69);
	};
	Bleed = {
		Color = Color3.fromRGB(255, 66, 69);
		Name = "Bleeding"
	};
	Radiation = {
		Color = Color3.fromRGB(182, 179, 89);
	};
	Pickup = {
		Color = Color3.fromRGB(89, 148, 64);
		Remove = "Pickup";
	};
	Drop = {
		Color = Color3.fromRGB(255, 94, 0);
		Remove = "Drop";
	};
	Decay = {
		Color = Color3.fromRGB(255, 94, 0);
		Name = "Building Decaying!";
	};
}
local statEffectSettings = {
	Radiation = {
		BlurSize = 8;
		ColorCorrectionLowest = 83;
	};
	Health = {
		BlurSize = 4;
		ColorCorrectionLowest = 83;
	};
}

--Variables
local lastRadCheck = tick()
local lastPickupInsert = tick() -- this variable stores the last time that a pickup was inserted into stats class
local lastStatUpdate = tick() -- this variable stores the last time we checked the frames to update the stat numbers
local pickupQueue = {} --table that stores the most recent pickups FIFO
local savedResistances = {
	Head = {
		Bullet = 0;
		Melee = 0;
	};
	Chest = {
		Bullet = 0;
		Melee = 0;
	};
	Legs = {
		Bullet = 0;
		Melee = 0;
	};
}
local currentCraft = "" --Most recently used name for the craft stat frame

-- Functions
local function FormatStatNumber(rawValue, statName)
	if string.find(statName, "Pickup") then --pickup stat
		return "+"..math.ceil(rawValue)
	elseif string.find(statName, "Drop") then --drop stat
		return "-"..math.ceil(rawValue)
	elseif statName == "Wet" then
		return ""..math.ceil((rawValue)).."%"
	elseif statName == "Drowning" then  --drown stat
		return "X"
	elseif statName == "BCAccess" then --Cabinet Access
		--format number in minutes to days and hours or hours and minutes if too low
		rawValue = rawValue == -1 and 0 or rawValue
		return NumberUtil:FormatTime(rawValue, "Days", "Minutes", true, 2)
	elseif statName == "BCDenied" then --Cabinet Denied
		return "X"
	elseif statName == "Decay" then
		return "X"
	elseif statName == "Craft" then
		return rawValue .. "s"
	elseif statName == "Safezone" then
		return "X"
	elseif statName == "Temperature" then
		return "" .. math.ceil(rawValue) .. "°C"
	elseif statName == "Comfort" then
		return "" .. math.ceil(rawValue) .. "%"
	else --Default format
		return tostring(math.ceil(rawValue))
	end
end

local function DestroyStatusBar(statFrame)
	if not statFrame then return end

	statFrame:Destroy()
end

local function statFadeTween(visible, statTemplate)
	--local transparency = visible and 0 or 1 
	local function applyAttributesOnObject(object)
		local attrs = object:GetAttributes()
		for attrName, attrValue in pairs(attrs) do
			local propertyPresent = pcall(function()
				local _ = object[attrName]
			end)
			if propertyPresent then 
				attrValue = visible and attrValue or 1
				TweenUtil:Tween(object, attrName, attrValue, 0.4)
			end
		end
	end
	applyAttributesOnObject(statTemplate) --Run func on stat template
	for _, v in pairs(statTemplate:GetChildren()) do --Run func on stat template children
		applyAttributesOnObject(v)
	end
end

local function UpdateStatusBars()
	--Create frames for main stats
	local framesToCreate = StatusEffects:GetStatsPickupTableCombined()
	local startPos = StatsFrame.Template.Position
	for index, statTable in pairs(framesToCreate) do
		local foundFrame = StatsFrame:FindFirstChild(statTable[1]) --Check if the frame already exists for the stat, update the reach value of it
		if foundFrame then --Frame exists, Need to update the position, make sure its in the right spot
			foundFrame:SetAttribute("Reach", statTable[2])
			local foundIndex = foundFrame:GetAttribute("Index")
			if index ~= foundIndex then --Update position
				foundFrame:SetAttribute("Index", index)
				local endPos = UDim2.new(startPos.X.Scale, 0, startPos.Y.Scale - (0.04 * (index - 1)), 0)
				TweenUtil:Tween(foundFrame, "Position", endPos, 0.4)
			end
		else --Create the frame to display
			local info = statSettings[statTable[1]] --Setting stat info
			if string.find(statTable[1], "Pickup") then --If its a pickup, set it to pickup info
				info = statSettings.Pickup
			elseif string.find(statTable[1], "Drop") then --If its a drop, set it to drop info
				info = statSettings.Drop

			end
			if not info then continue end 

			local clone = StatsFrame.Template:Clone()
			clone.Color.BackgroundColor3 = info.Color
			clone.Name = statTable[1]
			if info.Remove ~= nil then
				local labelText = string.gsub(statTable[1], info.Remove, "")
				clone.StatLabel.Text = (labelText:find(" Trophy") and "Bone Trophy" or labelText)
			else
				clone.StatLabel.Text = statTable[1]
			end
			clone.StatLabel.Text = info.Name == "Craft" and currentCraft or (info.Name ~= nil and info.Name or clone.StatLabel.Text)
			local formattedNum = FormatStatNumber(statTable[2], statTable[1])
			if formattedNum == "X" then
				clone.BackColor.Visible = false
				clone.Num.Visible = false
			end
			clone.Num.Text = formattedNum
			clone:SetAttribute("CurrentNum", statTable[2])
			clone:SetAttribute("Reach", statTable[2])
			clone:SetAttribute("Index", index)
			--local numString = info.Prefix ~= nil and info.Prefix .. statTable[2] or statTable[2]
			--clone.Num.Text = numString
			clone.Parent = StatsFrame
			clone.Position = UDim2.new(startPos.X.Scale, 0, startPos.Y.Scale - (0.04 * (index - 1)), 0)
			statFadeTween(true, clone)
		end
	end
	--Check for old ones to destroy
	--This destroys stats that aren't pickups, like bleeding, because the pickup loop won't destroy those.
	for _, statFrame in pairs(StatsFrame:GetChildren()) do
		local statIndex = StatusEffects:GetIndexOfStat(statFrame.Name)
		local n = statFrame.Name
		if not statIndex then 
			continue
		end
		if n ~= "Health" and n ~= "Hunger" and n ~= "Thirst" and n ~= "Template" and (string.find(n, "Pickup") or string.find(n, "Drop")) then
			continue
		end
		local statExists = false
		for _, statTable in pairs(framesToCreate) do
			--print(statTable[1])
			if statTable[1] == n then
				--print("exists")
				statExists = true
				break
			end
		end
		if not statExists then
			DestroyStatusBar(statFrame)
		end
	end
end

local function UpdateStats(statTable)
	StatusEffects:CompareServerTable(statTable)
	--Update Health Stat
	local healthFrame = StatsFrame:FindFirstChild("Health")
	local health = Humanoid.Health
	local healthPercent = health / statMax["Health"]
	local healthBar = healthFrame.Bar
	TweenUtil:Tween(healthBar.Fill, "Size", UDim2.new(math.clamp(healthPercent, 0, 1), 0, 1, 0),  0.4)
	healthBar.StatLabel.Text = tostring(math.ceil(health))
	--Update Hunger/Thirst Stats
	for statName, value in pairs(statTable) do
		local statFrame = StatsFrame:FindFirstChild(statName)
		if statFrame and (statName == "Hunger" or statName == "Thirst" )then  
			local percent = value / statMax[statName]
			local bar = statFrame.Bar

			--Tween value bar
			TweenUtil:Tween(bar.Fill, "Size", UDim2.new(percent, 0, 1, 0),  0.4)
			bar.StatLabel.Text = tostring(math.ceil(value))

		elseif statName == "HQueue"  then --Health queue updater
			local statFrame = StatsFrame.Health
			local bar = statFrame.Bar
			local queuePercent = (Humanoid.Health + value) / statMax["Health"]

			TweenUtil:Tween(bar.HQueue, "Size", UDim2.new(math.clamp(queuePercent, 0, 1), 0, 1, 0), 0.4)
		end
	end

	--Update External Status Bars
	UpdateStatusBars()

	--Play radiation sound on radiation stat
	local radiation = StatsFrame:FindFirstChild("Radiation") and StatsFrame.Radiation:GetAttribute("Reach") or 0
	local perc = (radiation / 120)
	local volume = math.clamp(NumberUtil:Lerp(.8, 1.3, perc), 0.8, 1.3)
	local speed = math.clamp(NumberUtil:Lerp(.9, 1.2, perc), .9, 1.2)
	RADIATION_SND.Volume = volume
	RADIATION_SND.PlaybackSpeed = speed
	if radiation > 0 then RADIATION_SND:Play() else RADIATION_SND:Stop() end
	--Update Screen FX based on stats
	--blur has to take the strongest blur based on hp and rads
	local hpBlurSize = health <= 40 and statEffectSettings.Health.BlurSize - ((health/40) * statEffectSettings.Health.BlurSize) or 0
	local radBlurSize = radiation >= 15 and math.clamp((radiation/120) * statEffectSettings.Radiation.BlurSize, 0, statEffectSettings.Radiation.BlurSize) or 0
	local blur = hpBlurSize >= radBlurSize and hpBlurSize or radBlurSize
	--color correction has to take the highest color loss based on health and rads
	local hpColorLoss = health <= 40 and 255 - (statEffectSettings.Health.ColorCorrectionLowest - ((health/40) * statEffectSettings.Health.ColorCorrectionLowest)) or 255
	local radColorLoss = radiation >= 15 and math.clamp(255 - (radiation/120) * statEffectSettings.Radiation.ColorCorrectionLowest, statEffectSettings.Radiation.ColorCorrectionLowest, 255) or 255
	local colorCorrection = hpColorLoss <= radColorLoss and hpColorLoss or radColorLoss
	BLUR.Size = blur
	COLOR_CORRECTION.TintColor = Color3.fromRGB(colorCorrection, colorCorrection, colorCorrection)
end

local function ApplyColorToBars(barContainerFrame, color)
	for _, bar in pairs(barContainerFrame:GetChildren()) do
		if not bar:IsA("Frame") then continue end
		bar.BackgroundColor3 = color
		bar.Fill.BackgroundColor3 = color
	end
end

local function FillResistanceBar(barContainerFrame, value)
	--local maxValue = 100 --resistance bars will ALWAYS have a max value of 100 // its commented out ik just leaving it here so u know its 100 max for every resistance stat
	local negative = (value < 0) 
	if negative and barContainerFrame:GetAttribute("ColorNegative") then --Check if the value is negative, if it is make the bars red
		value *= -1 --Make value positive so we can count bars properly
		ApplyColorToBars(barContainerFrame, barContainerFrame:GetAttribute("ColorNegative"))
	elseif barContainerFrame:GetAttribute("ColorPositive") ~= nil then --otherwise see if the attribute for positive color exists, if it does set it
		ApplyColorToBars(barContainerFrame, barContainerFrame:GetAttribute("ColorPositive"))
	end

	-- I fixed your code below since it wasn't displaying the values properly
	local bars = math.ceil(value / 10) -- We have to round up in this case since we can assume any bars higher than this index can just be left unfilled
	for i = 1, 10 do
		local translatedNum = (i >= 10 and tostring(i) or "0" .. i)
		local bar = barContainerFrame:FindFirstChild(translatedNum)
		local lastSize = (i - 1) * 10 -- We wanna get the last size to see if the current bar has any more value to fill in
		local size = (i > bars and 0 or math.min((value - lastSize) / 10, 1)) -- If we're past the max possible amount of bars, then don't bother calculating
		bar.Fill.Size = UDim2.new(size, 0, 1, 0)
	end

	--[[local bars = math.floor(value / 10)
	local remainder = value % 10 
	local tryBreak = false --if try break gets set to true, then we want to look to break the loop by clearing the remaining fills on the bars
	local empty = (bars == 0 and remainder == 0)
	
	for i = 1,10 do
		local translatedNum = i >= 10 and i or "0" .. i
		local bar = barContainerFrame:FindFirstChild(translatedNum)
		
		if tryBreak then 
			if bar.Fill.Size.X.Scale > 0 then
				bar.Fill.Size = UDim2.new(0, 0, 1, 0)
				continue
			else --The bar.size was 0 and we can break
				break
			end
		end
		
		if empty then --This if statement catches the first bar to set the fill to empty if there is no bars or remainder
			bar.Fill.Size = UDim2.new(0, 0, 1, 0)
		end
		
		if i > bars then --This is only going to run once, when it needs to set the remainder and then after, it needs to check for breaks
			if remainder > 0 then --Set the remainder, and then flag the loop to break
				local perc = remainder / 10
				bar.Fill.Size = UDim2.new(perc, 0, 1, 0)
			end
			tryBreak = true
			continue
		end
		--None of the above if statements were true, so just set the fill and continue through the loop
		bar.Fill.Size = UDim2.new(1, 0, 1, 0)
	end]]
end

local function ToggleSubResistances(bool, resistanceName) --bool is it toggling on or off, resistanceName is the Head, Chest or Legs
	local function toggleBars(b)
		BULLET_BARS.Visible = b
		BULLET_DETAIL.Visible = b
		MELEE_BARS.Visible = b
		MELEE_DETAIL.Visible = b
	end
	if bool then --Turn them on and fill their bars
		--Adjust bullet bars
		--print(savedResistances)
		FillResistanceBar(BULLET_BARS, savedResistances[resistanceName].Bullet)
		--Adjust melee bars
		FillResistanceBar(MELEE_BARS, savedResistances[resistanceName].Melee)
		--Make them visible
		toggleBars(bool)
	else --just hide the sub resistances and ignore
		toggleBars(bool)
	end
end

--Event Connections
--ui connections
VP_HITBOX_HEAD.MouseEnter:Connect(function()
	ToggleSubResistances(true, "Head")
	ViewportModule:HighlightCharArea(VIEWPORT_FRAME, "Head")
end)
VP_HITBOX_HEAD.MouseLeave:Connect(function()
	ToggleSubResistances(false, "Head")
	ViewportModule:HighlightCharArea(VIEWPORT_FRAME)
end)

VP_HITBOX_CHEST.MouseEnter:Connect(function()
	ToggleSubResistances(true, "Chest")
	ViewportModule:HighlightCharArea(VIEWPORT_FRAME, "Chest")
end)
VP_HITBOX_CHEST.MouseLeave:Connect(function()
	ToggleSubResistances(false, "Chest")
	ViewportModule:HighlightCharArea(VIEWPORT_FRAME)
end)

VP_HITBOX_LEGS.MouseEnter:Connect(function()
	ToggleSubResistances(true, "Legs")
	ViewportModule:HighlightCharArea(VIEWPORT_FRAME, "Legs")
end)
VP_HITBOX_LEGS.MouseLeave:Connect(function()
	ToggleSubResistances(false, "Legs")
	ViewportModule:HighlightCharArea(VIEWPORT_FRAME)
end)

Player:GetAttributeChangedSignal("SafeZone"):Connect(function()
	local value = Player:GetAttribute("SafeZone")
	if value then
		StatusEffects:InsertStat("Safezone", 1)
	else
		StatusEffects:UpdateStat("Safezone", 0)
	end
end)

--Bindable Connections
BINDABLE_CRAFTUPDATE.Event:Connect(function(updateType, arg1, arg2) 
	-- "UpdateRecipes", recipeCount: number
	-- "CreateCraft", displayName: string
	-- "UpdateCraft", displayName: string, craftTime: number
	-- "RemoveCraft"

	if updateType == "UpdateRecipes" then
		-- blah nigga HOW COULD YOU SAY THAT
		if arg1 <= 0 then
			--delete stat
			StatusEffects:InsertStat("Recipes", 0)
		else
			--insert stat
			StatusEffects:InsertStat("Recipes", arg1)
		end
		return
	elseif updateType == "UpdateCraft" then
		currentCraft = arg1
		StatusEffects:InsertStat("Craft", arg2)
	elseif updateType == "RemoveCraft" then
		StatusEffects:InsertStat("Craft", 0)
	end

	UpdateStatusBars()
end)

-- Reset color correction
COLOR_CORRECTION.TintColor = Color3.new(1, 1, 1)

-- Remotes
VectorUtil:SetupRemote(StatsRemotes, SendStats, function(statTable, armorStats) --SendStats
	if statTable ~= nil then --Update client ui
		UpdateStats(statTable)
	end

	if armorStats ~= nil then --Update the armor bars
		for statName, statValue in pairs(armorStats) do
			if statName == "Head" or statName == "Chest" or statName == "Legs" then --If its a head, chest or legs save the resistances in the variable
				savedResistances[statName].Bullet = statValue.Bullet
				savedResistances[statName].Melee = statValue.Melee
			else --otherwise we want to set the bar values immediatly
				local barContainer = ARMOR_FRAME:FindFirstChild(statName .. "Bars")
				if not barContainer then print("BAR CONTAINER NOT FOUND FOR " .. statName) continue end
				FillResistanceBar(barContainer, statValue)
			end
		end
	end 
end)

VectorUtil:SetupRemote(StatsRemotes, Pickup, function(pickupInfo, isDrop) --Pickup item
	table.insert(pickupQueue, pickupInfo)
	UpdateStatusBars()
end)

BLUR.Size = 0
COLOR_CORRECTION.TintColor = Color3.fromRGB(255, 255, 255)

VectorUtil:FireRemote(StatsRemotes, SendStats, {})

while true do -- Stats controller loop
	local somethingChanged = false

	--Pickup + Drop Inserter / Pickup + Drop Queue
	if tick() - lastPickupInsert >= PICKUP_COOLDOWN then
		lastPickupInsert = tick()
		--Take out the first thing in pickup queue, and add it to stats
		local pickupInfo = pickupQueue[1]

		if pickupInfo then
			table.remove(pickupQueue, 1)
			StatusEffects:InsertStat(pickupInfo[1], pickupInfo[2])
			somethingChanged = true
		end
	end

	--Pickup + Drop Deleter
	for _, pickupInfo in pairs(StatusEffects:GetPickups()) do
		if tick() - pickupInfo[3] >= PICKUP_LIFETIME then --Delete pickup / drop
			local foundFrame = StatsFrame:FindFirstChild(pickupInfo[1])
			if foundFrame then
				delay(0.4, function()
					foundFrame:Destroy()
				end)
				statFadeTween(false, foundFrame)
			end
			StatusEffects:RemovePickup(pickupInfo[1])
			somethingChanged = true
		end
	end

	if tick() - lastStatUpdate >= STAT_NUM_UPD_TIME then --Stat number update tweener
		lastStatUpdate = tick()
		for _, stat in pairs(StatsFrame:GetChildren()) do
			local blacklist = {"Health", "Hunger", "Thirst", "Template"}
			local isBlacklist = false
			for _, blacklistItem in pairs(blacklist) do
				if stat.Name == blacklistItem then
					isBlacklist = true
					break
				end
			end
			if isBlacklist then continue end

			local cur = stat:GetAttribute("CurrentNum")
			local reach = stat:GetAttribute("Reach")
			local label = stat.Num
			if not reach or cur == reach then
				continue
			elseif cur >= reach - 0.4 then --assign number to reach value
				cur = reach
				stat:SetAttribute("CurrentNum", cur)
				label.Text = FormatStatNumber(cur, stat.Name)
			else --tween the number closer to the reach
				local newCur = NumberUtil:Lerp(cur, reach, STAT_NUM_LERP_PERC)
				stat:SetAttribute("CurrentNum", newCur)
				label.Text = FormatStatNumber(newCur, stat.Name)
			end
		end
	end

	if somethingChanged then
		UpdateStatusBars()
	end

	if #StatusEffects:GetPickups() <= 0 then
		wait(PICKUP_LOOP_COOLDOWN)
	else
		wait()
	end
end