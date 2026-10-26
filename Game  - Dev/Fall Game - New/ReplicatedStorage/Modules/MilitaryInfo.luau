-- [PATH] ReplicatedStorage / Modules / MilitaryInfo @Type ModuleScript


return {
    Weapons = {
        ["Military USP"] = {
            Health = 135,
            Damage = 6,
            Speed = 4,
            ShotCount = 3,
            BurstDelay = 0.9,
            BrainTimer = 0.75,
            MaxTargetDistance = 300,
            Template = "Soldier",
            BodyName = "Military USP Scav Body"
        },
        ["Salvaged AK74u"] = {
            Health = 115,
            Damage = 6,
            Speed = 4,
            ShotCount = 5,
            BurstDelay = 0.9,
            BrainTimer = 0.75,
            Template = "Soldier",
            BodyName = "Salvaged AK74u Scav Body"
        },
        ["Military M4A1"] = {
            Health = 165,
            Damage = 8,
            Speed = 4,
            ShotCount = 9,
            BurstDelay = 1.1,
            BrainTimer = 0.45,
            Template = "Soldier",
            BodyName = "Military M4A1 Scav Body"
        },
        ["Bruno\'s M4A1"] = {
            Health = 1800,
            Damage = 11,
            Speed = 5,
            ShotCount = 3,
            BurstDelay = 0.4,
            BrainTimer = 0.3,
            Template = "Bruno",
            BodyName = "Body of Bruno",
            RunSpeed = 9,
            Boss = true,
            AttackerName = "BRUNO"
        },
        ["Military PKM"] = {
            Health = 3000,
            Damage = 13,
            Speed = 6,
            ShotCount = 4,
            BurstDelay = 0.3,
            BrainTimer = 0.2,
            Template = "Boris",
            BodyName = "Body of Boris",
            RunSpeed = 9,
            Boss = true
        },
        ["Military Grenade Launcher"] = {
            Health = 3200,
            Damage = 13,
            Speed = 6,
            ShotCount = 1,
            BurstDelay = 1.5,
            BrainTimer = 0.2,
            Template = "Brutus",
            BodyName = "Body of Brutus",
            RunSpeed = 9,
            Boss = true,
            Launcher = true
        },
        ["Nail Gun"] = {
            Health = 85,
            Damage = 4,
            Speed = 4,
            ShotCount = 4,
            BurstDelay = 1.2,
            BrainTimer = 0.6,
            MaxTargetDistance = 110,
            FireRange = 50,
            Template = "Soldier",
            Armor = "Scav",
            BodyName = "Nail Gun Scav Body",
            AttackerName = "SCAV",
            Shot = {
                Tracer = "NailBullet",
                Speed = 165,
                Gravity = 0.25,
                Range = 125,
                Radius = 18,
                BulletSize = 0.2,
                Dropoff = { 25, 100 }
            }
        },
        ["Salvaged Break Action"] = {
            Health = 95,
            Damage = 4,
            Speed = 4,
            ShotCount = 1,
            BurstDelay = 0.6,
            BrainTimer = 0.6,
            MaxTargetDistance = 180,
            FireRange = 30,
            Template = "Soldier",
            Armor = "Scav",
            BodyName = "Salvaged Break Action Scav Body",
            AttackerName = "SCAV",
            Shot = {
                Speed = 550,
                Gravity = 0.6,
                Range = 200,
                Radius = 40,
                Pellets = 8,
                Dropoff = { 12, 150 }
            }
        }
    },
    Armor = {
        Soldier = { { "Military Helmet", "Default" }, { "Military Chestplate", "Default" }, { "Military Leggings", "Default" }, { "Military Gloves", "Default" }, { "Balaclava", "Default" }, { "Hoodie", "Woodland" }, { "Pants", "Woodland" }, { "Boots", "Woodland" } },
        Bruno = { { "Boss Helmet", "Default" }, { "Boss Chestplate", "Default" }, { "Military Leggings", "Default" }, { "Hoodie", "Abibas" }, { "Pants", "Abibas" }, { "Boots", "Abibas" }, { "Military Gloves", "Default" }, { "Balaclava", "Default" } },
        Boris = { { "Boss Helmet", "Boris" }, { "Boss Chestplate", "Boris" }, { "Military Leggings", "Default" }, { "Hoodie", "Boris" }, { "Pants", "Boris" }, { "Boots", "Boris" }, { "Military Gloves", "Default" }, { "Balaclava", "Default" } },
        Brutus = { { "Boss Helmet", "Brutus" }, { "Boss Chestplate", "Brutus" }, { "Military Leggings", "Brutus" }, { "Hoodie", "Brutus" }, { "Pants", "Brutus" }, { "Boots", "Brutus" }, { "Military Gloves", "Default" } },
        Scav = { { "Cloth Shirt", "Default" }, { "Cloth Pants", "Default" }, { "Cloth Handwraps", "Default" }, { "Cloth Headwrap", "Default" }, { "Wooden Helmet", "Default" }, { "Wooden Chestplate", "Default" }, { "Wooden Leggings", "Default" } }
    },
    Settings = {
        ThinkHz = 10,
        MidThinkHz = 3,
        NearDistance = 150,
        FarDistance = 400,
        MaxThinksPerFrame = 60,
        TargetInterval = 0.5,
        TargetAddDistance = 260,
        MaxTargetDistance = 1200,
        WaypointReached = 4,
        OffPathDistance = 6,
        LeashDistance = 260,
        SpawnHeight = 2.5,
        MuzzleOffset = Vector3.new(0.5, 0.5, -2.5),
        KillHeight = 0
    },
    Brain = {
        RunSpeed = 11,
        FacingDot = 0.9,
        PushHealth = 0.5,
        SearchTime = 4,
        RepositionTime = { 1.5, 3 },
        StrafeDistance = { 4, 8 },
        CoverRings = { 8, 14, 20 },
        CoverSamples = 10,
        CoverMargin = 1.5,
        CoverChoices = 3,
        CoverReached = 3,
        CoverHold = { 0.5, 1 },
        SpotSearchInterval = 0.5,
        SpotMaxRise = 4,
        FleeHealth = 0.3,
        FleeRings = { 20, 30, 40 },
        FleeGain = 8,
        FleeTime = 6,
        HealUseTime = 1.5,
        HealInstant = 15,
        HealRegen = 20,
        HealRegenTime = 10,
        UnreachableTime = 10,
        HideTime = 5,
        HurtMemory = 1.5,
        WeaveWidth = { 4, 9 },
        WeaveInterval = { 0.6, 1.3 },
        WeaveFadeDistance = 12,
        BlockedTime = 0.6,
        MissBursts = 2,
        FlankRings = { 8, 14, 22 },
        FlankSamples = 10,
        FlankChoices = 3,
        FlankTime = 4,
        ReloadRetreatMinMagazine = 1,
        ReloadRings = { 10, 16, 22 },
        ReloadGain = 4,
        SearchRunTime = 8,
        PushUnseenTime = 3,
        PushLeash = 200,
        BossTemperament = "Boss",
        Temperaments = {
            Holder = {
                Weight = 0.4,
                PushChance = 0,
                HurtPushChance = 0.2,
                ChargeRange = 40,
                PushTime = 3,
                HoldRadius = 25,
                Chases = false
            },
            Pusher = {
                Weight = 0.4,
                PushChance = 0.15,
                HurtPushChance = 0.6,
                ChargeRange = 25,
                PushTime = 6,
                HoldRadius = 70,
                Chases = true
            },
            Rusher = {
                Weight = 0.2,
                PushChance = 0.5,
                HurtPushChance = 1,
                ChargeRange = 12,
                PushTime = 9,
                HoldRadius = 260,
                Chases = true
            },
            Boss = {
                Weight = 0,
                PushChance = 0.5,
                HurtPushChance = 1,
                ChargeRange = 15,
                PushTime = 9,
                HoldRadius = 120,
                Chases = true
            }
        }
    },
    Replication = {
        TickHz = 10,
        InterestRadius = 400,
        Height = 400,
        Hysteresis = 40,
        NearDistance = 120,
        FarDistance = 200,
        BusyHz = 10,
        IdleHz = 3,
        FarHz = 2,
        BossHz = 1,
        KeepAlive = 2,
        MaxPerPacket = 80,
        ClientTimeout = 5,
        States = { "Idle", "Walk", "Run", "Aim", "Heal", "Dead", "Crouch", "Reload" },
        Rigs = { "Salvaged AK74u", "Military M4A1", "Military USP", "Bruno\'s M4A1", "Military PKM", "Military Grenade Launcher", "Nail Gun", "Salvaged Break Action" }
    },
    HitTest = {
        BodyRadius = 1.4,
        Padding = 0.15,
        InterpDelay = 0.15,
        HistoryLength = 12,
        MaxRewind = 0.6,
        MeleeHalfAngle = 50,
        Boxes = { {
                Limb = "Head",
                Center = Vector3.new(0, 1.5, 0),
                Half = Vector3.new(0.6, 0.6, 0.6)
            }, {
                Limb = "Chest",
                Center = Vector3.new(0, 0, 0),
                Half = Vector3.new(1, 1, 0.5)
            }, {
                Limb = "Legs",
                Center = Vector3.new(0, -2, 0),
                Half = Vector3.new(1, 1, 0.5)
            }, {
                Limb = "Arms",
                Center = Vector3.new(0.3, 0.3, -0.7),
                Half = Vector3.new(1.2, 0.5, 0.7)
            } },
        CrouchBoxes = { {
                Limb = "Head",
                Center = Vector3.new(0, 1.5, 0),
                Half = Vector3.new(0.6, 0.6, 0.6)
            }, {
                Limb = "Chest",
                Center = Vector3.new(0, 0, 0),
                Half = Vector3.new(1, 1, 0.5)
            }, {
                Limb = "Legs",
                Center = Vector3.new(0, -1.75, -0.1),
                Half = Vector3.new(1, 0.8, 0.7)
            }, {
                Limb = "Arms",
                Center = Vector3.new(0.3, 0.3, -0.7),
                Half = Vector3.new(1.2, 0.5, 0.7)
            } }
    },
    Proxy = {
        Head = {
            Part = "Head",
            Size = Vector3.new(1.2, 1.2, 1.2),
            Offset = Vector3.new(0, 1.5, 0)
        },
        Chest = {
            Part = "UpperTorso",
            Size = Vector3.new(2, 2, 1),
            Offset = Vector3.new(0, 0, 0)
        },
        Legs = {
            Part = "LeftUpperLeg",
            Size = Vector3.new(2, 2, 1),
            Offset = Vector3.new(0, -2, 0)
        },
        Arms = {
            Part = "RightUpperArm",
            Size = Vector3.new(2.4, 1, 1.4),
            Offset = Vector3.new(0.3, 0.3, -0.7)
        }
    },
    Movement = {
        GroundOffset = 3,
        StepHeight = 2.5,
        MaxDrop = 20,
        Gravity = 80,
        MaxFallSpeed = 60,
        ProbeRadius = 1,
        MinWalkableNormalY = 0.5,
        WallNormalY = 0.7,
        SeparationRadius = 3,
        SeparationStrength = 0.8,
        PlayerSpacing = 2.5,
        TurnSpeed = 8,
        WallFollowTime = 2,
        StuckTime = 2,
        StuckDistance = 2,
        DetourTime = 2,
        LevelHeight = 4,
        PathRetry = 3
    },
    Ragdoll = {
        RootJoint = "Root",
        Push = 16,
        Lift = 4,
        Spin = 0.25,
        RestTime = 0.6,
        RestSpeed = 0.5,
        SettleTime = 1.6,
        SettleSpeed = 4,
        MaxTime = 3,
        CheckHz = 10,
        Joints = {
            Neck = { 40, 30 },
            Waist = { 25, 20 },
            LeftShoulder = { 80, 45 },
            RightShoulder = { 80, 45 },
            LeftHip = { 50, 20 },
            RightHip = { 50, 20 }
        },
        Collide = {
            Head = true,
            UpperTorso = true,
            LowerTorso = true,
            LeftUpperArm = true,
            LeftLowerArm = true,
            LeftHand = true,
            RightUpperArm = true,
            RightLowerArm = true,
            RightHand = true,
            LeftUpperLeg = true,
            LeftLowerLeg = true,
            LeftFoot = true,
            RightUpperLeg = true,
            RightLowerLeg = true,
            RightFoot = true
        }
    },
    Reload = {
        MagazineMult = 1.5,
        MaxTime = 3,
        Sounds = {
            ["Military USP"] = { { "MagOut", 0.1 }, { "MagIn", 0.55 }, { "MagInTwo", 0.7 } },
            ["Salvaged AK74u"] = { { "MagOut", 0.1 }, { "MagIn", 0.45 }, { "BoltBack", 0.72 }, { "BoltForward", 0.82 } },
            ["Military M4A1"] = { { "MagOut", 0.1 }, { "MagIn", 0.45 }, { "BoltBack", 0.72 }, { "BoltForward", 0.82 } },
            ["Bruno\'s M4A1"] = { { "MagOut", 0.1 }, { "MagIn", 0.45 }, { "BoltBack", 0.72 }, { "BoltForward", 0.82 } },
            ["Military PKM"] = { { "LidOpen", 0.08 }, { "MagOut", 0.2 }, { "Bullets", 0.4 }, { "MagIn", 0.55 }, { "LidClose", 0.72 }, { "BoltBack", 0.85 }, { "BoltForward", 0.92 } },
            ["Military Grenade Launcher"] = { { "Open", 0.1 }, { "Load", 0.45 }, { "Close", 0.8 } },
            ["Nail Gun"] = { { "MagOut", 0.1 }, { "MagIn", 0.55 }, { "Air", 0.8 } },
            ["Salvaged Break Action"] = { { "OpenBarrel", 0.1 }, { "ShellRemove", 0.3 }, { "ShellInsert", 0.55 }, { "CloseBarrel", 0.8 } }
        }
    },
    SpawnPools = {
        Spawn = { "Salvaged AK74u", "Military M4A1" },
        SpawnScav = { "Nail Gun", "Salvaged Break Action" }
    },
    Shot = {
        Tracer = "RifleBullet",
        Speed = 1500,
        Gravity = 1,
        Range = 800,
        Radius = 115,
        Pellets = 1,
        Dropoff = { 400, 800 }
    },
    Client = {
        FullDistance = 60,
        AnimDistance = 180,
        MoveDistance = 400,
        DrawHeight = 400,
        FarUpdateHz = 15,
        ImpostorDistance = 250,
        ImpostorHysteresis = 15,
        MaxAnimatedRigs = 40,
        PrewarmRigs = 4,
        BodyWaitTime = 1.5,
        BodyMatchRadius = 15,
        FlinchTime = 0.3,
        FlinchAngle = 14,
        HeadFlinchAngle = 24,
        CrouchDrop = 0.7,
        CrouchDropRate = 6,
        WalkClipSpeed = 4,
        RunClipSpeed = 14,
        AnimFpsTiers = { { 60, 0 }, { 120, 24 }, { 220, 12 }, { 400, 6 } },
        Poses = {
            Idle = { "Idle", "WeaponIdle" },
            Walk = { "Forward", "WeaponIdle" },
            Run = { "Sprint", "WeaponIdle" },
            Aim = { "Idle", "WeaponAim" },
            Crouch = { "Crouch", "WeaponIdle" },
            Heal = { "Crouch", "MedkitUse" },
            Reload = { "Idle", "WeaponIdle" }
        },
        ClipPriority = {
            Crouch = Enum.AnimationPriority.Movement
        },
        MedkitGrip = CFrame.new(0, -0.35, -0.45),
        Mobile = {
            FullDistance = 40,
            AnimDistance = 100,
            MoveDistance = 250,
            FarUpdateHz = 10,
            ImpostorDistance = 150,
            MaxAnimatedRigs = 10,
            PrewarmRigs = 2,
            NoShadows = true,
            AnimFpsTiers = { { 40, 0 }, { 80, 15 }, { 150, 8 }, { 250, 4 } }
        }
    }
};