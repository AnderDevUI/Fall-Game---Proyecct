-- [PATH] ReplicatedStorage / Modules / BasePartInfo @Type ModuleScript
local BasePartInfo = {}

function BasePartInfo:Fetch()
	return {
		[1] = {
			Name = "Foundation";
			Description = "Every base starts from here.";
		};
		[2] = {
			Name = "Triangle Foundation";
			Description = "Every base starts from here.";
		};
		[3] = {
			Name = "Foundation Steps";
			Description = "For accessing tall foundations.";
		};
		[4] = {
			Name = "Wall";
			Description = "Great for keeping people out.";
		};
		[5] = {
			Name = "Half Wall";
			Description = "Half of a regular wall.";
		};
		[6] = {
			Name = "Low Wall";
			Description = "Quarter of a regular wall.";
		};
		[7] = {
			Name = "Wall Frame";
			Description = "Wall outline for placing stuff inside.";
		};
		[8] = {
			Name = "Doorway";
			Description = "Perfect fit for doors and vending machines.";
		};
		[9] = {
			Name = "Window";
			Description = "Perfect fit for window panels.";
		};
		[10] = {
			Name = "Floor";
			Description = "Add more stories to your base.";
		};
		[11] = {
			Name = "Triangle Floor";
			Description = "Add more stories to your base.";
		};
		[12] = {
			Name = "Floor Frame";
			Description = "Floor outline for placing stuff inside.";
		};
		[13] = {
			Name = "Triangle Floor Frame";
			Description = "Triangle Floor outline for placing stuff inside.";
		};
		[14] = {
			Name = "L-Shaped Stairs";
			Description = "Set of stairs with a 90 degree turn.";
		};
		[15] = {
			Name = "U-Shaped Stairs";
			Description = "Set of stairs with a 180 degree turn.";
		};
		[16] = {
			Name = "Ramp";
			Description = "Easier navigation of vehicles onto Foundations.";
		};
	}
end

local wheelInfos = BasePartInfo:Fetch()
function BasePartInfo:GetIndexFromName(name: string)
	for index, wheelInfo in pairs(wheelInfos) do
		if wheelInfo.Name ~= name then continue end
		return index
	end
	return ""
end

function BasePartInfo:GetNameFromIndex(index: nunber)
	local wheelInfo = wheelInfos[index]
	return (wheelInfo and wheelInfo.Name)
end

return BasePartInfo
