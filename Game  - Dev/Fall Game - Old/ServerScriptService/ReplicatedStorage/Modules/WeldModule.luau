-- [PATH] ReplicatedStorage / Modules / WeldModule @Type ModuleScript
-- Weld Module
-- ChickenBagelz
-- August 11, 2021

-- A universal module for welding parts to other parts, models to other models, etc.


-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Sound = game:GetService("SoundService")

-- Folders
local Modules = Replicated:WaitForChild("Modules")
local Attachments = Replicated:WaitForChild("Attachments")
local Remotes = Replicated:WaitForChild("Remotes")
local PlayerSounds = Replicated:WaitForChild("PlayerSounds")

-- Modules
local Items = require(Modules:WaitForChild("Items"))


local WeldModule = {}

function WeldModule:WeldParts(part, partTo, ignore) -- Welds two parts together
	local W
	if ignore ~= "All" then -- 'ignore' parameter is used to just set parts' properties properly without repeating code
		W = Instance.new("Weld")
		W.Part0 = partTo
		W.Part1 = part
		if type(ignore) ~= "string" and ignore then -- Check for a custom offset
			W.C0 = ignore -- Offset
		else
			-- If no custom offset, weld parts to each others' inverse CFrames
			local CJ = CFrame.new(W.Part0.Position)
			W.C0 = W.Part0.CFrame:inverse() * CJ
			W.C1 = W.Part1.CFrame:inverse() * CJ
		end
		W.Parent = part
	end
	part.Anchored = false
	part.CanCollide = false
	part.Massless = true
	return W
end

function WeldModule:WeldModel(model, ignore, noCanQuery) -- Welds a model to its own PrimaryPart
	for _, v in pairs(model:GetChildren()) do
		if not v:IsA("BasePart") then continue end
		if model.PrimaryPart ~= v then -- Make sure we don't weld the primarypart to itself
			self:WeldParts(v, model.PrimaryPart, ignore)
		end
		if not noCanQuery then continue end
		v.CanTouch = false
		v.CanQuery = false
	end
end

function WeldModule:WeldModelToPart(model, partTo, offset, weldModel) -- Welds a model to a Part using possible offset (if weldModel, model itself will weld before welding to specified part)
	self:WeldModel(model, (weldModel and "" or "All")) -- Even if weldModel is nil, run function to make all parts noncancollide and stuff
	return self:WeldParts(model.PrimaryPart, partTo, offset)
end

