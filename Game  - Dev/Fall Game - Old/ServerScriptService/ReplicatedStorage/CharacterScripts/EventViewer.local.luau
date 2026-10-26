-- [PATH] ReplicatedStorage / CharacterScripts / EventViewer @Type LocalScript
--[[

made sometime late january 2024
neddleduck & chickenbagelz 
handles viewing the events currently on the map and some visual effects for the relevant events, like rotating btr wheels

]]

--Services
local Players = game:GetService("Players")
local Tween = game:GetService("TweenService")
local Replicated = game:GetService("ReplicatedStorage")

--Constants
local PLAYER = Players.LocalPlayer
local GUI = PLAYER:WaitForChild("PlayerGui")
local MAIN = GUI:WaitForChild("Main")
local NOTIFICATION = MAIN:WaitForChild("Notification")
local MAP = MAIN:WaitForChild("Map"):WaitForChild("Frame"):WaitForChild("Map")
local CRATE_TEMPLATE = MAP:WaitForChild("TimedCrateTemplate")
local BTR_TEMPLATE = MAP:WaitForChild("BTRTemplate")
local EVENTS_FOLDER = workspace:WaitForChild("Events")

local MODULES = Replicated:WaitForChild("Modules")
local NUM_UTIL = require(MODULES:WaitForChild("NumberUtil"))

local NOTIFICATION_SND = script:WaitForChild("Notification")

local Bases = workspace:WaitForChild("Bases")
local Loners = Bases:WaitForChild("Loners")
local TimedCrate

local MAP_MAX_BOUNDS = 3750

local EVENTS_INFO = {
	["BTR"] = "rbxassetid://16270992443";
	["BTRfire"] = "rbxassetid://16270991717";
	["Timed Crate"] = "rbxassetid://16018005011";
}

--Variables
local mapEvents = { --this basically stores the image labels on the map
	--[[
		[Bench/Event Model] = imagelabel on the map
	]]
}
local rotatingWheels = false --This variable is true when the client is actively rotating the wheels on the btr model

local function VectorToMap(vec: Vector3|Vector2): UDim2 -- returns a UI position based on the Vector3 passed
	-- origin of 0, 0 should be equal to 0.5, 0.5
	local x = 0.5 + vec.X / (MAP_MAX_BOUNDS * 2)
	local y = 0.5 + (typeof(vec) == "Vector3" and vec.Z or vec.Y) / (MAP_MAX_BOUNDS * 2)
	return UDim2.new(x, 0, y, 0)
end

local function UpdateEventsOnMap(onlyBTR)
	--Delete old ones
	for benchModel, gui in pairs(mapEvents) do
		if onlyBTR then
			if gui.Name ~= "BTR" then continue end 
		end
		gui:Destroy()
		mapEvents[benchModel] = nil
	end
	
	--Show timed crate
	if TimedCrate and TimedCrate.Parent and not onlyBTR then 
		for _, benchModel in pairs(TimedCrate:GetChildren()) do
			local gui = CRATE_TEMPLATE:Clone()
			gui.Position = VectorToMap(benchModel.Main.Position)
			gui.Parent = MAP
			gui.Visible = true
			mapEvents[benchModel] = gui
			gui.MouseEnter:Connect(function()
				gui.TextLabel.Visible = true
			end)
			gui.MouseLeave:Connect(function()
				gui.TextLabel.Visible = false
			end)
		end
	end
	
	--Show btr
	local btrModel = EVENTS_FOLDER:FindFirstChild("BTR")
	if not btrModel then return end
	local gui = BTR_TEMPLATE:Clone()
	gui.BTRImage.Image = btrModel:GetAttribute("Destroyed") and EVENTS_INFO.BTRfire or EVENTS_INFO.BTR
	gui.Position = VectorToMap(btrModel.HumanoidRootPart.Position)
	gui.Name = "BTR"
	gui.Parent = MAP
	gui.Visible = true
	mapEvents[btrModel] = gui
end

local function NotifyEvent(name)
	NOTIFICATION.Bottom.Event.Text = string.upper(name) .. " AVAILABLE"
	NOTIFICATION.Image.Image = EVENTS_INFO[name]
	
	--Play sound
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0)
	local goalsOpen = {
		Position = NOTIFICATION:GetAttribute("PositionOpen")
	}
	local goalsClose = {
		Position = NOTIFICATION:GetAttribute("PositionClosed")
	}
	local t1 = Tween:Create(NOTIFICATION, tweenInfo, goalsOpen)
	local t2 = Tween:Create(NOTIFICATION, tweenInfo, goalsClose)
	t1:Play()
	NOTIFICATION_SND:Play()
	task.wait(8)
	t2:Play()
