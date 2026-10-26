-- [PATH] ReplicatedStorage / Modules / ItemClass @Type ModuleScript
--[[
	ItemClass
	by ChickenBagelz
	July 16, 2022
	
	Holds all information on an item
]]

-- Services
local Replicated = game:GetService("ReplicatedStorage")

-- Folders
local Modules = Replicated:WaitForChild("Modules")

-- Modules
local Items = require(Modules:WaitForChild("Items"))


local ItemClass = {}
ItemClass.__index = ItemClass

function ItemClass.new(id, amount, skin, durability, repair, ammo, attachments, cookTimes, owner)
	local self
	if type(id) == "table" then
		local item = id
		local decompressData = amount
		self = setmetatable(item, ItemClass)
		if decompressData then
			decompressData(self)
		end
		if self.Ammo then
			local ammo = setmetatable(self.Ammo, ItemClass)
			self.Ammo = ammo
			if decompressData then
				decompressData(ammo)
			end
		end
		if self.Attachments then
			for index, attachment in pairs(self.Attachments) do
				local attachmentItem = setmetatable(attachment, ItemClass)
				self.Attachments[index] = attachmentItem
				if not decompressData then continue end
				decompressData(attachmentItem)
			end
		end
	else
		local info = Items[id]
		local maxDur = info.MaxDurability
		local dur = tonumber(durability)
		self = setmetatable({
			ID = id;
			Amount = amount;
			Skin = (skin or "Default");
			Durability = ((type(durability) == "string" and dur and maxDur) and maxDur * dur or (durability or maxDur or 0));
			Repair = (repair or 0);
			Ammo = ammo;
			Attachments = (attachments or (info.Attachments and {}));
			CookTimes = cookTimes;
			Owner = owner;
		}, ItemClass)
	end
	
	return self
end

function ItemClass:SetAmount(amount)
	self.Amount = amount
end

function ItemClass:ChangeAmount(n, mult)
	local maxStack = Items[self.ID].MaxStack
	self.Amount = math.clamp(self.Amount + n, 0, math.round(maxStack * (maxStack ~= 1 and mult or 1)))
end

function ItemClass:AddAttachment(attachment)
	table.insert(self.Attachments, attachment)
end

function ItemClass:RemoveAttachment(index)
	local attachments = self.Attachments
	if type(index) == "table" then
		for i, v in pairs(attachments) do
			if v == index then
				table.remove(attachments, i)
				break
			end
		end
	else
		table.remove(attachments, index)
	end
end

function ItemClass:GetComponents(length)
	local total = {self.ID, self.Amount, self.Skin, self.Durability, self.Repair, self.Ammo, self.Attachments, self.CookTimes, self.Owner}
	return unpack(total, 1, (length or #total))
end

function ItemClass:AttachmentStats(isAiming)
	local attachments = (self.Attachments or {})
	local allStats = {}
	for _, attachment in pairs(attachments) do
		local attachmentInfo = Items[attachment.ID]
		if not (attachmentInfo and attachmentInfo.MaxDurability == nil or attachment.Durability > 0) then continue end
		local attachmentStats = attachmentInfo.AttachmentStats
		if not attachmentStats then continue end
		local isToggle = attachmentStats.Toggle
		local needsAim = attachmentStats.AimForRecoilMult
		if isToggle and not attachment.On then continue end
		for stat, value in pairs(attachmentStats) do
			if stat == "RecoilMult" and needsAim and not isAiming then continue end
			local curStat = allStats[stat]
			allStats[stat] = ((curStat and type(curStat) == "number") and curStat + value or value)
		end
	end
	return allStats
end

function ItemClass:HasAttachment(id)
	for _, attachment in pairs(self.Attachments or {}) do
		if attachment.ID ~= id then continue end
		return attachment
	end
end

function ItemClass:IsToolbar()
	local info = Items[self.ID]
	return (info.Type == "Gun" or info.Type == "Tool" or info.Type == "Consumable" or info.Type == "Bench" or info.Type == "Lock")
end

return ItemClass
