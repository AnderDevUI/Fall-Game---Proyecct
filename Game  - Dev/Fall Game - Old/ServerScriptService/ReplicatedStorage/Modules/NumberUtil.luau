-- [PATH] ReplicatedStorage / Modules / NumberUtil @Type ModuleScript
--[[
	NumberUtil [CLIENT]
	by ChickenBagelz
	April 4, 2022
	
	Used for number calculations
]]


local NumberUtil = {}

function NumberUtil:Lerp(a, b, t) -- Linear interpolation
	return a * (1 - t) + (b * t)
end

local times = {
	{7 * 24 * 60 * 60, "Weeks"};
	{24 * 60 * 60, "Days"};
	{60 * 60, "Hours"};
	{60, "Minutes"};
	{1, "Seconds"};
}
function NumberUtil:FormatTime(n: number, format: string, formatEnd: string, useLetters: boolean?, truncate: number): string
	local start = false
	local ended = false
	local usedTimes = {}
	local nonEmptyStart = 0
	for i, t in pairs(times) do
		if t[2] == format or start then
			local new = math.floor(n / t[1])
			local nextT = times[i - 1]
			if nextT and nextT[2] == formatEnd then
				ended = true
			end
			if not ended then
				table.insert(usedTimes, {
					Formatted = ((new <= 9 and start) and "0" or "")..new..(useLetters and t[2]:sub(1, 1):lower() or ":");
					Raw = new;
				})
				nonEmptyStart = (nonEmptyStart == 0 and (new > 0 and #usedTimes or 0) or nonEmptyStart)
			end
			n = n - new * t[1]
			start = true
		end
	end
	if truncate then
		nonEmptyStart = math.min((nonEmptyStart == 0 and math.huge or nonEmptyStart), #usedTimes - (truncate - 1))
	end
	local tim = ""
	for index, usedTime in pairs(usedTimes) do
		local formatted = usedTime.Formatted
		local raw = usedTime.Raw
		if not (truncate and index < nonEmptyStart) then
			tim = tim..formatted
		end
	end
	return tim:sub(1, tim:len() - (useLetters and 0 or 1))
end

function NumberUtil:MultUDim2ByNum(udim2, num) -- Multiplies all values in a UDim2 by a number
	return UDim2.new(udim2.X.Scale * num, udim2.X.Offset * num, udim2.Y.Scale * num, udim2.Y.Offset * num)
end

function NumberUtil:MultColor3ByNum(color3, num) -- Multiplies all values in a Color3 by a number
	return Color3.new(color3.R * num, color3.G * num, color3.B * num)
end

function NumberUtil:NumberToInteger(num) -- Properly rounds a number to an integer depending on its decimal places
	local floored = math.floor(num)
	return (num == floored and num or (math.random(1, 10000) <= math.ceil((num - floored) * 10000) and math.ceil(num) or floored))
end

function NumberUtil:FormatNumber(n) -- credit http://richard.warburton.it  / Adds commas to numbers
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function NumberUtil:RoundNumber(num, digits, doRound)
	digits = (digits or 3)
	return math[doRound and "round" or "floor"](num * 10^digits) / 10^digits
end

function NumberUtil:IsWithin(pos1, pos2, dist)
	local squared = (pos1.X - pos2.X)^2 + (pos1.Y - pos2.Y)^2 + (typeof(pos1) == "Vector3" and (pos1.Z - pos2.Z)^2 or 0)
	return (squared <= dist^2), squared
end

function NumberUtil:BytesToKB(num)
	local kb = num / 1024
	return self:FormatNumber(self:RoundNumber(kb, 3))
end

return NumberUtil