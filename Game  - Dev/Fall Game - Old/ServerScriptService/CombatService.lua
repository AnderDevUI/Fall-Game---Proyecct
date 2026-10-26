-- [PATH] ServerScriptService / ServerService / CombatService @Type Script
--[[
	CombatService
	by ChickenBagelz
	September 7th, 2022
	
	Master script of all combat, actions, and damaging                                                                                                                                                             :3
]]

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local Debris = game:GetService("Debris")
local ServerScripts = game:GetService("ServerScriptService")
local Run = game:GetService("RunService")
local Http = game:GetService("HttpService")
-- Dependencies
local InventoryService = ServerScripts:WaitForChild("InventoryService")
local FireService = ServerScripts:WaitForChild("FireService")
local ServerService = ServerScripts:WaitForChild("ServerService")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")
local VFX_PARTS = workspace:WaitForChild("VFX")
local VFX_STORAGE = Replicated:WaitForChild("VFX")
local Drops = workspace:WaitForChild("Drops")
local Plants = workspace:WaitForChild("Plants")
local Animals = workspace:WaitForChild("Animals")
local Events = workspace:WaitForChild("Events")
local Values = Replicated:WaitForChild("Values")
local Remotes = Replicated:WaitForChild("Remotes")
local ItemModels = Storage:WaitForChild("Items")
local GlobalSounds = Storage:WaitForChild("GlobalSounds")
local Bases = workspace:WaitForChild("Bases")
local CombatRemotes = Remotes:WaitForChild(string.char(136, 151, 150, 79, 83, 47, 12, 43, 83, 127, 29, 120, 155, 32, 59, 102, 175, 55, 75, 15, 144, 155, 96, 107, 90, 79, 115, 186, 42, 82))
local VFXRemotes = Remotes:WaitForChild(string.char(117, 120, 9, 96, 94, 13, 91, 23, 14, 148, 185, 74, 28, 140, 96, 114, 26, 142, 147, 134, 186, 127, 154, 150, 62, 16, 83, 53, 24, 157))

-- Modules
local Items = require(SharedModules:WaitForChild("Items"))
local ToolInfo = require(SharedModules:WaitForChild("ToolInfo"))
local RaycastUtil = require(SharedModules:WaitForChild("RaycastUtil"))
local VFXModule = require(SharedModules:WaitForChild("VFXModule"))
local ItemClass = require(SharedModules:WaitForChild("ItemClass"))
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local DamageModule = require(ServerModules:WaitForChild("DamageModule"))
local SoundModule = require(ServerModules:WaitForChild("SoundModule"))
local WeldModule = require(SharedModules:WaitForChild("WeldModule"))
local NumberUtil = require(SharedModules:WaitForChild("NumberUtil"))
local EventModule = require(ServerModules:WaitForChild("EventModule"))
local FallenGuard = require(ServerModules:WaitForChild("FallenGuard"))

-- Bindables
local CreateFire = FireService:WaitForChild("Create")
local LoadingScreenRemote = Replicated:WaitForChild("LoadingScreen")

-- Raycast Filter Functions
local blacklistParts = FallenGuard:GetPartBlacklist()
local viewFunc = RaycastUtil:FilterFunction("View")
local viewFilterFunc = function(hit)
	local filter = viewFunc(hit)
	if filter then
		return filter
	end
	if hit and blacklistParts[hit.Name] then
		return hit
	end
end
local hitFilterFunc = RaycastUtil:FilterFunction("Hit")
local hitIgnoreFilterFunc = RaycastUtil:FilterFunction("HitIgnore")
local hitMeleeFilterFunc = RaycastUtil:FilterFunction("HitMelee")
local hitMeleeIgnoreFilterFunc = RaycastUtil:FilterFunction("HitMeleeIgnore")
local viewExtraFilterFunc = RaycastUtil:FilterFunction("ViewExtra")

-- Local Variables
local cachedFilterFuncs = {}

-- Functions
function HitFilterFunction(hit, bulletHit, otherFilter)
	local parent = hit.Parent
	if parent and bulletHit and bulletHit.Parent and not bulletHit:IsDescendantOf(parent) and parent:FindFirstChild("Humanoid") then
		return parent
	else
		return otherFilter(hit)
	end
end

function HandleInvalids(player, weaponName, msg, attackId)
	local user = shared.Users[player]
	if not user then return end
	local userStats = user.UserStats
	if type(weaponName) == "table" then
		userStats:Synchronize("AddWeaponHit", weaponName.WeaponName, weaponName.Range, "Invalid")
	elseif type(weaponName) == "string" then
		userStats:Synchronize("AddUsedWeapon", weaponName, true)
	end
	warn(player.Name.." > "..msg)
	--local t = tick()
	if attackId and attackId == user.LastInvalid then return end --t - (user.LastInvalid or 0) < 2 then return end
	LoadingScreenRemote:FireClient(player, "Invalid", msg)
	user.LastInvalid = attackId
end

function SusFire(user, diff, n, considerBan, wepName)
	--[[if considerBan then
		local player = user.Player
		local susTime = user.SuspiciousActionFireTime
		if susTime == true or (type(susTime) == "number" and os.clock() - susTime < 4) then
			user.SuspiciousActionFireAmount = (user.SuspiciousActionFireAmount or 0) + 1
			if user.SuspiciousActionFireAmount + 1 == 5 then
				user.SuspiciousActionFireTime = true
				task.wait(4)
				user.SuspiciousActionFireTime = nil
				return ModUtil:BanPlayer(player.Name, "008", nil, `{wepName} - {user.SuspiciousActionFireAmount}/{diff}`, `CAMERA AND {n == 1 and "MOUSE" or "CHARACTER"} ROT MISMATCH`)
			end
		else
			user.SuspiciousActionFireAmount = 0
			user.SuspiciousActionFireTime = os.clock()
		end
		print(user.SuspiciousActionFireAmount, n)
	end]]
	return "GUN ACTION FUNCTION STOPPED: CLIENT AND SERVER ROTATION NOT IN SYNC #"..n
end

