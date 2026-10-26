-- [PATH] ServerScriptService / ServerService / CollisionService @Type Script
--[[
	CollisionService
	by ChickenBagelz
	August 6th, 2022
	
	Adds or removes parts from collision groups easily
]]

-- Services
local Physics = game:GetService("PhysicsService")

-- Global Functions
function shared.SetModelCollision(model, collisionGroup, recurse, doHead)
	for _, part in pairs(model:GetChildren()) do
		if part:IsA("BasePart") then
			part.CollisionGroup = ((part.Name == "Head" or part.Name == "UpperTorso") and doHead or collisionGroup)
		end
		if recurse and part:FindFirstChildWhichIsA("BasePart") then
			shared.SetModelCollision(part, collisionGroup, recurse)
		end
	end
end

-- Collision group creation
Physics:RegisterCollisionGroup("Players")
Physics:RegisterCollisionGroup("PlayersTop")
Physics:RegisterCollisionGroup("Items")
Physics:RegisterCollisionGroup("Animals")
Physics:RegisterCollisionGroup("VFX")
Physics:RegisterCollisionGroup("Nodes")
Physics:RegisterCollisionGroup("Trees")
Physics:RegisterCollisionGroup("Bodies")
Physics:RegisterCollisionGroup("Ladder")

-- Collision group configuration
Physics:CollisionGroupSetCollidable("Items", "Players", false)
Physics:CollisionGroupSetCollidable("Items", "PlayersTop", false)
Physics:CollisionGroupSetCollidable("Items", "Items", false)
Physics:CollisionGroupSetCollidable("Items", "Bodies", false)
Physics:CollisionGroupSetCollidable("Animals", "Players", false)
Physics:CollisionGroupSetCollidable("Animals", "PlayersTop", false)
Physics:CollisionGroupSetCollidable("Animals", "Trees", false)
Physics:CollisionGroupSetCollidable("Animals", "Nodes", false)
Physics:CollisionGroupSetCollidable("Animals", "Animals", false)
Physics:CollisionGroupSetCollidable("Animals", "Items", false)
Physics:CollisionGroupSetCollidable("VFX", "Items", false)
Physics:CollisionGroupSetCollidable("VFX", "Players", false)
Physics:CollisionGroupSetCollidable("VFX", "PlayersTop", false)
Physics:CollisionGroupSetCollidable("VFX", "Nodes", false)
Physics:CollisionGroupSetCollidable("VFX", "VFX", false)
Physics:CollisionGroupSetCollidable("VFX", "Animals", false)
Physics:CollisionGroupSetCollidable("Bodies", "Players", false)
Physics:CollisionGroupSetCollidable("Bodies", "PlayersTop", false)
Physics:CollisionGroupSetCollidable("Bodies", "Bodies", false)
Physics:CollisionGroupSetCollidable("Ladder", "PlayersTop", false)