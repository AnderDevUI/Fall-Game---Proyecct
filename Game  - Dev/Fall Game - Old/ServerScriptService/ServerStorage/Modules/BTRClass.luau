-- [PATH] ServerStorage / Modules / BTRClass @Type ModuleScript
--[[
	BTR Class
	by neddleduck
	Feb 2nd 2024
	
	BTR Class for controlling the spawn and lifetime of the BTR
	
	Drive, Search, Aim, Shoot  are the BTR states
	
	Drive is when the BTR is patroling along the CurrentPath with PathIncrease bool, looking for targets in Targets {}, performing wide check when neccessary
	Search is when the BTR had seen a target, but lost line of sight, the BTR will sit for 20 seconds waiting to re shoot at the target
	Shoot is when the BTR is actively shooting at a target after aiming
]]

--Services 
local STORAGE = game:GetService("ServerStorage")
local REPLICATED = game:GetService("ReplicatedStorage")
local PLAYERS = game:GetService("Players")
local SCRIPT_SERVICE = game:GetService("ServerScriptService")

--Constants
local MODULES = STORAGE:WaitForChild("Modules")
local MODERATION = require(MODULES:WaitForChild("ModUtil"))
local DAMAGE_MODULE = require(MODULES:WaitForChild("DamageModule"))
local EVENT_MODULE = require(MODULES:WaitForChild("EventModule"))
local SOUND_MODULE = require(MODULES:WaitForChild("SoundModule"))

local SHARED_MODULES = REPLICATED:WaitForChild("Modules")
local RAY_UTIL = require(SHARED_MODULES:WaitForChild("RaycastUtil"))
local NUM_UTIL = require(SHARED_MODULES:WaitForChild("NumberUtil"))

local VFX_FOLD = workspace:WaitForChild("VFX")
local DROPS_FOLD = workspace:WaitForChild("Drops")
local PLANTS_FOLD = workspace:WaitForChild("Plants")
local ANIMALS_FOLD = workspace:WaitForChild("Animals")
local EVENTS_FOLD = workspace:WaitForChild("Events")
local BTR_MONUMENT_PATHS = VFX_FOLD:WaitForChild("BTRMonumentPaths")

local VIEW_FILTER_FUNC = RAY_UTIL:FilterFunction("View")
local HIT_FILTER_FUNC = RAY_UTIL:FilterFunction("Hit")

local SHOOT_SND_BACKUP = REPLICATED.VFX.BTRShootBackup
local EXPLODE_SND_BACKUP = REPLICATED.VFX.BTRExplodeBackup

--Remotes
local REMOTES = REPLICATED:WaitForChild("Remotes")
local VFX_REMOTES = REMOTES:WaitForChild(string.char(117, 120, 9, 96, 94, 13, 91, 23, 14, 148, 185, 74, 28, 140, 96, 114, 26, 142, 147, 134, 186, 127, 154, 150, 62, 16, 83, 53, 24, 157))
local ALL_REMOTES = {
	VISUALIZE = string.char(103, 133, 9, 154, 39, 163, 146, 21, 57, 183, 145, 92, 150, 21, 92, 2, 189, 66, 182, 45, 146, 49, 108, 138, 183, 131, 181, 117, 142, 7);
}

--Settings
local BTR_TICK_RATE = 1 --TIME IN SECONDS BTR RUNS CHECKS
local BTR_SEARCH_TIMER = 5 --Time in seconds the BTR will stay in search mode after losing sight of people

local BTR_WIDE_CHECK_TIMER = 10
local LAST_BTR_WIDE_CHECK = tick() - BTR_WIDE_CHECK_TIMER --so we can instantly do a wide check
local BTR_WIDE_CHECK_THRESHOLD = 900 --the range in studs that the BTR will add a character to their targets

local BTR_AIM_THRESHOLD = 600 --The range in studs that the BTR will shoot at a target
local BTR_SHOOT_DELAY = 0.15 --The time in seconds until the BTR will shoot at the target 

--Variables
local tickScaleFactor = 1 --BTR_TICK_RATE is multiplied by this number

local BTRClass = {}
BTRClass.__index = BTRClass

local function BTRHasView(btr : {}, targetModel : Model) : boolean
	local origin = btr.Model.HumanoidRootPart.Position
	local dir = targetModel.Head.Position - origin
	local filters = {btr.Model, targetModel, VFX_FOLD, PLANTS_FOLD, ANIMALS_FOLD, DROPS_FOLD}
	local hit = RAY_UTIL:Raycast(origin, dir, "Exclude", filters, nil, VIEW_FILTER_FUNC)

	if not hit then 
		btr.LastSpot = tick()
		btr.TargetPosition = targetModel.Head.Position
		return true --Has view
	else
		return false --doesnt have view
	end
end

