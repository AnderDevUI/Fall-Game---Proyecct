-- [PATH] ReplicatedStorage / Modules / VFXModule @Type ModuleScript


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local VFX = ReplicatedStorage:WaitForChild("VFX")
local VFX2 = workspace:WaitForChild("VFX")
local Terrain = workspace:WaitForChild("Terrain")
local Nodes = workspace:WaitForChild("Nodes")
local Animals = workspace:WaitForChild("Animals")
local v1 = require(Modules:WaitForChild("RaycastUtil"))
local v2 = require(Modules:WaitForChild("WeldModule"))
local v3 = require(Modules:WaitForChild("Items"))
local v4 = require(Modules:WaitForChild("ToolInfo"))
local v5 = require(Modules:WaitForChild("CameraShakeModule"))
local v6 = require(Modules:WaitForChild("NumberUtil"))
local v7 = require(Modules:WaitForChild("SettingsModule"))
local v8
local v9 = RunService:IsClient() and Players.LocalPlayer

if v9 then
	v8 = require(Modules:WaitForChild("SoundModule"))
end
local CurrentCamera = workspace.CurrentCamera
local t1 = {}
local t2 = { __mode = "k" }
local v10 = setmetatable(t1, t2)
local t3 = {}
local t4 = {}
local n1 = 0
local v11
local t5 = {}
local t6 = {}
local t7 = { HeliRocket = true }
local v12 = v5.new(Enum.RenderPriority.Camera.Value, function(p1) -- line: 77
	-- upvalues: CurrentCamera (copy)
	CurrentCamera.CFrame *= p1
end)
v12:Start()
local v13 = Random.new()
v1:FilterFunction("HitIgnore")
local t8 = {
	Lasers = t3,
	TracerSkins = {
		"Frosty",
		"Cherry Blossom",
		"Cyber",
		"Cryo",
		"Black Ice",
		"Nutcracker",
		"Red Relic",
		"Glitch",
		"Oni",
		"Vaporwave",
		"Anime Bloss",
		"Elite Bunny",
		"Phantom",
		"VIP",
		"Gingerbread",
		"Diablo",
		"CyberPop",
		"Stellark",
		"Medusa",
		"Stellark Dragon",
		"High Tide",
		"Valentine",
		"Blue Gem",
		"Monster",
		"Crimson Glitched",
		"Arcane",
		"Hot Rod",
		"Tyrant",
		"Independence",
		"Tempest",
		"Turbo",
		"Anime Waifu",
		"Dune"
	}
}
local t9 = {}

function t9.FakeHitFunc(...) -- line: 126
	-- upvalues: t8 (copy)
	t8:HitVFX(...)
end