end

local function SetTimedCrateFolder(folder)
	if not folder or not folder.Parent or folder.Name ~= "Timed Crate" then return end
	TimedCrate = folder
	TimedCrate.ChildAdded:Connect(function(child)
		if child.Name == "Timed Crate" then
			UpdateEventsOnMap()
			NotifyEvent("Timed Crate")
		end
	end)
	TimedCrate.ChildRemoved:Connect(function(child)
		if child.Name == "Timed Crate" then
			UpdateEventsOnMap()
		end
	end)
	
	task.wait()
	UpdateEventsOnMap()
end

local function SetupEventChild(child)
	if child.Name == "BTR" then
		if not child:GetAttribute("Marked") then -- make sure we don't notify twice on respawn
			child:SetAttribute("Marked", true)
			NotifyEvent("BTR")
		end
		local currentTargetPos
		local runningLerp = false
		local lastLerpUpdate = 0
		child:GetAttributeChangedSignal("GunPosition"):Connect(function()
			if not NUM_UTIL:IsWithin(PLAYER.Character.HumanoidRootPart.Position, child.HumanoidRootPart.Position, 1500) then return end
			local aimPos = child:GetAttribute("GunPosition")
			local gunBase = child.Detail:FindFirstChild("GunBase")
			if not gunBase then return end
			if not runningLerp or (currentTargetPos and not NUM_UTIL:IsWithin(currentTargetPos, aimPos, 3)) then
				local gunMotor = gunBase:FindFirstChild("GunPivot")
				local tankPrim = child:FindFirstChild("HumanoidRootPart")
				if not gunMotor or not tankPrim then return end
				local gunBaseMotor = tankPrim:FindFirstChild("GunBase")
				if not gunBaseMotor then return end
				runningLerp = true
				local currentPos = currentTargetPos
				currentTargetPos = aimPos
				if not currentPos then
					currentPos = aimPos
				end
				lastLerpUpdate = os.clock()
				--print("started tank lerp loop")
				while os.clock() - lastLerpUpdate < 1 do
					local step = task.wait(1/60)
					if not gunBaseMotor.Parent or not gunMotor.Parent then return end
					local alpha = math.clamp(step * 6, 0, 1)
					currentPos = currentPos:Lerp(currentTargetPos, alpha)
					local basePos = gunBase.Position
					local aimTo = currentPos
					local base2d = Vector3.new(basePos.X, 0, basePos.Z)
					local aim2d = Vector3.new(aimTo.X, 0, aimTo.Z)
					gunBaseMotor.C1 = CFrame.new(0, 0.3, 0) * tankPrim.CFrame.Rotation * CFrame.new(base2d, aim2d).Rotation:Inverse()-- * CFrame.Angles(0, math.rad(180), 0)
					local currentAngle = math.clamp(math.atan2(aimTo.Y - basePos.Y, (aim2d - base2d).Magnitude), -0.25, 1.1)
					gunMotor.C1 = CFrame.Angles(0, 0, -currentAngle)
					--print(currentRot, currentAngle)
				end
				runningLerp = false
				--print("ended tank lerp loop")
			else
				currentTargetPos = aimPos
				lastLerpUpdate = os.clock()
			end
			--[[
			local targetAngle = math.clamp(math.atan2(aimPos.Y - basePos.Y, (aim2d - base2d).Magnitude), -0.25, 1.1)
			local targetRot = math.atan2(aimPos.Z - basePos.Z, aimPos.X - basePos.X)--CFrame.new(base2d, aim2d).Rotation:Inverse() * CFrame.Angles(0, math.rad(180), 0)
			if not runningLerp and (math.abs(currentTargetAngle - targetAngle) > 0.05 or math.abs(currentTargetRot - targetRot) > 0.05) then
				local gunMotor = gunBase:FindFirstChild("GunPivot")
				local tankPrim = child:FindFirstChild("HumanoidRootPart")
				if not gunMotor or not tankPrim then return end
				local gunBaseMotor = tankPrim:FindFirstChild("GunBase")
				if not gunBaseMotor then return end
				runningLerp = true
				local currentAngle = currentTargetAngle
				local currentRot = currentTargetRot
				local currentCF = currentTargetCF
				currentTargetAngle = targetAngle
				currentTargetRot = targetRot
				currentTargetCF = CFrame.new(base2d, aim2d).Rotation:Inverse() * CFrame.Angles(0, math.rad(180), 0)
				if not currentCF then
					currentCF = currentTargetCF
				end
				lastLerpUpdate = os.clock()
				--print("started tank lerp loop")
				while os.clock() - lastLerpUpdate < 1 do
					local step = task.wait()
					if not gunBaseMotor.Parent or not gunMotor.Parent then return end
					local lastRot = currentRot
					local alpha = math.clamp(step * 6, 0, 1)
					currentRot = NUM_UTIL:Lerp(currentRot, currentTargetRot, alpha)
					--print(currentTargetRot)
					gunBaseMotor.C1 = currentCF:Lerp(currentTargetCF, alpha)
					--gunBaseMotor.C1 = CFrame.Angles(0, currentRot + extraRot, 0)
					currentAngle = NUM_UTIL:Lerp(currentAngle, currentTargetAngle, alpha)
					gunMotor.C1 = CFrame.Angles(0, 0, -currentAngle)
					--print(currentRot, currentAngle)
				end
				runningLerp = false
				--print("ended tank lerp loop")
			else
				if math.abs(targetAngle - currentTargetAngle) > math.pi then
					extraRot += math.pi * (targetAngle > 0 and -2 or 2)
					print("added extra rotation")
				end
				currentTargetAngle = targetAngle
				currentTargetRot = targetRot
				currentTargetCF = CFrame.new(base2d, aim2d).Rotation:Inverse() * CFrame.Angles(0, math.rad(180), 0)
				lastLerpUpdate = os.clock()
				--print("updated ongoing lerp loop")
			end]]
		end)
		local humanoid = child:WaitForChild("Humanoid")
		if not humanoid then return end
		local rootPart = child:WaitForChild("HumanoidRootPart")
		if not rootPart then return end
		local wheelJoints = rootPart:WaitForChild("WheelJoints")
		if not wheelJoints then return end
		local loopRunning = false
		local desiredSpeed = 0
		local acceleration = 1
		local currentRotation = 0
		humanoid.Running:Connect(function(speed)
			if not NUM_UTIL:IsWithin(PLAYER.Character.HumanoidRootPart.Position, child.HumanoidRootPart.Position, 750) then return end
			if not loopRunning and speed > 0.01 then
				loopRunning = true
				desiredSpeed = speed
				local currentSpeed = desiredSpeed
				local joints = wheelJoints:GetChildren()
				while true do
					local step = task.wait(1/60)
					if not wheelJoints.Parent then return end
					currentSpeed = NUM_UTIL:Lerp(currentSpeed, desiredSpeed, math.clamp(step * acceleration * 8, 0, 1))
					currentRotation += math.rad(currentSpeed * 12.5 * step)
					for _, joint in pairs(joints) do
						joint.C1 = CFrame.Angles(currentRotation, 0, 0)
					end
					if currentSpeed <= 0.01 and desiredSpeed <= 0.01 then break end
				end
				loopRunning = false
			else
				desiredSpeed = speed
				acceleration = (speed <= 0.01 and 4 or 1)
			end
		end)
		--[[child:GetAttributeChangedSignal("Drive"):Connect(function()
			if not NUM_UTIL:IsWithin(PLAYER.Character.HumanoidRootPart.Position, child.HumanoidRootPart.Position, 1800) then return end
			if child:GetAttribute("Drive") then
				if not rotatingWheels then
					rotatingWheels = true
					while rotatingWheels do
						--rotate wheels
						local joints = child.HumanoidRootPart.WheelJoints

						local frequency = 0.025
						local degree = 5
						for _, joint in pairs(joints:GetChildren()) do
							joint.C1 = joint.C1 * CFrame.Angles(math.rad(degree), 0, 0)
						end
						task.wait(frequency)
					end
				end
			else
				rotatingWheels = false
			end
		end)]]
	end
end

Loners.ChildAdded:Connect(SetTimedCrateFolder)
SetTimedCrateFolder(Loners:FindFirstChild("Timed Crate"))

EVENTS_FOLDER.ChildRemoved:Connect(function()
	UpdateEventsOnMap()
end)

EVENTS_FOLDER.ChildAdded:Connect(SetupEventChild)

for _, child in pairs(EVENTS_FOLDER:GetChildren()) do --TEMP AF cuz btr is already spawned so I just copy and paste for testing
	SetupEventChild(child)
end

while true do
	UpdateEventsOnMap()
	task.wait(2)
end