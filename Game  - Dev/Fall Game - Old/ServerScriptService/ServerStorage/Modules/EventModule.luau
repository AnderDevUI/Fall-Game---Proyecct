-- [PATH] ServerStorage / Modules / EventModule @Type ModuleScript
--[[
	EventModule
	by ChickenBagelz
	August 26, 2023
	
	Holds all the code for spawning in-game events like airdrops, helicopter, etc.
]]


-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")
local EventModels = Storage:WaitForChild("EventModels")
local Benches = Replicated:WaitForChild("Benches")
local Events = workspace:WaitForChild("Events")
local Bases = workspace:WaitForChild("Bases")
local VFX_PARTS = workspace:WaitForChild("VFX")
local Drops = workspace:WaitForChild("Drops")
local Plants = workspace:WaitForChild("Plants")
local Animals = workspace:WaitForChild("Animals")

-- Modules
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local TweenUtil = require(SharedModules:WaitForChild("TweenUtil"))

-- Constants
local SupplyPlane = EventModels:WaitForChild("SupplyPlane")
local PI2 = math.pi * 2
local viewFilterFunc = RaycastUtil:FilterFunction("View")

-- Local Variables
local RNG = Random.new()


local EventModule = {}

function EventModule:SpawnSupplyDrop(dropPos: Vector3, packageDroppedDeferredFunc, packageLandedFunc)
	local maxBounds = script:GetAttribute("CarePackageMaxBounds")
	-- Get the position of where the plane will spawn beforehand
	local spawnNum = RNG:NextInteger(1, 4)
	local spawnOffset = RNG:NextNumber(-maxBounds, maxBounds)
	local spawnHeight = RNG:NextNumber(script:GetAttribute("CarePackageMinHeight"), script:GetAttribute("CarePackageMaxHeight"))
	local spawnPos = Vector3.new((spawnNum == 1 and maxBounds or (spawnNum == 2 and -maxBounds or spawnOffset)), spawnHeight, (spawnNum == 3 and maxBounds or (spawnNum == 4 and -maxBounds or spawnOffset)))
	-- Align the drop position to the spawn position so we can align both Vectors
	local alignedDropPos = Vector3.new(dropPos.X, spawnPos.Y, dropPos.Z)
	local distNeededForDrop = (spawnPos - alignedDropPos).Magnitude -- Store the distance needed to travel before reaching the drop position
	-- Create the plane
	local plane = ModUtil:SafeClone(SupplyPlane)
	plane:PivotTo(CFrame.new(spawnPos, alignedDropPos))
	plane.Parent = Events
	local planePrim = plane.PrimaryPart
	local oldVolume = planePrim.Fly.Volume
	planePrim.Fly.Volume = 0
	planePrim.Fly:Play()
	TweenUtil:Tween(planePrim.Fly, "Volume", oldVolume, 10, "Linear", "InOut")
	local extraSound = planePrim:FindFirstChild("Extra")
	if extraSound then
		extraSound:Play()
	end
	local droppedPackage = false
	local packageLanded = false
	local planeDeleted = false
	local carePackage, carePackages
	local nextRaycast = 0
	local lastRaycastPos
	local packageDroppedThread
	while packageLanded == false or planeDeleted == false do
		local step = task.wait(1/20)
		local planeMoveSpeed = script:GetAttribute("CarePackagePlaneMoveSpeed")
		local packageDropSpeed = script:GetAttribute("CarePackageDropSpeed")
		local raycastInterval = script:GetAttribute("CarePackageRaycastInterval")
		local moveStep = 0
		if not planeDeleted then
			local planeCF = plane:GetPivot()
			local planePos = planeCF.Position
			if math.abs(planePos.X) > maxBounds or math.abs(planePos.Z) > maxBounds then -- Delete plane as its finished its course
				for _, part in pairs(plane:GetChildren()) do
					if part.Name == "Main" then
						part.Transparency = 1
						continue
					end
					part:Destroy()
				end
				TweenUtil:Tween(planePrim.Fly, "Volume", 0, 10, "Linear", "InOut")
				task.delay(10, function()
					if not plane.Parent then return end
					ModUtil:SafeDestroy(plane)
				end)
				planeDeleted = true
				--=print("deleting plane")
				if not droppedPackage then
					warn("CARE PACKAGE PLANE WAS DELETED BEFORE DROPPING PACKAGE", dropPos, spawnPos)
					break
				end
			end
			moveStep = planeMoveSpeed * step
			plane:PivotTo(planeCF * CFrame.new(0, 0, -moveStep))
			--print(plane:GetPivot().Position, distNeededForDrop)
		end
		if droppedPackage and not packageLanded then
			if carePackage and carePackage.Parent then -- Only move the care package downwards if its been dropped
				local packageCF = carePackage:GetPivot()
				local dropSpeed = -packageDropSpeed * step
				carePackage:PivotTo(packageCF + Vector3.new(0, dropSpeed, 0))
				nextRaycast += step
				if nextRaycast < raycastInterval then continue end
				nextRaycast = 0
				local newPackageCF = carePackage:GetPivot()
				local newPackagePos = newPackageCF.Position
				local landedOn, landPos = RaycastUtil:Raycast(lastRaycastPos, newPackagePos - lastRaycastPos, "Exclude", {VFX_PARTS, Events, carePackage, Drops, Plants, Animals, carePackages}, false, viewFilterFunc, true)
				--print("firing package ray", landedOn)
				if not landedOn then
					-- We didn't hit anything, save last pos and continue
					lastRaycastPos = newPackagePos
					continue
				end
				--print("package landed")
				carePackage:PivotTo(newPackageCF + (landPos - newPackagePos)) -- Move package to where it landed
				local parachute = carePackage:FindFirstChild("Parachute")
				if parachute and parachute.Parent then
					parachute:Destroy()
				end
				carePackage.ModelStreamingMode = Enum.ModelStreamingMode.Atomic
				packageLanded = true
				if packageLandedFunc then
					packageLandedFunc(packageDroppedThread) -- If a function that runs when the package lands was specified, run it
				end
			else
				--print("package looted before landing")
				packageLanded = true -- Care package was looted, count it as landing so we don't continue moving it 
			end
			continue -- Make sure we don't drop it twice
		end
		distNeededForDrop -= moveStep
		if droppedPackage or distNeededForDrop > 0 then continue end
		warn("dropping package", os.time())
		local packageSpawnCF = CFrame.new(alignedDropPos) * CFrame.Angles(0, RNG:NextNumber(0, PI2), 0)
		carePackages, carePackage = EventModule:CreateBench("Care Package", packageSpawnCF) -- Store package in variable for moving downwards
		
		lastRaycastPos = packageSpawnCF.Position -- Gotta make sure to set this as the raycasting needs it
		if packageDroppedDeferredFunc then
			packageDroppedThread = task.defer(packageDroppedDeferredFunc) -- If a function that runs when the package is dropped was specified, run it
		end
		droppedPackage = true
	end
end

function EventModule:CreateBench(benchName: string, spawnCF: CFrame)
	local benches = Bases.Loners:FindFirstChild(benchName)
	if not benches then
		benches = Instance.new("Folder")
		benches.Name = benchName
		benches.Parent = Bases.Loners
	end
	return benches, shared.CreateBench(Benches[benchName].Default, benchName, spawnCF, benches, 0, 0)
end

return EventModule