function WeldModule:FullyWeldModels(model, modelTo, noCanQuery) -- Modular way of welding a full group of models to a group of parts (e.g welding armor to each character's corresponding body part)
	local models = {}
	for _, m in pairs(model:GetChildren()) do
		if not m:IsA("Model") then
			m.Parent = modelTo
		elseif modelTo:FindFirstChild(m.Name) then
			m.PrimaryPart = (m.PrimaryPart or m:FindFirstChild("Middle"))
			local prim = m.PrimaryPart
			self:WeldModel(m, nil, noCanQuery) -- Weld the model first
			m.Parent = modelTo
			self:WeldParts(prim, modelTo[m.Name], CFrame.new()) -- Weld the model's primarypart to the corresponding part
			prim.Transparency = 1
			prim.Name = m.Name
			m.Name = model.Name
			table.insert(models, m)
		end
	end
	model:Destroy()
	return models
end

function WeldModule:WeldAttachments(model, item, ignore, hideDetails, ammoId)
	local hasItem = (type(item) == "table")
	local extras = {}
	local attachmentFolder = model:FindFirstChild("Attachments")
	local attachments = (hasItem and item.Attachments or {})
	local hasArrow = (model:FindFirstChild("Arrow") or model:FindFirstChild("ArrowMain"))
	if (model:FindFirstChild("RocketRoot") or hasArrow) and hasItem then
		local ammo = item.Ammo
		if ammo and ammo.Amount > 0 and not ammoId then
			ammoId = ammo.ID
		end
		--[[if not (Players.LocalPlayer or ammoId) then
			ammoId = 98
		end]]
		local ammoInfo = (ammoId and Items[ammoId])
		local ammoName = (ammoInfo and ammoInfo.Name or "")
		for _, part in pairs(model:GetChildren()) do
			local name = part.Name
			if name == "RocketRoot" or name == "Arrow" or name == "ArrowMain" then continue end
			if (hasArrow and not name:find("Arrow")) or ((not hasArrow) and not name:find("Rocket")) then continue end
			local show = (name == ammoName)
			part.Transparency = (show and 0 or 1)
			if name ~= "Combustive Arrow" then continue end
			local holder = part:FindFirstChild("ParticleHolder")
			if not holder then continue end
			for _, effect in pairs(holder:GetChildren()) do
				effect.Enabled = show
			end
		end
	end
	if not (attachmentFolder and attachments) then return end
	local curAttachments = {}
	for _, attachment in pairs(attachments) do
		local attachmentInfo = Items[attachment.ID]
		if attachmentInfo.MaxDurability and attachment.Durability <= 0 then continue end
		curAttachments[attachmentInfo.Name] = attachment
	end
	for _, attachmentModel in pairs(attachmentFolder:GetChildren()) do
		local attachment = curAttachments[attachmentModel.Name]
		if attachment then continue end
		attachmentModel:Destroy()
	end
	local sightTrans = 0
	for attachmentName, attachment in pairs(curAttachments) do
		local attachmentModel = attachmentFolder:FindFirstChild(attachmentName)
		local attachmentInfo = Items[attachment.ID]
		local attachmentType = attachmentInfo.AttachmentType
		if attachmentType == "Sight" then
			sightTrans = 1
		end
		local doRiser = (attachmentType == "Sight" and hasItem and (item.ID == 198 or item.ID == 221))
		if not attachmentModel then 
			local attacher = model:FindFirstChild(attachmentType.."Main")
			attachmentModel = Attachments:FindFirstChild(attachmentName)
			if not (attachmentModel and attacher) then continue end
			attachmentModel = attachmentModel:Clone()
			attachmentModel.PrimaryPart = attachmentModel:FindFirstChild("Main")
			local reticle = attachmentModel:FindFirstChild("Reticle")
			if reticle and hideDetails then
				for _, detail in pairs(reticle:GetChildren()) do
					detail.Enabled = false
				end
			end
			local didRiser = false
			if doRiser then
				local riserPart = attachmentModel:FindFirstChild("M4Riser")
				if riserPart then
					didRiser = true
					riserPart.Transparency = 0
				end
			end
			WeldModule:WeldModelToPart(attachmentModel, attacher, (didRiser and CFrame.new(0, 0.08, 0) or CFrame.new()))
			attachmentModel.Parent = attachmentFolder
		end
		for _, v in pairs({"AimFront", "AimBack", "FlashPart"}) do
			local a = (attachmentModel and attachmentModel:FindFirstChild(v))
			if a then
				extras[v] = a
			end
		end
	end
	local sightHide = model:FindFirstChild("SightHide")
	if sightHide then
		sightHide.Transparency = sightTrans
	end
	local hasSilencer = curAttachments.Silencer
	while hasItem and not ignore do
		local char = model.Parent
		local player = Players:GetPlayerFromCharacter(char)
		if not player then break end
		local prim = char.PrimaryPart
		local itemInfo = Items[item.ID]
		if not (prim and itemInfo) then break end
		local savedSoundFolder = PlayerSounds:FindFirstChild(itemInfo.Name)
		if not savedSoundFolder then break end
		local shootSound = prim:FindFirstChild(itemInfo.Name.."Shoot")
		local savedShootSound = savedSoundFolder:FindFirstChild("Shoot")
		if not (shootSound and savedShootSound) then break end
		shootSound.RollOffMaxDistance = (hasSilencer and 100 or savedShootSound.RollOffMaxDistance)
		shootSound.Volume = savedShootSound.Volume * (hasSilencer and 0.85 or 1)
		local soundEffect = shootSound:FindFirstChild("SilencedEffect")
		if hasSilencer and not soundEffect then
			soundEffect = Sound.SilencedEffect:Clone()
			soundEffect.Parent = shootSound
		elseif soundEffect and not hasSilencer then
			soundEffect:Destroy()
		end
		break
	end
	
	return extras.AimFront, extras.AimBack, extras.FlashPart
end

return WeldModule