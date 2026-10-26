-- [PATH] ServerScriptService / Main @Type Script
-- Server entry point.


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")


local Modules = ReplicatedStorage:WaitForChild("Modules")
local Library = ServerScriptService:WaitForChild("Library")
local Server = ServerScriptService:WaitForChild("Server")

require(Server.LogTap).Start()
require(Library:WaitForChild("CONSTANTS")).INIT()

local Asset = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("AssetContainer"))()
-- This initializes the replicated remotes. Register gameplay handlers separately.


local PlayerDataService = require(Server.PlayerDataService)
local PlayerService = require(Server.PlayerService)


-- Everything that listens to PlayerDataService.Loaded starts before it.
PlayerService.Start()
PlayerDataService.Start()




print("[Server] online")
