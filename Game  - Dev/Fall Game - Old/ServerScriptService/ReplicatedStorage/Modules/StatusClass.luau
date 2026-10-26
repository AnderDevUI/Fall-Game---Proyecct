-- [PATH] ReplicatedStorage / Modules / StatusClass @Type ModuleScript
--[[
	StatusClass
	by neddleduck
	August 28, 2022
	
	This class holds the status bar effects and functions for inserting, removing, and manipulating status effects
	It has an easy function to apply the stats from the server, with the CompareServerTable() function
	self.StatusEffects = {
		{statusName, value, timeInserted}, {statusName, value, timeInserted}, --etc...	
		
		statusName = status name of the status effect
		value = the value of the status effect
		timeInserted = the time the stat was inserted so if applicable it can despawn when appropriate time has passed
	}
]]

local statusInfo = {
	["BCAccess"] = {
		Priority = 1;
	};
	["BCDenied"] = {
		Priority = 1;
	};
	["Safezone"] = {
		Priority = 2;
	};
	["Recipes"] = {
		Priority = 3;
	};
	["Craft"] = {
		Priority = 4;
	};
	["Decay"] = {
		Priority = 5;
	};
	["Bleed"] = {
		Priority = 6;
	};
	["Radiation"] = {
		Priority = 7;
		Max = 499;
	};
	["Wet"] = {
		Priority = 8;
	};
	["Temperature"] = {
		Priority = 9;
	};
	["Comfort"] = {
		Priority = 11;
	};
	["Drowning"] = {
		Priority = 12;
	};
}

local StatusClass = {}
StatusClass.__index = StatusClass

function StatusClass.new() 
	local self = setmetatable({}, StatusClass)
	
	--Setup Status Table
	self.StatusEffects = {}
	self.Pickups = {}

	return self
end

function StatusClass:GetStatusEffects()
	return self.StatusEffects
end

function StatusClass:GetPickups()
	return self.Pickups
end

function StatusClass:RemovePickup(pickupName)
	for index, pickupInfo in pairs(self:GetPickups()) do
		if pickupInfo[1] == pickupName then
			table.remove(self:GetPickups(), index)
		end
	end
end

function StatusClass:GetPickupAmount(pickupName)
	for _, pickupInfo in pairs(self:GetPickups()) do
		if pickupInfo[1] == pickupName then
			return pickupInfo[2]
		end
	end
end

function StatusClass:GetStatsPickupTableCombined()
	local newTable = {}
	for _,v in pairs(self.StatusEffects) do 
		if v[2] and (v[2] > 0 or v[2] == -1) or v[1] == "Temperature" then --Temperature can be negative, still send temperature stat effect if its negative
			table.insert(newTable, v)
		end
	end
	for _,v in pairs(self.Pickups) do
		if v[2] and (v[2] > 0 or v[2] == -1) then
			table.insert(newTable, v)
		end
	end
	return newTable
end

function StatusClass:GetIndexOfStat(statName)
	for index, statTable in pairs(self:GetStatusEffects()) do
		if statTable[1] == statName then
			return index
		end
	end
end

function StatusClass:GetStatValueFromIndex(index)
	local tabl = self:GetStatusEffects()
	if tabl[index] ~= nil then return end
	return tabl[index][2]
end

function StatusClass:GetStatValueFromName(statName)
	if string.find(statName, "Pickup") or string.find(statName, "Drop") then
		for _, pickup in pairs(self:GetPickups()) do
			if statName == pickup[1] then
				return pickup[2]
			end
		end
	end
	return self:GetStatValueFromIndex(self:GetIndexOfStat(statName))
end

function StatusClass:OrderStats()
	table.sort(self.StatusEffects, function(a, b)
		local nameA = statusInfo[a[1]]
		local nameB = statusInfo[b[1]]
		if not (nameA or nameB) then return end
		local priorityA = nameA.Priority
		local priorityB = nameB.Priority
		return priorityA < priorityB
	end)
end

function StatusClass:InsertStat(statusName, value)
	--Check if stat is a pickup and if it is, just insert it into pickups
	if string.find(statusName, "Pickup") or string.find(statusName, "Drop") then
		local exists = false
		--check if the pickup exists, if it exists, update the number and the tick, otherwise make it
		for _, pickupInfo in pairs(self.Pickups) do
			if pickupInfo[1] == statusName then
				exists = true
				pickupInfo[2] = pickupInfo[2] + value
				pickupInfo[3] = tick()
			end
		end
		if not exists then
			table.insert(self.Pickups, {statusName, value, tick()})
		end
		return
	end
	--If this runs then the stat is not a pickup, so check if stat exists and if it does, just update it
	local index = self:GetIndexOfStat(statusName) 
	if index ~= nil then --Update it
		self:UpdateStat(statusName, value, tick())
	else --Create pickup / drop
		local length = #self:GetStatusEffects()
		self:GetStatusEffects()[length + 1] = {statusName, value, tick()}
	end
	self:OrderStats()
end

function StatusClass:RemoveStat(statusName)
	for index, statValues in pairs(self:GetStatusEffects()) do
		if statValues[1] == statusName then
			table.remove(self:GetStatusEffects(), index)
		end
	end
	self:OrderStats()
end

function StatusClass:UpdateStat(statusName, value)
	for _, statValues in pairs(self:GetStatusEffects()) do
		if statValues[1] == statusName then
			if statusInfo.Max ~= nil then --When we update the stat, if there is a max value for the stat, clamp it to the max.
				value = math.clamp(value, 0, statusInfo.Max)
			end
			statValues[2] = value
			statValues[3] = tick()
		end
	end
	
	self:OrderStats()
end

function StatusClass:CompareServerTable(serverTable)
	for serverStatName, serverValue in pairs(serverTable) do
		local s = serverStatName
		if s == "HQueue" or s == "Health" or s == "Hunger" or s == "Thirst" then continue end
		
		--Check if stat exists in client table
		local foundStat = false
		for index, statusValues in pairs(self:GetStatusEffects()) do 
			if statusValues[1] == serverStatName then 
				foundStat = index
				break
			end
		end
		--Assign the stat
		if foundStat then
			self:GetStatusEffects()[foundStat][2] = serverValue
		else
			self:InsertStat(serverStatName, serverValue)
		end
	end
	
	self:OrderStats()
end

return StatusClass