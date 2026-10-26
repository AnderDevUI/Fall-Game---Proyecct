-- [PATH] ReplicatedStorage / Modules / VectorUtil @Type ModuleScript
--[[
	VectorUtil
	by ChickenBagelz
	July 3, 2023
	
	Allows communication between localscripts and the FallenGuard Actor instance inside the Player
]]

--------------------------------------------------------------------------------------- LURAPH MACROS
LPH_OBFUSCATED = false -- Will be set to true automatically when the script is obfuscated
if not LPH_OBFUSCATED then
	LPH_CRASH = function(...) return ... end -- Crashes and scrambles the script, making code basically unusable
	LPH_NO_VIRTUALIZE = function(...) return ... end -- Prevents the function provided from being obfuscated 
	LPH_JIT_MAX = function(...) return ... end -- Puts more aggressive and risky optimizations to the function provided
end
---------------------------------------------------------------------------------------

-- Services
local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local TextChat = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local Http = game:GetService("HttpService")
local Run = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local Gui = game:GetService("GuiService")
local Stat = game:GetService("Stats")

-- Folders
local Remotes = Replicated:WaitForChild("Remotes")
local Values = Replicated:WaitForChild("Values")
local Modules = Replicated:WaitForChild("Modules")

-- Modules
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"))

local cachedMouseRaycast = RaycastUtil.MouseRaycast

-- Player Variables
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerScripts = Player:WaitForChild("PlayerScripts")

-- Anticheat

--local FallenGuard = PlayerScripts:WaitForChild("FallenGuard")
local FallenGuard, FireRemoteBindable, SetupRemoteBindable, MockFireRemoteBindable
while true do
	FallenGuard = PlayerScripts:FindFirstChild("FallenGuard")
	FireRemoteBindable = TextChat:FindFirstChild("1")
	SetupRemoteBindable = TextChat:FindFirstChild("2")
	MockFireRemoteBindable = TextChat:FindFirstChild("3")
	if FallenGuard and FireRemoteBindable and SetupRemoteBindable and MockFireRemoteBindable then break end
	task.wait()
end
local debugMode = false--(FallenGuard.WorldPivot ~= CFrame.new())

-- Local Variables
local storedBindables = {}
local lastChecked = 0
local currentHumanoid
local index, namecall
local cachedIndexMetamethod, cachedNamecallMetamethod, cachedNewindexMetamethod
local cached
local checkIndex
local isWindowFocused = false
local weakLoopStarted

-- Functions
local MakeError = function(err)
	local num = math.random(1, 3)
	if num == 1 then
		local errorInstance = Instance.new("Sky")
		errorInstance.Name = err
		errorInstance._ = 0
	elseif num == 2 then
		assert(false, err)
	end
	error(err)
end

local trapArg = newproxy(true)
local trapMetaTable = getmetatable(trapArg)
local trapArgTriggered
for index, metamethod in pairs({"le", "lt", "eq", "tostring", "pow", "div", "mul", "sub", "add", "unm", "concat", "call", "index", "newindex"}) do
	trapMetaTable["__"..metamethod] = function()
		trapArgTriggered = index
		if rawequal(metamethod, "tostring") then
			return ""
		end
	end
end
trapMetaTable.__metatable = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

