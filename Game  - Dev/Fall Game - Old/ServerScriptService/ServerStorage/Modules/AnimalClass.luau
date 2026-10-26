-- [PATH] ServerStorage / Modules / AnimalClass @Type ModuleScript
--[[
	AnimalClass
	by neddleduck
	Feb 11th 2023
	
	animal class wow
]]

--Services 
local STORAGE = game:GetService("ServerStorage")
local REPLICATED = game:GetService("ReplicatedStorage")
local PLAYERS = game:GetService("Players")
local SCRIPT_SERVICE = game:GetService("ServerScriptService")

--User Created Services
local ANIMAL_SERVICE = SCRIPT_SERVICE:WaitForChild("AnimalService")

--Constants
local MODULES = STORAGE:WaitForChild("Modules")
local MODERATION = require(MODULES:WaitForChild("ModUtil"))
local ANIMAL_INFO = require(MODULES:WaitForChild("AnimalInfo"))
local DAMAGE_MODULE = require(MODULES:WaitForChild("DamageModule"))

local SHARED_MODULES = REPLICATED:WaitForChild("Modules")
local WELD_MOD = require(SHARED_MODULES:WaitForChild("WeldModule"))
local RAY_UTIL = require(SHARED_MODULES:WaitForChild("RaycastUtil"))
local NUM_UTIL = require(SHARED_MODULES:WaitForChild("NumberUtil"))

local ANIMALS = STORAGE:WaitForChild("Animals")
local RAGDOLL_MASKS = STORAGE:WaitForChild("RagdollMasks")
local PREFAB_ANIMAL = ANIMALS:WaitForChild("PREFAB_ANIMAL")

local WORKSPACE_ANIMALS = workspace:WaitForChild("Animals")
local VFX_FOLD = workspace:WaitForChild("VFX")

local EVENT_HARVESTED = ANIMAL_SERVICE:WaitForChild("Harvested")

--Settings
local RAGDOLL_TIME = 2.5 --Time in seconds the body will spend ragdolling
local ANIMAL_AGGRO_TIME = 8 --Time in seconds the animal will spend aggro'd on to the player before dashing away

--Variables
local viewFilterFunc = RAY_UTIL:FilterFunction("View")

--Functions
local function AlignMaskToTree(mask, boneTree, isAnchor)
	for _, part in pairs(mask:GetChildren()) do
		if isAnchor then
			part.Anchored = true
		end
		if part.Name == "IGNORE" then continue end --Do not check parts named IGNORE
		--Look for the bone in the bone tree table
		local foundBone = nil
		for index, bone in pairs(boneTree) do
			--Check to set rootBone and moveBone
			if bone.Name == part.Name then
				foundBone = bone
				break
			end
		end
		if not foundBone then continue end

		--The bone exists, so set its property
		foundBone.WorldCFrame = part.CFrame
	end
end

local function Get180Direction(rootPart) --Gets the flipped direction of the animal root part if it has to dash away in another direction
	local rotationToApply = math.random(-30, 30)
	local rotatedVector = rootPart.CFrame * CFrame.Angles(0, math.rad(rotationToApply), 0)
	return rotatedVector.LookVector * -1
end

local AnimalClass = {}
AnimalClass.__index = AnimalClass

