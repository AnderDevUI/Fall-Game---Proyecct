-- [PATH] ServerStorage / Modules / CharacterAppearanceClass @Type ModuleScript
--[[
	Character Appearance Class
	by neddleduck
	July 16, 2022
	
	Holds all character appearance functions and data
]]

-- Services
local Storage = game:GetService("ServerStorage")
local Replicated = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Folders
local Modules = Storage:WaitForChild("Modules")
local Shared_Modules = Replicated:WaitForChild("Modules")

--Modules
local Appearance_Mod = require(Modules:WaitForChild("AppearanceModule"))
local Weld_Mod = require(Shared_Modules:WaitForChild("WeldModule"))

--Constants
local HAIR_STORAGE = Storage.Hair

local CharacterAppearanceClass = {}
CharacterAppearanceClass.__index = CharacterAppearanceClass

function CharacterAppearanceClass.new(player, data)
	local self = setmetatable({}, CharacterAppearanceClass)
	--[[if player and player.UserId ~= 47983795 then
		data = nil
	end]]
	local newData = self:GetNewData()
	if not data then
		data = newData
	else
		data = self:SetupData(data)
		if data.ExoticHair == nil then
			data.ExoticHair = newData.ExoticHair
			data.HairColor = newData.HairColor
		end
		if data.Wrinkles == nil then
			data.Wrinkles = newData.Wrinkles
		end
	end
	
	self.Player = player
	self:ApplyData(data)
	
	print(player.Name, self)

	return self
end

function CharacterAppearanceClass:GetData()
	return {
		[1] = self.Male,
		[2] = self.Old,
		[3] = self.White,
		[4] = self.SkinColor,
		[5] = self.Scars,
		[6] = self.Freckles,
		[7] = self.Birthmarks,
		[8] = self.Hair,
		[9] = self.HairColor,
		[10] = self.Mouth,
		[11] = self.Bald,
		[12] = self.Brows,
		[13] = self.ExoticHair,
		[14] = self.Wrinkles
	}
end

function CharacterAppearanceClass:SetupData(data)
	return {
		Male = data[1],
		Old = data[2],
		White = data[3],
		SkinColor = data[4],
		Scars = data[5],
		Freckles = data[6],
		Birthmarks = data[7],
		Hair = data[8],
		HairColor = data[9],
		Mouth = data[10],
		Bald = data[11],
		Brows = data[12],
		ExoticHair = data[13],
		Wrinkles = data[14]
	}
end

function CharacterAppearanceClass:ApplyData(data)
	for attribute, value in pairs(data) do
		self[attribute] = value
	end
end

