-- [PATH] ReplicatedStorage / CharacterScripts / CameraController @Type LocalScript


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Values = ReplicatedStorage:WaitForChild("Values")
require(Modules:WaitForChild("NumberUtil"))
local v1 = require(Modules:WaitForChild("Items"))
local v2 = require(Modules:WaitForChild("NumberUtil"))
local v3 = require(Modules:WaitForChild("SettingsModule"))
local v4 = require(Modules:WaitForChild("GamepadIconModule"))
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Parent = script.Parent
local Humanoid = Parent:WaitForChild("Humanoid")
local CurrentCamera = workspace.CurrentCamera
local ViewmodelController = Parent:WaitForChild("ViewmodelController")
local InventoryController = Parent:WaitForChild("InventoryController")
local TeamNavigationController = Parent:WaitForChild("TeamNavigationController")
local PreferredInputController = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PreferredInputController")
local CollectionService = game:GetService("CollectionService")
local v5 = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("CameraInput"))
local v6

local function v7(p1) -- line: 48
	-- upvalues: CollectionService (copy)
	for _, v8 in CollectionService:GetTagged("CameraPanIgnore") do
		if v8:IsA("GuiObject") then
			local v9 = v8
			local v10
			while true do
				if v9 and v9:IsA("GuiObject") then
					if v9.Visible then
						v9 = v9.Parent
						continue
					end
					v10 = false
				else
					v10 = true
				end
				break
			end
			if v10 then
				if v9 and v9:IsA("ScreenGui") then
					if v9.Enabled then
						local AbsolutePosition = v8.AbsolutePosition
						local AbsoluteSize = v8.AbsoluteSize
						local X = p1.X
						if AbsolutePosition.X <= X and p1.X <= AbsolutePosition.X + AbsoluteSize.X then
							local Y = p1.Y
							if AbsolutePosition.Y <= Y and p1.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
								return true
							end
						end
					end
				else
					local AbsolutePosition = v8.AbsolutePosition
					local AbsoluteSize = v8.AbsoluteSize
					local X = p1.X
					if AbsolutePosition.X <= X and p1.X <= AbsolutePosition.X + AbsoluteSize.X then
						local Y = p1.Y
						if AbsolutePosition.Y <= Y and p1.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

local Main = PlayerGui:WaitForChild("Main")
local CustomChat = PlayerGui:WaitForChild("CustomChat")
local Loading = PlayerGui:WaitForChild("Loading")
local v11 = Main:WaitForChild("ServerName ")
local FreeLookLabel = Main:WaitForChild("GamepadControls"):WaitForChild("FreeLookLabel")
local v12 = Vector2.new()
local v13 = Vector2.new()
Vector3.new()
local v14 = false
local n1 = 0
local v15 = Vector2.new()
local n2 = 0
local SeatPart
local v16 = CFrame.identity
local v17
local v18 = false
local v19 = CFrame.identity
local v20
local v21 = CFrame.identity
local n3 = 0

local function _() -- line: 93
	-- upvalues: ViewmodelController (copy), InventoryController (copy)
	local v22 = InventoryController.Fetch:Invoke()
	if v22 then
		local Toolbar = v22.Toolbar
		if Toolbar then
			local v23 = Toolbar[ViewmodelController:GetAttribute("Equipped")]
			if v23 == nil or v23 == 0 then
				v23 = false
			end
			return v23
		end
	end
end

local t1 = {
	["Wooden Boat"] = true,
	["Military Boat"] = true
}

local function _(p2) -- line: 106
	-- upvalues: t1 (copy)
	if not (p2 and p2.Parent) then
		return nil
	end
	if p2.Name == "PassengerSeat1" and p2:FindFirstAncestor("Salvaged Flycopter") then
		return 1.8325957145940461
	end
	if not (p2.Name == "VehicleSeat" and t1[p2.Parent.Name]) then
		return nil
	end
	return 2.2689280275926285
end