function AnimalClass.new(animalName, spawnPoint, chunkIndex)
	local self = setmetatable({}, AnimalClass)
	self.Name = animalName

	self.ChunkIndex = chunkIndex --Stores animal chunk that it is spawned on
	self.Despawn = false --When despawn is set to true the animal will start to try and despawn if it can
	self.DespawnTimer = tick() --This is the timer for the animal to despawn, if an interaction happens with the animal the timer is reset, once the timer reaches and despawn is true, the animal despawns
	self.Active = false --This sets the animal to be active, when an animal is not active for long enough, it will despawn
	self.DeactiveTimer = tick() --This stores the animals current time it has been deactive for, if it has been deactive for long enough, it will set despawn to true
	self.Target = nil --Stores the target ROOT PART
	self.TargetTime = tick() --This variable stores how long the animal has had a target for, so that if they have had a target for long enough and certain checks pass, they will remove the target
	self.Attack = false -- This variable stores the variable if the animal is currently fighting another player
	self.AttackTime = tick() -- This variable stores the time that the animal has last attacked the player
	self.Attacking = false --This variable stores if the animal is currently in the middle of attacking the player
	self.Run = false --If animal is currently running
	self.RunTime = tick() --This variable stores how long the animal has been running for, so we can stop it from running forever
	self.Model = MODERATION:SafeClone(PREFAB_ANIMAL)
	self.Root = self.Model:WaitForChild("HumanoidRootPart")
	self.Animations = nil --Loaded animations table
	self.Playing = nil --Currnent animation
	self.Dash = false -- if animal is currently dashing
	self.DashTime = tick() - 10 -- This holds the time that the animal has last dashed, used as a debounce to not update the animals path and continue running a direction
	self.Chase = false --chase boolean if the animal is chasing a player (only for aggressive)
	self.ChaseTime = tick() -- cooresponding variable for chase boolean, that stores the time the chase started

	--Info Variable
	local info = ANIMAL_INFO[self.Name]

	--Disable some humanoid states / set walkspeed
	local hum = self.Model:WaitForChild("Humanoid")
	hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
	hum.WalkSpeed = info.RunSpeed

	local oldHealth = hum.Health
	--Setup a connection for when the humanoid is damaged to trigger run away command on target, also this will reset the despawn timer on the animal if it has been marked to despawn
	hum.HealthChanged:Connect(function(newHealth)
		local decreased = (newHealth < oldHealth)
		oldHealth = newHealth
		if decreased then
			if info.Aggressive then
				if self.Target == nil then return end
				local isWithin, squaredDist = NUM_UTIL:IsWithin(self.Root.Position, self.Target.Position, 12)
				if (not info.Confident) and isWithin and tick() - self.AttackTime < info.AttackTime then --Close enough to be spooked if not confident and cannot attack
					self:RunFrom(self.Target) -- Spook the animal
					self.Chase = false
				else
					local dist = math.sqrt(squaredDist)
					if dist <= (info.SpookRange * 2)  then --Close enough to run at them and fight
						self.Attack = true
						self.Run = true
						if not self.Chase then -- Don't want to update tick if already chasing
							self.Chase = true
							self.ChaseTime = tick()
						end
						self:RunTo(self.Target)
					else --Animal was shot, run from target
						self:RunFrom(self.Target)
						self.Chase = false
					end
				end
				return
			end
			self:RunFrom(self.Target)
		end
	end)

	--Spawn in animal
	local m = self.Model
	local detail = MODERATION:SafeClone(ANIMALS[self.Name])
	local detailWeldPart = detail:WaitForChild("WeldPart")
	local animFolder = detail.Animations
	local animController = detail.AnimationController

	m.Name = m.Name .. "_" .. string.upper(self.Name) 
	m.Parent = WORKSPACE_ANIMALS
	detail.Name = "Detail"
	detail.Parent = m

	--Set detail and children of detail to server owner
	for _, part in pairs(detail:GetChildren()) do
		if part:IsA("MeshPart") or part:IsA("Part") then
			part:SetNetworkOwner()
		end
	end
	--Set the root to the server, we don't want any clients taking over
	self.Root:SetNetworkOwner()
	self.Root.Position = Vector3.new(spawnPoint.X, spawnPoint.Y + 4, spawnPoint.Z)
	detailWeldPart.CFrame = (m.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0))

	WELD_MOD:WeldParts(detailWeldPart, self.Root)	

	--Set Collision Group
	shared.SetModelCollision(m, "Animals", true)

	--Setup animations
	self.Animations = {
		--[AnimName] = LoadedAnimation
	}
	for _,animInstance in pairs(animFolder:GetChildren()) do
		self.Animations[animInstance.Name] = animController:LoadAnimation(animInstance)
	end
	self:PlayAnimation("Idle")

	--Setup humanoid died function for the ragdoll and general body setup
	hum.Died:Connect(function()
		MODERATION:SafeDestroy(hum)
		self.Root.Anchored = true
		self:SetDespawn()
		self.Active = false
		self.Run = false --If we were running before, we aren't anymore
		local mask = MODERATION:SafeClone(RAGDOLL_MASKS:FindFirstChild("Mask" .. self.Name))
		shared.SetModelCollision(mask, "Animals", false)
		local rootBone = (function() -- Root bone is the animals root part, the movebone is the bone that the root part will move to if the root part gets too far from the move bone. (i.e. an exploiter tried to move the ragdoll to them)
			for _, bone in pairs(detail.RootPart:GetDescendants()) do
				if not bone:IsA("Bone") then continue end --Guard clause if found obj is not a bone
				if bone.Name == info.RootBone then
					return bone
				end
			end
		end)() --Run a function to go through the rootparts descendants to assign the rootbone variable and the movebone variable
		local boneTree = detail.RootPart:GetDescendants()

		--UNLOAD ALL THE ANIMS (stop them all, and set animations to a blank table)
		for _, anim in pairs(self.Animations) do
			anim:Stop()
		end
		self.Animations = {}

		self.Root.Anchored = true
		mask:PivotTo(rootBone.WorldCFrame * CFrame.new(0, 3, 0)) --position the ragdoll mask
		mask.Parent = VFX_FOLD
		for _, part in pairs(mask:GetChildren()) do --Go through model setting network owner to server
			part:SetNetworkOwner()
		end
		--spawn the thread to attach the bones to the ragdoll mask
		task.defer(function()
			local ragdollStart = tick()
			local animalFellUnderMap = false
			while true do
				--go through the ragdoll bones, matching all of them to the :Desecendants of the bone tree
				AlignMaskToTree(mask, boneTree)
				--Check if enough time has past for the ragdoll to be finished. Once it is finished, check if it is too far from the HRP, if it is too far from the HRP then reposition it other wise leave it
				if tick() - ragdollStart >= RAGDOLL_TIME then --Enough time has past for ragdoll to finish
					if self.Model:FindFirstChild("Detail") == nil then --Animal has fallen under the map for some weird reason
						--print("ANIMAL FELL UNDER THE MAP IDK WHY, BUT IT GOT CLEANED UP")
						MODERATION:SafeDestroy(self.Model)
						MODERATION:SafeDestroy(mask)
						self:SetDespawn()
						animalFellUnderMap = true
						break
					end
					for _, detailChild in pairs(self.Model.Detail:GetChildren()) do --Anchor animal body parts
						if detailChild:IsA("MeshPart") or detailChild:IsA("Part") then
							detailChild.Anchored = true
						end
					end
					break --break the loop
				end
				wait()
			end
			if animalFellUnderMap then return end -- guard clause cause gay
			--Ragdolling is over ( create a new body because the client and server position gets fucked)
			local oldRootBoneCFrame = rootBone.WorldCFrame --saving old root bone position to apply the new deer body instead of looping through the mask again to find it
			local bodyPart = detail:FindFirstChild(info.Body)
			bodyPart.CFrame = rootBone.WorldCFrame
			self.Root.CFrame = bodyPart.CFrame --Set humanoid root part to deer body CFrame
			--create a new body, apply it over the ragdoll mask, position the hitbox properly, and delete the old one, then move the new one into the workspace
			detail:Destroy() --delete the old one first, cause were going to re-assign the variable(s)
			local detail = MODERATION:SafeClone(ANIMALS[self.Name])
			local detailWeldPart = detail:WaitForChild("WeldPart")
			local boneTree = detail.RootPart:GetDescendants()
			detailWeldPart.Anchored = true
			detail.Parent = m
			detailWeldPart.CFrame = (m.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0))
			AlignMaskToTree(mask, boneTree, true)
			detail:FindFirstChild(info.Body).CFrame = oldRootBoneCFrame
			--Resize, and reposition the humanoid root part to encapsulate the deer body for a better hitbox
			local moveBone = (function()
				for _, bone in pairs(boneTree) do
					if bone.Name == info.MoveBone then
						return bone
					end
				end
			end)() --Get the bone where we are positioning the HRP at
			self.Root.Size = info.DeadRootSize
			self.Root.CFrame = oldRootBoneCFrame --Apply the CFrame so it gets rotation and shit
			self.Root.Position = moveBone.WorldCFrame.Position --Apply the HRP over the movebone position
			
			--self.Root.Size = info.Body
			--local distanceFromRoot = (self.Root.Position - bodyPart.Position).Magnitude --distance from root PART (not used anymore)
			--Destroy mask
			MODERATION:SafeDestroy(mask)
			--Assign attributes for harvesting
			m:SetAttribute("Health", info.Health)
			m:SetAttribute("MaxHealth", info.Health)
			--Harvest Event Connection
			m:GetAttributeChangedSignal("Health"):Connect(function()
				local hp = m:GetAttribute("Health")
				if hp <= 0 then
					EVENT_HARVESTED:Fire(self)
				end
			end)
		end)
	end)
	
	self:CalculateDistanceFunctions()
	return self
