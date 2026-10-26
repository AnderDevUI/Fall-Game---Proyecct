-- [PATH] ServerScriptService / ServerService / WeatherService @Type Script
--[[
	WeatherService
	by ChickenBagelz
	October 6, 2022
	
	Handles day and night cycle as long as environmental changes
]]


-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")

-- Folders
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local Values = Replicated:WaitForChild("Values")

-- Modules
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local WeatherModule = require(ServerModules:WaitForChild("WeatherModule"))

-- Local Variables
local lastStage
local savedDawn
local doChange = false
local lastRaining = nil

while true do
	local extraTime = script:GetAttribute("ExtraTime")
	local step = (extraTime or task.wait(1/30)) * script:GetAttribute("Speed")
	if extraTime then
		--print("LIGHTING TIME PASSED", extraTime)
		script:SetAttribute("ExtraTime", nil)
	end
	local allSettings = WeatherModule:GetSettings()
	local currentKeyframes = WeatherModule:GetCurrentKeyframes()
	local clockTime = Lighting.ClockTime
	for index = #currentKeyframes, 1, -1 do
		local currentKeyframe = currentKeyframes[index]
		local currentTime = currentKeyframe.Time
		local currentStage = currentKeyframe.Stage
		if clockTime < currentTime then continue end
		if lastStage and lastStage ~= currentStage then
			-- We detected a change in the stage, check if it's turning daytime to change weather accordingly
			if currentStage == "Dawn" then
				if lastStage == "Night" then
					-- To make the transition from clear to rainy more seamless, save the last dawn keyframe and use that instead, and replace later
					local rainChance = math.random(1, 100)
					local lastDawn = shared.WeatherCurrentKeyframes[2]
					print(lastDawn)
					if rainChance <= 10 then
						print("SETTING TO RAINY LIGHTING")
						shared.WeatherCurrentKeyframes = table.clone(shared.WeatherKeyframeDays.Rain)
					else
						print("SETTING TO CLEAR LIGHTING")
						shared.WeatherCurrentKeyframes = table.clone(shared.WeatherKeyframeDays.Sun)
					end
					savedDawn = shared.WeatherCurrentKeyframes[2]
					print(savedDawn)
					shared.WeatherCurrentKeyframes[2] = lastDawn
				end
			elseif savedDawn then
				doChange = true
			end
		end
		local nextKeyframe = currentKeyframes[index == #currentKeyframes and 1 or index + 1]
		local nextTime = (nextKeyframe.Time == 0 and 24 or nextKeyframe.Time)
		local timeDiff = nextTime - currentTime
		local ratio = math.clamp((clockTime - currentTime) / timeDiff, 0, 1)
		local currentSettings = allSettings[currentKeyframe.Keyframe]
		local nextSettings = allSettings[nextKeyframe.Keyframe]
		local isRaining = Values.Raining.Value > 0.8
		--set materials based on raining or not
		if lastRaining ~= nil and isRaining ~= lastRaining then -- Make sure we only set materials when it changes to avoid unnecessary lag
			print("changing materials")
			local materials = isRaining and WeatherModule.WeatherMaterials.Rain or WeatherModule.WeatherMaterials.Default
			for matEnum, matName in pairs(materials) do
				MaterialService:SetBaseMaterialOverride(matEnum, matName)
			end
		end
		lastRaining = isRaining
		for instance, currentProperties in pairs(currentSettings) do
			local nextProperties = nextSettings[instance]
			for property, currentValue in pairs(currentProperties) do
				local nextValue = nextProperties[property]
				local valueType = typeof(currentValue)
				instance[property] = (valueType == "number" and NumberUtil:Lerp(currentValue, nextValue, ratio) or 
					((valueType == "Color3" or valueType == "Vector3") and currentValue:Lerp(nextValue, ratio) or 
						currentValue))
			end
		end
		Lighting:SetAttribute("Stage", currentStage)
		lastStage = currentStage
		Lighting.ClockTime += timeDiff / currentKeyframe.Duration * step / 60
		if doChange and savedDawn and Lighting.ClockTime > 7.5 then -- Replace saved dawn keyframe in case weather repeats
			shared.WeatherCurrentKeyframes[2] = savedDawn
			savedDawn = nil
		end
		break
	end
end