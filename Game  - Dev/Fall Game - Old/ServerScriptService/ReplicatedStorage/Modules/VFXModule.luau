-- [PATH] ReplicatedStorage / Modules / VFXModule @Type ModuleScript
--[[
	VFXModule
	by ChickenBagelz
	September 6th, 2022
	
	Holds VFX logic
	
	
	DOCUMENTATION:

	CreateProjectile's parameters are:
		Position,
		Direction,
		PositionFirst [OPTIONAL],
		DirectionFirst [OPTIONAL],
		FilterType,
		Filters,
		FilterFunction = function(hit) OR key of ClientFunctions -- gives hit part, returns instance to ignore if specific parameters are met [OPTIONAL],
		VisualizeRay [OPTIONAL],
		Speed,
		Gravity,
		MaxRange,
		TracerName [OPTIONAL].
		HitFunction = function(hit) OR key of ClientFunctions [OPTIONAL],
		MissFunction = function() OR key of ClientFunctions [OPTIONAL],
		StepFunction = function() OR key of ClientFunctions [OPTIONAL],
		Instant [OPTIONAL]
]]


-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Folders
local Modules = Replicated:WaitForChild("Modules")
local VFX_STORAGE = Replicated:WaitForChild("VFX")
local VFX_PARTS = workspace:WaitForChild("VFX")
local Terrain = workspace:WaitForChild("Terrain")
local Nodes = workspace:WaitForChild("Nodes")
local Animals = workspace:WaitForChild("Animals")

-- Modules
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"))
local WeldModule = require(Modules:WaitForChild("WeldModule"))
local Items = require(Modules:WaitForChild("Items"))
local ToolInfo = require(Modules:WaitForChild("ToolInfo"))
local CameraShakeModule = require(Modules:WaitForChild("CameraShakeModule"))
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))
local SoundModule
if Run:IsClient() and Players.LocalPlayer then
	SoundModule = require(Modules:WaitForChild("SoundModule"))
end
-- Local Variables
local Camera = workspace.CurrentCamera
local flashParts = {}
local lasers = {}
local lastWhizzes = {}
local localBulletId = 0
local bulletLoop
local allBullets = {}
local activeGibs = {}

local camShaker = CameraShakeModule.new(Enum.RenderPriority.Camera.Value, function(offset)
	Camera.CFrame *= offset
end)
camShaker:Start()

local hitIgnoreFilterFunc = RaycastUtil:FilterFunction("HitIgnore")


local VFXModule = {}

