-- [PATH] ServerScriptService / ServerService / SoundService @Type Script
--[[
	SoundService
	by ChickenBagelz
	September 30, 2022
	
	Receives all sound calls from a specific client to play to other clients simultaneously, respecting FilteringEnabled.
	
	
	DOCUMENTATION:
	To use, simply fire the HandleSound BindableEvent with the following arguments:
	
	sound = The Sound Instance that you wish to use
	typ = The action you wish to perform on the sound. "Play" will simply play it, "Stop" will stop the sound, "PlayDuplicate" will play a cloned
		  version of the current sound.
]]

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")

-- Folders
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")
local Remotes = Replicated:WaitForChild("Remotes")

-- Modules
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local SoundModule = require(ServerModules:WaitForChild("SoundModule"))

-- Constants
local PlaySound = Replicated:WaitForChild("PlaySound")


PlaySound.OnServerEvent:Connect(function(player, ...)
	local user = shared.Users[player]
	if not user then return end
	local args = {...}
	local sound = args[1]
	local typ = args[2]
	local extra1 = args[3]
	--print(sound, typ, extra1)
	if #args >= 4 or args[4] or (sound and typeof(sound) ~= "Instance") or (typ and type(typ) ~= "string") or (typ == "ChangeSpeed" and (type(extra1) ~= "number" or extra1 <= 0.1 or extra1 >= 4)) then
		ModUtil:BanPlayer(player.Name, "001", nil, PlaySound, args)
		return
	end
	local char = player.Character
	if not char then return end
	local prim = char.PrimaryPart
	if not prim then return end
	if typ == "Footsteps" then
		if user.CombatAlive == false then return end
		char:SetAttribute("Loaded", true)
		SoundModule:ReplicateSoundToClients(sound, typ, player, char)
		return
	end
	if not (typeof(sound) == "Instance" and sound.Parent and sound.Parent == prim) then return end
	local ignoreCooldown = (sound.Name == "WalkWater" or typ == "Stop" or (typ == "ChangeSpeed" and sound.Name:find("Footsteps")))
	if sound:GetAttribute("Cooldown") and not ignoreCooldown then return end
	local cooldown
	if not ignoreCooldown then
		sound:SetAttribute("Cooldown", true)
	end
	--print("PLAYING SOUND", sound.Name)
	user.LastSoundPlayed = tick()
	SoundModule:ReplicateSoundToClients(sound, (typ or "PlayDuplicate"), player, extra1)
	task.wait(sound.TimeLength * sound.PlaybackSpeed * 0.6)
	if not (sound and sound.Parent) then return end
	sound:SetAttribute("Cooldown", false)
end)