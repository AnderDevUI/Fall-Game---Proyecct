-- [PATH] ReplicatedStorage / CharacterScripts / CraftingController @Type LocalScript
--[[
	CraftingController
	by ChickenBagelz
	April 19, 2023
	
	Controls all of the crafting logic on the client
]]


-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")

-- Folders
local Modules = Replicated:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")
local Values = Replicated:WaitForChild("Values")
local Bases = workspace:WaitForChild("Bases")
local VFX = workspace:WaitForChild("VFX")
local Animals = workspace:WaitForChild("Animals")
local Plants = workspace:WaitForChild("Plants")
local Vegetation = workspace:WaitForChild("Vegetation")

-- Modules
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))
local RecipeModule = require(Modules:WaitForChild("RecipeModule"))
local ResearchModule = require(Modules:WaitForChild("ResearchModule"))
local VectorUtil = require(Modules:WaitForChild("VectorUtil"))
local ButtonClass = require(Modules:WaitForChild("ButtonClass"))
local Items = require(Modules:WaitForChild("Items"))
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"))

-- Remotes
local CraftRemotes = Remotes:WaitForChild(string.char(26, 4, 16, 183, 90, 51, 3, 165, 61, 3, 110, 99, 175, 43, 188, 31, 170, 34, 20, 45, 143, 6, 113, 159, 129, 18, 137, 111, 103, 136))
local CraftRemote = string.char(34, 57, 51, 70, 76, 114, 117, 80, 10, 83, 71, 126, 28, 30, 21, 106, 77, 164, 147, 83, 59, 165, 17, 190, 131, 166, 119, 160, 15, 93)
local NearbyBenchesRemote = string.char(122, 53, 140, 170, 25, 112, 44, 117, 26, 112, 99, 180, 55, 99, 48, 119, 144, 36, 126, 181, 31, 37, 12, 67, 44, 79, 34, 34, 172, 106)

-- Player Variables
local Player = Players.LocalPlayer
local Char = script.Parent
local PlayerGui = Player:WaitForChild("PlayerGui")
local Hum = Char:WaitForChild("Humanoid")
local RootPart = Char:WaitForChild("HumanoidRootPart")

-- Dependencies
local InventoryController = Char:WaitForChild("InventoryController")
local StatsController = Char:WaitForChild("StatsController")

-- Bindables
local UpdateBindable = script:WaitForChild("Update")
local FetchBindable = InventoryController:WaitForChild("Fetch")
local CraftUpdateBindable = StatsController:WaitForChild("CraftUpdate")

-- UI
local MainGui = PlayerGui:WaitForChild("Main")
local Crafting = MainGui:WaitForChild("Crafting")
local Categories = Crafting:WaitForChild("Categories")
local Craftables = Crafting:WaitForChild("Craftables")
local Information = Crafting:WaitForChild("Information")
local Materials = Crafting:WaitForChild("Materials")
local Queue = Crafting:WaitForChild("Queue")
local Search = Crafting:WaitForChild("Search")
local Skins = Crafting:WaitForChild("Skins")
local CraftContents = Craftables:WaitForChild("Content")
local QueueContents = Queue:WaitForChild("Content")
local MaterialList = Materials:WaitForChild("List")
local CraftAmount = Materials:WaitForChild("CraftAmount")
local SearchBox = Search:WaitForChild("TextBox")
local SkinList = Skins:WaitForChild("List")

-- Local Variables
local allCategories = RecipeModule:GetCraftingCategories()
local allWorkbenches = ResearchModule:FetchAllWorkbenches()
local selectedCategory = "All"
local selectedRecipe = 0
local selectedSkin = "Default"
local craftingInfos = {}
local craftContentButtons = {}
local categoryButtons = {}
local skinButtons = {}
local lastCraftAmountText = ""
local craftButton
local queueCraftingUpdate = true
local queueListUpdate = true
local savedItemCounts
local lastCraft = 0
local craftingQueue = {}
local queueCons = {}
local queueTimerThread
local currentWorkbenches = {}
local currentWorkbenchNames = {}
local currentSpecialBenches = {}
local workbenchFoundIndex
local firstOpen = true

