-- [PATH] ReplicatedStorage / Modules / Items @Type ModuleScript
--[[
	Items
	by ChickenBagelz
	July 16, 2022
	
	Holds all information of every item in the game
	
	
	DOCUMENTATION:
	
	[id] = {
		Name = The name of the item
		Image = A link to the items image. If item has skins, set it up as a dictionary, like this:
		{
			["Default"] = link;
			["Gold"] = link;
		}
		Description = A brief description of the item
		Type = What type of item it is. This will determine multiple behaviors of the item, so this is important. All current possible types are:
			Misc (average item)
			Resource (miscellaneous item that can go inside a BC)
			Tool (has some sort of VM to initialize)
			Gun (variation of a Tool)
			Bench (can be placed)
			Lock (places onto existing Benches)
			Ammo
			Attachment
			Consumable
			Armor (can be equipped on an armor slot)
		MaxStack = The max possible stack the item can be in.
		DespawnTime = How long it takes for the item to be cleared once it's dropped. If inside a bag, the highest despawn time will be prioritized.
		ItemWorth = The average value this item is worth. Used to determine holster priority and container total worth values. Also used to determine quick craft shit.
		Sounds = Sound names played under ReplicatedStorage.LocalSounds (all of these are optional)
			Grab = Sound played when the item is picked up in your inventory
			Drop = Sound played when the item is dropped onto a slot in your inventory
		WeldInfo = If present, will allow the item to be holstered onto the player when unequipped.
			Part = Name of the limb the item will be welded to.
			Offset = The CFrame offset applied to the item when welded.
		MaxDurability = How much durability the item has. If not present, it will be infinite (if applicable).
		BaseMaxAmmo = How much base ammo the item can hold
		AmmoType = Used for guns and ammo. Only matching ammo types can be reloaded into guns with the same ammo type.
		AmmoWheelImage = Silhouette image used in ammo selection wheel.
		AmmoStats = Stats applied to weapon when ammo is used. Here are all possible stats:
			DamageMult = Damage multiplier applied to weapon with this ammo
			SpeedMult = Speed multiplier applied to weapon with this ammo
			RangeMult = Range multiplier applied to weapon with this ammo
			GravityMult = Gravity multiplier applied to weapon with this ammo
			HipSpreadMult = Hip spread multiplier applied to weapon with this ammo
			AimSpreadMult = Aim spread multiplier applied to weapon with this ammo
			BleedMult = Bleed multiplier applied to weapon with this ammo
			ArmorPenMult = Multiplier applied to Bullet armor defense (eg 50% defense with a 50% armor pen mult would reduce it to 25% defense)
			Bullets = Total number of pellets this ammo shoots out
			TracerName = Name of bullet model used for visualization, found in ReplicatedStorage.VFX
			BulletSize = Size of the bullet hitbox
			Impact = If present, the name prefix that will override default impact VFX when bullet lands. All available are:
				"ExplosionBullet" = Overrides all material impacts to the ExplosionBullet impact. Purely cosmetic.
				"Explosive" = Creates an Explosion VFX effect. Purely cosmetic.
				"Stick" = Makes the bullet stick onto the surface it lands on. Still creates impact particles and sound.
					ShatterChance = Determines the % chance for the bullet to not stick and shatter. Defaults to 0.
				"Fire" = 
			StepType = If present, will override the default bullet step function with this one. If set to "", will have no step function.
			WeaponDurability = How much durability the weapon that shot this ammo loses per round
			MuzzleDurability = How much durability muzzle attachments lose with this ammo
			Explosive = If present, the bullet will have an AOE when hitting something. The following paramters are:
				Radius = Radius, in studs, where it will do splash damage
				HumanoidMaxDamage = Extra damage added on top of the current bullet's damage. Scales based on distance from center
				SoftSideMult = How much bench damages are multiplied if hitting the soft side with explosive
				BenchDamageMults = Holds all multipliers to the current weapon's ObjectDamages table when splashed
		Attachments = If present, a table of all possible attachment types that can be equipped to the item. All current possible configurations are:
			Sight
			Muzzle
			Barrel
			Magazine
		AttachmentType = The type of attachment this item is. Look above this for all attachment types.
		AttachmentStats = Stats applied to the weapon when this attachment is equipped. All possible configurations are:
			DamageMult = Multiplier added to weapon's total damage. [STACKS]
			FireRateMult = Multiplier added to weapon's fire rate. [STACKS]
			RecoilMult = Multiplier added to weapon's default recoil. [STACKS]
			GunRecoilAimMult = Multiplier for how much gun VM recoil happens in the X and Z when you fire whilst ADSing. [STACKS]
			SwayMult = Multiplier added to weapon's idle and aim sway. [STACKS]
			HipSpreadMult = Multiplier added to aimcone when firing without ADSing. [STACKS]
			AimSpreadMult = Multiplier added to aimcone when firing while ADSing. [STACKS]
			ZoomLevel = Determines your zoom level when ADSing, overriding the weapon's default zoom level.
			Scope = If present, will ADS using the sniper scope UI and use this value as the scope's size.
			Toggle = If enabled, will allow you attachment to be toggled on and off. All other stats are only applied when toggled on.
			HideTracer = If true, will hide bullet tracer from all players.
			AimForRecoilMult = If true and RecoilMult is present, it will only take effect when ADSing.
		SmeltInfo = If present, allows the item to be smelted in specified containers
			Amount = Item amount used per smelt
			Time = Seconds for item to smelt fully
			LootTable = LootTable path for items given once item smelts. If not present, won't give anything once it smelts. Found under ServerStorage.Modules.LootTableModule
		};
		ArmorType = Armor type index of the item. This will determine which ArmorTypes it's incompatible with. All possible ArmorTypes are found under ReplicatedStorage.Modules.ArmorModule
		HideHair = If true, the armor will hide all hair parts on the player when equipped
		Attribute = Must be a string, sets an attribute under Player that equals to true whenever this armor is ever present and not broken
		Resistances = {
			Heat = 0; --Heat resistance
			Cold = 0; --Cold resistance
			Explosive = 0; --Explosive resistance
			Radiation = 0; --Radiation resistance
			Animal = 0; --Animal damage resistance
			Legs = { --Damage to the legs resistance
				Bullet = 0;
				Melee = 0;
			};
			Chest = { --Damage to the chest resistance
				Bullet = 0;
				Melee = 0;
			};
			Head = { --Damage to the head resistance
				Bullet = 0;
				Melee = 0;
			};
		}
		DropInfo = If present, allows the item to be "crushed" into another item(s). Works by applying a loot table onto the player.
			ButtonName = Action text displayed on the action menu button
			LootTable = LootTable path for items given once the item is crushed. Found under ServerStorage.Modules.LootTableModule
	}
]]