local function v24(p3) -- line: 112
	-- upvalues: Humanoid (copy), CurrentCamera (copy), t1 (copy)
	local SeatPart = Humanoid.SeatPart
	local v25
	if not (SeatPart and SeatPart.Parent) then
	elseif not (SeatPart.Name == "PassengerSeat1" and SeatPart:FindFirstAncestor("Salvaged Flycopter")) then
		if not (SeatPart.Name == "VehicleSeat" and t1[SeatPart.Parent.Name]) then
		else
			v25 = 2.2689280275926285
		end
	else
		v25 = 1.8325957145940461
	end
	if v25 then
		local v26 = SeatPart.CFrame:VectorToObjectSpace(p3.LookVector)
		local v27 = v26.X * v26.X + v26.Z * v26.Z
		local v28 = math.sqrt(v27)
		if v28 < 0.001 then
			return p3
		end
		local v29 = -v26.X
		local v30 = -v26.Z
		local v31 = math.atan2(v29, v30)
		if math.abs(v31) <= v25 then
			return p3
		end
		local v32 = -v25
		local v33 = math.clamp(v31, v32, v25)
		local _CFrame = SeatPart.CFrame
		local v34 = -math.sin(v33) * v28
		local Y = v26.Y
		local v35 = -math.cos(v33) * v28
		local Unit = _CFrame:VectorToWorldSpace((Vector3.new(v34, Y, v35))).Unit
		local Position = CurrentCamera.Focus.Position
		local Magnitude = (p3.Position - Position).Magnitude
		local v36 = if not (Magnitude > 0.001 and Magnitude < 2) then p3.Position else Position - Unit * Magnitude
		return CFrame.lookAt(v36, v36 + Unit)
	end
	return p3
end

local function v37() -- line: 136
	-- upvalues: Humanoid (copy), t1 (copy)
	local SeatPart = Humanoid.SeatPart
	if not (SeatPart and SeatPart.Parent) then
		return (Vector3.new(0, 0, 0))
	end
	if SeatPart.Name == "PassengerSeat1" and SeatPart:FindFirstAncestor("Salvaged Flycopter") then
		return SeatPart.CFrame:VectorToWorldSpace((Vector3.new(0, -0.30000001192092896, -0.550000011920929)))
	end
	if not (SeatPart.Name == "VehicleSeat" and t1[SeatPart.Parent.Name]) then
		return (Vector3.new(0, 0, 0))
	end
	return SeatPart.CFrame:VectorToWorldSpace((Vector3.new(0, 1, 0.5)))
end

