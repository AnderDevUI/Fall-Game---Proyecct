-- [PATH] ReplicatedStorage / Modules / ButtonClass @Type ModuleScript
--[[
	ButtonClass
	by ChickenBagelz
	September 1, 2021

	For shared button animations
]]


-- Services
local RunService = game:GetService("RunService")
local Replicated = game:GetService("ReplicatedStorage")

-- Folders
local Modules = Replicated:WaitForChild("Modules")

-- Modules
local NumberUtil = require(Modules:WaitForChild("NumberUtil"))
local Thread = require(Modules:WaitForChild("Thread"))


local ButtonClass = {}
ButtonClass.__index = ButtonClass

function ButtonClass.new(button, prop, clickFunc, hoverMult, clickColor, rightClickFunc, guiPropAffected)
	local ui = (guiPropAffected or button)
	local self = setmetatable({
		Button = button;
		Property = prop;
		OrigSize = button.Size;
		OrigColor = ui[prop];
		CurColor = ui[prop]; -- Changes when button is hovered over
		TargetColor = ui[prop]; -- Color that will be lerped into
		DoingLoop = false; -- Is true if any color logic is being calculated
		Alpha = 0; -- Goes from 0 to 1 to indicate how much button[prop] has lerped to self.TargetColor
		Selected = false; -- Clicked or not
		MouseEntered = false;
		HoverMult = (hoverMult or 1.25); -- OrigColor * HoverMult
		ClickColor = ((clickColor ~= nil and (type(clickColor) == "number" and NumberUtil:MultColor3ByNum(ui[prop], clickColor) or clickColor)) or Color3.fromRGB(30, 154, 206));
		Connections = {};
		GuiAffected = guiPropAffected;
	}, ButtonClass)
	table.insert(self.Connections, button.MouseEnter:Connect(function()
		self.MouseEntered = true
		local curColor = self.CurColor
		self.Alpha = 0
		self.TargetColor = NumberUtil:MultColor3ByNum(curColor, self.HoverMult)
		self:DoLoop()
	end))
	table.insert(self.Connections, button.MouseLeave:Connect(function()
		self.MouseEntered = false
		local curColor = self.CurColor
		self.Alpha = 0
		self.TargetColor = curColor
		self:DoLoop()
	end))
	for i = 1, 2 do -- Loop twice in case logic for right clicking was implemented
		if i == 2 and not rightClickFunc then break end
		table.insert(self.Connections, button["MouseButton"..i.."Down"]:Connect(function()
			button:TweenSize(NumberUtil:MultUDim2ByNum(self.OrigSize, 0.75), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true) -- Shrink button
			local letgo = false
			local con = button["MouseButton"..i.."Up"]:Connect(function()
				letgo = true
			end)
			task.wait(0.15)
			while (not letgo) and self.MouseEntered do -- Will unshrink button when either mouse is let go or mouse leaves button
				RunService.Heartbeat:Wait()
			end
			con:Disconnect()
			if button.Parent ~= nil then
				button:TweenSize(self.OrigSize, Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.2, true) -- Go back to original size
			end
		end))
	end
	table.insert(self.Connections, button.Activated:Connect(clickFunc))
	if rightClickFunc then
		table.insert(self.Connections, button.MouseButton2Click:Connect(rightClickFunc))
	end
	--self:ToggleButton(not self.Selected)
	return self
end

function ButtonClass:ToggleButton(b, instant) -- Turns the button either on or off (selects or unselects)
	if self.Selected ~= b then
		self.Selected = b
		local curColor = (b and self.ClickColor or self.OrigColor)
		self.Alpha = 0
		self.CurColor = curColor
		self.TargetColor = NumberUtil:MultColor3ByNum(curColor, (self.MouseEntered and self.HoverMult or 1))
		self:DoLoop(instant)
	end
end

function ButtonClass:UpdateBaseColor(color, clickColor)
	self.OrigColor = color
	self.CurColor = color
	self.TargetColor = color
	if clickColor then
		self.ClickColor = clickColor
	end
end 

function ButtonClass:DoLoop(instant) -- For running logic and lerping of button
	local button = (self.GuiAffected or self.Button)
	local prop = self.Property
	if not self.DoingLoop then
		if instant then
			button[prop] = self.TargetColor
		else
			self.DoingLoop = true
			while math.abs(1 - self.Alpha) > 0.001 do
				local deltaTime = task.wait() / (1 / 60)
				if not button.Parent then return end
				local alpha = math.clamp(0.3 * deltaTime, 0, 1)
				self.Alpha = NumberUtil:Lerp(self.Alpha, 1, alpha)
				button[prop] = button[prop]:Lerp(self.TargetColor, alpha)
				RunService.Heartbeat:Wait()
			end
			self.DoingLoop = false
		end
	end
end

function ButtonClass:Destroy() -- Properly disconnects all events and cleans up metatables
	for _, c in pairs(self.Connections) do
		c:Disconnect()
	end
	self = nil
end

function ButtonClass:IsToggled() 
	return self.Selected
end

return ButtonClass