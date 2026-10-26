-- [PATH] ServerStorage / Modules / LootTableModule / AI @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local Animals = {
	["Body of Bruno"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 24; -- Cloth
				Amount = 20;
			}};
		},
		{
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 92; -- Timed Charge
				Amount = 1;
			}};
		},
		{
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 170; -- piercing ammo
				Amount = {17, 81};
			}};
		},
		{
			Rolls = 1;
			Loot = {
				{
					Weight = 6;
					Type = "Item";
					ID = 221; -- Bruno's M4A1
					Amount = 1;
					Attachments = LootTable.new(
						{
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 219; -- Bruno's ACOG Sight
								Amount = 1;
							}};
						},
						{
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 220; -- Military Lasersight
								Amount = 1;
							}};
						}
					);
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 150; -- Military Leggings
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 223; -- Bruno's Helmet
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 222; -- Bruno's Chestplate
					Amount = 1;
				};
			};
		}
	);
	["Salvaged AK74u Scav Body"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 24; -- Cloth
				Amount = 15;
			}};
		},
		{
			Rolls = 0.2;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 136; -- Small Medkit
				Amount = 1;
			}};
		},
		{
			Rolls = 0.2;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 4; -- Heavy Ammo
				Amount = {5, 18};
			}};
		},
		{
			Rolls = 0.2;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 36; -- Light Ammo
				Amount = {7, 28};
			}};
		},
		{
			Rolls = 1;
			Loot = {
				{
					Weight = 8;
					Type = "Item";
					ID = 6; -- BottleCaps
					Amount = {1, 5};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 79; -- Copper Cogs
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 88; -- Circuit Boards
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 38; -- Salvaged SMG
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 4;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {8, 10};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 170; -- Military Grenade
					Amount = 1;
				};
			};
			
		}
	);
	["Military M4A1 Scav Body"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 24; -- Cloth
				Amount = 15;
			}};
		},
		{
			Rolls = 0.2;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 136; -- Small Medkit
				Amount = 1;
			}};
		},
		{
			Rolls = 0.2;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 4; -- Heavy Ammo
				Amount = {8, 18};
			}};
		},
		{
			Rolls = 0.2;
			Loot = {{
				Weight = 1;
				Type = "Item";
				ID = 36; -- Light Ammo
				Amount = {7, 18};
			}};
		},
		{
			Rolls = 1;
			Loot = {
				{
					Weight = 8;
					Type = "Item";
					ID = 6; -- BottleCaps
					Amount = {1, 8};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 79; -- Copper Cogs
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 88; -- Circuit Boards
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 38; -- Salvaged SMG
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 4;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {8, 10};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 170; -- Military Grenade
					Amount = 1;
				};
			};
		}
	);
}

return Animals
