-- [PATH] ServerStorage / a @Type Script
client = nil;
service = nil;
cPcall = nil;
Pcall = nil;
Routine = nil;
GetEnv = nil;
origEnv = nil;
logError = nil;
return function()
	local Player = service.Players.LocalPlayer;
	local v2 = tostring(getfenv);
	local u1 = nil;
	local l__client__2 = client;
	local u3 = nil;
	local u4 = nil;
	local u5 = nil;
	local l__service__6 = service;
	getfenv().client = nil;
	getfenv().service = nil;
	getfenv().script = nil;
	local NetworkClient = service.NetworkClient;
	local SendRemote = client.Remote.Send;
	local Disconnect = client.Disconnect;
	local Kill = client.Kill;
	local v3 = getfenv();
	local v4, v5 = pcall(function()
		return game:________();
	end);
	local function u14(p1, p2, p3)
		if NetworkClient and p1 ~= "_" then
			pcall(SendRemote, "Detected", p1, p2);
			wait(0.5);
			if p1 == "kick" then
				if not l__service__6.RunService:IsStudio() then
					if p3 then
						Player:Kick(p2);
					else
						Disconnect(p2);
					end;
				end;
			elseif p1 == "crash" then
				Kill(p2);
			end;
		end;
		return true;
	end;
	local u15 = v4;
	local u17 = v5;
	local u18 = v3;
	local l__Kick__19 = Player.Kick;
	Routine(function()
		while wait(5) do
			if not u14("_", "_", true) then
				while true do

				end;
			end;
			if not (not u15) or not rawequal(u15, u15) or not rawequal(u17, u17) or not (not rawequal(u17, "new")) or u17 ~= u17 or u17 == "new" or not (not rawequal(u18, { 1 })) or (u18 == { 1 } or u18 ~= u18) then
				u14("crash", "Tamper Protection 658947");
				wait(1);
				pcall(Disconnect, "Adonis_658947");
				pcall(Kill, "Adonis_658947");
				pcall(l__Kick__19, Player, "Adonis_658947");
			end;
			if xpcall(function()
					return game:________();
				end, function()

				end) then
				u14("crash", "Tamper Protection 906287");
				wait(1);
				pcall(Disconnect, "Adonis_906287");
				pcall(Kill, "Adonis_906287");
				pcall(l__Kick__19, Player, "Adonis_906287");
			end;
			local v6, v7 = pcall(function()
				return game:________();
			end);
			if v6 ~= u15 or u17 ~= v7 then
				u14("kick", "Methamethod tampering 456456");
			end;
			local u24 = false;
			coroutine.wrap(function()
				local v8, v9 = pcall(l__service__6.UnWrap(Player).Kick, l__service__6.UnWrap(workspace), "If this appears, you have a glitch. Method 1");
				if v8 or not string.match(v9, "Expected ':' not '.' calling member function Kick") then
					u14("kick", "Anti kick found! Method 1");
				end;
				u24 = true;
			end)();
			coroutine.wrap(function()
				task.wait(4);
				if not u24 then
					u14("kick", "Anti kick found! Method 3");
				end;
				local v10, v11 = pcall(l__service__6.UnWrap(workspace).GetRealPhysicsFPS, l__service__6.UnWrap(game));
				if v10 or not string.match(v11, "Expected ':' not '.' calling member function GetRealPhysicsFPS") then
					u14("kick", "Anti FPS detection found!");
				end;
			end)();		
		end;
	end);
	u18 = l__service__6.ReadOnly;
	u15 = {};
	u17 = function(p4)
		l__service__6.StartLoop("AntiSpeed", 1, function()
			if tonumber(p4.Speed) < workspace:GetRealPhysicsFPS() then
				u14("kill", "Speed exploiting");
			end;
		end);
	end;
	u15.Speed = u17;
	u17 = function()
		l__service__6.Player.DescendantAdded:Connect(function(p5)
			if p5:IsA("GuiMain") or p5:IsA("PlayerGui") and rawequal(p5.Parent, l__service__6.PlayerGui) and not u1.Get(p5) then
				p5:Destroy();
				u14("log", "Unknown GUI detected and destroyed: " .. p5.Name);
			end;
		end);
	end;
	u15.AntiGui = u17;
	u17 = function()
		if l__service__6.Player:WaitForChild("Backpack", 120) then
			local function v12(p6)
				if (p6:IsA("Tool") or p6.ClassName == "HopperBin") and not p6:FindFirstChild(u4.CodeName) and l__client__2.AntiBuildingTools and p6.ClassName == "HopperBin" and (not (not rawequal(p6.BinType, Enum.BinType.Grab)) or not (not rawequal(p6.BinType, Enum.BinType.Clone)) or not (not rawequal(p6.BinType, Enum.BinType.Hammer)) or rawequal(p6.BinType, Enum.BinType.GameTool)) then
					p6.Active = false;
					p6:Destroy();
					u14("log", "HopperBin Detected (BTools)");
				end;
			end;
			for v13, v14 in pairs(l__service__6.Player.Backpack:GetChildren()) do
				v12(v14);
			end;
			l__service__6.Player.Backpack.ChildAdded:Connect(v12);
		end;
	end;
	u15.AntiTools = u17;
	u17 = function()
		wait(1);
		local v15 = l__service__6.Player.Character:WaitForChild("Humanoid", 2) or l__service__6.Player.Character:FindFirstChildOfClass("Humanoid");
		if v15 then
			local u28 = true;
			local u29 = nil;
			u29 = v15.StateChanged:Connect(function(p7, p8)
				if not u28 then
					u29:Disconnect();
				end;
				if rawequal(p8, Enum.HumanoidStateType.StrafingNoPhysics) and u28 then
					u28 = false;
					u14("kill", "NoClipping");
					u29:Disconnect();
				end;
			end);
			while v15 and v15.Parent and v15.Parent.Parent and u28 do
				if not wait(0.1) then
					break;
				end;
				if rawequal(v15:GetState(), Enum.HumanoidStateType.StrafingNoPhysics) and u28 then
					u28 = false;
					u14("kill", "NoClipping");
				end;			
			end;
		end;
	end;
	u15.HumanoidState = u17;
	u17 = function()
		local v16 = time();
		local v17 = l__service__6.ReadOnly({
			FriendStatus = true, 
			ImageButton = false, 
			ButtonHoverText = true, 
			HoverMid = true, 
			HoverLeft = true, 
			HoverRight = true, 
			ButtonHoverTextLabel = true, 
			Icon = true, 
			ImageLabel = true, 
			NameLabel = true, 
			Players = true, 
			ColumnValue = true, 
			ColumnName = true, 
			Frame = false, 
			StatText = false
		});
		local blacklistedMessages = { "current identity is 0", "gui made by kujo", "tetanus reloaded hooked", "hookmetamethod", "hookfunction", "HttpGet", "^Chunk %w+, at Line %d+", "syn%.", "newcclosure" };
		local u38 = select(2, pcall(l__service__6.RunService.IsStudio, l__service__6.RunService));
		local l__FindService__39 = l__service__6.DataModel.FindService;
		local l__DataModel__40 = l__service__6.DataModel;
		local u42 = {};
		l__service__6.Events.CharacterRemoving:Connect(function()
			for v19, v20 in next, u42 do
				if v17[v19] then
					u42[v19] = 0;
				end;
			end;
		end);
		local function soundCheck(sound)
			for _, id in pairs( { 5032588119 }) do
				if sound.SoundId then
					if string.find(string.lower(tostring(sound.SoundId)), tostring(id)) then
						return true;
					end;
					if sound.SoundId == tostring(id) then
						return true;
					end;
				end;
			end;
			return false;
		end;
		game.PolicyService.ChildAdded:Connect(function(child)
			if child:IsA("Sound") then
				if not soundCheck(child) then
					wait();
					if soundCheck(child) then
						u14("crash", "CMDx Detected; " .. tostring(child));
					end;
					return;
				end;
			else
				return;
			end;
			u14("crash", "CMDx Detected; " .. tostring(child));
		end);
		local function checkMessage(p13)
			for index, message in pairs(blacklistedMessages) do
				if string.find(string.lower(p13), string.lower(v24)) then
					return true;
				end;
				if string.match(p13, v24) and not string.find(string.lower(p13), "failed to load") then
					return true;
				end;
			end;
		end;
		l__service__6.LogService.MessageOut:Connect(function(p14)
			if checkMessage(p14) then
				u14("crash", "Exploit detected; " .. p14);
			end;
		end);
		l__service__6.ScriptContext.Error:Connect(function(p15, p16, p17)
			local v25 = tostring(p15);
			local v26 = tostring(p16);
			local v27 = tostring(p17);
			if v27 and v27 == "tpircsnaisyle" then
				u14("kick", "Elysian Detected");
				return;
			end;
			if not (not u44(v25)) or not (not u44(v26)) or u44(v27) then
				u14("crash", "Exploit detected; " .. v25 .. " " .. v26 .. " " .. v27);
				return;
			end;
			if not v27 or not v26 or v26 == "" then
				local v28 = l__service__6.LogService:GetLogHistory();
				local v29 = false;
				if v27 then
					for v30, v31 in next, v28 do
						if v31.message == v25 and v28[v30 + 1] and v28[v30 + 1].message == v26 then
							v29 = true;
						end;
					end;
				else
					v29 = true;
				end;
				if v29 then
					if not string.match(v26, "CoreGui") then
						if not (not string.match(v26, "PlayerScripts")) or not (not string.match(v26, "Animation_Scripts")) or string.match(v26, "^(%S*)%.(%S*)") then
							return;
						end;
						u14("log", "Traceless/Scriptless error");
					else
						return;
					end;
				end;
			end;
		end);
		local u45 = v16;
		l__service__6.RunService.Stepped:Connect(function()
			u45 = time();
		end);
		if l__service__6.Player:WaitForChild("Backpack", 120) then
			l__service__6.Player.Backpack.ChildAdded:Connect(function(p18)
				if (p18:IsA("Tool") or p18.ClassName == "HopperBin") and not p18:FindFirstChild(u4.CodeName) and (l__service__6.Player:FindFirstChild("Backpack") and p18:IsDescendantOf(l__service__6.Player.Backpack) and p18.ClassName == "HopperBin") and (not (not rawequal(p18.BinType, Enum.BinType.Grab)) or not (not rawequal(p18.BinType, Enum.BinType.Clone)) or not (not rawequal(p18.BinType, Enum.BinType.Hammer)) or rawequal(p18.BinType, Enum.BinType.GameTool)) then
					u14("log", "Building Tools detected; " .. tostring(p18.BinType));
				end;
			end);
		end;
		l__service__6.StartLoop("Detection", 10, function()
			if l__service__6.Player.Parent ~= l__service__6.Players then
				u14("crash", "Parent not players");
			end;
			local v32, v33 = pcall(function()
				l__service__6.ScriptContext.Name = "ScriptContext";
			end);
			if not v32 then
				u14("log", "ScriptContext error?");
			end;
			local v34 = l__service__6.LogService:GetLogHistory();
			if not v34[1] then
				l__client__2.OldPrint(" ");
				l__client__2.OldPrint(" ");
				v34 = l__service__6.LogService:GetLogHistory();
				local v35 = v34[1];
			end;
			for v36, v37 in ipairs(v34) do
				if u44(v37.message) then
					u14("crash", "Exploit detected; " .. v37.message);
				end;
			end;
		end);
	end;
	u15.MainDetection = u17;
	u17 = false;
	u18 = u18(u15, u17, true);
	u15 = function(p19, p20)
		if u3.Detectors[p19] and l__service__6.NetworkClient then
			u3.Detectors[p19](p20);
		end;
	end;
	u17 = l__service__6.ReadOnly;
	local v44 = {
		LastChanges = {
			Lighting = {}
		}, 
		Init = function()
			u1 = l__client__2.UI;
			u3 = l__client__2.Anti;
			u4 = l__client__2.Variables;
			u5 = l__client__2.Process;
			u3.Init = nil;
		end, 
		RunLast = function()
			u3.RunLast = nil;
		end, 
		Launch = u15, 
		Detected = u14, 
		Detectors = u18
	};
	function v44.GetClassName(p21)
		local u47 = tostring(math.random() .. math.random());
		local v45, v46 = pcall(function()
			local v47 = p21[u47];
		end);
		if v46 then
			local v48 = string.match(v46, u47 .. " is not a valid member of (.*)");
			if v48 then
				return v48;
			end;
		end;
	end;
	function v44.RLocked(p22)
		return not pcall(function()
			return p22:GetFullName();
		end);
	end;
	function v44.CoreRLocked(p23)
		local u48 = tostring(math.random() .. math.random());
		local v49, v50 = pcall(function()
			game:GetService("GuiService"):AddSelectionParent(u48, p23);
			game:GetService("GuiService"):RemoveSelectionGroup(u48);
		end);
		if v50 and string.find(v50, u48) and string.find(v50, "GuiService:") then
			return true;
		end;
		wait(0.5);
		local v51, v52 = l__service__6.LogService:GetLogHistory();
		while true do
			local v53, v54 = next(v51, v52);
			if not v53 then
				break;
			end;
			v52 = v53;
			if string.find(v54.message, u48) and string.find(v54.message, "GuiService:") then
				return true;
			end;		
		end;
	end;
	u17 = u17(v44, {
		Init = true, 
		RunLast = true, 
		RunAfterLoaded = true
	}, true);
	u3 = u17;
	l__client__2.Anti = u3;
	u17 = l__service__6.MetaFunc;
	local v55 = u17(time);
	local u49 = u17(wait);
	local l__Core__50 = client.Core;
	local l__Remote__51 = client.Remote;
	local l__Functions__52 = client.Functions;
	local l__Get__53 = client.Remote.Get;
	local u54 = u17(pcall);
	u17(l__service__6.TrackTask)("Thread: TableCheck", u17(function()
		while u49(1) do
			local v56, v57, v58, v59, v60, v61, v62, v63, v64, v65 = coroutine.resume(coroutine.create(function()
				return l__client__2.Core, l__client__2.Remote, l__client__2.Functions, l__client__2.Anti, l__client__2.Remote.Send, l__client__2.Remote.Get, l__client__2.Anti.Detected, l__client__2.Disconnect, l__client__2.Kill;
			end));
			if not v56 or v57 ~= l__Core__50 or v58 ~= l__Remote__51 or v59 ~= l__Functions__52 or v60 ~= u3 or v61 ~= SendRemote or v62 ~= l__Get__53 or v63 ~= u14 or v64 ~= Disconnect or v65 ~= Kill then
				u54(u14, "crash", "Tamper Protection 10042");
				u49(1);
				u54(Disconnect, "Adonis_10042");
				u54(Kill, "Adonis_10042");
				u54(l__Kick__19, Player, "Adonis_10042");
			end;		
		end;
	end));
end;