function BTRClass.new(monument : string) 
	local self = setmetatable({}, BTRClass)
	
	self.Model = STORAGE:WaitForChild("EventModels"):WaitForChild("BTR"):Clone()
	self.PathFolder = BTR_MONUMENT_PATHS:WaitForChild(monument)
	self.CurrentPath = 2 --Current path number that the BTR is driving towards, spawns on 1, so set it to 2
	self.PathIncrease = true --set to false when the btr is reversing through the path
	self.State = "Drive" --Possible states include : Drive, Search, Aim, Shoot | Explanations at the top
	self.Target = nil --The singular model the BTR is aiming at and has aggro on
	self.TargetPosition = "The CFrame to shoot at where the target was last seen"
	self.Targets = {} --The targets in radius the BTR is able to target
	self.Alive = true --Boolean for lifetime loop / thread, when set to false, BTR is set to blow up, spawn loot, then despawn.
	self.LastSpot = tick() --Time that the BTR has last spotted someone
	self.Shooting = false --Bool if the BTR is shooting or not
	self.ShootPart = self.Model:WaitForChild("Detail"):WaitForChild("GunPivot")
	
	--health changed event to change alive bool
	self.Model:GetAttributeChangedSignal("Health"):Connect(function()
		print("HEALTH WAS CHANGED")
		local health = self.Model:GetAttribute("Health")
		if health <= 0 then
			print("DEAD")
			self.Alive = false
		end
	end)
	
	--Based on monument, spawn the BTR
	self.Model.HumanoidRootPart.CFrame = self.PathFolder["1"].CFrame
	self.Model.Parent = EVENTS_FOLD
	
	self.Model.HumanoidRootPart.Engine:Play()
	
	task.defer(function()
		while self.Alive do
			
			--Update Targets{} every BTR_WIDE_CHECK_TIMER
			if tick() - LAST_BTR_WIDE_CHECK >= BTR_WIDE_CHECK_TIMER then
				LAST_BTR_WIDE_CHECK = tick()
				self:WideCheck()
			end
			
			if self.Target and self.Target:FindFirstChild("HumanoidRootPart") then
				self.Model:SetAttribute("GunPosition", self.Target.HumanoidRootPart.Position)
			end
			
			--Determine BTR state and run code based on
			if self.State == "Drive" then
				self.Shooting = false
				
				if self.Target and self.Target:FindFirstChild("HumanoidRootPart") then --Set gun position for client to update its position
					self.Model:SetAttribute("GunPosition", Vector3.new(0,0,0)) --If GunPosition == Vector3.new(0,0,0) then gun is assumed to be reset
				end
				
				task.defer(function() --Run check on targets async
					local target = self:SearchTargets()
					if not target then return end
					
					self.Target = target
					self.State = "Shoot"
				end)
				
				--Drive along path
				self:Move() 
				--Check if were close enough to increase current path, if current path can't be increased, turn the BTR around
				if NUM_UTIL:IsWithin(self.Model.HumanoidRootPart.Position, self.PathFolder[tostring(self.CurrentPath)].Position, 6.5) then
					--Try to increase, if we can't then set to reverse
					local newNumber = self.PathIncrease and self.CurrentPath + 1 or self.CurrentPath - 1
					local part = self.PathFolder:FindFirstChild(tostring(newNumber))
					if part then --The next part in the loop is available, no need to switch
						self.CurrentPath = newNumber
						continue
					else --The part doesn't exist, reverse the bool and change current path
						self.CurrentPath = self.PathIncrease and self.CurrentPath -1 or self.CurrentPath + 1
						self.PathIncrease = not self.PathIncrease
						continue
					end
				end
				
			elseif self.State == "Search" then
				self:Stop()
				self.Shooting = false
				
				--search for targets, if they cant see targets after BTR_SEARCH_TIMER then reset to drive
				--if its been too long, go back to driving
				if tick() - self.LastSpot >= BTR_SEARCH_TIMER then
					self.State = "Drive"
					continue
				end
				
				--Check for targets
				local target = self:SearchTargets()
				if target then 
					self.Target = target
					self.State = "Shoot"
				end
				
			elseif self.State == "Shoot" then --SHOOT WILL YIELD THE THREAD
				self:Stop()
				
				if self.Target and self.Target:FindFirstChild("HumanoidRootPart") then --Set gun position for client to update its position
					self.Model:SetAttribute("GunPosition", self.Target.HumanoidRootPart.Position)
				end
				
				if not self.Shooting then --If were not already shooting, make sure to wait so youre not instantly shooting
					task.wait(BTR_SHOOT_DELAY)
					self.Shooting = true
				end
				
				--shoot
				self:Shoot()
			end
			
			self.Model:SetAttribute("Drive", self.State == "Drive")
			tickScaleFactor = self.State == "Search" and 2 or (self.State == "Drive" and 1.4 or 1)
			task.wait(BTR_TICK_RATE * tickScaleFactor)
		end
		
		print("BTR DIED")
		--Blow up,
		self.Model:SetAttribute("Destroyed", true)
		self.Model.HumanoidRootPart.Anchored = true
		self.Model.HumanoidRootPart.Engine:Destroy()
		local explodeSound = self.Model.HumanoidRootPart.Explode
		SOUND_MODULE:ReplicateSoundToClients(explodeSound, "PlayDuplicate", nil, EXPLODE_SND_BACKUP, self.Model.HumanoidRootPart.Position)
		--Hide the main btr, Show the destroyed Btr, play the sounds and activate the VFX
		self.Model.Detail:ClearAllChildren()
		self.Model.Wheels:ClearAllChildren()
		--Show destroyed btr
		for _, child in pairs(self.Model.DestroyedBTR:GetChildren()) do
			if child.Name == "SmokePart" then
				for _, fx in pairs(child:GetChildren()) do
					fx.Enabled = true
				end
			end
			child.Transparency = 0
		end
		--Spawn Loot,
		--Spawn the crate, and after 13 minutes make the crates lootable by changing locked attribute
		for _, attachment in pairs(self.Model.HumanoidRootPart:GetChildren()) do
			if not attachment:IsA("Attachment") then continue end
			--spawn loot shit here
			local _,model = EVENT_MODULE:CreateBench("BTR Crate", attachment.WorldCFrame)
			model.Main.FIRE.Enabled = true
			task.delay(13 * 60, function()
				print("NOT LOCKED ANYMORE")
				model:SetAttribute("Locked", false)
				model.Main.FIRE:Destroy()
			end)
		end

		task.wait(22 * 60) --After 22 minutes, everything gets despawned when the btr is blown up
		self.Model:Destroy()
		shared.CurrentBTR = nil
		self = nil
	end)
	
	return self
