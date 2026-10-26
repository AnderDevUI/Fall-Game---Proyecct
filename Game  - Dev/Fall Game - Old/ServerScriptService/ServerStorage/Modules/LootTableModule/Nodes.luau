-- [PATH] ServerStorage / Modules / LootTableModule / Nodes @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local Nodes = {
	Stone = {
		Start = LootTable.new({
			Worth = 1;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 26; -- Stone
				Amount = 750;
			}};
		});
		Finish = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 26; -- Stone
				Amount = 250;
			}};
		});
	};
	
	Metal = {
		Start = LootTable.new({
			Worth = 1;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 27; -- Iron Ore
				Amount = 450;
			}};
		});
		Finish = LootTable.new(
			{
				Rolls = 1;
				Loot = {{
					Weight = 1;
					Type = "Item";
					ID = 27; -- Iron Ore
					Amount = 150;
				}};
			},
			{
				Rolls = 1;
				Loot = {{
					Weight = 1;
					Type = "Item";
					ID = 28; -- Quality Iron Ore
					Amount = 2;
				}};
			}
		);
	};
	
	Phosphate = {
		Start = LootTable.new({
			Worth = 1;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 64; -- Phosphate Ore
				Amount = 225;
			}};
		});
		Finish = LootTable.new(
			{
				Rolls = 1;
				Loot = {{
					Weight = 1;
					Type = "Item";
					ID = 64; -- Phosphate Ore
					Amount = 75;
				}};
			}
		);
	};
}

return Nodes
