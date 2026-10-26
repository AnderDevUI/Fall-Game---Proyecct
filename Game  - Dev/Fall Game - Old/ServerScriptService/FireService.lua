-- [PATH] ServerScriptService / ServerService / FireService @Type Script
--[[
	FireService
	by ChickenBagelz
	August 17, 2023
	
	Controls every fire part and their creation/deletion/damage calculation
]]


-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")
local VFX_STORAGE = Replicated:WaitForChild("VFX")
local VFX_PARTS = workspace:WaitForChild("VFX")
local VFX_FIRE = VFX_PARTS:WaitForChild("Fire")
local Vegetation = workspace:WaitForChild("Vegetation")
local Trees = workspace:WaitForChild("Trees")
local Nodes = workspace:WaitForChild("Nodes")
local Drops = workspace:WaitForChild("Drops")
local GlobalSounds = Storage:WaitForChild("GlobalSounds")

-- Modules
local DamageModule = require(ServerModules:WaitForChild("DamageModule"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local BenchInfo = require(SharedModules:WaitForChild("BenchInfo"))

-- Bindables
local CreateEvent = script:WaitForChild("Create")

-- Raycast Filter Functions
local hitIgnoreFilterFunc = RaycastUtil:FilterFunction("HitIgnore")

-- Constants
local Terrain = workspace:WaitForChild("Terrain")
local BurnSound = GlobalSounds:WaitForChild("Damages"):WaitForChild("Burn")
local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Exclude
overlapParams.FilterDescendantsInstances = {VFX_PARTS, Terrain, Vegetation, Trees, Nodes, Drops}

-- Local Variables
local allFireParts = {}


-- Functions
local filterFunc = RaycastUtil:FilterFunction("View")
function FireRayFilterFunc(hit)
	if not hit.CanCollide then return end
	local filter = filterFunc(hit)
	if filter then
		return filter
	end
end

function CreateFire(amount: number, plrDmg: number, woodDmg: number, fireRadius: number, fireDuration: number, velocityMin: number, velocityMax: number, fireLevel: number, useMultipleThreads: boolean, cframeCalculationFunc, fireType: string?, creator: Player)
	local fireParts = {}
	local allFires = {}
	local combatArena, creatorUser
	if creator and creator.Parent then
		creatorUser = shared.Users[creator]
		if creatorUser then
			combatArena = creatorUser:IsInCombatArena(true)
		end
	end
	for _ = 1, amount do
		local firePart = VFX_STORAGE.FirePart:Clone()
		local fireMain = firePart.PrimaryPart
		fireMain[tostring(fireLevel)].Enabled = true
		firePart.Parent = VFX_FIRE
		fireMain:SetNetworkOwner(nil)
		fireMain.Anchored = true
		local fireTable = {firePart}
		table.insert(fireParts, fireTable)
		if combatArena then
			table.insert(combatArena.Fires, firePart)
		end
	end
	local function setupFire()
		for _, fireTable in pairs(fireParts) do
			local firePart = fireTable[1]
			if not firePart.Parent then continue end
			local fireMain = firePart.PrimaryPart
			if not fireMain then continue end
			local fireCollision = firePart.Collision
			local partCF = cframeCalculationFunc()
			firePart:PivotTo(partCF)
			fireMain.AssemblyLinearVelocity = partCF.LookVector * math.random(velocityMin, velocityMax)
			fireMain.Anchored = false
			local collidingObjs = {}
			fireTable[3] = collidingObjs
			fireTable[4] = partCF.Position
			local totalFireParts = #allFireParts
			local maxFireParts = script:GetAttribute("MaxFireParts")
			if totalFireParts >= maxFireParts and totalFireParts > 0 then
				print(`max fire part count reached ({maxFireParts}), clearing fire part`)
				local removeIndex = math.random(1, totalFireParts)
				task.defer(DeleteFire, allFireParts[removeIndex], false, true)
				table.remove(allFireParts, removeIndex)
			end
			table.insert(allFireParts, fireTable)
			table.insert(allFires, fireTable)
			local loopRunning = false
			fireCollision.Touched:Connect(function(hit)
				local parent = hit.Parent
				if not parent then return end
				local object = parent
				local hum = object:FindFirstChild("Humanoid")
				local currentHealth = object:GetAttribute("Health")
				if not (hum or currentHealth) then
					object = object.Parent
					currentHealth = object:GetAttribute("Health")
				end
				if hum == nil and (currentHealth == nil or currentHealth <= 0) then return end
				local damageType = object:GetAttribute("DamageType")
				if damageType == "Stone" or damageType == "Metal" or damageType == "Steel" then return end
				if table.find(collidingObjs, object) then return end
				if hum and hum.Health <= 0 then return end
				
				local plr = Players:GetPlayerFromCharacter(hum.Parent)
				if plr then
					local user = shared.Users[plr]
					if (not user) or ((plr:GetAttribute("SafeZone") or plr:GetAttribute("DamageDisabled"))) or (creator and creator.Parent and creatorUser and creatorUser ~= user and (creator:GetAttribute("SafeZone") or creator:GetAttribute("DamageDisabled") or (creator.Team ~= nil and plr.Team ~= nil and plr.Team == creator.Team))) then
						print(plr.Name, "ignoring fire dmg from", creator)
						return 
					end
				end
				table.insert(collidingObjs, object)
				if hum then
					hum:SetAttribute("DamageConnections", (hum:GetAttribute("DamageConnections") or 0) + 1)
				end
				--print("adding", object, "to fire collision list", collidingObjs)
				if loopRunning then return end
				--print("starting fire loop")
				loopRunning = true
				while fireCollision.Parent do
					local firePos = fireCollision.Position
					local parts = workspace:GetPartBoundsInRadius(firePos, fireRadius, overlapParams)
					for index = #collidingObjs, 1, -1 do
						local obj = collidingObjs[index]
						local isBench = obj:GetAttribute("Health")
						if obj.Parent then
							local found = false
							for i, part in pairs(parts) do
								if not part:IsDescendantOf(obj) then continue end
								--print("should fire damage", obj)
								local fPos = firePos + Vector3.new(0, 1.25, 0)
								local rayHit, rayPos, rayNor = RaycastUtil:Raycast(fPos, part.Position - fPos, "Exclude", {VFX_PARTS, Drops}, false, hitIgnoreFilterFunc, true)
								if not (rayHit and rayHit:IsDescendantOf(obj)) then continue end
								table.remove(parts, i)
								local rayPosition = rayHit.CFrame:PointToObjectSpace(rayPos)
								found = true
								local dmgMult = 1
								if isBench then
									local benchInfo = BenchInfo[obj.Name]
									if benchInfo then
										local damageMults = benchInfo.FireDamageMults
										if damageMults and fireType and damageMults[fireType] then
											dmgMult = damageMults[fireType]
										end
									end
								end
								local damageTable = (isBench and {
									Twig = woodDmg * dmgMult;
									Wood = woodDmg * dmgMult;
									--[[Stone = 2500;
									Metal = 125000;
									Steel = 250000;]]
									BenchWood = woodDmg * 1.75 * dmgMult;
								} or {
									Head = plrDmg;
									Chest = plrDmg;
									Arms = plrDmg;
									Legs = plrDmg;
									Bleed = 0;
								})
								local _, _, _, humanoid = DamageModule:Damage(rayHit, rayPosition, rayNor, fireMain.CFrame, damageTable, {Start = 1000, End = 1000}, nil, nil, "Fire", nil, nil, true)
								if humanoid and humanoid.Health <= 0 then
									found = false
									break
								end
								if not isBench then
									local sound = BurnSound:Clone()
									sound.PlaybackSpeed += math.random(-50, 50) / 1000
									sound.Parent = rayHit
									sound:Play()
									Debris:AddItem(sound, 2.5)
								end
								break
							end
							if found then continue end
						end
						table.remove(collidingObjs, index)
						if isBench then continue end
						local humanoid = obj:FindFirstChild("Humanoid")
						if not humanoid then continue end
						humanoid:SetAttribute("DamageConnections", math.max(humanoid:GetAttribute("DamageConnections") - 1, 0))
						--print("fire no longer touching", obj, ", removing from table", collidingObjs)
					end
					if #collidingObjs <= 0 then break end
					task.wait(0.5)
				end
				--print("ending fire loop")
				loopRunning = false
			end)
		end
		task.delay(fireDuration, function()
			--print("deleting spawned fires")
			for _, fireTable in pairs(allFires) do
				DeleteFire(fireTable, true)
			end
			task.wait(1)
			for _, fireTable in pairs(allFires) do
				local firePart = fireTable[1]
				local groundedCon = fireTable[2]
				if groundedCon then
					groundedCon:Disconnect()
				end
				if not firePart.Parent then continue end
				firePart:Destroy()
			end
		end)
		SetupFirePartDrops(fireParts)
	end
	if useMultipleThreads then
		task.delay(0.05, setupFire)
	else
		task.wait(0.05)
		setupFire()
	end
end

function DeleteFire(fireTable, ignoreDestroy: boolean, ignoreTableRemoval: boolean)
	if not fireTable then return end
	local firePart = fireTable[1]
	local collidingObjs = fireTable[3]
	for _, object in pairs(collidingObjs) do
		if not object.Parent then continue end
		local hum = object:FindFirstChild("Humanoid")
		if not hum then continue end
		hum:SetAttribute("DamageConnections", math.max(hum:GetAttribute("DamageConnections") - 1, 0))
	end
	if not ignoreTableRemoval then
		local foundIndex = table.find(allFireParts, fireTable)
		if foundIndex then
			table.remove(allFireParts, foundIndex)
		end
	end
	if not firePart.Parent then return end
	local fireMain = firePart.PrimaryPart
	if fireMain then
		local fireCollision = firePart:FindFirstChild("Collision")
		if fireCollision then
			fireCollision:Destroy()
		end
		for _, particle in pairs(fireMain:GetChildren()) do
			if not particle:IsA("ParticleEmitter") then continue end
			particle.Enabled = false
		end
		if ignoreDestroy then return end
		task.wait(1)
	elseif ignoreDestroy then return end
	local groundedCon = fireTable[2]
	if groundedCon then
		groundedCon:Disconnect()
	end
	firePart:Destroy()
end

function SetupFirePartDrops(fireParts, disconnectTouchCon: boolean)
	if disconnectTouchCon then
		local fireTable = fireParts[1]
		if fireTable and fireTable[2] then
			fireTable[2]:Disconnect()
			fireTable[2] = nil
		end
	end
	while #fireParts > 0 do
		task.wait(0.5)
		for index = #fireParts, 1, -1 do
			local fireTable = fireParts[index]
			local firePart = fireTable[1]
			if firePart.Parent then
				local fireMain = firePart.PrimaryPart
				local velocity = fireMain.AssemblyLinearVelocity.Magnitude
				--print(velocity)
				local firePos = fireMain.Position
				local lastPos = fireTable[4]
				fireTable[4] = firePos
				local inWater = false
				if firePos.Y <= 30 and lastPos then
					local hitTerrain, _, _, terrainMat = RaycastUtil:Raycast(lastPos, firePos - lastPos, "Include", Terrain)
					if hitTerrain and terrainMat == Enum.Material.Water then
						--print("fire part destroyed because it came in contact with water")
						inWater = true
						task.defer(DeleteFire, fireTable)
					end
				end
				if velocity > 0.01 and not inWater then continue end
				if not inWater then
					local touching, _, _, material = RaycastUtil:Raycast(firePos, Vector3.new(0, -2, 0), "Exclude", {VFX_PARTS, Vegetation, Drops}, false, FireRayFilterFunc, false)
					if material == Enum.Material.Water then
						--print("fire part destroyed because it was detected being on top of water")
						task.defer(DeleteFire, fireTable)
					else
						fireMain.Anchored = true
						--print("anchoring fire part", touching)
						if touching and touching.Parent then
							local conFired = false
							local touchCon; touchCon = touching:GetPropertyChangedSignal("Parent"):Connect(function()
								if conFired or (touching and touching.Parent) then return end
								conFired = true
								--print("touching fire part removed, unanchoring")
								task.wait()
								if fireMain and fireMain.Parent then
									fireMain.Anchored = false
									SetupFirePartDrops({fireTable}, touchCon)
									return
								end
								touchCon:Disconnect()
								fireTable[2] = nil
							end)
							fireTable[2] = touchCon
						end
					end
				end
			end
			table.remove(fireParts, index)
		end
	end
end


CreateEvent.Event:Connect(CreateFire)