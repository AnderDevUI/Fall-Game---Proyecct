-- [PATH] ReplicatedStorage / CharacterScripts / CameraController @Type LocalScript
--[[
	CameraController
	by ChickenBagelz
	February 21, 2023
]]

-- Services
local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Replicated = game:GetService("ReplicatedStorage")

-- Folders
local Modules = Replicated:WaitForChild("Modules")
local Values = Replicated:WaitForChild("Values")

-- Modules
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))
local Items = require(Modules:WaitForChild("Items"))
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))

-- Player Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Char = script.Parent
local Humanoid = Char:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- Dependencies
local ViewmodelController = Char:WaitForChild("ViewmodelController")
local InventoryController = Char:WaitForChild("InventoryController")

-- UI
local Main = PlayerGui:WaitForChild("Main")
local Chat = PlayerGui:WaitForChild("CustomChat")
local Loading = PlayerGui:WaitForChild("Loading")
local ServerName = Main:WaitForChild("ServerName")

-- Local Variables
local totalMouseMovement = Vector2.new()
local mouseMovement = Vector2.new()
local camRootOffset = Vector3.new()
local binded = false
local camAlpha = 0


-- Functions
local function GetEquipped()
	local containers = InventoryController.Fetch:Invoke()
	if not containers then return end
	local toolbar = containers.Toolbar
	if not toolbar then return end
	local equipped = toolbar[ViewmodelController:GetAttribute("Equipped")]
	return (equipped ~= nil and equipped ~= 0 and equipped)
end

local function ResetFreeLook()
	binded = false
	Camera.CameraType = Enum.CameraType.Custom
	--[[Player.CameraMode = Enum.CameraMode.LockFirstPerson
	Camera.CameraSubject = Humanoid]]
	script:SetAttribute("ViewmodelCFrame", nil)
	Run:UnbindFromRenderStep("FreeLook")
	if not (Humanoid and Humanoid.Parent) then return end
	Humanoid.AutoRotate = true
end

local function FreeLookDownFunc()
	if script:GetAttribute("FreeLooking") or not (Char and Humanoid and Humanoid.Health > 0 and not Humanoid:GetAttribute("Downed")) then return end
	local equipped = GetEquipped()
	local itemInfo = (equipped and Items[equipped.ID])
	if ViewmodelController:GetAttribute("Using") and itemInfo and itemInfo.Type == "Gun" then return end
	local prim = Char.PrimaryPart
	if not prim then return end
	local camCF = Camera.CFrame
	script:SetAttribute("FreeLooking", true)
	script:SetAttribute("ActualCFrame", camCF)
	if binded then return end
	binded = true
	Humanoid.AutoRotate = false
	Camera.CameraType = Enum.CameraType.Scriptable
	--[[Player.CameraMode = Enum.CameraMode.Classic
	Camera.CameraSubject = nil]]
	local camRootOffset = camCF.Position - prim.Position
	Run:BindToRenderStep("FreeLook", Enum.RenderPriority.Camera.Value + 1, function(step)
		local deltaTime = step / (1 / 60)
		local savedCamera = script:GetAttribute("ActualCFrame")
		local freeLooking = script:GetAttribute("FreeLooking")
		local did = false
		if prim and prim.Parent then
			mouseMovement = (freeLooking and totalMouseMovement or mouseMovement:Lerp(Vector2.new(), math.clamp(camAlpha, 0, 1)))
			if not freeLooking then
				totalMouseMovement = Vector2.new()
				camAlpha += step * 10
			else
				camAlpha = 0
			end
			local savedR1, savedR2, savedR3 = savedCamera:ToEulerAnglesXYZ()
			local savedRot = CFrame.Angles(savedR1, savedR2, savedR3)
			local vmCF = CFrame.new(prim.Position + camRootOffset) * savedRot
			script:SetAttribute("ViewmodelCFrame", vmCF)
			local mouseRot = CFrame.Angles(0, -math.rad(mouseMovement.X), 0) * CFrame.Angles(-math.rad(mouseMovement.Y), 0, 0)
			Camera.CFrame = vmCF * mouseRot
			did = (freeLooking or camAlpha < 1)
		end
		if did then return end
		ResetFreeLook()
	end)
end

local function FreeLookUpFunc()
	script:SetAttribute("FreeLooking", false)
end

-- Events
UserInput.InputBegan:Connect(function(input, notProcessed)
	local textBox = UserInput:GetFocusedTextBox()
	if textBox or notProcessed then return end
	local inputType = input.UserInputType
	if inputType ~= Enum.UserInputType.Keyboard then return end
	local key = input.KeyCode
	if key == (Run:IsStudio() and Enum.KeyCode.T or Enum.KeyCode.LeftAlt) then
		FreeLookDownFunc()
	elseif key == Enum.KeyCode.M then
		local uiToggled = (not script:GetAttribute("UI"))
		script:SetAttribute("UI", uiToggled)
		Main.Toolbar.Visible = uiToggled
		Main.Stats.Visible = uiToggled
		Main.Compass.Visible = uiToggled
		Main.Invalids.Visible = uiToggled
		Main.ClientInfo.Visible = uiToggled
		Main.Team.Visible = uiToggled
		Main.ServerName.Visible = uiToggled
		Main.CombatServer.Position = UDim2.new(0, 0, (uiToggled and 0 or -1), 0)
		Chat.Enabled = uiToggled
	end
end)

UserInput.InputChanged:Connect(function(input)
	if not script:GetAttribute("FreeLooking") then return end
	local inputType = input.UserInputType
	if inputType ~= Enum.UserInputType.MouseMovement then return end
	local delta = input.Delta / 2
	totalMouseMovement = Vector2.new(math.clamp(totalMouseMovement.X + delta.X, -140, 140), math.clamp(totalMouseMovement.Y + delta.Y, -50, 50))
	--print(totalMouseMovement, delta)
end)

UserInput.InputEnded:Connect(function(input, notProcessed)
	local textBox = UserInput:GetFocusedTextBox()
	if textBox or notProcessed then return end
	local inputType = input.UserInputType
	if inputType ~= Enum.UserInputType.Keyboard then return end
	local key = input.KeyCode
	if key == (Run:IsStudio() and Enum.KeyCode.T or Enum.KeyCode.LeftAlt) then
		FreeLookUpFunc()
	end
end)

Humanoid.Died:Connect(FreeLookUpFunc)
Humanoid:GetAttributeChangedSignal("Downed"):Connect(function()
	if not Humanoid:GetAttribute("Downed") then return end
	FreeLookUpFunc()
end)

ResetFreeLook()

ServerName.Text = Values.ServerName.Value

Loading.Enabled = true
local preSpawns = workspace:WaitForChild("PreSpawns")
while true do
	if not (Char.Parent and preSpawns.Parent) then
		if Loading.Parent then
			Loading.Enabled = false
		end
		break 
	end
	local charPrim = Char.PrimaryPart
	if charPrim then
		--print("CHECKING", (preSpawns:GetPivot().Position - charPrim.Position).Magnitude)
		if not NumberUtil:IsWithin(preSpawns:GetPivot().Position, charPrim.Position, 50) then
			Loading.Enabled = false
			break 
		end
	end
	task.wait()
end