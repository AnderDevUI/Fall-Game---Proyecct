-- [PATH] ServerStorage / Modules / LootTableModule / Logs @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local Logs = LootTable.new({
	Worth = 1;
	Rolls = 1;
	Loot = {{
		Weight = 1;
		Type = "Item";
		ID = 1; -- Wood Log
		Amount = 300;
	}};
});

return Logs
