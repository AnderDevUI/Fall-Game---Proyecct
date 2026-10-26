-- [PATH] ReplicatedStorage / CharacterScripts / InventoryController @Type LocalScript
--[[
	InventoryController
	by ChickenBagelz
	July 16, 2022
	
	Controls all slots in inventory and their actions. Holds limited inv info from the server
]]

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local UserInput = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Users = game:GetService("UserService")
local Sound = game:GetService("SoundService")

-- Folders
local Modules = Replicated:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")
local Values = Replicated:WaitForChild("Values")
local LocalSounds = Replicated:WaitForChild("LocalSounds")
local InventoryRemotes = Remotes:WaitForChild(string.char(112, 17, 107, 22, 65, 146, 120, 135, 75, 57, 109, 34, 79, 105, 140, 153, 152, 95, 159, 125, 83, 96, 185, 108, 168, 132, 159, 28, 114, 103))
local StatsRemotes = Remotes:WaitForChild(string.char(32, 175, 56, 160, 50, 187, 113, 77, 49, 22, 130, 142, 126, 38, 59, 102, 17, 6, 168, 41, 9, 180, 85, 142, 105, 14, 66, 146, 142, 126))
local BenchRemotes = Remotes:WaitForChild(string.char(80, 174, 145, 85, 122, 27, 174, 146, 106, 51, 133, 27, 138, 20, 188, 5, 143, 181, 154, 67, 20, 136, 79, 62, 36, 5, 34, 30, 25, 108))
local InteractRemotes = Remotes:WaitForChild(string.char(60, 12, 5, 117, 173, 26, 48, 16, 174, 61, 181, 117, 1, 115, 39, 143, 91, 146, 18, 3, 41, 181, 157, 74, 180, 31, 46, 57, 187, 151))

-- Remotes
local FetchRemote = string.char(16, 19, 29, 113, 24, 175, 14, 3, 182, 41, 116, 77, 11, 175, 50, 140, 128, 42, 4, 128, 146, 2, 117, 135, 37, 129, 145, 54, 134, 135)
local InventoryRemote = string.char(53, 11, 104, 88, 159, 158, 138, 46, 60, 39, 122, 104, 25, 110, 176, 190, 84, 79, 104, 16, 3, 115, 180, 167, 55, 106, 24, 128, 170, 167)
local UpdateRemote = string.char(46, 140, 60, 189, 147, 36, 171, 98, 122, 54, 166, 1, 67, 35, 73, 113, 83, 148, 150, 187, 151, 41, 183, 1, 10, 173, 51, 78, 26, 85)
local ConsumeRemote = string.char(27, 172, 20, 5, 103, 62, 136, 82, 35, 178, 177, 27, 40, 69, 51, 169, 95, 77, 172, 4, 97, 63, 55, 189, 180, 173, 72, 135, 187, 25)
local ChangeRemote = string.char(101, 174, 125, 80, 107, 99, 116, 157, 132, 169, 40, 119, 37, 163, 5, 18, 93, 127, 108, 101, 116, 179, 178, 121, 123, 32, 131, 88, 93, 77)
local BenchRemote = string.char(69, 158, 103, 31, 151, 49, 145, 49, 110, 75, 182, 63, 158, 153, 114, 34, 159, 171, 119, 72, 22, 128, 92, 190, 34, 24, 31, 56, 111, 13)

-- Modules
local Items = require(Modules:WaitForChild("Items"))
local TweenUtil = require(Modules:WaitForChild("TweenUtil"))
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))
local Thread = require(Modules:WaitForChild("Thread"))
local ButtonClass = require(Modules:WaitForChild("ButtonClass"))
local ViewportModule = require(Modules:WaitForChild("ViewportModule"))
local SoundModule = require(Modules:WaitForChild("SoundModule"))
local VectorUtil = require(Modules:WaitForChild("VectorUtil"))
local ToolInfo = require(Modules:WaitForChild("ToolInfo"))
local ResearchModule = require(Modules:WaitForChild("ResearchModule"))
local RecipeModule = require(Modules:WaitForChild("RecipeModule"))

-- Bindables
local Fetch = script:WaitForChild("Fetch")
local GetBench = script:WaitForChild("GetBench")
local UpdItemStats = script:WaitForChild("ItemStats")

-- Player Variables
local Player = Players.LocalPlayer
local Character = script.Parent
local PlayerGui = Player:WaitForChild("PlayerGui")
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- Dependencies
local ViewmodelController = Character:WaitForChild("ViewmodelController")
local WheelController = Character:WaitForChild("WheelController")
local CraftingController = Character:WaitForChild("CraftingController")
local StateController = Character:WaitForChild("StateController")
local TeamNavigationController = Character:WaitForChild("TeamNavigationController")

-- UI
local MainGui = PlayerGui:WaitForChild("Main")
local InvBG = MainGui:WaitForChild("BG")
local Inventory = MainGui:WaitForChild("Inventory")
local Toolbar = MainGui:WaitForChild("Toolbar")
local Drag = MainGui:WaitForChild("Drag")
local Inv = Inventory:WaitForChild("Inv")
local ActionMenu = Inventory:WaitForChild("ActionMenu")
local ItemStats = ActionMenu:WaitForChild("ItemStats")
local Benches = Inventory:WaitForChild("Benches")
local Armor = Inventory:WaitForChild("Armor")
local CharViewport = Armor:WaitForChild("ViewportFrame")
local ChestHitbox = Armor:WaitForChild("HitboxChest")
local HeadHitbox = Armor:WaitForChild("HitboxHead")
local LegsHitbox = Armor:WaitForChild("HitboxLegs")
local Crafting = MainGui:WaitForChild("Crafting")

-- Local Variables
local invInfo = {}
local researchLevels = {}
local skins = {}
local containers = {
	Inventory = Inv;
	Toolbar = Toolbar;
	Armor = Armor;
}
local invOpenTween, invCloseTween
local selectedSlot
local dragSlot
local actionMenuElements
local actionMenuTrans = 1
local origActionMenuSize = ActionMenu.Size
local firstActionMenu = true
local actionMenuSliderDragged = false
local actionMenuAmount
local currentBench
local quickStackButtonHolding = false
local quickStackQueued = 0
local quickStackCompleted = 0
local buttonClasses = {}
local benchTargetTick = 0
local benchTickRunning = false
local cachedUserInfos = {}
local researchUpgradeButton, repairButton
local lastResearchUpgrade = 0
local currentPlinko = 1
local lastConsumeFire = 0

-- Functions
local function IsAlive()
	return (Humanoid and Humanoid.Parent and Humanoid.Health > 0)
end

local function ClearDragged() -- Simple function that deletes the current item you're dragging properly
	Drag.Visible = false
	Run:UnbindFromRenderStep("Drag")
	dragSlot = nil
end

local function CloseBench()
	SoundModule:PlayBenchSound((currentBench and currentBench.Name), "Close")
	currentBench = nil
	local ui = containers.Bench
	if ui and ui.Parent then
		ui.Visible = false
	end
	containers.Bench = nil
	invInfo.Bench = nil
	if dragSlot and dragSlot.Container == "Bench" then
		ClearDragged()
	end
	if selectedSlot and selectedSlot.Container == "Bench" then
		SelectSlot(nil)
	end
end

local function Toggle(typ, instant) -- Close or open inventory
	-- Setup tweens if not yet initialized
	if not invOpenTween then
		invOpenTween = TweenUtil:Tween(InvBG, "BackgroundTransparency", 0.5, 0.15, "Quart", "Out", true)
		invCloseTween = TweenUtil:Tween(InvBG, "BackgroundTransparency", 1, 0.15, "Quart", "In", true)
	end
	local isOpen = (typ ~= "None")
	if isOpen then
		if instant then
			InvBG.BackgroundTransparency = 0.5
		else
			invOpenTween:Play()
		end
	else
		if currentBench and currentBench.Parent then
			VectorUtil:FireRemote(BenchRemotes, ChangeRemote, {
				[1] = currentBench,
				[2] = "Close"
			})
		end
		CloseBench()
		if instant then
			InvBG.BackgroundTransparency = 1
		else
			invCloseTween:Play()
		end
		ClearDragged()
	end
	Inventory:TweenPosition(UDim2.new((typ == "Crafting" and 1 or (typ == "Inventory" and 0 or -1)), 0, 0, 0), (isOpen and "Out" or "In"), "Quart", (instant and 0 or 0.1), true)
	Crafting:TweenPosition(UDim2.new((typ == "Crafting" and 0 or (typ == "Inventory" and -1 or -2)), 0, 0, 0), (isOpen and "Out" or "In"), "Quart", (instant and 0 or 0.1), true)
	-- Detach or attach mouse to center
	if not TeamNavigationController:GetAttribute("MapOpen") or isOpen then
		UserInput.MouseBehavior = Enum.MouseBehavior[isOpen and "Default" or "LockCenter"]
		UserInput.MouseIconEnabled = isOpen
	end
	script:SetAttribute("Open", isOpen)
	script:SetAttribute("CurOpen", typ)
