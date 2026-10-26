-- [PATH] ReplicatedStorage / Modules / TweenUtil @Type ModuleScript
-- Tween Util
-- ChickenBagelz
-- April 4, 2022


-- Services
local TweenService = game:GetService("TweenService")


local TweenUtil = {}

function TweenUtil:Tween(obj, properties, values, duration, easingStyle, easingDirection, dontPlay)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle[easingStyle or "Quad"], Enum.EasingDirection[easingDirection or "Out"])
	local goals = {}
	values = (type(values) == "table" and values or {values})
	for i, prop in pairs(type(properties) == "table" and properties or {properties}) do
		goals[prop] = values[i]
	end
	local tween = TweenService:Create(obj, tweenInfo, goals)
	if not dontPlay then
		tween:Play()
	end
	return tween
end

return TweenUtil