-- [PATH] ServerScriptService / TagService @Type Script
--[[
	TagService
	by ChickenBagelz
	August 15, 2022
	
	Handles all CollectionService functions
]]

-- Services
local Collection = game:GetService("CollectionService")
local Http = game:GetService("HttpService")
local StarterPlayer = game:GetService("StarterPlayer")

-- Folders
--[[shared.Characters = workspace:WaitForChild("Characters")
local calculateName = function()
	local chosen = table.create(32, 7)
	for i = 1, 32 do
		local sub = math.random(0, math.min(chosen[i], 8))
		chosen[i] -= sub
		while sub > 0 do
			local n = math.random(1, 32)
			local new = math.min(chosen[n] + sub, 15)
			local change = new - chosen[n]
			sub -= change
			chosen[n] = new
		end
	end
	local final = {}
	for i = 1, #chosen do
		local n = math.random(1, #chosen)
		table.insert(final, chosen[n])
		table.remove(chosen, n)
	end
	local name = "^"
	for i, v in pairs(final) do
		name ..= string.format("%X", `{v}`)..((i == 8 or i == 12 or i == 16 or i == 20) and "-" or "")
	end
	return name
end
Collection:AddTag(shared.Characters, calculateName())
task.defer(function()
	while true do
		local newName = ""
		for i = 1, math.random(3, 14) do
			local letter = string.char(math.random(97, 122))
			if i == 1 then
				letter = letter:upper()
			end
			newName ..= letter
		end
		shared.Characters.Name = newName
		task.wait(math.random(10, 75) / 10)
	end
end)]]

local Nodes = workspace:WaitForChild("Nodes")
local Trees = workspace:WaitForChild("Trees")
local Vegetation = workspace:WaitForChild("Vegetation")
local VFX_PARTS = workspace:WaitForChild("VFX")

-- Functions
function shared.GiveInstanceId(instance)
	local tags = Collection:GetTags(instance)
	for _, tag in pairs(tags) do
		if tag:sub(1, 1) == "^" then
			Collection:RemoveTag(instance, tag)
		end
	end
	--[[local guid
	local tries = 0
	while true do
		tries += 1
		guid = Http:GenerateGUID(false)
		if instance:IsA("Folder") and instance.Parent == workspace then
			local tag = guid:gsub("-", "")
			local total = 0
			for i = 1, #tag do
				local n = tonumber(tag:sub(i, i), 16)
				if type(n) ~= "number" or n < 0 or n > 15 then break end
				total += n
			end
			if total == 224 then
				warn("DESCENDANT OF WORKSPACE TAG HAS TOTAL OF 224 - RECREATING TAG", tries, instance:GetFullName())
			else
				break
			end
		else
			break
		end
	end
	Collection:AddTag(instance, "^"..guid)]]
	Collection:AddTag(instance, "^"..Http:GenerateGUID(false))
end

function RecurseGiveId(instance, ignoreFirst, ignoreConnection, ignoreFutureConnections)
	if not ignoreFirst then
		shared.GiveInstanceId(instance)
	end
	for _, child in pairs(instance:GetChildren()) do
		if not (child:IsA("Folder") or child:IsA("Model") or child:IsA("BasePart")) then continue end
		RecurseGiveId(child)
		--[[if instance:FindFirstChild("Humanoid") then
			print("TAGGED", child.Name)
		end]]
	end
	if ignoreConnection ~= true or not (instance:IsA("Folder") or instance:IsA("Model") or instance:IsA("BasePart")) then
		instance.ChildAdded:Connect(function(child)
			RecurseGiveId(child, nil, ignoreFutureConnections)
		end)
	end
end

-- Tag all existing instances
for _, serviceName in pairs({"Players", "ReplicatedStorage", "SoundService", "Teams", "Lighting"}) do
	local service = game:GetService(serviceName)
	RecurseGiveId(service, true, false, true)
end

for _, child in pairs(workspace:GetChildren()) do
	if child == Nodes or child == Trees or child == Vegetation or child == VFX_PARTS or child == shared.Characters then continue end
	RecurseGiveId(child)
end

--[[for _, instance in pairs(workspace:GetDescendants()) do
	if not (instance:IsA("Folder") or instance:IsA("Model") or instance:IsA("BasePart") or instance:IsA("Sound")) then continue end
	shared.GiveInstanceId(instance)
end]]


--[[for _, instance in pairs(game:GetDescendants()) do
	if instance.Parent == game or instance:IsDescendantOf(StarterPlayer) then return end
	shared.GiveInstanceId(instance)
end]]