-- [PATH] ReplicatedStorage / Modules / ToolInfo @Type ModuleScript
--[[
	ToolInfo
	by neddleduck & ChickenBagelz
	August 27, 2022
	
	All information of every tool, separated from Items module to avoid clutter
	
	
	DOCUMENTATION:

	[name] = {
		
	}
	self explanatory lol
]]

local MeleeChecks = {
	Default = function(range, length, width)
		return {
			{
				Offset = CFrame.new();
				Range = range;
			};
			{
				Offset = CFrame.new(length, 0, 0);
				Range = range;
			};
			{
				Offset = CFrame.new(-length, 0, 0);
				Range = range;
			};
			{
				Offset = CFrame.new(0, width, 0);
				Range = range;
			};
			{
				Offset = CFrame.new(0, -width, 0);
				Range = range;
			};
			{
				Offset = CFrame.new(length, width, 0);
				Range = range;
			};
			{
				Offset = CFrame.new(length, -width, 0);
				Range = range;
			};
			{
				Offset = CFrame.new(-length, width, 0);
				Range = range;
			};
			{
				Offset = CFrame.new(-length, -width, 0);
				Range = range;
			};
		}
	end;
}

local ToolInfo = {
	------ [[GUNS]] ------
	["Salvaged M14"] = {
		Offsets = {
			Global = CFrame.new(-0.0062, -0.5775, -0.6094, 1, 0, -0, -0, 0, 1, 0, -1, 0);
			Local = CFrame.new();
		};
		Weapon = {
			RPM = 370;
			Auto = false;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.3;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadAnimSpeed = 0.9;
			ReloadDuration = 3.1;
			EquipAnimSpeed = 0.9;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
		};
		Bullet = {
			Speed = 2100;
			Gravity = 0.55;
			MaxRange = 1100;
			Dropoff = {
				Start = 550;
				End = 1000;
			};
			HumanoidDamages = {
				Head = 60;
				Chest = 40;
				Arms = 40;
				Legs = 30;
				Bleed = 5;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.5;
				Wood = 360;
				Stone = 2500;
				Metal = 125000;
				Steel = 250000;
				BenchWood = 1.5;
				BenchBarrel = 7;

				Explo_Twig = 1;
				Explo_Wood = 51;
				Explo_Stone = 188;
				Explo_Metal = 472;
				Explo_Steel = 944;
				Explo_BenchWood = 7.5;
				Explo_BenchBarrel = 35;
				Explo_BenchVehicle = 1.75;
			};
		};
		Casing = {
			Type = "CasingLarge";
			Velocity = {10, 11};
			Offset = CFrame.Angles(0, 0, math.rad(20));
			RotationVariance = 5;
			ExtraMoveVelocities = {-10, 13};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 21;
				Moving = 36;
				ShootingExtra = 10;
			};
			Aiming = {
				Hide = true;
				Idle = 0.5;
				Moving = 1;
				ShootingExtra = 5;
			};
			Shooting = {
				BulletsForMax = 2.5;
				DecayStart = 0.12;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.08;
				FinishStart = 0.08;
				Decay = {
					Bullet = 0.4;
					Start = 0.08;
					Rate = 0.1;
					Multiplier = 0.12;
					--Ratio = 1;
				};
				Shake = {
					X = {-0.3, 0.3};
					Y = {0, 0};
				};
				RecoilStart = function(x)
					return 3.05 + math.max(x - 6, 0) * 0.09, 0
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.2;
				};
				Rot = {
					Y = 1.5;
					X = {-1.5, 1.5};
					Z = {-1, 1};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(2.5, 0, 3);
			Speed = 0.25;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};

	["Salvaged AK47"] = {
		Offsets = {
			Global = CFrame.new(0.0434, -0.3856, -0.2963, 0, 0, 1, -1, 0, 0, 0, -1, 0);
			Local = CFrame.new(0.1041, 0.136, 0.2841, 1, 0.0001, 0.0001, -0, 1, -0, -0, 0.0001, 1);
		};
		Weapon = {
			RPM = 450;
			Auto = true;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadDuration = 2.9;
			ReloadAnimSpeed = 1;
			EquipAnimSpeed = 0.75;
			VMMovementMults = {
				Bobbing = 0.8;
				MouseSway = 0.8;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
		};
		Bullet = {
			Speed = 2100;
			Gravity = 0.55;
			MaxRange = 1100;
			Dropoff = {
				Start = 550;
				End = 1000;
			};
			HumanoidDamages = {
				Head = 75;
				Chest = 50;
				Arms = 50;
				Legs = 38;
				Bleed = 5;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.2;
				Wood = 320;
				Stone = 2000;
				Metal = 100000;
				Steel = 200000;
				BenchWood = 1.75;
				BenchBarrel = 8;

				Explo_Twig = 1;
				Explo_Wood = 50;
				Explo_Stone = 185;
				Explo_Metal = 465;
				Explo_Steel = 930;
				Explo_BenchWood = 8;
				Explo_BenchBarrel = 40;
				Explo_BenchVehicle = 1.75;
			};
		};
		Casing = {
			Type = "CasingLarge";
			Velocity = {12, 13};
			Offset = CFrame.Angles(math.rad(-90), 0, math.rad(0));
			RotationVariance = 5;
			ExtraMoveVelocities = {13, -10};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 18;
				Moving = 30;
				ShootingExtra = 20;
			};
			Aiming = {
				Hide = true;
				Idle = 0.3;
				Moving = 0.6;
				ShootingExtra = 8;
			};
			Shooting = {
				BulletsForMax = 4;
				DecayStart = 0.1;
				DecayEnd = 0.75;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.08;
				FinishStart = 0.08;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {0, 0};
					Y = {0, 0};
				};
				RecoilStart = function(x)
					local multY = 1 - math.min(math.max(x - 7, 0) / 40, 0.5)
					local multX = 3 - math.min(x / 10, 0.9)
					return 3.5 * multY, multX * math.sin(math.min(x, 29) / 9.55) * 1.1
					--[[local mult = 1 - math.min(math.max(x - 5, 0) / 40, 0.5)
					return 3.4 * mult, (x > 5 and 2.6 * mult / math.max(8 - x, 1) or 0)]]
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.2;
				};
				Rot = {
					Y = 1.5;
					X = {-1.5, 1.5};
					Z = {-1, 1};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(2.5, 0, 3);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};
	
	["Military M4A1"] = {
		Offsets = {
			Global = CFrame.new(-0.0261, -0.6152, -0.4132, 0, 0, 1, -1, 0, 0, 0, -1, 0);
			Local = CFrame.new(0.0501, 0.0601, 0.0041, 1, 0.0001, 0.0001, -0, 1, -0, -0, 0.0001, 1);
		};
		Weapon = {
			RPM = 500;
			Auto = true;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadDuration = 2.9;
			ReloadAnimSpeed = 1;
			EquipAnimSpeed = 0.75;
			VMMovementMults = {
				Bobbing = 0.8;
				MouseSway = 0.8;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
		};
		Bullet = {
			Speed = 2100;
			Gravity = 0.55;
			MaxRange = 1050;
			Dropoff = {
				Start = 550;
				End = 950;
			};
			HumanoidDamages = {
				Head = 60;
				Chest = 40;
				Arms = 40;
				Legs = 30;
				Bleed = 5;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.2;
				Wood = 320;
				Stone = 2000;
				Metal = 100000;
				Steel = 200000;
				BenchWood = 1.75;
				BenchBarrel = 8;

				Explo_Twig = 1;
				Explo_Wood = 50;
				Explo_Stone = 185;
				Explo_Metal = 465;
				Explo_Steel = 930;
				Explo_BenchWood = 8;
				Explo_BenchBarrel = 40;
				Explo_BenchVehicle = 1.75;
			};
		};
		Casing = {
			Type = "CasingLarge";
			Velocity = {12, 13};
			Offset = CFrame.Angles(math.rad(-90), 0, math.rad(0));
			RotationVariance = 5;
			ExtraMoveVelocities = {13, -10};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 20;
				Moving = 32;
				ShootingExtra = 20;
			};
			Aiming = {
				Hide = true;
				Idle = 0.3;
				Moving = 0.6;
				ShootingExtra = 10;
			};
			Shooting = {
				BulletsForMax = 5;
				DecayStart = 0.1;
				DecayEnd = 0.6;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.08;
				FinishStart = 0.08;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {-0.05, 0.05};
					Y = {0, 0.1};
				};
				RecoilStart = function(x)
					local multY = 1 - math.min(math.max(x - 5, 0) / 30, 0.3)
					local multX = 1.8 * math.sin((x - 2) / 5)
					return 2.9 * multY, (0.3 + multX) * 0.7
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.17;
				};
				Rot = {
					Y = 1.3;
					X = {-1.3, 1.3};
					Z = {-0.9, 0.9};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(2.5, 0, 3);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};
	["Bruno's M4A1"] = {
		Offsets = {
			Global = CFrame.new(-0.0261, -0.6152, -0.4132, 0, 0, 1, -1, 0, 0, 0, -1, 0);
			Local = CFrame.new(0.0501, 0.0601, 0.0041, 1, 0.0001, 0.0001, -0, 1, -0, -0, 0.0001, 1);
		};
		Weapon = {
			RPM = 530;
			Auto = true;
			Burst = 3;
			BurstRPM = 700;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadDuration = 2.9;
			ReloadAnimSpeed = 1;
			EquipAnimSpeed = 0.75;
			VMMovementMults = {
				Bobbing = 0.8;
				MouseSway = 0.8;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
		};
		Bullet = {
			Speed = 2100;
			Gravity = 0.55;
			MaxRange = 1050;
			Dropoff = {
				Start = 550;
				End = 950;
			};
			HumanoidDamages = {
				Head = 62;
				Chest = 42;
				Arms = 20;
				Legs = 32;
				Bleed = 5;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.2;
				Wood = 320;
				Stone = 2000;
				Metal = 100000;
				Steel = 200000;
				BenchWood = 1.75;
				BenchBarrel = 8;

				Explo_Twig = 1;
				Explo_Wood = 50;
				Explo_Stone = 185;
				Explo_Metal = 465;
				Explo_Steel = 930;
				Explo_BenchWood = 8;
				Explo_BenchBarrel = 40;
				Explo_BenchVehicle = 1.75;
			};
		};
		Casing = {
			Type = "CasingLarge";
			Velocity = {12, 13};
			Offset = CFrame.Angles(math.rad(-90), 0, math.rad(0));
			RotationVariance = 5;
			ExtraMoveVelocities = {13, -10};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 20;
				Moving = 32;
				ShootingExtra = 20;
			};
			Aiming = {
				Hide = true;
				Idle = 0.3;
				Moving = 0.6;
				ShootingExtra = 10;
			};
			Shooting = {
				BulletsForMax = 5;
				DecayStart = 0.1;
				DecayEnd = 0.6;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.08;
				FinishStart = 0.08;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {-0.05, 0.05};
					Y = {0, 0.1};
				};
				RecoilStart = function(x)
					local multY = 1 - math.min(math.max(x - 5, 0) / 30, 0.3)
					local multX = 1.8 * math.sin((x - 2) / 5)
					return 2.2 * multY, (0.3 + multX) * 0.53
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.17;
				};
				Rot = {
					Y = 1.3;
					X = {-1.3, 1.3};
					Z = {-0.9, 0.9};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(2.5, 0, 3);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};
	["Military PKM"] = {
		Offsets = {
			Global = CFrame.new(0.0409, -0.4636, -0.6307, 0, 0, -1, 1, 0, 0, 0, -1, 0);
			Local = CFrame.new();
		};
		Weapon = {
			RPM = 425;
			Auto = true;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.25;
				Out = 0.3;
			};
			ReloadDuration = 6;
			ReloadAnimSpeed = 1;
			EquipAnimSpeed = 0.75;
			VMMovementMults = {
				Bobbing = 0.95;
				MouseSway = 0.8;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
		};
		Bullet = {
			Speed = 2400;
			Gravity = 0.55;
			MaxRange = 1250;
			Dropoff = {
				Start = 600;
				End = 1000;
			};
			HumanoidDamages = {
				Head = 82;
				Chest = 55;
				Arms = 55;
				Legs = 42;
				Bleed = 5;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.2;
				Wood = 320;
				Stone = 2000;
				Metal = 100000;
				Steel = 200000;
				BenchWood = 1.75;
				BenchBarrel = 8;

				Explo_Twig = 1;
				Explo_Wood = 50;
				Explo_Stone = 185;
				Explo_Metal = 465;
				Explo_Steel = 930;
				Explo_BenchWood = 8;
				Explo_BenchBarrel = 40;
				Explo_BenchVehicle = 1.75;
			};
		};
		Casing = {
			Type = "CasingLarge";
			Velocity = {12, 13};
			Offset = CFrame.Angles(math.rad(-90), 0, math.rad(0));
			RotationVariance = 5;
			ExtraMoveVelocities = {13, -10};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 24;
				Moving = 40;
				ShootingExtra = 15;
			};
			Aiming = {
				Hide = true;
				Idle = 0.3;
				Moving = 0.6;
				ShootingExtra = 8;
			};
			Shooting = {
				BulletsForMax = 8;
				DecayStart = 0.25;
				DecayEnd = 1;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.08;
				FinishStart = 0.08;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {-0.1, 0.1};
					Y = {0, 0.2};
				};
				RecoilStart = function(x)
					return 3.5, 0.3
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.17;
				};
				Rot = {
					Y = 1.3;
					X = {-1.3, 1.3};
					Z = {-0.9, 0.9};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(2.5, 0, 3);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};

	["Salvaged AK74u"] = {
		Offsets = {
			Global = CFrame.new(-0.0209, -0.7758, -0.3914, 1, 0, 0, 0, 0, 1, 0, -1, 0);
			Local = CFrame.new(0.0421, 0.0261, -0.1839, 1, 0.0001, 0.0001, -0, 1, -0, -0, 0.0001, 1);
		};
		Weapon = {
			RPM = 540;
			Auto = true;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadDuration = 2.9;
			ReloadAnimSpeed = 1;
			EquipAnimSpeed = 0.75;
			VMMovementMults = {
				Bobbing = 0.8;
				MouseSway = 0.8;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
		};
		Bullet = {
			Speed = 1800;
			Gravity = 0.6;
			MaxRange = 800;
			Dropoff = {
				Start = 325;
				End = 700;
			};
			HumanoidDamages = {
				Head = 53;
				Chest = 35;
				Arms = 35;
				Legs = 26;
				Bleed = 4;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.69;
				Wood = 450;
				Stone = 2812;
				Metal = 140625;
				Steel = 281250;
				BenchWood = 1;
				BenchBarrel = 6;
			};
		};
		Casing = {
			Type = "CasingSmall";
			Velocity = {10, 12};
			Offset = CFrame.Angles(math.rad(-90), 0, math.rad(30));
			RotationVariance = 5;
			ExtraMoveVelocities = {-10, 13};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 15;
				Moving = 24;
				ShootingExtra = 18;
			};
			Aiming = {
				Hide = true;
				Idle = 1;
				Moving = 2;
				ShootingExtra = 8;
			};
			Shooting = {
				BulletsForMax = 3.25;
				DecayStart = 0.2;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.08;
				FinishStart = 0.08;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {0, 0};
					Y = {0, 0};
				};
				RecoilStart = function(x)
					local multX = x * ((2 - math.max(x - 13, 0) / 10) * math.sin(x / 5)) / 8
					local multY = math.max(1 - math.max(x - 19, 0) / 6, 0)
					return 2.75 * multY, multX * 0.95
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.2;
				};
				Rot = {
					Y = 1.5;
					X = {-1.5, 1.5};
					Z = {-1, 1};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(2.5, 0, 3);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};

	["Crossbow"] = {
		Offsets = {
			Global = CFrame.new(-0.0255, -0.3972, -0.433, 0, 0, 1, -1, 0, 0, 0, -1, 0);
			Local = CFrame.new();
		};
		Weapon = {
			RPM = 180;
			DisplayRPM = 14;
			Auto = false;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.3;
			AimDownSpeed = {
				In = 0.16;
				Out = 0.2;
			};
			ReloadDuration = 3.6;
			ReloadAnimSpeed = 0.53;
			ReloadAnimTime = 3.75;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.95;
			IgnoreEmptyClick = true;
		};
		Bullet = {
			Offset = math.rad(0.4);
			Speed = 370;
			Gravity = 0.2;
			MaxRange = 500;
			Dropoff = {
				Start = 175;
				End = 375;
			};
			HumanoidDamages = {
				Head = 105;
				Chest = 60;
				Arms = 60;
				Legs = 45;
				Bleed = 8;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.1;
				Wood = 3000;
				Stone = 40000;
				BenchWood = 0.5;
				BenchBarrel = 20;
			};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 24;
				Moving = 40;
				ShootingExtra = 5;
			};
			Aiming = {
				Hide = true;
				Idle = 0.05;
				Moving = 0.05;
				ShootingExtra = 0;
			};
			Shooting = {
				BulletsForMax = 1;
				DecayStart = 0.1;
				DecayEnd = 1;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.15;
				FinishStart = 0.1;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {-1, 1};
					Y = {0, 0.5};
				};
				RecoilStart = function(x)
					return 5, 0
				end;
				RecoilFinish = function(x)
					return -1, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = {-0.05, 0.05};
					Y = -0.03;
					Z = 0.3;
				};
				Rot = {
					Y = 1.6;
					X = {-1.5, 1.5};
					Z = {-1, 1};
				};
			};
		};
	};

	["Wooden Bow"] = {
		Offsets = {
			Global = CFrame.new(-0.0501, -0.1349, 0.1087, 0, 0.0075, 1, 0.9999, -0.0173, 0.0002, 0.0174, 0.9999, -0.0074);
			Local = CFrame.new();
			Aim = CFrame.new(-0.224, 0.4922, 0.6801, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			RPM = 150;
			DisplayRPM = 37;
			Auto = false;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.1;
			AimDownSpeed = {
				In = 0.27;
				Out = 0.46;
			};
			ReloadDuration = 1.2;
			ReloadAnimSpeed = 1;
			EquipAnimSpeed = 1.35;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.6;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			IsBow = true;
			IgnoreEmptyClick = true;
		};
		Bullet = {
			Offset = math.rad(0.75);
			Speed = 260;
			Gravity = 0.2;
			MaxRange = 400;
			Dropoff = {
				Start = 125;
				End = 300;
			};
			HumanoidDamages = {
				Head = 64;
				Chest = 40;
				Arms = 40;
				Legs = 30;
				Bleed = 7;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.4;
				Wood = 4000;
				Stone = 50000;
				BenchWood = 0.25;
				BenchBarrel = 15;
			};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 5;
				Moving = 5;
				IdleExtra = 14;
				MovingExtra = 27;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = true;
				Idle = 0.1;
				Moving = 0.1;
				ShootingExtra = 0;
			};
			Shooting = {
				BulletsForMax = 1;
				DecayStart = 0.1;
				DecayEnd = 1;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.15;
				FinishStart = 0.1;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {-0.1, 0.1};
					Y = {-0.1, 0.1};
				};
				RecoilStart = function(x)
					return 0, 0
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = {-0.05, 0.05};
					Y = -0.03;
					Z = 0.3;
				};
				Rot = {
					Y = 1.6;
					X = {-1.5, 1.5};
					Z = {-1, 1};
				};
			};
		};
	};

	["Salvaged P250"] = {
		Offsets = {
			Global = CFrame.new(-0.17, -0.3834, -0.2964, 0, 0, -1, 1, 0, 0, 0, -1, 0);
			Local = CFrame.new(-0.0918, 0.1341, 0.0101, 1, 0, 0, 0, 1, 0, 0, 0, 1); 
		};
		Weapon = {
			RPM = 375;
			Auto = false;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadAnimSpeed = 1;
			ReloadDuration = 2.55;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.95;
		};
		Bullet = {
			Speed = 1400;
			Gravity = 0.6;
			MaxRange = 600;
			Dropoff = {
				Start = 250;
				End = 500;
			};
			HumanoidDamages = {
				Head = 53;
				Chest = 35;
				Arms = 35;
				Legs = 26;
				Bleed = 5;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.5;
				Wood = 400;
				Stone = 2500;
				Metal = 125000;
				Steel = 250000;
				BenchWood = 1;
				BenchBarrel = 6;
			};
		};
		Casing = {
			Type = "CasingSmall";
			Velocity = {8, 10};
			Offset = CFrame.Angles(0, 0, math.rad(20));
			RotationVariance = 4;
			ExtraMoveVelocities = {-8, 11};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 16;
				Moving = 28;
				ShootingExtra = 20;
			};
			Aiming = {
				Hide = true;
				Idle = 1.75;
				Moving = 3.5;
				ShootingExtra = 11;
			};
			Shooting = {
				BulletsForMax = 1.75;
				DecayStart = 0.2;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.07;
				FinishStart = 0.07;
				Decay = {
					Bullet = 0.5;
					Start = 0.08;
					Rate = 0.1;
					Multiplier = 0.12;
					--Ratio = 1;
				};
				Shake = {
					X = {-0.5, 0.5};
					Y = {0, 0};
				};
				RecoilStart = function(x)
					return 2.2 + math.max(x - 2.5, 0) * 0.14, 0
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.2;
				};
				Rot = {
					Y = 1.5;
					X = {-1.5, 1.5};
					Z = {-1, 1};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(1.9, 0, 2.4);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};

	["Salvaged SMG"] = {
		Offsets = {
			Global = CFrame.new(0.0146, -0.6745, -0.4232, 1, 0.0001, -0, 0.0001, -0, 1, -0, -1, 0);
			Local = CFrame.new(0.0083, -0.0439, -0.3758, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			RPM = 462;
			Auto = true;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadDuration = 2.6;
			ReloadAnimSpeed = 1.1;
			EquipAnimSpeed = 0.8;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
		};
		Bullet = {
			Speed = 1800;
			Gravity = 0.6;
			MaxRange = 750;
			Dropoff = {
				Start = 325;
				End = 700;
			};
			HumanoidDamages = {
				Head = 54;
				Chest = 36;
				Arms = 36;
				Legs = 27;
				Bleed = 4;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.69;
				Wood = 450;
				Stone = 2812;
				Metal = 140625;
				Steel = 281250;
				BenchWood = 1;
				BenchBarrel = 7;
			};
		};
		Casing = {
			Type = "CasingSmall";
			Velocity = {12, 13};
			Offset = CFrame.Angles(math.rad(-90), 0, math.rad(30));
			RotationVariance = 5;
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 17;
				Moving = 28;
				ShootingExtra = 18;
			};
			Aiming = {
				Hide = true;
				Idle = 1;
				Moving = 2;
				ShootingExtra = 10;
			};
			Shooting = {
				BulletsForMax = 4.5;
				DecayStart = 0.1;
				DecayEnd = 0.75;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.09;
				FinishStart = 0.09;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {0, 0};
					Y = {0, 0};
				};
				RecoilStart = function(x)
					return 2.6 + math.max(x - 5, 0) * 0.04, math.min(2.5 + x / 8, 5) * math.sin(x / 2.3) * 0.56
					--return 2.7 + math.max(x - 5, 0) * 0.035, 0
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.2;
				};
				Rot = {
					Y = 1.5;
					X = {-1.5, 1.5};
					Z = {-1, 1};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(1.9, 0, 2.4);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};
	
	["Salvaged Skorpion"] = {
		Offsets = {
			Global = CFrame.new(-0.0179, -0.2526, -0.3474, 0, 0, 1, -1, 0, 0, 0, -1, 0);
			Local = CFrame.new(0.0043, 0.0801, -0.0257, 1, 0.0001, 0.0001, -0, 1, 0.0001, -0, -0, 1);
		};
		Weapon = {
			RPM = 600;
			Auto = true;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadDuration = 2.7;
			ReloadAnimSpeed = 0.8;
			EquipAnimSpeed = 0.8;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
		};
		Bullet = {
			Speed = 1600;
			Gravity = 0.6;
			MaxRange = 550;
			Dropoff = {
				Start = 250;
				End = 500;
			};
			HumanoidDamages = {
				Head = 45;
				Chest = 30;
				Arms = 30;
				Legs = 23;
				Bleed = 4;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.69;
				Wood = 450;
				Stone = 2812;
				Metal = 140625;
				Steel = 281250;
				BenchWood = 1;
				BenchBarrel = 7;
			};
		};
		Casing = {
			Type = "CasingSmall";
			Velocity = {12, 13};
			Offset = CFrame.Angles(math.rad(-90), 0, math.rad(30));
			RotationVariance = 5;
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 20;
				Moving = 32;
				ShootingExtra = 22;
			};
			Aiming = {
				Hide = true;
				Idle = 3;
				Moving = 5;
				ShootingExtra = 12;
			};
			Shooting = {
				BulletsForMax = 3.5;
				DecayStart = 0.1;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.09;
				FinishStart = 0.09;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {0, 0};
					Y = {0, 0};
				};
				RecoilStart = function(x)
					return 2.75 + math.max(x - 5, 0) * 0.06, math.min(2.5 + x / 8, 5) * math.sin(x / 6) * 0.3
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.2;
				};
				Rot = {
					Y = 1.5;
					X = {-1.5, 1.5};
					Z = {-1, 1};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(1.9, 0, 2.4);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};

	["Salvaged Python"] = {
		Offsets = {
			Global = CFrame.new(-0.0319, -0.0594, -0.5213, 0, 0, 1, -1, 0, 0, 0, -1, 0);
			Local = CFrame.new(-0.0617, 0.1222, -0.1778, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			RPM = 300;
			Auto = false;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadAnimSpeed = 1;
			ReloadDuration = 3.02;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
		};
		Bullet = {
			Speed = 1800;
			Gravity = 0.6;
			MaxRange = 700;
			Dropoff = {
				Start = 325;
				End = 600;
			};
			HumanoidDamages = {
				Head = 80;
				Chest = 54;
				Arms = 54;
				Legs = 40;
				Bleed = 6;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.4;
				Wood = 380;
				Stone = 2500;
				Metal = 125000;
				Steel = 250000;
				BenchWood = 1.5;
				BenchBarrel = 8;
			};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 14;
				Moving = 27;
				ShootingExtra = 20;
			};
			Aiming = {
				Hide = true;
				Idle = 1;
				Moving = 2;
				ShootingExtra = 10;
			};
			Shooting = {
				BulletsForMax = 1.5;
				DecayStart = 0.2;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.07;
				FinishStart = 0.07;
				Decay = {
					Bullet = 0.4;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
					--Ratio = 1;
				};
				Shake = {
					X = {-1.5, 1.5};
					Y = {0, 0};
				};
				RecoilStart = function(x)
					return 5.4 + math.max(x - 1, 0) * 0.4, 0
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.2;
				};
				Rot = {
					Y = 1.5;
					X = {-1.5, 1.5};
					Z = {-1, 1};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(2.5, 0, 3);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};

	["Nail Gun"] = {
		Offsets = {
			Global = CFrame.new(-0.016, 0.1562, -0.4697, 0, 0, 1, -1, 0, 0, 0, -1, 0);
			Local = CFrame.new(-0.05, 0.0081, 0.146, 1, 0.0001, 0.0001, -0, 1, -0, -0, 0.0001, 1);
		};
		Weapon = {
			RPM = 400;
			Auto = false;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.2;
			AimDownSpeed = {
				In = 0.16;
				Out = 0.2;
			};
			ReloadAnimSpeed = 1;
			ReloadDuration = 2.6;
			EquipAnimSpeed = 1.35;
			VMMovementMults = {
				Bobbing = .8;
				MouseSway = .8;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
		};
		Bullet = {
			Offset = math.rad(1.5);
			Speed = 165;
			Gravity = 0.25;
			MaxRange = 125;
			Dropoff = {
				Start = 25;
				End = 100;
			};
			HumanoidDamages = {
				Head = 27;
				Chest = 18;
				Arms = 18;
				Legs = 14;
				Bleed = 3;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 8;
				Wood = 4000;
				Stone = 50000;
				BenchWood = 0.1;
				BenchBarrel = 2.5;
			};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 15;
				Moving = 24;
				ShootingExtra = 15;
			};
			Aiming = {
				Hide = true;
				Idle = 2;
				Moving = 2;
				ShootingExtra = 10;
			};
			Shooting = {
				BulletsForMax = 2.75;
				DecayStart = 0.12;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.08;
				FinishStart = 0.08;
				Decay = {
					Bullet = 0.5;
					Start = 0.08;
					Rate = 0.1;
					Multiplier = 0.12;
					--Ratio = 1;
				};
				Shake = {
					X = {-0.2, 0.2};
					Y = {0, 0};
				};
				RecoilStart = function(x)
					return 2 + math.max(x - 3, 0) * 0.06, 0
				end;
				RecoilFinish = function(x)
					return 0, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = 0;
					Y = -0.01;
					Z = 0.1;
				};
				Rot = {
					Y = 1;
					X = {-1, 1};
					Z = {-0.5, 0.5};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(1.9, 0, 2.4);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};

	["Salvaged RPG"] = {
		Offsets = {
			Global = CFrame.new(-0.1689, -0.549, -0.1655, 0, 0, 1, -1, 0, 0, 0, -1, 0);
			Local = CFrame.new(-0.05, 0.0081, 0.146, 1, 0.0001, 0.0001, -0, 1, -0, -0, 0.0001, 1);
			SightBack = CFrame.Angles(0, 0, math.rad(-15));
		};
		Weapon = {
			RPM = 60;
			DisplayRPM = 11;
			Auto = false;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.35;
				Out = 0.45;
			};
			ReloadAnimSpeed = 0.9;
			ReloadDuration = 4;
			EquipAnimSpeed = 0.6;
			VMMovementMults = {
				Bobbing = .8;
				MouseSway = .8;
				SprintTilt = 1.1;
				SprintMoveDown = 1.25;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
			RequiresAim = true;
		};
		Bullet = {
			Offset = math.rad(2.5);
			Speed = 100;
			Gravity = 0.12;
			MaxRange = 1000;
			Dropoff = {
				Start = 1000;
				End = 1000;
			};
			DisplayDamage = 175;
			HumanoidDamages = {
				Head = 20;
				Chest = 20;
				Arms = 20;
				Legs = 20;
				Bleed = 0;
			};
			SoftSideMult = 1;
		};
		ObjectDamages = {
			Benches = {
				Twig = 0.05;
				Wood = 1.7;
				Stone = 3.8;
				Metal = 7.6;
				Steel = 15.2;
				BenchWood = 200;
				BenchBarrel = 200;
				BenchVehicle = 91;

				HV_Twig = 0.05 * 7;
				HV_Wood = 1.7 * 7;
				HV_Stone = 3.8 * 7;
				HV_Metal = 7.6 * 7;
				HV_Steel = 15.2 * 7;
				HV_BenchWood = 200 / 4;
				HV_BenchBarrel = 200 / 4;
				HV_BenchVehicle = 143;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 10;
				Moving = 10;
				ShootingExtra = 10;
			};
			Aiming = {
				Hide = true;
				Idle = 10;
				Moving = 10;
				ShootingExtra = 10;
			};
			Shooting = {
				BulletsForMax = 1;
				DecayStart = 0.12;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.3;
				FinishStart = 0.12;
				Decay = {
					Bullet = 0.4;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
					--Ratio = 1;
				};
				Shake = {
					X = {-3, 3};
					Y = {0, 2};
				};
				RecoilStart = function(x)
					return 10, 0
				end;
				RecoilFinish = function(x)
					return -3.5, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = {-0.2, 0.2};
					Y = -0.05;
					Z = 0.5;
				};
				Rot = {
					Y = 2;
					X = {-2.25, 2.25};
					Z = {-1.3, 1.3};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(3.8, 0, 4.8);
			Speed = 0.25;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};

	["Salvaged Pipe Rifle"] = {
		Offsets = {
			Global = CFrame.new(0.0119, -0.9016, -0.361, 0, 0, -1, 1, 0, 0, 0, -1, 0);
			Local = CFrame.new(-0.0119, 0.004, -0.462, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			RPM = 135;
			DisplayRPM = 16;
			Auto = false;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.3;
			AimDownSpeed = {
				In = 0.16;
				Out = 0.2;
			};
			ReloadAnimSpeed = {0.92 * 0.9, 0.6 * 0.9, 0.78 * 0.9};
			ReloadAnimTime = 1.07;
			ReloadDuration = 1.3 * 0.9;
			ExtraReloadDuration = 1.1 * 0.9;
			EquipAnimSpeed = 0.9;
			VMMovementMults = {
				Bobbing = 0.8;
				MouseSway = 0.9;
				SprintTilt = 0.9;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
			BoltFed = true;
		};
		Bullet = {
			Speed = 1700;
			Gravity = 0.6;
			MaxRange = 850;
			Dropoff = {
				Start = 400;
				End = 750;
			};
			HumanoidDamages = {
				Head = 98;
				Chest = 56;
				Arms = 56;
				Legs = 42;
				Bleed = 4;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1;
				Wood = 267;
				Stone = 1667;
				Metal = 83334;
				Steel = 166667;
				BenchWood = 1.5;
				BenchBarrel = 8;
			};
		};
		Casing = {
			Type = "CasingLarge";
			Velocity = {16, 18};
			Offset = CFrame.Angles(0, 0, math.rad(30));
			RotationVariance = 4;
			ExtraMoveVelocities = {-10, 13};
			IgnoreShoot = true;
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 24;
				Moving = 40;
				ShootingExtra = 20;
			};
			Aiming = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 12;
			};
			Shooting = {
				BulletsForMax = 1;
				DecayStart = 0.12;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.15;
				FinishStart = 0.1;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {-3, 3};
					Y = {0, 0.5};
				};
				RecoilStart = function(x)
					return 6.5, 0
				end;
				RecoilFinish = function(x)
					return -1.5, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = {-0.05, 0.05};
					Y = -0.05;
					Z = 0.5;
				};
				Rot = {
					Y = 2;
					X = {-1, 1};
					Z = {-0.5, 0.5};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(3, 0, 3);
			Speed = 0.25;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};
	
	["Military Barrett"] = {
		Offsets = {
			Global = CFrame.new(-0.1934, 0.2028, -0.1084, -1, 0, 0, 0, 0, -1, 0, -1, 0);
			Local = CFrame.new();
		};
		Weapon = {
			RPM = 160;
			DisplayRPM = 30;
			Auto = true;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.25;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			BoltAnimSpeed = 0.86;
			ReloadDuration = 4.6;
			ReloadAnimSpeed = 1;
			EquipAnimSpeed = 0.75;
			VMMovementMults = {
				Bobbing = 0.8;
				MouseSway = 0.8;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
				BoltFed = true;
			};
			SReduction = 0.9;
		};
		Bullet = {
			Speed = 2500;
			Gravity = 0.55;
			MaxRange = 1100;
			Dropoff = {
				Start = 550;
				End = 1000;
			};
			HumanoidDamages = {
				Head = 140;
				Chest = 80;
				Arms = 80;
				Legs = 60;
				Bleed = 5;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 1.2;
				Wood = 320;
				Stone = 2000;
				Metal = 100000;
				Steel = 200000;
				BenchWood = 1.75;
				BenchBarrel = 8;

				Explo_Twig = 1;
				Explo_Wood = 50;
				Explo_Stone = 185;
				Explo_Metal = 465;
				Explo_Steel = 930;
				Explo_BenchWood = 8;
				Explo_BenchBarrel = 40;
				Explo_BenchVehicle = 1.75;
			};
		};
		Casing = {
			Type = "CasingLarge";
			Velocity = {12, 13};
			Offset = CFrame.Angles(math.rad(-90), 0, math.rad(0));
			RotationVariance = 5;
			ExtraMoveVelocities = {13, -10};
			IgnoreShoot = true;
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 18;
				Moving = 30;
				ShootingExtra = 20;
			};
			Aiming = {
				Hide = true;
				Idle = 0.3;
				Moving = 0.6;
				ShootingExtra = 8;
			};
			Shooting = {
				BulletsForMax = 4;
				DecayStart = 0.1;
				DecayEnd = 0.75;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.15;
				FinishStart = 0.1;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {-3, 3};
					Y = {0, 0.5};
				};
				RecoilStart = function(x)
					return 8, 0
				end;
				RecoilFinish = function(x)
					return -1.75, 0
				end,
			};
			VM = {
				StartTime = 0.08;
				EndTime = 0.12;
				Pos = {
					X = {-0.06, 0.06};
					Y = -0.06;
					Z = 0.7;
				};
				Rot = {
					Y = 2.4;
					X = {-1.2, 1.2};
					Z = {-0.6, 0.6};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(3, 0, 4);
			Speed = 0.2;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};

	["Salvaged Break Action"] = {
		Offsets = {
			Global = CFrame.new(0.006, -0.4763, -0.696, 0, 0, -1, 1, 0.0001, 0, -0, -1, 0);
			Local = CFrame.new(0.096, 0.0382, -0.17, 1, 0.0001, 0.0001, -0, 1, -0, -0, 0.0001, 1);
		};
		Weapon = {
			RPM = 130;
			DisplayRPM = 15;
			Auto = false;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.2;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadAnimSpeed = 0.8;
			ReloadAnimTime = 3.45;
			ReloadDuration = 3.3;
			EquipAnimSpeed = 0.5;
			BoltAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = .8;
				MouseSway = .8;
				SprintTilt = 1;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
			SReduction = 0.95;
		};
		Bullet = {
			Speed = 550;
			Gravity = 0.6;
			MaxRange = 200;
			Dropoff = {
				Start = 0;
				End = 150;
			};
			HumanoidDamages = {
				Head = 96;
				Chest = 64;
				Arms = 64;
				Legs = 48;
				Bleed = 1;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 8;
				Wood = 225;
				Stone = 3400;
				BenchWood = 2.4;
				BenchBarrel = 12;
			};
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 45;
				Moving = 55;
				ShootingExtra = 15;
			};
			Aiming = {
				Hide = true;
				Idle = 45;
				Moving = 45;
				ShootingExtra = 15;
			};
			Shooting = {
				BulletsForMax = 1;
				DecayStart = 0.12;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.15;
				FinishStart = 0.1;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {-3, 3};
					Y = {0, 0.5};
				};
				RecoilStart = function(x)
					return 6.5, 0
				end;
				RecoilFinish = function(x)
					return -1.5, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = {-0.05, 0.05};
					Y = -0.05;
					Z = 0.5;
				};
				Rot = {
					Y = 2;
					X = {-1, 1};
					Z = {-0.5, 0.5};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(3, 0, 3);
			Speed = 0.25;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};
	
	["Military AA12"] = {
		Offsets = {
			Global = CFrame.new(-0.0212, -0.3769, -0.3103, 0, 0, 1, -1, 0, 0, 0, -1, 0);
			Local = CFrame.new(0.096, 0.0382, -0.17, 1, 0.0001, 0.0001, -0, 1, -0, -0, 0.0001, 1);
		};
		Weapon = {
			RPM = 220;
			Auto = true;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.2;
			AimDownSpeed = {
				In = 0.2;
				Out = 0.25;
			};
			ReloadAnimSpeed = {1, 1, 1};
			--ReloadAnimTime = 1.07;
			ReloadDuration = 0.1 + 0.72;
			ExtraReloadDuration = 0.72;
			EquipAnimSpeed = 0.8;
			VMMovementMults = {
				Bobbing = .8;
				MouseSway = .8;
				SprintTilt = 1;
				SprintMoveDown = 1;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
			BoltFed = true;
		};
		Bullet = {
			Speed = 600;
			Gravity = 0.6;
			MaxRange = 200;
			Dropoff = {
				Start = 0;
				End = 150;
			};
			HumanoidDamages = {
				Head = 78;
				Chest = 52;
				Arms = 52;
				Legs = 39;
				Bleed = 1;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 8 / 0.75;
				Wood = 225 / 0.75;
				Stone = 3400 / 0.75;
				BenchWood = 2.4 * 0.75;
				BenchBarrel = 12 * 0.75;
			};
		};
		Casing = {
			Type = "CasingShell";
			Velocity = {16, 18};
			Offset = CFrame.Angles(0, 0, math.rad(30));
			RotationVariance = 4;
			ExtraMoveVelocities = {-10, 13};
			IgnoreShoot = true;
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 45;
				Moving = 55;
				ShootingExtra = 15;
			};
			Aiming = {
				Hide = true;
				Idle = 45;
				Moving = 45;
				ShootingExtra = 15;
			};
			Shooting = {
				BulletsForMax = 2;
				DecayStart = 0.12;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.15;
				FinishStart = 0.1;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {-2, 2};
					Y = {0, 0.4};
				};
				RecoilStart = function(x)
					return 5.5, 0
				end;
				RecoilFinish = function(x)
					return -1.5, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = {-0.04, 0.04};
					Y = -0.04;
					Z = 0.4;
				};
				Rot = {
					Y = 1.6;
					X = {-0.75, 0.75};
					Z = {-0.4, 0.4};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(3, 0, 3);
			Speed = 0.25;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};
	
	["Salvaged Pump Action"] = {
		Offsets = {
			Global = CFrame.new(0.0119, -0.9016, -0.361, 0, 0, -1, 1, 0, 0, 0, -1, 0);
			Local = CFrame.new(-0.0759, 0.0181, -0.1519, 1, 0, 0, 0, 1, -0, 0, 0.0001, 1);
		};
		Weapon = {
			RPM = 135;
			DisplayRPM = 20;
			Auto = false;
			Burst = 1;
			BurstRPM = 0;
			DefaultZoomLevel = 1.2;
			AimDownSpeed = {
				In = 0.3;
				Out = 0.3;
			};
			ReloadAnimSpeed = {0.92 * 0.9, 0.6 * 0.9, 0.78 * 0.9};
			ReloadAnimTime = 1.07;
			ReloadDuration = 1.3 * 0.9;
			ExtraReloadDuration = 1.1 * 0.9;
			EquipAnimSpeed = 0.5;
			BoltAnimSpeed = 0.8;
			VMMovementMults = {
				Bobbing = 0.7;
				MouseSway = 0.8;
				SprintTilt = 0.8;
				SprintMoveDown = 0.4;
				SprintMoveBackward = 0;
			};
			SReduction = 0.9;
			BoltFed = true;
		};
		Bullet = {
			Speed = 650;
			Gravity = 0.6;
			MaxRange = 200;
			Dropoff = {
				Start = 0;
				End = 150;
			};
			HumanoidDamages = {
				Head = 96;
				Chest = 64;
				Arms = 64;
				Legs = 48;
				Bleed = 1;
			};
			SoftSideMult = 2;
		};
		ObjectDamages = {
			Benches = {
				Twig = 8;
				Wood = 225;
				Stone = 3400;
				BenchWood = 2.4;
				BenchBarrel = 12;
			};
		};
		Casing = {
			Type = "CasingShell";
			Velocity = {16, 18};
			Offset = CFrame.Angles(0, 0, math.rad(30));
			RotationVariance = 4;
			ExtraMoveVelocities = {-10, 13};
			IgnoreShoot = true;
		};
		Spread = {
			Hip = {
				Hide = false;
				Idle = 40;
				Moving = 50;
				ShootingExtra = 15;
			};
			Aiming = {
				Hide = true;
				Idle = 40;
				Moving = 40;
				ShootingExtra = 15;
			};
			Shooting = {
				BulletsForMax = 1;
				DecayStart = 0.12;
				DecayEnd = 0.8;
			};
		};
		Recoil = {
			Camera = {
				Duration = 0.15;
				FinishStart = 0.1;
				Decay = {
					Bullet = 0.3;
					Start = 0.08;
					Rate = 0.12;
					Multiplier = 0.12;
				};
				Shake = {
					X = {-3, 3};
					Y = {0, 0.5};
				};
				RecoilStart = function(x)
					return 6.5, 0
				end;
				RecoilFinish = function(x)
					return -1.5, 0
				end,
			};
			VM = {
				StartTime = 0.07;
				EndTime = 0.11;
				Pos = {
					X = {-0.05, 0.05};
					Y = -0.05;
					Z = 0.5;
				};
				Rot = {
					Y = 2;
					X = {-1, 1};
					Z = {-0.5, 0.5};
				};
			};
		};
		Shake = {
			Strength = Vector3.new(3, 0, 3);
			Speed = 0.25;
			Angles = {-179, 180};
			SnapBack = false;
			DelayTime = 0;
		};
	};

	------ [[MELEE]] ------
	["Stone Hatchet"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local = CFrame.new( 0.0429758094, -0.533661604, -0.128225714, 1, -8.40779079e-45, 8.40779079e-45, 8.40779079e-45, 1, -8.40779079e-45, -8.40779079e-45, 8.40779079e-45, 1);
			LocalUse = CFrame.new(-0.538181007, -0.69784683, -0.138619661, 0.985808969, -0.150060594, 0.0749957785, 0.162847772, 0.963356495, -0.213055477, -0.0402772278, 0.222248882, 0.974134088);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(6);
				Logic = "Normal";
				Velocity = 65;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, 7.5};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(-90), 0);
				LandOffset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, -1, 0);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 0.9;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 2;
				SprintMoveBackward = 3;
			};
		};
		Melee = {
			MaxRange = 5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(5, 0.2, 0.2)};
				{1, MeleeChecks.Default(5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 24;
				Chest = 16;
				Arms = 16;
				Legs = 12;
				Bleed = 4;
			};
			ThrowDamages = {
				Head = 38;
				Chest = 25;
				Arms = 25;
				Legs = 19;
				Bleed = 6;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 1.5;
				Bench = 2.5;
				BasePart = 6;
				Throw = 3;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 18;
				Wood = 1000;
				Stone = 13200;
				Metal = 51000;
				Steel = 102000;
				BenchWood = 1.75;
				BenchBarrel = 3.5;
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 13;
					Mult = 0.7;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 12;
					Mult = 0.7;
				};
			};
			Trees = {
				Desert = {
					HitsToBreak = 18;
					SparkMult = 2;
					Mult = 0.75;
				};
				Small = {
					HitsToBreak = 24;
					SparkMult = 2;
					Mult = 0.75;
				};
				Medium = {
					HitsToBreak = 30;
					SparkMult = 2;
					Mult = 0.75;
				};
				Giant = {
					HitsToBreak = 36;
					SparkMult = 2;
					Mult = 0.75;
				};
			};
			Logs = {
				HitsToBreak = 10;
				Mult = 0.75;
			};
			Cactus = {
				Small = {
					HitsToBreak = 5;
					Mult = 0.75;
				};
				Medium = {
					HitsToBreak = 10;
					Mult = 0.75;
				};
				Large = {
					HitsToBreak = 15;
					Mult = 0.75;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};

	["Iron Shard Hatchet"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local = CFrame.new( 0.0429758094, -0.533661604, -0.128225714, 1, -8.40779079e-45, 8.40779079e-45, 8.40779079e-45, 1, -8.40779079e-45, -8.40779079e-45, 8.40779079e-45, 1);
			LocalUse = CFrame.new(-0.538181007, -0.69784683, -0.138619661, 0.985808969, -0.150060594, 0.0749957785, 0.162847772, 0.963356495, -0.213055477, -0.0402772278, 0.222248882, 0.974134088);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Logic = "Normal";
				Velocity = 55;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, 7.5};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(-90), 0);
				LandOffset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0.5, -0.75, 0);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 0.9;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 2;
				SprintMoveBackward = 3;
			};
		};
		Melee = {
			MaxRange = 5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(5, 0.2, 0.2)};
				{1, MeleeChecks.Default(5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 45;
				Chest = 30;
				Arms = 30;
				Legs = 23;
				Bleed = 5;
			};
			ThrowDamages = {
				Head = 72;
				Chest = 48;
				Arms = 48;
				Legs = 36;
				Bleed = 7;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 2;
				Bench = 7;
				BasePart = 18;
				Throw = 4;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 9;
				Wood = 375;
				Stone = 4437;
				Metal = 22500;
				Steel = 22500 * 2;
				BenchWood = 2.5;
				BenchBarrel = 5;
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 12;
					Mult = 0.9;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 11;
					Mult = 0.9;
				};
			};
			Trees = {
				Desert = {
					HitsToBreak = 14;
					SparkMult = 2;
					Mult = 0.8;
				};
				Small = {
					HitsToBreak = 19;
					SparkMult = 2;
					Mult = 0.8;
				};
				Medium = {
					HitsToBreak = 24;
					SparkMult = 2;
					Mult = 0.8;
				};
				Giant = {
					HitsToBreak = 29;
					SparkMult = 2;
					Mult = 0.8;
				};
			};
			Logs = {
				HitsToBreak = 10;
				Mult = 0.8;
			};
			Cactus = {
				Small = {
					HitsToBreak = 5;
					Mult = 0.9;
				};
				Medium = {
					HitsToBreak = 10;
					Mult = 0.9;
				};
				Large = {
					HitsToBreak = 15;
					Mult = 0.9;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
		
	};

	["Steel Axe"] = {
		Offsets = {
			Global = CFrame.new(-0.0097, -0.1736, -0.8023, 1, 0.0001, -0, 0.0001, -0, 1, 0.0001, -1, -0);
			Local = CFrame.new(-0.3259, -0.0815, -0.0937, 1, 0, 0, 0, 1, 0, 0, 0, 1);
			LocalUse = CFrame.new(-0.238, -0.0798, -0.6528, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(8);
				Logic = "Normal";
				Velocity = 50;
				GravityMult = 0.4;
				SpinSpeed = {-6, 0, 0};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(0, 0, 0);
				LandOffset = CFrame.Angles(math.rad(30), math.rad(180), 0) * CFrame.new(0, -1.1, 0.5);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1.5;
			UsePositionTimes = {
				Start = 0.1;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1.25;
				SprintTilt = 0.9;
				SprintMoveDown = 4;
				SprintMoveBackward = 3;
			};
		};
		Melee = {
			MaxRange = 5.5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(5.5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(5.5, 0.2, 0.2)};
				{1, MeleeChecks.Default(5.5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 60;
				Chest = 40;
				Arms = 40;
				Legs = 30;
				Bleed = 7;
			};
			ThrowDamages = {
				Head = 90;
				Chest = 60;
				Arms = 60;
				Legs = 45;
				Bleed = 8;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 3;
				Bench = 6;
				BasePart = 15;
				Throw = 4;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 5;
				Wood = 290;
				Stone = 2589;
				Metal = 15106;
				Steel = 15106 * 2;
				BenchWood = 5;
				BenchBarrel = 10;
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 7;
					Mult = 1;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 7;
					Mult = 1;
				};
			};
			Trees = {
				Desert = {
					HitsToBreak = 7;
					SparkMult = 2;
					Mult = 1;
				};
				Small = {
					HitsToBreak = 11;
					SparkMult = 2;
					Mult = 1;
				};
				Medium = {
					HitsToBreak = 15;
					SparkMult = 2;
					Mult = 1;
				};
				Giant = {
					HitsToBreak = 19;
					SparkMult = 2;
					Mult = 1;
				};
			};
			Logs = {
				HitsToBreak = 4;
				Mult = 1;
			};
			Cactus = {
				Small = {
					HitsToBreak = 2;
					Mult = 1;
				};
				Medium = {
					HitsToBreak = 4;
					Mult = 1;
				};
				Large = {
					HitsToBreak = 7;
					Mult = 1;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};

	["Stone Pickaxe"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local = CFrame.new( 0.0429758094, -0.533661604, -0.128225714, 1, -8.40779079e-45, 8.40779079e-45, 8.40779079e-45, 1, -8.40779079e-45, -8.40779079e-45, 8.40779079e-45, 1);
			LocalUse = CFrame.new(-0.538181007, -0.69784683, -0.138619661, 0.985808969, -0.150060594, 0.0749957785, 0.162847772, 0.963356495, -0.213055477, -0.0402772278, 0.222248882, 0.974134088);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(6);
				Logic = "Normal";
				Velocity = 65;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, 7.5};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(-90), 0);
				LandOffset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, -1, 0);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 0.9;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 2;
				SprintMoveBackward = 3;
			};
		};
		Melee = {
			MaxRange = 5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(5, 0.2, 0.2)};
				{1, MeleeChecks.Default(5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 24;
				Chest = 16;
				Arms = 16;
				Legs = 12;
				Bleed = 4;
			};
			ThrowDamages = {
				Head = 38;
				Chest = 25;
				Arms = 25;
				Legs = 19;
				Bleed = 6;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 1.5;
				Bench = 2.5;
				BasePart = 6;
				Throw = 3;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 24;
				Wood = 2000;
				Stone = 6600;
				Metal = 32200;
				Steel = 64400;
				BenchWood = 2;
				BenchBarrel = 4;
			};
			Nodes = {
				Stone = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.7;
				};
				Metal = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.7;
				};
				Phosphate = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.7;
				};
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 15;
					Mult = 0.6;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 14;
					Mult = 0.6;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};

	["Iron Shard Pickaxe"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local = CFrame.new( 0.0429758094, -0.533661604, -0.128225714, 1, -8.40779079e-45, 8.40779079e-45, 8.40779079e-45, 1, -8.40779079e-45, -8.40779079e-45, 8.40779079e-45, 1);
			LocalUse = CFrame.new(-0.538181007, -0.69784683, -0.138619661, 0.985808969, -0.150060594, 0.0749957785, 0.162847772, 0.963356495, -0.213055477, -0.0402772278, 0.222248882, 0.974134088);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Logic = "Normal";
				Velocity = 55;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, 7.5};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(-90), 0);
				LandOffset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0.5, -0.75, 0);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 0.9;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 2;
				SprintMoveBackward = 3;
			};
		};
		Melee = {
			MaxRange = 5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(5, 0.2, 0.2)};
				{1, MeleeChecks.Default(5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 38;
				Chest = 25;
				Arms = 25;
				Legs = 19;
				Bleed = 5;
			};
			ThrowDamages = {
				Head = 60;
				Chest = 40;
				Arms = 40;
				Legs = 30;
				Bleed = 7;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 3;
				Bench = 6;
				BasePart = 18;
				Throw = 4;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 12;
				Wood = 687;
				Stone = 2225;
				Metal = 10125;
				Steel = 10125 * 2;
				BenchWood = 3;
				BenchBarrel = 6;
			};
			Nodes = {
				Stone = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 1;
				};
				Metal = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 1;
				};
				Phosphate = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 1;
				};
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 14;
					Mult = 0.65;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 13;
					Mult = 0.65;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};

	["Bone Tool"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local = CFrame.new( 0.0429758094, -0.533661604, -0.128225714, 1, -8.40779079e-45, 8.40779079e-45, 8.40779079e-45, 1, -8.40779079e-45, -8.40779079e-45, 8.40779079e-45, 1);
			LocalUse = CFrame.new(-0.538181007, -0.69784683, -0.138619661, 0.985808969, -0.150060594, 0.0749957785, 0.162847772, 0.963356495, -0.213055477, -0.0402772278, 0.222248882, 0.974134088);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Logic = "Normal";
				Velocity = 55;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, 7.5};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(-90), 0);
				LandOffset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0.5, -0.75, 0);
				Stick = true;
			};
			CanSprintWhileAttacking = true;
			Cooldown = 0.9;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 2;
				SprintMoveBackward = 3;
			};
		};
		Melee = {
			MaxRange = 5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(5, 0.2, 0.2)};
				{1, MeleeChecks.Default(5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 30;
				Chest = 20;
				Arms = 20;
				Legs = 15;
				Bleed = 4;
			};
			ThrowDamages = {
				Head = 48;
				Chest = 32;
				Arms = 32;
				Legs = 24;
				Bleed = 2;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 2;
				Bench = 4;
				BasePart = 10;
				Throw = 3;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 21;
				Wood = 1550;
				Stone = 8100;
				Metal = 41000;
				Steel = 41000 * 2;
				BenchWood = 2.5;
				BenchBarrel = 6;
			};
			Nodes = {
				Stone = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.6;
				};
				Metal = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.6;
				};
				Phosphate = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.6;
				};
			};
			Logs = {
				HitsToBreak = 10;
				Mult = 0.6;
			};
			Cactus = {
				Small = {
					HitsToBreak = 5;
					Mult = 0.6;
				};
				Medium = {
					HitsToBreak = 10;
					Mult = 0.6;
				};
				Large = {
					HitsToBreak = 15;
					Mult = 0.6;
				};
			};
			Trees = {
				Desert = {
					HitsToBreak = 14;
					SparkMult = 2;
					Mult = 0.6;
				};
				Small = {
					HitsToBreak = 19;
					SparkMult = 2;
					Mult = 0.6;
				};
				Medium = {
					HitsToBreak = 24;
					SparkMult = 2;
					Mult = 0.6;
				};
				Giant = {
					HitsToBreak = 29;
					SparkMult = 2;
					Mult = 0.6;
				};
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 11;
					Mult = 0.95;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 10;
					Mult = 0.95;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};
	
	["Candy Cane"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local = CFrame.new( 0.0429758094, -0.533661604, -0.128225714, 1, -8.40779079e-45, 8.40779079e-45, 8.40779079e-45, 1, -8.40779079e-45, -8.40779079e-45, 8.40779079e-45, 1);
			LocalUse = CFrame.new(-0.538181007, -0.69784683, -0.138619661, 0.985808969, -0.150060594, 0.0749957785, 0.162847772, 0.963356495, -0.213055477, -0.0402772278, 0.222248882, 0.974134088);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Logic = "Normal";
				Velocity = 55;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, 7.5};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(-90), 0);
				LandOffset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0.5, -0.75, 0);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 0.9;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 2;
				SprintMoveBackward = 3;
			};
		};
		Melee = {
			MaxRange = 5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(5, 0.2, 0.2)};
				{1, MeleeChecks.Default(5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 30;
				Chest = 20;
				Arms = 20;
				Legs = 15;
				Bleed = 4;
			};
			ThrowDamages = {
				Head = 48;
				Chest = 32;
				Arms = 32;
				Legs = 24;
				Bleed = 2;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 2;
				Bench = 4;
				BasePart = 10;
				Throw = 3;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 21;
				Wood = 1550;
				Stone = 8100;
				Metal = 41000;
				Steel = 41000 * 2;
				BenchWood = 2.5;
				BenchBarrel = 15;
			};
			Nodes = {
				Stone = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.6;
				};
				Metal = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.6;
				};
				Phosphate = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.6;
				};
			};
			Logs = {
				HitsToBreak = 10;
				Mult = 0.6;
			};
			Cactus = {
				Small = {
					HitsToBreak = 5;
					Mult = 0.6;
				};
				Medium = {
					HitsToBreak = 10;
					Mult = 0.6;
				};
				Large = {
					HitsToBreak = 15;
					Mult = 0.6;
				};
			};
			Trees = {
				Desert = {
					HitsToBreak = 14;
					SparkMult = 2;
					Mult = 0.6;
				};
				Small = {
					HitsToBreak = 19;
					SparkMult = 2;
					Mult = 0.6;
				};
				Medium = {
					HitsToBreak = 24;
					SparkMult = 2;
					Mult = 0.6;
				};
				Giant = {
					HitsToBreak = 29;
					SparkMult = 2;
					Mult = 0.6;
				};
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 11;
					Mult = 0.4;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 10;
					Mult = 0.4;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};
	
	["Carrot Blade"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local = CFrame.new( 0.0429758094, -0.533661604, -0.128225714, 1, -8.40779079e-45, 8.40779079e-45, 8.40779079e-45, 1, -8.40779079e-45, -8.40779079e-45, 8.40779079e-45, 1);
			LocalUse = CFrame.new(-0.538181007, -0.69784683, -0.138619661, 0.985808969, -0.150060594, 0.0749957785, 0.162847772, 0.963356495, -0.213055477, -0.0402772278, 0.222248882, 0.974134088);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Logic = "Normal";
				Velocity = 55;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, 7.5};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(-90), 0);
				LandOffset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0.5, -0.75, 0);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 0.9;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 2;
				SprintMoveBackward = 3;
			};
		};
		Melee = {
			MaxRange = 5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(5, 0.2, 0.2)};
				{1, MeleeChecks.Default(5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 30;
				Chest = 20;
				Arms = 20;
				Legs = 15;
				Bleed = 4;
			};
			ThrowDamages = {
				Head = 48;
				Chest = 32;
				Arms = 32;
				Legs = 24;
				Bleed = 2;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 2;
				Bench = 4;
				BasePart = 10;
				Throw = 3;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 21;
				Wood = 1550;
				Stone = 8100;
				Metal = 41000;
				Steel = 41000 * 2;
				BenchWood = 2.5;
				BenchBarrel = 15;
			};
			Nodes = {
				Stone = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.6;
				};
				Metal = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.6;
				};
				Phosphate = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.6;
				};
			};
			Logs = {
				HitsToBreak = 10;
				Mult = 0.6;
			};
			Cactus = {
				Small = {
					HitsToBreak = 5;
					Mult = 0.6;
				};
				Medium = {
					HitsToBreak = 10;
					Mult = 0.6;
				};
				Large = {
					HitsToBreak = 15;
					Mult = 0.6;
				};
			};
			Trees = {
				Desert = {
					HitsToBreak = 14;
					SparkMult = 2;
					Mult = 0.6;
				};
				Small = {
					HitsToBreak = 19;
					SparkMult = 2;
					Mult = 0.6;
				};
				Medium = {
					HitsToBreak = 24;
					SparkMult = 2;
					Mult = 0.6;
				};
				Giant = {
					HitsToBreak = 29;
					SparkMult = 2;
					Mult = 0.6;
				};
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 11;
					Mult = 0.4;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 10;
					Mult = 0.4;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};

	["Steel Pickaxe"] = {
		Offsets = {
			Global = CFrame.new(-0.0097, -0.1736, -0.8023, 1, 0.0001, -0, 0.0001, -0, 1, 0.0001, -1, -0);
			Local = CFrame.new(-0.238, -0.0735, 0.1723, 1, 0, 0, 0, 1, 0, 0, 0, 1);
			LocalUse = CFrame.new(-0.238, -0.0798, -0.6528, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(8);
				Logic = "Normal";
				Velocity = 50;
				GravityMult = 0.4;
				SpinSpeed = {-6, 0, 0};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(0), 0);
				LandOffset = CFrame.Angles(math.rad(30), math.rad(180), 0) * CFrame.new(0, -1.1, 0.5);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1.5;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = .8;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.6;
				SprintMoveDown = 2;
				SprintMoveBackward = 1;
			};
		};
		Melee = {
			MaxRange = 5.5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(5.5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(5.5, 0.2, 0.2)};
				{1, MeleeChecks.Default(5.5, 0.2, 0.2)};
			};
			BounceMult = 0.9;
			HumanoidDamages = {
				Head = 60;
				Chest = 40;
				Arms = 40;
				Legs = 30;
				Bleed = 7;
			};
			ThrowDamages = {
				Head = 90;
				Chest = 60;
				Arms = 60;
				Legs = 45;
				Bleed = 8;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 3;
				Bench = 6;
				BasePart = 15;
				Throw = 4;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 8;
				Wood = 430;
				Stone = 1362;
				Metal = 6906;
				Steel = 6906 * 2;
				BenchWood = 5;
				BenchBarrel = 11;
			};
			Nodes = {
				Stone = {
					HitsToBreak = 9;
					SparkMult = 2;
					Mult = 1;
				};
				Metal = {
					HitsToBreak = 9;
					SparkMult = 2;
					Mult = 1;
				};
				Phosphate = {
					HitsToBreak = 9;
					SparkMult = 2;
					Mult = 1;
				};
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 9;
					Mult = 0.75;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 9;
					Mult = 0.75;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};

	["Wooden Spear"] = {
		Offsets = {
			Global = CFrame.new(-0.0196, -0.1961, -0.0096, 0, 0.0001, 1, 0, 1, 0, -0.9999, 0.0001, 0);
			Local = CFrame.new(-0.7787, -0.1986, 0.2951, 0.9875, -0.1576, -0.0094, 0.1556, 0.981, -0.1161, 0.0276, 0.1133, 0.9932);
			LocalUse = CFrame.new(-0.8928442, -0.242026985, 0.514454186, 0.911695421, -0.410821944, 0.00587406289, 0.402106851, 0.889236391, -0.218097121, 0.0843757689, 0.201200515, 0.975907624);
			Aim = CFrame.new(-0.551757753, -0.177877635, 0.30824694, 0.987818241, -0.146761477, -0.0514304191, 0.143076792, 0.987271965, -0.069209449, 0.0609331839, 0.0610083342, 0.996260107);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(5);
				Logic = "Normal";
				Velocity = 80;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, 0};
				RotateDynamically = true;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(180), 0);
				LandOffset = CFrame.new(0, 0, -1.5);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1.3;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = true;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
		};
		Melee = {
			MaxRange = 7.5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(7.5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(7.5, 0.2, 0.2)};
				{1, MeleeChecks.Default(7.5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 38;
				Chest = 25;
				Arms = 25;
				Legs = 19;
				Bleed = 6;
			};
			ThrowDamages = {
				Head = 60;
				Chest = 40;
				Arms = 40;
				Legs = 30;
				Bleed = 8;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1.25;
				Humanoid = 1;
				Bench = 2.5;
				BasePart = 5;
				Throw = 1;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 20;
				Wood = 1120;
				Stone = 4180;
				Metal = 23200;
				Steel = 46400;
				BenchWood = 2.5;
				BenchBarrel = 7;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0.2;
		};
	};

	["Stone Spear"] = {
		Offsets = {
			Global = CFrame.new(-0.0196, -0.1961, -0.0096, 0, 0.0001, 1, 0, 1, 0, -0.9999, 0.0001, 0);
			Local = CFrame.new(-0.7787, -0.1986, 0.2951, 0.9875, -0.1576, -0.0094, 0.1556, 0.981, -0.1161, 0.0276, 0.1133, 0.9932);
			LocalUse = CFrame.new(-0.8928442, -0.242026985, 0.514454186, 0.911695421, -0.410821944, 0.00587406289, 0.402106851, 0.889236391, -0.218097121, 0.0843757689, 0.201200515, 0.975907624);
			Aim = CFrame.new(-0.551757753, -0.177877635, 0.30824694, 0.987818241, -0.146761477, -0.0514304191, 0.143076792, 0.987271965, -0.069209449, 0.0609331839, 0.0610083342, 0.996260107);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(5);
				Logic = "Normal";
				Velocity = 80;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, 0};
				RotateDynamically = true;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(180), 0);
				LandOffset = CFrame.new(0, 0, -1.5);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1.3;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = true;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 0;
				SprintMoveBackward = 0;
			};
		};
		Melee = {
			MaxRange = 7.5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(7.5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(7.5, 0.2, 0.2)};
				{1, MeleeChecks.Default(7.5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 53;
				Chest = 35;
				Arms = 35;
				Legs = 26;
				Bleed = 6;
			};
			ThrowDamages = {
				Head = 84;
				Chest = 56;
				Arms = 56;
				Legs = 42;
				Bleed = 8;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1.25;
				Humanoid = 1;
				Bench = 2.5;
				BasePart = 6;
				Throw = 1;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 20 * 0.75;
				Wood = 1120 * 0.75;
				Stone = 4180 * 0.75;
				Metal = 23200 * 0.75;
				Steel = 46400 * 0.75;
				BenchWood = 3.2;
				BenchBarrel = 9;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0.2;
		};
	};

	["Boulder"] = {
		Offsets = {
			Global = CFrame.new(-0.0126, -0.3809, -0.0042, -1, 0, -0, 0, 1, 0, 0.0001, 0, -1);
			Local = CFrame.new(-0.271, -0.0755, -0.3162, 1, -0, 0.0001, 0.0001, 1, -0, -0, 0.0001, 1);
			LocalUse = CFrame.new(-0.193, 0.4544, -0.1361, 1, -0, 0.0001, 0.0001, 1, -0, -0, 0.0001, 1);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(7);
				Logic = "Normal";
				Velocity = 55;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, 10};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(0, math.rad(45), 0);
				LandOffset = CFrame.new(0, 0, -0.5);
				Stick = false;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1.5;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1.5;
				MouseSway = 1.1;
				SprintTilt = 0.9;
				SprintMoveDown = 3;
				SprintMoveBackward = 0;
			};
		};
		Melee = {
			MaxRange = 4.5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(4.5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(4.5, 0.2, 0.2)};
				{1, MeleeChecks.Default(4.5, 0.2, 0.2)};
			};
			BounceMult = 0.85;
			HumanoidDamages = {
				Head = 15;
				Chest = 10;
				Arms = 10;
				Legs = 8;
				Bleed = 3;
			};
			ThrowDamages = {
				Head = 24;
				Chest = 16;
				Arms = 16;
				Legs = 12;
				Bleed = 4;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 2;
				Bench = 4;
				BasePart = 10;
				Throw = 3;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 29;
				Wood = 7240;
				Stone = 14720;
				Metal = 58000;
				Steel = 116000;
				BenchWood = 1.25;
				BenchBarrel = 3.25;
			};
			Nodes = {
				Stone = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.375;
				};
				Metal = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.375;
				};
				Phosphate = {
					HitsToBreak = 25;
					SparkMult = 2;
					Mult = 0.375;
				};
			};
			Trees = {
				Desert = {
					HitsToBreak = 19;
					SparkMult = 2;
					Mult = 0.45;
				};
				Small = {
					HitsToBreak = 23;
					SparkMult = 2;
					Mult = 0.45;
				};
				Medium = {
					HitsToBreak = 27;
					SparkMult = 2;
					Mult = 0.45;
				};
				Giant = {
					HitsToBreak = 31;
					SparkMult = 2;
					Mult = 0.45;
				};
			};
			Logs = {
				HitsToBreak = 10;
				Mult = 0.45;
			};
			Cactus = {
				Small = {
					HitsToBreak = 5;
					Mult = 0.45;
				};
				Medium = {
					HitsToBreak = 10;
					Mult = 0.45;
				};
				Large = {
					HitsToBreak = 15;
					Mult = 0.45;
				};
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 8;
					Mult = 0.4;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 8;
					Mult = 0.4;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0.28;
		};
	};

	["Steel Shovel"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local =  CFrame.new(-0.046, -0.27, -0.0599, 1, 0, 0, 0, 1, 0, 0, 0, 1);
			LocalUse =  CFrame.new(-0.0799, -0.0439, -0.06, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(8);
				Logic = "Normal";
				Velocity = 45;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, -7.5};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(math.rad(180), math.rad(90), 0);
				LandOffset = CFrame.Angles(math.rad(-90), 0, 0) * CFrame.new(0, 1.1, 0);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1.35;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1;
				SprintMoveBackward = 1.5;
			};
		};
		Melee = {
			MaxRange = 6;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(6, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(6, 0.2, 0.2)};
				{1, MeleeChecks.Default(6, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 60;
				Chest = 40;
				Arms = 40;
				Legs = 30;
				Bleed = 4;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 4;
				Bench = 5;
				BasePart = 20;
				Throw = 6;
			};
			ThrowDamages = {
				Head = 75;
				Chest = 50;
				Arms = 50;
				Legs = 38;
				Bleed = 6;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 18 * 0.6;
				Wood = 3500 * 0.6;
				Stone = 20000 * 0.6;
				Metal = 60000 * 0.6;
				Steel = 120000 * 0.6;
				BenchWood = 4;
				BenchBarrel = 21;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};

	["Salvaged Shovel"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local =  CFrame.new(-0.046, -0.27, -0.0599, 1, 0, 0, 0, 1, 0, 0, 0, 1);
			LocalUse =  CFrame.new(-0.0799, -0.0439, -0.06, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(8);
				Logic = "Normal";
				Velocity = 50;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, -7.5};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(math.rad(180), math.rad(90), 0);
				LandOffset = CFrame.Angles(math.rad(-90), 0, 0) * CFrame.new(0, 0.65, 0);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1.3;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1;
				SprintMoveBackward = 1.5;
			};
		};
		Melee = {
			MaxRange = 6;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(6, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(6, 0.2, 0.2)};
				{1, MeleeChecks.Default(6, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 36;
				Chest = 24;
				Arms = 24;
				Legs = 18;
				Bleed = 3;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 3;
				Bench = 2.5;
				BasePart = 10;
				Throw = 4;
			};
			ThrowDamages = {
				Head = 45;
				Chest = 30;
				Arms = 30;
				Legs = 23;
				Bleed = 5;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 18;
				Wood = 3500;
				Stone = 20000;
				Metal = 60000;
				Steel = 120000;
				BenchWood = 1.5;
				BenchBarrel = 7;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};

	["ez shovel"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local =  CFrame.new(-0.046, -0.27, -0.0599, 1, 0, 0, 0, 1, 0, 0, 0, 1);
			LocalUse =  CFrame.new(-0.0799, -0.0439, -0.06, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			Auto = true;
			--[[DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(8);
				Logic = "Normal";
				Velocity = 45;
				GravityMult = 0.4;
				SpinSpeed = {0, 0, -7.5};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(math.rad(180), math.rad(90), 0);
				LandOffset = CFrame.Angles(math.rad(-90), 0, 0) * CFrame.new(0, 0.65, 0);
				Stick = true;
			};]]
			CanSprintWhileAttacking = true;
			Cooldown = 1.3;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1;
				SprintMoveBackward = 1.5;
			};
		};
		Melee = {
			MaxRange = 6;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(6, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(6, 0.2, 0.2)};
				{1, MeleeChecks.Default(6, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 420;
				Chest = 420;
				Arms = 420;
				Legs = 420;
				Bleed = 0;
			};
			SoftSideMult = 10;
			--[[ThrowDamages = {
				Head = 100;
				Chest = 100;
				Arms = 100;
				Legs = 100;
				Bleed = 0;
			};]]
		};
		ObjectDamages = {
			Benches = {
				Twig = 1;
				Wood = 1;
				Stone = 1;
				Metal = 1;
				Steel = 1;
				BenchWood = 1000;
				BenchBarrel = 1000;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			--[[Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};]]
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};
	
	["Saw Bat"] = {
		Offsets = {
			Global = CFrame.new(0.0056, -0.1169, -1.3109, 1, 0, 0, 0, 1, 0, 0, 0, 1);
			Local =  CFrame.new(-0.046, -0.27, -0.0599, 1, 0, 0, 0, 1, 0, 0, 0, 1);
			LocalUse =  CFrame.new(-0.0799, -0.0439, -0.06, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(8.5);
				Logic = "Normal";
				Velocity = 40;
				GravityMult = 0.4;
				SpinSpeed = {-7, 0, 0};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(math.rad(90), 0, 0);
				LandOffset = CFrame.Angles(math.rad(150), 0, 0) * CFrame.new(0, 0, 1.2);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			SwingAnimSpeed = 0.75;
			Cooldown = 1.6;
			UsePositionTimes = {
				Start = 0.08;
				End = 0.75;
				Alpha = 0.06;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1;
				SprintMoveBackward = 1.5;
			};
		};
		Melee = {
			MaxRange = 6.5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(6.5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(6.5, 0.2, 0.2)};
				{1, MeleeChecks.Default(6.5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 83;
				Chest = 55;
				Arms = 55;
				Legs = 42;
				Bleed = 8;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 2;
				Humanoid = 2;
				Bench = 6;
				BasePart = 25;
				Throw = 5;
			};
			ThrowDamages = {
				Head = 90;
				Chest = 60;
				Arms = 60;
				Legs = 45;
				Bleed = 6;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 18 * 0.4;
				Wood = 3700 * 0.4;
				Stone = 20000 * 0.4;
				Metal = 60000 * 0.4;
				Steel = 120000 * 0.4;
				BenchWood = 6;
				BenchBarrel = 15;
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 7;
					Mult = 0.75;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 6;
					Mult = 0.75;
				};
			};
			Cactus = {
				Small = {
					HitsToBreak = 4;
					Mult = 0.75;
				};
				Medium = {
					HitsToBreak = 6;
					Mult = 0.75;
				};
				Large = {
					HitsToBreak = 8;
					Mult = 0.75;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1.25, 1.25, 1.25);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};
	
	["Machete"] = {
		Offsets = {
			Global = CFrame.new(0.0277, -0.1464, -1.0165, 1, 0, 0, 0, 1, 0, 0, 0, 1);
			Local =  CFrame.new(-0.04, -0.0093, -0.2099, 1, 0, 0, 0, 1, 0, 0, 0, 1);
			LocalUse =  CFrame.new(-0.0799, -0.0439, -0.06, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			Auto = true;
			DefaultZoomLevel = 0.9;
			AimDownSpeed = {
				In = 0.5;
				Out = 0.5;
			};
			ThrowInfo = {
				Offset = math.rad(8);
				Logic = "Normal";
				Velocity = 50;
				GravityMult = 0.4;
				SpinSpeed = {-7.5, 0, 0};
				RotateDynamically = false;
				ThrowCFrameOffset = CFrame.Angles(math.rad(90), 0, 0);
				LandOffset = CFrame.Angles(math.rad(150), 0, 0) * CFrame.new(0, 0, 1.2);
				Stick = true;
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1.25;
			UsePositionTimes = {
				Start = 0.05;
				End = 0.6;
				Alpha = 0.07;
				PlayOnMiss = false;
			};
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1;
				SprintMoveBackward = 1.5;
			};
		};
		Melee = {
			MaxRange = 5.5;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(5.5, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(5.5, 0.2, 0.2)};
				{1, MeleeChecks.Default(5.5, 0.2, 0.2)};
			};
			BounceMult = 0.75;
			HumanoidDamages = {
				Head = 60;
				Chest = 40;
				Arms = 40;
				Legs = 30;
				Bleed = 4;
			};
			SoftSideMult = 10;
			Durabilities = {
				Breakable = 1;
				Humanoid = 2;
				Bench = 4;
				BasePart = 20;
				Throw = 5;
			};
			ThrowDamages = {
				Head = 75;
				Chest = 50;
				Arms = 50;
				Legs = 38;
				Bleed = 6;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 20 * 0.55;
				Wood = 1120 * 0.55;
				Stone = 4180 * 0.6;
				Metal = 23200 * 0.6;
				Steel = 46400 * 0.6;
				BenchWood = 3.75;
				BenchBarrel = 10;
			};
			Animals = {
				PREFAB_ANIMAL_DEER = {
					HitsToBreak = 9;
					Mult = 0.95;
				};
				PREFAB_ANIMAL_WILDBOAR = {
					HitsToBreak = 8;
					Mult = 0.95;
				};
			};
			Trees = {
				Desert = {
					HitsToBreak = 12;
					SparkMult = 2;
					Mult = 0.4;
				};
				Small = {
					HitsToBreak = 16;
					SparkMult = 2;
					Mult = 0.4;
				};
				Medium = {
					HitsToBreak = 20;
					SparkMult = 2;
					Mult = 0.4;
				};
				Giant = {
					HitsToBreak = 24;
					SparkMult = 2;
					Mult = 0.4;
				};
			};
			Logs = {
				HitsToBreak = 8;
				Mult = 0.4;
			};
			Cactus = {
				Small = {
					HitsToBreak = 4;
					Mult = 0.4;
				};
				Medium = {
					HitsToBreak = 6;
					Mult = 0.4;
				};
				Large = {
					HitsToBreak = 8;
					Mult = 0.4;
				};
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
			Aiming = {
				Hide = false;
				Idle = 25;
				Moving = 25;
				ShootingExtra = 0;
			};
		};
		Shake = {
			Strength = Vector3.new(1, 1, 1);
			Speed = 1;
			Angles = {-75, 75};
			SnapBack = true;
			DelayTime = 0;
		};
	};

	------ [[MISCELLANEOUS]] ------
	["Blueprint"] = {
		Offsets = {
			Global = CFrame.new(-0.0002, 0.0003, 0.0005, 0.0001, 0, -1, 0, 1, 0, 1, 0, 0.0001);
			Local = CFrame.new();
		};
	};

	["Hammer"] = {
		Offsets = {
			Global = CFrame.new(0.128, -0.3583, -0.6082, 0, 0, -0.9999, 0.9136, 0.4068, 0, 0.4068, -0.9135, 0);
			Local = CFrame.new( 0.0429758094, -0.533661604, -0.128225714, 1, -8.40779079e-45, 8.40779079e-45, 8.40779079e-45, 1, -8.40779079e-45, -8.40779079e-45, 8.40779079e-45, 1);
			LocalUse = CFrame.new(-0.538181007, -0.69784683, -0.138619661, 0.985808969, -0.150060594, 0.0749957785, 0.162847772, 0.963356495, -0.213055477, -0.0402772278, 0.222248882, 0.974134088);
		};
		Weapon = {
			Auto = true;
			CanSprintWhileAttacking = true;
			Cooldown = 0.72;
			UsePositionTimes = {
				Start = 0.04;
				End = 0.48;
				Alpha = 0.08;
				PlayOnMiss = false;
			};
			SwingAnimSpeed = 1.2;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 4;
				SprintMoveBackward = 3;
			};
		};
		Melee = {
			MaxRange = 10;
			MeleeChecks = {
				{0.6, MeleeChecks.Default(10, 0.2, 0.2)};
				{0.8, MeleeChecks.Default(10, 0.2, 0.2)};
				{1, MeleeChecks.Default(10, 0.2, 0.2)};
			};
			BounceMult = 0.25;
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};

	["Lighter"] = {
		Offsets = {
			Global = CFrame.new(-0.0058, -0.2429, -0.3194, 1, 0, 0, 0, 0, 1, 0, -1, 0);
			Local = CFrame.new();
		};
		Weapon = {
			CanSprintWhileAttacking = true;
			Cooldown = 1.4;
			EquipAnimSpeed = 1;
			SwingSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 0.9;
				SprintMoveBackward = 1;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};

	["Yellow Keycard"] = {
		Offsets = {
			Global = CFrame.new(-0.164, -0.2533, -0.3431, 1, 0, 0.0001, 0, 1, 0, -0, 0, 1);
			Local = CFrame.new();
		};
		Weapon = {
			CanSprintWhileAttacking = true;
			Cooldown = 1;
			EquipAnimSpeed = 1;
			SwingSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 0.9;
				SprintMoveBackward = 1;
			};
			KeycardColor = "Yellow";
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};

	["Purple Keycard"] = {
		Offsets = {
			Global = CFrame.new(-0.164, -0.2533, -0.3431, 1, 0, 0.0001, 0, 1, 0, -0, 0, 1);
			Local = CFrame.new();
		};
		Weapon = {
			CanSprintWhileAttacking = true;
			Cooldown = 1;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 0.9;
				SprintMoveBackward = 1;
			};
			KeycardColor = "Purple";
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};

	["Pink Keycard"] = {
		Offsets = {
			Global = CFrame.new(-0.164, -0.2533, -0.3431, 1, 0, 0.0001, 0, 1, 0, -0, 0, 1);
			Local = CFrame.new();
		};
		Weapon = {
			CanSprintWhileAttacking = true;
			Cooldown = 1;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 0.9;
				SprintMoveBackward = 1;
			};
			KeycardColor = "Pink";
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};

	["Bandage"] = {
		Offsets = {
			Global = CFrame.new(-0.0031, -0.154, -0.2158, 1, 0, 0, 0, 1, 0, 0, 0, 1);
			Local = CFrame.new(-0.0179, -0.026, 0.0942, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			CanSprintWhileAttacking = true;
			Cooldown = 4;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1;
				SprintMoveBackward = 1;
			};
			HealthItem = true;
			AnimationTimeScale = 0.55;
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};

	["Small Medkit"] = {
		Offsets = {
			Global = CFrame.new(-196.4214, -0.0628, -116.1838, -1, 0, 0, 0, 0, -1, 0, -1, 0);
			Local = CFrame.new(-0.0459, -0.1859, 0.0223, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			CanSprintWhileAttacking = true;
			Cooldown = 2.75;
			EquipAnimSpeed = 1.25;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1;
				SprintMoveBackward = 1;
			};
			HealthItem = true;
			AnimationTimeScale = 1.05;
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};

	["Timed Charge"] = {
		Offsets = {
			Global = CFrame.new(-0.0127, -0.2815, -0.0174, 0, 0, -1, 0, -1, 0, -1, 0, 0);
			Local = CFrame.new(0.043, -0.0276, -0.1282, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			ThrowInfo = {
				Offset = math.rad(6);
				Logic = "AlwaysStick";
				Velocity = 40;
				GravityMult = 0.5;
				ThrowCFrameOffset = CFrame.Angles(math.rad(90), 0, 0);
				LandOffset = CFrame.Angles(math.rad(-90), math.rad(180), 0);
				Explosive = {
					Radius = 14;
					HumanoidMaxDamage = 150;
					SoftSideMult = 1;
					DamagePrefix = "";
					HumanoidOnly = true;
					ShakeStrength = 0.9;
					Duration = 0.45;
					SoundName = "C4";
					DistanceBenchDamage = false;
				};
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 2;
				MouseSway = 1.5;
				SprintTilt = 0.9;
				SprintMoveDown = 2;
				SprintMoveBackward = 1.5;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 0.02;
				Wood = 0.85;
				Stone = 1.9;
				Metal = 3.8;
				Steel = 7.6;
				BenchWood = 400;
				BenchBarrel = 400;
				BenchVehicle = 400;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};

	["Dynamite Bundle"] = {
		Offsets = {
			Global = CFrame.new(-0.0127, -0.2815, -0.0174, 0, 0, -1, 0, -1, 0, -1, 0, 0);
			Local = CFrame.new(0.043, -0.0276, -0.1282, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			ThrowInfo = {
				Offset = math.rad(6);
				Logic = "AlwaysStick";
				Velocity = 40;
				GravityMult = 0.5;
				ThrowCFrameOffset = CFrame.new();
				LandOffset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, 0, 0.25);
				Explosive = {
					Radius = 12;
					HumanoidMaxDamage = 150;
					SoftSideMult = 1;
					DamagePrefix = "";
					HumanoidOnly = true;
					ShakeStrength = 0.6;
					Duration = 0.3;
					SoundName = "DynamiteBundle";
					DistanceBenchDamage = false;
				};
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1.5;
				SprintMoveBackward = 1.5;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 0.1;
				Wood = 2.7;
				Stone = 9.8;
				Metal = 22.6;
				Steel = 45.2;
				BenchWood = 90;
				BenchBarrel = 120;
				BenchVehicle = 50;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};

	["Dynamite Stick"] = {
		Offsets = {
			Global = CFrame.new(-0.0127, -0.2815, -0.0174, 0, 0, -1, 0, -1, 0, -1, 0, 0);
			Local = CFrame.new(0.043, -0.0276, -0.1282, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			ThrowInfo = {
				Offset = math.rad(3);
				Logic = "PlaceableGrenade";
				Velocity = 80;
				GravityMult = 0.5;
				ThrowCFrameOffset = CFrame.new();
				LandOffset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(0, 0, -0.18);
				Explosive = {
					Radius = 12;
					HumanoidMaxDamage = 150;
					SoftSideMult = 1;
					DamagePrefix = "";
					HumanoidOnly = false;
					ShakeStrength = 0.4;
					Duration = 0.25;
					SoundName = "DynamiteStick";
					DistanceBenchDamage = true;
				};
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1.5;
				SprintMoveBackward = 1.5;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 0.1 * 4.5;
				Wood = 2.7 * 4.5;
				Stone = 9.8 * 4.5;
				Metal = 22.6 * 4.5;
				Steel = 45.2 * 4.5;
				BenchWood = 90 / 4.5;
				BenchBarrel = 120 / 4.5;
				BenchVehicle = 5.25;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};
	
	["Military Grenade"] = {
		Offsets = {
			Global = CFrame.new(-0.0127, -0.2815, -0.0174, 0, 0, -1, 0, -1, 0, -1, 0, 0);
			Local = CFrame.new(0.043, -0.0276, -0.1282, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			ThrowInfo = {
				Offset = math.rad(3);
				Logic = "PlaceableGrenade";
				Velocity = 80;
				GravityMult = 0.5;
				ThrowCFrameOffset = CFrame.new();
				LandOffset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(0, 0, -0.18);
				Explosive = {
					Radius = 12;
					HumanoidMaxDamage = 160;
					SoftSideMult = 1;
					DamagePrefix = "";
					HumanoidOnly = false;
					ShakeStrength = 0.4;
					Duration = 0.25;
					SoundName = "MilitaryGrenade";
					DistanceBenchDamage = true;
				};
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1.5;
				SprintMoveBackward = 1.5;
			};
		};
		ObjectDamages = {
			Benches = {
				Twig = 0.1 * 18;
				Wood = 2.7 * 18;
				Stone = 9.8 * 18;
				Metal = 22.6 * 18;
				Steel = 45.2 * 18;
				BenchWood = 90 / 18;
				BenchBarrel = 120 / 18;
				BenchVehicle = 25;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};
	
	["Care Package Signal"] = {
		Offsets = {
			Global = CFrame.new(-0.0127, -0.2815, -0.0174, 0, 0, -1, 0, -1, 0, -1, 0, 0);
			Local = CFrame.new(0.043, -0.0276, -0.1282, 1, 0, 0, 0, 1, 0, 0, 0, 1);
		};
		Weapon = {
			ThrowInfo = {
				Offset = math.rad(3);
				Logic = "Grenade";
				Velocity = 80;
				GravityMult = 0.5;
				ThrowCFrameOffset = CFrame.new();
			};
			CanSprintWhileAttacking = false;
			Cooldown = 1;
			EquipAnimSpeed = 1;
			VMMovementMults = {
				Bobbing = 1;
				MouseSway = 1;
				SprintTilt = 0.9;
				SprintMoveDown = 1.5;
				SprintMoveBackward = 1.5;
			};
		};
		Spread = {
			Hip = {
				Hide = true;
				Idle = 0;
				Moving = 0;
				ShootingExtra = 0;
			};
		};
	};
}

for _, info in pairs(ToolInfo) do
	local objDmgs = info.ObjectDamages
	if not objDmgs then continue end
	local benchDmgs = objDmgs.Benches
	if not benchDmgs then continue end
	for name, num in pairs(benchDmgs) do
		if num == 0 or name:find("Bench") then continue end
		benchDmgs[name] = (name:find("Twig") and 10 or (name:find("Wood") and 250 or (name:find("Stone") and 500 or (name:find("Metal") and 1000 or 2000)))) / num
	end
end

return ToolInfo