end

local function StartDrag(s, image, container, index, mouseButton, isActionMenu, item) -- Initialize a drag from slot specified
	if not script:GetAttribute("Open") then return end
	dragSlot = {
		Slot = s;
		Container = container;
		Index = index;
		Mouse = mouseButton;
		IsActionMenu = isActionMenu;
	}
	--print("doing drag", dragSlot)
	Drag.Image = image
	-- Attach dragged item to mouse
	--Drag.Position = UDim2.new(0, Mouse.X + 1, 0, Mouse.Y + 1)
	local didVis = false
	Run:BindToRenderStep("Drag", Enum.RenderPriority.Input.Value + 1, function()
		if not didVis then
			Drag.Visible = true
			didVis = true
		end
		Drag.Position = UDim2.new(0, Mouse.X + 1, 0, Mouse.Y + 1)
	end)
	SoundModule:PlayItemSound(item.ID, "Drag")
	return true
end

local function QuickStackItem(s, container, index, doQueue)
	if not script:GetAttribute("Open") then return end
	local t = invInfo[container]
	if not (t and tick() - (s.Fill:GetAttribute("Cooldown") or 0) >= 0.4 and not s.Fill.Visible) then return end
	local item = t[index]
	if not (item and item ~= 0) then return end
	local id = item.ID
	local info = (Items[id] or {})
	local isArmor = (info.Type == "Armor")
	s.Fill.Visible = true
	local speed = ((currentBench and container ~= "Armor") and 0.3 or 0.1)
	local finished = false
	local total = 0
	local curStackQueue
	if doQueue then
		curStackQueue = quickStackQueued
		quickStackQueued += 1
	end
	local function can()
		return not doQueue or containers.Bench or container == "Armor" or isArmor
	end
	if can() then
		SoundModule:PlayItemSound(id, "Drag")
	end
	while invInfo[container] and t[index] and t[index] ~= 0 and can() do
		local passed = math.min(total, speed)
		local r = passed / speed
		local fill = math.clamp((doQueue and 1 - r or r), 0, 1)
		s.Fill.Size = UDim2.new(1, 0, fill, 0)
		s.Fill.Position = UDim2.new(0, 0, 1 - fill, 0)
		if passed >= speed then
			finished = true
			break
		end
		local step = Run.Heartbeat:Wait()
		--print(curStackQueue, quickStackQueued, quickStackCompleted)
		if (not doQueue) or quickStackCompleted >= curStackQueue then
			total += step
		end
	end
	if finished then
		SoundModule:PlayItemSound(id, "Drop")
		VectorUtil:FireRemote(InventoryRemotes, InventoryRemote, {
			[1] = "QuickStack", 
			[2] = index, 
			[3] = container
		})
	end
	s.Fill:SetAttribute("Cooldown", tick())
	s.Fill.Visible = false
	if doQueue then
		quickStackCompleted += 1
	end
end

local function SetActionMenuTransparency(r)
	if not actionMenuElements then
		actionMenuElements = {}
		for _, v in pairs(ActionMenu:GetDescendants()) do 
			local prop = (v:IsA("TextLabel") and "Text" or ((v:IsA("Frame") or v.Image == "") and "Background" or "Image")).."Transparency" 
			actionMenuElements[v] = {prop, v[prop]} 
		end
	end
	for ui, t in pairs(actionMenuElements) do 
		local prop = t[1] 
		local n = t[2] 
		ui[prop] = NumberUtil:Lerp(n, 1, r)
	end
	ActionMenu.Visible = (r < 1)
end

local function UpdateActionMenuSlider()
	if selectedSlot then
		local selectedContainer = invInfo[selectedSlot.Container]
		if not selectedContainer then return end
		local selectedItem = selectedContainer[selectedSlot.Index]
		if (not selectedItem) or selectedItem == 0 or selectedItem.Amount <= 0 then return end
		actionMenuAmount = math.clamp(actionMenuAmount, 1, selectedItem.Amount)
		local r = actionMenuAmount / selectedItem.Amount
		ActionMenu.SplitBar.Fill:TweenSize(UDim2.new(r, 0, 1, 0), "Out", "Quart", 0.15, true)
		ActionMenu.SplitBar.Amount.Text = NumberUtil:FormatNumber(actionMenuAmount)
	end
end

