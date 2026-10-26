-- [PATH] ReplicatedStorage / Modules / ResearchModule @Type ModuleScript
--[[
	ResearchModule
	by ChickenBagelz
	October 10, 2023
]]


local ResearchInfos = {
	[1] = {
		Name = "Anvil";
		Tiers = { -- 9 tiers total
			[1] = {};
			[2] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 50;
				};
				{
					ID = 82; -- Rope
					Amount = 1;
				};
			};
			[3] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 125;
				};
			};
			[4] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 175;
				};
				{
					ID = 180; -- Pistol Receiver
					Amount = 1;
				};
			};
			[5] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 400;
				};
				{
					ID = 172; -- Semi Receiver
					Amount = 1;
				};
				{
					ID = 45; -- Iron Shards
					Amount = 100;
				};
			};
			[6] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 500;
				};
				{
					ID = 173; -- SMG Receiver
					Amount = 1;
				};
				{
					ID = 46; -- Steel Metal
					Amount = 10;
				};
			};
			[7] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 750;
				};
				{
					ID = 80; -- Pipe
					Amount = 5;
				};
			};
			[8] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 750;
				};
				{
					ID = 46; -- Steel Metal
					Amount = 25;
				};
			};
			[9] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 1000;
				};
				{
					ID = 174; -- Rifle Receiver
					Amount = 1;
				};
			};
		};
		Unlocks = {};
	};
	[2] = {
		Name = "Carpentry Table";
		Tiers = { -- 7 tiers total
			[1] = {};
			[2] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 100;
				};
				{
					ID = 82; -- Rope
					Amount = 2;
				};
			};
			[3] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 150;
				};
				{
					ID = 1; -- Wood Log
					Amount = 300;
				};
			};
			[4] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 250;
				};
				{
					ID = 45; -- Iron Shards
					Amount = 100;
				};
			};
			[5] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 400;
				};
				{
					ID = 79; -- Copper Cogs
					Amount = 3;
				};
			};
			[6] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 300;
				};
				{
					ID = 46; -- Steel Metal
					Amount = 30;
				};
			};
			[7] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 800;
				};
			};
		};
		Unlocks = {};
	};
	[3] = {
		Name = "Sewing Table";
		Tiers = { -- 6 tiers total
			[1] = {};
			[2] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 25;
				};
				{
					ID = 1; -- Wood Log
					Amount = 100;
				};
			};
			[3] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 75;
				};
				{
					ID = 84; -- Thread
					Amount = 2;
				};
			};
			[4] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 100;
				};
				{
					ID = 45; -- Iron Shards
					Amount = 200;
				};
			};
			[5] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 250;
				};
				{
					ID = 87; -- Tarp
					Amount = 3;
				};
			};
			[6] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 400;
				};
				{
					ID = 85; -- Metal Plating
					Amount = 2;
				};
				{
					ID = 84; -- Thread
					Amount = 4;
				};
			};
			[7] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 1250;
				};
				{
					ID = 46; -- Steel Metal
					Amount = 25;
				};
			};
		};
		Unlocks = {};
	};
	[4] = {
		Name = "Ammo Press";
		Tiers = { -- 6 tiers total
			[1] = {};
			[2] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 75;
				};
				{
					ID = 179; -- Glue
					Amount = 3;
				};
			};
			[3] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 150;
				};
				{
					ID = 45; -- Iron Shards
					Amount = 100;
				};
			};
			[4] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 400;
				};
				{
					ID = 46; -- Steel Metal
					Amount = 20;
				};
			};
			[5] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 400;
				};
				{
					ID = 65; -- Phosphate Dust
					Amount = 250;
				};
			};
			[6] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 300;
				};
			};
		};
		Unlocks = {};
	};
	[5] = {
		Name = "Chemistry Lab";
		Tiers = { -- 5 tiers total
			[1] = {};
			[2] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 125;
				};
				{
					ID = 45; -- Iron Shards
					Amount = 250;
				};
			};
			[3] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 450;
				};
				{
					ID = 68; -- Crude Fuel
					Amount = 50;
				};
			};
			[4] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 1000;
				};
				{
					ID = 46; -- Steel Metal
					Amount = 25;
				};
				{
					ID = 88; -- Circuit Boards
					Amount = 1;
				};
			};
			[5] = {
				{
					ID = 6; -- Bottle Caps
					Amount = 500;
				};
			};
		};
		Unlocks = {};
	};
	[6] = {
		Name = "Culinary Table";
		Tiers = { -- 2 tiers total
			[1] = {};
		};
		Unlocks = {};
	};
}
local AllWorkbenches = {}


-- Services
local Replicated = game:GetService("ReplicatedStorage")

-- Folders
local Modules = Replicated:WaitForChild("Modules")

-- Modules
local RecipeModule = require(Modules:WaitForChild("RecipeModule"))


local ResearchModule = {}

function ResearchModule:GetInfoFromName(benchName: string)
	for index, info in pairs(ResearchInfos) do
		if info.Name ~= benchName then continue end
		return info, index
	end
end

function ResearchModule:GetInfoFromIndex(index: number)
	return ResearchInfos[index]
end

function ResearchModule:CalculateUnlocks()
	for _, category in pairs(RecipeModule:GetCraftingCategories()) do
		local recipes = RecipeModule:FetchRecipeList(category) or {}
		--print(category, recipes)
		for _, recipe in pairs(recipes) do
			local benchNeeded = recipe.BenchNeeded
			if not benchNeeded then continue end
			AllWorkbenches[benchNeeded] = true
			local tierNeeded = recipe.TierNeeded
			local recipeId = recipe.ID
			local researchInfo = self:GetInfoFromName(benchNeeded)
			if not researchInfo then continue end
			local allUnlocks = researchInfo.Unlocks
			local tierUnlocks = allUnlocks[tierNeeded]
			if not tierUnlocks then
				tierUnlocks = {}
				allUnlocks[tierNeeded] = tierUnlocks
			end
			if table.find(tierUnlocks, recipe) then continue end
			table.insert(tierUnlocks, recipe)
		end
	end
	--print(ResearchInfos)
end

function ResearchModule:CalculateCraftTime(currentTier, tierNeeded, totalTiers)
	return (currentTier > tierNeeded and 0.75 - 0.5 / math.max(totalTiers - 1, 1) * math.max(currentTier - tierNeeded - 1, 0) or 1)
end

function ResearchModule:DebugGetCosts()
	local total = 0
	local tables = {}
	for _, v in pairs(ResearchInfos) do
		tables[v.Name] = 0
		for _, a in pairs(v.Tiers) do
			for _, b in pairs(a) do
				if b.ID ~= 6 then continue end
				tables[v.Name] += b.Amount
				total += b.Amount
			end
		end
	end
	print(`TOTAL BOTTLE CAP COST OF {total}`, tables)
end

function ResearchModule:FetchResearchInfos()
	return ResearchInfos
end

function ResearchModule:FetchAllWorkbenches()
	return AllWorkbenches
end

ResearchModule:CalculateUnlocks()

return ResearchModule