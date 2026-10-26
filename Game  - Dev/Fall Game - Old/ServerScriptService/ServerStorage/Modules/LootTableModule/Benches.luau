-- [PATH] ServerStorage / Modules / LootTableModule / Benches @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local Benches = {
	["Wooden Crate"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1; -- 100%
				Type = "Item";
				ID = 6; -- Bottle Caps 
				Amount = 5;
			}};
		},
		{
			Rolls = 1;
			Loot = { -- Total weight of 45
				{
					Weight = 4;
					Type = "Item";
					ID = 217; -- Machete
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 113; -- Shorts
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 114; -- Tank Top
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 154; -- Baseball Cap
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 158; -- Leather Gloves
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 2; -- Bandage
					Amount = 2;
					--LuckAffected = true;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 126; -- Wooden Arrow
					Amount = {3, 5};
					--LuckAffected = true;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 181; -- Salvaged Shovel
					Amount = 1;
					Durability = {0.5, 1};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 152; -- Balaclava
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 162; -- Diving Goggles
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 160; -- Flippers
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 124; -- Wooden Chestplate
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 125; -- Wooden Leggings
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 12; -- Salvaged Sight
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 53; -- Wooden Window Bars
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 78; -- Power Cell
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 23; -- Wooden Bow
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 195; -- Wooden Spikes
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 200; -- Large Wooden Sign
					Amount = 1;
				};
			};
		}
	);
	
	["Small Gift"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {
				{ -- Total weight of 1
					Weight = 4; -- 80%
					Type = "Item";
					ID = 6; -- Bottle Caps 
					Amount = {1,2};
				};
				--[[{ -- Total weight of 1
					Weight = 1; -- 20%
					Type = "Item";
					ID = 34; -- Charcoal
					Amount = {10, 80};
				};]]
			};
		},
		{
			Rolls = 1;
			Loot = { -- Total weight of 45
				{
					Weight = 1;
					Type = "Item";
					ID = 2; -- Bandage
					Amount = 2;
					--LuckAffected = true;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 126; -- Wooden Arrow
					Amount = {3, 5};
					--LuckAffected = true;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 181; -- Salvaged Shovel
					Amount = 1;
					Durability = {0.5, 1};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 113; -- Shorts
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 114; -- Tank Top
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 154; -- Baseball Cap
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 158; -- Leather Gloves
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 152; -- Balaclava
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 162; -- Diving Goggles
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 160; -- Flippers
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 124; -- Wooden Chestplate
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 125; -- Wooden Leggings
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 12; -- Salvaged Sight
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 53; -- Wooden Window Bars
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 78; -- Power Cell
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 20; -- Stone Spear
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 23; -- Wooden Bow
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 36; -- Light Ammo
					Amount = {10, 15};
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 195; -- Wooden Spikes
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 200; -- Large Wooden Sign
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 83; -- Blade
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 82; -- Rope
					Amount = {1, 2};
				};
				{
					Weight = 16;
					Type = "Item";
					ID = 225; -- Carrot Blade
					Amount = 1;
				};
				--[[{
					Weight = 15;
					Type = "Item";
					ID = 206; -- Christmas Tree
					Amount = 1;
				};]]
				{
					Weight = 1;
					Type = "Item";
					ID = 179; -- Glue
					Amount = {1, 3};
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 89; -- Metal Scraps
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 87; -- Tarp
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 80; -- Pipe
					Amount = 1;
				};

				{
					Weight = 1;
					Type = "Item";
					ID = 84; -- Thread
					Amount = {2, 3};
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 178; -- Duct Tape
					Amount = {1, 2};
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 86; -- Spring
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 85; -- Metal Plating
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 79; -- Copper Cogs
					Amount = 2;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 78; -- Power Cell
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 180; -- Pistol Receiver
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 172; -- Semi Receiver
					Amount = 1;
				};

				{
					Weight = 1;
					Type = "Item";
					ID = 199; -- Small Wooden Sign
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 22; -- Crossbow
					Amount = 1;
				};
			};
		}
	);
	
	["Medium Gift"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {
				{ -- Total weight of 5
					Weight = 4; -- 80%
					Type = "Item";
					ID = 6; -- Bottle Caps 
					Amount = {3, 5};
				};
				--[[{ -- Total weight of 1
					Weight = 1; -- 20%
					Type = "Item";
					ID = 34; -- Bottle Caps 
					Amount = {50, 150};
				};]]
			};
		},
		{
			Rolls = 1;
			Loot = { -- Total weight of 45
				{
					Weight = 5;
					Type = "Item";
					ID = 136; -- Small Medkit
					Amount = 1;
					--LuckAffected = true;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 4; -- Heavy Ammo
					Amount = {5, 10};
					--LuckAffected = true;
				};
				{
					Weight = 7;
					Type = "Item";
					ID = 225; -- Carrot Blade
					Amount = 1;
				};
				--[[{
					Weight = 7;
					Type = "Item";
					ID = 206; -- Christmas Tree
					Amount = 1;
				};]]
				{
					Weight = 4;
					Type = "Item";
					ID = 181; -- Salvaged Shovel
					Amount = 1;
					Durability = {0.5, 1};
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 118; -- Leather poncho
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 152; -- Balaclava
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 162; -- Diving Goggles
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 160; -- Flippers
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 124; -- Wooden Chestplate
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 125; -- Wooden Leggings
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 12; -- Salvaged Sight
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 53; -- Wooden Window Bars
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 78; -- Power Cell
					Amount = 1;
				};
				--[[{
					Weight = 1;
					Type = "Item";
					ID = 35; -- Salvaged P250
					Amount = 1;
					Durability = {0.1, 0.3};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {2, 5};
						}};
					});
				};]]
				{
					Weight = 3;
					Type = "Item";
					ID = 22; -- Crossbow
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 200; -- Large Wooden Sign
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 178; -- Duct Tape
					Amount = {1, 2};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 86; -- Spring
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 85; -- Metal Plating
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 84; -- Thread
					Amount = {3, 4};
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 130; -- Iron Shard Hatchet
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 131; -- Iron Shard Pickaxe
					Amount = 1;
				};
			};
		}
	);
	
	["Large Gift"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {
				{ -- Total weight of 1
					Weight = 4; -- 80%
					Type = "Item";
					ID = 6; -- Bottle Caps 
					Amount = {9, 11};
				};
				--[[{ -- Total weight of 1
					Weight = 1; -- 20%
					Type = "Item";
					ID = 34; -- Charcoal
					Amount = {150, 250};
				};]]
			};
		},
		{
			Rolls = 1;
			Loot = { -- Total weight of 45
				{
					Weight = 5;
					Type = "Item";
					ID = 136; -- Small Medkit
					Amount = 1;
					--LuckAffected = true;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 4; -- Heavy Ammo
					Amount = {15, 20};
					--LuckAffected = true;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 225; -- Carrot Blade
					Amount = 1;
				};
				--[[{
					Weight = 4;
					Type = "Item";
					ID = 206; -- Christmas Tree
					Amount = 1;
				};]]
				{
					Weight = 4;
					Type = "Item";
					ID = 175; -- Steel Shovel
					Amount = 1;
					Durability = {0.5, 1};
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 112; -- Collared Shirt
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 63; -- Pants
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 161; -- Diving Tank
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 35; -- Salvaged P250
					Amount = 1;
					Durability = {0.1, 0.3};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {2, 5};
						}};
					});
				};
				--[[{
					Weight = 1;
					Type = "Item";
					ID = 204; -- Salvaged Skorpion
					Amount = 1;
					Durability = {0.1, 0.3};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {5, 12};
						}};
					});
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 109; -- Salvaged Pipe Rifle
					Amount = 1;
					Durability = {0.1, 0.3};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {0, 1};
						}};
					});
				};]]
				{
					Weight = 3;
					Type = "Item";
					ID = 85; -- Metal Plating
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 76; -- Steel Axe
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 77; -- Steel Pickaxe
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 174; -- Rifle Receiver
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 173; -- SMG Receiver
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 88; -- Circuit Boards
					Amount = {2, 4};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 46; -- Steel Metal
					Amount = {4, 5};
				};
				
				{
					Weight = 2;
					Type = "Item";
					ID = 94; -- Garage Door
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 57; -- Trap Door
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 190; -- Triangle Trap Door
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 132; -- Large Furnace
					Amount = 1;
				};
				--[[{
					Weight = 1;
					Type = "Item";
					ID = 189; -- Petroleum Refinery
					Amount = 1;
				};]]
				{
					Weight = 3;
					Type = "Item";
					ID = 103; -- Vertical Window Cover
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 104; -- Horizontal Window Cover
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 55; -- Glass Window
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 95; -- Dynamite Bundle
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 226; -- Metal Spikes
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 193; -- Salvaged Pump Action
					Amount = 1;
					Durability = {0.2, 0.3};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 138; -- Buckshot
							Amount = 2;
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 146; -- Salvaged Chestplate
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 147; -- Salvaged Leggings
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 7; -- Holo Sight
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 215; -- Landmine Trap
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 212; -- Military Grenade
					Amount = 1;
				};
			};
		}
	);
	
	["Trash Can"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1; -- 100%
				Type = "Item";
				ID = 6; -- Bottle Caps 
				Amount = 3;
			}};
		},
		{
			Rolls = 1;
			Loot = { -- Total weight of 
				{
					Weight = 16;
					Type = "Item";
					ID = 83; -- Blade
					Amount = 1;
				};
				{
					Weight = 15;
					Type = "Item";
					ID = 82; -- Rope
					Amount = {1, 2};
				};
				{
					Weight = 7;
					Type = "Item";
					ID = 179; -- Glue
					Amount = {1, 3};
				};
				{
					Weight = 7;
					Type = "Item";
					ID = 89; -- Metal Scraps
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 87; -- Tarp
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 80; -- Pipe
					Amount = 1;
				};
				
				{
					Weight = 3;
					Type = "Item";
					ID = 84; -- Thread
					Amount = {2, 3};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 178; -- Duct Tape
					Amount = {1, 2};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 86; -- Spring
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 85; -- Metal Plating
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 79; -- Copper Cogs
					Amount = 2;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 78; -- Power Cell
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 180; -- Pistol Receiver
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 172; -- Semi Receiver
					Amount = 1;
				};
				
				{
					Weight = 1;
					Type = "Item";
					ID = 113; -- Shorts
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 114; -- Tank Top
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 154; -- Baseball Cap
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 158; -- Leather Gloves
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 152; -- Balaclava
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 53; -- Wooden Window Bars
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 181; -- Salvaged Shovel
					Amount = 1;
					Durability = {0.5, 1};
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 195; -- Wooden Spikes
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 199; -- Small Wooden Sign
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 217; -- Machete
					Amount = 1;
					Durability = {0.5, 1};
				};
			};
		}
	);
	
	["Food Crate"] = LootTable.new(
		{
			Rolls = 1;
			Loot = { -- Total weight of 9
				{
					Weight = 3;
					Type = "Item";
					ID = 58; -- Radiation Vitamins
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 169; -- Water Bottle
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 165; -- Chocolate Bar
					Amount = {1, 2};
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 166; -- Bean Can
					Amount = {1, 2};
				};
			};
		},
		{
			Rolls = 1;
			Loot = { -- Total weight of 14
				{
					Weight = 7;
					Type = "Nothing";
					--LuckAffected = true;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 168; -- Fish Can
					Amount = {1, 2};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 61; -- Chicken MRE
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 62; -- Beef MRE
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 167; -- Meatball Can
					Amount = 1;
				}
			}
		}
	);
	
	["Oil Barrel"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1;
				Type = "Item";
				ID = 68; -- Crude Fuel
				Amount = {4, 8};
			}};
		},
		{
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1;
				Type = "Item";
				ID = 110; -- Petroleum
				Amount = {12, 16};
			}};
		}
	);
	
	["Locked Wooden Crate"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1; -- 100%
				Type = "Item";
				ID = 6; -- Bottle Caps 
				Amount = 8;
			}};
		},
		{
			Rolls = 1;
			Loot = { -- Total weight of 27
				{
					Weight = 3;
					Type = "Item";
					ID = 178; -- Duct Tape
					Amount = {1, 2};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 86; -- Spring
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 85; -- Metal Plating
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 84; -- Thread
					Amount = {3, 4};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 79; -- Copper Cogs
					Amount = 2;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 78; -- Power Cell
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 180; -- Pistol Receiver
					Amount = {1, 2};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 172; -- Semi Receiver
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 80; -- Pipe
					Amount = {1, 4};
				};
			};
		},
		{
			Rolls = 1.04;
			Loot = { -- Total weight of 178
				{
					Weight = 120;
					Type = "Nothing";
					LuckAffected = true;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 161; -- Diving Tank
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 159; -- Wetsuit
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 216; -- Saw Bat
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 63; -- Pants
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 112; -- Collared Shirt
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 130; -- Iron Shard Hatchet
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 131; -- Iron Shard Pickaxe
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 122; -- Flannel Jacket
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 128; -- Bone Arrow
					Amount = {7, 10};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 127; -- Swift Arrow
					Amount = {5, 8};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 129; -- Combustive Arrow
					Amount = {4, 6};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 60; -- Hazmat Suit
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 160; -- Flippers
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 162; -- Diving Goggles
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 68; -- Crude Fuel
					Amount = {20, 38};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 54; -- Metal Window Bars
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 105; -- Jail Wall
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 106; -- Jail Door
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 164; -- Ladder
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 101; -- External Wooden Wall
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 102; -- External Wooden Gate
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 16; -- Weapon Flashlight
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 14; -- Compensator
					Amount = 1;
					Durability = {0.75, 1};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 22; -- Crossbow
					Amount = 1;
					Durability = {0.2, 0.5};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 96; -- Dynamite Stick
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 136; -- Health Pen
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 36; -- Light Ammo
					Amount = {12, 16};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 138; -- Buckshot
					Amount = {5, 7};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 197; -- Metal Barricade
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 201; -- Storage Cabinet
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 137; -- Salvaged Break Action
					Amount = 1;
					Durability = {0.1, 0.2};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 213; -- Floor Grill
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 214; -- Bear Trap
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 211; -- Shotgun Turret
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 35; -- Salvaged P250
					Amount = 1;
					Durability = {0.15, 0.2};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {3, 4};
						}};
					});
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 139; -- Slug
					Amount = 4;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 90; -- Swift Light Ammo
					Amount = {9, 12};
				};
			};
		}
	);
	
	["Locked Metal Crate"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1; -- 100%
				Type = "Item";
				ID = 6; -- Bottle Caps 
				Amount = 12;
			}};
		},
		{
			Rolls = 1;
			Loot = { -- Total weight of 18
				{
					Weight = 3;
					Type = "Item";
					ID = 174; -- Rifle Receiver
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 173; -- SMG Receiver
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 88; -- Circuit Boards
					Amount = {2, 4};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 46; -- Steel Metal
					Amount = {11, 17};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 80; -- Pipe
					Amount = 5;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 86; -- Spring
					Amount = 2;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 178; -- Duct Tape
					Amount = {3, 4};
				};
			};
		},
		{
			Rolls = 1.04;
			Loot = { -- total weight of 248
				{
					Weight = 180;
					Type = "Nothing";
					LuckAffected = true;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 59; -- Hoodie
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 145; -- Salvaged Helmet
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 155; -- Salvaged Gloves
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 111; -- Boots
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 13; -- Muzzle Boost
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 76; -- Steel Axe
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 77; -- Steel Pickaxe
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 175; -- Steel Shovel
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 94; -- Garage Door
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 57; -- Trap Door
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 190; -- Triangle Trap Door
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 132; -- Large Furnace
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 189; -- Petroleum Refinery
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 136; -- Health Pen
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 103; -- Vertical Window Cover
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 104; -- Horizontal Window Cover
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 55; -- Glass Window
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 4; -- Heavy Ammo
					Amount = {10, 14};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 95; -- Dynamite Bundle
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 226; -- Metal Spikes
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 193; -- Salvaged Pump Action
					Amount = 1;
					Durability = {0.2, 0.3};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 138; -- Buckshot
							Amount = 2;
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 109; -- Salvaged Pipe Rifle
					Amount = 1;
					Durability = {0.2, 0.4};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = 1;
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 204; -- Salvaged Skorpion
					Amount = 1;
					Durability = {0.2, 0.4};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {5, 7};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 11; -- Swift Heavy Ammo
					Amount = {8, 11};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 171; -- Piercing Light Ammo
					Amount = {8, 11};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 146; -- Salvaged Chestplate
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 147; -- Salvaged Leggings
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 7; -- Holo Sight
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 215; -- Landmine Trap
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 212; -- Military Grenade
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 177; -- Care Package Signal
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 38; -- Salvaged SMG
					Amount = 1;
					Durability = {0.15, 0.2};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {8, 9};
						}};
					});
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 39; -- Salvaged Python
					Amount = 1;
					Durability = 0.1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {2, 3};
						}};
					});
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 9; -- Salvaged M14
					Amount = 1;
					Durability = {0.15, 0.2};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {6, 7};
						}};
					});
				};
			};
		}
	);
	
	["Locked Steel Crate"] = LootTable.new(
		{
			Rolls = 1;
			Loot = {{ -- Total weight of 1
				Weight = 1; -- 100%
				Type = "Item";
				ID = 6; -- Bottle Caps 
				Amount = 35;
			}};
		},
		{
			Rolls = 3;
			Loot = { -- Total weight of 18
				{
					Weight = 3;
					Type = "Item";
					ID = 174; -- Rifle Receiver
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 173; -- SMG Receiver
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 88; -- Circuit Boards
					Amount = {2, 4};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 46; -- Steel Metal
					Amount = {11, 17};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 80; -- Pipe
					Amount = 5;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 86; -- Spring
					Amount = 2;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 178; -- Duct Tape
					Amount = {3, 4};
				};
			};
		},
		{
			Rolls = 1.04;
			Loot = { -- total weight of 205
				{
					Weight = 60;
					Type = "Nothing";
					LuckAffected = true;
				};
				{
					Weight = 10;
					Type = "Item";
					ID = 138; -- Buckshot
					Amount = {7, 14};
				};
				{
					Weight = 8;
					Type = "Item";
					ID = 90; -- Swift Light Ammo
					Amount = {20, 40};
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 177; -- Care Package Signal
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 212; -- Military Grenade
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 11; -- Swift Heavy Ammo
					Amount = {15, 50};
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 56; -- Steel Glass Window
					Amount = {1, 2};
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 92; -- Timed Charge
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 15; -- Salvaged Lasersight
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 17; -- Salvaged Sniper Scope
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 141; -- Steel Helmet
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 142; -- Steel Chestplate
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 143; -- Steel Leggings
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 73; -- Steel Door
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 74; -- Steel Double Door
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 9; -- Salvaged M14
					Amount = 1;
					Durability = {0.15, 0.2};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {6, 7};
						}};
					});
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 97; -- Salvaged RPG
					Amount = 1;
					Durability = 0.2;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 95; -- Dynamite Bundle
					Amount = 2;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 100; -- Combustive Rocket
					Amount = {1, 2};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 108; -- Salvaged AK74u	
					Amount = 1;
					Durability = {0.15, 0.2};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {11, 14};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 5; -- Salvaged AK47	
					Amount = 1;
					Durability = {0.15, 0.2};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {11, 14};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 38; -- Salvaged SMG
					Amount = 1;
					Durability = {0.15, 0.2};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {8, 9};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 39; -- Salvaged Python
					Amount = 1;
					Durability = 0.1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {2, 3};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 196; -- Military ACOG Sight
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 59; -- Hoodie
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 145; -- Salvaged Helmet
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 155; -- Salvaged Gloves
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 111; -- Boots
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 13; -- Muzzle Boost
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 76; -- Steel Axe
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 77; -- Steel Pickaxe
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 175; -- Steel Shovel
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 94; -- Garage Door
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 57; -- Trap Door
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 190; -- Triangle Trap Door
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 209; -- Blast Furnace
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 132; -- Large Furnace
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 189; -- Petroleum Refinery
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 103; -- Vertical Window Cover
					Amount = {1, 2};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 104; -- Horizontal Window Cover
					Amount = {1, 2};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 171; -- Piercing Light Ammo
					Amount = {15, 40};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 170; -- Piercing Heavy Ammo
					Amount = {10, 50};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 40; -- Combustive Heavy Ammo
					Amount = {15, 30};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 146; -- Salvaged Chestplate
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 147; -- Salvaged Leggings
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 7; -- Holo Sight
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 68; -- Crude Fuel
					Amount = {33, 38};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 191; -- Military AA12
					Amount = 1;
					Durability = {0.5, 0.8};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 138; -- Buckshot
							Amount = {4, 6};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 202; -- External Stone Gate
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 208; -- External Stone Wall
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 98; -- Rocket
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 18; -- Military Sniper Scope
					Amount = 1;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 198; -- Military M4A1	
					Amount = 1;
					Durability = {0.1, 0.2};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {11, 14};
						}};
					});
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 210; -- Military Barrett
					Amount = 1;
					Durability = {0.1, 0.2};
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {1, 3};
						}};
					});
				};
			};
		}
	);
	
	["Care Package"] = LootTable.new(
		{
			Rolls = 2;
			Loot = {
				{
					Weight = 4;
					Type = "Item";
					ID = 193; -- Salvaged Pump Action
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 4;
							Type = "Item";
							ID = 138; -- Buckshot
							Amount = 2;
						}};
					});
					LuckAffected = true;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 204; -- Salvaged Skorpion
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {5, 7};
						}};
					});
					LuckAffected = true;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 109; -- Salvaged Pipe Rifle
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {0, 1};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 191; -- Military AA12
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 138; -- Buckshot
							Amount = {4, 6};
						}};
					});
				};
				{
					Weight = 2;
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
					ID = 9; -- Salvaged M14
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 4;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {6, 7};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 108; -- Salvaged AK74u
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 4;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {12, 15};
						}};
					});
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 5; -- Salvaged AK47
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {11, 14};
						}};
					});
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 198; -- Military M4A1
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {11, 14};
						}};
					});
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 210; -- Military Barrett
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {1, 3};
						}};
					});
				};
			};
		},
		
		{
			Rolls = 2;
			Loot = { -- Total weight of 30
				{
					Weight = 4; -- 13.33%
					Type = "Item";
					ID = 59; -- Hoodie
					Amount = 1;
					LuckAffected = true;
				};
				{
					Weight = 3; -- 10%
					Type = "Item";
					ID = 63; -- Pants
					Amount = 1;
					LuckAffected = true;
				};
				{
					Weight = 3; -- 10%
					Type = "Item";
					ID = 111; -- Boots
					Amount = 1;
					LuckAffected = true;
				};
				
				{
					Weight = 3; -- 10%
					Type = "Item";
					ID = 155; -- Salvaged Gloves
					Amount = 1;
				};
				{
					Weight = 3; -- 10%
					Type = "Item";
					ID = 147; -- Salvaged Leggings
					Amount = 1;
				};
				{
					Weight = 3; -- 10%
					Type = "Item";
					ID = 146; -- Salvaged Chestplate
					Amount = 1;
				};
				{
					Weight = 3; -- 10%
					Type = "Item";
					ID = 145; -- Salvaged Helmet
					Amount = 1;
				};

				{
					Weight = 2; -- 6.66%
					Type = "Item";
					ID = 157; -- Military Gloves
					Amount = 1;
				};
				{
					Weight = 2; -- 6.66%
					Type = "Item";
					ID = 150; -- Military Leggings
					Amount = 1;
				};
				{
					Weight = 2; -- 6.66%
					Type = "Item";
					ID = 149; -- Military Chestplate
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 124; -- Wooden Chestplate
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 125; -- Wooden Leggings
					Amount = 1;
				};
				{
					Weight = 2; -- 6.66%
					Type = "Item";
					ID = 148; -- Military Helmet
					Amount = 1;
				};
			};
		},
		
		{
			Rolls = 3;
			Loot = { -- Total weight of 33
				{
					Weight = 6;
					Type = "Item";
					ID = 36; -- Light Ammo
					Amount = {20, 42};
					LuckAffected = true;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 138; -- Buckshot
					Amount = {9, 15};
					LuckAffected = true;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 4; -- Heavy Ammo
					Amount = {16, 40};
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 98; -- Rocket
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 90; -- Swift Light Ammo
					Amount = {15, 30};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 139; -- Slug
					Amount = {6, 10};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 11; -- Swift Heavy Ammo
					Amount = {10, 35};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 171; -- Piercing Light Ammo
					Amount = {10, 20};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 170; -- Piercing Heavy Ammo
					Amount = {5, 16};
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 40; -- Combustive Heavy Ammo
					Amount = {4, 7};
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 212; -- Military Grenade
					Amount = 1;
				};
			};
		},
		
		{
			Rolls = 1;
			Loot = { -- Total weight of 14
				{
					Weight = 7; -- 50%
					Type = "Nothing";
					LuckAffected = true;
				};
				{
					Weight = 4; -- 28%
					Type = "Item";
					ID = 95; -- Dynamite Bundle
					Amount = 2;
				};
				{
					Weight = 2; -- 14%
					Type = "Item";
					ID = 92; -- Timed Charge
					Amount = 1;
				};
				{
					Weight = 1; -- 8%
					Type = "Item";
					ID = 11; -- Combustive Heavy Ammo
					Amount = {15, 20};
				};
			};
		},
		{
			Rolls = 1;
			Loot = { -- Total weight of 25
				{
					Weight = 5;
					Type = "Item";
					ID = 6; -- Bottle Caps
					Amount = {125, 150};
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 46; -- Steel Metal
					Amount = {28, 36};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 88; -- Circuit Boards
					Amount = 4;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 85; -- Metal Plating
					Amount = 4;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 79; -- Copper Cogs
					Amount = 5;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 80; -- Pipe
					Amount = 5;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 196; -- Military ACOG Sight
					Amount = 1;
				};
			};
		}
	);
	
	["Timed Crate"] = LootTable.new(
		{
			Rolls = 3;
			Loot = { -- Total weight of 18
				{
					Weight = 3;
					Type = "Item";
					ID = 174; -- Rifle Receiver
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 173; -- SMG Receiver
					Amount = 1;
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 88; -- Circuit Boards
					Amount = {2, 4};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 46; -- Steel Metal
					Amount = {11, 18};
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 80; -- Pipe
					Amount = 5;
				};
			};
		},
		{
			Rolls = 2;
			Loot = { --
				{
					Weight = 10;
					Type = "Item";
					ID = 108; -- Salvaged AK74u	
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {11, 14};
						}};
					});
					LuckAffected = true;
				};
				{
					Weight = 8;
					Type = "Item";
					ID = 9; -- Salvaged M14
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {6, 7};
						}};
					});
					LuckAffected = true;
				};
				{
					Weight = 8;
					Type = "Item";
					ID = 210; -- Military Barrett
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {1, 3};
						}};
					});
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 198; -- Military M4A1	
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {11, 14};
						}};
					});
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 5; -- Salvaged AK47	
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {11, 14};
						}};
					});
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 38; -- Salvaged SMG
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {8, 9};
						}};
					});
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 218; -- Military PKM	
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {11, 14};
						}};
					});
				};
			};
		},
		{
			Rolls = 3;
			Loot = {
				{
					Weight = 6;
					Type = "Item";
					ID = 138; -- Buckshot
					Amount = {16, 22};
					LuckAffected = true;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 90; -- Swift Light Ammo
					Amount = {30, 42};
					LuckAffected = true;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 11; -- Swift Heavy Ammo
					Amount = {25, 55};
					LuckAffected = true;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 141; -- Steel Helmet
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 142; -- Steel Chestplate
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 143; -- Steel Leggings
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 56; -- Steel Glass Window
					Amount = {1, 2};
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 15; -- Salvaged Lasersight
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 220; -- Military Lasersight
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 92; -- Timed Charge
					Amount = {1, 2};
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 98; -- Rocket
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 212; -- Military Grenade
					Amount = 1;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 40; -- Combustive Heavy Ammo
					Amount = {20, 35};
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 17; -- Salvaged Sniper Scope
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 73; -- Steel Door
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 74; -- Steel Double Door
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 202; -- Stone External Gate
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 97; -- Salvaged RPG
					Amount = 1;
					Durability = 0.2;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 100; -- Combustive Rocket
					Amount = {1, 2};
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 18; -- Military Sniper Scope
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 196; -- Military ACOG Sight
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 157; -- Military Gloves
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 59; -- Hoodie
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 148; -- Military Helmet
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 111; -- Boots
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 13; -- Muzzle Boost
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 76; -- Steel Axe
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 77; -- Steel Pickaxe
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 175; -- Steel Shovel
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 94; -- Garage Door
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 57; -- Trap Door
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 190; -- Triangle Trap Door
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 209; -- Blast Furnace
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 132; -- Large Furnace
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 189; -- Petroleum Refinery
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 171; -- Piercing Light Ammo
					Amount = {25, 45};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 170; -- Piercing Heavy Ammo
					Amount = {20, 55};
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 149; -- Military Chestplate
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 150; --  Military Leggings
					Amount = 1;
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 7; -- Holo Sight
					Amount = 1;
				};
			};
		}
	);
	
	["BTR Crate"] = LootTable.new(	
		{
			Rolls = 3.05;
			Loot = {
				{
					Weight = 7;
					Type = "Item";
					ID = 11; -- Swift Heavy Ammo
					Amount = {40, 128};
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 92; -- Timed Charge
					Amount = {1, 2};
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 100; -- Combustive Rocket
					Amount = 3;
				};
				{
					Weight = 6;
					Type = "Item";
					ID = 17; -- Salvaged Sniper Scope
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 40; -- Combustive Heavy Ammo
					Amount = {30, 70};
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 98; -- Rocket
					Amount = 3;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 74; -- Steel Double Door
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 73; -- Steel Door
					Amount = 1;
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 90; -- Swift Light Ammo
					Amount = {60, 128};
				};
				{
					Weight = 5;
					Type = "Item";
					ID = 88; -- Circuit Boards
					Amount = {9, 11};
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 196; -- Military ACOG Sight
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 18; -- Military Sniper Scope
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 220; -- Military Lasersight
					Amount = 1;
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 198; -- Military M4A1	
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {11, 14};
						}};
					});
				};
				{
					Weight = 4;
					Type = "Item";
					ID = 210; -- Military Barrett
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {1, 3};
						}};
					});
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 218; -- Military PKM	
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {11, 32};
						}};
					});
				};
				{
					Weight = 3;
					Type = "Item";
					ID = 5; -- Salvaged AK47	
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {11, 14};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 108; -- Salvaged AK74u	
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 36; -- Light Ammo
							Amount = {11, 14};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 9; -- Salvaged M14
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 4; -- Heavy Ammo
							Amount = {6, 7};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 191; -- Military AA12
					Amount = 1;
					Ammo = LootTable.new({
						Rolls = 1;
						Loot = {{
							Weight = 1;
							Type = "Item";
							ID = 138; -- Buckshot
							Amount = {4, 6};
						}};
					});
				};
				{
					Weight = 2;
					Type = "Item";
					ID = 15; -- Salvaged Lasersight
					Amount = 1;
					LuckAffected = true;
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 171; -- Piercing Light Ammo
					Amount = {50, 100};
				};
				{
					Weight = 1;
					Type = "Item";
					ID = 170; -- Piercing Heavy Ammo
					Amount = {40, 90};
				};
			};
		}
	);
	
	--[[{
		Weight = 2;
		Type = "Item";
		ID = 13; -- Muzzle Boost
		Amount = 1;
		Durability = {0.75, 1};
	};]]
	
	["Campfire"] = LootTable.new({
		Rolls = 1;
		Loot = {{ -- Total weight of 1
			Weight = 1;
			Type = "Item";
			ID = 1; -- Wood Log
			Amount = 50;
		}};
	});
}

return Benches
