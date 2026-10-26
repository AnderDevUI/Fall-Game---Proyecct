-- [PATH] ServerScriptService / ShopService @Type Script
--[[
	ShopService
	by ChickenBagelz
	November 30, 2023
]]


-- Services
local Players = game:GetService("Players")
local Marketplace = game:GetService("MarketplaceService")
local Replicated = game:GetService("ReplicatedStorage")

-- Remotes
local LoadingScreenRemote = Replicated:WaitForChild("LoadingScreen")

-- Events
Marketplace.PromptGamePassPurchaseFinished:Connect(function(player, passId, wasPurchased)
	if not wasPurchased then return end
	local user = shared.Users[player]
	if not user then return end
	local Gamepasses = user:GetAllGamepasses()
	if passId ~= Gamepasses.ImageFrames then return end
	local ownedPasses = user.OwnedPasses
	local t = os.time()
	ownedPasses.ImageFrames = t
	LoadingScreenRemote:FireClient(player, "UpdateSign", t)
end)