-- [PATH] ReplicatedStorage / CharacterScripts / EquipController @Type LocalScript
--[[
	EquipController
	by ChickenBagelz
	May 26, 2023
]]

--Services
local InputService = game:GetService("UserInputService")
local Replicated = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Run = game:GetService("RunService")

-- Folders
local Values = Replicated:WaitForChild("Values")

--Player Variables
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Char = script.Parent
local Hum = Char:WaitForChild("Humanoid")

--Controllers
local InventoryController = Char:WaitForChild("InventoryController")
local ViewmodelController = Char:WaitForChild("ViewmodelController")
local BuildController = Char:WaitForChild("BuildController")
local CameraController = Char:WaitForChild("CameraController")

--Modules
local Modules = Replicated:WaitForChild("Modules")
local Items = require(Modules:WaitForChild("Items"))
local VectorUtil = require(Modules:WaitForChild("VectorUtil"))

--Remotes
local Remotes = Replicated:WaitForChild("Remotes")
local StatsRemotes = Remotes:WaitForChild(string.char(32, 175, 56, 160, 50, 187, 113, 77, 49, 22, 130, 142, 126, 38, 59, 102, 17, 6, 168, 41, 9, 180, 85, 142, 105, 14, 66, 146, 142, 126))
local EquipRemotes = Remotes:WaitForChild(string.char(48, 32, 92, 99, 132, 71, 174, 29, 30, 26, 187, 7, 15, 97, 74, 158, 136, 71, 94, 130, 105, 30, 61, 94, 189, 126, 122, 164, 159, 188))

local ConsumeRemote = string.char(27, 172, 20, 5, 103, 62, 136, 82, 35, 178, 177, 27, 40, 69, 51, 169, 95, 77, 172, 4, 97, 63, 55, 189, 180, 173, 72, 135, 187, 25)
local EquipRemote = string.char(12, 24, 129, 111, 133, 84, 169, 122, 127, 1, 125, 129, 159, 123, 134, 132, 189, 66, 19, 177, 43, 98, 73, 179, 94, 189, 188, 3, 146, 44)

--Keycode Library
local NumberEnums = {
	Enum.KeyCode.One,
	Enum.KeyCode.Two,
	Enum.KeyCode.Three,
	Enum.KeyCode.Four,
	Enum.KeyCode.Five,
	Enum.KeyCode.Six
}

--UI Constants
local GUI = PlayerGui:WaitForChild("Main")
local Toolbar = GUI:WaitForChild("Toolbar")
local Codelock = GUI:WaitForChild("Codelock")

-- Bindables
local FetchInv = InventoryController:WaitForChild("Fetch")

--Variables
local currentEquipNum = 0
local equipQueue = {}
local queueRunning = false
local lastConsumeFire = 0

--Functions
local function IsAlive()
	return (Hum and Hum.Parent and Hum.Health > 0 and not CameraController:GetAttribute("ViewmodelCFrame"))
end

local function UpdateSlot(n)
	local equipped = script:GetAttribute("Equipped")
	local slot = Toolbar:FindFirstChild("Slot"..n)
	if not slot then return end
	--print("updating slot to blue", equipped == n)
	slot.BackgroundColor3 = InventoryController:GetAttribute((equipped == n and "Selected" or "Default").."SlotColor")
end

local function GetToolbarItem(n)
	local containers = FetchInv:Invoke()
	local toolbar = containers.Toolbar
	local item = toolbar[n]
	local itemInfo = (item and item ~= 0 and item.Amount > 0 and Items[item.ID])
	return item, itemInfo
end

local function UpdateEquipped(equipped)
	local curEquipped = script:GetAttribute("Equipped")
	script:SetAttribute("Equipped", equipped)
	if curEquipped ~= equipped then
		UpdateSlot(curEquipped)
	end
	UpdateSlot(equipped)
	local item, itemInfo = GetToolbarItem(equipped)
	equipped = (((itemInfo and itemInfo.Type ~= "Gun" and itemInfo.Type ~= "Tool" and itemInfo.Type ~= "Bench") or (itemInfo and itemInfo.MaxDurability and item.Durability <= 0)) and 0 or equipped)
	ViewmodelController.EquipVM:Fire(equipped)
	BuildController.EquipBench:Fire(equipped)
	--print("updating", script:GetAttribute("Equipped"), equipped)
	return true--(itemInfo and equipped ~= 0)
end

