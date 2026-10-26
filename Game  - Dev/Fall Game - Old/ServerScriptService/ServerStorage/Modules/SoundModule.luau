-- [PATH] ServerStorage / Modules / SoundModule @Type ModuleScript
--[[
	SoundModule [SERVER]
	by ChickenBagelz
	October 1, 2022
	
	Holds useful functions involving sounds to allow for proper and robust replication
	This is the server's SoundModule. Has to be separate because anticheat interferes with the code.
]]

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")

-- Folders
local Remotes = Replicated:WaitForChild("Remotes")
local SharedModules = Replicated:WaitForChild("Modules")
local ServerModules = Storage:WaitForChild("Modules")
local VFX_PARTS = workspace:WaitForChild("VFX")

-- Modules
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local Thread = require(SharedModules:WaitForChild("Thread"))

-- Remotes
local PlayRemote = Replicated:WaitForChild("PlaySound")


local SoundModule = {}

function SoundModule:ReplicateSoundToClients(sound, typ, playerToIgnore, ...)
	local backupSound, backupPos
	if sound and sound.Parent then
		local backupTag = sound:FindFirstChild("Backup")
		if backupTag then
			backupSound = backupTag.Value
		end
		if sound.Parent:IsA("BasePart") then
			backupPos = sound.Parent.Position
		end
	end
	--print(sound, typ, backupSound, backupPos, ...)
	local combatArena
	if type(playerToIgnore) == "table" then
		playerToIgnore = playerToIgnore[1]
		local user = shared.Users[playerToIgnore]
		if user then
			combatArena = user:IsInCombatArena(true)
		end
	end
	for _, player in pairs(Players:GetPlayers()) do
		if player == playerToIgnore then continue end
		if combatArena and not table.find(combatArena.PlayersRed, player) and not table.find(combatArena.PlayersBlue, player) then
			--print("not playing sound for", player.Name, "as they're not in the same arena as", playerToIgnore.Name)
			continue 
		end
		--print("playing sound to", player)
		PlayRemote:FireClient(player, sound, typ, backupSound, backupPos, ...)
	end
end

function SoundModule:PlayDuplicateSound(sound, backupSound, backupPos)
	local newSound
	local soundPart
	if backupSound and backupPos and not (sound and sound.Parent) then
		--print("creating mock sound")
		soundPart = Instance.new("Part")
		soundPart.Name = "SoundPart"
		soundPart.Transparency = 1
		soundPart.CanCollide = false
		soundPart.Anchored = true
		soundPart.Size = Vector3.new(0.1, 0.1, 0.1)
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
	newSound.Volume *= (Players.LocalPlayer and newSound:GetAttribute("ClientReplicationMultiplier") or 1)
	newSound:Play()
	Thread.Spawn(function()
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
	end)
end

function SoundModule:PlayLocalSound(player, soundName, ...)
	if not (player and player.Parent) then return end
	PlayRemote:FireClient(player, soundName, "LocalSound", ...)
end

function SoundModule:PlayItemSound(player, id, soundType)
	if not (player and player.Parent) then return end
	PlayRemote:FireClient(player, id, "ItemSound", soundType)
end

return SoundModule