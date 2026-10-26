-- [PATH] ReplicatedStorage / Modules / RaycastUtil @Type ModuleScript
-- Raycast Util
-- ChickenBagelz
-- July 8, 2022


-- Services
local Replicated = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

-- Folders
local VFX_STORAGE = Replicated:WaitForChild("VFX")
local VFX_PARTS = workspace:WaitForChild("VFX")
local Animals = workspace:WaitForChild("Animals")
local Events = workspace:WaitForChild("Events")
local Values = Replicated:WaitForChild("Values")

-- Local Variables
local Player = Players.LocalPlayer


local RaycastUtil = {}

function RaycastUtil:FilterFunction(name)
	return ((name == "Hit" or name == "HitIgnore" or name == "HitMelee" or name == "HitMeleeIgnore" or name == "HitNoMeleeMouse") and function(hit)
		local parent = hit.Parent
		if not parent then return end
		if (parent.Parent:FindFirstChild("Humanoid") and not parent:IsDescendantOf(Animals) and not parent:IsDescendantOf(Events)) or (parent.Parent.Name == "Attachments" and parent.Parent:IsA("Folder")) or ((parent.Name == "Jail Wall" or hit:FindFirstAncestor("Jail Door")) and name == "Hit") then
			return parent
		elseif (parent:FindFirstChild("Humanoid") and hit.Name == "HumanoidRootPart") or (hit.Transparency >= 1 and (name ~= "HitMelee" or (parent.Name ~= "NodeSpark" and parent.Name ~= "TreeX")) and not hit.CanCollide) or hit.Name == "LeafPart" or (hit.Name == "CactusPart" and name == "Hit") or (hit.Name == "SignPart" and not name:find("Melee")) then
			return hit
		end
	end or name == "HitPlace" and function(hit)
		local parent = hit.Parent
		if (parent.Parent.Name == "Attachments" and parent.Parent:IsA("Folder")) then
			return parent
		elseif (hit.Transparency >= 1 and parent.Name ~= "CollisionParts" and hit.Name ~= "SpawnPart" and not hit.CanCollide) or (parent:FindFirstChild("CollisionParts") or (parent.Parent:FindFirstChild("CollisionParts") and parent.Name ~= "CollisionParts")) or hit.Name == "LeafPart" then
			return hit
		else
			local hum = parent:FindFirstChild("Humanoid")
			if hum and hit.Name ~= "HumanoidRootPart" then
				return hit
			else
				hum = parent.Parent:FindFirstChild("Humanoid")
				if hum then
					return parent
				end
			end
		end
	end or (name == "View" or name == "ViewBench" or name == "ViewExtra") and function(hit)
		local parent = hit.Parent
		local hum = (parent:FindFirstChild("Humanoid") or parent.Parent:FindFirstChild("Humanoid"))
		if hum and (name == "View" or hum.Parent.Name ~= "Sleeper") and (name ~= "ViewBench" or hum.Parent.Name ~= "Contents") then
			return hum.Parent
		elseif (parent.Parent.Name == "Attachments" and parent.Parent:IsA("Folder")) then
			return hit.Parent
		elseif (((name == "View" and hit.Transparency >= 1) or (name == "ViewBench" and hit.Transparency == 1)) and not hit.CanCollide) or hit.Name == "LeafPart" or hit.Name == "CactusPart" or hit.Name == "SignPart" or (name == "View" and hit.CollisionGroup == "Items") then
			return hit
		elseif name == "ViewExtra" and (hit.CollisionGroup == "Items" or not hit.CanCollide) then 
			return hit 
		end
	end or name == "PlacementDefault" and function(hit)
		if not hit then return end
		local parent = hit.Parent
		if not parent then return end
		if hit.Name == "LeafPart" then
			return hit
		elseif (hit.Transparency == 1 and (hit.Position.Y == 478 or hit.Position.Y == 578 or hit.Name == "RadiationPart")) or (parent.Parent.Name == "Attachments" and parent.Parent:IsA("Folder")) then
			return hit.Parent
		elseif (hit.Transparency == 1 and hit.Name == "BuildingPriv") then
			--[[local baseCabinets = hit:FindFirstAncestor("Base Cabinet")
			if baseCabinets and baseCabinets.Parent then-- and base.Parent.Name ~= "MonumentBuildBlock" then
				return baseCabinets
			end]]
			return hit
		else
			local hum = (parent:FindFirstChild("Humanoid") or parent.Parent:FindFirstChild("Humanoid"))
			if hum then
				return hum.Parent
			end
		end
	end or name == "BuildingPrivCheck" and function(hit)
		if hit.Name == "BuildingPriv" then
			local hitBase = hit:FindFirstAncestor("Base")
			if hitBase then
				local baseCabinets = hitBase:FindFirstChild("Base Cabinet")
				if baseCabinets and #baseCabinets:GetChildren() > 0 then return end
			end
		end
		return hit
	end)