local function Equip(n, equipOnly)
	local item, itemInfo = GetToolbarItem(n)
	if itemInfo and itemInfo.Type == "Consumable" then
		if equipOnly then return end
		local press = tick()
		if press - lastConsumeFire < 0.2 then return end
		lastConsumeFire = press
		-- Eat food
		VectorUtil:FireRemote(StatsRemotes, ConsumeRemote, {
			[1] = n, 
			[2] = "Toolbar"
		})
		return
	elseif type(item) == "table" and item.Amount <= 0 then
		return
	end
	local equipped = (script:GetAttribute("Equipped") == n and 0 or n)
	if equipped ~= 0 and Player:GetAttribute("SafeZone") then 
		local item, itemInfo = GetToolbarItem(equipped)
		if type(itemInfo) == "table" and itemInfo.Type == "Gun" then return end 
	end
	local didEquip = UpdateEquipped(equipped)
	if not didEquip then return end
	VectorUtil:FireRemote(EquipRemotes, EquipRemote, {
		[1] = equipped
	})
	--print("equipped", equipped)
	return didEquip
end

local function CycleEquipped(n)
	local equipped = script:GetAttribute("Equipped")
	if equipped == 0 then return end
	local i = equipped
	repeat
		i += n
		i = (i > #NumberEnums and 1 or (i < 1 and #NumberEnums or i))
	until i == equipped or Equip(i, true)
end

local function QueueFunction(func)
	if #equipQueue > 3 then return end
	table.insert(equipQueue, func)
	if not queueRunning then
		queueRunning = true
		local lastFunc = os.clock()
		while #equipQueue > 0 do
			local t = os.clock()
			local cooldown = 0.1
			if t - lastFunc >= cooldown then
				while t - lastFunc >= cooldown do
					t -= cooldown
					local cur = equipQueue[1]
					if not cur then break end
					cur()
					table.remove(equipQueue, 1)
					if #equipQueue <= 0 then
						queueRunning = false
						break 
					end
				end
				lastFunc = os.clock()
			end
			task.wait()
		end
	end
end

-- I HAVE TO ADD THIS TO MAKE SURE THE CLIENT'S INVENTORY IS FULLY LOADED BEFORE WE CAN EQUIP ANYTHING
while true do
	if not (FetchInv and FetchInv.Parent) then return end
	local containers = FetchInv:Invoke()
	if type(containers) == "table" then
		local toolbar = containers.Toolbar
		if type(toolbar) == "table" then break end
	end
	task.wait()
end

InputService.InputBegan:Connect(function(input)
	local inputType = input.UserInputType
	local textBox = InputService:GetFocusedTextBox()
	if textBox or Codelock.Visible or Hum:GetAttribute("Downed") or not IsAlive() then return end
	if inputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		--[[if key == Enum.KeyCode.J then
			print("yes")
			local InventoryRemotes = Remotes:WaitForChild(string.char(112, 17, 107, 22, 65, 146, 120, 135, 75, 57, 109, 34, 79, 105, 140, 153, 152, 95, 159, 125, 83, 96, 185, 108, 168, 132, 159, 28, 114, 103))
			local InventoryRemote = string.char(53, 11, 104, 88, 159, 158, 138, 46, 60, 39, 122, 104, 25, 110, 176, 190, 84, 79, 104, 16, 3, 115, 180, 167, 55, 106, 24, 128, 170, 167)
			VectorUtil:FireRemote(EquipRemotes, EquipRemote, {
				[1] = 1
			})
			VectorUtil:FireRemote(InventoryRemotes, InventoryRemote, {
				[1] = "QuickStack", 
				[2] = 0, 
				[3] = "Toolbar"
			})
			return
		end]]
		for index, enum in pairs(NumberEnums) do
			if enum ~= key then continue end
			QueueFunction(function()
				if CameraController:GetAttribute("ViewmodelCFrame") then return end
				Equip(index)
			end)
			break
		end
	end
end)

InputService.InputChanged:Connect(function(input, notProcessed)
	local inputType = input.UserInputType
	local textBox = InputService:GetFocusedTextBox()
	if inputType ~= Enum.UserInputType.MouseWheel or textBox or notProcessed or Codelock.Visible or Hum:GetAttribute("Downed") or Player:GetAttribute("SafeZone") or not IsAlive() then return end
	QueueFunction(function()
		CycleEquipped(input.Position.Z > 0 and -1 or 1)
	end)
end)

VectorUtil:SetupRemote(EquipRemotes, EquipRemote, UpdateEquipped)

if Values.ServerType.Value == "GunGame" then
	Equip(1)
end