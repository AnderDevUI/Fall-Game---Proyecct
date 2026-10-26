-- [PATH] ServerStorage / Modules / AnimalInfo @Type ModuleScript
local AnimalInfo = {}

AnimalInfo.Spawns = {
	
}

AnimalInfo.Deer = {
	--Stats
	Health = 150;
	RunSpeed = 18;
	DashSpeed = 22;
	
	Aggressive = false;
	
	--Distance Ranges
	ActivationRange = 250;
	SpookRange = 60; --If aggressive spook range will be either used to aggro, or they will always run if they are below 20% hp and spooked
	RunRange = 50;
	
	--Part/Bone Names for script
	RootBone = "Deer_ROOTSHJnt";
	MoveBone = "Deer_Spine_03SHJnt"; --This move bone is used for when the animal dies, the HRP gets placed overtop of this bone, and expanded
	Body = "deer_body";
	
	DeadRootSize = Vector3.new(2, 2, 4)
}

AnimalInfo.WildBoar = {
	--Stats
	Health = 150;
	RunSpeed = 18;
	DashSpeed = 22;
	
	Aggressive = true;
	Confident = false; --This variable is used for when the player is fighting the animal, if the animal is not confident then it will run away during fights, confident animals will still run away when low hp
	AttackRange = 10;
	AttackTime = 2;
	Damage = 11;
	Bleed = 2;
	
	--Distance Ranges
	ActivationRange = 250;
	SpookRange = 50; --If aggressive spook range will be either used to aggro, or they will always run if they are below 20% hp and spooked. Essentially making runrange ineffective when the animal is aggressive, spookrange overrides.
	RunRange = 50;
	

	--Part/Bone Names for script
	RootBone = "WildBoar_ROOTSHJnt";
	MoveBone = "WildBoar_Spine_03SHJnt"; --This move bone is used for when the animal dies, the HRP gets placed overtop of this bone, and expanded
	Body = "RootPart";
	
	DeadRootSize = Vector3.new(2, 2, 4)
}

return AnimalInfo