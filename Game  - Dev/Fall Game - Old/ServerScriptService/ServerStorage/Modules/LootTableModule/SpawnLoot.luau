-- [PATH] ServerStorage / Modules / LootTableModule / SpawnLoot @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local SpawnLoot = LootTable.new(
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 37; -- Boulder
			Amount = 1;
			--Skin = "Frosty";
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 10; -- Lighter
			Amount = 1;
		}};
	}
	--[[{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 97; -- Salvaged RPG
			Amount = 1;
			Ammo = LootTable.new({
				Rolls = 1;
				Loot = {{
					Weight = 1;
					Type = "Item";
					ID = 100; -- Combustive Rocket
					Amount = 1;
				}};
			});
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 100; -- Combustive Rocket
			Amount = 10;
		}};
	}]]
	--[[{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 22; -- Crossbow
			Amount = 1;
			Ammo = LootTable.new({
				Rolls = 1;
				Loot = {{
					Weight = 1;
					Type = "Item";
					ID = 126; -- Wooden Arrow
					Amount = 1;
				}};
			});
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 23; -- Wooden Bow
			Amount = 1;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 75; -- Nail Gun
			Amount = 1;
			Ammo = LootTable.new({
				Rolls = 1;
				Loot = {{
					Weight = 1;
					Type = "Item";
					ID = 93; -- Nails
					Amount = 14;
				}};
			});
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 30; -- Blueprint
			Amount = 1;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 31; -- Hammer
			Amount = 1;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 10; -- Mushroom
			Amount = 10;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 5; -- Salvaged AK47
			Amount = 1;
			Durability = 0.8; -- 80%
			Repair = 0.2; -- 20%
			Ammo = LootTable.new({
				Rolls = 1;
				Loot = {{
					Weight = 1;
					Type = "Item";
					ID = 4; -- Heavy Ammo
					Amount = 30;
				}};
			});
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 35; -- P250	
			Amount = 1;
			Attachments = LootTable.new(
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 7; -- Holo Sight
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 8; -- Silencer
						Amount = 1;
						Durability = {0.4, 0.6}; -- 40-60%
					}};
				}
			);
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 4; -- Heavy Ammo
			Amount = 128;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 11; -- HV Heavy Ammo
			Amount = 128;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 40; -- Explosive Heavy Ammo
			Amount = 128;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 36; -- Light Ammo
			Amount = 128;
		}};
	},
	{
		Rolls = 2;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 1; -- Wood Log
			Amount = 1000;
		}};
	},
	{
		Rolls = 2;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 26; -- Stone
			Amount = 1000;
		}};
	},
	{
		Rolls = 2;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 45; -- Iron
			Amount = 1000;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 46; -- Quality Iron
			Amount = 100;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 60; -- Hazmat Suit
			Amount = 1;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 37; -- Boulder
			Amount = 1;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 126; -- Wooden Arrow
			Amount = 64;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 128; -- Bone Arrow
			Amount = 64;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 93; -- Nails
			Amount = 64;
		}};
	},
	{
		Rolls = 1;
		Loot = {{
			Weight = 1;
			Type = "Item";
			ID = 93; -- Nails
			Amount = 64;
		}};
	}]]
)

return SpawnLoot