local FireRemote = LPH_JIT_MAX(function(self, ...)
	local args = {...}
	local gotBanned = false
	if pcall(settings) then
		args = {0}
		gotBanned = true
	elseif trapArgTriggered then
		StarterGui:SetAttribute("r", Http:JSONEncode({trapArgTriggered})) -- 089
		trapArgTriggered = false
		gotBanned = true
	else
		local fenv0 = getfenv(0)
		local fenv1 = getfenv(1)
		if rawequal(fenv0.script, fenv1.script) then
			args = {1}
			gotBanned = true
		elseif os.clock() - lastChecked >= 10 then
			
			lastChecked = os.clock()
			
			local noCheckIndex = (checkIndex == nil)
			checkIndex = (noCheckIndex and 0 or (checkIndex >= 5 and 1 or checkIndex + 1))
			
			if checkIndex == 1 or noCheckIndex then
				local fenv = getfenv()
				for index, value in pairs(fenv._G) do
					StarterGui:SetAttribute("s", Http:JSONEncode({index}))
					gotBanned = true
					break
				end
				for index, value in pairs(fenv.shared) do
					if not (rawequal(index, "ActiveBenches") or rawequal(index, "Beds") or rawequal(index, "LastTextBoxFocused")) then
						StarterGui:SetAttribute("s", Http:JSONEncode({index}))
						gotBanned = true
						break
					end
				end
				if not (currentHumanoid and currentHumanoid.Parent) then
					local character = Player.Character
					if character then
						currentHumanoid = character:FindFirstChildOfClass("Humanoid")
					end
				end
				if currentHumanoid and currentHumanoid.Parent then
					local prop = "q"
					local suc1, err1 = pcall(function()
						prop = currentHumanoid[trapArg]
					end)
					if suc1 or prop ~= "q" or not (err1:find("VectorUtil") and err1:find("invalid argument #2") and err1:find("string expected, got userdata")) then
						StarterGui:SetAttribute("a", Http:JSONEncode({err1}))
						gotBanned = true
					end
				end
			end
			if checkIndex == 2 or noCheckIndex then
				local testInstance = Instance.new("Texture")
				testInstance.Name = "Humanoid"
				testInstance.Parent = game.Lighting
				local humProps = {"WalkSpeed", "JumpHeight", "HipHeight"}
				for index, value in pairs(humProps) do
					local prop = "q"
					local suc1, err1 = pcall(function()
						prop = testInstance[value]
					end)
					if testInstance.ClassName ~= "Texture" or suc1 or prop ~= "q" or err1:find("VectorUtil") or not (err1:find(value) and err1:find("is not a valid member of") and err1:find("Texture") and err1:find("Lighting.Humanoid")) then
						StarterGui:SetAttribute("b", Http:JSONEncode({err1, index}))
						gotBanned = true
						break
					end
					local suc2, err2 = pcall(function()
						testInstance[value] = 0
					end)
					if suc2 or err2:find("VectorUtil") or not (err2:find(value) and err2:find("is not a valid member of") and err2:find("Texture") and err2:find("Lighting.Humanoid")) then
						StarterGui:SetAttribute("c", Http:JSONEncode({err2, index}))
						gotBanned = true
						break
					end
				end
				local fireSuc, fireErr = pcall(function()
					testInstance:FireServer()
					return true
				end)
				if fireSuc or type(fireErr) ~= "string" or fireErr:find("VectorUtil") or not (fireErr:find("FireServer") and fireErr:find("is not a valid member of") and fireErr:find("Texture") and fireErr:find("Lighting.Humanoid")) then
					StarterGui:SetAttribute("d", Http:JSONEncode({fireErr}))
					gotBanned = true
				end
				testInstance:Destroy()
			end
			if checkIndex == 3 or noCheckIndex then
				local indexMethodSuc, indexMethodRet = xpcall(function()
					return game.WalkSpeed
				end, LPH_JIT_MAX(function() -- formerly nothing
					local indexMethodSource, indexMethodLine, indexMethodFunc = debug.info(2, "slf")
					if not cachedIndexMetamethod then
						cachedIndexMetamethod = indexMethodFunc
					end
					local indexMismatch = (indexMethodFunc ~= cachedIndexMetamethod)
					local indexType = type(indexMethodFunc)
					if indexMethodSource ~= "[C]" or indexMethodLine ~= -1 or indexMismatch or indexType ~= "function" then
						StarterGui:SetAttribute("e", Http:JSONEncode({indexMismatch and "true" or "false", indexMethodSource, indexMethodLine, indexType}))
						gotBanned = true
						return
					end
					local prop = "q"
					local suc1, err1 = pcall(function()
						prop = indexMethodFunc()
					end)
					if suc1 or prop ~= "q" or not (err1:find("VectorUtil") and err1:find("missing argument #1") and err1:find("Instance expected)")) then
						StarterGui:SetAttribute("f", Http:JSONEncode({err1 or "N/A", 1}))
						gotBanned = true
						return
					end
					local suc2, err2 = pcall(function()
						prop = indexMethodFunc(game)
					end)
					if suc2 or prop ~= "q" or not (err2:find("VectorUtil") and err2:find("missing argument #2") and err2:find("string expected)")) then
						StarterGui:SetAttribute("f", Http:JSONEncode({err2 or "N/A", 2}))
						gotBanned = true
						return
					end
					local suc3, err3 = pcall(function()
						prop = indexMethodFunc(nil, "Parent")
					end)
					if suc3 or prop ~= "q" or not (err3:find("VectorUtil") and err3:find("invalid argument #1") and err3:find("Instance expected, got nil")) then
						StarterGui:SetAttribute("f", Http:JSONEncode({err3 or "N/A", 3}))
						gotBanned = true
						return
					end
					local extra
					local suc4, err4 = pcall(function()
						prop, extra = indexMethodFunc(game.Lighting, "TimeOfDay", trapArg)
					end)
					if (not suc4) or prop == "q" or err4 or type(prop) ~= "string" or extra ~= nil then
						StarterGui:SetAttribute("f", Http:JSONEncode({err4 or "N/A", 4}))
						gotBanned = true
						return
					end
					local indexMethodParamCount, indexMethodIsVariadic = debug.info(2, "a")
					if indexMethodParamCount ~= 0 or not indexMethodIsVariadic then
						StarterGui:SetAttribute("g", Http:JSONEncode({indexMethodParamCount, indexMethodIsVariadic and "true" or "false"}))
						gotBanned = true
					end
				end))
				if indexMethodSuc or indexMethodRet ~= nil then
					StarterGui:SetAttribute("h", Http:JSONEncode({2}))
					gotBanned = true
				end
			end
			if checkIndex == 4 or noCheckIndex then
				local namecallMethodSuc, namecallMethodRet = xpcall(function()
					return game:FireServer()
				end, LPH_JIT_MAX(function() -- fomerly nothing
				--[[local fenvsuc, fenverr = pcall(getfenv, 7)
				if fenvsuc or not fenverr:find("invalid argument #1 to 'getfenv' (invalid level)") then
					local gooned = #Ban;
					goonedExtras = {fenverr};
					(Ban.."110")[string.char(gooned)]();
					return
				end]]
					local namecallMethodSource, namecallMethodLine, namecallMethodFunc = debug.info(2, "slf")
					if not cachedNamecallMetamethod then
						cachedNamecallMetamethod = namecallMethodFunc
					end
					local namecallMismatch = (namecallMethodFunc ~= cachedNamecallMetamethod)
					local namecallType = type(namecallMethodFunc)
					if namecallMethodSource ~= "[C]" or namecallMethodLine ~= -1 or namecallMismatch or namecallType ~= "function" then
						StarterGui:SetAttribute("i", Http:JSONEncode({namecallMismatch and "true" or "false", namecallMethodSource, namecallMethodLine, namecallType}))
						gotBanned = true
						return
					end
					local suc1, err1 = pcall(function()
						namecallMethodFunc()
						return true
					end)
					local suc5, err5 = pcall(function()
						if LPH_OBFUSCATED then
							namecallMethodFunc(Replicated.LoadingScreen, "FireServer", trapArg)
						else
							namecallMethodFunc(Replicated.LoadingScreen, trapArg)
						end
					end)
					if (not suc5) or err5 ~= nil then
						StarterGui:SetAttribute("j", Http:JSONEncode({err5 or "N/A", 5}))
						gotBanned = true
						return
					end
					if suc1 or type(err1) ~= "string" or not (err1:find("VectorUtil") and err1:find("missing argument #1") and err1:find("Instance expected)")) then
						StarterGui:SetAttribute("j", Http:JSONEncode({err1 or "N/A", 1}))
						gotBanned = true
						return
					end
					local remote = Remotes:FindFirstChildWhichIsA("RemoteEvent", true)
					local suc2, err2 = pcall(function()
						namecallMethodFunc(remote)
						return true
					end)
					if LPH_OBFUSCATED then
						if suc2 or type(err2) ~= "string" or not (err2:find("VectorUtil") and err2:find("missing argument #2") and err2:find("string expected)")) then
							StarterGui:SetAttribute("j", Http:JSONEncode({err2 or "N/A", 2}))
							gotBanned = true
							return
						end
					else
						if suc2 or type(err2) ~= "string" or not rawequal(err2, "Argument 1 missing or nil") then
							StarterGui:SetAttribute("j", Http:JSONEncode({err2 or "N/A", 2}))
							gotBanned = true
							return
						end
					end
					local suc3, err3 = pcall(function()
						namecallMethodFunc(trapArg, "FireServer")
					end)
					if suc3 or type(err3) ~= "string" or not (err3:find("VectorUtil") and err3:find("invalid argument #1") and err3:find("Instance expected, got userdata")) then
						StarterGui:SetAttribute("j", Http:JSONEncode({err3 or "N/A", 3}))
						gotBanned = true
						return
					end
					local suc4, err4 = pcall(function()
						namecallMethodFunc(Replicated.LoadingScreen, trapArg)
					end)
					if LPH_OBFUSCATED then
						if suc4 or type(err4) ~= "string" or not (err4:find("VectorUtil") and err4:find("invalid argument #2") and err4:find("string expected, got userdata")) then
							StarterGui:SetAttribute("j", Http:JSONEncode({err4 or "N/A", 4}))
							gotBanned = true
							return
						end
					else
						if suc4 or type(err4) ~= "string" or err4:find("VectorUtil") or not rawequal(err4, "Unable to cast value to std::string") then
							StarterGui:SetAttribute("j", Http:JSONEncode({err4 or "N/A", 4}))
							gotBanned = true
							return
						end
					end
					local namecallMethodParamCount, namecallMethodIsVariadic = debug.info(2, "a")
					if namecallMethodParamCount ~= 0 or not namecallMethodIsVariadic then
						StarterGui:SetAttribute("k", Http:JSONEncode({namecallMethodParamCount, namecallMethodIsVariadic and "true" or "false"}))
						gotBanned = true
						return
					end
					local _, fenv5 = pcall(getfenv, 5)
					local _, fenv6 = pcall(getfenv, 6)
					if type(fenv5) ~= "table" or type(fenv6) ~= "table" or getfenv(5).script ~= script or getfenv(6).script ~= script then
						StarterGui:SetAttribute("l", Http:JSONEncode({}))
						gotBanned = true
					end
				end))
				if namecallMethodSuc or namecallMethodRet ~= nil then
					StarterGui:SetAttribute("h", Http:JSONEncode({3}))
					gotBanned = true
				end
			end
			if checkIndex == 5 or noCheckIndex then
				local newindexMethodSuc, newindexMethodRet = xpcall(function()
					game.WalkSpeed = 0
					return true
				end, LPH_JIT_MAX(function()
					local newindexMethodSource, newindexMethodLine, newindexMethodFunc = debug.info(2, "slf")
					if not cachedNewindexMetamethod then
						cachedNewindexMetamethod = newindexMethodFunc
					end
					local newindexMismatch = (newindexMethodFunc ~= cachedNewindexMetamethod)
					local newindexType = type(newindexMethodFunc)
					if newindexMethodSource ~= "[C]" or newindexMethodLine ~= -1 or newindexMismatch or newindexType ~= "function" then
						--[[local gooned = #Ban;
						goonedExtras = {newindexMismatch and "true" or "false", newindexMethodSource, newindexMethodLine, newindexType};
						(Ban..("098"))[string.char(gooned)]();]]
						StarterGui:SetAttribute("t", Http:JSONEncode({newindexMismatch and "true" or "false", newindexMethodSource, newindexMethodLine, newindexType}))
						gotBanned = true
						return
					end
					local suc1, err1 = pcall(function()
						newindexMethodFunc()
						return true
					end)
					if suc1 or type(err1) ~= "string" or not (err1:find("VectorUtil") and err1:find("missing argument #1") and err1:find("Instance expected)")) then
						StarterGui:SetAttribute("t", Http:JSONEncode({err1 or "N/A", 1}))
						gotBanned = true
						return
					end
					local suc2, err2 = pcall(function()
						newindexMethodFunc(game)
						return true
					end)
					if suc2 or type(err2) ~= "string" or not (err2:find("VectorUtil") and err2:find("missing argument #2") and err2:find("string expected)")) then
						StarterGui:SetAttribute("t", Http:JSONEncode({err2 or "N/A", 2}))
						gotBanned = true
						return
					end
					local suc3, err3 = pcall(function()
						newindexMethodFunc(trapArg)
						return true
					end)
					if suc3 or type(err3) ~= "string" or not (err3:find("VectorUtil") and err3:find("invalid argument #1") and err3:find("Instance expected, got userdata")) then
						StarterGui:SetAttribute("t", Http:JSONEncode({err3 or "N/A", 3}))
						gotBanned = true
						return
					end
					local suc4, err4 = pcall(function()
						newindexMethodFunc(nil, "WalkSpeed", 17)
						return true
					end)
					if suc4 or type(err4) ~= "string" or not (err4:find("VectorUtil") and err4:find("invalid argument #1") and err4:find("Instance expected, got nil")) then
						StarterGui:SetAttribute("t", Http:JSONEncode({err4 or "N/A", 4}))
						gotBanned = true
						return
					end
					local extra
					local suc5, err5 = pcall(function()
						extra = newindexMethodFunc(workspace, "Name", "Workspace ", trapArg)
					end)
					if (not suc5) or extra ~= nil or err5 ~= nil or workspace.Name ~= "Workspace " then
						StarterGui:SetAttribute("t", Http:JSONEncode({err5 or "N/A", 5}))
						gotBanned = true
						return
					end
					local newindexMethodParamCount, newindexMethodIsVariadic = debug.info(2, "a")
					if newindexMethodParamCount ~= 0 or not newindexMethodIsVariadic then
						StarterGui:SetAttribute("u", Http:JSONEncode({newindexMethodParamCount, newindexMethodIsVariadic and "true" or "false"}))
						gotBanned = true
						return
					end
				end))
				if newindexMethodSuc or newindexMethodRet ~= nil then
					--[[local gooned = #Ban;
					goonedExtras = {1};
					(Ban..("097"))[string.char(gooned)]();]]
					StarterGui:SetAttribute("h", Http:JSONEncode({1}))
					gotBanned = true
					return
				end
			end
		end
	end
	if not args[4] then
		MockFireRemoteBindable:Fire(unpack(args))
		FallenGuard:SendMessage("__"..game.PlaceVersion, unpack(args))
		if gotBanned then
			LPH_CRASH()
		end
		return
	end
	local suc, ret = pcall(function()
		return {FireRemoteBindable:Invoke(unpack(args))}
	end)
	if suc and ret[1] ~= "-/|" then
		if LPH_OBFUSCATED then
			LPH_CRASH()
		else
			warn("ANTICHEAT REMOTEFUNCTION FAILED TO RETURN ARGUMENTS PROPERLY; IF OBFUSCATED, FALLENGUARD WOULD'VE CRASHED (DON'T FORGET TO PASS 'true' AS 4TH ARGUMENT WHEN DOING VectorUtil:FireRemote)", args, ret)
		end
	elseif gotBanned then
		LPH_CRASH()
	end
 	return unpack((type(ret) == "table" and ret or {}), 2)
end)

