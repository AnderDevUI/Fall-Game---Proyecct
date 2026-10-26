-- [PATH] ServerStorage / Modules / UserStatsClass @Type ModuleScript
--[[
	UserStatsClass
	by ChickenBagelz
	June 15, 2023
	
	Keeps track of all the player's actions
]]


-- Services
local Players = game:GetService("Players")
local Http = game:GetService("HttpService")

-- Local Variables
local RangeValues = {5, 10, 20, 50, 100, 200, 300, 500, 1000, "Other"}


local UserStatsClass = {}
UserStatsClass.__index = UserStatsClass

function UserStatsClass.new(player: Player, data: {}): {}
	local self = setmetatable({}, UserStatsClass)
	self.Player = player
	self.Stats = {
		Combat = (data and data[1] or {});
		ResourcesGathered = (data and data[2] or {});
		Deaths = (data and data[3] or {});
		WeaponUseRates = {};
		General = {
			StudsWalked = 0;
		};
	}

	return self
end

function UserStatsClass:AddUsedWeapon(weaponName: string, wasInvalid: boolean?)
	local combat = self:GetStats("Combat")
	local weaponStats = combat[weaponName]
	if not weaponStats then
		weaponStats = {
			Used = 0;
			Invalids = 0;
			Ranges = {};
			Kills = {};
			Downs = {};
		}
		combat[weaponName] = weaponStats
	end
	weaponStats[wasInvalid and "Invalids" or "Used"] += 1
	--[[if not self.Player then return end
	print("used weapon", weaponName, combat)]]
end

function UserStatsClass:AddWeaponHit(weaponName: string, range: number, limb: string)
	local combat = self:GetStats("Combat")
	local weaponStats = combat[weaponName]
	if not weaponStats then return end
	local ranges = weaponStats.Ranges
	for _, rangeValue in pairs(RangeValues) do
		if type(rangeValue) == "number" and range > rangeValue then continue end
		local rangeInfo = ranges[tostring(rangeValue)]
		if not rangeInfo then
			rangeInfo = {
				Invalids = 0;
				Hits = {
					Head = 0;
					Chest = 0;
					Arms = 0;
					Legs = 0;
					Unknown = 0;
				}
			}
			ranges[tostring(rangeValue)] = rangeInfo
		end
		if rangeInfo.Hits[limb] then
			rangeInfo.Hits[limb] += 1
		else
			rangeInfo.Invalids += 1
		end
		break
	end
	--[[if not self.Player then return end
	print("added weapon hit", weaponName, combat)]]
end

function UserStatsClass:AddWeaponStat(typ: string, weaponName: string, weaponAgainst: string?)
	local combat = self:GetStats("Combat")
	local weaponStats = combat[weaponName]
	if not weaponStats then return end
	weaponAgainst = (type(weaponAgainst) == "string" and weaponAgainst or "None")
	local stat = weaponStats[typ]
	stat[weaponAgainst] = (stat[weaponAgainst] or 0) + 1
	--[[if not self.Player then return end
	print("added weapon", typ, weaponName, stat)]]
end

function UserStatsClass:AddDeath(deathBy: string, killedBy: number?)
	local deaths = self:GetStats("Deaths")
	local deathTable = deaths[deathBy]
	if killedBy then
		if not deathTable then
			deathTable = {}
			deaths[deathBy] = deathTable
		end
		deathTable[killedBy] = (deathTable[killedBy] or 0) + 1
		if not self.Player then return end
		--print("new player death", deathBy, killedBy, deathTable[killedBy])
	elseif type(deathTable) ~= "table" then
		deaths[deathBy] = (deaths[deathBy] or 0) + 1
		if not self.Player then return end
		--print("new general death", deathBy, deaths[deathBy])
	end
end

function UserStatsClass:AddResourceGathered(resource: string|number, amount: number)
	local resourcesGathered = self:GetStats("ResourcesGathered")
	resourcesGathered[resource] = (resourcesGathered[resource] or 0) + amount
	if not self.Player then return end
	--print("added resource", resource, amount, resourcesGathered)
end

function GetWeaponStats(typ, combat, weaponNameOnly, weaponAgainstOnly)
	local total = 0
	for weaponName, weaponStats in pairs(combat) do
		if weaponNameOnly and weaponName ~= weaponNameOnly then continue end
		for wepAgainst, amount in pairs(weaponStats[typ]) do
			if weaponAgainstOnly and wepAgainst ~= weaponAgainstOnly then continue end
			total += amount
		end
	end
	return total
