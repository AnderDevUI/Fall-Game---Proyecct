-- [PATH] ReplicatedStorage / Modules / TableUtil @Type ModuleScript
--[[
	TableUtil
	by ChickenBagelz
	August 5th, 2022
	
	Holds useful functions involving tables
]]


local TableUtil = {}

function TableUtil:TableRandom(t, numMult, base)
	base = (base or 2)
	numMult = (numMult or 1)
	local mult = 10 ^ base
	return (type(t) == "number" and t * numMult or math.random(t[1] * numMult * mult, t[2] * numMult * mult) / mult)
end

function TableUtil:CloneTable(t, dontRecurse)
	local newT = {}
	for index, value in pairs(t) do
		newT[index] = ((type(value) == "table" and not dontRecurse) and self:CloneTable(value) or value)
	end
	return newT
end

function TableUtil:RandomizeTable(t, dontClone)
	local newT = {}
	local actualT = (dontClone and t or self:CloneTable(t))
	for i = 1, #actualT do
		local n = math.random(1, #actualT)
		table.insert(newT, actualT[n])
		table.remove(actualT, n)
	end
	return newT
end

function TableUtil:CompareTables(t1, t2) -- ONLY WORKS ON ARRAYS WITHOUT NESTED TABLES
	if #t1 ~= #t2 then return false end
	for index, value1 in pairs(t1) do
		local value2 = t2[index]
		if value1 ~= value2 then return false end
	end
	return true
end

return TableUtil