-- [PATH] ServerStorage / Modules / LootTableModule / Cacti @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local Cacti = {
	Small = LootTable.new(
		{
			Worth = 0.6;
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1;
				Type = "Item";
				ID = 24; -- Cloth
				Amount = 5;
			}};
		},
		{
			Worth = 0.4;
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1;
				Type = "Item";
				ID = 25; -- Cactus Flesh
				Amount = {0.9, 1};
			}};
		}
	);
	
	Medium = LootTable.new(
		{
			Worth = 0.6;
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1;
				Type = "Item";
				ID = 24; -- Cloth
				Amount = 10;
			}};
		},
		{
			Worth = 0.4;
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1;
				Type = "Item";
				ID = 25; -- Cactus Flesh
				Amount = 2;
			}};
		}
	);
	
	Large = LootTable.new(
		{
			Worth = 0.6;
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1;
				Type = "Item";
				ID = 24; -- Cloth
				Amount = 15;
			}};
		},
		{
			Worth = 0.4;
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1;
				Type = "Item";
				ID = 25; -- Cactus Flesh
				Amount = 3;
			}};
		}
	);
}

return Cacti