function CharacterAppearanceClass:GetNewData()
	local data = {}
	
	data.Male = math.random(1, 100) <= 50
	
	data.Old = math.random(1, 100) <= 13
	
	data.Wrinkles = data.Old and math.random(1, #Appearance_Mod.Wrinkles) or 0
	
	data.White = math.random(1, 100) <= 50
	
	data.SkinColor = (function()
		local skinColors = Appearance_Mod.SkinColors[data.White and "White" or "Black"]
		return math.random(1, #skinColors)
	end)()
	
	data.Scars = (function()
		local t = {0, 0}--{leftIndex, rightIndex}
		local left = math.random(1, 100) <= 5
		local right = math.random(1, 100) <= 5
		if left then
			local index = math.random(1, #Appearance_Mod.Scar.Left)
			t[1] = index
		end
		if right then
			local index = math.random(1, #Appearance_Mod.Scar.Right)
			t[2] = index
		end
		return t
	end)()
	
	data.Freckles = math.random(1, 100) <= 18 and math.random(1, #Appearance_Mod.Freckles) or 0
	
	data.Birthmarks = (function()
		local t = {} --{0, 2(index), 0, 4(index)} <-- example one generated
		for index,_ in pairs(Appearance_Mod.BirthMark) do
			table.insert(t, math.random(1, 100) <= 15 and index or 0)
		end
		return t
	end)()
	
	data.Hair = (function()
		local hairsToChoose = HAIR_STORAGE:GetChildren()
		for index = #hairsToChoose, 1, -1 do
			local hair = hairsToChoose[index]
			local toRemove = data.Male and "Hair_Female" or "Hair_Male"
			--print(string.find(hair.Name, toRemove))
			if string.find(hair.Name, toRemove) then
				--print(hair.Name .. " Removed")
				table.remove(hairsToChoose, index)
			end
		end
		--print(hairsToChoose)
		return hairsToChoose[math.random(1, #hairsToChoose)].Name
	end)()
	
	data.ExoticHair = math.random(1, 2000) <= 1
	
	data.HairColor = (function()
		local index = data.ExoticHair and "Exotic" or (data.Old and "Old" or (data.White and "White" or "Black"))
		return math.random(1, #Appearance_Mod.HairColors[index])
	end)()
	
	data.Mouth = math.random(1,3)
	
	data.Bald = (function()
		local baldChance = 0 + (data.Male and (data.Old and 20 or 5) or 0)
		return math.random(1, 100) <= baldChance
	end)()
	
	data.Brows = math.random(1, #Appearance_Mod.Brows)
	
	return data
end

function CharacterAppearanceClass:LoadAppearance()
	local char = self.Player.Character
	local head = char.Head
	local hum = char:WaitForChild("Humanoid")
	--Remove old decals
	for _, decal in pairs(head:GetChildren()) do
		if not decal:IsA("Decal") then continue end
		decal:Destroy()
	end
	
	--Body setup
	--local models = (self.Male and {} or Weld_Mod:FullyWeldModels(Storage.FemaleTorso, char))
	--[[if self.Male then
		--print("doing male setup")
		local humDesc = Instance.new("HumanoidDescription")
		for _, limbName in pairs({"Head", "Torso", "LeftLeg", "RightLeg", "LeftArm", "RightArm"}) do
			humDesc[limbName.."Color"] = skinColor
		end
		humDesc.Parent = hum
		hum:ApplyDescription(humDesc)
		char:FindFirstChild("UpperTorso").Massless = true
	else]]
		--print("doing female setup")
		
	--end
	--[[if not self.Male then
		local upperTorso = char:WaitForChild("UpperTorso")
		upperTorso.Transparency = 1
		local lowerTorso = char:WaitForChild("LowerTorso")
		lowerTorso.Transparency = 1
	end]]
	local skinColor = Appearance_Mod.SkinColors[self.White and "White" or "Black"][self.SkinColor]
	local models = {}
	table.insert(models, char)
	for _, model in pairs(models) do
		for _, part in pairs(model:GetChildren()) do
			if not (part:IsA("BasePart") and part.Transparency < 1) then continue end
			part.Color = skinColor
		end
	end
	--Shirt/Pants
	local shirt = char:FindFirstChild("Shirt") or Instance.new("Shirt")
	shirt.Name = "Shirt"
	shirt.ShirtTemplate = Appearance_Mod.Clothing.Shirt
	shirt.Parent = char
	local pants = char:FindFirstChild("Pants") or Instance.new("Pants")
	pants.Name = "Pants"
	pants.PantsTemplate = Appearance_Mod.Clothing.Pants
	pants.Parent = char
	--Facial Features
	local eyes = Instance.new("Decal")
	eyes.Name = "Eyes"
	eyes.Texture = Appearance_Mod.Eyes[2]
	eyes.Parent = head
	local mouth = Instance.new("Decal")
	mouth.Name = "Mouth"
	mouth.Texture = Appearance_Mod.Mouth[self.Mouth][2]
	mouth.Parent = head
	local brows = Instance.new("Decal")
	brows.Name = "Brows"
	brows.Texture = Appearance_Mod.Brows[self.Brows]
	brows.Parent = head
	if not self.Male then 
		local femaleFaceDetail = Instance.new("Decal")
		femaleFaceDetail.Name = "Detail"
		femaleFaceDetail.Texture = Appearance_Mod.FemaleFace
		femaleFaceDetail.Parent = head
	end
	--Birthmarks
	for index, birthmark in pairs(self.Birthmarks) do
		if birthmark == 0 then continue end
		local decal = Instance.new("Decal")
		decal.Name = "Birthmark" .. index
		decal.Texture = Appearance_Mod.BirthMark[birthmark]
		decal.Parent = head
	end
	--Scars
	for index, scar in pairs(self.Scars) do
		if scar == 0 then continue end
		local decal = Instance.new("Decal")
		decal.Name = "Scar"..index
		decal.Texture = Appearance_Mod.Scar[index == 1 and "Left" or "Right"][scar]
		decal.Parent = head
	end
	--Freckles
	if self.Freckles > 0 then
		local decal = Instance.new("Decal")
		decal.Name = "Freckles"
		decal.Texture = Appearance_Mod.Freckles[self.Freckles]
		decal.Parent = head
	end
	--Old
	if self.Old then
		if self.Wrinkles == 0 or not self.Wrinkles then
			self.Wrinkles = math.random(1, #Appearance_Mod.Wrinkles)
		end
		local decal = Instance.new("Decal")
		decal.Name = "Wrinkles"
		decal.Texture = Appearance_Mod.Wrinkles[self.Wrinkles]
		decal.Parent = head
	end
	--Hair
	if not self.Bald then
		local hair = HAIR_STORAGE[self.Hair]:Clone()
		hair.Parent = workspace
		local hairColors = Appearance_Mod.HairColors[self.ExoticHair and "Exotic" or (self.Old and "Old" or (self.White and "White" or "Black"))]
		local hairColor = hairColors[self.HairColor]
		if not hairColor then
			self.HairColor = math.random(1, #hairColors)
			hairColor = hairColors[self.HairColor]
		end
		hair.Head.HairPart.Color = hairColor
		local models = Weld_Mod:FullyWeldModels(hair, char)
		for _, model in pairs(models) do
			model.Name = "Hair"
		end
	end
end

CharacterAppearanceClass.LoadSleeper = function(Sleeper, data)
	local skinColor = Appearance_Mod.SkinColors[data.SkinColor]
	for _, part in pairs(Sleeper:GetChildren()) do
		if not part:IsA("Part") then continue end
		part.Color3 = skinColor
	end
	if not data.Bald then
		local hair = HAIR_STORAGE[Appearance_Mod.Hair[data.Hair]]:Clone()
		hair.Parent = workspace
		hair.Head.HairPart.Color = Appearance_Mod.HairColors[data.Old and "Old" or (data.SkinColor == "White" and "White" or "Black")][data.HairColor]
		local models = Weld_Mod:FullyWeldModels(hair, Sleeper)
		for _, model in pairs(models) do
			model.Name = "Hair"
		end
	end
end

return CharacterAppearanceClass