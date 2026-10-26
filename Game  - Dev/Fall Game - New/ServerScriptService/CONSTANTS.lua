-- [PATH] ServerScriptService / Library / CONSTANTS @Type ModuleScript
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local TestLibrary = require(script.Parent.TestLibrary)

local ServerConstants = {}

ServerConstants.GAME_VERSION = 1
ServerConstants.DEVICE = "Server"

ServerConstants.IS_RUNNING = RunService:IsRunning()
ServerConstants.IS_STUDIO = RunService:IsStudio()
ServerConstants.IS_SERVER = RunService:IsServer()

ServerConstants.PLACE_ID = game.PlaceId
ServerConstants.JOB_ID = game.JobId

ServerConstants.PRIVATE_SERVER_ID = game.PrivateServerId
ServerConstants.PRIVATE_SERVER_OWNER_ID = game.PrivateServerOwnerId

ServerConstants.GROUP_ID = 0

ServerConstants.BASE_HEALTH = 100
ServerConstants.BASE_WALKSPEED = 16
ServerConstants.BASE_JUMPPOWER = 50
ServerConstants.BASE_GRAVITY = workspace.Gravity

ServerConstants.MAX_RAYCAST_DISTANCE = 500
ServerConstants.RENDER_DISTANCE = 500

ServerConstants.DEFAULT_WEAPONS = {
	"Fists",
	"Handgun",
	"Assault Rifle",
	"Grenade",
}

ServerConstants.DEFAULT_MAPS = {
	"Forest",
	"AbandonedTown",
	"MilitaryBase",
	"Harbor",
}

ServerConstants.MAX_EQUIPPABLE_WEAPONS = 4
ServerConstants.MAX_BACKPACK_USE_QUANTITY = 100
ServerConstants.MAX_PARTY_SIZE = 5

ServerConstants.AIRBORNE_HUMANOID_STATES = {
	[Enum.HumanoidStateType.FallingDown] = true,
	[Enum.HumanoidStateType.Jumping] = true,
	[Enum.HumanoidStateType.Freefall] = true,
	[Enum.HumanoidStateType.Flying] = true,
	[Enum.HumanoidStateType.PlatformStanding] = true,
}

ServerConstants.IS_PUBLIC_SERVER = game.PrivateServerId == ""
ServerConstants.IS_RESERVED_SERVER =
	game.PrivateServerId ~= ""
	and game.PrivateServerOwnerId == 0

ServerConstants.IS_PRIVATE_SERVER =
	game.PrivateServerId ~= ""
	and game.PrivateServerOwnerId ~= 0

ServerConstants.IS_PRIVATE_SERVER_OWNER = function(userId: number): boolean
	return ServerConstants.IS_PRIVATE_SERVER
		and ServerConstants.PRIVATE_SERVER_OWNER_ID == userId
end

ServerConstants.SHOULD_ALWAYS_REPLICATE = function(): boolean
	return false
end

ServerConstants.INIT = function()
	if not ServerConstants.IS_SERVER then
		error("ServerConstants must be initialized on the server.")
	end

	return ServerConstants
end

return ServerConstants