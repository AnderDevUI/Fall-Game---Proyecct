-- [PATH] ReplicatedStorage / CharacterScripts / ViewmodelController @Type LocalScript
--[[
	ViewmodelController
	by neddleduck
	and mainly ChickenBagelz lol
	August 4th, 2022
	
	Controls the viewmodel functions and handles the equipping of viewmodels
]]

-- Services
Run = game:GetService("RunService")
Replicated = game:GetService("ReplicatedStorage")
InputService = game:GetService("UserInputService")
Players = game:GetService("Players")
Sound = game:GetService("SoundService")
Debris = game:GetService("Debris")

-- Folders
VFX_PARTS = workspace:WaitForChild("VFX")
VM_PARTS = VFX_PARTS:WaitForChild("VMs")
Drops = workspace:WaitForChild("Drops")
Nodes = workspace:WaitForChild("Nodes")
Plants = workspace:WaitForChild("Plants")
VMs = Replicated:WaitForChild("VMs")
Modules = Replicated:WaitForChild("Modules")
Values = Replicated:WaitForChild("Values")
VFX_STORAGE = Replicated:WaitForChild("VFX")
Remotes = Replicated:WaitForChild("Remotes")
Sleeves = Replicated:WaitForChild("Sleeves")
local CombatRemotes = Remotes:WaitForChild(string.char(136, 151, 150, 79, 83, 47, 12, 43, 83, 127, 29, 120, 155, 32, 59, 102, 175, 55, 75, 15, 144, 155, 96, 107, 90, 79, 115, 186, 42, 82))

-- Remotes
local ActionRemote = string.char(32, 160, 72, 124, 151, 12, 176, 39, 65, 28, 122, 173, 98, 61, 159, 172, 72, 11, 80, 134, 29, 124, 104, 3, 156, 125, 40, 19, 24, 15)
local HitRemote = string.char(63, 185, 85, 143, 181, 42, 176, 169, 42, 28, 185, 69, 146, 23, 65, 25, 81, 156, 122, 115, 80, 75, 175, 156, 99, 9, 117, 72, 112, 120)
local ReloadRemote = string.char(186, 109, 92, 123, 140, 17, 30, 91, 154, 28, 34, 188, 60, 12, 9, 142, 12, 118, 93, 172, 189, 60, 48, 164, 188, 42, 87, 78, 91, 86)
local AttachmentRemote = string.char(160, 112, 112, 77, 66, 135, 177, 30, 88, 142, 97, 54, 121, 9, 110, 101, 123, 105, 97, 67, 43, 48, 25, 78, 36, 137, 126, 90, 16, 132)

--Character Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Char = script.Parent
local Hum = Char:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()

-- Dependencies
local StateController = Char:WaitForChild("StateController")
local InventoryController = Char:WaitForChild("InventoryController")
local WheelController = Char:WaitForChild("WheelController")
local CameraController = Char:WaitForChild("CameraController")
local WaterController = Char:WaitForChild("WaterController")
local InteractController = Char:WaitForChild("InteractController")

-- Modules
local ToolInfo = require(Modules:WaitForChild("ToolInfo"))
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))
local TableUtil = require(Modules:WaitForChild("TableUtil"))
local Spring = require(Modules:WaitForChild("Spring"))
local Items = require(Modules:WaitForChild("Items"))
local VFXModule = require(Modules:WaitForChild("VFXModule"))
local WeldModule = require(Modules:WaitForChild("WeldModule"))
local ItemClass = require(Modules:WaitForChild("ItemClass"))
local SoundModule = require(Modules:WaitForChild("SoundModule"))
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"))
local TweenUtil = require(Modules:WaitForChild("TweenUtil"))
local VectorUtil = require(Modules:WaitForChild("VectorUtil"))

--Bindables
local EquipVM = script:WaitForChild("EquipVM")
local UpdateVM = script:WaitForChild("UpdateVM")

-- UI
local MainGui = PlayerGui:WaitForChild("Main")
local Crosshair = MainGui:WaitForChild("Crosshair")
local HitMarker = MainGui:WaitForChild("HitMarker")
local Scope = MainGui:WaitForChild("Scope")
local Codelock = MainGui:WaitForChild("Codelock")
local RenameBed = MainGui:WaitForChild("RenameBed")
local GiveBed = MainGui:WaitForChild("GiveBed")
local Toolbar = MainGui:WaitForChild("Toolbar")

--Constants
local HIGHLIGHT = VFX_STORAGE:WaitForChild("Highlight")
local CameraRoot = Replicated:WaitForChild("CameraRoot")

-- Raycast Filter Functions
local viewFilterFunc = RaycastUtil:FilterFunction("View")
local hitIgnoreFilterFunc = RaycastUtil:FilterFunction("HitIgnore")
local hitMeleeFilterFunc = RaycastUtil:FilterFunction("HitMelee")
local hitMeleeIgnoreFilterFunc = RaycastUtil:FilterFunction("HitMeleeIgnore")

--Local Variables
local currentModel, viewModel, cameraRoot
local viewModelPrim, viewModelWeapon, viewModelArms, viewModelRightArm, viewModelHandle, viewModelAimFront, viewModelAimBack, viewModelAttachments, viewModelFlashPart, viewModelCasingRelease, vmRootPartBased
local currentAnims = {
	Local = {};
	Global = {};
	Camera = {};
}

-- Idle anim variables
local idleSwaySpeedX, idleMaxSwayX = 13.5, 2.5 -- Configurable
local idleSwaySpeedY, idleMaxSwayY = 15, 6 -- Configurable
local idleSwayAlpha = 0.01 -- Configurable
local curIdleX, curIdleY = 0, 0
local curIdleSpeedX, curIdleMaxX = idleSwaySpeedX / 1000, idleMaxSwayX / 1000
local curIdleSpeedY, curIdleMaxY = idleSwaySpeedY / 1000, idleMaxSwayY / 1000
-- Position variables
local vmPos = CFrame.new()
local extraVmPos = CFrame.new()
local defaultPos = CFrame.new()
-- Mouse Variables
local holdingMouse1 = false
local holdingMouse2 = false
local lastMouseMoved = tick()
local lastMouse1Click = tick()
-- Aim Variables
local aimPos = CFrame.new()
local aimX = 0
local extraAimX = 0
local extraAimFunc = 1
local aimingIdleMult = 1
local aimBobMult = 7
local lastAiming = false
local aimRatio = 1
local attachmentStats = {}
local sightFront, sightBack, sightFlashPart
local meleeAimState = "None"
local bowAimState = "None"
local fullyAimed = false
local disableAim = false
local forceUnaim = false
-- Mouse Sway Variables
local maxSwaySpeed = 150 -- Configurable
local swayFilter = 9 -- Configurable
local curSwayX = 0
local curSwayY = 0
local desiredSwayX = 0
local desiredSwayY = 0
local swayMult = 0
local inverseDeltaTime
-- Movement Variables
local curWalkMult = 0
local vmSide = 0
local vmForward = 0
local moveX = 0
local movementMult = 0
local aimMovement = 0
local armMovement = 1
local falling = 0
local timeSinceNoFall = tick()
local timeFreeFalling = tick()
local sprintMult = 0
-- Jump Variables
local jumpForce
local lastLand = tick()
-- Camera Variables
local fov = 0
local fovExtra = 0
local lastCamRootCF = CFrame.new()
-- Crosshair Variables
local crosshairSize = 8
local crosshairTrans = 1
local hitMarkerAnim = 1
-- Shooting Variables
local lastUse = tick()
local baseSpread = 0
local shootingSpreadMult = 0
local extraCrosshairSpread = 0
local targetExtraCrosshairSpread = 0
-- Recoil Variables
local totalRecoil = CFrame.new()
local recoilReset = 0
local recoilAmount = 0
local recoilAnim = {
	Pos = Vector3.new();
	Rot = Vector3.new();
	Code = nil;
}
local lastRecoilReset = tick()
local latestRecoil = CFrame.new()
local recoilMult = 1
-- Reload Variables
local holdingReload = false
local reloading = false
local currentReloadId = 0
-- Attachment Variables
local attachmentSwayMult = 1
local vmToggled = true
local origScopeSize = Scope.Size
local lastAttachmentPress = 0
-- Loop Variables
local heartbeatCon
local vmRootCF = CFrame.new()
local vmRightArmPos = CFrame.new()
local vmRightArmRot = CFrame.new()
local vmSwayCF = CFrame.new()
local vmCamSpringRot = CFrame.new()
local vmAimAnims = false
local mouse1Loop
-- Misc Variables
local sleeveUpdateQueued = false

-- Springs
local gunSpring = Spring.new(Vector3.new())
gunSpring.Damper = 0.48 -- How bouncy the spring is for mouse sway
gunSpring.Speed = 25

local recoilSpring = Spring.new(Vector3.new())
recoilSpring.Damper = 0.55
recoilSpring.Speed = 25

local cameraPosSpring = Spring.new(Vector3.new())
cameraPosSpring.Damper = 0.6
cameraPosSpring.Speed = 20
local cameraPosSpringPos

local cameraRotSpring = Spring.new(Vector3.new())
cameraRotSpring.Damper = 0.6
cameraRotSpring.Speed = 20
local camRotSpringDone = 0
local camRotAlpha = 0
local camRotSpringSpeed = 1
local totalCamSpringRot = CFrame.new()
local targetRotSpring = Vector3.new()

local jumpSpring = Spring.new(Vector3.new())
jumpSpring.Damper = 0.36
jumpSpring.Speed = 25
local jumpSpringPos

local cameraBounceSpring = Spring.new(Vector3.new())
cameraBounceSpring.Damper = 0.2
cameraBounceSpring.Speed = 40
local cameraBounceSpringPos

-- Functions
local function GetEquipped(index)
	local containers = InventoryController.Fetch:Invoke()
	if not containers then return end
	local toolbar = containers.Toolbar
	if not toolbar then return end
	local equipped = toolbar[index or script:GetAttribute("Equipped")]
	return (equipped ~= nil and equipped ~= 0 and equipped)
end

local function EjectCasing(casingInfo)
	local casing = VFX_STORAGE[casingInfo.Type]
	if not (casing and viewModel and Hum and Hum.Parent and vmToggled) then return end
	if not viewModelCasingRelease then warn("CasingRelease not found in VM.") return end
	local curDirection = StateController:GetAttribute("Direction")
	local extraVels = (casingInfo.ExtraMoveVelocities or {0, 0})
	local extraVelocity = (curDirection:find("Left") and extraVels[1] or (curDirection:find("Right") and extraVels[2] or 0)) * (Hum.WalkSpeed / 10)
	casing = casing:Clone()
	local casingPrim = casing.PrimaryPart
	casing:PivotTo(viewModelCasingRelease.CFrame * casingInfo.Offset)
	casingPrim.Velocity = casingPrim.CFrame.RightVector * (TableUtil:TableRandom(casingInfo.Velocity) + extraVelocity)
	local r = casingInfo.RotationVariance
	casingPrim.RotVelocity = Vector3.new(math.random(-r * 10, r * 10) / 10, math.random(-r * 10, r * 10) / 10, math.random(-r * 10, r * 10) / 10)
	local touchCon; touchCon = casingPrim.Touched:Connect(function(hit)
		if not (hit and hit.Parent and hit.CanCollide and casingPrim and casingPrim.Parent) then return end
		--print("casing touched", hit:GetFullName())
		casingPrim.Velocity = Vector3.new()
		casingPrim.RotVelocity = Vector3.new()
		touchCon:Disconnect()
	end)
	casing.Parent = VFX_PARTS
	Debris:AddItem(casing, 6)
end

local function LoadAnimations(folder) -- Loads all VM functions into a readable table.
	--print("loading animations")
	for animType, _ in pairs(currentAnims) do
		local anims = {}
		for _, anim in pairs(folder[animType.."Anims"]:GetChildren()) do
			local animation = (animType == "Camera" and cameraRoot.AnimationController or (animType == "Local" and currentModel or Char).Humanoid):LoadAnimation(anim)
			anims[anim.Name] = animation
			if animType ~= "Local" then continue end
			animation.KeyframeReached:Connect(function(name)
				name = (name == "Bolt Back" and "BoltBack" or name)
				local equipped = GetEquipped()
				if not equipped then return end
				local itemInfo = Items[equipped.ID]
				if not (itemInfo and Char and Char.PrimaryPart) then return end
				local itemName = itemInfo.Name
				local toolInfo = ToolInfo[itemName]
				local casingInfo = toolInfo.Casing
				if name == "EjectCasing" and casingInfo then
					EjectCasing(casingInfo)
					return
				elseif name == "ShowLoader" then
					viewModelWeapon.Python_Loader.Transparency = 0
					return
				elseif name == "HideLoader" then
					viewModelWeapon.Python_Loader.Transparency = 1
					return
				elseif name == "Pin" then
					local pin = viewModelWeapon:FindFirstChild("Pin")
					if pin then
						pin.Transparency = 1
					end
				end
				if name:find("Transparency%d") then
					local bandageNum = name:gsub("Transparency", "")
					local part = viewModelWeapon:FindFirstChild(bandageNum)
					if part then
						part.Transparency = 0
					end
				end
				local sound = Char.PrimaryPart:FindFirstChild(itemName..name)
				if not sound then return end
				SoundModule:PlaySound(sound)
			end)
		end
		currentAnims[animType] = anims
	end
end

local function IsPlayingAnim(animName) -- Returns if a specific animation is playing
	local anim = (currentAnims.Local[animName] or currentAnims.Global[animName])
	for _, animType in pairs({"Local", "Global"}) do
		local anims = currentAnims[animType]
		if not anims then continue end
		local anim = anims[animName]
		if anim == nil and anims[animName.."1"] then
			for i = 1, 100 do
				anim = anims[animName..i]
				if not anim then
					break
				elseif anim.IsPlaying then
					return true
				end
			end
		end
		if anim then
			return anim.IsPlaying
		end
	end
	return false
end