end

function AnimalClass:ChangeMovespeed(speed)
	local hum = self.Model:FindFirstChild("Humanoid")
	if not hum then return end 
	
	hum.WalkSpeed = speed
end

function AnimalClass:DashAway()
	if not self.Dash then
		if self.Aggressive then
			self.Target = nil
			self.Attack = false
			self.Chase = false
		end
		self.Dash = true
		self.DashTime = tick()
		self:RunTo(Get180Direction(self.Root))
	end
end

function AnimalClass:ToggleActive(bool)
	if not bool and self.Active then --Animal was changed from active to false
		self.Active = bool
		self.DeactiveTimer = tick() --Set despawn timer
	else
		self.Active = bool
	end
end

function AnimalClass:SetDespawn()
	if not self.Despawn then
		self.Despawn = true
		self.DespawnTimer = tick()
	end
end

function AnimalClass:PlayAnimation(animName, playOnce)
	if self.Animations[animName] == nil then return end --Guard clause if anim name doesn't exist in table, useful for when the animations are all unloaded when the animal dies
	if playOnce then
		self.Animations[animName]:Play()
	end
	if self.Playing ~= animName and self.Animations[self.Playing] ~= nil then
		self.Animations[self.Playing]:Stop()
	end
	if self.Playing == animName then return end --Do not play the already playing animation

	self.Playing = animName
	self.Animations[animName]:Play()
