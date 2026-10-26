-- [PATH] ServerStorage / Modules / KitModule @Type ModuleScript
-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")

-- Modules
local LootTable = require(ServerModules:WaitForChild("LootTable"))


local KitModule = {}

function KitModule:Initialize()
	shared.ArmorKits = {
		[1] = {
			Name = "Nothing",
			Armors = {}
		};
		[2] = {
			Name = "Full Cloth",
			Armors = {
				116; -- Cloth Pants
				115; -- Cloth Shirt
				153; -- Cloth Headwrap
				117; -- Cloth Footwraps
				156; -- Cloth Handwraps
			}
		};
		[3] = {
			Name = "Wooden Set",
			Armors = {
				123; -- Wooden Helmet
				124; -- Wooden Chestplate
				125; -- Wooden Leggings
				115; -- Cloth Shirt
				116; -- Cloth Pants
				152; -- Balaclava
				158; -- Leather Gloves
			}
		};
		[4] = {
			Name = "Hazmat",
			Armors = {
				60; -- Hazmat Suit
			}
		};
		[5] = {
			Name = "Salvaged Set",
			Armors = {
				145; -- Salvaged Helmet
				146; -- Salvaged Chestplate
				147; -- Salvaged Leggings
				112; -- Collared Shirt
				119; -- Leather Pants
				121; -- Leather Boots
				155; -- Salvaged Gloves
			}
		};
		[6] = {
			Name = "Military Set",
			Armors = {
				148; -- Military Helmet
				149; -- Military Chestplate
				150; -- Military Leggings
				59; -- Hoodie
				63; -- Pants
				111; -- Boots
				155; -- Salvaged Gloves
			}
		};
		[7] = {
			Name = "Steel Set",
			Armors = {
				141; -- Steel Helmet
				142; -- Steel Chestplate
				143; -- Steel Leggings
				59; -- Hoodie
				63; -- Pants
				111; -- Boots
				157; -- Military Gloves
			}
		};
		[8] = {
			Name = "Bruno's Set",
			Armors = {
				223; -- Steel Helmet
				222; -- Steel Chestplate
				143; -- Steel Leggings
				59; -- Hoodie
				63; -- Pants
				111; -- Boots
				157; -- Military Gloves
			}
		};
	}
	shared.WeaponKits = {
		[1] = {
			Name = "Boulder",
			Items = LootTable.new( -- 5 BOULDERS, 5 BANDAGES
				{
					Rolls = 5;
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
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		[2] = {
			Name = "Spears",
			Items = LootTable.new( -- 11 SPEARS, 10 BANDAGES
				{
					Rolls = 5;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 19; -- Wooden Spear
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				},
				{
					Rolls = 6;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 19; -- Wooden Spear
						Amount = 1;
					}};
				}
			)
		};
		[3] = {
			Name = "Wooden Bow",
			Items = LootTable.new( -- 1 WOODEN BOW, 500 WOODEN ARROWS, 10 BANDAGES
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
						ID = 126; -- Wooden Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		[4] = {
			Name = "Crossbow",
			Items = LootTable.new( -- 1 CROSSBOW, 500 WOODEN ARROWS, 10 BANDAGES
				{
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
						ID = 126; -- Wooden Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		[5] = {
			Name = "Nail Gun",
			Items = LootTable.new( -- 1 NAIL GUN, 999 NAILS, 10 BANDAGES
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
						ID = 93; -- Nails
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		[6] = {
			Name = "Crossy + Bow",
			Items = LootTable.new( -- 1 CROSSBOW, 1 WOODEN BOW, 500 WOODEN ARROWS, 500 BONE ARROWS, 500 COMBUSTIVE ARROWS, 10 BANDAGES
				{
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
						ID = 126; -- Wooden Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 128; -- Bone Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 129; -- Combustive Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		[7] = {
			Name = "Crossy + Nailgun",
			Items = LootTable.new( -- 1 CROSSBOW, 1 NAIL GUN, 500 WOODEN ARROWS, 500 BONE ARROWS, 999 NAILS, 10 BANDAGES
				{
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
						ID = 93; -- Nails
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 126; -- Wooden Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 128; -- Bone Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 129; -- Combustive Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		[8] = {
			Name = "Bow + Nailgun",
			Items = LootTable.new( -- 1 WOODEN BOW, 1 NAIL GUN, 500 WOODEN ARROWS, 500 BONE ARROWS, 999 NAILS, 10 BANDAGES
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
						ID = 93; -- Nails
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 126; -- Wooden Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 128; -- Bone Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 129; -- Combustive Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		[9] = {
			Name = "Break Action",
			Items = LootTable.new( -- 1 SALVAGED BREAK ACTION, 500 BUCKSHOT, 500 SLUG, 10 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 137; -- Salvaged Break Action
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 138; -- Buckshot
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
						ID = 138; -- Buckshot
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 139; -- Slug
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		[10] = {
			Name = "Bow + Break Action",
			Items = LootTable.new( -- 1 WOODEN BOW, 1 SALVAGED BREAK ACTION, 500 WOODEN ARROWS, 500 BONE ARROWS, 500 BUCKSHOT, 10 BANDAGES
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
						ID = 137; -- Salvaged Break Action
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 138; -- Buckshot
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
						ID = 138; -- Buckshot
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 126; -- Wooden Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 128; -- Bone Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 129; -- Combustive Arrow
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		[11] = {
			Name = "Salvaged P250",
			Items = LootTable.new( -- 1 SALVAGED P250, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 35; -- Salvaged P250
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 8;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[12] = {
			Name = "P250 Attachments",
			Items = LootTable.new( -- 1 SALVAGED P250, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 35; -- Salvaged P250
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 8;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 12; -- Salvaged Sight
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};
		[13] = {
			Name = "Salvaged Pipe Rifle",
			Items = LootTable.new( -- 1 SALVAGED PIPE RIFLE, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 109; -- Salvaged Pipe Rifle
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Light Ammo
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
						ID = 36; -- Light Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[14] = {
			Name = "Pipe Rifle + Break Action",
			Items = LootTable.new( -- 1 SALVAGED PIPE RIFLE, 1 SALVAGED BREAK ACTION, 999 RIFLE AMMO, 500 BUCKSHOT, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 109; -- Salvaged Pipe Rifle
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Light Ammo
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
						ID = 137; -- Salvaged Break Action
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 138; -- Buckshot
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
						ID = 138; -- Buckshot
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Light Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[15] = {
			Name = "P250 + Break Action",
			Items = LootTable.new( -- 1 SALVAGED P250, 1 SALVAGED BREAK ACTION, 500 BUCKSHOT, 999 PISTOL AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 35; -- Salvaged P250
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 8;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 137; -- Salvaged Break Action
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 138; -- Buckshot
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
						ID = 138; -- Buckshot
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[16] = {
			Name = "P250 + Pipe Rifle",
			Items = LootTable.new( -- 1 SALVAGED P250, 1 SALVAGED PIPE RIFLE, 999 PISTOL AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 35; -- Salvaged P250
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 8;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 109; -- Salvaged Pipe Rifle
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Light Ammo
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
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[17] = {
			Name = "Salvaged Python",
			Items = LootTable.new( -- 1 SALVAGED PYTHON, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 39; -- Salvaged Python
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 6;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[18] = {
			Name = "Python Attachments",
			Items = LootTable.new( -- 1 SALVAGED PYTHON, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 39; -- Salvaged Python
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 6;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
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
						ID = 12; -- Salvaged Sight
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};
		[19] = {
			Name = "Salvaged SMG",
			Items = LootTable.new( -- 1 SALVAGED SMG, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 38; -- Salvaged SMG
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 20;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[20] = {
			Name = "SMG Attachments",
			Items = LootTable.new( -- 1 SALVAGED SMG, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 38; -- Salvaged SMG
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 20;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
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
						ID = 12; -- Salvaged Sight
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};
		[21] = {
			Name = "Salvaged M14",
			Items = LootTable.new( -- 1 SALVAGED M14, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 9; -- Salvaged M14
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 4; -- Heavy Ammo
								Amount = 15;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[22] = {
			Name = "M14 Attachments",
			Items = LootTable.new( -- 1 SALVAGED M14, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 9; -- Salvaged M14
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 4; -- Heavy Ammo
								Amount = 15;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
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
						ID = 12; -- Salvaged Sight
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 15; -- Salvaged Lasersight
						Amount = 1;
					}};
				}
			)
		};
		[23] = {
			Name = "Salvaged AK74u",
			Items = LootTable.new( -- 1 SALVAGED AK74U, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 108; -- Salvaged AK74u
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
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
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[24] = {
			Name = "AK74u Attachments",
			Items = LootTable.new( -- 1 SALVAGED AK74U, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 108; -- Salvaged AK74u
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
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
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
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
						ID = 196; -- Military ACOG Sight
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 12; -- Salvaged Sight
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
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 15; -- Salvaged Lasersight
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};
		[25] = {
			Name = "Salvaged AK47",
			Items = LootTable.new( -- 1 SALVAGED AK47, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[26] = {
			Name = "AK47 Attachments",
			Items = LootTable.new( -- 1 SALVAGED AK47, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 196; -- Military ACOG Sight
						Amount = 1;
					}};
				},
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
						ID = 12; -- Salvaged Sight
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
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 15; -- Salvaged Lasersight
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
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};
		--[[
		[27] = {
			Name = "RPG All Ammos",
			Items = LootTable.new( -- 1 SALVAGED RPG, 60 SWIFT ROCKETS, 30 COMBUSTIVE ROCKETS, 12 MED PENS, 6 BANDAGES
				{
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
								ID = 99; -- Swift Rocket
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
						ID = 99; -- Swift Rocket
						Amount = 60;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 100; -- Combustive Rocket
						Amount = 30;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		]]
		[27] = {
			Name = "Melees",
			Items = LootTable.new( -- 1
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 216; -- Saw Bat
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 217; -- Machete
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 203; -- Bone Tool
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 181; -- Salvaged Shovel
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 20; -- Stone Spear
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		[28] = {
			Name = "Salvaged RPG",
			Items = LootTable.new( -- 1 SALVAGED RPG, 60 SWIFT ROCKETS, 12 MED PENS, 6 BANDAGES
				{
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
								ID = 99; -- Swift Rocket
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
						ID = 99; -- Swift Rocket
						Amount = 60;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		[29] = {
			Name = "Break Action Buckshot",
			Items = LootTable.new( -- 1 SALVAGED BREAK ACTION, 500 BUCKSHOT, 10 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 137; -- Salvaged Break Action
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 138; -- Buckshot
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
						ID = 138; -- Buckshot
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};
		
		[30] = {
			Name = "Break Action Slugs",
			Items = LootTable.new( -- 1 SALVAGED BREAK ACTION, 500 SLUGS, 10 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 137; -- Salvaged Break Action
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 139; -- Buckshot
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
						ID = 139; -- Slug
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 10;
					}};
				}
			)
		};

		[31] = {
			Name = "Python + Pump",
			Items = LootTable.new( -- 1 SALVAGED PYTHON, 1 SALVAGED PUMP ACTION, 999 LIGHT AMMO, 500 SLUGS, 12 HEALTH PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 39; -- Salvaged Python
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 6;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 193; -- Salvaged Pump Action
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 138; -- Buckshot
								Amount = 5;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 138; -- Buckshot
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[32] = {
			Name = "Pump Action Buckshot",
			Items = LootTable.new( -- 1 SALVAGED PUMP ACTION, 500 BUCKSHOT, 12 HEALTH PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 193; -- Salvaged Pump Action
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 138; -- Buckshot
								Amount = 5;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 138; -- Buckshot
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[33] = {
			Name = "Pump Action Slugs",
			Items = LootTable.new( -- 1 SALVAGED PUMP ACTION, 500 SLUGS, 12 HEALTH PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 193; -- Salvaged Pump Action
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 139; -- Slug
								Amount = 5;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 139; -- Slug
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[34] = {
			Name = "AA12 Buckshot",
			Items = LootTable.new( -- 1 MILITARY AA12, 500 BUCKSHOT, 12 HEALTH PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 191; -- Military AA12
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 138; -- Buckshot
								Amount = 10;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 138; -- Buckshot
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};

		[35] = {
			Name = "AA12 Slugs",
			Items = LootTable.new( -- 1 MILITARY AA12, 500 SLUGS, 12 HEALTH PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 191; -- Military AA12
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 139; -- Slug
								Amount = 10;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 139; -- Slug
						Amount = 500;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[36] = {
			Name = "Military M4A1",
			Items = LootTable.new( -- 1 MILITARY M4A1, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[37] = {
			Name = "M4A1 Attachments",
			Items = LootTable.new( -- 1 MILITARY M4A1, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 196; -- Military ACOG Sight
						Amount = 1;
					}};
				},
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
						ID = 12; -- Salvaged Sight
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
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 15; -- Salvaged Lasersight
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
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};
		
		[38] = {
			Name = "Salvaged Skorpion",
			Items = LootTable.new( -- 1 SALVAGED SKORPION, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 204; -- Salvaged Skorpion
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 15;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[39] = {
			Name = "Skorpion Attachments",
			Items = LootTable.new( -- 1 SALVAGED SKORPION, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 204; -- Salvaged Skorpion
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 36; -- Pistol Ammo
								Amount = 15;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 36; -- Pistol Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
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
						ID = 12; -- Salvaged Sight
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
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				}
			)
		};
		
		[40] = {
			Name = "Military Barrett",
			Items = LootTable.new( -- 1 MILITARY BARRETT, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
								Amount = 5;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[41] = {
			Name = "Barrett Attachments",
			Items = LootTable.new( -- 1 MILITARY BARRETT, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
								Amount = 5;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 17; -- Salvaged Sniper Scope
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 196; -- Military ACOG Sight
						Amount = 1;
					}};
				},
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
						ID = 12; -- Salvaged Sight
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
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 15; -- Salvaged Lasersight
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
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};

		[42] = {
			Name = "M4A1 + Barrett",
			Items = LootTable.new( -- 1 MILITARY M4A1, 1 MILITARY BARRETT, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
						ID = 210; -- Military Barrett
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 4; -- Heavy Ammo
								Amount = 5;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[43] = {
			Name = "AK47 + Barrett",
			Items = LootTable.new( -- 1 SALVAGED AK47, 1 MILITARY BARRETT 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
						ID = 210; -- Military Barrett
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 4; -- Heavy Ammo
								Amount = 5;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[44] = {
			Name = "Military PKM",
			Items = LootTable.new( -- 1 MILITARY PKM, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
								Amount = 75;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[45] = {
			Name = "PKM Attachments",
			Items = LootTable.new( -- 1 MILITARY PKM, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
								Amount = 75;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 196; -- Military ACOG Sight
						Amount = 1;
					}};
				},
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
						ID = 12; -- Salvaged Sight
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
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 15; -- Salvaged Lasersight
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
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};
		
		[46] = {
			Name = "AK47 + Barrett Attachments",
			Items = LootTable.new( -- 1 SALVAGED AK47, 1 MILITARY BARRETT, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
						ID = 210; -- Military Barrett
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 4; -- Heavy Ammo
								Amount = 5;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 17; -- Salvaged Sniper Scope
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 196; -- Military ACOG Sight
						Amount = 1;
					}};
				},
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
						ID = 12; -- Salvaged Sight
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
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 15; -- Salvaged Lasersight
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
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};
		
		[47] = {
			Name = "M4A1 + Barrett Attachments",
			Items = LootTable.new( -- 1 MILITARY M4A1, 1 MILITARY BARRETT, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
						ID = 210; -- Military Barrett
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 4; -- Heavy Ammo
								Amount = 5;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 17; -- Salvaged Sniper Scope
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 196; -- Military ACOG Sight
						Amount = 1;
					}};
				},
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
						ID = 12; -- Salvaged Sight
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
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 15; -- Salvaged Lasersight
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
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};
		
		[48] = {
			Name = "PKM + Barrett Attachments",
			Items = LootTable.new( -- 1 MILITARY PKM, 1 MILITARY BARRETT, ATTACHMENTS, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
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
								Amount = 75;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
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
								Amount = 5;
							}};
						});
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 17; -- Salvaged Sniper Scope
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 196; -- Military ACOG Sight
						Amount = 1;
					}};
				},
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
						ID = 12; -- Salvaged Sight
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
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 13; -- Muzzle Boost
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 14; -- Compensator
						Amount = 1;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 15; -- Salvaged Lasersight
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
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 16; -- Weapon Flashlight
						Amount = 1;
					}};
				}
			)
		};
		
		[49] = {
			Name = "Bruno's M4A1",
			Items = LootTable.new( -- 1 BRUNO'S M4A1, 999 AMMO, 12 MED PENS, 6 BANDAGES
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 221; -- Bruno's M4A1
						Amount = 1;
						Ammo = LootTable.new({
							Rolls = 1;
							Loot = {{
								Weight = 1;
								Type = "Item";
								ID = 4; -- Heavy Ammo
								Amount = 30;
							}};
						});
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
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 4; -- Heavy Ammo
						Amount = 999;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 136; -- Health Pen
						Amount = 12;
					}};
				},
				{
					Rolls = 1;
					Loot = {{
						Weight = 1;
						Type = "Item";
						ID = 2; -- Bandage
						Amount = 6;
					}};
				}
			)
		};
		
		[50] = {
			Name = "???",
			Items = LootTable.new({ -- 1 EZ SHOVEL
				Rolls = 1;
				Loot = {{
					Weight = 1;
					Type = "Item";
					ID = 182; -- ez shovel
					Amount = 1;
				}};
			})
		};
	}
end

return KitModule