end

function RaycastUtil:MouseRaycast(filterFunc, filters, maxRange, filterType, visual, ignoreWater)
	if not Player then return end
	local Mouse = Player:GetMouse()
	local mouseRay = Mouse.UnitRay
	local hit, pos, nor, mat = self:Raycast(mouseRay.Origin, mouseRay.Direction * (maxRange or 1024), (filterType or "Blacklist"), filters, visual, filterFunc, ignoreWater)
	return pos, hit, nor, mat
end

function RaycastUtil:GetBaseCabinetUnder(position, doOnce)
	local ignores = {VFX_PARTS, Animals}
	local oldestCabinet, monumentCabinet
	while true do
		local privHit = self:Raycast(Vector3.new(position.X, 225.6, position.Z), Vector3.new(0, -0.2, 0), "Blacklist", ignores, false, function(hit)
			if hit.Name == "BuildingPriv" then
				local hitBase = hit:FindFirstAncestor("Base")
				if hitBase and not table.find(ignores, hitBase) then
					table.insert(ignores, hitBase)
					local baseCabinets = hitBase:FindFirstChild("Base Cabinet")
					if baseCabinets then 
						local baseCabinet = baseCabinets:FindFirstChild("Base Cabinet")
						if baseCabinet then
							if baseCabinet:GetAttribute("Monument") then 
								monumentCabinet = baseCabinet
								return 
							end
							local placed = baseCabinet:GetAttribute("Placed")
							local oldestPlaced = (oldestCabinet and oldestCabinet.Parent and oldestCabinet:GetAttribute("Placed"))
							if (not oldestPlaced) or placed < oldestPlaced then
								oldestCabinet = baseCabinet
							end
						end
					end
				end
				return 
			end
			return hit
		end)
		if monumentCabinet and privHit then
			if not Player then
				privHit:SetAttribute("LastEnter", os.time())
			end
			return monumentCabinet, privHit:GetAttribute("Safe")
		end
		if doOnce or not privHit then break end
	end
	return oldestCabinet
end

