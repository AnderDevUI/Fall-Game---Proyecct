-- [PATH] ServerStorage / Modules / MilitaryClass @Type ModuleScript
--[[
	MilitaryClass
	by neddleduck
	June 5th 2023
]]

--Services 
local STORAGE = game:GetService("ServerStorage")
local REPLICATED = game:GetService("ReplicatedStorage")
local PLAYERS = game:GetService("Players")
local PATHFINDING = game:GetService("PathfindingService")
local SCRIPT_SERVICE = game:GetService("ServerScriptService")

--User Services
local BENCH_SERVICE = SCRIPT_SERVICE:WaitForChild("BenchService")

--Constants
local MODULES = STORAGE:WaitForChild("Modules")
local MODERATION = require(MODULES:WaitForChild("ModUtil"))
local MILITARY_INFO = require(MODULES:WaitForChild("MilitaryInfo"))
local DAMAGE_MODULE = require(MODULES:WaitForChild("DamageModule"))
local BENCHCLASS = require(MODULES:WaitForChild("BenchClass"))
local SOUND_MODULE = require(MODULES:WaitForChild("SoundModule"))
local EVENT_MODULE = require(MODULES:WaitForChild("EventModule"))
local RAGDOLL_MODULE = require(MODULES:WaitForChild("RagdollModule"))

local SHARED_MODULES = REPLICATED:WaitForChild("Modules")
local WELD_MOD = require(SHARED_MODULES:WaitForChild("WeldModule"))
local RAY_UTIL = require(SHARED_MODULES:WaitForChild("RaycastUtil"))
local TOOL_INFO = require(SHARED_MODULES:WaitForChild("ToolInfo"))
local NUM_UTIL = require(SHARED_MODULES:WaitForChild("NumberUtil"))

local VFX_FOLD = workspace:WaitForChild("VFX")
local DROPS_FOLD = workspace:WaitForChild("Drops")
local PLANTS_FOLD = workspace:WaitForChild("Plants")
local ANIMALS_FOLD = workspace:WaitForChild("Animals")

local WORKSPACE_MILITARY = workspace:WaitForChild("Military")
local STORAGE_MILITARY = STORAGE:WaitForChild("Military")
local ARMORS = REPLICATED:WaitForChild("Armors")
local VMS = REPLICATED:WaitForChild("VMs")
local BASES = workspace:WaitForChild("Bases")

local SHOOT_SND_BACKUP = REPLICATED.VFX.MilitaryShootBackup

local HIT_FILTER_FUNC = RAY_UTIL:FilterFunction("Hit")
local VIEW_FILTER_FUNC = RAY_UTIL:FilterFunction("View")

--Remotes
local REMOTES = REPLICATED:WaitForChild("Remotes")
local VFX_REMOTES = REMOTES:WaitForChild(string.char(117, 120, 9, 96, 94, 13, 91, 23, 14, 148, 185, 74, 28, 140, 96, 114, 26, 142, 147, 134, 186, 127, 154, 150, 62, 16, 83, 53, 24, 157))
local ALL_REMOTES = {
	VISUALIZE = string.char(103, 133, 9, 154, 39, 163, 146, 21, 57, 183, 145, 92, 150, 21, 92, 2, 189, 66, 182, 45, 146, 49, 108, 138, 183, 131, 181, 117, 142, 7);
}

local ARMOR_INDEXES = {
	Bruno = {
		{"Bruno's Helmet", "Default"}, {"Bruno's Chestplate", "Default"}, {"Military Leggings", "Default"}, {"Hoodie", "Abibas"}, {"Pants", "Abibas"}, {"Boots", "Abibas"}, {"Military Gloves", "Default"}, {"Balaclava", "Default"}
	};
	Soldier = {
		{"Military Helmet", "Default"}, {"Military Chestplate", "Default"}, {"Military Leggings", "Default"}, {"Military Gloves", "Default"}, {"Balaclava", "Default"}, {"Hoodie", "Woodland"}, {"Pants", "Woodland"}, {"Boots", "Woodland"}
	}
}

--Settings
local LIFETIME_CHECK_DELAY = 0.6 --DEFAULT BRAIN TIMER, CAN BE OVERWRITTEN IN MILITARY INFO WITH BrainTimer
local TARGET_SEARCH_WIDE_DELAY = 12 --Time in seconds the military class will update its wide targets
local MAXIMUM_TARGET_DISTANCE = 1200 --Maximum distance AI will shoot at targets
local TARGET_ADD_DISTANCE = 260 --Studs the AI will start to shoot at you

