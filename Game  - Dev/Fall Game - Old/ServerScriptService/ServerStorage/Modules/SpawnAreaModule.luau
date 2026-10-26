-- [PATH] ServerStorage / Modules / SpawnAreaModule @Type ModuleScript
--[[
	SpawnAreaContainers
	by ChickenBagelz
	January 30, 2023
	
	Holds information for each spawn area (what to spawn, amount to spawn, etc)
]]


-- Services
local Run = game:GetService("RunService")

-- Tables
local SpawnAreaInfos = {
	{"PlainSpawns", {
		Counts = {
			{
				Type = "Forest";
				Subtype = "Boulder";
				Count = 150;
				Saveable = true;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Sand = true;
					Sandstone = true;
				};
				MaxAngle = 30;
			};
			{
				Type = "Forest";
				Subtype = "Bush";
				Count = 750;
				Saveable = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
			};
			{
				Type = "Forest";
				Subtype = "Fern";
				Count = 750;
				Saveable = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
			};

			{
				Type = "DigPiles";
				Count = 40;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Asphalt = true;
					CrackedLava = true;
				};
			};
			
			--[[{
				Type = "Small Gift";
				Count = 80;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Medium Gift";
				Count = 40;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Large Gift";
				Count = 20;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};]]
			
			--[[{
				Type = "Small Egg";
				Count = 80;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Medium Egg";
				Count = 40;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Large Egg";
				Count = 20;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};]]

			{
				Type = "Forest";
				Subtype = "Log";
				Count = 200;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
				MaxAngle = 20;
			};

			{
				Type = "Plants";
				Subtype = "Cloth Plant";
				Count = 350;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
				MaxAngle = 35;
			};

			{
				Type = "Stone_Node";
				Count = 300;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Sand = true;
					Sandstone = true;
					Ground = true;
					Snow = true;
				};
			};
			{
				Type = "Metal_Node";
				Count = 170;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Sand = true;
					Sandstone = true;
					Ground = true;
					Snow = true;
				};
			};
			{
				Type = "Phosphate_Node";
				Count = 170;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Sand = true;
					Sandstone = true;
					Ground = true;
					Snow = true;
				};
			};

			{
				Type = "Forest_Trees";
				Count = 1250;
				Saveable = false;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
			};
			{
				Type = "Birch_Trees";
				Count = 210;
				Saveable = false;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
			};
		};
	}};
	{"ForestSpawns", {
		Counts = {
			{
				Type = "Forest";
				Subtype = "Boulder";
				Count = 10;
				Saveable = true;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Sand = true;
					Sandstone = true;
				};
				MaxAngle = 30;
			};
			{
				Type = "Forest";
				Subtype = "Bush";
				Count = 300;
				Saveable = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
			};
			{
				Type = "Forest";
				Subtype = "Fern";
				Count = 300;
				Saveable = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
			};
			{
				Type = "Forest";
				Subtype = "Flower";
				Count = 300;
				Saveable = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
			};

			{
				Type = "Forest";
				Subtype = "Log";
				Count = 75;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
				MaxAngle = 20;
			};

			{
				Type = "Stone_Node";
				Count = 16;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Sand = true;
					Sandstone = true;
					Ground = true;
				};
			};
			{
				Type = "Metal_Node";
				Count = 12;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Sand = true;
					Sandstone = true;
					Ground = true;
				};
			};
			{
				Type = "Phosphate_Node";
				Count = 12;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Sand = true;
					Sandstone = true;
					Ground = true;
				};
			};

			{
				Type = "Forest_Trees";
				Count = 1000;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
			};
			{
				Type = "Birch_Trees";
				Count = 300;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
				};
			};
			--[[{
				Type = "Small Gift";
				Count = 25;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Medium Gift";
				Count = 15;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Large Gift";
				Count = 10;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};]]
			--[[{
				Type = "Small Egg";
				Count = 25;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Medium Egg";
				Count = 15;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Large Egg";
				Count = 10;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};]]
		};
	}};


	{"TundraSpawns", {
		Counts = {
			{
				Type = "Tundra";
				Subtype = "Boulder";
				Count = 130;
				Saveable = true;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Ice = true;
				};
				MaxAngle = 30;
			};
			{
				Type = "Tundra";
				Subtype = "Bush";
				Count = 380;
				Saveable = true;
				Whitelist = {
					Grass = true;
					LeafyGrass = true;
					Snow = true;
				};
			};

			{
				Type = "DigPiles";
				Count = 30;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Asphalt = true;
					CrackedLava = true;
				};
			};
			
			--[[{
				Type = "Small Gift";
				Count = 20;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Medium Gift";
				Count = 9;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Large Gift";
				Count = 6;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};]]
			--[[{
				Type = "Small Egg";
				Count = 20;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Medium Egg";
				Count = 9;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Large Egg";
				Count = 6;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};]]

			{
				Type = "Tundra";
				Subtype = "Log";
				Count = 110;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Snow = true;
					Glacier = true;
				};
				MaxAngle = 20;
			};

			{
				Type = "Stone_Node";
				Count = 90;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
				};
			};
			{
				Type = "Metal_Node";
				Count = 80;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
				};
			};
			{
				Type = "Phosphate_Node";
				Count = 70;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
				};
			};

			{
				Type = "Tundra_Trees";
				Count = 200;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Ice = true;
				};
			};
		};
	}};
	{"Tundra_ForestSpawns", {
		Counts = {
			{
				Type = "Tundra";
				Subtype = "Boulder";
				Count = 4;
				Saveable = true;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
				};
				MaxAngle = 30;
			};

			{
				Type = "Tundra";
				Subtype = "Log";
				Count = 25;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Snow = true;
					Glacier = true;
				};
				MaxAngle = 20;
			};

			{
				Type = "Tundra_Trees";
				Count = 175;
				Saveable = false;
				--CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
				};
			};
		};
	}};


	{"DesertSpawns", {
		Counts = {
			{
				Type = "Desert";
				Subtype = "Boulder";
				Count = 180;
				Saveable = true;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
					Grass = true;
					Rock = true;
				};
				MaxAngle = 30;
			};
			{
				Type = "Forest";
				Subtype = "Fern";
				Count = 130;
				Saveable = true;
				Whitelist = {
					Sand = true;
					Sandstone = true;
					Grass = true;
				};
			};
			{
				Type = "Desert";
				Subtype = "Bush";
				Count = 170;
				Saveable = true;
				Whitelist = {
					Sand = true;
					Sandstone = true;
				};
			};

			{
				Type = "DigPiles";
				Count = 30;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Asphalt = true;
					CrackedLava = true;
				};
			};

			{
				Type = "Desert";
				Subtype = "Log";
				Count = 100;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Sand = true;
					Sandstone = true;
					Grass = true;
				};
				MaxAngle = 20;
			};

			{
				Type = "Stone_Node";
				Count = 80;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
				};
			};
			{
				Type = "Metal_Node";
				Count = 50;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
				};
			};
			{
				Type = "Phosphate_Node";
				Count = 60;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
					Mud = true;
				};
			};
			--[[{
				Type = "Small Gift";
				Count = 15;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Medium Gift";
				Count = 7;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Large Gift";
				Count = 5;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};]]
			--[[{
				Type = "Small Egg";
				Count = 15;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Medium Egg";
				Count = 7;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Large Egg";
				Count = 5;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};]]
			{
				Type = "Desert";
				Subtype = "Cactus";
				Count = 700;
				Saveable = false;
				Whitelist = {
					Sand = true;
					Sandstone = true;
				};
			};
			{
				Type = "Desert_Trees";
				Count = 385;
				Saveable = false;
				Whitelist = {
					Grass = true;
				};
			};
		};
	}};

	{"SwampSpawns", {
		Counts = {
			{
				Type = "Swamp";
				Subtype = "Bush";
				Count = 100;
				Saveable = true;
				Whitelist = {
					Mud = true;
					Grass = true;
				};
			};

			{
				Type = "Forest";
				Subtype = "Log";
				Count = 50;
				Saveable = false;
				CantSpawnUnderBase = true;
				Whitelist = {
					Mud = true;
					Grass = true;
				};
				MaxAngle = 20;
			};

			{
				Type = "Stone_Node";
				Count = 8;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Metal_Node";
				Count = 5;
				Saveable = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};

			{
				Type = "Forest_Trees";
				Count = 85;
				Saveable = false;
				Whitelist = {
					Mud = true;
					Grass = true;
				};
			};
			
			--[[{
				Type = "Small Gift";
				Count = 3;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Medium Gift";
				Count = 2;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Large Gift";
				Count = 1;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};]]
			--[[{
				Type = "Small Egg";
				Count = 3;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Medium Egg";
				Count = 2;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};
			{
				Type = "Large Egg";
				Count = 1;
				Saveable = false;
				CantSpawnUnderBase = false;
				Blacklist = {
					Asphalt = true;
					Water = true;
				};
			};]]

			{
				Type = "Birch_Trees";
				Count = 15;
				Saveable = false;
				Whitelist = {
					Mud = true;
					Grass = true;
				};
			};
		};
	}};
}

local SpawnAreaModule = {}

function SpawnAreaModule:FetchSpawnInfos()
	return SpawnAreaInfos
end

function SpawnAreaModule:GetSpawnInfo(spawnName)
	for _, spawnInfo in pairs(SpawnAreaInfos) do
		local name, info = unpack(spawnInfo)
		if name ~= spawnName then continue end
		return info
	end
end

function SpawnAreaModule:Initialize()
	local mult = script:GetAttribute((Run:IsStudio() and "Studio" or "Game").."SpawnMult")
	print(mult)
	for _, spawnInfo in pairs(SpawnAreaInfos) do
		local name, info = unpack(spawnInfo)
		if name == "TestSpawns" then continue end
		for _, count in pairs(info.Counts) do
			count.Count = math.max(math.ceil(count.Count * mult), 1)
		end
	end
end

return SpawnAreaModule
