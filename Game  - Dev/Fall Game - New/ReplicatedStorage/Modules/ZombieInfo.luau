-- [PATH] ReplicatedStorage / Modules / ZombieInfo @Type ModuleScript


local u1 = {
    Settings = {
        MaxZombies = 200,
        PerPlayerRadius = 250,
        SafeZoneMargin = 120,
        SpawnPointMargin = 150,
        SpawnInterval = 5,
        ThinkHz = 10,
        MidThinkHz = 3,
        SiegeThinkHz = 4,
        IdleThinkHz = 3,
        NearDistance = 150,
        FarDistance = 350,
        DespawnDistance = 400,
        DespawnTime = 30,
        TargetInterval = 0.5,
        LoseTargetTime = 4,
        PursuitTime = 3,
        DeadRemoveDelay = 0.5,
        PlayerHitInterval = 0.8,
        Wild = {
            PerPlayerCap = 4,
            HalloweenMult = 0.25,
            MinPlayerDistance = 100,
            GroupSize = { 1, 3 },
            SpawnRing = { 120, 220 }
        },
        ExplosivesVsZombies = {
            DamageMult = 2.5,
            RadiusMult = 1.5
        },
        Monument = {
            SizePerZombie = 26,
            MinCap = 2,
            MaxCap = 34,
            CapOverrides = {
                Airfield = 42,
                ["Rocket Factory"] = 40,
                ["Lab 1-A"] = 47,
                ["Vault 2-B"] = 30,
                ["Military Barracks"] = 28,
                ["Cargo Yard"] = 21,
                Trainyard = 26,
                ["Offshore Rig"] = 34
            },
            ExtraSpots = {
                ["Vault 2-B"] = {
                    Count = 24,
                    MinSpacing = 20,
                    Step = 8
                }
            },
            Sampled = {
                Step = 8,
                Above = 40,
                Below = 30,
                AreaPerSpot = 900,
                MinSpacing = 12,
                Count = { 10, 40 }
            },
            NightCapOverrides = {
                ["Lab 1-A"] = 60
            },
            ExtraPlayerMult = 0.5,
            MaxPlayerMult = 3,
            ClusterChance = 0.35,
            ClusterMinCap = 8,
            ClusterGroups = { 2, 3 },
            ClusterGroupSize = { 2, 4 },
            ClusterRadius = 30,
            StockDistance = 120,
            StockPerSize = 0.3,
            OutsideShare = 0.25,
            OutsideMinCap = 10,
            HomePadding = 60,
            FloorMinSize = 6,
            GroupSize = { 2, 8 },
            MinPlayerDistance = 35,
            NearDistance = 100,
            Padding = 30,
            SpawnOffset = 3,
            LockedRooms = {
                Sight = 45,
                SameFloor = 8,
                DoorClearance = 3,
                InsideDoor = 4
            },
            SpreadRadius = 15,
            Levels = {
                Band = 14,
                Outside = 25
            },
            Barriers = {
                MinHeight = 1,
                MaxHeight = 8,
                NamePatterns = { "railing", "rails", "rail_", "fence", "barrier" }
            },
            Spread = {
                MinCap = 15,
                NearShare = 0.65,
                NearPool = 0.35,
                MinDistance = 28,
                Spacing = 16,
                GroupSize = { 2, 4 },
                Ring = { 30, 75 },
                Behind = {
                    Share = 0.35,
                    Cone = 65,
                    Hunt = true,
                    Ring = { 22, 60 }
                }
            },
            Stranded = {
                Reach = 40,
                SameFloor = 8,
                Candidates = 6,
                Idle = 30,
                CheckEvery = 15
            },
            PuzzleAmbush = {
                Base = 3,
                PerSpot = 0.3,
                Max = 8,
                Delay = 2.5,
                MinDistance = 10,
                OutsideDoor = 6,
                DoorRadius = 60,
                Cooldown = 900,
                GroupSize = { 2, 3 }
            },
            Difficulty = {
                BannerTime = 4,
                ReshowAfter = 90,
                LeaveMargin = 25,
                MaxCap = { 4, 9, 17, 28 },
                StarOverrides = {
                    ["Offshore Rig"] = 5,
                    ["Army Depot"] = 4,
                    ["Submarine Wreck"] = 2,
                    ["Vault 2-B"] = 5
                },
                ToughShare = { 0, 0.05, 0.12, 0.2, 0.28 },
                Tough = {
                    HealthMult = 1.4,
                    DamageMult = 1.2,
                    SpeedMult = 1.08
                },
                DisplayNames = {
                    ConvoyOne = "Convoy",
                    ConvoyTwo = "Convoy",
                    ConvoyThree = "Convoy",
                    ConvoyFour = "Convoy"
                }
            },
            EmptyResetTime = 120,
            TrickleDelay = 300,
            TrickleInterval = 90,
            TrickleIntervalBig = 40,
            TrickleBigCap = 30,
            TrickleCapDivisor = 5,
            TrickleMin = 1,
            TrickleMax = 5,
            RestockPerPass = 8
        },
        Noise = {
            GunshotRadius = 160,
            SilencedRadius = 0,
            ReactChance = 0.55,
            MaxResponders = 14,
            Interval = 0.6,
            InvestigateTime = 20,
            InvestigateSpeedMult = 0.85,
            ArriveDistance = 8,
            WeaponRadius = {
                ["Wooden Bow"] = 0,
                Crossbow = 0,
                ["Nail Gun"] = 40,
                ["Salvaged RPG"] = 240
            }
        },
        Missions = {
            MaxActive = 4,
            Lifetime = 2100,
            CrateLinger = 600,
            MinSpacing = 1500,
            RestockPerPass = 24,
            BigCap = 15,
            NearMargin = 30,
            RevealAt = 5,
            RevealMax = 8,
            ArrowImage = "rbxthumb://type=Asset&id=137181551950044&w=150&h=150",
            StarImage = "rbxthumb://type=Asset&id=14219539457&w=150&h=150",
            MetersPerStud = 0.28,
            FirstDelay = { 60, 120 },
            SpawnInterval = { 180, 360 },
            Halloween = {
                MaxActive = 1,
                FirstDelay = { 600, 1200 },
                SpawnInterval = { 1500, 2400 }
            },
            Eligible = { "Airfield", "Rocket Factory", "Lab 1-A", "Vault 2-B", "Military Barracks", "Cargo Yard", "Army Depot", "Submarine Bunker", "Relay Station", "Abandoned Farm", "Scav Hideout", "Lighthouse", "Offshore Rig", "Trainyard", "Military Base", "Industrial Port" },
            Tiers = {
                Small = {
                    Easy = 60,
                    Medium = 40
                },
                Big = {
                    Medium = 40,
                    Hard = 40,
                    Epic = 20
                }
            },
            Order = { "Easy", "Medium", "Hard", "Epic" },
            Difficulties = {
                Easy = {
                    Zombies = 16,
                    SenseMult = 1,
                    AlertMult = 1.25,
                    SpeedMult = 1.1,
                    DamageMult = 1.1,
                    HealthMult = 1,
                    ToughShare = 0,
                    StunMult = 1,
                    AggroOnSpawn = false,
                    Crate = "Easy Mission Crate",
                    Arrows = 1,
                    Hunt = { 40, 4 }
                },
                Medium = {
                    Zombies = 34,
                    SenseMult = 1.4,
                    AlertMult = 1.8,
                    SpeedMult = 1.2,
                    DamageMult = 1.25,
                    HealthMult = 1.35,
                    ToughShare = 0.1,
                    StunMult = 0.75,
                    ShotRally = 0.4,
                    AggroOnSpawn = true,
                    Crate = "Medium Mission Crate",
                    Arrows = 2,
                    Hunt = { 18, 8 }
                },
                Hard = {
                    Zombies = 48,
                    SenseMult = 1.7,
                    AlertMult = 2.2,
                    SpeedMult = 1.3,
                    DamageMult = 1.45,
                    HealthMult = 1.9,
                    ToughShare = 0.25,
                    StunMult = 0.45,
                    ShotRally = 0.8,
                    AggroOnSpawn = true,
                    Crate = "Hard Mission Crate",
                    Arrows = 3,
                    Hunt = { 12, 12 }
                },
                Epic = {
                    Zombies = 64,
                    SenseMult = 2.1,
                    AlertMult = 2.7,
                    SpeedMult = 1.4,
                    DamageMult = 1.7,
                    HealthMult = 2.6,
                    ToughShare = 0.4,
                    StunMult = 0.25,
                    ShotRally = 0.95,
                    AggroOnSpawn = true,
                    Crate = "Epic Mission Crate",
                    Star = true,
                    Hunt = { 8, 16 }
                }
            },
            SizeScale = {
                Reference = 160,
                Exponent = 0.75,
                Min = 0.5,
                Max = 1.6
            },
            WipeCurve = {
                Odds = { 0.6, 0.75, 0.9, 1, 1.15 },
                Count = { 0.75, 0.85, 0.95, 1, 1.1 },
                Boost = { 0.7, 0.8, 0.9, 1, 1.1 }
            },
            RevealColor = Color3.fromRGB(255, 40, 40),
            CrateLockedColor = Color3.fromRGB(255, 255, 255),
            CrateOpenColor = Color3.fromRGB(70, 255, 120),
            ZombieOverrides = {
                ["Offshore Rig"] = {
                    Epic = 50
                }
            },
            Rally = {
                LockRange = 90,
                GroupSize = 6,
                GroupGap = 1.5,
                ShotMargin = 150,
                Cooldown = 8,
                HuntRange = 150
            },
            Relocate = {
                LastStandMin = 8,
                LastStandShare = 0.2,
                LastStandRally = 10,
                LastStandLostTime = 20,
                LostTime = 45,
                FarLevel = 16,
                FarDistance = 70,
                SameFloor = 10,
                LevelSpawn = 12,
                CheckInterval = 5,
                MaxPerCheck = 4,
                SpawnDistance = { 20, 60 }
            }
        },
        Airdrop = {
            Enabled = true,
            DelayMin = 60,
            DelayMax = 420,
            GuardRadius = 45,
            LandTries = 25,
            GuardTime = 1200,
            Zombies = { 10, 16 },
            GroupSize = { 2, 4 },
            Ring = { 8, 26 }
        },
        Herd = {
            Enabled = true,
            MaxActive = 2,
            Speed = 3,
            Radius = 30,
            Notify = false,
            Loot = true,
            Lifetime = 1500,
            WakeDistance = 320,
            SleepDistance = 420,
            SleepTime = 15,
            StartMinDistance = 600,
            StopShare = 0.5,
            SpawnPerTick = 6,
            Danger = 2,
            CrateLinger = 600,
            FirstDelay = { 300, 600 },
            Interval = { 900, 1500 },
            Size = { 8, 12 },
            Crates = {},
            Road = {
                Step = 24,
                FarStep = 60,
                BranchChance = 0.08,
                Turns = { 0, 15, -15, 30, -30, 45, -45, 60, -60, 80, -80 }
            }
        },
        Siege = {
            DefaultSeconds = 100,
            RefAttackers = 6,
            BarricadeMult = 1.4,
            SwingInterval = 1.5,
            MaxAttackers = 8,
            ReachCheck = 4.5,
            StandOff = 2.6,
            StandOffSpeed = 3,
            CheckInterval = 0.5,
            PathFirst = 10,
            EntrySearch = 14,
            EntryTime = 8,
            EntryRetry = 15,
            SecondsToBreak = {
                Twig = 6,
                Wood = 40,
                Stone = 110,
                Metal = 220,
                Steel = 400,
                BenchWood = 25,
                BenchMetal = 90
            }
        },
        Defense = {
            DamagerDps = 0.35,
            DamagerRange = 2,
            BearTrapStun = 4,
            DamagerWear = 0.011111111111111112,
            BearTrapWear = 0.15,
            HordeWearMult = 2,
            TurretScan = 0.35,
            TurretLosTries = 5,
            TurretZombieDamageMult = 1,
            ShotgunZombieDamage = 24,
            AutoTurretZombieMult = 0.75,
            AutoTurretZombieMax = 26,
            CacheRefresh = 5,
            DamagerDpsByName = {
                ["Wooden Spikes"] = 1.1,
                ["Metal Spikes"] = 1.5
            },
            DamagerWearByName = {
                ["Wooden Spikes"] = 0.016666666666666666,
                ["Metal Spikes"] = 0.008333333333333333
            }
        },
        Horde = {
            Every = 4,
            PerPlayerBase = 8,
            PerPlayerMax = 40,
            MinCap = 4,
            GlobalMax = 600,
            MinCapUnderLoad = 6,
            PerfBudgetMs = 4,
            BudgetMin = 150,
            BudgetStep = 0.1,
            BudgetCheckTime = 10,
            SpawnRing = { 60, 110 },
            OutsidePriv = {
                Margin = 10,
                PushStep = 15,
                PushMax = 180
            },
            LeashDistance = 220,
            StuckRecycle = 8,
            SpawnPointMargin = 30,
            StuckRecycleDistance = 25,
            Pool = {
                Base = 50,
                Min = 12,
                Max = 500,
                GroupMax = 250,
                AlliedGroupMax = 300,
                GroupShare = 0.015,
                StarterPool = 6,
                GlobalMax = 9000
            },
            Overflow = {
                DamagePerExtra = 0.5,
                MaxDamageMult = 1.75
            },
            RespawnDelay = { 1.6, 0.5 },
            Burst = { 5, 3 },
            Intensity = {
                CapMult = { 1, 1.5 },
                PoolMult = { 1, 1.8 },
                RespawnSpeed = { 1, 1.5 }
            },
            CloseSafeZones = true,
            Nightmare = {
                CapMult = 1.75,
                PoolMult = 1.75,
                GroupMaxMult = 1.2,
                HealthMult = 1.5,
                DamageMult = 1.25,
                SpeedMult = 1.1
            },
            Strength = {
                Min = 0.25,
                BaseWeight = 0.9,
                ArmorForFull = 6,
                Upgrade = 0.5,
                Upkeep = 0.25,
                Defenses = 0.25,
                UpkeepFullDays = 1,
                DefensesForFull = 8,
                DefenseRange = 60,
                TierValues = {
                    Twig = 0,
                    Wood = 0.25,
                    Stone = 0.5,
                    Metal = 0.75,
                    Steel = 1
                }
            },
            BaseRunSpeed = 13.75,
            SpeedMult = { 1.35, 1.6 },
            DamageMult = { 1.4, 1.85 },
            HealthMult = { 1, 1.3 },
            StructureDamageMult = { 2.5, 5.5 },
            StructureStrengthMin = 0.85,
            StructureHardMult = { 1, 1.5 },
            CapGrowth = { 1, 1.7 },
            RampMinutes = 150,
            GatherScaling = {
                Ramp = 1,
                BaseSize = 0.5,
                Upkeep = 1,
                Defenses = 0.5
            },
            RampMin = 0.45,
            WipeCurve = {
                Progress = { 1.1, 1.25, 1.35, 1.45, 1.6 },
                Strength = { 0.7, 0.82, 0.9, 0.95, 1 },
                GroupMax = { 110, 150, 180, 220, 250 },
                OverflowMax = { 1.1, 1.25, 1.4, 1.55, 1.75 }
            },
            Newcomer = {
                Hours = 3,
                StrengthStart = 0.4
            },
            Reward = {
                Enabled = true,
                SizeWeight = 0.45,
                StrengthWeight = 0.45,
                OverflowWeight = 0.1,
                StarterLabel = "SMALL",
                Linger = 900,
                TierBonus = {
                    Rebuilding = 0.1
                },
                StarterCrates = { "Wooden Crate" },
                Ladder = { {
                        Score = 0,
                        Label = "EASY",
                        Crates = { "Easy Mission Crate" }
                    }, {
                        Score = 0.25,
                        Label = "MEDIUM",
                        Crates = { "Medium Mission Crate" }
                    }, {
                        Score = 0.5,
                        Label = "HARD",
                        Crates = { "Hard Mission Crate" }
                    }, {
                        Score = 0.75,
                        Label = "EPIC",
                        Crates = { "Epic Mission Crate" }
                    } }
            },
            Progress = {
                Growth = 0.1,
                Max = 1.6,
                ForgetDays = 3
            },
            GroupRadius = 60,
            GroupShare = 0.15,
            BaseWeights = {
                Twig = 0.2,
                Wood = 1,
                Stone = 2,
                Metal = 3,
                Steel = 4
            },
            BaseFactor = { 0.4, 1.6 },
            BaseScoreDivisor = 250,
            Rebuild = {
                Share = 0.4,
                Recover = 0.7,
                MinPeak = 60,
                CapMult = 0.6,
                BoostScale = 0.5
            },
            BaseCacheTime = 60,
            GearPerArmor = 0.02,
            GearMax = 1.08,
            EndFleeTime = 20,
            SiegeSwingInterval = 0.85,
            SiegeFirstSwing = 0.1,
            AttackCooldownMult = 0.65,
            AlertSound = "rbxassetid://89122120920150",
            AlertVolume = 0.3,
            Music = "rbxassetid://9045953992",
            MusicVolume = 0.04,
            MoonTexture = "rbxthumb://type=Asset&id=119188414898923&w=420&h=420"
        },
        Starter = {
            MaxBaseScore = 15,
            MaxArmor = 3,
            DamageMult = 0.5,
            HitIntervalMult = 2,
            ChaseSpeedMult = 0.85,
            NoticeMult = 0.6,
            GiveUpTime = 20,
            IgnoreTime = 30,
            WildMult = 0.5,
            HordeCap = 2,
            HordeRespawn = 12,
            TierCheckTime = 5
        },
        Night = {
            Start = 19,
            End = 6,
            MaxZombies = 750,
            PerPlayerCapMult = 2,
            MonumentCapMult = 1.5,
            GroupSizeMult = 1.5,
            SpawnIntervalMult = 0.6,
            SpeedMult = 1.1,
            AggroRangeMult = 1.15,
            Message = "Night falls. The hordes are growing...",
            DawnMessage = "Dawn breaks. The hordes are thinning out."
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
        KeepAlive = 2,
        MaxPerPacket = 80,
        ClientTimeout = 5,
        States = { "Idle", "Walk", "Chase", "Attack", "Stunned", "Jump", "Dead" },
        Rigs = {}
    },
    HitTest = {
        BodyRadius = 1.4,
        Padding = 0.15,
        HeadRadius = 0.95,
        HeadHeight = 1.6,
        InterpDelay = 0.15,
        HistoryLength = 12,
        MaxRewind = 0.6,
        MeleeHalfAngle = 50,
        Boxes = { {
                Limb = "Head",
                Center = Vector3.new(0, 1.58, -0.06),
                Half = Vector3.new(0.67, 0.71, 0.62)
            }, {
                Limb = "Body",
                Center = Vector3.new(0, 0, 0),
                Half = Vector3.new(1, 1, 0.5)
            }, {
                Limb = "Body",
                Center = Vector3.new(0, -2, 0),
                Half = Vector3.new(1, 1, 0.5)
            }, {
                Limb = "Body",
                Center = Vector3.new(0, 0.5, -1),
                Half = Vector3.new(2, 0.5, 1)
            } }
    },
    Runtime = {
        Night = false
    },
    Movement = {
        GroundOffset = 3,
        StepHeight = 2.5,
        MaxDrop = 20,
        ChaseMaxDrop = 45,
        Gravity = 80,
        MaxFallSpeed = 60,
        ProbeRadius = 1,
        KneeHeight = 1.5,
        MinWalkableNormalY = 0.5,
        WallNormalY = 0.7,
        SeparationRadius = 3,
        SeparationStrength = 0.8,
        TurnSpeed = 8,
        WallFollowTime = 2,
        StuckTime = 2,
        StuckDistance = 2,
        DetourTime = 2,
        RecycleStuckTime = 15,
        JumpHeight = 7,
        JumpCooldown = 1,
        LevelHeight = 4,
        PathRetry = 3,
        JumpArc = 1,
        SwimDepth = 3.5,
        SwimSpeedMult = 0.6,
        SwimAttackReach = 2.5,
        ClimbSpeed = 7,
        LadderReach = 80,
        LadderTopReach = 40,
        LadderGiveUp = 25
    },
    Hitbox = {
        BodySize = Vector3.new(2.2, 4, 1.3),
        BodyOffset = Vector3.new(0, -1, 0),
        HeadSize = Vector3.new(1.4, 1.4, 1.4),
        HeadOffset = Vector3.new(0, 1.6, 0)
    },
    Types = {
        Default = {
            Health = 90,
            WalkSpeed = 5,
            RunSpeed = 9.5,
            Damage = 7,
            Bleed = 0,
            AttackRange = 4.5,
            AttackHeight = 4,
            AttackCooldown = 2,
            AttackWindup = 0.55,
            SightRange = 75,
            SightAngle = 130,
            HearRange = 18,
            ChaseRange = 100,
            AlertRadius = 30,
            HeadshotMult = 1,
            StunTime = 0.35,
            HeadStunTime = 0.7,
            StunCooldown = 0.5,
            Knockback = 7,
            DeathPush = 26,
            Rig = "Default",
            Weight = 1,
            Scale = 1,
            FirstAttackDelay = { 0.2, 0.7 },
            LootTable = { "AI", "Zombie" }
        }
    }
};

local function Variant(p2) -- Line: 697
    -- upvalues: u1 (copy)
    local table_clone_ret = table.clone(u1.Types.Default);

    for i, v in p2 do
        table_clone_ret[i] = v;
    end;

    return table_clone_ret;
end;

local Types = u1.Types;
local table_clone_ret = table.clone(u1.Types.Default);

for i, v in {
    Health = 70,
    WalkSpeed = 5.5,
    RunSpeed = 12.5,
    Damage = 6,
    AttackCooldown = 1.6,
    SightRange = 85,
    Rig = "Runner",
    Weight = 0
} do
    table_clone_ret[i] = v;
end;

Types.Runner = table_clone_ret;
local Types2 = u1.Types;
local table_clone_ret2 = table.clone(u1.Types.Default);

for i, v in {
    Health = 230,
    WalkSpeed = 4,
    RunSpeed = 8,
    Damage = 14,
    AttackCooldown = 2.6,
    AttackRange = 5.2,
    StunTime = 0.12,
    HeadStunTime = 0.3,
    Knockback = 2,
    DeathPush = 14,
    Scale = 1.15,
    NoStarter = true,
    Rig = "Brute",
    Weight = 0
} do
    table_clone_ret2[i] = v;
end;

Types2.Brute = table_clone_ret2;
local Types3 = u1.Types;
local table_clone_ret3 = table.clone(u1.Types.Default);

for i, v in {
    Health = 80,
    WalkSpeed = 5,
    RunSpeed = 11,
    Damage = 0,
    AttackRange = 3.5,
    AttackWindup = 1.2,
    AttackCooldown = 99,
    NoStarter = true,
    NoGear = true,
    Rig = "Bomber",
    Weight = 0,
    Bomb = {
        Radius = 12,
        PlayerDamage = 40,
        EdgeMult = 0.25,
        MaxDamageMult = 1.15,
        PlayerCooldown = 1.5,
        StructureRadius = 6,
        StructureSwings = 12,
        StructureMultMax = 2,
        ZombieDamage = 50,
        ShotFuse = 0.35,
        DeathPush = 40
    }
} do
    table_clone_ret3[i] = v;
end;

Types3.Bomber = table_clone_ret3;
u1.Variants = {
    AirdropDanger = 2,
    NightmareDanger = 1,
    Order = { "Default", "Runner", "Brute", "Bomber" },
    Gears = { "Plain", "Light", "Heavy" },
    Rows = {
        [0] = {
            Runner = 0.08,
            Brute = 0,
            Bomber = 0,
            Light = 0.05,
            Heavy = 0
        },
        [1] = {
            Runner = 0.14,
            Brute = 0.03,
            Bomber = 0,
            Light = 0.13,
            Heavy = 0.02
        },
        [2] = {
            Runner = 0.2,
            Brute = 0.07,
            Bomber = 0.04,
            Light = 0.22,
            Heavy = 0.06
        },
        [3] = {
            Runner = 0.26,
            Brute = 0.12,
            Bomber = 0.07,
            Light = 0.28,
            Heavy = 0.12
        },
        [4] = {
            Runner = 0.32,
            Brute = 0.18,
            Bomber = 0.1,
            Light = 0.32,
            Heavy = 0.2
        }
    },
    MissionDanger = {
        Easy = 1,
        Medium = 2,
        Hard = 3,
        Epic = 4
    }
};
u1.Looks = {
    Light = { {
            Weight = 3,
            Pieces = { "Wooden Helmet" },
            Resist = {
                Head = 0.8
            }
        }, {
            Weight = 2,
            NoBrute = true,
            Pieces = { "Wooden Chestplate", "Wooden Leggings" },
            Resist = {
                Body = 0.88
            }
        }, {
            Weight = 2,
            NoBrute = true,
            Pieces = { "Wooden Helmet", "Wooden Chestplate", "Wooden Leggings" },
            Resist = {
                Head = 0.8,
                Body = 0.88
            }
        }, {
            Weight = 3,
            Pieces = { "Salvaged Helmet" },
            Resist = {
                Head = 0.65
            }
        }, {
            Weight = 2,
            NoBrute = true,
            Pieces = { "Salvaged Chestplate", "Salvaged Leggings" },
            Resist = {
                Body = 0.82
            }
        }, {
            Weight = 1,
            NoBrute = true,
            Pieces = { "Salvaged Helmet", "Salvaged Chestplate" },
            Resist = {
                Head = 0.65,
                Body = 0.82
            }
        } },
    Heavy = { {
            Weight = 3,
            Pieces = { "Military Helmet" },
            Resist = {
                Head = 0.5
            }
        }, {
            Weight = 3,
            NoBrute = true,
            Pieces = { "Military Helmet", "Military Chestplate", "Military Leggings" },
            Resist = {
                Head = 0.5,
                Body = 0.72
            }
        }, {
            Weight = 2,
            NoBrute = true,
            Pieces = { "Salvaged Helmet", "Military Chestplate" },
            Resist = {
                Head = 0.65,
                Body = 0.72
            }
        }, {
            Weight = 1,
            Pieces = { "Steel Helmet" },
            Resist = {
                Head = 0.4
            }
        }, {
            Weight = 1,
            NoBrute = true,
            Pieces = { "Steel Helmet", "Steel Chestplate", "Steel Leggings" },
            Resist = {
                Head = 0.4,
                Body = 0.65
            }
        } }
};

for _, v in u1.Variants.Order do
    local v3 = v;

    for _, v2 in u1.Variants.Gears do
        table.insert(u1.Replication.Rigs, v3 .. "." .. v2);
    end;
end;

u1.Client = {
    FullDistance = 60,
    AnimDistance = 180,
    MoveDistance = 400,
    DrawHeight = 400,
    FarUpdateHz = 15,
    ImpostorDistance = 250,
    ImpostorHysteresis = 15,
    MaxAnimatedRigs = 60,
    MaxLights = 8,
    MaxRagdolls = 16,
    RagdollMinTime = 0.7,
    RagdollMaxTime = 3,
    RagdollDistance = 90,
    RagdollSettleTime = 1.6,
    FallTime = 0.45,
    CorpseTime = 2,
    FadeTime = 0.6,
    MaxCorpses = 24,
    DeathsPerFrame = 4,
    PrewarmRigs = 10,
    PrewarmImpostors = 20,
    FlinchTime = 0.3,
    FlinchAngle = 18,
    HeadFlinchAngle = 28,
    AnimFpsTiers = { { 60, 0 }, { 120, 24 }, { 220, 12 }, { 400, 6 } },
    Sounds = {
        MinDistance = 6,
        MaxDistance = 85,
        GrowlDistance = 70,
        MaxGrowls = 5,
        PitchJitter = 0.08,
        IdleGap = { 7, 15 },
        ActiveGap = { 3, 7 }
    },
    HordeEyeColor = Color3.fromRGB(255, 25, 15),
    HordeEyeLight = Color3.fromRGB(255, 40, 25),
    Mobile = {
        FullDistance = 40,
        AnimDistance = 100,
        MoveDistance = 250,
        FarUpdateHz = 10,
        ImpostorDistance = 150,
        MaxAnimatedRigs = 12,
        MaxLights = 3,
        MaxRagdolls = 5,
        RagdollDistance = 45,
        MaxCorpses = 10,
        PrewarmRigs = 4,
        PrewarmImpostors = 8,
        NoShadows = true,
        AnimFpsTiers = { { 40, 0 }, { 80, 15 }, { 150, 8 }, { 250, 4 } }
    },
    Animations = {
        Attack = "Attack",
        Hit = "Hit",
        RunSpeed = 11,
        WalkSpeed = 5,
        Run = { "Run1", "Run2" },
        Walk = { "Walk1", "Walk2" },
        Idle = { "Idle" }
    },
    Dress = {
        HeadScale = 1.12,
        Segments = {
            Head = { "Head" },
            UpperTorso = { "Torso", CFrame.new(0, 0.2, 0) },
            LowerTorso = { "Torso", CFrame.new(0, -0.8, 0) },
            RightUpperArm = { "Right Arm", CFrame.new(0, 0.369, 0) },
            RightLowerArm = { "Right Arm", CFrame.new(0, -0.224, 0) },
            RightHand = { "Right Arm", CFrame.new(0, -0.85, 0) },
            LeftUpperArm = { "Left Arm", CFrame.new(0, 0.369, 0) },
            LeftLowerArm = { "Left Arm", CFrame.new(0, -0.224, 0) },
            LeftHand = { "Left Arm", CFrame.new(0, -0.85, 0) },
            RightUpperLeg = { "Right Leg", CFrame.new(0, 0.579, 0) },
            RightLowerLeg = { "Right Leg", CFrame.new(0, -0.201, 0) },
            RightFoot = { "Right Leg", CFrame.new(0, -0.85, 0) },
            LeftUpperLeg = { "Left Leg", CFrame.new(0, 0.579, 0) },
            LeftLowerLeg = { "Left Leg", CFrame.new(0, -0.201, 0) },
            LeftFoot = { "Left Leg", CFrame.new(0, -0.85, 0) }
        },
        HeadOffset = CFrame.new(0, 0, 0)
    },
    Bomb = {
        Hidden = true,
        Mounts = { CFrame.new(0, 0.05, -0.78) },
        BodyTint = Color3.fromRGB(120, 210, 90),
        EyeColor = Color3.fromRGB(110, 255, 70)
    }
};

function u1.GetType(p4, p5) -- Line: 889
    return p4.Types[p5] or p4.Types.Default;
end;

function u1.PickType(p6) -- Line: 893
    local v7 = 0;

    for _, v in p6.Types do
        v7 = v7 + (v.Weight or 1);
    end;

    local v8 = math.random() * v7;

    for i, v in p6.Types do
        v8 = v8 - (v.Weight or 1);

        if v8 <= 0 then
            return i;
        end;
    end;

    return "Default";
end;

function u1.VariantRow(p9, p10) -- Line: 909
    local Rows = p9.Variants.Rows;
    local math_clamp_ret = math.clamp(p10 or 0, 0, #Rows);
    local math_floor_ret = math.floor(math_clamp_ret);
    local math_min_ret = math.min(math_floor_ret + 1, #Rows);
    local v11 = math_clamp_ret - math_floor_ret;
    local v12 = {};

    for i, v in Rows[math_floor_ret] do
        v12[i] = v + ((Rows[math_min_ret][i] or v) - v) * v11;
    end;

    return v12;
end;

function u1.PickVariant(p13, p14, p15) -- Line: 923
    local v16 = p13:VariantRow(p14);
    local math_random_ret = math.random();
    local v17 = "Default";

    for _, v in p13.Variants.Order do
        local v18 = v16[v];

        if v18 and (v18 > 0 and not (p15 and p13.Types[v].NoStarter)) then
            if math_random_ret < v18 then
                v17 = v;
                break;
            end;

            math_random_ret = math_random_ret - v18;
        end;
    end;

    local math_random_ret2 = math.random();

    return v17, p13.Types[v17].NoGear and "Plain" or (math_random_ret2 < v16.Heavy and "Heavy" or (math_random_ret2 < v16.Heavy + v16.Light and "Light" or "Plain"));
end;

function u1.LookFor(p19, p20, p21, p22) -- Line: 951
    local v23 = p19.Looks[p22];

    if not v23 then
        return 0;
    end;

    local v24 = p21 == "Brute";
    local v25 = 0;

    for _, v in v23 do
        if not (v24 and v.NoBrute) then
            v25 = v25 + v.Weight;
        end;
    end;

    if v25 <= 0 then
        return 0;
    end;

    local v26 = p20 % 65536 * 2654435761 % 4294967296 / 4294967296 * v25;

    for i, v in v23 do
        if not (v24 and v.NoBrute) then
            v26 = v26 - v.Weight;

            if v26 < 0 then
                return i;
            end;
        end;
    end;

    return 0;
end;

function u1.GetLook(p27, p28, p29) -- Line: 971
    local v30 = p27.Looks[p28];

    if v30 then
        v30 = v30[p29];
    end;

    return v30;
end;

function u1.SplitRig(p31, p32) -- Line: 977
    local string_match_ret, v33 = string.match(p32 or "", "^([^%.]+)%.?(.*)$");

    return not (string_match_ret and (p31.Types[string_match_ret] and string_match_ret)) and "Default" or string_match_ret, (v33 == "" or not v33) and "Plain" or v33;
end;

function u1.DressBomb(p34, p35) -- Line: 985
    local v36 = {};
    local v37 = {
        Emitters = {}
    };
    local VMs = game:GetService("ReplicatedStorage"):FindFirstChild("VMs");

    if VMs then
        VMs = VMs:FindFirstChild("Dynamite Bundle");
    end;

    if VMs then
        VMs = VMs:FindFirstChild("Default");
    end;

    if VMs then
        VMs = VMs:FindFirstChild("Weapon");
    end;

    if VMs then
        VMs = VMs:FindFirstChild("Handle");
    end;

    local Torso = p35:FindFirstChild("Torso");
    local Bomb = p34.Client.Bomb;

    for _, v in { "Left Leg", "Right Leg" } do
        local v38 = p35:FindFirstChild(v);

        if v38 then
            v38 = v38:FindFirstChildOfClass("SurfaceAppearance");
        end;

        if v38 then
            v38.Color = Bomb.BodyTint;
        end;
    end;

    local Eyes = p35:FindFirstChild("Eyes");

    if Eyes then
        Eyes.Color = Bomb.EyeColor;
    end;

    if not (VMs and Torso) then
        return v36, v37;
    end;

    for i, v in p34.Client.Bomb.Mounts do
        local v39 = VMs:Clone();
        v39.Name = "Dynamite";
        local v40 = v;
        local v41 = i;

        for _, descendant in v39:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                if v41 == 1 then
                    descendant.Enabled = false;
                    table.insert(v37.Emitters, descendant);
                else
                    descendant:Destroy();
                end;
            elseif descendant:IsA("Sound") then
                if v41 == 1 then
                    descendant.Looped = true;
                    v37.Sound = descendant;
                else
                    descendant:Destroy();
                end;
            elseif descendant:IsA("Light") or descendant:IsA("BaseScript") then
                descendant:Destroy();
            end;
        end;

        for _, child in v39:GetChildren() do
            if child:IsA("JointInstance") or child:IsA("WeldConstraint") then
                child:Destroy();
            end;
        end;

        if Bomb.Hidden then
            v39.Transparency = 1;
        end;

        v39.Anchored = false;
        v39.CanCollide = false;
        v39.CanTouch = false;
        v39.CanQuery = false;
        v39.Massless = true;
        v39.CastShadow = false;
        v39.CFrame = Torso.CFrame * v40;
        local Weld = Instance.new("Weld");
        Weld.Part0 = Torso;
        Weld.Part1 = v39;
        Weld.C0 = v40;
        Weld.Parent = v39;
        v39.Parent = p35;
        table.insert(v36, v39);
    end;

    return v36, v37;
end;

function u1.Dress(p42, p43, p44, p45, p46) -- Line: 1039
    local Look = p42:GetLook(p44, p45);
    local v47 = {};

    if not Look then
        return v47;
    end;

    local Armors = game:GetService("ReplicatedStorage"):FindFirstChild("Armors");
    local Dress = p42.Client.Dress;
    local Torso = p43:FindFirstChild("Torso");

    for _, v in Look.Pieces do
        local v48;

        if Armors then
            v48 = Armors:FindFirstChild(v);
        else
            v48 = Armors;
        end;

        if v48 then
            v48 = v48:FindFirstChild("Default");
        end;

        if v48 then
            for _, child in v48:GetChildren() do
                local v49 = Dress.Segments[child.Name];
                local v50;

                if v49 then
                    v50 = p43:FindFirstChild(v49[1]);
                else
                    v50 = v49;
                end;

                if v50 and (child:IsA("Model") and child:FindFirstChild("Middle")) then
                    local v51 = child:Clone();
                    v51.Name = "Gear";

                    for _, descendant in v51:GetDescendants() do
                        if descendant:IsA("JointInstance") or descendant:IsA("WeldConstraint") then
                            descendant:Destroy();
                        end;
                    end;

                    local Middle = v51:FindFirstChild("Middle");
                    v51.PrimaryPart = Middle;
                    local v52 = v49[2];

                    if not v52 then
                        local CFrame_new_ret = CFrame.new(v50.Position);
                        v52 = v50.CFrame:ToObjectSpace(CFrame_new_ret * (Torso and Torso.CFrame.Rotation or CFrame.identity)) * Dress.HeadOffset;

                        if Dress.HeadScale ~= 1 then
                            v51:ScaleTo(Dress.HeadScale);
                        end;
                    end;

                    v51:PivotTo(v50.CFrame * v52);

                    for _, descendant in v51:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            descendant.Anchored = false;
                            descendant.CanCollide = false;
                            descendant.CanTouch = false;
                            descendant.CanQuery = false;
                            descendant.Massless = true;

                            if descendant == Middle then
                                descendant.Transparency = 1;
                            end;

                            descendant.CastShadow = false;
                            local Weld = Instance.new("Weld");
                            Weld.Part0 = v50;
                            Weld.Part1 = descendant;
                            Weld.C0 = v50.CFrame:ToObjectSpace(descendant.CFrame);
                            Weld.Parent = descendant;
                            table.insert(v47, descendant);
                        elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Light") or descendant:IsA("BaseScript")) then
                            descendant:Destroy();
                        end;
                    end;

                    v51.Parent = p43;
                end;
            end;
        end;
    end;

    return v47;
end;

return u1;