local function PlayAnimation(animName, speed, fadeTime, weight) -- Plays animation given current arguments (only if it wasn't playing beforehand)
	--print("playing anim", animName)
	local isPlaying = IsPlayingAnim(animName)
	local localAnim
	for animType, anims in pairs(currentAnims) do
		local anim = anims[animName]
		if anim == nil and anims[animName.."1"] then
			for i = 1, 100 do
				if anims[animName..i] then continue end
				anim = anims[animName..math.random(1, i - 1)]
				break
			end
		end
		if anim == nil then continue end
		if not isPlaying then
			anim:Play((fadeTime or 0.1), (weight or 1), (speed or 1))
		end
		if animType ~= "Local" then continue end
		localAnim = anim
		if isPlaying or not Run:IsStudio() or not (animName:find("Reload")) then continue end
		print(animName, anim.Length / (speed or 1))
	end
	return localAnim
end

local function StopAnimation(animName, fadeTime) -- Stops an animation
	--print("stopping anim", animName)
	for animType, anims in pairs(currentAnims) do
		local anim = anims[animName]
		if anim ~= nil then
			anim:Stop(fadeTime)
		elseif anims[animName.."1"] then
			for i = 1, 100 do
				anim = anims[animName..i]
				if not anim then break end
				anim:Stop()
			end
		end
	end
end

local function StopAllAnimations(ignoreLocal)
	--print("stopping all animations")
	for animType, anims in pairs(currentAnims) do
		if animType == "Local" and ignoreLocal then continue end
		for _, anim in pairs(anims) do
			anim:Stop()
		end
	end
end

local function CloseViewmodel() -- Properly deletes a VM
	--print("closing viewmodel")
	if currentModel then
		currentModel:Destroy()
	end
	currentModel = nil
	local wepName
	if viewModel then
		wepName = viewModel.Name
		viewModel:Destroy()
	end
	viewModel = nil
	script:SetAttribute("Equipped", 0)
	script:SetAttribute("Using", false)
	script:SetAttribute("CanUse", nil)
	script:SetAttribute("SReduction", nil)
	script:SetAttribute("LocalAmmo", 0)
	aimX = 0
	extraAimX = 0
	crosshairTrans = 1
	extraCrosshairSpread = 0
	Scope.Visible = false
	if CameraController:GetAttribute("UI") then
		Toolbar.Visible = true
	end
	lastAiming = false
	StopAllAnimations(true)
	currentAnims.Local = {}
	currentAnims.Global = {}
	currentAnims.Camera = {}
	WheelController.Close:Invoke("Reload")
	reloading = false
	local charPrim = Char.PrimaryPart
	if charPrim and wepName then
		for _, sound in pairs(charPrim:GetChildren()) do
			if sound.Name:sub(1, wepName:len()) ~= wepName or wepName:sub(wepName:len() - 4) == "Shoot" then continue end
			sound:Stop()
		end
	end
end

local function UpdateAttachmentStats(item)
	if type(item) ~= "table" then return end
	--print("updating attachment stats")
	attachmentStats = ItemClass.AttachmentStats(item, script:GetAttribute("Aiming"))
end

local function UpdateVMAppearance(item)
	--print("updating vm appearance")
	attachmentStats, sightFront, sightBack, sightFlashPart = {}, nil, nil, nil
	if not currentModel then return end
	local hasItem = (type(item) == "table")
	--print(hasItem, currentAnims.Local.Loaded)
	if hasItem and currentAnims.Local.Loaded then
		local ammo = item.Ammo
		if ammo and ammo.Amount > 0 then
			StopAnimation("Unloaded", 0)
			if not IsPlayingAnim("Loaded") then
				PlayAnimation("Loaded", 1, 0)
			end
		else
			StopAnimation("Loaded", 0)
			if not IsPlayingAnim("Unloaded") then
				PlayAnimation("Unloaded", 1, 0)
			end
		end
	end
	sightFront, sightBack, sightFlashPart = WeldModule:WeldAttachments(viewModelWeapon, item)
	UpdateAttachmentStats(item)
	local attachments = (hasItem and item.Attachments or {})
	local hasSight = false
	for _, attachment in pairs(attachments) do
		local attachmentInfo = Items[attachment.ID]
		if attachmentInfo and attachmentInfo.AttachmentType == "Sight" then
			hasSight = true
			continue
		end
		local attachmentStats = attachmentInfo.AttachmentStats
		if not (viewModelAttachments and attachmentStats and attachmentStats.Toggle) then continue end
		local attachmentModel = viewModelAttachments:FindFirstChild(attachmentInfo.Name)
		if not attachmentModel then continue end
		if attachmentInfo.Name == "Weapon Flashlight" then
			attachmentModel.Base.Light.Enabled = attachment.On
		elseif attachmentInfo.Name:find(" Lasersight") then
			local laser = attachmentModel.Laser
			laser.Laser.Enabled = attachment.On
			if attachment.On then
				VFXModule:InitializeLaser(laser)
			end
		end
	end
	if currentAnims.Local.SightFix then
		if hasSight and not IsPlayingAnim("SightFix") then
			PlayAnimation("SightFix")
		elseif not hasSight and IsPlayingAnim("SightFix") then
			StopAnimation("SightFix")
		end
	end
end

local function UpdateSleeves()
	if not (viewModel and viewModelArms and viewModelArms.Parent) then return end
	local allSleeves = (Player:GetAttribute("ArmorSleeves") or "")
	--print(allSleeves == "" and " " or allSleeves)
	local equippedSleeves = string.split(allSleeves, "^")
	--print(allSleeves, currentSleeves)
	for _, armorModel in pairs(viewModelArms:GetChildren()) do
		local armorName = armorModel.Name
		if not (armorName:sub(1, 5) == "Armor" and armorModel:IsA("Model")) then continue end
		local sleeveId = armorName:sub(6)
		local found = false
		for _, sleeve in pairs(equippedSleeves) do
			if sleeve ~= sleeveId then continue end
			found = true
			break 
		end
		if found then continue end
		armorModel:Destroy()
	end
	for _, sleeve in pairs(equippedSleeves) do
		if not (sleeve and sleeve ~= "") then continue end
		local name, skin = unpack(string.split(sleeve, "/"))
		local armorModel = Sleeves[name][skin]:Clone()
		local models = WeldModule:FullyWeldModels(armorModel, viewModelArms, true)
		for _, model in pairs(models) do
			model.Name = "Armor:"..sleeve
		end
	end
	--print("updated sleeves:", currentSleeves)
end

local function QueueSleeveUpdate()
	sleeveUpdateQueued = true
end

local function EquipViewmodel(equippedIndex, globalAnims, equipSpeedMult) -- Equips and sets up a viewmodel with the given name
	local equipped = GetEquipped(equippedIndex)
	local itemInfo = (equipped and Items[equipped.ID])
	local itemName = (itemInfo and (itemInfo.Type == "Bench" and "Blueprint" or itemInfo.Name))
	local currentEquipped = script:GetAttribute("Equipped")
	if currentEquipped > 0 and ((currentAnims.Local.Idle == nil and currentAnims.Global.Idle) or (currentModel and (currentEquipped ~= equippedIndex or (itemInfo and currentModel.Name ~= itemInfo.Name)))) then
		CloseViewmodel()
	end
	--print(currentModel, itemInfo and itemInfo.Name)
	if not (equipped and Hum.Parent and Hum.Health > 0) then return end 
	local toolInfo = ToolInfo[itemName]
	local folder = VMs:FindFirstChild(itemName)
	if not (folder and toolInfo) then return end
	local weaponInfo = toolInfo.Weapon
	local offsets = toolInfo.Offsets
	--print("equipping viewmodel")
	local newModel = (folder:FindFirstChild(equipped.Skin) or folder:FindFirstChild("Default"))
	local hl
	if newModel then
		newModel = newModel:Clone()
		newModel.Name = itemName
		viewModelPrim = newModel:WaitForChild("HumanoidRootPart")
		viewModelWeapon = newModel:WaitForChild("Weapon")
		viewModelArms = newModel:WaitForChild("Arms")
		viewModelRightArm = viewModelArms:WaitForChild("RightArm")
		viewModelAttachments = viewModelWeapon:FindFirstChild("Attachments")
		viewModelAimFront = viewModelWeapon:FindFirstChild("AimFront")
		viewModelAimBack = viewModelWeapon:FindFirstChild("AimBack")
		viewModelCasingRelease = viewModelWeapon:FindFirstChild("CasingRelease")
		viewModelFlashPart = viewModelWeapon:FindFirstChild("FlashPart")
		viewModelHandle = (viewModelWeapon:FindFirstChild("Handle") or viewModelWeapon.Main)

		defaultPos = offsets.Local
		vmRootPartBased = offsets.RootPartBased
		if viewModelAimBack then
			viewModelAimBack.CFrame = CFrame.new(viewModelAimBack.Position, viewModelAimFront.Position) * (offsets.SightBack or CFrame.new())
			WeldModule:WeldParts(viewModelAimBack, viewModelHandle)
		end

		viewModel = newModel
		currentModel = newModel
		for _, arm in pairs(viewModelArms and viewModelArms:GetChildren() or {}) do
			if not arm:IsA("BasePart") then continue end
			local charArm = Char:FindFirstChild(arm.Name:find("Left") and "LeftUpperArm" or "RightUpperArm")
			if not charArm then continue end
			arm.Color = charArm.Color
		end
		--local newVM = newModel:Clone()
		--viewModel = newVM
		--for _, child in pairs(newVM:GetDescendants()) do
		--	if child:IsA("Weld") or child:IsA("Motor6D") then
		--		child:Destroy()
		--	elseif child:IsA("BasePart") then
		--		child.Anchored = true
		--	end
		--end
		--newVM.Parent = workspace
		viewModel = newModel
		currentModel = newModel
		newModel.Parent = Camera
		LoadAnimations(folder, globalAnims)
		UpdateVMAppearance(equipped)
		QueueSleeveUpdate()
		hl = HIGHLIGHT:Clone()
		hl.Parent = viewModel
		hl.Enabled = true
		aimPos = (viewModelAimBack and viewModelPrim.CFrame:ToObjectSpace(viewModelAimBack.CFrame):inverse() or offsets.Aim) -- Get the offset for aiming position

		if Char.PrimaryPart then
			local equipSound = Char.PrimaryPart:FindFirstChild("Equip")
			if equipSound then
				SoundModule:PlaySound(equipSound)
			end
		end
	else
		LoadAnimations(folder, globalAnims)
	end
	--[[local localAnimsFolder = folder.LocalAnims:Clone()
	local globalAnimsFolder = folder.GlobalAnims:Clone()
	localAnimsFolder.Parent = newModel
	globalAnimsFolder.Parent = newModel]]

	script:SetAttribute("CanUse", (type(weaponInfo) == "table" and weaponInfo.CanSprintWhileAttacking))
	script:SetAttribute("SReduction", (type(weaponInfo) == "table" and weaponInfo.SReduction))
	script:SetAttribute("Equipped", equippedIndex)
	local ammo = equipped.Ammo
	script:SetAttribute("LocalAmmo", (ammo and ammo.Amount or 0))

	for _, vm in pairs(VM_PARTS:GetChildren()) do
		if vm == newModel then continue end
		vm:Destroy()
	end

	--add highlight to model
	vmToggled = true
	meleeAimState = "None"
	bowAimState = "None"
	forceUnaim = false

	PlayAnimation("Idle")
	PlayAnimation("Equip", (weaponInfo and weaponInfo.EquipAnimSpeed or 1) * (equipSpeedMult or 1))
	task.wait(0.1)
	if newModel and newModel.Parent then
		newModel.Parent = VM_PARTS
		if hl and hl.Parent then
			hl.Adornee = viewModel
		end
	end
end

local function ToggleViewmodel(t)
	if t == vmToggled or not viewModel then return end
	--print("toggling viewmodel", t)
	local armorModels = {}
	for _, model in pairs(viewModelArms:GetChildren()) do
		if not model:IsA("Model") then continue end
		table.insert(armorModels, model)
	end
	for _, value in pairs({viewModelArms, viewModelWeapon, (viewModelAttachments and viewModelAttachments:GetChildren() or {}), unpack(armorModels)}) do
		for _, model in pairs(type(value) == "table" and value or {value}) do
			--print(model)
			for _, part in pairs(model:GetChildren()) do
				if not part:IsA("BasePart") then continue end
				local origTrans = part:GetAttribute("OrigTrans")
				if not origTrans then
					if part.Transparency == 1 then continue end
					origTrans = part.Transparency
					part:SetAttribute("OrigTrans", origTrans)
				end
				part.Transparency = (t and origTrans or 1)
				if part.Name ~= "Bolt" then continue end
				for _, beam in pairs(part:GetChildren()) do
					if not beam:IsA("Beam") then continue end
					beam.Enabled = t
				end
			end
		end
	end
	vmToggled = t
	return true
end

local function RecoilVM(newPos, newRot, Duration)
	recoilAnim.Code = math.random(1, 1e8)
	recoilAnim.X = 0
	recoilAnim.Increment = 1.5 / Duration
	recoilAnim.PrevPos = recoilAnim.Pos
	recoilAnim.PrevRot = recoilAnim.Rot
	recoilAnim.NewPos = newPos
	recoilAnim.NewRot = newRot
end

local function CameraShake(shakeInfo, strengthMult)
	if not shakeInfo then return end
	local strength = (shakeInfo.Strength or Vector3.new(1, 1, 1)) * (strengthMult or 1)
	local speed = (shakeInfo.Speed or 1)
	local angles = (shakeInfo.Angles or {-75, 75})
	local snapBack = (shakeInfo.SnapBack)
	local delayTime = (shakeInfo.DelayTime or 0)
	if strength == 0 or speed <= 0 then return end
	if delayTime > 0 then
		task.wait(delayTime)
	end
	camRotSpringDone = 0
	camRotAlpha = 0
	camRotSpringSpeed = 0.15 * speed
	local angle = math.rad(math.random(angles[1], angles[2]))
	local x = math.sin(angle) / 300 * strength.X
	local y = math.cos(angle) / 225 * strength.Y
	local z = math.rad(math.random(-15, 15)) / 15 * strength.Z
	local yDown = math.rad(-0.3) * strength.Y
	cameraRotSpring.Damper = 0.6
	cameraRotSpring.Speed = 20
	targetRotSpring = Vector3.new(x, y, z)
	task.wait(0.15 * speed)
	cameraRotSpring.Damper = 0.4
	if shakeInfo.SnapBack then
		cameraRotSpring.Speed = 30
		targetRotSpring = Vector3.new(-x, -y + yDown, -z)
		task.wait(0.15 * speed)
		cameraRotSpring.Speed = 20
		targetRotSpring = Vector3.new(0, -yDown, 0)
		task.wait(0.175 * speed)
	end
	targetRotSpring = Vector3.new()
end

local function CreateHitMarker(hitType)
	Sound:PlayLocalSound(Sound[hitType])
	hitMarkerAnim = 0
	HitMarker.Rotation = math.random(430, 470) / 10
	local isHead = (hitType == "HitHead")
	for _, line in pairs(HitMarker:GetChildren()) do
		if not HitMarker.Visible then
			line.BackgroundColor3 = Color3.new(1, 1, 1)--(isHead and Color3.fromRGB(255, 202, 202) or Color3.new(1, 1, 1))
		end
		TweenUtil:Tween(line, "BackgroundColor3", (isHead and Color3.new(1, 0, 0) or Color3.new(1, 1, 1)), 0.09, "Quart", "In")
	end
	--[[
	HitMarker.Rotation = math.random(-50, 50) / 10
	HitMarker.Position = UDim2.new(0.5, 1 + math.random(-1, 1), 0.5, 1 + math.random(-1, 1))
	HitMarker.Size = UDim2.new(0, 20, 0, 20)
	HitMarker:TweenSize(UDim2.new(0, 30, 0, 30), "Out", "Quart", 0.3, true)]]
end

local function ReflectVector(v, axis)
	return v - 2 * (axis * v:Dot(axis))
end

local function CSquare(pos)
	return pos.X^2 + pos.Y^2 + pos.Z^2
end

local function TranslateVM(model, mirrorModel, flip)
	if not (currentModel and viewModel) then return end
	local prim = currentModel.HumanoidRootPart
	local mirrorPrim = viewModel.HumanoidRootPart
	for _, part in pairs(model:GetChildren()) do
		local mirrorPart = mirrorModel:FindFirstChild(part.Name)
		if not mirrorPart then continue end
		if part.Name ~= "HumanoidRootPart" and part:IsA("BasePart") and mirrorPart:IsA("BasePart") then
			local cf = part.CFrame
			if flip then
				local mirrorCF = prim.CFrame * CFrame.Angles(0, math.pi / 2, 0)
				local mirrorPoint = mirrorCF.Position
				local mirrorAxis = mirrorCF.LookVector
				local x, y, z, xx, yx, zx, xy, yy, zy, xz, yz, zz = cf:GetComponents()
				local newPos = mirrorPoint + ReflectVector(Vector3.new(x, y, z) - mirrorPoint, mirrorAxis)
				local xAxis = Vector3.new(xx, xy, xz)
				local yAxis = Vector3.new(yx, yy, yz)
				local zAxis = Vector3.new(zx, zy, zz)
				xAxis = ReflectVector(xAxis, mirrorAxis)
				yAxis = ReflectVector(yAxis, mirrorAxis)
				zAxis = ReflectVector(zAxis, mirrorAxis)
				xAxis = -xAxis
				cf = CFrame.new(newPos.X, newPos.Y, newPos.Z,
					xAxis.X,  yAxis.X,  zAxis.X,
					xAxis.Y,  yAxis.Y,  zAxis.Y,
					xAxis.Z,  yAxis.Z,  zAxis.Z)
				--[[
					[Enum.Axis.X] = {0, math.pi / 2, 0},
					[Enum.Axis.Y] = {math.pi / 2, 0, 0},
					[Enum.Axis.Z] = {0, 0, 0}
				]]
			end
			local offset = prim.CFrame:ToObjectSpace(cf)
			mirrorPart.CFrame = mirrorPrim.CFrame * offset
			--print("setting ", mirrorPart, "from", part)
		end
		TranslateVM(part, mirrorPart, flip)
	end
end

local function LocalHitFunction(args, detArgs, impactType, ignoreHitMarker)
	local hit = args[1]
	local position = args[2]
	local normal = args[3]
	local material = args[4]
	local id = args[5]
	local hitHums = (args[6] or {})
	local pos = ((hit and hit.Parent and position) and hit.CFrame:PointToObjectSpace(position))
	local materialName = (material and material.Name)
	--print("firing to server", id)
	local arguments = {
		[1] = hit,
		[2] = (pos or "nil"), 
		[3] = normal, 
		[4] = materialName, 
		[5] = id
	}
	if args[7] or args[8] then
		arguments = {
			[1] = args[8],
			[2] = args[7],
			[3] = hit,
			[4] = pos, 
			[5] = normal, 
			[6] = materialName, 
			[7] = id
		}
	end
	--print(arguments)
	VectorUtil:FireRemote(CombatRemotes, HitRemote, arguments)
	if not (hit and hit.Parent) then return end
	local hum = (hit.Parent:FindFirstChild("Humanoid") or hit.Parent.Parent:FindFirstChild("Humanoid"))
	local ignoreVFX = (impactType == true or (impactType and impactType ~= "Stick"))
	--print(impactType, ignoreVFX)
	if hum then
		local t = hitHums[hum]
		local hitType = (hit.Name == "Head" and "HitHead" or "Hit")
		if not t then
			t = {}
			hitHums[hum] = t
		end
		if not t[hitType] then
			t[hitType] = true
			if not ignoreHitMarker then
				CreateHitMarker(hitType)
			end
		end
		if ignoreVFX then return end
		task.defer(VFXModule.CreateBlood, VFXModule, unpack(args))
	elseif not ignoreVFX then
		local actualArgs = ((detArgs and detArgs[1] and detArgs[1].Parent) and detArgs or args)
		task.defer(VFXModule.CreateHole, VFXModule, actualArgs[1], actualArgs[2], actualArgs[3], actualArgs[4], nil, (impactType == "Stick"))
	end
end

local function SetupViewModelReequip(waitTime, equipped, equipSpeed, started)
	local oldViewmodel = viewModel
	started = (started or tick())
	local hadOne = (equipped.Amount == 1)
	while tick() - started < waitTime and viewModel == oldViewmodel do
		task.wait()
	end
	local newEquipped = GetEquipped()
	if newEquipped then
		if newEquipped.ID == equipped.ID then
			local hasOne = (newEquipped.Amount == 1)
			if hadOne and hasOne then
				CloseViewmodel()
			else
				local oldIndex = script:GetAttribute("Equipped")
				CloseViewmodel()
				EquipViewmodel(oldIndex, nil, equipSpeed)
			end
		end
	else
		CloseViewmodel()
	end
end

function MouseButton1DownFunc(isRightClick)
	if WheelController:GetAttribute("Open") then return end
	holdingMouse1 = true
	if script:GetAttribute("Using") then
		lastMouse1Click = tick()
		return 
	end
	--print("starting mouse1 loop")
	if mouse1Loop then
		task.cancel(mouse1Loop)
	end
	mouse1Loop = task.spawn(function()
		local first = true
		local checkingForAim = false
		local alreadyClicked = false
		local playedEmpty = false
		while holdingMouse1 or alreadyClicked do
			--print("running loop")
			first = false
			local equipped = GetEquipped()
			local ammo, ammoInfo, ammoStats, equippedInfo
			if equipped then
				ammo = equipped.Ammo
				equippedInfo = Items[equipped.ID]
			end
			if ammo then
				ammoInfo = Items[ammo.ID]
				ammoStats = ammoInfo.AmmoStats
			end
			local localAmmo = script:GetAttribute("LocalAmmo")
			if (equippedInfo and equippedInfo.Type ~= "Bench") and not (IsPlayingAnim("Equip") or reloading or InventoryController:GetAttribute("Open") or (not equipped) or (equippedInfo.MaxDurability and equipped.Durability <= 0)) then
				local equippedType = equippedInfo.Type
				local wepName = equippedInfo.Name
				local toolInfo = ToolInfo[wepName]
				local weaponInfo = toolInfo.Weapon
				local throwInfo = (weaponInfo ~= nil and weaponInfo.ThrowInfo)
				local isBow = (weaponInfo ~= nil and weaponInfo.IsBow)
				local meleeInfo = toolInfo.Melee
				local shakeInfo = toolInfo.Shake
				-- and not CameraController:GetAttribute("ViewmodelCFrame")
				if equippedType == "Gun" and Char.PrimaryPart and playedEmpty == false and weaponInfo and weaponInfo.IgnoreEmptyClick ~= true and not (ammo ~= nil and localAmmo > 0) then
					local emptySound = Char.PrimaryPart:FindFirstChild("GunEmpty")
					if emptySound then
						playedEmpty = true
						SoundModule:PlaySound(emptySound)
					end
				end -- bowAimState == "AimingIn2" or 
				if (
					(equippedType == "Gun" and ammo ~= nil and localAmmo > 0) or (equippedType == "Tool" and weaponInfo and weaponInfo.Cooldown)
					) and (
						(isBow and (bowAimState == "Holding" or bowAimState == "NoneJump") and not WaterController:GetAttribute("IsSwim")) or 
							((not isBow) and ((meleeInfo and meleeInfo.MeleeChecks) or tick() - timeSinceNoFall >= 0.1))) then
					local canUse = ((weaponInfo.AimDownSpeed == nil or (not throwInfo) or holdingMouse2 == false or meleeAimState == "Holding") and (equippedType ~= "Gun" or not CameraController:GetAttribute("ViewmodelCFrame")))
					script:SetAttribute("Using", canUse)
					if equippedType == "Gun" then
						CameraController:SetAttribute("FreeLooking", false)
					end
					if canUse then
						if weaponInfo.RequiresAim then
							alreadyClicked = true
							if not checkingForAim then
								checkingForAim = true
								if not holdingMouse2 then
									task.spawn(MouseButton2DownFunc, "Auto")
								end
							end
							if not fullyAimed then
								Run.Heartbeat:Wait()
								continue
							end
							if holdingMouse2 == "Auto" then
								MouseButton2UpFunc()
							else
								disableAim = true
								task.delay(0.7, function()
									disableAim = false
								end)
							end
						end
						if equippedType == "Gun" then
							local spreadInfo = toolInfo.Spread
							local bulletInfo = toolInfo.Bullet
							local casingInfo = toolInfo.Casing
							local recoilInfo = toolInfo.Recoil
							local recoilVM = recoilInfo.VM
							local recoilCam = recoilInfo.Camera
							local fireRateMult = 1 - (attachmentStats.FireRateMult or 0)
							local shootSpeed = 60 / weaponInfo.RPM * fireRateMult
							local burstSpeed = 60 / weaponInfo.BurstRPM * fireRateMult
							for _ = 1, weaponInfo.Burst do
								StopAnimation("Inspect", 0)
								StopAnimation("Shoot", 0)
								PlayAnimation("Shoot", 1, 0)
								if casingInfo and not casingInfo.IgnoreShoot then
									EjectCasing(casingInfo)
								end
								local isAiming = script:GetAttribute("Aiming")
								local flashPart = (sightFlashPart or viewModelFlashPart)
								if not (attachmentStats.Scope and isAiming) then
									VFXModule:FlashPart(flashPart)
								end
								local shootSound = Char.PrimaryPart:FindFirstChild(equippedInfo.Name.."Shoot")
								if shootSound then
									SoundModule:PlayDuplicateSound(shootSound, nil, nil, true)
								end
								lastUse = tick()
								local gunRecoilAimMult = 1 + (isAiming and attachmentStats["GunRecoilAimMult"] or 0)
								local shootingExtra = spreadInfo[isAiming and "Aiming" or "Hip"].ShootingExtra
								local attachmentSpreadMult = 1 + (attachmentStats[(isAiming and "Aim" or "Hip").."SpreadMult"] or 0)
								local ammoSpreadMult = (ammoStats[(isAiming and "Aim" or "Hip").."SpreadMult"] or 1)
								local shootingSpread = shootingExtra * attachmentSpreadMult * (shootingSpreadMult < 0.001 and 0 or shootingSpreadMult) * ammoSpreadMult
								shootingSpreadMult = math.min(shootingSpreadMult + 1 / spreadInfo.Shooting.BulletsForMax, 1)
								local totalSpread = ((baseSpread < 0.001 and 0 or baseSpread) + shootingSpread)
								local extraOffset = CFrame.Angles((bulletInfo.Offset or 0), 0, 0)
								local camCF = Camera.CFrame
								local suc, serverTick = pcall(function()
									return workspace:GetServerTimeNow() --Values.ServerTick.Value
								end)
								if not suc then
									warn("BULLET SYNCHRONIZATION INTERNAL ERROR: ", serverTick)
									continue
								end
								local bullets = {}
								local randomSeed = math.floor(serverTick * 10000)
								--print("client randomseed:", randomSeed, "client totalspread:", totalSpread)
								local random = Random.new(randomSeed)
								for _ = 1, (ammoStats.Bullets or 1) do
									local t = {
										Radius = random:NextNumber(0, math.floor(totalSpread * 100) / 100) / 500;
										Degree = random:NextNumber(0, 2 * math.pi);
										ID = random:NextInteger(1, math.ceil(1e9 * math.max(1, math.floor(totalSpread * 100) / 100)));
									}
									table.insert(bullets, t)
								end
								local flashPos = flashPart.Position
								local charPos = Char.PrimaryPart.CFrame * CFrame.new(0, 1.5, 0)
								local hitHums = {}
								local mousePos, mouseHit = RaycastUtil:MouseRaycast(hitIgnoreFilterFunc, {Char, VFX_PARTS})
								local bulletTracer = (attachmentStats.HideTracer and "" or ((equipped.Skin == "Frosty" or equipped.Skin == "Cherry Blossom" or equipped.Skin == "Vaporwave" or equipped.Skin == "VIP" or equipped.Skin == "Gingerbread" or equipped.Skin == "Diablo" or equipped.Skin == "High Tide" or equipped.Skin == "Valentine" or equipped.Skin == "Blue Gem" or equipped.Skin == "Monster" or equipped.Skin == "Crimson Glitched") and equipped.Skin.."Bullet" or ammoStats.TracerName))
								for _, bullet in pairs(bullets) do
									local spread = extraOffset * CFrame.Angles(math.sin(bullet.Degree) * bullet.Radius, math.cos(bullet.Degree) * bullet.Radius, 0)
									local id = bullet.ID
									VFXModule:CreateProjectile({
										Position = flashPos;
										Direction = (CFrame.new(flashPos, mousePos) * spread).LookVector;
										PositionFirst = charPos.p;
										DirectionFirst = (camCF * spread).LookVector;
										FilterType = "Blacklist";
										Filters = {Char, VFX_PARTS, Drops, Plants};
										FilterFunction = (ammoStats.FilterType or "Hit");
										VisualizeRay = script:GetAttribute("DebugShowRays");
										Speed = (bulletInfo.Speed * (1 + (attachmentStats.SpeedMult or 0))) * (ammoStats.SpeedMult or 1);
										Gravity = bulletInfo.Gravity * (ammoStats.GravityMult or 1);
										MaxRange = (bulletInfo.MaxRange * (1 + (attachmentStats.RangeMult or 0))) * (ammoStats.RangeMult or 1);
										Size = ammoStats.BulletSize;
										TracerName = bulletTracer;
										HitFunction = function(...)
											local args = {...}
											LocalHitFunction({args[1], args[2], args[3], args[4], id, hitHums}, nil, ammoStats.Impact)
										end;
										MissFunction = function()
											VectorUtil:FireRemote(CombatRemotes, HitRemote, {
												[1] = id
											})
											--print("miss")
										end;
									})
								end
								localAmmo -= 1
								script:SetAttribute("LocalAmmo", localAmmo)
								--print("tick on client", serverTick)
								VectorUtil:FireRemote(CombatRemotes, ActionRemote, {
									[1] = mousePos,
									[2] = shootingSpread, 
									[3] = baseSpread, 
									[4] = charPos, 
									[5] = charPos:PointToObjectSpace(flashPos), 
									[6] = camCF,--CFrame.new(camCF.Position, mousePos),
									[7] = equippedInfo.Name, 
									[8] = serverTick, 
								})
								RecoilVM(
									Vector3.new(TableUtil:TableRandom(recoilVM.Pos.X), TableUtil:TableRandom(recoilVM.Pos.Y), TableUtil:TableRandom(recoilVM.Pos.Z)), 
									Vector3.new(math.rad(TableUtil:TableRandom(recoilVM.Rot.Y)), math.rad(TableUtil:TableRandom(recoilVM.Rot.X)) * gunRecoilAimMult, math.rad(TableUtil:TableRandom(recoilVM.Rot.Z)) * gunRecoilAimMult), 
									recoilVM.StartTime
								)
								local newCode = recoilAnim.Code
								recoilReset = 0
								recoilAmount = recoilAmount + 1
								lastRecoilReset = tick()
								local recStartX, recStartY = recoilCam.RecoilStart(recoilAmount)
								local recEndX, recEndY = recoilCam.RecoilFinish(recoilAmount)
								recStartX = recStartX + TableUtil:TableRandom(recoilCam.Shake.Y)
								recStartY = recStartY + TableUtil:TableRandom(recoilCam.Shake.X)
								recStartX, recStartY = -math.rad(recStartY), math.rad(recStartX)
								recEndX, recEndY = -math.rad(recEndY), math.rad(recEndX)
								local started = tick()
								local steps = 0
								local stepsTotal = 0
								local actualStepsTotal = 0
								local finishDuration = recoilCam.Duration - recoilCam.FinishStart
								local step = 0
								task.spawn(function()
									--print("starting camera loop")
									local doingCam = true
									local didVM = false
									while doingCam or not didVM do
										local frameworkSpeed = script:GetAttribute("DebugFrameworkSpeed")
										local step = Run.Heartbeat:Wait() * frameworkSpeed
										if doingCam then
											local aimMult = (script:GetAttribute("Aiming") and 0.7 or 1.2) * (StateController:GetAttribute("IsCrouch") and 0.75 or 1) * (1 + (attachmentStats.RecoilMult or 0))
											local old = steps
											steps = math.min(steps + step, recoilCam.FinishStart)
											local newStep = steps - old
											local dt = newStep / recoilCam.FinishStart * aimMult
											local rec = CFrame.Angles(recStartY * dt, recStartX * dt, 0)
											totalRecoil = totalRecoil * rec
											Camera.CFrame = Camera.CFrame * rec
											local oldTotal = actualStepsTotal
											stepsTotal = math.min(stepsTotal + step, recoilCam.Duration)
											actualStepsTotal = math.clamp(stepsTotal - recoilCam.FinishStart, 0, finishDuration)
											local newStepTotal = actualStepsTotal - oldTotal
											local dtTotal = newStepTotal / finishDuration * aimMult
											local recTotal = CFrame.Angles(recEndY * dtTotal, recEndX * dtTotal, 0)
											totalRecoil = totalRecoil * recTotal
											Camera.CFrame = Camera.CFrame * recTotal
											if tick() - started >= recoilCam.Duration / frameworkSpeed then
												doingCam = false
											end
										end
										if tick() - started >= recoilVM.StartTime / frameworkSpeed and not didVM then
											didVM = true
											if recoilAnim.Code == newCode or not recoilAnim.Code then
												RecoilVM(Vector3.new(), Vector3.new(), recoilVM.EndTime)
											end
										end
									end
									--print("ended camera loop")
								end)
								task.defer(CameraShake, shakeInfo, (isAiming and 0.4 or 1))
								if weaponInfo.BurstRPM > 0 then
									task.wait(burstSpeed)
									if localAmmo <= 0 or IsPlayingAnim("Equip") or InventoryController:GetAttribute("Open") or CameraController:GetAttribute("ViewmodelCFrame") or tick() - timeSinceNoFall < 0.1 or (not GetEquipped()) or equipped.Durability == nil or equipped.Durability <= 0 then
										script:SetAttribute("Using", false)
										if not equipped then
											return
										else
											break
										end
									end
								end
							end
							if isBow then
								StopAnimation("AimStart")
								StopAnimation("AimHold")
								bowAimState = "None"
								forceUnaim = false
								for _, part in pairs(viewModelWeapon:GetChildren()) do
									if not (part:IsA("BasePart") and part.Name:find("Arrow")) then continue end
									part.Transparency = 1
								end
								--[[
								local arrowDetail = viewModelWeapon.ArrowDetail
								arrowDetail.Transparency = 1
								task.delay(0.75, function()
									if not (arrowDetail and arrowDetail.Parent) then return end
									arrowDetail.Transparency = 0
								end)]]
							end
							task.wait(shootSpeed)
							local boltSpeed = (weaponInfo.BoltAnimSpeed or 1)
							if currentAnims.Local.Bolt then
								local oldViewModel = viewModel
								local boltAnim = PlayAnimation("Bolt", boltSpeed)
								if not boltAnim then continue end
								task.wait(boltAnim.Length)
								if not (oldViewModel and oldViewModel.Parent) then continue end
								StopAnimation("Bolt")
							end
						else
							StopAnimation("Inspect", 0)
							StopAnimation("Hit", 0.1)
							StopAnimation("Miss", 0.1)
							lastUse = tick()
							local suc, serverTick = pcall(function()
								return workspace:GetServerTimeNow() --Values.ServerTick.Value
							end)
							if not suc then
								warn("MELEE SYNCHRONIZATION INTERNAL ERROR: ", serverTick)
								continue
							end
							local throwLogic = (throwInfo and throwInfo.Logic)
							if throwInfo and (throwLogic ~= "Normal" or meleeAimState == "Holding") then
								StopAnimation("ThrowHold")
								StopAnimation("Aim")
								local oldViewModel = viewModel
								if currentAnims.Local.Light then
									--SoundModule:PlaySound(Char.PrimaryPart[wepName.."Light"], true)
									local lightAnim = PlayAnimation("Light")
									if not lightAnim then break end
									local effectPart = viewModelHandle:FindFirstChild("Effect")
									if effectPart then
										task.delay(0.5, function()
											if not (effectPart and effectPart.Parent) then return end
											for _, effect in pairs(effectPart:GetChildren()) do
												effect.Enabled = true
											end
											viewModelHandle.Fuse:Play()
										end)
									end
									task.wait(lightAnim.Length)
									if not (oldViewModel and oldViewModel.Parent) then break end
									StopAnimation("Light")
								end
								local animList = ((throwLogic == "Grenade" or throwLogic == "PlaceableGrenade") and {"ThrowStart", (isRightClick and "UnderHandThrow" or "OverHandThrow")} or {"Throw"})
								local throwAnim
								local started
								for i, v in pairs(animList) do
									throwAnim = PlayAnimation(v)
									if not throwAnim then return end
									if i == #animList then
										if throwLogic ~= "Normal" then
											started = tick()
											task.wait(0.3)
											if not (oldViewModel and oldViewModel.Parent) then break end
											for _, part in pairs(viewModelWeapon:GetChildren()) do
												part.Transparency = 1
												local effects = part:FindFirstChild("Effect")
												if not effects then continue end
												effects:ClearAllChildren()
												local fuseSound = part:FindFirstChild("Fuse")
												if not fuseSound then continue end
												fuseSound:Stop()
											end
										end
										continue
									end
									task.wait(throwAnim.Length)
									StopAnimation(v)
								end
								local camCF = (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame)
								local throwArgs = {
									[1] = camCF * CFrame.new(0.5, 0, 0) * CFrame.Angles((throwInfo.Offset or 0), 0, 0),
									[2] = wepName, 
									[3] = serverTick, 
								}
								if throwLogic == "PlaceableGrenade" and isRightClick then
									local mousePos, mouseHit = RaycastUtil:MouseRaycast(viewFilterFunc, {VFX_PARTS, Char, Drops, Plants}, 4)
									if mouseHit then
										table.insert(throwArgs, 1, mouseHit.CFrame:PointToObjectSpace(mousePos))
										table.insert(throwArgs, 1, mouseHit)
									else
										table.insert(throwArgs, 1, 0)
									end
								elseif throwLogic == "Grenade" and isRightClick then
									table.insert(throwArgs, 1, 0)
								end
								VectorUtil:FireRemote(CombatRemotes, ActionRemote, throwArgs)
								task.spawn(CameraShake, {
									Strength = Vector3.new(4, 4, 4); 
									Speed = 0.25;
									Angles = {-179, 180};
									SnapBack = true;
								})
								if throwLogic == "Normal" then
									started = tick()
									while tick() - started < throwAnim.Length and throwAnim.IsPlaying and viewModel == oldViewModel do
										task.wait()
									end
								end
								meleeAimState = "None"
								if throwLogic == "Normal" then
									script:SetAttribute("Using", false)
									holdingMouse1 = false
									return
								else
									SetupViewModelReequip(math.max(throwAnim.Length, 0.46), equipped, 3, started)
									break
								end
							else
								VectorUtil:FireRemote(CombatRemotes, ActionRemote, {
									[1] = equippedInfo.Name, 
									[2] = serverTick, 
								})
								task.spawn(CameraShake, shakeInfo)
								local cooldown = weaponInfo.Cooldown
								if weaponInfo.KeycardColor then -- TO ADD MORE LOGICS, JUST ADD IFELSE STATEMENTS TO THIS ()
									StopAnimation("Use")
									PlayAnimation("Use", 1)
									task.wait(cooldown) -- Don't forget to make it wait
								elseif wepName == "Lighter" then
									local oldViewModel = viewModel
									StopAnimation("Use")
									PlayAnimation("Use", 1)
									task.wait(0.5)
									if not (oldViewModel and oldViewModel.Parent) then break end
									viewModelWeapon.LightPart.ParticleEmitter.Enabled = not viewModelWeapon.LightPart.ParticleEmitter.Enabled
									viewModelWeapon.LightPart.PointLight.Enabled = not viewModelWeapon.LightPart.PointLight.Enabled
									task.wait(math.max(cooldown - 0.5, 0))
								elseif weaponInfo.HealthItem then --Med pen / bandage use
									local animScale = weaponInfo.AnimationTimeScale
									StopAnimation("Use")
									PlayAnimation("Use", animScale)
									SetupViewModelReequip(cooldown, equipped, 1)
									break
								else
									-- Default to melee if tool doesn't have any other logic
									local swingSpeed = (weaponInfo.SwingAnimSpeed or 1)
									StopAnimation("Swing", 0)
									PlayAnimation("Swing", swingSpeed)
									local windupAnim = PlayAnimation("Windup", swingSpeed, 0)
									if windupAnim then
										local length = windupAnim.Length
										local started = tick()
										local currentCheck = 0
										local closestHit, closestPos, closestNor, closestMat, closestCF, closestDir
										local closestPriority = 0
										local closestDist = math.huge
										local closestCheck = 0
										local closestCheckIndex = 0
										local meleeChecks = meleeInfo.MeleeChecks
										--print("starting melee swing")
										local oldViewModel = viewModel
										while Run.Heartbeat:Wait() do
											if viewModel ~= oldViewModel then
												script:SetAttribute("Using", false)
												break
											end
											local passed = tick() - started
											local r = math.clamp(passed / length, 0, 1)
											local lastCheck = currentCheck
											currentCheck = 0
											for i, v in pairs(meleeChecks) do
												currentCheck = (r >= v[1] and i or currentCheck)
											end
											--print(lastCheck, currentCheck)
											if lastCheck ~= currentCheck then
												local cf = (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame)
												for index, rayInfo in pairs(meleeChecks[currentCheck][2]) do
													local origin = (cf * rayInfo.Offset).Position
													local direction = cf.LookVector * rayInfo.Range
													local hit, position, normal, material, visualPart = RaycastUtil:Raycast(origin, direction, "Blacklist", {Char, VFX_PARTS, Drops, Plants}, script:GetAttribute("DebugShowRays"), hitMeleeFilterFunc, true)
													if visualPart then
														Debris:AddItem(visualPart, 3)
													end
													local priority = 0
													local dist = math.huge
													if hit and hit.Parent then
														local name = hit.Name
														local parent = hit.Parent
														local hum = (parent:FindFirstChild("Humanoid") or parent.Parent:FindFirstChild("Humanoid"))
														priority = (hum and (name == "Head" and 7 or (name:find("Torso") and 6 or (name:find("Arm") and 5 or 4))) or ((parent.Name == "NodeSpark" or parent.Name == "TreeX") and 3 or (hit:IsA("Terrain") and 1 or 2)))
														dist = (position - origin).Magnitude
													end
													if priority > closestPriority or (priority == closestPriority and dist < closestDist) then
														closestHit = hit
														closestPos = position
														closestNor = normal
														closestMat = material
														closestCF = cf
														closestDir = direction
														closestCheck = currentCheck
														closestCheckIndex = index
														closestPriority = priority
														closestDist = dist
													end
												end
												--print("check changed so firing rays: current highest -", (closestHit and closestHit:GetFullName()), closestPriority)
											end
											if r >= 1 then break end
										end
										--print("ended melee swing")
										if script:GetAttribute("Using") then
											StopAnimation("Windup", 0)
											local swingSound = Char.PrimaryPart:FindFirstChild(equippedInfo.Name.."Swing")
											if swingSound then
												SoundModule:PlayDuplicateSound(swingSound, nil, nil, true)
											end
											local randomSeed = math.floor(serverTick * 10000)
											local random = Random.new(randomSeed)
											local id = random:NextInteger(1, 1e10)
											closestCF = (closestCF or (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame))
											local detHit, detPos, detNor, detMat
											if closestDir then
												detHit, detPos, detNor, detMat = RaycastUtil:Raycast(closestCF.Position, closestDir * 1.5, "Blacklist", {Char, VFX_PARTS, Drops, Plants}, script:GetAttribute("DebugShowRays"), hitMeleeIgnoreFilterFunc, true)
											end
											if closestHit and closestHit.Parent then
												cameraBounceSpring.Target = Vector3.new(math.random(-15, 15) / 100, math.random(-15, 15) / 100, 0.5) * (meleeInfo.BounceMult or 1)
											end
											task.spawn(function()
												LocalHitFunction({closestHit, closestPos, closestNor, closestMat, id, nil, closestCF, closestCheck}, {detHit, detPos, detNor, detMat}, true, (equipped.ID == 31))
											end)
											local animName = (closestHit and "Hit" or "Miss")
											local chosenAnim = PlayAnimation(animName, swingSpeed, (animName == "Hit" and 0.1 or 0.4), 10)
											--print(chosenAnim.Name, chosenAnim.Length)
											task.wait(cooldown - length)
										end
									else
										Run.Heartbeat:Wait()
									end
								end
							end
						end
						alreadyClicked = false
						if script:GetAttribute("Using") and not (weaponInfo.Auto or tick() - lastMouse1Click <= 0.2) then
							script:SetAttribute("Using", false)
							return
						end
					else
						checkingForAim = false
						Run.Heartbeat:Wait()
					end
				else
					checkingForAim = false
					Run.Heartbeat:Wait()
				end
			else
				checkingForAim = false
				Run.Heartbeat:Wait()
			end
		end
		--print("ended mouse1 loop")
		script:SetAttribute("Using", false)
	end)
end

local function MouseButton1UpFunc()
	holdingMouse1 = false
end

function MouseButton2DownFunc(replace) -- Function for right-clicking (it's a function for adding a keyboard key alternative)
	local oldHolding = holdingMouse2
	if replace then
		holdingMouse2 = replace
	else
		holdingMouse2 = true
	end
	if replace == nil and oldHolding == "Auto" then return end
	while holdingMouse2 ~= false do
		fullyAimed = false
		local using = script:GetAttribute("Using")
		if holdingMouse2 == "Auto" and not using then
			MouseButton2UpFunc()
		end
		local isAiming = script:GetAttribute("Aiming")
		local equipped = GetEquipped()
		local equippedInfo = (equipped and Items[equipped.ID])
		local toolInfo = (equippedInfo and ToolInfo[equippedInfo.Name])
		local weaponInfo = (toolInfo and toolInfo.Weapon)
		local throwInfo = (weaponInfo and weaponInfo.ThrowInfo)
		if throwInfo and (throwInfo.Logic == "Grenade" or throwInfo.Logic == "PlaceableGrenade") then
			return MouseButton1DownFunc(true)
		end
		local canAim = true
		if (not equippedInfo) or equippedInfo.Type == "Bench" or equippedInfo.Name == "Blueprint" or disableAim or IsPlayingAnim("Equip") or reloading or IsPlayingAnim("Bolt") or IsPlayingAnim("Throw") or InventoryController:GetAttribute("Open") or CameraController:GetAttribute("FreeLooking") or tick() - timeSinceNoFall < 0.1 or not equipped then
			canAim = false
		elseif equippedInfo.Type == "Tool" and (weaponInfo.AimDownSpeed == nil or using) then
			canAim = false
		end
		if canAim then
			if not isAiming then
				script:SetAttribute("Aiming", true)
				PlayAnimation("Aim")
				StopAnimation("Inspect")
				UpdateAttachmentStats(equipped)
			end
			fullyAimed = (aimX >= 1)
		elseif isAiming then
			script:SetAttribute("Aiming", false)
			StopAnimation("Aim")
			UpdateAttachmentStats(equipped)
		end
		Run.Heartbeat:Wait()
	end
	script:SetAttribute("Aiming", false)
	StopAnimation("Aim")
end

function MouseButton2UpFunc() -- Function for letting go of right click
	holdingMouse2 = false
end

local function ReloadDownFunc(onlyCheck)
	holdingReload = true
	local total = 0
	local ammos = {}
	local equippedIndex, equippedAmmo, maxAmmo
	local isBow = false
	local first = true
	--print("starting reloading loop", onlyCheck)
	while total < 0.5 do
		if onlyCheck and not first then break end
		first = false
		local step = (onlyCheck and 0.1 or Run.Heartbeat:Wait())
		local equipped = GetEquipped()
		equippedIndex = script:GetAttribute("Equipped")
		isBow = ((currentAnims.Local.Reload or currentAnims.Local.Reload1) == nil)
		if IsPlayingAnim("Equip") or reloading or IsPlayingAnim("Reload") or IsPlayingAnim("Bolt") or InventoryController:GetAttribute("Open") or script:GetAttribute("Using") or not equipped then
			total = 0
			--print("reset")
			if not holdingReload then break end
		else
			if not holdingReload then break end
			--print("checking for ammos")
			local equippedInfo = Items[equipped.ID]
			local equippedAmmoType = equippedInfo.AmmoType
			equippedAmmo = equipped.Ammo
			maxAmmo = equippedInfo.BaseMaxAmmo
			if not equippedAmmoType then continue end
			local invInfo = InventoryController.Fetch:Invoke()
			ammos = {}
			for _, containerName in pairs({"Inventory", "Toolbar"}) do
				local container = invInfo[containerName]
				for _, item in pairs(container) do
					if item == 0 or item.Amount <= 0 then continue end
					local id = item.ID
					local amount = item.Amount
					local info = Items[id]
					local ammoType = info.AmmoType
					if info.Type ~= "Ammo" or equippedAmmoType ~= ammoType then continue end
					local found = false
					for _, ammo in pairs(ammos) do
						if ammo.ID ~= id then continue end
						ammo.Amount += amount
						found = true
						break
					end
					if found then continue end
					table.insert(ammos, {
						ID = id;
						Amount = amount;
						IsEquipped = (equippedAmmo ~= nil and equippedAmmo.ID == id)
					})
				end
			end
			--[[
			table.sort(ammos, function(a, b)
				local aP = a.Priority
				local bP = b.Priority
				return aP < bP or (aP == bP and a.ID < b.ID)
			end)]]
			--print(ammos)
			if #ammos <= 0 then continue end
			total += step
		end
		if onlyCheck then break end
	end
	--print("ended reload loop")
	--print(total)
	if total <= 0 or (not ammos) or (total < 0.5 and equippedAmmo and maxAmmo and equippedAmmo.Amount >= maxAmmo) then return false end
	local newAmmoReload
	if total >= 0.5 then
		local wheelInfo = {}
		for _, ammo in pairs(ammos) do
			local info = Items[ammo.ID]
			table.insert(wheelInfo, {
				Image = info.AmmoWheelImage;
				Name = info.Name;
				Description = info.Description;
				Cost = NumberUtil:FormatNumber(ammo.Amount).." Left";
				Selectable = true;
				SelectFirst = ammo.IsEquipped;
			})
		end
		local selected = WheelController.Open:Invoke(wheelInfo, "Reload", true)
		--print(selected)
		if not selected then return end
		local selectedAmmo = ammos[selected]
		if (not selectedAmmo) or (equippedAmmo and equippedAmmo.ID == selectedAmmo.ID and maxAmmo and equippedAmmo.Amount >= maxAmmo) then return end
		newAmmoReload = selectedAmmo.ID
	elseif isBow and not onlyCheck then
		return
	end
	if equippedIndex ~= script:GetAttribute("Equipped") then return end
	local equipped = GetEquipped()
	local equippedInfo = Items[equipped.ID]
	local toolInfo = ToolInfo[equippedInfo.Name]
	local weaponInfo = toolInfo.Weapon
	VectorUtil:FireRemote(CombatRemotes, ReloadRemote, {
		[1] = (newAmmoReload or "None"),
		[2] = workspace:GetServerTimeNow()
	})
	local ammoId = newAmmoReload
	if not ammoId then
		for _, ammo in pairs(ammos) do
			if not ammo.IsEquipped then continue end
			ammoId = ammo.ID
			break
		end
	end
	local displayAmmo = (ammoId or ammos[1].ID)
	if onlyCheck then 
		return true, displayAmmo
	end
	local isAiming = script:GetAttribute("Aiming")
	task.delay(((isBow and isAiming) and 1 or 0.1), function()
		if not (viewModelWeapon and viewModelWeapon.Parent) then return end
		WeldModule:WeldAttachments(viewModelWeapon, equipped, nil, nil, displayAmmo)
	end)
	if isBow then
		if isAiming then
			forceUnaim = true
		end
		return
	end
	StopAnimation("Inspect")
	reloading = true
	local boltFed = weaponInfo.BoltFed
	local reloadAnimSpeed = weaponInfo.ReloadAnimSpeed
	local oldViewModel = viewModel
	local reloadId = currentReloadId
	task.delay(0.1, function()
		if not (oldViewModel and oldViewModel.Parent) then return end
		StopAnimation("Unloaded", 0)
		StopAnimation("Loaded", 0)
	end)
	if boltFed then
		local animSpeeds = (reloadAnimSpeed or {})
		local reloadAnim1 = PlayAnimation("Reload1", animSpeeds[1])
		if not reloadAnim1 then return end
		task.wait(reloadAnim1.Length / animSpeeds[1])
		if not (oldViewModel and oldViewModel.Parent) then return end
		local con
		con = InputService.InputBegan:Connect(function(input, notProccessed)
			local inputType = input.UserInputType
			if InputService:GetFocusedTextBox() or notProccessed or inputType ~= Enum.UserInputType.MouseButton1 then return end
			if reloadId == currentReloadId then
				VectorUtil:FireRemote(CombatRemotes, ReloadRemote, {
					[1] = "Cancel",
					[2] = workspace:GetServerTimeNow()
				})
			end
			reloadId = nil
			con:Disconnect()
		end)
		while reloadId == currentReloadId do
			StopAnimation("Reload2")
			local reloadAnim2 = PlayAnimation("Reload2", animSpeeds[2])
			if not reloadAnim2 then return end
			task.wait(reloadAnim2.Length / animSpeeds[2])
			if not (oldViewModel and oldViewModel.Parent) then return end
		end
		local reloadAnim3 = PlayAnimation("Reload3", animSpeeds[3])
		if not reloadAnim3 then return end
		task.wait(weaponInfo.ReloadAnimTime or reloadAnim3.Length / animSpeeds[3])
	else
		local reloadAnim = PlayAnimation("Reload", reloadAnimSpeed)
		if not reloadAnim then return end
		task.wait(weaponInfo.ReloadAnimTime or reloadAnim.Length / reloadAnimSpeed)
	end
	reloading = false
end

local function ReloadUpFunc()
	holdingReload = false
	WheelController.Close:Invoke("Reload")
end

local function InspectFunc()
	if currentModel == nil or IsPlayingAnim("Equip") or reloading or script:GetAttribute("Using") or script:GetAttribute("Aiming") then return end
	StopAnimation("Inspect")
	PlayAnimation("Inspect")
end

local function ToggleAttachmentFunc()
	local equipped = GetEquipped()
	if not (equipped and viewModel) then return end
	local attachments = equipped.Attachments
	if not attachments then return end
	--print("toggling attachments")
	local change
	for _, attachment in pairs(attachments) do
		local attachmentInfo = Items[attachment.ID]
		local attachmentStats = attachmentInfo.AttachmentStats
		if not (attachmentStats and attachmentStats.Toggle) then continue end
		attachment.On = (not attachment.On)
		change = attachment.ID
	end
	if not change then return end
	local press = tick()
	if press - lastAttachmentPress < 0.15 then return end
	lastAttachmentPress = press
	script.AttachmentToggle.PlaybackSpeed = math.random(95, 105) / 100
	Sound:PlayLocalSound(script.AttachmentToggle)
	VectorUtil:FireRemote(CombatRemotes, AttachmentRemote, {
		[1] = change
	})
	UpdateVMAppearance(equipped)
end

local function JumpFunc()
	if not (Hum and Hum.Parent and tick() - lastLand >= 0.25 and not jumpForce) then return end
	Hum.Jump = true
end

local function FixAttachmentChild(child)
	if child.Name == "Reticle" then
		task.spawn(function()
			if not (child and child.Parent) then return end
			local reticleFront = child:WaitForChild("ReticleFront", 5)
			if not reticleFront then return end
			reticleFront.Enabled = false
		end)
		local reticleBack = child:WaitForChild("ReticleBack", 5)
		if not reticleBack then return end
		reticleBack.Enabled = false
	end
	for i = 1, 2 do
		if child.Name ~= (i == 1 and "Base" or "Laser") then continue end
		for o = 1, 2 do
			local effect = child:WaitForChild(i == 1 and (o == 1 and "Light" or "Extender") or "Laser", 5)
			if not effect then break end
			if o == 2 then
				effect = effect:FindFirstChild("Light")
				if not effect then break end
			end
			effect.Enabled = false
			--print(effect.Name, "was found, turning off")
			effect:GetPropertyChangedSignal("Enabled"):Connect(function()
				--print(effect.Name, "was turned on, turning off")
				effect.Enabled = false
			end)
			if i == 2 then break end
		end
	end
end

local function FixLocalAttachment(attachment)
	if not (attachment and attachment.Parent) then return end
	--print("fixing local attachments")
	attachment.ChildAdded:Connect(FixAttachmentChild)
	for _, child in pairs(attachment:GetChildren()) do
		FixAttachmentChild(child)
	end
end

local function CheckModelChild(child)
	if child.Name == "Bolt" then
		for _, beam in pairs(child:GetChildren()) do
			if not beam:IsA("Beam") then continue end
			beam.Enabled = false
		end
		child.ChildAdded:Connect(function(beam)
			if not beam:IsA("Beam") then return end
			beam.Enabled = false
		end)
	elseif child:IsA("Beam") then
		child.Enabled = false
	elseif child.Name == "LightPart" then
		for _, effect in pairs(child:GetChildren()) do
			effect.Enabled = false
			effect:GetPropertyChangedSignal("Enabled"):Connect(function()
				effect.Enabled = false
			end)
		end
		child.ChildAdded:Connect(function(effect)
			effect.Enabled = false
			effect:GetPropertyChangedSignal("Enabled"):Connect(function()
				effect.Enabled = false
			end)
		end)
	end
end

local function CheckModel(model)
	if not (model and model.Parent and model:IsA("Model")) then return end
	if model.Name == "HolsterModel" or model.Name == "Crossbow" or model.Name == "Wooden Bow" or model.Name == "Lighter" then
		model.ChildAdded:Connect(CheckModelChild)
		for _, child in pairs(model:GetChildren()) do
			CheckModelChild(child)
		end
	end
	task.defer(function()
		local attachments = model:WaitForChild("Attachments", 5)
		if not attachments then return end
		attachments.ChildAdded:Connect(function(attachment)
			--print("attachment child added", attachment)
			FixLocalAttachment(attachment)
		end)
		for _, attachment in pairs(attachments:GetChildren()) do
			FixLocalAttachment(attachment)
		end
	end)
end

--Events

InputService.InputBegan:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	local textBox = InputService:GetFocusedTextBox()
	if textBox then return end
	if inputType == Enum.UserInputType.MouseButton1 and not (notProcessed or Codelock.Visible or GiveBed.Visible or RenameBed.Visible) then -- Shooting / action
		MouseButton1DownFunc()
	elseif inputType == Enum.UserInputType.MouseButton2 and not notProcessed then -- ADS
		MouseButton2DownFunc()
	elseif inputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		local canMoveVM = script:GetAttribute("DebugEnableVMMovement")
		if key == Enum.KeyCode.R and not notProcessed then -- Reload
			ReloadDownFunc()
		elseif key == Enum.KeyCode.F and not notProcessed then -- Attachment toggle
			ToggleAttachmentFunc()
		elseif key == Enum.KeyCode.N and not notProcessed then -- Inspect
			InspectFunc()
		elseif key == Enum.KeyCode.Z and not notProcessed then -- ADS
			MouseButton2DownFunc()
		elseif key == Enum.KeyCode.Space and not notProcessed then -- Jump
			JumpFunc()
		elseif (key == Enum.KeyCode.J or key == Enum.KeyCode.U or key == Enum.KeyCode.K or key == Enum.KeyCode.I or key == Enum.KeyCode.L or key == Enum.KeyCode.O) and canMoveVM then
			-- For debug moving / rotating vm
			local equipped = GetEquipped()
			if not equipped then return end
			local itemInfo = Items[equipped.ID]
			local toolInfo = ToolInfo[itemInfo.Name]
			if toolInfo and toolInfo.Offsets and toolInfo.Offsets.Local then
				local spd = script:GetAttribute("DebugVMMovementAmount")
				local lol = {
					J = {CFrame.new(-spd, 0, 0), CFrame.Angles(0, spd, 0)};
					U = {CFrame.new(spd, 0, 0), CFrame.Angles(0, -spd, 0)};
					K = {CFrame.new(0, -spd, 0), CFrame.Angles(spd, 0, 0)};
					I = {CFrame.new(0, spd, 0), CFrame.Angles(-spd, 0, 0)};
					L = {CFrame.new(0, 0, -spd), CFrame.Angles(0, 0, spd)};
					O = {CFrame.new(0, 0, spd), CFrame.Angles(0, 0, -spd)};
				}
				local n = (script:GetAttribute("DebugVMRotating") and 2 or 1)
				if lol[key.Name] then
					--print("yup")
					extraVmPos = extraVmPos * lol[key.Name][n]
					--print(lol[key.Name][n].p)
					task.wait(0.25)
					while InputService:IsKeyDown(key) do
						extraVmPos = extraVmPos * lol[key.Name][n]
						task.wait()
					end
				end
			end
			--end
		elseif key == Enum.KeyCode.P and canMoveVM then
			-- Print current vm CFrame
			local equipped = GetEquipped()
			if not equipped then return end
			local itemInfo = Items[equipped.ID]
			local toolInfo = ToolInfo[itemInfo.Name]
			if toolInfo and toolInfo.Offsets and toolInfo.Offsets.Local then
				local p = {}
				local roundTo = script:GetAttribute("DebugPrintRoundedDecimalPoints")
				for i, v in pairs({(vmPos * extraVmPos):GetComponents()}) do
					p[i] = math.ceil(v * 10 ^ roundTo) / 10 ^ roundTo
				end
				print("CFrame.new("..table.concat(p, ", ")..");")
			end
		elseif key == Enum.KeyCode.H and (canMoveVM or Run:IsStudio()) and not notProcessed then-- and Run:IsStudio() and not textBox then
			-- Toggle third person
			Player.CameraMode = Enum.CameraMode.Classic
			Player.CameraMaxZoomDistance = 10
		end
	end
end)

InputService.InputEnded:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	if inputType == Enum.UserInputType.MouseButton1 then -- Shooting / action
		MouseButton1UpFunc()
	elseif inputType == Enum.UserInputType.MouseButton2 then -- ADS
		MouseButton2UpFunc()
	elseif inputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		if key == Enum.KeyCode.Z then -- ADS
			MouseButton2UpFunc()
		elseif key == Enum.KeyCode.R then
			ReloadUpFunc()
		end
	end
end)