-- Remotes
local AllRemotes = {
	Action = string.char(32, 160, 72, 124, 151, 12, 176, 39, 65, 28, 122, 173, 98, 61, 159, 172, 72, 11, 80, 134, 29, 124, 104, 3, 156, 125, 40, 19, 24, 15);
	Hit = string.char(63, 185, 85, 143, 181, 42, 176, 169, 42, 28, 185, 69, 146, 23, 65, 25, 81, 156, 122, 115, 80, 75, 175, 156, 99, 9, 117, 72, 112, 120);
	Visualize = string.char(103, 133, 9, 154, 39, 163, 146, 21, 57, 183, 145, 92, 150, 21, 92, 2, 189, 66, 182, 45, 146, 49, 108, 138, 183, 131, 181, 117, 142, 7);
	Reload = string.char(186, 109, 92, 123, 140, 17, 30, 91, 154, 28, 34, 188, 60, 12, 9, 142, 12, 118, 93, 172, 189, 60, 48, 164, 188, 42, 87, 78, 91, 86);
	Attachment = string.char(160, 112, 112, 77, 66, 135, 177, 30, 88, 142, 97, 54, 121, 9, 110, 101, 123, 105, 97, 67, 43, 48, 25, 78, 36, 137, 126, 90, 16, 132);
}
ModUtil:SetupRemotes(CombatRemotes, {
	[AllRemotes.Action] = {
		Cooldown = 0.04;
		AllowedCallsBeforeThrottle = 8;
		IgnoreDecryption = true;
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local firedTick = args[1]
			local wepName = args[2]
			local serverTick = workspace:GetServerTimeNow() --Values.ServerTick.Value
			--print("tick on server:", firedTick)
			if type(wepName) ~= "string" or ToolInfo[wepName] == nil or type(firedTick) ~= "number" then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			else
				local lastFiredTick = user.LastCombatFired
				if lastFiredTick and ((lastFiredTick % 1 == 0 and firedTick % 1 == 0) or (lastFiredTick == firedTick)) then
					return ModUtil:BanPlayer(player.Name, "008", nil, firedTick.."/"..lastFiredTick, "MALICIOUS FIRED TICKS")
				end
				if serverTick - firedTick > script:GetAttribute("ActionRemoteTimeout") or firedTick - 1 > serverTick then return end
				--return ModUtil:BanPlayer(player.Name, "008", nil, serverTick - firedTick)
			end
			local inventory = user.Inventory
			local toolbar = inventory:GetToolbar()
			local equipped = user.Equipped
			local bulletQueue = user.BulletQueue
			local character = player.Character
			local userStats = user.UserStats
			local wepUseRates = userStats:GetStats("WeaponUseRates")
			local lastAttacks = user.LastAttacks
			if not (equipped and equipped.Index and equipped.Index > 0) then return end
			local equippedModel = equipped.Model
			local item = toolbar[equipped.Index]
			if not (equippedModel and equippedModel.Parent and equippedModel.PrimaryPart and item and item ~= 0 and item.Amount > 0) then return end
			local itemInfo = Items[item.ID]
			if not (itemInfo and itemInfo.Name == wepName and (itemInfo.MaxDurability == nil or item.Durability > 0)) then return end
			userStats:Synchronize("AddUsedWeapon", wepName)
			local isThrow = false
			local durDecreaseMult = ServerService:GetAttribute("DurabilityDecreaseMult")
			local projectileInvalid, projectileId = (function()
				local humanoid = user.Humanoid
				if not (humanoid and humanoid.Health > 0 and not humanoid:GetAttribute("Downed")) then return "WEAPON ACTION FUNCTION STOPPED: PLAYER DEAD/DOWNED" end
				local character = humanoid.Parent
				if not character then return "WEAPON ACTION FUNCTION STOPPED: VALID CHARACTER NOT FOUND" end
				local primPart = character.PrimaryPart
				if not primPart then return "WEAPON ACTION FUNCTION STOPPED: HUMANOIDROOTPART NOT FOUND" end
				local combatArena = user:IsInCombatArena(true)
				local toolInfo = ToolInfo[itemInfo.Name]
				local weaponInfo = toolInfo.Weapon
				local meleeInfo = toolInfo.Melee
				local itemType = itemInfo.Type
				local objectDamages = toolInfo.ObjectDamages
				local attachmentStats = item:AttachmentStats()
				local showSanityCheckRays = (script:GetAttribute("DebugShowSanityCheckRays") and "GreenRay")
				local showProjectileRays = (script:GetAttribute("DebugShowProjectileRays") and "BlueRay")
				if user:CheckLastMovementDetection(character, humanoid, primPart) == "Noclip" then return "WEAPON ACTION FUNCTION STOPPED: ATTACK WAS INITIALIZED SHORTLY AFTER SNAPBACK" end
				if itemType == "Gun" then
					local firedCF = args[3]
					local firedFlashPos = args[4]
					local firedCharCF = args[5]
					local baseSpread = args[6]
					local shootingSpread = args[7] -- :3
					local mousePos = args[8]
					if args[9] or #args >= 9 or typeof(firedCF) ~= "CFrame" or typeof(firedFlashPos) ~= "Vector3" or typeof(firedCharCF) ~= "CFrame" or type(baseSpread) ~= "number" or baseSpread < -0.01 or type(shootingSpread) ~= "number" or shootingSpread < -0.01 or typeof(mousePos) ~= "Vector3" or mousePos == Vector3.new() then
						--print(args)
						return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
					end
					local ammo = item.Ammo
					if not (ammo and ammo.Amount > 0) then return "GUN ACTION STOPPED: SERVER AMMO <= 0" end
					local bulletInfo = toolInfo.Bullet
					local ammoInfo = Items[ammo.ID]
					local ammoStats = ammoInfo.AmmoStats
					local ammoImpact = ammoStats.Impact
					local rawFireRate = 60 / math.max(weaponInfo.RPM, weaponInfo.BurstRPM) 
					local fireRate = rawFireRate * (1 - (attachmentStats.FireRateMult or 0))
					local leeWay = math.min(script:GetAttribute("AttackCooldownMaxLeeway"), fireRate * script:GetAttribute("AttackCooldownLeewayMult"))
					local serverFireRate = fireRate - leeWay
					ammo.Amount -= 1
					item.Durability = math.max(item.Durability - (ammoStats.WeaponDurability or 1) * durDecreaseMult, 0)
					for _, attachment in pairs(item.Attachments or {}) do
						local attachmentInfo = Items[attachment.ID]
						if not (attachmentInfo.MaxDurability and attachment.Durability > 0) then continue end
						attachment.Durability = math.max(attachment.Durability - (ammoStats.MuzzleDurability or 1) * durDecreaseMult, 0)
						if attachment.Durability <= 0 then
							attachment.On = nil
						end
					end
					inventory:UpdateClient({"Toolbar", equipped.Index, toolbar[equipped.Index]})
					local _, _, sightFlashPart = WeldModule:WeldAttachments(equippedModel, item)
					if lastAttacks then
						local lastAttackInfo = lastAttacks[wepName]
						if lastAttackInfo then
							local lastAttack = serverTick - lastAttackInfo[1]
							--print(wepName, lastAttack, serverFireRate)
							if wepUseRates then
								local wepUseRate = wepUseRates[wepName]
								if not wepUseRate then
									wepUseRate = {0, 0}
									wepUseRates[wepName] = wepUseRate
								end
								wepUseRate[1] += math.min(lastAttack, fireRate)
								wepUseRate[2] += 1
								if wepUseRate[2] % 100 == 0 then
									local useRate = wepUseRate[1] / wepUseRate[2]
									local useRateRatio = useRate / rawFireRate
									print(useRateRatio)
									if useRateRatio <= script:GetAttribute("AttackCooldownRateForBan") then
										ModUtil:BanPlayer(player.Name, "008", nil, `{wepName} - {NumberUtil:RoundNumber(useRate)}/{NumberUtil:RoundNumber(rawFireRate)} ({wepUseRate[2]})`, "MALICIOUS FIRERATE")
										return 
									end
								end
							end
							if lastAttack < serverFireRate then
								local fastFireCount = lastAttackInfo[2] + 1
								lastAttackInfo[1] = serverTick
								lastAttackInfo[2] = fastFireCount
								print(player, "ATTACK TOO FAST", wepName, serverFireRate - lastAttack, lastAttackInfo[2])
								if fastFireCount >= script:GetAttribute("AttackCooldownLeewayCount") then
									return "GUN ACTION FUNCTION STOPPED: NOT ENOUGH TIME ELAPSED SINCE LAST ATTACK"
								end
							else
								lastAttackInfo[1] = serverTick
								lastAttackInfo[2] = 0
							end
						else
							lastAttacks[wepName] = {serverTick, 0}
						end
					end
					local primPos = primPart.Position + Vector3.new(0, 1.5, 0)
					local isWithin, squaredDist = NumberUtil:IsWithin(firedCharCF.Position, primPos, script:GetAttribute("MaxClientToServerDistanceThreshold"))
					if not isWithin then return "GUN ACTION FUNCTION STOPPED: CLIENT PLAYER POSITION TOO FAR FROM CURRENT SERVER POSITION ("..math.sqrt(squaredDist)..")" end
					local firedVector = firedCF.LookVector
					local camToMouseRotDiff = firedVector:Dot(CFrame.new(firedCF.Position, mousePos).LookVector)
					if camToMouseRotDiff <= 0.99 then
						return SusFire(user, camToMouseRotDiff, 1, camToMouseRotDiff <= 0.97, wepName) 
					end
					local charVector = firedCharCF.LookVector
					local firedCF2d = CFrame.new(firedCF.Position, firedCF.Position + Vector3.new(firedVector.X, 0, firedVector.Z))
					local charCF2d = CFrame.new(firedCharCF.Position, firedCharCF.Position + Vector3.new(charVector.X, 0, charVector.Z))
					local camToCharRotDiff = firedCF2d.LookVector:Dot(charCF2d.LookVector)
					if camToCharRotDiff <= 0.97 then
						return SusFire(user, camToCharRotDiff, 2, camToCharRotDiff <= 0.91, wepName) 
					end
					local hit = RaycastUtil:Raycast(primPos, firedCharCF.Position - primPos, "Blacklist", {VFX_PARTS, character, Drops, Plants, Animals}, showSanityCheckRays, viewFilterFunc, true)
					if hit then return "GUN ACTION FUNCTION STOPPED: CLIENT AND SERVER CHARACTER VIEW IS OBSTRUCTED (OBJECT HIT: "..hit:GetFullName()..")" end
					local checkFlashPos = (firedCharCF * CFrame.new(firedFlashPos)).Position
					--local checkCharPos = (primPart.CFrame * CFrame.new(firedFlashPos)).p
					--local clientServerFlashPosDiff = checkFlashPos - firedCharCF.Position
					--print(clientServerFlashPosDiff.Magnitude)
					isWithin, squaredDist = NumberUtil:IsWithin(checkFlashPos, firedCharCF.Position, script:GetAttribute("MaxCharToFlashPartDistanceThreshold"))
					if not isWithin then return "GUN ACTION FUNCTION STOPPED: PLAYER POSITION TOO FAR FROM FLASHPART ("..math.sqrt(squaredDist)..")" end
					local camFlashOffset = firedCF:ToObjectSpace(CFrame.new(checkFlashPos))
					if camFlashOffset.Position.Z >= 0 then return "GUN ACTION FUNCTION STOPPED: LOCAL FLASHPART NOT IN VIEW OF CAMERA" end
					--local flashPartHit = RaycastUtil:Raycast(primPos, clientServerFlashPosDiff, "Blacklist", {VFX_PARTS, character, Drops, Plants}, showSanityCheckRays, viewFilterFunc, true)
					local headHit = RaycastUtil:Raycast(primPart.Position, Vector3.new(0, 1.6, 0), "Exclude", {VFX_PARTS, character, Drops, Plants, Animals}, showSanityCheckRays, viewFilterFunc, true)
					if headHit then return "GUN ACTION FUNCTION STOPPED: HEAD VIEW IS OBSTRUCTED (OBJECT HIT: "..headHit:GetFullName()..")" end
					local totalSpread = baseSpread + shootingSpread
					local bullets = {}
					local randomSeed = math.floor(firedTick * 10000)
					--print("server randomseed:", randomSeed, "server totalspread:", totalSpread)
					local random = Random.new(randomSeed)
					for _ = 1, (ammoStats.Bullets or 1) do
						local t = {
							Radius = random:NextNumber(0, math.floor(totalSpread * 100) / 100) / 500;
							Degree = random:NextNumber(0, 2 * math.pi);
							ID = random:NextInteger(1, math.ceil(1e9 * math.max(1, math.floor(totalSpread * 100) / 100)));
						}
						table.insert(bullets, t)
					end
					for _, bullet in pairs(bullets) do
						for _, t in pairs(bulletQueue) do
							if t.ID ~= bullet.ID then continue end
							return "GUN ACTION FUNCTION STOPPED: ATTACK ID ALREADY PRESENT IN SERVER.", t.ID
						end
						local extraOffset = CFrame.Angles((bulletInfo.Offset or 0), 0, 0)
						bullet.Spread = extraOffset * CFrame.Angles(math.sin(bullet.Degree) * bullet.Radius, math.cos(bullet.Degree) * bullet.Radius, 0)
					end
					local bulletSpeed = (bulletInfo.Speed * (1 + (attachmentStats.SpeedMult or 0))) * (ammoStats.SpeedMult or 1)
					local bulletGrav = bulletInfo.Gravity * (ammoStats.GravityMult or 1)
					local bulletRange = (bulletInfo.MaxRange * (1 + (attachmentStats.RangeMult or 0))) * (ammoStats.RangeMult or 1)
					local bulletStepType = (ammoStats.StepType or "FakeStepFunc")
					local bulletFilterType = (ammoStats.FilterType or "Hit")
					for _, bullet in pairs(bullets) do
						--print("created bullet with ID", bullet.ID)
						local t = {
							ID = bullet.ID;
							Type = "Bullet";
							Spread = bullet.Spread;
							Direction = firedCF;
							CharPos = firedCharCF.Position;
							FlashPos = checkFlashPos;
							Speed = bulletSpeed;
							Gravity = bulletGrav;
							Range = bulletRange;
							WeaponName = wepName;
							HitInfo = nil;
						}
						table.insert(bulletQueue, t)
						bullet.Table = t
						bullet.Path = {t.CharPos}
					end
					local allParams = {}
					local flashPart = (sightFlashPart or equippedModel:FindFirstChild("FlashPart"))
					local bulletTracer = (attachmentStats.HideTracer and "" or ((item.Skin == "Frosty" or item.Skin == "Cherry Blossom" or item.Skin == "Vaporwave" or item.Skin == "VIP" or item.Skin == "Gingerbread" or item.Skin == "Diablo" or equipped.Skin == "Valentine" or equipped.Skin == "High Tide" or equipped.Skin == "Blue Gem" or equipped.Skin == "Monster" or equipped.Skin == "Crimson Glitched") and item.Skin.."Bullet" or ammoStats.TracerName))
					for _, bullet in pairs(bullets) do
						local firedDir = bullet.Table.Direction
						local tspread = bullet.Table.Spread
						local charPos = bullet.Table.CharPos
						local flashPos = bullet.Table.FlashPos
						local params = {
							--[[Position = flashPart.Position;
							Direction = (firedCF * bullet.Spread).LookVector;
							PositionFirst = primPart.Position + Vector3.new(0, 1.5, 0);]]

							Position = flashPos;
							Direction = (CFrame.new(flashPos, mousePos) * tspread).LookVector;
							PositionFirst = charPos;
							DirectionFirst = (firedDir * tspread).LookVector;
							FilterType = "Blacklist";
							Filters = {character, VFX_PARTS, Drops, Plants};
							FilterFunction = bulletFilterType;
							Speed = bulletSpeed;
							Gravity = bulletGrav;
							MaxRange = bulletRange;
							TracerName = bulletTracer;
							HitFunction = ((ammoImpact == nil or ammoImpact == "Stick") and "FakeHitFunc");
							StepFunction = bulletStepType;
						}
						-- (position - firedPos) * 1.01
						local filterFunc = cachedFilterFuncs[bulletFilterType]
						if not filterFunc then
							filterFunc = RaycastUtil:FilterFunction(bulletFilterType)
							cachedFilterFuncs[bulletFilterType] = filterFunc
							print("created filter func", bulletFilterType)
						end
						local proj = {
							Position = flashPos;
							Direction = (CFrame.new(flashPos, mousePos) * tspread).LookVector;
							PositionFirst = charPos;
							DirectionFirst = (firedDir * tspread).LookVector;
							FilterType = "Blacklist";
							Filters = {VFX_PARTS, character, Drops, Plants};
							FilterFunction = function(h)
								if bullet.Table and bullet.Table.HitInfo then
									local huma = bullet.Table.HitInfo.Humanoid
									if huma then
										local hum = h.Parent:FindFirstChild("Humanoid")
										if hum and hum ~= huma then
											print("HIT ANOTHER HUMANOID, IGNORING", huma.Parent, hum.Parent)
											return h.Parent
										end
									end
								end
								return filterFunc(h)
							end;
							VisualizeRay = showProjectileRays;
							Speed = bulletSpeed;
							Gravity = bulletGrav;
							MaxRange = bulletRange;
							HitFunction = function(...)
								if (not bullet) or bullet.Completed or bullet.ServerHit then return end
								bullet.ServerHit = {...}
							end;
							MissFunction = function()
								if (not bullet) or bullet.Completed or bullet.ServerHit then return end
								bullet.ServerHit = {}
							end;
							StepFunction = function(origin, position)
								table.insert(bullet.Path, position)
								if bullet.HitInfo or bullet.Completed then
									return true
								end
							end;
						}
						bullet.Table.ProjectileSettings = proj
						VFXModule:CreateProjectile(proj)
						table.insert(allParams, params)
					end
					local shootSound = primPart:FindFirstChild(itemInfo.Name.."Shoot")
					--print(shootSound)
					if shootSound then
						SoundModule:ReplicateSoundToClients(shootSound, "PlayDuplicate", {player}) -- Passing player as a table to signal combat arena only sounds
					end
					for _, plr in pairs(Players:GetPlayers()) do
						if plr == player then continue end
						ModUtil:FireClient(VFXRemotes, AllRemotes.Visualize, plr, "FlashPart", flashPart)
						ModUtil:FireClient(VFXRemotes, AllRemotes.Visualize, plr, "CreateProjectile", allParams)
					end
					local started = tick()
					local maxTime = script:GetAttribute("BulletLeewayToHit") + bulletSpeed / bulletRange
					while #bullets > 0 and player.Parent do
						local timeOut = (tick() - started >= maxTime)
						for index = #bullets, 1, -1 do
							local bullet = bullets[index]
							local t = bullet.Table
							local id = t.ID
							local hitInfo = t.HitInfo
							if not (hitInfo or timeOut) then continue end
							for i, v in pairs(bulletQueue) do
								if v ~= t and not timeOut then continue end
								table.remove(bulletQueue, i)
								break
							end
							table.remove(bullets, index)
							task.spawn(function()
								if timeOut then
									bullet.Completed = true
									HandleInvalids(player, wepName, "BULLET HIT DETECTION FAILED - SERVER BULLET HAS NO VALID PATH", t.ID) 
									return 
								end
								local bulletServer = bullet.ServerHit
								local startServer = tick()
								while not bulletServer do
									if tick() - startServer >= 3 then HandleInvalids(player, wepName, "BULLET HIT DETECTION FAILED - SERVER BULLET FAILED TO FINALIZE", t.ID) return end
									bulletServer = bullet.ServerHit
									task.wait()
								end
								local bulletHit = hitInfo.Hit
								local bulletPos = hitInfo.Position
								local bulletNor = hitInfo.Normal
								if not bulletHit then return end
								local path = bullet.Path
								if not bulletHit.Parent then HandleInvalids(player, wepName, "BULLET HIT DETECTION FAILED - HIT HAS NO VALID PARENT", t.ID) return end
								local doHit = (bulletServer ~= nil and bulletServer[1] and bulletHit)
								if doHit then
									local object = bulletHit.Parent
									local currentHealth = object:GetAttribute("Health")
									local humanoid = hitInfo.Humanoid
									if not (currentHealth or humanoid) then
										--print("ye")
										object = object.Parent
										currentHealth = object:GetAttribute("Health")
										humanoid = object:FindFirstChild("Humanoid")
									end
									if not (currentHealth or humanoid) then
										--print("hit non humanoid")
										doHit = true -- Ignore checks as we didn't hit a humanoid or a destroyable
									else
										--print("hit hum", humanoid, currentHealth)
										doHit = bulletServer[1]:IsDescendantOf(bulletHit.Parent) -- Ignore checks if server bullet hit object properly
									end
								end
								local position = (bulletHit.CFrame * CFrame.new(bulletPos)).Position
								local distance = (checkFlashPos - position).Magnitude
								local invalidTable = {
									WeaponName = wepName;
									Range = distance;
									--Hit = bulletHit;
								}
								if #path < 2 and not doHit then HandleInvalids(player, invalidTable, "BULLET HIT DETECTION FAILED - SERVER BULLET HAS NO VALID PATH", t.ID) return end
								if not doHit then
									local pathFirst = path[1]
									local pathLast = path[#path]
									local _, alphaLength, maxLength = RaycastUtil:GetClosestPointFromRay(pathFirst, pathLast, position)
									local clampedAlpha = math.clamp(alphaLength, 0, maxLength) / maxLength
									local medianIndex = math.clamp(#path * clampedAlpha + 0.5, 1, #path)
									local indexPercent = script:GetAttribute("BulletPathCheckPercent") / 200 * #path
									local startIndex = math.clamp(math.floor(medianIndex - indexPercent), 1, #path)
									local endIndex = math.clamp(math.ceil(medianIndex + indexPercent) + (startIndex == 1 and 1 or 0), 1, #path)
									local minThreshold = script:GetAttribute("BulletTrajectoryDistanceThreshold")
									local threshold = math.clamp(totalSpread / script:GetAttribute("BulletTrajectorySpreadDivider") * minThreshold, minThreshold, script:GetAttribute("BulletTrajectoryMaxThreshold"))
									--print(bulletHit, path, #path, clampedAlpha, startIndex, endIndex, medianIndex, indexPercent, totalSpread, threshold)
									local hasView = false
									local closest = math.huge
									local closestPoints = {}
									--showSanityCheckRays = "GreenRay"
									local ignores = {VFX_PARTS, character, Drops, Plants, Animals, bulletHit}
									for index = startIndex, endIndex do
										if index == 1 then continue end
										local startPoint = path[index - 1]
										local endPoint = path[index]
										local closestPos = RaycastUtil:GetClosestPointFromRay(startPoint, endPoint, position)
										local isWithin, distSquared = NumberUtil:IsWithin(closestPos, position, threshold)
										if isWithin then
											local rayDir = CFrame.new(startPoint, endPoint).LookVector
											local checkStartPos = closestPos
											for i = -3, 1, 2 do
												local checkPos = (i == -3 and checkStartPos)
												if not checkPos then
													local unobStartPos = (CFrame.new(checkStartPos, position) * CFrame.new(0, 0, 0.2)).Position
													local _, unobstructedPos = RaycastUtil:Raycast(unobStartPos, rayDir * 4 * i, "Blacklist", ignores, showSanityCheckRays, viewExtraFilterFunc, true)
													checkPos = unobstructedPos
												end
												checkPos = (CFrame.new(checkPos, position) * CFrame.new(0, 0, 0.2)).Position
												table.insert(closestPoints, checkPos)
												local rayHit = RaycastUtil:Raycast(checkPos, position - checkPos, "Blacklist", ignores, showSanityCheckRays, viewExtraFilterFunc, true)
												if not rayHit then
													hasView = true
													break
												end
											end
											if hasView then break end
										end
										local dist = math.sqrt(distSquared)
										closest = math.min(closest, dist)
									end
									if showSanityCheckRays then
										for _, v in pairs(closestPoints) do
											local debugPart = Instance.new("Part")
											debugPart.Name = "BulletExtremity"
											debugPart.Transparency = 0.5
											debugPart.Material = "Neon"
											debugPart.CanCollide = false
											debugPart.Anchored = true
											debugPart.Size = Vector3.new(0.25, 0.25, 0.25)
											debugPart.BrickColor = BrickColor.new("Bright red")
											debugPart.CFrame = CFrame.new(v)
											debugPart.Parent = VFX_PARTS
											Debris:AddItem(debugPart, 10)
										end
									end
									--print(#closestPoints)
									if not hasView then
										HandleInvalids(player, invalidTable, `BULLET HIT DETECTION FAILED - CLOSEST: {closest} PATH LENGTHS: {startIndex}/{endIndex}/{#path} CLIENT HIT: {bulletHit} SERVER HIT: {bulletServer[1]}`, t.ID)
										return
									end
								end
								local hitCFrame = CFrame.new(position, position + bulletNor)
								local isPierce = (ammoImpact == "Pierce")
								local isFireArrow = (ammoImpact == "FireArrow")
								if ammoImpact == "ExplosiveBullet" or isPierce or isFireArrow then
									local impactStorage = VFX_STORAGE[(isPierce or isFireArrow) and "ImpactPiercingBullet" or "ImpactExplosiveBullet"]
									local impact = impactStorage:Clone()
									impact.CFrame = hitCFrame
									impact.Anchored = bulletHit.Anchored
									impact.Parent = VFX_PARTS
									if not bulletHit.Anchored then
										local impactWeld = WeldModule:WeldParts(impact, bulletHit)
									end
									local color
									for _, effect in pairs(impact:GetChildren()) do
										if effect:IsA("Sound") then
											effect.PlaybackSpeed += math.random(-50, 50) / 1000
											--[[local backup = Instance.new("ObjectValue")
											backup.Name = "Backup"
											backup.Value = impactStorage[effect.Name]
											backup.Parent = effect
											SoundModule:ReplicateSoundToClients(effect, "PlayDuplicate")]]
											effect:Play()
										else
											effect.Enabled = true
										end
									end
									task.delay(0.1, function()
										for i = 1, 2 do
											if not (impact and impact.Parent) then return end
											if i == 2 then 
												impact:Destroy() 
												return 
											end
											for _, effect in pairs(impact:GetChildren()) do
												if effect:IsA("Sound") then continue end
												effect.Enabled = false
											end
											task.wait(4)
										end
									end)
									if isFireArrow then
										CreateFire:Fire(1, 1.5, 0.1, 2.25, 10, 6, 8, 1, true, function()
											return hitCFrame * CFrame.Angles(0, 0, math.rad(math.random(1, 360))) * CFrame.Angles(math.rad(math.random(1, 30)), 0, 0)
										end, "Combustive Arrow", player)
									elseif (isPierce and math.random(1, 3) == 1 and not bulletHit.Parent:FindFirstChild("Humanoid")) or (ammoImpact == "ExplosiveBullet" and math.random(1, 10) == 1) then
										CreateFire:Fire(1, 2, 0.1, 2, 20, 9, 11, 1, true, function()
											return hitCFrame * CFrame.Angles(0, 0, math.rad(math.random(1, 360))) * CFrame.Angles(math.rad(math.random(1, 30)), 0, 0)
										end, "Bullet", player)
									end
								elseif ammoImpact == "Explosion" or ammoImpact == "Fire" then
									local exploInfo = ammoStats.Explosive
									ModUtil:FireAllClients(VFXRemotes, AllRemotes.Visualize, "CreateExplosion", hitCFrame, exploInfo.ShakeStrength, exploInfo.Duration, exploInfo.SoundName)
									if ammoImpact == "Fire" then
										CreateFire:Fire(40, 5, 0.36, 3, 60, 21, 29, 3, true, function()
											return hitCFrame * CFrame.Angles(0, 0, math.rad(math.random(1, 360))) * CFrame.Angles(math.rad(math.random(8, 60)), 0, 0)
										end, "Combustive Rocket", player)
									end
								elseif ammoImpact == "Stick" and math.random(1, 100) > (ammoStats.ShatterChance or 0) then
									local itemModel = InventoryService.DropItem:Invoke(hitCFrame * CFrame.new(0, 0, -0.2), ItemClass.new(ammo.ID, 1), 1, nil, true, VFX_STORAGE[ammoStats.TracerName])
									if combatArena then
										table.insert(combatArena.Drops, itemModel)
									end
									itemModel:SetAttribute("IsThrow", true)
									local primPart = itemModel.PrimaryPart
									local dontWeld = bulletHit.Anchored
									primPart.Anchored = dontWeld
									local weldPart = ((bulletHit.Name ~= "LowerTorso" and not (bulletHit.Name:find("Leg") or bulletHit.Name:find("Foot")) and bulletHit.Parent:FindFirstChild("Humanoid")) and bulletHit.Parent.PrimaryPart or bulletHit)
									if not dontWeld then
										WeldModule:WeldParts(primPart, weldPart)
									end
									local hitCons = {}
									table.insert(hitCons, weldPart.AncestryChanged:Connect(function()
										if weldPart and weldPart.Parent then return end
										for _, part in pairs(itemModel:GetChildren()) do
											if not part:IsA("BasePart") then continue end
											part.Anchored = false
											part.CanCollide = true
										end
										itemModel:SetAttribute("IsThrow", false)
									end))
									table.insert(hitCons, itemModel.Destroying:Connect(function()
										for _, con in pairs(hitCons) do
											con:Disconnect()
										end
									end))
								end
								local _, hitLimb = DamageModule:Damage(bulletHit, bulletPos, bulletNor, t.Direction, bulletInfo.HumanoidDamages, bulletInfo.Dropoff, ammoStats, item, player, bulletInfo.SoftSideMult, "Bullet")
								if hitLimb then
									userStats:Synchronize("AddWeaponHit", wepName, distance, hitLimb)
								end
							end)
						end
						if timeOut then print(#bullets.." BULLET(S) NULLIFIED - TIMEOUT REACHED ("..maxTime.." SECONDS)") end
						task.wait()
					end
				elseif itemType == "Tool" and weaponInfo then
					local firedCF = args[3]
					local throwExtra = args[4]
					local throwPlacedOn = args[5]
					if args[6] or #args >= 6 or (firedCF and typeof(firedCF) ~= "CFrame") or (throwExtra and throwExtra ~= 0 and typeof(throwExtra) ~= "Vector3") or (throwPlacedOn and type(throwPlacedOn) ~= "string" and typeof(throwPlacedOn) ~= "Instance") then
						return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
					end
					isThrow = (firedCF ~= nil)
					local cooldown = weaponInfo.Cooldown * (1 - (attachmentStats.FireRateMult or 0))
					local leeWay = math.min(script:GetAttribute("AttackCooldownMaxLeeway"), cooldown * script:GetAttribute("AttackCooldownLeewayMult"))
					local serverCooldown = cooldown - leeWay
					--[[local lastAttack = tick() - user.LastAttack
					if user.LastAttackWeapon == wepName and lastAttack < serverCooldown then
						user.LastElapsedCount = (user.LastElapsedCount or 0) + 1
						if user.LastElapsedCount >= 2 then
							return "TOOL ACTION FUNCTION STOPPED: NOT ENOUGH TIME ELAPSED SINCE LAST USE ("..serverCooldown - lastAttack..")" 
						end
					else
						user.LastElapsedCount = 0
					end]]
					local durabilities = (meleeInfo and meleeInfo.Durabilities)
					if firedCF then
						local primPos = primPart.Position
						local isWithin, squaredDist = NumberUtil:IsWithin(firedCF.Position, primPos, script:GetAttribute("MaxClientToServerDistanceThreshold"))
						if not isWithin then return "THROW FUNCTION STOPPED: CLIENT PLAYER POSITION TOO FAR FROM CURRENT SERVER POSITION ("..math.sqrt(squaredDist)..")" end
						local hit = RaycastUtil:Raycast(primPos, firedCF.Position - primPos, "Blacklist", {VFX_PARTS, character, Drops, Plants, Animals}, showSanityCheckRays, viewFilterFunc, true)
						if hit then return "THROW FUNCTION STOPPED: CLIENT AND SERVER CHARACTER VIEW IS OBSTRUCTED (OBJECT HIT: "..hit:GetFullName()..")" end
						local throwInfo = weaponInfo.ThrowInfo
						if not throwInfo then return end
						local throwLogic = throwInfo.Logic
						local placedCFrame, placeNormal
						if throwLogic == "PlaceableGrenade" and typeof(throwExtra) == "Vector3" then
							if not (typeof(throwPlacedOn) == "Instance" and throwPlacedOn.Parent) then return end
							local placeCF = throwPlacedOn.CFrame * CFrame.new(throwExtra)
							local placePos = placeCF.Position
							local placeHit, _, nor = RaycastUtil:Raycast(primPos, (placePos - primPos).Unit * 5, "Blacklist", {VFX_PARTS, character, Drops, Plants, Animals}, showSanityCheckRays, viewFilterFunc, true)
							if placeHit == nil or (placeHit ~= throwPlacedOn and not placeHit:IsDescendantOf(throwPlacedOn.Parent)) then return "GRENADE PLACE STOPPED: PLACE LOCATION DOESN'T MATCH CLIENT (SERVER: "..(placeHit and placeHit:GetFullName() or "nil")..") (CLIENT: "..(throwPlacedOn and throwPlacedOn.Name or "nil")..")" end
							placeNormal = nor
							placedCFrame = CFrame.new(placePos, placePos + placeNormal) * throwInfo.LandOffset
						end
						if durabilities then
							item.Durability = math.max(item.Durability - (durabilities.Throw or 1) * durDecreaseMult, 0)
						end
						item.Amount -= 1
						if item.Amount <= 0 then
							toolbar[equipped.Index] = 0
						end
						inventory:UpdateClient((throwLogic ~= "Normal" and "IgnoreEquipUpdate"), {"Toolbar", equipped.Index, toolbar[equipped.Index]})
						if throwLogic ~= "Normal" then
							isThrow = false
							local itemModel = ModUtil:SafeClone(ItemModels[wepName][item.Skin or "Default"])
							if itemModel then
								userStats:Synchronize("AddUsedWeapon", wepName)
								local itemId = item.ID
								local itemPrim = (itemModel:FindFirstChild("Dynamite") or itemModel:FindFirstChild("Main") or itemModel:FindFirstChild("Handle"))
								for _, part in pairs(itemModel:GetChildren()) do
									if not part:IsA("BasePart") then continue end
									part.CanCollide = false
									part.Anchored = false
									part.Massless = (part ~= itemPrim)
									part.CollisionGroup = "Items"
								end
								itemModel.Name = wepName
								itemModel.PrimaryPart = itemPrim
								itemPrim.CanCollide = (throwLogic == "Grenade" or throwLogic == "PlaceableGrenade")
								if itemPrim.CanCollide then
									itemPrim.CustomPhysicalProperties = PhysicalProperties.new(5, 2, 0, 100, 100)
								end
								local itemVal = Instance.new("StringValue")
								itemVal.Name = "Item"
								local oldAmount = item.Amount
								item.Amount = 1
								itemVal.Value = Http:JSONEncode(item)
								item.Amount = oldAmount
								itemVal.Parent = itemModel
								itemModel.Parent = VFX_PARTS
								itemPrim:SetNetworkOwner(player)
								itemModel:SetPrimaryPartCFrame(placedCFrame or firedCF * throwInfo.ThrowCFrameOffset)
								local throwSound = GlobalSounds.Throw:Clone()
								throwSound.Parent = itemPrim
								throwSound.PlaybackSpeed += math.random(-50, 50) / 1000
								throwSound:Play()
								local antiGrav = Instance.new("BodyForce")
								antiGrav.Name = "AntiGravity"
								antiGrav.Parent = itemPrim 
								antiGrav.Force = Vector3.new(0, itemPrim:GetMass() * workspace.Gravity * (1 - throwInfo.GravityMult), 0)
								local lastNormal = Vector3.new(0, 1, 0)
								local stuckOn
								local HitFunc = function(hit, normal, pos)
									itemPrim.AssemblyLinearVelocity = Vector3.new()
									local dontWeld = hit.Anchored
									itemPrim.Anchored = dontWeld
									if pos then
										itemModel:SetPrimaryPartCFrame(CFrame.new(pos, pos + normal) * throwInfo.LandOffset)
									end
									local weld
									if not dontWeld then
										weld = WeldModule:WeldParts(itemPrim, hit)
									end
									local hitCons = {}
									table.insert(hitCons, hit.AncestryChanged:Connect(function()
										if hit and hit.Parent then return end
										if weld then
											weld:Destroy()
										end
										itemPrim.Anchored = false
										stuckOn = nil
									end))
									table.insert(hitCons, itemModel.Destroying:Connect(function()
										for _, con in pairs(hitCons) do
											con:Disconnect()
										end
									end))
									stuckOn = hit
									lastNormal = normal
								end
								if placedCFrame then
									HitFunc(throwPlacedOn, placeNormal)
								else
									itemPrim.AssemblyLinearVelocity = firedCF.LookVector * throwInfo.Velocity / (throwExtra == 0 and 5 or 1)
								end
								local hitWater = false
								local lastCF = itemPrim.CFrame
								local connection
								local started = tick()
								connection = Run.Heartbeat:Connect(function(step)
									if tick() - started > 600 or not (itemPrim and itemPrim.Parent) then
										if itemModel and itemModel.Parent then
											itemModel:Destroy()
										end
										connection:Disconnect()
										return
									end
									if stuckOn and stuckOn.Parent then return end
									local curCF = itemPrim.CFrame -- :3
									local posDiff = (curCF.Position - lastCF.Position)
									local hit, pos, normal, material = RaycastUtil:Raycast(lastCF.Position, posDiff, "Blacklist", {VFX_PARTS, character, Drops, Plants}, showProjectileRays, viewFilterFunc, (wepName == "Timed Charge"))
									if hit and material == Enum.Material.Water then
										hit = nil
										if not hitWater then
											--print("hit water")
											hitWater = true
											local effectPart = itemPrim:FindFirstChild("Effect")
											if effectPart then
												for _, effect in pairs(effectPart:GetChildren()) do
													effect.Enabled = false
												end
											end
											for _, part in pairs(itemModel:GetChildren()) do
												if not part:IsA("BasePart") then continue end
												part.CanCollide = true
											end
											itemPrim.AssemblyLinearVelocity = itemPrim.AssemblyLinearVelocity * 0.1
											itemPrim.AssemblyAngularVelocity = Vector3.new()
											itemPrim.CustomPhysicalProperties = PhysicalProperties.new(80, 2, 0)
											connection:Disconnect()
											return
										end
									end
									if hit and throwLogic == "AlwaysStick" then
										HitFunc(hit, normal, pos)
									else
										lastCF = curCF
									end
								end)
								local fuseSound
								while true do
									local skip = false
									local affectedByWater = false
									if wepName == "Timed Charge" then
										for i = 1, 10 do
											task.wait(0.65)
											if not (itemModel and itemModel.Parent) then return end
											local children = itemPrim.ParticleHolder:GetChildren()
											for _, child in pairs(children) do
												if child:IsA("Sound") then
													child.PlaybackSpeed += (i == 10 and 0.15 or 0.05)
													child:Play()
													continue
												end
												child.Enabled = true
											end
											task.wait(0.35)
											if not (itemModel and itemModel.Parent) then return end
											for _, child in pairs(children) do
												if child:IsA("Sound") then continue end
												child.Enabled = false
											end
										end
									elseif wepName == "Care Package Signal" then
										for _ = 1, 5 do
											task.wait(1)
											if not (itemModel and itemModel.Parent) then return end
										end
										connection:Disconnect()
										for _, effect in pairs(itemPrim.Effect:GetChildren()) do
											effect.Enabled = true
										end
										local function disableCrate()
											if not itemPrim.Parent then return end
											for _, effect in pairs(itemPrim.Effect:GetChildren()) do
												effect.Enabled = false
											end
											itemPrim.Transparency = 1
											task.wait(6)
											if not itemPrim.Parent then return end
											ModUtil:SafeDestroy(itemModel)
										end
										EventModule:SpawnSupplyDrop(itemPrim.Position + Vector3.new(math.random(-25, 25), 0, math.random(-25, 25)), function()
											task.wait(150)
											disableCrate()
										end, function(droppedThread)
											if droppedThread then
												task.cancel(droppedThread)
											end
											disableCrate()
										end)
										break
									elseif wepName == "Military Grenade" then
										affectedByWater = true
										local fuseDuration = 3
										local passed = 0
										while passed < fuseDuration do
											passed += task.wait(1/30)
											if not (itemModel and itemModel.Parent) then return end
											if hitWater then break end
										end
										if affectedByWater and hitWater then
											if itemModel and itemModel.Parent then
												itemModel:SetAttribute("HasFuse", nil)
												itemModel.Parent = Drops
											end
											break
										end
										if skip then continue end
										if itemModel and itemModel.Parent then
											local cf = itemPrim.CFrame
											local exploInfo = throwInfo.Explosive
											local damagedHum = DamageModule:ExplosionDamage(cf.Position, lastNormal, objectDamages, exploInfo, player, {stuckOn}, itemId)
											if damagedHum then
												ModUtil:FireClient(CombatRemotes, AllRemotes.Hit, player, "HitMarker", "Hit")
											end
											if stuckOn and stuckOn.Parent then
												DamageModule:Damage(stuckOn, Vector3.new(), lastNormal, cf, objectDamages.Benches, {Start = 100000; End = 100000}, nil, nil, player, 1, "Explosive", true)
											end
											ModUtil:FireAllClients(VFXRemotes, AllRemotes.Visualize, "CreateExplosion", cf, exploInfo.ShakeStrength, exploInfo.Duration, exploInfo.SoundName)
											ModUtil:SafeDestroy(itemModel)
											break
										end
									else
										affectedByWater = true
										local fuseNum = math.random(1, 100)
										local fuseDuration = (fuseNum <= 25 and math.random(20, 30) or (fuseNum <= 50 and math.random(110, 140) or math.random(50, 80))) / 10
										local passed = 0
										if not fuseSound then
											fuseSound = GlobalSounds.Fuse:Clone()
											fuseSound.Parent = itemPrim
										end
										fuseSound:Play()
										for _, effect in pairs(itemPrim.Effect:GetChildren()) do
											effect.Enabled = true
										end
										while passed < fuseDuration do
											passed += task.wait(1/30)
											if not (itemModel and itemModel.Parent) then return end
											if hitWater then break end
											local r = math.clamp(passed / fuseDuration, 0, 1)
											local start = math.floor(r / 0.25)
											local attachStart = itemPrim[tostring(1 + start)]
											local attachEnd = itemPrim[tostring(1 + math.ceil(r / 0.25))]
											itemPrim.Effect.CFrame = attachStart.CFrame:Lerp(attachEnd.CFrame, (r - start * 0.25) / 0.25)
										end
										local dudNum = math.random(1, 100)
										if dudNum <= 50 and not hitWater then
											for _, effect in pairs(itemPrim.Effect:GetChildren()) do
												effect.Enabled = false
											end
											fuseSound:Stop()
											if dudNum <= 20 then
												task.wait(math.random(10, 60) / 10)
											else
												itemModel:SetAttribute("HasFuse", 0)
												itemModel.Parent = Drops
												while not hitWater do
													if not (itemModel and itemModel.Parent) then return end
													local hasFuse = itemModel:GetAttribute("HasFuse")
													if hasFuse and hasFuse == 1 then
														skip = true
														itemModel.Parent = VFX_PARTS
														itemModel:SetAttribute("HasFuse", nil)
														break 
													end
													task.wait(1/20)
												end
											end
										end
									end
									if affectedByWater and hitWater then
										if itemModel and itemModel.Parent then
											itemModel:SetAttribute("HasFuse", nil)
											itemModel.Parent = Drops
										end
										break
									end
									if skip then continue end
									if itemModel and itemModel.Parent then
										local cf = itemPrim.CFrame
										local exploInfo = throwInfo.Explosive
										local damagedHum = DamageModule:ExplosionDamage(cf.Position, lastNormal, objectDamages, exploInfo, player, {stuckOn}, itemId)
										if damagedHum then
											ModUtil:FireClient(CombatRemotes, AllRemotes.Hit, player, "HitMarker", "Hit")
										end
										if stuckOn and stuckOn.Parent then
											DamageModule:Damage(stuckOn, Vector3.new(), lastNormal, cf, objectDamages.Benches, {Start = 100000; End = 100000}, nil, nil, player, 1, "Explosive", true)
										end
										ModUtil:FireAllClients(VFXRemotes, AllRemotes.Visualize, "CreateExplosion", cf, exploInfo.ShakeStrength, exploInfo.Duration, exploInfo.SoundName)
										ModUtil:SafeDestroy(itemModel)
										break
									end
								end
							end
						else
							local itemModel = InventoryService.DropItem:Invoke(player, item, 1, nil, true)
							if itemModel then
								if combatArena then
									table.insert(combatArena.Drops, itemModel)
								end
								if itemModel.Name == "Salvaged Shovel" or itemModel.Name == "ez shovel" then -- NOTE: if this isn't here, when its thrown it doesn't show up for some reason
									itemModel.Handle:Destroy()
									itemModel.Detail.Name = "Handle"
									itemModel.PrimaryPart = itemModel.Handle
								elseif itemModel.Name == "Wooden Spear" or itemModel.Name == "Stone Spear" then
									itemModel.Handle:Destroy()
									itemModel["Wood Spear"]:Destroy()
									itemModel.NewSpear.Name = "Handle"
									itemModel.PrimaryPart = itemModel.Handle
								end
								userStats:Synchronize("AddUsedWeapon", "Thrown "..wepName)
								itemModel:SetAttribute("IsThrow", true)
								itemModel.Parent = VFX_PARTS
								local throwPart = Instance.new("Part")
								throwPart.Size = Vector3.new(1, 1, 1)
								throwPart.Name = "ThrowPart"
								throwPart.CanCollide = false
								throwPart.Transparency = 1
								throwPart.Parent = VFX_PARTS
								throwPart:SetNetworkOwner(nil)
								throwPart.CFrame = firedCF
								local throwSound = GlobalSounds.Throw:Clone()
								throwSound.Parent = throwPart
								throwSound.PlaybackSpeed += math.random(-50, 50) / 1000
								throwSound:Play()
								local antiGrav = Instance.new("BodyForce")
								antiGrav.Name = "AntiGravity"
								antiGrav.Parent = throwPart 
								antiGrav.Force = Vector3.new(0, throwPart:GetMass() * workspace.Gravity * (1 - throwInfo.GravityMult), 0)
								throwPart.AssemblyLinearVelocity = firedCF.LookVector * throwInfo.Velocity
								local handle = itemModel.PrimaryPart
								for _, part in pairs(itemModel:GetChildren()) do
									if not part:IsA("BasePart") then continue end
									part.CanCollide = false
									part.Anchored = true
									part.Massless = (part ~= handle)
								end
								local lastCF = throwPart.CFrame
								local con
								local started = tick()
								local curSpin = CFrame.new()
								local hitWater = false
								--[[task.delay(0.1, function()
									if not (itemModel and itemModel.Parent) then return end
									local highlight = itemModel:FindFirstChild("Highlight")
									if highlight then
										highlight.Adornee = itemModel
									end
								end)]]
								con = Run.Heartbeat:Connect(function(step)
									if tick() - started >= 15 or not (throwPart and throwPart.Parent) then
										if itemModel and itemModel.Parent then
											itemModel:Destroy()
										end
										con:Disconnect()
										return
									end
									local curCF = throwPart.CFrame
									local posDiff = (curCF.Position - lastCF.Position)
									local hit, pos, normal, material = RaycastUtil:Raycast(lastCF.Position, posDiff, "Blacklist", {VFX_PARTS, character, Drops, Plants}, showProjectileRays, hitMeleeIgnoreFilterFunc)
									--[[if hit and material == Enum.Material.Water then
										hit = nil
										if not hitWater then
											hitWater = true
											handle.AssemblyLinearVelocity = Vector3.new()
											handle.AssemblyAngularVelocity = Vector3.new()
										end
									end]]
									if hit then
										local position = hit.CFrame:PointToObjectSpace(pos)
										local dontWeld = true
										if throwInfo.Stick then
											dontWeld = hit.Anchored
											for _, part in pairs(itemModel:GetChildren()) do
												if not part:IsA("BasePart") then continue end
												part.Anchored = dontWeld
											end
										end
										local isWater = (material == Enum.Material.Water)
										if not isWater then
											itemModel:SetPrimaryPartCFrame(CFrame.new(pos, pos + normal) * throwInfo.LandOffset)
										end
										if throwInfo.Stick and not isWater then
											local weldPart = ((hit.Name ~= "LowerTorso" and not (hit.Name:find("Leg") or hit.Name:find("Foot")) and hit.Parent:FindFirstChild("Humanoid")) and hit.Parent.PrimaryPart or hit)
											if not dontWeld then
												WeldModule:WeldParts(handle, weldPart)
											end
											local hitCons = {}
											table.insert(hitCons, weldPart.AncestryChanged:Connect(function()
												if weldPart and weldPart.Parent then return end
												for _, part in pairs(itemModel:GetChildren()) do
													if not part:IsA("BasePart") then continue end
													part.Anchored = false
													part.CanCollide = true
												end
												itemModel:SetAttribute("IsThrow", false)
											end))
											table.insert(hitCons, itemModel.Destroying:Connect(function()
												for _, con in pairs(hitCons) do
													con:Disconnect()
												end
											end))
										else
											for _, part in pairs(itemModel:GetChildren()) do
												if not part:IsA("BasePart") then continue end
												part.CanCollide = true
												part.Anchored = false
											end
											if isWater then
												handle.CustomPhysicalProperties = PhysicalProperties.new(100, 2, 0)
												handle.AssemblyAngularVelocity = Vector3.new()
												handle.AssemblyLinearVelocity = Vector3.new()
												handle.Velocity = Vector3.new()
												handle.RotVelocity = Vector3.new()
												antiGrav:Destroy()
											else
												local throwVel = throwPart.AssemblyLinearVelocity
												handle.AssemblyLinearVelocity = throwVel * 0.2
											end
											itemModel:SetAttribute("IsThrow", false)
										end
										local parent = hit.Parent
										local hum = (parent:FindFirstChild("Humanoid") or parent.Parent:FindFirstChild("Humanoid"))
										if hum then
											ModUtil:FireClient(CombatRemotes, AllRemotes.Hit, player, "HitMarker", (hit.Name == "Head" and "HitHead" or "Hit"))
										end
										for _, plr in pairs(Players:GetPlayers()) do
											ModUtil:FireClient(VFXRemotes, AllRemotes.Visualize, plr, "HitVFX", hit, CFrame.new(position), normal, material)
										end
										throwPart:Destroy()
										local _, hitLimb, distance = DamageModule:Damage(hit, position, normal, firedCF, meleeInfo.ThrowDamages, {Start = 100, End = 100}, nil, item, player, meleeInfo.SoftSideMult, "Melee", true, durabilities)
										if hitLimb and distance then
											userStats:Synchronize("AddWeaponHit", "Thrown "..wepName, distance, hitLimb)
										end
										local itemVal = itemModel:FindFirstChild("Item")
										if itemVal and item then
											local oldAmount = item.Amount
											item.Amount = 1
											itemVal.Value = Http:JSONEncode(item)
											item.Amount = oldAmount
										end
										itemModel.Parent = Drops
										con:Disconnect()
									else
										local spinSpeed = step * posDiff.Magnitude
										curSpin = curSpin * CFrame.Angles(throwInfo.SpinSpeed[1] * spinSpeed, throwInfo.SpinSpeed[2] * spinSpeed, throwInfo.SpinSpeed[3] * spinSpeed)
										local throwCF = (throwInfo.RotateDynamically and CFrame.new(curCF.Position, curCF.Position + (curCF.Position - lastCF.Position)) or curCF)
										itemModel:SetPrimaryPartCFrame(throwCF * throwInfo.ThrowCFrameOffset * curSpin)
										lastCF = curCF
									end
								end)
							end
						end
						return
					end
					if meleeInfo then
						local randomSeed = math.floor(firedTick * 10000)
						local random = Random.new(randomSeed)
						local melee = {
							ID = random:NextInteger(1, 1e10);
							Type = "Melee";
							EquippedModel = equippedModel;
							FlashPos = (firedCF ~= nil and firedCF.Position);
							WeaponName = wepName;
						}
						for _, t in pairs(bulletQueue) do
							if t.ID ~= melee.ID then continue end
							return "MELEE ACTION FUNCTION STOPPED: ATTACK ID ALREADY PRESENT IN SERVER."
						end
						local swingSound = primPart:FindFirstChild(itemInfo.Name.."Swing")
						if swingSound then
							SoundModule:ReplicateSoundToClients(swingSound, "PlayDuplicate", player)
						end
						table.insert(bulletQueue, melee)
						local started = tick()
						local maxTime = script:GetAttribute("MeleeAttackTimeout")
						while melee and player and player:IsDescendantOf(Players) and equippedModel and equippedModel.Parent do
							local timeOut = (tick() - started >= maxTime)
							local id = melee.ID
							local hitInfo = melee.HitInfo
							if not (hitInfo or timeOut) then 
								task.wait() 
								continue 
							end
							for i, v in pairs(bulletQueue) do
								if v ~= melee and not timeOut then continue end
								table.remove(bulletQueue, i)
								break
							end
							if timeOut and (hitInfo == nil or not hitInfo.Hit) then
								print("MELEE ATTACK NULLIFIED - TIMEOUT REACHED ("..maxTime.." SECONDS)")
								break
							end
							if not hitInfo.Hit then break end

							melee = nil
							local detHit, detPos, detNor, detMat = RaycastUtil:Raycast(hitInfo.FiredCFrame.Position, hitInfo.FiredDirection * 1.5, "Blacklist", {VFX_PARTS, character, Drops, Plants}, showProjectileRays, function(h)
								return HitFilterFunction(h, hitInfo.Hit, hitMeleeIgnoreFilterFunc)
							end, true)
							if item.ID == 31 then
								DamageModule:RepairBench(hitInfo.Hit, player)
							else
								for _, plr in pairs(Players:GetPlayers()) do
									-- if plr == player then continue end
									-- CFrame.new(hitInfo.Hit.CFrame:PointToObjectSpace(hitInfo.Position))
									local hitPart = hitInfo.Hit
									ModUtil:FireClient(VFXRemotes, AllRemotes.Visualize, plr, "HitVFX", unpack((detHit ~= nil and detHit.Parent ~= nil) and {detHit, detPos, detNor, detMat, item} or {hitPart, CFrame.new(hitInfo.Position), hitInfo.Normal, hitInfo.Material, item}))
								end
								local _, hitLimb, distance = DamageModule:Damage(hitInfo.Hit, hitInfo.Position, hitInfo.Normal, hitInfo.FiredCFrame, meleeInfo.HumanoidDamages, {Start = 1000, End = 1000}, nil, item, player, meleeInfo.SoftSideMult, "Melee", false, durabilities)
								if hitLimb and distance then
									userStats:Synchronize("AddWeaponHit", wepName, distance, hitLimb)
								end
							end
							task.wait()
						end
					else
						local clientTickDiff = serverTick - firedTick
						local cardColor = weaponInfo.KeycardColor
						if itemInfo.ConsumableStats then --IF ITEM IS A BANDAGE / MED PEN
							local useTime = math.max(weaponInfo.Cooldown - 0.25 - clientTickDiff, 0)
							--print(weaponInfo.Cooldown, useTime)
							task.wait(useTime)
							if equippedModel ~= user.Equipped.Model or not (equippedModel and equippedModel.Parent) then return end
							item.Amount -= 1
							if item.Amount <= 0 then
								toolbar[equipped.Index] = 0
							end
							inventory:UpdateClient("IgnoreEquipUpdate", {"Toolbar", equipped.Index, toolbar[equipped.Index]})
							user.Stats:ApplyConsumableTable(itemInfo.ConsumableStats)
							user.Stats:UpdateClient()
						elseif cardColor and item.Durability > 0 then
							local timeWaited = task.wait(math.max(0.4 - clientTickDiff, 0))
							if not (equippedModel and equippedModel.Parent) then return end
							local doors = Bases.Loners:FindFirstChild(`{cardColor} Keycard Door`)
							if not doors then return end
							local distCF = primPart.CFrame * CFrame.new(0, 1, 0)
							local checkPos = (distCF * CFrame.new(0, 0, -2)).Position
							for _, door in pairs(doors:GetChildren()) do
								if door:GetAttribute("Open") or door:GetAttribute("Moving") then continue end
								local doorBench = shared.Benches[door]
								if not (doorBench and doorBench.Powered and not doorBench.Swiped) then continue end
								local swiper = doorBench.Swiper
								local swiperPos = swiper.Main.Position
								local isWithin, distSquared = NumberUtil:IsWithin(checkPos, swiperPos, 1.5)
								--print(math.sqrt(distSquared))
								if not isWithin then continue end
								local swiperHit = RaycastUtil:Raycast(distCF.Position, swiperPos - distCF.Position, "Exclude", {character, VFX_PARTS, Drops, Plants, Animals}, false, viewFilterFunc, true)
								if not (swiperHit and swiperHit:IsDescendantOf(swiper)) then continue end
								item.Durability = math.max(item.Durability - 1 * durDecreaseMult, 0)
								inventory:UpdateClient({"Toolbar", equipped.Index, toolbar[equipped.Index]})
								--doorBench:OpenDoor()
								doorBench.Swiped = true
								doorBench:ToggleKeycardDoor(true)
								break
							end
							task.wait(weaponInfo.Cooldown - timeWaited)
						elseif wepName == "Lighter" then
							task.wait(math.max(0.5 - clientTickDiff, 0))
							if not (equippedModel and equippedModel.Parent) then return end
							local lightPart = equippedModel:FindFirstChild("LightPart")
							if not lightPart then return end
							local lastEffect
							for _, v in pairs(lightPart:GetChildren()) do
								v.Enabled = not v.Enabled
								lastEffect = v
							end
							local nextDur = 1
							while lastEffect and lastEffect.Parent and lastEffect.Enabled and equippedModel.Parent do
								if nextDur >= 1 then
									nextDur -= 1
									local newDur = math.max(item.Durability - 1 * durDecreaseMult, 0)
									item.Durability = newDur
									inventory:UpdateClient({"Toolbar", equipped.Index, toolbar[equipped.Index]})
									if newDur <= 0 then
										break 
									end
								end
								nextDur += task.wait()
							end
						end
					end
				end
			end)()
			if projectileInvalid then
				HandleInvalids(player, (isThrow and "Thrown " or "")..wepName, projectileInvalid, projectileId)
			end
		end;
	};
	[AllRemotes.Hit] = {
		Cooldown = 0.03;
		AllowedCallsBeforeThrottle = 30;
		ThrottleQueueMaxSize = 20;
		IgnoreDecryption = true;
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			--print(args[1], args[2], args[3], args[4], args[5])
			local bulletQueue = user.BulletQueue
			local bulletID = args[1] -- :3
			--print("fired to server", bulletID)
			local isInst = (typeof(args[5]) == "Instance")
			if not (args[5] and isInst and args[5]:IsDescendantOf(workspace) and typeof(args[4]) == "Vector3") then
				if args[5] and args[5] ~= ".void" then
					--warn("SERVER HIT ARGUMENT FAILED", args[5], (isInst and args[5]:GetFullName()), args[4], args[3], args[2])
					--HandleInvalids(player, nil, "HIT FAILED - INVALID ARGUMENTS", (type(bulletID) == "number" and bulletID))
				end
				for i = 2, 5 do
					args[i] = nil
				end
			end
			local bulletMatName = args[2]
			local bulletNor = args[3]
			local bulletPos = args[4]
			local bulletHit = args[5]
			local bulletMat
			pcall(function()
				if not bulletMatName then return end
				bulletMat = Enum.Material[bulletMatName]
			end)
			if type(bulletID) ~= "number" or bulletID < 1 or bulletID % 1 ~= 0 or 
				(bulletHit and (typeof(bulletHit) ~= "Instance" or typeof(bulletPos) ~= "Vector3" or typeof(bulletNor) ~= "Vector3" or typeof(bulletMat) ~= "EnumItem" or bulletPos == bulletHit.Position or bulletPos == Vector3.new() or bulletNor == Vector3.new() or math.abs(bulletNor.X) >= 1.01 or math.abs(bulletNor.Y) >= 1.01 or math.abs(bulletNor.Z) >= 1.01 or (bulletHit.Name == "Head" and bulletMat.Name ~= "Plastic"))) 
				or (bulletHit == nil and (bulletPos or bulletNor or bulletMatName)) then
				--[[print(
					type(bulletID) ~= "number", 
					bulletID < 1, 
					bulletID % 1 ~= 0,  
					typeof(bulletHit) ~= "Instance", 
					typeof(bulletPos) ~= "Vector3", 
					typeof(bulletNor) ~= "Vector3", 
					typeof(bulletMat) ~= "EnumItem", 
					bulletPos == bulletHit.Position, 
					bulletPos == Vector3.new(), 
					bulletNor == Vector3.new(), 
					math.abs(bulletNor.X) >= 1.01, 
					math.abs(bulletNor.Y) >= 1.01, 
					math.abs(bulletNor.Z) >= 1.01,
					(bulletHit == nil and (bulletPos or bulletNor or bulletMatName))
				)]]
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			local invalidTable
			local projectileInvalid = (function()
				local showSanityCheckRays = (script:GetAttribute("DebugShowSanityCheckRays") and "GreenRay")
				local showProjectileRays = (script:GetAttribute("DebugShowProjectileRays") and "BlueRay")
				local didFind = false
				--print(#bulletQueue, bulletQueue)
				for _, bullet in pairs(bulletQueue) do
					if bullet.ID ~= bulletID then continue end
					didFind = true
					invalidTable = bullet.WeaponName
					if bullet.HitInfo then return "DAMAGE FUNCTION STOPPED: A HIT HAS ALREADY BEEN REGISTERED ON THE SERVER." end
					local ignore = false
					local actualFiredCF, actualFiredDir, hitHum
					if bulletHit and bulletPos then
						local position = (bulletHit.CFrame * CFrame.new(bulletPos)).Position
						--print(bulletHit, bulletHit.Position, bulletPos, position)
						local surfaceCF = CFrame.new(position, position + bulletNor) * CFrame.new(0, 0, -0.2)
						local rayPos = surfaceCF.Position
						if bullet.FlashPos then
							invalidTable = {
								WeaponName = bullet.WeaponName;
								Range = (position - bullet.FlashPos).Magnitude;
								--Hit = bulletHit;
							}
						end
						hitHum = bulletHit.Parent:FindFirstChild("Humanoid")
						local isSurface, maxRange
						if not bulletHit.Anchored then
							maxRange = (hitHum and script:GetAttribute("HumanoidLimbSurfaceMaxAllowedRange") or (bulletHit:IsDescendantOf(Events) and 40 or script:GetAttribute("UnanchoredPartSurfaceMaxAllowedRange")))
							isSurface = NumberUtil:IsWithin(rayPos, bulletHit.Position, maxRange)
						else
							--isSurface = RaycastUtil:Raycast(rayPos, surfaceCF.LookVector * -0.8, "Whitelist", {bulletHit}, showSanityCheckRays)
							isSurface = true -- TODO: FIX
						end
						if not isSurface then return `DAMAGE FUNCTION STOPPED: SURFACE POSITION TOO FAR FROM HIT PART ({isSurface} {maxRange})` end
						if hitHum then
							local surfaceHit = RaycastUtil:Raycast(rayPos, bulletHit.Position - rayPos, "Blacklist", {VFX_PARTS, player.Character, bulletHit.Parent, Drops, Plants, workspace.Terrain}, showSanityCheckRays, viewFilterFunc, true)
							if surfaceHit and (surfaceHit:IsA("Terrain") or surfaceHit:IsDescendantOf(Bases)) then return "DAMAGE FUNCTION STOPPED: SURFACE POSITION TO LIMB IS OBSTRUCTED (SURFACE HIT: "..surfaceHit:GetFullName()..", LIMB HIT: "..bulletHit.Name..")" end
						end
						if bullet.Type == "Bullet" then
							if args[6] or #args >= 6 then
								--print("bullet too many")
								return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
							end
							local proj = bullet.ProjectileSettings
							if proj then -- :3
								proj.Instant = (1 / 60)
							end
						elseif bullet.Type == "Melee" then
							local firedCF = args[6]
							local meleeKeyframeIndex = args[7]
							if args[8] or #args >= 8 or typeof(firedCF) ~= "CFrame" or 
								type(meleeKeyframeIndex) ~= "number" or meleeKeyframeIndex % 1 ~= 0 or meleeKeyframeIndex < 1 then
								return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
							end
							local equipped = user.Equipped
							local inventory = user.Inventory
							local toolbar = inventory:GetToolbar()
							local equippedModel = bullet.EquippedModel
							local item = toolbar[equipped.Index]
							if not (equippedModel and equippedModel.Parent and item and item ~= 0 and item.Amount > 0) then return end
							local itemInfo = Items[item.ID]
							local toolInfo = ToolInfo[itemInfo.Name]
							local meleeInfo = toolInfo.Melee
							local meleeChecks = meleeInfo.MeleeChecks
							local meleeKeyframes = meleeChecks[meleeKeyframeIndex]
							if not (meleeKeyframes and (itemInfo.MaxDurability == nil or item.Durability > 0)) then return end
							local humanoid = user.Humanoid
							if not (humanoid and humanoid.Health > 0 and not humanoid:GetAttribute("Downed")) then return "MELEE DAMAGER FUNCTION STOPPED: PLAYER DEAD/DOWNED" end
							local character = humanoid.Parent
							if not character then return "MELEE DAMAGE FUNCTION STOPPED: NO VALID CHARACTER" end
							local primPart = character.PrimaryPart
							if not primPart then return "MELEE DAMAGE FUNCTION STOPPED: NO VALID HUMANOIDROOTPART" end
							local primPos = primPart.Position
							local isWithin, squaredDist = NumberUtil:IsWithin(firedCF.Position, primPos, script:GetAttribute("MaxClientToServerDistanceThreshold"))
							if not isWithin then return "MELEE DAMAGE FUNCTION STOPPED: CLIENT PLAYER POSITION TOO FAR FROM CURRENT SERVER POSITION ("..math.sqrt(squaredDist)..")" end
							local isObstructed = RaycastUtil:Raycast(primPos, firedCF.Position - primPos, "Blacklist", {VFX_PARTS, character, Drops, Plants, Animals}, showSanityCheckRays, viewFilterFunc, true)
							if isObstructed then return "MELEE DAMAGE FUNCTION STOPPED: CLIENT AND SERVER CHARACTER VIEW IS OBSTRUCTED (OBJECT HIT: "..isObstructed:GetFullName()..")" end
							local hit
							local maxRange = meleeInfo.MaxRange + script:GetAttribute("MeleeExtraRange")
							--[[for index, rayInfo in pairs(meleeKeyframes[2]) do
								local checkCF = firedCF * rayInfo.Offset
								local origin = checkCF.Position
								local direction = CFrame.new(origin, position).LookVector * maxRange
								local checkHit = RaycastUtil:Raycast(origin, direction, "Blacklist", {VFX_PARTS, character, Drops, Plants}, showProjectileRays, function(h)
									return HitFilterFunction(h, bulletHit, hitMeleeFilterFunc)
								end, true)
								--print(bulletHit, checkHit)
								if not checkHit then continue end
								hit = checkHit
								local parent = hit.Parent
								if parent and bulletHit:IsDescendantOf(parent) then
									actualFiredCF = checkCF
									actualFiredDir = direction
									break
								end 
								hit = nil
							end]]
							local origin = firedCF.Position
							local targetPosition = (hitHum and bulletHit.Position or position)
							local direction = CFrame.new(origin, targetPosition).LookVector * maxRange
							local checkHit = RaycastUtil:Raycast(origin, direction, "Blacklist", {VFX_PARTS, character, Drops, Plants}, showProjectileRays, function(h)
								return HitFilterFunction(h, bulletHit, hitMeleeFilterFunc)
							end, true)
							if checkHit and (checkHit:IsDescendantOf(bulletHit.Parent) or not checkHit.Parent.Name:find("Wall")) then -- TODO should prob fix this lmao
								actualFiredCF = firedCF
								actualFiredDir = direction
							else
								if checkHit then
									if type(invalidTable) == "table" then
										invalidTable.Range = (targetPosition - firedCF.Position).Magnitude
									end
									HandleInvalids(player, invalidTable, "MELEE DAMAGE FUNCTION FAILED: CLIENT HIT ("..(bulletHit and bulletHit.Name)..") DOESN'T MATCH SERVER ("..(checkHit and checkHit.Name)..").", bulletID)
								else
									HandleInvalids(player, itemInfo.Name, "DAMAGE FUNCTION FAILED: SERVER'S MELEE RAYCAST FAILED TO HIT ANYTHING", bulletID)
								end
								ignore = true
							end
						end
					end
					bullet.HitInfo = ((bulletHit == nil or ignore) and {} or {
						Hit = bulletHit;
						Position = bulletPos;
						Normal = bulletNor;
						Material = bulletMat;
						FiredCFrame = actualFiredCF;
						FiredDirection = actualFiredDir;
						Humanoid = hitHum;
					})
					--print("server", bullet.HitInfo)
					break
				end
				--if not didFind then return "DAMAGE FUNCTION FAILED - BULLET FAILED TO FULLY INITIALIZE ON SERVER" end--print(player.Name.." DAMAGE FUNCTION FAILED - ID NOT FOUND IN SERVER") end
			end)()
			if projectileInvalid then
				HandleInvalids(player, invalidTable, projectileInvalid, bulletID)
			end
		end;
	};
	[AllRemotes.Reload] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local reloadStartedTick = args[1]
			local newBulletID = args[2]
			if newBulletID == "Cancel" then
				user.ReloadIndex = (user.ReloadIndex >= 100 and 1 or user.ReloadIndex + 1)
				return
			elseif newBulletID == "None" then
				newBulletID = nil
			end
			local serverTick = workspace:GetServerTimeNow()
			local clientTickDiff = type(reloadStartedTick) == "number" and serverTick - reloadStartedTick
			if args[3] or #args >= 3 or (newBulletID ~= nil and (type(newBulletID) ~= "number" or not Items[newBulletID])) or not clientTickDiff or clientTickDiff <= -3 or clientTickDiff >= 120 then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			local equipped = user.Equipped
			local inventory = user.Inventory
			local toolbar = inventory:GetToolbar()
			local character = player.Character
			if not character then return end
			local primPart = character.PrimaryPart
			local humanoid = character:FindFirstChild("Humanoid")
			if not (primPart and equipped and equipped.Index and equipped.Index > 0) then return end
			local equippedModel = equipped.Model
			local item = toolbar[equipped.Index]
			if not (equippedModel and equippedModel.Parent and equippedModel.PrimaryPart and item and item ~= 0 and item.Amount > 0 and item.Durability and item.Durability > 0) then return end
			local itemInfo = Items[item.ID]
			local itemAmmoType = itemInfo.AmmoType
			local maxAmmo = itemInfo.BaseMaxAmmo
			if not (itemAmmoType and itemInfo.Type == "Gun" and maxAmmo) then return end
			local toolInfo = ToolInfo[itemInfo.Name]
			local weaponInfo = toolInfo.Weapon
			local boltFed = weaponInfo.BoltFed
			local count = 0
			local setAmmoId
			local reloadIndex = user.ReloadIndex
			while true do
				if not (humanoid and humanoid.Parent and humanoid.Health > 0) then return end
				if reloadIndex ~= user.ReloadIndex or not (item.Ammo == nil or item.Ammo.Amount < maxAmmo or newBulletID) then break end
				if not equippedModel.Parent or equipped.Model ~= equippedModel then return end
				local canReload = inventory:FindItem(1, {"Inventory", "Toolbar"}, {itemAmmoType, setAmmoId}, function(item, args)
					local id = item.ID
					if args[2] then
						return id == args[2]
					else
						local info = Items[id]
						return (info.Type == "Ammo" and info.AmmoType == args[1])
					end
				end)
				if not canReload then break end
				count += 1
				local started = tick()
				local duration = (count == 1 and math.max(weaponInfo.ReloadDuration - clientTickDiff, 0) or weaponInfo.ExtraReloadDuration)
				--print("starting server reload", duration)
				repeat
					task.wait()
					if not equippedModel.Parent or equipped.Model ~= equippedModel then return end
				until tick() - started >= duration
				if reloadIndex ~= user.ReloadIndex and count ~= 1 then break end
				--print("server reload initializing")
				local ammo = item.Ammo
				local reloadID = (setAmmoId or (newBulletID == nil and ammo ~= nil and ammo.ID))
				local ammos = {}
				local ammoFound
				for _, containerName in pairs({"Inventory", "Toolbar"}) do
					local container = inventory:GetInv()[containerName]
					for index, item in pairs(container) do
						if item == 0 or item.Amount <= 0 then continue end
						local id = item.ID
						local amount = item.Amount
						local info = Items[id]
						local ammoType = info.AmmoType
						if info.Type ~= "Ammo" or ammoType ~= itemAmmoType then continue end
						local ammoT
						for _, v in pairs(ammos) do
							if v.ID ~= id then continue end
							ammoT = v
							break
						end
						if not ammoT then
							ammoT = {
								ID = id;
								Amount = 0;
								Found = {}; -- :3
							}
							table.insert(ammos, ammoT)
							if id == reloadID then
								ammoFound = ammoT
							end
						end
						ammoT.Amount += amount
						table.insert(ammoT.Found, {containerName, index})
					end
				end
				if not equippedModel.Parent or equipped.Model ~= equippedModel then return end
				local needNew = (setAmmoId == nil and ((not reloadID) or not (ammoFound and ammoFound.Amount > 0)))
				local newBulletInfo = (newBulletID and Items[newBulletID])
				--print(ammo, reloadID, ammos, needNew, newBulletID)
				for index, t in pairs(ammos) do
					if (needNew and ( (t.ID == newBulletID and newBulletInfo and newBulletInfo.Type == "Ammo" and newBulletInfo.AmmoType == itemAmmoType) or (newBulletID == nil and index == 1) ))
						or ((not needNew) and t.ID == reloadID) then
						if ammo and ammo.Amount > 0 and ammo.ID ~= t.ID then
							inventory:AddItem(ammo)
							ammo.Amount = 0
						elseif not ammo then
							ammo = ItemClass.new(t.ID, 0)
							item.Ammo = ammo
						end
						local oldLeft = (boltFed and 1 or math.min(maxAmmo - (ammo and ammo.Amount or 0), t.Amount))
						local update, left = inventory:RemoveFoundItems(t.Found, oldLeft)
						--print("reloading successful", ammo.ID, ammo.Amount, t.ID, oldLeft)
						ammo.ID = t.ID
						ammo.Amount += (oldLeft - left)
						WeldModule:WeldAttachments(equippedModel, item)
						table.insert(update, {"Toolbar", equipped.Index, toolbar[equipped.Index], "LocalAmmo"})
						inventory:UpdateClient(unpack(update))
						setAmmoId = ammo.ID
						break
					end
				end
				if (not boltFed) or (ammo and ammo.Amount >= maxAmmo) then break end
			end
			if not boltFed then return end -- :3
			ModUtil:FireClient(CombatRemotes, AllRemotes.Reload, player)
		end;
	};
	[AllRemotes.Attachment] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local attachmentID = args[1]
			if args[2] or #args > 1 or type(attachmentID) ~= "number" or not Items[attachmentID] then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			local equipped = user.Equipped
			local inventory = user.Inventory
			local toolbar = inventory:GetToolbar()
			if not (equipped and equipped.Index and equipped.Index > 0) then return end
			local humanoid = user.Humanoid
			if not (humanoid and humanoid.Health > 0) then return end
			local character = humanoid.Parent
			if not character then return end
			local primPart = character.PrimaryPart
			if not primPart then return end
			local equippedModel = equipped.Model
			local item = toolbar[equipped.Index]
			if not (equippedModel and equippedModel.Parent and equippedModel.PrimaryPart and item and item ~= 0 and item.Amount > 0 and item.Durability and item.Durability > 0) then return end
			local itemInfo = Items[item.ID]
			local attachment = item:HasAttachment(attachmentID)
			if not attachment then return end
			local attachmentInfo = Items[attachment.ID]
			local attachmentStats = attachmentInfo.AttachmentStats
			if not (attachmentStats and attachmentStats.Toggle) then return end
			attachment.On = (not attachment.On)
			inventory:UpdateClient({"Toolbar", equipped.Index, toolbar[equipped.Index]})
			user:UpdateAttachments() -- :3
		end;
	};
})

ModUtil:SetupRemotes(VFXRemotes, {
	[AllRemotes.Visualize] = { -- Nobody should be firing this unless it's anticheat doing so
		Function = function(remote, player, args)
			return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
		end;
	};
})