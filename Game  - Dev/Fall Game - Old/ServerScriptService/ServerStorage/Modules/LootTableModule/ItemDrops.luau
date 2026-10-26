-- [PATH] ServerStorage / Modules / LootTableModule / ItemDrops @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local ItemDrops = {
	["Trophy"] = LootTable.new({
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 70; -- Bone Shards
			Amount = 20;
		}};
	});
	["Empty Can"] = LootTable.new({
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 176; -- Empty Can
			Amount = 1;
		}};
	});
}

return ItemDrops