InputService.InputChanged:Connect(function(input) -- Check any change in player input
	local inputtype = input.UserInputType
	if inputtype == Enum.UserInputType.MouseMovement then
		-- Make VM sway depending on how much the mouse moved, cap it at a certain speed as well
		desiredSwayX = math.min(math.max(input.Delta.x * 1.5, -maxSwaySpeed), maxSwaySpeed)-- * rdt
		desiredSwayY = math.min(math.max(input.Delta.y * 1.5, -maxSwaySpeed), maxSwaySpeed)-- * rdt
		lastMouseMoved = tick()
		--[[local inputDelta = Vector2.new(input.Delta.x, input.Delta.y)
		inputDelta = inputDelta * Vector2.new( 0.002 * math.pi, 0.0015 * math.pi) * (Camera.FieldOfView / 70)
		totalRecoil = totalRecoil * CFrame.Angles((inputDelta.y > 0 and -inputDelta.y or 0), (inputDelta.x < 0 and -inputDelta.x or 0), 0)
		local r1, r2, r3 = totalRecoil:ToEulerAnglesXYZ()
		totalRecoil = CFrame.Angles(math.max(r1, 0), math.min(r2, 0), r3)]]
		--Camera.CFrame = Camera.CFrame * CFrame.Angles(inputDelta.y, 0, 0)
	end
end)