--Class Metatable
local MilitaryClass = {}
MilitaryClass.__index = MilitaryClass

function MilitaryClass.new(weaponName : string, pathsFolder : Instance, monumentName : string)
	local self = setmetatable({}, MilitaryClass)
	--Variables
	--local spawnPart = spawnsFolderChildren[math.random(1, #spawnsFolderChildren)] OLD FOR RANDOM SPAWN
	local spawnPart = pathsFolder:FindFirstChild("1")
	local spawnPoint = spawnPart.Position
	local info = MILITARY_INFO[weaponName]
	local isBruno = weaponName == "Bruno's M4A1"
	LIFETIME_CHECK_DELAY = info.BrainTimer and info.BrainTimer or LIFETIME_CHECK_DELAY
	
	self.Targets = {} --This variable stores the current targets 
	--[[
	self.Targets = {
		[targetCharacterModel] = {HeadOfTarget, DmgTheyHaveDealt} 
	}
	]]
	self.Target = nil --This variable stores the ROOT PART of the current target
	self.State = "inactive" --States include : "inactive", "delete", 
	self.LastDamageTakenTime = tick() --This variable stores the time the NPC was last damaged
	self.Model = MODERATION:SafeClone(STORAGE_MILITARY:FindFirstChild(isBruno and "Bruno" or "Soldier")) --Stores the model for the NPC
	self.Root = self.Model:WaitForChild("HumanoidRootPart")
	self.Humanoid = self.Model:WaitForChild("Humanoid")
	self.Lootable = false --A boolean for determining if the military NPC has been turned into a lootable body, used when the lifetime thread stops and we want to cleanup
	self.CurrentPath = 1 --Current path number
	self.Paths = pathsFolder --table containing the indexes of the path parts for the AI to move on
	self.PathReverse = false --Boolean for moving backwards along the path if true
	
	local toolInfo = TOOL_INFO[weaponName]
	
	local lastWaypointCheck = tick() --Time that the last waypoints were calculated
	local forceWaypointCheck = false --Used if the target is changed and needs to force the different waypoint path
	
	local lastWeaponExecute = tick()

	--Weld gun if not bruno
	if not isBruno then 
		local weaponModel = MODERATION:SafeClone(STORAGE.Items:FindFirstChild(weaponName).Default)
		weaponModel.Parent = self.Model
		WELD_MOD:WeldModelToPart(weaponModel, self.Model:FindFirstChild("RightHand"), ((toolInfo and toolInfo.Offsets.Global) or CFrame.new()), false)
	end
	--Weld armor
	local armors = isBruno and ARMOR_INDEXES.Bruno or ARMOR_INDEXES.Soldier
	for _, armor in pairs(armors) do
		local model = MODERATION:SafeClone(ARMORS:FindFirstChild(armor[1]):FindFirstChild(armor[2]))
		WELD_MOD:FullyWeldModels(model, self.Model, true)
	end
	--Put shoot sound in their humanoid root part based on gun
	local snd = STORAGE_MILITARY:WaitForChild("GunSounds"):WaitForChild(weaponName):Clone()
	snd.Name = "Shoot"
	snd.Parent = self.Model.HumanoidRootPart


	--Parent model
	self.Model.Parent = WORKSPACE_MILITARY[monumentName]
	
	--Position
	self.Model:PivotTo(CFrame.new(spawnPoint.X, spawnPoint.Y + 2.5, spawnPoint.Z))
	--Set model and children to be owned by server
	for _, part in pairs(self.Model:GetChildren()) do
		if part:IsA("BasePart") then
			part:SetNetworkOwner()
		end
	end
	
	--Setup Animations
	local animFold = self.Model:WaitForChild("Animations")
	local weaponAnims = VMS:FindFirstChild(weaponName).GlobalAnims:GetChildren()
	self.Playing = {} --Table of strings of current animation names playing
	self.Animations = (function()
		local animationTable = {}
		--Load Base Animations
		for _, anim in pairs(animFold:GetChildren()) do
			if not anim:IsA("Animation") then continue end
			animationTable[anim.Name] = self.Humanoid:LoadAnimation(anim)
		end
		--Load Weapon Animations
		for _, anim in pairs(weaponAnims) do
			if not anim:IsA("Animation") then continue end
			animationTable[weaponName .. anim.Name] = self.Humanoid:LoadAnimation(anim)
		end
		return animationTable
	end)()
	
	--Disable some humanoid states / set walkspeed
	local hum = self.Model:WaitForChild("Humanoid")
	hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
	hum.WalkSpeed = info.Speed
	hum.MaxHealth = info.Health
	hum.Health = info.Health
	local oldHealth = hum.Health
	--Setup a connection for when the humanoid is damaged
	hum.HealthChanged:Connect(function(newHealth)
		local decreased = (newHealth < oldHealth)
		oldHealth = newHealth
		if not decreased then return end
		self.LastDamageTakenTime = tick()
	end)
	--Setup humanoid died function
	hum.Died:Connect(function() --If this function runs, then it will re parent the body to another folder setting it up to be a lootable body before deleting it here
		self.Lootable = true
		self.State = "delete" --stops the while loop
		
		if self.Root and self.Root.Walk then
			self.Root.Walk:Stop() -- STOP WALKING SOUND CUZ ITS ANNOYING
		end
		
		--Setup/Create lootable body
		local benchFolder = BASES.Loners:FindFirstChild("Contents")
		if not benchFolder then
			benchFolder = Instance.new("Folder")
			benchFolder.Name = "Contents"
			benchFolder.Parent = BASES.Loners
		end
		
		RAGDOLL_MODULE.RagdollCharacter(self.Model, true)
		self.Model.Name = "Contents"
		self.Model.Parent = benchFolder
		self.Model:SetAttribute("BenchName", isBruno and "Body of Bruno" or weaponName .. " Scav Body")
		self.Model:SetAttribute("Health", 0)
		self.Model:SetAttribute("MaxHealth", 0)
		self.Model:SetAttribute("Repair", 0)
		self.Model:SetAttribute("Skin", "Default")
		self.Root.Name = "Main"
		self.Root.Transparency = 1.01
		local benchClass = BENCHCLASS.new(self.Model)
		shared.Benches[self.Model] = benchClass
	end)
	
	task.defer(function() --Lifetime thread
		self:ToggleAnimation("Idle", true)
		self:ToggleAnimation(weaponName.."Idle", true)
		
		task.defer(function() --Targets table updater thread NOTE: DOES NOT SET self.Target only self.Targets
			while self.State ~= "delete" do
					task.defer(function()
						--Wide check for targets
						self:UpdateTargets()
					end)
				wait(TARGET_SEARCH_WIDE_DELAY)
			end
		end)
		
		--Update state based on target
		while self.State ~= "delete" do --When state is set to delete, the AI is going to end the lifetime loop and destroy itself, unless lootable is true, then it will be a body for a bit
			if not self.Model or not self.Model.Head then self.State = "delete" end
			
			--Update Target based on Targets and State based on Target, Their Sight, Their HP, ETC
			local mvt = nil --MOST VALUABLE TARGET = {HeadOfTarget, DmgTheyHaveDealt, hasSight}
			local hasSight = false
			for i, target in pairs(self.Targets) do --Run through targets, determine the best target
				local hum = target[1].Parent
				if not NUM_UTIL:IsWithin(target[1].Position, self.Model.Head.Position, MAXIMUM_TARGET_DISTANCE) or (target[1].Parent and target[1].Parent.Humanoid and target[1].Parent.Humanoid.Health <=0) or (not hasSight and not NUM_UTIL:IsWithin(target[1].Position, self.Model.Head.Position, TARGET_ADD_DISTANCE)) then --Target is out of range or, their humanoid is dead, skip them remove them from targets
					self.Targets[i] = nil
					continue
				end
				
				hasSight = self:HasSight(target[1].Parent)
				local damageDone = target[2]
				
				if not mvt then
					mvt = {target[1], target[2], hasSight}
					hasSight = mvt[3]
					continue
				end
				if hasSight then --Has sight on new target
					if not mvt[3] then --Didnt have sight on previous target
						mvt = {target[1], target[2], hasSight}
					else --has sight on previous target
						if target[2] > mvt[2] then --If new target youre checking has done more damage, switch to them
							mvt = {target[1], target[2], hasSight}
						end
					end
				else --Doesn't have sight on new target
					if not mvt[3] and target[2] > mvt[2] then --Doesn't have sight of old target, and If new target youre checking has done more damage, switch to them
						mvt = {target[1], target[2], hasSight}
					end
				end
				hasSight = mvt[3]
			end
			self.Target = mvt and {mvt[1], mvt[2]} or nil
			
			--Update State based on Target and hasSight
			if not self.Target then --No Target
				if #self.Targets > 0 then --Targets in area 
					self.State = "patrol"
				else --People not nearby or in area just sit there
					self.State = "inactive"
				end
			else --Have a target, and we can assume the target is in range, it was just assigned
				if hasSight then --Has sight of target, shoot them
					self.State = "shoot"
				else --Doesn't have sight of target
					self.State = "patrol"
				end
			end
			
			if self.State ~= "patrol" then
				self:ToggleAnimation("Forward", false)
				if self.Root and self.Root.Walk and self.Root.Walk.IsPlaying then
					self.Root.Walk:Stop()
				end
			end
			if self.State ~= "inactive" then
				if self.Root then
					self.Root.Anchored = false
				end
			end
			
			--After updating target and state, perform state logic check
			if self.State == "inactive" then 
				--do nothing
				self.Root.Anchored = true
				self.Humanoid:MoveTo(self.Model.HumanoidRootPart.Position, self.Model.HumanoidRootPart) -- stop moving
			elseif self.State == "patrol" then --Patrol around paths
				self:ToggleAnimation("Forward", true)
				if self.Root and self.Root.Walk and not self.Root.Walk.IsPlaying then
					self.Root.Walk:Play()
				end
				local function getNextPath()
					return self.Paths:FindFirstChild(tostring(self.CurrentPath + (self.PathReverse and -1 or 1)))
				end
				local nextPath = getNextPath()
				--check if we are close enough to the next path to increase our current path
				local closeEnough = NUM_UTIL:IsWithin(self.Root.Position, nextPath.Position, 4)
				if closeEnough then --Close enough to change paths and increase
					self.CurrentPath += self.PathReverse and -1 or 1
					nextPath = getNextPath()
					if not nextPath then
						self.PathReverse = not self.PathReverse
						nextPath = getNextPath()
					end
				end
				self.Humanoid:MoveTo(nextPath.Position, nextPath)
			elseif self.State == "shoot" then 
				task.defer(function()
					local startPos = self.Model.HumanoidRootPart.Position
					local lookAtPos = Vector3.new(self.Target[1].Position.X, startPos.Y, self.Target[1].Position.Z)
					self.Model.HumanoidRootPart.CFrame = CFrame.new(startPos, lookAtPos) --Face target
					if not (tick() - lastWeaponExecute >= info.BurstDelay) then return end
					lastWeaponExecute = tick()
					self:Shoot(info.ShotCount, toolInfo.Weapon.RPM, info.Damage, weaponName)
				end)
			end
			
			task.wait(LIFETIME_CHECK_DELAY)
		end
		--Ai loop is over
		if isBruno then
			--Bruno is dead, tell server hes dead
			BENCH_SERVICE:SetAttribute("Bruno", false)
		end
		
		
		if self.Lootable == false then --The ai was cleaned up and not killed by a player, so just delete it
			MODERATION:SafeDestroy(self.Model)
		end
	end)
	
	return self, self.Model
end

--Functions
function MilitaryClass:ToggleAnimation(animName : string, toggle : boolean)
	local anim = self.Animations[animName]
	if not anim then return end
	local isPlaying = table.find(self.Playing, animName)
	if toggle and not isPlaying then
		table.insert(self.Playing, animName)
		anim:Play()
	elseif not toggle then
		anim:Stop()
		if isPlaying then
			table.remove(self.Playing, isPlaying)
		end
	end
end

function MilitaryClass:UpdateTargets() --This function updates the military ais targets table that it can search through to find a target
	if not self.Model or not self.Model.Head then return end
	for index, target in pairs(self.Targets) do --loop through current targets and remove any that aren't in max distance
		local targetHead = target[1]
		if not NUM_UTIL:IsWithin(self.Model.Head.Position, targetHead.Position, MAXIMUM_TARGET_DISTANCE) then 
			self.Targets[index] = nil
		end
	end
	for _, player in pairs(game.Players:GetChildren()) do --go through players and add any that are in distance
		local char = player.Character
		if not char or not char:FindFirstChild("Head") or not self.Model or not self.Model.Head then continue end
		local targetHead = char.Head
		if NUM_UTIL:IsWithin(self.Model.Head.Position, targetHead.Position, TARGET_ADD_DISTANCE) then
			if self.Targets[char] ~= nil then continue end
			self.Targets[char] = {targetHead, 0}
		end
	end
end

function MilitaryClass:Shoot(shotCount : number, rpm : number, dmg : number, weaponName)
	local function toggleFlashPartFX(p : Part, b : boolean) 
		for _, c in pairs(p:GetChildren()) do
			if pcall(function() local _ = c.Enabled end) then
				c.Enabled = b
			end
		end
	end
	local flashPart = self.Model:WaitForChild("Default"):WaitForChild("FlashPart")
	for i = 1, shotCount do
		if i == 1 then
			--Start shooting FX
			toggleFlashPartFX(flashPart, true)
		elseif i == shotCount then
			--Stop shooting FX after 0.2 seconds
			task.delay(0.2, function()
				toggleFlashPartFX(flashPart, false)
			end)
		end
		if not self.Target or not self.Target[1] or not self.Target[1].Parent or not self.Target[1].Parent.Humanoid or self.Target[1].Parent.Humanoid.Health <= 0 then
			toggleFlashPartFX(flashPart, false)
			break
		end
		
		--Shoot a single bullet
		local shootSound = self.Model.HumanoidRootPart.Shoot
		SOUND_MODULE:ReplicateSoundToClients(shootSound, "PlayDuplicate", nil, SHOOT_SND_BACKUP, self.Model.HumanoidRootPart.Position)
		--Fire signal to client for fake bullet
		local fakeBulletStart = flashPart
		local aimTo = self.Target[1].Position
		self.Model:SetAttribute("GunPosition", aimTo)
		local bulletParameters = {
			Position = fakeBulletStart.Position;
			Direction = CFrame.new(fakeBulletStart.Position, aimTo).LookVector;
			PositionFirst = self.Model.HumanoidRootPart.Position;
			FilterType = "Blacklist";
			Filters = {self.Model, VFX_FOLD, DROPS_FOLD, PLANTS_FOLD};
			FilterFunction = "Hit";
			Speed = 1500;
			Gravity = 1;
			MaxRange = 800;
			TracerName = "RifleBullet";
			HitFunction = "FakeHitFunc";
			StepFunction = "FakeStepFunc";
		}
		MODERATION:FireAllClients(VFX_REMOTES, ALL_REMOTES.VISUALIZE, "CreateProjectile", {bulletParameters})

		local turretStats = {
			Damage = dmg;
			Bleed = 1;
			BulletRadius = 115;
			BulletRange = 800;
			DamageRange = {400, 800};
		}
		local shootPos = flashPart.Position
		local shootCF = CFrame.new(shootPos, self.Target[1].Position)
		local offset = turretStats.BulletRadius * math.sqrt(math.random())
		local rotation = math.random() * 2 * math.pi
		local aimTo = (shootCF * CFrame.new(0, 0, -turretStats.BulletRange) * CFrame.Angles(rotation, 0, 0) * CFrame.new(0, offset, 0)).Position
		local bulletHit, bulletPos, bulletNor, bulletMat = RAY_UTIL:Raycast(shootPos, aimTo - shootPos, "Exclude", {VFX_FOLD, DROPS_FOLD, PLANTS_FOLD, self.Model}, nil, HIT_FILTER_FUNC, true)
		local hitPos = (bulletHit and bulletHit.CFrame:PointToObjectSpace(bulletPos))
		local rawDamage = turretStats.Damage
		local dropoff = turretStats.DamageRange
		DAMAGE_MODULE:Damage(bulletHit, hitPos, bulletNor, shootCF, {
			Head = rawDamage * 1.5;
			Chest = rawDamage;
			Arms = rawDamage;
			Legs = rawDamage * 0.75;
			Bleed = turretStats.Bleed;
		}, {Start = dropoff[1], End = dropoff[2]}, nil, nil, weaponName == "Bruno's M4A1" and "BRUNO" or "MILITARY", nil, "Bullet")
		
		task.wait(60 / rpm)
	end
end

function MilitaryClass:HasSight(of : Model) : boolean
	--Fire a ray to the target, if class can see and fire at target, return true, else false
	if not self.Model or not self.Model.Head or not of or not of.Head then return false end
	
	local origin = self.Model.Head.Position
	local dir = of.Head.Position - origin
	local filters = {self.Model, of, VFX_FOLD, PLANTS_FOLD, ANIMALS_FOLD, DROPS_FOLD}
	local hit = RAY_UTIL:Raycast(origin, dir, "Exclude", filters, nil, VIEW_FILTER_FUNC)
	if not hit then 
		return true --Has view
	else
		return false --doesnt have view
	end
	
end

return MilitaryClass