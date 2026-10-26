-- [PATH] ServerScriptService / ServerService / EventService @Type Script
--[[
	EventService
	by ChickenBagelz
	August 26, 2023

	Handles the natural spawning of events such as airdrops, helicopters, etc.
]]

-- Services
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local BTRClass = require(ServerModules:WaitForChild("BTRClass"))

-- Modules
local EventModule = require(ServerModules:WaitForChild("EventModule"))

-- Constants
local EVENT_SPAWN_BTR = script:WaitForChild("SpawnBTR")
local EVENTS_FOLD = workspace:WaitForChild("Events")
local RNG = Random.new()

--variables
shared.CurrentBTR = nil

EVENT_SPAWN_BTR.Event:Connect(function(monument : string) --spawn btr
	if not monument then return end
	if EVENTS_FOLD:FindFirstChild("BTR") then return end
	print("SPAWNING BTR AT " .. string.upper(monument))
	shared.CurrentBTR = BTRClass.new(monument)
end)


task.wait(script:GetAttribute("CarePackageFirstDelay") * 60)

while true do
	task.wait(RNG:NextNumber(script:GetAttribute("CarePackageSpawnTimeMin") * 60, script:GetAttribute("CarePackageSpawnTimeMax") * 70))
	local radius = script:GetAttribute("CarePackageSpawnRadius")
	EventModule:SpawnSupplyDrop(script:GetAttribute("CarePackageSpawnOrigin") + Vector3.new(RNG:NextNumber(-radius, radius), 0, RNG:NextNumber(-radius, radius)))
end