-- [PATH] ReplicatedStorage / CharacterScripts / VehicleController @Type LocalScript
--[[
	VehicleController
	by ChickenBagelz
	October 3, 2022
	
	Handles all local movement logic of any vehicle the player is seated in
]]

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local UserInput = game:GetService("UserInputService")
local Run = game:GetService("RunService")

-- Folders
local Modules = Replicated:WaitForChild("Modules")
local VFX_PARTS = workspace:WaitForChild("VFX")

-- Modules
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))

-- Player Variables
local Player = Players.LocalPlayer
local Char = script.Parent
local Hum = Char:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- Local Variables
local currentVehicle
local verticalAccel = 0
local verticalPos = 0
local currentYaw = 0
local targetYaw = 0
local currentPitch = 0
local targetPitch = 0
local totalPitch = 0
local currentRoll = 0
local targetRoll = 0
local totalRoll = 0
local targetCF = CFrame.new()
local debugTargetPos
local totalMouseMovement = Vector3.new()
local cappedMouseMovement = Vector3.new()
local lastMouseMove = tick()

-- Functions
local function GetMass(model)
	if not (model and model.Parent) then return 0 end
	local totalMass = 0
	for _, part in pairs(model:GetDescendants()) do
		if (not part:IsA("BasePart")) or part.Massless then continue end
		totalMass += part.Mass
		if not (part:IsA("Seat") or part:IsA("VehicleSeat")) then continue end
		local occupant = part.Occupant
		if not (occupant and occupant.Parent) then continue end
		totalMass += GetMass(occupant.Parent)
	end
	return totalMass
end

-- Events
--[[
UserInput.InputBegan:Connect(function(input)
	local inputType = input.UserInputType
	local textBox = UserInput:GetFocusedTextBox()
	if textBox or not currentVehicle then return end
	if inputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		if key == Enum.KeyCode.W then
			local seat = currentVehicle:FindFirstChild("DriverSeat")
			local bodyForce = seat:FindFirstChild("BodyForce")
			
		end
	end
end)]]

UserInput.InputChanged:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	local textBox = UserInput:GetFocusedTextBox()
	if textBox or notProcessed or not currentVehicle then return end
	if inputType == Enum.UserInputType.MouseMovement then
		local delta = input.Delta
		lastMouseMove = tick()
		totalMouseMovement += delta
	end
end)

