-- [PATH] ReplicatedStorage / Modules / SoundModule @Type ModuleScript
--[[
	SoundModule [CLIENT]
	by ChickenBagelz
	October 1, 2022
	
	Holds useful functions involving sounds to allow for proper and robust replication
	This is the client's SoundModule. Has to be separate because anticheat interferes with the code.
]]

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Sound = game:GetService("SoundService")

-- Folders
local Remotes = Replicated:WaitForChild("Remotes")
local Modules = Replicated:WaitForChild("Modules")
local LocalSounds = Replicated:WaitForChild("LocalSounds")
local VFX_PARTS = workspace:WaitForChild("VFX")

-- Modules
local Items = require(Modules:WaitForChild("Items"))
local VectorUtil = require(Modules:WaitForChild("VectorUtil"))
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))
local BenchInfo = require(Modules:WaitForChild("BenchInfo"))

-- Player Variables
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Remotes
local PlayRemote = Replicated:WaitForChild("PlaySound")

-- Local Variables
local cameraRoot


local SoundModule = {}

function SoundModule:PlaySound(sound, playDuplicate)
	sound:Play()
	PlayRemote:FireServer(sound, "Play"..(playDuplicate and "Duplicate" or ""))
end

function SoundModule:StopSound(sound)
	sound:Stop()
	PlayRemote:FireServer(sound, "Stop")
end

function SoundModule:ChangeSoundSpeed(sound, speed)
	sound.PlaybackSpeed = speed
	PlayRemote:FireServer(sound, "ChangeSpeed", speed)
end

function SoundModule:ToggleFootstep(char, sound)
	local prim = char.PrimaryPart
	if not prim then return end
	for _, charSound in pairs(prim:GetChildren()) do
		if charSound.Name:sub(1, 9) ~= "Footsteps" or not charSound:IsA("Sound") then continue end
		charSound.Volume = (charSound == sound and sound:GetAttribute("MaxVolume") or 0)
	end
	PlayRemote:FireServer(sound, "Footsteps")
end

function SoundModule:PlayDuplicateSound(sound, backupSound, backupPos, dontDoRemove)
	local newSound
	if not (sound and sound.Parent) then 
		if backupSound and backupSound.Parent and backupPos then
			if not (cameraRoot and cameraRoot.Parent) then
				cameraRoot = workspace:FindFirstChild("CameraRoot")
			end
			if not cameraRoot then return end
			--print(backupSound:GetFullName(), "playing mock sound")
			local soundAttachment = Instance.new("Attachment")
			soundAttachment.Parent = cameraRoot.PrimaryPart
			soundAttachment.WorldCFrame = CFrame.new(backupPos)
			local newSound = backupSound:Clone()
			newSound.Parent = soundAttachment
			local name = newSound.Name
			if name:sub(name:len() - 4) == "Shoot" and name ~= "Shoot" then
				self:ReverbSound(newSound, 600, 1000)
			end
			newSound:Play()
			task.defer(function()
				if not (soundAttachment and soundAttachment.Parent) then return end
				if not newSound.IsPlaying then
					soundAttachment:Destroy()
					return
				end
				newSound.Ended:Wait()
				soundAttachment:Destroy()
			end)
		end
		return 
	end
	local name = sound.Name
	local canReverb = (name:sub(name:len() - 4) == "Shoot" and name ~= "Shoot")
	if canReverb == false and not sound.IsPlaying then
		--print(sound:GetFullName(), "ignoring copying sound; playing without clone")
		sound:Play()
		return
	end
	local doRemove = not dontDoRemove
	local newSound = sound:Clone()
	newSound:Stop()
	--newSound.PlayOnRemove = (doRemove == true)
	--newSound.Volume *= (soundPart and newSound:GetAttribute("ClientReplicationMultiplier") or 1)
	newSound.Parent = sound.Parent
	if canReverb then
		self:ReverbSound(newSound, 600, 1000)
	end
	if newSound.PlayOnRemove then
		--print(sound:GetFullName(), "playing with PlayOnRemove")
		newSound:Destroy()
		return
	end
	--print(sound:GetFullName(), "cloned normally")
	newSound:Play()
	task.defer(function()
		if not (newSound and newSound.Parent) then return end
		if not newSound.IsPlaying then
			newSound:Destroy()
			return
		end
		newSound.Ended:Wait()
		newSound:Destroy()
	end)
	--[[
	local newSound
	local soundPart
	--print(sound, backupSound, backupPos)
	if backupSound and backupPos and not (sound and sound.Parent) then
		--print("creating mock sound")
		soundPart = Instance.new("Part")
		soundPart.Name = "SoundPart"
		soundPart.Transparency = 1
		soundPart.CanCollide = false
		soundPart.CanTouch = false
		soundPart.CanQuery = false
		soundPart.Anchored = true
		soundPart.Parent = VFX_PARTS
		soundPart.Position = backupPos
		newSound = backupSound:Clone()
		newSound.Parent = soundPart
	elseif sound and sound.Parent then
		--print("playing sound normally")
		newSound = sound:Clone()
		newSound.Parent = sound.Parent
	end
	if not newSound then return end
	newSound.Volume *= (soundPart and newSound:GetAttribute("ClientReplicationMultiplier") or 1)
	local name = newSound.Name
	if name:sub(name:len() - 4) == "Shoot" and name ~= "Shoot" then
		self:ReverbSound(newSound, 600, 1000)
	end
	newSound:Play()
	task.defer(function()
		if not (newSound and newSound.Parent) then return end
		if not newSound.IsPlaying then
			newSound:Destroy()
			if soundPart and soundPart.Parent then
				soundPart:Destroy()
			end
			return
		end
		newSound.Ended:Wait()
		newSound:Destroy()
		if not (soundPart and soundPart.Parent) then return end
		soundPart:Destroy()
	end)]]