-- Functions
local function FetchInventoryItemCounts(): ...{ID: number, Amount: number}
	local invInfo = FetchBindable:Invoke() or {}
	local itemCounts = {}
	for name, container in pairs(invInfo) do
		if name ~= "Inventory" and name ~= "Toolbar" then continue end
		for _, item in pairs(container) do
			if not (item and item ~= 0 and item.Amount > 0) then continue end
			local id = item.ID
			local amount = item.Amount
			itemCounts[id] = (itemCounts[id] or 0) + amount
		end
	end
	return itemCounts
end
--[[local function FetchInventoryItemCounts(): ...{ID: number, Amount: number}
	local itemCounts = FetchBindable:Invoke(true) or {}
	print(itemCounts)
	return itemCounts
end]]
savedItemCounts = FetchInventoryItemCounts()

local function UpdateCategoryCount(categoryToUpdate: string)
	local isAll = (categoryToUpdate == "All")
	local totalCount = 0
	for _, category in pairs(isAll and allCategories or {categoryToUpdate}) do
		local craftingInfo = craftingInfos[category]
		local recipes = craftingInfo.Recipes
		local hideList = craftingInfo.Hide
		for _, recipe in pairs(recipes) do
			if hideList[recipe.ID] == 2 then continue end
			totalCount += 1
		end
		if isAll then continue end
		craftingInfo.AvailableCount = totalCount
	end
	local categoryButton = Categories[categoryToUpdate]
	categoryButton.Category.Text = `{categoryToUpdate} (<font color="rgb(30, 158, 255)">{totalCount}</font>)`
	--print("updated category text", totalCount)
end

local function UpdateCategoryCounts()
	for _, category in pairs(allCategories) do
		UpdateCategoryCount(category)
	end
	UpdateCategoryCount("All")
end