Hum.StateChanged:Connect(function(old, state) -- Humanoid state handler
	local landed = (state == Enum.HumanoidStateType.Landed)
	if state == Enum.HumanoidStateType.Jumping then
		falling = 2
		if not (Char and Char.Parent and Hum and Hum.Health > 0) then return end
		local prim = Char.PrimaryPart
		if not prim then return end
		local primVel = prim.Velocity
		local moveDir = Hum.MoveDirection
		local charVel = Vector3.new(primVel.X, 0, primVel.Z).Magnitude
		local charDir = (charVel >= Hum.WalkSpeed / 3 and Vector3.new(moveDir.X, 0, moveDir.Z) or Vector3.new())
		if jumpForce and jumpForce.Parent then
			jumpForce:Destroy()
		end
		jumpForce = Instance.new("BodyVelocity")
		jumpForce.MaxForce = Vector3.new(20000, 0, 20000)
		jumpForce.Velocity = charDir * math.max(charVel, 6)
		local straightJump = (jumpForce.Velocity.Magnitude <= 0.01)
		jumpForce.Name = "JumpForce"
		jumpForce.Parent = prim
		local a = 1
		local started = os.clock()
		while a >= 0 do
			local step = Run.Heartbeat:Wait()
			if not (jumpForce and jumpForce.Parent) then break end
			if os.clock() - started < (straightJump and 0.1 or 0.15) then continue end
			--print(a, StateController:GetAttribute("Direction"))
			a = NumberUtil:Lerp(a, 0, step * 1.15)
			if a <= 0.01 then
				a = 0
			end
			--print("JUMP STRENGTH", a)
			jumpForce.MaxForce = jumpForce.MaxForce:Lerp(Vector3.new(), a)
		end
	elseif landed or state == Enum.HumanoidStateType.Running then
		falling = 0
		if jumpForce and jumpForce.Parent then
			lastLand = tick()
			jumpForce:Destroy()
		end
		jumpForce = nil
		if landed == false or StateController:GetAttribute("IsCrouch") then return end
		jumpSpring.Target = jumpSpring.Target + Vector3.new(0, -1, 0)
	elseif state == Enum.HumanoidStateType.Freefall or old == Enum.HumanoidStateType.Freefall then
		falling = 1
	end
end)

