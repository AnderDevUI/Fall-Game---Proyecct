-- [PATH] ServerStorage / Modules / LootTableModule / Trees @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local Trees = {
	Desert = {
		Start = LootTable.new({
			Worth = 1;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 1; -- Wood Log
				Amount = 320;
			}};
		});
		Finish = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 1; -- Wood Log
				Amount = 80;
			}};
		});
	};
	
	Small = {
		Start = LootTable.new({
			Worth = 1;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 1; -- Wood Log
				Amount = 480;
			}};
		});
		Finish = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 1; -- Wood Log
				Amount = 120;
			}};
		});
	};
	
	Medium = {
		Start = LootTable.new({
			Worth = 1;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 1; -- Wood Log
				Amount = 640;
			}};
		});
		Finish = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 1; -- Wood Log
				Amount = 160;
			}};
		});
	};
	
	Giant = {
		Start = LootTable.new({
			Worth = 1;
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 1; -- Wood Log
				Amount = 800;
			}};
		});
		Finish = LootTable.new({
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 1; -- Wood Log
				Amount = 200;
			}};
		});
	};
}

return Trees