local Items = {
	[1] = {
		Name = "Wood Log";
		Image = "rbxassetid://14183996624";
		Description = [[Wood harvested from a tree. Used as a crafting component and fuel.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 5;
		SmeltInfo = {
			Amount = 1;
			Time = 10;
			LootTable = {"Smelt", "General", "Wood Log"}; -- 1 Charcoal
		};
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[2] = {
		Name = "Bandage";
		Image = "rbxassetid://14134567329";
		Description = [[A primitive healing tool. Heals 5 HP per use.]];
		Type = "Tool";
		MaxStack = 3;
		DespawnTime = 5;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
		ConsumableStats = {
			Health = 5;
			HQueue = 0;
			StopBleeds = true;
		};
	};
	[3] = {
		Name = "Stone Hatchet";
		Image = {
			["Default"] = "rbxassetid://15073617325";
			["Molten"] = "rbxassetid://15305732445";
			["Shark"] = "rbxassetid://16208668072";
			["VIP"] = "rbxassetid://16014755281";
			["Valentine"] = "rbxassetid://16281532811";
		};
		Description = [[Primitive tool for gathering wood more efficiently.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 175;
		ItemWorth = 20;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067);
		};
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[4] = {
		Name = "Heavy Ammo";
		Image = "rbxassetid://13186564679";
		Description = [[Standard heavy ammo.]];
		Type = "Ammo";
		MaxStack = 128;
		DespawnTime = 20;
		AmmoType = "Rifle";
		AmmoWheelImage = "rbxassetid://2535574992";
		AmmoStats = {
			TracerName = "RifleBullet";
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[5] = {
		Name = "Salvaged AK47";
		Image = {
			["Default"] = "rbxassetid://14882620172";
			["Anodized Red"] = "rbxassetid://15291340361";
			["Frosty"] = "rbxassetid://15304886302";
			["Vaporwave"] = "rbxassetid://15574230457";
			["Anodized Blue"] = "rbxassetid://15792000837";
			["Diablo"] = "rbxassetid://16021791118";
			["Blue Gem"] = "rbxassetid://16577230239";
			
		};
		Description = [[Great damage, firerate, and range, but strong recoil. Uses Heavy Ammo.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 45;
		MaxDurability = 675;
		BaseMaxAmmo = 30;
		AmmoType = "Rifle";
		Attachments = {"Sight", "Muzzle", "Barrel"};
		ItemWorth = 500;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(-0.0388, -0.3648, 0.6324, 0.5917, -0.8061, 0, 0.8062, 0.5917, 0, 0, 0, 1);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[6] = {
		Name = "Bottle Caps";
		Image = "rbxassetid://14654996629";
		Description = [[Official currency of Fallen. Can be used for purchasing and unlocking crafting recipes.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 5;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[7] = {
		Name = "Holo Sight";
		Image = "rbxassetid://14162721610";
		Description = [[Holographic sight. Provides enhanced zoom and aim spread reduction.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 30;
		AttachmentType = "Sight";
		AttachmentStats = {
			ZoomLevel = 1.5;
			AimSpreadMult = -0.2;
			GunRecoilAimMult = -0.4;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[8] = {
		Name = "Silencer";
		Image = "rbxassetid://15347105863";
		Description = [[Muzzle attachment. Lowers gunshot sounds, spread, and removes tracers for the cost of damage reduction.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 20;
		MaxDurability = 400;
		AttachmentType = "Muzzle";
		AttachmentStats = {
			DamageMult = -0.20;
			--[[HipSpreadMult = -0.1;
			AimSpreadMult = -0.1;]]
			HideTracer = true;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[9] = {
		Name = "Salvaged M14";
		Image = {
			["Default"] = "rbxassetid://14882876522";
			["Paintball"] = "rbxassetid://15305730875";
			["Candy Dragon"] = "rbxassetid://15346320769";
			["Splat"] = "rbxassetid://16031054728";
			["High Tide"] = "rbxassetid://16483734949";
		};
		Description = [[Semi automatic rifle. Good damage and range, but a slower firerate. Uses Heavy Ammo.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 30;
		MaxDurability = 330;
		BaseMaxAmmo = 15;
		AmmoType = "Rifle";
		Attachments = {"Sight", "Muzzle", "Barrel"};
		ItemWorth = 400;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(-0.2223, -0.2861, 0.627, 0.0001, -0.7788, -0.6272, 0.0001, 0.6273, -0.7788, 1, 0, -0);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[10] = {
		Name = "Lighter";
		Image = "rbxassetid://15128007580";
		Description = [[A handheld Lighter. Provides small amount of light to help illuminate dark areas.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 300;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[11] = {
		Name = "Swift Heavy Ammo";
		Image = "rbxassetid://13186565740";
		Description = [[Swift heavy ammo. Travels faster and longer distances.]];
		Type = "Ammo";
		MaxStack = 128;
		DespawnTime = 25;
		AmmoType = "Rifle";
		AmmoWheelImage = "rbxassetid://2535574992";
		AmmoStats = {
			SpeedMult = 1.25;
			RangeMult = 1.25;
			TracerName = "RifleBullet";
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[12] = {
		Name = "Salvaged Sight";
		Image = "rbxassetid://15283494417";
		Description = [[A makeshift weapon sight. Lower FOV, but provides a small reduction in spread.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 10;
		AttachmentType = "Sight";
		AttachmentStats = {
			ZoomLevel = 1.15;
			AimSpreadMult = -0.1;
			GunRecoilAimMult = -0.15;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[13] = {
		Name = "Muzzle Boost";
		Image = "rbxassetid://15347107233";
		Description = [[Muzzle attachment. Slightly increases firerate at the cost of spread.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 20;
		MaxDurability = 400;
		AttachmentType = "Muzzle";
		AttachmentStats = {
			FireRateMult = 0.12;
			HipSpreadMult = 0.15;
			AimSpreadMult = 0.3;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[14] = {
		Name = "Compensator";
		Image = "rbxassetid://15347108187";
		Description = [[Muzzle attachment. Provides better recoil compensation for the slight cost of hip spread.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 15;
		MaxDurability = 400;
		AttachmentType = "Muzzle";
		AttachmentStats = {
			RecoilMult = -0.25;
			RangeMult = -0.2;
			HipSpreadMult = 0.3;
			AimSpreadMult = 0.1;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[15] = {
		Name = "Salvaged Lasersight";
		Image = "rbxassetid://15347108897";
		Description = [[Barrel attachment. Lowers spread and aim sway when toggled.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 40;
		AttachmentType = "Barrel";
		AttachmentStats = {
			Toggle = true;
			HipSpreadMult = -0.35;
			AimSpreadMult = -0.15;
			SwayMult = -0.8;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[16] = {
		Name = "Weapon Flashlight";
		Image = "rbxassetid://15373700419";
		Description = [[Barrel attachment. Provides great visibility in dark situations.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 20;
		AttachmentType = "Barrel";
		AttachmentStats = {
			Toggle = true;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[17] = {
		Name = "Salvaged Sniper Scope";
		Image = "rbxassetid://15304097362";
		Description = [[Sniper scope that provides 4x augmentation.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 40;
		AttachmentType = "Sight";
		AttachmentStats = {
			ZoomLevel = 4;
			RecoilMult = 0.5;
			AimForRecoilMult = true;
			AimSpreadMult = -0.1;
			Scope = 1.05;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[18] = {
		Name = "Military Sniper Scope";
		Image = "rbxassetid://15304097316";
		Description = [[Military-grade sniper scope with 8x augmentation.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 45;
		AttachmentType = "Sight";
		AttachmentStats = {
			ZoomLevel = 8;
			RecoilMult = 0.5;
			AimForRecoilMult = true;
			AimSpreadMult = -0.1;
			Scope = 0.95;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[19] = {
		Name = "Wooden Spear";
		Image = "rbxassetid://15303292373";
		Description = [[Deal damage from up close. Can be effectively thrown.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 100;
		ItemWorth = 24;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(-0.0829, 0.0772, 0.5622, 0.2589, -0.9659, 0, -0.9659, -0.2588, 0.0001, 0, 0, -1);
		};
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[20] = {
		Name = "Stone Spear";
		Image = "rbxassetid://15303292549";
		Description = [[An upgrade to the Wooden Spear. Sturdier and more effective.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 120;
		ItemWorth = 25;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(-0.0785, 0.0868, 0.5842, 0.2589, 0.0001, 0.966, -0.9659, 0, 0.2589, 0.0001, -1, 0.0001);
		};
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[21] = {
		Name = "Stone Pickaxe";
		Image = {
			["Default"] = "rbxassetid://15073617163";
			["Molten"] = "rbxassetid://15305731898";
			["VIP"] = "rbxassetid://16014754516";
			["Valentine"] = "rbxassetid://16281531919";
		};
		Description = [[Primitive tool for gathering stone and minerals more effectively.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 175;
		ItemWorth = 19;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067);
		};
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[22] = {
		Name = "Crossbow";
		Image = {
			["Default"] = "rbxassetid://15305596532";
			["Crossbones"] = "rbxassetid://15305756728";
			["HotDog"] = "rbxassetid://15877969435";
			["Candy Whale"] = "rbxassetid://16114353256";
			["Emerald"] = "rbxassetid://16751858634";
		};
		Description = [[Fires all types of arrows. Slow to reload and fire, but comes with greater velocity than the bow.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 15;
		MaxDurability = 75;
		BaseMaxAmmo = 1;
		Attachments = {"Sight", "Barrel"};
		AmmoType = "Arrow";
		ItemWorth = 50;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(-0.1409, -0.0804, 0.737, 0.5, 0, 0.8661, -0.866, 0, 0.5, 0, -1, 0);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[23] = {
		Name = "Wooden Bow";
		Image = {
			["Default"] = "rbxassetid://15313266356";
			["Blue Fissure"] = "rbxassetid://15313269139";
			["Sweet Gingerbread"] = "rbxassetid://15623006255";
			["Cupid"] = "rbxassetid://16260403928";
			["Crimson"] = "rbxassetid://16912320324";
		};
		Description = [[A bow made from wood and cloth, fires any kind of arrow.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 140;
		BaseMaxAmmo = 1;
		AmmoType = "Arrow";
		Attachments = {};
		ItemWorth = 35;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(-0.4203, -0.0257, 0.5778, 0.757, -0.6534, 0.0049, -0.6534, -0.7569, 0.0057, 0, -0.0074, -0.9999);
		}; -- CFrame.new(0.0166, -0.1705, 0.5805, 0, -0.866, 0.5, 0, 0.5, 0.8661, -1, 0, 0);
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[24] = {
		Name = "Cloth";
		Image = "rbxassetid://13207713326";
		Description = [[Strands of cloth. Crafting material.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 10;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[25] = {
		Name = "Cactus Flesh";
		Image = "rbxassetid://13219980518";
		Description = [[Cactus flesh gathered from a catus. Not very nutricious.]];
		Type = "Consumable";
		MaxStack = 10;
		DespawnTime = 5;
		ConsumableStats = {
			Health = 0;
			HQueue = 3;
			Hunger = 1;
			Thirst = 8;
		};
		Sounds = {
			Drag = "GrassPickup";
			Drop = "GrassDrop";
		};
	};
	[26] = {
		Name = "Stone";
		Image = "rbxassetid://14308848818";
		Description = [[Unearthed stone, used for crafting recipes and upgrading your base.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 5;
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[27] = {
		Name = "Iron Ore";
		Image = "rbxassetid://14308849053";
		Description = [[Raw iron ore. Smelt to refine.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 10;
		SmeltInfo = {
			Amount = 3;
			Time = 10;
			LootTable = {"Smelt", "Furnace", "Iron Ore"}; -- 3 Iron Shard
		};
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[28] = {
		Name = "Quality Iron Ore";
		Image = "rbxassetid://14308848947";
		Description = [[Raw quality iron ore. Smelts into Steel.]];
		Type = "Resource";
		MaxStack = 100;
		DespawnTime = 20;
		SmeltInfo = {
			Amount = 2;
			Time = 13.33;
			LootTable = {"Smelt", "Furnace", "Quality Iron Ore"}; -- 2 Steel Metal
		};
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[29] = {
		Name = "Campfire";
		Image = {
			["Default"] = "rbxassetid://15128008159";
		};
		Description = [[Primitive campfire that allows the cooking of raw food. Not very effective.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 10;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[30] = {
		Name = "Blueprint";
		Image = "rbxassetid://15132469785";
		Description = [[Start your base construction! Hold right click to switch base parts.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[31] = {
		Name = "Hammer";
		Image = {
			["Default"] = "rbxassetid://15318044673";
			["Toy"] = "rbxassetid://15509809013";
			["ERROR 404"] = "rbxassetid://15305728235";
			["Building Blocks"] = "rbxassetid://15953856112";
		};
		Description = [[Allows you to repair objects and upgrade base parts.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[32] = {
		Name = "Raw Pork";
		Image = "rbxassetid://15295774046";
		Description = [[Raw pork meat. Not recommended for consumption. Cook in a campfire.]];
		Type = "Consumable";
		MaxStack = 20;
		DespawnTime = 5;
		ConsumableStats = {
			Health = -3;
			HQueue = 0;
			Hunger = 10;
			Thirst = 0;
		};
		SmeltInfo = {
			Amount = 1;
			Time = 15;
			LootTable = {"Smelt", "Campfire", "Raw Pork"}; -- 1 Cooked Pork
		};
		Sounds = {
			Drag = "MeatPickup";
			Drop = "MeatDrop";
		};
	};
	[33] = {
		Name = "Cooked Pork";
		Image = "rbxassetid://15295773801";
		Description = [[Cooked pork meat. Great food source.]];
		Type = "Consumable";
		MaxStack = 20;
		DespawnTime = 5;
		ConsumableStats = {
			Health = 3;
			HQueue = 2;
			Hunger = 20;
			Thirst = 1;
		};
		Sounds = {
			Drag = "MeatPickup";
			Drop = "MeatDrop";
		};
	};
	[34] = {
		Name = "Charcoal";
		Image = "rbxassetid://13207713474";
		Description = [[The remains of burnt wood. Crafting material.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 5;
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[35] = {
		Name = "Salvaged P250";
		Image = {
			["Default"] = "rbxassetid://15305065991";
			["Splat"] = "rbxassetid://15305728596";
			["Fade"] = "rbxassetid://15631601051";
			["Peppermint"] = "rbxassetid://15712513595";
			["Sketch"] = "rbxassetid://16208668754";
			["Egg Sketch"] = "rbxassetid://16916693041";
		};
		Description = [[Semi-automatic pistol with low to medium range. Average firerate and damage. Uses Light Ammo.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 20;
		MaxDurability = 180;
		BaseMaxAmmo = 8;
		AmmoType = "Pistol";
		Attachments = {"Sight", "Muzzle"};--, "Barrel"};
		ItemWorth = 140;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(1.0928, -0.1503, 0.1334, 0, 0, -1, 1, 0, 0, 0, -1, 0);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[36] = {
		Name = "Light Ammo";
		Image = "rbxassetid://13685818536";
		Description = [[Standard light ammo.]];
		Type = "Ammo";
		MaxStack = 128;
		DespawnTime = 20;
		AmmoType = "Pistol";
		AmmoWheelImage = "rbxassetid://15635709508";
		AmmoStats = {
			TracerName = "RifleBullet";
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[37] = {
		Name = "Boulder";
		Image = {
			["Default"] = "rbxassetid://15304806846";
			["Bubblegum"] = "rbxassetid://15304805303";
			["Frosty"] = "rbxassetid://15304805239";
			["Tester"] = "rbxassetid://15304805180";
			["Voxel"] = "rbxassetid://15574223076";
			["Wrapped"] = "rbxassetid://15712360641";
			["Fish Tank"] = "rbxassetid://15792001129";
			["ERROR 404"] = "rbxassetid://16031055626";
		};
		Description = [[A boulder, your starting tool. Good for breaking trees, nodes, or bashing heads.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 2;
		MaxDurability = 200;
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[38] = {
		Name = "Salvaged SMG";
		Image = {
			["Default"] = "rbxassetid://15132874040";
			["Fire and Ice"] = "rbxassetid://15312330570";
			["Splat"] = "rbxassetid://15313314715";
			["Red Urban"] = "rbxassetid://15574233065";
			["Inferno"] = "rbxassetid://15883391466";
			["Checkmate"] = "rbxassetid://16114277804";
			["Valentine"] = "rbxassetid://16281529715";
			["Evil Easter"] = "rbxassetid://16916946492";
		};
		Description = [[Fully automatic, slower firing with moderate damage. Well rounded sub machine gun. Uses Light Ammo.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 25;
		MaxDurability = 450;
		BaseMaxAmmo = 20;
		AmmoType = "Pistol";
		Attachments = {"Sight", "Muzzle", "Barrel"};
		ItemWorth = 350;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.0236, -0.0898, 0.5505, -0, -0.866, -0.5, -0, 0.5, -0.866, 1, 0.0001, -0);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[39] = {
		Name = "Salvaged Python";
		Image = {
			["Default"] = "rbxassetid://15188995729";
			["Canvas"] = "rbxassetid://15283200809";
			["Hazard"] = "rbxassetid://15305731383";
			["Blue Prey"] = "rbxassetid://15574225312";
			["Saku"] = "rbxassetid://16029067988";
			["Inferno"] = "rbxassetid://16283806768";
			["Pink Canvas"] = "rbxassetid://16663261806";
			["Crimson Glitched"] = "rbxassetid://16912320052";
		};
		Description = [[Limited magazine pistol that packs a punch. Uses Light Ammo.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 25;
		MaxDurability = 140;
		BaseMaxAmmo = 6;
		AmmoType = "Pistol";
		Attachments = {"Sight", "Barrel"};
		ItemWorth = 340;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(1.1544, 0.237, 0.0757, 0, 0, 1, -1, 0, 0, 0, -1, 0);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[40] = {
		Name = "Combustive Heavy Ammo";
		Image = "rbxassetid://13186583441";
		Description = [[Combustive heavy ammo. Explodes on impact.]];
		Type = "Ammo";
		MaxStack = 128;
		DespawnTime = 45;
		AmmoType = "Rifle";
		AmmoWheelImage = "rbxassetid://2535574992";
		AmmoStats = {
			TracerName = "RifleBullet";
			Impact = "ExplosiveBullet";
			FilterType = "HitIgnore";
			SpeedMult = 0.75;
			RangeMult = 0.75;
			GravityMult = 1.1;
			MuzzleDurability = 3;
			WeaponDurability = 2;
			Explosive = {
				Radius = 1.5;
				HumanoidMaxDamage = 10;
				SoftSideMult = 1.2;
				DamagePrefix = "Explo_";
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[41] = {
		Name = "Animal Fat";
		Image = "rbxassetid://15304534433";
		Description = [[The fats harvested from an animal. Crafting material.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 5;
		Sounds = {
			Drag = "MeatPickup";
			Drop = "MeatDrop";
		};
	};
	[42] = {
		Name = "Small Storage Box";
		Image = {
			["Default"] = "rbxassetid://15094083341";
			["Monster"] = "rbxassetid://15883290696";
			["Comic"] = "rbxassetid://16577230729";
			["Gremlin"] = "rbxassetid://16748563435";
		};
		Description = [[stores stuff]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 30;
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[43] = {
		Name = "Raw Venison";
		Image = "rbxassetid://13220221327";
		Description = [[Raw venison from a deer. Not recommended for consumption. Cook in a campfire.]];
		Type = "Consumable";
		MaxStack = 20;
		DespawnTime = 5;
		ConsumableStats = {
			Health = -6;
			HQueue = 0;
			Hunger = 5;
			Thirst = 1;
		};
		SmeltInfo = {
			Amount = 1;
			Time = 15;
			LootTable = {"Smelt", "Campfire", "Raw Venison"}; -- 1 Cooked Venison
		};
		Sounds = {
			Drag = "MeatPickup";
			Drop = "MeatDrop";
		};
	};
	[44] = {
		Name = "Cooked Venison";
		Image = "rbxassetid://13220221662";
		Description = [[Cooked venison. Great food source.]];
		Type = "Consumable";
		MaxStack = 20;
		DespawnTime = 5;
		ConsumableStats = {
			Health = 0;
			HQueue = 10;
			Hunger = 10;
			Thirst = 2;
		};
		Sounds = {
			Drag = "MeatPickup";
			Drop = "MeatDrop";
		};
	};
	[45] = {
		Name = "Iron Shards";
		Image = "rbxassetid://14184000696";
		Description = [[Crude iron shards. Crafting material.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 15;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[46] = {
		Name = "Steel Metal";
		Image = "rbxassetid://16252541108";
		Description = [[Refined quality iron ore. Crafting material.]];
		Type = "Resource";
		MaxStack = 100;
		DespawnTime = 40;
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[47] = {
		Name = "Wooden Door";
		Image = {
			["Default"] = "rbxassetid://15132568626";
			["Beware"] = "rbxassetid://15305026376";
			["Chocolate"] = "rbxassetid://15712523927";
			["Pot of Gold"] = "rbxassetid://16748559894";
		};
		Description = [[A wooden door vulnerable to fire attacks. Place a Lock to prevent unwanted visitors.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 100;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[48] = {
		Name = "Wooden Lock";
		Image = "rbxassetid://15305165322";
		Description = [[A basic wooden key lock. Locks a bench so only one person can access.]];
		Type = "Lock";
		MaxStack = 10;
		DespawnTime = 5;
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[49] = {
		Name = "Combination Lock";
		Image = "rbxassetid://15305165381";
		Description = [[A metal code lock. Only allows people with the combination access to the bench.]];
		Type = "Lock";
		MaxStack = 10;
		DespawnTime = 5;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[50] = {
		Name = "Salvaged Metal Door";
		Image = {
			["Default"] = "rbxassetid://15132658803";
			["Visions"] = "rbxassetid://15444463543";
			["Graffiti"] = "rbxassetid://16664082484";
		};
		Description = [[Low durability metallic door. Prevents fire attacks. Place a Lock to prevent unwanted visitors.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 100;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[51] = {
		Name = "Base Cabinet";
		Image = "rbxassetid://14653876852";
		Description = [[Vital part of the base. Provides building privilege if authorized and prevents decay. Secure well.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 100;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[52] = {
		Name = "Wooden Double Door";
		Image = {
			["Default"] = "rbxassetid://15132568988";
			["Rainbow"] = "rbxassetid://15344501592";
			["Cherry Blossom"] = "rbxassetid://16577230495";
		};
		Description = [[A wooden double door. Vulnerable to fire attacks. Place a Lock to prevent unwanted visitors.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 100;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[53] = {
		Name = "Wooden Window Bars";
		Image = "rbxassetid://15128007380";
		Description = [[Place on window frames to deny unwanted visitors from jumping in. Vulnerable to fire attacks.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 5;
		MaxDurability = 250;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[54] = {
		Name = "Metal Window Bars";
		Image = "rbxassetid://15132553555";
		Description = [[Place on window frames to deny unwanted visitors from jumping in.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 500;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[55] = {
		Name = "Glass Window";
		Image = "rbxassetid://15210914495";
		Description = [[Allows you to view outside your base while safe from bullet shots.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 15;
		MaxDurability = 250;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[56] = {
		Name = "Steel Glass Window";
		Image = "rbxassetid://15132487922";
		Description = [[Allows you to view outside your base while safe from bullet shots.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 20;
		MaxDurability = 500;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[57] = {
		Name = "Trap Door";
		Image = {
			["Default"] = "rbxassetid://13143032792";
		};
		Description = [[Open or close a hatch for easy access to upwards areas. Immune to fire attacks.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 150;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[58] = {
		Name = "Radiation Vitamins";
		Image = "rbxassetid://15304290390";
		Description = [[Greatly lowers radiation, for the cost of thirst.]];
		Type = "Consumable";
		MaxStack = 10;
		DespawnTime = 5;
		ConsumableStats = {
			Thirst = -4;
			Radiation = -40;
		};
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[59] = {
		Name = "Hoodie";
		Image = {
			["Default"] = "rbxassetid://14654794392";
			["Forest Camo"] = "rbxassetid://15283152783";
			["Red"] = "rbxassetid://15283152304";
			["Purple"] = "rbxassetid://15283152380";
			["Green"] = "rbxassetid://15283152598";
			["Abibas"] = "rbxassetid://15305689057";
			["Wool"] = "rbxassetid://15877516276";
			["Valentine"] = "rbxassetid://16293021303";
			["Woodland"] = "rbxassetid://16448119412";
		};
		Description = [[Provides good resistance against the cold.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 10;
		ArmorType = "Shirt";
		Resistances = {
			Heat = 0;
			Cold = 9;
			Explosive = 2;
			Radiation = 5;
			Animal = 6;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 20;
				Melee = 15;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[60] = {
		Name = "Hazmat Suit";
		Image = {
			["Default"] = "rbxassetid://15046441717";
			["Snowman"] = "rbxassetid://15712521421";
			["Blue Fissure"] = "rbxassetid://16822398564";
		};
		Description = [[This full-body Hazmat Suit provides radiation protection plus basic damage resistance.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 15;
		MaxDurability = 2800;
		ArmorType = "All";
		Attribute = "ResistWet";
		HideHair = true;
		Resistances = {
			Heat = 0;
			Cold = 8;
			Explosive = 7;
			Radiation = 50;
			Animal = 8;
			Legs = {
				Bullet = 25;
				Melee = 25;
			};
			Chest = { 
				Bullet = 25;
				Melee = 25;
			};
			Head = { 
				Bullet = 25;
				Melee = 25;
			};
		};
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[61] = {
		Name = "Chicken MRE";
		Image = "rbxassetid://14162884663";
		Description = [[A full meal made from chicken ready to eat. Provides a great amount of nutrition.]];
		Type = "Consumable";
		MaxStack = 5;
		DespawnTime = 10;
		ConsumableStats = {
			Health = 0;
			HQueue = 3;
			Hunger = 20;
			Thirst = 10;
		};
		Sounds = {
			Drag = "GrassPickup";
			Drop = "GrassDrop";
		};
	};
	[62] = {
		Name = "Beef MRE";
		Image = "rbxassetid://14162884919";
		Description = [[A full meal made from beef ready to eat. Provides a great amount of nutrition.]];
		Type = "Consumable";
		MaxStack = 5;
		DespawnTime = 10;
		ConsumableStats = {
			Health = 0;
			HQueue = 3;
			Hunger = 20;
			Thirst = 10;
		};
		Sounds = {
			Drag = "GrassPickup";
			Drop = "GrassDrop";
		};
	};
	[63] = {
		Name = "Pants";
		Image = {
			["Default"] = "rbxassetid://14654792590";
			["Khaki"] = "rbxassetid://15283151856";
			["Forest Camo"] = "rbxassetid://15283152437";
			["Abibas"] = "rbxassetid://15305689962";
			["Valentine"] = "rbxassetid://16293019822";
			["Woodland"] = "rbxassetid://16448121262";
		};
		Description = [[A nice pair of quality pants.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 10;
		ArmorType = "Pants";
		Resistances = {
			Heat = 0;
			Cold = 8;
			Explosive = 2;
			Radiation = 5;
			Animal = 3;
			Legs = {
				Bullet = 15;
				Melee = 10;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[64] = {
		Name = "Phosphate Ore";
		Image = "rbxassetid://15132608151";
		Description = [[Raw phosphate ore. Smelt to refine.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 15;
		SmeltInfo = {
			Amount = 3;
			Time = 5;
			LootTable = {"Smelt", "Furnace", "Phosphate Ore"}; -- 3 Phosphate Ore
		};
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[65] = {
		Name = "Phosphate Dust";
		Image = "rbxassetid://14183996960";
		Description = [[Smelted phosphate ore. Crafting material.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 25;
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[66] = {
		Name = "Leather";
		Image = "rbxassetid://13207712789";
		Description = [[Strands of leather. Crafting material.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 15;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[67] = {
		Name = "Furnace";
		Image = {
			["Default"] = "rbxassetid://15074084708";
			["Banana"] = "rbxassetid://15344532656";
			["Sweet Gingerbread"] = "rbxassetid://15622165066";
			["Glyphs"] = "rbxassetid://15630767150";
			["Gorilla"] = "rbxassetid://16484587298";
		};
		Description = [[Primitive furnace designed to reach temperatures hot enough to refine ores using wood. Limited capacity.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 100;
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[68] = {
		Name = "Crude Fuel";
		Image = "rbxassetid://14651282157";
		Description = [[Fuel source for generators and vehicles. Crafting material.]];
		Type = "Resource";
		MaxStack = 500;
		DespawnTime = 10;
		Sounds = {
			Drag = "LiquidPickup";
			Drop = "LiquidDrop";
		};
	};
	[69] = {
		Name = "Gunpowder";
		Image = "rbxassetid://15074277771";
		Description = [[Combustable material made from phosphate and charcoal. Crafting material.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 45;
		Sounds = {
			Drag = "GrassPickup";
			Drop = "GrassDrop";
		};
	};
	[70] = {
		Name = "Bone Shards";
		Image = "rbxassetid://13207713694";
		Description = [[The remaining shards of bones harvested from an animal. Crafting material.]];
		Type = "Resource";
		MaxStack = 1000;
		DespawnTime = 10;
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[71] = {
		Name = "Metal Door";
		Image = {
			["Default"] = "rbxassetid://15132832907";
			["Pixel"] = "rbxassetid://15310965325";
			["PLZ NO RAID"] = "rbxassetid://15310983705";
			["Frosty"] = "rbxassetid://15304875360";
			["Angry Bunny"] = "rbxassetid://16924356510";
		};
		Description = [[A metallic door. Medium durability, prevents fire attacks. Place a Lock to prevent unwanted visitors.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 150;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[72] = {
		Name = "Metal Double Door";
		Image = {
			["Default"] = "rbxassetid://15132833297";
			["Pixel"] = "rbxassetid://15310966370";
			["Tropical"] = "rbxassetid://16483738322";
		};
		Description = [[Metallic double door. Vulnerable to fire attacks. Place a Lock to prevent unwanted visitors.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 150;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[73] = {
		Name = "Steel Door";
		Image = {
			["Default"] = "rbxassetid://15132554218";
			["Christmas Tree"] = "rbxassetid://15638295051";
			["Galactic"] = "rbxassetid://16483736587";
		};
		Description = [[A strong steel door. Great durability. Place a Lock to prevent unwanted visitors.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 45;
		MaxDurability = 600;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[74] = {
		Name = "Steel Double Door";
		Image = {
			["Default"] = "rbxassetid://15132553963";
		};
		Description = [[A strong steel double door. Great durability. Place a Lock to prevent unwanted visitors.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 45;
		MaxDurability = 600;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[75] = {
		Name = "Nail Gun";
		Image = {
			["Default"] = "rbxassetid://15305104734";
			["Striker"] = "rbxassetid://15305729695";
			["Magma"] = "rbxassetid://15946260536";
		};
		Description = [[An industrial tool salvaged from the wasteland thats been given a new purpose as a weapon. Shoots Nails.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 210;
		BaseMaxAmmo = 14;
		AmmoType = "Nail";
		Attachments = {};
		ItemWorth = 45;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(1.1325, 0.2604, -0.082, 0, 0, 1, -1, 0, 0, 0, -1, 0);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[76] = {
		Name = "Steel Axe";
		Image = {
			["Default"] = "rbxassetid://13206734202";
			["Ruby"] = "rbxassetid://15444465626";
			["Freeze"] = "rbxassetid://15712516834";
		};
		Description = [[An axe made from steel. Very effective gathering tool.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 500;
		ItemWorth = 94;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.0328, -0.2053, 0.6296, -0, 0.7072, -0.7071, 0.0001, 0.7072, 0.7072, 1, 0.0001, -0);
		};
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};
	[77] = {
		Name = "Steel Pickaxe";
		Image = {
			["Default"] = "rbxassetid://13206733920";
			["Cross"] = "rbxassetid://15444466662";
			["Freeze"] = "rbxassetid://15712518908";
		};
		Description = [[A pickaxe made from steel. Very effective mining tool.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 500;
		ItemWorth = 95;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.0328, -0.2053, 0.6296, -0, 0.7072, -0.7071, 0.0001, 0.7072, 0.7072, 1, 0.0001, -0);
		};
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};
	[78] = {
		Name = "Power Cell";
		Image = "rbxassetid://13187407477";
		Description = [[Electrical component that can be used for puzzles or recycling.]];
		Type = "Misc";
		MaxStack = 10;
		DespawnTime = 20;
		MaxDurability = 100;
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[79] = {
		Name = "Copper Cogs";
		Image = "rbxassetid://14651228837";
		Description = [[A crafting component found in the world and crates. Crafting material.]];
		Type = "Misc"; 
		MaxStack = 20;
		DespawnTime = 30;
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[80] = {
		Name = "Pipe";
		Image = "rbxassetid://14651117776";
		Description = [[A crafting component found in the world and crates. Crafting material.]];
		Type = "Misc";
		MaxStack = 20;
		DespawnTime = 20;
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};	
	[81] = {
		Name = "Propane Tank";
		Image = "rbxassetid://13187406443";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 5;
		DespawnTime = 5;
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};	
	[82] = {
		Name = "Rope";
		Image = "rbxassetid://14651117276";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 50;
		DespawnTime = 10;
		Sounds = {
			Drag = "GrassPickup";
			Drop = "GrassDrop";
		};
	};	
	[83] = {
		Name = "Blade";
		Image = "rbxassetid://14651119220";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 20;
		DespawnTime = 10;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[84] = {
		Name = "Thread";
		Image = "rbxassetid://14651157447";
		Description = [[A crafting component found in the world and crates, Can be used to craft clothing.]];
		Type = "Misc";
		MaxStack = 20;
		DespawnTime = 20;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[85] = {
		Name = "Metal Plating";
		Image = "rbxassetid://14651164157";
		Description = [[A crafting component found in the world and crates, Can be used to craft Armor.]];
		Type = "Misc";
		MaxStack = 20;
		DespawnTime = 20;
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};
	[86] = {
		Name = "Spring";
		Image = "rbxassetid://14651115579";
		Description = [[A crafting component found in the world and crates, Can be used to craft Weapons. Crafting material.]];
		Type = "Misc";
		MaxStack = 20;
		DespawnTime = 20;
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[87] = {
		Name = "Tarp";
		Image = "rbxassetid://14651115367";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 20;
		DespawnTime = 10;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[88] = {
		Name = "Circuit Boards";
		Image = "rbxassetid://14651118848";
		Description = [[A crafting component found in crates, Can be used to craft raiding tools. Crafting material.]];
		Type = "Misc";
		MaxStack = 20;
		DespawnTime = 30;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[89] = {
		Name = "Metal Scraps";
		Image = "rbxassetid://14651117901";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 20;
		DespawnTime = 10;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[90] = {
		Name = "Swift Light Ammo";
		Image = "rbxassetid://13186591166";
		Description = [[Swift light ammo. Travels faster and longer distances.]];
		Type = "Ammo";
		MaxStack = 128;
		DespawnTime = 20;
		AmmoType = "Pistol";
		AmmoWheelImage = "rbxassetid://15635709508";
		AmmoStats = {
			SpeedMult = 1.25;
			RangeMult = 1.25;
			TracerName = "RifleBullet";
		};
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};	
	[91] = {
		Name = "Sleeping Bag";
		Image = {
			["Default"] = "rbxassetid://15313154200";
			["Cucumber John"] = "rbxassetid://15313175563";
			["Prismatic"] = "rbxassetid://15574227229";
			["Santa"] = "rbxassetid://15715978392";
			["Shark"] = "rbxassetid://16117442613";
		};
		Description = [[Sleeping bags are used as a respawn point on the map. Sleeping bags placed too close to one another will share the same cooldown.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 40;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[92] = {
		Name = "Timed Charge";
		Image = "rbxassetid://13169199238";
		Description = [[Timed explosive charge. Heavy single target bench damage.]];
		Type = "Tool";
		MaxStack = 10;
		DespawnTime = 50;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[93] = {
		Name = "Nails";
		Image = "rbxassetid://13186564996";
		Description = [[Metal nails. Can be shot out of a Nail Gun.]];
		Type = "Ammo";
		MaxStack = 128;
		DespawnTime = 5;
		AmmoType = "Nail";
		AmmoWheelImage = "rbxassetid://2535574992";
		AmmoStats = {
			TracerName = "NailBullet";
			Impact = "Stick";
			ShatterChance = 30;
			StepType = "";
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[94] = {
		Name = "Garage Door";
		Image = {
			["Default"] = "rbxassetid://16574547137";
			["King Raid"] = "rbxassetid://15344456682";
			["Blob"] = "rbxassetid://15509791543";
			["Surprise Meow"] = "rbxassetid://16574535811";
			["King of the street"] = "rbxassetid://17193053474";
		};
		Description = [[A Garage Door. Very durable, but slow opening and closing times.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 300;
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};
	[95] = {
		Name = "Dynamite Bundle";
		Image = "rbxassetid://15127431071";
		Description = [[Crude bundle of dynamite sticks. Fuse times may vary and explosion is not guaranteed.]];
		Type = "Tool";
		MaxStack = 10;
		DespawnTime = 20;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[96] = {
		Name = "Dynamite Stick";
		Image = "rbxassetid://15127430886";
		Description = [[Crude dynamite grenade stick. Fuse times may vary and explosion is not guaranteed.]];
		Type = "Tool";
		MaxStack = 5;
		DespawnTime = 15;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[97] = {
		Name = "Salvaged RPG";
		Image = {
			["Default"] = "rbxassetid://15132772506";
			["Blast"] = "rbxassetid://15305772236";
		};
		Description = [[Shoots rocket-propelled grenades at fast speeds that explode on impact.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 45;
		MaxDurability = 40;
		BaseMaxAmmo = 1;
		AmmoType = "Rocket";
		Attachments = {};
		ItemWorth = 550;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.2261, -0.4751, 0.6137, -0.5362, -0.844, 0, -0.844, 0.5363, 0, 0, 0, -1);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[98] = {
		Name = "Rocket";
		Image = "rbxassetid://15132772763";
		Description = [[Explosive rocket ammunition.]];
		Type = "Ammo";
		MaxStack = 3;
		DespawnTime = 50;
		AmmoType = "Rocket";
		AmmoWheelImage = "rbxassetid://15635733735";
		AmmoStats = {
			TracerName = "Rocket";
			Impact = "Explosion";
			FilterType = "HitIgnore";
			Explosive = {
				Radius = 8.5;
				HumanoidMaxDamage = 175;
				SoftSideMult = 1;
				DamagePrefix = "";
				ShakeStrength = 0.8;
				Duration = 0.45;
				SoundName = "Rocket";
			};
			StepType = "";
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[99] = {
		Name = "Swift Rocket";
		Image = "rbxassetid://15637955888";
		Description = [[Swift rocket ammunition. Much faster velocity with lower damages.]];
		Type = "Ammo";
		MaxStack = 3;
		DespawnTime = 45;
		AmmoType = "Rocket";
		AmmoWheelImage = "rbxassetid://15635741795";
		AmmoStats = {
			TracerName = "HVRocket";
			Impact = "Explosion";
			FilterType = "HitIgnore";
			SpeedMult = 1.35;
			RangeMult = 1.35;
			Explosive = {
				Radius = 8;
				HumanoidMaxDamage = 180;
				SoftSideMult = 1;
				DamagePrefix = "HV_";
				ShakeStrength = 0.7;
				Duration = 0.4;
				SoundName = "Rocket";
			};
			StepType = "";
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[100] = {
		Name = "Combustive Rocket";
		Image = "rbxassetid://15637959127";
		Description = [[Combustive rocket ammunition. Explodes into a gulf of flames.]];
		Type = "Ammo";
		MaxStack = 3;
		DespawnTime = 45;
		AmmoType = "Rocket";
		AmmoWheelImage = "rbxassetid://15635738700";
		AmmoStats = {
			TracerName = "IncendiaryRocket";
			Impact = "Fire";
			FilterType = "HitIgnore";
			DamageMult = 0.75;
			Explosive = {
				Radius = 7.5;
				HumanoidMaxDamage = 50;
				SoftSideMult = 1;
				DamagePrefix = "HV_";
				ShakeStrength = 0.4;
				Duration = 0.25;
				SoundName = "Rocket";
			};
			StepType = "";
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[101] = {
		Name = "External Wooden Wall";
		Image = "rbxassetid://15132487460";
		Description = [[Barbed wooden wall that can be placed outside your base to further prevent intruders.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 500;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[102] = {
		Name = "External Wooden Gate";
		Image = "rbxassetid://15132487698";
		Description = [[Barbed wooden gate that can be placed outside your base to further prevent intruders.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 500;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[103] = {
		Name = "Vertical Window Cover";
		Image = "rbxassetid://15396925620";
		Description = [[Extra cover that can be placed on top of windows.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 500;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[104] = {
		Name = "Horizontal Window Cover";
		Image = "rbxassetid://15396925485";
		Description = [[Extra cover that can be placed on top of windows.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 500;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[105] = {
		Name = "Jail Wall";
		Image = "rbxassetid://13547704099";
		Description = [[Sturdy metal bars. Can be shot through but not trespassed.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 75;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[106] = {
		Name = "Jail Door";
		Image = "rbxassetid://13547704298";
		Description = [[Sturdy metal bars that can be opened. Can be shot through but not trespassed.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 75;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[107] = {
		Name = "%s's Trophy";
		Image = "rbxassetid://15274399715";
		Description = [[Belongs to %s. I wonder what it's made out of..?]];
		Type = "Misc";
		MaxStack = 1;
		DespawnTime = 3;
		DropInfo = {
			ButtonName = "CRUSH";
			LootTable = {"ItemDrops", "Trophy"}; -- 20 Bone Shards
		};
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[108] = {
		Name = "Salvaged AK74u";
		Image = {
			["Default"] = "rbxassetid://15073408197";
			["Beast"] = "rbxassetid://15305755800";
			["Splash"] = "rbxassetid://15509741616";
			["VIP"] = "rbxassetid://16014753591";
			["Comic"] = "rbxassetid://16114228051";
			["Clover"] = "rbxassetid://16748171046";
		};
		Description = [[Fully automatic AK74u that has been modified to shoot Light Ammo at a high fire rate.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 40;
		MaxDurability = 675;
		BaseMaxAmmo = 30;
		AmmoType = "Pistol";
		Attachments = {"Sight", "Muzzle", "Barrel"};
		ItemWorth = 450;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.15, -0.5523, 0.593, 0, 0.8661, -0.4999, 0, 0.5, 0.8661, 1, 0, 0);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[109] = {
		Name = "Salvaged Pipe Rifle";
		Image = {
			["Default"] = "rbxassetid://15073408081";
			["Surge"] = "rbxassetid://15509721163";
			["Gingerbread"] = "rbxassetid://15638252851";
			["Frost"] = "rbxassetid://16208668377";
		};
		Description = [[Barrel fed, single shot, bolt action rifle made from some pipes. Slow to shoot. Uses Light Ammo.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 20;
		MaxDurability = 75;
		BaseMaxAmmo = 1;
		AmmoType = "Pistol";
		Attachments = {"Barrel"};
		ItemWorth = 200;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.5807, -0.0974, 0.5802, -0.7071, -0.7071, 0, -0.7071, 0.7072, 0, 0, 0, -1);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[110] = {
		Name = "Petroleum";
		Image = "rbxassetid://14651118356";
		Description = [[Unrefined fuel. Can be refined into Crude Fuel.]];
		Type = "Resource";
		MaxStack = 500;
		DespawnTime = 5;
		SmeltInfo = {
			Amount = 2;
			Time = 6;
			LootTable = {"Smelt", "PetroleumRefinery", "Petroleum"}; -- 6 Crude Fuel
		};
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};
	[111] = {
		Name = "Boots";
		Image = {
			["Default"] = "rbxassetid://14654795457";
			["Black"] = "rbxassetid://15283152697";
			["Forest Camo"] = "rbxassetid://15283152517";
			["Abibas"] = "rbxassetid://15305690697";
			["Valentine"] = "rbxassetid://16293022275";
			["Woodland"] = "rbxassetid://16473066174";
			
		};
		Description = [[Sturdy pair of well made boots.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 10;
		ArmorType = "Boots";
		Resistances = {
			Heat = 0;
			Cold = 8;
			Explosive = 1;
			Radiation = 4;
			Animal = 3;
			Legs = {
				Bullet = 10;
				Melee = 10;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[112] = {
		Name = "Collared Shirt";
		Image = {
			["Default"] = "rbxassetid://14654793432";
			["Business"] = "rbxassetid://15444462393";
		};
		Description = [[A nice looking shirt. Provides some protection against the elements.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 7;
		ArmorType = "Shirt";
		Resistances = {
			Heat = 0;
			Cold = 8;
			Explosive = 1;
			Radiation = 5;
			Animal = 6;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 15;
				Melee = 15;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[113] = {
		Name = "Shorts";
		Image = {
			["Default"] = "rbxassetid://14654791921";
		};
		Description = [[A pair of shorts to keep you cool on a hot day.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 5;
		ArmorType = "Pants";
		Resistances = {
			Heat = 0;
			Cold = 7;
			Explosive = 1;
			Radiation = 2;
			Animal = 3;
			Legs = {
				Bullet = 5;
				Melee = 10;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[114] = {
		Name = "Tank Top";
		Image = {
			["Default"] = "rbxassetid://14654791246";
		};
		Description = [[Double the tank tops... gives you more defense. Don't ask any questions.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 5;
		ArmorType = "Shirt";
		Resistances = {
			Heat = 0;
			Cold = 7;
			Explosive = 1;
			Radiation = 2;
			Animal = 3;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 5;
				Melee = 10;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[115] = {
		Name = "Cloth Shirt";
		Image = {
			["Default"] = "rbxassetid://14654794835";
		};
		Description = [[An improvised shirt made from scraps of cloth, not very effective.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 4;
		ArmorType = "Shirt";
		Resistances = {
			Heat = 0;
			Cold = 7;
			Explosive = 1;
			Radiation = 2;
			Animal = 3;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 5;
				Melee = 10;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[116] = {
		Name = "Cloth Pants";
		Image = {
			["Default"] = "rbxassetid://14654794952";
		};
		Description = [[An improvised pair of pants made from scraps of cloth, not very effective.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 4;
		ArmorType = "Pants";
		Resistances = {
			Heat = 0;
			Cold = 7;
			Explosive = 1;
			Radiation = 2;
			Animal = 3;
			Legs = {
				Bullet = 5;
				Melee = 10;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[117] = {
		Name = "Cloth Footwraps";
		Image = {
			["Default"] = "rbxassetid://14654794730";
		};
		Description = [[An improvised pair of feet wraps made from scraps of cloth, not very effective.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 4;
		ArmorType = "Boots";
		Resistances = {
			Heat = 0;
			Cold = 3;
			Explosive = 0;
			Radiation = 2;
			Animal = 2;
			Legs = {
				Bullet = 5;
				Melee = 5;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[118] = {
		Name = "Leather Poncho";
		Image = {
			["Default"] = "rbxassetid://14654793821";
			["Viva"] = "rbxassetid://16208668209";
		};
		Description = [[A sturdy poncho made from scraps of leather. Provides moderate protection from the elements.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 1000;
		ArmorType = "Chestplate";
		Resistances = {
			Heat = 0;
			Cold = 8;
			Explosive = 5;
			Radiation = 8;
			Animal = 5;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 10;
				Melee = 30;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[119] = {
		Name = "Leather Pants";
		Image = {
			["Default"] = "rbxassetid://14654793993";
		};
		Description = [[A sturdy leather pants made from scraps of leather. Provides moderate protection from the elements.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 4;
		ArmorType = "Pants";
		Resistances = {
			Heat = 0;
			Cold = 4;
			Explosive = 1;
			Radiation = 2;
			Animal = 7;
			Legs = {
				Bullet = 10;
				Melee = 15;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[120] = {
		Name = "Leather Shirt";
		Image = {
			["Default"] = "rbxassetid://14654793568";
		};
		Description = [[A sturdy leather shirt made from scraps of leather. Provides moderate protection from the elements.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 4;
		ArmorType = "Shirt";
		Resistances = {
			Heat = 0;
			Cold = 5;
			Explosive = 1;
			Radiation = 3;
			Animal = 8;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 10;
				Melee = 15;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[121] = {
		Name = "Leather Boots";
		Image = {
			["Default"] = "rbxassetid://14654794176";
		};
		Description = [[A sturdy pair of leather boots made from scraps of leather. Provides moderate protection from the elements.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 4;
		ArmorType = "Boots";
		Resistances = {
			Heat = 0;
			Cold = 5;
			Explosive = 0;
			Radiation = 2;
			Animal = 4;
			Legs = {
				Bullet = 5;
				Melee = 5;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[122] = {
		Name = "Flannel Jacket";
		Image = {
			["Default"] = "rbxassetid://14654794281";
			["Snow White"] = "rbxassetid://15283151729";
			["Biker"] = "rbxassetid://15877516070";
		};
		Description = [[A durable flannel jacket that can go overtop of your shirt. Provides moderate protection, and good warmth.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 7;
		ArmorType = "Chestplate";
		Resistances = {
			Heat = 0;
			Cold = 10;
			Explosive = 0;
			Radiation = 5;
			Animal = 7;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 15;
				Melee = 15;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[123] = {
		Name = "Wooden Helmet";
		Image = {
			["Default"] = "rbxassetid://14776135648";
			["Crimson Bunny"] = "rbxassetid://16912320885";
		};
		Description = [[A primitive helmet made from scrap wood and cloth. Provides some protection to the head.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 1000;
		ArmorType = "Hat";
		HideHair = true;
		Resistances = {
			Heat = 0;
			Cold = 0;
			Explosive = 4;
			Radiation = 3;
			Animal = 5;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 15;
				Melee = 20;
			};
		};
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[124] = {
		Name = "Wooden Chestplate";
		Image = {
			["Default"] = "rbxassetid://14776135830";
			["Crimson Bunny"] = "rbxassetid://16912321117";
		};
		Description = [[A primitive protective chestplate made from scrap wood and rope. Provides some protection to the chest.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 900;
		ArmorType = "Chestplate";
		Resistances = {
			Heat = 0;
			Cold = 0;
			Explosive = 4;
			Radiation = 5;
			Animal = 5;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 10;
				Melee = 25;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[125] = {
		Name = "Wooden Leggings";
		Image = {
			["Default"] = "rbxassetid://14776135514";
			["Crimson Bunny"] = "rbxassetid://16912320687";
		};
		Description = [[A primitive protective pair of wooden leggings made from wood and rope. Provides some protection to the legs.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 750;
		ArmorType = "Kilt";
		Resistances = {
			Heat = 0;
			Cold = 0;
			Explosive = 4;
			Radiation = 5;
			Animal = 5;
			Legs = {
				Bullet = 10;
				Melee = 30;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = {
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[126] = {
		Name = "Wooden Arrow";
		Image = "rbxassetid://13981013657";
		Description = [[Standard wooden arrow.]];
		Type = "Ammo";
		MaxStack = 64;
		DespawnTime = 5;
		AmmoType = "Arrow";
		AmmoWheelImage = "rbxassetid://2535574992";
		AmmoStats = {
			TracerName = "WoodenArrow";
			Impact = "Stick";
			ShatterChance = 30;
		};
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[127] = {
		Name = "Swift Arrow";
		Image = "rbxassetid://13981013848";
		Description = [[Swift arrow. Travels faster and longer distances.]];
		Type = "Ammo";
		MaxStack = 64;
		DespawnTime = 5;
		AmmoType = "Arrow";
		AmmoWheelImage = "rbxassetid://2535574992";
		AmmoStats = {
			TracerName = "HVArrow";
			Impact = "Stick";
			ShatterChance = 30;
			SpeedMult = 1.25;
			RangeMult = 1.25;
		};
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[128] = {
		Name = "Bone Arrow";
		Image = "rbxassetid://13981013521";
		Description = [[Bone arrow. Easier to hit targets for the cost of damage and velocity.]];
		Type = "Ammo";
		MaxStack = 64;
		DespawnTime = 5;
		AmmoType = "Arrow";
		AmmoWheelImage = "rbxassetid://2535574992";
		AmmoStats = {
			TracerName = "BoneArrow";
			Impact = "Stick";
			ShatterChance = 30;
			SpeedMult = 0.9;
			DamageMult = 0.8;
			BleedMult = 1.3;
			BulletSize = 1.5;--Vector3.new(2, 2, 0);
		};
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[129] = {
		Name = "Combustive Arrow";
		Image = "rbxassetid://13981013386";
		Description = [[Combustive arrow. Explodes on impact.]];
		Type = "Ammo";
		MaxStack = 64;
		DespawnTime = 5;
		AmmoType = "Arrow";
		AmmoWheelImage = "rbxassetid://2535574992";
		AmmoStats = {
			TracerName = "FireArrow";
			Impact = "FireArrow";
			SpeedMult = 0.8;
			DamageMult = 0.8;
			Explosive = {
				Radius = 2;
				HumanoidMaxDamage = 20;
				DamagePrefix = "";
			};
		};
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[130] = {
		Name = "Iron Shard Hatchet";
		Image = {
			["Default"] = "rbxassetid://15073617640";
			["Fade"] = "rbxassetid://16663953399";
		};
		Description = [[A crude tool made from iron shards and scraps of wood. Used for gathering wood. ]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 450;
		ItemWorth = 90;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067);
		};
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};
	[131] = {
		Name = "Iron Shard Pickaxe";
		Image = {
			["Default"] = "rbxassetid://15073617491";
			["Fade"] = "rbxassetid://16663949312";
		};
		Description = [[A crude tool made from iron shards and scraps of wood. Used for mining.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 450;
		ItemWorth = 91;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067);
		};
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
		
	};
	[132] = {
		Name = "Large Furnace";
		Image = {
			["Default"] = "rbxassetid://15133678858";
		};
		Description = [[Industrial-grade Furnace designed to cook large amounts of Ores at once.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 15;
		MaxDurability = 250;
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};	
	[133] = {
		Name = "Yellow Keycard";
		Image = "rbxassetid://15247381343";
		Description = [[A Dazbog Corporation Support Personnel Yellow Keycard. Grants access to yellow restricted areas.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 4;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};	
	[134] = {
		Name = "Purple Keycard";
		Image = "rbxassetid://15247381544";
		Description = [[A Dazbog Corporation Support Personnel Purple Keycard. Grants access to purple restricted areas.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 15;
		MaxDurability = 3;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};	
	[135] = {
		Name = "Pink Keycard";
		Image = "rbxassetid://15247381747";
		Description = [[A Dazbog Corporation Support Personnel Pink Keycard. Grants access to pink restricted areas.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 25;
		MaxDurability = 3;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[136] = {
		Name = "Small Medkit";
		Image = "rbxassetid://15086741523";
		Description = [[A small medikt that grants 15 hp when used and regenerates 20 over time.]];
		Type = "Tool";
		MaxStack = 2;
		DespawnTime = 15;
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
		ConsumableStats = {
			Health = 15;
			HQueue = 20;
		};
	};
	[137] = {
		Name = "Salvaged Break Action";
		Image = {
			["Default"] = "rbxassetid://15305085935";
			["Splat"] = "rbxassetid://15305729191";
			["HotDog"] = "rbxassetid://15632163269";
			["Boom"] = "rbxassetid://16823202171";
			["Carrot"] = "rbxassetid://16917852163";
			["Easter Wood"] = "rbxassetid://16917852163";
		};
		Description = [[Salvaged Break Action Shotgun. Fires one shell before needing to reload.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 15;
		MaxDurability = 55;
		BaseMaxAmmo = 1;
		AmmoType = "Shell";
		Attachments = {"Barrel"};
		ItemWorth = 100;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(-0.1524, -0.3038, 0.5539, 0.2589, -0.9659, 0, 0.966, 0.2589, 0, 0, 0, 1);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[138] = {
		Name = "Buckshot";
		Image = "rbxassetid://13186566301";
		Description = [[12 Gauge Buckshot, lots of power up close, not very useful at range.]];
		Type = "Ammo";
		MaxStack = 64;
		DespawnTime = 15;
		AmmoType = "Shell";
		AmmoWheelImage = "rbxassetid://15635720278";
		AmmoStats = {
			TracerName = "ShotgunBullet";
			Bullets = 8;
			DamageMult = 0.25;
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[139] = {
		Name = "Slug";
		Image = "rbxassetid://13186564525";
		Description = [[12 Gauge Shotgun Slug, provides extra range to shotguns, without the pellet spread.]];
		Type = "Ammo";
		MaxStack = 32;
		DespawnTime = 15;
		AmmoType = "Shell";
		AmmoWheelImage = "rbxassetid://15635720278";
		AmmoStats = {
			TracerName = "RifleBullet";
			HipSpreadMult = 0.6;
			AimSpreadMult = 0.1;
			SpeedMult = 1.5;
			RangeMult = 2.5;
			GravityMult = 0.9;
			HeadshotDamageMult = 1/6; -- ~0.167% (HS from 1.5x to 1.75x) (1.75 / 1.5 == ~1.167)
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[140] = {
		Name = "Combustive Buckshot";
		Image = "rbxassetid://13186565241";
		Description = [[12 Gauge combustive Buckshot, shoots out incendiary pellets with a chance to leave a flame.]];
		Type = "Ammo";
		MaxStack = 64;
		DespawnTime = 8;
		AmmoType = "Shell";
		AmmoWheelImage = "rbxassetid://2535574992";
		AmmoStats = {
			TracerName = "CombustiveBullet";
			Bullets = 8;
			DamageMult = 0.35;
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[141] = {
		Name = "Steel Helmet";
		Image = {
			["Default"] = "rbxassetid://14654791532";
			["Golden"] = "rbxassetid://15305714913";
			["Frosty"] = "rbxassetid://15305683226";
			["OBEY"] = "rbxassetid://15305695029";
			["VIP"] = "rbxassetid://16014684244";
			["Cardboard"] = "rbxassetid://15627624994";
			["OH Deer"] = "rbxassetid://15630406001";
			["Woodland"] = "rbxassetid://16447574211";
		};
		Description = [[A protective helmet made from Steel metal. Provides excellent protection to the head.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 40;
		MaxDurability = 2000;
		ArmorType = "Helmet";
		HideHair = true;
		Resistances = {
			Heat = -1;
			Cold = -4;
			Explosive = 8;
			Radiation = 0;
			Animal = 8;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 55;
				Melee = 30;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[142] = {
		Name = "Steel Chestplate";
		Image = {
			["Default"] = "rbxassetid://14654791689";
			["Frosty"] = "rbxassetid://15305683641";
			["OBEY"] = "rbxassetid://15305695517";
			["OH Deer"] = "rbxassetid://15630407338";
			["Woodland"] = "rbxassetid://16447572145";
		};
		Description = [[A protective chestplate made from Steel metal. Provides excellent protection to the chest.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 40;
		MaxDurability = 1800;
		ArmorType = "Chestplate";
		Resistances = {
			Heat = -2;
			Cold = -8;
			Explosive = 6;
			Radiation = 0;
			Animal = 5;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 30;
				Melee = 15;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[143] = {
		Name = "Steel Leggings";
		Image = {
			["Default"] = "rbxassetid://14654791387";
			["Frosty"] = "rbxassetid://15305684250";
			["OBEY"] = "rbxassetid://15311675719";
			["OH Deer"] = "rbxassetid://15630408363";
			["Woodland"] = "rbxassetid://16447575529";
		};
		Description = [[A protective pair of leggings made from Steel metal. Provides excellent protection to the legs.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 40;
		MaxDurability = 1600;
		ArmorType = "Kilt";
		Resistances = {
			Heat = -1;
			Cold = -4;
			Explosive = 5;
			Radiation = 0;
			Animal = 5;
			Legs = {
				Bullet = 25;
				Melee = 20;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[144] = {
		Name = "Large Storage Box";
		Image = { 
			["Default"] = "rbxassetid://15094083403";
			["Canvas"] = "rbxassetid://15283200485";
			["Festive"] = "rbxassetid://15709683124";
			["Industrial Guns"] = "rbxassetid://15305708083";
			["Industrial Resources"] = "rbxassetid://15305708823";
			["Industrial Medical"] = "rbxassetid://15305709566";
			["Industrial Components"] = "rbxassetid://15305710817";
			["Industrial Armor"] = "rbxassetid://15305711681";
			["Egg Sketch"] = "rbxassetid://16916931642";
			
		};
		Description = [[Wooden container that can hold up to 30 items inside.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 60;
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[145] = {
		Name = "Salvaged Helmet";
		Image = {
			["Default"] = "rbxassetid://14654792150";
			["Digital Snow"] = "rbxassetid://15283152199";
			["Kill to Survive"] = "rbxassetid://15792001031";
			["Cupid"] = "rbxassetid://16261611838";
		};
		Description = [[A protective helmet made from sheet metal. Provides moderate protection to the head.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 12;
		MaxDurability = 1500;
		ArmorType = "Helmet";
		HideHair = true;
		Resistances = {
			Heat = -2;
			Cold = -5;
			Explosive = 5;
			Radiation = 5;
			Animal = 8;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 35;
				Melee = 40;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[146] = {
		Name = "Salvaged Chestplate";
		Image = {
			["Default"] = "rbxassetid://14654792418";
			["Digital Snow"] = "rbxassetid://15283152111";
			["Cupid"] = "rbxassetid://16261611092";
		};
		Description = [[A protective chestplate made from sheet metal. Provides moderate protection to the chest.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 12;
		MaxDurability = 1350;
		ArmorType = "Chestplate";
		Resistances = {
			Heat = -2;
			Cold = -6;
			Explosive = 6;
			Radiation = 0;
			Animal = 10;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 20;
				Melee = 15;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[147] = {
		Name = "Salvaged Leggings";
		Image = {
			["Default"] = "rbxassetid://14654792046";
			["Digital Snow"] = "rbxassetid://15283153195";
			["Cupid"] = "rbxassetid://16261614321";
		};
		Description = [[A protective pair of leggings made from sheet metal. Provides moderate protection to the legs.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 12;
		MaxDurability = 1200;
		ArmorType = "Kilt";
		Resistances = {
			Heat = -2;
			Cold = -6;
			Explosive = 4;
			Radiation = 0;
			Animal = 10;
			Legs = {
				Bullet = 15;
				Melee = 20;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[148] = {
		Name = "Military Helmet";
		Image = {
			["Default"] = "rbxassetid://14654793165";
		};
		Description = [[A protective helmet from one of the guards on the island. Provides good protection to the head.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 30;
		MaxDurability = 1800;
		ArmorType = "Helmet";
		HideHair = true;
		Resistances = {
			Heat = -1;
			Cold = -4;
			Explosive = 7;
			Radiation = 0;
			Animal = 7;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 45;
				Melee = 35;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[149] = {
		Name = "Military Chestplate";
		Image = {
			["Default"] = "rbxassetid://14654793303";
		};
		Description = [[A protective chesplate from one of the guards on the island. Provides good protection to the chest.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 12;
		MaxDurability = 1700;
		ArmorType = "Chestplate";
		Resistances = {
			Heat = -1;
			Cold = -6;
			Explosive = 4;
			Radiation = 0;
			Animal = 4;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 25;
				Melee = 15;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[150] = {
		Name = "Military Leggings";
		Image = {
			["Default"] = "rbxassetid://14654792938";
		};
		Description = [[A protective pair of leggings from one of the guards on the island. Provides good protection to the legs.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 12;
		MaxDurability = 1500;
		ArmorType = "Kilt";
		Resistances = {
			Heat = -1;
			Cold = -5;
			Explosive = 4;
			Radiation = 0;
			Animal = 4;
			Legs = {
				Bullet = 20;
				Melee = 20;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[151] = {
		Name = "Hard Hat";
		Image = {
			["Default"] = "rbxassetid://14654794545";
			["Slurpee"] = "rbxassetid://15950562586";
		};
		Description = [[A simple hard hat to protect your head.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 8;
		MaxDurability = 1250;
		ArmorType = "Hat";
		Resistances = {
			Heat = 0;
			Cold = 3;
			Explosive = 7;
			Radiation = 4;
			Animal = 7;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 20;
				Melee = 30;
			};
		};
		HideHair = true;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[152] = {
		Name = "Balaclava";
		Image = {
			["Default"] = "rbxassetid://14654791788";
			["Jester"] = "rbxassetid://15344534842";
			["Frankenstein"] = "rbxassetid://15883389666";
			["Crimson Bunny"] = "rbxassetid://16912319678";
		};
		Description = [[A handmade balaclava. Keeps you warm and provides some protection.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 5;
		ArmorType = "Face";
		Resistances = {
			Heat = 0;
			Cold = 11;
			Explosive = 3;
			Radiation = 3;
			Animal = 3;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 10;
				Melee = 15;
			};
		};
		HideHair = true;
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[153] = {
		Name = "Cloth Headwrap";
		Image = {
			["Default"] = "rbxassetid://14654795058";
		};
		Description = [[A headwrap made from cloth. Keeps you warm and provides a little bit of protection.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 5;
		ArmorType = "Helmet";
		HideHair = true;
		Resistances = {
			Heat = 0;
			Cold = 7;
			Explosive = 1;
			Radiation = 2;
			Animal = 3;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 10;
				Melee = 15;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[154] = {
		Name = "Baseball Cap";
		Image = {
			["Default"] = "rbxassetid://14654795325";
			["Quack"] = "rbxassetid://16208669800";
		};
		Description = [[A baseball cap. Baseball players wear these, not people fighting for their lives.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 5;
		ArmorType = "Hat";
		HideHair = true;
		Resistances = {
			Heat = 0;
			Cold = 5;
			Explosive = 1;
			Radiation = 1;
			Animal = 3;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 5;
				Melee = 10;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[155] = {
		Name = "Salvaged Gloves";
		Image = {
			["Default"] = "rbxassetid://14654792260";
			["Digital Snow"] = "rbxassetid://15283152030";
			["Cupid"] = "rbxassetid://16261613114";
		};
		Description = [[A pair of sheet metal gloves. Provides moderate proection.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 10;
		ArmorType = "Gloves";
		MaxDurability = 1200;
		Resistances = {
			Heat = 0;
			Cold = -5;
			Explosive = 3;
			Radiation = 4;
			Animal = 10;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 10;
				Melee = 15;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[156] = {
		Name = "Cloth Handwraps";
		Image = {
			["Default"] = "rbxassetid://14654831164";
		};
		Description = [[A pair of cloth handwraps. Provides a bit of warmth, not much else.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 3;
		ArmorType = "Gloves";
		Resistances = {
			Heat = 0;
			Cold = 4;
			Explosive = 0;
			Radiation = 3;
			Animal = 2;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 5;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[157] = {
		Name = "Military Gloves";
		Image = {
			["Default"] = "rbxassetid://14654794652";
		};
		Description = [[A pair of sturdy military gloves. Provides excellent protection.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 15;
		ArmorType = "Gloves";
		Resistances = {
			Heat = 0;
			Cold = 7;
			Explosive = 2;
			Radiation = 6;
			Animal = 4;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 10;
				Melee = 10;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[158] = {
		Name = "Leather Gloves";
		Image = {
			["Default"] = "rbxassetid://14654794097";
		};
		Description = [[A pair of leather gloves. Provides a bit of warmth, and a small amount of protection.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 8;
		ArmorType = "Gloves";
		Resistances = {
			Heat = 0;
			Cold = 5;
			Explosive = 2;
			Radiation = 4;
			Animal = 3;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 5;
				Melee = 5;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[159] = {
		Name = "Wetsuit";
		Image = "rbxassetid://15304093679";
		Description = [[A wetsuit. Keeps water trapped against your body to provide heat.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 10;
		ArmorType = "Wetsuit";
		Attribute = "ResistWet";
		Resistances = {
			Heat = 0;
			Cold = 10;
			Explosive = 1;
			Radiation = 20;
			Animal = 2;
			Legs = {
				Bullet = 10;
				Melee = 10;
			};
			Chest = { 
				Bullet = 10;
				Melee = 10;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[160] = {
		Name = "Flippers";
		Image = "rbxassetid://13843003596";
		Description = [[A pair of flippers. Hard to walk with these on, but lets you swim alot faster.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 10;
		ArmorType = "Boots";
		Attribute = "HasFlippers";
		Resistances = {
			Heat = 0;
			Cold = 0;
			Explosive = 0;
			Radiation = 0;
			Animal = 0;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[161] = {
		Name = "Diving Tank";
		Image = "rbxassetid://13843003364";
		Description = [[A diving tank. Used for breathing underwater.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 10;
		ArmorType = "Chestplate";
		MaxDurability = 800;
		Attribute = "HasTank";
		Resistances = {
			Heat = 0;
			Cold = 0;
			Explosive = 0;
			Radiation = 0;
			Animal = 0;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[162] = {
		Name = "Diving Goggles";
		Image = "rbxassetid://13842989638";
		Description = [[A pair of diving goggles. Used to see better underwater.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 10;
		ArmorType = "Helmet";
		Attribute = "HasGoggles";
		Resistances = {
			Heat = 0;
			Cold = 0;
			Explosive = 0;
			Radiation = 0;
			Animal = 0;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
	};
	[163] = {
		Name = "Cooking Pot";
		Image = {
			["Default"] = "rbxassetid://15127562373";
		};
		Description = [[An upgraded Campfire that allows for more efficient food cooking.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 20;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[164] = {
		Name = "Ladder";
		Image = {
			["Default"] = "rbxassetid://15127607098";
		};
		Description = [[Can be placed to climb over structures.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 20;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[165] = {
		Name = "Chocolate Bar";
		Image = "rbxassetid://14162884792";
		Description = [[A nicely wrapped chocolate bar.]];
		Type = "Consumable";
		MaxStack = 10;
		DespawnTime = 5;
		ConsumableStats = {
			Health = 2;
			HQueue = 0;
			Hunger = 15;
			Thirst = -1;
		};
		Sounds = {
			Drag = "GrassPickup";
			Drop = "GrassDrop";
		};
	};
	[166] = {
		Name = "Bean Can";
		Image = "rbxassetid://14162885124";
		Description = [[An unopened can of beans ready to be eaten. Provides a moderate amount of nutrition.]];
		Type = "Consumable";
		MaxStack = 10;
		DespawnTime = 5;
		ConsumableStats = {
			Health = 0;
			HQueue = 0;
			Hunger = 15;
			Thirst = 3;
			Returns = {"ItemDrops", "Empty Can"};
		};
		Sounds = {
			Drag = "CannedPickup";
			Drop = "CannedDrop";
		};
	};
	[167] = {
		Name = "Meatball Can";
		Image = "rbxassetid://14162884362";
		Description = [[A large unopened can of meatballs ready to be eaten. Provides a great amount of nutrition.]];
		Type = "Consumable";
		MaxStack = 10;
		DespawnTime = 5;
		ConsumableStats = {
			Health = 0;
			HQueue = 5;
			Hunger = 20;
			Thirst = 2;
			Returns = {"ItemDrops", "Empty Can"};
		};
		Sounds = {
			Drag = "CannedPickup";
			Drop = "CannedDrop";
		};
	};
	[168] = {
		Name = "Fish Can";
		Image = "rbxassetid://14162884523";
		Description = [[An unopened can of meatballs ready to be eaten. Provides a moderate amount of nutrition.]];
		Type = "Consumable";
		MaxStack = 10;
		DespawnTime = 5;
		ConsumableStats = {
			Health = 2;
			HQueue = 0;
			Hunger = 10;
			Thirst = 6;
			Returns = {"ItemDrops", "Empty Can"};
		};
		Sounds = {
			Drag = "CannedPickup";
			Drop = "CannedDrop";
		};
	};
	[169] = {
		Name = "Water Bottle";
		Image = "rbxassetid://14162884193";
		Description = [[Hopefully nobody drank from this.]];
		Type = "Consumable";
		MaxStack = 5;
		DespawnTime = 5;
		ConsumableStats = {
			Health = 0;
			HQueue = 0;
			Hunger = 0;
			Radiation = -30;
			Thirst = 36;
		};
		Sounds = {
			Drag = "LiquidPickup";
			Drop = "LiquidDrop";
		};
	};
	[170] = {
		Name = "Piercing Heavy Ammo";
		Image = "rbxassetid://13186565419";
		Description = [[Pierces through armor for the cost of less bleed and range. Can ignite when hitting hard surfaces.]];
		Type = "Ammo";
		MaxStack = 128;
		DespawnTime = 30;
		AmmoType = "Rifle";
		AmmoWheelImage = "rbxassetid://2535574992";
		AmmoStats = {
			TracerName = "RifleBullet";
			Impact = "Pierce";
			RangeMult = 0.7;
			ArmorPenMult = 0.75;
			BleedMult = 0.5;
			MuzzleDurability = 2;
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[171] = {
		Name = "Piercing Light Ammo";
		Image = "rbxassetid://13186588755";
		Description = [[Pierces through armor for the cost of less bleed and range. Can ignite when hitting hard surfaces.]];
		Type = "Ammo";
		MaxStack = 128;
		DespawnTime = 25;
		AmmoType = "Pistol";
		AmmoWheelImage = "rbxassetid://15635709508";
		AmmoStats = {
			TracerName = "RifleBullet";
			Impact = "Pierce";
			RangeMult = 0.7;
			ArmorPenMult = 0.75;
			BleedMult = 0.5;
			MuzzleDurability = 2;
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[172] = {
		Name = "Semi Receiver";
		Image = "rbxassetid://14651116315";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 10;
		DespawnTime = 15;
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[173] = {
		Name = "SMG Receiver";
		Image = "rbxassetid://14651115848";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 10;
		DespawnTime = 25;
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};	
	[174] = {
		Name = "Rifle Receiver";
		Image = "rbxassetid://14651117496";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 10;
		DespawnTime = 30;
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};	
	[175] = {
		Name = "Steel Shovel";
		Image = "rbxassetid://15074351964";
		Description = [[Melee tool. Can dig up trash piles faster than doing it by hand.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 600;
		ItemWorth = 90;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067);
		};
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};
	[176] = {
		Name = "Empty Can";
		Image = "rbxassetid://14594762895";
		Description = [[An empty can. Can be smelted in a Campfire or Cooking Pot for Iron Shards.]];
		Type = "Misc";
		MaxStack = 5;
		DespawnTime = 3;
		Sounds = {
			Drag = "CannedPickup";
			Drop = "CannedDrop";
		};
		SmeltInfo = {
			Amount = 1;
			Time = 15;
			LootTable = {"Smelt", "Campfire", "Empty Can"}; -- 10-15 Iron Shards
		};
	};
	[177] = {
		Name = "Care Package Signal";
		Image = "rbxassetid://15128007999";
		Description = [[Throwable grenade that signals a Care Package to be dropped at its location when thrown.]];
		Type = "Tool";
		MaxStack = 5;
		DespawnTime = 15;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[178] = {
		Name = "Duct Tape";
		Image = "rbxassetid://14651118525";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 20;
		DespawnTime = 10;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[179] = {
		Name = "Glue";
		Image = "rbxassetid://14651236358";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 50;
		DespawnTime = 5;
		Sounds = {
			Drag = "LiquidPickup";
			Drop = "LiquidDrop";
		};
	};
	[180] = {
		Name = "Pistol Receiver";
		Image = "rbxassetid://14651117642";
		Description = [[A crafting component found in the world. Crafting material.]];
		Type = "Misc";
		MaxStack = 10;
		DespawnTime = 8;
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[181] = {
		Name = "Salvaged Shovel";
		Image = "rbxassetid://15074352064";
		Description = [[Melee tool. Can dig up trash piles faster than doing it by hand.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 15;
		MaxDurability = 200;
		ItemWorth = 90;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067);
		};
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};
	[182] = {
		Name = "ez shovel";
		Image = "rbxassetid://13877485530";
		Description = [[EZ]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 1;
		Sounds = {
			Drag = "MetalToolPickup";
			Drop = "MetalToolDrop";
		};
	};
	[183] = {
		Name = "Anvil";
		Image = "rbxassetid://15082009292";
		Description = [[Workbench specialized for crafting tools, guns, and weapons.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 100;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[184] = {
		Name = "Chemistry Lab";
		Image = "rbxassetid://15074207343";
		Description = [[Industrial workbench specialized for crafting explosives and raiding equipment.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 20;
		MaxDurability = 200;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[185] = {
		Name = "Carpentry Table";
		Image = "rbxassetid://15082010398";
		Description = [[Workbench specialized for crafting other benches and base-building commodities.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 100;
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[186] = {
		Name = "Sewing Table";
		Image = "rbxassetid://15061609510";
		Description = [[Workbench specialized for crafting clothes and armor.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 50;
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[187] = {
		Name = "Ammo Press";
		Image = "rbxassetid://15061609857";
		Description = [[Workbench specialized for crafting Gunpowder and ammunition.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 150;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[188] = {
		Name = "Culinary Table";
		Image = "rbxassetid://15061609707";
		Description = [[Workbench specialized for crafting medical stuff and food.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 250;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[189] = {
		Name = "Petroleum Refinery";
		Image = {
			["Default"] = "rbxassetid://15304104065";
		};
		Description = [[Industrial-grade refinery used to convert Petroleum into Crude Fuel.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 20;
		MaxDurability = 250;
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[190] = {
		Name = "Triangle Trap Door";
		Image = {
			["Default"] = "rbxassetid://13724822281";
		};
		Description = [[Open or close a hatch for easy access to upwards areas. Immune to fire attacks.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 150;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[191] = {
		Name = "Military AA12";
		Image = {
			["Default"] = "rbxassetid://15068791139";
			["Red Tiger"] = "rbxassetid://16485447561";
		};
		Description = [[Automatic firing shotgun with decent magazine capacity. Deadly at close ranges.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 30;
		MaxDurability = 150;
		BaseMaxAmmo = 10;
		AmmoType = "Shell";
		Attachments = {"Barrel"};
		ItemWorth = 525;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(-0.1524, -0.3038, 0.5539, 0.2589, -0.9659, 0, 0.966, 0.2589, 0, 0, 0, 1);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[192] = {
		Name = "Repair Table";
		Image = { 
			["Default"] = "rbxassetid://15283452092";
		};
		Description = [[A Table that allows for repairing and re-skinning of items.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 100;
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[193] = {
		Name = "Salvaged Pump Action";
		Image = {
			["Default"] = "rbxassetid://15092313032";
			["Gold Ripple"] = "rbxassetid://15444464740";
			["Red Tiger"] = "rbxassetid://15792000933";
			["Joe Skeleton"] = "rbxassetid://16828401186";
		};
		Description = [[Pump action, tube fed, shotgun made from some pipes. Slow to shoot.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 20;
		MaxDurability = 100;
		BaseMaxAmmo = 5;
		AmmoType = "Shell";
		Attachments = {"Barrel", "Sight"};
		ItemWorth = 205;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.5807, -0.0974, 0.5802, -0.7071, -0.7071, 0, -0.7071, 0.7072, 0, 0, 0, -1);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[194] = {
		Name = "Bed";
		Image = {
			["Default"] = "rbxassetid://15368539842";
		};
		Description = [[Beds are used as a respawn point on the map that are faster than sleeping bags. Beds placed too close to one another will share the same cooldown.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 100;
		Sounds = {
			Drag = "ClothPickup";
			Drop = "ClothDrop";
		};
	};
	[195] = {
		Name = "Wooden Spikes";
		Image = "rbxassetid://15380989444";
		Description = [[Wooden Spikes that can be placed outside or on your base to further prevent intruders.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 60;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[196] = {
		Name = "Military ACOG Sight";
		Image = "rbxassetid://15373701079";
		Description = [[Military-grade Advanced Combat Optical Gunsight. Provides 2x zoom augmentation.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 40;
		AttachmentType = "Sight";
		AttachmentStats = {
			ZoomLevel = 2.05;
			AimSpreadMult = -0.2;
			GunRecoilAimMult = -0.4;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[197] = {
		Name = "Metal Barricade";
		Image = "rbxassetid://15380991275";
		Description = [[A metal barricade that can protect you from bullets. Placed down on terrain or on your base.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 65;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[198] = {
		Name = "Military M4A1";
		Image = {
			["Default"] = "rbxassetid://15346201415";
			["Cherry Blossom"] = "rbxassetid://15509842541";
			["Syntax"] = "rbxassetid://15951831122";
			["Monster"] = "rbxassetid://16663261126";
		};
		Description = [[Good damage, fast firerate, and average range. Uses Heavy Ammo.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 45;
		MaxDurability = 675;
		BaseMaxAmmo = 30;
		AmmoType = "Rifle";
		Attachments = {"Sight", "Muzzle", "Barrel"};
		ItemWorth = 530;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.2142, -0.066, 0.6367, 0.6097, -0.7926, 0, 0.7927, 0.6097, 0, 0, 0, 1);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[199] = {
		Name = "Small Wooden Sign";
		Image = "rbxassetid://15509119765";
		Description = [[A small wooden sign which you can write some text on, or put an image using the Image Frames Gamepass.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 5;
		MaxDurability = 10;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[200] = {
		Name = "Large Wooden Sign";
		Image = "rbxassetid://15509119053";
		Description = [[A large wooden sign which you can write a lot of text on, or put an image using the Image Frames Gamepass.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 5;
		MaxDurability = 30;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
		
	};
	[201] = {
		Name = "Storage Cabinet";
		Image = {
			["Default"] = "rbxassetid://15572100650";
			["Monster"] = "rbxassetid://15631715604";
			["Hades"] = "rbxassetid://16293483340";
		};
		Description = [[Wooden Cabinet that can hold up to 48 items inside.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 90;
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[202] = {
		Name = "External Stone Gate";
		Image = "rbxassetid://14134361372";
		Description = [[Barbed stone gate that can be placed outside your base to further prevent intruders.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 500;
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[203] = {
		Name = "Bone Tool";
		Image = {
			["Default"] = "rbxassetid://15510368323";
		};
		Description = [[All in one primitive tool.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 200;
		ItemWorth = 19;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067);
		};
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[204] = {
		Name = "Salvaged Skorpion";
		Image = {
			["Default"] = "rbxassetid://15369212859";
			["Gingerbread"] = "rbxassetid://15637191692";
			["Superior"] = "rbxassetid://15950161435";
			["Pegasus"] = "rbxassetid://16577230942";
		};
		Description = [[Fully automatic, fast firing with a lot of spread and medium damage. Small magazine size though. Uses Light Ammo.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 25;
		MaxDurability = 300;
		BaseMaxAmmo = 15;
		AmmoType = "Pistol";
		Attachments = {"Sight", "Muzzle"};
		ItemWorth = 150;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(1.0317, -0.2614, -0.034, 0, 0, 1, -0.9848, 0.1737, 0, -0.1736, -0.9848, 0);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[205] = {
		Name = "Candy Cane";
		Image = {
			["Default"] = "rbxassetid://15633196493";
		};
		Description = [[Tool for hitting gifts.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 175;
		ItemWorth = 18;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067);
		};
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[206] = {
		Name = "Christmas Tree";
		Image = {
			["Default"] = "rbxassetid://15634564093";
		};
		Description = [[Good old christmas tree.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 90;
		Sounds = {
			Drag = "WoodPickup";
			Drop = "WoodDrop";
		};
	};
	[207] = {
		Name = "Santa Hat";
		Image = {
			["Default"] = "rbxassetid://15636087096";
		};
		Description = [[A little present from santa.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 2;
		ArmorType = "Hat";
		HideHair = true;
		Resistances = {
			Heat = 0;
			Cold = 2;
			Explosive = 1;
			Radiation = 1;
			Animal = 1;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 5;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};
		
	};
	[208] = {
		Name = "External Stone Wall";
		Image = "rbxassetid://15709318091";
		Description = [[Barbed stone wall that can be placed outside your base to further prevent intruders.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 500;
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[209] = {
		Name = "Blast Furnace";
		Image = {
			["Default"] = "rbxassetid://15876671239";
		};
		Description = [[Industrial-grade Furnace designed to smelt fast and large amounts of Ores at once.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 15;
		MaxDurability = 150;
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};	
	[210] = {
		Name = "Military Barrett";
		Image = {
			["Default"] = "rbxassetid://15346280030";
			["Surge"] = "rbxassetid://15876918136";
			["Leprechaun"] = "rbxassetid://16751857511";
		};
		Description = [[Heavy but slow shooting rifle. Very powerful at long distances.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 20;
		MaxDurability = 75;
		BaseMaxAmmo = 5;
		AmmoType = "Rifle";
		Attachments = {"Sight", "Muzzle", "Barrel"};
		ItemWorth = 800;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(1.2965, 0.6657, 0.6881, 0, -0.8742, -0.4854, 0, 0.4855, -0.8742, 1, 0, 0);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[211] = {
		Name = "Shotgun Turret";
		Image = "rbxassetid://16009975774";
		Description = [[Primitive shotgun turret that fires Shotgun ammo at unauthorized players. Only works under a Base Cabinet. Can only face a single direction.]];
		Type = "Bench";
		MaxStack = 1;
		DespawnTime = 15;
		MaxDurability = 60;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[212] = {
		Name = "Military Grenade";
		Image = "rbxassetid://15444535479";
		Description = [[A good explosive for damaging other players. Not effective at destroying structures.]];
		Type = "Tool";
		MaxStack = 5;
		DespawnTime = 15;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[213] = {
		Name = "Floor Grill";
		Image = "rbxassetid://15853202987";
		Description = [[Placed in floor frames. Useful for keeping intruders out of furnace bases.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 150;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[214] = {
		Name = "Bear Trap";
		Image = "rbxassetid://16283811174";
		Description = [[Manually-armed trap that deals lots of damage when stepped on.]];
		Type = "Bench";
		MaxStack = 5;
		DespawnTime = 10;
		MaxDurability = 15;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[215] = {
		Name = "Landmine Trap";
		Image = "rbxassetid://16283811057";
		Description = [[Touch-triggered explosive trap. Explodes when steppd off of. Can be picked up when stood on.]];
		Type = "Bench";
		MaxStack = 5;
		DespawnTime = 10;
		MaxDurability = 5;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[216] = {
		Name = "Saw Bat";
		Image = "rbxassetid://16249771997";
		Description = [[A baseball bat with a saw blade bolted to it. Great melee weapon.]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 15;
		MaxDurability = 600;
		ItemWorth = 95;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.1204, -0.0661, 0.6012, 0, -0.8286, -0.5597, 0, 0.5598, -0.8286, 1, 0, 0);
		};
		Sounds = {
			Drag = "WoodLogPickup";
			Drop = "WoodLogDrop";
		};
	};
	[217] = {
		Name = "Machete";
		Image = {
			["Default"] = "rbxassetid://16249771824";
			["Rainbow"] = "rbxassetid://16823202004";
			["Crimson"] = "rbxassetid://16912320468";
		};
		Description = [[A salvaged machete made from scrap iron. Mid-tier melee weapon]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 10;
		MaxDurability = 400;
		ItemWorth = 31;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(-1.0091, -0.0037, 0.1799, 1, 0, 0, 0, -0.9317, 0.3631, 0, -0.363, -0.9317);
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[218] = {
		Name = "Military PKM";
		Image = {
			["Default"] = "rbxassetid://16471125314";
			["Woodland"] = "rbxassetid://16471122135";
			["Digital Red"] = "rbxassetid://16828755578";
		};
		Description = [[Heavy slow shooting LMG. Good damage and average range. Uses Heavy Ammo]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 20;
		MaxDurability = 900;
		BaseMaxAmmo = 75;
		AmmoType = "Rifle";
		Attachments = {"Sight", "Muzzle", "Barrel"};
		ItemWorth = 800;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.0871, -0.4001, 0.8196, -0.5578, -0.8299, 0, -0.8299, 0.5579, 0, 0, 0, -1);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[219] = {
		Name = "Bruno's ACOG Sight";
		Image = "rbxassetid://16671196298";
		Description = [[Military-grade Advanced Combat Optical Gunsight. Provides 2x zoom augmentation. Used by Bruno.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 40;
		AttachmentType = "Sight";
		AttachmentStats = {
			ZoomLevel = 2.05;
			AimSpreadMult = -0.2;
			GunRecoilAimMult = -0.4;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[220] = {
		Name = "Military Lasersight";
		Image = "rbxassetid://15510372535";
		Description = [[Barrel attachment. Greatly lowers spread and aim sway when toggled.]];
		Type = "Attachment";
		MaxStack = 1;
		DespawnTime = 40;
		AttachmentType = "Barrel";
		AttachmentStats = {
			Toggle = true;
			HipSpreadMult = -0.4;
			AimSpreadMult = -0.2;
			SwayMult = -0.97;
		};
		Sounds = {
			Drag = "HQMPickup";
			Drop = "HQMDrop";
		};
	};
	[221] = {
		Name = "Bruno's M4A1";
		Image = {
			["Default"] = "rbxassetid://15574295393";
		};
		Description = [[Good damage, fast firerate, and average range. Uses Heavy Ammo. Has been modified with some attachments giving better stats.]];
		Type = "Gun";
		MaxStack = 1;
		DespawnTime = 45;
		MaxDurability = 675;
		BaseMaxAmmo = 30;
		AmmoType = "Rifle";
		Attachments = {"Sight", "Barrel"};
		ItemWorth = 600;
		WeldInfo = {
			Part = "UpperTorso";
			Offset = CFrame.new(0.2142, -0.066, 0.6367, 0.6097, -0.7926, 0, 0.7927, 0.6097, 0, 0, 0, 1);
		};
		Sounds = {
			Drag = "GunPickup";
			Drop = "GunDrop";
		};
	};
	[222] = {
		Name = "Bruno's Chestplate";
		Image = {
			["Default"] = "rbxassetid://16652581317";
		};
		Description = [[A protective chestplate from one of the guards on the island named Bruno. Provides excellent protection to the chest.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 40;
		MaxDurability = 1800;
		ArmorType = "Chestplate";
		Resistances = {
			Heat = -2;
			Cold = -8;
			Explosive = 7;
			Radiation = 0;
			Animal = 5;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 35;
				Melee = 20;
			};
			Head = { 
				Bullet = 0;
				Melee = 0;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[223] = {
		Name = "Bruno's Helmet";
		Image = {
			["Default"] = "rbxassetid://16652579167";
		};
		Description = [[A protective helmet from one of the guards on the island named Bruno. Provides excellent protection to the head.]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 40;
		MaxDurability = 2000;
		ArmorType = "Helmet";
		HideHair = true;
		Resistances = {
			Heat = -1;
			Cold = -4;
			Explosive = 9;
			Radiation = 0;
			Animal = 8;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 60;
				Melee = 35;
			};
		};
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
	[224] = {
		Name = "Bunny Ears";
		Image = {
			["Default"] = "rbxassetid://16916795577";
		};
		Description = [[A little hat from the Easter Bunny!]];
		Type = "Armor";
		MaxStack = 1;
		DespawnTime = 2;
		ArmorType = "Hat";
		HideHair = false;
		Resistances = {
			Heat = 0;
			Cold = 2;
			Explosive = 1;
			Radiation = 1;
			Animal = 1;
			Legs = {
				Bullet = 0;
				Melee = 0;
			};
			Chest = { 
				Bullet = 0;
				Melee = 0;
			};
			Head = { 
				Bullet = 0;
				Melee = 5;
			};
		};
		Sounds = {
			Drag = "ClothingPickup";
			Drop = "ClothingDrop";
		};

	};
	[225] = {
		Name = "Carrot Blade";
		Image = {
			["Default"] = "rbxassetid://16916703095";
		};
		Description = [[A sharpened carrot. Used as a melee weapon]];
		Type = "Tool";
		MaxStack = 1;
		DespawnTime = 5;
		MaxDurability = 175;
		ItemWorth = 18;
		WeldInfo = {
			Part = "LowerTorso";
			Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067);
		};
		Sounds = {
			Drag = "RockPickup";
			Drop = "RockDrop";
		};
	};
	[226] = {
		Name = "Metal Spikes";
		Image = "rbxassetid://16484592502";
		Description = [[Reinforced Metal Spikes that can be placed outside or on your base to further prevent intruders. Very resilient.]];
		Type = "Bench";
		MaxStack = 10;
		DespawnTime = 10;
		MaxDurability = 150;
		Sounds = {
			Drag = "MetalPickup";
			Drop = "MetalDrop";
		};
	};
}

return Items 