Hum.Died:Connect(function()
	heartbeatCon:Disconnect()
	CloseViewmodel()
end)

Hum:GetAttributeChangedSignal("Downed"):Connect(CloseViewmodel)

Char.ChildAdded:Connect(function(model)
	task.wait()
	CheckModel(model)
end)

for _, model in pairs(Char:GetChildren()) do
	task.defer(CheckModel, model)
end

Player:GetAttributeChangedSignal("ArmorSleeves"):Connect(QueueSleeveUpdate)

-- Remotes
VectorUtil:SetupRemote(CombatRemotes, HitRemote, function(typ, ...)
	--print("hitmarker")
	local args = {...}
	if typ ~= "HitMarker" then return end
	local hitType = args[1]
	CreateHitMarker(hitType)
end)

VectorUtil:SetupRemote(CombatRemotes, ReloadRemote, function()
	--print("cancel reload")
	currentReloadId += 1
end)

-- Bindables
EquipVM.Event:Connect(function(...)
	--print("equip bindable fired")
	local args = {...}
	local index = args[1]
	if index and index > 0 then
		--print("opening viewmodel", index)
		EquipViewmodel(...)
	else
		--print("closing viewmodel")
		CloseViewmodel()
	end
end)

UpdateVM.Event:Connect(UpdateVMAppearance)

