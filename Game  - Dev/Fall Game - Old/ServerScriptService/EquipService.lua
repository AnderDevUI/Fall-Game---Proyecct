-- [PATH] ServerScriptService / ServerService / EquipService @Type Script
-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")

-- Constants
local ServerScripts = script.Parent
local Remotes = Replicated:WaitForChild("Remotes")
local ServerModules = Storage:WaitForChild("Modules")
local SharedModules = Replicated:WaitForChild("Modules")

--Remotes
local EquipRemotes = Remotes:WaitForChild(string.char(48, 32, 92, 99, 132, 71, 174, 29, 30, 26, 187, 7, 15, 97, 74, 158, 136, 71, 94, 130, 105, 30, 61, 94, 189, 126, 122, 164, 159, 188))
local AllRemotes = {
	Equip = string.char(12, 24, 129, 111, 133, 84, 169, 122, 127, 1, 125, 129, 159, 123, 134, 132, 189, 66, 19, 177, 43, 98, 73, 179, 94, 189, 188, 3, 146, 44);
}

-- Modules
local ModUtil = require(ServerModules:WaitForChild("ModUtil"))
local Items = require(SharedModules:WaitForChild("Items"))

--Functions
ModUtil:SetupRemotes(EquipRemotes, {
	[AllRemotes.Equip] = {
		Function = function(remote, player, args)
			local user = shared.Users[player]
			if not user then return end
			local char = player.Character
			if not char then return end
			local hum = char:WaitForChild("Humanoid")
			if not (hum and hum.Health > 0 and not hum:GetAttribute("Downed")) then return end
			local equipIndex = args[1]
			if type(equipIndex) ~= "number" or equipIndex % 1 ~= 0 or equipIndex < 0 or equipIndex > 6 then
				return ModUtil:BanPlayer(player.Name, "001", nil, remote, args)
			end
			if player:GetAttribute("SafeZone") then
				local containers = user.Inventory:GetInv()
				local toolbar = containers.Toolbar
				local item = toolbar[equipIndex]
				if item and item ~= 0 then
					local itemInfo = Items[item.ID]
					if itemInfo and itemInfo.Type == "Gun" then return end
				end
			end
			user:Equip(equipIndex)
		end;
	};
})