local function UpdateSlot(s, t, localAmmo, ignoreVMUpdate) -- Updates a slot with an item table
	local slotIndex = tonumber(s.Name:sub(5))
	--print("updating", s, "to", t)
	local info, image, maxDur, attachments, ammo, cookTimes
	if t and t ~= 0 then
		info = Items[t.ID]
		image = info.Image
		maxDur = info.MaxDurability
		attachments = info.Attachments
		ammo = t.Ammo
		cookTimes = t.CookTimes
	end
	-- Durability
	local durability = s:FindFirstChild("Durability")
	local durVis = false
	if durability then
		durVis = (maxDur ~= nil)
		if maxDur then
			durability.Fill.Size = UDim2.new(math.clamp(t.Durability / maxDur, 0, 1), 0, 1, 0)
			local r = math.min(t.Repair, 1)
			durability.Repair.Position = UDim2.new(1 - r, 0, 0, 0)
			durability.Repair.Size = UDim2.new(r, 0, 1, 0)
		end
		durability.Visible = durVis
	end
	-- Show attachments
	for i = 1, 4 do
		local a = s:FindFirstChild("Att"..i)
		if not a then continue end
		if attachments then
			a.BackgroundColor3 = (i <= #t.Attachments and Color3.fromRGB(255, 244, 88) or Color3.fromRGB(167, 165, 130))
		end
		a.Visible = (attachments ~= nil and i <= #attachments)
	end
	s.ItemImage.Image = (image and (type(image) == "table" and image[t.Skin] or image) or "")
	-- If item's amount is exactly one or doesn't exist, don't show text unless it has ammo of some sort. Otherwise, show amount.
	s.ItemAmount.Text = (info and ((info.Type ~= "Ammo" and info.AmmoType ~= nil) and NumberUtil:FormatNumber(ammo ~= nil and (localAmmo or ammo.Amount) or 0) or (t.Amount > 1 and "x"..NumberUtil:FormatNumber(t.Amount) or "")) or "")
	s.ItemAmount.Position = UDim2.new(0.25, 0, (durVis and 0.71 or 0.76), 0)
	local broken = s:FindFirstChild("Broken")
	if broken then
		broken.Visible = (maxDur ~= nil and t.Durability <= 0)
	end
	local empty = s:FindFirstChild("Empty")
	if empty then
		empty.Visible = (image == nil)
	end
	local checker = s:FindFirstChild("Checker")
	if checker then
		checker.Visible = false
	end
	local cookBar = s:FindFirstChild("CookBar")
	if cookBar then
		if cookTimes then
			local barSize = math.clamp(cookTimes[1] / cookTimes[2], 0, 1)
			local doFull = (barSize < cookBar.Fill.Size.Y.Scale and cookBar.Visible)
			local isEmpty = (barSize <= 0.001)
			cookBar.Fill:TweenSize(UDim2.new(1, 0, ((doFull and not isEmpty) and 1 or barSize), 0), "InOut", "Linear", ((cookBar.Visible and not isEmpty) and (doFull and 0.8 or 1) or 0), true)
			if doFull and not isEmpty then
				Thread.Delay(0.8, function()
					if not (cookBar and cookBar.Parent and cookBar.Visible and cookBar.Fill.Size.Y.Scale >= 0.99) then return end
					cookBar.Fill:TweenSize(UDim2.new(1, 0, barSize, 0), "InOut", "Linear", 0.1, true)
				end)
			end
		end
		cookBar.Visible = (cookTimes ~= nil)
	end
	local equippedIndex = ViewmodelController:GetAttribute("Equipped")
	if ignoreVMUpdate or s.Parent ~= Toolbar or slotIndex ~= equippedIndex then return end
	ViewmodelController.UpdateVM:Fire(t)
end

local function SetItemStats(itemStats, ...)
	local args = {...}
	for i = 1, 8 do
		local statText = itemStats["Stat"..i]
		local text = (args[i] or "")
		statText.Size = UDim2.new((i > 4 and 0.5 or 1), 0, 0.24, 0)
		statText.RichText = (text:find("</") ~= nil)
		statText.Text = text
		if i <= 4 then continue end
		local leftStatText = itemStats["Stat"..i - 4]
		leftStatText.Size = UDim2.new(0.5, 0, 0.24, 0)
	end
end

local function UpdateItemStats(itemStats, id, itemInfo)
	SetItemStats(itemStats)
	itemInfo = (itemInfo or Items[id])
	local ammoStats = itemInfo.AmmoStats
	local consumeStats = itemInfo.ConsumableStats
	local resistances = itemInfo.Resistances
	local toolInfo = ToolInfo[itemInfo.Name]
	if itemInfo.Type == "Gun" and toolInfo then
		local weaponInfo = toolInfo.Weapon
		local bulletInfo = toolInfo.Bullet
		if bulletInfo then
			local humDmgs = bulletInfo.HumanoidDamages
			local dropoff = bulletInfo.Dropoff
			SetItemStats(itemStats,
				`Base Damage: {NumberUtil:RoundNumber(bulletInfo.DisplayDamage or humDmgs.Chest)}`, 
				`RPM: {NumberUtil:FormatNumber(weaponInfo.DisplayRPM or weaponInfo.RPM)}`, 
				`Range Dropoff: {NumberUtil:FormatNumber(dropoff.Start)..(dropoff.End == dropoff.Start and "" or "-"..NumberUtil:FormatNumber(dropoff.End))}`,
				`Bullet Velocity: {NumberUtil:FormatNumber(bulletInfo.Speed)}`
			)
		end
	elseif itemInfo.Type == "Tool" or itemInfo.Type == "Consumable" then
		local statTexts = {}
		if toolInfo then
			local weaponInfo = toolInfo.Weapon
			local meleeInfo = toolInfo.Melee
			local objDmgs = toolInfo.ObjectDamages
			if meleeInfo then
				local humDmgs = meleeInfo.HumanoidDamages
				if humDmgs then
					table.insert(statTexts, `Base Damage: {NumberUtil:RoundNumber(humDmgs.Chest)}`)
				end
			end
			local throwInfo = (weaponInfo and weaponInfo.ThrowInfo)
			if throwInfo then
				local explosive = throwInfo.Explosive
				if explosive then
					table.insert(statTexts, `Splash Damage: {NumberUtil:RoundNumber(explosive.HumanoidMaxDamage)}`)
				end
			end
			local cooldown = (weaponInfo and weaponInfo.Cooldown)
			if cooldown then
				table.insert(statTexts, `Cooldown: {NumberUtil:RoundNumber(cooldown)}`)
			end
			if objDmgs then
				local treeDmgs = objDmgs.Trees
				if treeDmgs then
					table.insert(statTexts, `Tree Gather: {math.round(treeDmgs.Medium.Mult * 1000) / 100}`)
				end
				local nodeDmgs = objDmgs.Nodes
				if nodeDmgs then
					table.insert(statTexts, `Node Gather: {math.round(nodeDmgs.Stone.Mult * 1000) / 100}`)
				end
			end
		end
		if consumeStats then
			for statName, statVal in pairs(consumeStats) do
				if statVal == 0 or type(statVal) ~= "number" then continue end
				local val = NumberUtil:RoundNumber(statVal)
				local dispVal = math.abs(statVal)
				local showRed = ((val < 0) == (statName ~= "Radiation"))
				local clr = script:GetAttribute(showRed and "StatRedColor" or "StatGreenColor")
				table.insert(statTexts, `{statName == "HQueue" and "Health Regen" or (statName == "Health" and "Instant Health" or statName)}: <font color="rgb({math.round(clr.R * 255)}, {math.round(clr.G * 255)}, {math.round(clr.B * 255)})">{(val < 0 and "-" or "+")..dispVal}</font>`)
			end
		end
		SetItemStats(itemStats, unpack(statTexts))
	elseif ammoStats then
		local statTexts = {}
		for statName, statVal in pairs(ammoStats) do
			if statName:sub(#statName - 3) == "Mult" then
				local statPrefix = statName:sub(1, #statName - 4)
				local isGrav = (statPrefix == "Gravity")
				local val = math.round(((isGrav or statPrefix == "ArmorPen") and 1 - statVal or (statPrefix == "HeadshotDamage" and statVal or statVal * (ammoStats.Bullets or 1) - 1)) * 100)
				local dispVal = math.abs(val)
				--print(statPrefix, statVal, val, dispVal)
				local showRed = ((val < 0) == (statPrefix:find("Spread") == nil))
				local clr = script:GetAttribute(showRed and "StatRedColor" or "StatGreenColor")
				table.insert(statTexts, `{isGrav and "Drop" or (statPrefix == "ArmorPen" and "Armor Penetration" or (statPrefix == "HeadshotDamage" and "HS Mult" or statPrefix:gsub("Spread", " Spread")))}: <font color="rgb({math.round(clr.R * 255)}, {math.round(clr.G * 255)}, {math.round(clr.B * 255)})">{(val < 0 and "-" or "+")..dispVal}%</font>`)
			elseif statName == "Explosive" then
				local splashDmg = NumberUtil:FormatNumber(statVal.HumanoidMaxDamage)
				if itemInfo.AmmoType == "Rocket" then
					if itemInfo.Name ~= "Rocket" then
						table.insert(statTexts, `Damage Override: {NumberUtil:FormatNumber(splashDmg)}`)
					end
				else
					local clr = script:GetAttribute("StatGreenColor")
					table.insert(statTexts, `Splash Damage: <font color="rgb({math.round(clr.R * 255)}, {math.round(clr.G * 255)}, {math.round(clr.B * 255)})">+{splashDmg}</font>`)
				end
			elseif statName == "Bullets" then
				table.insert(statTexts, `Pellets: {statVal}`)
			end
		end
		SetItemStats(itemStats, unpack(statTexts))
	elseif resistances then
		local statTables = {}
		for _, statName in pairs({"Chest", "Legs", "Head"}) do
			local statVal = resistances[statName]
			local bullet = statVal.Bullet
			local melee = statVal.Melee
			if bullet == 0 and melee == 0 then continue end
			if bullet ~= 0 then
				table.insert(statTables, {"Bullet", bullet})
			end
			if melee ~= 0 then
				table.insert(statTables, {"Melee", melee})
			end
			break
		end
		for statName, statVal in pairs(resistances) do
			if statVal == 0 or type(statVal) ~= "number" then continue end
			table.insert(statTables, {statName, statVal})
		end
		local statTexts = {}
		for _, statTable in pairs(statTables) do
			local statVal = statTable[2]
			local dispVal = NumberUtil:RoundNumber(math.abs(statVal))
			local clr = script:GetAttribute(statVal < 0 and "StatRedColor" or "StatGreenColor")
			table.insert(statTexts, `{statTable[1]}: <font color="rgb({math.round(clr.R * 255)}, {math.round(clr.G * 255)}, {math.round(clr.B * 255)})">{(statVal < 0 and "-" or "+")..dispVal}</font>`)
		end
		SetItemStats(itemStats, unpack(statTexts))
	else
		local attachmentStats = itemInfo.AttachmentStats
		if attachmentStats then
			local statTexts = {}
			for statName, statVal in pairs(attachmentStats) do
				local isZoom = (statName == "ZoomLevel")
				if statName == "GunRecoilAimMult" or type(statVal) ~= "number" or statVal == 0 or (statName:sub(#statName - 3) ~= "Mult" and not isZoom) then continue end
				local statPrefix = (isZoom and statName or statName:sub(1, #statName - 4))
				local dispStat = (statPrefix == "Sway" and "Aim Sway" or statPrefix:gsub("(%u)", " %1"):gsub("^%s", ""))
				local val = (isZoom and NumberUtil:RoundNumber(statVal, 2) or math.round(statVal * 100))
				local dispVal = math.abs(val)
				local showRed = ((val < 0) == (statPrefix == "Damage" or statPrefix == "FireRate"))
				if isZoom then
					showRed = (val < 1.2)
				end
				local clr = script:GetAttribute(showRed and "StatRedColor" or "StatGreenColor")
				table.insert(statTexts, `{dispStat}: <font color="rgb({math.round(clr.R * 255)}, {math.round(clr.G * 255)}, {math.round(clr.B * 255)})">{(isZoom and "" or (val < 0 and "-" or "+"))..dispVal..(isZoom and "x" or "%")}</font>`)
			end
			SetItemStats(itemStats, unpack(statTexts))
		end
	end
end

local function UpdateActionMenu()
	if selectedSlot then
		--print("updating action menu")
		local selContainer = selectedSlot.Container
		local selectedContainer = invInfo[selContainer]
		if not selectedContainer then return end
		local selIndex = selectedSlot.Index
		local selectedItem = selectedContainer[selIndex]
		if (not selectedItem) or selectedItem == 0 or selectedItem.Amount <= 0 then return end
		local selectedInfo = Items[selectedItem.ID]
		local attachments = selectedItem.Attachments
		local hasAttachments = selectedInfo.Attachments
		local image = selectedInfo.Image
		local ammoStats = selectedInfo.AmmoStats
		local consumeStats = selectedInfo.ConsumableStats
		local resistances = selectedInfo.Resistances
		local itemImage = (image and (type(image) == "table" and image[selectedItem.Skin] or image) or "")
		ActionMenu.Split.ItemImage.Image = itemImage
		ActionMenu.ItemInfo.ItemImage.Image = itemImage
		for i = 1, 4 do
			local a = ActionMenu.ItemDetails["Slot"..i]
			if hasAttachments then
				UpdateSlot(a, attachments[i])
			end
			a.Checker.Visible = (i > (hasAttachments and #hasAttachments or 0))
			a.Visible = (hasAttachments ~= nil)
		end
		local dropInfo = selectedInfo.DropInfo
		if selectedInfo.Type == "Gun" then
			ActionMenu.Actions.Action1.Label.Text = "UNLOAD AMMO"
		elseif selectedInfo.Type == "Consumable" then
			ActionMenu.Actions.Action1.Label.Text = "EAT"
		elseif dropInfo then
			ActionMenu.Actions.Action1.Label.Text = dropInfo.ButtonName
		end
		local isGun = (selectedInfo.Type == "Gun")
		local isConsume = (selectedInfo.Type == "Consumable")
		ActionMenu.Actions.Action1.Visible = (isGun or isConsume or dropInfo ~= nil)
		--ActionMenu.Actions.Action1.Icon.Text = (selectedInfo.Type == "Consumable") and [[️🍖]] or [[ ️❗]]
		actionMenuAmount = (actionMenuAmount or math.ceil(selectedItem.Amount / 2))
		UpdateItemStats(ItemStats, selectedItem.ID, selectedInfo)
		UpdateActionMenuSlider()
		local nameExtra = "[ERR]"
		local descExtra = "[ERR]"
		local ownerId = selectedItem.Owner
		if ownerId then
			local userInfo = cachedUserInfos[ownerId]
			if (not userInfo) or tick() - userInfo.Called >= 600 then
				local suc, userInfos = pcall(function()
					return Users:GetUserInfosByUserIdsAsync({ownerId})
				end)
				if suc and userInfos and #userInfos > 0 then
					userInfo = userInfos[1]
					userInfo.Called = tick()
				end
			end
			if userInfo then
				cachedUserInfos[ownerId] = userInfo
				nameExtra = userInfo.DisplayName
				descExtra = userInfo.DisplayName.."(@"..userInfo.Username..")"
			end
		end
		if selectedSlot and selectedSlot.Container == selContainer and selectedSlot.Index == selIndex then
			ActionMenu.ItemName.Text = string.format(selectedInfo.Name, nameExtra)
			ActionMenu.ItemInfo.ItemDesc.Text = string.format(selectedInfo.Description, descExtra)
		end
	end
end

function SelectSlot(s, container, index) -- Select a slot for action menu
	--if (not selectedSlot) then
	-- Unselect old slot if applicable
	local oldSel = selectedSlot
	if selectedSlot and selectedSlot.Slot then
		selectedSlot.Slot.BackgroundColor3 = selectedSlot.Color
	end
	selectedSlot = nil
	if s and ((not oldSel) or s ~= oldSel.Slot) then
		-- Select new slot
		selectedSlot = {
			Slot = s;
			Container = container;
			Index = index;
			Color = s.BackgroundColor3;
		}
		s.BackgroundColor3 = script:GetAttribute("SelectedSlotColor")
	end
	local selSlot = selectedSlot
	if selSlot ~= oldSel then
		local willShow = (selSlot ~= nil)
		if willShow then
			local cont = invInfo[selSlot.Container]
			if cont then
				local item = cont[selSlot.Index]
				willShow = (item ~= nil and item ~= 0 and item.Amount > 0)
				if willShow then
					SoundModule:PlayItemSound(item.ID, "Drag")
				end
			else
				willShow = false
			end
		end
		UpdateActionMenu()
		if firstActionMenu then
			ActionMenu.Size = NumberUtil:MultUDim2ByNum(origActionMenuSize, 1.3)
			firstActionMenu = false
		end
		ActionMenu:TweenSize(NumberUtil:MultUDim2ByNum(origActionMenuSize, (willShow and 1 or 1.3)), (willShow and "Out" or "In"), "Quart", 0.175, true)
		local started = tick()
		local speed = 0.1
		local targetTrans = (willShow and 0 or 1)
		if actionMenuTrans ~= targetTrans then
			actionMenuTrans = targetTrans
			while true do
				local passed = tick() - started
				local r = math.min(passed / speed, 1)
				local trans = (willShow and (1 - r) or r)
				SetActionMenuTransparency(trans)
				if passed >= speed then
					break
				end
				task.wait(1/60)
			end
		end
	end
	--end
end

local function DragifySlot(s, i, downFunc, dragDropFunc, noDragFunc)
	local mouseHeldPos
	local held = 0
	local didDrag = false
	s["MouseButton"..i.."Down"]:Connect(function()
		held = i
		mouseHeldPos = Vector2.new(Mouse.X, Mouse.Y)
		didDrag = false
		-- Run a loop to check if mouse is being dragged or if it's just clicking on the slot
		while held > 0 do
			local mousePos = Vector2.new(Mouse.X, Mouse.Y)
			if not NumberUtil:IsWithin(mouseHeldPos, mousePos, 5) then
				-- Mouse is being dragged, commence dragging function
				if downFunc then
					didDrag, held = downFunc(didDrag, held)
				end
				break
			end
			Run.RenderStepped:Wait()
		end
	end)
	s["MouseButton"..i.."Up"]:Connect(function()
		if dragSlot and dragSlot.Mouse == i then
			-- Dragged item was dropped onto this slot, perform an action
			if dragDropFunc then
				dragDropFunc()
			end
			ClearDragged()
		elseif held > 0 then
			-- No dragging was done, check if mouse was already on the slot beforehand
			local oldHeld = held
			held = 0
			if noDragFunc and not didDrag then
				noDragFunc(oldHeld)
			end
		end
	end)
end

local function GetDragAmount()
	local dragContainer = dragSlot.Container
	local dragIndex = dragSlot.Index
	local container = invInfo[dragContainer]
	if not container then return end
	local dragItem = container[dragIndex]
	local holdingShift = UserInput:IsKeyDown(Enum.KeyCode.LeftShift) and not StateController:GetAttribute("IsSprint")
	local mouse = dragSlot.Mouse
	local isActionMenu = dragSlot.IsActionMenu
	return (isActionMenu == true and actionMenuAmount or ((mouse == 1 and holdingShift) and 1 or math.ceil(dragItem.Amount / ((mouse == 2 and holdingShift) and 3 or mouse))))
end

local function InventoryServer(container, index)
	local dragContainer = dragSlot.Container
	local dragIndex = dragSlot.Index
	local isActionMenu = dragSlot.IsActionMenu
	local dragAmount = GetDragAmount()
	local isDrop = (container == "Drop" and Camera.CFrame)
	while isDrop do
		local t = invInfo[dragContainer]
		if not t then break end
		local item = t[dragIndex]
		if not (item and item ~= 0) then break end
		SoundModule:PlayItemSound(item.ID, "Drop")
		break
	end
	if isActionMenu and type(isActionMenu) == "number" then
		VectorUtil:FireRemote(InventoryRemotes, InventoryRemote, {
			[1] = isDrop,
			[2] = isActionMenu, 
			[3] = "RemoveAttachment", 
			[4] = index, 
			[5] = container,
			[6] = dragAmount,
			[7] = dragIndex, 
			[8] = dragContainer
		})
	else
		VectorUtil:FireRemote(InventoryRemotes, InventoryRemote, {
			[1] = isDrop,
			[2] = "none",
			[3] = "none",
			[4] = index, 
			[5] = container, 
			[6] = dragAmount, 
			[7] = dragIndex, 
			[8] = dragContainer
		})
	end
end

local function ActivateSlot(s, container, index)
	-- Create tweens
	local outTween = TweenUtil:Tween(s, "Size", NumberUtil:MultUDim2ByNum(s.Size, 1.05), 0.04, "Quart", "Out", true)
	local inTween = TweenUtil:Tween(s, "Size", s.Size, 0.46, "Elastic", "Out", true)
	local checker = s:FindFirstChild("Checker")
	s.MouseEnter:Connect(function() -- Play animation when mouse enters slot
		if checker and checker.Visible then return end
		outTween:Play()
		wait(0.04)
		inTween:Play()
	end)
	s.InputChanged:Connect(function(input)
		local inputType = input.UserInputType
		if inputType ~= Enum.UserInputType.MouseMovement or not quickStackButtonHolding then return end
		QuickStackItem(s, container, index, true)
	end)
	for i = 1, 2 do
		DragifySlot(s, i, function(didDrag, held)
			local conTable = invInfo[container]
			if conTable then
				local item = conTable[index]
				if item and item ~= 0 and not dragSlot then
					didDrag = StartDrag(s, s.ItemImage.Image, container, index, held, nil, item)
				end
			end
			return didDrag, held
		end, function()
			--print("dropped")
			if dragSlot.Slot == s then
				-- It was the original slot it was dragged from, just select the item
				Thread.SpawnNow((dragSlot.Mouse == 1 and SelectSlot or QuickStackItem), s, container, index)
			else
				-- Do inventory logic on server
				local dragCon = dragSlot.Container
				local dragIndex = dragSlot.Index
				local conTable = invInfo[dragCon]
				while conTable do
					local item = conTable[dragIndex]
					if not (item and item ~= 0) then break end
					SoundModule:PlayItemSound(item.ID, "Drop")
					break
				end
				InventoryServer(container, index)
			end
		end, function(oldHeld)
			if oldHeld == 2 then
				-- Right-click logic
				QuickStackItem(s, container, index)
			else
				-- Select slot as normally, was just a click
				SelectSlot(s, container, index)
			end
		end)
	end
end

local function DropifyButton(button)
	for i = 1, 2 do
		button["MouseButton"..i.."Up"]:Connect(function()
			if not (dragSlot and dragSlot.Mouse == i) then return end
			InventoryServer("Drop")
			ClearDragged()
		end)		
	end
end

local function ToggleInvFunc()
	if WheelController:GetAttribute("Open") or Humanoid:GetAttribute("Downed") or not IsAlive() then return end
	Toggle(script:GetAttribute("CurOpen") == "None" and "Inventory" or "None")
end

local function ToggleCraftFunc()
	if not Values.CraftingEnabled.Value or WheelController:GetAttribute("Open") or Humanoid:GetAttribute("Downed") or not IsAlive() then return end
	Toggle(script:GetAttribute("CurOpen") == "Crafting" and "Inventory" or "Crafting")
end

local function QuickStackButtonDownFunc()
	quickStackButtonHolding = true
end

local function QuickStackButtonUpFunc()
	quickStackButtonHolding = false
end

local function FetchInventoryItemCounts(): ...{ID: number, Amount: number}
	local itemCounts = {}
	for name, container in pairs(invInfo) do
		if name ~= "Inventory" and name ~= "Toolbar" then continue end
		for _, item in pairs(container) do
			if not (item and item ~= 0) then continue end
			local id = item.ID
			local amount = item.Amount
			itemCounts[id] = (itemCounts[id] or 0) + amount
		end
	end
	return itemCounts
end

local function CanUpdateResearch()
	local benchUI = containers.Bench
	if not (currentBench and currentBench.Parent and benchUI and benchUI.Parent and benchUI.Name == "CraftingStation") then return end
	local id = currentBench:GetAttribute("ID")
	if not id then return end
	return benchUI, id
end

local function RefreshResearch(ui: Frame, id: number, nextCosts)
	if not (ui and id) then
		ui, id = CanUpdateResearch()
		if not ui then return end
	end
	if not nextCosts then
		local itemInfo = Items[id]
		if not itemInfo then return end
		local benchName = itemInfo.Name
		local researchInfo = ResearchModule:GetInfoFromName(benchName)
		if not researchInfo then return end
		local tiers = researchInfo.Tiers
		local upgradeLevel = researchLevels[benchName] or 0
		nextCosts = tiers[upgradeLevel + 1]
	end
	local canUpgrade = (nextCosts ~= nil)
	if nextCosts then
		local itemCounts = FetchInventoryItemCounts()
		for _, cost in pairs(nextCosts) do
			local costId = cost.ID
			local slot = ui.UpgradeFrame.Items:FindFirstChild(costId)
			if not slot then continue end
			local hasAmount = itemCounts[costId] or 0
			local hasEnough = (hasAmount >= cost.Amount)
			slot.Grey.Visible = not hasEnough
			if hasEnough then continue end
			canUpgrade = false
		end
	end
	if researchUpgradeButton and (canUpgrade and not researchUpgradeButton:IsToggled()) or (canUpgrade == false and researchUpgradeButton:IsToggled()) then
		task.defer(researchUpgradeButton.ToggleButton, researchUpgradeButton, canUpgrade)
	end
	--print("research refreshed")
end

local function UpdateResearch(ui: Frame, id: number)
	if not (ui and id) then
		ui, id = CanUpdateResearch()
		if not ui then return end
	end
	local UnlockItems = ui.UnlocksFrame.Items
	local UpgradeItems = ui.UpgradeFrame.Items
	for _, slot in pairs(UpgradeItems:GetChildren()) do
		if not slot:IsA("ImageButton") then continue end
		slot:Destroy()
	end
	for _, slot in pairs(UnlockItems:GetChildren()) do
		if slot.Name == "Template" then continue end
		slot:Destroy()
	end
	ui.UnlocksFrame.Maxed.Visible = false
	local itemInfo = Items[id]
	if not itemInfo then return end
	local benchName = itemInfo.Name
	local researchInfo = ResearchModule:GetInfoFromName(benchName)
	if not researchInfo then return end
	local tiers = researchInfo.Tiers
	local unlocks = researchInfo.Unlocks
	local upgradeLevel = researchLevels[benchName] or 0
	local isMax = upgradeLevel >= #tiers
	ui.Item.Label.Image = (type(itemInfo.Image) == "table" and itemInfo.Image.Default or itemInfo.Image)
	ui.CurrentTier.Text = `Current Tier: <font color="rgb(255, 248, 41)">{upgradeLevel}</font>`
	ui.UpgradeTier.Text = `Upgrade Current Tier: <font color="rgb(255, 248, 41)">{upgradeLevel..(isMax and " (MAX)" or "")}</font>`..(isMax and "" or ` -> <font color="rgb(255, 248, 41)">{(upgradeLevel + 1)..(upgradeLevel + 1 == #tiers and " (MAX)" or "")}</font>`)
	if isMax then
		ui.UnlocksFrame.Maxed.Visible = true
		ui.UpgradeFrame.Free.Text = "N/A"
	else
		local nextCosts = tiers[upgradeLevel + 1]
		local nextUnlocks = unlocks[upgradeLevel + 1] or {}
		local sizeRatio = math.max(0.4 + math.floor((#nextUnlocks - 1) / 4) * 0.42, 1)
		UnlockItems.CanvasSize = UDim2.new(0, 0, 0.76 * sizeRatio - 0.001, 0)
		local template = UnlockItems.Template
		template.Size = UDim2.new(0.24, 0, 0.4 / sizeRatio, 0)
		--print(#nextUnlocks, sizeRatio)
		local n = -1
		for _, recipe in pairs(nextUnlocks) do
			n += 1
			local recipeId = recipe.ID
			local info = Items[recipeId]
			local slot = template:Clone()
			slot.Name = "Slot"..(n + 1)
			slot.ItemImage.Image = (type(info.Image) == "table" and info.Image.Default or info.Image)
			slot.ItemName.Text = info.Name
			slot.Position = UDim2.new(0.25 * (n % 4), 0, 0.42 * math.floor(n / 4) / sizeRatio, 0)
			slot.Parent = UnlockItems
			slot.MouseEnter:Connect(function()
				slot.ItemName:TweenPosition(UDim2.new(0.5, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.4, true)
			end)
			slot.MouseLeave:Connect(function()
				slot.ItemName:TweenPosition(UDim2.new(0.5, 0, -0.26, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.15, true)
			end)
			slot.Visible = true
		end
		for index, cost in pairs(nextCosts) do
			local info = Items[cost.ID]
			local slot = UpgradeItems.Layout.Template:Clone()
			slot.Name = tostring(cost.ID)
			slot.ItemImage.Image = (type(info.Image) == "table" and info.Image.Default or info.Image)
			slot.ItemName.Text = info.Name
			slot.ItemAmount.Text = "x"..NumberUtil:FormatNumber(cost.Amount)
			slot.Parent = UpgradeItems
		end
		ui.UpgradeFrame.Free.Text = (#nextCosts <= 0 and "FREE" or "")
		RefreshResearch(ui, id, nextCosts)
	end
	--print("research updated")
end

local repairSkinButtons = {}
local lastRepairId
local function UpdateRepair(ui: Frame)
	local container = invInfo.Bench
	if not container or not ui or not ui.Parent then return end
	local item = container[1]
	local itemId = (item == 0 and 0 or item.ID)
	print("updated repair", itemId, lastRepairId)
	local doRefresh = (lastRepairId == itemId)
	lastRepairId = itemId
	local CostItems = ui.CostFrame.Items
	local SkinItems = ui.SkinsFrame.Items
	if not doRefresh then
		for _, frame in pairs(CostItems:GetChildren()) do
			if not frame:IsA("ImageButton") then continue end
			frame:Destroy()
		end
		for frame, button in pairs(repairSkinButtons) do
			button:Destroy()
			if not frame.Parent then continue end
			frame:Destroy()
		end
		repairSkinButtons = {}
	end
	local canRepair = false
	ui.DetailExtra.Text = ""
	if type(item) == "table" then
		local info = Items[itemId]
		local itemImages = info.Image
		if type(itemImages) == "table" then
			if not doRefresh then
				local ownedSkins = {}
				for skin, _ in pairs(itemImages) do
					local hasSkin = table.find(skins or {}, info.Name.."/"..skin)
					if skin == "Default" or not hasSkin then continue end
					table.insert(ownedSkins, skin)
				end
				table.insert(ownedSkins, "Default")
				local sizeRatio = math.max(0.4 + math.floor((#ownedSkins - 1) / 4) * 0.42, 1)
				SkinItems.CanvasSize = UDim2.new(0, 0, 0.76 * sizeRatio - 0.001, 0)
				local template = SkinItems.Template
				template.Size = UDim2.new(0.24, 0, 0.4 / sizeRatio, 0)
				--print(#nextUnlocks, sizeRatio)
				local n = -1
				for _, skin in pairs(ownedSkins) do
					n += 1
					local slot = template:Clone()
					slot.Name = "Skin"..skin
					slot.ItemImage.Image = itemImages[skin]
					slot.ItemName.Text = skin
					slot.Position = UDim2.new(0.12 + 0.25 * (n % 4), 0, (0.2 + 0.42 * math.floor(n / 4)) / sizeRatio, 0)
					slot.Parent = SkinItems
					--[[slot.MouseEnter:Connect(function()
						slot.ItemName:TweenPosition(UDim2.new(0.5, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.4, true)
					end)
					slot.MouseLeave:Connect(function()
						slot.ItemName:TweenPosition(UDim2.new(0.5, 0, -0.26, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.15, true)
					end)]]
					local button = ButtonClass.new(slot, "BackgroundColor3", function()
						local container = invInfo.Bench
						if not container or not ui.Visible then return end
						local item = container[1]
						if tick() - lastResearchUpgrade < 0.4 or not item or item == 0 or item.Amount <= 0 or item.Skin == skin then return end
						lastResearchUpgrade = tick()
						VectorUtil:FireRemote(InteractRemotes, BenchRemote, {
							[1] = skin,
							[2] = "Repair2",
							[3] = currentBench
						}, true)
					end, 1.3, script:GetAttribute("SelectedSlotColor"))
					repairSkinButtons[slot] = button
					slot.Visible = true
				end
			end
			for frame, button in pairs(repairSkinButtons) do
				local frameSkin = frame.Name:sub(5)
				if item.Skin == frameSkin and not button:IsToggled() then
					task.defer(button.ToggleButton, button, true)
				elseif item.Skin ~= frameSkin and button:IsToggled() then
					task.defer(button.ToggleButton, button, false)
				end
			end
			ui.SkinsFrame.Visible = true
		else
			ui.SkinsFrame.Visible = false
		end
		local recipe = (RecipeModule:GetRecipesForItem(itemId) or {})[1]
		if recipe and item.Repair < 1 and info.MaxDurability then
			local benchNeeded = recipe.BenchNeeded
			local tierNeeded = recipe.TierNeeded
			local mult = 0.5
			if (tierNeeded or 0) > 0 then
				local researchInfo = ResearchModule:GetInfoFromName(benchNeeded)
				if researchInfo then
					local currentTier = researchLevels[benchNeeded] or 0
					local maxTier = #researchInfo.Tiers
					local tierDiff = tierNeeded - currentTier
					mult = (tierDiff <= 0 and 0.5 or tierDiff)
					if tierDiff > 4 then
						mult = nil
						ui.CostFrame.Extra.Text = `Level {math.max(tierNeeded - 4, 0)} {benchNeeded} or higher required.`
					elseif mult > 0.5 then
						ui.DetailExtra.Text = `<font color="rgb(255, 66, 69)">{math.round(mult / 0.5)}X COST PENALTY</font> (<font color="rgb(0, 157, 255)">{tierDiff}</font> more <font color="rgb(255, 248, 41)">{benchNeeded}</font> tiers needed for no penalty)`
					end
				end
			end
			if mult then
				local costs = RecipeModule:CalculateTotalCost(recipe, mult, true, {6, 68, 179})
				if not doRefresh then
					for index, cost in pairs(costs) do
						local costInfo = Items[cost.ID]
						local frame = CostItems.Layout.Template:Clone()
						frame.Name = "Slot"..index
						frame.ItemImage.Image = (type(costInfo.Image) == "table" and costInfo.Image.Default or costInfo.Image)
						frame.ItemName.Text = costInfo.Name
						frame.Parent = CostItems
					end
				end
				local itemCounts = FetchInventoryItemCounts()
				canRepair = true
				for index, cost in pairs(costs) do
					local frame = CostItems:FindFirstChild("Slot"..index)
					if not frame then continue end
					frame.ItemAmount.Text = "x"..NumberUtil:FormatNumber(math.ceil(cost.Amount))
					local notEnough = ((itemCounts[cost.ID] or 0) < math.ceil(cost.Amount))
					frame.Grey.Visible = notEnough
					if notEnough then
						canRepair = false
					end
				end
				if canRepair and item.Durability >= (info.MaxDurability or 0) * (1 - item.Repair) - 0.01 then
					canRepair = false
				end
				ui.CostFrame.Extra.Text = ""
			end
		else
			ui.CostFrame.Extra.Text = "Item unavailable for repairing."
		end
	else
		ui.SkinsFrame.Visible = false
		ui.CostFrame.Extra.Text = "Insert an item into the slot to Repair."
	end
	if not repairButton then return end
	if canRepair and not repairButton:IsToggled() then
		task.defer(repairButton.ToggleButton, repairButton, true)
	elseif not canRepair and repairButton:IsToggled() then
		task.defer(repairButton.ToggleButton, repairButton, false)
	end
end

-- Events
UserInput.InputBegan:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	local textBox = UserInput:GetFocusedTextBox()
	if inputType == Enum.UserInputType.Keyboard and not textBox then
		local key = input.KeyCode
		if key == Enum.KeyCode.Tab then -- Toggle inventory
			ToggleInvFunc()
		elseif key == Enum.KeyCode.Q then -- Toggle crafting
			ToggleCraftFunc()
		elseif key == Enum.KeyCode.H and not notProcessed then -- Quick loot
			QuickStackButtonDownFunc()
		end
	end
end)

UserInput.InputEnded:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	local textBox = UserInput:GetFocusedTextBox()
	if inputType == Enum.UserInputType.MouseButton1 then
		actionMenuSliderDragged = false
		if dragSlot and dragSlot.Mouse == 1 and not notProcessed then
			InventoryServer("Drop")
			ClearDragged()
		end
	elseif inputType == Enum.UserInputType.MouseButton2 and dragSlot and dragSlot.Mouse == 2 and not notProcessed then
		InventoryServer("Drop")
		ClearDragged()
	elseif inputType == Enum.UserInputType.Keyboard and not textBox then
		local key = input.KeyCode
		if key == Enum.KeyCode.H then
			QuickStackButtonUpFunc()
		end
	end
end)

ViewmodelController.AttributeChanged:Connect(function(attr)
	if attr ~= "LocalAmmo" then return end
	local equippedIndex = ViewmodelController:GetAttribute("Equipped")
	if equippedIndex <= 0 then return end
	UpdateSlot(Toolbar["Slot"..equippedIndex], invInfo.Toolbar[equippedIndex], ViewmodelController:GetAttribute("LocalAmmo"))
end)

Humanoid.Died:Connect(function()
	ClearDragged()
	ViewportModule:ClearViewport(CharViewport)
	WheelController:SetAttribute("Open", false)
	Toggle("None", true)
end)

Humanoid:GetAttributeChangedSignal("Downed"):Connect(function()
	if not Humanoid:GetAttribute("Downed") then return end
	WheelController:SetAttribute("Open", false)
	Toggle("None", true)
end)

-- Remotes
VectorUtil:SetupRemote(InventoryRemotes, UpdateRemote, function(...) -- Updates inventory table and corresponding slots
	--local savedContainer, savedIndex
	local args = {...}
	--print(args)
	local ignoreVMUpdate = false
	local updateArmor = false
	local updateCrafting = false
	local updateResearch = false
	local updatedRepair = false
	for _, t in pairs(args) do
		if type(t) ~= "table" then
			if t == "IgnoreVMUpdate" then
				ignoreVMUpdate = true
			elseif typeof(t) == "Instance" then
				currentBench = t
			elseif type(t) == "string" and t:sub(1, 5) == "Bench" then
				local benchUI = Benches:FindFirstChild(t:sub(6))
				if not benchUI then return end
				for _, ui in pairs(Benches:GetChildren()) do
					ui.Visible = (ui == benchUI)
					if not (ui == benchUI and ui:FindFirstChild("BenchName")) then continue end
					local slotFrame = (ui:FindFirstChild("Inv") or ui)
					local benchName = currentBench.Name
					local nameTag = currentBench:FindFirstChild("NameTag")
					local isSleeper = (benchName == "Sleeper")
					ui.BenchName.Text = (currentBench:GetAttribute("BenchName") or (benchName == "Body Bag" and [[CORPSE OF <b>]]..(currentBench:GetAttribute("OwnerName") or "[ERR]")..[[</b>]] or (isSleeper and `INVENTORY OF <b>{nameTag and nameTag.Label.Text or "[ERR]"}</b>` or benchName:upper())))
					if ui.Name == "BodyLoot" then
						ui.Slot38.Visible = not isSleeper
						ui.BenchName.Position = UDim2.new((isSleeper and 0.808 or 0.858), 0, 0.36, 0)
					elseif ui.Name == "CraftingStation" then
						if not researchUpgradeButton then
							researchUpgradeButton = ButtonClass.new(ui.UpgradeFrame.Upgrade, "BackgroundColor3", function()
								--print(currentBench)
								if tick() - lastResearchUpgrade < 0.5 or not (currentBench and currentBench.Parent) then return end
								lastResearchUpgrade = tick()
								VectorUtil:FireRemote(InteractRemotes, BenchRemote, {
									[1] = "Upgrade",
									[2] = currentBench
								}, true)
							end, 1.3, Color3.fromRGB(89, 148, 64))
						end
						UpdateResearch(ui, currentBench:GetAttribute("ID"))
					elseif ui.Name == "Plinko" then
						currentPlinko = currentBench:GetAttribute("PlinkoIndex")
						print("set plinko to", currentPlinko)
						ui.Timer.Text = Values["PlinkoTimer"..currentPlinko].Value.."s"
					end
					for _, slot in pairs(slotFrame:GetChildren()) do
						if not (slot.Name:sub(1, 4) == "Slot" and slot:IsA("ImageButton")) then continue end
						UpdateSlot(slot, 0)
						local checker = slot:FindFirstChild("Checker")
						if not checker then continue end
						checker.Visible = true
					end
				end
				SoundModule:PlayBenchSound(currentBench.Name, "Open")
				containers.Bench = benchUI
				local items = {}
				local slotFrame = (benchUI:FindFirstChild("Inv") or benchUI)
				for _, slot in pairs(slotFrame:GetChildren()) do
					if slot.Name:sub(1, 4) ~= "Slot" then continue end
					table.insert(items, 0)
				end
				invInfo.Bench = items
				if benchUI.Name == "RepairTable" then
					if not repairButton then
						repairButton = ButtonClass.new(benchUI.CostFrame.Repair, "BackgroundColor3", function()
							if not currentBench or not currentBench.Parent or tick() - lastResearchUpgrade < 0.4 or not repairButton:IsToggled() then return end
							lastResearchUpgrade = tick()
							VectorUtil:FireRemote(InteractRemotes, BenchRemote, {
								[1] = "Repair1",
								[2] = currentBench
							}, true)
						end, 1.3, Color3.fromRGB(89, 148, 64))
					end
					--UpdateRepair(benchUI)
				end
				Toggle("Inventory")
			end
			continue
		end
		local containerName = t[1]
		if not containerName then
			local ui = containers.Bench
			if not ui then continue end
			local totalUpkeep = t.Upkeep
			local upkeepTick = t.UpkeepTick
			local newResearchLevels = t.RL
			if t.On ~= nil then
				local control = ui:FindFirstChild("ControlFrame")
				if not control then continue end
				local toggle = control:FindFirstChild("Toggle")
				if not toggle then continue end
				local button = buttonClasses[toggle]
				if not button then continue end
				toggle.Label.Text = (t.On and "Turn Off" or "Turn On")
				button:ToggleButton(t.On)
			elseif totalUpkeep and upkeepTick then
				--print(totalUpkeep)
				local costFrameSaved = ui:FindFirstChild("C")
				if not costFrameSaved then continue end
				local protFrame = ui:FindFirstChild("ProtectionFrame")
				if not protFrame then continue end
				for _, costFrame in pairs(ui:GetChildren()) do
					local name = costFrame.Name
					if not (name:sub(1, 4) == "Cost" and costFrame:IsA("ImageButton")) then continue end
					costFrame:Destroy()
				end
				for index, upkeep in pairs(totalUpkeep) do
					local costFrame = costFrameSaved:Clone()
					costFrame.Position = UDim2.new(0.5 - (#totalUpkeep - 1) * 0.1 + (index - 1) * 0.2, 0, 0.711, 0)
					costFrame.Name = "Cost"..index
					costFrame.Parent = ui
					UpdateSlot(costFrame, upkeep)
					costFrame.Visible = true
				end
				benchTargetTick = upkeepTick
				if not benchTickRunning then
					benchTickRunning = true
					Values.ServerTick.Changed:Connect(function()
						local tickLeft = math.max(benchTargetTick - Values.ServerTick.Value, 0)
						if not (protFrame and protFrame.Parent) then return end
						protFrame.Timer.TextColor3 = protFrame.Timer:GetAttribute(tickLeft > 0 and "Protected" or "Decaying")
						protFrame.Timer.Text = (tickLeft > 0 and NumberUtil:FormatTime(tickLeft, "Days", "Minutes", true) or "Base is Decaying!")
					end)
				end
			elseif newResearchLevels then
				researchLevels = t.RL
				updateResearch = true
			end
			continue
		end
		local index = t[2]
		local new = t[3]
		local extra = t[4]
		local container = invInfo[containerName]
		local containerUI = containers[containerName]
		if container and containerUI then
			if extra == "LocalAmmo" and new.Ammo then
				ViewmodelController:SetAttribute("LocalAmmo", new.Ammo.Amount)
			end
			local slotFrame = (containerUI:FindFirstChild("Inv") or containerUI)
			local slot = slotFrame:FindFirstChild("Slot"..index)
			local oldItem = container[index]
			if selectedSlot and selectedSlot.Slot == slot and oldItem ~= 0 and (new == 0 or oldItem.ID ~= new.ID) then
				--print("is drag slot")
				Thread.SpawnNow(SelectSlot)
			end
			if updateCrafting == false and (containerName == "Inventory" or containerName == "Toolbar") and new and oldItem and ((new == 0 and 0 or new.ID) ~= (oldItem == 0 and 0 or oldItem.ID) or (new == 0 and 0 or new.Amount) ~= (oldItem == 0 and 0 or oldItem.Amount)) then
				updateCrafting = true
			end
			
			container[index] = new -- Update table
			if selectedSlot and selectedSlot.Slot == slot then
				UpdateActionMenu()
			end
			if slot then
				UpdateSlot(slot, new, nil, ignoreVMUpdate) -- Update slot UI
			end
			if containerName == "Armor" then
				updateArmor = true
			end
			if containerName == "Bench" and containerUI.Name == "RepairTable" then
				UpdateRepair(containerUI)
				updatedRepair = true
			end
			--[[if extra == "UpdateEquipped" then
				
			end]]
		end
		--[[if t[4] == "Save" then -- Save the new slot we dragged into to select it afterwards
			savedContainer = containerName
			savedIndex = index
		elseif t[4] == "Drag" and selectedSlot and selectedSlot.Container == containerName and selectedSlot.Index == index and savedContainer and savedIndex then
			SelectSlot(containers[savedContainer]["Slot"..savedIndex], savedContainer, savedIndex)
		end]]
	end
	--print(updateCrafting, updateResearch)
	if updateResearch then
		CraftingController.Update:Fire("Research")
		UpdateResearch()
	elseif updateCrafting then
		RefreshResearch()
		CraftingController.Update:Fire()
		local containerUI = containers.Bench
		if containerUI and containerUI.Parent and containerUI.Name == "RepairTable" and not updatedRepair then
			UpdateRepair(containerUI)
		end
	end
	
	if updateArmor then
		ViewportModule:UpdateArmors(CharViewport, invInfo.Armor)
	end
	-- Check if our selected item still exists or not to unselect it
	--[[if selectedSlot then
		local selectedContainer = invInfo[selectedSlot.Container]
		if selectedContainer then
			local selectedItem = selectedContainer[selectedSlot.Index]
			if selectedItem == 0 then
				SelectSlot(nil)
			end
		end
	end]]
	if dragSlot then
		local dragContainer = invInfo[dragSlot.Container]
		if dragContainer then
			local dragItem = dragContainer[dragSlot.Index]
			if dragItem == 0 then
				ClearDragged()
			end
		elseif dragSlot.Container == "Bench" then
			ClearDragged()
		end
	end
	
	--print("CLIENT INVENTORY UPDATED:", invInfo)
end)

VectorUtil:SetupRemote(BenchRemotes, ChangeRemote, function(typ, ...) -- Changes/updates the bench locally
	local args = {...}
	if typ == "Close" then
		local containerName = args[1]
		local curContainer = containers.Bench
		if not (curContainer and curContainer.Name == containerName) then return end
		--print("closing bench locally")
		CloseBench()
	end
end)

-- Bindables
Fetch.OnInvoke = function()
	--if not doCounts then
	return invInfo, researchLevels, skins
	--end
	--return FetchInventoryItemCounts()
end
GetBench.OnInvoke = function()
	return currentBench
end
UpdItemStats.OnInvoke = UpdateItemStats

-- Close all existing UI in case it was left open
InvBG.Visible = true
Inventory.Visible = true
Crafting.Visible = true
Toggle("None", true)
SetActionMenuTransparency(1)
ActionMenu.Visible = false

invInfo, researchLevels, skins = VectorUtil:FireRemote(InventoryRemotes, FetchRemote, {}, true)
ViewportModule:ShowCharacter(CharViewport, Character, {ChestHitbox, HeadHitbox, LegsHitbox}, invInfo.Armor)
script:SetAttribute("Initiated", true)
--print(invInfo)
-- Initialize action menu
ActionMenu.SplitBar.MouseButton1Down:Connect(function()
	local selSlot = selectedSlot
	if selSlot then
		local selContainer = invInfo[selSlot.Container]
		if not selContainer then return end
		local selItem = selContainer[selSlot.Index]
		if selItem and selItem ~= 0 and selItem.Amount > 0 then
			actionMenuSliderDragged = true
			while actionMenuSliderDragged and selectedSlot and selectedSlot == selSlot do
				local r = math.clamp((Mouse.X - ActionMenu.SplitBar.AbsolutePosition.X) / ActionMenu.SplitBar.AbsoluteSize.X, 0, 1)
				actionMenuAmount = math.ceil(selItem.Amount * math.clamp(r, 0, 1))
				UpdateActionMenuSlider()
				Run.Heartbeat:Wait()
			end
		end
	end
end)
DropifyButton(ActionMenu.SplitBar)

DragifySlot(ActionMenu.Split, 1, function(didDrag, held)
	if selectedSlot then
		local slot = selectedSlot.Slot
		local conTable = invInfo[selectedSlot.Container]
		if conTable and slot then
			local item = conTable[selectedSlot.Index]
			if item and item ~= 0 and not dragSlot then
				didDrag = StartDrag(slot, slot.ItemImage.Image, selectedSlot.Container, selectedSlot.Index, held, true, item)
			end
		end
	end
	return didDrag, held
end)
DropifyButton(ActionMenu.Split)

pcall(function()
	Run:UnbindFromRenderStep("SliderTextPosition")
end)
Run:BindToRenderStep("SliderTextPosition", Enum.RenderPriority.Last.Value, function()
	ActionMenu.SplitBar.Amount.Position = UDim2.new(math.max(ActionMenu.SplitBar.Fill.Size.X.Scale, 0.1), 0, 0.5, 0)
end)

for i = 1, 4 do
	local s = ActionMenu.ItemDetails["Slot"..i]
	DragifySlot(s, 1, function(didDrag, held)
		local slot = selectedSlot.Slot
		local conTable = invInfo[selectedSlot.Container]
		if conTable then
			local item = conTable[selectedSlot.Index]
			if item and item ~= 0 and item.Amount > 0 and not dragSlot then
				local attachment = item.Attachments[i]
				if attachment then
					didDrag = StartDrag(slot, s.ItemImage.Image, selectedSlot.Container, selectedSlot.Index, held, i, attachment)
					--print("dragging attachment")
				end
			end
		end
		return didDrag, held
	end, function()
		--print("dropped attachment")
		if selectedSlot then
			-- Do inventory logic on server
			local dragContainer = dragSlot.Container
			local dragIndex = dragSlot.Index
			local conTable = invInfo[dragContainer]
			if not conTable then return end
			local dragItem = conTable[dragIndex]
			if dragItem and dragItem ~= 0 and dragItem.Amount > 0 then
				SoundModule:PlayItemSound(dragItem.ID, "Drop")
			end
			VectorUtil:FireRemote(InventoryRemotes, InventoryRemote, {
				[1] = selectedSlot.Index, 
				[2] = selectedSlot.Container, 
				[3] = dragItem.Amount, 
				[4] = dragIndex, 
				[5] = dragContainer
			})
		end
	end)
end
for _, action in pairs(ActionMenu.Actions:GetChildren()) do
	local actionName = action.Name
	action.Activated:Connect(function()
		if selectedSlot then
			local container = selectedSlot.Container
			local index = selectedSlot.Index
			local conTable = invInfo[container]
			if conTable then
				local item = conTable[index]
				if item and item ~= 0 and item.Amount > 0 then
					local info = Items[item.ID]
					if actionName == "Drop" then
						VectorUtil:FireRemote(InventoryRemotes, InventoryRemote, {
							[1] = Camera.CFrame,
							[2] = "none",
							[3] = "none",
							[4] = "none",
							[5] = "Drop",
							[7] = index, 
							[8] = container
						})
					elseif actionName == "Action1" then
						local dropInfo = info.DropInfo
						if info.Type == "Gun" and item.Ammo and item.Ammo.Amount > 0 then
							VectorUtil:FireRemote(InventoryRemotes, InventoryRemote, {
								[1] = "UnloadAmmo", 
								[2] = index, 
								[3] = container
							})
						elseif dropInfo then
							VectorUtil:FireRemote(InventoryRemotes, InventoryRemote, {
								[1] = "ItemDrop", 
								[2] = index, 
								[3] = container
							})
						elseif info.Type == "Consumable" then
							local press = tick()
							if press - lastConsumeFire < 0.15 then return end
							lastConsumeFire = press
							VectorUtil:FireRemote(StatsRemotes, ConsumeRemote, {
								[1] = index, 
								[2] = container
							})
						end
					end
				end
			end
		end
	end)
	DropifyButton(action)
end

-- Initlaize inventory slots
for container, t in pairs(invInfo) do
	for i, v in pairs(t) do
		local ui = containers[container]
		if not ui then continue end
		local slot = ui["Slot"..i]
		ActivateSlot(slot, container, i)
		UpdateSlot(slot, v)
	end	
end

-- Initialize benches
for _, ui in pairs(Benches:GetChildren()) do
	ui.Visible = false
	local slotFrame = (ui:FindFirstChild("Inv") or ui)
	for _, slot in pairs(slotFrame:GetChildren()) do
		if slot.Name:sub(1, 4) ~= "Slot" then continue end
		local index = tonumber(slot.Name:sub(5))
		if not index then continue end
		ActivateSlot(slot, "Bench", index)
		UpdateSlot(slot, 0)
	end
	local control = ui:FindFirstChild("ControlFrame")
	if not control then continue end
	local toggle = control:FindFirstChild("Toggle")
	if not toggle then continue end
	toggle.BackgroundColor3 = toggle:GetAttribute("ColorOff")
	local lastPress = 0
	buttonClasses[toggle] = ButtonClass.new(toggle, "BackgroundColor3", function()
		if not currentBench then return end
		local press = tick()
		if press - lastPress < 0.2 then return end
		lastPress = press
		VectorUtil:FireRemote(InteractRemotes, BenchRemote, {
			[1] = (buttonClasses[toggle]:IsToggled() and "Turn Off" or "Turn On"),
			[2] = currentBench
		}, true)
	end, 1.3, toggle:GetAttribute("ColorOn"))
end

-- Do plinko timer
for i = 1, 2 do
	local value = Values:WaitForChild("PlinkoTimer"..i)
	value:GetPropertyChangedSignal("Value"):Connect(function()
		if i ~= currentPlinko or not Benches.Plinko.Visible then return end
		print("updating", i)
		Benches.Plinko.Timer.Text = value.Value.."s"
	end)
end