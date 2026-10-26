-- [PATH] ServerStorage / Modules / CrafterClass @Type ModuleScript
--[[
	CrafterClass
	by ChickenBagelz
	October 9, 2023
	
	Holds the crafting queue of a user
]]


-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local ServerScripts = game:GetService("ServerScriptService")

-- Dependencies
local ServerService = ServerScripts:WaitForChild("ServerService")

-- Folders
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")
local Values = Replicated:WaitForChild("Values")

-- Modules
local Items = require(SharedModules:WaitForChild("Items"))
local RecipeModule = require(SharedModules:WaitForChild("RecipeModule"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local ResearchModule = require(SharedModules:WaitForChild("ResearchModule"))

-- Remotes
local CraftRemotes = Remotes:WaitForChild(string.char(26, 4, 16, 183, 90, 51, 3, 165, 61, 3, 110, 99, 175, 43, 188, 31, 170, 34, 20, 45, 143, 6, 113, 159, 129, 18, 137, 111, 103, 136))
local AllRemotes = {
	Craft = string.char(34, 57, 51, 70, 76, 114, 117, 80, 10, 83, 71, 126, 28, 30, 21, 106, 77, 164, 147, 83, 59, 165, 17, 190, 131, 166, 119, 160, 15, 93);
}


local CrafterClass = {}
CrafterClass.__index = CrafterClass

function CrafterClass.new(player)
	local self = setmetatable({}, CrafterClass)
	
	self.Player = player
	self.CraftingQueue = {}
	self.Running = false
	
	return self
end

function CrafterClass:CraftRecipe(recipe, craftAmount: number, skin: string?)
	skin = (skin or "Default")
	local player = self.Player
	local craftingQueue = self.CraftingQueue
	local user = shared.Users[player]
	local researchLevels = user.ResearchLevels
	local nearbyBenches = user.NearbyBenches
	local benchNeeded = recipe.BenchNeeded
	local tierNeeded = recipe.TierNeeded
	local currentTier = (researchLevels[benchNeeded] or 0)
	if (benchNeeded and currentTier < tierNeeded) or recipe.Hidden then
		--print("RECIPE NOT UNLOCKED YET", recipe.Id, currentTier, tierNeeded)
		return
	end
	local recipeId = recipe.ID
	local recipeInfo = Items[recipeId]
	local receiveAmount = recipe.ReceiveAmount
	local inventory = user.Inventory
	local costs = recipe.Costs
	local foundItems = {}
	local actualCraftAmount = craftAmount
	for _, cost in pairs(costs) do
		local costAmount = cost.Amount
		local totalAmount = costAmount * actualCraftAmount
		local _, found, left = inventory:FindItem(totalAmount, {"Inventory", "Toolbar"}, {cost.ID})
		local hasAmount = totalAmount - left
		actualCraftAmount = math.min(math.floor(hasAmount / costAmount), actualCraftAmount)
		if actualCraftAmount <= 0 then return end
		table.insert(foundItems, found)
	end
	local latestQueueItem = craftingQueue[#craftingQueue]
	local isQueueMaxed = (#craftingQueue >= 9)
	local ignoreQueueAdd = false
	local maxStack = math.ceil(recipeInfo.MaxStack * ServerService:GetAttribute("MaxStackMult") / receiveAmount)
	if latestQueueItem and latestQueueItem.ID == recipeId and (latestQueueItem.Skin or "Default") == skin then
		local firstAmount = latestQueueItem.Amount
		if firstAmount >= maxStack and isQueueMaxed then return end
		--[[local newAmount = math.min(firstAmount + actualCraftAmount, maxStack)
		local origAmount = actualCraftAmount
		origAmount -= origAmount - (newAmount - firstAmount) -- same as doing the change and left logic but with extra steps lol but whatever
		ignoreQueueAdd = (actualCraftAmount == origAmount or isQueueMaxed)
		if ignoreQueueAdd then
			actualCraftAmount = origAmount
			firstQueueItem.Amount = newAmount
		end]]
	elseif isQueueMaxed then
		--print("CRAFTING QUEUE IS FULL")
		return
	end
	local startQueue = false
	local addedToQueue = false
	local queueItemsChanged = {}
	if not ignoreQueueAdd then
		local left = actualCraftAmount
		for i = 1, math.min(10 - #craftingQueue, 9) do
			local queueItem = (i == 1 and craftingQueue[#craftingQueue])
			if not queueItem then
				addedToQueue = true
				queueItem = {
					ID = recipeId;
					Amount = 0;
				}
				if skin ~= "Default" then
					queueItem.Skin = skin
				end
				table.insert(craftingQueue, queueItem)
				if #craftingQueue == 1 then
					startQueue = true
				end
			elseif queueItem.ID ~= recipeId or (queueItem.Skin or "Default") ~= skin then
				continue
			end
			local newAmount = math.min(queueItem.Amount + left, maxStack)
			local change = newAmount - queueItem.Amount
			queueItem.Amount = newAmount
			left -= change
			table.insert(queueItemsChanged, {queueItem, change})
			if left <= 0 then break end
		end
		actualCraftAmount -= left
		if actualCraftAmount <= 0 then return end
	end
	local allUpdates = {}
	for index, cost in pairs(costs) do
		local costId = cost.ID
		local found = foundItems[index]
		local totalAmount = cost.Amount * actualCraftAmount
		local updates, left, savedInfos = inventory:RemoveFoundItems(found, totalAmount, true)
		if savedInfos then
			--print(savedInfos)
			for i, v in pairs(queueItemsChanged) do
				local queueItem = v[1]
				local changedAmount = v[2]
				local savedInfo = queueItem.SavedInfo
				if not savedInfo then
					savedInfo = {}
					queueItem.SavedInfo = savedInfo
				end
				for i = 1, changedAmount do
					table.insert(savedInfo, savedInfos[1])
					table.remove(savedInfos, 1)
				end
				--print(i, queueItem, changedAmount)
			end
		end
		for _, update in pairs(updates) do
			table.insert(allUpdates, update)
		end
	end
	inventory:UpdateClient(unpack(allUpdates))
	ModUtil:FireClient(CraftRemotes, AllRemotes.Craft, player, addedToQueue, craftingQueue)
	--print(`CRAFTED x{actualCraftAmount}/({craftAmount}) {Items[recipeId].Name} {skin}`)
	if startQueue then
		self:StartQueue()
	end
end

function CrafterClass:StartQueue()
	if self.Running then return end
	local player = self.Player
	local user = shared.Users[player]
	local researchLevels = user.ResearchLevels
	local inventory = user.Inventory
	self.Running = true
	--print("starting crafting queue")
	while self.Running and player.Parent and not user.Left do
		local craftingQueue = self.CraftingQueue
		if #craftingQueue <= 0 then break end
		local firstItem = craftingQueue[1]
		local recipe
		local doUpdate = false
		local removedFromQueue = false
		if not firstItem.Speed then
			recipe = RecipeModule:GetRecipesForItem(firstItem.ID)[1]
			local benchNeeded = recipe.BenchNeeded
			local workbenchSpeedMult = 1
			if benchNeeded then
				local researchInfo = ResearchModule:GetInfoFromName(benchNeeded)
				if researchInfo then
					local nearbyBenches = user.NearbyBenches
					for _, bench in pairs(nearbyBenches) do
						if not (bench.Parent and bench.Name == benchNeeded) then continue end
						local currentTier = (researchLevels[benchNeeded] or 0)
						local tierNeeded = recipe.TierNeeded or 0
						local tiers = researchInfo.Tiers
						workbenchSpeedMult = ResearchModule:CalculateCraftTime(currentTier, tierNeeded, #tiers)
						--print(bench, workbenchSpeedMult)
						break
					end
				end
			end
			local craftSpeed = recipe.Time / Values.CraftSpeedMult.Value * workbenchSpeedMult
			firstItem.Speed = tick() + craftSpeed
			doUpdate = true
		end
		local timeForCraft = firstItem.Speed - tick()
		if timeForCraft <= 0 then
			doUpdate = true
			firstItem.Speed = nil
			firstItem.Amount -= 1
			if firstItem.Amount <= 0 then
				table.remove(craftingQueue, 1)
				removedFromQueue = true
			end
			--task.wait(1)
			recipe = (recipe or RecipeModule:GetRecipesForItem(firstItem.ID)[1])
			if not firstItem.Removed then
				inventory:AddItem(recipe.ID, recipe.ReceiveAmount, firstItem.Skin)
			end
			--print("MADE", firstItem.ID, "FROM QUEUE")
		else
			--print(firstItem.ID, timeForCraft, craftingQueue, #craftingQueue)
		end
		if doUpdate then
			ModUtil:FireClient(CraftRemotes, AllRemotes.Craft, player, removedFromQueue, craftingQueue)
		end
		task.wait(math.min(timeForCraft, 1))
	end
	self.Running = false
	--print("ended crafting queue")
end

function CrafterClass:RemoveFromQueue(index: number)
	local player = self.Player
	local craftingQueue = self.CraftingQueue
	local user = shared.Users[player]
	local queueItem = craftingQueue[index]
	if not queueItem then return end
	if not self:CancelCraft(index, user) then return end
	ModUtil:FireClient(CraftRemotes, AllRemotes.Craft, player, true, craftingQueue)
end

function CrafterClass:CancelAllCrafts()
	local player = self.Player
	local user = shared.Users[player]
	local craftingQueue = self.CraftingQueue
	for index = #craftingQueue, 1, -1 do
		self:CancelCraft(index, user)
	end
end

function CrafterClass:CancelCraft(index: number, user)
	local craftingQueue = self.CraftingQueue
	local queueItem = craftingQueue[index]
	if not (queueItem and queueItem.Amount > 0 and not queueItem.Removed and (index ~= 1 or queueItem.Speed)) then return end
	queueItem.Removed = true
	user = (user or shared.Users[self.Player])
	local inventory = user.Inventory
	table.remove(craftingQueue, index)
	local savedInfos = queueItem.SavedInfo
	local recipe = RecipeModule:GetRecipesForItem(queueItem.ID)[1]
	for _, cost in pairs(recipe.Costs) do
		local costId = cost.ID
		if savedInfos then
			for index, savedInfo in pairs(savedInfos) do
				if savedInfo[1] ~= costId then continue end
				local skin, dur, repair = savedInfo[2], savedInfo[3], savedInfo[4]
				print("found saved info for", costId, savedInfos, index, skin, dur, repair)
				inventory:AddItem(costId, 1, skin, dur, repair)
				table.remove(savedInfos, index)
				break
			end
			continue
		end
		inventory:AddItem(costId, cost.Amount * queueItem.Amount)
	end
	return true
end

function CrafterClass:StopQueue()
	self.Running = false
end

return CrafterClass