local function v38() -- line: 163
	-- upvalues: v12 (ref), v13 (ref), v14 (ref), n1 (ref), v15 (ref), SeatPart (ref), v16 (ref), v17 (ref), v18 (ref), v19 (ref), v20 (ref), v21 (ref), n3 (ref), RunService (copy), v1 (copy), v3 (copy), Parent (copy), Humanoid (copy), CurrentCamera (copy), ViewmodelController (copy), InventoryController (copy), v37 (copy)
	local v39, v40
	if script:GetAttribute("FreeLooking") then
		v40 = true
	elseif Parent and Humanoid and Humanoid.Health > 0 then
		if Humanoid:GetAttribute("Downed") then
			v40 = true
		else
			local v41 = InventoryController.Fetch:Invoke()
			if v41 then
				local Toolbar = v41.Toolbar
				if Toolbar then
					v39 = Toolbar[ViewmodelController:GetAttribute("Equipped")]
					if v39 == nil or v39 == 0 then
						v39 = false
					end
				end
			end
			v40 = false
		end
	else
		v40 = true
	end
	if v40 then
		return
	end
	local v42 = v39 and v1[v39.ID]
	if ViewmodelController:GetAttribute("Using") and v42 and v42.Type == "Gun" then
		return
	end
	local PrimaryPart = Parent.PrimaryPart
	if PrimaryPart then
		script:SetAttribute("FreeLooking", true)
		if v14 then
			v12 = v13
		else
			local _CFrame = CurrentCamera.CFrame
			v19 = _CFrame
			script:SetAttribute("ActualCFrame", _CFrame)
			local SeatPart2 = Humanoid.SeatPart
			if SeatPart2 and SeatPart2.Parent then
				SeatPart = SeatPart2
			else
				SeatPart = nil
			end
			if SeatPart then
				v16 = SeatPart.CFrame:ToObjectSpace(_CFrame)
			else
				v16 = CFrame.identity
			end
			v18 = true
			v14 = true
			v17 = nil
			Humanoid.AutoRotate = false
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			local v43 = _CFrame.Position - PrimaryPart.Position
			local v44 = Enum.RenderPriority.Camera.Value + (if SeatPart2 and SeatPart2.Parent and SeatPart2.Name == "VehicleSeat" then 2 else 1)
			RunService:BindToRenderStep("FreeLook", v44, function(p4) -- line: 191
				-- upvalues: v43 (ref), PrimaryPart (copy), v12 (ref), v13 (ref), v14 (ref), n1 (ref), v15 (ref), SeatPart (ref), v16 (ref), v17 (ref), v18 (ref), v19 (ref), v20 (ref), v21 (ref), n3 (ref), RunService (copy), v3 (copy), Humanoid (copy), CurrentCamera (copy), v37 (copy)
				local _ = p4 / 0.016666666666666666
				local v45 = v19
				local FreeLooking = script:GetAttribute("FreeLooking")
				if FreeLooking and (v15.X ~= 0 or v15.Y ~= 0) then
					local v46 = v3.GetSetting("Gamepad", "Mouse Sensitivity") or 0.65
					local v47 = v15 * (200 * v46 * p4)
					local new = Vector2.new
					local v48 = v12.X + v47.X
					local v49 = math.clamp(v48, -140, 140)
					local v50 = v12.Y + v47.Y
					v12 = new(v49, (math.clamp(v50, -50, 50)))
				end
				local v51
				if PrimaryPart and PrimaryPart.Parent then
					local v52
					if FreeLooking then
						v52 = v12
						if not v52 then
							local v53 = v13
							local v54 = Vector2.new()
							local v55 = n1
							v52 = v53:Lerp(v54, (math.clamp(v55, 0, 1)))
						end
					else
						local v56 = v13
						local v57 = Vector2.new()
						local v58 = n1
						v52 = v56:Lerp(v57, (math.clamp(v58, 0, 1)))
					end
					v13 = v52
					if FreeLooking then
						n1 = 0
					else
						v12 = Vector2.new()
						n1 += p4 * 10
					end
					local v59
					if v18 then
						v18 = false
						local CFrame = CurrentCamera.CFrame
						local Magnitude = (CFrame.Position - CurrentCamera.Focus.Position).Magnitude
						if v37() == Vector3.new(0, 0, 0) or not (Magnitude < 2) then
							Magnitude = 0
						end
						n3 = Magnitude
						v19 = CFrame
						script:SetAttribute("ActualCFrame", CFrame)
						v43 = CFrame.Position - PrimaryPart.Position
						if SeatPart and SeatPart.Parent then
							local CFrame2 = SeatPart.CFrame
							local v60 = if SeatPart.Name == "VehicleSeat" then SeatPart:FindFirstAncestor("Salvaged Flycopter") ~= nil else false
							if v20 == SeatPart and not v60 then
								CFrame2 = v21
							end
							v16 = CFrame2:ToObjectSpace(CFrame)
						end
						v59 = CFrame
					else
						v59 = v45
					end
					local SeatPart2 = Humanoid.SeatPart
					if SeatPart2 and not SeatPart2.Parent then
						SeatPart2 = nil
					end
					local v61, v62, v63
					if SeatPart2 == SeatPart then
						v62 = v59
						v63 = true
					elseif v17 then
						if SeatPart2 then
							v16 = SeatPart2.CFrame:ToObjectSpace(v17)
							v61 = v59
						else
							v43 = v17.Position - PrimaryPart.Position
							v61 = v17
							v19 = v17
							script:SetAttribute("ActualCFrame", v17)
						end
						v63 = false
					else
						v62 = v59
						v63 = true
					end
					if not v63 then
						SeatPart = SeatPart2
						v62 = v61
					end
					local v64
					if SeatPart then
						v64 = SeatPart.CFrame * v16
					else
						local v65, v66, v67 = v62:ToEulerAnglesXYZ()
						local v68 = CFrame.Angles(v65, v66, v67)
						v64 = CFrame.new(PrimaryPart.Position + v43) * v68
					end
					v17 = v64
					script:SetAttribute("ViewmodelCFrame", v64)
					local Angles = CFrame.Angles
					local X = v13.X
					local v69 = Angles(0, -math.rad(X), 0)
					local Angles2 = CFrame.Angles
					local Y = v13.Y
					local v70 = v69 * Angles2(-math.rad(Y), 0, 0)
					local v71 = if n3 > 0 then v64 * CFrame.new(0, 0, -n3) * v70 * CFrame.new(0, 0, n3) else v64 * v70
					CurrentCamera.CFrame = v71
					v51 = FreeLooking or n1 < 1
				else
					v51 = false
				end
				if v51 then
					return
				end
				v14 = false
				CurrentCamera.CameraType = Enum.CameraType.Custom
				script:SetAttribute("ViewmodelCFrame", nil)
				SeatPart = nil
				v17 = nil
				v18 = false
				n3 = 0
				RunService:UnbindFromRenderStep("FreeLook")
				if Humanoid then
					if not Humanoid.Parent then
						return
					end
					Humanoid.AutoRotate = true
				end
			end)
		end
	end
