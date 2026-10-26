-- [PATH] ServerStorage / Modules / LootTableModule / Smelt @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local Smelt = {
	Campfire = {
		["Raw Pork"] = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 33; -- Cooked Pork
				Amount = 1;
			}};
		});
		["Raw Venison"] = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 44; -- Cooked Venison
				Amount = 1;
			}};
		});
		["Empty Can"] = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 45; -- Iron Shards
				Amount = {10, 15};
			}};
		});
	};
	
	Furnace = {
		["Phosphate Ore"] = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 65; -- Phosphate Dust
				Amount = 3;
			}};
		});
		["Iron Ore"] = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 45; -- Iron Shards
				Amount = 3;
			}};
		});
		["Quality Iron Ore"] = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 46; -- Quality Iron
				Amount = 2;
			}};
		});
	};
	
	PetroleumRefinery = {
		["Petroleum"] = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 68; -- Crude Fuel
				Amount = 6;
			}};
		});
	};
	
	General = {
		["Wood Log"] = LootTable.new({
			Rolls = 0.75;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 34; -- Charcoal
				Amount = 1;
			}};
		});
	};
	
}

return Smelt
