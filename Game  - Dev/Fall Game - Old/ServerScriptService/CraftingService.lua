-- [PATH] ServerScriptService / ServerService / CraftingService @Type Script
--[[
	CraftingService
	by ChickenBagelz
	October 8, 2023
	
	Handles crafting requests from players and the natural crafting queue flow
]]


-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")

-- Folders
local Remotes = Replicated:WaitForChild("Remotes")
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local Values = Replicated:WaitForChild("Values")
local Bases = workspace:WaitForChild("Bases")

-- Modules
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local RecipeModule = require(SharedModules:WaitForChild("RecipeModule"))
local ResearchModule = require(SharedModules:WaitForChild("ResearchModule"))
local Items = require(SharedModules:WaitForChild("Items"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))

-- Remotes
local CraftRemotes = Remotes:WaitForChild(string.char(26, 4, 16, 183, 90, 51, 3, 165, 61, 3, 110, 99, 175, 43, 188, 31, 170, 34, 20, 45, 143, 6, 113, 159, 129, 18, 137, 111, 103, 136))
local AllRemotes = {
	Craft = string.char(34, 57, 51, 70, 76, 114, 117, 80, 10, 83, 71, 126, 28, 30, 21, 106, 77, 164, 147, 83, 59, 165, 17, 190, 131, 166, 119, 160, 15, 93);
	NearbyBenches = string.char(122, 53, 140, 170, 25, 112, 44, 117, 26, 112, 99, 180, 55, 99, 48, 119, 144, 36, 126, 181, 31, 37, 12, 67, 44, 79, 34, 34, 172, 106);
}

-- Local Variables
local allWorkbenches = ResearchModule:FetchAllWorkbenches()

-- Functions
local function IsSpecial(bench)
	return bench:GetAttribute("Comfort") ~= nil
end

ModUtil:SetupRemotes(CraftRemotes, {
	[AllRemotes.Craft] = {
		Cooldown = 0.04;
		AllowedCallsBeforeThrottle = 12;
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local recipeId = args[1]
			local craftAmount = args[2]
			local selectedSkin = args[3]
			local workbench = args[4]
			if args[5] or #args >= 5 or type(recipeId) ~= "number" or (craftAmount and (type(craftAmount) ~= "number" or recipeId <= 0 or recipeId % 1 ~= 0 or craftAmount < 1 or craftAmount > 99 or craftAmount % 1 ~= 0 or type(selectedSkin) ~= "string")) then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			if not Values.CraftingEnabled.Value then return end
			if craftAmount then
				if workbench and typeof(workbench) ~= "Instance" and type(workbench) ~= "string" then
					return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
				elseif typeof(workbench) ~= "Instance" or not (workbench:IsA("Model") and workbench:GetAttribute("ID") and workbench:IsDescendantOf(Bases)) then
					workbench = nil
				end
			end
			local character = player.Character
			if not character then return end
			local humanoid = character:FindFirstChild("Humanoid")
			local charPrim = character.PrimaryPart
			if not (humanoid and charPrim and humanoid.Health > 0 and not humanoid:GetAttribute("Downed")) then return end
			local crafter = user.Crafter
			if not craftAmount then
				-- we're removing something from the queue
				local queueIndex = recipeId
				crafter:RemoveFromQueue(queueIndex)
			else
				-- crafting normally
				local recipe = (RecipeModule:GetRecipesForItem(recipeId) or {})[1]
				if not recipe then return end
				local itemInfo = Items[recipe.ID]
				if selectedSkin and type(itemInfo.Image) == "table" and selectedSkin ~= "Default" then
					if not itemInfo.Image[selectedSkin] then return end
					local skinIndex = itemInfo.Name.."/"..selectedSkin
					if not table.find(user.Skins, skinIndex) then return end
				else
					selectedSkin = "Default"
				end
				local benchNeeded = recipe.BenchNeeded
				local tierNeeded = recipe.TierNeeded
				if benchNeeded and (tierNeeded or 0) > 0 then
					local ignoreCraft = (workbench == nil or workbench.Name ~= benchNeeded)
					if not ignoreCraft then
						local benchPos = workbench:GetPivot().Position
						local charPos = charPrim.Position
						ignoreCraft = not NumberUtil:IsWithin(charPos, benchPos, 9)
					end
					if ignoreCraft then
						--warn(`CAN'T CRAFT - NOT NEARBY VALID WORKBENCH ({benchNeeded})`)
						return
					end
				end
				crafter:CraftRecipe(recipe, craftAmount, selectedSkin)
			end
		end;
	};
	[AllRemotes.NearbyBenches] = {
		Cooldown = 0.9;
		AllowedCallsBeforeThrottle = 2;
		ThrottleQueueMaxSize = 4;
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local character = player.Character
			if not character then return end
			local charPrim = character.PrimaryPart
			if not charPrim then return end
			local charPos = charPrim.Position
			local benches = {}
			for index, bench in pairs(args) do
				local t = typeof(bench)
				if type(index) ~= "number" or (t ~= "Instance" and t ~= "string") or (t == "string" and bench ~= "none") or (t == "Instance" and bench.Parent and not (bench:IsA("Model") and bench:IsDescendantOf(Bases))) then
					return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
				end
				if t ~= "Instance" or not bench.Parent or benches[bench] then continue end
				local specialBench = IsSpecial(bench)
				if not allWorkbenches[bench.Name] and not specialBench then continue end
				local benchPos = bench:GetPivot().Position
				if not NumberUtil:IsWithin(charPos, benchPos, 9) then continue end
				table.insert(benches, bench)
				--print(bench)
			end
			print("new nearby benches for", player.Name, benches)
			user.NearbyBenches = benches
		end;
	}
})