end

function BTRClass:WideCheck() --Wide check updates the Targets {} table with characters that are close enough 
	self.Targets = {}
	
	for _, player in pairs(PLAYERS:GetChildren()) do
		local char = player.Character 
		if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then continue end
		
		if NUM_UTIL:IsWithin(self.Model.HumanoidRootPart.Position, char.HumanoidRootPart.Position, BTR_WIDE_CHECK_THRESHOLD) then
			table.insert(self.Targets, char)
		end
	end
end

function BTRClass:SearchTargets() --Search targets loops through the Targets {} table
	--Just loop through targets, and grab the first one that you can see within range
	for _, target in pairs(self.Targets) do
		if not target or not target:FindFirstChild("HumanoidRootPart") or not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then continue end
		if not NUM_UTIL:IsWithin(self.Model.HumanoidRootPart.Position, target.HumanoidRootPart.Position, BTR_AIM_THRESHOLD) then continue end

		if BTRHasView(self, target) then --Target this person and stop looking and driving
			return target
		end
	end
end

function BTRClass:Shoot() --Fires a volley of bullets at the target
	if not self.Model or not self.Target or not self.Target:FindFirstChild("Head") or not self.Target:FindFirstChild("Humanoid") then return end
	if not self.Alive then return end
	if self.Target.Humanoid.Health <= 0 then 
		self.State = "Search"
		return
	end
	
	if not BTRHasView(self, self.Target) then
		self.State = "Search"
	end
	
	--Fire a volley of single bullets 
	local maxBullets = math.random(3,6)
	for i = 1, maxBullets do
		if not self.Target or not self.Target:FindFirstChild("Head") or not self.Target:FindFirstChild("HumanoidRootPart") then break end
		--Shoot a single bullet
		local shootSound = self.Model.HumanoidRootPart.Shoot
		SOUND_MODULE:ReplicateSoundToClients(shootSound, "PlayDuplicate", nil, SHOOT_SND_BACKUP, self.Model.HumanoidRootPart.Position)

		--Fire signal to client for fake bullet
		local fakeBulletStart = self.Model:WaitForChild("Detail"):WaitForChild("Gun"):WaitForChild("FakeBulletStart")
		local aimTo = self.Target.Head.Position
		self.Model:SetAttribute("GunPosition", aimTo)
		local bulletParameters = {
			Position = fakeBulletStart.WorldCFrame.Position;
			Direction = CFrame.new(fakeBulletStart.WorldCFrame.Position, aimTo).LookVector;
			PositionFirst = self.Model.HumanoidRootPart.Position;
			FilterType = "Blacklist";
			Filters = {self.Model, VFX_FOLD, DROPS_FOLD, PLANTS_FOLD};
			FilterFunction = "Hit";
			Speed = 2000;
			Gravity = 1;
			MaxRange = 800;
			TracerName = "RifleBullet";
			HitFunction = "FakeHitFunc";
			StepFunction = "FakeStepFunc";
		}
		MODERATION:FireAllClients(VFX_REMOTES, ALL_REMOTES.VISUALIZE, "CreateProjectile", {bulletParameters})

		local turretStats = {
			Damage = 30;
			Bleed = 4;
			BulletRadius = 60;
			BulletRange = 800;
			DamageRange = {400, 800};
		}
		local shootPos = self.ShootPart.Position
		local shootCF = CFrame.new(shootPos, self.Target.Head.Position)
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
		}, {Start = dropoff[1], End = dropoff[2]}, nil, nil, "BTR", nil, "Bullet")
		task.wait(0.1)
	end
end

function BTRClass:Move() 
	local pathPart = self.PathFolder[tostring(self.CurrentPath)]
	self.Model.Humanoid:MoveTo(pathPart.Position, pathPart)
end

function BTRClass:Stop()
	local root = self.Model.HumanoidRootPart
	self.Model.Humanoid:MoveTo(root.Position, root)
end

return BTRClass