end

function AnimalClass:RunFrom(position) --or part /// This function is used when an animal wants to run away from a target
	local point = (typeof(position) == "Instance") and position.Position or position
	local rootPos = self.Root.Position
	local directionAway = (rootPos - point) * 1
	local hum = self.Model:FindFirstChild("Humanoid")
	if not hum then return end --guard clause
	hum:Move(Vector3.new(directionAway.X, self.Root.Position.Y, directionAway.Z))
	self:PlayAnimation("Run")
	self.Run = true
	self.Attack = false
	self.RunTime = tick()
end

function AnimalClass:RunTo(position) --or part, or CFrame
	local hum = self.Model:FindFirstChild("Humanoid")
	if not hum then return end --guard clause
	
	self:PlayAnimation("Run")
	local pos = typeof(position) == "Vector3" and position or position.Position
	hum:MoveTo(pos)
end

function AnimalClass:StopRun(facePart) --Stop running, face the animal towards a part if you want
	local hum = self.Model:FindFirstChild("Humanoid")
	if not hum then return end --guard clause
	hum:MoveTo(self.Root.Position)
	self.Run = false
	local animToPlay = (self.Aggressive and self.Attack) and "AttackIdle" or "Idle"
	self:PlayAnimation(animToPlay)
	if facePart then
		local fpPos = facePart.Position
		local newCF = CFrame.new(self.Root.Position, Vector3.new(fpPos.X, self.Root.Position.Y, fpPos.Z))
		self.Root.CFrame = newCF
	end
end

function AnimalClass:DespawnAnimal()
	MODERATION:SafeDestroy(self.Model)
end