function t9.FakeStepFunc(p2, p3, p4) -- line: 129
	-- upvalues: Players (copy), Debris (copy), VFX (copy), VFX2 (copy), v1 (copy), v6 (copy), t4 (copy)
	local LocalPlayer = Players.LocalPlayer
	if LocalPlayer and not t4[p4] then
		local Character = LocalPlayer.Character
		if Character then
			local Head = Character:FindFirstChild("Head")
			if Head then
				local v14 = v1:GetClosestPointFromRay(p2, p3, Head.Position)
				if v6:IsWithin(Head.Position, v14, 10) then
					t4[p4] = true
					local v15 = VFX.WhizzPart:Clone()
					v15.CFrame = CFrame.new(v14)
					v15.Parent = VFX2
					local v16 = v15:GetChildren()
					v16[math.random(1, #v16)]:Play()
					Debris:AddItem(v15, 0.5)
				end
			end
		end
	end
end

function t8.HitVFX(_, ...) -- line: 149
	-- upvalues: Players (copy), t8 (copy)
	local t10 = { ... }
	local v17 = t10[1]
	local v18 = tick()
	while v17 do
		if v17.Parent then
			break
		end
		if tick() - v18 >= 1 then
			break
		end
		task.wait()
	end
	local v19
	if v17 and v17.Parent and v17.Parent.Parent then
		v19 = v17.Parent:FindFirstChild("Humanoid") or v17.Parent.Parent:FindFirstChild("Humanoid")
	else
		return
	end
	local LocalPlayer = Players.LocalPlayer
	if v19 and LocalPlayer and (v19.Parent == LocalPlayer.Character or v19.Parent.Name == "BTR") then
		return
	end
	local v20 = t10[2]
	t10[2] = typeof(v20) == "CFrame" and (v17.CFrame * t10[2]).Position or t10[2]
	local v21 = if v19 then "CreateBlood" else "CreateHole"
	t8[v21](t8, unpack(t10))
end

function t8.FlashPart(p6, p7) -- line: 167
	-- upvalues: RunService (copy), v10 (copy)
	local v22 = tick()
	while p7 do
		if p7.Parent then
			break
		end
		if tick() - v22 >= 1 then
			break
		end
		task.wait()
	end
	if p7 and p7:IsDescendantOf(workspace) and not p6:CheckCameraDistance(p7.Position, 1000) then
		if not v10[p7] or tick() - v10[p7] >= 0.08 then
			for _, v23 in pairs(p7:GetChildren()) do
				if not v23:IsA("Attachment") and not v23:IsA("Sound") then
					v23.Enabled = true
				end
			end
			task.defer(function() -- line: 180
				-- upvalues: p7 (copy), RunService (copy), v10 (copy)
				while true do
					if not (p7 and p7:IsDescendantOf(workspace)) then
						return
					end
					if tick() - v10[p7] >= 0.08 then
						break
					end
					RunService.RenderStepped:Wait()
				end
				for _, v24 in pairs(p7:GetChildren()) do
					if not v24:IsA("Attachment") and not v24:IsA("Sound") then
						v24.Enabled = false
					end
				end
			end)
		end
		v10[p7] = tick()
	end
end

function t8.InitializeLaser(_, p9) -- line: 196
	-- upvalues: v9 (copy), t3 (copy)
	assert(v9, "VFXModule.InitializeLaser can currently only be called from the Client.")
	if p9 and p9.Parent and p9.Parent.Name:find(" Lasersight") then
		if not table.find(t3, p9) then
			table.insert(t3, p9)
		end
	else
		local v25 = tick()
		while p9 do
			if p9.Parent then
				break
			end
			if tick() - v25 >= 3 then
				break
			end
			task.wait()
		end
		if p9 and p9.Parent then
			local v26 = p9:WaitForChild("Attachments", 3)
			if v26 and v26.Parent then
				local v27 = os.clock()
				local v28, v29
				while true do
					if os.clock() - v27 < 3 then
						if v26.Parent then
							local v30 = v26:FindFirstChild("Salvaged Lasersight")
							if v30 then
								v29 = v30
								break
							end
							v28 = v26:FindFirstChild("Military Lasersight")
							if v28 then
								v29 = v28
								break
							end
							task.wait()
							continue
						end
						return
					end
					v29 = v28
					break
				end
				if v29 and v29.Parent then
					local v31 = v29:WaitForChild("Laser", 3)
					if v31 and v31.Parent and not table.find(t3, v31) then
						table.insert(t3, v31)
					end
				end
			end
		end
	end
end

function t8.CreateGib(_, p11, p12, p13, p14, p15) -- line: 229
	-- upvalues: VFX2 (copy), v7 (copy), t6 (copy)
	local v32 = p15 or 1
	local n2 = 0
	local n3 = 0
	local n4 = 0
	for v33, v34 in pairs(t6) do
		local Gib = v34.Gib
		local Priority = v34.Priority
		if Gib and Gib.Parent then
			n2 += 1
			if not (n4 > 0) and Priority == "High" then
				n4 = v33 - n3
			end
		else
			table.remove(t6, v33)
			n3 += 1
		end
	end
	local v35 = v7.GetSetting("Graphics", "Max Gib Count") <= n2
	if not v35 or n4 > 0 then
		local v36 = p11:Clone()
		v36.Anchored = true
		v36.Size *= v32
		local BodyForce = Instance.new("BodyForce")
		local v37 = workspace.Gravity * v36:GetMass() * p14
		BodyForce.Force = Vector3.new(0, v37, 0)
		BodyForce.Name = "AntiGravity"
		BodyForce.Parent = v36
		v36.Parent = VFX2
		task.delay(0.1, function() -- line: 256
			-- upvalues: p12 (copy), v36 (copy)
			if v36 and v36.Parent then
				v36.CFrame = p12
				v36.Anchored = false
			end
		end)
		local t11 = {
			Gib = v36,
			Priority = p13
		}
		if v35 then
			local Gib = t6[n4].Gib
			if Gib and Gib.Parent then
				Gib:Destroy()
			end
			t6[n4] = t11
		else
			table.insert(t6, t11)
		end
		return t11
	end
end

local function HandleGibs(_, p17, p18, p19, p20) -- line: 281
	local v38 = p19 or 0.001
	local v39 = tick()
	while #p17 > 0 do
		local v40 = tick() - v39
		local v41 = v40 - (p18 - v38)
		local v42 = math.clamp(v41, 0, v38) * (1 / v38)
		for v43, v44 in pairs(p17) do
			local Gib = v44.Gib
			if Gib and Gib.Parent then
				Gib.Transparency = v42
				if v42 >= 1 then
					Gib:Destroy()
				end
				if p20 and p20 <= v40 then
					v44.Priority = "High"
				end
			else
				table.remove(p17, v43)
			end
		end
		if v42 >= 1 then
			break
		end
		task.wait()
	end
end

t8.HandleGibs = HandleGibs

function t8.CreateGibs(p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32) -- line: 307
	-- upvalues: VFX (copy)
	local v45 = VFX[p22]
	local t12 = {}
	if v45 then
		local v46 = v45:GetChildren()
		local v47 = math.random(p24, p25)
		for _ = 1, v47 do
			local Angles = CFrame.Angles
			local v48 = math.random(-p29, p29)
			local v49 = math.rad(v48)
			local v50 = math.random(-p27, p28)
			local v51 = p23 * Angles(v49, math.rad(v50), 0)
			local v52
			if p32 then
				v52 = CFrame.new(0, 0, math.random(-20, 20) / 10)
			end
			local v53
			if not p32 or not v52 then
				v53 = CFrame.new()
			else
				v53 = v52
			end
			local v54 = v51 * v53
			local v55 = p21:CreateGib(v46[math.random(1, #v46)], v54, "High", 0.5, p26)
			if v55 then
				local Gib = v55.Gib
				Gib.AssemblyLinearVelocity = v54.LookVector * math.random(p30 * 10, p31 * 10) / 10
				Gib.CanCollide = p22 ~= "DigGibs"
				table.insert(t12, v55)
			end
		end
	end
	if p32 and #t12 > 0 then
		if p21:CheckCameraDistance(p23.Position, 200) then
			return
		end
		p21:HandleGibs(t12, 3, 0.5)
	end
	return t12
end

function t8.CreateBenchGibs(p33, p34, p35) -- line: 329
	-- upvalues: v8 (ref), VFX (copy)
	if p35 and not p33:CheckCameraDistance(p35.Position, 700) then
		local v56 = VFX.BenchGibs:FindFirstChild(p34)
		if v56 then
			local v57 = v56:Clone()
			v57:PivotTo(p35)
			local t13 = {}
			for _, v58 in pairs(v57:GetChildren()) do
				if v58:IsA("Sound") then
					v58.PlaybackSpeed += math.random(-50, 50) / 1000
					v8:PlayDuplicateSound(nil, v58, p35.Position)
				elseif v58:IsA("BasePart") then
					local v59 = p33:CreateGib(v58, v58.CFrame, "Low", 0.5, 0.8)
					if v59 then
						local Gib = v59.Gib
						local v60 = math.random(-50, 50) / 10
						local v61 = math.random(-50, 50) / 10
						local v62 = math.random(-50, 50) / 10
						Gib.AssemblyLinearVelocity = Vector3.new(v60, v61, v62)
						table.insert(t13, v59)
					end
				end
			end
			v57:Destroy()
			if not (#t13 <= 0) then
				p33:HandleGibs(t13, 5, 0.25, 1)
			end
		end
	end
end

function t8.CreateHole(p36, p37, p38, p39, p40, p41, p42) -- line: 354
	-- upvalues: Debris (copy), VFX (copy), VFX2 (copy), Terrain (copy), Nodes (copy), Animals (copy), v2 (copy), v3 (copy), v4 (copy), v7 (copy)
	if p40 == Enum.Material.Water then
		return
	end
	local v63 = type(p41) == "table"
	local v64 = if v63 then v3[p41.ID] else nil
	if not v63 or not v64 then
		if type(p41) == "number" then
			v64 = v3[p41]
		else
			v64 = false
		end
	end
	local v65 = v64 and v4[v64.Name]
	local v66 = v65 and v65.ObjectDamages
	local v67 = tick()
	while p37 do
		if p37.Parent then
			break
		end
		if tick() - v67 >= 1 then
			break
		end
		task.wait()
	end
	local v68
	if p37 and p37.Parent and p38 and p39 then
		v68 = p37 == Terrain
	else
		return
	end
	local v69 = CFrame.new(p38, p38 + p39)
	if p36:CheckCameraDistance(v69.Position, 100) then
		return
	end
	local v70 = v66 and v66.Nodes and p37:IsDescendantOf(Nodes)
	local v71 = if p40 == Enum.Material.Rock or p40 == Enum.Material.Brick or p40 == Enum.Material.Slate or p40 == Enum.Material.Basalt or p40 == Enum.Material.Concrete then true else p40 == Enum.Material.Asphalt
	local v72 = if p40 == Enum.Material.Metal or p40 == Enum.Material.DiamondPlate then true else p40 == Enum.Material.CorrodedMetal
	local v73 = if p40 == Enum.Material.Wood then true else p40 == Enum.Material.WoodPlanks
	local v74 = if p40 == Enum.Material.Glass then true else p37.Name == "GlassPart"
	local v75 = p37:IsDescendantOf(Animals) or p37.Parent.Name == "Sleeper"
	local v76 = v64 and v64.Type == "Tool"
	local v77 = if p37.Parent.Name == "Trash Can" then true else p37.Parent.Name == "Oil Barrel"
	local v78
	if v70 then
		v78 = "Node2"
	elseif not v77 or not v76 then
		if v72 then
			v78 = "Metal"
		elseif v73 then
			v78 = "Wood"
		elseif v74 then
			v78 = "Glass"
		elseif v68 then
			v78 = "Terrain"
		elseif v75 then
			v78 = "Animal"
		else
			v78 = "Default"
		end
	else
		v78 = "Barrel"
	end
	local v79 = VFX["Impact" .. v78]:Clone()
	v79.CFrame = v69
	v79.Anchored = p37.Anchored
	v79.Parent = VFX2
	local v80
	local Angles = CFrame.Angles
	local v81 = math.random(0, 359)
	local v82 = v69 * Angles(0, 0, (math.rad(v81)))
	local v83
	if v7.GetSetting("Graphics", "Impacts") == true then
		local v84
		if v72 then
			v84 = "Metal"
		elseif v74 then
			v84 = "Glass"
		elseif v76 then
			if v71 then
				v84 = "Stone"
			elseif v73 then
				v84 = "Wood"
			elseif v75 then
				v84 = "Blood"
			else
				v84 = "Melee"
			end
		else
			v84 = ""
		end
		local v85 = VFX[v84 .. "Hole"]:Clone()
		v80 = v85
		v85.CFrame = v82
		local v86 = math.random(20, 30)
		local v87
		if v76 then
			v87 = 2
		elseif v72 or v74 then
			v87 = 1.5
		else
			v87 = 1
		end
		local v88 = v86 * v87 / 100
		local Z = v85.Size.Z
		v85.Size = Vector3.new(v88, v88, Z)
		v85.Anchored = p37.Anchored
		if p42 then
			v85.Decal.Transparency = 1
		end
		v85.Parent = VFX2
		v83 = v85
	end
	if not p37.Anchored then
		v2:WeldParts(v79, p37)
		if v83 then
			v2:WeldParts(v83, p37)
		end
	end
	local v89
	for _, v90 in pairs(v79:GetChildren()) do
		if v90:IsA("Sound") then
			v90.PlaybackSpeed += math.random(-50, 50) / 1000
			v90:Play()
		else
			v90.Enabled = true
			if v90.Name == "Dirt" then
				if v68 then
					if p40 then
						if not v89 then
							local new = ColorSequence.new
							local v91 = p40.Name:find("Grass") and Enum.Material.Mud or p40
							v89 = new(Terrain:GetMaterialColor(v91) or Color3.fromRGB(100, 100, 100) or p37.Color)
						end
						v90.Color = v89
					end
				else
					v89 = v89 or ColorSequence.new(p37.Color)
					v90.Color = v89
				end
			end
		end
	end
	local Parent = p37.Parent
	Parent = Parent.Name == "NodeSpark" and Parent.Parent or Parent
	local v92, v93
	if v70 then
		v93 = p36:CreateGibs(Parent.Name .. "Gibs", v82, 4, 6, 0.25, 60, 60, 60, 12.5, 17.5, false)
		v92 = v93
	end
	if not v70 or not v93 then
		v92 = {}
	end
	Debris:AddItem(v79, 5)
	if v83 then
		Debris:AddItem(v83, 10)
	end
	task.delay(0.16, function() -- line: 445
		-- upvalues: v80 (ref), v92 (ref), p37 (copy), v79 (copy), VFX2 (copy)
		if v79 and v79.Parent then
			for _, v94 in pairs(v79:GetChildren()) do
				if not v94:IsA("Sound") then
					v94.Enabled = false
				end
			end
		end
		local v95 = tick()
		local v96 = false
		while true do
			local v97 = tick() - v95
			local v98 = v97 - 2.5
			local v99 = math.clamp(v98, 0, 0.5) * 2
			for _, v100 in pairs(v92) do
				local Gib = v100.Gib
				if Gib and Gib.Parent then
					Gib.Transparency = v99
					if v99 >= 1 then
						Gib:Destroy()
					end
				end
			end
			if v99 >= 1 then
				v92 = {}
			end
			if not (v80 and v80.Parent) then
				v96 = true
			end
			local v101, v102
			if v96 then
				v101 = v96
				v102 = true
			elseif v97 >= 10 or p37 == nil or p37.Parent == nil or p37.Parent:IsDescendantOf(VFX2) then
				v102 = false
			elseif p37.Transparency >= 1 then
				if p37.CanCollide then
					v101 = v96
					v102 = true
				else
					v102 = false
				end
			else
				v101 = v96
				v102 = true
			end
			if not v102 then
				if v80 then
					v80:Destroy()
				end
				v101 = true
			end
			if not (#v92 <= 0) then
				task.wait()
				v96 = v101
				continue
			end
			if v101 then
				break
			end
			task.wait()
			v96 = v101
		end
	end)
end

function t8.CreateBlood(p43, p44, p45) -- line: 487
	-- upvalues: Debris (copy), VFX (copy), VFX2 (copy), v2 (copy), v7 (copy)
	if v7.GetSetting("Graphics", "Blood") then
		local v103 = tick()
		while p44 do
			if p44.Parent then
				break
			end
			if tick() - v103 >= 1 then
				break
			end
			task.wait()
		end
		if p44 and p44.Parent and not p43:CheckCameraDistance(p45, 500) then
			local v104 = VFX.BloodPart:Clone()
			v104.CFrame = CFrame.new(p45)
			v104.Anchored = false
			v104.Parent = VFX2
			v2:WeldParts(v104, p44)
			for _, v105 in pairs(v104:GetChildren()) do
				v105.Enabled = true
			end
			Debris:AddItem(v104, 2)
			task.delay(0.15, function() -- line: 505
				-- upvalues: v104 (copy)
				if v104 and v104.Parent then
					for _, v106 in pairs(v104:GetChildren()) do
						v106.Enabled = false
					end
				end
			end)
		end
	end
end

function t8.CreateExplosion(p46, p47, p48, p49, p50, p51, p52) -- line: 513
	-- upvalues: v8 (ref), Debris (copy), VFX (copy), VFX2 (copy), v7 (copy), v12 (copy), v13 (copy)
	local v107 = p48 or 1
	local v108 = p49 or 0.45
	local Position = p47.Position
	local v109, v110 = p46:CheckCameraDistance(Position, 1000, true)
	local v111, v112, v113, v114
	if v110 then
		local v115 = 1 - v110 / (p52 or 150)
		local v116 = math.clamp(v115, 0, 1)
		if v116 > 0 then
			v111 = v12
			v112 = v116 * 10 * v107
			if v7.GetSetting("General", "Decrease Camera Shake") then
				v113 = 0.5
			else
				v113 = 1
			end
			v114 = false
		else
			v114 = true
		end
	else
		v114 = true
	end
	if not v114 then
		v111:ShakeOnce(v112 * v113, 30, 0, 1.5)
	end
	local v117 = VFX[("Explosion%*"):format(p51 or "")]
	if v109 then
		if p50 then
			local v118 = v117[p50]:Clone()
			local Part = Instance.new("Part")
			Part.Name = "ExplosionPart"
			Part.CanCollide = false
			Part.CanQuery = false
			Part.CanTouch = false
			Part.Anchored = true
			Part.Transparency = 1
			Part.CFrame = p47
			Part.Parent = VFX2
			v118.Parent = Part
			if p50 == "HeliCrashing" then
				v118.PlaybackSpeed = 1.2 + v13:NextNumber(-0.05, 0.05)
			end
			v8:ReverbSound(v118, 600, 1000)
			v118:Play()
			v118.Ended:Wait()
			Part:Destroy()
		end
	else
		if p51 ~= "Cursed" and p51 ~= "Small" then
			local Explosion = Instance.new("Explosion")
			Explosion.Name = "ExplosionEffect"
			Explosion.Position = Position
			Explosion.BlastRadius = 0
			Explosion.BlastPressure = 0
			Explosion.Parent = VFX2
			Debris:AddItem(Explosion, 5)
		end
		local v119 = v117:Clone()
		v119.CFrame = p47
		v119.Parent = VFX2
		local t14 = {}
		for _, v120 in pairs(v119:GetChildren()) do
			if v120:IsA("Sound") then
				if v120.Name == p50 then
					v8:ReverbSound(v120, 600, 1000)
					v120:Play()
				end
			else
				v120.Enabled = true
				if v120:IsA("ParticleEmitter") then
					table.insert(t14, v120)
				end
			end
		end
		task.delay(0.15, function() -- line: 573
			-- upvalues: v119 (copy)
			if v119 and v119.Parent then
				v119.Light.Enabled = false
			end
		end)
		task.wait(v108)
		if v119 and v119.Parent then
			for _, v121 in pairs(t14) do
				v121.Enabled = false
			end
			task.wait(5)
			if v119 and v119.Parent then
				v119:Destroy()
			end
		end
	end
end

local v122 = if v9 then 40000 else 10000

local function IsFiniteNumber(p53) -- line: 590
	if type(p53) == "number" and p53 == p53 then
		if p53 == (1/0) then
			return false
		end
		return p53 ~= (-1/0)
	end
	return false
end

local function IsFiniteVector3(p54) -- line: 594
	if typeof(p54) == "Vector3" then
		local X = p54.X
		local v123
		if type(X) == "number" and X == X then
			if X == (1/0) then
				v123 = false
			else
				v123 = X ~= (-1/0)
			end
		else
			v123 = false
		end
		if v123 then
			local Y = p54.Y
			local v124
			if type(Y) == "number" and Y == Y then
				if Y == (1/0) then
					v124 = false
				else
					v124 = Y ~= (-1/0)
				end
			else
				v124 = false
			end
			if v124 then
				local Z = p54.Z
				if type(Z) == "number" and Z == Z then
					if Z == (1/0) then
						return false
					end
					return Z ~= (-1/0)
				end
				return false
			end
			return v124
		end
		return v123
	end
	return false
end

local t15 = {
	["Salvaged Flycopter"] = true,
	["Wooden Boat"] = true,
	["Military Boat"] = true
}

local function WithSeatedVehicles(p55) -- line: 603
	-- upvalues: t15 (copy)
	if type(p55) == "table" then
		local v125 = p55
		for _, v126 in p55 do
			if typeof(v126) == "Instance" and v126:IsA("Model") then
				local Humanoid = v126:FindFirstChildOfClass("Humanoid")
				local v127 = Humanoid and Humanoid.SeatPart
				local v128 = v127 and v127.Parent
				if v128 and v128:IsA("Model") and t15[v128.Name] and not table.find(v125, v128) then
					if v125 == p55 then
						v125 = table.clone(p55)
					end
					table.insert(v125, v128)
				end
			end
		end
		return v125
	end
	return p55
end

t8.WithSeatedVehicles = WithSeatedVehicles

local function ShooterSeat(p56) -- line: 623
	-- upvalues: t15 (copy)
	if type(p56) == "table" then
		for _, v129 in p56 do
			if typeof(v129) == "Instance" and v129:IsA("Model") then
				local Humanoid = v129:FindFirstChildOfClass("Humanoid")
				if Humanoid then
					local SeatPart = Humanoid.SeatPart
					local v130 = SeatPart and SeatPart.Parent
					if v130 and v130:IsA("Model") and t15[v130.Name] then
						return v129, SeatPart
					end
					return v129, nil
				end
			end
		end
	end
	return nil, nil
end

local function ShooterCarry(p57) -- line: 644
	-- upvalues: ShooterSeat (copy)
	local _, v131 = ShooterSeat(p57)
	if v131 then
		local AssemblyLinearVelocity = v131.AssemblyLinearVelocity
		local v132
		if typeof(AssemblyLinearVelocity) == "Vector3" then
			local X = AssemblyLinearVelocity.X
			local v133
			if type(X) == "number" and X == X then
				if X == (1/0) then
					v133 = false
				else
					v133 = X ~= (-1/0)
				end
			else
				v133 = false
			end
			if v133 then
				local Y = AssemblyLinearVelocity.Y
				local v134
				if type(Y) == "number" and Y == Y then
					if Y == (1/0) then
						v134 = false
					else
						v134 = Y ~= (-1/0)
					end
				else
					v134 = false
				end
				if v134 then
					local Z = AssemblyLinearVelocity.Z
					if type(Z) == "number" and Z == Z then
						if Z == (1/0) then
							v132 = false
						else
							v132 = Z ~= (-1/0)
						end
					else
						v132 = false
					end
				else
					v132 = v134
				end
			else
				v132 = v133
			end
		else
			v132 = false
		end
		if v132 then
			if AssemblyLinearVelocity.Magnitude > 300 then
				AssemblyLinearVelocity = AssemblyLinearVelocity.Unit * 300
			end
			return AssemblyLinearVelocity
		end
	end
	return (Vector3.new(0, 0, 0))
end

local v135 = v122

function t8.CreateProjectile(p58, p59) -- line: 655
	-- upvalues: n1 (ref), v11 (ref), RunService (copy), Debris (copy), VFX (copy), VFX2 (copy), v1 (copy), t4 (copy), t5 (copy), t7 (copy), t8 (copy), t9 (copy), WithSeatedVehicles (copy), ShooterSeat (copy), v135 (copy)
	local ShooterOffset = p59.ShooterOffset
	if typeof(ShooterOffset) == "Vector3" then
		local ShooterOffset = p59.ShooterOffset
		local v136
		if typeof(ShooterOffset) == "Vector3" then
			local X = ShooterOffset.X
			local v137
			if type(X) == "number" and X == X then
				if X == (1/0) then
					v137 = false
				else
					v137 = X ~= (-1/0)
				end
			else
				v137 = false
			end
			if v137 then
				local Y = ShooterOffset.Y
				local v138
				if type(Y) == "number" and Y == Y then
					if Y == (1/0) then
						v138 = false
					else
						v138 = Y ~= (-1/0)
					end
				else
					v138 = false
				end
				if v138 then
					local Z = ShooterOffset.Z
					if type(Z) == "number" and Z == Z then
						if Z == (1/0) then
							v136 = false
						else
							v136 = Z ~= (-1/0)
						end
					else
						v136 = false
					end
				else
					v136 = v138
				end
			else
				v136 = v137
			end
		else
			v136 = false
		end
		if v136 and p59.ShooterOffset.Magnitude < 20 then
			local v139, v140 = ShooterSeat(p59.Filters)
			local v141 = v140 and v139 and v139.PrimaryPart
			if v141 then
				local v142 = v141.CFrame * CFrame.new(0, 1.5, 0) * p59.ShooterOffset
				local v143 = v142 - p59.Position
				p59.Position = v142
				local PositionFirst = p59.PositionFirst
				if typeof(PositionFirst) == "Vector3" then
					p59.PositionFirst += v143
				end
			end
		end
	end
	if p58:CheckCameraDistance(p59.Position, p59.MaxRange * 1.5) then
		return
	end
	p59.Filters = WithSeatedVehicles(p59.Filters)
	local FilterFunction = p59.FilterFunction
	local v144 = type(FilterFunction) == "string" and v1:FilterFunction(p59.FilterFunction) or p59.FilterFunction
	local HitFunction = p59.HitFunction
	local v145 = type(HitFunction) == "string" and t9[p59.HitFunction] or p59.HitFunction
	local MissFunction = p59.MissFunction
	local v146 = type(MissFunction) == "string" and t9[p59.MissFunction] or p59.MissFunction
	local StepFunction = p59.StepFunction
	local v147 = type(StepFunction) == "string" and t9[p59.StepFunction] or p59.StepFunction
	local v148 = p59.Direction * p59.Speed
	local SavedVariables = p59.SavedVariables
	local v149, v150
	if SavedVariables then
		v150 = p59.SavedVariables[1]
		v149 = v150
	end
	if not SavedVariables or not v150 then
		v149 = v148
	end
	local SavedVariables2 = p59.SavedVariables
	local v151, v152
	if SavedVariables2 then
		v152 = p59.SavedVariables[2]
		v151 = v152
	end
	if not SavedVariables2 or not v152 then
		v151 = p59.Position
	end
	local SavedVariables3 = p59.SavedVariables
	local v153, v154
	if SavedVariables3 then
		v154 = p59.SavedVariables[3]
		v153 = v154
	end
	if not SavedVariables3 or not v154 then
		v153 = 0
	end
	local v155 = (p59.SavedVariables and p59.SavedVariables[4]) == true
	local SavedVariables4 = p59.SavedVariables
	local v156, v157
	if SavedVariables4 then
		v157 = p59.SavedVariables[5]
		v156 = v157
	end
	if not SavedVariables4 or not v157 then
		v156 = p59.Speed
	end
	local SavedVariables5 = p59.SavedVariables
	local v158, v159
	if SavedVariables5 then
		v159 = p59.SavedVariables[6]
		v158 = v159
	end
	if not SavedVariables5 or not v159 then
		v158 = p59.Gravity
	end
	local SavedVariables6 = p59.SavedVariables
	local v160, v161
	if SavedVariables6 then
		v161 = p59.SavedVariables[7]
		v160 = v161
	end
	if not SavedVariables6 or not v161 then
		v160 = p59.MaxRange
	end
	local SavedVariables7 = p59.SavedVariables
	local v162, v163
	if SavedVariables7 then
		v163 = p59.SavedVariables[8]
		v162 = v163
	end
	if not SavedVariables7 or not v163 then
		v162 = 0
	end
	local SavedVariables8 = p59.SavedVariables
	local v164, v165
	if SavedVariables8 then
		v165 = p59.SavedVariables[9]
		v164 = v165
	end
	local v166
	if not SavedVariables8 or not v165 then
		local Filters = p59.Filters
		local _, v167 = ShooterSeat(Filters)
		local v168 = false
		local v169 = false
		local v170 = false
		local v171 = false
		local v172 = false
		if v167 then
			v168 = true
		else
			v172 = true
		end
		local AssemblyLinearVelocity, v173
		if v168 then
			AssemblyLinearVelocity = v167.AssemblyLinearVelocity
			if typeof(AssemblyLinearVelocity) == "Vector3" then
				v169 = true
			else
				v173 = false
				v172 = false
			end
		end
		v168 = false
		local X, v174
		if v169 then
			X = AssemblyLinearVelocity.X
			if type(X) == "number" then
				v168 = true
			else
				v174 = false
				v170 = true
			end
		end
		v169 = false
		if v168 then
			if X == X then
				v169 = true
			else
				v174 = false
				v170 = true
			end
		end
		v168 = false
		if v169 then
			if X == (1/0) then
				v174 = false
				v170 = true
			else
				v168 = true
			end
		end
		v169 = false
		if v168 then
			if X == (-1/0) then
				v171 = true
			else
				v169 = true
			end
		end
		v168 = false
		if v169 then
			v174 = true
			v170 = true
		end
		v169 = false
		if v171 then
			v174 = false
			v170 = true
		end
		v171 = false
		if v170 then
			if v174 then
				v171 = true
			else
				v173 = v174
				v172 = false
			end
		end
		v170 = false
		local Y, v175
		if v171 then
			Y = AssemblyLinearVelocity.Y
			if type(Y) == "number" then
				v170 = true
			else
				v175 = false
				v169 = true
			end
		end
		v171 = false
		if v170 then
			if Y == Y then
				v171 = true
			else
				v175 = false
				v169 = true
			end
		end
		v170 = false
		if v171 then
			if Y == (1/0) then
				v175 = false
				v169 = true
			else
				v170 = true
			end
		end
		v171 = false
		if v170 then
			if Y == (-1/0) then
				v168 = true
			else
				v171 = true
			end
		end
		if v171 then
			v175 = true
			v169 = true
		end
		v171 = false
		if v168 then
			v175 = false
			v169 = true
		end
		v168 = false
		if v169 then
			if v175 then
				v168 = true
			else
				v173 = v175
				v172 = false
			end
		end
		v169 = false
		local Z
		if v168 then
			Z = AssemblyLinearVelocity.Z
			if type(Z) == "number" then
				v169 = true
			else
				v173 = false
				v172 = false
			end
		end
		v168 = false
		if v169 then
			if Z == Z then
				v168 = true
			else
				v173 = false
				v172 = false
			end
		end
		v169 = false
		if v168 then
			if Z == (1/0) then
				v173 = false
				v172 = false
			else
				v169 = true
			end
		end
		v168 = false
		if v169 then
			if Z == (-1/0) then
				v171 = true
			else
				v168 = true
			end
		end
		if v168 then
			v173 = true
			v172 = false
		end
		if v171 then
			v173 = false
			v172 = false
		end
		if v172 then
			v166 = Vector3.new(0, 0, 0)
		elseif v173 then
			if AssemblyLinearVelocity.Magnitude > 300 then
				v166 = AssemblyLinearVelocity.Unit * 300
			else
				v166 = AssemblyLinearVelocity
			end
		else
			v166 = Vector3.new(0, 0, 0)
		end
		v164 = v166
	else
		v166 = v165
	end
	local v176 = VFX:FindFirstChild(p59.TracerName or "")
	local v177 = v176
	local v178, v179, v180, v181
	local v182 = false
	local v183 = false
	local v184 = false
	local v185, v186
	if v176 then
		local v187
		if v176.Name:find("Rocket") == nil then
			v182 = false
			v187 = false
		else
			v182 = true
			v187 = true
		end
		local v188
		if v176.Name:find("Arrow") == nil then
			v183 = false
			v188 = false
		else
			v183 = true
			v188 = true
		end
		local v189
		if v176.Name == "NailBullet" then
			v184 = true
			v189 = true
		else
			v184 = false
			v189 = false
		end
		local v190, v191
		if t7[v176.Name] then
			local v192 = CFrame.new()
			if v192 then
				v190 = v192
				v191 = true
			elseif v187 then
				local v193 = CFrame.Angles(0, -1.5707963267948966, 0)
				if v193 then
					v190 = v193
					v191 = true
				else
					v191 = false
				end
			else
				v191 = false
			end
		elseif v187 then
			local v194 = CFrame.Angles(0, -1.5707963267948966, 0)
			if v194 then
				v190 = v194
				v191 = true
			else
				v191 = false
			end
		else
			v191 = false
		end
		if not v191 then
			local v195
			if v188 then
				local v196 = CFrame.Angles(0, 3.141592653589793, 0)
				if v196 then
					v190 = v196
					v195 = true
				elseif v189 then
					local v197 = CFrame.Angles(1.5707963267948966, 0, 0)
					if v197 then
						v190 = v197
						v195 = true
					else
						v195 = false
					end
				else
					v195 = false
				end
			elseif v189 then
				local v198 = CFrame.Angles(1.5707963267948966, 0, 0)
				if v198 then
					v190 = v198
					v195 = true
				else
					v195 = false
				end
			else
				v195 = false
			end
			if not v195 then
				v190 = CFrame.new()
			end
		end
		v181 = v190
		local v199 = v176:Clone()
		v177 = v199
		if v199.Name == "RifleBullet" then
			v199:PivotTo(CFrame.new(p59.Position, p59.Position + p59.Direction) * CFrame.new(0, 0, -2) * v190)
		elseif v199.Name:find("Pumpkin") then
			local Angles = CFrame.Angles
			local v200 = math.random(0, 359)
			local v201 = math.rad(v200)
			local v202 = math.random(0, 359)
			local v203 = math.rad(v202)
			local v204 = math.random(0, 359)
			v185 = Angles(v201, v203, (math.rad(v204)))
			local Angles2 = CFrame.Angles
			local v205 = math.random(30, 40) / 10
			local v206 = math.rad(v205) * (math.random(1, 2) * 2 - 3)
			local v207 = math.random(30, 40) / 10
			local v208 = math.rad(v207) * (math.random(1, 2) * 2 - 3)
			local v209 = math.random(30, 40) / 10
			v186 = Angles2(v206, v208, math.rad(v209) * (math.random(1, 2) * 2 - 3))
		end
		v199.Parent = VFX2
		v178 = v199.PrimaryPart:FindFirstChildOfClass("Trail")
		v179 = v199.PrimaryPart:FindFirstChild("TracerBoard")
		if v187 then
			v199.PrimaryPart.RocketFly:Play()
		end
		if t7[v199.Name] then
			v180 = true
		end
	end
	local v210 = false
	local v211 = false
	local Magnitude
	if n1 >= 10000 then
		n1 = 1
	else
		n1 += 1
	end
	local v212 = n1
	local SaveVariables = p59.SaveVariables
	if SaveVariables then
		SaveVariables[9] = v166
	end

	local function v213(p60) -- line: 731
		-- upvalues: v149 (ref), v151 (ref), v153 (ref), v155 (ref), v156 (ref), v158 (ref), v160 (ref), v162 (ref), v164 (ref), v177 (ref), v178 (ref), v179 (ref), v180 (ref), v181 (ref), v182 (ref), v183 (ref), v184 (ref), v185 (ref), v186 (ref), v210 (ref), v211 (ref), Magnitude (ref), p59 (copy), v144 (copy), v145 (copy), v147 (copy), v212 (copy), SaveVariables (copy), Debris (copy), v1 (copy), t8 (copy), v135 (copy)
		local v214 = p59.Instant or p60
		local v215, v216
		while true do
			if not v210 then
				local v217 = v162
				local v218
				if v135 <= v217 then
					v218 = false
				else
					local v219 = v153
					local v220
					if type(v219) == "number" and v219 == v219 then
						if v219 == (1/0) then
							v220 = false
						else
							v220 = v219 ~= (-1/0)
						end
					else
						v220 = false
					end
					v218 = not not v220
				end
				if v218 then
					local v221 = v214 / 0.016666666666666666
					v162 += 1
					if SaveVariables then
						SaveVariables[8] = v162
					end
					local v222 = if v162 == 1 then p59.PositionFirst ~= nil else false
					local Magnitude2
					if v222 then
						Magnitude = (p59.Position - p59.PositionFirst).Magnitude
						Magnitude2 = Magnitude
					end
					local v223 = if not v222 or not Magnitude2 then v156 * v214 else Magnitude2
					local v224 = v153 + v223
					local v225 = v160
					local v226 = math.min(v224, v225) - v153
					local DirectionFirst = if v222 then p59.DirectionFirst else nil
					local v227 = if not v222 or not DirectionFirst then v149.Unit else DirectionFirst
					local PositionFirst = if v222 then p59.PositionFirst else nil
					local v228 = if not v222 or not PositionFirst then v151 else PositionFirst
					local v229 = if v222 then v227 * v226 else v227 * v226 + v164 * v214
					local v230
					if typeof(v227) == "Vector3" then
						local X = v227.X
						local v231
						if type(X) == "number" and X == X then
							if X == (1/0) then
								v231 = false
							else
								v231 = X ~= (-1/0)
							end
						else
							v231 = false
						end
						if v231 then
							local Y = v227.Y
							local v232
							if type(Y) == "number" and Y == Y then
								if Y == (1/0) then
									v232 = false
								else
									v232 = Y ~= (-1/0)
								end
							else
								v232 = false
							end
							if v232 then
								local Z = v227.Z
								if type(Z) == "number" and Z == Z then
									if Z == (1/0) then
										v230 = false
									else
										v230 = Z ~= (-1/0)
									end
								else
									v230 = false
								end
							else
								v230 = v232
							end
						else
							v230 = v231
						end
					else
						v230 = false
					end
					local v233 = false
					local v234 = false
					local v235 = false
					local v236 = false
					local v237 = false
					local v238 = false
					if v230 then
						v233 = true
					else
						v238 = false
					end
					local v239
					if v233 then
						if typeof(v228) == "Vector3" then
							v234 = true
						else
							v239 = false
							v235 = true
						end
					end
					v233 = false
					local X, v240
					if v234 then
						X = v228.X
						if type(X) == "number" then
							v233 = true
						else
							v240 = false
							v236 = true
						end
					end
					v234 = false
					if v233 then
						if X == X then
							v234 = true
						else
							v240 = false
							v236 = true
						end
					end
					v233 = false
					if v234 then
						if X == (1/0) then
							v240 = false
							v236 = true
						else
							v233 = true
						end
					end
					v234 = false
					if v233 then
						if X == (-1/0) then
							v237 = true
						else
							v234 = true
						end
					end
					v233 = false
					if v234 then
						v240 = true
						v236 = true
					end
					v234 = false
					if v237 then
						v240 = false
						v236 = true
					end
					v237 = false
					if v236 then
						if v240 then
							v237 = true
						else
							v239 = v240
							v235 = true
						end
					end
					v236 = false
					local Y, v241
					if v237 then
						Y = v228.Y
						if type(Y) == "number" then
							v236 = true
						else
							v241 = false
							v234 = true
						end
					end
					v237 = false
					if v236 then
						if Y == Y then
							v237 = true
						else
							v241 = false
							v234 = true
						end
					end
					v236 = false
					if v237 then
						if Y == (1/0) then
							v241 = false
							v234 = true
						else
							v236 = true
						end
					end
					v237 = false
					if v236 then
						if Y == (-1/0) then
							v233 = true
						else
							v237 = true
						end
					end
					v236 = false
					if v237 then
						v241 = true
						v234 = true
					end
					v237 = false
					if v233 then
						v241 = false
						v234 = true
					end
					v233 = false
					if v234 then
						if v241 then
							v233 = true
						else
							v239 = v241
							v235 = true
						end
					end
					v234 = false
					local Z
					if v233 then
						Z = v228.Z
						if type(Z) == "number" then
							v234 = true
						else
							v239 = false
							v235 = true
						end
					end
					v233 = false
					if v234 then
						if Z == Z then
							v233 = true
						else
							v239 = false
							v235 = true
						end
					end
					v234 = false
					if v233 then
						if Z == (1/0) then
							v239 = false
							v235 = true
						else
							v234 = true
						end
					end
					v233 = false
					if v234 then
						if Z == (-1/0) then
							v237 = true
						else
							v233 = true
						end
					end
					v234 = false
					if v233 then
						v239 = true
						v235 = true
					end
					v233 = false
					if v237 then
						v239 = false
						v235 = true
					end
					v237 = false
					if v235 then
						if v239 then
							v237 = true
						else
							v238 = false
						end
					end
					v235 = false
					local v242
					if v237 then
						if type(v226) == "number" then
							v235 = true
						else
							v242 = false
							v233 = true
						end
					end
					v237 = false
					if v235 then
						if v226 == v226 then
							v237 = true
						else
							v242 = false
							v233 = true
						end
					end
					v235 = false
					if v237 then
						if v226 == (1/0) then
							v242 = false
							v233 = true
						else
							v235 = true
						end
					end
					v237 = false
					if v235 then
						if v226 == (-1/0) then
							v234 = true
						else
							v237 = true
						end
					end
					v235 = false
					if v237 then
						v242 = true
						v233 = true
					end
					v237 = false
					if v234 then
						v242 = false
						v233 = true
					end
					v234 = false
					if v233 then
						if v242 then
							v234 = true
						else
							v238 = false
						end
					end
					v233 = false
					local v243
					if v234 then
						if typeof(v229) == "Vector3" then
							v233 = true
						else
							v243 = false
							v237 = true
						end
					end
					v234 = false
					local X2, v244
					if v233 then
						X2 = v229.X
						if type(X2) == "number" then
							v234 = true
						else
							v244 = false
							v235 = true
						end
					end
					v233 = false
					if v234 then
						if X2 == X2 then
							v233 = true
						else
							v244 = false
							v235 = true
						end
					end
					v234 = false
					if v233 then
						if X2 == (1/0) then
							v244 = false
							v235 = true
						else
							v234 = true
						end
					end
					v233 = false
					if v234 then
						if X2 == (-1/0) then
							v236 = true
						else
							v233 = true
						end
					end
					v234 = false
					if v233 then
						v244 = true
						v235 = true
					end
					v233 = false
					if v236 then
						v244 = false
						v235 = true
					end
					v236 = false
					if v235 then
						if v244 then
							v236 = true
						else
							v243 = v244
							v237 = true
						end
					end
					v235 = false
					local Y2, v245
					if v236 then
						Y2 = v229.Y
						if type(Y2) == "number" then
							v235 = true
						else
							v245 = false
							v233 = true
						end
					end
					v236 = false
					if v235 then
						if Y2 == Y2 then
							v236 = true
						else
							v245 = false
							v233 = true
						end
					end
					v235 = false
					if v236 then
						if Y2 == (1/0) then
							v245 = false
							v233 = true
						else
							v235 = true
						end
					end
					v236 = false
					if v235 then
						if Y2 == (-1/0) then
							v234 = true
						else
							v236 = true
						end
					end
					if v236 then
						v245 = true
						v233 = true
					end
					v236 = false
					if v234 then
						v245 = false
						v233 = true
					end
					v234 = false
					if v233 then
						if v245 then
							v234 = true
						else
							v243 = v245
							v237 = true
						end
					end
					v233 = false
					local Z2
					if v234 then
						Z2 = v229.Z
						if type(Z2) == "number" then
							v233 = true
						else
							v243 = false
							v237 = true
						end
					end
					v234 = false
					if v233 then
						if Z2 == Z2 then
							v234 = true
						else
							v243 = false
							v237 = true
						end
					end
					v233 = false
					if v234 then
						if Z2 == (1/0) then
							v243 = false
							v237 = true
						else
							v233 = true
						end
					end
					v234 = false
					if v233 then
						if Z2 == (-1/0) then
							v236 = true
						else
							v234 = true
						end
					end
					if v234 then
						v243 = true
						v237 = true
					end
					if v236 then
						v243 = false
						v237 = true
					end
					if v237 then
						v238 = not not v243
					end
					if v238 then
						local Size = p59.Size
						local v246 = if Size
							then {
								Type = "Sphere",
								Position = v228,
								Size = p59.Size
							}
							else nil
						local v247 = if not Size or not v246 then v228 else v246
						local v248, v249, v250, v251, v252 = v1:Raycast(v247, v229, p59.FilterType, p59.Filters, p59.VisualizeRay, v144, v155)
						local Magnitude = (v249 - v228).Magnitude
						local Magnitude2 = v229.Magnitude
						local v253
						if Magnitude2 > 0.000001 then
							local v254 = Magnitude / Magnitude2
							v253 = v226 * math.min(v254, 1)
						else
							v253 = Magnitude
						end
						local v255, v256, v257, v258
						if v177 then
							if v222 then
								v257 = v216
								v258 = true
							else
								v255 = CFrame.new(v249, v228) * CFrame.new(0, 0, Magnitude / -1.2) * v181
								v256 = v185 or CFrame.new()
								v258 = false
							end
						else
							v257 = v216
							v258 = true
						end
						if not v258 then
							local v259 = v255 * v256
							v215 = v259
							v257 = v259
						end
						if v185 then
							local v260 = v185 * v186
							v185 = v185:Lerp(v260, v221)
						end
						if v178 then
							v178.Enabled = not v222
						end
						local v261 = v153 + v253
						local v262 = v160
						v153 = math.min(v261, v262)
						if SaveVariables then
							SaveVariables[3] = v153
						end
						if v179 then
							local Circle = v179.Circle
							local v263 = (v153 - p59.MaxRange * 0.6) / (p59.MaxRange * 0.4)
							Circle.ImageTransparency = math.clamp(v263, 0, 1)
						end
						if v252 then
							Debris:AddItem(v252, 5)
						end
						if v147 and type(v147) == "function" and v147(v228, v249, v212) then
							v210 = true
						end
						if v248 then
							local v264
							if v251 == Enum.Material.Water then
								if v155 then
									v264 = true
								else
									v155 = true
									v153 = 0
									v164 = Vector3.new(0, 0, 0)
									if SaveVariables then
										SaveVariables[9] = v164
									end
									v264 = false
								end
							else
								v264 = true
							end
							if v264 then
								v211 = true
								v210 = true
								if v145 then
									local v265 = v183 or v184
									v145(v248, v249, v250, v251, nil, v265)
								end
							else
								local v266 = v158 + 0.25
								v158 = math.max(v266, 1)
								v156 *= 0.08
								local v267 = p59.MaxRange / 50
								v160 = math.clamp(v267, 10, 25)
								if SaveVariables then
									SaveVariables[3] = v153
									SaveVariables[4] = v155
									SaveVariables[5] = v156
									SaveVariables[6] = v158
									SaveVariables[7] = v160
								end
							end
						elseif v222 then
							if v164 ~= Vector3.new(0, 0, 0) then
								v151 += v164 * v214
								if SaveVariables then
									SaveVariables[2] = v151
								end
							end
						elseif v162 > 1 then
							local v268 = v149
							local v269 = 196.2 * v158
							v149 = v268 - Vector3.new(0, v269, 0) * v214
							v151 = v249
							if SaveVariables then
								SaveVariables[1] = v149
								SaveVariables[2] = v151
							end
						end
						local v270 = v160 - v153
						if math.abs(v270) <= 1 then
							v210 = true
						end
						if v210 and v177 then
							if v182 or v177.Name == "PumpkinCursed" then
								for _, v271 in v177:GetDescendants() do
									if v271:IsA("BasePart") then
										v271.Transparency = 1
									elseif v271:IsA("Sound") then
										v271:Stop()
									elseif v271:IsA("ParticleEmitter") or v271:IsA("Light") or v271:IsA("Beam") or v271:IsA("Trail") or v271:IsA("Fire") or v271:IsA("Smoke") or v271:IsA("Sparkles") then
										v271.Enabled = false
									end
								end
								Debris:AddItem(v177, 3)
							elseif v177.Name == "PumpkinRegular" then
								task.defer(t8.CreateBenchGibs, t8, "Pumpkin", v215)
							else
								v177:Destroy()
							end
							v215 = nil
							v216 = nil
						else
							v216 = v257
						end
						if p59.Instant then
							continue
						end
					else
						v210 = true
						v215 = nil
						if v177 then
							v177:Destroy()
							v177 = nil
						end
					end
				else
					v210 = true
					v215 = nil
					if v177 then
						v177:Destroy()
						v177 = nil
					end
				end
			end
			break
		end
		if v215 then
			if v180 then
				v177:PivotTo(v215)
				return v210
			end
			return v210, v177.PrimaryPart, v215
		end
		return v210
	end

	local function v272() -- line: 915
		-- upvalues: v211 (ref), v146 (copy), v212 (copy), t4 (copy)
		t4[v212] = nil
		if not v211 and v146 then
			v146()
		end
	end

	if p59.Instant then
		v213()
		t4[v212] = nil
		if not v211 and v146 then
			v146()
		end
	else
		local t16 = {
			StepFunction = v213,
			FinishFunction = v272,
			Parameters = p59
		}
		table.insert(t5, t16)
		if not (v11 and v11.Connected) then
			v11 = RunService.Heartbeat:Connect(function(p61) -- line: 932
				-- upvalues: v11 (ref), t5 (copy)
				local t17 = {}
				local t18 = {}
				local t19 = {}
				local v273 = #t5
				for i = v273, 1, -1 do
					local v274 = t5[i]
					t17[1] = false
					local v275 = (function(p62)
						return function() -- line: 938
							-- upvalues: p62 (copy), p61 (copy), t18 (copy), t19 (copy), v274 (copy)
							if v274.Parameters.Terminate then
								p62[1] = true
							else
								local v276, v277, v278 = v274.StepFunction(p61)
								if v277 then
									table.insert(t18, v277)
									table.insert(t19, v278)
								end
								if v276 then
									v274.FinishFunction()
									p62[1] = true
								end
							end
						end
					end)(t17)
					local v279, v280 = pcall(v275)
					local v281
					if v279 then
						v281 = not t17[1]
					else
						warn(v280, " - BULLET CALCULATION ERROR")
						v281 = false
					end
					if not v281 then
						table.remove(t5, i)
					end
					t17 = {}
				end
				if #t18 > 0 then
					workspace:BulkMoveTo(t18, t19, Enum.BulkMoveMode.FireCFrameChanged)
				end
				if not (#t5 > 0) then
					v11:Disconnect()
					v11 = nil
				end
			end)
		end
	end
end

function t8.CheckCameraDistance(_, p64, p65, p66) -- line: 971
	-- upvalues: Players (copy), v6 (copy), CurrentCamera (copy)
	if Players.LocalPlayer then
		if CurrentCamera then
			local Position = CurrentCamera.CFrame.Position
			if p66 then
				local Magnitude = (Position - p64).Magnitude
				return p65 < Magnitude, Magnitude
			end
			local v282, v283 = v6:IsWithin(Position, p64, p65)
			return not v282, v283
		end
		return true
	end
end

return t8