Mouse.TargetFilter = VFX_PARTS
Crosshair.Up.Size = UDim2.new(0, 2, 0, crosshairSize)
Crosshair.Down.Size = UDim2.new(0, 2, 0, crosshairSize)
Crosshair.Right.Size = UDim2.new(0, crosshairSize, 0, 2)
Crosshair.Left.Size = UDim2.new(0, crosshairSize, 0, 2)

--\\ Render Step \\--
-- Unbind ViewmodelController from last existing script if present
pcall(function()
	Run:UnbindFromRenderStep("ViewmodelController")
	Run:UnbindFromRenderStep("HumCamOffset")
end)

heartbeatCon = Run.Heartbeat:Connect(function(passed)
	--print("heartbeat", math.random(1, 2))
	-- Attributes
	local disableScriptAnims = script:GetAttribute("DebugDisableScriptAnims")
	local isAiming = script:GetAttribute("Aiming")
	local isUsing = script:GetAttribute("Using")
	local curDirection = StateController:GetAttribute("Direction")
	local sprinting = StateController:GetAttribute("IsSprint")
	local crouching = StateController:GetAttribute("IsCrouch")
	local frameworkSpeed = script:GetAttribute("DebugFrameworkSpeed")
	local uiToggled = CameraController:GetAttribute("UI")
	local canUse = script:GetAttribute("CanUse")
	-- DeltaTime
	passed = passed * frameworkSpeed
	local deltaTime = passed / (1 / 60)
	local newInverseDeltaTime = math.clamp((1 / 60) / passed, 0.001, 100)
	if not inverseDeltaTime then
		inverseDeltaTime = newInverseDeltaTime
	else
		inverseDeltaTime = (math.abs(inverseDeltaTime - newInverseDeltaTime) <= 0.001 and newInverseDeltaTime or NumberUtil:Lerp(inverseDeltaTime, newInverseDeltaTime, math.clamp(0.25 * deltaTime, 0, 1)))
	end

	-- Hit Marker
	local doHitMarker = (hitMarkerAnim < 1 and uiToggled)
	if doHitMarker then
		hitMarkerAnim = math.min(hitMarkerAnim + passed * 5, 1)
		local trans = (hitMarkerAnim < 0.1 and -8 * hitMarkerAnim + 1 or (hitMarkerAnim <= 0.75 and 0.2 or 0.8 * (4 * hitMarkerAnim - 3) + 0.2))
		for _, line in pairs(HitMarker:GetChildren()) do
			line.BackgroundTransparency = trans
		end
		local hitMarkerSize = -15 * (hitMarkerAnim - 1)^3 + 8
		HitMarker.Up.Position = UDim2.new(0, 0, 0, -hitMarkerSize)
		HitMarker.Left.Position = UDim2.new(0, -hitMarkerSize, 0, 0)
		HitMarker.Down.Position = UDim2.new(0, 0, 0, hitMarkerSize + 2)
		HitMarker.Right.Position = UDim2.new(0, hitMarkerSize + 2, 0, 0)
	end
	HitMarker.Visible = (doHitMarker)

	-- Field Of View
	local targetExtraFov = (sprinting and 5 or 0)
	fovExtra = (math.abs(fovExtra - targetExtraFov) <= 0.01 and targetExtraFov or NumberUtil:Lerp(fovExtra, targetExtraFov, math.clamp(0.15 * deltaTime, 0, 1)))
	Camera.FieldOfView = fov + fovExtra
	-- Movement
	local equipped = GetEquipped()
	local equippedInfo = (equipped and Items[equipped.ID])
	local toolInfo = (equippedInfo and ToolInfo[equippedInfo.Name])
	local weaponInfo = (toolInfo and toolInfo.Weapon)
	local movementMults = (weaponInfo and weaponInfo.VMMovementMults or {})
	local walkSpeedMult = (Hum.WalkSpeed / 10)
	local targetMovementMult = (curDirection == "" and 0 or math.max(walkSpeedMult, 0.5))
	movementMult = (math.abs(targetMovementMult - movementMult) <= 0.01 and targetMovementMult or NumberUtil:Lerp(movementMult, targetMovementMult, math.clamp(0.15 * deltaTime, 0, 1)))
	curWalkMult = (math.abs(curWalkMult - walkSpeedMult) <= 0.01 and walkSpeedMult or NumberUtil:Lerp(curWalkMult, walkSpeedMult, math.clamp(0.12 * deltaTime, 0, 1))) -- Variable for slowing down / speeding up anims based on how fast you're walking
	moveX = moveX + (passed * 6.5 * walkSpeedMult)
	local bobMovementMult = (movementMults.Bobbing or 1)
	local moveEquationX = (0.05 * math.sin(moveX) + 0.007 * math.sin(1.6 * moveX)) * movementMult
	local moveEquationY = (0.0225 * math.cos(2 * moveX) + 0.007 * math.cos(2.2 * moveX)) * 0.9 * movementMult
	local jumpTarg = jumpSpring.Target
	if jumpTarg ~= Vector3.new() then
		jumpSpring.Target = (CSquare(jumpTarg) <= 0.01 and Vector3.new() or jumpTarg:Lerp(Vector3.new(), math.clamp(0.2 * deltaTime, 0, 1)))
	end
	jumpSpringPos = jumpSpring.Position
	local cameraBounceTarg = cameraBounceSpring.Target
	if cameraBounceTarg ~= Vector3.new() then
		cameraBounceSpring.Target = (CSquare(cameraBounceTarg) <= 0.01 and Vector3.new() or cameraBounceTarg:Lerp(Vector3.new(), math.clamp(0.3 * deltaTime, 0, 1)))
	end
	cameraBounceSpringPos = cameraBounceSpring.Position
	cameraPosSpring.Target = (curDirection == "" and Vector3.new() or Vector3.new(moveEquationX, moveEquationY * 1.5, 0) * -2)
	cameraPosSpringPos = cameraPosSpring.Position
	cameraRotSpring.Target = targetRotSpring * deltaTime
	local camRotSpring = cameraRotSpring.Position
	vmCamSpringRot = CFrame.Angles(camRotSpring.Y, camRotSpring.X, camRotSpring.Z)
	camRotSpringDone = (cameraRotSpring.Target == Vector3.new() and camRotSpringDone + passed or 0)
	if camRotSpringDone >= camRotSpringSpeed then
		local newCamRotAlpha = math.clamp(camRotAlpha + 0.1 * deltaTime, 0, 1)
		local alpha = newCamRotAlpha - camRotAlpha
		vmCamSpringRot = totalCamSpringRot:Lerp(CFrame.new(), 1 - alpha):inverse()
		camRotAlpha = newCamRotAlpha
	else
		local cSR1, cSR2, cSR3 = vmCamSpringRot:ToEulerAnglesXYZ()
		vmCamSpringRot = CFrame.Angles(cSR1, cSR2, cSR3)
	end
	totalCamSpringRot *= vmCamSpringRot
	-- VM Recoil
	if recoilAnim.Code then
		recoilAnim.X = math.min(recoilAnim.X + recoilAnim.Increment * deltaTime, 90)
		recoilAnim.Pos = recoilAnim.PrevPos:Lerp(recoilAnim.NewPos, math.sin(math.rad(recoilAnim.X)))
		recoilAnim.Rot = recoilAnim.PrevRot:Lerp(recoilAnim.NewRot, math.sin(math.rad(recoilAnim.X)))
		if recoilAnim.X >= 90 then
			recoilAnim.Code = nil	
		end
	end
	-- Sleeve Updates
	if sleeveUpdateQueued then
		sleeveUpdateQueued = false
		UpdateSleeves()
	end
	if not (equipped and viewModel and viewModel.Parent == VM_PARTS and type(toolInfo) == "table") then
		fov = 70		
		Crosshair.Visible = false
		return
	end
	-- Equipped info
	local equippedType = equippedInfo.Type
	local meleeInfo = toolInfo.Melee
	local spreadInfo = toolInfo.Spread
	local recoilInfo = toolInfo.Recoil
	local offsets = toolInfo.Offsets
	local usePositions = (weaponInfo and weaponInfo.UsePositionTimes)
	local lastUsed = tick() - lastUse
	local defaultPosName = ((usePositions and lastUsed >= usePositions.Start and lastUsed <= usePositions.End and disableScriptAnims == false and (usePositions.PlayOnMiss or not IsPlayingAnim("Miss"))) and "LocalUse" or "Local")
	local canAim = (weaponInfo ~= nil and weaponInfo.AimDownSpeed ~= nil)
	local isBow = (weaponInfo ~= nil and weaponInfo.IsBow)
	isAiming = (isAiming and (isBow ~= true or bowAimState == "AimingIn2" or bowAimState == "Holding"))
	defaultPos = defaultPos:Lerp(offsets[defaultPosName], math.clamp((usePositions and usePositions.Alpha or 0.1) * deltaTime, 0, 1))
	--print(defaultPosName)
	-- Left-Right handed math
	--[[local lefty = script:GetAttribute("LeftHanded")
	TranslateVM(currentModel, viewModel, lefty)]]

	-- Handles idle sway anim
	--local idleMult = 1--(passed <= (1 / 60) and 1 or inverseDeltaTime)
	attachmentSwayMult = NumberUtil:Lerp(attachmentSwayMult, (isAiming and 1 + (attachmentStats.SwayMult or 0) or 1), math.clamp(0.1 * deltaTime, 0, 1))
	curIdleSpeedX = NumberUtil:Lerp(curIdleSpeedX, idleSwaySpeedX / 1000, idleSwayAlpha)
	curIdleSpeedY = NumberUtil:Lerp(curIdleSpeedY, idleSwaySpeedY / 1000, idleSwayAlpha)
	curIdleMaxX = NumberUtil:Lerp(curIdleMaxX, idleMaxSwayX / 1000, idleSwayAlpha)
	curIdleMaxY = NumberUtil:Lerp(curIdleMaxY, idleMaxSwayY / 1000, idleSwayAlpha)
	local idleSpeedIncrease = 1 + movementMult * 2
	curIdleX = (curIdleX + curIdleSpeedX * idleSpeedIncrease * deltaTime) % (math.pi * 2) -- REMOVED DELTATIME
	curIdleY = (curIdleY + curIdleSpeedY * idleSpeedIncrease * deltaTime) % (math.pi * 2) -- REMOVED DELTATIME
	local idleY = math.sin(curIdleY) * (curIdleMaxY * curWalkMult * attachmentSwayMult)
	local idleX = math.sin(curIdleX) * (curIdleMaxX * curWalkMult * attachmentSwayMult)
	-- Mouse movement swaying
	if tick() - lastMouseMoved >= 0.15 / frameworkSpeed then
		desiredSwayX = NumberUtil:Lerp(desiredSwayX, 0, math.clamp(0.1 * deltaTime, 0, 1))
		desiredSwayY = NumberUtil:Lerp(desiredSwayY, 0, math.clamp(0.1 * deltaTime, 0, 1))
	end
	--gunSpring.Speed = 25 * deltaTime
	gunSpring.Target = (CameraController:GetAttribute("FreeLooking") and Vector3.new() or Vector3.new(desiredSwayX, desiredSwayY, 0))
	local gunSpringPos = gunSpring.Position
	local newGunSpring = gunSpringPos * inverseDeltaTime
	curSwayX = newGunSpring.X / (maxSwaySpeed / swayFilter)
	curSwayY = newGunSpring.Y / (maxSwaySpeed / swayFilter)
	swayMult = NumberUtil:Lerp(swayMult, (isAiming and 15 or 1), math.clamp(0.1 * deltaTime, 0, 1))
	-- Aiming
	local aimDownSpeed = 1
	if weaponInfo ~= nil and weaponInfo.AimDownSpeed then
		aimDownSpeed = weaponInfo.AimDownSpeed[isAiming and "In" or "Out"]
	end
	local maxAimX = 1.1
	if isAiming ~= lastAiming then
		aimRatio = math.clamp((isAiming and 1 - aimX / maxAimX or aimX / maxAimX), 0, 1)
		lastAiming = isAiming
	end
	aimBobMult = NumberUtil:Lerp(aimBobMult, (curDirection == "" and 7 or 5) / (crouching and 0.9 or ((sprinting and curDirection ~= "") and 1.25 or 1)), math.clamp((curDirection == "" and 0.01 or 0.15) * deltaTime, 0, 1))
	aimX = math.max(0, math.min(aimX + ((isAiming and (isBow ~= true or (bowAimState ~= "Started" and not bowAimState:find("None")))) and passed or -passed) * aimRatio / aimDownSpeed, maxAimX))
	local clampedAimX = math.min(aimX, 1)
	extraAimX = (aimX >= 1 and extraAimX + (passed * 1.5) or 1)
	if isAiming and canAim and not (meleeInfo or offsets.Aim) then
		aimPos = viewModelPrim.CFrame:ToObjectSpace((sightBack or viewModelAimBack).CFrame):inverse()
	end
	if canAim then
		if meleeInfo then
			if isAiming then
				if meleeAimState == "None" then
					meleeAimState = "Started"
					PlayAnimation("ThrowWindup")
				elseif meleeAimState == "Started" and not IsPlayingAnim("ThrowWindup") then
					meleeAimState = "Holding"
					PlayAnimation("ThrowHold")
				end
			elseif IsPlayingAnim("ThrowHold") or IsPlayingAnim("ThrowWindup") then
				meleeAimState = "None"
				StopAnimation("ThrowWindup")
				StopAnimation("ThrowHold")
			end
		elseif isBow then
			local aimStartAnim = currentAnims.Local.AimStart
			if script:GetAttribute("Aiming") and not forceUnaim then
				if bowAimState == "None" then
					local equippedAmmo = equipped.Ammo
					local displayAmmo
					if (not IsPlayingAnim("AimStop")) and (not isUsing) and ((equippedAmmo ~= nil and equippedAmmo.Amount > 0) or (function() 
							local canReload, dispAm = ReloadDownFunc(true)
							displayAmmo = dispAm
							return canReload
						end)()) then
						bowAimState = "Started"
						PlayAnimation("AimStart", 0.9)
						if displayAmmo then
							WeldModule:WeldAttachments(viewModelWeapon, equipped, nil, nil, displayAmmo)
						end
					end
				elseif IsPlayingAnim("AimStart") and aimStartAnim.TimePosition >= 0.85 then
					bowAimState = "AimingIn2"
				elseif IsPlayingAnim("AimStart") and aimStartAnim.TimePosition >= 0.7 then
					bowAimState = "AimingIn1"
				elseif not IsPlayingAnim("AimStart") then
					bowAimState = "Holding"
					PlayAnimation("AimHold")
				end
			elseif bowAimState == "Holding" or not (bowAimState:find("None") or IsPlayingAnim("AimStart")) then
				local freeFallTime = tick() - timeFreeFalling
				bowAimState = ((freeFallTime >= 0.25 and freeFallTime <= 0.45) and "NoneJump" or "None")
				if bowAimState == "NoneJump" then
					task.delay(0.3, function()
						if bowAimState ~= "NoneJump" then return end
						bowAimState = "None"
					end)
					--print("JUMPSHOT - CURRENT AIRBORNE TIME:", freeFallTime)
				else
					StopAnimation("AimStart")
					StopAnimation("AimHold")
					PlayAnimation("AimStop", -1)--(forceUnaim and -1.25 or -1))
				end
				forceUnaim = false
			end
		end
	end
	--print(aimBobMult)
	if viewModelAttachments then
		local acog = viewModelAttachments:FindFirstChild("Military ACOG Sight") or viewModelAttachments:FindFirstChild("Bruno's ACOG Sight")
		if acog then
			local hideAcog = (clampedAimX >= 0.5)
			acog.ADS.Transparency = (hideAcog and 0 or 1)
			acog.Front.Transparency = (hideAcog and 1 or 0)
			acog.Middle.Transparency = (hideAcog and 1 or 0)
			acog.Red.Transparency = (hideAcog and 1 or 0)
			acog.Vignette.Transparency = (hideAcog and 1 or 0.95)
		end
	end
	local aimFunc = (clampedAimX <= 0.5 and 4 * clampedAimX ^ 3 or 4 * (clampedAimX - 1) ^ 3 + 1) -- inOutCubic
	extraAimFunc = (extraAimX > 1 and 2 ^ (-aimBobMult * extraAimX) * math.sin(extraAimX * (2 * math.pi / 0.5)) or NumberUtil:Lerp(extraAimFunc, 0, math.clamp(0.5 * deltaTime, 0, 1)))
	--local aimFunc = 1 + 2.70158 * (aimX - 1) ^ 3 + 1.70158 * (aimX - 1) ^ 2 -- outBack
		--[[
		local aimConstant = 1.70158 * 1.525
		local aimFunc2 = ((2 * aimX - 2) ^ 2 * ((aimConstant + 1) * (2 * aimX -2) + aimConstant) + 2) / 2
		local aimFunc = (aimX <= 0.5 and 4 * aimX ^ 3 or aimFunc2)]]
	--local aimFunc = (aimX == 0 and 0 or (aimX == 1 and 1 or 2 ^ (-40 * aimX) * math.sin((aimX * 10 - 0.75) * (2 * math.pi / 3)) + 1)) -- elasticOut
	aimingIdleMult = NumberUtil:Lerp(aimingIdleMult, (isAiming and 0.1 or 1), math.clamp(0.2 * deltaTime, 0, 1)) * attachmentSwayMult
	fov = NumberUtil:Lerp(70, 70 / (attachmentStats.ZoomLevel or (weaponInfo ~= nil and weaponInfo.DefaultZoomLevel) or 1), math.min(aimFunc * 1.2, 1))
	--print(fov)
	-- Movement
	local isSprinting = (sprinting and not (canUse and isUsing))
	local isFalling = ((falling >= 1 or WaterController:GetAttribute("IsSwim")))
	local doFallAnim = isFalling and (equippedType ~= "Tool" or not isUsing)
	local sprintForwardMult = (isSprinting and movementMults.SprintTilt or 1)
	timeSinceNoFall = ((isFalling and equippedType ~= "Tool") and tick() or timeSinceNoFall)
	timeFreeFalling = (falling >= 1 and timeFreeFalling or tick())
	vmForward = NumberUtil:Lerp(vmForward, math.rad((doFallAnim and (isSprinting and -5 or -15) * sprintForwardMult or 0) + (curDirection:find("Forward") and (isSprinting and -15 * sprintForwardMult or -2) or (curDirection:find("Backward") and 2 or 0))) / ((isBow and IsPlayingAnim("AimStart") and doFallAnim) and 10 or 1), math.clamp((doFallAnim and 0.25 or 0.15) * deltaTime, 0, 1))
	vmSide = NumberUtil:Lerp(vmSide, math.rad(4 * (curDirection:find("Right") and 1 or (curDirection:find("Left") and -1 or 0))), math.clamp(0.1 * deltaTime, 0, 1))
	-- Spread
	local spreadTable
	local attachmentSpreadMult = 1
	local ammo = equipped.Ammo
	local ammoInfo = (ammo and Items[ammo.ID])
	local ammoStats = (ammoInfo and ammoInfo.AmmoStats or {})
	local ammoSpreadMult = (ammoStats[(isAiming and "Aim" or "Hip").."SpreadMult"] or 1)
	if spreadInfo then
		spreadTable = spreadInfo[isAiming and "Aiming" or "Hip"]
		attachmentSpreadMult = 1 + (attachmentStats[(isAiming and "Aim" or "Hip").."SpreadMult"] or 0)
		baseSpread = math.max(NumberUtil:Lerp(baseSpread, spreadTable[curDirection == "" and "Idle" or "Moving"] * attachmentSpreadMult * ammoSpreadMult, math.clamp(0.2 * deltaTime, 0, 1)), 0)
		local shootSpread = spreadInfo.Shooting
		if shootSpread then
			if tick() - lastUse >= shootSpread.DecayStart / frameworkSpeed then
				shootingSpreadMult = math.max(shootingSpreadMult - passed * (1 / (shootSpread.DecayEnd - shootSpread.DecayStart)), 0)
			end
		else
			shootingSpreadMult = 0
		end
		-- Recoil
		--recoilSpring.Speed = 25 * deltaTime
		recoilSpring.Target = recoilAnim.Rot
		local recoilCam = (recoilInfo and recoilInfo.Camera)
		if recoilCam and (recoilReset < 1 or recoilAmount > 0) then
			local timeLastShot = tick() - lastUse
			if timeLastShot >= recoilCam.Decay.Start / frameworkSpeed then
				recoilReset = math.min(recoilReset + (recoilCam.Decay.Rate / (recoilAmount * recoilCam.Decay.Multiplier)) * deltaTime, 1)
				if timeLastShot >= recoilCam.Decay.Bullet then
					local timepassed = tick() - lastRecoilReset
					local frameCheck = 1 / 60 / frameworkSpeed
					if recoilAmount > 0 and timepassed >= frameCheck then
						for i = 1, math.floor(timepassed / frameCheck) do
							recoilAmount = math.max(recoilAmount - 1, 0)
						end
						lastRecoilReset = tick()
					end
				end
				--[[
				local old = totalRecoil
				totalRecoil = latestRecoil:Lerp(CFrame.new(), recoilReset * recoilInfo.Camera.Decay.Ratio)
				Camera.CFrame = Camera.CFrame * totalRecoil:toObjectSpace(old):inverse()]]
			else
				lastRecoilReset = tick()
				latestRecoil = totalRecoil
			end
		end
	end
	-- Crosshair
	local targetCrossTrans = ((spreadTable == nil or isSprinting or IsPlayingAnim("Equip") or reloading or IsPlayingAnim("Inspect") or CameraController:GetAttribute("FreeLooking")) and 1 or 0.2)
	if targetCrossTrans ~= 1 then
		local transAiming = (isAiming or clampedAimX >= 0.8)
		targetCrossTrans = ((transAiming and spreadInfo.Aiming.Hide) and 1 or ((transAiming == false and spreadInfo.Hip.Hide) and 1 or 0.2))
	end
	crosshairTrans = NumberUtil:Lerp(crosshairTrans, targetCrossTrans, math.clamp(0.4 * deltaTime, 0, 1))
	Crosshair.Visible = (crosshairTrans < 1 and vmToggled and uiToggled)
	if Crosshair.Visible and spreadTable then
		for _, v in pairs({Crosshair, unpack(Crosshair:GetChildren())}) do
			v.BackgroundTransparency = crosshairTrans
		end
		local shootingSpread = spreadTable.ShootingExtra * attachmentSpreadMult * shootingSpreadMult * ammoSpreadMult
		targetExtraCrosshairSpread = (spreadTable[curDirection == "" and "IdleExtra" or "MovingExtra"] or 0)
		extraCrosshairSpread = (math.abs(extraCrosshairSpread - targetMovementMult) <= 0.01 and targetExtraCrosshairSpread or NumberUtil:Lerp(extraCrosshairSpread, targetExtraCrosshairSpread, math.clamp(0.16 * deltaTime, 0, 1)))
		local spread = baseSpread + shootingSpread + extraCrosshairSpread
		Crosshair.Up.Position = UDim2.new(0, 0, 0, -spread)
		Crosshair.Left.Position = UDim2.new(0, -spread, 0, 0)
		Crosshair.Down.Position = UDim2.new(0, 0, 0, spread + 2)
		Crosshair.Right.Position = UDim2.new(0, spread + 2, 0, 0)
		--[[
		local r1, r2, r3 = camextra:ToEulerAnglesXYZ()
		local crossx = math.floor(r2 * 200)
		local crossy = math.floor(r1 * 400)
		Crosshair.Position = UDim2.new(0, Mouse.X - 1 + crossx, 0, Mouse.Y - 1 + crossy)
		if not InventoryController:GetAttribute("Open") then
			Crosshair.Position = UDim2.new(0, Mouse.X - 1, 0, Mouse.Y - 1)
		end]]
	end
	-- Scope
	local isScope = attachmentStats.Scope
	local scopeTrans = (isScope and math.clamp(1 - aimFunc * 1.2, 0, 1) or 1)
	if isScope then
		Scope.Size = NumberUtil:MultUDim2ByNum(origScopeSize, isScope)
		for _, v in pairs({Scope, Scope.Frame, unpack(Scope.Frame:GetChildren())}) do
			v[(v:IsA("Frame") and "Background" or "Image").."Transparency"] = (v.Name == "Grain" and scopeTrans * 0.1 + 0.9 or scopeTrans)
		end
	end
	Scope.Visible = (isScope ~= nil)
	Scope.Position = UDim2.new(0.55, 0, 0.55, 0):Lerp(UDim2.new(0.5, 0, 0.5, 0), aimFunc + extraAimFunc * 15 * attachmentSwayMult)
	if ToggleViewmodel(scopeTrans >= 0.8) and isScope then
		Toolbar.Visible = vmToggled and CameraController:GetAttribute("UI")
	end
	-- Camera
	Camera.CFrame *= (vmToggled and CFrame.new() or CFrame.Angles(
		idleY * 0.08 * (1 + movementMult * 2), 
		idleX * 0.16 * (1 + movementMult * 2), 
		0
		))
	-- VM Position
	vmPos = (aimPos and defaultPos:Lerp(aimPos, (isScope and 1 - scopeTrans or aimFunc + extraAimFunc * attachmentSwayMult)) or defaultPos)
	vmAimAnims = (aimX >= 0.85)
	vmRootCF = vmPos * extraVmPos * (disableScriptAnims and CFrame.new() or CFrame.Angles(
		idleY * aimingIdleMult, 
		idleX * (aimingIdleMult * 3), 
		0
		)) + (jumpSpringPos or jumpSpring.Position) / -4
	local movementAlpha = math.clamp((isAiming and (vmAimAnims and 0.2 or 0.1) or (vmAimAnims and 0.1 or 0.2)) * deltaTime, 0, 1)
	armMovement = NumberUtil:Lerp(armMovement, (vmAimAnims and 0 or 1), movementAlpha)
	recoilMult = NumberUtil:Lerp(recoilMult, (isAiming and 0 or 1), math.clamp(0.25 * deltaTime, 0, 1))
	local recoilRot = recoilSpring.Position * (0.2 + 0.8 * recoilMult)
	local recoilPos = recoilAnim.Pos * (0.5 + 0.5 * recoilMult)
	sprintMult = NumberUtil:Lerp(sprintMult, (isSprinting and 1 or 0), math.clamp(0.25 * deltaTime, 0, 1))
	local sprintDownMult = (movementMults.SprintMoveDown or 0) * sprintMult
	local sprintBackMult = (movementMults.SprintMoveBackward or 0) * sprintMult
	--print(vmForward)
	vmRightArmPos = (disableScriptAnims and CFrame.new() or CFrame.new(
		moveEquationX * bobMovementMult * armMovement,
		moveEquationY * bobMovementMult * armMovement + vmForward * sprintDownMult,
		vmForward * -sprintBackMult
		)
	)
	vmRightArmRot = (disableScriptAnims and CFrame.new() or CFrame.Angles(
		vmForward * armMovement + recoilRot.X,
		vmSide * armMovement + recoilRot.Y,
		-vmSide * armMovement + recoilRot.Z
		) * CFrame.new(
			recoilPos.X, 
			recoilPos.Y, 
			recoilPos.Z
		)
	)
	aimMovement = NumberUtil:Lerp(aimMovement, ((vmAimAnims and extraAimX >= 1.5) and 1 or 0), movementAlpha)
	local mouseSwayMult = (movementMults.MouseSway or 1)
	vmSwayCF = (disableScriptAnims and CFrame.new() or CFrame.Angles(
		math.rad(curSwayY) * mouseSwayMult / swayMult + (math.rad(moveEquationY * bobMovementMult * 3 * walkSpeedMult) + vmForward / 30) * aimMovement,
		math.rad(curSwayX) * mouseSwayMult / swayMult + (math.rad(moveEquationX * bobMovementMult * 3 * walkSpeedMult) + vmSide / 30) * aimMovement,
		0
		))
