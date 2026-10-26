-- [PATH] ServerStorage / Modules / WeatherModule @Type ModuleScript
--[[
	WeatherModule
	by ChickenBagelz, nedder
	October 6, 2022
	
	Holds all information on property changes for environment
	
	
	DOCUMENTATION:
	Day and night cycle works using a keyframe system; meaning, it gets the current time of day and
	interpolates between the settings in between the two matching times.
	
	Here is how to write a proper keyframe:
	{
		Time = The time of day which this keyframe relies in.
		Duration = Amount of time, in minutes, the time of day will take to reach the next desired keyframe.
		Stage = The stage of day displayed under Lighting. Used with other scripts.
		Keyframe = Name of settings keyframe under shared.WeatherSettings. These will be applied to the keyframe.
	}
	
	NOTES:
		1. The first keyframe MUST start with a Time of 0, or else it won't work properly.
		2. To sustain a set of values along a specified timespan, use the same setting values on two similar
		   keyframes, with different Time values.
		3. To set proper duration values that scale well will the time difference between keyframes, just
		   subtract the next and current keyframe's Time value and set that to the Duration. Then, you can
		   manipulate it by, for example halfing it, which would basically double the day cycle speed. Doubling
		   the duration would in turn half the day cycle speed.
		4. All settings and keyframes are stored globally, meaning they can be edited in real-time.

	To actually set the keyframes settings, you must write a new Settings under shared.WeatherSettings, like this:
	
	KeyframeName = { <--- (KeyframeName is replaced by name desired to be used under keyframe.Keyframe)
		[Instance] = { <--- (Instance is the instance whos the tables properties will affect)
			property = desiredValue;
			
			^ Write the name of the property you wish to change and the new desired value.
		}	
	}
	
	Storing all settings separately from the keyframes will allow for different day lighting depending on the
	weather by simply changing keyframe.Keyframe to the new desired settings.
	
	BiomeTemperatureFromClock : 
	Takes a biome and a clock time,
	returns a base outdoor temperature in that biome for the time (armor will be considered later)
]]


-- Services
local Lighting = game:GetService("Lighting")
local Replicated = game:GetService("ReplicatedStorage")

-- Instances
local Bloom = Lighting:WaitForChild("Bloom")
local ColorCorrection = Lighting:WaitForChild("ColorCorrection")
local Atmosphere = Lighting:WaitForChild("Atmosphere")
local Terrain = workspace:WaitForChild("Terrain")
local Clouds = Terrain:WaitForChild("Clouds")
local Values = Replicated:WaitForChild("Values")
local Raining = Values:WaitForChild("Raining")

--Constants
local BIOME_FOLDERS = workspace:WaitForChild("SpawnAreas")

-- Global Variables
shared.WeatherSettings = {
	ClearDay = {
		[Lighting] = {
			Ambient = Lighting.Ambient;
			OutdoorAmbient = Lighting.OutdoorAmbient;
			Brightness = Lighting.Brightness;
		};
		[Clouds] = {
			Density = Clouds.Density;
			Color = Clouds.Color;
		};
		[Atmosphere] = {
			Color = Atmosphere.Color;
			Density = Atmosphere.Density;
			Decay = Atmosphere.Decay;
		};
		[Raining] = {
			Value = 0;
		};
		[workspace] = {
			GlobalWind = Vector3.new(-2.818, -0.944, 0.049)
		};
	};
	ClearNight = {
		[Lighting] = {
			Ambient = Color3.fromRGB(15, 15, 15);
			OutdoorAmbient = Color3.fromRGB(35, 35, 35);
			Brightness = 0.25;
		};
		[Clouds] = {
			Density = 0.5;
			Color = Color3.fromRGB(216, 216, 216)
		};
		[Atmosphere] = {
			Color = Color3.fromRGB(150, 150, 150);
			Decay = Color3.fromRGB(197, 226, 235);
			Density = 0.5;
		};
		[Raining] = {
			Value = 0;
		};
		[workspace] = {
			GlobalWind = Vector3.new(-2.818, -0.944, 0.049)
		}
	};
	RainyMorning = {
		[Lighting] = {
			Ambient = Color3.fromRGB(97, 97, 97);
			OutdoorAmbient = Color3.fromRGB(198, 196, 170);
			Brightness = 1.5;
		};
		[Clouds] = {
			Density = 0.6;
			Color = Color3.fromRGB(126, 126, 126);
		};
		[Atmosphere] = {
			Color = Color3.fromRGB(199, 199, 199);
			Decay = Color3.fromRGB(236, 236, 236);
			Density = 0.5;
		};
		[Raining] = {
			Value = 0;
		};
		[workspace] = {
			GlobalWind = Vector3.new(14, -2, 0.8)
		}
	};
	RainyDay = {
		[Lighting] = {
			Ambient = Color3.fromRGB(97, 97, 97);
			OutdoorAmbient = Color3.fromRGB(198 /2, 196 /2, 170 /2);
			Brightness = 1;
		};
		[Clouds] = {
			Density = 0.85;
			Color = Color3.fromRGB(126, 126, 126);
		};
		[Atmosphere] = {
			Color = Color3.fromRGB(166, 166, 166);
			Decay = Color3.fromRGB(236, 236, 236);
			Density = 0.37;
		};
		[Raining] = {
			Value = 1;
		};
		[workspace] = {
			GlobalWind = Vector3.new(17, -2, 0.8)
		}
	};
	RainyNight = {
		[Lighting] = {
			Ambient = Color3.fromRGB(52, 50, 61);
			OutdoorAmbient = Color3.fromRGB(30, 30, 55);
			Brightness = 0.3;
		};
		[Clouds] = {
			Density = 0.85;
			Color = Color3.fromRGB(72, 77, 91);
		};
		[Atmosphere] = {
			Color = Color3.fromRGB(144, 144, 144);
			Decay = Color3.fromRGB(212, 212, 212);
			Density = 0.6;
		};
		[Raining] = {
			Value = 1.1;
		};
		[workspace] = {
			GlobalWind = Vector3.new(20, -2, 0.8)
		}
	};
	
	--[[ClearNight = { OLD NIGHT
		[Lighting] = {
			Ambient = Color3.new(0, 0, 0);
			OutdoorAmbient = Color3.new(0, 0, 0);
			Brightness = 0;
		};
		[Clouds] = {
			Cover = 0.3;
		};
		[Atmosphere] = {
			Color = Color3.fromRGB(150, 150, 150);
		};
	};]]
	
}

