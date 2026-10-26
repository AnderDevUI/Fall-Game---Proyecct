-- [PATH] ReplicatedStorage / Modules / RecipeModule @Type ModuleScript
--[[
	RecipeModule
	by ChickenBagelz
	March 1, 2023
	
	Instead of having recycling, repairing, and crafting recipes/requirements all in their own code, might as well keep everything inside a table,
	since they all work the same way
]]


-- Services
local Replicated = game:GetService("ReplicatedStorage")

-- Folders
local Modules = Replicated:WaitForChild("Modules")

-- Modules
local Items = require(Modules:WaitForChild("Items"))

-- Local Variables
local Recipes = {}
local CachedRecipesForID = {}
local CraftingCategories = {"Weapons", "Tools", "Build", "Attire", "Ammo", "Resources", "Medical", "Other"}


local RecipeModule = {}

function RecipeModule:CalculateTotalCost(recipe: any, scale: number?, splitComponents: boolean?, ignoreIds: {number?}) 
	-- Calculates a table of costs scaled to the given scale variable (defaults to 1), and splits components to its resources if specified
	scale = (scale or 1)
	local calculatedCosts = {}
	local costs = recipe.Costs
	for _, cost in pairs(costs or {}) do
		local id = cost.ID
		if ignoreIds and table.find(ignoreIds, id) then continue end
		local amt = cost.Amount
		if splitComponents then -- Split the cost to its own costs if splitComponents is true and a recipe is found for the item
			local costRecipes = self:GetRecipesForItem(id)
			if #costRecipes > 0 then
				if #costRecipes > 1 then warn("MULTIPLE RECIPES FOUND FOR ID OF "..id.."; DEFAULTING TO FIRST", costRecipes[1]) end
				local costRecipe = costRecipes[1]
				local costCosts = self:CalculateTotalCost(costRecipe, scale, true, ignoreIds)
				for _, costCost in pairs(costCosts) do
					self:CombineCost(calculatedCosts, costCost.ID, costCost.Amount, scale)
				end
				-- We don't want to add the item if it's been split, so skip this current thread
				continue
			end
		end
		self:CombineCost(calculatedCosts, id, amt, scale)
	end
	return calculatedCosts
end

function RecipeModule:GetCostDifferences(recipe: any, startHealth: number, targetHealth: number, scale: number?, splitComponents: boolean?, ignoreIds: {number?})
	-- Gets cost differences between two health values, splitting components or scaling if specified
	scale = (scale or 1)
	local maxCosts = self:CalculateTotalCost(recipe, scale, splitComponents, ignoreIds)
	local lowestRatio
	for _, maxCost in pairs(maxCosts) do
		local costRatio = 1 / maxCost.Amount
		if lowestRatio and lowestRatio < costRatio then continue end
		lowestRatio = costRatio
	end
	if not lowestRatio then error("RECIPE USED FOR REPAIRING RETURNED NO VALID COSTS", recipe) end
	--print("before math:", startHealth, targetHealth, lowestRatio)
	-- Scale the repair amount if recipe's cost is very low
	targetHealth = math.min(startHealth + math.max(targetHealth, lowestRatio), 1)
	startHealth = startHealth
	--print("after:", startHealth, targetHealth)
	local startCosts = self:CalculateTotalCost(recipe, startHealth * scale, splitComponents, ignoreIds)
	local targetCosts = self:CalculateTotalCost(recipe, targetHealth * scale, splitComponents, ignoreIds)
	local diffCosts = {}
	for _, targetCost in pairs(targetCosts) do
		local startAmount = 0
		for _, startCost in pairs(startCosts) do
			if startCost.ID ~= targetCost.ID then continue end
			startAmount = startCost.Amount
			break
		end
		local amountDiff = targetCost.Amount - startAmount
		if amountDiff <= 0 then continue end
		targetCost.Amount = amountDiff
		table.insert(diffCosts, targetCost)
	end
	local actualHealth = targetHealth - startHealth
	--print(diffCosts, actualHealth)
	return diffCosts, actualHealth
end

function RecipeModule:CombineCost(totalCosts: any, id: number, amount: number, scale: number)
	-- Adds the cost to the total cost table given, stacking onto already existing tables if present and applying scale multiplier
	local newCost = {}
	local found = false
	for _, currentCost in pairs(totalCosts) do
		if currentCost.ID ~= id then continue end
		-- Found recipe Id in current total costs, use that table instead of making a new one
		found = true
		newCost = currentCost
		break
	end
	local newAmount = (newCost.Amount or 0) + amount * scale -- Scale amount properly
	if newAmount <= 0 then return end -- Don't add to total if amount is 0
	newCost.ID = id
	newCost.Amount = newAmount
	if not found then
		table.insert(totalCosts, newCost)
	end
	return newCost
end

function RecipeModule:GetRecipesForItem(recipeId: string|number) -- Easy way to get all crafting recipes associated with an ID, caches results for easy locating after
	local cachedRecipes = CachedRecipesForID[recipeId]
	if cachedRecipes then
		return cachedRecipes -- Found cached results so we don't have to reloop through every single recipe
	end
	local found = {}
	for _, recipeList in pairs(Recipes) do
		for _, recipe in pairs(recipeList.Recipes) do
			if recipe.ID ~= recipeId then continue end
			recipe.Category = recipeList.Type
			table.insert(found, recipe)
		end
	end
	CachedRecipesForID[recipeId] = found -- Set cache for next time we loop for same ID
	return found
end

function RecipeModule:FetchRecipe(recipeType: string, recipeId: string|number) -- Returns a recipe table based on the recipe type and ID
	local recipeList = self:FetchRecipeList(recipeType)
	if not recipeList then return end
	return self:FindRecipe(recipeList, recipeId)
end

function RecipeModule:FetchRecipeList(recipeType: string) -- Returns the recipe list table based on the type
	for _, recipeList in pairs(Recipes) do
		if recipeList.Type ~= recipeType then continue end
		return recipeList.Recipes
	end
end

function RecipeModule:FindRecipe(recipeList: any, recipeId: string|number) -- Finds a specificed recipe by its ID
	for _, recipe in pairs(recipeList) do
		if recipe.ID ~= recipeId then continue end
		return recipe
	end
end

function RecipeModule:RefreshCache() -- Refresh the cache table, useful for when making a change to the Recipes table
	CachedRecipesForID = {}
end

function RecipeModule:GetAllRecipes() -- Returns all recipe lists in the game
	return Recipes
end

function RecipeModule:GetCraftingCategories()
	return CraftingCategories
end	

-- Setup all recipes into one neat table
for _, module in pairs(script:GetChildren()) do
	for _, recipeList in pairs(require(module)) do
		table.insert(Recipes, recipeList)
	end
end
--print(Recipes)

return RecipeModule