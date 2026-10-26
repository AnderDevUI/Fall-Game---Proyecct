-- [PATH] ServerStorage / Modules / StatsClass @Type ModuleScript
--[[
	StatsClass
	by neddleduck
	August 27, 2022
	
	Holds all of the characters stats currently holding {
		Hunger
		Thirst
	}
]]

-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Storage = game:GetService("ServerStorage")
local ServerScripts = game:GetService("ServerScriptService")

-- Folders
local SHARED_MOD = Replicated:WaitForChild("Modules")
local SERVER_MOD = Storage:WaitForChild("Modules")

-- Modules
local ModUtil = require(SERVER_MOD:WaitForChild("ModUtil"))
local Items = require(SHARED_MOD:WaitForChild("Items"))
local ItemClass = require(SHARED_MOD:WaitForChild("ItemClass"))
local LootTableModule = require(SERVER_MOD:WaitForChild("LootTableModule"))

--Remotes
local Remotes = Replicated.Remotes
local AllRemotes = {
	Consume = string.char(27, 172, 20, 5, 103, 62, 136, 82, 35, 178, 177, 27, 40, 69, 51, 169, 95, 77, 172, 4, 97, 63, 55, 189, 180, 173, 72, 135, 187, 25);
	SendStats = string.char(79, 32, 52, 90, 156, 106, 154, 4, 122, 24, 35, 31, 152, 159, 32, 108, 184, 86, 28, 97, 6, 28, 22, 147, 8, 79, 15, 125, 32, 45);
}
local StatsRemotes = Remotes:WaitForChild(string.char(32, 175, 56, 160, 50, 187, 113, 77, 49, 22, 130, 142, 126, 38, 59, 102, 17, 6, 168, 41, 9, 180, 85, 142, 105, 14, 66, 146, 142, 126))

--Settings
local maxStat = { --Consumable affected stats only
	HQueue = 100;
	Hunger = 100;
	Thirst = 100;
	Bleed = 99;
	Radiation = 499;
}

local StatsClass = {}
StatsClass.__index = StatsClass

function StatsClass.new(player)
	local self = setmetatable({}, StatsClass)
	
	self.Player = player
	--Stores time on last consumable use for cooldown
	self.LastConsumable = tick()
	
	return self
end

function StatsClass:GetStats()
	return self.Values
end

function StatsClass:CreateStats(hunger, thirst, bleed, radiation, wet, drowning)
	self.Values = {
		HQueue = 0;
		BCAccess = 0;
		BCDenied = 0;
		Decay = 0;
		Hunger = hunger or math.random(45, 60);
		Thirst = thirst or math.random(45, 60);
		Bleed = bleed or 0;
		Radiation = radiation or 0;
		Wet = wet or 0;
		Drowning = drowning or 0;
		Temperature = 15;
		Comfort = 0;
	}
	self.Resistances = self:ApplyArmorTable({}) --Applies an empty armor table on launch, to generate a new armor table
	self:UpdateClient()
end

function StatsClass:SetStat(StatName, Amnt)
	local stat = self.Values[StatName]
	if not stat then return end
	
	stat = Amnt
end

function StatsClass:ChangeStat(StatName, Amnt)
	local stat = self.Values[StatName]
	if not stat then return end
	
	stat = stat + Amnt
end

function StatsClass:ApplyConsumableTable(tbl)
	local values = self.Values
	for statName, Value in pairs(tbl) do
		if statName == "Health" then
			local hum = self.Player.Character.Humanoid
			hum.Health = hum.Health + Value
			if Value > 0 then
				self:LimitHealthQueue(hum)
			end
		elseif statName == "StopBleeds" then
			values.Bleed = 0
		elseif statName == "Thirst" then
			local hum = self.Player.Character.Humanoid
			local health = hum.Health
			if health < 40 then
				hum.Health = math.min(health + Value * 0.25, 40)
				--print("doing drink health", hum.Health - health)
				self:LimitHealthQueue(hum)
			end
		end
		local stat = values[statName]
		if stat then
			values[statName] = math.clamp(values[statName] + tbl[statName], 0, maxStat[statName])
		end
		if statName ~= "HQueue" then continue end
		local character = self.Player.Character
		if not character then continue end
		local hum = character:FindFirstChild("Humanoid")
		if not hum then continue end
		self:LimitHealthQueue(hum)
	end
	
	--guard clause
	if not tbl.Returns then return end
	local lootTable = LootTableModule:GetLootTable(unpack(tbl.Returns))
	local user = shared.Users[self.Player]
	if (not lootTable or not user) then return end
	
	local itemsGiven = lootTable:Roll()
	for _, itemGiven in pairs(itemsGiven) do
		user.Inventory:AddItem(itemGiven)
	end
end

function StatsClass:ApplyArmorTable(tbl)
	local newResistances = {
		Heat = 0;
		Cold = 0;
		Explosive = 0;
		Radiation = 0;
		Animal = 0;
		Legs = {
			Bullet = 0;
			Melee = 0;
		};
		Chest = {
			Bullet = 0;
			Melee = 0;
		};
		Head = {
			Bullet = 0;
			Melee = 0;
		};
	}
	
	for _, armor in pairs(tbl) do
		--Change resistances based on the armor found
		local info = Items[armor.ID]
		if not info then continue end
		local resistanceInfo = info.Resistances
		local protectedAreas = {"Head", "Chest", "Legs"}
		
		for resistanceName, resistanceValue in pairs(resistanceInfo) do
			
			if table.find(protectedAreas, resistanceName) then --It is chest legs or head, so apply the bullet and melee resistances accordingly
				local bulletResistance = resistanceValue.Bullet
				local meleeResistance = resistanceValue.Melee
				
				if bulletResistance ~= 0 then
					newResistances[resistanceName].Bullet += bulletResistance
				end
				if meleeResistance ~= 0 then
					newResistances[resistanceName].Melee += meleeResistance
				end
			else --It is not chest legs or head, so change the stat 
				if resistanceValue ~= 0 then
					newResistances[resistanceName] += resistanceValue
				end
			end
		end
	end
	self.Resistances = newResistances
	return newResistances
end

function StatsClass:GetHp()
	return self.Player.Character.Humanoid.Health
end

function StatsClass:SetHp(hp)
	local humanoid = self.Player.Character.Humanoid
	humanoid.Health = hp
	self:LimitHealthQueue(humanoid)
end

function StatsClass:LimitHealthQueue(humanoid) -- limits the health queue to make sure hum health + hqueue always equals to 100
	if humanoid.Health >= 100 then -- this is a failsafe for if the player's health is ever set to past 100 using commands to not make health queue behave weirdly
		self.Values.HQueue = 0
		return
	end
	local hq = self.Values.HQueue
	if hq <= 0 then return end
	self.Values.HQueue = math.max(hq - math.max((humanoid.Health + hq) - 100, 0), 0)
end

function StatsClass:IsLoaded()
	return (self.Values ~= nil)
end

function StatsClass:UpdateClient()
	ModUtil:FireClient(StatsRemotes, AllRemotes.SendStats, self.Player, self:GetStats())
end

return StatsClass