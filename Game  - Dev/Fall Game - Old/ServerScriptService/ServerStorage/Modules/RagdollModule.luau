-- [PATH] ServerStorage / Modules / RagdollModule @Type ModuleScript
--Services
local Players = game:GetService("Players")
local ServerScripts = game:GetService("ServerScriptService")

-- Dependencies
local UserService = ServerScripts:WaitForChild("UserService")

-- Folders
local VFX_PARTS = workspace:WaitForChild("VFX")
local RAGDOLL_CONTAINER = VFX_PARTS:WaitForChild("Ragdolls")

--Settings
local RAGDOLL_LIFETIME = 90
local JOINT_CONFIGURATION = {
	LeftAnkle = {
		"Hinge";
		Properties = {
			LimitsEnabled = true;
			UpperAngle = 15;
			LowerAngle = -45;
		};
	};
	RightAnkle = {
		"Hinge";
		Properties = {
			LimitsEnabled = true;
			UpperAngle = 15;
			LowerAngle = -45;
		};
	};
	LeftKnee = {
		"Hinge";
		Properties = {
			LimitsEnabled = true;
			UpperAngle = 0;
			LowerAngle = -75;
		};
	};
	RightKnee = {
		"Hinge";
		Properties = {
			LimitsEnabled = true;
			UpperAngle = 0;
			LowerAngle = -75;
		};
	};
	LeftHip = {"BallSocket"};
	RightHip = {"BallSocket"};
	Waist = {"BallSocket"};
	LeftShoulder = {"BallSocket"};
	RightShoulder = {"BallSocket"};
	LeftElbow = {"BallSocket"};
	RightElbow = {"BallSocket"};
	LeftWrist = {
		"Hinge";
		Properties = {
			LimitsEnabled = true;
			UpperAngle = 0;
			LowerAngle = 0;
		};
	};
	RightWrist = {
		"Hinge";
		Properties = {
			LimitsEnabled = true;
			UpperAngle = 0;
			LowerAngle = 0;
		};
	};
	Neck = {"Hinge"};
}

local RagdollModule = {}

RagdollModule.RagdollCharacter = function(character, ignoreAttribute)
	if ignoreAttribute ~= true and not UserService:GetAttribute("RagdollOnDeath") then return end
	if not character or character:GetAttribute("DidRagdoll") then return end
	local rootPart = character.PrimaryPart
	if not rootPart then return end
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end
	character:SetAttribute("DidRagdoll", true)
	humanoid.Health = 0
	local nameTag = character:FindFirstChild("NameTag")
	if nameTag then
		nameTag:Destroy()
	end
	local torsoController = character:FindFirstChild("TorsoController")
	if torsoController then
		torsoController:Destroy()
	end
	rootPart.Anchored = true
	rootPart.CanCollide = false
	rootPart:BreakJoints()
	for _,desc in pairs(character:GetDescendants()) do
		if (desc:IsA("Motor6D") and JOINT_CONFIGURATION[desc.Name]) then
			local Joint = Instance.new(JOINT_CONFIGURATION[desc.Name][1] .. "Constraint")
			local Attachment0 = desc.Parent:FindFirstChild(desc.Name .. "Attachment") or desc.Parent:FindFirstChild(desc.Name .. "RigAttachment")
			local Attachment1 = desc.Part0:FindFirstChild(desc.Name .. "Attachment") or desc.Part0:FindFirstChild(desc.Name .. "RigAttachment")

			if (JOINT_CONFIGURATION[desc.Name].Properties) then
				for property,value in pairs(JOINT_CONFIGURATION[desc.Name].Properties) do
					Joint[property] = value
				end
			end

			if (Attachment0 and Attachment1) then
				Joint.Attachment0 = Attachment0
				Joint.Attachment1 = Attachment1
				Joint.Name = "RagdollConstraint" .. Attachment0.Name
				Joint.Parent = desc.Parent
				desc:Destroy()
			end
		elseif (desc:IsA("Attachment")) then
			desc.Axis = Vector3.new(0, 1, 0)
			desc.SecondaryAxis = Vector3.new(0, 0, 1)
			desc.Rotation = Vector3.new(0, 0, 0)
		end
	end
	shared.SetModelCollision(character, "Bodies", true)
	task.wait(2)--wait 2 seconds, then anchor everything.
	for _, part in pairs(character:GetChildren()) do 
		if part:IsA("BasePart") then
			part.Anchored = true
		end
	end
end

RagdollModule.CreateVFXRagdoll = function(character, ignoreAttribute)
	if ignoreAttribute ~= true and not UserService:GetAttribute("PersistentRagdolls") then return end
	if not (character and character.Parent and character:GetAttribute("DidRagdoll")) then return end
	
	character.Archivable = true
	local ragdoll = character:Clone()
	character.Archivable = false
	for attr, _ in pairs(ragdoll:GetAttributes()) do
		ragdoll:SetAttribute(attr, nil)
	end
	for _, child in pairs(ragdoll:GetChildren()) do
		if child:IsA("Script") or child:IsA("LocalScript") or child.Name == "CombatHighlight" then
			child:Destroy()
		end
	end
	ragdoll.Parent = RAGDOLL_CONTAINER
	task.delay(RAGDOLL_LIFETIME, function()
		if not (ragdoll and ragdoll.Parent) then return end
		ragdoll:Destroy()
	end)
end


return RagdollModule