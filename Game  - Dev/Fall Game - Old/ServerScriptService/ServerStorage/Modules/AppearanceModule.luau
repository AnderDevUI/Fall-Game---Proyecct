-- [PATH] ServerStorage / Modules / AppearanceModule @Type ModuleScript
--With facial expressions the higher number means healthier
local Storage = game:GetService("ServerStorage")
local HairFolder = Storage:WaitForChild("Hair")

local AppearanceModule = {}

AppearanceModule.Eyes = {
	[1] = "rbxassetid://2801594973";
	[2] = "rbxassetid://2801605712";
	[3] = "rbxassetid://2801605473";
}

AppearanceModule.Mouth = {
	[1] = {
		[1] = "rbxassetid://2801767539";
		[2] = "rbxassetid://2813767341";
		[3] = "rbxassetid://2801760198";
	};
	[2] = {
		[1] = "rbxassetid://2818152574";
		[2] = "rbxassetid://2801742053";
		[3] = "rbxassetid://2801751501";
	};
	[3] = {
		[1] = "rbxassetid://2801778896";
		[2] = "rbxassetid://2818152144";
		[3] = "rbxassetid://2801751773";
	};
}

AppearanceModule.Brows = {
	[1] = "rbxassetid://2801687922";
	[2] = "rbxassetid://2801696705";
	[3] = "rbxassetid://2801687635";
	[4] = "rbxassetid://2801697189";
	[5] = "rbxassetid://3523930715";
	[6] = "rbxassetid://2801688112";
	[7] = "rbxassetid://2801716156";
	[8] = "rbxassetid://3523931344";
	[9] = "rbxassetid://3523932495";
}

AppearanceModule.Wrinkles = {
	[1] = "rbxassetid://3524043745";
	[2] = "rbxassetid://3524044387";
}

AppearanceModule.Freckles = {
	[1] = "rbxassetid://3524071308";
	[2] = "rbxassetid://3524071917";
}

AppearanceModule.BirthMark = {
	[1] = "rbxassetid://3524056624";
	[2] = "rbxassetid://3524049825";
	[3] = "rbxassetid://3524057611";
	[4] = "rbxassetid://3524058219";
}

AppearanceModule.Bruise = {
	"rbxassetid://3524033921",
	"rbxassetid://3524032382",
}

AppearanceModule.Scuff = {
	  "rbxassetid://3524040607",
	  "rbxassetid://3524039424",
}

AppearanceModule.Scar = {
	Left = {
		[1] = "rbxassetid://3524096384";
		[2] = "rbxassetid://3524094387";
		[3] = "rbxassetid://3524098445";
		[4] = "rbxassetid://3524097055";
	};
	Right = {
		[1] = "rbxassetid://3524095759";
		[2] = "rbxassetid://3524093815";
		[3] = "rbxassetid://3524097791";
		[4] = "rbxassetid://3524097055";
	};
}

AppearanceModule.Dead = {
	Eyes = "rbxassetid://2818166000";
	Mouth = "rbxassetid://2801768094";
}

AppearanceModule.SkinColors = {
	White = {
		[1] = Color3.fromRGB(234, 184, 146);
		[2] = Color3.fromRGB(198, 155, 123);
		[3] = Color3.fromRGB(170, 132, 105);
		[4] = Color3.fromRGB(198, 155, 123);
		[5] = Color3.fromRGB(162, 125, 100);
		[6] = Color3.fromRGB(144, 111, 89);
		[7] = Color3.fromRGB(255, 204, 153);
		[8] = Color3.fromRGB(239, 191, 143);
		[9] = Color3.fromRGB(239, 191, 143);
	};
	Black = {
		[1] = Color3.fromRGB(103, 48, 0);
		[2] = Color3.fromRGB(120, 93, 74);
		[3] = Color3.fromRGB(113, 87, 70);
		[4] = Color3.fromRGB(109, 83, 68);
		[5] = Color3.fromRGB(100, 76, 62);
		[6] = Color3.fromRGB(91, 69, 56);
		[7] = Color3.fromRGB(80, 61, 49);
		[8] = Color3.fromRGB(66, 50, 40);
		[9] = Color3.fromRGB(52, 39, 32);
	};
}

AppearanceModule.HairColors = {
	White = {
		[1] = Color3.fromRGB(184, 156, 110);
		[2] = Color3.fromRGB(227, 211, 86);
		[3] = Color3.fromRGB(184, 147, 101);
		[4] = Color3.fromRGB(104, 77, 59);
		[5] = Color3.fromRGB(91, 67, 52);
		[6] = Color3.fromRGB(67, 49, 38);
		[7] = Color3.fromRGB(48, 35, 27);
		[8] = Color3.fromRGB(35, 25, 20);
		[9] = Color3.fromRGB(17, 12, 10);
		[10] = Color3.fromRGB(141, 86, 41);
	};
	Black = {
		[1] = Color3.fromRGB(40, 29, 23);
		[2] = Color3.fromRGB(34, 25, 20);
		[3] = Color3.fromRGB(30, 22, 18);
		[4] = Color3.fromRGB(21, 15, 13);
		[5] = Color3.fromRGB(11, 14, 22);
		[6] = Color3.fromRGB(15, 11, 9);
		[7] = Color3.fromRGB(0, 0, 0);
		[8] = Color3.fromRGB(18, 29, 36);
		[9] = Color3.fromRGB(10, 17, 21);
	};
	Old = {
		[1] = Color3.fromRGB(166, 155, 143);
		[2] = Color3.fromRGB(106, 99, 91);
		[3] = Color3.fromRGB(124, 124, 126);
	};
	Exotic = {
		[1] = Color3.fromRGB(0, 231, 27);
		[2] = Color3.fromRGB(0, 47, 255);
		[3] = Color3.fromRGB(255, 30, 195);
		[4] = Color3.fromRGB(119, 0, 255);
		[5] = Color3.fromRGB(0, 251, 255);
	};
}

AppearanceModule.Clothing = {
	Shirt = "rbxassetid://10672670360";
	Pants = "rbxassetid://3159759976";
}

AppearanceModule.FemaleFace = "rbxassetid://2801785860"
AppearanceModule.FemaleTorso = 48474356;

return AppearanceModule