-- Functions
local ClientFunctions = {
	FakeHitFunc = function(...)
		VFXModule:HitVFX(...)
	end;
	FakeStepFunc = function(origin, position, localId)
		local player = Players.LocalPlayer
		if (not player) or lastWhizzes[localId] then return end
		local character = player.Character
		if not character then return end
		local head = character:FindFirstChild("Head")
		if not head then return end
		local closestPoint = RaycastUtil:GetClosestPointFromRay(origin, position, head.Position)
		if NumberUtil:IsWithin(head.Position, closestPoint, 10) then
			lastWhizzes[localId] = true
			local whizz = VFX_STORAGE.WhizzPart:Clone()
			whizz.CFrame = CFrame.new(closestPoint)
			whizz.Parent = VFX_PARTS
			local childs = whizz:GetChildren()
			childs[math.random(1, #childs)]:Play()
			Debris:AddItem(whizz, 0.5)
		end
	end;
}

function VFXModule:HitVFX(...)
	local args = {...}
	local hit = args[1]
	local started = tick()
	while hit and not hit.Parent do
		if tick() - started >= 1 then break end
		task.wait()
	end
	if not (hit and hit.Parent) then return end
	local hum = (hit.Parent:FindFirstChild("Humanoid") or hit.Parent.Parent:FindFirstChild("Humanoid"))
	local player = Players.LocalPlayer
	if hum and player and (hum.Parent == player.Character or hum.Parent.Name == "BTR") then return end
	args[2] = (typeof(args[2]) == "CFrame" and (hit.CFrame * args[2]).Position or args[2])
	local typ = (hum and "CreateBlood" or "CreateHole")
	--print(typ, ...)
	VFXModule[typ](VFXModule, unpack(args))
end

function VFXModule:FlashPart(part)
	local started = tick()
	while part and not part.Parent do
		if tick() - started >= 1 then break end
		task.wait()
	end
	if not (part and part:IsDescendantOf(workspace)) then return end
	if self:CheckCameraDistance(part.Position, 1000) then return end
	if (not flashParts[part]) or tick() - flashParts[part] >= 0.08 then
		for _, effect in pairs(part:GetChildren()) do 
			if effect:IsA("Attachment") then continue end --Guard clause for attachments
			effect.Enabled = true
		end
		task.defer(function()
			while part and part:IsDescendantOf(workspace) do
				if tick() - flashParts[part] >= 0.08 then 
					for _, effect in pairs(part:GetChildren()) do
						if effect:IsA("Attachment") then continue end --Guard clause for attachments
						effect.Enabled = false
					end
					break 
				end
				Run.RenderStepped:Wait()
			end
		end)
	end
	flashParts[part] = tick()
end

function VFXModule:InitializeLaser(laser)
	if laser and laser.Parent and laser.Parent.Name:find(" Lasersight") then
		if not table.find(lasers, laser) then
			table.insert(lasers, laser)
		end
		return
	end
	local model = laser
	local started = tick()
	while model and not model.Parent do
		if tick() - started >= 3 then break end
		task.wait()
	end
	if not (model and model.Parent) then return end
	local attachments = model:WaitForChild("Attachments", 3)
	if not (attachments and attachments.Parent) then return end
	started = os.clock()
	local attachment
	while os.clock() - started < 3 do
		if not attachments.Parent then return end
		attachment = attachments:FindFirstChild("Salvaged Lasersight")
		if attachment then break end
		attachment = attachments:FindFirstChild("Military Lasersight")
		if attachment then break end
		task.wait()
	end
	if not (attachment and attachment.Parent) then return end
	laser = attachment:WaitForChild("Laser", 3)
	if not (laser and laser.Parent and not table.find(lasers, laser)) then return end
	table.insert(lasers, laser)
end

function VFXModule:CreateGib(model, cframe, cleanupPriority, gravity, sizeMult)
	sizeMult = (sizeMult or 1)
	local totalGibs = 0
	local totalRemoved = 0
	local oldestHighIndex = 0
	for index, gibInfo in pairs(activeGibs) do
		local gib = gibInfo.Gib
		local priority = gibInfo.Priority
		if not (gib and gib.Parent) then
			table.remove(activeGibs, index)
			totalRemoved += 1
			continue
		end
		totalGibs += 1
		if oldestHighIndex > 0 or priority ~= "High" then continue end
		oldestHighIndex = index - totalRemoved
	end
	local isFullGibs = (totalGibs >= 100)
	if (not isFullGibs) or oldestHighIndex > 0 then
		local gib = model:Clone()
		gib.Anchored = true
		gib.Size *= sizeMult
		local antiGrav = Instance.new("BodyForce")
		antiGrav.Force = Vector3.new(0, workspace.Gravity * gib:GetMass() * gravity, 0)
		antiGrav.Name = "AntiGravity"
		antiGrav.Parent = gib 
		gib.Parent = VFX_PARTS
		task.delay(0.1, function()
			if not (gib and gib.Parent) then return end
			gib.CFrame = cframe
			gib.Anchored = false
		end)
		local gibInfo = {
			Gib = gib;
			Priority = cleanupPriority;
		}
		if isFullGibs then
			local currentGibInfo = activeGibs[oldestHighIndex]
			local currentGib = currentGibInfo.Gib
			if currentGib and currentGib.Parent then
				currentGib:Destroy()
			end
			activeGibs[oldestHighIndex] = gibInfo
			--print("gib queue full - replacing low-priority gib at", oldestHighIndex)
		else
			table.insert(activeGibs, gibInfo)
			--print("creating gib - queue not full, adding normally (length:", #activeGibs, ")")
		end
		return gibInfo
	end
end

function VFXModule:HandleGibs(spawnedGibs, totalDuration, fadeTime, highCleanupSetTime)
	fadeTime = (fadeTime or 0.001)
	local started = tick()
	while #spawnedGibs > 0 do
		local passed = tick() - started
		local trans = math.clamp(passed - (totalDuration - fadeTime), 0, fadeTime) * (1 / fadeTime)
		for index, gibInfo in pairs(spawnedGibs) do
			local gib = gibInfo.Gib
			if not (gib and gib.Parent) then
				table.remove(spawnedGibs, index)
				continue 
			end
			gib.Transparency = trans
			if trans >= 1 then
				gib:Destroy()
			end
			if highCleanupSetTime and passed >= highCleanupSetTime then
				--if gibInfo.Priority ~= "High" then print("set gib priority to high after", highCleanupSetTime, "seconds") end
				gibInfo.Priority = "High"
			end
		end
		if trans >= 1 then break end
		task.wait()
	end
end

function VFXModule:CreateGibs(typ, cframe, amountMin, amountMax, sizeMult, minRotX, maxRotX, rotY, minSpeed, maxSpeed, handleVanishing)
	local gibs = VFX_STORAGE[typ]
	local spawnedGibs = {}
	if gibs then
		local allGibs = gibs:GetChildren()
		for i = 1, math.random(amountMin, amountMax) do
			local cf = cframe * CFrame.Angles(math.rad(math.random(-rotY, rotY)), math.rad(math.random(-minRotX, maxRotX)), 0) * (handleVanishing and CFrame.new(0, 0, math.random(-20, 20) / 10) or CFrame.new())
			local gibInfo = self:CreateGib(allGibs[math.random(1, #allGibs)], cf, "High", 0.5, sizeMult)
			if not gibInfo then continue end
			local gib = gibInfo.Gib
			gib.AssemblyLinearVelocity = cf.LookVector * math.random(minSpeed * 10, maxSpeed * 10) / 10
			gib.CanCollide = (typ ~= "DigGibs")
			table.insert(spawnedGibs, gibInfo)
		end
	end
	if handleVanishing and #spawnedGibs > 0 then
		if self:CheckCameraDistance(cframe.Position, 200) then return end
		self:HandleGibs(spawnedGibs, 3, 0.5)
	end
	return spawnedGibs
end

function VFXModule:CreateBenchGibs(typ, cframe)
	if self:CheckCameraDistance(cframe.Position, 700) then return end
	local gibModel = VFX_STORAGE.BenchGibs:FindFirstChild(typ)
	if not gibModel then return end
	local gibs = gibModel:Clone()
	gibs:PivotTo(cframe)
	local spawnedGibs = {}
	for _, child in pairs(gibs:GetChildren()) do
		if child:IsA("Sound") then
			child.PlaybackSpeed += math.random(-50, 50) / 1000
			SoundModule:PlayDuplicateSound(nil, child, cframe.Position)
			continue
		end
		if not child:IsA("BasePart") then continue end
		local gibInfo = self:CreateGib(child, child.CFrame, "Low", 0.5, 0.8)
		if not gibInfo then continue end
		local gib = gibInfo.Gib
		gib.AssemblyLinearVelocity = Vector3.new(math.random(-50, 50) / 10, math.random(-50, 50) / 10, math.random(-50, 50) / 10)
		table.insert(spawnedGibs, gibInfo)
	end
	gibs:Destroy()
	if #spawnedGibs <= 0 then return end
	self:HandleGibs(spawnedGibs, 5, 0.25, 1)
end

function VFXModule:CreateHole(hit, position, normal, material, item, impactOnly)
	if material == Enum.Material.Water then return end
	local itemInfo = (type(item) == "table" and Items[item.ID])
	local toolInfo = (itemInfo and ToolInfo[itemInfo.Name])
	local objectDamages = (toolInfo and toolInfo.ObjectDamages)
	local started = tick()
	while hit and not hit.Parent do
		if tick() - started >= 1 then break end
		task.wait()
	end
	if not (hit and hit.Parent and position and normal) then return end
	local isTerrain = (hit == Terrain)
	local pos = CFrame.new(position, position + normal)
	if self:CheckCameraDistance(pos.Position, 100) then return end
	local isNode = (objectDamages and objectDamages.Nodes and hit:IsDescendantOf(Nodes))
	local isStone = (material == Enum.Material.Rock or material == Enum.Material.Brick or material == Enum.Material.Slate or material == Enum.Material.Basalt or material == Enum.Material.Concrete or material == Enum.Material.Asphalt)
	local isMetal = (material == Enum.Material.Metal or material == Enum.Material.DiamondPlate or material == Enum.Material.CorrodedMetal)
	local isWood = (material == Enum.Material.Wood or material == Enum.Material.WoodPlanks)
	local isGlass = (material == Enum.Material.Glass or hit.Name == "GlassPart")
	local isAnimal = (hit:IsDescendantOf(Animals) or hit.Parent.Name == "Sleeper")
	local isMelee = (itemInfo and itemInfo.Type == "Tool")
	local isBarrel = (hit.Parent.Name == "Trash Can" or hit.Parent.Name == "Oil Barrel")
	local impact = VFX_STORAGE["Impact"..
		(isNode and "Node2" or
			((isBarrel and isMelee) and "Barrel" or
				(isMetal and "Metal" or
					(isWood and "Wood" or 
						(isGlass and "Glass" or
							(isTerrain and "Terrain" or 
								(isAnimal and "Animal" or "Default")
							)
						)
					)
				)
			)
		)
	]

	impact = impact:Clone()
	impact.CFrame = pos
	impact.Anchored = hit.Anchored
	impact.Parent = VFX_PARTS
	local hole = VFX_STORAGE[(isMetal and "Metal" or 
		(isGlass and "Glass" or 
			(isMelee and 
				(isStone and "Stone" or 
					(isWood and "Wood" or 
						(isAnimal and "Blood" or "Melee")
					)
				)
					or "")
		)
	).."Hole"]:Clone()
	--local hole = VFX_STORAGE[((isStone and isMelee) and "Stone" or "").."Hole"]:Clone()
	hole.CFrame = pos * CFrame.Angles(0, 0, math.rad(math.random(0, 359)))
	local size = math.random(20, 30) * (isMelee and 2 or ((isMetal or isGlass) and 1.5 or 1)) / 100
	hole.Size = Vector3.new(size, size, hole.Size.Z)
	hole.Anchored = hit.Anchored
	if impactOnly then
		hole.Decal.Transparency = 1
	end
	hole.Parent = VFX_PARTS
	if not hit.Anchored then
		local impactWeld = WeldModule:WeldParts(impact, hit)
		local holeWeld = WeldModule:WeldParts(hole, hit)
	end
	local color
	for _, effect in pairs(impact:GetChildren()) do
		if effect:IsA("Sound") then
			effect.PlaybackSpeed += math.random(-50, 50) / 1000
			effect:Play()
		else
			effect.Enabled = true
			if effect.Name ~= "Dirt" or (isTerrain and not material) then continue end
			color = (color or ColorSequence.new(isTerrain and (Terrain:GetMaterialColor(material.Name:find("Grass") and Enum.Material.Mud or material) or Color3.fromRGB(100, 100, 100)) or hit.Color))
			effect.Color = color
		end
	end
	local parent = hit.Parent
	parent = (parent.Name == "NodeSpark" and parent.Parent or parent)
	local gibs = (isNode and self:CreateGibs(parent.Name.."Gibs", hole.CFrame, 4, 6, 0.25, 60, 60, 60, 12.5, 17.5, false) or {})
	Debris:AddItem(impact, 5)
	Debris:AddItem(hole, 10)
	task.delay(0.16, function()
		if impact and impact.Parent then
			for _, effect in pairs(impact:GetChildren()) do
				if effect:IsA("Sound") then continue end
				effect.Enabled = false
			end
		end
		local started = tick()
		local shouldBreak = false
		while true do
			local passed = tick() - started
			local trans = math.clamp(passed - 2.5, 0, 0.5) * 2
			for _, gibInfo in pairs(gibs) do
				local gib = gibInfo.Gib
				if not (gib and gib.Parent) then continue end
				gib.Transparency = trans
				if trans >= 1 then
					gib:Destroy()
				end
			end
			if trans >= 1 then
				gibs = {}
			end
			if not (hole and hole.Parent) then 
				shouldBreak = true 
			end
			if not shouldBreak then
				if passed >= 10 or hit == nil or hit.Parent == nil or hit.Parent:IsDescendantOf(VFX_PARTS) or (hit.Transparency >= 1 and not hit.CanCollide) then
					hole:Destroy()
					shouldBreak = true
				end
			end
			if #gibs <= 0 and shouldBreak then
				break
			end
			task.wait()
		end
	end)
end

function VFXModule:CreateBlood(hit, position)
	local started = tick()
	while hit and not hit.Parent do
		if tick() - started >= 1 then break end
		task.wait()
	end
	if not (hit and hit.Parent) then return end
	if self:CheckCameraDistance(position, 500) then return end
	local blood = VFX_STORAGE.BloodPart:Clone()
	blood.CFrame = CFrame.new(position)
	blood.Anchored = false
	blood.Parent = VFX_PARTS
	local weld = WeldModule:WeldParts(blood, hit)
	for _, effect in pairs(blood:GetChildren()) do
		effect.Enabled = true
	end
	Debris:AddItem(blood, 2)
	task.delay(0.15, function()
		if not (blood and blood.Parent) then return end
		for _, effect in pairs(blood:GetChildren()) do
			effect.Enabled = false
		end
	end)
end

function VFXModule:CreateExplosion(cframe, shakeMult, duration, soundName)
	shakeMult = (shakeMult or 1)
	duration = (duration or 0.45)
	local pos = cframe.Position
	local tooFar, dist = self:CheckCameraDistance(pos, 1000, true)
	local shakeStrength = math.clamp(1 - dist / 150, 0, 1)
	if shakeStrength > 0 then
		camShaker:ShakeOnce(10 * shakeStrength * shakeMult, 30, 0, 1.5)
	end
	if tooFar then
		if soundName then
			-- If the explosion was too far away, create a simpler sound part to use for playing the sound
			local sound = VFX_STORAGE.Explosion[soundName]:Clone()
			local part = Instance.new("Part")
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.Anchored = true
			part.Transparency = 1
			part.CFrame = cframe
			part.Parent = VFX_PARTS
			sound.Parent = part
			SoundModule:ReverbSound(sound, 600, 1000)
			sound:Play()
			sound.Ended:Wait()
			part:Destroy()
		end
		return 
	end
	local e = Instance.new("Explosion")
	e.Position = pos
	e.BlastRadius = 0
	e.BlastPressure = 0
	e.Parent = VFX_PARTS
	Debris:AddItem(e, 5)
	local exp = VFX_STORAGE.Explosion:Clone()
	exp.CFrame = cframe
	exp.Parent = VFX_PARTS
	local effects = {}
	for _, effect in pairs(exp:GetChildren()) do
		if effect:IsA("Sound") then
			if effect.Name ~= soundName then continue end
			SoundModule:ReverbSound(effect, 600, 1000)
			effect:Play()
			continue
		end
		effect.Enabled = true
		if not effect:IsA("ParticleEmitter") then continue end
		table.insert(effects, effect)
	end
	task.delay(0.15, function()
		if not (exp and exp.Parent) then return end
		exp.Light.Enabled = false
	end)
	task.wait(duration)
	if not (exp and exp.Parent) then return end
	for _, effect in pairs(effects) do
		effect.Enabled = false
	end
	task.wait(5)
	if exp and exp.Parent then
		exp:Destroy()
	end
end

function VFXModule:CreateProjectile(params)
	if self:CheckCameraDistance(params.Position, params.MaxRange * 1.5) then return end
	local filterFunc = (type(params.FilterFunction) == "string" and RaycastUtil:FilterFunction(params.FilterFunction) or params.FilterFunction)
	local hitFunc = (type(params.HitFunction) == "string" and ClientFunctions[params.HitFunction] or params.HitFunction)
	local missFunc = (type(params.MissFunction) == "string" and ClientFunctions[params.MissFunction] or params.MissFunction)
	local stepFunc = (type(params.StepFunction) == "string" and ClientFunctions[params.StepFunction] or params.StepFunction)
	local originalSpeed = params.Speed
	local originalGravity = params.Gravity
	local originalMaxRange = params.MaxRange
	local velocity = params.Direction * params.Speed
	local currentPos = params.Position
	local currentVel = velocity
	local totalTravelled = 0
	local tracer = VFX_STORAGE:FindFirstChild(params.TracerName or "")
	local trail, dot
	local tracerOffset
	local isRocket = false
	local isArrow = false
	local isNail = false
	if tracer then
		isRocket = (tracer.Name:find("Rocket") ~= nil)
		isArrow = (tracer.Name:find("Arrow") ~= nil)
		isNail = (tracer.Name == "NailBullet")
		tracerOffset = (isRocket and CFrame.Angles(0, math.rad(-90), 0) or (isArrow and CFrame.Angles(0, math.rad(180), 0) or (isNail and CFrame.Angles(math.rad(90), 0, 0) or CFrame.new())))
		tracer = tracer:Clone()
		if tracer.Name == "RifleBullet" then
			tracer:PivotTo(CFrame.new(params.Position, params.Position + params.Direction) * CFrame.new(0, 0, -2) * tracerOffset)
		end
		tracer.Parent = VFX_PARTS
		trail = tracer.PrimaryPart:FindFirstChildOfClass("Trail")
		dot = tracer.PrimaryPart:FindFirstChild("TracerBoard")
		if isRocket then
			tracer.PrimaryPart.RocketFly:Play()
		end
	end
	local finish = false
	local hitSome = false
	local skipPassed = false
	local enteredWater = false
	local firstDiff
	local steps = 0
	localBulletId = (localBulletId >= 10000 and 1 or localBulletId + 1)
	local localId = localBulletId
	local bulletStepFunc = function(step)
		--print("bullet step", localId)
		step = (params.Instant or step)
		local tracerCF
		while not finish do
			local deltaTime = step / (1 / 60)
			steps += 1
			skipPassed = false
			local doFirst = (steps == 1 and params.PositionFirst ~= nil)
			if doFirst then
				firstDiff = (params.Position - params.PositionFirst).Magnitude
			end
			local desiredSpeed = (doFirst and firstDiff or originalSpeed * step)
			local nextTravelled = math.min(totalTravelled + desiredSpeed, originalMaxRange)
			local actualSpeed = nextTravelled - totalTravelled
			local direction = (doFirst and params.DirectionFirst or currentVel.Unit)
			local origin = (doFirst and params.PositionFirst or currentPos)
			local startParam = (params.Size and {Position = origin, Size = params.Size, Type = "Sphere"} or origin) -- CF = CFrame.new(origin, origin + direction)
			local hit, position, normal, material, visualPart = RaycastUtil:Raycast(startParam, direction * actualSpeed, params.FilterType, params.Filters, params.VisualizeRay, filterFunc, enteredWater)
			local travelled = (position - origin).Magnitude
			-- Update fake bullet tracer
			if tracer and not doFirst then
				-- Place the fake bullet in between the ray to simulate movement
				--if steps > 1 then
				tracerCF = CFrame.new(position, origin) * CFrame.new(0, 0, travelled / -1.2) * tracerOffset
				--else
				--	tracer:PivotTo(CFrame.new(params.Position, params.Position + params.Direction))-- * CFrame.new(0, 0, -2))
				--end
			end
			if trail then
				--[[if trail.Name == "Trail" then
					trail.MaxLength = math.min(trail.MaxLength + 1 * deltaTime, 25)
				end]]
				trail.Enabled = (not doFirst)
			end
			totalTravelled = math.min(totalTravelled + travelled, originalMaxRange)
			if dot then
				dot.Circle.ImageTransparency = math.clamp((totalTravelled - (params.MaxRange * 0.6)) / (params.MaxRange * 0.4), 0, 1)
			end
			if visualPart then
				Debris:AddItem(visualPart, 5)
			end
			if stepFunc and type(stepFunc) == "function" then
				if stepFunc(origin, position, localId) then
					finish = true
				end
			end
			--print(hit, travelled, totalTravelled, desiredSpeed, origin, direction)
			if hit then
				if material == Enum.Material.Water and not enteredWater then
					enteredWater = true
					originalGravity = math.max(originalGravity + 0.25, 1)
					originalSpeed *= 0.08
					totalTravelled = 0
					originalMaxRange = math.clamp(params.MaxRange / 50, 10, 25)
				else
					hitSome = true
					finish = true
					if hitFunc then
						hitFunc(hit, position, normal, material, nil, (isArrow or isNail))
					end
					--[[
					local h = (hit.Parent:FindFirstChild("Humanoid") or hit.Parent.Parent:FindFirstChild("Humanoid"))
					if not fake then
						Remotes.DoDamage:FireServer(wep, hit, pos, nor, (0.6 + (math.max(wallpen, 0) / origpen) * 0.4) * (wallpen < origpen and -1 or 1))
					end]]
				end
			elseif doFirst then
				skipPassed = true
			elseif steps > 1 then
				currentVel = currentVel - (Vector3.new(0, 196.2 * originalGravity, 0) * step)
				currentPos = position
			end
			if math.abs(originalMaxRange - totalTravelled) <= 1 then -- Check if bullet hasn't travelled past its range
				finish = true
			end
			if finish then
				if tracer then
					--if steps == 1 then
					tracerCF = nil
					if isRocket then
						tracer.PrimaryPart.Transparency = 1
						for _, effect in pairs(tracer.PrimaryPart:GetChildren()) do
							if effect:IsA("Sound") then
								effect:Stop()
								continue
							end
							effect.Enabled = false
						end
						Debris:AddItem(tracer, 3)
					else
						tracer:Destroy()
					end
					--else
						--[[if steps == 2 and totalTravelled >= 7.5 then
							Run[runToUse]:Wait()
						end]]
						--[[tracer:PivotTo(CFrame.new(position) * CFrame.Angles(tracer.PrimaryPart.CFrame:ToEulerAnglesXYZ()))
						for _, v in pairs(tracer:GetChildren()) do
							local light = v:FindFirstChild("Light")
							if light then
								light.Enabled = false
							end
						end
						task.delay(0.1, function()
							if not (tracer and tracer.Parent) then return end
							tracer:Destroy()
						end)
					end]]
				end
			end
			if not params.Instant then break end
		end
		if tracerCF then
			return finish, tracer.PrimaryPart, tracerCF
		end
		return finish
	end
	local bulletFinishFunc = function()
		lastWhizzes[localId] = nil
		if hitSome or not missFunc then return end
		missFunc()
	end
	if params.Instant then
		bulletStepFunc()
		bulletFinishFunc()
	else
		table.insert(allBullets, {
			StepFunction = bulletStepFunc;
			FinishFunction = bulletFinishFunc;
		})
		--print("bullet created", #allBullets)
		if not (bulletLoop and bulletLoop.Connected) then
			--print("started bullet loop")
			bulletLoop = Run.Heartbeat:Connect(function(step)
				local parts, cframes = {}, {}
				for index, bulletTable in pairs(allBullets) do
					local did = false
					local suc, err = pcall(function()
						local finish, part, cf = bulletTable.StepFunction(step)
						if part then
							table.insert(parts, part)
							table.insert(cframes, cf)
						end
						if not finish then return end
						bulletTable.FinishFunction()
						did = true
					end)
					if suc and not did then continue end
					if not suc then
						warn("BULLET CALCULATION ERRORED - REMOVING FROM TABLE:", err)
					end
					table.remove(allBullets, index)
					--print("bullet removed", #allBullets)
				end
				if #parts > 0 then
					workspace:BulkMoveTo(parts, cframes, Enum.BulkMoveMode.FireCFrameChanged)
				end
				if #allBullets > 0 then return end
				bulletLoop:Disconnect()
				bulletLoop = nil
				--print("bullet loop done")
			end)
		end
	end
end

function VFXModule:CheckCameraDistance(checkPos, maxDist, useMagnitude)
	local player = Players.LocalPlayer
	if not player then return end
	if not Camera then return true end
	local camCF = Camera.CFrame
	local camPos = camCF.Position
	if useMagnitude then
		local dist = (camPos - checkPos).Magnitude
		return dist > maxDist, dist
	end
	local isWithin, squared = NumberUtil:IsWithin(camPos, checkPos, maxDist)
	return (not isWithin), squared
end

Run.Heartbeat:Connect(function()
	for index = #lasers, 1, -1 do
		local laser = lasers[index]
		if not (laser and laser.Parent and laser.Laser.Enabled) then table.remove(lasers, index) continue end
		local start = laser.Start.WorldCFrame
		local skip = false
		repeat
			local player = Players.LocalPlayer
			if not player then break end
			local char = player.Character
			if not char then break end
			local prim = char.PrimaryPart
			if not prim then break end
			skip = (not NumberUtil:IsWithin(prim.Position, start.Position, 1000))
		until true
		if skip then
			laser.End.WorldPosition = start.Position
			continue 
		end
		local _, position = RaycastUtil:Raycast(start.Position, start.RightVector * 1000, "Blacklist", {VFX_PARTS, laser.Parent}, nil, hitIgnoreFilterFunc)
		laser.End.WorldPosition = position
	end
end)

return VFXModule