--------------------------------------------------------------------------------------- MEMORY/GC CHECKS
local canUseCollectGarbage = pcall(function()
	collectgarbage("count")
end)
local gcThreadCount = 4
local gcLastThreadCountChecked = 0
local gcThreadCountFailedAmount = 0
local gcThread = task.defer(LPH_JIT_MAX(function()
	while Values.Loading.Value do task.wait(0.1) gcThreadCount = gcThreadCount + 1 end
	local started = tick()
	repeat task.wait(0.1) gcThreadCount = gcThreadCount + 1 until game:IsLoaded() or tick() - started >= 45
	task.wait(2)
	local lastTimeDetected = 0
	local detects = 0
	local lastDetects = 0
	local thresholds = {}
	local threshold = 19000.5
	if not canUseCollectGarbage then
		warn("collectgarbage() errored. Check if it has been fully deprecated?")
	end
	local lastGC = 0
	local matchingGCCounts = 0
	local lowestGC = math.huge
	local highestGC = 0
	local unchangedGCCount = 0
	local lastTimeMemoryDiffFired = 0
	local lastMemoryDiffs = 0
	local memoryDiffs = 0
	local unmatchingGCCGCounts = 0
	local lastGCStrainCheck = 0
	started = tick()
	while Run.RenderStepped:Wait() do
		local cg
		local gc = gcinfo()
		if canUseCollectGarbage then
			cg = collectgarbage("count")
			if math.abs(cg - gc) > 0 then
				unmatchingGCCGCounts = unmatchingGCCGCounts + 1
				if unmatchingGCCGCounts >= 10 then
					StarterGui:SetAttribute("m", Http:JSONEncode({gc, cg}))
					break
				end
			else
				unmatchingGCCGCounts = 0
			end
		end
		--[[OBF
		local sameDiff = math.abs(gc - gcinfo())
		if sameDiff > 1 then
			local gooned = #Ban;
			goonedExtras = {sameDiff};
			(Ban.."043")[string.char(gooned)]();
			task.wait(1)
		end]]
		local first = math.max(gc, (canUseCollectGarbage and cg or 0))
		if math.abs(first - lastGC) <= 2 then
			lowestGC = math.min(lowestGC, first)
			highestGC = math.max(highestGC, first)
			matchingGCCounts = matchingGCCounts + 1
			if matchingGCCounts >= 100 then
				StarterGui:SetAttribute("n", Http:JSONEncode({lastGC, lowestGC, highestGC}))
				break
			elseif matchingGCCounts >= 75 then
				--warn("MATCHING GC COUNTS >= 75%:", matchingGCCounts, first, lastGC, lowestGC, highestGC)
			end
		else
			matchingGCCounts = 0
			lowestGC = math.huge
			highestGC = 0
			lastGC = first
		end
		if tick() - lastGCStrainCheck >= 0.5 then
			lastGCStrainCheck = tick()
			local a = gcinfo()
			local t = {}
			table.insert(t, {{{}}})
			for i = 1, 100 do
				table.insert(t[1][1], math.random(1, 100) * math.sin(i))
			end
			table.remove(t[1], 1)
			table.remove(t, 1)
			unchangedGCCount = (math.abs(gcinfo() - a) == 0 and unchangedGCCount + 1 or 0)
			if unchangedGCCount >= 30 then
				StarterGui:SetAttribute("o", Http:JSONEncode({}))
				break
			elseif unchangedGCCount >= 15 then
				--warn("UNCHANGED GC COUNTS >= 50%:", unchangedGCCount)
			end
		end
		--[[
		local lowestMemory = math.huge
		local highestMemory = 0
		local totalMemory = 0
		for i = 1, 100 do
			local memory = Stats:GetTotalMemoryUsageMb()
			totalMemory = totalMemory + memory
			highestMemory = math.max(highestMemory, memory)
			lowestMemory = math.min(lowestMemory, memory)
		end
		local avgMemory = totalMemory / 100
		local d1 = math.abs(avgMemory - lowestMemory)
		local d2 = math.abs(avgMemory - highestMemory)
		if (d1 >= 0.01 and d1 <= 5) and (d2 >= 0.01 and d2 <= 5) then
			memoryDiffs = memoryDiffs + 1
			if tick() - lastTimeMemoryDiffFired >= 120 then
				lastTimeMemoryDiffFired = tick()
				Thread.Delay(5, function()
					local a = lastMemoryDiffs
					lastMemoryDiffs = memoryDiffs
					Ban("050", memoryDiffs - a, memoryDiffs)
				end)
			end
		end]]
		task.wait(0.1)
		local new = math.max(gcinfo(), (canUseCollectGarbage and collectgarbage("count") or 0))
		local diff = new - first
		if thresholds and diff > 2 and tick() - started >= 15 then
			table.insert(thresholds, diff)
			local added = 0
			for _, v in pairs(thresholds) do
				added = added + v
			end
		end
		if thresholds and #thresholds >= 50 then
			local added = 0
			for _, v in pairs(thresholds) do
				added = added + v
			end
			threshold = math.clamp(math.ceil(added / #thresholds * 15), 15000, 20000)
			--print("GC CLIENT SET THRESHOLD: "..threshold)
			thresholds = nil
		end

		if diff >= threshold * 0.5 then
			--warn("GC SPIKE: >= 50% OF THRESHOLD REACHED", diff, threshold)
		end
		if diff > threshold then
			StarterGui:SetAttribute("q", Http:JSONEncode({diff, threshold}))
			break
		end
		--[[detects = detects + 1
		if tick() - lastTimeDetected >= 5 then
			lastTimeDetected = tick()
			warn("MEMORY SPIKE DETECTED: WENT PAST THRESHOLD. DETECTIONS:", detects)
			lastDetects = detects
		end]]
		gcThreadCount = gcThreadCount + 1
	end
	LPH_CRASH()
end))

----------------------------------------------------------------------------------------- CONNECTIONS
task.spawn(function()
	local thread = coroutine.running()
	local con1 = UserInput.InputChanged:Connect(function()
		coroutine.resume(thread)
	end)
	local con2 = UserInput.WindowFocused:Connect(function()
		coroutine.resume(thread)
	end)
	coroutine.yield()
	con1:Disconnect()
	con2:Disconnect()
	isWindowFocused = true
	UserInput.WindowFocused:Connect(function()
		isWindowFocused = true
	end)
	UserInput.WindowFocusReleased:Connect(function()
		isWindowFocused = false
	end)
end)

local lastTableYields = {}
local WeakTableYield = LPH_NO_VIRTUALIZE(function()
	local indicatorValue = {}
	local indicatorTable = setmetatable({indicatorValue}, {__mode = "kv"})
	indicatorValue = nil
	repeat
		if weakLoopStarted and not isWindowFocused then
			weakLoopStarted = os.clock()
		end
		lastTableYields = {rawlen(indicatorTable), table.maxn(indicatorTable)}
		wait(0.11)
	until rawlen(indicatorTable) == 0 or not rawget(indicatorTable, 1) or table.maxn(indicatorTable) == 0
end)

local checkThread
local SetupRemote = function(self, folder, remoteName, func)
	if debugMode then
		print("SETTING UP REMOTE", folder, remoteName)
	end
	local folderBindables = storedBindables[folder]
	if not folderBindables then
		folderBindables = {}
		storedBindables[folder] = folderBindables
	end
	local bindable = folderBindables[remoteName]
	if bindable then
		bindable:Destroy()
	end
	bindable = Instance.new("BindableEvent")
	bindable.Event:Connect(func)
	folderBindables[remoteName] = bindable
	SetupRemoteBindable:Fire(folder, remoteName, bindable)
	if remoteName ~= string.char(139, 69, 112, 34, 135, 187, 185, 110, 102, 27, 11, 71, 142, 94, 63, 149, 48, 11, 174, 74, 123, 167, 169, 90, 182, 183, 188, 116, 61, 158) then return end
	if debugMode then
		print("STARTING MODULE CHECKS")
	end
	local indexFunc
	xpcall(function()
		return game.OHNOGG
	end, function()
		indexFunc = debug.info(2, "f")
	end)
	local checksLOL = {
		[1] = {function() return rawequal() end, "VectorUtil", ": missing argument #1"},
		[2] = {function() return rawequal("a") end, "VectorUtil", ": missing argument #2"},
		[3] = {function() return getmetatable() end, "VectorUtil", ": missing argument #1"},
		[4] = {function() return setmetatable() end, "VectorUtil", ": missing argument #1 to", "setmetatable", "table expected"},
		[5] = {function() return setmetatable("") end, "VectorUtil", ": invalid argument #1 to", "setmetatable", "table expected, got string"},
		[6] = {function() return setmetatable({}) end, "VectorUtil", ": missing argument #2 to", "setmetatable", "nil or table expected"},
		[7] = {function() return setmetatable({}, "") end, "VectorUtil", ": invalid argument #2 to", "setmetatable", "nil or table expected, got string"},
		[8] = {function() return task.spawn({}) end, "VectorUtil", ": invalid argument #1 to", "spawn", "function or thread expected"},
		[9] = {function() return task.defer({}) end, "VectorUtil", ": invalid argument #1 to", "defer", "function or thread expected"},
		[10] = {function() return task.delay() end, "VectorUtil", ": invalid argument #2 to", "delay", "function or thread expected"},
		[11] = {function() return task.delay({}) end, "VectorUtil", ": invalid argument #1 to", "delay", "number expected, got table"},
		[12] = {function() return newproxy(trapArg) end, "VectorUtil", ": invalid argument #1 to", "newproxy", "nil or boolean expected, got userdata"},
		--[13] = {function() return rawequal(game:GetService("MessageBusService").Call, plugin) end, "The current thread cannot access", "MessageBusService", "lacking capability", "RobloxScript"},
	}
	local function findin(str, t)
		local last = 0
		for i, v in pairs(t) do
			local pos = string.find(str, v)
			if (not pos) or last > pos then
				return false
			end
			last = pos
		end
		return true
	end
	local blah = 0
	local weakDetections = 0
	local LoopChecks = LPH_JIT_MAX(function()
		local character = Player.Character
		Stat.Name = "Stats  " -- 2
		local walkspeed, jumpheight, hipheight, primCF
		if character then
			local hum = character:FindFirstChildOfClass("Humanoid")
			Stat.Name = "Stats   " -- 3
			if hum then
				walkspeed, jumpheight, hipheight = hum.WalkSpeed, hum.JumpHeight, hum.HipHeight
			end
			Stat.Name = "Stats    " -- 4
			local primPart = character.PrimaryPart
			if primPart then
				primCF = primPart.CFrame
			end
			Stat.Name = "Stats     " -- 5
			if hum then
				local suc2, err2 = pcall(function()
					hum[trapArg] = 0
				end)
				if suc2 or not (err2:find("VectorUtil") and err2:find("invalid argument #2") and err2:find("string expected, got userdata")) then
					MakeError("HD_8 "..(err2 or "N/A").."0")
				end
				local suc3, err3 = pcall(function()
					hum.Parent = trapArg
				end)
				if suc3 or not (hum.Parent and hum.Parent == character and err3:find("VectorUtil") and err3:find("invalid argument #3") and err3:find("Instance expected, got userdata")) then
					MakeError("HD_9 "..(err3 or "N/A")..hum:GetFullName())
				end
			end
		end
		Stat.Name = "Stats      " -- 6
		gcinfo()
		collectgarbage("count")
		math.random()
		Stat.Name = "Stats       " -- 7
		local suc1, err1 = pcall(function() error("oh") end)
		if suc1 or not err1:find("oh") then
			MakeError("HD_1")
		end
		Stat.Name = "Stats        " -- 8
		local suc2, ret2 = xpcall(function() local _ = game._ end, function() 
			local source, line, functio = debug.info(2, "slf")
			return (source == "[C]" and line == -1 and functio == indexFunc)
		end)
		if suc2 or ret2 ~= true then
			MakeError("HD_2")
		end
		Stat.Name = "Stats         " -- 9
		local a = newproxy(true)
		if type(a) ~= "userdata" or getmetatable(a) == nil then
			MakeError("HD_3")
		end 
		Stat.Name = "Stats          " -- 10
		local b = getfenv()
		if type(b) ~= "table" or b.script ~= script then
			MakeError("HD_4")
		end
		Stat.Name = "Stats           " -- 11
		blah = blah + 1
		if blah >= 3 then
			for index, check in pairs(checksLOL) do
				local suc, ret = pcall(check[1])
				if suc or type(ret) ~= "string" or not findin(ret, {select(2, unpack(check))}) then
					--[[local gooned = #Ban;
					goonedExtras = {(ret == nil and "N/A" or ret), index};
					(Ban..("083"))[string.char(gooned)]();
					return]]
					MakeError("HD_5 "..(ret == nil and "N/A" or tostring(ret))..index)
				end
			end
			blah = 0
		end
		Stat.Name = "Stats            " -- 12
		--print(gcThreadCount, gcLastThreadCountChecked, gcThreadCountFailedAmount)
		if coroutine.status(gcThread) ~= "running" and coroutine.status(gcThread) ~= "suspended" then
			MakeError("HD_6")
		elseif math.abs(gcThreadCount - gcLastThreadCountChecked) <= 1 then
			if not LPH_OBFUSCATED then
				--print(gcThreadCount, gcLastThreadCountChecked)
			end
			gcThreadCountFailedAmount = gcThreadCountFailedAmount + 1
			if gcThreadCountFailedAmount >= 9 then
				MakeError("HD_7")
			end
		else
			gcThreadCountFailedAmount = 0
		end
		gcLastThreadCountChecked = gcThreadCount
		Stat.Name = "Stats             " -- 13
		if cachedMouseRaycast ~= RaycastUtil.MouseRaycast then
			MakeError("CH1")
		end
		Stat.Name = "Stats"
		return {walkspeed, jumpheight, hipheight, primCF}
	end)
	if checkThread then
		--warn("CANCELLING THREAD")
		task.cancel(checkThread)
	end
	--print("STARTING THREAD")
	checkThread = task.spawn(function()
		local checkServices = {
			"ServerScriptService",
			"CoreGui",
			"MessageBusService",
			"TimerService",
			"VideoCaptureService",
			"HttpRbxApiService",
			"NotificationService",
			"MaterialService",
			"StarterPlayer",
			"GeometryService",
			"CookiesService",
			"MouseService",
			"SolidModelContentProvider",
			"HSRDataContentProvider",
			"MeshContentProvider",
			"NetworkClient",
			"AssetService",
			"ServerStorage",
			"StarterPack",
			"JointsService",
			"PhysicsService",
			"InsertService",
			"KeyboardService",
			"MemStorageService",
			"PermissionsService",
			"VirtualInputManager",
			"test",
			"LogService",
			"test2",
			"TeleportService",
			"ScriptService",
			"BrowserService",
			"Teams",
			"AdService",
			"SharedTableRegistry",
			--"ReplicatedFirst",
			--"ContentProvider",
			--"LocalizationService",
			--"Stats",
			--"UserInputService",
			--"ContextActionService",
			--"Players",
			--"RunService",
			--"GuiService",
		}
		local loopSuc, loopErr = pcall(function()
			local doErr
			repeat
				Stat.Name = "Stats " -- 1
				if game:IsLoaded() and not weakLoopStarted then
					--print("weaktable started")
					weakLoopStarted = os.clock()
					task.defer(function()
						local _, weakErr = pcall(function()
							local weakTable = setmetatable({}, {__mode = "v"})
							for _, serviceName in pairs(checkServices) do
								local instance
								if serviceName == "test" then
									instance = workspace:FindFirstChild("BenchSpawnGroups")
								elseif serviceName == "test2" then
									instance = game:FindFirstChildWhichIsA("ClientReplicator")
								else
									instance = game:GetService(serviceName)
								end
								weakTable[#weakTable + 1] = instance
								instance = nil
							end
							WeakTableYield()
							if rawlen(weakTable) ~= 0 or rawget(weakTable, 1) or table.maxn(weakTable) ~= 0 then
								task.wait(3)
							end
							local maxIndex = table.maxn(weakTable)
							local didIncrease = false
							for i, value in pairs(weakTable) do
								if value ~= nil and i < rawlen(checkServices) - 2 then
									local _, valueName = pcall(function()
										return value:GetFullName()
									end)
									if i == 1 and rawlen(weakTable) == 34 and maxIndex == 34 and valueName == "ServerScriptService" then
										weakDetections = weakDetections + 1
										didIncrease = true
										if weakDetections < 3 then break end
									end
									StarterGui:SetAttribute("p", Http:JSONEncode({valueName, i.."/"..rawlen(weakTable).."/"..maxIndex}))
									break
								end
							end
							if not didIncrease then
								weakDetections = 0
							end
							weakLoopStarted = nil
							--print("weak loop ended")
						end)
						if weakErr then
							doErr = weakErr
						end
					end)
				end
				if doErr then
					MakeError(doErr)
				elseif weakLoopStarted and os.clock() - weakLoopStarted > 60 then
					--print("hello from Chicken", math.floor(os.clock() - weakLoopStarted))
					MakeError(`WLPERR{lastTableYields[1]}/{lastTableYields[2]}`)
				end
				game:SetAttribute("1", math.ceil(workspace:GetServerTimeNow()))
				local suc, err = pcall(LoopChecks)
				local walkspeed, jumpheight, hipheight, primCF
				if suc then
					walkspeed, jumpheight, hipheight, primCF = unpack(err)
					err = nil
				end
				if FallenGuard.Parent then
					FallenGuard:SendMessage("_"..game.JobId, indexFunc, walkspeed, jumpheight, hipheight, Stat:GetTotalMemoryUsageMb(), workspace.Gravity, Camera.CFrame, primCF, err)
				end
				if debugMode then
					print("loop ended", gcThreadCount, gcThreadCountFailedAmount)
				end
				task.wait(5)
			until 6 == 7
		end)
		game:SetAttribute("ass", loopErr)
	end)
end

return LPH_NO_VIRTUALIZE(function() 
	local VectorUtil = {}
	
	local fireRemote = function(...)
		return FireRemote(...)
	end
	VectorUtil.FireRemote = fireRemote
	
	local setupRemote = function(...)
		return SetupRemote(...)
	end
	VectorUtil.SetupRemote = SetupRemote

	return VectorUtil
end)()