end

local function v72() -- line: 274
	script:SetAttribute("FreeLooking", false)
end

local function _() -- line: 280
	-- upvalues: v38 (copy)
	if script:GetAttribute("FreeLooking") then
		script:SetAttribute("FreeLooking", false)
	else
		v38()
	end
end

UserInputService.InputBegan:Connect(function(p5, p6) -- line: 289
	-- upvalues: n2 (ref), UserInputService (copy), v3 (copy), TeamNavigationController (copy), Main (copy), CustomChat (copy), v11 (copy), v38 (copy)
	if not v3.MainMenuOpen() and not (UserInputService:GetFocusedTextBox() or p6) then
		local UserInputType = p5.UserInputType
		if UserInputType == Enum.UserInputType.Keyboard then
			local Name = p5.KeyCode.Name
			if Name == v3.GetSetting("Controls", "Free Look") then
				v38()
			elseif Name == v3.GetSetting("Controls", "Hide UI") then
				local v73 = not script:GetAttribute("UI")
				script:SetAttribute("UI", v73)
				Main.Toolbar.Visible = v73
				Main.Stats.Visible = v73
				Main.Compass.Visible = v73
				Main.Invalids.Visible = v73
				Main.ClientInfo.Visible = v73
				Main.Team.Visible = v73
				v11.Visible = v73
				Main.CombatServer.Position = UDim2.new(0, 0, if v73 then 0 else -1, 0)
				Main.BuildServer.Position = UDim2.new(0, 0, if v73 then 0 else -1, 0)
				CustomChat.Enabled = v73
			end
		elseif UserInputType == Enum.UserInputType.Gamepad1 and p5.KeyCode.Name == v3.GetSetting("Gamepad", "Free Look") and not TeamNavigationController:GetAttribute("MapOpen") then
			n2 = os.clock()
		end
	end
end)
UserInputService.InputChanged:Connect(function(p7) -- line: 318
	-- upvalues: v6 (ref), v12 (ref), v15 (ref), v3 (copy), PreferredInputController (copy)
	local UserInputType = p7.UserInputType
	if UserInputType == Enum.UserInputType.Gamepad1 and p7.KeyCode == Enum.KeyCode.Thumbstick2 then
		local v74 = PreferredInputController:GetAttribute("JoystickDeadzone") or 0.225
		local Position = p7.Position
		local X
		if Position.X < v74 then
			local X2 = Position.X
			if -v74 < X2 then
				X = 0
			else
				X = Position.X
			end
		else
			X = Position.X
		end
		local v75 = Position.Y < v74
		local v76
		if v75 then
			local Y = Position.Y
			v76 = -v74 < Y
		end
		local v77 = if not v75 or not v76 then Position.Y else 0
		v15 = Vector2.new(X, -v77)
	elseif script:GetAttribute("FreeLooking") then
		if UserInputType == Enum.UserInputType.Touch then
			if p7 == v6 then
				local v78 = v3.GetSetting("Mobile", "Mobile Sensitivity") or 1
				local v79 = p7.Delta * (0.35 * v78)
				local new = Vector2.new
				local v80 = v12.X + v79.X
				local v81 = math.clamp(v80, -140, 140)
				local v82 = v12.Y + v79.Y
				v12 = new(v81, (math.clamp(v82, -50, 50)))
			end
		elseif UserInputType == Enum.UserInputType.MouseMovement then
			local v83 = p7.Delta / 2
			local new = Vector2.new
			local v84 = v12.X + v83.X
			local v85 = math.clamp(v84, -140, 140)
			local v86 = v12.Y + v83.Y
			v12 = new(v85, (math.clamp(v86, -50, 50)))
		end
	end
end)
UserInputService.InputEnded:Connect(function(p8, p9) -- line: 343
	-- upvalues: n2 (ref), UserInputService (copy), v3 (copy), v38 (copy)
	if not (UserInputService:GetFocusedTextBox() or p9) then
		local UserInputType = p8.UserInputType
		if UserInputType == Enum.UserInputType.Keyboard then
			if p8.KeyCode.Name == v3.GetSetting("Controls", "Free Look") then
				script:SetAttribute("FreeLooking", false)
			end
		elseif UserInputType == Enum.UserInputType.Gamepad1 and p8.KeyCode.Name == v3.GetSetting("Gamepad", "Free Look") and n2 > 0 then
			local v87 = os.clock() - n2
			n2 = 0
			if v87 < 0.25 then
				if script:GetAttribute("FreeLooking") then
					script:SetAttribute("FreeLooking", false)
				else
					v38()
				end
			end
		end
	end
end)
script:WaitForChild("MobileFreeLook").Event:Connect(function(p10) -- line: 367
	-- upvalues: v6 (ref), v3 (copy), v5 (copy), v7 (copy), v38 (copy)
	if p10 and not v3.MainMenuOpen() then
		if not script:GetAttribute("FreeLooking") then
			local v88 = v5.getPanTouch and v5.getPanTouch()
			local v89, v90
			if v88 then
				if v88.UserInputState == Enum.UserInputState.End or v7(v88.Position) then
					v90 = false
				else
					v89 = v88
					v90 = true
				end
			else
				v90 = false
			end
			if not v90 then
				v89 = nil
			end
			v6 = v89
		end
		if script:GetAttribute("FreeLooking") then
			script:SetAttribute("FreeLooking", false)
		else
			v38()
		end
	end
end)
UserInputService.TouchStarted:Connect(function(p11, p12) -- line: 381
	-- upvalues: v6 (ref), v7 (copy)
	if not p12 and script:GetAttribute("FreeLooking") and (not v6 or v6.UserInputState == Enum.UserInputState.End) and not v7(p11.Position) then
		v6 = p11
	end
end)
UserInputService.TouchEnded:Connect(function(p13) -- line: 387
	-- upvalues: v6 (ref)
	if p13 == v6 then
		v6 = nil
	end
end)
Humanoid.Died:Connect(v72)
Humanoid:GetAttributeChangedSignal("Downed"):Connect(function() -- line: 392
	-- upvalues: Humanoid (copy)
	if Humanoid:GetAttribute("Downed") then
		script:SetAttribute("FreeLooking", false)
	end
end)
v4.RegisterSetting(FreeLookLabel.ImageLabel, "Gamepad", "Free Look")
script:GetAttributeChangedSignal("FreeLooking"):Connect(function() -- line: 399
	-- upvalues: PreferredInputController (copy), FreeLookLabel (copy)
	local v91 = if script:GetAttribute("FreeLooking") == true then PreferredInputController:GetAttribute("PreferredInput") == "Gamepad" else false
	FreeLookLabel.Visible = v91
end)
InventoryController:GetAttributeChangedSignal("Open"):Connect(function() -- line: 403
	-- upvalues: InventoryController (copy)
	if InventoryController:GetAttribute("Open") then
		script:SetAttribute("FreeLooking", false)
	end
end)
TeamNavigationController:GetAttributeChangedSignal("MapOpen"):Connect(function() -- line: 407
	-- upvalues: TeamNavigationController (copy)
	if TeamNavigationController:GetAttribute("MapOpen") then
		script:SetAttribute("FreeLooking", false)
	end
end)
v14 = false
CurrentCamera.CameraType = Enum.CameraType.Custom
script:SetAttribute("ViewmodelCFrame", nil)
SeatPart = nil
v17 = nil
v18 = false
n3 = 0
RunService:UnbindFromRenderStep("FreeLook")