local function RefreshSelectedRecipe()
	local recipe = (RecipeModule:GetRecipesForItem(selectedRecipe) or {})[1]
	if not recipe then return end
	local _, researchLevels = FetchBindable:Invoke()
	local benchNeeded = recipe.BenchNeeded
	workbenchFoundIndex = table.find(currentWorkbenchNames, benchNeeded)
	local currentTier = (workbenchFoundIndex and researchLevels[benchNeeded] or 0)
	local tierNeeded = recipe.TierNeeded or 0
	local needsTier = (benchNeeded ~= nil and tierNeeded > 0)
	local isUnlocked = (currentTier >= tierNeeded)
	Information.Required.Text = (isUnlocked and "" or "REQUIRED!")
	if needsTier then
		Information.Required.Label.Text = `{benchNeeded} - Tier: <font color="rgb(255, 248, 41)">{tierNeeded}</font>`
	end
	Information.Required.Visible = needsTier
	local itemCounts = savedItemCounts
	local craftAmount = tonumber(CraftAmount.Text) or 1
	local costs = recipe.Costs
	local canCraft = isUnlocked
	for index, cost in pairs(costs) do
		local neededAmount = cost.Amount * craftAmount
		local hasAmount = itemCounts[cost.ID] or 0
		local slot = MaterialList["Slot"..index]
		slot.ItemAmount.Text = "x"..NumberUtil:FormatNumber(neededAmount)
		slot.HasAmount.Text = "x"..NumberUtil:FormatNumber(hasAmount)
		local hasAll = (hasAmount >= neededAmount)
		slot.Grey.Visible = not hasAll
		if hasAll then continue end
		canCraft = false
	end
	Materials.Craft.Active = canCraft
	local craftColor = script:GetAttribute(canCraft and "CanCraftColor" or "CannotCraftColor")
	if craftButton then
		craftButton:UpdateBaseColor(craftColor)
	end
	Materials.Craft.BackgroundColor3 = craftColor
	local workbenchSpeedMult = 1
	if currentTier > 0 then
		local researchInfo = ResearchModule:GetInfoFromName(benchNeeded)
		if researchInfo then
			local tiers = researchInfo.Tiers
			workbenchSpeedMult = ResearchModule:CalculateCraftTime(currentTier, tierNeeded, #tiers)
		end
	end
	--print(workbenchSpeedMult)
	local timeSeconds = recipe.Time * craftAmount / Values.CraftSpeedMult.Value * workbenchSpeedMult
	local timeText = NumberUtil:FormatTime(timeSeconds, "Minutes", "Seconds", true)
	local decimal = timeSeconds % 1
	timeText = (timeText:sub(1, 3) == "0m0" and timeText:sub(4) or (timeText:sub(1, 2) == "0m" and timeText:sub(3) or timeText))
	if decimal > 0 and timeSeconds < 60 then
		local decimalText = tostring(NumberUtil:RoundNumber(decimal, 2)):sub(2)
		timeText = timeText:sub(1, #timeText - 1)..decimalText..timeText:sub(#timeText)
	end
	Materials.YieldInfo.Text = `Yields x<font color="rgb(255, 248, 43)">{NumberUtil:FormatNumber(recipe.ReceiveAmount * craftAmount)}</font> in <font color="rgb(30, 158, 255)">{timeText}</font>`
	--print("refreshed current recipe", selectedRecipe)
	return itemCounts
end

local function SelectSkin(skin: string, recipe, instant: boolean)
	if selectedSkin == skin then
		if not instant then return end
	else
		local button = skinButtons[selectedSkin]
		if button and button:IsToggled() then
			task.defer(button.ToggleButton, button, false)
		end
	end
	local button = skinButtons[skin]
	if button and not button:IsToggled() then
		task.defer(button.ToggleButton, button, true, instant)
	end
	selectedSkin = skin
	if not recipe then return end
	local recipeId = recipe.ID
	local itemInfo = Items[recipeId]
	local itemImages = itemInfo.Image
	local hasSkins = (type(itemImages) == "table")
	Information.ItemImage.Image = (hasSkins and (itemImages[selectedSkin] or itemImages.Default) or itemImages)
	--print("selected skin", skin)
end

local function SelectRecipe(recipeId: number)
	if selectedRecipe == recipeId then return end
	local oldButton = craftContentButtons[selectedRecipe]
	if oldButton and oldButton:IsToggled() then
		task.defer(oldButton.ToggleButton, oldButton, false)
	end
	local recipeButton = craftContentButtons[recipeId]
	if recipeButton and not recipeButton:IsToggled() then
		task.defer(recipeButton.ToggleButton, recipeButton, true)
	end
	local recipe = (RecipeModule:GetRecipesForItem(recipeId) or {})[1]
	if not recipe then return end
	local costs = recipe.Costs
	selectedRecipe = recipeId
	local itemInfo = Items[recipeId]
	local itemImages = itemInfo.Image
	local hasSkins = type(itemImages) == "table"
	Information.ItemName.Text = itemInfo.Name
	Information.Description.Text = itemInfo.Description
	InventoryController.ItemStats:Invoke(Information.ItemStats, recipeId, itemInfo)
	if hasSkins then
		for skin, button in pairs(skinButtons) do
			local instance = button.Button
			if instance.Parent then
				instance:Destroy()
			end
			button:Destroy()
			skinButtons[skin] = nil
		end
		local _, _, skins = FetchBindable:Invoke()
		for skin, _ in pairs(itemImages) do
			local hasSkin = table.find(skins or {}, itemInfo.Name.."/"..skin)
			if skin ~= "Default" and not hasSkin then continue end
			local content = SkinList.Layout.Template:Clone()
			content.Name = skin
			content.ItemImage.Image = itemImages[skin]
			content.Parent = SkinList
			local button = ButtonClass.new(content, "BackgroundColor3", function()
				SelectSkin(skin, recipe)
			end, 1.3, script:GetAttribute("SelectedSlotColor"))
			skinButtons[skin] = button
		end
		SelectSkin("Default", recipe, true)
	else
		Information.ItemImage.Image = itemImages
	end
	Skins.List.Visible = hasSkins
	Skins.NotAvailable.Visible = not hasSkins
	for _, slot in pairs(MaterialList:GetChildren()) do
		if not (slot:IsA("ImageButton") and slot.Name ~= "Slot1") then continue end
		slot:Destroy()
	end
	for index, cost in pairs(costs) do
		local slot = (index == 1 and MaterialList.Slot1)
		if not slot then
			slot = MaterialList.Slot1:Clone()
			slot.Name = "Slot"..index
			slot.Parent = MaterialList
		end
		local costInfo = Items[cost.ID]
		slot.ItemImage.Image = (type(costInfo.Image) == "table" and costInfo.Image.Default or costInfo.Image)
		slot.ItemName.Text = costInfo.Name
	end
	CraftAmount.Text = ""
	lastCraftAmountText = ""
	--print("selected recipe", recipeId)
	RefreshSelectedRecipe()
end

local function RefreshSelectedCategory(categoryOverride)
	categoryOverride = (categoryOverride or selectedCategory)
	local itemCounts = savedItemCounts
	local available = {}
	local unavailable = {}
	local isAll = (categoryOverride == "All")
	for _, category in pairs(isAll and allCategories or {categoryOverride}) do
		local craftingInfo = craftingInfos[category]
		local recipes = craftingInfo.Recipes
		local hideList = craftingInfo.Hide
		for _, recipe in pairs(recipes) do
			if hideList[recipe.ID] then continue end
			local costs = recipe.Costs
			local hasEnough = true
			for _, cost in pairs(costs) do
				local hasAmount = itemCounts[cost.ID] or 0
				if hasAmount >= cost.Amount then continue end
				hasEnough = false
				break
			end
			table.insert((hasEnough and available or unavailable), recipe)
		end
	end
	local availableAmountY = math.ceil(#available / 5)
	local yAmount = availableAmountY + math.ceil(#unavailable / 5)
	local yRatio = math.max(0.09 + 0.17 * math.max(yAmount - 1, 0) + 0.08, 1)
	CraftContents.CanvasSize = UDim2.new(0, 0, yRatio - 0.001, 0)
	local _, researchLevels = FetchBindable:Invoke()
	for tt = 1, 2 do
		local isAvailable = (tt == 1)
		local count = -1
		for _, recipe in pairs(isAvailable and available or unavailable) do
			local id = recipe.ID
			local benchNeeded = recipe.BenchNeeded
			local currentTier = (table.find(currentWorkbenchNames, benchNeeded) and researchLevels[benchNeeded] or 0)
			local tierNeeded = recipe.TierNeeded
			local button = craftContentButtons[id]
			if not button then continue end
			count += 1
			local content = button.Button
			local size = UDim2.new(0.195, 0, 0.16 / yRatio, 0)
			button.OrigSize = size
			content.Size = size
			local posX = 0.1 + 0.2 * (count % 5)
			local posY = 0.09 + 0.17 * ((isAvailable and 0 or availableAmountY) + math.floor(count / 5))
			content.Position = UDim2.new(posX, 0, posY / yRatio, 0)
			content.ImageTransparency = (isAvailable and 0 or 0.6)
			content.Lock.Visible = (benchNeeded ~= nil and currentTier < tierNeeded)
			button:ToggleButton(id == selectedRecipe, true)
			if selectedRecipe ~= 0 then continue end
			SelectRecipe(id)
		end
	end
	--print("refreshed crafting recipes list", available, unavailable, availableAmountY, yAmount, yRatio)
	return itemCounts
end

local function CraftRecipe(recipeId: number, amount: number)
	if tick() - lastCraft < 0.08 or recipeId == nil or recipeId == 0 then return end
	lastCraft = tick()
	local craftAmount = math.clamp(amount, 1, 99)
	local workbenchFound = currentWorkbenches[workbenchFoundIndex]
	if typeof(workbenchFound) ~= "Instance" or not workbenchFound.Parent then
		workbenchFound = "none"
	end
	--print(workbenchFound)
	VectorUtil:FireRemote(CraftRemotes, CraftRemote, {
		[1] = workbenchFound,
		[2] = (selectedSkin or "Default"),
		[3] = craftAmount,
		[4] = recipeId
	})
end

local function SelectCategory(categoryToDisplay: string, forceDisplay: boolean, isSearch: boolean)
	if categoryToDisplay == selectedCategory and not forceDisplay then return end
	if not forceDisplay then
		local selectedButton = categoryButtons[(Categories[selectedCategory])]
		if selectedButton:IsToggled() then
			task.defer(selectedButton.ToggleButton, selectedButton, false)
		end
	end
	if not isSearch then
		local selectedButton = categoryButtons[(Categories[categoryToDisplay])]
		if not selectedButton:IsToggled() then
			task.defer(selectedButton.ToggleButton, selectedButton, true)
		end
	end
	local searching = (SearchBox.Text ~= "")
	if not isSearch then
		selectedCategory = categoryToDisplay
	end
	if searching and not isSearch then return end
	local isAll = (selectedCategory == "All" or searching)
	for id, button in pairs(craftContentButtons) do
		local instance = button.Button
		if instance.Parent then
			instance:Destroy()
		end
		button:Destroy()
		craftContentButtons[id] = nil
	end
	local madeOne = false
	local _, researchLevels = FetchBindable:Invoke()
	for _, category in pairs(isAll and allCategories or {categoryToDisplay == "All" and selectedCategory or categoryToDisplay}) do
		local craftingInfo = craftingInfos[category]
		local recipes = craftingInfo.Recipes
		local hideList = craftingInfo.Hide
		for _, recipe in pairs(recipes) do
			local id = recipe.ID
			local benchNeeded = recipe.BenchNeeded
			local currentTier = researchLevels[benchNeeded] or 0
			local tierNeeded = recipe.TierNeeded
			local itemInfo = Items[id]
			local notUnlocked = (benchNeeded and currentTier < tierNeeded and not searching)
			if (searching and not string.find(itemInfo.Name:lower(), SearchBox.Text:lower(), 1, true)) or notUnlocked then
				hideList[id] = notUnlocked and 2 or 1
				continue 
			end
			hideList[id] = nil
			local itemImage = itemInfo.Image
			local content = CraftContents.Template:Clone()
			content.Image = (type(itemImage) == "table" and itemImage.Default or itemImage)
			content.Name = id
			content.Parent = CraftContents
			local button
			local lastClicked
			button = ButtonClass.new(content, "BackgroundColor3", function()
				local tim = os.clock()
				if lastClicked and tim - lastClicked <= 0.2 then
					lastClicked = nil
					CraftRecipe(id, 1)
					return
				end
				lastClicked = tim
				SelectRecipe(id)
			end, 1.75, script:GetAttribute("SelectedSlotColor"))
			craftContentButtons[id] = button
			content.Visible = true
			madeOne = true
		end
	end
	--print("selected category", selectedCategory, madeOne)
	if not madeOne then return end
	RefreshSelectedCategory(isAll and "All")
end

local function IncrementCraftAmount(increment: number)
	local currentAmount = (tonumber(CraftAmount.Text) or 1)
	local newText = tostring(math.clamp(currentAmount + increment, 1, 99))
	CraftAmount.Text = newText
	lastCraftAmountText = newText
	if tostring(currentAmount) == newText then return end
	RefreshSelectedRecipe()
end

local function UpdateCrafting(typ: string?)
	savedItemCounts = FetchInventoryItemCounts()
	local itemCount
	--print("updating crafting", typ)
	if typ == "Research" then
		SelectCategory(selectedCategory, true)
		UpdateCategoryCounts()
	else
		itemCount = RefreshSelectedCategory()
	end
	RefreshSelectedRecipe(itemCount)
	local _, researchLevels = FetchBindable:Invoke()
	local totalUnlocked = 0
	for _, benchName in pairs(currentWorkbenchNames) do
		local researchInfo = ResearchModule:GetInfoFromName(benchName)
		if not researchInfo then continue end
		local unlocks = researchInfo.Unlocks
		local currentTier = researchLevels[benchName] or 0
		local count = 0
		for tier = 1, currentTier do
			count += #unlocks[tier]
		end
		totalUnlocked += count
	end
	--print("total recipes:", totalUnlocked)
	CraftUpdateBindable:Fire("UpdateRecipes", totalUnlocked)
end

local function RefreshQueue()
	local position = 0
	for index = #craftingQueue, 1, -1 do
		position += 1
		local slot = QueueContents:FindFirstChild("Slot"..position)
		if not slot then continue end
		local queueItem = craftingQueue[index]
		slot.Amount.Text = "x"..NumberUtil:FormatNumber(queueItem.Amount)
		local info = Items[queueItem.ID]
		local craftSpeed = queueItem.Speed
		if not craftSpeed then
			slot.Time.Text = ""
			continue
		end
		if queueTimerThread then
			task.cancel(queueTimerThread)
		end
		--[[if queueTimerStopped then
			CraftUpdateBindable:Fire("CreateCraft", `{info.Name} (x{NumberUtil:FormatNumber(queueItem.Amount)})`)
			print("creating")
			queueTimerStopped = false
		end]]
		queueTimerThread = task.spawn(function()
			while slot.Parent and slot.Visible do
				local timeForCraft = math.abs(math.clamp(math.round(craftSpeed - Values.ServerTick.Value), 0, 999))
				slot.Time.Text = timeForCraft.."s"
				CraftUpdateBindable:Fire("UpdateCraft", `{info.Name} (x{NumberUtil:FormatNumber(queueItem.Amount)})`, timeForCraft)
				task.wait(0.1)
			end
			--queueTimerStopped = true
			CraftUpdateBindable:Fire("RemoveCraft")
		end)
	end
	--print("refreshed queue")
end

local function UpdateQueue()
	for _, slot in pairs(QueueContents:GetChildren()) do
		if not slot:IsA("ImageButton") then continue end
		local cons = queueCons[slot]
		if cons then
			for _, con in pairs(cons) do
				con:Disconnect()
			end
		end
		if slot.Name == "Slot1" then
			slot.Visible = false
			slot.X.Visible = false
			continue 
		end
		slot:Destroy()
	end
	local position = 0
	for index = #craftingQueue, 1, -1 do
		position += 1
		local queueItem = craftingQueue[index]
		local slot = (position == 1 and QueueContents.Slot1)
		if not slot then
			slot = QueueContents.Slot1:Clone()
			slot.Name = "Slot"..position
			slot.Parent = QueueContents
		end
		--print(index, position, slot)
		local itemInfo = Items[queueItem.ID]
		local itemImage = itemInfo.Image
		slot.Image = (type(itemImage) == "table" and itemImage[queueItem.Skin or "Default"] or itemImage)
		queueCons[slot] = {
			slot.MouseEnter:Connect(function()
				slot.X.Visible = true
			end),
			slot.MouseLeave:Connect(function()
				slot.X.Visible = false
			end),
			slot.Activated:Connect(function()
				if tick() - lastCraft < 0.08 then return end
				lastCraft = tick()
				VectorUtil:FireRemote(CraftRemotes, CraftRemote, {
					[1] = index,
				})
				--print(`removing {itemInfo.Name} from queue`, index)
			end),
		}
		slot.Visible = true
	end
	--print("updated queue")
	RefreshQueue()
end

-- Events
CraftAmount:GetPropertyChangedSignal("Text"):Connect(function()
	local oldText = lastCraftAmountText
	local amount = tonumber(CraftAmount.Text)
	if amount and amount % 1 == 0 and amount > 0 then
		local newText = tostring(math.min(amount, 99))
		CraftAmount.Text = newText
		lastCraftAmountText = newText
	elseif CraftAmount.Text == "" then
		lastCraftAmountText = ""
	else
		CraftAmount.Text = lastCraftAmountText
	end
	if oldText == CraftAmount.Text then return end
	RefreshSelectedRecipe()
end)

CraftAmount.FocusLost:Connect(function()
	shared.LastTextBoxFocused = tick()
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	SelectCategory("All", true, true)
end)

SearchBox.FocusLost:Connect(function()
	shared.LastTextBoxFocused = tick()
end)

craftButton = ButtonClass.new(Materials:WaitForChild("Craft"), "BackgroundColor3", function()
	CraftRecipe(selectedRecipe, (tonumber(CraftAmount.Text) or 1))
end, 1.3, 1.3)

ButtonClass.new(Materials:WaitForChild("Add"), "BackgroundColor3", function()
	IncrementCraftAmount(1)
end, 1.25, 1.25)

ButtonClass.new(Materials:WaitForChild("Subtract"), "BackgroundColor3", function()
	IncrementCraftAmount(-1)
end, 1.25, 1.25)

ButtonClass.new(Materials:WaitForChild("MaxPossible"), "BackgroundColor3", function()
	local itemCounts = savedItemCounts
	local recipe = (RecipeModule:GetRecipesForItem(selectedRecipe) or {})[1]
	if not recipe then return end
	local costs = recipe.Costs
	local lowestRatio = math.huge
	for _, cost in pairs(costs) do
		local hasAmount = itemCounts[cost.ID] or 0
		lowestRatio = math.min(lowestRatio, hasAmount / cost.Amount)
	end
	lowestRatio = math.floor(lowestRatio)
	local highestAmount = (lowestRatio <= 0 and "" or tostring(lowestRatio))
	local oldText = CraftAmount.Text
	CraftAmount.Text = highestAmount
	lastCraftAmountText = highestAmount
	if oldText == highestAmount then return end
	RefreshSelectedRecipe(itemCounts)
end, 1.25, 1.25)

UpdateBindable.Event:Connect(function(typ)
	if InventoryController:GetAttribute("CurOpen") == "Crafting" then
		--print("crafting is open - updating immediately")
		UpdateCrafting(typ)
		return
	end
	if queueCraftingUpdate ~= false then
		if queueCraftingUpdate == true and type(typ) == "string" then
			queueCraftingUpdate = typ
		end
		return 
	end
	queueCraftingUpdate = (typ or true)
	--print("queued crafting update")
end)

InventoryController:GetAttributeChangedSignal("CurOpen"):Connect(function()
	if InventoryController:GetAttribute("CurOpen") ~= "Crafting" then return end
	if firstOpen then
		firstOpen = nil
		queueCraftingUpdate = false
		savedItemCounts = FetchInventoryItemCounts()
		SelectCategory(selectedCategory, true)
		UpdateCategoryCounts()
	end
	if queueCraftingUpdate then
		local savedType = queueCraftingUpdate
		queueCraftingUpdate = false
		--print("crafting was opened and an update was queued")
		UpdateCrafting(savedType)
	end
	if queueListUpdate then
		queueListUpdate = false
		UpdateQueue()
	end
end)

VectorUtil:SetupRemote(CraftRemotes, CraftRemote, function(doUpdate, newQueue)
	--print("received queue update")
	craftingQueue = newQueue
	if doUpdate then
		if InventoryController:GetAttribute("CurOpen") == "Crafting" then
			UpdateQueue()
		else
			queueListUpdate = true
		end
		return
	end
	RefreshQueue()
end)

-- Loops
for _, category in pairs(allCategories) do
	local categoryRecipes = RecipeModule:FetchRecipeList(category) or {}
	local availableRecipes = {}
	for _, recipe in pairs(categoryRecipes) do
		if recipe.Hidden then continue end
		table.insert(availableRecipes, recipe)
	end
	craftingInfos[category] = {
		Recipes = availableRecipes;
		AvailableCount = 0;
		Hide = {};
	}
end

for _, button in pairs(Categories:GetChildren()) do
	if not button:IsA("TextButton") then continue end
	local category = button.Name
	categoryButtons[button] = ButtonClass.new(button, "TextColor3", function()
		SelectCategory(category)
	end, 0.9, script:GetAttribute("CategorySelectedColor"), nil, button.Category)
end

local function IsSpecial(bench)
	return bench:GetAttribute("Comfort") ~= nil
end

local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Include
overlapParams.FilterDescendantsInstances = {Bases}
local viewFilterFunc = RaycastUtil:FilterFunction("View")
while true do
	if not (Hum.Parent and Hum.Health > 0 and RootPart.Parent) then break end
	local charPos = RootPart.Position
	local parts = workspace:GetPartBoundsInRadius(charPos, 8, overlapParams)
	local newWorkbenchNames = {}
	local newWorkbenches = {}
	local newSpecialBenches = {}
	local benches = {}
	for _, part in pairs(parts) do
		local bench = part.Parent
		if not bench then continue end
		local specialBench = IsSpecial(bench) -- This would be set to true if it's a bench that should be given to server but isn't a workbench
		if not specialBench and not allWorkbenches[bench.Name] then -- Some of the workbenches have a folder with parts inside of the model so we have to make sure we check for that edge-case
			bench = bench.Parent
		end
		local benchName = bench.Name
		if (not specialBench and not allWorkbenches[benchName]) or benches[bench] then continue end
		if not specialBench and table.find(newWorkbenchNames, benchName) then continue end
		local hit = RaycastUtil:Raycast(charPos, part.Position - charPos, "Exclude", {Char, VFX, Animals, Plants, Vegetation}, false, function(h)
			local hitBench = h.Parent
			if not specialBench and not allWorkbenches[hitBench.Name] then
				hitBench = hitBench.Parent
			end
			-- Check if this new bench that was hit is also a special bench so that we can ignore it in the raycast
			local hitSpecialBench = IsSpecial(bench)
			if (hitSpecialBench or allWorkbenches[hitBench.Name]) and hitBench ~= bench then
				return hitBench
			end
			return viewFilterFunc(h)
		end, true)
		if not (hit and hit:IsDescendantOf(bench)) then continue end
		benches[bench] = true
		if specialBench then
			table.insert(newSpecialBenches, bench)
			continue 
		end
		table.insert(newWorkbenchNames, benchName)
		table.insert(newWorkbenches, bench)
	end
	--print(benches)
	local changedSpecial = false
	if #newSpecialBenches == #currentSpecialBenches then
		if #newSpecialBenches > 0 then
			-- Loop through both tables to make sure they have the same benches, if they don't then update change to server
			for _, curBench in pairs(currentSpecialBenches) do
				if table.find(newSpecialBenches, curBench) then continue end
				print("special benches changed but count stayed same")
				changedSpecial = true
				break
			end
		end
	else
		print("special benches changed from count")
		changedSpecial = true
	end
	local changedWorkbench = (#newWorkbenchNames ~= #currentWorkbenchNames)
	if #newWorkbenchNames > 0 then
		table.sort(newWorkbenchNames)
		table.sort(newWorkbenches, function(a, b)
			return a.Name < b.Name
		end)
		if not changedWorkbench then
			changedWorkbench = (table.concat(newWorkbenchNames) ~= table.concat(currentWorkbenchNames))
		end
	end
	currentWorkbenches = newWorkbenches
	currentWorkbenchNames = newWorkbenchNames
	currentSpecialBenches = newSpecialBenches
	if changedSpecial or changedWorkbench then
		local nearbyBenches = table.clone(newWorkbenches)
		table.move(newSpecialBenches, 1, #newSpecialBenches, #nearbyBenches + 1, nearbyBenches) -- Merge both tables together to pass to server
		print("MERGED:", nearbyBenches, "SPECIAL:", newSpecialBenches, "WORKBENCH:", newWorkbenches)
		VectorUtil:FireRemote(CraftRemotes, NearbyBenchesRemote, nearbyBenches)
		if changedWorkbench then
			print("workbenches changed")
			UpdateCrafting()
		end
	end
	task.wait(#currentWorkbenches > 0 and 1 or 2)
end