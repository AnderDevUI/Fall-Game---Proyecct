

return {
    {
        Name = "Wood Log",
        Image = "rbxassetid://14183996624",
        Description = "Wood harvested from a tree. Used as a crafting component and fuel.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 5,
        SmeltInfo = {
            Amount = 1,
            Time = 10,
            LootTable = { "Smelt", "General", "Wood Log" }
        },
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Bandage",
        Image = "rbxassetid://14134567329",
        Description = "A primitive healing tool. Heals 5 HP per use.",
        Type = "Tool",
        MaxStack = 3,
        DespawnTime = 5,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        },
        ConsumableStats = {
            Health = 5,
            HQueue = 0,
            StopBleeds = true,
            Instant = false
        }
    },
    {
        Name = "Stone Hatchet",
        Description = "Primitive tool for gathering wood more efficiently.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 175,
        ItemWorth = 20,
        Image = {
            Default = "rbxassetid://15073617325",
            Molten = "rbxassetid://15305732445",
            Shark = "rbxassetid://16208668072",
            VIP = "rbxassetid://16014755281",
            Valentine = "rbxassetid://16281532811",
            Slime = "rbxassetid://80657230310751",
            ["Candy Cane"] = "rbxassetid://113420518729636",
            ["Love Trip"] = "rbxassetid://106301749629689"
        },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067)
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Heavy Ammo",
        Image = "rbxassetid://13186564679",
        Description = "Standard heavy ammo.",
        Type = "Ammo",
        MaxStack = 128,
        DespawnTime = 20,
        AmmoType = "Rifle",
        AmmoWheelImage = "rbxassetid://2535574992",
        AmmoStats = {
            TracerName = "RifleBullet"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Salvaged AK47",
        Description = "Great damage, firerate, and range, but strong recoil. Uses Heavy Ammo.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 45,
        MaxDurability = 675,
        BaseMaxAmmo = 30,
        AmmoType = "Rifle",
        ItemWorth = 500,
        Image = {
            Default = "rbxassetid://14882620172",
            ["Anodized Red"] = "rbxassetid://15291340361",
            Frosty = "rbxassetid://15304886302",
            Vaporwave = "rbxassetid://15574230457",
            ["Anodized Blue"] = "rbxassetid://15792000837",
            Diablo = "rbxassetid://16021791118",
            ["Blue Gem"] = "rbxassetid://16577230239",
            ["Cyber Hunter"] = "rbxassetid://17199281165",
            ["Hot Rod"] = "rbxassetid://17768697376",
            Fade = "rbxassetid://79444477121964",
            Tyrant = "rbxassetid://124312637758997",
            Gingerbread = "rbxassetid://85687142665622",
            Ghillie = "rbxassetid://132083989873001",
            Anodized = "rbxassetid://80710562596890",
            ["Gold Sky"] = "rbxassetid://106035094504671",
            CyberPop = "rbxassetid://128785004285267",
            ["Phantom Rider"] = "rbxassetid://85810076023854",
            ["North Pole"] = "rbxassetid://105407359855835",
            Oni = "rbxassetid://105854184847862",
            ["Red Relic"] = "rbxassetid://132874855148397",
            Medal = "rbxassetid://102460072725837",
            Dune = "rbxassetid://83484244695308",
            Bling = "rbxassetid://81122287242310",
            Rogue = "rbxassetid://126781222915481",
            Airframe = "rbxassetid://77882549278978"
        },
        Attachments = { "Sight", "Muzzle", "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.0388, -0.3648, 0.6324, 0.5917, -0.8061, 0, 0.8062, 0.5917, 0, 0, 0, 1)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Bottle Caps",
        Image = "rbxassetid://14654996629",
        Description = "Official currency of Fallen. Can be used for purchasing and unlocking crafting recipes.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 5,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Holo Sight",
        Image = "rbxassetid://14162721610",
        Description = "Holographic sight. Provides enhanced zoom and aim spread reduction.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 30,
        AttachmentType = "Sight",
        AttachmentStats = {
            ZoomLevel = 1.5,
            AimSpreadMult = -0.2,
            GunRecoilAimMult = -0.4
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Silencer",
        Image = "rbxassetid://15347105863",
        Description = "Muzzle attachment. Lowers gunshot sounds, spread, and removes tracers for the cost of damage reduction.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 400,
        AttachmentType = "Muzzle",
        AttachmentStats = {
            DamageMult = -0.2,
            HideTracer = true
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Salvaged M14",
        Description = "Semi automatic rifle. Good damage and range, but a slower firerate. Uses Heavy Ammo.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 30,
        MaxDurability = 330,
        BaseMaxAmmo = 15,
        AmmoType = "Rifle",
        ItemWorth = 400,
        Image = {
            Default = "rbxassetid://14882876522",
            Paintball = "rbxassetid://15305730875",
            ["Candy Dragon"] = "rbxassetid://15346320769",
            Splat = "rbxassetid://16031054728",
            Arcane = "rbxassetid://17507702118",
            ["High Tide"] = "rbxassetid://16483734949",
            Stellark = "rbxassetid://77123726699368",
            Huntsman = "rbxassetid://121372881282577",
            Glitch = "rbxassetid://82715807510122",
            Frog14 = "rbxassetid://133627766691157",
            ["Anime Bloss"] = "rbxassetid://91134373735199",
            ["Jingle Bell"] = "rbxassetid://78927394340869"
        },
        Attachments = { "Sight", "Muzzle", "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.2223, -0.2861, 0.627, 0.0001, -0.7788, -0.6272, 0.0001, 0.6273, -0.7788, 1, 0, -0),
            ArmorStand = CFrame.new(0, 0, 0.2),
            AutoTurret = CFrame.new(0, 0, 0) * CFrame.Angles(0, -1.5707963267948966, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Lighter",
        Description = "A handheld Lighter. Provides small amount of light to help illuminate dark areas.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 300,
        Image = {
            Default = "rbxassetid://15128007580",
            Lantern = "rbxassetid://123377357974589"
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Swift Heavy Ammo",
        Image = "rbxassetid://13186565740",
        Description = "Swift heavy ammo. Travels faster and longer distances.",
        Type = "Ammo",
        MaxStack = 128,
        DespawnTime = 25,
        AmmoType = "Rifle",
        AmmoWheelImage = "rbxassetid://2535574992",
        AmmoStats = {
            SpeedMult = 1.25,
            RangeMult = 1.25,
            TracerName = "RifleBullet"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Salvaged Sight",
        Image = "rbxassetid://15283494417",
        Description = "A makeshift weapon sight. Lower FOV, but provides a small reduction in spread.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 10,
        AttachmentType = "Sight",
        AttachmentStats = {
            ZoomLevel = 1.15,
            AimSpreadMult = -0.1,
            GunRecoilAimMult = -0.15
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Muzzle Boost",
        Image = "rbxassetid://15347107233",
        Description = "Muzzle attachment. Slightly increases firerate at the cost of spread.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 400,
        AttachmentType = "Muzzle",
        AttachmentStats = {
            FireRateMult = 0.12,
            HipSpreadMult = 0.15,
            AimSpreadMult = 0.3
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Compensator",
        Image = "rbxassetid://15347108187",
        Description = "Muzzle attachment. Provides better recoil compensation for the slight cost of hip spread, range, and damage.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 400,
        AttachmentType = "Muzzle",
        AttachmentStats = {
            RecoilMult = -0.25,
            RangeMult = -0.2,
            DamageMult = -0.1,
            HipSpreadMult = 0.3,
            AimSpreadMult = 0.1
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Salvaged Lasersight",
        Image = "rbxassetid://15347108897",
        Description = "Barrel attachment. Lowers spread and aim sway when toggled.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 40,
        AttachmentType = "Barrel",
        AttachmentStats = {
            Toggle = true,
            HipSpreadMult = -0.35,
            AimSpreadMult = -0.2,
            SwayMult = -0.8
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Weapon Flashlight",
        Image = "rbxassetid://15373700419",
        Description = "Barrel attachment. Provides great visibility in dark situations.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 20,
        AttachmentType = "Barrel",
        AttachmentStats = {
            Toggle = true
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Salvaged Sniper Scope",
        Image = "rbxassetid://15304097362",
        Description = "Sniper scope that provides 4x augmentation.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 40,
        AttachmentType = "Sight",
        AttachmentStats = {
            ZoomLevel = 4,
            RecoilMult = 0.5,
            AimForRecoilMult = true,
            AimSpreadMult = -0.1,
            Scope = 1.05
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Military Sniper Scope",
        Image = "rbxassetid://15304097316",
        Description = "Military-grade sniper scope with 8x augmentation.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 45,
        AttachmentType = "Sight",
        AttachmentStats = {
            ZoomLevel = 8,
            RecoilMult = 0.5,
            AimForRecoilMult = true,
            AimSpreadMult = -0.1,
            Scope = 0.95
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Wooden Spear",
        Image = "rbxassetid://15303292373",
        Description = "Deal damage from up close. Can be effectively thrown.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 100,
        ItemWorth = 24,
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.0829, 0.0772, 0.5622, 0.2589, -0.9659, 0, -0.9659, -0.2588, 0.0001, 0, 0, -1)
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Stone Spear",
        Image = "rbxassetid://15303292549",
        Description = "An upgrade to the Wooden Spear. Sturdier and more effective.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 120,
        ItemWorth = 25,
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.0785, 0.0868, 0.5842, 0.2589, 0.0001, 0.966, -0.9659, 0, 0.2589, 0.0001, -1, 0.0001)
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Stone Pickaxe",
        Description = "Primitive tool for gathering stone and minerals more effectively.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 175,
        ItemWorth = 19,
        Image = {
            Default = "rbxassetid://15073617163",
            Molten = "rbxassetid://15305731898",
            VIP = "rbxassetid://16014754516",
            Valentine = "rbxassetid://16281531919",
            ["Love Trip"] = "rbxassetid://120075663072035"
        },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067)
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Crossbow",
        Description = "Fires all types of arrows. Slow to reload and fire, but comes with greater velocity than the bow.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 75,
        BaseMaxAmmo = 1,
        AmmoType = "Arrow",
        ItemWorth = 50,
        Image = {
            Default = "rbxassetid://15305596532",
            Crossbones = "rbxassetid://15305756728",
            HotDog = "rbxassetid://15877969435",
            ["Candy Whale"] = "rbxassetid://16114353256",
            Emerald = "rbxassetid://16751858634",
            Rose = "rbxassetid://80803215254174",
            Toy = "rbxassetid://102956782968040",
            Chief = "rbxassetid://137062431435688"
        },
        Attachments = { "Sight", "Barrel" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.1409, -0.0804, 0.737, 0.5, 0, 0.8661, -0.866, 0, 0.5, 0, -1, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Wooden Bow",
        Description = "A bow made from wood and cloth, fires any kind of arrow.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 140,
        BaseMaxAmmo = 1,
        AmmoType = "Arrow",
        ItemWorth = 35,
        Image = {
            Default = "rbxassetid://15313266356",
            ["Blue Fissure"] = "rbxassetid://15313269139",
            ["Sweet Gingerbread"] = "rbxassetid://15623006255",
            Cupid = "rbxassetid://16260403928",
            Crimson = "rbxassetid://16912320324",
            Dragon = "rbxassetid://119198626388204",
            ["Ancient Bone"] = "rbxassetid://136557779662161"
        },
        Attachments = {},
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.4203, -0.0257, 0.5778, 0.757, -0.6534, 0.0049, -0.6534, -0.7569, 0.0057, 0, -0.0074, -0.9999),
            ArmorStand = CFrame.new(0, -0.25, 0.2) * CFrame.Angles(1.5707963267948966, 1.5707963267948966, 0)
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Cloth",
        Image = "rbxassetid://13207713326",
        Description = "Strands of cloth. Crafting material.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 10,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Cactus Flesh",
        Image = "rbxassetid://13219980518",
        Description = "Cactus flesh gathered from a catus. Not very nutricious.",
        Type = "Consumable",
        MaxStack = 10,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 0,
            HQueue = 3,
            Hunger = 1,
            Thirst = 8,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Stone",
        Image = "rbxassetid://14308848818",
        Description = "Unearthed stone, used for crafting recipes and upgrading your base.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 5,
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Iron Ore",
        Image = "rbxassetid://14308849053",
        Description = "Raw iron ore. Smelt to refine.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 10,
        SmeltInfo = {
            Amount = 3,
            Time = 10,
            LootTable = { "Smelt", "Furnace", "Iron Ore" }
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Quality Iron Ore",
        Image = "rbxassetid://14308848947",
        Description = "Raw quality iron ore. Smelts into Steel.",
        Type = "Resource",
        MaxStack = 100,
        DespawnTime = 20,
        SmeltInfo = {
            Amount = 2,
            Time = 13.33,
            LootTable = { "Smelt", "Furnace", "Quality Iron Ore" }
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Campfire",
        Description = "Primitive campfire that allows the cooking of raw food. Not very effective.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 10,
        Image = {
            Default = "rbxassetid://15128008159",
            Skulls = "rbxassetid://133107732568884"
        },
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Blueprint",
        Image = "rbxassetid://15132469785",
        Description = "Start your base construction! Hold right click to switch base parts.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Hammer",
        Description = "Allows you to repair objects and upgrade base parts.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        Image = {
            Default = "rbxassetid://15318044673",
            Toy = "rbxassetid://15509809013",
            ["ERROR 404"] = "rbxassetid://15305728235",
            ["Building Blocks"] = "rbxassetid://15953856112"
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Raw Pork",
        Image = "rbxassetid://15295774046",
        Description = "Raw pork meat. Not recommended for consumption. Cook in a campfire.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = -3,
            HQueue = 0,
            Hunger = 10,
            Thirst = 0,
            Instant = true
        },
        SmeltInfo = {
            Amount = 1,
            Time = 15,
            LootTable = { "Smelt", "Campfire", "Raw Pork" }
        },
        Sounds = {
            Drag = "MeatPickup",
            Drop = "MeatDrop"
        }
    },
    {
        Name = "Cooked Pork",
        Image = "rbxassetid://15295773801",
        Description = "Cooked pork meat. Great food source.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 3,
            HQueue = 2,
            Hunger = 20,
            Thirst = 1,
            Instant = true
        },
        Sounds = {
            Drag = "MeatPickup",
            Drop = "MeatDrop"
        }
    },
    {
        Name = "Charcoal",
        Image = "rbxassetid://13207713474",
        Description = "The remains of burnt wood. Crafting material.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 5,
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Salvaged P250",
        Description = "Semi-automatic pistol with low to medium range. Average firerate and damage. Uses Light Ammo.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 180,
        BaseMaxAmmo = 8,
        AmmoType = "Pistol",
        ItemWorth = 140,
        Image = {
            Default = "rbxassetid://15305065991",
            Splat = "rbxassetid://15305728596",
            Fade = "rbxassetid://15631601051",
            Peppermint = "rbxassetid://15712513595",
            Sketch = "rbxassetid://16208668754",
            ["Egg Sketch"] = "rbxassetid://16916693041",
            ["Blue Terror"] = "rbxassetid://17366305322",
            ["Blue Gem"] = "rbxassetid://18149208414",
            Tempest = "rbxassetid://18966645823",
            Festive = "rbxassetid://101842524476750",
            ["Elite Bunny"] = "rbxassetid://138989649466976",
            Drift = "rbxassetid://94234232543243"
        },
        Attachments = { "Sight", "Muzzle" },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(1.0928, -0.1503, 0.1334, 0, 0, -1, 1, 0, 0, 0, -1, 0),
            AutoTurret = CFrame.new(0.65, 0, 0) * CFrame.Angles(0, 3.141592653589793, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Light Ammo",
        Image = "rbxassetid://13685818536",
        Description = "Standard light ammo.",
        Type = "Ammo",
        MaxStack = 128,
        DespawnTime = 20,
        AmmoType = "Pistol",
        AmmoWheelImage = "rbxassetid://15635709508",
        AmmoStats = {
            TracerName = "RifleBullet"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Boulder",
        Description = "A boulder, your starting tool. Good for breaking trees, nodes, or bashing heads.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 2,
        MaxDurability = 200,
        Image = {
            Default = "rbxassetid://15304806846",
            Bubblegum = "rbxassetid://15304805303",
            Frosty = "rbxassetid://15304805239",
            Tester = "rbxassetid://15304805180",
            Voxel = "rbxassetid://15574223076",
            Wrapped = "rbxassetid://15712360641",
            ["Fish Tank"] = "rbxassetid://15792001129",
            ["ERROR 404"] = "rbxassetid://16031055626",
            Pixskull = "rbxassetid://17766619061",
            Stellark = "rbxassetid://97313343547804",
            Cursed = "rbxassetid://92913832321996",
            ["Jack-O-Lantern"] = "rbxassetid://86358241058177",
            Sushi = "rbxassetid://78426403974796",
            Chocolate = "rbxassetid://139716602333201",
            Moai = "rbxassetid://115978938918724",
            Ducky = "rbxassetid://124674000707337",
            Pumpkin = "rbxassetid://126349162347833",
            Mosaic = "rbxassetid://74510585736689"
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Salvaged SMG",
        Description = "Fully automatic, slower firing with moderate damage. Well rounded sub machine gun. Uses Light Ammo.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 25,
        MaxDurability = 450,
        BaseMaxAmmo = 20,
        AmmoType = "Pistol",
        ItemWorth = 350,
        Image = {
            Default = "rbxassetid://15132874040",
            ["Fire and Ice"] = "rbxassetid://15312330570",
            Splat = "rbxassetid://15313314715",
            ["Red Urban"] = "rbxassetid://15574233065",
            Inferno = "rbxassetid://15883391466",
            Checkmate = "rbxassetid://16114277804",
            Valentine = "rbxassetid://16281529715",
            ["Evil Easter"] = "rbxassetid://16916946492",
            Knight = "rbxassetid://17366143384",
            ["Digital Candy"] = "rbxassetid://18557168240",
            Tempest = "rbxassetid://18966646387",
            ["Black Ice"] = "rbxassetid://109856083708178",
            ["Elite Bunny"] = "rbxassetid://138479957487119",
            Joker = "rbxassetid://104734469891887",
            Ducky = "rbxassetid://119924390182546",
            ["Game Buddy"] = "rbxassetid://75480260862201"
        },
        Attachments = { "Sight", "Muzzle", "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.0236, -0.0898, 0.5505, -0, -0.866, -0.5, -0, 0.5, -0.866, 1, 0.0001, -0),
            ArmorStand = CFrame.new(0, 0.05, -0.15),
            AutoTurret = CFrame.new(0.65, 0, 0) * CFrame.Angles(0, 0, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Salvaged Python",
        Description = "Limited magazine pistol that packs a punch. Uses Light Ammo.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 25,
        MaxDurability = 140,
        BaseMaxAmmo = 6,
        AmmoType = "Pistol",
        ItemWorth = 340,
        Image = {
            Default = "rbxassetid://15188995729",
            Canvas = "rbxassetid://15283200809",
            Hazard = "rbxassetid://15305731383",
            ["Blue Prey"] = "rbxassetid://15574225312",
            Saku = "rbxassetid://16029067988",
            Inferno = "rbxassetid://16283806768",
            ["Pink Canvas"] = "rbxassetid://16663261806",
            ["Crimson Glitched"] = "rbxassetid://16912320052",
            Shockwave = "rbxassetid://17366304773",
            Independence = "rbxassetid://18341881121",
            Stellark = "rbxassetid://124497972716738",
            Hyper = "rbxassetid://85697748071844",
            ["Black Ice"] = "rbxassetid://138482014642051",
            Smudge = "rbxassetid://76952866923184",
            Medal = "rbxassetid://128419932789140"
        },
        Attachments = { "Sight", "Barrel" },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(1.1544, 0.237, 0.0757, 0, 0, 1, -1, 0, 0, 0, -1, 0),
            AutoTurret = CFrame.new(0.65, 0, 0) * CFrame.Angles(0, 0, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Combustive Heavy Ammo",
        Image = "rbxassetid://13186583441",
        Description = "Combustive heavy ammo. Explodes on impact.",
        Type = "Ammo",
        MaxStack = 128,
        DespawnTime = 45,
        AmmoType = "Rifle",
        AmmoWheelImage = "rbxassetid://2535574992",
        AmmoStats = {
            TracerName = "RifleBullet",
            Impact = "ExplosiveBullet",
            FilterType = "HitIgnore",
            SpeedMult = 0.75,
            RangeMult = 0.75,
            GravityMult = 1.1,
            MuzzleDurability = 3,
            WeaponDurability = 2,
            Explosive = {
                Radius = 1.5,
                HumanoidMaxDamage = 10,
                SoftSideMult = 1.2,
                DamagePrefix = "Explo_"
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Animal Fat",
        Image = "rbxassetid://15304534433",
        Description = "The fats harvested from an animal. Crafting material.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 5,
        Sounds = {
            Drag = "MeatPickup",
            Drop = "MeatDrop"
        }
    },
    {
        Name = "Small Storage Box",
        Description = "A small storage box for storing a small amount of items",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 30,
        Image = {
            Default = "rbxassetid://15094083341",
            Monster = "rbxassetid://15883290696",
            Comic = "rbxassetid://16577230729",
            Gremlin = "rbxassetid://16748563435",
            Burger = "rbxassetid://95806776502625",
            Medical = "rbxassetid://97915388339168"
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Raw Venison",
        Image = "rbxassetid://13220221327",
        Description = "Raw venison from a deer. Not recommended for consumption. Cook in a campfire.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = -6,
            HQueue = 0,
            Hunger = 5,
            Thirst = 1,
            Instant = true
        },
        SmeltInfo = {
            Amount = 1,
            Time = 15,
            LootTable = { "Smelt", "Campfire", "Raw Venison" }
        },
        Sounds = {
            Drag = "MeatPickup",
            Drop = "MeatDrop"
        }
    },
    {
        Name = "Cooked Venison",
        Image = "rbxassetid://13220221662",
        Description = "Cooked venison. Great food source.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 0,
            HQueue = 10,
            Hunger = 10,
            Thirst = 2,
            Instant = true
        },
        Sounds = {
            Drag = "MeatPickup",
            Drop = "MeatDrop"
        }
    },
    {
        Name = "Iron Shards",
        Image = "rbxassetid://14184000696",
        Description = "Crude iron shards. Crafting material.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 15,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Steel Metal",
        Image = "rbxassetid://16252541108",
        Description = "Refined quality iron ore. Crafting material.",
        Type = "Resource",
        MaxStack = 100,
        DespawnTime = 40,
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Wooden Door",
        Description = "A wooden door vulnerable to fire attacks. Place a Lock to prevent unwanted visitors.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 100,
        Image = {
            Default = "rbxassetid://15132568626",
            Beware = "rbxassetid://15305026376",
            Chocolate = "rbxassetid://15712523927",
            ["Pot of Gold"] = "rbxassetid://16748559894",
            ["Summer Time"] = "rbxassetid://18762630774",
            Cardboard = "rbxassetid://132805078818983",
            ["Christmas Tree"] = "rbxassetid://111412634443690",
            Pixel = "rbxassetid://106378082611103",
            Wise = "rbxassetid://101629446511815"
        },
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Wooden Lock",
        Image = "rbxassetid://15305165322",
        Description = "A basic wooden key lock. Locks a bench so only one person can access.",
        Type = "Lock",
        MaxStack = 10,
        DespawnTime = 5,
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Combination Lock",
        Image = "rbxassetid://15305165381",
        Description = "A metal code lock. Only allows people with the combination access to the bench.",
        Type = "Lock",
        MaxStack = 10,
        DespawnTime = 5,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Salvaged Metal Door",
        Description = "Low durability metallic door. Prevents fire attacks. Place a Lock to prevent unwanted visitors.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 100,
        Image = {
            Default = "rbxassetid://15132658803",
            Visions = "rbxassetid://15444463543",
            Graffiti = "rbxassetid://16664082484"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Base Cabinet",
        Description = "Vital part of the base. Provides building privilege if authorized and prevents decay. Secure well.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 100,
        Image = {
            Default = "rbxassetid://14653876852",
            Server = "rbxassetid://109131187101243",
            ["Winter Wrap"] = "rbxassetid://79186461116233"
        },
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Wooden Double Door",
        Description = "A wooden double door. Vulnerable to fire attacks. Place a Lock to prevent unwanted visitors.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 100,
        Image = {
            Default = "rbxassetid://15132568988",
            Rainbow = "rbxassetid://15344501592",
            ["Cherry Blossom"] = "rbxassetid://16577230495",
            ["Barn Doors"] = "rbxassetid://17497777892",
            Decoy = "rbxassetid://127297439262046"
        },
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Wooden Window Bars",
        Image = "rbxassetid://15128007380",
        Description = "Place on window frames to deny unwanted visitors from jumping in. Vulnerable to fire attacks.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        MaxDurability = 250,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Metal Window Bars",
        Image = "rbxassetid://15132553555",
        Description = "Place on window frames to deny unwanted visitors from jumping in.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 500,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Glass Window",
        Image = "rbxassetid://15210914495",
        Description = "Allows you to view outside your base while safe from bullet shots.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 15,
        MaxDurability = 250,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Steel Glass Window",
        Image = "rbxassetid://15132487922",
        Description = "Allows you to view outside your base while safe from bullet shots.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 20,
        MaxDurability = 500,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Trap Door",
        Description = "Open or close a hatch for easy access to upwards areas. Immune to fire attacks.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 150,
        Image = {
            Default = "rbxassetid://13143032792"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Radiation Vitamins",
        Image = "rbxassetid://15304290390",
        Description = "Greatly lowers radiation, for the cost of thirst.",
        Type = "Consumable",
        MaxStack = 10,
        DespawnTime = 5,
        ConsumableStats = {
            Thirst = -4,
            Radiation = -40,
            Instant = true
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Hoodie",
        Description = "Provides good resistance against the cold.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 10,
        ArmorType = "Shirt",
        Image = {
            Default = "rbxassetid://14654794392",
            Boris = "rbxassetid://18312277063",
            ["Forest Camo"] = "rbxassetid://15283152783",
            Red = "rbxassetid://15283152304",
            Purple = "rbxassetid://15283152380",
            Green = "rbxassetid://15283152598",
            Abibas = "rbxassetid://15305689057",
            Wool = "rbxassetid://15877516276",
            Valentine = "rbxassetid://16293021303",
            Woodland = "rbxassetid://16448119412",
            ["Hot Rod"] = "rbxassetid://17768833509",
            Tyrant = "rbxassetid://130901964742021",
            Nutcracker = "rbxassetid://72418266986929",
            Puffer = "rbxassetid://71855339887230",
            Brutus = "rbxassetid://116605401922894",
            Tundra = "rbxassetid://94852483691948",
            ["Elite Bunny"] = "rbxassetid://77892644977802",
            Pilot = "rbxassetid://102843742682628",
            Player = "rbxassetid://72323540553042",
            Bee = "rbxassetid://106663686372311",
            Night = "rbxassetid://104718096945503"
        },
        Resistances = {
            Heat = 0,
            Cold = 9,
            Explosive = 2,
            Radiation = 5,
            Animal = 6,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 20,
                Melee = 15
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Hazmat Suit",
        Description = "This full-body Hazmat Suit provides radiation protection plus basic damage resistance.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 2800,
        ArmorType = "All",
        Attribute = "ResistWet",
        HideHair = true,
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://15046441717",
            Snowman = "rbxassetid://15712521421",
            ["Blue Fissure"] = "rbxassetid://16822398564",
            ["Digital Red"] = "rbxassetid://17366071573",
            Spark = "rbxassetid://18965466357",
            Stellark = "rbxassetid://123693400858947",
            ["Digital Camo"] = "rbxassetid://106956792584318",
            Classified = "rbxassetid://78801273340050",
            Front = "rbxassetid://109185322610878",
            Guard = "rbxassetid://113617571174399",
            Ducky = "rbxassetid://116234383398695",
            Ghoul = "rbxassetid://102977931837887",
            Specialist = "rbxassetid://99406105774604"
        },
        Attachments = { "Helmet", "Chestplate", "Leggings", "All" },
        Resistances = {
            Heat = 0,
            Cold = 8,
            Explosive = 7,
            Radiation = 50,
            Animal = 8,
            Legs = {
                Bullet = 25,
                Melee = 25
            },
            Chest = {
                Bullet = 25,
                Melee = 25
            },
            Head = {
                Bullet = 25,
                Melee = 25
            }
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Chicken MRE",
        Image = "rbxassetid://14162884663",
        Description = "A full meal made from chicken ready to eat. Provides a great amount of nutrition.",
        Type = "Consumable",
        MaxStack = 5,
        DespawnTime = 10,
        ConsumableStats = {
            Health = 0,
            HQueue = 3,
            Hunger = 20,
            Thirst = 10,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Beef MRE",
        Image = "rbxassetid://14162884919",
        Description = "A full meal made from beef ready to eat. Provides a great amount of nutrition.",
        Type = "Consumable",
        MaxStack = 5,
        DespawnTime = 10,
        ConsumableStats = {
            Health = 0,
            HQueue = 3,
            Hunger = 20,
            Thirst = 10,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Pants",
        Description = "A nice pair of quality pants.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 10,
        ArmorType = "Pants",
        Image = {
            Default = "rbxassetid://14654792590",
            Boris = "rbxassetid://18312279038",
            Khaki = "rbxassetid://15283151856",
            ["Forest Camo"] = "rbxassetid://15283152437",
            Abibas = "rbxassetid://15305689962",
            Valentine = "rbxassetid://16293019822",
            Woodland = "rbxassetid://16448121262",
            ["Hot Rod"] = "rbxassetid://17768833305",
            Correctional = "rbxassetid://135793344308303",
            Tyrant = "rbxassetid://136885851029799",
            Nutcracker = "rbxassetid://71901466636387",
            Brutus = "rbxassetid://85540429494017",
            Tundra = "rbxassetid://90847059484754",
            ["Elite Bunny"] = "rbxassetid://89074393808133",
            Pilot = "rbxassetid://98210347761500",
            Player = "rbxassetid://129572575838612",
            Bee = "rbxassetid://136553486453775"
        },
        Resistances = {
            Heat = 0,
            Cold = 8,
            Explosive = 2,
            Radiation = 5,
            Animal = 3,
            Legs = {
                Bullet = 15,
                Melee = 10
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Phosphate Ore",
        Image = "rbxassetid://15132608151",
        Description = "Raw phosphate ore. Smelt to refine.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 15,
        SmeltInfo = {
            Amount = 3,
            Time = 5,
            LootTable = { "Smelt", "Furnace", "Phosphate Ore" }
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Phosphate Dust",
        Image = "rbxassetid://14183996960",
        Description = "Smelted phosphate ore. Crafting material.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 25,
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Leather",
        Image = "rbxassetid://13207712789",
        Description = "Strands of leather. Crafting material.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 15,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Furnace",
        Description = "Primitive furnace designed to reach temperatures hot enough to refine ores using wood. Limited capacity.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 100,
        Image = {
            Default = "rbxassetid://15074084708",
            Banana = "rbxassetid://15344532656",
            ["Sweet Gingerbread"] = "rbxassetid://15622165066",
            Glyphs = "rbxassetid://15630767150",
            Gorilla = "rbxassetid://16484587298",
            ["Blue Steel"] = "rbxassetid://18761542136",
            Burger = "rbxassetid://84948985557474",
            Penguin = "rbxassetid://122396159441498",
            Pumpkin = "rbxassetid://81542845446759",
            ["Winter Wrap"] = "rbxassetid://82920100728899",
            ["Chinese New Year"] = "rbxassetid://137256732968955"
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Crude Fuel",
        Image = "rbxassetid://14651282157",
        Description = "Fuel source for generators and vehicles. Crafting material.",
        Type = "Resource",
        MaxStack = 500,
        DespawnTime = 10,
        Sounds = {
            Drag = "LiquidPickup",
            Drop = "LiquidDrop"
        },
        SmeltInfo = {
            Amount = 1,
            Time = 12,
            DoFirst = true
        }
    },
    {
        Name = "Gunpowder",
        Image = "rbxassetid://15074277771",
        Description = "Combustable material made from phosphate and charcoal. Crafting material.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 45,
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Bone Shards",
        Image = "rbxassetid://13207713694",
        Description = "The remaining shards of bones harvested from an animal. Crafting material.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 10,
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Metal Door",
        Description = "A metallic door. Medium durability, prevents fire attacks. Place a Lock to prevent unwanted visitors.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 150,
        Image = {
            Default = "rbxassetid://15132832907",
            Pixel = "rbxassetid://15310965325",
            ["PLZ NO RAID"] = "rbxassetid://15310983705",
            Frosty = "rbxassetid://15304875360",
            ["Angry Bunny"] = "rbxassetid://16924356510",
            Independence = "rbxassetid://18341881259",
            Comic = "rbxassetid://18444379748",
            ["Elite Bunny"] = "rbxassetid://77825470317254",
            Industrial = "rbxassetid://78073516430678",
            Demon = "rbxassetid://137869636615146",
            Bayou = "rbxassetid://88981731583061"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Metal Double Door",
        Description = "Metallic double door. Immune to fire attacks. Place a Lock to prevent unwanted visitors.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 150,
        Image = {
            Default = "rbxassetid://15132833297",
            Pixel = "rbxassetid://15310966370",
            Tropical = "rbxassetid://16483738322",
            ["Hells Gate"] = "rbxassetid://90897641914339",
            Nightwave = "rbxassetid://119789304012674"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Steel Door",
        Description = "A strong steel door. Great durability. Place a Lock to prevent unwanted visitors.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 45,
        MaxDurability = 600,
        Image = {
            Default = "rbxassetid://15132554218",
            ["Christmas Tree"] = "rbxassetid://15638295051",
            Galactic = "rbxassetid://16483736587",
            Tyrant = "rbxassetid://90255972475887",
            Duck = "rbxassetid://132207599970757",
            Rogue = "rbxassetid://107019289116584",
            ["Elven Gate"] = "rbxassetid://123531366217243"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Steel Double Door",
        Description = "A strong steel double door. Great durability. Place a Lock to prevent unwanted visitors.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 45,
        MaxDurability = 600,
        Image = {
            Default = "rbxassetid://15132553963",
            Vaporwave = "rbxassetid://17199280862",
            ["Red Lotus"] = "rbxassetid://130069862861998",
            ["Elven Gate"] = "rbxassetid://95946321412209"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Nail Gun",
        Description = "An industrial tool salvaged from the wasteland thats been given a new purpose as a weapon. Shoots Nails.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 210,
        BaseMaxAmmo = 14,
        AmmoType = "Nail",
        ItemWorth = 45,
        Image = {
            Default = "rbxassetid://15305104734",
            Striker = "rbxassetid://15305729695",
            Magma = "rbxassetid://15946260536",
            Wintrane = "rbxassetid://114731373088561"
        },
        Attachments = {},
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(1.1325, 0.2604, -0.082, 0, 0, 1, -1, 0, 0, 0, -1, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Steel Axe",
        Description = "An axe made from steel. Very effective gathering tool.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 500,
        ItemWorth = 94,
        Image = {
            Default = "rbxassetid://13206734202",
            Ruby = "rbxassetid://15444465626",
            Freeze = "rbxassetid://15712516834",
            ["Fire Axe"] = "rbxassetid://17199281023",
            Lava = "rbxassetid://81357829552245",
            Fade = "rbxassetid://109709016746739"
        },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.0328, -0.2053, 0.6296, -0, 0.7072, -0.7071, 0.0001, 0.7072, 0.7072, 1, 0.0001, -0)
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Steel Pickaxe",
        Description = "A pickaxe made from steel. Very effective mining tool.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 500,
        ItemWorth = 95,
        Image = {
            Default = "rbxassetid://13206733920",
            Cross = "rbxassetid://15444466662",
            Freeze = "rbxassetid://15712518908",
            ["Ice Pick"] = "rbxassetid://17750836356",
            Molten = "rbxassetid://18762535576",
            Fade = "rbxassetid://110115929577544"
        },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.0328, -0.2053, 0.6296, -0, 0.7072, -0.7071, 0.0001, 0.7072, 0.7072, 1, 0.0001, -0)
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Power Cell",
        Image = "rbxassetid://13187407477",
        Description = "Electrical component that can be used for puzzles or recycling.",
        Type = "Misc",
        MaxStack = 10,
        DespawnTime = 20,
        MaxDurability = 100,
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Copper Cogs",
        Image = "rbxassetid://14651228837",
        Description = "A crafting component found in the world and crates. Crafting material.",
        Type = "Misc",
        MaxStack = 20,
        DespawnTime = 30,
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Pipe",
        Image = "rbxassetid://14651117776",
        Description = "A crafting component found in the world and crates. Crafting material.",
        Type = "Misc",
        MaxStack = 20,
        DespawnTime = 20,
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Propane Tank",
        Image = "rbxassetid://13187406443",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 5,
        DespawnTime = 5,
        Hidden = true,
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Rope",
        Image = "rbxassetid://14651117276",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 50,
        DespawnTime = 10,
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Blade",
        Image = "rbxassetid://14651119220",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 20,
        DespawnTime = 10,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Thread",
        Image = "rbxassetid://14651157447",
        Description = "A crafting component found in the world and crates, Can be used to craft clothing.",
        Type = "Misc",
        MaxStack = 20,
        DespawnTime = 20,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Metal Plating",
        Image = "rbxassetid://14651164157",
        Description = "A crafting component found in the world and crates, Can be used to craft Armor.",
        Type = "Misc",
        MaxStack = 20,
        DespawnTime = 20,
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Spring",
        Image = "rbxassetid://14651115579",
        Description = "A crafting component found in the world and crates, Can be used to craft Weapons. Crafting material.",
        Type = "Misc",
        MaxStack = 20,
        DespawnTime = 20,
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Tarp",
        Image = "rbxassetid://14651115367",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 20,
        DespawnTime = 10,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Circuit Boards",
        Image = "rbxassetid://14651118848",
        Description = "A crafting component found in crates, Can be used to craft raiding tools. Crafting material.",
        Type = "Misc",
        MaxStack = 20,
        DespawnTime = 30,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Metal Scraps",
        Image = "rbxassetid://14651117901",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 20,
        DespawnTime = 10,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Swift Light Ammo",
        Image = "rbxassetid://13186591166",
        Description = "Swift light ammo. Travels faster and longer distances.",
        Type = "Ammo",
        MaxStack = 128,
        DespawnTime = 20,
        AmmoType = "Pistol",
        AmmoWheelImage = "rbxassetid://15635709508",
        AmmoStats = {
            SpeedMult = 1.25,
            RangeMult = 1.25,
            TracerName = "RifleBullet"
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Sleeping Bag",
        Description = "Sleeping bags are used as a respawn point on the map. Sleeping bags placed too close to one another will share the same cooldown.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 40,
        Image = {
            Default = "rbxassetid://15313154200",
            ["Cucumber John"] = "rbxassetid://15313175563",
            Prismatic = "rbxassetid://15574227229",
            Santa = "rbxassetid://15715978392",
            Shark = "rbxassetid://16117442613",
            Voxel = "rbxassetid://18147427074",
            Spooky = "rbxassetid://85015559308510",
            Fruit = "rbxassetid://81952434018281",
            ["Big Pillow"] = "rbxassetid://128662593449303",
            UwU = "rbxassetid://96904970768142",
            Chocolate = "rbxassetid://108416357231982",
            Jungle = "rbxassetid://96564910653821"
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Timed Charge",
        Image = "rbxassetid://13169199238",
        Description = "Timed explosive charge. Heavy single target bench damage.",
        Type = "Tool",
        MaxStack = 10,
        DespawnTime = 50,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Nails",
        Image = "rbxassetid://13186564996",
        Description = "Metal nails. Can be shot out of a Nail Gun.",
        Type = "Ammo",
        MaxStack = 128,
        DespawnTime = 5,
        AmmoType = "Nail",
        AmmoWheelImage = "rbxassetid://2535574992",
        AmmoStats = {
            TracerName = "NailBullet",
            Impact = "Stick",
            ShatterChance = 30,
            BulletSize = 0.2,
            StepType = ""
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Garage Door",
        Description = "A Garage Door. Very durable, but slow opening and closing times.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 300,
        Image = {
            Default = "rbxassetid://16574547137",
            ["King Raid"] = "rbxassetid://15344456682",
            Blob = "rbxassetid://15509791543",
            ["Surprise Meow"] = "rbxassetid://16574535811",
            ["King of the street"] = "rbxassetid://17193053474",
            ["Grand Prix"] = "rbxassetid://88541547537698",
            Cryo = "rbxassetid://113706556350765",
            Witch = "rbxassetid://85491019952546"
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Dynamite Bundle",
        Image = "rbxassetid://15127431071",
        Description = "Crude bundle of dynamite sticks. Fuse times may vary and explosion is not guaranteed.",
        Type = "Tool",
        MaxStack = 10,
        DespawnTime = 20,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Dynamite Stick",
        Image = "rbxassetid://15127430886",
        Description = "Crude dynamite grenade stick. Fuse times may vary and explosion is not guaranteed.",
        Type = "Tool",
        MaxStack = 5,
        DespawnTime = 15,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Salvaged RPG",
        Description = "Shoots rocket-propelled grenades at fast speeds that explode on impact.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 45,
        MaxDurability = 40,
        BaseMaxAmmo = 1,
        AmmoType = "Rocket",
        ItemWorth = 550,
        Image = {
            Default = "rbxassetid://15132772506",
            Blast = "rbxassetid://15305772236",
            Boomstick = "rbxassetid://18965877488",
            Festive = "rbxassetid://81287503464820"
        },
        Attachments = {},
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.2261, -0.4751, 0.6137, -0.5362, -0.844, 0, -0.844, 0.5363, 0, 0, 0, -1),
            ArmorStand = CFrame.new(0, -0.05, -0.35) * CFrame.Angles(0, 1.5707963267948966, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Rocket",
        Image = "rbxassetid://15637955888",
        Description = "Explosive rocket ammunition.",
        Type = "Ammo",
        MaxStack = 3,
        DespawnTime = 50,
        AmmoType = "Rocket",
        AmmoWheelImage = "rbxassetid://15635741795",
        AmmoStats = {
            TracerName = "Rocket",
            Impact = "Explosion",
            FilterType = "HitIgnore",
            BulletSize = 0.5,
            StepType = "",
            Explosive = {
                Radius = 8.5,
                HumanoidMaxDamage = 175,
                SoftSideMult = 1,
                DamagePrefix = "",
                ShakeStrength = 0.8,
                Duration = 0.45,
                SoundName = "Rocket"
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Swift Rocket",
        Image = "rbxassetid://15132772763",
        Description = "Swift rocket ammunition. Much faster velocity with lower damages.",
        Type = "Ammo",
        MaxStack = 3,
        DespawnTime = 45,
        AmmoType = "Rocket",
        AmmoWheelImage = "rbxassetid://15635733735",
        AmmoStats = {
            TracerName = "HVRocket",
            Impact = "Explosion",
            FilterType = "HitIgnore",
            SpeedMult = 1.35,
            RangeMult = 1.35,
            BulletSize = 0.5,
            StepType = "",
            Explosive = {
                Radius = 8,
                HumanoidMaxDamage = 180,
                SoftSideMult = 1,
                DamagePrefix = "HV_",
                ShakeStrength = 0.7,
                Duration = 0.4,
                SoundName = "Rocket"
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Combustive Rocket",
        Image = "rbxassetid://15637959127",
        Description = "Combustive rocket ammunition. Explodes into a gulf of flames.",
        Type = "Ammo",
        MaxStack = 3,
        DespawnTime = 45,
        AmmoType = "Rocket",
        AmmoWheelImage = "rbxassetid://15635738700",
        AmmoStats = {
            TracerName = "IncendiaryRocket",
            Impact = "Fire",
            FilterType = "HitIgnore",
            DamageMult = 0.75,
            BulletSize = 0.5,
            StepType = "",
            Explosive = {
                Radius = 7.5,
                HumanoidMaxDamage = 50,
                SoftSideMult = 1,
                DamagePrefix = "HV_",
                ShakeStrength = 0.4,
                Duration = 0.25,
                SoundName = "Rocket"
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "External Wooden Wall",
        Image = "rbxassetid://15132487460",
        Description = "Barbed wooden wall that can be placed outside your base to further prevent intruders.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 500,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "External Wooden Gate",
        Image = "rbxassetid://15132487698",
        Description = "Barbed wooden gate that can be placed outside your base to further prevent intruders.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 500,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Vertical Window Cover",
        Image = "rbxassetid://15396925620",
        Description = "Extra cover that can be placed on top of windows.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 500,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Horizontal Window Cover",
        Image = "rbxassetid://15396925485",
        Description = "Extra cover that can be placed on top of windows.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 500,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Jail Wall",
        Image = "rbxassetid://13547704099",
        Description = "Sturdy metal bars. Can be shot through but not trespassed.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 75,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Jail Door",
        Image = "rbxassetid://13547704298",
        Description = "Sturdy metal bars that can be opened. Can be shot through but not trespassed.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 75,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "%s\'s Trophy",
        Image = "rbxassetid://15274399715",
        Description = "Belongs to %s. I wonder what it\'s made out of..?",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 3,
        MaxDurability = 10,
        Hidden = true,
        DropInfo = {
            ButtonName = "CRUSH",
            LootTable = { "ItemDrops", "Trophy" }
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Salvaged AK74u",
        Description = "Fully automatic AK74u that has been modified to shoot Light Ammo at a high fire rate.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 40,
        MaxDurability = 675,
        BaseMaxAmmo = 30,
        AmmoType = "Pistol",
        ItemWorth = 450,
        Image = {
            Default = "rbxassetid://15073408197",
            Beast = "rbxassetid://15305755800",
            Splash = "rbxassetid://15509741616",
            VIP = "rbxassetid://16014753591",
            Comic = "rbxassetid://16114228051",
            Clover = "rbxassetid://16748171046",
            Nebula = "rbxassetid://17518135139",
            ["Stellark Dragon"] = "rbxassetid://116297510128388",
            ["Black Ice"] = "rbxassetid://128242163135902",
            Tundra = "rbxassetid://114982197234346",
            ["Pink Ripple"] = "rbxassetid://122346171773813",
            MP5 = "rbxassetid://78960618674854",
            Flarette = "rbxassetid://125113179502352",
            Zombie = "rbxassetid://101630769388124",
            ["Phantom Rider"] = "rbxassetid://140329577619010"
        },
        Attachments = { "Sight", "Muzzle", "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.15, -0.5523, 0.593, 0, 0.8661, -0.4999, 0, 0.5, 0.8661, 1, 0, 0),
            ArmorStand = CFrame.new(0, 0.2, -0.3),
            AutoTurret = CFrame.new(0, 0, 0) * CFrame.Angles(0, -1.5707963267948966, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Salvaged Pipe Rifle",
        Description = "Barrel fed, single shot, bolt action rifle made from some pipes. Slow to shoot. Uses Light Ammo.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 75,
        BaseMaxAmmo = 1,
        AmmoType = "Pistol",
        ItemWorth = 200,
        Image = {
            Default = "rbxassetid://15073408081",
            Surge = "rbxassetid://15509721163",
            Gingerbread = "rbxassetid://15638252851",
            Frost = "rbxassetid://16208668377",
            Skyline = "rbxassetid://18557168359"
        },
        Attachments = { "Barrel" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.5807, -0.0974, 0.5802, -0.7071, -0.7071, 0, -0.7071, 0.7072, 0, 0, 0, -1),
            ArmorStand = CFrame.new(0, -0.15, -0.6) * CFrame.Angles(0, -1.5707963267948966, 0),
            AutoTurret = CFrame.new(0, 0, 0) * CFrame.Angles(0, 3.141592653589793, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Petroleum",
        Image = "rbxassetid://14651118356",
        Description = "Unrefined fuel. Can be refined into Crude Fuel.",
        Type = "Resource",
        MaxStack = 500,
        DespawnTime = 5,
        SmeltInfo = {
            Amount = 2,
            Time = 6,
            LootTable = { "Smelt", "PetroleumRefinery", "Petroleum" }
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Boots",
        Description = "Sturdy pair of well made boots.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 10,
        ArmorType = "Boots",
        Image = {
            Default = "rbxassetid://14654795457",
            Black = "rbxassetid://15283152697",
            ["Forest Camo"] = "rbxassetid://15283152517",
            Abibas = "rbxassetid://15305690697",
            Valentine = "rbxassetid://16293022275",
            Woodland = "rbxassetid://16473066174",
            ["Hot Rod"] = "rbxassetid://17768833072",
            Correctional = "rbxassetid://92577755087375",
            Nutcracker = "rbxassetid://102533866187536",
            Brutus = "rbxassetid://124559624944530",
            Tundra = "rbxassetid://75185734630840",
            ["Elite Bunny"] = "rbxassetid://98142715632310",
            Pilot = "rbxassetid://74948835097705",
            Medal = "rbxassetid://107412050354842"
        },
        Resistances = {
            Heat = 0,
            Cold = 8,
            Explosive = 1,
            Radiation = 4,
            Animal = 3,
            Legs = {
                Bullet = 10,
                Melee = 10
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Collared Shirt",
        Description = "A nice looking shirt. Provides some protection against the elements.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 7,
        ArmorType = "Shirt",
        Image = {
            Default = "rbxassetid://14654793432",
            Business = "rbxassetid://15444462393",
            Correctional = "rbxassetid://140110401401547",
            Flannel = "rbxassetid://97292443788852",
            Woodland = "rbxassetid://127116898404941"
        },
        Resistances = {
            Heat = 0,
            Cold = 8,
            Explosive = 1,
            Radiation = 5,
            Animal = 6,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 15,
                Melee = 15
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Shorts",
        Description = "A pair of shorts to keep you cool on a hot day.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 5,
        ArmorType = "Pants",
        Image = {
            Default = "rbxassetid://14654791921",
            ["Beach Day"] = "rbxassetid://106157418298863"
        },
        Resistances = {
            Heat = 0,
            Cold = 7,
            Explosive = 1,
            Radiation = 2,
            Animal = 3,
            Legs = {
                Bullet = 5,
                Melee = 10
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Tank Top",
        Description = "Double the tank tops... gives you more defense. Don\'t ask any questions.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 5,
        ArmorType = "Shirt",
        Image = {
            Default = "rbxassetid://14654791246"
        },
        Resistances = {
            Heat = 0,
            Cold = 7,
            Explosive = 1,
            Radiation = 2,
            Animal = 3,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 5,
                Melee = 10
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Cloth Shirt",
        Description = "An improvised shirt made from scraps of cloth, not very effective.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 4,
        ArmorType = "Shirt",
        Image = {
            Default = "rbxassetid://14654794835",
            Ninja = "rbxassetid://107568365412229"
        },
        Resistances = {
            Heat = 0,
            Cold = 7,
            Explosive = 1,
            Radiation = 2,
            Animal = 3,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 5,
                Melee = 10
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Cloth Pants",
        Description = "An improvised pair of pants made from scraps of cloth, not very effective.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 4,
        ArmorType = "Pants",
        Image = {
            Default = "rbxassetid://14654794952",
            Ninja = "rbxassetid://88014133756226"
        },
        Resistances = {
            Heat = 0,
            Cold = 7,
            Explosive = 1,
            Radiation = 2,
            Animal = 3,
            Legs = {
                Bullet = 5,
                Melee = 10
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Cloth Footwraps",
        Description = "An improvised pair of feet wraps made from scraps of cloth, not very effective.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 4,
        ArmorType = "Boots",
        Image = {
            Default = "rbxassetid://14654794730",
            Ninja = "rbxassetid://132892877448790"
        },
        Resistances = {
            Heat = 0,
            Cold = 3,
            Explosive = 0,
            Radiation = 2,
            Animal = 2,
            Legs = {
                Bullet = 5,
                Melee = 5
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Leather Poncho",
        Description = "A sturdy poncho made from scraps of leather. Provides moderate protection from the elements.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 1000,
        ArmorType = "Chestplate",
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14654793821",
            Viva = "rbxassetid://16208668209",
            Pilgrim = "rbxassetid://98358561085174"
        },
        Attachments = { "Chestplate", "All" },
        Resistances = {
            Heat = 0,
            Cold = 8,
            Explosive = 5,
            Radiation = 8,
            Animal = 5,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 10,
                Melee = 30
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Leather Pants",
        Description = "A sturdy leather pants made from scraps of leather. Provides moderate protection from the elements.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 4,
        ArmorType = "Pants",
        Image = {
            Default = "rbxassetid://14654793993",
            Correctional = "rbxassetid://108412621160578"
        },
        Resistances = {
            Heat = 0,
            Cold = 4,
            Explosive = 1,
            Radiation = 2,
            Animal = 7,
            Legs = {
                Bullet = 10,
                Melee = 15
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Leather Shirt",
        Description = "A sturdy leather shirt made from scraps of leather. Provides moderate protection from the elements.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 4,
        ArmorType = "Shirt",
        Image = {
            Default = "rbxassetid://14654793568",
            Correctional = "rbxassetid://109168692318343"
        },
        Resistances = {
            Heat = 0,
            Cold = 5,
            Explosive = 1,
            Radiation = 3,
            Animal = 8,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 10,
                Melee = 15
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Leather Boots",
        Description = "A sturdy pair of leather boots made from scraps of leather. Provides moderate protection from the elements.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 4,
        ArmorType = "Boots",
        Image = {
            Default = "rbxassetid://14654794176",
            Correctional = "rbxassetid://95515905374532"
        },
        Resistances = {
            Heat = 0,
            Cold = 5,
            Explosive = 0,
            Radiation = 2,
            Animal = 4,
            Legs = {
                Bullet = 5,
                Melee = 5
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Flannel Jacket",
        Description = "A durable flannel jacket that can go overtop of your shirt. Provides moderate protection, and good warmth.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 7,
        ArmorType = "Chestplate",
        Image = {
            Default = "rbxassetid://14654794281",
            ["Snow White"] = "rbxassetid://15283151729",
            Biker = "rbxassetid://15877516070",
            Correctional = "rbxassetid://100006176575349",
            Abibas = "rbxassetid://138547747231782"
        },
        Resistances = {
            Heat = 0,
            Cold = 10,
            Explosive = 0,
            Radiation = 5,
            Animal = 7,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 15,
                Melee = 15
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Wooden Helmet",
        Description = "A primitive helmet made from scrap wood and cloth. Provides some protection to the head.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 1000,
        ArmorType = "Hat",
        HideHair = true,
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14776135648",
            ["Crimson Bunny"] = "rbxassetid://16912320885"
        },
        Attachments = { "Helmet", "All" },
        Resistances = {
            Heat = 0,
            Cold = 0,
            Explosive = 4,
            Radiation = 3,
            Animal = 5,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 15,
                Melee = 20
            }
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Wooden Chestplate",
        Description = "A primitive protective chestplate made from scrap wood and rope. Provides some protection to the chest.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 900,
        ArmorType = "Chestplate",
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14776135830",
            ["Crimson Bunny"] = "rbxassetid://16912321117"
        },
        Attachments = { "Chestplate", "All" },
        Resistances = {
            Heat = 0,
            Cold = 0,
            Explosive = 4,
            Radiation = 5,
            Animal = 5,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 10,
                Melee = 25
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Wooden Leggings",
        Description = "A primitive protective pair of wooden leggings made from wood and rope. Provides some protection to the legs.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 750,
        ArmorType = "Kilt",
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14776135514",
            ["Crimson Bunny"] = "rbxassetid://16912320687"
        },
        Attachments = { "Leggings", "All" },
        Resistances = {
            Heat = 0,
            Cold = 0,
            Explosive = 4,
            Radiation = 5,
            Animal = 5,
            Legs = {
                Bullet = 10,
                Melee = 30
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Wooden Arrow",
        Image = "rbxassetid://13981013657",
        Description = "Standard wooden arrow.",
        Type = "Ammo",
        MaxStack = 64,
        DespawnTime = 5,
        AmmoType = "Arrow",
        AmmoWheelImage = "rbxassetid://2535574992",
        AmmoStats = {
            TracerName = "WoodenArrow",
            Impact = "Stick",
            ShatterChance = 30,
            BulletSize = 0.3
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Swift Arrow",
        Image = "rbxassetid://13981013848",
        Description = "Swift arrow. Travels faster and longer distances.",
        Type = "Ammo",
        MaxStack = 64,
        DespawnTime = 5,
        AmmoType = "Arrow",
        AmmoWheelImage = "rbxassetid://2535574992",
        AmmoStats = {
            TracerName = "HVArrow",
            Impact = "Stick",
            ShatterChance = 10,
            SpeedMult = 1.25,
            RangeMult = 1.25,
            BulletSize = 0.3
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Bone Arrow",
        Image = "rbxassetid://13981013521",
        Description = "Bone arrow. Easier to hit targets for the cost of damage and velocity.",
        Type = "Ammo",
        MaxStack = 64,
        DespawnTime = 5,
        AmmoType = "Arrow",
        AmmoWheelImage = "rbxassetid://2535574992",
        AmmoStats = {
            TracerName = "BoneArrow",
            Impact = "Stick",
            ShatterChance = 30,
            SpeedMult = 0.9,
            DamageMult = 0.8,
            BleedMult = 2,
            BulletSize = 1.5
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Combustive Arrow",
        Image = "rbxassetid://13981013386",
        Description = "Combustive arrow. Explodes on impact.",
        Type = "Ammo",
        MaxStack = 64,
        DespawnTime = 5,
        AmmoType = "Arrow",
        AmmoWheelImage = "rbxassetid://2535574992",
        AmmoStats = {
            TracerName = "FireArrow",
            Impact = "FireArrow",
            SpeedMult = 0.8,
            DamageMult = 0.8,
            BulletSize = 0.3,
            Explosive = {
                Radius = 2,
                HumanoidMaxDamage = 20,
                DamagePrefix = ""
            }
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Iron Shard Hatchet",
        Description = "A crude tool made from iron shards and scraps of wood. Used for gathering wood. ",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 450,
        ItemWorth = 90,
        Image = {
            Default = "rbxassetid://15073617640",
            Fade = "rbxassetid://16663953399",
            Sawblade = "rbxassetid://18963884209",
            Leather = "rbxassetid://82373698320243"
        },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067)
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Iron Shard Pickaxe",
        Description = "A crude tool made from iron shards and scraps of wood. Used for mining.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 450,
        ItemWorth = 91,
        Image = {
            Default = "rbxassetid://15073617491",
            Fade = "rbxassetid://16663949312",
            Leather = "rbxassetid://99659875069484"
        },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067)
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Large Furnace",
        Description = "Industrial-grade Furnace designed to cook large amounts of Ores at once.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 250,
        Image = {
            Default = "rbxassetid://15133678858"
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Yellow Keycard",
        Image = "rbxassetid://15247381343",
        Description = "A Dazbog Corporation Support Personnel Yellow Keycard. Grants access to yellow restricted areas.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 4,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Purple Keycard",
        Image = "rbxassetid://15247381544",
        Description = "A Dazbog Corporation Support Personnel Purple Keycard. Grants access to purple restricted areas.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 3,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Pink Keycard",
        Image = "rbxassetid://15247381747",
        Description = "A Dazbog Corporation Support Personnel Pink Keycard. Grants access to pink restricted areas.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 25,
        MaxDurability = 2,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Small Medkit",
        Image = "rbxassetid://15086741523",
        Description = "A small medikt that grants 15 hp when used and regenerates 20 over time.",
        Type = "Tool",
        MaxStack = 2,
        DespawnTime = 15,
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        },
        ConsumableStats = {
            Health = 15,
            HQueue = 20,
            Instant = false
        }
    },
    {
        Name = "Salvaged Break Action",
        Description = "Salvaged Break Action Shotgun. Fires one shell before needing to reload.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 55,
        BaseMaxAmmo = 1,
        AmmoType = "Shell",
        ItemWorth = 100,
        Image = {
            Default = "rbxassetid://15305085935",
            Splat = "rbxassetid://15305729191",
            HotDog = "rbxassetid://15632163269",
            Boom = "rbxassetid://16823202171",
            Carrot = "rbxassetid://16917852163",
            ["Easter Wood"] = "rbxassetid://16917852163",
            Surf = "rbxassetid://17766587211"
        },
        Attachments = { "Barrel" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.1524, -0.3038, 0.5539, 0.2589, -0.9659, 0, 0.966, 0.2589, 0, 0, 0, 1),
            AutoTurret = CFrame.new(0, 0, 0) * CFrame.Angles(0, 3.141592653589793, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Buckshot",
        Image = "rbxassetid://13186566301",
        Description = "12 Gauge Buckshot, lots of power up close, not very useful at range.",
        Type = "Ammo",
        MaxStack = 64,
        DespawnTime = 15,
        AmmoType = "Shell",
        AmmoWheelImage = "rbxassetid://15635720278",
        AmmoStats = {
            TracerName = "ShotgunBullet",
            Bullets = 8,
            DamageMult = 0.25
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Slug",
        Image = "rbxassetid://13186564525",
        Description = "12 Gauge Shotgun Slug, provides extra range to shotguns, without the pellet spread.",
        Type = "Ammo",
        MaxStack = 32,
        DespawnTime = 15,
        AmmoType = "Shell",
        AmmoWheelImage = "rbxassetid://15635720278",
        AmmoStats = {
            TracerName = "RifleBullet",
            HipSpreadMult = 0.6,
            AimSpreadMult = 0.1,
            SpeedMult = 1.5,
            RangeMult = 2.5,
            GravityMult = 0.9,
            HeadshotDamageMult = 0.16666666666666666
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Combustive Buckshot",
        Image = "rbxassetid://13186565241",
        Description = "12 Gauge combustive Buckshot, shoots out incendiary pellets with a chance to leave a flame.",
        Type = "Ammo",
        MaxStack = 64,
        DespawnTime = 8,
        AmmoType = "Shell",
        AmmoWheelImage = "rbxassetid://2535574992",
        AmmoStats = {
            TracerName = "CombustiveBullet",
            Bullets = 8,
            DamageMult = 0.35,
            Incendiary = {
                Chance = 0.6666666666666666,
                Damage = 1.5,
                Radius = 2.25,
                Duration = 10,
                FireLevel = 1
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Steel Helmet",
        Description = "A protective helmet made from Steel metal. Provides excellent protection to the head.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 40,
        MaxDurability = 2000,
        ItemWorth = 255,
        ArmorType = "Helmet",
        HideHair = true,
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14654791532",
            Golden = "rbxassetid://15305714913",
            Frosty = "rbxassetid://15305683226",
            OBEY = "rbxassetid://15305695029",
            VIP = "rbxassetid://16014684244",
            Cardboard = "rbxassetid://15627624994",
            ["OH Deer"] = "rbxassetid://15630406001",
            Woodland = "rbxassetid://16447574211",
            ["Hot Rod"] = "rbxassetid://17768832901",
            Tyrant = "rbxassetid://109539796004549",
            Bomo = "rbxassetid://80249585885084",
            Hockey = "rbxassetid://97015125505963",
            Fear = "rbxassetid://81724456402833",
            ["Phantom Rider"] = "rbxassetid://122478227429676",
            Oni = "rbxassetid://114978122703010",
            Dune = "rbxassetid://72849082443137",
            Rogue = "rbxassetid://115980646836359"
        },
        Attachments = { "Helmet", "All" },
        Resistances = {
            Heat = -1,
            Cold = -4,
            Explosive = 8,
            Radiation = 0,
            Animal = 8,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 50,
                Melee = 30
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Steel Chestplate",
        Description = "A protective chestplate made from Steel metal. Provides excellent protection to the chest.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 40,
        MaxDurability = 1800,
        ItemWorth = 250,
        ArmorType = "Chestplate",
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14654791689",
            Frosty = "rbxassetid://15305683641",
            OBEY = "rbxassetid://15305695517",
            ["OH Deer"] = "rbxassetid://15630407338",
            Woodland = "rbxassetid://16447572145",
            ["Hot Rod"] = "rbxassetid://17768833992",
            Tyrant = "rbxassetid://140168023066476",
            ["Phantom Rider"] = "rbxassetid://116301304304192",
            Oni = "rbxassetid://126974041982300",
            Dune = "rbxassetid://105836010915280",
            Rogue = "rbxassetid://140346200597830"
        },
        Resistances = {
            Heat = -2,
            Cold = -8,
            Explosive = 6,
            Radiation = 0,
            Animal = 5,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 30,
                Melee = 15
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Attachments = { "Chestplate", "All" },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Steel Leggings",
        Description = "A protective pair of leggings made from Steel metal. Provides excellent protection to the legs.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 40,
        MaxDurability = 1600,
        ItemWorth = 245,
        ArmorType = "Kilt",
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14654791387",
            Frosty = "rbxassetid://15305684250",
            OBEY = "rbxassetid://15311675719",
            ["OH Deer"] = "rbxassetid://15630408363",
            Woodland = "rbxassetid://16447575529",
            ["Hot Rod"] = "rbxassetid://17768833765",
            Tyrant = "rbxassetid://79519920346999",
            ["Phantom Rider"] = "rbxassetid://85294785312442",
            Oni = "rbxassetid://98478307520733",
            Dune = "rbxassetid://76898574981463",
            Rogue = "rbxassetid://74157992093881"
        },
        Attachments = { "Leggings", "All" },
        Resistances = {
            Heat = -1,
            Cold = -4,
            Explosive = 5,
            Radiation = 0,
            Animal = 5,
            Legs = {
                Bullet = 25,
                Melee = 20
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Large Storage Box",
        Description = "Wooden container that can hold up to 30 items inside.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 60,
        Image = {
            Default = "rbxassetid://15094083403",
            Canvas = "rbxassetid://15283200485",
            Festive = "rbxassetid://15709683124",
            ["Industrial Guns"] = "rbxassetid://15305708083",
            ["Industrial Resources"] = "rbxassetid://15305708823",
            ["Industrial Medical"] = "rbxassetid://15305709566",
            ["Industrial Components"] = "rbxassetid://15305710817",
            ["Industrial Armor"] = "rbxassetid://15305711681",
            ["Egg Sketch"] = "rbxassetid://16916931642",
            Forged = "rbxassetid://17758887216",
            Coffin = "rbxassetid://112688458744179",
            Ouja = "rbxassetid://102172335761498",
            ["Game Buddy"] = "rbxassetid://139299560912717",
            Rogue = "rbxassetid://117769797937635"
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Salvaged Helmet",
        Description = "A protective helmet made from sheet metal. Provides moderate protection to the head.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 12,
        MaxDurability = 1500,
        ItemWorth = 115,
        ArmorType = "Helmet",
        HideHair = true,
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14654792150",
            ["Digital Snow"] = "rbxassetid://15283152199",
            ["Kill to Survive"] = "rbxassetid://15792001031",
            Cupid = "rbxassetid://16261611838",
            Tempest = "rbxassetid://18966646232",
            Cardboard = "rbxassetid://71323845635099",
            ["Elite Bunny"] = "rbxassetid://119864001362604"
        },
        Attachments = { "Helmet", "All" },
        Resistances = {
            Heat = -2,
            Cold = -5,
            Explosive = 5,
            Radiation = 5,
            Animal = 8,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 35,
                Melee = 40
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Salvaged Chestplate",
        Description = "A protective chestplate made from sheet metal. Provides moderate protection to the chest.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 12,
        MaxDurability = 1350,
        ItemWorth = 120,
        ArmorType = "Chestplate",
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14654792418",
            ["Digital Snow"] = "rbxassetid://15283152111",
            Cupid = "rbxassetid://16261611092",
            Burnout = "rbxassetid://18557168052",
            Tempest = "rbxassetid://18966646034",
            ["Elite Bunny"] = "rbxassetid://71496524358663"
        },
        Attachments = { "Chestplate", "All" },
        Resistances = {
            Heat = -2,
            Cold = -6,
            Explosive = 6,
            Radiation = 0,
            Animal = 10,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 20,
                Melee = 15
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Salvaged Leggings",
        Description = "A protective pair of leggings made from sheet metal. Provides moderate protection to the legs.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 12,
        MaxDurability = 1200,
        ItemWorth = 110,
        ArmorType = "Kilt",
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14654792046",
            ["Digital Snow"] = "rbxassetid://15283153195",
            Cupid = "rbxassetid://16261614321",
            Tempest = "rbxassetid://18966645952",
            ["Elite Bunny"] = "rbxassetid://99275929303588"
        },
        Attachments = { "Leggings", "All" },
        Resistances = {
            Heat = -2,
            Cold = -6,
            Explosive = 4,
            Radiation = 0,
            Animal = 10,
            Legs = {
                Bullet = 15,
                Melee = 20
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Military Helmet",
        Description = "A protective helmet from one of the guards on the island. Provides good protection to the head.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 30,
        MaxDurability = 1800,
        ArmorType = "Helmet",
        HideHair = true,
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14654793165",
            Nutcracker = "rbxassetid://80633563389909",
            Pilot = "rbxassetid://114197191915930",
            Medal = "rbxassetid://108938282129584"
        },
        Attachments = { "Helmet", "All" },
        Resistances = {
            Heat = -1,
            Cold = -4,
            Explosive = 7,
            Radiation = 0,
            Animal = 7,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 45,
                Melee = 35
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Military Chestplate",
        Description = "A protective chesplate from one of the guards on the island. Provides good protection to the chest.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 12,
        MaxDurability = 1700,
        ArmorType = "Chestplate",
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14654793303",
            Nutcracker = "rbxassetid://70853333750344",
            Pilot = "rbxassetid://110806561416713",
            Medal = "rbxassetid://81188910996008"
        },
        Attachments = { "Chestplate", "All" },
        Resistances = {
            Heat = -1,
            Cold = -6,
            Explosive = 4,
            Radiation = 0,
            Animal = 4,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 25,
                Melee = 15
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Military Leggings",
        Description = "A protective pair of leggings from one of the guards on the island. Provides good protection to the legs.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 12,
        MaxDurability = 1500,
        ArmorType = "Kilt",
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://14654792938",
            Nutcracker = "rbxassetid://84566720271674",
            Brutus = "rbxassetid://75512320758936",
            Tundra = "rbxassetid://86308809791688",
            Cryo = "rbxassetid://88056077715569",
            Medal = "rbxassetid://136956516639652"
        },
        Attachments = { "Leggings", "All" },
        Resistances = {
            Heat = -1,
            Cold = -5,
            Explosive = 4,
            Radiation = 0,
            Animal = 4,
            Legs = {
                Bullet = 20,
                Melee = 20
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Hard Hat",
        Description = "A simple hard hat to protect your head.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 8,
        MaxDurability = 1250,
        ArmorType = "Hat",
        MaxAttachments = 1,
        HideHair = true,
        Image = {
            Default = "rbxassetid://14654794545",
            Slurpee = "rbxassetid://15950562586"
        },
        Attachments = { "Helmet", "All" },
        Resistances = {
            Heat = 0,
            Cold = 3,
            Explosive = 7,
            Radiation = 4,
            Animal = 7,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 20,
                Melee = 30
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Balaclava",
        Description = "A handmade balaclava. Keeps you warm and provides some protection.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 5,
        ArmorType = "Face",
        HideHair = true,
        Image = {
            Default = "rbxassetid://14654791788",
            Jester = "rbxassetid://15344534842",
            Frankenstein = "rbxassetid://15883389666",
            ["Crimson Bunny"] = "rbxassetid://16912319678",
            Independence = "rbxassetid://18341880885",
            Digital = "rbxassetid://18965910197",
            Jolly = "rbxassetid://129387971218495",
            Skull = "rbxassetid://139941774966045",
            Monkey = "rbxassetid://74568523494874"
        },
        Resistances = {
            Heat = 0,
            Cold = 11,
            Explosive = 3,
            Radiation = 3,
            Animal = 3,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 10,
                Melee = 15
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Cloth Headwrap",
        Description = "A headwrap made from cloth. Keeps you warm and provides a little bit of protection.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 5,
        ArmorType = "Helmet",
        HideHair = true,
        Image = {
            Default = "rbxassetid://14654795058",
            Ninja = "rbxassetid://120080222783269"
        },
        Resistances = {
            Heat = 0,
            Cold = 7,
            Explosive = 1,
            Radiation = 2,
            Animal = 3,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 10,
                Melee = 15
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Baseball Cap",
        Description = "A baseball cap. Baseball players wear these, not people fighting for their lives.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 5,
        ArmorType = "Hat",
        HideHair = true,
        Image = {
            Default = "rbxassetid://14654795325",
            Quack = "rbxassetid://16208669800",
            Independence = "rbxassetid://18341880766",
            Propeller = "rbxassetid://115535550124192",
            Pilgrim = "rbxassetid://132977576727336"
        },
        Resistances = {
            Heat = 0,
            Cold = 5,
            Explosive = 1,
            Radiation = 1,
            Animal = 3,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 5,
                Melee = 10
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Salvaged Gloves",
        Description = "A pair of sheet metal gloves. Provides moderate proection.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 10,
        ArmorType = "Gloves",
        MaxDurability = 1200,
        Image = {
            Default = "rbxassetid://14654792260",
            ["Digital Snow"] = "rbxassetid://15283152030",
            Cupid = "rbxassetid://16261613114",
            Tempest = "rbxassetid://18971460487"
        },
        Resistances = {
            Heat = 0,
            Cold = -5,
            Explosive = 3,
            Radiation = 4,
            Animal = 10,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 10,
                Melee = 15
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Cloth Handwraps",
        Description = "A pair of cloth handwraps. Provides a bit of warmth, not much else.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 3,
        ArmorType = "Gloves",
        Image = {
            Default = "rbxassetid://14654831164",
            Ninja = "rbxassetid://114878511497747"
        },
        Resistances = {
            Heat = 0,
            Cold = 4,
            Explosive = 0,
            Radiation = 3,
            Animal = 2,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 5
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Military Gloves",
        Description = "A pair of sturdy military gloves. Provides excellent protection.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 15,
        ArmorType = "Gloves",
        Image = {
            Default = "rbxassetid://14654794652",
            Nutcracker = "rbxassetid://118158228480821",
            Arctic = "rbxassetid://76148467345468",
            Pilot = "rbxassetid://127212715621154",
            Grim = "rbxassetid://123472167772965",
            Medal = "rbxassetid://137375914230135"
        },
        Resistances = {
            Heat = 0,
            Cold = 7,
            Explosive = 2,
            Radiation = 6,
            Animal = 4,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 10,
                Melee = 10
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Leather Gloves",
        Description = "A pair of leather gloves. Provides a bit of warmth, and a small amount of protection.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 8,
        ArmorType = "Gloves",
        Image = {
            Default = "rbxassetid://14654794097",
            Correctional = "rbxassetid://92980178755471",
            Noir = "rbxassetid://107804982630320"
        },
        Resistances = {
            Heat = 0,
            Cold = 5,
            Explosive = 2,
            Radiation = 4,
            Animal = 3,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 5,
                Melee = 5
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Wetsuit",
        Description = "A wetsuit. Keeps water trapped against your body to provide heat.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 10,
        ArmorType = "Wetsuit",
        Attribute = "ResistWet",
        Image = {
            Default = "rbxassetid://15304093679",
            Pink = "rbxassetid://17363544575",
            Frog = "rbxassetid://80603678790020",
            ["Lady Bug"] = "rbxassetid://98332102346223"
        },
        Resistances = {
            Heat = 0,
            Cold = 10,
            Explosive = 1,
            Radiation = 20,
            Animal = 2,
            Legs = {
                Bullet = 10,
                Melee = 10
            },
            Chest = {
                Bullet = 10,
                Melee = 10
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Flippers",
        Image = "rbxassetid://13843003596",
        Description = "A pair of flippers. Hard to walk with these on, but lets you swim alot faster.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 10,
        ArmorType = "Boots",
        Attribute = "HasFlippers",
        Resistances = {
            Heat = 0,
            Cold = 0,
            Explosive = 0,
            Radiation = 0,
            Animal = 0,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Diving Tank",
        Image = "rbxassetid://13843003364",
        Description = "A diving tank. Used for breathing underwater.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 10,
        ArmorType = "Chestplate",
        MaxDurability = 800,
        Attribute = "HasTank",
        MaxAttachments = 1,
        Attachments = { "Chestplate", "All" },
        Resistances = {
            Heat = 0,
            Cold = 0,
            Explosive = 0,
            Radiation = 0,
            Animal = 0,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Diving Goggles",
        Image = "rbxassetid://13842989638",
        Description = "A pair of diving goggles. Used to see better underwater.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 10,
        ArmorType = "Helmet",
        Attribute = "HasGoggles",
        Resistances = {
            Heat = 0,
            Cold = 0,
            Explosive = 0,
            Radiation = 0,
            Animal = 0,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Cooking Pot",
        Description = "An upgraded Campfire that allows for more efficient food cooking.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 20,
        Image = {
            Default = "rbxassetid://15127562373"
        },
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Ladder",
        Description = "Can be placed to climb over structures.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 20,
        Image = {
            Default = "rbxassetid://15127607098"
        },
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Chocolate Bar",
        Image = "rbxassetid://14162884792",
        Description = "A nicely wrapped chocolate bar.",
        Type = "Consumable",
        MaxStack = 10,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 2,
            HQueue = 0,
            Hunger = 15,
            Thirst = -1,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Bean Can",
        Image = "rbxassetid://14162885124",
        Description = "An unopened can of beans ready to be eaten. Provides a moderate amount of nutrition.",
        Type = "Consumable",
        MaxStack = 10,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 0,
            HQueue = 0,
            Hunger = 15,
            Thirst = 3,
            Instant = true,
            Returns = { "ItemDrops", "Empty Can" }
        },
        Sounds = {
            Drag = "CannedPickup",
            Drop = "CannedDrop"
        }
    },
    {
        Name = "Meatball Can",
        Image = "rbxassetid://14162884362",
        Description = "A large unopened can of meatballs ready to be eaten. Provides a great amount of nutrition.",
        Type = "Consumable",
        MaxStack = 10,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 0,
            HQueue = 5,
            Hunger = 20,
            Thirst = 2,
            Instant = true,
            Returns = { "ItemDrops", "Empty Can" }
        },
        Sounds = {
            Drag = "CannedPickup",
            Drop = "CannedDrop"
        }
    },
    {
        Name = "Fish Can",
        Image = "rbxassetid://14162884523",
        Description = "An unopened can of meatballs ready to be eaten. Provides a moderate amount of nutrition.",
        Type = "Consumable",
        MaxStack = 10,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 2,
            HQueue = 0,
            Hunger = 10,
            Thirst = 6,
            Instant = true,
            Returns = { "ItemDrops", "Empty Can" }
        },
        Sounds = {
            Drag = "CannedPickup",
            Drop = "CannedDrop"
        }
    },
    {
        Name = "Water Bottle",
        Image = "rbxassetid://14162884193",
        Description = "Hopefully nobody drank from this.",
        Type = "Consumable",
        MaxStack = 5,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 0,
            HQueue = 0,
            Hunger = 0,
            Radiation = -30,
            Thirst = 36,
            Instant = true
        },
        Sounds = {
            Drag = "LiquidPickup",
            Drop = "LiquidDrop"
        }
    },
    {
        Name = "Piercing Heavy Ammo",
        Image = "rbxassetid://13186565419",
        Description = "Pierces through armor for the cost of less bleed and range. Can ignite when hitting hard surfaces.",
        Type = "Ammo",
        MaxStack = 128,
        DespawnTime = 30,
        AmmoType = "Rifle",
        AmmoWheelImage = "rbxassetid://2535574992",
        AmmoStats = {
            TracerName = "RifleBullet",
            Impact = "Pierce",
            RangeMult = 0.7,
            ArmorPenMult = 0.75,
            BleedMult = 0.5,
            MuzzleDurability = 2
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Piercing Light Ammo",
        Image = "rbxassetid://13186588755",
        Description = "Pierces through armor for the cost of less bleed and range. Can ignite when hitting hard surfaces.",
        Type = "Ammo",
        MaxStack = 128,
        DespawnTime = 25,
        AmmoType = "Pistol",
        AmmoWheelImage = "rbxassetid://15635709508",
        AmmoStats = {
            TracerName = "RifleBullet",
            Impact = "Pierce",
            RangeMult = 0.7,
            ArmorPenMult = 0.75,
            BleedMult = 0.5,
            MuzzleDurability = 2
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Semi Receiver",
        Image = "rbxassetid://14651116315",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 10,
        DespawnTime = 15,
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "SMG Receiver",
        Image = "rbxassetid://14651115848",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 10,
        DespawnTime = 25,
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Rifle Receiver",
        Image = "rbxassetid://14651117496",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 10,
        DespawnTime = 30,
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Steel Shovel",
        Description = "Melee tool. Can dig up trash piles faster than doing it by hand.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 600,
        ItemWorth = 90,
        Image = {
            Default = "rbxassetid://15074351964",
            ["Heart of Spades"] = "rbxassetid://113366819252362"
        },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067)
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Empty Can",
        Image = "rbxassetid://14594762895",
        Description = "An empty can. Can be smelted in a Campfire or Cooking Pot for Iron Shards.",
        Type = "Misc",
        MaxStack = 5,
        DespawnTime = 3,
        Sounds = {
            Drag = "CannedPickup",
            Drop = "CannedDrop"
        },
        SmeltInfo = {
            Amount = 1,
            Time = 15,
            LootTable = { "Smelt", "Campfire", "Empty Can" }
        }
    },
    {
        Name = "Care Package Signal",
        Image = "rbxassetid://15128007999",
        Description = "Throwable grenade that signals a Care Package to be dropped at its location when thrown.",
        Type = "Tool",
        MaxStack = 5,
        DespawnTime = 15,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Duct Tape",
        Image = "rbxassetid://14651118525",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 20,
        DespawnTime = 10,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Glue",
        Image = "rbxassetid://14651236358",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 50,
        DespawnTime = 5,
        Sounds = {
            Drag = "LiquidPickup",
            Drop = "LiquidDrop"
        }
    },
    {
        Name = "Pistol Receiver",
        Image = "rbxassetid://14651117642",
        Description = "A crafting component found in the world. Crafting material.",
        Type = "Misc",
        MaxStack = 10,
        DespawnTime = 8,
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Salvaged Shovel",
        Image = "rbxassetid://15074352064",
        Description = "Melee tool. Can dig up trash piles faster than doing it by hand.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 200,
        ItemWorth = 90,
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067)
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "ez shovel",
        Image = "rbxassetid://13877485530",
        Description = "One shovel to rule them all",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 1,
        Hidden = true,
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Anvil",
        Image = "rbxassetid://15082009292",
        Description = "Workbench specialized for crafting tools, guns, and weapons.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 100,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Chemistry Lab",
        Image = "rbxassetid://15074207343",
        Description = "Industrial workbench specialized for crafting explosives and raiding equipment.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 200,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Carpentry Table",
        Image = "rbxassetid://15082010398",
        Description = "Workbench specialized for crafting other benches and base-building commodities.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 100,
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Sewing Table",
        Image = "rbxassetid://15061609510",
        Description = "Workbench specialized for crafting clothes and armor.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 50,
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Ammo Press",
        Image = "rbxassetid://15061609857",
        Description = "Workbench specialized for crafting Gunpowder and ammunition.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 150,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Culinary Table",
        Image = "rbxassetid://15061609707",
        Description = "Workbench specialized for crafting medical stuff and food.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 250,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Petroleum Refinery",
        Description = "Industrial-grade refinery used to convert Petroleum into Crude Fuel.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 250,
        Image = {
            Default = "rbxassetid://15304104065"
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Triangle Trap Door",
        Description = "Open or close a hatch for easy access to upwards areas. Immune to fire attacks.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 150,
        Image = {
            Default = "rbxassetid://13724822281"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Military AA12",
        Description = "Automatic firing shotgun with decent magazine capacity. Deadly at close ranges.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 30,
        MaxDurability = 150,
        BaseMaxAmmo = 10,
        AmmoType = "Shell",
        ItemWorth = 525,
        Image = {
            Default = "rbxassetid://15068791139",
            ["Red Tiger"] = "rbxassetid://16485447561",
            Zombie = "rbxassetid://17199281354",
            Monster = "rbxassetid://136853604493538"
        },
        Attachments = { "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.1524, -0.3038, 0.5539, 0.2589, -0.9659, 0, 0.966, 0.2589, 0, 0, 0, 1),
            AutoTurret = CFrame.new(0.65, 0, 0) * CFrame.Angles(0, 0, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Repair Table",
        Description = "A Table that allows for repairing and re-skinning of items.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 100,
        Image = {
            Default = "rbxassetid://15283452092"
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Salvaged Pump Action",
        Description = "Pump action, tube fed, shotgun made from some pipes. Slow to shoot.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 100,
        BaseMaxAmmo = 5,
        AmmoType = "Shell",
        ItemWorth = 205,
        Image = {
            Default = "rbxassetid://15092313032",
            ["Gold Ripple"] = "rbxassetid://15444464740",
            ["Red Tiger"] = "rbxassetid://15792000933",
            ["Joe Skeleton"] = "rbxassetid://16828401186",
            Cyber = "rbxassetid://91058444899439",
            Flurry = "rbxassetid://138789905852084"
        },
        Attachments = { "Barrel", "Sight" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.5807, -0.0974, 0.5802, -0.7071, -0.7071, 0, -0.7071, 0.7072, 0, 0, 0, -1),
            ArmorStand = CFrame.new(0, 0.1, -0.6) * CFrame.Angles(0, -1.5707963267948966, 0),
            AutoTurret = CFrame.new(0.65, 0, 0) * CFrame.Angles(0, 3.141592653589793, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Bed",
        Description = "Beds are used as a respawn point on the map that are faster than sleeping bags. Beds placed too close to one another will share the same cooldown.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 100,
        Image = {
            Default = "rbxassetid://15368539842",
            Pixel = "rbxassetid://125567129432156"
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Wooden Spikes",
        Image = "rbxassetid://15380989444",
        Description = "Wooden Spikes that can be placed outside or on your base to further prevent intruders.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 60,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Military ACOG Sight",
        Image = "rbxassetid://15373701079",
        Description = "Military-grade Advanced Combat Optical Gunsight. Provides 2x zoom augmentation.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 40,
        AttachmentType = "Sight",
        AttachmentStats = {
            ZoomLevel = 2.05,
            AimSpreadMult = -0.2,
            GunRecoilAimMult = -0.4
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Metal Barricade",
        Image = "rbxassetid://15380991275",
        Description = "A metal barricade that can protect you from bullets. Placed down on terrain or on your base.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 60,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Military M4A1",
        Description = "Good damage, fast firerate, and average range. Uses Heavy Ammo.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 45,
        MaxDurability = 675,
        BaseMaxAmmo = 30,
        AmmoType = "Rifle",
        ItemWorth = 530,
        Image = {
            Default = "rbxassetid://15346201415",
            ["Cherry Blossom"] = "rbxassetid://15509842541",
            Syntax = "rbxassetid://15951831122",
            Monster = "rbxassetid://16663261126",
            Toy = "rbxassetid://17521734560",
            Independence = "rbxassetid://18341881006",
            Phantom = "rbxassetid://139190777075295",
            Nutcracker = "rbxassetid://136729540441664",
            Medusa = "rbxassetid://101267874762837",
            ["Spring Lily"] = "rbxassetid://117935810694220",
            Cryo = "rbxassetid://94745687589547",
            CyberPop = "rbxassetid://101893225757265",
            Banana = "rbxassetid://90449610336629"
        },
        Attachments = { "Sight", "Muzzle", "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.2142, -0.066, 0.6367, 0.6097, -0.7926, 0, 0.7927, 0.6097, 0, 0, 0, 1)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Small Wooden Sign",
        Image = "rbxassetid://15509119765",
        Description = "A small wooden sign which you can write some text on, or put an image using the Image Frames Gamepass.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        MaxDurability = 10,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Large Wooden Sign",
        Image = "rbxassetid://15509119053",
        Description = "A large wooden sign which you can write a lot of text on, or put an image using the Image Frames Gamepass.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        MaxDurability = 30,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Storage Cabinet",
        Description = "Wooden Cabinet that can hold up to 48 items inside.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 90,
        Image = {
            Default = "rbxassetid://15572100650",
            Monster = "rbxassetid://15631715604",
            Hades = "rbxassetid://16293483340",
            Tyrant = "rbxassetid://125396135034194",
            ["Gift Wrap"] = "rbxassetid://118868800240580",
            Server = "rbxassetid://83936574533516",
            ["Winter Wrap"] = "rbxassetid://91326939040045",
            ["Neon Comps"] = "rbxassetid://137890598897098",
            ["Neon Ore"] = "rbxassetid://117037924484110",
            ["Neon Wood"] = "rbxassetid://113647648471288",
            ["Neon Guns"] = "rbxassetid://96393837052071",
            ["Neon Armor"] = "rbxassetid://89173492679105",
            ["Neon Meds"] = "rbxassetid://123483791358250",
            ["Neon Tools"] = "rbxassetid://138360879416940",
            ["Neon Boom"] = "rbxassetid://92352079720786",
            ["Neon Food"] = "rbxassetid://102242543665645"
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "External Stone Gate",
        Image = "rbxassetid://14134361372",
        Description = "Barbed stone gate that can be placed outside your base to further prevent intruders.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 500,
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Bone Tool",
        Description = "All in one primitive tool.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 200,
        ItemWorth = 19,
        Image = {
            Default = "rbxassetid://15510368323"
        },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067)
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Salvaged Skorpion",
        Description = "Fully automatic, fast firing with a lot of spread and medium damage. Small magazine size though. Uses Light Ammo.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 25,
        MaxDurability = 300,
        BaseMaxAmmo = 15,
        AmmoType = "Pistol",
        ItemWorth = 150,
        Image = {
            Default = "rbxassetid://15369212859",
            Gingerbread = "rbxassetid://15637191692",
            Superior = "rbxassetid://15950161435",
            Pegasus = "rbxassetid://16577230942",
            Surge = "rbxassetid://18149214997",
            Rusty = "rbxassetid://87710451691684",
            Comic = "rbxassetid://103323135308928",
            Celestial = "rbxassetid://102882157920367",
            ["Cyber Revenge"] = "rbxassetid://112592127248445",
            Surplus = "rbxassetid://129262805599287"
        },
        Attachments = { "Sight", "Muzzle" },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(1.0317, -0.2614, -0.034, 0, 0, 1, -0.9848, 0.1737, 0, -0.1736, -0.9848, 0),
            AutoTurret = CFrame.new(0.65, 0, 0) * CFrame.Angles(0, 0, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Candy Cane",
        Description = "Tool for hitting gifts.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 175,
        ItemWorth = 18,
        Image = {
            Default = "rbxassetid://15633196493"
        },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067)
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Christmas Tree",
        Description = "A very decorated Christmas tree. You can place it in your base, and if you decorate it with an ornament, Santa may bring you gifts.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 90,
        Image = {
            Default = "rbxassetid://15634564093"
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Santa Hat",
        Description = "A little present from santa.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 2,
        ArmorType = "Hat",
        HideHair = true,
        Image = {
            Default = "rbxassetid://15636087096"
        },
        Resistances = {
            Heat = 0,
            Cold = 2,
            Explosive = 1,
            Radiation = 1,
            Animal = 1,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 5
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "External Stone Wall",
        Image = "rbxassetid://15709318091",
        Description = "Barbed stone wall that can be placed outside your base to further prevent intruders.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 500,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Blast Furnace",
        Description = "Industrial-grade Furnace designed to smelt fast and large amounts of Ores at once.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 150,
        Image = {
            Default = "rbxassetid://15876671239",
            Robot = "rbxassetid://18149216269",
            Steampunk = "rbxassetid://113856439034974"
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Military Barrett",
        Description = "Heavy but slow shooting rifle. Very powerful at long distances.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 75,
        BaseMaxAmmo = 5,
        AmmoType = "Rifle",
        ItemWorth = 800,
        Image = {
            Default = "rbxassetid://15346280030",
            Surge = "rbxassetid://15876918136",
            Leprechaun = "rbxassetid://16751857511",
            Mystra = "rbxassetid://98792148092190",
            Fade = "rbxassetid://73907766386158",
            Molten = "rbxassetid://103075738835660",
            Cryo = "rbxassetid://124741300378620",
            Ghillie = "rbxassetid://83691565477213"
        },
        Attachments = { "Sight", "Muzzle", "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(1.2965, 0.6657, 0.6881, 0, -0.8742, -0.4854, 0, 0.4855, -0.8742, 1, 0, 0),
            ArmorStand = CFrame.new(0, -0.2, 1.25) * CFrame.Angles(0, 3.141592653589793, 0),
            AutoTurret = CFrame.new(0.65, 0, 0) * CFrame.Angles(0, 1.5707963267948966, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Shotgun Turret",
        Image = "rbxassetid://16009975774",
        Description = "Primitive shotgun turret that fires Shotgun ammo at unauthorized players. Only works under a Base Cabinet. Can only face a single direction.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 60,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Military Grenade",
        Image = "rbxassetid://15444535479",
        Description = "A good explosive for damaging other players. Not effective at destroying structures.",
        Type = "Tool",
        MaxStack = 5,
        DespawnTime = 15,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Floor Grill",
        Image = "rbxassetid://15853202987",
        Description = "Placed in floor frames. Useful for keeping intruders out of furnace bases.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 150,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Bear Trap",
        Image = "rbxassetid://16283811174",
        Description = "Manually-armed trap that deals lots of damage when stepped on.",
        Type = "Bench",
        MaxStack = 5,
        DespawnTime = 10,
        MaxDurability = 15,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Landmine Trap",
        Image = "rbxassetid://16283811057",
        Description = "Touch-triggered explosive trap. Explodes when steppd off of. Can be picked up when stood on.",
        Type = "Bench",
        MaxStack = 5,
        DespawnTime = 10,
        MaxDurability = 5,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Saw Bat",
        Image = "rbxassetid://16249771997",
        Description = "A baseball bat with a saw blade bolted to it. Great melee weapon.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 600,
        ItemWorth = 95,
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.1204, -0.0661, 0.6012, 0, -0.8286, -0.5597, 0, 0.5598, -0.8286, 1, 0, 0)
        },
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Machete",
        Description = "A salvaged machete made from scrap iron. Mid-tier melee weapon",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 400,
        ItemWorth = 31,
        Image = {
            Default = "rbxassetid://16249771824",
            Rainbow = "rbxassetid://16823202004",
            Crimson = "rbxassetid://16912320468",
            Foam = "rbxassetid://18761536955",
            Oni = "rbxassetid://84793810931259"
        },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(-1.0091, -0.0037, 0.1799, 1, 0, 0, 0, -0.9317, 0.3631, 0, -0.363, -0.9317)
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Military PKM",
        Description = "Heavy slow shooting LMG. Good damage and average range. Uses Heavy Ammo",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 900,
        BaseMaxAmmo = 75,
        AmmoType = "Rifle",
        ItemWorth = 800,
        Image = {
            Default = "rbxassetid://16471125314",
            Woodland = "rbxassetid://16471122135",
            ["Digital Red"] = "rbxassetid://16828755578",
            Resistance = "rbxassetid://18149212335",
            Turbo = "rbxassetid://18950918343",
            ["Anime Sketch"] = "rbxassetid://90293792623916",
            ["Anime Waifu"] = "rbxassetid://102634442832437",
            Bling = "rbxassetid://83175562460125",
            Cryptid = "rbxassetid://98359394317755"
        },
        Attachments = { "Sight", "Muzzle", "Barrel" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.0871, -0.4001, 0.8196, -0.5578, -0.8299, 0, -0.8299, 0.5579, 0, 0, 0, -1),
            ArmorStand = CFrame.new(0, 0.1, 0.3) * CFrame.Angles(0, -1.5707963267948966, 0),
            AutoTurret = CFrame.new(0, 0, 0) * CFrame.Angles(0, 3.141592653589793, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Bruno\'s ACOG Sight",
        Image = "rbxassetid://16671196298",
        Description = "Military-grade Advanced Combat Optical Gunsight. Provides 2x zoom augmentation. Used by Bruno.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 40,
        AttachmentType = "Sight",
        AttachmentStats = {
            ZoomLevel = 2.05,
            AimSpreadMult = -0.2,
            GunRecoilAimMult = -0.4
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Military Lasersight",
        Image = "rbxassetid://15510372535",
        Description = "Barrel attachment. Greatly lowers spread and aim sway when toggled.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 40,
        AttachmentType = "Barrel",
        AttachmentStats = {
            Toggle = true,
            HipSpreadMult = -0.4,
            AimSpreadMult = -0.35,
            SwayMult = -0.97
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Bruno\'s M4A1",
        Description = "Good damage, fast firerate, and average range. Uses Heavy Ammo. Has been modified with some attachments giving better stats.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 45,
        MaxDurability = 675,
        BaseMaxAmmo = 30,
        AmmoType = "Rifle",
        ItemWorth = 600,
        Image = {
            Default = "rbxassetid://15574295393"
        },
        Attachments = { "Sight", "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.2142, -0.066, 0.6367, 0.6097, -0.7926, 0, 0.7927, 0.6097, 0, 0, 0, 1)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Boss Chestplate",
        Description = "A protective Chestplate dropped from one of the many Bosses in this island. Provides excellent protection to the chest.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 40,
        MaxDurability = 1800,
        ArmorType = "Chestplate",
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://16652581317",
            ["Bruno Tundra"] = "rbxassetid://92200143576210",
            Cryo = "rbxassetid://106187507956822",
            Blackwidow = "rbxassetid://120371980580928",
            Boris = "rbxassetid://18354053691",
            ["Boris Abibas"] = "rbxassetid://137740231154465",
            Brutus = "rbxassetid://120699966211693"
        },
        Attachments = { "Chestplate", "All" },
        Resistances = {
            Heat = -1,
            Cold = -5,
            Explosive = 9,
            Radiation = 2,
            Animal = 8,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 30,
                Melee = 25
            },
            Head = {
                Bullet = 0,
                Melee = 0
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Boss Helmet",
        Description = "A protective Helmet dropped from one of the many Bosses in this island. Provides excellent protection to the head.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 40,
        MaxDurability = 2000,
        ArmorType = "Helmet",
        HideHair = true,
        ItemWorth = 550,
        MaxAttachments = 2,
        Image = {
            Default = "rbxassetid://16652579167",
            ["Bruno Tundra"] = "rbxassetid://106377950808399",
            Cryo = "rbxassetid://102872157681930",
            Blackwidow = "rbxassetid://82474893491255",
            Boris = "rbxassetid://18312187080",
            ["Boris Abibas"] = "rbxassetid://18450404634",
            ["Boris Carbon"] = "rbxassetid://106169002653059",
            ["Boris Sky"] = "rbxassetid://140423012958795",
            Brutus = "rbxassetid://134265072222654"
        },
        Attachments = { "Helmet", "All" },
        Resistances = {
            Heat = -2,
            Cold = -5,
            Explosive = 10,
            Radiation = 2,
            Animal = 9,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 50,
                Melee = 40
            }
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Bunny Ears",
        Description = "A little hat from the Easter Bunny!",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 2,
        ArmorType = "Hat",
        HideHair = false,
        Image = {
            Default = "rbxassetid://16916795577"
        },
        Resistances = {
            Heat = 0,
            Cold = 2,
            Explosive = 1,
            Radiation = 1,
            Animal = 1,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 5
            }
        },
        Sounds = {
            Drag = "ClothingPickup",
            Drop = "ClothingDrop"
        }
    },
    {
        Name = "Carrot Blade",
        Description = "A sharpened carrot. Used as a melee weapon",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 175,
        ItemWorth = 18,
        Image = {
            Default = "rbxassetid://16916703095"
        },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(-0.9139, -0.3766, 0.1413, -0.2364, -0.1052, 0.966, 0.9577, 0.1431, 0.2501, -0.1644, 0.9842, 0.067)
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Metal Spikes",
        Image = "rbxassetid://16484592502",
        Description = "Reinforced Metal Spikes that can be placed outside or on your base to further prevent intruders. Very resilient.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 10,
        MaxDurability = 150,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Rug",
        Description = "Comfy house rug that gives Comfort when nearby.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        MaxDurability = 5,
        Image = {
            Default = "rbxassetid://17205250687",
            Kraken = "rbxassetid://17518134457",
            Independence = "rbxassetid://18341881393",
            ["Chinese Dragon"] = "rbxassetid://71202563952285",
            ["Jolly Rogers"] = "rbxassetid://104276123436561",
            ["Christmas Knit"] = "rbxassetid://90714037219162"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Shop Machine",
        Description = "An automated electronic shop that allows you to sell your goods to other players. Requires Base Cabinet authorization to open.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 750,
        Image = {
            Default = "rbxassetid://16769451135"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Chainsaw",
        Description = "A very fast and effective tool used for harvesting trees. Uncraftable.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 2500,
        ItemWorth = 110,
        Image = {
            Default = "rbxassetid://17201657737",
            Recycle = "rbxassetid://17357130465"
        },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.1497, 0.6944, 0.8864, 0, -0.9031, 0.4293, 0, 0.4293, 0.9032, -1, 0, 0)
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Mining Drill",
        Description = "A very fast and effective drill used for mining. Uncraftable.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 2500,
        ItemWorth = 111,
        Image = {
            Default = "rbxassetid://17287978593",
            Recycle = "rbxassetid://17357129069",
            Brick = "rbxassetid://111424776562874"
        },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.4287, 0.3697, 0.5869, -0.4168, 0, 0.909, -0.9089, 0, -0.4168, 0, -1, 0)
        },
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Extended Mag",
        Image = "rbxassetid://17286302189",
        Description = "Magazine attachment. Increases maximum magazine capacity on your weapon.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 20,
        AttachmentType = "Magazine",
        AttachmentStats = {
            MaxAmmoMult = 0.2
        },
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Jukebox",
        Description = "A music player that can be placed in authorized areas. Must have the Fallen UGC Jukebox Backpack owned to operate. Provides comfort when nearby.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 15,
        DisableDrop = true,
        DisableContainer = true,
        Image = {
            Default = "rbxassetid://17343466496"
        },
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Wool Plant Seed",
        Image = "rbxassetid://17357235671",
        Description = "Can be planted anywhere on terrain or in specific Planter Boxes.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Wool",
        Image = "rbxassetid://17499807914",
        Description = "Balls of wool. Can be manually turned into Cloth or used at a Loom for higher Cloth yields.",
        Type = "Resource",
        MaxStack = 1000,
        DespawnTime = 5,
        SmeltInfo = {
            Amount = 4,
            Time = 4,
            LootTable = { "Smelt", "Loom", "Wool" }
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Loom",
        Image = "rbxassetid://17517380322",
        Description = "Automatically weaves Wool into Cloth, yielding more than handcrafting it.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 20,
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Small Planter Box",
        Image = "rbxassetid://17506371372",
        Description = "Allows the safe planting of up to 3 different crops. Can be placed inside bases.",
        Type = "Bench",
        MaxStack = 5,
        DespawnTime = 10,
        MaxDurability = 40,
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Large Planter Box",
        Image = "rbxassetid://17506371558",
        Description = "Allows the safe planting of up to 9 different crops. Can be placed inside bases.",
        Type = "Bench",
        MaxStack = 5,
        DespawnTime = 10,
        MaxDurability = 60,
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Tomato Plant Seed",
        Image = "rbxassetid://17357235843",
        Description = "Can be planted anywhere on terrain or in specific Planter Boxes.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Corn Plant Seed",
        Image = "rbxassetid://17357236563",
        Description = "Can be planted anywhere on terrain or in specific Planter Boxes.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Tomato",
        Image = "rbxassetid://17412555272",
        Description = "Fresh tomato ready for consumption. Average healing and nutrition.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 2,
            HQueue = 0,
            Hunger = 2,
            Thirst = 5,
            Instant = true
        },
        SmeltInfo = {
            ["Chicken House"] = {
                Amount = 1,
                Time = 500,
                LootTable = { "Smelt", "ChickenHouse", "Tomato" }
            },
            ["Cow Pasture"] = {
                Amount = 2,
                Time = 400,
                LootTable = { "Smelt", "CowPasture", "Tomato" }
            }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Corn",
        Image = "rbxassetid://17412555936",
        Description = "Fresh corn ready for consumption. Average healing and nutrition.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 0,
            HQueue = 3,
            Hunger = 5,
            Thirst = 3,
            Instant = true
        },
        SmeltInfo = {
            ["Chicken House"] = {
                Amount = 1,
                Time = 400,
                LootTable = { "Smelt", "ChickenHouse", "Corn" }
            },
            ["Cow Pasture"] = {
                Amount = 2,
                Time = 500,
                LootTable = { "Smelt", "CowPasture", "Corn" }
            }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Chicken Egg",
        Image = "rbxassetid://17497768025",
        Description = "Fresh egg hatched from a chicken. Best combined with other food to make recipes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = -1,
            HQueue = 0,
            Hunger = 3,
            Thirst = 1,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Milk",
        Image = "rbxassetid://17497767948",
        Description = "Fresh milk from a cow. Can be combined with other food to make recipes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 0,
            HQueue = 1,
            Hunger = 0,
            Thirst = 10,
            Instant = true
        },
        Sounds = {
            Drag = "LiquidPickup",
            Drop = "LiquidDrop"
        }
    },
    {
        Name = "Raspberry Pie I",
        Image = "rbxassetid://17513317601",
        Description = "Fresh baked raspberry pie. Provides a small buff to your max HP for 5 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 10,
        ConsumableStats = {
            Health = 3,
            HQueue = 1,
            Hunger = 15,
            Thirst = 0,
            Instant = true,
            Health_Buff = { 1, 300 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Raspberry Pie II",
        Image = "rbxassetid://17513317487",
        Description = "Fresh baked raspberry pie. Provides a moderate buff to your max HP for 10 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 15,
        ConsumableStats = {
            Health = 4,
            HQueue = 1,
            Hunger = 20,
            Thirst = 0,
            Instant = true,
            Health_Buff = { 2, 600 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Raspberry Pie III",
        Image = "rbxassetid://17513317352",
        Description = "Fresh baked raspberry pie. Provides a good buff to your max HP for 15 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 20,
        ConsumableStats = {
            Health = 5,
            HQueue = 1,
            Hunger = 25,
            Thirst = 0,
            Instant = true,
            Health_Buff = { 3, 900 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Raspberry Pie IV",
        Image = "rbxassetid://17513317172",
        Description = "Fresh baked raspberry pie. Provides a great buff to your max HP for 15 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 20,
        ConsumableStats = {
            Health = 6,
            HQueue = 1,
            Hunger = 30,
            Thirst = 0,
            Instant = true,
            Health_Buff = { 4, 900 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Blueberry Pie I",
        Image = "rbxassetid://17513319274",
        Description = "Fresh baked blueberry pie. Provides a small buff to your mining gather rates for 5 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 10,
        ConsumableStats = {
            Health = 3,
            HQueue = 1,
            Hunger = 15,
            Thirst = 0,
            Instant = true,
            Node_Buff = { 1, 300 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Blueberry Pie II",
        Image = "rbxassetid://17513319171",
        Description = "Fresh baked blueberry pie. Provides a moderate buff to your mining gather rates for 10 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 15,
        ConsumableStats = {
            Health = 4,
            HQueue = 1,
            Hunger = 20,
            Thirst = 0,
            Instant = true,
            Node_Buff = { 2, 600 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Blueberry Pie III",
        Image = "rbxassetid://17513318992",
        Description = "Fresh baked blueberry pie. Provides a good buff to your mining gather rates for 15 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 20,
        ConsumableStats = {
            Health = 5,
            HQueue = 1,
            Hunger = 25,
            Thirst = 0,
            Instant = true,
            Node_Buff = { 3, 900 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Blueberry Pie IV",
        Image = "rbxassetid://17513318548",
        Description = "Fresh baked blueberry pie. Provides a great buff to your mining gather rates for 15 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 20,
        ConsumableStats = {
            Health = 6,
            HQueue = 1,
            Hunger = 30,
            Thirst = 0,
            Instant = true,
            Node_Buff = { 4, 900 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Lemon Cake I",
        Image = "rbxassetid://17513316973",
        Description = "Fresh baked lemon cake. Provides a small buff to your wood harvesting gather rates for 5 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 10,
        ConsumableStats = {
            Health = 3,
            HQueue = 1,
            Hunger = 15,
            Thirst = 0,
            Instant = true,
            Wood_Buff = { 1, 300 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Lemon Cake II",
        Image = "rbxassetid://17513316847",
        Description = "Fresh baked lemon cake. Provides a moderate buff to your wood harvesting gather rates for 10 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 15,
        ConsumableStats = {
            Health = 4,
            HQueue = 1,
            Hunger = 20,
            Thirst = 0,
            Instant = true,
            Wood_Buff = { 2, 600 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Lemon Cake III",
        Image = "rbxassetid://17513316683",
        Description = "Fresh baked lemon cake. Provides a good buff to your wood harvesting gather rates for 15 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 20,
        ConsumableStats = {
            Health = 5,
            HQueue = 1,
            Hunger = 25,
            Thirst = 0,
            Instant = true,
            Wood_Buff = { 3, 900 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Lemon Cake IV",
        Image = "rbxassetid://17513316422",
        Description = "Fresh baked lemon cake. Provides a great buff to your wood harvesting gather rates for 15 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 20,
        ConsumableStats = {
            Health = 6,
            HQueue = 1,
            Hunger = 30,
            Thirst = 0,
            Instant = true,
            Wood_Buff = { 4, 900 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Corn Bread I",
        Image = "rbxassetid://17513318249",
        Description = "Fresh baked corn bread. Provides a small buff to your bottle caps harvesting gather rates from barrels for 5 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 10,
        ConsumableStats = {
            Health = 3,
            HQueue = 1,
            Hunger = 15,
            Thirst = 0,
            Instant = true,
            Caps_Buff = { 1, 300 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Corn Bread II",
        Image = "rbxassetid://17513318071",
        Description = "Fresh baked corn bread. Provides a moderate buff to your bottle caps harvesting gather rates from barrels for 10 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 15,
        ConsumableStats = {
            Health = 4,
            HQueue = 1,
            Hunger = 20,
            Thirst = 0,
            Instant = true,
            Caps_Buff = { 2, 600 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Corn Bread III",
        Image = "rbxassetid://17513317915",
        Description = "Fresh baked corn bread. Provides a good buff to your bottle caps harvesting gather rates from barrels for 15 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 20,
        ConsumableStats = {
            Health = 5,
            HQueue = 1,
            Hunger = 25,
            Thirst = 0,
            Instant = true,
            Caps_Buff = { 3, 900 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Corn Bread IV",
        Image = "rbxassetid://17513317765",
        Description = "Fresh baked corn bread. Provides a great buff to your bottle caps harvesting gather rates from barrels for 15 minutes.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 20,
        ConsumableStats = {
            Health = 6,
            HQueue = 1,
            Hunger = 30,
            Thirst = 0,
            Instant = true,
            Caps_Buff = { 4, 900 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Cow Pasture",
        Image = "rbxassetid://17499917838",
        Description = "Houses a cow, can be fed vegetables to produce milk. Favorite produce is Tomatoes.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 20,
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Chicken House",
        Image = "rbxassetid://17499918454",
        Description = "Houses a chicken, can be fed vegetables to produce eggs. Favorite produce is Corn.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 20,
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Barrel Light",
        Image = "rbxassetid://17508402018",
        Description = "Light stuff up. Crops grown in enclosed areas require light in order to grow.",
        Type = "Bench",
        MaxStack = 5,
        DespawnTime = 5,
        MaxDurability = 20,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Raspberries",
        Image = "rbxassetid://17508521640",
        Description = "Fresh raspberry ready for consumption. Low nutrition. Can be made into a dessert.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 0,
            HQueue = 0,
            Hunger = 3,
            Thirst = 1,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Blueberries",
        Image = "rbxassetid://17508520653",
        Description = "Fresh blueberry ready for consumption. Low nutrition. Can be made into a dessert.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 0,
            HQueue = 0,
            Hunger = 3,
            Thirst = 1,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Lemon",
        Image = "rbxassetid://17508522472",
        Description = "Fresh lemon ready for consumption. Low nutrition. Can be made into a dessert.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 0,
            HQueue = 0,
            Hunger = 4,
            Thirst = 2,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Lemon Plant Seed",
        Image = "rbxassetid://17357236426",
        Description = "Can be planted anywhere on terrain or in specific Planter Boxes.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Raspberry Plant Seed",
        Image = "rbxassetid://17357236197",
        Description = "Can be planted anywhere on terrain or in specific Planter Boxes.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Blueberry Plant Seed",
        Image = "rbxassetid://17357236681",
        Description = "Can be planted anywhere on terrain or in specific Planter Boxes.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Military MP7",
        Description = "Fully automatic Military MP7. Shoots light ammo at a very high fire rate.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 40,
        MaxDurability = 675,
        BaseMaxAmmo = 22,
        AmmoType = "Pistol",
        ItemWorth = 500,
        Image = {
            Default = "rbxassetid://17607841424",
            ["Dark Matter"] = "rbxassetid://17768541905",
            Fade = "rbxassetid://18764670728",
            Whiteout = "rbxassetid://112724849582854",
            Tyrant = "rbxassetid://88901653074832",
            ["Digital Tiger"] = "rbxassetid://109024303396384",
            Wave = "rbxassetid://108003941053496",
            Animeaster = "rbxassetid://137259300477168",
            Solitare = "rbxassetid://128296099845816",
            Grunge = "rbxassetid://96361565266502",
            ["Pink Plasm"] = "rbxassetid://74447782460391",
            Zap = "rbxassetid://126949129741030"
        },
        Attachments = { "Sight", "Muzzle", "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.0878, -0.111, 0.6685, 0, -0.7791, 0.6269, 0, 0.6269, 0.7792, -1, 0, 0),
            ArmorStand = CFrame.new(0, 0, -0.35),
            AutoTurret = CFrame.new(0.65, 0, 0) * CFrame.Angles(0, -1.5707963267948966, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Red Keycard",
        Image = "rbxassetid://18313788194",
        Description = "A Dazbog Corporation Support Personnel Red Keycard. Grants access to Red restricted areas.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 25,
        MaxDurability = 1,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Salvaged Double Barrel",
        Description = "Salvaged Break Action Shotgun... But with 2 barrels! Fires two shells before needing to reload.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 55,
        BaseMaxAmmo = 2,
        AmmoType = "Shell",
        ItemWorth = 150,
        Image = {
            Default = "rbxassetid://132642766917853",
            Ducky = "rbxassetid://140296796147704",
            HotDog = "rbxassetid://86842880761011"
        },
        Attachments = { "Barrel", "Sight" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.6166, 0.6879, 0.7184, 0, -0.9202, 0.3914, 0, 0.3914, 0.9203, -0.9999, 0, 0),
            AutoTurret = CFrame.new(0.65, 0, 0) * CFrame.Angles(0, -1.5707963267948966, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Military Boat",
        Image = "rbxassetid://14183996624",
        Description = "erm",
        Type = "Resource",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 200,
        Hidden = true,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Clan Table",
        Image = "rbxassetid://74442604226077",
        Description = "Clan Table for putting your Clan on the leaderboard. Only one can be placed. Must be within base cabinet authorization",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 10,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Wooden Boat",
        Image = "rbxassetid://14183996624",
        Description = "erm",
        Type = "Resource",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 100,
        Hidden = true,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Military USP",
        Description = "Semi-automatic pistol with medium range. Good firerate and damage. Uses Light Ammo.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 220,
        BaseMaxAmmo = 12,
        AmmoType = "Pistol",
        ItemWorth = 250,
        Image = {
            Default = "rbxassetid://85577075764668",
            ["Cherry Blossom"] = "rbxassetid://133722249630533",
            Fade = "rbxassetid://89094430760827",
            ["Crimson Scale"] = "rbxassetid://85217509353028",
            Azure = "rbxassetid://74032961902891",
            ["Bright Water"] = "rbxassetid://110809910409468"
        },
        Attachments = { "Sight", "Muzzle", "Barrel" },
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(1.0782, -0.1523, 0.0661, 0, 0, -0.9999, 1, 0, 0, 0, -1, 0),
            AutoTurret = CFrame.new(0.65, 0, 0) * CFrame.Angles(0, 3.141592653589793, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Common Goodie Bag",
        Image = "rbxassetid://118444522725158",
        Description = "Can be opened for low-tier loot or combined into a Rare Goodie Bag.",
        Type = "Misc",
        MaxStack = 100,
        DespawnTime = 4,
        DropInfo = {
            ButtonName = "OPEN",
            LootTable = { "ItemDrops", "Common Goodie Bag" }
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Rare Goodie Bag",
        Image = "rbxassetid://82913604650237",
        Description = "Can be opened for medium-tier loot or combined into an Epic Goodie Bag.",
        Type = "Misc",
        MaxStack = 100,
        DespawnTime = 6,
        DropInfo = {
            ButtonName = "OPEN",
            LootTable = { "ItemDrops", "Rare Goodie Bag" }
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Epic Goodie Bag",
        Image = "rbxassetid://93565798791105",
        Description = "Can be opened for high-tier loot. Highest Goodie Bag tier.",
        Type = "Misc",
        MaxStack = 10,
        DespawnTime = 8,
        DropInfo = {
            ButtonName = "OPEN",
            LootTable = { "ItemDrops", "Epic Goodie Bag" }
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Candle",
        Description = "Decorative item. Provides ambient light and can be toggled on/off.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 4,
        MaxDurability = 4,
        Image = {
            Default = "rbxassetid://117249643725742",
            Medium = "rbxassetid://108927440959870",
            Large = "rbxassetid://84899373039469"
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Armor Stand",
        Image = "rbxassetid://80529735817758",
        Description = "Can store a loadout that can easily be swapped into for quickly gearing up. Displays the loadout as well.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 60,
        Sounds = {
            Drag = "WoodPickup",
            Drop = "WoodDrop"
        }
    },
    {
        Name = "Jack-O-Lantern",
        Description = "Limited Decorative item. Provides ambient light and comfort. Can be toggled on/off.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        MaxDurability = 10,
        Image = {
            Default = "rbxassetid://139460860545325",
            Sad = "rbxassetid://101370696376275",
            Happy = "rbxassetid://130966939339167"
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Small Cobweb",
        Image = "rbxassetid://72444796789811",
        Description = "Decorative Halloween-only item. Can be placed on any surface.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 4,
        MaxDurability = 3,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Large Cobweb",
        Image = "rbxassetid://104604287353224",
        Description = "Decorative Halloween-only item. Can be placed on any surface.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 4,
        MaxDurability = 3,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Pumpkin Plant Seed",
        Image = "rbxassetid://121878490679837",
        Description = "Can be planted anywhere on terrain or in specific Planter Boxes.",
        Type = "Bench",
        MaxStack = 10,
        DespawnTime = 5,
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Pumpkin",
        Image = "rbxassetid://88626583598376",
        Description = "Spoooooky pumpkin. High nutrition. Can be made into a dessert. Or you can put it on your head.",
        Type = "ConsumableAmmoArmor",
        MaxStack = 10,
        DespawnTime = 5,
        AmmoType = "Pumpkin",
        AmmoWheelImage = "rbxassetid://84634418586788",
        ArmorType = "Helmet",
        HideHair = true,
        ConsumableStats = {
            Health = 0,
            HQueue = 2,
            Hunger = 10,
            Thirst = 3,
            Instant = true
        },
        AmmoStats = {
            TracerName = "PumpkinRegular",
            BulletSize = 1.5
        },
        Resistances = {
            Heat = 0,
            Cold = 2,
            Explosive = 1,
            Radiation = 1,
            Animal = 1,
            Legs = {
                Bullet = 0,
                Melee = 0
            },
            Chest = {
                Bullet = 0,
                Melee = 0
            },
            Head = {
                Bullet = 0,
                Melee = 5
            }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Halloween Scythe",
        Image = "rbxassetid://97593929634585",
        Description = "A limited time Halloween event scythe. Very good melee damage. And a source of light.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 500,
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Pumpkin Launcher",
        Image = "rbxassetid://119532925295032",
        Description = "Limited-time Halloween weapon. Shoots Pumpkins as ammunition.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 120,
        BaseMaxAmmo = 6,
        AmmoType = "Pumpkin",
        Attachments = {},
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.133, -0.4829, 0.6196, 0, -0.8876, 0.4605, 0, 0.4605, 0.8877, -1, 0, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Raw Wolf",
        Image = "rbxassetid://15295774046",
        Description = "Raw wolf meat. Not recommended for consumption. Cook in a campfire.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = -3,
            HQueue = 0,
            Hunger = 12,
            Thirst = 0,
            Instant = true
        },
        SmeltInfo = {
            Amount = 1,
            Time = 15,
            LootTable = { "Smelt", "Campfire", "Raw Wolf" }
        },
        Sounds = {
            Drag = "MeatPickup",
            Drop = "MeatDrop"
        }
    },
    {
        Name = "Cooked Wolf",
        Image = "rbxassetid://15295773801",
        Description = "Cooked wolf meat. Great food source.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 2,
            HQueue = 4,
            Hunger = 23,
            Thirst = 2,
            Instant = true
        },
        Sounds = {
            Drag = "MeatPickup",
            Drop = "MeatDrop"
        }
    },
    {
        Name = "Pumpkin Pie",
        Image = "rbxassetid://84895386905458",
        Description = "Fresh baked Pumpkin pie. Provides a regeneration boost when consumed.",
        Type = "Consumable",
        MaxStack = 20,
        DespawnTime = 10,
        ConsumableStats = {
            Health = 3,
            HQueue = 1,
            Hunger = 15,
            Thirst = 0,
            Instant = true,
            Regen_Buff = { 1, 120 }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Cursed Pumpkin",
        Image = "rbxassetid://74135087469069",
        Description = "Ammunition for Pumpkin Launcher. Explosive, inedible variant. Deals higher damage and explodes on impact. Limited time item.",
        Type = "Ammo",
        MaxStack = 10,
        DespawnTime = 10,
        AmmoType = "Pumpkin",
        AmmoWheelImage = "rbxassetid://84634418586788",
        AmmoStats = {
            TracerName = "PumpkinCursed",
            BulletSize = 1.5,
            Impact = "Explosion",
            FilterType = "HitIgnore",
            StepType = "",
            Explosive = {
                Radius = 4,
                HumanoidMaxDamage = 40,
                SoftSideMult = 1,
                DamagePrefix = "Cursed_",
                ShakeStrength = 0.2,
                Duration = 0.3,
                SoundName = "Pumpkin",
                Variation = "Cursed"
            }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Marsh Bar",
        Image = "rbxassetid://113016339245665",
        Description = "A nicely wrapped chocolate marsh bar.",
        Type = "Consumable",
        MaxStack = 10,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 1,
            HQueue = 2,
            Hunger = 10,
            Thirst = 0,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Peanut Butter Cup",
        Image = "rbxassetid://77624523695187",
        Description = "A nicely wrapped peanut butter cup.",
        Type = "Consumable",
        MaxStack = 10,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 1,
            HQueue = 2,
            Hunger = 10,
            Thirst = 0,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Candy Roll",
        Image = "rbxassetid://138463136634140",
        Description = "Unknown candy that has been rolled up. It tastes good atleast.",
        Type = "Consumable",
        MaxStack = 10,
        DespawnTime = 5,
        ConsumableStats = {
            Health = 1,
            HQueue = 2,
            Hunger = 10,
            Thirst = 0,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Scarecrow",
        Image = "rbxassetid://99382957417299",
        Description = "Scares birds (maybe even people) away from your crops. Limited time Halloween decoration.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 10,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Salvaged Shotgun",
        Description = "Salvaged Shotgun. Chambers any 12 Gauge shell and fires it with a fuse before needing to reload. Detonation time may vary.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 6,
        MaxDurability = 30,
        BaseMaxAmmo = 1,
        AmmoType = "Shell",
        ItemWorth = 39,
        Image = {
            Default = "rbxassetid://128621428767531",
            Banana = "rbxassetid://90420924851404",
            HotDog = "rbxassetid://94732589170018",
            Camo = "rbxassetid://85391407055752"
        },
        Attachments = {},
        WeldInfo = {
            Part = "LowerTorso",
            Offset = CFrame.new(
                -1.0793,
                -0.3047,
                0.0274,
                -0.9994,
                -0.016,
                -0.0301,
                -0.0341,
                0.4787,
                0.8774,
                0.0004,
                0.8779,
                -0.4789
            )
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Salvaged Shell",
        Image = "rbxassetid://127373719846093",
        Description = "Salvaged Shell, primitive shotgun ammo. Fits any shotgun and the Shotgun Turret. Not very useful at range.",
        Type = "Ammo",
        MaxStack = 64,
        DespawnTime = 10,
        AmmoType = "Shell",
        AmmoWheelImage = "rbxassetid://15635720278",
        AmmoStats = {
            TracerName = "ShotgunBullet",
            Bullets = 10,
            DamageMult = 0.2
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Bone Armor",
        Description = "This full-body Bone Armor provides minor radiation protection and basic damage resistance.",
        Type = "Armor",
        MaxStack = 1,
        DespawnTime = 15,
        MaxDurability = 1500,
        ArmorType = "All",
        HideHair = true,
        MaxAttachments = 1,
        Image = {
            Default = "rbxassetid://119847143620647"
        },
        Attachments = { "Helmet", "Chestplate", "Leggings", "All" },
        Resistances = {
            Heat = 0,
            Cold = 5,
            Explosive = 3,
            Radiation = 11,
            Animal = 7,
            Legs = {
                Bullet = 13,
                Melee = 20
            },
            Chest = {
                Bullet = 13,
                Melee = 20
            },
            Head = {
                Bullet = 13,
                Melee = 20
            }
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Armor Plate",
        Image = "rbxassetid://126213314272257",
        Description = "Increases your bullet resistance when taking damage from bullets.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 45,
        AttachmentType = "All",
        AttachmentStats = {},
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Heavy Padding",
        Image = "rbxassetid://136131316663930",
        Description = "Increases your melee resistance when taking damage from blunt or sharp melee attacks.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 45,
        AttachmentType = "All",
        AttachmentStats = {},
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Night Vision Goggles",
        Image = "rbxassetid://97551543360376",
        Description = "Allows you to see in the dark, can only be equipped on helmets.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 45,
        AttachmentType = "Helmet",
        Attribute = "NVG",
        AttachmentStats = {},
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Lightweight Padding",
        Image = "rbxassetid://96591489718879",
        Description = "Softens the noise and radius of your footsteps, can only be equipped on leggings",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 45,
        AttachmentType = "Leggings",
        Attribute = "SilentSteps",
        AttachmentStats = {},
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Resistant Rubber",
        Image = "rbxassetid://114763366778253",
        Description = "Increases radiation resistance on your choice of armor.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 45,
        AttachmentType = "All",
        AttachmentStats = {},
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Armor Polish",
        Image = "rbxassetid://106804025023012",
        Description = "Decreases the amount of damage your armor will take.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 45,
        AttachmentType = "All",
        AttachmentStats = {},
        Sounds = {
            Drag = "LiquidPickup",
            Drop = "LiquidDrop"
        }
    },
    {
        Name = "Water Filter",
        Image = "rbxassetid://128444748129429",
        Description = "Allows you to drink from salt water, and heal more from drinking water, can only be equipped on helmets",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 45,
        AttachmentType = "Helmet",
        Attribute = "WaterFilter",
        AttachmentStats = {},
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Steel Toes",
        Image = "rbxassetid://117409121428636",
        Description = "Allows your character to take 25 percent less fall damage, can only be equipped on leggings.",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 45,
        AttachmentType = "Leggings",
        Attribute = "SteelToes",
        AttachmentStats = {},
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Snorkle",
        Image = "rbxassetid://136407336127139",
        Description = "Allows your character to breathe under water for longer than normal",
        Type = "Attachment",
        MaxStack = 1,
        DespawnTime = 45,
        AttachmentType = "Helmet",
        Attribute = "Snorkle",
        AttachmentStats = {},
        Sounds = {
            Drag = "HQMPickup",
            Drop = "HQMDrop"
        }
    },
    {
        Name = "Military Backpack",
        Description = "Military-grade backpack that allows you to carry 24 extra items on you.",
        Type = "Backpack",
        MaxStack = 1,
        DespawnTime = 20,
        SlotSize = 24,
        Image = {
            Default = "rbxassetid://117242081838466",
            ["Digital Red"] = "rbxassetid://113943759309035",
            Tundra = "rbxassetid://98126095773472",
            Abibas = "rbxassetid://82640089227507"
        },
        Sounds = {
            Drag = "BagPickup",
            Drop = "BagDrop"
        }
    },
    {
        Name = "Salvaged Backpack",
        Description = "Handcrafted backpack that allows you to carry 12 extra items on you.",
        Type = "Backpack",
        MaxStack = 1,
        DespawnTime = 15,
        SlotSize = 12,
        Image = {
            Default = "rbxassetid://80978101846806",
            ["Elite Bunny"] = "rbxassetid://130786989208457",
            Ducky = "rbxassetid://84777906931514",
            Patchwork = "rbxassetid://104923741626597"
        },
        Sounds = {
            Drag = "BagPickup",
            Drop = "BagDrop"
        }
    },
    {
        Name = "Salvaged Sniper",
        Description = "Heavy but slow shooting salvaged rifle. Very powerful at long distances.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 20,
        MaxDurability = 75,
        BaseMaxAmmo = 5,
        AmmoType = "Rifle",
        ItemWorth = 800,
        Image = {
            Default = "rbxassetid://74470836610605",
            Valentine = "rbxassetid://134067753909583",
            Radioactive = "rbxassetid://128500957974672"
        },
        Attachments = { "Sight", "Muzzle", "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.0779, 0.2697, 0.5979, 0, -0.8823, 0.4707, 0, 0.4707, 0.8824, -1, 0, 0),
            ArmorStand = CFrame.new(0, 0.2, -0.35) * CFrame.Angles(0, 3.141592653589793, 0),
            AutoTurret = CFrame.new(0, 0, 0) * CFrame.Angles(0, -1.5707963267948966, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Military Grenade Launcher",
        Description = "A semi automatic revolving action grenade launcher, requires 40mm shells to shoot.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 30,
        MaxDurability = 100,
        BaseMaxAmmo = 6,
        AmmoType = "40mm",
        ItemWorth = 700,
        Image = {
            Default = "rbxassetid://136030704871223"
        },
        Attachments = { "Sight", "Barrel" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(0.1779, -0.0258, 0.5908, 0, -0.7071, 0.7072, 0, 0.7072, 0.7072, -1, 0, 0),
            ArmorStand = CFrame.new(0, 0.35, -0.4) * CFrame.Angles(1.5707963267948966, 0, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Explosive Shell",
        Image = "rbxassetid://71411772918243",
        Description = "Explosive ammunition for Grenade Launchers, deals high damage and explodes on impact. Can be used for raiding.",
        Type = "Ammo",
        MaxStack = 10,
        DespawnTime = 10,
        AmmoType = "40mm",
        AmmoWheelImage = "rbxassetid://90346230004065",
        AmmoStats = {
            TracerName = "40mm",
            Impact = "Explosion",
            FilterType = "HitIgnore",
            BulletSize = 0.4,
            StepType = "",
            Explosive = {
                Radius = 10,
                HumanoidMaxDamage = 70,
                SoftSideMult = 1,
                DamagePrefix = "military_40mm_",
                ShakeStrength = 0.2,
                Duration = 0.3,
                SoundName = "MilitaryGrenade",
                Variation = ""
            }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Salvaged Flycopter",
        Image = "rbxassetid://14183996624",
        Description = "erm",
        Type = "Resource",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 250,
        Hidden = true,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Fireplace",
        Description = "Cozy Fireplace for cooking lots of food and giving tons of comfort. Only available in the Winter Wrap Bundle.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 10,
        MaxDurability = 30,
        Image = {
            Default = "rbxassetid://134438626724268"
        },
        Sounds = {
            Drag = "RockPickup",
            Drop = "RockDrop"
        }
    },
    {
        Name = "Black Keycard",
        Image = "rbxassetid://115892814344173",
        Description = "A Dazbog Corporation Support Personnel Black Keycard. Grants access to Black restricted areas.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 25,
        MaxDurability = 1,
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Salvaged Grenade Launcher",
        Description = "Single shot grenade launcher, requires 40mm shells to shoot.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 30,
        MaxDurability = 40,
        BaseMaxAmmo = 1,
        AmmoType = "40mm",
        ItemWorth = 540,
        Image = {
            Default = "rbxassetid://122319440938090"
        },
        Attachments = {},
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.1922, -0.4526, 0.6133, -0.5191, -0.8546, 0, -0.8546, 0.5192, 0, 0, 0, -1),
            ArmorStand = CFrame.new(0, 0.1, -0.1) * CFrame.Angles(0, -1.5707963267948966, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "Salvaged Explosive Shell",
        Image = "rbxassetid://100468627382165",
        Description = "Salvaged explosive ammunition for Grenade Launchers, deals high damage and explodes on impact. Doesn\'t deal much damage to structures.",
        Type = "Ammo",
        MaxStack = 10,
        DespawnTime = 10,
        AmmoType = "40mm",
        AmmoWheelImage = "rbxassetid://90346230004065",
        AmmoStats = {
            TracerName = "40mm",
            Impact = "Explosion",
            FilterType = "HitIgnore",
            BulletSize = 0.4,
            StepType = "",
            Explosive = {
                Radius = 7.5,
                HumanoidMaxDamage = 60,
                SoftSideMult = 1,
                DamagePrefix = "salvaged_40mm_",
                ShakeStrength = 0.2,
                Duration = 0.3,
                SoundName = "MilitaryGrenade",
                Variation = ""
            }
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Shotgun Shell",
        Image = "rbxassetid://90346230004065",
        Description = "Shotgun ammunition for Grenade Launchers, shoots a spread of pellets.",
        Type = "Ammo",
        MaxStack = 10,
        DespawnTime = 10,
        AmmoType = "40mm",
        AmmoWheelImage = "rbxassetid://15635733735",
        AmmoStats = {
            TracerName = "ShotgunBullet",
            Bullets = 8,
            DamageMult = 0.25
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Large Medkit",
        Image = "rbxassetid://75730798424498",
        Description = "A large medkit that will stop bleeding and heal instantly plus 100 health over time.",
        Type = "Consumable",
        MaxStack = 10,
        DespawnTime = 5,
        ConsumableStats = {
            StopBleeds = true,
            Health = 6,
            HQueue = 100,
            Instant = true
        },
        Sounds = {
            Drag = "GrassPickup",
            Drop = "GrassDrop"
        }
    },
    {
        Name = "Small Battery",
        Description = "A small battery, useful for storing a small amount of power by wiring it with some form of a power source.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 7,
        MaxDurability = 100,
        Image = {
            Default = "rbxassetid://88959343384498"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Medium Battery",
        Description = "A medium battery, useful for storing a good amount of power by wiring it with some form of a power source.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 7,
        MaxDurability = 150,
        Image = {
            Default = "rbxassetid://129552454538184"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Large Battery",
        Description = "A large battery, useful for storing a large amount of power by wiring it with some form of a power source.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 7,
        MaxDurability = 200,
        Image = {
            Default = "rbxassetid://78253036378845"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Crude Fuel Generator",
        Description = "A small generator that takes crude fuel, and converts it into electricity.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 7,
        MaxDurability = 100,
        Image = {
            Default = "rbxassetid://117457710807147"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Solar Panel",
        Description = "Solar panels that require sunlight, and when properly under the sun will produce electricity.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 7,
        MaxDurability = 500,
        Image = {
            Default = "rbxassetid://81539973869850"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Water Turbine",
        Description = "A hydro-electricity turbine, and when properly placed on water will produce electricity.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 7,
        MaxDurability = 5000,
        Image = {
            Default = "rbxassetid://118840048689367"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Wire Cutters",
        Image = "rbxassetid://118552370695485",
        Description = "A pair of industrial wire cutters. For connecting power in and out electrical benches. Press left click while hovering an electrical bench to display connections.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 8,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Button",
        Image = "rbxassetid://93858053715998",
        Description = "A power button. Provides power going out for approximately 5 seconds when pressed.",
        Type = "Bench",
        MaxStack = 3,
        DespawnTime = 5,
        MaxDurability = 10,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Electric Furnace",
        Description = "Compact furnace designed to reach hot enough temperatures to outperform its regular Furnace counterpart. Requires power source to operate.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 50,
        Image = {
            Default = "rbxassetid://71536889851799",
            ICBM = "rbxassetid://115876027631434"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Electric Heater",
        Description = "Compact electrical heater designed to produce heat to keep you warm in the cold. Requires power source to operate.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 50,
        Image = {
            Default = "rbxassetid://117015755787407"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Switch",
        Image = "rbxassetid://99819564678318",
        Description = "A power switch. Provides an on/off functionality for power to flow through.",
        Type = "Bench",
        MaxStack = 3,
        DespawnTime = 5,
        MaxDurability = 10,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Windmill",
        Description = "A windmill that provides power from the wind, the further off the ground, the more electricity it will produce.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 7,
        MaxDurability = 7500,
        Image = {
            Default = "rbxassetid://84509705966195"
        },
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Splitter",
        Image = "rbxassetid://119105209870894",
        Description = "An electricity bench. Allows for wires to be extended and electricity to be split between outputs",
        Type = "Bench",
        MaxStack = 3,
        DespawnTime = 5,
        MaxDurability = 10,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "[FREE SLOT]",
        Image = "rbxassetid://14183996624",
        Description = "erm",
        Type = "Resource",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 250,
        Hidden = true,
        Sounds = {
            Drag = "WoodLogPickup",
            Drop = "WoodLogDrop"
        }
    },
    {
        Name = "Auto Turret",
        Image = "rbxassetid://92892387954820",
        Description = "Automatic firing turret that requires power to operate. On attack mode, the turret will shoot people not authorized to the base cabinet. When the turret is on peaceful mode, it will only shoot people who have weapons equipped.",
        Type = "Bench",
        MaxStack = 1,
        DespawnTime = 5,
        MaxDurability = 250,
        Sounds = {
            Drag = "MetalPickup",
            Drop = "MetalDrop"
        }
    },
    {
        Name = "Military M39",
        Description = "Military variant of the Semi automatic rifle. Higher damage and range, similar firerate. Uses Heavy Ammo.",
        Type = "Gun",
        MaxStack = 1,
        DespawnTime = 30,
        MaxDurability = 330,
        BaseMaxAmmo = 20,
        AmmoType = "Rifle",
        ItemWorth = 600,
        Image = {
            Default = "rbxassetid://74435081612082",
            Medusa = "rbxassetid://117342321001432",
            Turkey = "rbxassetid://111197339750272"
        },
        Attachments = { "Sight", "Muzzle", "Barrel", "Magazine" },
        WeldInfo = {
            Part = "UpperTorso",
            Offset = CFrame.new(-0.1158, -0.2786, 0.644, 0, -0.8381, 0.5455, 0, 0.5455, 0.8382, -1, 0, 0),
            ArmorStand = CFrame.new(0, 0, 0.2),
            AutoTurret = CFrame.new(0, 0, 0) * CFrame.Angles(0, -1.5707963267948966, 0)
        },
        Sounds = {
            Drag = "GunPickup",
            Drop = "GunDrop"
        }
    },
    {
        Name = "White Ornament",
        Image = "rbxassetid://125029502429647",
        Description = "A Decorative White Ornament, can be placed into a Christmas Tree to improve the rewards given. Tier 1 Ornament",
        Type = "Resource",
        MaxStack = 1,
        DespawnTime = 9,
        Sounds = {
            Drag = "CannedPickup",
            Drop = "CannedDrop"
        }
    },
    {
        Name = "Red Ornament",
        Image = "rbxassetid://100403008362378",
        Description = "A Decorative Red Ornament, can be placed into a Christmas Tree to improve the rewards given. Tier 2 Ornament.",
        Type = "Resource",
        MaxStack = 1,
        DespawnTime = 9,
        Sounds = {
            Drag = "CannedPickup",
            Drop = "CannedDrop"
        }
    },
    {
        Name = "Purple Ornament",
        Image = "rbxassetid://131580423003709",
        Description = "A Decorative Purple Ornament, can be placed into a Christmas Tree to improve the rewards given. Tier 3 Ornament",
        Type = "Resource",
        MaxStack = 1,
        DespawnTime = 9,
        Sounds = {
            Drag = "CannedPickup",
            Drop = "CannedDrop"
        }
    },
    {
        Name = "Wreath",
        Description = "A festive Christmas wreath. A nice decoration, also provides some comfort when nearby. Only available in the Winter Wrap Bundle.",
        Type = "Bench",
        MaxStack = 5,
        DespawnTime = 5,
        MaxDurability = 5,
        Image = {
            Default = "rbxassetid://125156247966096"
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Christmas Lights",
        Description = "A festive set of Christmas Lights. Only available in the Winter Wrap Bundle.",
        Type = "Bench",
        MaxStack = 5,
        DespawnTime = 5,
        MaxDurability = 5,
        Image = {
            Default = "rbxassetid://134491722995587"
        },
        Sounds = {
            Drag = "ClothPickup",
            Drop = "ClothDrop"
        }
    },
    {
        Name = "Admin Tool",
        Image = "rbxassetid://16630443040",
        Description = "Administrative tool. Delete bases and other undeletable items/benches with ease.",
        Type = "Tool",
        MaxStack = 1,
        DespawnTime = 1,
        Hidden = true,
        DisableDrop = true,
        DisableContainer = true,
        Sounds = {
            Drag = "MetalToolPickup",
            Drop = "MetalToolDrop"
        }
    },
    {
        Name = "Diesel",
        Image = "rbxassetid://112582516390443",
        Description = "A barrel of diesel fuel, used to power heavy-duty machinery like the quarries.",
        Type = "Resource",
        MaxStack = 10,
        DespawnTime = 20,
        FuelTime = 130,
        Sounds = {
            Drag = "LiquidPickup",
            Drop = "LiquidDrop"
        }
    }
};