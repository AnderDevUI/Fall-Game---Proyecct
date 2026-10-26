-- [PATH] ReplicatedStorage / Modules / RecipeModule / ItemRecipes @Type ModuleScript
--[[
	BasePartRecipes
	by ChickenBagelz
	March 1, 2023
	
	Holds recipes for every item
]]

local BasePartRecipes = {
	{
		Type = "Weapons";
		Recipes = {
			{
				ID = 19; -- Wooden Spear
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 275;
					};
				};
			};
			{
				ID = 20; -- Stone Spear
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 19; -- Wooden Spear
						Amount = 1;
					};
					{
						ID = 26; -- Stone
						Amount = 20;
					};
				};
			};
			{
				ID = 23; -- Wooden Bow
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 200;
					};
					{
						ID = 24; -- Cloth
						Amount = 50;
					};
				};
			};
			{
				ID = 75; -- Nail Gun
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
					{
						ID = 6; -- Bottle Caps
						Amount = 15;
					};
				};
			};
			{
				ID = 22; -- Crossbow
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 2;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 200;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
					{
						ID = 82; -- Rope
						Amount = 2;
					};
				};
			};
			{
				ID = 137; -- Salvaged Break Action
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 3;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 150;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 50;
					};
					{
						ID = 80; -- Pipe
						Amount = 1;
					};
					{
						ID = 179; -- Glue
						Amount = 2;
					};
				};
			};
			{
				ID = 35; -- Salvaged P250
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 4;
				Costs = {
					{
						ID = 180; -- Pistol Receiver
						Amount = 1;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 125;
					};
					{
						ID = 24; -- Cloth
						Amount = 25;
					};
					{
						ID = 179; -- Glue
						Amount = 2;
					};
				};
			};
			{
				ID = 193; -- Salvaged Pump Action
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 5;
				Costs = {
					{
						ID = 86; -- Spring
						Amount = 1;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 15;
					};
					{
						ID = 80; -- Pipe
						Amount = 2;
					};
				};
			};
			{
				ID = 109; -- Salvaged Pipe Rifle
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 5;
				Costs = {
					{
						ID = 172; -- Semi Receiver
						Amount = 1;
					};
					{
						ID = 1; -- Wood Log
						Amount = 250;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 4;
					};
					{
						ID = 80; -- Pipe
						Amount = 2;
					};
				};
			};
			{
				ID = 204; -- Salvaged Skorpion
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 5;
				Costs = {
					{
						ID = 173; -- SMG Receiver
						Amount = 1;
					};
					{
						ID = 86; -- Spring
						Amount = 1;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 8;
					};
				};
			};
			{
				ID = 39; -- Salvaged Python
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 6;
				Costs = {
					{
						ID = 180; -- Pistol Receiver
						Amount = 1;
					};
					{
						ID = 86; -- Spring
						Amount = 1;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 10;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
				};
			};
			{
				ID = 38; -- Salvaged SMG
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 6;
				Costs = {
					{
						ID = 173; -- SMG Receiver
						Amount = 1;
					};
					{
						ID = 86; -- Spring
						Amount = 1;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 10;
					};
					{
						ID = 178; -- Duct Tape
						Amount = 1;
					};
				};
			};
			{
				ID = 9; -- Salvaged M14
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 7;
				Costs = {
					{
						ID = 172; -- Semi Receiver
						Amount = 1;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 450;
					};
					{
						ID = 1; -- Wood Log
						Amount = 100;
					};
					{
						ID = 86; -- Spring
						Amount = 1;
					};
					{
						ID = 178; -- Duct Tape
						Amount = 1;
					};
				};
			};
			{
				ID = 97; -- Salvaged RPG
				ReceiveAmount = 1;
				Time = 60;
				BenchNeeded = "Anvil";
				TierNeeded = 7;
				Costs = {
					{
						ID = 80; -- Pipe
						Amount = 4;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 40;
					};
					{
						ID = 178; -- Duct Tape
						Amount = 1;
					};
				};
			};
			{
				ID = 108; -- Salvaged AK74u
				ReceiveAmount = 1;
				Time = 45;
				BenchNeeded = "Anvil";
				TierNeeded = 8;
				Costs = {
					{
						ID = 173; -- SMG Receiver
						Amount = 1;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 20;
					};
					{
						ID = 86; -- Spring
						Amount = 2;
					};
					{
						ID = 178; -- Duct Tape
						Amount = 1;
					};
				};
			};
			{
				ID = 5; -- Salvaged AK47
				ReceiveAmount = 1;
				Time = 45;
				BenchNeeded = "Anvil";
				TierNeeded = 9;
				Costs = {
					{
						ID = 174; -- Rifle Receiver
						Amount = 1;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 45;
					};
					{
						ID = 1; -- Wood Log
						Amount = 250;
					};
					{
						ID = 86; -- Spring
						Amount = 3;
					};
					{
						ID = 178; -- Duct Tape
						Amount = 2;
					};
				};
			};
			
			{
				ID = 191; -- Military AA12
				ReceiveAmount = 1;
				Time = 45;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 30;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 300;
					};
					{
						ID = 86; -- Spring
						Amount = 3;
					};
				};
				Hidden = true;
			};
			
			{
				ID = 210; -- Military Barrett
				ReceiveAmount = 1;
				Time = 45;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 50;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 500;
					};
					{
						ID = 86; -- Spring
						Amount = 6;
					};
				};
				Hidden = true;
			};
			
			{
				ID = 198; -- Military M4A1
				ReceiveAmount = 1;
				Time = 45;
				Costs = {
					{
						ID = 174; -- Rifle Receiver
						Amount = 1;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 40;
					};
					{
						ID = 86; -- Spring
						Amount = 2;
					};
				};
				Hidden = true;
			};
			
			{
				ID = 221; -- Bruno's M4A1
				ReceiveAmount = 1;
				Time = 60;
				Costs = {
					{
						ID = 174; -- Rifle Receiver
						Amount = 1;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 45;
					};
					{
						ID = 86; -- Spring
						Amount = 2;
					};
				};
				Hidden = true;
			};
			
			{
				ID = 218; -- Military PKM
				ReceiveAmount = 1;
				Time = 60;
				Costs = {
					{
						ID = 174; -- Rifle Receiver
						Amount = 2;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 50;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 50;
					};
					{
						ID = 86; -- Spring
						Amount = 3;
					};
				};
				Hidden = true;
			};
		};
	};
	
	{
		Type = "Tools";
		Recipes = {
			{
				ID = 3; -- Stone Hatchet
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 200;
					};
					{
						ID = 26; -- Stone
						Amount = 100;
					};
				};
			};
			{
				ID = 21; -- Stone Pickaxe
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 200;
					};
					{
						ID = 26; -- Stone
						Amount = 100;
					};
				};
			};
			{
				ID = 30; -- Blueprint
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 20;
					};
				};
			};
			{
				ID = 31; -- Hammer
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 100;
					};
				};
			};
			{
				ID = 37; -- Boulder
				ReceiveAmount = 1;
				Time = 5;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 26; -- Stone
						Amount = 20;
					};
				};
			};
			{
				ID = 10; -- Lighter
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 30;
					};
					{
						ID = 68; -- Crude Fuel
						Amount = 1;
					};
				};
			};
			{
				ID = 203; -- Bone Tool
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 70; -- Bone Shards
						Amount = 40;
					};
				};
			};
			{
				ID = 217; -- Machete
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Anvil";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 80;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 40;
					};
				};
			};
			{
				ID = 130; -- Iron Shard Hatchet
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 1;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 100;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 50;
					};
				};
			};
			{
				ID = 131; -- Iron Shard Pickaxe
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 2;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 100;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
				};
			};
			{
				ID = 181; -- Salvaged Shovel
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 2;
				Costs = {
					{
						ID = 83; -- Blade
						Amount = 2;
					};
					{
						ID = 80; -- Pipe
						Amount = 1;
					};
					{
						ID = 179; -- Glue
						Amount = 1;
					};
				};
			};
			{
				ID = 216; -- Saw Bat
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 3;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 250;
					};
					{
						ID = 24; -- Cloth
						Amount = 15;
					};
					{
						ID = 83; -- Blade
						Amount = 2;
					};
				};
			};
			{
				ID = 76; -- Steel Axe
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 5;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 6;
					};
					{
						ID = 1; -- Wood Log
						Amount = 150;
					};
					{
						ID = 178; -- Duct Tape
						Amount = 2;
					};
				};
			};
			{
				ID = 77; -- Steel Pickaxe
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 5;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 6;
					};
					{
						ID = 1; -- Wood Log
						Amount = 150;
					};
					{
						ID = 178; -- Duct Tape
						Amount = 2;
					};
				};
			};
			{
				ID = 175; -- Steel Shovel
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 6;
				Costs = {
					{
						ID = 83; -- Blade
						Amount = 4;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 3;
					};
					{
						ID = 1; -- Wood Log
						Amount = 150;
					};
					{
						ID = 178; -- Duct Tape
						Amount = 1;
					};
				};
			};
			
			{
				ID = 96; -- Dynamite Stick
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Chemistry Lab";
				TierNeeded = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 20;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 50;
					};
				};
			};
			{
				ID = 212; -- Military Grenade
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Chemistry Lab";
				TierNeeded = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 30;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 25;
					};
				};
			};
			{
				ID = 95; -- Dynamite Bundle
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Chemistry Lab";
				TierNeeded = 2;
				Costs = {
					{
						ID = 96; -- Dynamite Stick
						Amount = 4;
					};
					{
						ID = 24; -- Cloth
						Amount = 10;
					};
					{
						ID = 82; -- Rope
						Amount = 1;
					};
				};
			};
			{
				ID = 92; -- Timed Charge
				ReceiveAmount = 1;
				Time = 60;
				BenchNeeded = "Chemistry Lab";
				TierNeeded = 4;
				Costs = {
					{
						ID = 69; -- Gunpowder
						Amount = 1000;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 150;
					};
					{
						ID = 24; -- Cloth
						Amount = 20;
					};
					{
						ID = 88; -- Circuit Boards
						Amount = 2;
					};
				};
			};
		};
	};
	
	{
		Type = "Build";
		Recipes = {
			{
				ID = 29; -- Campfire
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 100;
					};
				};
			};
			{
				ID = 67; -- Furnace
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 26; -- Stone
						Amount = 200;
					};
					{
						ID = 1; -- Wood Log
						Amount = 100;
					};
					{
						ID = 68; -- Crude Fuel
						Amount = 50;
					};
				};
			};
			{
				ID = 51; -- Base Cabinet
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 1000;
					};
				};
			};
			{
				ID = 47; -- Wooden Door
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 300;
					};
				};
			};
			{
				ID = 52; -- Wooden Double Door
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 350;
					};
				};
			};
			{
				ID = 50; -- Salvaged Metal Door
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 125;
					};
					{
						ID = 1; -- Wood Log
						Amount = 75;
					};
				};
			};
			{
				ID = 53; -- Wooden Window Bars
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 50;
					};
				};
			};
			{
				ID = 91; -- Sleeping Bag
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 30;
					};
				};
			};
			{
				ID = 42; -- Small Storage Box
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 100;
					};
				};
			};
			{
				ID = 144; -- Large Storage Box
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 250;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 50;
					};
				};
			};
			{
				ID = 48; -- Wooden Lock
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 75;
					};
				};
			};
			{
				ID = 49; -- Combination Lock
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 100;
					};
				};
			};
			{
				ID = 186; -- Sewing Table
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				ShredIgnore = {6};
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 100;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 25;
					};
					{
						ID = 6; -- Bottle Caps
						Amount = 15;
					};
				};
			};
			{
				ID = 183; -- Anvil
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				ShredIgnore = {6};
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 100;
					};
					{
						ID = 82; -- Rope
						Amount = 1;
					};
					{
						ID = 6; -- Bottle Caps
						Amount = 75;
					};
				};
			};
			{
				ID = 185; -- Carpentry Table
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				ShredIgnore = {6};
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 400;
					};
					{
						ID = 87; -- Tarp
						Amount = 1;
					};
					{
						ID = 6; -- Bottle Caps
						Amount = 100;
					};
				};
			};
			{
				ID = 187; -- Ammo Press
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				ShredIgnore = {6};
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 50;
					};
					{
						ID = 89; -- Metal Scraps
						Amount = 1;
					};
					{
						ID = 6; -- Bottle Caps
						Amount = 50;
					};
				};
			};
			{
				ID = 199; -- Small Wooden Sign
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 75;
					};
				};
			};
			{
				ID = 71; -- Metal Door
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 150;
					};
				};
			};
			{
				ID = 72; -- Metal Double Door
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 200;
					};
				};
			};
			{
				ID = 163; -- Cooking Pot
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 40;
					};
					{
						ID = 1; -- Wood Log
						Amount = 100;
					};
				};
			};
			{
				ID = 195; -- Wooden Spikes
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 1;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 400;
					};
				};
			};
			{
				ID = 200; -- Large Wooden Sign
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 1;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 150;
					};
				};
			};
			{
				ID = 164; -- Ladder
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 2;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 300;
					};
					{
						ID = 82; -- Rope
						Amount = 3;
					};
				};
			};
			{
				ID = 54; -- Metal Window Bars
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 2;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 25;
					};
				};
			};
			{
				ID = 184; -- Chemistry Lab
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 2;
				ShredIgnore = {6};
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 300;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 10;
					};
					{
						ID = 6; -- Bottle Caps
						Amount = 150;
					};
				};
			};
			{
				ID = 197; -- Metal Barricade
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 2;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 250;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
				};
			};
			{
				ID = 213; -- Floor Grill
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 2;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
				};
			};
			{
				ID = 214; -- Bear Trap
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 2;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
					{
						ID = 83; -- Blade
						Amount = 1;
					};
				};
			};
			{
				ID = 188; -- Culinary Table
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 3;
				ShredIgnore = {6};
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 15;
					};
					{
						ID = 24; -- Cloth
						Amount = 100;
					};
					{
						ID = 6; -- Bottle Caps
						Amount = 250;
					};
				};
			};
			{
				ID = 101; -- External Wooden Wall
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 3;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 1500;
					};
				};
			};
			{
				ID = 102; -- External Wooden Gate
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 3;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 3000;
					};
					{
						ID = 79; -- Copper Cogs
						Amount = 2;
					};
				};
			};
			{
				ID = 192; -- Repair Table
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 3;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 125;
					};
				};
			};
			{
				ID = 201; -- Storage Cabinet
				ReceiveAmount = 1;
				Time = 25;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 3;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 600;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 150;
					};
					{
						ID = 179; -- Glue
						Amount = 1;
					};

				};
			};
			{
				ID = 226; -- Metal Spikes
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 3;
				Costs = {
					{
						ID = 83; -- Blade
						Amount = 2;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 200;
					};
				};
			};
			{
				ID = 103; -- Vertical Window Cover
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 4;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 100;
					};
				};
			};
			{
				ID = 104; -- Horizontal Window Cover
				ReceiveAmount = 1;
				Time = 15;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 4;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 100;
					};
				};
			};
			{
				ID = 105; -- Jail Wall
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 4;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
				};
			};
			{
				ID = 106; -- Jail Door
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 4;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
				};
			};
			{
				ID = 194; -- Bed
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 4;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 100;
					};
					{
						ID = 84; -- Thread
						Amount = 6;
					};
				};
			};
			{
				ID = 211; -- Shotgun Turret
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 4;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 500;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 250;
					};
					{
						ID = 79; -- Copper Cogs
						Amount = 2;
					};
					{
						ID = 82; -- Rope
						Amount = 2;
					};
				};
			};
			{
				ID = 57; -- Trap Door
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 5;
				Costs = {
					{
						ID = 164; -- Ladder
						Amount = 1;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 250;
					};
					{
						ID = 79; -- Copper Cogs
						Amount = 2;
					};
				};
			};
			{
				ID = 190; -- Triangle Trap Door
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 5;
				Costs = {
					{
						ID = 164; -- Ladder
						Amount = 1;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 250;
					};
					{
						ID = 79; -- Copper Cogs
						Amount = 2;
					};
				};
			};
			{
				ID = 132; -- Large Furnace
				ReceiveAmount = 1;
				Time = 40;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 5;
				Costs = {
					{
						ID = 26; -- Stone
						Amount = 500;
					};
					{
						ID = 1; -- Wood Log
						Amount = 600;
					};
					{
						ID = 68; -- Crude Fuel
						Amount = 75;
					};
				};
			};
			{
				ID = 55; -- Glass Window
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 5;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 50;
					};
				};
			};
			{
				ID = 215; -- Landmine Trap
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 5;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 50;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 30;
					};
				};
			};
			{
				ID = 94; -- Garage Door
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 6;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 300;
					};
					{
						ID = 79; -- Copper Cogs
						Amount = 2;
					};
				};
			};
			{
				ID = 189; -- Petroleum Refinery
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 6;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 500;
					};
					{
						ID = 1; -- Wood Log
						Amount = 200;
					};
					{
						ID = 68; -- Crude Fuel
						Amount = 250;
					};
				};
			};
			{
				ID = 209; -- Blast Furnace
				ReceiveAmount = 1;
				Time = 35;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 6;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 500;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 10;
					};
					{
						ID = 68; -- Crude Fuel
						Amount = 75;
					};
				};
			};
			{
				ID = 208; -- External Stone Wall
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 6;
				Costs = {
					{
						ID = 26; -- Stone
						Amount = 1500;
					};
				};
			};
			{
				ID = 202; -- External Stone Gate
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 6;
				Costs = {
					{
						ID = 26; -- Stone
						Amount = 3000;
					};
					{
						ID = 79; -- Copper Cogs
						Amount = 5;
					};
				};
			};
			{
				ID = 56; -- Glass Window
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 7;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 4;
					};
				};
			};
			{
				ID = 73; -- Steel Door
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 7;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 25;
					};
					{
						ID = 79; -- Copper Cogs
						Amount = 5;
					};
				};
			};
			{
				ID = 74; -- Steel Double Door
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Carpentry Table";
				TierNeeded = 7;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 30;
					};
					{
						ID = 79; -- Copper Cogs
						Amount = 5;
					};
				};
			};
		};
	};
	
	{
		Type = "Attire";
		Recipes = {
			{
				ID = 153; -- Cloth Headwrap
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Sewing Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 10;
					};
				};
			};
			{
				ID = 115; -- Cloth Shirt
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Sewing Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 15;
					};
				};
			};
			{
				ID = 116; -- Cloth Pants
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Sewing Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 15;
					};
				};
			};
			{
				ID = 117; -- Cloth Footwraps
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Sewing Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 5;
					};
				};
			};
			{
				ID = 156; -- Cloth Handwraps
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Sewing Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 5;
					};
				};
			};
			{
				ID = 154; -- Baseball Cap
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Sewing Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 5;
					};
				};
			};
			{
				ID = 125; -- Wooden Leggings
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Sewing Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 200;
					};
					{
						ID = 82; -- Rope
						Amount = 1;
					};
				};
			};
			{
				ID = 124; -- Wooden Chestplate
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 250;
					};
					{
						ID = 82; -- Rope
						Amount = 1;
					};
				};
			};
			{
				ID = 123; -- Wooden Helmet
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 200;
					};
					{
						ID = 24; -- Cloth
						Amount = 10;
					};
					{
						ID = 179; -- Glue
						Amount = 1;
					};
				};
			};
			{
				ID = 152; -- Balaclava
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Sewing Table";
				TierNeeded = 1;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 15;
					};
				};
			};
			{
				ID = 158; -- Leather Gloves
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 1;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 15;
					};
					{
						ID = 179; -- Glue
						Amount = 1;
					};
				};
			};
			{
				ID = 121; -- Leather Boots
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Sewing Table";
				TierNeeded = 1;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 5;
					};
				};
			};
			{
				ID = 119; -- Leather Pants
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Sewing Table";
				TierNeeded = 2;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 10;
					};
				};
			};
			{
				ID = 120; -- Leather Shirt
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Sewing Table";
				TierNeeded = 2;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 10;
					};
				};
			};
			{
				ID = 118; -- Leather Poncho
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 2;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 20;
					};
					{
						ID = 179; -- Glue
						Amount = 1;
					};
				};
			};
			
			{
				ID = 112; -- Collared Shirt
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 3;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 30;
					};
				};
			};
			{
				ID = 63; -- Pants
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 3;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 35;
					};
					{
						ID = 84; -- Thread
						Amount = 1;
					};
				};
			};
			{
				ID = 122; -- Flannel Jacket
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 4;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 50;
					};
					{
						ID = 84; -- Thread
						Amount = 2;
					};
				};
			};
			{
				ID = 151; -- Hard Hat
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 4;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 10;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 40;
					};
					{
						ID = 179; -- Glue
						Amount = 2;
					};
				};
			};
			{
				ID = 60; -- Hazmat Suit
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Sewing Table";
				TierNeeded = 5;
				Costs = {
					{
						ID = 87; -- Tarp
						Amount = 4;
					};
					{
						ID = 84; -- Thread
						Amount = 2;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 5;
					};
				};
			};
			{
				ID = 111; -- Boots
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 5;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 20;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 15;
					};
					{
						ID = 84; -- Thread
						Amount = 1;
					};
				};
			};
			{
				ID = 59; -- Hoodie
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 5;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 40;
					};
					{
						ID = 84; -- Thread
						Amount = 1;
					};
				};
			};
			{
				ID = 155; -- Salvaged Gloves
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 5;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 15;
					};
					{
						ID = 85; -- Metal Plating
						Amount = 1;
					};
					{
						ID = 84; -- Thread
						Amount = 2;
					};
				};
			};
			{
				ID = 147; -- Salvaged Leggings
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 6;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 10;
					};
					{
						ID = 85; -- Metal Plating
						Amount = 1;
					};
					{
						ID = 84; -- Thread
						Amount = 2;
					};
				};
			};
			{
				ID = 146; -- Salvaged Chestplate
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 6;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 20;
					};
					{
						ID = 85; -- Metal Plating
						Amount = 2;
					};
					{
						ID = 84; -- Thread
						Amount = 2;
					};
				};
			};
			{
				ID = 145; -- Salvaged Helmet
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Sewing Table";
				TierNeeded = 6;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 15;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 60;
					};
					{
						ID = 84; -- Thread
						Amount = 1;
					};
				};
			};
			{
				ID = 143; -- Steel Leggings
				ReceiveAmount = 1;
				Time = 40;
				BenchNeeded = "Sewing Table";
				TierNeeded = 7;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 30;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 10;
					};
					{
						ID = 84; -- Thread
						Amount = 4;
					};
				};
			};
			{
				ID = 142; -- Steel Chestplate
				ReceiveAmount = 1;
				Time = 40;
				BenchNeeded = "Sewing Table";
				TierNeeded = 7;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 40;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 25;
					};
					{
						ID = 84; -- Thread
						Amount = 7;
					};
				};
			};
			{
				ID = 141; -- Steel Helmet
				ReceiveAmount = 1;
				Time = 40;
				BenchNeeded = "Sewing Table";
				TierNeeded = 7;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 50;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 15;
					};
					{
						ID = 84; -- Thread
						Amount = 5;
					};
				};
			};
			
			{
				ID = 150; -- Military Leggings
				ReceiveAmount = 1;
				Time = 40;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 10;
					};
				};
				Hidden = true;
			};
			{
				ID = 149; -- Military Chestplate
				ReceiveAmount = 1;
				Time = 40;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 25;
					};
				};
				Hidden = true;
			};
			{
				ID = 148; -- Military Helmet
				ReceiveAmount = 1;
				Time = 40;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 15;
					};
				};
				Hidden = true;
			};
			{
				ID = 157; -- Military Gloves
				ReceiveAmount = 1;
				Time = 30;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 30;
					};
					{
						ID = 84; -- Thread
						Amount = 4;
					};
				};
				Hidden = true;
			};
			
			{
				ID = 222; -- Bruno's Chestplate
				ReceiveAmount = 1;
				Time = 60;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 20;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 50;
					};
					{
						ID = 84; -- Thread
						Amount = 3;
					};
				};
				Hidden = true;
			};
			{
				ID = 223; -- Bruno's Helmet
				ReceiveAmount = 1;
				Time = 60;
				Costs = {
					{
						ID = 66; -- Leather
						Amount = 25;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 40;
					};
					{
						ID = 84; -- Thread
						Amount = 3;
					};
				};
				Hidden = true;
			};
			
			{
				ID = 114; -- Tank Top
				ReceiveAmount = 1;
				Time = 1;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 15;
					};
				};
				Hidden = true;
			};
			{
				ID = 113; -- Shorts
				ReceiveAmount = 1;
				Time = 1;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 15;
					};
				};
				Hidden = true;
			};
			{
				ID = 162; -- Diving Goggles
				ReceiveAmount = 1;
				Time = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 70;
					};
				};
				Hidden = true;
			};
			{
				ID = 159; -- Wetsuit
				ReceiveAmount = 1;
				Time = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
				};
				Hidden = true;
			};
			{
				ID = 160; -- Flippers
				ReceiveAmount = 1;
				Time = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 100;
					};
				};
				Hidden = true;
			};
			{
				ID = 161; -- Diving Tank
				ReceiveAmount = 1;
				Time = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 100;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 5;
					};
				};
				Hidden = true;
			};
		};
	};
	
	{
		Type = "Ammo";
		Recipes = {
			{
				ID = 126; -- Wooden Arrow
				ReceiveAmount = 2;
				Time = 3;
				BenchNeeded = "Ammo Press";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 25;
					};
					{
						ID = 26; -- Stone
						Amount = 10;
					};
				};
				ShredAmount = 8;
			};
			{
				ID = 128; -- Bone Arrow
				ReceiveAmount = 3;
				Time = 3;
				BenchNeeded = "Ammo Press";
				TierNeeded = 0;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 25;
					};
					{
						ID = 70; -- Bone Shards
						Amount = 10;
					};
				};
				ShredAmount = 8;
			};
			{
				ID = 93; -- Nails
				ReceiveAmount = 5;
				Time = 2;
				BenchNeeded = "Ammo Press";
				TierNeeded = 0;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 8;
					};
				};
				ShredAmount = 8;
			};
			{
				ID = 127; -- Swift Arrow
				ReceiveAmount = 2;
				Time = 3;
				BenchNeeded = "Ammo Press";
				TierNeeded = 1;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 15;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 5;
					};
				};
				ShredAmount = 4;
			};
			{
				ID = 129; -- Combustive Arrow
				ReceiveAmount = 2;
				Time = 3;
				BenchNeeded = "Ammo Press";
				TierNeeded = 1;
				Costs = {
					{
						ID = 1; -- Wood Log
						Amount = 20;
					};
					{
						ID = 24; -- Cloth
						Amount = 2;
					};
					{
						ID = 68; -- Crude Fuel
						Amount = 10;
					};
				};
				ShredAmount = 4;
			};
			{
				ID = 138; -- Buckshot
				ReceiveAmount = 2;
				Time = 4;
				BenchNeeded = "Ammo Press";
				TierNeeded = 2;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 5;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 5;
					};
				};
				ShredAmount = 4;
			};
			{
				ID = 139; -- Slug
				ReceiveAmount = 2;
				Time = 4;
				BenchNeeded = "Ammo Press";
				TierNeeded = 3;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 5;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 10;
					};
				};
				ShredAmount = 2;
			};
			{
				ID = 36; -- Light Ammo
				ReceiveAmount = 4;
				Time = 3;
				BenchNeeded = "Ammo Press";
				TierNeeded = 3;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 10;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 5;
					};
				};
				ShredAmount = 4;
			};
			{
				ID = 90; -- Swift Light Ammo
				ReceiveAmount = 3;
				Time = 3;
				BenchNeeded = "Ammo Press";
				TierNeeded = 4;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 10;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 10;
					};
				};
				ShredAmount = 4;
			};
			{
				ID = 4; -- Heavy Ammo
				ReceiveAmount = 3;
				Time = 3;
				BenchNeeded = "Ammo Press";
				TierNeeded = 4;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 10;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 5;
					};
				};
				ShredAmount = 4;
			};
			{
				ID = 11; -- Swift Heavy Ammo
				ReceiveAmount = 2;
				Time = 3;
				BenchNeeded = "Ammo Press";
				TierNeeded = 5;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 10;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 10;
					};
				};
				ShredAmount = 4;
			};
			{
				ID = 171; -- Piercing Light Ammo
				ReceiveAmount = 3;
				Time = 3;
				BenchNeeded = "Ammo Press";
				TierNeeded = 5;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 15;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 10;
					};
					{
						ID = 65; -- Phosphate Dust
						Amount = 5;
					};
				};
				ShredAmount = 4;
			};
			{
				ID = 170; -- Piercing Heavy Ammo
				ReceiveAmount = 2;
				Time = 3;
				BenchNeeded = "Ammo Press";
				TierNeeded = 6;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 15;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 10;
					};
					{
						ID = 65; -- Phosphate Dust
						Amount = 5;
					};
				};
				ShredAmount = 4;
			};
			{
				ID = 99; -- Swift Rocket
				ReceiveAmount = 1;
				Time = 10;
				BenchNeeded = "Chemistry Lab";
				TierNeeded = 3;
				Costs = {
					{
						ID = 69; -- Gunpowder
						Amount = 100;
					};
					{
						ID = 80; -- Pipe
						Amount = 1;
					};
				};
			};
			{
				ID = 100; -- Combustive Rocket
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Chemistry Lab";
				TierNeeded = 3;
				Costs = {
					{
						ID = 68; -- Crude Fuel
						Amount = 250;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 150;
					};
					{
						ID = 24; -- Cloth
						Amount = 30;
					};
					{
						ID = 80; -- Pipe
						Amount = 2;
					};
				};
			};
			{
				ID = 40; -- Combustive Heavy Ammo
				ReceiveAmount = 2;
				Time = 3;
				BenchNeeded = "Chemistry Lab";
				TierNeeded = 4;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 10;
					};
					{
						ID = 69; -- Gunpowder
						Amount = 20;
					};
					{
						ID = 65; -- Phosphate Dust
						Amount = 10;
					};
				};
				ShredAmount = 4;
			};
			{
				ID = 98; -- Rocket
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Chemistry Lab";
				TierNeeded = 5;
				Costs = {
					{
						ID = 69; -- Gunpowder
						Amount = 650;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 100;
					};
					{
						ID = 65; -- Phosphate Dust
						Amount = 100;
					};
					{
						ID = 68; -- Crude Fuel
						Amount = 30;
					};
					{
						ID = 80; -- Pipe
						Amount = 2;
					};
				};
			};
		};
	};
	
	{
		Type = "Resources";
		Recipes = {
			{
				ID = 68; -- Crude Fuel
				ReceiveAmount = 4;
				Time = 5;
				BenchNeeded = "Chemistry Lab";
				TierNeeded = 0;
				Costs = {
					{
						ID = 41; -- Animal Fat
						Amount = 3;
					};
					{
						ID = 24; -- Cloth
						Amount = 1;
					};
				};
				ShredAmount = 25;
			};
			{
				ID = 69; -- Gunpowder
				ReceiveAmount = 10;
				Time = 2;
				BenchNeeded = "Ammo Press";
				TierNeeded = 1;
				Costs = {
					{
						ID = 34; -- Charcoal
						Amount = 30;
					};
					{
						ID = 65; -- Phosphate Dust
						Amount = 20;
					};
				};
				ShredAmount = 50;
			};
			
			{
				ID = 78; -- Power Cell
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 1;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 40;
					};
				};
				Hidden = true;
			};
			{
				ID = 79; -- Copper Cogs
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 3;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 20;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 25;
					};
				};
				Hidden = true;
			};
			{
				ID = 80; -- Pipe
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 3;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 10;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 2;
					};
				};
				Hidden = true;
			};
			{
				
				ID = 82; -- Rope
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 5;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 30;
					};
				};
				Hidden = true;
			};
			{

				ID = 83; -- Blade
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 3;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 5;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 30;
					};
				};
				Hidden = true;
			};
			{

				ID = 84; -- Thread
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 3;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 20;
					};
					{
						ID = 82; -- Rope
						Amount = 4;
					};
				};
				Hidden = true;
			};
			{

				ID = 85; -- Metal Plating
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 2;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 15;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 75;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 2;
					};
				};
				Hidden = true;
			};
			{

				ID = 86; -- Spring
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 2;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 20;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 2;
					};
				};
				Hidden = true;
			};
			{

				ID = 87; -- Tarp
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 2;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 80;
					};
				};
				Hidden = true;
			};
			{

				ID = 88; -- Circuit Boards
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 2;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 40;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 2;
					};
				};
				Hidden = true;
			};
			{

				ID = 89; -- Metal Scraps
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 2;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 2;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 100;
					};
				};
				Hidden = true;
			};
			{

				ID = 180; -- Pistol Receiver
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 2;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 15;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 100;
					};
				};
				Hidden = true;
			};
			{

				ID = 172; -- Semi Receiver
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 2;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 30;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 50;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 4;
					};
				};
				Hidden = true;
			};
			{

				ID = 173; -- SMG Receiver
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 1;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 30;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 4;
					};
				};
				Hidden = true;
			};
			{

				ID = 174; -- Rifle Receiver
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 1;
				Costs = {
					{
						ID = 6; -- Bottle Caps
						Amount = 50;
					};
					{
						ID = 46; -- Steel Metal
						Amount = 4;
					};
				};
				Hidden = true;
			};
			{

				ID = 179; -- Glue
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 3;
				Costs = {
					{
						ID = 41; -- Animal Fat
						Amount = 1;
					};
				};
				Hidden = true;
			};
			{

				ID = 178; -- Duct Tape  
				ReceiveAmount = 1;
				Time = 1;
				ShredAmount = 3;
				Costs = {
					{
						ID = 179; -- Glue
						Amount = 2;
					};
					{
						ID = 24; -- Cloth
						Amount = 10;
					};
				};
				Hidden = true;
			};
			{
				ID = 107; -- Bone Trophy
				ReceiveAmount = 1;
				Time = 1;
				Costs = {
					{
						ID = 70; -- Bone Shards
						Amount = 40;
					};
				};
				Hidden = true;
			};
			{
				ID = 176; -- Empty Can
				ReceiveAmount = 1;
				Time = 1;
				Costs = {
					{
						ID = 45; -- Iron Shards
						Amount = 20;
					};
				};
				Hidden = true;
			};
		};
	};
	
	{
		Type = "Medical";
		Recipes = {
			{
				ID = 2; -- Bandage
				ReceiveAmount = 1;
				Time = 4;
				BenchNeeded = "Culinary Table";
				TierNeeded = 0;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 4;
					};
				};
			};
			{
				ID = 136; -- Small Medkit
				ReceiveAmount = 1;
				Time = 8;
				BenchNeeded = "Culinary Table";
				TierNeeded = 1;
				Costs = {
					{
						ID = 24; -- Cloth
						Amount = 15;
					};
					{
						ID = 45; -- Iron Shards
						Amount = 10;
					};
					{
						ID = 68; -- Crude Fuel
						Amount = 10;
					};
				};
			};
		};
	};
	
	{
		Type = "Other";
		Recipes = {
			{
				ID = 12; -- Salvaged Sight
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Anvil";
				TierNeeded = 2;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 4;
					};
				};
			};
			{
				ID = 16; -- Weapon Flashlight
				ReceiveAmount = 1;
				Time = 20;
				BenchNeeded = "Anvil";
				TierNeeded = 4;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 4;
					};
				};
			};
			{
				ID = 14; -- Compensator
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 5;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 6;
					};
				};
			};
			{
				ID = 8; -- Silencer
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 6;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 8;
					};
				};
			};
			{
				ID = 13; -- Muzzle Boost
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 6;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 8;
					};
				};
			};
			{
				ID = 7; -- Holo Sight
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 7;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 10;
					};
					{
						ID = 88; -- Circuit Boards
						Amount = 1;
					};
				};
			};
			{
				ID = 15; -- Laersight
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 8;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 5;
					};
					{
						ID = 88; -- Circuit Boards
						Amount = 1;
					};
				};
			};
			{
				ID = 17; -- Salvaged Sniper Scope
				ReceiveAmount = 1;
				Time = 30;
				BenchNeeded = "Anvil";
				TierNeeded = 9;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 50;
					};
				};
			};
			{
				ID = 18; -- Military Sniper Scope
				ReceiveAmount = 1;
				Time = 30;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 75;
					};
				};
				Hidden = true
			};
			{
				ID = 196; -- Military ACOG Sight
				ReceiveAmount = 1;
				Time = 30;
				Costs = {
					{
						ID = 46; -- Steel Metal
						Amount = 30;
					};
					{
						ID = 88; -- Circuit Boards
						Amount = 3;
					};
				};
				Hidden = true
			};
		};
	};
}

return BasePartRecipes