end

function SoundModule:ReverbSound(sound, reverbMin, reverbMax)
	local camCF = Camera.CFrame
	local part = sound.Parent
	local isClose, distSquared = NumberUtil:IsWithin(part.Position, camCF.Position, reverbMin)
	if not isClose then
		sound.PlayOnRemove = false
		sound.Volume *= 8
		local dist = math.sqrt(distSquared)
		local distRatio = math.min((dist - reverbMin) / (reverbMax - reverbMin), 1)
		local soundGroup = Sound.GunshotReverb:Clone()
		--soundGroup.Compressor.Threshold *= math.min(distRatio * 2, 1)
		--soundGroup.Chorus.Depth *= distRatio
		soundGroup.Chorus.Mix *= distRatio
		soundGroup.Parent = sound
		sound.SoundGroup = soundGroup
		--print(sound.Name.." sound reverbing with an effect mult of "..distRatio)
	end
end

function SoundModule:PlayItemSound(id: number|{Sounds: {}}, soundType: string)
	if not id then return end
	local info = (type(id) == "number" and Items[id] or id)
	if not info then return end
	local sounds = info.Sounds
	if not sounds then return end
	local soundName = sounds[soundType]
	if not soundName then return end
	local sound = LocalSounds[soundName]
	local oldSpeed = sound.PlaybackSpeed
	sound.PlaybackSpeed += math.random(-20, 20) / 400 -- 0.05 diff
	Sound:PlayLocalSound(sound)
	sound.PlaybackSpeed = oldSpeed
end

function SoundModule:PlayBenchSound(benchName: string, soundType: string)
	local info = BenchInfo[benchName]
	if not info then return end
	local sounds = info.Sounds
	if not sounds then return end
	local soundName = sounds[soundType]
	if not soundName then return end
	local sound = LocalSounds.BenchSounds[soundName]
	local oldSpeed = sound.PlaybackSpeed
	sound.PlaybackSpeed += math.random(-20, 20) / 400 -- 0.05 diff
	Sound:PlayLocalSound(sound)
	sound.PlaybackSpeed = oldSpeed
end

return SoundModule