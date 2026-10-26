-- [PATH] ServerStorage / GrainImage @Type LocalScript
local grain = Instance.new("ScreenGui")
grain.Name = "FilmGrain"
grain.IgnoreGuiInset = true
grain.DisplayOrder = 99
grain.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local grainImage = Instance.new("ImageLabel")
grainImage.Size = UDim2.new(1, 0, 1, 0)
grainImage.BackgroundTransparency = 1
grainImage.ImageTransparency = 0.9
grainImage.ScaleType = Enum.ScaleType.Tile
grainImage.Image = "http://www.roblox.com/asset/?id=28756351"
grainImage.ZIndex = 1
grainImage.Parent = grain
local u1 = 0
local new = UDim2.new
local random = math.random
game:GetService("RunService").Heartbeat:Connect(function()
	if tick() - u1 < 0.020833333333333332 then
		return
	end
	u1 = tick()
	grainImage.TileSize = new(random(213.6, 266.40000000000003) / 1000, 0, random(213.6, 266.40000000000003) / 1000, 0)
end)