end

function UserStatsClass:GetKills(weaponNameOnly: string?, weaponAgainstOnly: string?): number
	return GetWeaponStats("Kills", self:GetStats("Combat"), weaponNameOnly, weaponAgainstOnly)
end

function UserStatsClass:GetDowns(weaponNameOnly: string?, weaponAgainstOnly: string?): number
	return GetWeaponStats("Downs", self:GetStats("Combat"), weaponNameOnly, weaponAgainstOnly)
end

function UserStatsClass:GetDeaths(deathTypeOnly: string?, userOnly: string?): number
	local deaths = self:GetStats("Deaths")
	local totalDeaths = 0
	for deathType, value in pairs(deaths) do
		if deathTypeOnly and deathType ~= deathTypeOnly then continue end
		if type(value) == "number" then
			totalDeaths += value
			continue
		end
		for userId, death in pairs(value) do
			if userOnly and userId ~= userOnly then continue end
			totalDeaths += death
		end
	end
	return totalDeaths
end

function UserStatsClass:GetTotalAccuracy(weaponNameOnly: string?)
	local combat = self:GetStats("Combat")
	local totalHits = 0
	local totalUsed = 0
	for weaponName, weaponStats in pairs(combat) do
		if weaponNameOnly and weaponName ~= weaponNameOnly then continue end
		local hits = self:GetWeaponHits(weaponName)
		local used = weaponStats.Used
		totalHits += hits
		totalUsed += used
	end
	return totalHits, totalUsed
end

function UserStatsClass:CalculateTotalAccuracy(weaponNameOnly: string?): string
	local totalHits, totalUsed = self:GetTotalAccuracy(weaponNameOnly)
	return math.round(totalHits / totalUsed * 100).."%"
end

function UserStatsClass:GetWeaponHits(weaponName: string, rangeOnly: number?, limbOnly: string?): number
	local combat = self:GetStats("Combat")
	local weaponStats = combat[weaponName]
	if not weaponStats then return end
	local ranges = weaponStats.Ranges
	local totalHits = 0
	for range, rangeInfo in pairs(ranges) do
		if rangeOnly and range ~= rangeOnly then continue end
		local hits = rangeInfo.Hits
		for limb, amount in pairs(hits) do
			if limbOnly and limb ~= limbOnly then continue end
			totalHits += amount
		end
	end
	return totalHits
end

function UserStatsClass:GetLimbPercentageAccuracies(weaponNameOnly: string?, rangeOnly: number?)
	local combat = self:GetStats("Combat")
	local limbHits = {}
	local totalHits = 0
	for weaponName, weaponStats in pairs(combat) do
		if weaponNameOnly and weaponName ~= weaponNameOnly then continue end
		local ranges = weaponStats.Ranges
		for range, rangeInfo in pairs(ranges) do
			if rangeOnly and range ~= rangeOnly then continue end
			local hits = rangeInfo.Hits
			for limb, amount in pairs(hits) do
				if limb == "Unknown" then continue end
				limbHits[limb] = (limbHits[limb] or 0) + amount
				totalHits += amount
			end
		end
	end
	return limbHits, totalHits
end

function UserStatsClass:CalculateLimbPercentageAccuracies(weaponNameOnly: string?, rangeOnly: number?)
	local limbHits, totalHits = self:GetLimbPercentageAccuracies(weaponNameOnly, rangeOnly)
	local percentages = {
		Head = 0;
		Chest = 0;
		Arms = 0;
		Legs = 0;
	}
	for limb, _ in pairs(percentages) do
		local hits = (limbHits[limb] or 0)
		percentages[limb] = math.round(hits / totalHits * 100).."%"
	end
	return percentages
end

function UserStatsClass:EncodeStats(): string
	return Http:JSONEncode(self.Stats)
end

function UserStatsClass:GetStats(statCategory: string): {}
	return self.Stats[statCategory]
end

function UserStatsClass:GetData(): {}
	local userStats = self.Stats
	return {
		userStats.Combat,
		userStats.ResourcesGathered,
		userStats.Deaths
	}
end

function UserStatsClass:Synchronize(funcName: string, ...)
	local func = self[funcName]
	local serverStats = shared.ServerStats
	if not (func and serverStats) then return end
	serverStats[funcName](serverStats, ...)
	func(self, ...)
end

return UserStatsClass