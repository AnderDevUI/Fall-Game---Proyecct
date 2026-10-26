-- [PATH] ReplicatedStorage / Modules / BenchInfo @Type ModuleScript
--[[
	BenchInfo
	by ChickenBagelz
	February 11, 2023
	
	Contains all information of every placeable bench and base part
	
	
	BENCHINFO DOCUMENTATION:
	[name] = {
		Type = The type of container. All available types are:
			Misc = No special actions.
			BasePart = For base parts. These have no valid BenchClass when placed down.
			Damager = Will setup the bench's damage parts along with these customizable parameters:
				Damage = Damage dealt to players per tick
				Bleed = Amount of bleed applied per tick
				HitTick = How often it will damage
			Container = Creates an unrestricted container that can hold items. Available arguments are:
				UI = Name of the UI displayed on the client when the bench is opened.
				Slots = Table that determines the raw container size, and the SlotType for each slot. All available SlotTypes are below.
				LootTable = Table path of the LootTable this container will begin with. All items generated from the LootTable will be added onto
							the bench upon creation.
				ResizeDynamically = If true, the bench will disable any slot that isn't initially occupied after generating the LootTable.
				DestroyOnEmpty = If true, the bench will destroy itself when all of its containers are empty.
				CombineItems = If true, combines items into proper stacks of the same ID.
				ShuffleItems = If true, shuffles all items randomly onto the container.
				LocalContainer = If true, every player will have their own unique container attached to this bench.
				MaxStack = A preset max stack that this container can hold in each of its slots.
				OnePersonOnly = If true, only one person can access the bench at a time.
			Campfire = Just like a Container, except it can be turned on if Fuel is inside the bench. Particles will play if present, and any extra
					   scripts added (like damaging parts) will be toggled depending on the bench's On state. While on, will smelt any items and
					   turn them to their corresponding Smelt LootTable counterparts. Extra available arguments are:
				FuelMult = Multiplier applied to Fuel smelt times (the lower, the faster the Fuel will smelt).
				InputMult = Multiplier applied to any other Input slot that isn't the fuel slot (the lowr, the faster it will smelt)
			Shredder = A special type of container. Turns every item in its input slots into its recycled counterparts. Gets turned off if its empty
					   or full.
			Door = A bench that acts like a door. Gives you the Open and Close options, as well as Knock. Available arguments are:
				MoveTime = Time, in seconds, for the door to finish its movement.
				MoveFunction = Mathematical function used to give the alpha for tweens. Returns a Y value given the X component.
				Logic = Function name inside of BenchClass that is fired when the bench is opened.
				Open = If true, bench will be placed as already open.
				OpenDegrees = How many degrees the door is offset by when opened.
				ChangeCollideWhenMoving = If true, the door will be set to cancollide false for the first half of its opening animation. Only works for OpenDoor logic
				
				IF DAMAGEPARTS ARE PRESENT, USE SAME ARGUMENTS AS THE DAMAGER TYPE.
				
			BaseCabinet = A special-case Container. Responsible for base decaying/upkeep/privilege
			Bed = Adds towards the player's respawn locations.
			Destroyable = Drops the specified LootTable's items when destroyed. Also applies health if it's a naturally-spawned bench.
			LockedContainer = Functions like a Container, but is locked with specified amount of Health that must be broken before being able to open.
			Sleeper = A special Container that is tied to players.
			Sign = A bench which you can either write text on or put a decal with a gamepass. Available arguments are:
				CharacterLimit = The max amount of characters you can write on the sign.
			Trap = A bench that has a TouchCollision part that when touched, performs a special action. Can be either Armed or arming. Available arguments are:
				Damage = [BEAR TRAP] How much damage will be dealt to a player when the trap is activated.
				Bleed = [BEAR TRAP] How much bleeding will be dealt to a player when the trap is activated.
				Explosive = [LANDMINE TRAP] A special Explosion table indicating explosive properties of the trap when stepped on.
			Turret = A trap/container hybrid. When a player is inside specified collision, the turret will shoot at the player. Available arguments:
				Damage = Base damage of the bullet. Can vary based on limb hit.
				Bleed = Base bleed of the bullet. Can vary based on limb hit.
				BulletRadius = Radius of the firing cone.
				BulletRange = The total length of the firing cone.
				DamageRange = {num, num} -- A table describing the damage dropoff (start and end) of the bullet.
				BulletCount = Pellets fired per shot.
				Cooldown = How fast it fires in seconds.
		TypeArguments = Function that is run to determine which arguments are given to the Initialize function for the container type
		ClientFunction = If present, this function will take the current BenchModel and can be used to change the client's selection UI while hovered
						 over the bench. Use this when wanting to add custom selection UI behavior. Returns the first option and number of total options.
		DecayType = Determines how the bench behaves in terms of building privilege and upkeep/decaying. All possible types are:
			Never = The bench will never decay nor affect upkeep in any way
			Always = Bench will always decay, no exceptions
			UnderBase = Bench will only decay if not under a base's building privilege radius
			Upkeep = Will add towards the base's total upkeep. If upkeep not met, bench will decay. Needs a valid Recipe in order to work
			Sleeper = Only works on Sleepers. Will deal damage to them if not under a base with proper authorization or if under water.
		PickupBehavior = The pickup behavior of the bench. All possible behaviors are:
			false (cannot be picked up in any capacity)
			"HammerOnly" (can only be picked up with a Hammer)
			true (can always be picked up)
		InteractDistance = Distance, in studs, where you can interact with the bench from. Distance calculated from the model's Main part.
		DurabilityDecrease = The % of durability lost when the Bench is picked up by the player (defaults to 0%)
		GuiOffset = Vector3 offset applied to the Info BillboardGui when visible (offset is from the benche's Main part)
		DisplayHealthOnly = If true, will only highlight the bench with a hammer and will only display its health when its health is low
		DamageType = Base damage value used when the bench is damaged (found inside ToolInfo.ObjectDamages.Benches)
		SoftSide = If present, the NormalId of the PrimaryPart that needs to be hit in order to count as a "soft side" (4x damage multiplier)
		Sounds = Optional sounds that are played locally from the bench. Can be found under Replicated.LocalSounds.BenchSounds
			Open = Sound name played when the bench is opened
			Close = Sound name played when the bench is closed
		THESE CAN BE DISCARDED IF THE BENCH IS NATURALLY GENERATED AND NOT PLACED DOWN:
		Cost = If present, the player will need this item in their inventory to place the bench
			ID = Item ID required
			Amount = Minimum number of the item required
		Offset = CFrame offset applied to the bench
		UnsnappedOffset = Extra CFrame offset applied to the bench when not snapped by any parts
		RotateOffset = CFrame offset applied every time the bench is rotated manually
		PlaceableAngles = {
			Min = Minimum angle incline the bench can be placed on
			Max = Maximum angle incline the bench can be placed on. Allows you to set placeables that can only be placed on walls, floors, etc.
		}
		RayCheckLength = If this is a free-placed bench, this is the length of the ray fired on the server to verify it's grounded.
		RayCheckVector = Determines the angle vector used when firing the server verification ray. Defaults to "UpVector", but can be changed to 
			"RightVector" or "LookVector".
		FaceCamera = Whether the bench is automatically rotated depending where you're looking at or not.
		OffsetSnappedFacingAway = If present, this will be extra rotation added to the bench when not facing the player.
		RotateOnSurface = Whether the bench will rotate depending on the surface angle it is being placed at.
		MaxPerBase = Max count of this bench that can be present per base
		PlaceBlacklist = If present, benches with these names will nullify placement
		PlaceWhitelist = If present, can only be placed on benches with this name
		IgnoreBuildBlock = If true, can be placed even when building blocked (excluding monument building block)
		PlacingFunc = Function used to determine if bench can be initially placed or not. Passes the BenchInfo of the bench, what the mouse hit,
					  and the angle incline of the bench. All available functions are down below.
		CollisionFunc = Function used to determine whether the bench is obstructed. Passes the bench model currently being collision checked. All
					  available functions down below.
		SnapPoints = Contains all the benches the bench can snap from, and the offsets. Bench will not snap to anything if this is not present.
					 A table example is = {
					 	{
					 		BenchNames = A table of all the bench names this offset applies to.
					 		Offset = CFrame offset applied from the bench's CFrame.
					 		AttachmentIndex = Index this snap occupies. A bench can only have one snapped bench per each AttachmentIndex, meaning
					 						  snaps with the same AttachmentIndex can only occupy one slot at a time.
					 		Unsnappable = If true, client will prevent snapping to this position.
					 	};
					 	-- And you would add more depending on how many snaps you want.
					 }
		SnapOnly = If true, the bench can only be placed when snapped onto another bench.
		AttachmentChecks = All raycast checks used to determine which benches are connected to which, allowing for stability calculations.
		NextConnections = A list of all attachment indexes the bench will use to check for benches "ahead" during stability loop
		RotateIgnores = A list of all attachment indexes that are ignored while checking stability when the bench is rotated with a Hammer
		WallBlockOffset = If present, will spawn a Wall Block (prevents builds temporarily) at this offset
		PlaceExtraDistance = If present, will change the default place distance by this amount
		MeleeResistance = If present, multiplier applied to melee weapon damage for this bench
		FireDamageMults = Increases fire damage dealt to this bench based on the Fire's type.
	}
	
	SLOTTYPE DOCUMENTATION:
	All current available SlotTypes are:
		Default = Accepts any item into the slot
		Output = No items can be added to the slot
		FuelWood = Only Wood Logs are accepted into the slot
		Resources = Only accepts items whos types are set to Resource
		InputCampfire = Only items with an available LootTable inside Smelt.Campfire are accepted
		InputFurnace = Only items with an available LootTable inside Smelt.Furnace are accepted
		InputPetroleum = Only items what available LootTable inside Smelt.PetroleumRefinery are accepted
		InputShredder = Only items with a valid recipe are accepted
		InputCaps = Only Bottle Caps are accepted
		InputPowerCell = Only Power Cells are accepted
		InputRepair = Only tools, guns, benches, armors, and attachments with a crafting recipe and durability are accepted
		BuildingTools = Only accepts Hammers or Blueprints
		Shotgun = Only accepts Buckshot/Combustive Buckshot
]]


-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Folders
local Modules = Replicated:WaitForChild("Modules")
local Benches = Replicated:WaitForChild("Benches")
local Values = Replicated:WaitForChild("Values")
local VFX_PARTS = workspace:WaitForChild("VFX")

-- Modules
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"))

-- Local Variables
local Player = Players.LocalPlayer
local BenchInfo
local hitPlaceFilterFunc = RaycastUtil:FilterFunction("HitPlace")

-- Functions
local function DefaultPlaceFunc(benchName, mouseHit, placeAngle, placedOn)
	local benchInfo = BenchInfo[benchName]
	if not benchInfo then return end
	local angles = benchInfo.PlaceableAngles
	local placeBlacklist = benchInfo.PlaceBlacklist
	local placeWhitelist = benchInfo.PlaceWhitelist
	local canPlace = (mouseHit ~= nil and placeAngle >= angles.Min and placeAngle <= angles.Max and placedOn ~= nil and placedOn == mouseHit and placedOn.Parent:GetAttribute("Open") == nil and placedOn.Parent.Parent:GetAttribute("Open") == nil)
	if canPlace and (placeBlacklist or placeWhitelist) then
		local parent = placedOn.Parent
		local placedOnModel = ((parent:IsA("Model") and parent.Parent ~= game and parent.Parent:IsA("Model") and parent.Name ~= "_Floor") and parent.Parent or parent)
		local hitModel = parent
		local isTerrain = (placedOn.Name == "Terrain")
		if placeWhitelist and ((isTerrain and not table.find(placeWhitelist, "Terrain")) or (isTerrain == false and not table.find(placeWhitelist, placedOnModel.Name))) then
			return false
		elseif placeBlacklist and ((isTerrain and table.find(placeBlacklist, "Terrain")) or (isTerrain == false and table.find(placeBlacklist, placedOnModel.Name))) then
			return false
		end
	end
	return canPlace
end

local function FoundationPlaceFunc()
	return true
end

local function NonBaseCollision(bench, from, useStorage)
	local prim = bench.PrimaryPart																		
	local storageBench = Benches:FindFirstChild(bench.Name)
	--print("doing")
	if storageBench and storageBench:IsA("Model") and prim then
		local storagePrim = storageBench:FindFirstChild("Main")
		local nonBaseCollisions = (useStorage and storageBench or bench):FindFirstChild("NonBaseCollisionParts")
		if nonBaseCollisions and storagePrim then
			local baseFrom = (from and from:FindFirstAncestor("Base"))
			local overlapParams = OverlapParams.new()
			overlapParams.FilterType = Enum.RaycastFilterType.Exclude
			overlapParams.FilterDescendantsInstances = {VFX_PARTS, bench}
			for _, collisionPart in pairs(nonBaseCollisions:GetChildren()) do
				if not collisionPart:IsA("BasePart") then continue end
				local deletePart
				if useStorage then
					deletePart = collisionPart:Clone()
					deletePart.Transparency = 1
					deletePart.CanCollide = false
					deletePart.CanQuery = false
					deletePart.Parent = VFX_PARTS
					deletePart.CFrame = prim.CFrame * storagePrim.CFrame:ToObjectSpace(collisionPart.CFrame)
				end
				local parts = workspace:GetPartsInPart(deletePart or collisionPart, overlapParams)
				if deletePart then
					deletePart:Destroy()
				end
				--[[print("did", parts, #parts)
				local regionPart = Instance.new("Part")
				regionPart.Parent = VFX_PARTS
				regionPart.Anchored = true
				regionPart.CanCollide = false
				regionPart.BrickColor = BrickColor.new("Bright red")
				regionPart.Transparency = 0.5
				regionPart.CFrame = collisionPart.CFrame
				regionPart.Size = collisionPart.Size
				Debris:AddItem(regionPart, 0.1)]]
				for _, part in pairs(parts) do
					local hitBase = part:FindFirstAncestor("Base")
					if (not hitBase) or hitBase == baseFrom then continue end
					return false
				end
			end
		end
	end
	return true
end

local function DefaultCollisionFunc(bench, doNonBase, from)
	if doNonBase and not NonBaseCollision(bench, from) then
		return false
	end
	local rayParts = bench:FindFirstChild("RayParts")
	if rayParts then
		for _, rayPart in pairs(rayParts:GetChildren()) do
			local cf = rayPart.CFrame
			local size = rayPart.Size
			for i = -1, 1, 2 do
				local startPos = (cf * CFrame.new(0, 0, -size.Z / 2 * i)).Position
				local endPos = (cf * CFrame.new(0, 0, size.Z / 2 * i)).Position
				local hit = RaycastUtil:Raycast(startPos, endPos - startPos, "Whitelist", workspace.Terrain)
				if not hit then continue end
				return false
			end
		end
	end
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = {VFX_PARTS}
	local baseCollisionParts = bench:FindFirstChild("BaseCollisionParts")
	if baseCollisionParts then
		for _, collisionPart in pairs(baseCollisionParts:GetChildren()) do
			if not collisionPart:IsA("BasePart") then continue end
			--[[local cf = collisionPart.CFrame
			local size = collisionPart.Size
			local parts = workspace:GetPartBoundsInBox(cf, size, overlapParams)]]
			local parts = workspace:GetPartsInPart(collisionPart, overlapParams)
			for _, part in pairs(parts) do
				local parent = part.Parent
				if parent.Name ~= "CollisionParts" then continue end
				local base = part:FindFirstAncestor("Base")
				if not base then continue end
				local benchInfo = BenchInfo[parent.Parent.Name]
				if not (benchInfo and benchInfo.Type == "BasePart") then continue end
				--print("base collision", part)
				return false
			end
		end
	end
	local collisionParts = bench:FindFirstChild("CollisionParts")
	if collisionParts then
		
		for _, collisionPart in pairs(collisionParts:GetChildren()) do
			if not collisionPart:IsA("BasePart") then continue end
			local cf = collisionPart.CFrame
			local size = collisionPart.Size
			
			--[[local regionPart = Instance.new("Part")
			regionPart.Parent = VFX_PARTS
			regionPart.Anchored = true
			regionPart.CanCollide = false
			regionPart.BrickColor = BrickColor.new("Bright red")
			regionPart.Transparency = 0.5
			regionPart.CFrame = cf
			regionPart.Size = size
			Debris:AddItem(regionPart, 0.1)]]
			
			--local isSpecialPart = (collisionPart.ClassName ~= "Part" or collisionPart.Shape ~= Enum.PartType.Block)
			local parts = workspace:GetPartsInPart(collisionPart, overlapParams)--(isSpecialPart and workspace:GetPartsInPart(collisionPart, overlapParams) or workspace:GetPartBoundsInBox(cf, size, overlapParams))
			for _, part in pairs(parts) do
				if hitPlaceFilterFunc(part) then continue end
				if collisionPart:GetAttribute("SameOnly") and part:GetAttribute("SameOnly") then continue end
				if (collisionPart:GetAttribute("IgnoreFloorFrame") and part:GetAttribute("IgnoreLargeFurnace")) or (part:GetAttribute("IgnoreFloorFrame") and collisionPart:GetAttribute("IgnoreLargeFurnace")) then continue end
				if Players.LocalPlayer and StarterGui:GetCore("DevConsoleVisible") then
					print(part:GetFullName())
				end
				--print("normal collision", part)
				return false
			end
		end
	end
	return true
end

local function FoundationCollisionFunc(...)
	local args = {...}
	local bench = args[1]
	for _, pole in pairs(bench:GetChildren()) do
		if pole.Name ~= "Pole" then continue end
		local cf = pole.CFrame
		local size = pole.Size
		local startPos = (cf * CFrame.new(0, size.Y / 2.4, 0)).Position
		local endPos = (cf * CFrame.new(0, -size.Y / 2.1, 0)).Position
		local hit = RaycastUtil:Raycast(startPos, endPos - startPos, "Blacklist", {VFX_PARTS}, false, hitPlaceFilterFunc, true)
		if not (hit and hit == workspace.Terrain) then return false end
	end
	return DefaultCollisionFunc(...)
end

local function CreateSnaps(loopCount, loopFunc)
	local snaps = {}
	for i = 1, loopCount do
		local offset, benchNames, attachmentIndex, unsnap = loopFunc(i)
		table.insert(snaps, {
			BenchNames = benchNames;
			Offset = offset;
			AttachmentIndex = attachmentIndex;
			Unsnappable = unsnap;
		})
	end
	return snaps
end

local function CreateChecks(loopCount, loopFunc)
	local checks = {}
	for i = 1, loopCount do
		local offsets, lengths, attachmentIndex = loopFunc(i)
		local check = {
			AttachmentIndex = attachmentIndex;
			Rays = {}
		}
		for index, offset in pairs(offsets) do
			table.insert(check.Rays, {
				Offset = offset;
				Length = lengths[index];
			})
		end
		table.insert(checks, check)
	end
	return checks
end

-- Local Variables
local Wall = {
	SnapPoints = {
		-- FLOORS/FOUNDATION
		{
			BenchNames = {"Foundation", "Floor", "Floor Frame"};
			Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(0, 5, 5);
			AttachmentIndex = 5;
		};
		{
			BenchNames = {"Foundation", "Floor", "Floor Frame"};
			Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, 5, 5);
			AttachmentIndex = 6;
		};
		{
			BenchNames = {"Foundation", "Floor", "Floor Frame"};
			Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, 5, 5);
			AttachmentIndex = 7;
		};
		{
			BenchNames = {"Foundation", "Floor", "Floor Frame"};
			Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(0, 5, 5);
			AttachmentIndex = 8;
		};

		-- TRIANGLE FOUNDATION
		{
			BenchNames = {"Triangle Foundation", "Triangle Floor", "Triangle Floor Frame"};
			Offset = CFrame.new(-5, 0, 4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1);
			AttachmentIndex = 4;
		};
		{
			BenchNames = {"Triangle Foundation", "Triangle Floor", "Triangle Floor Frame"};
			Offset = CFrame.new(-5, 2.5, 0, 0, -1, 0, -0.5, 0, 0.866, -0.866, 0, -0.5);
			AttachmentIndex = 5;
		};
		{
			BenchNames = {"Triangle Foundation", "Triangle Floor", "Triangle Floor Frame"};
			Offset = CFrame.new(-5, -2.5, 0, 0, -1, 0, -0.5, 0, -0.866, 0.866, 0, -0.5);
			AttachmentIndex = 6;
		};

		-- WALLS
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
			Offset = CFrame.new(0, 10, 0);
			AttachmentIndex = 3;
		};

		-- HALF WALL
		{
			BenchNames = {"Half Wall"};
			Offset = CFrame.new(0, 7.5, 0);
			AttachmentIndex = 3;
		};
	};
	AttachmentChecks = {
		{
			BenchNames = {"Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame"};
			MaxRange = 13;
			Checks = {
				{
					AttachmentIndex = 1;
					Rays = {
						{
							Offset = CFrame.new(4, -4.3, 0.6) * CFrame.Angles(math.rad(-90), 0, 0);
							Length = 0.4;
						};
						{
							Offset = CFrame.new(-4, -4.3, 0.6) * CFrame.Angles(math.rad(-90), 0, 0);
							Length = 0.4;
						};
					}
				};
				{
					AttachmentIndex = 2;
					Rays = {
						{
							Offset = CFrame.new(4, -4.3, -0.6) * CFrame.Angles(math.rad(-90), 0, 0);
							Length = 0.4;
						};
						{
							Offset = CFrame.new(-4, -4.3, -0.6) * CFrame.Angles(math.rad(-90), 0, 0);
							Length = 0.4;
						};
					}
				};
			}
		};
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window", "Half Wall"};
			MaxRange = 13;
			Checks = {
				{
					AttachmentIndex = 3;
					Rays = {{
						Offset = CFrame.new(0, 4.8, 0) * CFrame.Angles(math.rad(90), 0, 0);
						Length = 0.4;
					}}
				};

				{
					AttachmentIndex = 4;
					Rays = {{
						Offset = CFrame.new(0, -4.8, 0) * CFrame.Angles(math.rad(-90), 0, 0);
						Length = 0.4;
					}}
				};

				{
					AttachmentIndex = 5;
					Rays = {
						{
							Offset = CFrame.new(-5.6, -2.5, 0.6) * CFrame.Angles(math.rad(0), 0, 0);
							Length = 0.2;
						};
						{
							Offset = CFrame.new(-5.6, -2.5, -0.6) * CFrame.Angles(math.rad(180), 0, 0);
							Length = 0.2;
						};
					}
				};
				{
					AttachmentIndex = 6;
					Rays = {
						{
							Offset = CFrame.new(-5.6, 2.5, 0.6) * CFrame.Angles(math.rad(0), 0, 0);
							Length = 0.2;
						};
						{
							Offset = CFrame.new(-5.6, 2.5, -0.6) * CFrame.Angles(math.rad(180), 0, 0);
							Length = 0.2;
						};
					}
				};
				{
					AttachmentIndex = 7;
					Rays = {
						{
							Offset = CFrame.new(5.6, -2.5, 0.6) * CFrame.Angles(math.rad(0), 0, 0);
							Length = 0.2;
						};
						{
							Offset = CFrame.new(5.6, -2.5, -0.6) * CFrame.Angles(math.rad(180), 0, 0);
							Length = 0.2;
						};
					}
				};
				{
					AttachmentIndex = 8;
					Rays = {
						{
							Offset = CFrame.new(5.6, 2.5, 0.6) * CFrame.Angles(math.rad(0), 0, 0);
							Length = 0.2;
						};
						{
							Offset = CFrame.new(5.6, 2.5, -0.6) * CFrame.Angles(math.rad(180), 0, 0);
							Length = 0.2;
						};
					}
				};
			}
		};
		{
			BenchNames = {"Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame"};
			MaxRange = 9;
			Checks = {
				{
					AttachmentIndex = 9;
					Rays = {
						{
							Offset = CFrame.new(4, 4.3, 0.6) * CFrame.Angles(math.rad(90), 0, 0);
							Length = 0.4;
						};
						{
							Offset = CFrame.new(-4, 4.3, 0.6) * CFrame.Angles(math.rad(90), 0, 0);
							Length = 0.4;
						};
					}
				};
				{
					AttachmentIndex = 10;
					Rays = {
						{
							Offset = CFrame.new(4, 4.3, -0.6) * CFrame.Angles(math.rad(90), 0, 0);
							Length = 0.4;
						};
						{
							Offset = CFrame.new(-4, 4.3, -0.6) * CFrame.Angles(math.rad(90), 0, 0);
							Length = 0.4;
						};
					}
				};

				{
					AttachmentIndex = 11;
					Rays = {
						{
							Offset = CFrame.new(4, -0.7, 0.6) * CFrame.Angles(math.rad(90), 0, 0);
							Length = 0.4;
						};
						{
							Offset = CFrame.new(-4, -0.7, 0.6) * CFrame.Angles(math.rad(90), 0, 0);
							Length = 0.4;
						};
					}
				};
				{
					AttachmentIndex = 12;
					Rays = {
						{
							Offset = CFrame.new(4, -0.7, -0.6) * CFrame.Angles(math.rad(90), 0, 0);
							Length = 0.4;
						};
						{
							Offset = CFrame.new(-4, -0.7, -0.6) * CFrame.Angles(math.rad(90), 0, 0);
							Length = 0.4;
						};
					}
				};
			}
		};
	};
	StabilityInfo = {
		LossPerHeight = {
			Start = 0;
			PerStud = 1;
		};
		Checks = {
			{
				Connections = {4};
				StabilityLoss = {0};
			};
			{
				Connections = {1, 2};
				StabilityLoss = {0, 0};
				BenchNames = {"Foundation", "Triangle Foundation"};
			};
			{
				Connections = {1, 2};
				StabilityLoss = {20, 10};
			};
			{
				Connections = {5, 6, 7, 8};
				StabilityLoss = {75, 60, 45, 40};
			};
		}
	};
	NextConnections = {1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12};
}
local Floor = {
	SnapPoints = {
		-- FLOORS
		{
			BenchNames = {"Floor", "Floor Frame"};
			Offset = CFrame.new(0, 0, 10);
			AttachmentIndex = 1;
		};
		{
			BenchNames = {"Floor", "Floor Frame"};
			Offset = CFrame.new(0, 0, -10);
			AttachmentIndex = 2;
		};
		{
			BenchNames = {"Floor", "Floor Frame"};
			Offset = CFrame.new(10, 0, 0);
			AttachmentIndex = 3;
		};
		{
			BenchNames = {"Floor", "Floor Frame"};
			Offset = CFrame.new(-10, 0, 0);
			AttachmentIndex = 4;
		};

		-- TRIANGLE FLOORS
		{
			BenchNames = {"Triangle Floor", "Triangle Floor Frame"};
			Offset = CFrame.new(0, 0, 9.333, 0, -1, 0, 0, 0, 1, -1, 0, 0);
			AttachmentIndex = 1;
		};
		{
			BenchNames = {"Triangle Floor", "Triangle Floor Frame"};
			Offset = CFrame.new(0, 6.83, -2.497, 0, -1, 0, 0.5, 0, -0.866, 0.866, 0, 0.5);
			AttachmentIndex = 2;
		};
		{
			BenchNames = {"Triangle Floor", "Triangle Floor Frame"};
			Offset = CFrame.new(0, -6.83, -2.497, 0, -1, 0, 0.866, 0, -0.5, 0.5, 0, 0.866);
			AttachmentIndex = 3;
		};

		-- WALLS
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
			Offset = CFrame.new(0, 5, 5);
			AttachmentIndex = 9;
		};
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
			Offset = CFrame.new(0, 5, -5);
			AttachmentIndex = 10;
		};
		--[[
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
			Offset = CFrame.new(0, 0, 5);
			AttachmentIndex = 11;
		};
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
			Offset = CFrame.new(0, 0, -5);
			AttachmentIndex = 12;
		};]]

		-- HALF WALL
		{
			BenchNames = {"Half Wall"};
			Offset = CFrame.new(0, 2.5, 5);
			AttachmentIndex = 9;
		};
		{
			BenchNames = {"Half Wall"};
			Offset = CFrame.new(0, 2.5, -5);
			AttachmentIndex = 10;
		};
	};
	AttachmentChecks = {
		{
			BenchNames = {"Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame"};
			MaxRange = 11;
			Checks = {
				{
					AttachmentIndex = 1;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(4, 0, -4.4);
							Length = 0.7;
						};
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-4, 0, -4.4);
							Length = 0.7;
						};
					}
				};
				{
					AttachmentIndex = 2;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(4, 0, -4.4);
							Length = 0.7;
						};
						{
							Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(-4, 0, -4.4);
							Length = 0.7;
						};
					}
				};
				{
					AttachmentIndex = 3;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(4, 0, -4.4);
							Length = 0.7;
						};
						{
							Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4, 0, -4.4);
							Length = 0.7;
						};
					}
				};
				{
					AttachmentIndex = 4;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4, 0, -4.4);
							Length = 0.7;
						};
						{
							Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-4, 0, -4.4);
							Length = 0.7;
						};
					}
				};
			}
		};
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window", "Half Wall", "Low Wall", "Wall Block"};
			MaxRange = 9;
			Checks = {
				{
					AttachmentIndex = 5;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(4, 0.6, -4.3);
							Length = 0.4;
						};
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-4, 0.6, -4.3);
							Length = 0.4;
						};
					}
				};
				{
					AttachmentIndex = 6;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(4, 0.6, -4.3);
							Length = 0.4;
						};
						{
							Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(-4, 0.6, -4.3);
							Length = 0.4;
						};
					}
				};
				{
					AttachmentIndex = 7;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(4, 0.6, -4.3);
							Length = 0.4;
						};
						{
							Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4, 0.6, -4.3);
							Length = 0.4;
						};
					}
				};
				{
					AttachmentIndex = 8;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4, 0.6, -4.3);
							Length = 0.4;
						};
						{
							Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-4, 0.6, -4.3);
							Length = 0.4;
						};
					}
				};

				{
					AttachmentIndex = 9;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(4, -0.6, -4.3);
							Length = 0.4;
						};
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-4, -0.6, -4.3);
							Length = 0.4;
						};
					}
				};
				{
					AttachmentIndex = 10;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(4, -0.6, -4.3);
							Length = 0.4;
						};
						{
							Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(-4, -0.6, -4.3);
							Length = 0.4;
						};
					}
				};
				{
					AttachmentIndex = 11;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(4, -0.6, -4.3);
							Length = 0.4;
						};
						{
							Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4, -0.6, -4.3);
							Length = 0.4;
						};
					}
				};
				{
					AttachmentIndex = 12;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4, -0.6, -4.3);
							Length = 0.4;
						};
						{
							Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-4, -0.6, -4.3);
							Length = 0.4;
						};
					}
				};
			}
		};
	};
	StabilityInfo = {
		Checks = {
			{
				Connections = {9, 10, 11, 12};
				StabilityLoss = {15, 8, 4, 0};
			};
			{
				Connections = {1, 2, 3, 4};
				StabilityLoss = {75, 25, 10, 5};
			};
		}
	};
	NextConnections = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
}
local TriangleFloor = {
	SnapPoints = {
		-- TRIANGLE FLOORS
		{
			BenchNames = {"Triangle Floor", "Triangle Floor Frame"};
			Offset = CFrame.new(0, 0, 8.666, 1, 0, 0, 0, -1, 0, 0, 0, -1);
			AttachmentIndex = 1;
		};
		{
			BenchNames = {"Triangle Floor", "Triangle Floor Frame"};
			Offset = CFrame.new(0, 3.748, -2.167, 1, 0, 0, 0, 0.5, 0.866, 0, -0.866, 0.5);
			AttachmentIndex = 2;
		};
		{
			BenchNames = {"Triangle Floor", "Triangle Floor Frame"};
			Offset = CFrame.new(0, -3.748, -2.167, 1, 0, 0, 0, 0.5, -0.866, 0, 0.866, 0.5);
			AttachmentIndex = 3;
		};

		-- FLOORS
		{
			BenchNames = {"Floor", "Floor Frame"};
			Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, 0, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1);
			AttachmentIndex = 1;
		};
		{
			BenchNames = {"Floor", "Floor Frame"};
			Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(0, 0, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1);
			AttachmentIndex = 2;
		};
		{
			BenchNames = {"Floor", "Floor Frame"};
			Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(0, 0, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1);
			AttachmentIndex = 3;
		};
		{
			BenchNames = {"Floor", "Floor Frame"};
			Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, 0, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1);
			AttachmentIndex = 4;
		};

		-- WALLS
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
			Offset = CFrame.new(0, 5, 4.333, 0, 1, 0, 1, 0, 0, 0, 0, -1) * CFrame.Angles(0, 0, math.rad(180));
			AttachmentIndex = 9;
		};
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
			Offset = CFrame.new(0, 5, -4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1) * CFrame.Angles(0, 0, math.rad(180));
			AttachmentIndex = 10;
		};

		--[[{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
			Offset = CFrame.new(0, 0, 4.333, 0, 1, 0, 1, 0, 0, 0, 0, -1) * CFrame.Angles(0, 0, math.rad(180));
			AttachmentIndex = 11;
		};
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
			Offset = CFrame.new(0, 0, -4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1) * CFrame.Angles(0, 0, math.rad(180));
			AttachmentIndex = 12;
		};]]

		-- HALF WALL
		{
			BenchNames = {"Half Wall"};
			Offset = CFrame.new(0, 2.5, 4.333, 0, 1, 0, 1, 0, 0, 0, 0, -1) * CFrame.Angles(0, 0, math.rad(180));
			AttachmentIndex = 9;
		};
		{
			BenchNames = {"Half Wall"};
			Offset = CFrame.new(0, 2.5, -4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1) * CFrame.Angles(0, 0, math.rad(180));
			AttachmentIndex = 10;
		};
	};
	AttachmentChecks = {
		{
			BenchNames = {"Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame"};
			MaxRange = 9;
			Checks = {
				{
					AttachmentIndex = 1;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, -4, -4.1);
							Length = 0.6;
						};
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, -4, -4.1);
							Length = 0.6;
						};
					}
				};
				{
					AttachmentIndex = 2;
					Rays = {
						{
							Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(0, 5, -1.9);
							Length = 0.6;
						};
						{
							Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(0, -2.6, -1.9);
							Length = 0.6;
						};
					}
				};
				{
					AttachmentIndex = 3;
					Rays = {
						{
							Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(0, -5, -1.9);
							Length = 0.6;
						};
						{
							Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(0, 2.6, -1.9);
							Length = 0.6;
						};
					}
				};
			}
		};
		{
			BenchNames = {"Wall", "Wall Frame", "Doorway", "Window", "Half Wall", "Low Wall", "Wall Block"};
			MaxRange = 9;
			Checks = {
				{
					AttachmentIndex = 4;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0.6, 4, -3.6);
							Length = 0.6;
						};
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0.6, -4, -3.6);
							Length = 0.6;
						};
					}
				};
				{
					AttachmentIndex = 5;
					Rays = {
						{
							Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(-0.6, 5, -1.6);
							Length = 0.6;
						};
						{
							Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(-0.6, -2.6, -1.6);
							Length = 0.6;
						};
					}
				};
				{
					AttachmentIndex = 6;
					Rays = {
						{
							Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(-0.6, -5, -1.6);
							Length = 0.6;
						};
						{
							Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(-0.6, 2.6, -1.6);
							Length = 0.6;
						};
					}
				};

				{
					AttachmentIndex = 7;
					Rays = {
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-0.6, 4, -3.6);
							Length = 0.6;
						};
						{
							Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-0.6, -4, -3.6);
							Length = 0.6;
						};
					}
				};
				{
					AttachmentIndex = 8;
					Rays = {
						{
							Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(0.6, 5, -1.6);
							Length = 0.6;
						};
						{
							Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(0.6, -2.6, -1.6);
							Length = 0.6;
						};
					}
				};
				{
					AttachmentIndex = 9;
					Rays = {
						{
							Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(0.6, -5, -1.6);
							Length = 0.6;
						};
						{
							Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(0.6, 2.6, -1.6);
							Length = 0.6;
						};
					}
				};
			}
		};
	};
	StabilityInfo = {
		Checks = {
			{
				Connections = {7, 8, 9};
				StabilityLoss = {12, 5, 0};
			};
			{
				Connections = {1, 2, 3};
				StabilityLoss = {55, 16, 4};
			};
		}
	};
	NextConnections = {1, 2, 3, 4, 5, 6, 7, 8, 9};
}
local Stairs = {
	SnapPoints = {
		{
			BenchNames = {"Foundation"};
			Offset = CFrame.new(0, 5, 0);
			AttachmentIndex = 9;
		};
		{
			BenchNames = {"Floor"};
			Offset = CFrame.new(0, 5, 0);
			AttachmentIndex = 13;
		};
	};
	AttachmentChecks = {{
		BenchNames = {"Foundation", "Floor"};
		MaxRange = 13;
		Checks = {{
			AttachmentIndex = 1;
			Rays = {{
				Offset = CFrame.new(0, -4.3, 0) * CFrame.Angles(math.rad(-90), 0, 0);
				Length = 0.4;
			}};
		}};
	}};
	StabilityInfo = {
		Checks = {{
			Connections = {1};
			StabilityLoss = {4};
		}};
	};
	NextConnections = {};
}