if Humanoid and Humanoid.Parent then
	Humanoid.AutoRotate = true
end
local v92
local t2 = {
	tilt = nil,
	MAX = 0.17453292519943295
}

local function v93() -- line: 422
	-- upvalues: v14 (ref), v92 (ref), RunService (copy), Parent (copy), Humanoid (copy), CurrentCamera (copy), t1 (copy), v24 (copy), v37 (copy), t2 (copy)
	local SeatPart = Parent.Parent and Humanoid.SeatPart or nil
	local v94 = if SeatPart == nil or SeatPart.Parent == nil then false else t1[SeatPart.Parent.Name] == true
	local v95
	if not (SeatPart and SeatPart.Parent) then
	elseif not (SeatPart.Name == "PassengerSeat1" and SeatPart:FindFirstAncestor("Salvaged Flycopter")) then
		if not (SeatPart.Name == "VehicleSeat" and t1[SeatPart.Parent.Name]) then
		else
			v95 = 2.2689280275926285
		end
	else
		v95 = 1.8325957145940461
	end
	local v96 = if v95 == nil then v94 else true
	local v97 = if v96 then SeatPart else nil
	if v97 ~= v92 then
		v92 = v97
		RunService:UnbindFromRenderStep("PassengerLook")
		RunService:UnbindFromRenderStep("BoatSwayLevel")
		t2.tilt = nil
		if v96 then
			local v98 = true
			local v99 = SeatPart.Name == "VehicleSeat"
			local LookVector = SeatPart.CFrame.LookVector
			local v100 = -LookVector.X
			local v101 = -LookVector.Z
			local v102 = math.atan2(v100, v101)
			local BoatMain, BoatMain2
			if v94 then
				local BoatMain3 = SeatPart.Parent:FindFirstChild("BoatMain")
				BoatMain = BoatMain3
				BoatMain2 = BoatMain3
			end
			if BoatMain2 and not BoatMain2:IsA("BasePart") then
				BoatMain = nil
				BoatMain2 = nil
			end
			if BoatMain2 then
				RunService:BindToRenderStep("BoatSwayLevel", Enum.RenderPriority.Camera.Value - 2, function() -- line: 447
					-- upvalues: CurrentCamera (copy), t2 (copy)
					local tilt = t2.tilt
					if tilt then
						t2.tilt = nil
						local _CFrame = CurrentCamera.CFrame
						CurrentCamera.CFrame = CFrame.new(_CFrame.Position) * tilt:Inverse() * _CFrame.Rotation
					end
				end)
			end
			local v103 = Enum.RenderPriority.Camera.Value + 1
			local v104 = v94
			RunService:BindToRenderStep("PassengerLook", v103, function() -- line: 458
				-- upvalues: v98 (ref), v102 (ref), BoatMain (ref), SeatPart (copy), v104 (copy), v99 (copy), v14 (ref), Humanoid (copy), CurrentCamera (copy), v24 (copy), v37 (copy), t2 (copy)
				if v99 and CurrentCamera.CameraSubject ~= Humanoid then
					CurrentCamera.CameraSubject = Humanoid
				end
				local v105
				if v104 and SeatPart.Parent then
					local LookVector = SeatPart.CFrame.LookVector
					local v106 = -LookVector.X
					local v107 = -LookVector.Z
					local v108 = math.atan2(v106, v107)
					v105 = (v108 - v102 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
					v102 = v108
				else
					v105 = 0
				end
				if v14 then
					return
				end
				local _CFrame = CurrentCamera.CFrame
				if v105 ~= 0 then
					local Position = CurrentCamera.Focus.Position
					_CFrame = CFrame.new(Position) * CFrame.Angles(0, v105, 0) * CFrame.new(-Position) * _CFrame
				end
				local LookVector, Position, v109, v110
				if v98 then
					v98 = false
					local SeatPart = Humanoid.SeatPart
					if SeatPart then
						LookVector = SeatPart.CFrame.LookVector
						local Position2 = CurrentCamera.Focus.Position
						local Magnitude = (_CFrame.Position - Position2).Magnitude
						if Magnitude > 0.001 and Magnitude < 2 then
							Position = Position2 - LookVector * Magnitude
						else
							Position = _CFrame.Position
						end
						v110 = false
					else
						v109 = _CFrame
						v110 = true
					end
				else
					v109 = _CFrame
					v110 = true
				end
				if not v110 then
					v109 = CFrame.lookAt(Position, Position + LookVector)
				end
				local v111 = v37()
				local v112 = v24(v109) + v111
				CurrentCamera.Focus += v111
				local UpVector, v113, v114
				if BoatMain and BoatMain.Parent and SeatPart.Parent then
					if SeatPart.Parent:GetAttribute("Using") == false then
						v113 = v112
						v114 = true
					else
						local SwayUp = SeatPart.Parent:GetAttribute("SwayUp")
						if typeof(SwayUp) == "Vector3" and SwayUp.Magnitude > 0.5 then
							UpVector = SwayUp.Unit
						else
							UpVector = BoatMain.CFrame.UpVector
						end
						v114 = false
					end
				else
					v113 = v112
					v114 = true
				end
				if not v114 then
					local v115 = Vector3.new(0, 1, 0):Cross(UpVector)
					local Magnitude = v115.Magnitude
					if Magnitude > 0.00001 then
						local v116 = math.min(Magnitude, 1)
						local v117 = math.asin(v116)
						local MAX = t2.MAX
						local v118 = math.min(v117, MAX)
						local v119 = CFrame.fromAxisAngle(v115 / Magnitude, v118)
						t2.tilt = v119
						v113 = CFrame.new(v112.Position) * v119 * v112.Rotation
					else
						v113 = v112
					end
				end
				CurrentCamera.CFrame = v113
			end)
		end
	end
end

RunService:UnbindFromRenderStep("PassengerLook")
RunService:UnbindFromRenderStep("BoatSwayLevel")
Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(v93)
Parent.AncestryChanged:Connect(v93)
v93()
RunService:UnbindFromRenderStep("BoatDriverCam")

local function v120() -- line: 526
	-- upvalues: v20 (ref), v21 (ref), RunService (copy), Parent (copy), Humanoid (copy)
	local v121 = Parent.Parent and Humanoid.SeatPart
	RunService:UnbindFromRenderStep("SeatCamTrack")
	v20 = nil
	if v121 then
		local Value = Enum.RenderPriority.Last.Value
		RunService:BindToRenderStep("SeatCamTrack", Value, function() -- line: 531
			-- upvalues: v121 (copy), v20 (ref), v21 (ref)
			v20 = v121
			v21 = v121.CFrame
		end)
	end
end

RunService:UnbindFromRenderStep("SeatCamTrack")
Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(v120)
Parent.AncestryChanged:Connect(v120)
v120()
v11.Text = Values.ServerName.Value

local Background = Loading.BG:FindFirstChild("Background")
local v122 = Background and Background:GetAttribute("Choices")

if v122 then
	local v123 = string.split(v122, ",")
	Background.Image = v123[math.random(#v123)]
end
Loading.Enabled = true
while true do
	local PreSpawns = workspace:FindFirstChild("PreSpawns")
	if not PreSpawns then
		task.wait()
		continue
	end
	if Parent.Parent then
		local PrimaryPart = Parent.PrimaryPart
		if PrimaryPart then
			if v2:IsWithin(PreSpawns:GetPivot().Position, PrimaryPart.Position, 50) then
				task.wait()
				continue
			end
			break
		end
		task.wait()
		continue
	end
	break
end

if Loading.Parent then
	Loading.Enabled = false
end