shared.WeatherKeyframeDays = {
	Sun = {
		{
			Time = 0;
			Duration = 3.5;
			Stage = "Night";
			Keyframe = "ClearNight";
		};
		{
			Time = 5.5;
			Duration = 1;
			Stage = "Dawn";
			Keyframe = "ClearNight";
		};
		{
			Time = 6.5;
			Duration = 15;
			Stage = "Day";
			Keyframe = "ClearDay";
		};
		{
			Time = 17.5;
			Duration = 1;
			Stage = "Dusk";
			Keyframe = "ClearDay";
		};
		{
			Time = 18.5;
			Duration = 3.5;
			Stage = "Night";
			Keyframe = "ClearNight";
		};
	};
	
	Rain = {
		{
			Time = 0;
			Duration = 3.5;
			Stage = "Night";
			Keyframe = "RainyNight";
		};
		{
			Time = 5.5;
			Duration = 1;
			Stage = "Dawn";
			Keyframe = "RainyNight";
		};
		{
			Time = 6.5;
			Duration = 1;
			Stage = "Day";
			Keyframe = "RainyMorning";
		};
		{
			Time = 7.5;
			Duration = 14;
			Stage = "Day";
			Keyframe = "RainyDay";
		};
		{
			Time = 17.5;
			Duration = 1;
			Stage = "Dusk";
			Keyframe = "RainyDay";
		};
		{
			Time = 18.5;
			Duration = 3.5;
			Stage = "Night";
			Keyframe = "RainyNight";
		};
	};
};

shared.WeatherCurrentKeyframes = shared.WeatherKeyframeDays.Sun

-- Local Variables


local WeatherModule = {}

--Constants
WeatherModule.WeatherMaterials = {
	Default = {
		[Enum.Material.Asphalt] = "Road Cracked",
		[Enum.Material.Grass] = "Stylized Grass",
		[Enum.Material.LeafyGrass] = "stylized leafy grass",
		[Enum.Material.Sandstone] = "Sandstone Borderlands",
		[Enum.Material.Sand] = "Sand Borderlands",
		[Enum.Material.Cobblestone] = "Stylized Cobbstone",
		[Enum.Material.Rock] = "borderlands rock 3",
	};
	Rain = {
		[Enum.Material.Asphalt] = "Road Cracked Wet",
		[Enum.Material.Grass] = "Stylized Grass Wet",
		[Enum.Material.LeafyGrass] = "stylized leafy grass Wet",
		[Enum.Material.Sandstone] = "Sandstone Borderlands Wet",
		[Enum.Material.Sand] = "Sand Borderlands Wet",
		[Enum.Material.Cobblestone] = "Stylized Cobbstone Wet",
		[Enum.Material.Rock] = "borderlands rock 3 Wet",
	};
}

WeatherModule.BiomeTemperatureFromClock = function(biome: string, clockTime: num) --returns the base temperature number, and the string word for time of day --hard coded cancer function
	local tod = "" --Time Of Day
	local temp
	if clockTime >= 4 and clockTime <= 6 then --between 4 and 6 is morning
		tod = "Morning"
	elseif clockTime >= 6 and clockTime <= 18 then --between 6 and 18 is day
		tod = "Day"
	elseif clockTime >= 18 and clockTime <= 21 then --between 18 and 21 is dusk
		tod = "Dusk"
	else --between 21 and 4 is night
		tod = "Night"
	end
	
	if biome == "DesertSpawns" then
		temp = (tod == "Morning" or tod == "Dusk") and 15 or --Desert biome temps
					(tod == "Day" and 25 or 
					(tod == "Night" and -28))
	elseif biome == "ForestSpawns" or biome == "PlainSpawns" or biome == "SwampSpawns" then --Forest/Swamp biome temps
		temp = (tod == "Morning" or tod == "Dusk") and 15 or 
					(tod == "Day" and 20 or 
					(tod == "Night" and -8))
	elseif biome == "TundraSpawns" or biome == "Tundra_ForestSpawns" then --Winter temps
		temp = (tod == "Morning" or tod == "Dusk") and -27 or 
					(tod == "Day" and -20 or 
					(tod == "Night" and -33))
	end
	return temp
end

function WeatherModule:GetSettings()
	return shared.WeatherSettings
end

function WeatherModule:GetCurrentKeyframes()
	return shared.WeatherCurrentKeyframes
end

return WeatherModule