BenchInfo = {
	-- BENCHES
	["Campfire"] = {
		Type = "Campfire";
		TypeArguments = function()
			return {
				UI = "Campfire";
				Slots = {"FuelWood", "InputCampfire", "Output", "Output"}; -- 4 TOTAL: 1 Fuel, 1 Input, 2 Output
				LootTable = {"Benches", "Campfire"}; -- 50 Wood Logs
				IgnoreGatherMult = true;
				ResizeDynamically = false;
				CombineItems = true;
				FuelMult = 1; -- 6 Wood / min
				InputMult = 1;
				Comfort = 50; --Max comfort one bench will give
				Heat = 6; --Amount of heat the fire gives off
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 2, 0);
		Offset = CFrame.Angles(math.rad(-90), 0, 0) * CFrame.new(0, 0.4, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = .5;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	["Cooking Pot"] = {
		Type = "Campfire";
		TypeArguments = function()
			return {
				UI = "Furnace";
				Slots = {"FuelWood", "InputCampfire", "InputCampfire", "Output", "Output", "Output"}; -- 6 TOTAL: 1 Fuel, 2 Input, 3 Output
				LootTable = {"Benches", "Campfire"}; -- 50 Wood Logs
				IgnoreGatherMult = true;
				ResizeDynamically = false;
				CombineItems = true;
				FuelMult = 1; -- 6 Wood / min
				InputMult = 0.5;
				Comfort = 50; --Max comfort one bench will give
				Heat = 6; --Amount of heat the fire gives off
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 2, 0);
		Offset = CFrame.Angles(math.rad(-90), 0, 0) * CFrame.new(0, 0.4, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 0.5;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};

	["Furnace"] = {
		Type = "Campfire";
		TypeArguments = function()
			return {
				UI = "Furnace";
				Slots = {"FuelWood", "InputFurnace", "InputFurnace", "Output", "Output", "Output"}; -- 6 TOTAL: 1 Fuel, 2 Input, 3 Output
				ResizeDynamically = false;
				FuelMult = 0.2; -- 30 Wood / min
				InputMult = 1;
				Comfort = 5; --Max comfort one bench will give
				Heat = 3; --Amount of heat the fire gives off
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 2, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(180), 0) * CFrame.new(0, 2.5, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 2.7;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	["Large Furnace"] = {
		Type = "Campfire";
		TypeArguments = function()
			return {
				UI = "LargeFurnace";
				Slots = {"FuelWood", "FuelWood", "InputFurnace", "InputFurnace", "InputFurnace", "InputFurnace", "InputFurnace", "Output", "Output", "Output", "Output", "Output", "Output", "Output", "Output", "Output", "Output"}; -- 17 TOTAL: 2 Fuel, 5 Input, 10 Output
				ResizeDynamically = false;
				FuelMult = 0.2; -- 30 Wood / min
				InputMult = 1;
				Comfort = 10; --Max comfort one bench will give
				Heat = 5; --Amount of heat the fire gives off
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 8.8, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 20;
		};
		RayCheckLength = 9;
		PlaceExtraDistance = 5;
		InteractDistance = 11;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	["Blast Furnace"] = {
		Type = "Campfire";
		TypeArguments = function()
			return {
				UI = "BlastFurnace";
				Slots = {"FuelWood", "InputFurnace", "InputFurnace", "InputFurnace", "InputFurnace", "Output", "Output", "Output", "Output", "Output"}; -- 9 TOTAL: 1 Fuel, 4 Input, 5 Output
				ResizeDynamically = false;
				FuelMult = 0.15; -- 40 Wood / min
				InputMult = 0.75;
				Comfort = 5; --Max comfort one bench will give
				Heat = 5; --Amount of heat the fire gives off
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 3.2, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 20;
		};
		RayCheckLength = 4.75;
		PlaceExtraDistance = 5;
		InteractDistance = 11;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	["Petroleum Refinery"] = {
		Type = "Campfire";
		TypeArguments = function()
			return {
				UI = "Refinery";
				Slots = {"FuelWood", "InputPetroleum", "Output", "Output", "Output"}; -- 5 TOTAL: 1 Fuel, 1 Input, 3 Output
				ResizeDynamically = false;
				FuelMult = 0.15; -- 40 Wood / min
				InputMult = 1;
				Comfort = 5; --Max comfort one bench will give
				Heat = 2; --Amount of heat the fire gives off
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 4.55, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 30;
		};
		RayCheckLength = 4.7;
		PlaceExtraDistance = 2;
		InteractDistance = 8;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};

	["Base Cabinet"] = {
		Type = "BaseCabinet";
		TypeArguments = function()
			return {
				UI = "Base Cabinet";
				Slots = {"Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "BuildingTools", "BuildingTools"}; -- 26 TOTAL: 24 Resources, 2 BuildingTools
				ResizeDynamically = false;
			}
		end;
		ClientFunction = function(benchModel)
			local activeBenches = shared.ActiveBenches
			if not activeBenches then return end
			local bench = activeBenches[benchModel]
			if not bench then return end
			if bench.Access then
				return "OPEN", 3
			end
		end;
		DecayType = "Never";
		DamageType = "Wood";
		MeleeResistance = 0.4;
		FireDamageMults = {
			["Combustive Arrow"] = 7.5;
			["Combustive Rocket"] = 2;
			["Bullet"] = 2;
		};
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 3.2, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 5;
		};
		RayCheckLength = 3.4;
		FaceCamera = true;
		RotateOnSurface = true;
		MaxPerBase = 1;
		PlaceWhitelist = {"Foundation", "Triangle Foundation", "Floor", "Triangle Floor"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	
	["Anvil"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "CraftingStation";
				Slots = {};
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.25, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(90), 0) * CFrame.new(0, 1.2, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 1.3;
		PlaceExtraDistance = 1;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	["Chemistry Lab"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "CraftingStation";
				Slots = {};
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.5, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(180), 0) * CFrame.new(0, 1.9, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 2;
		PlaceExtraDistance = 1;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	["Carpentry Table"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "CraftingStation";
				Slots = {};
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.25, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(180), 0) * CFrame.new(0, 1.3, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 1.4;
		PlaceExtraDistance = 2;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	["Sewing Table"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "CraftingStation";
				Slots = {};
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.25, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 1.3, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 1.4;
		PlaceExtraDistance = 1;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	["Ammo Press"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "CraftingStation";
				Slots = {};
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.25, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 0.9, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 1;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	["Culinary Table"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "CraftingStation";
				Slots = {};
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.25, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 1.25, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 1.35;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};

	["Sleeping Bag"] = {
		Type = "Bed";
		TypeArguments = function()
			return {
				Timer = 300;
			}
		end;
		ClientFunction = function(benchModel)
			local activeBenches = shared.ActiveBenches
			if not activeBenches then return end
			local bench = activeBenches[benchModel]
			if not bench then return end
			if bench.Owned then
				return "RENAME BED", 2
			end
		end;
		DecayType = "Never";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(180), 0) * CFrame.new(0, 0.26, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		RayCheckLength = 0.35;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	
	["Bed"] = {
		Type = "Bed";
		TypeArguments = function()
			return {
				Timer = 120;
			}
		end;
		ClientFunction = function(benchModel)
			local activeBenches = shared.ActiveBenches
			if not activeBenches then return end
			local bench = activeBenches[benchModel]
			if not bench then return end
			if bench.Owned then
				return "RENAME BED", 2
			end
		end;
		DecayType = "Never";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(0), 0) * CFrame.new(0, 1.8, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		RayCheckLength = 1.9;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Foundation", "Triangle Foundation", "Floor", "Triangle Floor"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		InteractDistance = 7;
		PlaceExtraDistance = 2;
	};

	["Small Storage Box"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "Container12";
				Slots = table.create(12, "Default"); -- 12 TOTAL: 12 Default
				ResizeDynamically = false;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(180), 0) * CFrame.new(0, 0.95, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 1.1;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		DurabilityDecrease = 0.25;
	};

	["Large Storage Box"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "Container30";
				Slots = table.create(30, "Default"); -- 30 TOTAL: 30 Output
				ResizeDynamically = false;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(180), 0) * CFrame.new(0, 1.3, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 1.4;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		DurabilityDecrease = 0.25;
		InteractDistance = 8;
		PlaceExtraDistance = 1.5;
	};
	
	["Shotgun Turret"] = {
		Type = "Turret";
		TypeArguments = function()
			return {
				-- CONTAINER:
				UI = "Container4";
				Slots = {"Shotgun", "Shotgun"}; -- 2 TOTAL: 2 Shotgun
				ResizeDynamically = false;
				
				-- TURRET:
				Damage = 14;
				Bleed = 1;
				BulletRadius = 4;
				BulletRange = 14.25;
				DamageRange = {9, 25};
				BulletCount = 9;
				Cooldown = 0.45;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		MeleeResistance = 0.4;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), 0, 0) * CFrame.new(0, 1.21, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 180;
		};
		RayCheckLength = 1.3;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Wall", "Half Wall", "Doorway", "Window"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		DurabilityDecrease = 0.25;
		InteractDistance = 7.5;
		PlaceExtraDistance = 1.5;
	};
	
	["Bear Trap"] = {
		Type = "Trap";
		TypeArguments = function()
			return {
				Damage = 75;
				Bleed = 12;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = true;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(180), 0) * CFrame.new(0, 0.15, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 0.25;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Terrain"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		PlaceExtraDistance = 1;
	};
	
	["Landmine Trap"] = {
		Type = "Trap";
		TypeArguments = function()
			return {
				Explosive = {
					Radius = 3.5;
					HumanoidMaxDamage = 120;
					SoftSideMult = 1;
					DamagePrefix = "";
					HumanoidOnly = true;
					ShakeStrength = 0.2;
					Duration = 0.15;
					SoundName = "Landmine";
				};
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = true;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(180), 0) * CFrame.new(0, 0.24, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 0.35;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Terrain"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		PlaceExtraDistance = 1;
	};
	
	["Storage Cabinet"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "Container48";
				Slots = table.create(48, "Default"); -- 48 TOTAL: 48 Output
				ResizeDynamically = false;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 4, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		RayCheckLength = 4.1;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		DurabilityDecrease = 0.25;
		InteractDistance = 8;
		PlaceExtraDistance = 2;
	};
	
	["Christmas Tree"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "Container12";
				Slots = table.create(12, "Default"); -- 12 TOTAL: 12 Output
				ResizeDynamically = false;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 4.6, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		RayCheckLength = 5;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		DurabilityDecrease = 0.25;
		InteractDistance = 8;
		PlaceExtraDistance = 2;
	};
	
	["Repair Table"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "RepairTable";
				Slots = {"InputRepair"}; -- 1 TOTAL: 1 InputRepair
				ResizeDynamically = false;
				MaxStack = 1;
				OnePersonOnly = true;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(180), 0) * CFrame.new(0, 2.35, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 45;
		};
		RayCheckLength = 2.45;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		DurabilityDecrease = 0.25;
		InteractDistance = 7;
		PlaceExtraDistance = 2;
	};

	["External Wooden Wall"] = {
		Type = "Damager";
		TypeArguments = function()
			return {
				Damage = 15;
				Bleed = 3;
				HitTick = 0.14;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "Wood";
		MeleeResistance = 0.4;
		PickupBehavior = false;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 7.5, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		PlaceExtraDistance = 9;
		InteractDistance = 9;
		RayCheckLength = 7.75;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "_Floor"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};

	["External Wooden Gate"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 3;
				MoveFunction = function(x) -- InOutCubic
					return (x < 0.5 and 4 * x^3 or 1 - (-2 * x + 2)^3 / 2)
				end;
				Logic = "OpenDoor";
				OpenDegrees = -89;
				ChangeCollideWhenMoving = false;
				Damage = 15;
				Bleed = 3;
				HitTick = 0.14;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "Wood";
		MeleeResistance = 0.4;
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 7.5, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		PlaceExtraDistance = 10;
		InteractDistance = 16;
		RayCheckLength = 7.75;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	
	["External Stone Gate"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 3;
				MoveFunction = function(x) -- InOutCubic
					return (x < 0.5 and 4 * x^3 or 1 - (-2 * x + 2)^3 / 2)
				end;
				Logic = "OpenDoor";
				OpenDegrees = -89;
				ChangeCollideWhenMoving = false;
				Damage = 15;
				Bleed = 3;
				HitTick = 0.14;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "Stone";
		MeleeResistance = 0.4;
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 11, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		PlaceExtraDistance = 10;
		InteractDistance = 16;
		RayCheckLength = 13;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};

	["Ladder"] = {
		Type = "Misc";
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0.5, 0);
		Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0.15, 0, 0);
		UnsnappedOffset = CFrame.Angles(0, 0, math.rad(90));
		RotateOffset = CFrame.new();
		PlaceableAngles = {
			Min = 0;
			Max = 360;
		};
		RayCheckLength = 0.25;
		RayCheckVector = "RightVector";
		FaceCamera = false;
		RotateOnSurface = true;
		PlaceBlacklist = {"Terrain", "Ladder"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		IgnoreBuildBlock = true;
	};
	
	["Wooden Spikes"] = {
		Type = "Damager";
		TypeArguments = function()
			return {
				Damage = 8;
				Bleed = 1;
				HitTick = 0.19;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 2.9, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		PlaceExtraDistance = 9;
		InteractDistance = 9;
		RayCheckLength = 3.1;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	
	["Metal Spikes"] = {
		Type = "Damager";
		TypeArguments = function()
			return {
				Damage = 8;
				Bleed = 1;
				HitTick = 0.19;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "Metal";
		PickupBehavior = "HammerOnly";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 2.9, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		PlaceExtraDistance = 9;
		InteractDistance = 9;
		RayCheckLength = 3.1;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	
	["Metal Barricade"] = {
		Type = "Misc";
		DecayType = "UnderBase";
		DamageType = "Wood";
		PickupBehavior = false;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(90), 0) * CFrame.new(0, 3.4, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		MeleeResistance = 4;
		PlaceExtraDistance = 2;
		RayCheckLength = 4;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "_Floor"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
	
	["Small Wooden Sign"] = {
		Type = "Sign";
		TypeArguments = function()
			return {
				MaxCharacters = 100;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 2, 0);
		Offset = CFrame.Angles(math.rad(180), math.rad(90), 0) * CFrame.new(0, 0, 0);
		UnsnappedOffset = CFrame.Angles(0, 0, math.rad(90));
		RotateOffset = CFrame.new();
		PlaceableAngles = {
			Min = 89;
			Max = 91;
		};
		RayCheckLength = -0.2;
		RayCheckVector = "RightVector";
		FaceCamera = false;
		RotateOnSurface = true;
		PlaceWhitelist = {"Foundation", "Triangle Foundation", "Wall", "Half Wall", "Low Wall"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		DurabilityDecrease = 0.25;
		InteractDistance = 7.5;
		PlaceExtraDistance = 1.5;
	};
	
	["Large Wooden Sign"] = {
		Type = "Sign";
		TypeArguments = function()
			return {
				MaxCharacters = 300;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "BenchWood";
		PickupBehavior = "HammerOnly";
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 4, 0);
		Offset = CFrame.Angles(math.rad(180), math.rad(90), 0) * CFrame.new(-0.1, 0, 0);
		UnsnappedOffset = CFrame.Angles(0, 0, math.rad(90));
		RotateOffset = CFrame.new();
		PlaceableAngles = {
			Min = 89;
			Max = 91;
		};
		RayCheckLength = -0.3;
		RayCheckVector = "RightVector";
		FaceCamera = false;
		RotateOnSurface = true;
		PlaceWhitelist = {"Foundation", "Triangle Foundation", "Wall", "Half Wall", "Low Wall"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		DurabilityDecrease = 0.25;
		InteractDistance = 8.5;
		PlaceExtraDistance = 2;
	};
	
	["Food Crate"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "Container12";
				Slots = table.create(12, "Output");
				LootTable = {"Benches", "Food Crate"};
				ResizeDynamically = true;
				CombineItems = true;
				DestroyOnEmpty = true;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	["Wooden Crate"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "Container12";
				Slots = table.create(30, "Output");
				LootTable = {"Benches", "Wooden Crate"};
				ResizeDynamically = true;
				CombineItems = true;
				DestroyOnEmpty = true;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	["Locked Wooden Crate"] = {
		Type = "LockedContainer";
		TypeArguments = function()
			return {
				UI = "Container30";
				Slots = table.create(30, "Output");
				LootTable = {"Benches", "Locked Wooden Crate"};
				ResizeDynamically = true;
				CombineItems = true;
				DestroyOnEmpty = true;
				Health = 15;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	["Locked Metal Crate"] = {
		Type = "LockedContainer";
		TypeArguments = function()
			return {
				UI = "Container30";
				Slots = table.create(30, "Output");
				LootTable = {"Benches", "Locked Metal Crate"};
				ResizeDynamically = true;
				CombineItems = true;
				DestroyOnEmpty = true;
				Health = 25;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	["Locked Steel Crate"] = {
		Type = "LockedContainer";
		TypeArguments = function()
			return {
				UI = "Container30";
				Slots = table.create(30, "Output");
				LootTable = {"Benches", "Locked Steel Crate"};
				ResizeDynamically = true;
				CombineItems = true;
				DestroyOnEmpty = true;
				Health = 35;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	["Care Package"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "Container30";
				Slots = table.create(30, "Output");
				LootTable = {"Benches", "Care Package"};
				ResizeDynamically = true;
				CombineItems = true;
				DestroyOnEmpty = true;
				ShuffleItems = true;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 3.5, 0);
		InteractDistance = 9;
	};
	
	["Timed Crate"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "Container30";
				Slots = table.create(30, "Output");
				LootTable = {"Benches", "Timed Crate"};
				ResizeDynamically = true;
				CombineItems = true;
				DestroyOnEmpty = true;
				ShuffleItems = true;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 3.5, 0);
		InteractDistance = 9;
	};
	
	["BTR Crate"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "Container30";
				Slots = table.create(30, "Output");
				LootTable = {"Benches", "BTR Crate"};
				ResizeDynamically = true;
				CombineItems = true;
				DestroyOnEmpty = true;
				ShuffleItems = true;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 3.5, 0);
		InteractDistance = 9;
	};
	
	["Oil Barrel"] = {
		Type = "Destroyable";
		TypeArguments = function()
			return {
				LootTable = {"Benches", "Oil Barrel"};
				Health = 20;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.5, 0);
	};
	["Trash Can"] = {
		Type = "Destroyable";
		TypeArguments = function()
			return {
				LootTable = {"Benches", "Trash Can"};
				Health = 15 + math.random(0, 1) * 5;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.5, 0);
	};
	
	["Small Gift"] = {
		Type = "Destroyable";
		TypeArguments = function()
			return {
				LootTable = {"Benches", "Small Gift"};
				Health = 15 + math.random(0, 1) * 5;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.5, 0);
	};
	
	["Medium Gift"] = {
		Type = "Destroyable";
		TypeArguments = function()
			return {
				LootTable = {"Benches", "Medium Gift"};
				Health = 20 + math.random(0, 1) * 5;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.5, 0);
	};
	
	["Large Gift"] = {
		Type = "Destroyable";
		TypeArguments = function()
			return {
				LootTable = {"Benches", "Large Gift"};
				Health = 25 + math.random(0, 1) * 5;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.5, 0);
	};
	
	["Small Egg"] = {
		Type = "Destroyable";
		TypeArguments = function()
			return {
				LootTable = {"Benches", "Small Gift"};
				Health = 15 + math.random(0, 1) * 5;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.5, 0);
	};

	["Medium Egg"] = {
		Type = "Destroyable";
		TypeArguments = function()
			return {
				LootTable = {"Benches", "Medium Gift"};
				Health = 20 + math.random(0, 1) * 5;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.5, 0);
	};

	["Large Egg"] = {
		Type = "Destroyable";
		TypeArguments = function()
			return {
				LootTable = {"Benches", "Large Gift"};
				Health = 25 + math.random(0, 1) * 5;
			}
		end;
		DamageType = "BenchBarrel";
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0.5, 0);
	};

	["Fire Barrel"] = {
		Type = "Campfire";
		TypeArguments = function()
			return {
				UI = "Campfire";
				Slots = {"FuelWood", "InputCampfire", "Output", "Output"}; -- 4 TOTAL: 1 Fuel, 1 Input, 2 Output
				LootTable = {"Benches", "Campfire"}; -- 50 Wood Logs
				IgnoreGatherMult = true;
				ResizeDynamically = false;
				CombineItems = true;
				FuelMult = 0.75; -- 8 Wood / min
				InputMult = 1;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 3, 0);
	};
	
	["Shredder"] = {
		Type = "Shredder";
		TypeArguments = function()
			return {
				UI = "Shredder";
				Slots = {"InputShredder", "InputShredder", "InputShredder", "InputShredder", "InputShredder", "Output", "Output", "Output", "Output", "Output"}; -- 10 TOTAL: 5 ShredderInput, 5 Output
				ResizeDynamically = false;
				OnePersonOnly = true;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		InteractDistance = 8;
		GuiOffset = Vector3.new(0, 0.5, 0);
	};
	
	["Plinko Machine"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "Plinko";
				Slots = {"InputCaps", "InputCaps", "InputCaps", "InputCaps", "Output"}; -- 5 TOTAL: 4 InputCaps, 1 Output
				ResizeDynamically = false;
				LocalContainer = true;
				MaxStack = 1000;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 1, 0);
	};
	
	["Power Cell Box"] = {
		Type = "PowerCell";
		TypeArguments = function()
			return {
				UI = "OneSlot";
				Slots = {"InputPowerCell"}; -- 1 TOTAL: 1 InputPowerCell
				ResizeDynamically = false;
				MaxStack = 1;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		InteractDistance = 7;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	
	["Power Button"] = {
		Type = "Button";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		InteractDistance = 7;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	
	["Door Button"] = {
		Type = "Button";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		InteractDistance = 7;
		GuiOffset = Vector3.new(0, 0, 0);
	};

	["Body Bag"] = {
		Type = "Container";
		TypeArguments = function()
			return {
				UI = "BodyLoot";
				Slots = table.create(38, "Output"); -- 38 TOTAL: 38 Output
				ResizeDynamically = false;
				DestroyOnEmpty = true;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Sounds = {
			Open = "BagOpen";
		};
	};
	
	["Sleeper"] = {
		Type = "Sleeper";
		TypeArguments = function()
			return {
				UI = "BodyLoot";
				Slots = {"Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Output", "Output", "Output", "Output", "Output", "Output", "Output"}; -- 37 TOTAL: 30 Default, 7 Output
			}
		end;
		DecayType = "Sleeper";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, -1.5, 0);
		Sounds = {
			Open = "BagOpen";
		};
	};

	["Contents"] = {
		Type = "Container";
		TypeArguments = function(benchModel)
			local lootTable
			local benchName = benchModel:GetAttribute("BenchName")
			local resize = false
			if benchName and (benchName:find("Scav Body") or benchName == "Body of Bruno") then
				lootTable = {"AI", benchName};
				resize = true
			end
			return {
				UI = "Container48";
				Slots = table.create(48, "Output"); -- 48 TOTAL: 48 Output
				LootTable = lootTable;
				ResizeDynamically = resize;
				DestroyOnEmpty = true;
			}
		end;
		DecayType = "Never";
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Sounds = {
			Open = "BagOpen";
		};
		InteractDistance = 10;
	};

	["Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 0.5;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -95;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Never";
		InteractDistance = 10;
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	["Yellow Keycard Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 1;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -95;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Never";
		InteractDistance = 0;
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	["Purple Keycard Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 1;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -95;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Never";
		InteractDistance = 0;
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	["Pink Keycard Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 1;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -95;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Never";
		InteractDistance = 0;
		PickupBehavior = false;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
	};
	["Wooden Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 0.5;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -95;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Wood";
		MeleeResistance = 0.2;
		InteractDistance = 10;
		DurabilityDecrease = 0;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Doorway"};
			Offset = CFrame.new(0, -1.75, 0);
			AttachmentIndex = 13;
		}};
		WallBlockOffset = CFrame.new(0, -2, 0);
	};
	["Salvaged Metal Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 0.5;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -95;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		InteractDistance = 10;
		DurabilityDecrease = 0;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Doorway"};
			Offset = CFrame.new(0, -1.75, 0);
			AttachmentIndex = 13;
		}};
		WallBlockOffset = CFrame.new(0, -2, 0);
	};
	
	["Metal Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 0.5;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -95;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		InteractDistance = 10;
		DurabilityDecrease = 0;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Doorway"};
			Offset = CFrame.new(0, -1.75, 0);
			AttachmentIndex = 13;
		}};
		WallBlockOffset = CFrame.new(0, -2, 0);
	};
	
	["Steel Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 0.6;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -95;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		InteractDistance = 10;
		DurabilityDecrease = 0;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Doorway"};
			Offset = CFrame.new(0, -1.75, 0);
			AttachmentIndex = 13;
		}};
		WallBlockOffset = CFrame.new(0, -2, 0);
	};
	
	["Wooden Double Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 0.5;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -89;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Wood";
		MeleeResistance = 0.2;
		InteractDistance = 10;
		DurabilityDecrease = 0;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Wall Frame"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
		WallBlockOffset = CFrame.new(0, -3.75, 0);
	};
	
	["Metal Double Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 0.5;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -89;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		InteractDistance = 10;
		DurabilityDecrease = 0;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Wall Frame"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
		WallBlockOffset = CFrame.new(0, -3.75, 0);
	};
	
	["Steel Double Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 0.6;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenDoor";
				OpenDegrees = -89;
				ChangeCollideWhenMoving = true;
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		InteractDistance = 10;
		DurabilityDecrease = 0;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Wall Frame"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
		WallBlockOffset = CFrame.new(0, -3.75, 0);
	};

	["Trap Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 1;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenHatch";
				Open = true;
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		InteractDistance = 10;
		DurabilityDecrease = 0;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Floor Frame"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
	};
	
	["Triangle Trap Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 1;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenHatch";
				Open = true;
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		InteractDistance = 10;
		DurabilityDecrease = 0;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(0, 0, math.rad(90));
		UnsnappedOffset = CFrame.Angles(0, 0, math.rad(-90));
		RotateOffset = CFrame.Angles(0, math.rad(120), 0);
		FaceCamera = false;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Triangle Floor Frame"};
			Offset = CFrame.new(0.02, 0, 1.45);
			AttachmentIndex = 10;
		}};
	};
	
	["Floor Grill"] = {
		Type = "Misc";
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		DurabilityDecrease = 0;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Floor Frame"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
	};

	["Garage Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 6;
				Logic = "OpenGarage";
				MoveFunction = function(x) -- InOutSine
					return -(math.cos(math.pi * x) - 1) / 2 * 8.672 -- this equals to 0.542 * 16 (which is the amount of garage parts it has)
				end;
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		InteractDistance = 9;
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Wall Frame"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
	};

	["Jail Door"] = {
		Type = "Door";
		TypeArguments = function()
			return {
				MoveTime = 1;
				MoveFunction = function(x) -- OutCubic
					return 1 - (1 - x)^3
				end;
				Logic = "OpenJail";
			}
		end;
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		InteractDistance = 9;
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = false;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(0, math.rad(90), 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Wall Frame"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
		WallBlockOffset = CFrame.new(0, -3.75, 0);
	};
	["Jail Wall"] = {
		Type = "Misc";
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(0, math.rad(90), 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.new();
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Wall Frame"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
		WallBlockOffset = CFrame.new(0, -3.75, 0);
	};

	["Wooden Window Bars"] = {
		Type = "Misc";
		DecayType = "Upkeep";
		DamageType = "Wood";
		MeleeResistance = 0.4;
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new(0, 0.3, 0) * CFrame.Angles(0, math.rad(90), 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.new();
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Window"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
	};
	["Metal Window Bars"] = {
		Type = "Misc";
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new(0, 0.3, 0) * CFrame.Angles(0, math.rad(90), 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.new();
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Window"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
	};
	["Glass Window"] = {
		Type = "Misc";
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new(0, 0.3, 0) * CFrame.Angles(0, math.rad(90), 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.new();
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Window"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
	};
	["Steel Glass Window"] = {
		Type = "Misc";
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new(0, 0.3, 0) * CFrame.Angles(0, math.rad(90), 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.new();
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Window"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 13;
		}};
	};

	["Vertical Window Cover"] = {
		Type = "Misc";
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Window"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 14;
		}};
	};
	["Horizontal Window Cover"] = {
		Type = "Misc";
		DecayType = "Upkeep";
		DamageType = "Metal";
		MeleeResistance = 0.4;
		PickupBehavior = "HammerOnly";
		DurabilityDecrease = 0.25;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		SnapOnly = true;
		SnapPoints = {{
			BenchNames = {"Window"};
			Offset = CFrame.new(0, 0, 0);
			AttachmentIndex = 14;
		}};
	};

	["Wall Block"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Never";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		AttachmentChecks = {
			{
				BenchNames = {"Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame"};
				MaxRange = 13;
				Checks = {
					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.new(4, -0.55, 0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
							{
								Offset = CFrame.new(-4, -0.55, 0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.new(4, -0.55, -0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
							{
								Offset = CFrame.new(-4, -0.55, -0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
						}
					};
				}
			};
			{
				BenchNames = {"Wall", "Wall Frame", "Doorway", "Window", "Half Wall"};
				MaxRange = 13;
				Checks = {{
					AttachmentIndex = 3;
					Rays = {{
						Offset = CFrame.new(0, -1.05, 0) * CFrame.Angles(math.rad(-90), 0, 0);
						Length = 0.4;
					}}
				}};
			};
		};
		StabilityInfo = {
			Checks = {
				{
					Connections = {3};
					StabilityLoss = {0};
				};
				{
					Connections = {1, 2};
					StabilityLoss = {0, 0};
				};
			}
		};
		NextConnections = {};
	};
	
	["BTR"] = {
		DecayType = "Never";
		DisplayHealthOnly = true;
		InteractDistance = 0;
		GuiOffset = Vector3.new();
		DamageType = "BenchVehicle";
	};

	-- BASE PARTS
	["Foundation"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Top";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.new();
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = FoundationCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = false;
		SnapPoints = {
			-- FOUNDATION
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.new(0, a, 10), {"Foundation"}, 1
			end);
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.new(0, a, -10), {"Foundation"}, 2
			end);
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.new(10, a, 0), {"Foundation"}, 3
			end);
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.new(-10, a, 0), {"Foundation"}, 4
			end);

			-- TRIANGLE FOUNDATION
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.new(a, 0, 9.333, 0, -1, 0, 0, 0, 1, -1, 0, 0), {"Triangle Foundation"}, 1
			end);
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.new(a, 6.83, -2.497, 0, -1, 0, 0.5, 0, -0.866, 0.866, 0, 0.5), {"Triangle Foundation"}, 2
			end);
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.new(a, -6.83, -2.497, 0, -1, 0, 0.866, 0, -0.5, 0.5, 0, 0.866), {"Triangle Foundation"}, 3
			end);

			-- FOUNDATION STEPS
			{
				BenchNames = {"Foundation Steps"};
				Offset = CFrame.new(0, -2.5, -10);
				AttachmentIndex = 1;
			};
		};
		AttachmentChecks = {
			{
				BenchNames = {"Foundation", "Triangle Foundation", "Foundation Steps"};
				MaxRange = 11;
				Checks = {
					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(4, 0, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-4, 0, -4.4);
								Length = 0.7;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(4, 0, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(-4, 0, -4.4);
								Length = 0.7;
							};
						}
					};
					{
						AttachmentIndex = 3;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(4, 0, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4, 0, -4.4);
								Length = 0.7;
							};
						}
					};
					{
						AttachmentIndex = 4;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4, 0, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-4, 0, -4.4);
								Length = 0.7;
							};
						}
					};

					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(4, -10, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-4, -10, -4.4);
								Length = 0.7;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(4, -10, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(-4, -10, -4.4);
								Length = 0.7;
							};
						}
					};
					{
						AttachmentIndex = 3;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(4, -10, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4, -10, -4.4);
								Length = 0.7;
							};
						}
					};
					{
						AttachmentIndex = 4;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4, -10, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-4, -10, -4.4);
								Length = 0.7;
							};
						}
					};

					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(4, 10, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-4, 10, -4.4);
								Length = 0.7;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(4, 10, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(-4, 10, -4.4);
								Length = 0.7;
							};
						}
					};
					{
						AttachmentIndex = 3;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(4, 10, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4, 10, -4.4);
								Length = 0.7;
							};
						}
					};
					{
						AttachmentIndex = 4;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4, 10, -4.4);
								Length = 0.7;
							};
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-4, 10, -4.4);
								Length = 0.7;
							};
						}
					};
				}
			};
			{
				BenchNames = {"Wall", "Wall Frame", "Doorway", "Window", "Half Wall", "Low Wall", "Wall Block"};
				MaxRange = 9;
				Checks = {
					{
						AttachmentIndex = 5;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(4, 0.6, -4.3);
								Length = 0.4;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-4, 0.6, -4.3);
								Length = 0.4;
							};
						}
					};
					{
						AttachmentIndex = 6;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(4, 0.6, -4.3);
								Length = 0.4;
							};
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(-4, 0.6, -4.3);
								Length = 0.4;
							};
						}
					};
					{
						AttachmentIndex = 7;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(4, 0.6, -4.3);
								Length = 0.4;
							};
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4, 0.6, -4.3);
								Length = 0.4;
							};
						}
					};
					{
						AttachmentIndex = 8;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4, 0.6, -4.3);
								Length = 0.4;
							};
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-4, 0.6, -4.3);
								Length = 0.4;
							};
						}
					};
				}
			};
		};
		NextConnections = {1, 2, 3, 4, 5, 6, 7, 8};
	};
	["Triangle Foundation"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Top";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.Angles(0, math.rad(180), math.rad(-90));
		RotateOffset = CFrame.new();
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = FoundationCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = false;
		SnapPoints = {
			-- TRIANGLE FOUNDATION
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.new(a, 0, 8.666, 1, 0, 0, 0, -1, 0, 0, 0, -1), {"Triangle Foundation"}, 1
			end);
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.new(a, 3.748, -2.167, 1, 0, 0, 0, 0.5, 0.866, 0, -0.866, 0.5), {"Triangle Foundation"}, 2
			end);
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.new(a, -3.748, -2.167, 1, 0, 0, 0, 0.5, -0.866, 0, 0.866, 0.5), {"Triangle Foundation"}, 3
			end);

			-- FOUNDATION
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, a, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1), {"Foundation"}, 1
			end);
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.Angles(0, math.rad(0), 0) * CFrame.new(0, a, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1), {"Foundation"}, 2
			end);
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(0, a, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1), {"Foundation"}, 3
			end);
			CreateSnaps(5, function(i)
				local a = (i - 3) * 5 -- -10, -5, 0, 5, 10
				return CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, a, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1), {"Foundation"}, 4
			end);

			-- FOUNDATION STEPS
			{
				BenchNames = {"Foundation Steps"};
				Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(0, -2.5, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1);
				AttachmentIndex = 1;
			};
		};
		AttachmentChecks = {
			{
				BenchNames = {"Foundation", "Triangle Foundation", "Foundation Steps"};
				MaxRange = 9;
				Checks = {
					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, -4, -4.1);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, -4, -4.1);
								Length = 0.6;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(0, 5, -1.9);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(0, -2.6, -1.9);
								Length = 0.6;
							};
						}
					};
					{
						AttachmentIndex = 3;
						Rays = {
							{
								Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(0, -5, -1.9);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(0, 2.6, -1.9);
								Length = 0.6;
							};
						}
					};

					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-10, -4, -4.1);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-10, -4, -4.1);
								Length = 0.6;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(-10, 5, -1.9);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(-10, -2.6, -1.9);
								Length = 0.6;
							};
						}
					};
					{
						AttachmentIndex = 3;
						Rays = {
							{
								Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(10, -5, -1.9);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(10, 2.6, -1.9);
								Length = 0.6;
							};
						}
					};

					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(10, -4, -4.1);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(10, -4, -4.1);
								Length = 0.6;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(10, 5, -1.9);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(10, -2.6, -1.9);
								Length = 0.6;
							};
						}
					};
					{
						AttachmentIndex = 3;
						Rays = {
							{
								Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(10, -5, -1.9);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(10, 2.6, -1.9);
								Length = 0.6;
							};
						}
					};
				}
			};
			{
				BenchNames = {"Wall", "Wall Frame", "Doorway", "Window", "Half Wall", "Low Wall", "Wall Block"};
				MaxRange = 9;
				Checks = {
					{
						AttachmentIndex = 4;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0.6, 4, -3.6);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0.6, -4, -3.6);
								Length = 0.6;
							};
						}
					};
					{
						AttachmentIndex = 5;
						Rays = {
							{
								Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(-0.6, 5, -1.6);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(math.rad(60), 0, 0) * CFrame.new(-0.6, -2.6, -1.6);
								Length = 0.6;
							};
						}
					};
					{
						AttachmentIndex = 6;
						Rays = {
							{
								Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(-0.6, -5, -1.6);
								Length = 0.6;
							};
							{
								Offset = CFrame.Angles(math.rad(-60), 0, 0) * CFrame.new(-0.6, 2.6, -1.6);
								Length = 0.6;
							};
						}
					};
				}
			};
		};
		NextConnections = {1, 2, 3, 4, 5, 6};
	};
	["Foundation Steps"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Top";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.new();
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = FoundationCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = {
			-- FOUNDATION
			{
				BenchNames = {"Foundation"};
				Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, -2.5, -10);
				AttachmentIndex = 1;
			};
			{
				BenchNames = {"Foundation"};
				Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(0, -2.5, -10);
				AttachmentIndex = 2;
			};
			{
				BenchNames = {"Foundation"};
				Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(0, -2.5, -10);
				AttachmentIndex = 3;
			};
			{
				BenchNames = {"Foundation"};
				Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, -2.5, -10);
				AttachmentIndex = 4;
			};

			-- TRIANGLE FOUNDATION
			{
				BenchNames = {"Triangle Foundation"};
				Offset = CFrame.new(2.5, 0, 9.333, 0, -1, 0, 0, 0, 1, -1, 0, 0) * CFrame.Angles(0, math.rad(90), 0);
				AttachmentIndex = 1;
			};
			{
				BenchNames = {"Triangle Foundation"};
				Offset = CFrame.new(2.5, 6.83, -2.497, 0, -1, 0, 0.5, 0, -0.866, 0.866, 0, 0.5);
				AttachmentIndex = 2;
			};
			{
				BenchNames = {"Triangle Foundation"};
				Offset = CFrame.new(2.5, -6.83, -2.497, 0, -1, 0, 0.866, 0, -0.5, 0.5, 0, 0.866) * CFrame.Angles(0, math.rad(90), 0);
				AttachmentIndex = 3;
			};

			-- FOUNDATION STEPS
			{
				BenchNames = {"Foundation Steps"};
				Offset = CFrame.new(0, -5, -10);
				AttachmentIndex = 1;
			};
			{
				BenchNames = {"Foundation Steps"};
				Offset = CFrame.new(0, 5, 10);
				AttachmentIndex = 2;
			};
		};
		AttachmentChecks = {
			{
				BenchNames = {"Foundation", "Triangle Foundation", "Foundation Steps"};
				MaxRange = 11;
				Checks = {
					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(4, 0, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(-4, 0, -4.4);
								Length = 1.2;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(4, 0, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-4, 0, -4.4);
								Length = 1.2;
							};
						}
					};
					{
						AttachmentIndex = 3;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4, 0, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-4, 0, -4.4);
								Length = 1.2;
							};
						}
					};
					{
						AttachmentIndex = 4;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(4, 0, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4, 0, -4.4);
								Length = 1.2;
							};
						}
					};

					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(4, -10, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(-4, -10, -4.4);
								Length = 1.2;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(4, -10, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-4, -10, -4.4);
								Length = 1.2;
							};
						}
					};
					{
						AttachmentIndex = 3;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4, -10, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-4, -10, -4.4);
								Length = 1.2;
							};
						}
					};
					{
						AttachmentIndex = 4;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(4, -10, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4, -10, -4.4);
								Length = 1.2;
							};
						}
					};

					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(4, 10, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(-4, 10, -4.4);
								Length = 1.2;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(4, 10, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(-4, 10, -4.4);
								Length = 1.2;
							};
						}
					};
					{
						AttachmentIndex = 3;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4, 10, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(-4, 10, -4.4);
								Length = 1.2;
							};
						}
					};
					{
						AttachmentIndex = 4;
						Rays = {
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(4, 10, -4.4);
								Length = 1.2;
							};
							{
								Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4, 10, -4.4);
								Length = 1.2;
							};
						}
					};
				}
			};

		};
		StabilityInfo = {
			Checks = {
				{
					Connections = {2};
					StabilityLoss = {0};
				};
			}
		};
		NextConnections = {1, 2, 3, 4};
	};
	["Wall"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Front";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = Wall.SnapPoints;
		AttachmentChecks = Wall.AttachmentChecks;
		StabilityInfo = Wall.StabilityInfo;
		NextConnections = Wall.NextConnections;
		WallBlockOffset = CFrame.new(0, -3.75, 0);
	};
	["Wall Frame"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.new();
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = Wall.SnapPoints;
		AttachmentChecks = Wall.AttachmentChecks;
		StabilityInfo = Wall.StabilityInfo;
		NextConnections = Wall.NextConnections;
		WallBlockOffset = CFrame.new(0, -3.75, 0);
	};
	["Doorway"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Front";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = Wall.SnapPoints;
		AttachmentChecks = Wall.AttachmentChecks;
		StabilityInfo = Wall.StabilityInfo;
		NextConnections = Wall.NextConnections;
		RotateIgnores = {13};
		WallBlockOffset = CFrame.new(0, -3.75, 0);
	};
	["Window"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Front";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = Wall.SnapPoints;
		AttachmentChecks = Wall.AttachmentChecks;
		StabilityInfo = Wall.StabilityInfo;
		NextConnections = Wall.NextConnections;
		RotateIgnores = {13};
		WallBlockOffset = CFrame.new(0, -3.75, 0);
	};
	["Half Wall"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Front";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = {
			-- FLOORS/FOUNDATION
			{
				BenchNames = {"Foundation", "Floor", "Floor Frame"};
				Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(0, 2.5, 5);
				AttachmentIndex = 5;
			};
			{
				BenchNames = {"Foundation", "Floor", "Floor Frame"};
				Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, 2.5, 5);
				AttachmentIndex = 6;
			};
			{
				BenchNames = {"Foundation", "Floor", "Floor Frame"};
				Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, 2.5, 5);
				AttachmentIndex = 7;
			};
			{
				BenchNames = {"Foundation", "Floor", "Floor Frame"};
				Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(0, 2.5, 5);
				AttachmentIndex = 8;
			};

			-- TRIANGLE FOUNDATION
			{
				BenchNames = {"Triangle Foundation", "Triangle Floor", "Triangle Floor Frame"};
				Offset = CFrame.new(-2.5, 0, 4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1);
				AttachmentIndex = 4;
			};
			{
				BenchNames = {"Triangle Foundation", "Triangle Floor", "Triangle Floor Frame"};
				Offset = CFrame.new(-2.5, 2.5, 0, 0, -1, 0, -0.5, 0, 0.866, -0.866, 0, -0.5);
				AttachmentIndex = 5;
			};
			{
				BenchNames = {"Triangle Foundation", "Triangle Floor", "Triangle Floor Frame"};
				Offset = CFrame.new(-2.5, -2.5, 0, 0, -1, 0, -0.5, 0, -0.866, 0.866, 0, -0.5);
				AttachmentIndex = 6;
			};

			-- WALLS
			{
				BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
				Offset = CFrame.new(0, 7.5, 0);
				AttachmentIndex = 3;
			};

			-- HALF WALL
			{
				BenchNames = {"Half Wall"};
				Offset = CFrame.new(0, 5, 0);
				AttachmentIndex = 3;
			};
		};
		AttachmentChecks = {
			{
				BenchNames = {"Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame"};
				MaxRange = 13;
				Checks = {
					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.new(4, -1.8, 0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
							{
								Offset = CFrame.new(-4, -1.8, 0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.new(4, -1.8, -0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
							{
								Offset = CFrame.new(-4, -1.8, -0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
						}
					};
				}
			};
			{
				BenchNames = {"Wall", "Wall Frame", "Doorway", "Window", "Half Wall"};
				MaxRange = 13;
				Checks = {
					{
						AttachmentIndex = 3;
						Rays = {{
							Offset = CFrame.new(0, 2.3, 0) * CFrame.Angles(math.rad(90), 0, 0);
							Length = 0.4;
						}}
					};

					{
						AttachmentIndex = 4;
						Rays = {{
							Offset = CFrame.new(0, -2.3, 0) * CFrame.Angles(math.rad(-90), 0, 0);
							Length = 0.4;
						}}
					};

					{
						AttachmentIndex = 5;
						Rays = {
							{
								Offset = CFrame.new(-5.6, 0, 0.6) * CFrame.Angles(math.rad(0), 0, 0);
								Length = 0.2;
							};
							{
								Offset = CFrame.new(-5.6, 0, -0.6) * CFrame.Angles(math.rad(180), 0, 0);
								Length = 0.2;
							};
						}
					};
					{
						AttachmentIndex = 6;
						Rays = {
							{
								Offset = CFrame.new(5.6, 0, 0.6) * CFrame.Angles(math.rad(0), 0, 0);
								Length = 0.2;
							};
							{
								Offset = CFrame.new(5.6, 0, -0.6) * CFrame.Angles(math.rad(180), 0, 0);
								Length = 0.2;
							};
						}
					};
				}
			};
			{
				BenchNames = {"Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame"};
				MaxRange = 9;
				Checks = {
					{
						AttachmentIndex = 7;
						Rays = {
							{
								Offset = CFrame.new(4, 1.8, 0.6) * CFrame.Angles(math.rad(90), 0, 0);
								Length = 0.4;
							};
							{
								Offset = CFrame.new(-4, 1.8, 0.6) * CFrame.Angles(math.rad(90), 0, 0);
								Length = 0.4;
							};
						}
					};
					{
						AttachmentIndex = 8;
						Rays = {
							{
								Offset = CFrame.new(4, 1.8, -0.6) * CFrame.Angles(math.rad(90), 0, 0);
								Length = 0.4;
							};
							{
								Offset = CFrame.new(-4, 1.8, -0.6) * CFrame.Angles(math.rad(90), 0, 0);
								Length = 0.4;
							};
						}
					};
				}
			};
		};
		StabilityInfo = {
			LossPerHeight = {
				Start = 0;
				PerStud = 1;
			};
			Checks = {
				{
					Connections = {4};
					StabilityLoss = {0};
				};
				{
					Connections = {1, 2};
					StabilityLoss = {0, 0};
					BenchNames = {"Foundation", "Triangle Foundation"};
				};
				{
					Connections = {1, 2};
					StabilityLoss = {20, 10};
				};
				{
					Connections = {5, 6};
					StabilityLoss = {60, 40};
				};
				{
					Connections = {7, 8};
					StabilityLoss = {40, 40};
				};
			}
		};
		NextConnections = {3, 5, 6, 7, 8};
		WallBlockOffset = CFrame.new(0, -1.25, 0);
	};
	["Low Wall"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Front";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(180), 0);
		OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = {
			-- FLOORS/FOUNDATION
			{
				BenchNames = {"Foundation", "Floor", "Floor Frame"};
				Offset = CFrame.Angles(0, math.rad(0), 0) * CFrame.new(0, 1.25, 5);
				AttachmentIndex = 5;
			};
			{
				BenchNames = {"Foundation", "Floor", "Floor Frame"};
				Offset = CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, 1.25, 5);
				AttachmentIndex = 6;
			};
			{
				BenchNames = {"Foundation", "Floor", "Floor Frame"};
				Offset = CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, 1.25, 5);
				AttachmentIndex = 7;
			};
			{
				BenchNames = {"Foundation", "Floor", "Floor Frame"};
				Offset = CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(0, 1.25, 5);
				AttachmentIndex = 8;
			};

			-- TRIANGLE FOUNDATION
			{
				BenchNames = {"Triangle Foundation", "Triangle Floor", "Triangle Floor Frame"};
				Offset = CFrame.new(-1.25, 0, 4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1);
				AttachmentIndex = 4;
			};
			{
				BenchNames = {"Triangle Foundation", "Triangle Floor", "Triangle Floor Frame"};
				Offset = CFrame.new(-1.25, 2.5, 0, 0, -1, 0, -0.5, 0, 0.866, -0.866, 0, -0.5);
				AttachmentIndex = 5;
			};
			{
				BenchNames = {"Triangle Foundation", "Triangle Floor", "Triangle Floor Frame"};
				Offset = CFrame.new(-1.25, -2.5, 0, 0, -1, 0, -0.5, 0, -0.866, 0.866, 0, -0.5);
				AttachmentIndex = 6;
			};

			-- WALLS
			{
				BenchNames = {"Wall", "Wall Frame", "Doorway", "Window"};
				Offset = CFrame.new(0, 6.25, 0);
				AttachmentIndex = 3;
			};

			-- HALF WALL
			{
				BenchNames = {"Half Wall"};
				Offset = CFrame.new(0, 3.75, 0);
				AttachmentIndex = 3;
			};
		};
		AttachmentChecks = {
			{
				BenchNames = {"Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame"};
				MaxRange = 13;
				Checks = {
					{
						AttachmentIndex = 1;
						Rays = {
							{
								Offset = CFrame.new(4, -0.55, 0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
							{
								Offset = CFrame.new(-4, -0.55, 0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
						}
					};
					{
						AttachmentIndex = 2;
						Rays = {
							{
								Offset = CFrame.new(4, -0.55, -0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
							{
								Offset = CFrame.new(-4, -0.55, -0.6) * CFrame.Angles(math.rad(-90), 0, 0);
								Length = 0.4;
							};
						}
					};
				}
			};
			{
				BenchNames = {"Wall", "Wall Frame", "Doorway", "Window", "Half Wall"};
				MaxRange = 13;
				Checks = {{
					AttachmentIndex = 3;
					Rays = {{
						Offset = CFrame.new(0, -1.05, 0) * CFrame.Angles(math.rad(-90), 0, 0);
						Length = 0.4;
					}}
				}};
			};
		};
		StabilityInfo = {
			LossPerHeight = {
				Start = 0;
				PerStud = 1;
			};
			Checks = {
				{
					Connections = {3};
					StabilityLoss = {0};
				};
				{
					Connections = {1, 2};
					StabilityLoss = {0, 0};
					BenchNames = {"Foundation", "Triangle Foundation"};
				};
				{
					Connections = {1, 2};
					StabilityLoss = {5, 5};
				};
			}
		};
		NextConnections = {};
		WallBlockOffset = CFrame.new(0, 0, 0);
	};
	["Floor"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Bottom";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.new();
		FaceCamera = true;
		IgnoreBuildBlock = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = Floor.SnapPoints;
		AttachmentChecks = Floor.AttachmentChecks;
		StabilityInfo = Floor.StabilityInfo;
		NextConnections = Floor.NextConnections;
	};
	["Floor Frame"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.new();
		FaceCamera = true;
		IgnoreBuildBlock = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = Floor.SnapPoints;
		AttachmentChecks = Floor.AttachmentChecks;
		StabilityInfo = Floor.StabilityInfo;
		NextConnections = Floor.NextConnections;
	};
	["Triangle Floor"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Bottom";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.Angles(0, math.rad(180), math.rad(-90));
		RotateOffset = CFrame.new();
		FaceCamera = true;
		IgnoreBuildBlock = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = FoundationCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = TriangleFloor.SnapPoints;
		AttachmentChecks = TriangleFloor.AttachmentChecks;
		StabilityInfo = TriangleFloor.StabilityInfo;
		NextConnections = TriangleFloor.NextConnections;
	};
	["Triangle Floor Frame"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.Angles(0, math.rad(180), math.rad(-90));
		RotateOffset = CFrame.new();
		FaceCamera = true;
		IgnoreBuildBlock = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = FoundationCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = TriangleFloor.SnapPoints;
		AttachmentChecks = TriangleFloor.AttachmentChecks;
		StabilityInfo = TriangleFloor.StabilityInfo;
		NextConnections = TriangleFloor.NextConnections;
	};
	["L-Shaped Stairs"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Top";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		--OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = Stairs.SnapPoints;
		AttachmentChecks = Stairs.AttachmentChecks;
		StabilityInfo = Stairs.StabilityInfo;
		NextConnections = Stairs.NextConnections;
	};
	["U-Shaped Stairs"] = {
		Type = "BasePart";
		TypeArguments = function()
			return {}
		end;
		DecayType = "Upkeep";
		DamageType = "Twig";
		InteractDistance = 12;
		SoftSide = "Top";
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.new();
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		--OffsetSnappedFacingAway = CFrame.Angles(0, math.rad(180), 0);
		FaceCamera = true;
		PlacingFunc = FoundationPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
		NonBaseCollisionFunc = NonBaseCollision;
		SnapOnly = true;
		SnapPoints = Stairs.SnapPoints;
		AttachmentChecks = Stairs.AttachmentChecks;
		StabilityInfo = Stairs.StabilityInfo;
		NextConnections = Stairs.NextConnections;
	};
	["External Stone Wall"] = {
		Type = "Damager";
		TypeArguments = function()
			return {
				Damage = 15;
				Bleed = 3;
				HitTick = 0.14;
			}
		end;
		DecayType = "UnderBase";
		DamageType = "Stone";
		MeleeResistance = 0.4;
		PickupBehavior = false;
		DisplayHealthOnly = true;
		GuiOffset = Vector3.new(0, 0, 0);
		Offset = CFrame.Angles(math.rad(-90), math.rad(-90), 0) * CFrame.new(0, 7.5, 0);
		UnsnappedOffset = CFrame.new();
		RotateOffset = CFrame.Angles(0, math.rad(90), 0);
		PlaceableAngles = {
			Min = 0;
			Max = 40;
		};
		PlaceExtraDistance = 9;
		InteractDistance = 9;
		RayCheckLength = 7.75;
		FaceCamera = true;
		RotateOnSurface = true;
		PlaceWhitelist = {"Terrain"};
		PlacingFunc = DefaultPlaceFunc;
		CollisionFunc = DefaultCollisionFunc;
	};
}

for _, info in pairs(BenchInfo) do
	local snapPoints = info.SnapPoints
	if not snapPoints then continue end
	local newSnapPoints = {}
	for _, t in pairs(snapPoints) do
		for _, snapPoint in pairs(t[1] and t or {t}) do
			table.insert(newSnapPoints, snapPoint)
		end
	end
	info.SnapPoints = newSnapPoints
end

return BenchInfo