Hum.Seated:Connect(function(active, seatPart)
	pcall(function()
		Camera.CameraType = Enum.CameraType.Custom
		Run:UnbindFromRenderStep("VehicleControl")
		Run:UnbindFromRenderStep("VehicleCamera")
	end)
	if not active then
		currentVehicle = nil
		return
	end
	if not seatPart then return end
	local vehicle = seatPart.Parent
	if not (vehicle and vehicle:IsA("Model") and vehicle.Name == "Minicopter") then return end
	totalMouseMovement = Vector3.new()
	currentVehicle = vehicle
	Camera.CameraType = Enum.CameraType.Scriptable
	Run:BindToRenderStep("VehicleCamera", Enum.RenderPriority.Camera.Value - 1, function(step)
		if not (currentVehicle and currentVehicle.Parent and seatPart and seatPart:IsDescendantOf(currentVehicle)) then return end
		Camera.CFrame = seatPart.CFrame * CFrame.new(0, 3, -1.6)--CFrame.new(0, 8, 10)
	end)
	if seatPart.Name ~= "DriverSeat" then return end
	Run:BindToRenderStep("VehicleControl", Enum.RenderPriority.Input.Value + 1, function(step)
		if not (currentVehicle and currentVehicle.Parent) then 
			currentVehicle = nil 
			return 
		end
		local deltaTime = step / (1 / 60)
		local seat = currentVehicle:FindFirstChild("DriverSeat")
		if not seat then return end
		local spin = seat:FindFirstChild("Spin")
		local lift = seat:FindFirstChild("Lift")
		local drag = seat:FindFirstChild("Drag")
		local antigrav = seat:FindFirstChild("Antigravity")
		local holdingUp = UserInput:IsKeyDown(Enum.KeyCode.W)
		local holdingDown = UserInput:IsKeyDown(Enum.KeyCode.S)
		local holdingRight = UserInput:IsKeyDown(Enum.KeyCode.D)
		local holdingLeft = UserInput:IsKeyDown(Enum.KeyCode.A)
		local altitudeInput = ((holdingUp and not holdingDown) and 1 or ((holdingDown and not holdingUp) and -1 or 0))
		local yawInput = ((holdingRight and not holdingLeft) and 1 or ((holdingLeft and not holdingRight) and -1 or 0))
		if tick() - lastMouseMove > 0.5 then
			totalMouseMovement = totalMouseMovement:Lerp(Vector3.new(), 0.05 * deltaTime)
		end
		cappedMouseMovement = Vector3.new(math.clamp(totalMouseMovement.X / 400, -1, 1), math.clamp(totalMouseMovement.Y / 400, -1, 1), 0)
		local pitchInput = cappedMouseMovement.Y
		local rollInput = cappedMouseMovement.X
		if altitudeInput > 0 then
			verticalAccel = math.min(verticalAccel + 0.005 * deltaTime, 0.1)
		elseif altitudeInput < 0 then
			verticalAccel = math.max(verticalAccel - 0.005 * deltaTime, -0.1)
		else
			verticalAccel = NumberUtil:Lerp(verticalAccel, 0, 0.1 * deltaTime)
		end
		--[[
		if (seat.Position.Y >= 1200 and verticalAccel > 0) or (altitudeInput == 0 and math.abs(verticalAccel) <= 0.01) then
			verticalPos = NumberUtil:Lerp(verticalPos, 0, 0.02 * deltaTime)
		elseif altitudeInput ~= 0 then
			verticalPos = math.clamp(verticalPos + verticalAccel * deltaTime, -15, 20)
		end]]
		if altitudeInput ~= 0 then
			verticalPos = math.clamp(verticalPos + verticalAccel, -0.5, 1.1)
		elseif math.abs(verticalAccel) <= 0.1 then
			verticalPos = NumberUtil:Lerp(verticalPos, 0, 0.05 * deltaTime)
		end
		lift.Force = Vector3.new(0, GetMass(currentVehicle) * workspace.Gravity * (1 + verticalPos / 10), 0) * ((seat.Position.Y >= 1200) and -1 or 1)
		local curVelocity = seat.AssemblyLinearVelocity
		seat.AssemblyLinearVelocity = Vector3.new(math.clamp(curVelocity.X * 0.96, -50, 50), curVelocity.Y, math.clamp(curVelocity.Z * 0.96, -50, 40))
		local dragDir = -((seat.Position + seat.AssemblyLinearVelocity) - seat.Position).Unit
		drag.Force = Vector3.new(dragDir.X * 500, dragDir.Y * 500, dragDir.Z * 500)
		local vector = (seat.CFrame.UpVector - Vector3.yAxis).Magnitude
		vector = (vector > 0.75 and math.max((1 - vector) * 3, 0) or math.clamp(vector, 0, 0.75))
		antigrav.Force = Vector3.new(0, ((vector * 40) ^ 2 * 5), 0)
		print(vector)
		--print(seat.AssemblyLinearVelocity)
		if yawInput ~= 0 then
			targetYaw = math.rad(-yawInput * 40 * deltaTime)
		else
			targetYaw = 0
		end
		targetPitch = pitchInput * 100 * deltaTime
		currentPitch = NumberUtil:Lerp(currentPitch, targetPitch, 0.3 * deltaTime)
		local lastPitch = totalPitch
		totalPitch = totalPitch + currentPitch--math.clamp(totalPitch + currentPitch, -1000, 1000)
		local pitchDiff = math.rad(totalPitch - lastPitch)
		targetRoll = rollInput * 100 * deltaTime
		currentRoll = NumberUtil:Lerp(currentRoll, targetRoll, 0.3 * deltaTime)
		local lastRoll = totalRoll
		totalRoll = totalRoll + currentRoll--math.clamp(totalRoll + currentRoll, -1000, 1000)
		local rollDiff = math.rad(totalRoll - lastRoll)
		currentYaw = NumberUtil:Lerp(currentYaw, targetYaw, 0.1 * deltaTime)
		targetCF = seat.CFrame * CFrame.Angles(pitchDiff * 2, 0, rollDiff / 4) * CFrame.new(0, verticalPos, 0)
		--bodyPos.Position = targetCF.Position
		--bodyGyro.CFrame = seat.CFrame * CFrame.Angles(0, currentYaw, 0)
		spin.AngularVelocity = Vector3.new(rollDiff, currentYaw, pitchDiff)
		--print(verticalAccel, verticalPos)
		if not debugTargetPos then
			debugTargetPos = Instance.new("Part")
			debugTargetPos.Size = Vector3.new(1, 1, 1)
			debugTargetPos.CanCollide = false
			debugTargetPos.Anchored = true
			debugTargetPos.BrickColor = BrickColor.new("Really red")
			debugTargetPos.Parent = VFX_PARTS
		end
		if debugTargetPos then
			--debugTargetPos.CFrame = targetCF
		end
	end)
end)