function AnimalClass:CalculateDistanceFunctions() --This will calculate the closest players distance, and set the animals state and run functions accordingly 
	if self.Attacking then return end
	if self.Dash then return end --Don't want this running if we are dashing
	if not self.Model:FindFirstChild("Humanoid") then --Guard clause if hum not exists then don't run this func
		return
	end
	local hum = self.Model:FindFirstChild("Humanoid")
	local info = ANIMAL_INFO[self.Name]
	local closestDist = 10000
	local closestRoot = nil
	for _, player in pairs(PLAYERS:GetChildren()) do
		--Variables and guard clauses, I don't want to use WaitForChild() and yield, I just want to cycle through the hrps
		local char = player.Character
		if not char then continue end
		local hrp = char.PrimaryPart
		if not hrp then continue end
		local hum = char:FindFirstChild("Humanoid")
		if not hum or hum.Health <= 0 then continue end
		
		--Compare the distance to all the players in the game
		local isWithin, squaredDist = NUM_UTIL:IsWithin(self.Root.Position, hrp.Position, closestDist)
		if isWithin then
			closestDist = math.sqrt(squaredDist) --Change distance variable
			closestRoot = hrp
			self.Target = hrp
		end
	end

	--If in active distance set active to true
	if closestDist <= info.ActivationRange then
		if not self.Active then
			self:ToggleActive(true)
		end
	else
		--Animal can be set deactive nobody in range
		self:ToggleActive(false)
	end
	--Use closest distance to determine state
	local state = "Idle" --Default state
	local isAggressive = info.Aggressive
	--check if in spook range and set state to spook instead
	if closestDist <= (self.Chase and (info.SpookRange * 2) or info.SpookRange) then
		state = "Spook"
		if isAggressive then
			--Attack here
			if true then--if health > 20% then --Health is greater than 20%, animal wants to fight --TODO
				self.Attack = true
				if closestDist > info.AttackRange then --Not in range to attack
					--Move to attack
					local stopRange = -2 --Its set to -2, so that it actually runs -2 studs through the player
					local attackPoint = CFrame.new(self.Target.Position, self.Root.Position) * CFrame.new(0, 0, -stopRange)  --When moving to attack, I want the animal to move 2 studs off their target to their position so they never run inside of the player
					state = "Run"
					self:RunTo(attackPoint)
					if not self.Chase then -- Don't want to update tick if already chasing
						self.Chase = true
						self.ChaseTime = tick()
					end
				else --In range to attack
					if tick() - self.AttackTime >= info.AttackTime then --attack
						self:StopRun(self.Target) --stop running, face the target
						self.AttackTime = tick()
						local obstacle = RAY_UTIL:Raycast(self.Root.Position, self.Target.Position - self.Root.Position, "Exclude", {workspace.VFX, workspace.Animals, workspace.Vegetation, workspace.Plants}, false, viewFilterFunc, true)
						if not obstacle or obstacle:IsDescendantOf(self.Target) then
							self:PlayAnimation("Attack", true) --true is for the "PlayOnce" variable u can figure out what play once means
							self.Attacking = true
							self.Chase = false
							--DAMAGE_MODULE--
							local upperTorso = self.Target.Parent:FindFirstChild("UpperTorso")
							local causeOfDamage = self.Name
							DAMAGE_MODULE:Damage(upperTorso, Vector3.new(), Vector3.new(), upperTorso.CFrame, {
								Chest = info.Damage; -- damage here
								Bleed = info.Bleed; -- bleeding herer, s
							}, {Start = 1000, End = 1000}, nil, nil, causeOfDamage, nil, "Animal")
							----
							task.delay(info.AttackTime, function()
								self.Attacking = false
							end)
						end
					else
						self.Chase = false
						state = "AttackIdle"
						self:PlayAnimation(state)
					end
				end
			elseif (hum.Health / info.Health) > 0.2 and hum.Health > 0 then --Health is less than 30 and the animal wants to run away
				self.Attack = false
				self.Chase = false
				state = "Run"
				self:RunFrom(self.Target)
			end
		end
	else
		self.Chase = false
	end
	
	if isAggressive and self.Chase and tick() - self.ChaseTime >= ANIMAL_AGGRO_TIME  then --This is only a check for aggressive animals // Basically, if the animal has been chasing the player too long without hitting them, they will dash away
		self:DashAway()
	end
	--check if we need to run
	if not isAggressive and closestDist <= info.RunRange then --This is only a check for non aggressive animals
		if not hum then return end --guard clause
		if hum.Health > 0 then
			state = "Run"
			self:RunFrom(self.Target)
		end
	end
	state = self.Run and "Run" or state
	self:PlayAnimation(state)
end

function AnimalClass:CalculateObstacles() --Checks if theres a wall, if there isnt checks if theres water, if either works, runs away behind 
	local origin = Vector3.new(self.Root.Position.X, self.Root.Position.Y, self.Root.Position.Z)
	local dir = self.Root.CFrame.LookVector
	local length = 11
	local hit, position, normal, material = RAY_UTIL:Raycast(origin, dir * length, "Whitelist", workspace.Terrain)
	--local rayLength = (origin - position).Magnitude
	local hitAngle = hit and math.deg(math.acos(normal.Y)) or 0
	
	if hitAngle > 75 then
		self:DashAway()
	else
		local origin = (self.Root.CFrame * CFrame.new(0, 1, -20)).Position
		local dir = self.Root.CFrame.UpVector * -1
		local hit, position, normal, material = RAY_UTIL:Raycast(origin, dir * length, "Whitelist", workspace.Terrain)
		if material == Enum.Material.Water then
			self:DashAway()
		end
	end	
end

return AnimalClass