end)
Run:BindToRenderStep("HumCamOffset", Enum.RenderPriority.Camera.Value - 1, function(passed)
	Hum.CameraOffset = Vector3.new(0, -0.25, 0) + (cameraPosSpringPos or cameraPosSpring.Position) + (cameraBounceSpringPos or cameraBounceSpring.Position)
	Camera.CFrame *= vmCamSpringRot
end)

Run:BindToRenderStep("ViewmodelController", Enum.RenderPriority.Camera.Value + 2, function(passed)
	--print("renderstepped", math.random(1, 2))
	Camera.CFrame = Camera.CFrame + (jumpSpringPos or jumpSpring.Position)
	local camOffset = CFrame.new()
	if cameraRoot then
		local reloadAnim = currentAnims.Local.Reload
		local partCF = cameraRoot.Root.CFrame
		local camRootCF = ((reloadAnim and reloadAnim.IsPlaying) and partCF or partCF:Lerp(CFrame.new(partCF.Position), 0.5))
		Camera.CFrame *= lastCamRootCF:ToObjectSpace(camRootCF)
		lastCamRootCF = camRootCF
		camOffset = camRootCF:ToObjectSpace(CFrame.new(camRootCF.Position))
	end
	if not (viewModel and viewModel.Parent == VM_PARTS) then return end
	--print(IsPlayingAnim("Equip"))
	local camcf = (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame) * camOffset
	local aimFront = (sightFront or viewModelAimFront)
	local actualRootCF = camcf * vmRootCF
	viewModel.WorldPivot = viewModelPrim.CFrame
	if vmRootPartBased then
		viewModel:PivotTo(actualRootCF * vmRightArmPos * vmRightArmRot)
	else
		viewModel:PivotTo(actualRootCF)
		local rootR1, rootR2, rootR3 = actualRootCF:ToEulerAnglesXYZ()
		local rightArmCF = viewModelRightArm.CFrame
		local startRightArmCF = CFrame.new(rightArmCF.Position) * CFrame.Angles(rootR1, rootR2, rootR3)
		local rightArmOffset = startRightArmCF:ToObjectSpace(rightArmCF)
		local actualRightArmCF = startRightArmCF * vmRightArmPos * vmRightArmRot * rightArmOffset
		viewModel.WorldPivot = rightArmCF
		viewModel:PivotTo(actualRightArmCF)
	end
	local animPart = (vmAimAnims and aimFront or viewModelHandle)
	viewModel.WorldPivot = animPart.CFrame
	viewModel:PivotTo(animPart.CFrame * vmSwayCF)
end)

InteractController:GetAttributeChangedSignal("Digging"):Connect(function()
	local hasDig = currentAnims.Local.Dig
	local charPrim = Char.PrimaryPart
	local digSound
	if charPrim then
		digSound = charPrim:FindFirstChild(hasDig and "DigWithShovel" or "DigWithHand")
	end
	if InteractController:GetAttribute("Digging") then
		if hasDig and not IsPlayingAnim("Dig") then
			PlayAnimation("Dig")
		end
		if digSound then
			SoundModule:PlaySound(digSound)
		end
		return
	end
	StopAnimation("Dig")
	if digSound then
		SoundModule:StopSound(digSound)
	end
end)


-- CameraRoot setup
cameraRoot = workspace:FindFirstChild("CameraRoot")
if not cameraRoot then
	cameraRoot = CameraRoot:Clone()
	cameraRoot.Parent = workspace
end

-- Cleanup any leftover VMs
VM_PARTS:ClearAllChildren()