function RaycastUtil:Raycast(start, dir: Vector3, filterType: string, filters: {Instance}, visual: string?, filterFunc: any?, ignoreWater: boolean?, count: number) -- Custom raycast function that supports recursion, object filtering, and ray visualization
	filters = (type(filters) == "table" and filters or {filters})
	count = (count or 0) + 1
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType[filterType]
	raycastParams.FilterDescendantsInstances = filters -- Set custom filters according
	raycastParams.IgnoreWater = ignoreWater
	local isBlockcast = (type(start) == "table" and start.Type == "Block")
	local isSpherecast = (type(start) == "table" and start.Type == "Sphere")
	local raycastResult
	if isBlockcast then
		--print("blockcasting")
		raycastResult = workspace:Blockcast(start.CF, start.Size, dir, raycastParams)
	elseif isSpherecast then
		raycastResult = workspace:Spherecast(start.Position, start.Size, dir, raycastParams)
	else
		raycastResult = workspace:Raycast(start, dir, raycastParams)
	end
	local startPos = (isBlockcast and start.CF.Position or (isSpherecast and start.Position or start))
	local target = startPos + dir
	local position = (raycastResult ~= nil and raycastResult.Position or target) -- When old raycasts used to miss, they would still return a Vector3 of where the ray ended off at. This was readded artifically
	local visualPart
	if visual then
		local part = VFX_STORAGE:FindFirstChild(visual) or VFX_STORAGE:FindFirstChild("DefaultRay")
		if part then
			local distance = (start - position).Magnitude
			visualPart = part:Clone()
			for _, p in pairs(visualPart:GetChildren()) do
				if p:IsA("BasePart") then
					local size = p.Size
					p.Size = Vector3.new(distance, size.Y, size.Z)
				end
			end
			visualPart:SetPrimaryPartCFrame(CFrame.lookAt(start, position) * CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-distance / 2, 0, 0))
			--[[local startPart = visualPart:FindFirstChild("Start")
			if startPart then
				if first then
					startPart:SetPrimaryPartCFrame(visualPart.PrimaryPart.CFrame * CFrame.new(-distance / 2, 0, 0))
				else
					startPart:Destroy()
				end
			end]]
			visualPart.Parent = VFX_PARTS
			if visualPart.Name == "GreenRay" or visualPart.Name == "BlueRay" then
				Debris:AddItem(visualPart, 5)
			end
		end
	end
	if raycastResult then
		local hit = raycastResult.Instance
		if filterFunc and type(filterFunc) == "function" then
			local failed = filterFunc(hit)
			if failed then
				for _, filter in pairs(type(failed) == "table" and failed or {failed}) do
					table.insert(filters, filter)
				end
				if count < (Values.Loading.Value and 50 or 500) then
					if isBlockcast or isSpherecast then
						local size = start.Size
						local cf = (isBlockcast and start.CF or CFrame.new(start.Position))
						local distance = raycastResult.Distance
						local r1, r2, r3 = cf:ToEulerAnglesXYZ()
						local origin = startPos + dir.Unit * math.max(distance - 0.5, 0)
						local originCF = CFrame.new(origin) * CFrame.Angles(r1, r2, r3)
						--print(distance)
						if isBlockcast then
							start.CF = originCF
						elseif isSpherecast then
							start.Position = originCF.Position
						end
						return self:Raycast(start, target - origin, filterType, filters, visual, filterFunc, ignoreWater, count)
					else
						local origin = position - dir.Unit * 0.2
						return self:Raycast(origin, target - origin, filterType, filters, visual, filterFunc, ignoreWater, count)
					end
				else
					warn("[WARNING] RAYCAST RE-ENTRANCY EXCEEDED")
				end
			end
		end
		return hit, position, raycastResult.Normal, raycastResult.Material, visualPart
	else
		return nil, position, nil, nil, visualPart
	end
end

function RaycastUtil:GetClosestPointFromRay(startPoint: Vector3, endPoint: Vector3, point: Vector3): (Vector3, number, number)
	local line: Vector3 = endPoint - startPoint
	local len: number = line.Magnitude
	line = line.Unit
	local v: Vector3 = point - startPoint
	local alpha: number = v:Dot(line)
	local clampedAlpha: number = math.clamp(alpha, 0, len)
	return startPoint + line * clampedAlpha, clampedAlpha, len
end

function RaycastUtil:NormalToFace(normalVector, part)
	local tolerance = 1 - 0.001
	for _, normalId in pairs(Enum.NormalId:GetEnumItems()) do
		local faceNormal = part.CFrame:VectorToWorldSpace(Vector3.FromNormalId(normalId))
		if faceNormal:Dot(normalVector) <= tolerance then continue end
		return normalId
	end
end

return RaycastUtil