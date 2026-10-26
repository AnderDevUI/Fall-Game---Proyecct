-- [PATH] ServerStorage / Modules / LootTableModule / Animals @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local Animals = {
	PREFAB_ANIMAL_DEER = LootTable.new(
		{
			Worth = 0.2;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 24; -- Cloth
				Amount = 25;
			}};
		},
		{
			Worth = 0.2;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 41; -- Animal Fat
				Amount = 10;
			}};
		},
		{
			Worth = 0.2;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 66; -- Leather
				Amount = 40;
			}};
		},
		{
			Worth = 0.2;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 70; -- Bones
				Amount = 40;
			}};
		},
		{
			Worth = 0.2;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 43; -- Raw Venison
				Amount = 4;
			}};
		}
	);
	
	PREFAB_ANIMAL_WILDBOAR = LootTable.new(
		{
			Worth = 0.2;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 24; -- Cloth
				Amount = 10;
			}};
		},
		{
			Worth = 0.2;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 41; -- Animal Fat
				Amount = 40;
			}};
		},
		{
			Worth = 0.2;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 66; -- Leather
				Amount = 30;
			}};
		},
		{
			Worth = 0.2;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 70; -- Bones
				Amount = 50;
			}};
		},
		{
			Worth = 0.2;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 32; -- Raw Pork
				Amount = 8;
			}};
		}
	);
}

return Animals
