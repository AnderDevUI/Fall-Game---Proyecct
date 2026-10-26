-- [PATH] ReplicatedStorage / Modules / AssetContainer @Type ModuleScript
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local IS_SERVER = RunService:IsServer()
local IS_STUDIO = RunService:IsStudio()

local CONFIG = table.freeze({
	RootName = "Remotes",
	Timeout = 30,
	NameKey = "5STcbH/8vz4robq9SnGbHQ==",
	NameLength = 20,
	PrintTokensInStudio = true,
})

local RATE_LIMIT = table.freeze({ Burst = 40, PerSecond = 20 })
local VALID_TYPES = table.freeze({ RemoteEvent = true, RemoteFunction = true })

local Groups

if IS_SERVER then
	Groups = {
	["BenchSystem"] = {
		{ Name = "BenchAction", Type = "RemoteEvent" },
		{ Name = "ContainerSession", Type = "RemoteEvent" },
		{ Name = "FilterText", Type = "RemoteFunction" },
		{ Name = "SyncBeds", Type = "RemoteEvent" },
		{ Name = "SyncBenchInfo", Type = "RemoteEvent" },
	},
	["BuildingSystem"] = {
		{ Name = "PlaceStructure", Type = "RemoteEvent" },
		{ Name = "StructureAction", Type = "RemoteEvent" },
	},
	["CombatSystem"] = {
		{ Name = "Attack", Type = "RemoteEvent" },
		{ Name = "HitRegistration", Type = "RemoteEvent" },
		{ Name = "Reload", Type = "RemoteEvent" },
		{ Name = "ToggleAttachment", Type = "RemoteEvent" },
	},
	["ContainerSystem"] = {
		{ Name = "ContainerSession", Type = "RemoteEvent" },
	},
	["CraftingSystem"] = {
		{ Name = "CraftQueueAction", Type = "RemoteEvent" },
		{ Name = "NearbyBenches", Type = "RemoteEvent" },
	},
	["ElectricitySystem"] = {
		{ Name = "EditConnection", Type = "RemoteEvent" },
		{ Name = "GetConnections", Type = "RemoteFunction" },
	},
	["EquipmentSystem"] = {
		{ Name = "EquipSlot", Type = "RemoteEvent" },
	},
	["InteractionSystem"] = {
		{ Name = "BenchAction", Type = "RemoteEvent" },
		{ Name = "DigAction", Type = "RemoteFunction" },
		{ Name = "DrinkWater", Type = "RemoteEvent" },
		{ Name = "NPCDialogue", Type = "RemoteEvent" },
		{ Name = "Pickup", Type = "RemoteEvent" },
		{ Name = "PlaceLock", Type = "RemoteEvent" },
	},
	["InventorySystem"] = {
		{ Name = "GetInitialState", Type = "RemoteFunction" },
		{ Name = "ItemAction", Type = "RemoteEvent" },
	},
	["LoadingSystem"] = {
		{ Name = "Preload", Type = "RemoteEvent" },
	},
	["PlayerStateSystem"] = {
		{ Name = "ConsumeItem", Type = "RemoteEvent" },
		{ Name = "DeathInfo", Type = "RemoteEvent" },
		{ Name = "PickupNotification", Type = "RemoteEvent" },
		{ Name = "RespawnAndDamage", Type = "RemoteEvent" },
		{ Name = "Revive", Type = "RemoteEvent" },
		{ Name = "SurfaceFromWater", Type = "RemoteEvent" },
		{ Name = "SyncStats", Type = "RemoteEvent" },
		{ Name = "UpdateWetness", Type = "RemoteEvent" },
	},
	["TeamSystem"] = {
		{ Name = "TeamAction", Type = "RemoteEvent" },
	},
}
end

local rootFolder
local registry = {}
local clientCache = {}
local handlers = {}
local buckets = {}
local initializationState = "Idle"

local function check(condition, message)
	if not condition then
		error("[AssetContainer] " .. message, 3)
	end
end

local function expectString(value, label)
	check(type(value) == "string" and value ~= "", label .. " debe ser un string no vacío")
end

local function sortedKeys(dictionary)
	local keys = {}
	for key in pairs(dictionary) do
		keys[#keys + 1] = key
	end
	table.sort(keys)
	return keys
end

-- ============================================================
-- OPAQUE NAMES: algorithm and output preserved exactly.
-- Do not change the key, alphabet, PRNG steps or path encoding.
-- ============================================================

local function encodePart(text)
	return tostring(#text) .. ":" .. text
end

local function groupPath(group)
	return "G" .. encodePart(group)
end

local function remotePath(group, name)
	return "R" .. encodePart(group) .. encodePart(name)
end

local function hash32(text)
	local value = 5381
	for index = 1, #text do
		value = bit32.bxor(
			(value * 33) % 4294967296,
			string.byte(text, index)
		)
	end
	if value == 0 then
		value = 1831565813
	end
	return value
end

local function nextState(state)
	state = bit32.bxor(state, bit32.lshift(state, 13))
	state = bit32.bxor(state, bit32.rshift(state, 17))
	state = bit32.bxor(state, bit32.lshift(state, 5))
	return state
end

local function opaqueName(path)
	local state = hash32(encodePart(CONFIG.NameKey) .. path)
	local parts = table.create(CONFIG.NameLength)
	local ascii = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()+,-.:;<=>?@[]^_{|}~"
	local replacement = utf8.char(0xFFFD)

	for index = 1, CONFIG.NameLength do
		state = nextState(state)
		local selection = state % 100
		state = nextState(state)

		if selection < 55 then
			parts[index] = replacement
		elseif selection < 85 then
			local position = (state % #ascii) + 1
			parts[index] = string.sub(ascii, position, position)
		else
			parts[index] = utf8.char(0x00A1 + (state % 94))
		end
	end
	return table.concat(parts)
end

local function toLiteral(text)
	local parts = table.create(#text)
	for index = 1, #text do
		parts[index] = string.format("\\%03d", string.byte(text, index))
	end
	return '"' .. table.concat(parts) .. '"'
end

-- ============================================================
-- ROOT / HIERARCHY
-- ============================================================

local function findUnique(parent, name)
	local found
	for _, child in parent:GetChildren() do
		if child.Name == name then
			check(found == nil, "Instancias duplicadas: " .. toLiteral(name))
			found = child
		end
	end
	return found
end

local function remaining(deadline)
	return math.max(0, deadline - os.clock())
end

local function waitUnique(parent, name, deadline)
	local found = findUnique(parent, name)
	if found then
		return found
	end

	local timeout = remaining(deadline)
	check(timeout > 0, "Tiempo de espera agotado: " .. toLiteral(name))
	found = parent:WaitForChild(name, timeout)
	check(found ~= nil, "Tiempo de espera agotado: " .. toLiteral(name))
	check(findUnique(parent, name) == found, "La instancia cambió durante la resolución")
	return found
end

local function getRoot(deadline)
	if rootFolder then
		check(
			rootFolder.Parent == ReplicatedStorage
				and rootFolder.Name == CONFIG.RootName
				and rootFolder.ClassName == "Folder",
			"El folder principal fue alterado"
		)
		return rootFolder
	end

	local found
	if IS_SERVER then
		found = findUnique(ReplicatedStorage, CONFIG.RootName)
	else
		found = waitUnique(
			ReplicatedStorage,
			CONFIG.RootName,
			deadline or (os.clock() + CONFIG.Timeout)
		)
	end

	check(found and found.ClassName == "Folder",
		"Debe existir ReplicatedStorage." .. CONFIG.RootName .. " como Folder")
	rootFolder = found
	return found
end

local function assertType(instance, className, label)
	check(instance.ClassName == className,
		label .. ": se esperaba " .. className .. ", existe " .. instance.ClassName)
end

local function getOrCreate(parent, className, name, created)
	local found = findUnique(parent, name)
	if found then
		assertType(found, className, "Instancia existente")
		return found
	end

	local instance = Instance.new(className)
	-- Track immediately so any subsequent failure can roll it back.
	created[#created + 1] = instance
	instance.Name = name
	check(instance.Name == name, "Roblox modificó el nombre asignado")
	instance.Parent = parent
	return instance
end

-- ============================================================
-- CONFIGURATION / INITIALIZATION
-- ============================================================

local function makePlan()
	local plan, usedNames = {}, {}

	local function reserve(name, path)
		check(usedNames[name] == nil,
			"Colisión de nombres entre " .. tostring(usedNames[name]) .. " y " .. path)
		usedNames[name] = path
	end

	for group, definitions in pairs(Groups) do
		expectString(group, "Nombre de grupo")
		check(type(definitions) == "table", "Configuración inválida en " .. group)

		-- Reject sparse arrays and dictionary fields instead of silently skipping them.
		local count = 0
		for index in pairs(definitions) do
			check(type(index) == "number" and index >= 1 and index % 1 == 0,
				"Las definiciones deben ser una lista continua: " .. group)
			count += 1
		end
		for index = 1, count do
			check(definitions[index] ~= nil, "Hay huecos en las definiciones de " .. group)
		end

		local path = groupPath(group)
		local folderName = opaqueName(path)
		check(folderName ~= group, "Grupo sin ofuscar: " .. group)
		reserve(folderName, path)

		local entry = { Name = folderName, Remotes = {} }
		for _, definition in ipairs(definitions) do
			check(type(definition) == "table", "Definición inválida en " .. group)
			local name = definition.Name
			local className = definition.Type or definition.Typ
			expectString(name, "Nombre de Remote")
			check(VALID_TYPES[className] == true, "Tipo no admitido en " .. group .. "." .. name)
			check(entry.Remotes[name] == nil, "Remote repetido: " .. group .. "." .. name)

			local pathKey = remotePath(group, name)
			local remoteName = opaqueName(pathKey)
			check(remoteName ~= name, "Remote sin ofuscar: " .. name)
			reserve(remoteName, pathKey)
			entry.Remotes[name] = { Name = remoteName, Type = className }
		end
		plan[group] = entry
	end
	return plan
end

local function verifyRegistry(candidate)
	local root = getRoot()
	check(findUnique(ReplicatedStorage, CONFIG.RootName) == root,
		"El folder principal no es único")

	for group, entry in pairs(candidate) do
		check(entry.Folder.Parent == root
			and entry.Folder.ClassName == "Folder"
			and entry.Folder.Name == entry.Name
			and findUnique(root, entry.Name) == entry.Folder,
			"Jerarquía incorrecta en " .. group)

		for name, item in pairs(entry.Remotes) do
			local instance = item.Instance
			check(instance.Parent == entry.Folder
				and instance.Name == item.Name
				and instance.ClassName == item.Type
				and findUnique(entry.Folder, item.Name) == instance,
				"Remote incorrecto: " .. group .. "." .. name)
		end
	end
	return true
end

local function preflight(root, plan)
	for _, entry in pairs(plan) do
		local folder = findUnique(root, entry.Name)
		if folder then
			assertType(folder, "Folder", "Grupo existente")
			for _, item in pairs(entry.Remotes) do
				local instance = findUnique(folder, item.Name)
				if instance then
					assertType(instance, item.Type, "Remote existente")
				end
			end
		end
	end
end

local function init()
	check(IS_SERVER, "Init solo está disponible en servidor")
	if initializationState == "Ready" then
		return verifyRegistry(registry)
	end
	check(initializationState == "Idle", "Inicialización reentrante")
	initializationState = "Building"

	local created = {}
	local ok, result = xpcall(function()
		local plan = makePlan()
		local root = getRoot()
		preflight(root, plan)

		local candidate = {}
		for _, group in ipairs(sortedKeys(plan)) do
			local definition = plan[group]
			local folder = getOrCreate(root, "Folder", definition.Name, created)
			local entry = { Folder = folder, Name = definition.Name, Remotes = {} }

			for _, name in ipairs(sortedKeys(definition.Remotes)) do
				local item = definition.Remotes[name]
				entry.Remotes[name] = {
					Instance = getOrCreate(folder, item.Type, item.Name, created),
					Name = item.Name,
					Type = item.Type,
				}
			end
			candidate[group] = entry
		end

		verifyRegistry(candidate)
		return candidate
	end, debug.traceback)

	if not ok then
		for index = #created, 1, -1 do
			pcall(function()
				created[index]:Destroy()
			end)
		end
		initializationState = "Idle"
		error(result, 0)
	end

	registry = result
	initializationState = "Ready"
	return true
end

local function serverEntry(group, name)
	expectString(group, "Grupo")
	expectString(name, "Remote")
	if initializationState ~= "Ready" then
		init()
	end

	local entry = registry[group]
	check(entry ~= nil, "Grupo desconocido: " .. group)
	local item = entry.Remotes[name]
	check(item ~= nil, "Remote desconocido: " .. group .. "." .. name)

	-- Constant-time checks on the requested path; full scans only in Init/Verify.
	local root = getRoot()
	check(entry.Folder.Parent == root and entry.Folder.Name == entry.Name,
		"El grupo fue alterado: " .. group)
	check(item.Instance.Parent == entry.Folder
		and item.Instance.Name == item.Name
		and item.Instance.ClassName == item.Type,
		"El Remote fue alterado: " .. group .. "." .. name)
	return entry, item
end

local function printTokens()
	if initializationState ~= "Ready" then
		init()
	end
	verifyRegistry(registry)
	for _, group in ipairs(sortedKeys(registry)) do
		local entry = registry[group]
		for _, name in ipairs(sortedKeys(entry.Remotes)) do
			local item = entry.Remotes[name]
			print(("-- %s.%s (%s)\nlocal GROUP = %s\nlocal TOKEN = %s"):format(
				group, name, item.Type, toLiteral(entry.Name), toLiteral(item.Name)
				))
		end
	end
end

-- ============================================================
-- CLIENT RESOLUTION: opaque tokens only, with lazy cache eviction.
-- ============================================================

local function clientRemote(groupToken, remoteToken)
	expectString(groupToken, "Token de grupo")
	expectString(remoteToken, "Token de Remote")
	local deadline = os.clock() + CONFIG.Timeout
	local root = getRoot(deadline)
	local cached = clientCache[groupToken]

	if cached and (cached.Folder.Parent ~= root or cached.Folder.Name ~= groupToken) then
		clientCache[groupToken] = nil
		cached = nil
	end

	if cached then
		local remote = cached.Remotes[remoteToken]
		if remote and remote.Parent == cached.Folder
			and remote.Name == remoteToken and VALID_TYPES[remote.ClassName] then
			return remote
		end
		cached.Remotes[remoteToken] = nil
	end

	local folder = cached and cached.Folder or waitUnique(root, groupToken, deadline)
	assertType(folder, "Folder", "Grupo cifrado")
	local remote = waitUnique(folder, remoteToken, deadline)
	check(VALID_TYPES[remote.ClassName] == true, "El objeto cifrado no es un Remote válido")
	check(folder.Parent == root and folder.Name == groupToken
		and remote.Parent == folder and remote.Name == remoteToken,
		"La jerarquía cambió durante la resolución")

	if not cached then
		cached = { Folder = folder, Remotes = {} }
		clientCache[groupToken] = cached
	end
	cached.Remotes[remoteToken] = remote
	return remote
end

-- ============================================================
-- SERVER HANDLERS / TOKEN BUCKET
-- ============================================================

local function allow(player, remote)
	if player.Parent ~= Players then
		return false
	end
	local now = os.clock()
	local user = buckets[player]
	if not user then
		user = {}
		buckets[player] = user
	end
	local bucket = user[remote]
	if not bucket then
		bucket = { Tokens = RATE_LIMIT.Burst, Time = now }
		user[remote] = bucket
	end
	bucket.Tokens = math.min(RATE_LIMIT.Burst,
		bucket.Tokens + math.max(0, now - bucket.Time) * RATE_LIMIT.PerSecond)
	bucket.Time = now
	if bucket.Tokens < 1 then
		return false
	end
	bucket.Tokens -= 1
	return true
end

local function connectServer(remote, callback, validator)
	check(type(callback) == "function", "Se esperaba un callback")
	check(type(validator) == "function", "Se requiere un validador del servidor")
	local previous = handlers[remote]
	check(not previous or not previous.Connected, "Este Remote ya tiene un handler registrado")

	local lastWarning = -math.huge
	local function accepts(player, ...)
		if not allow(player, remote) then
			return false
		end
		local ok, valid = pcall(validator, player, ...)
		if not ok then
			local now = os.clock()
			if IS_STUDIO and now - lastWarning >= 5 then
				lastWarning = now
				warn("[AssetContainer] Error en validador: " .. tostring(valid))
			end
			return false
		end
		-- A yielding validator may return after the player has left.
		return valid == true and player.Parent == Players
	end

	if remote:IsA("RemoteEvent") then
		local connection = remote.OnServerEvent:Connect(function(player, ...)
			if accepts(player, ...) then
				callback(player, ...)
			end
		end)
		handlers[remote] = connection
		return connection
	end

	assertType(remote, "RemoteFunction", "Handler")
	-- OnServerInvoke is assigned, never read. Handler ownership is internal.
	-- Register this RemoteFunction through AssetContainer only.
	local connection = { Connected = true }
	remote.OnServerInvoke = function(player, ...)
		if connection.Connected and accepts(player, ...) and connection.Connected then
			return callback(player, ...)
		end
		return nil
	end

	function connection:Disconnect()
		if not self.Connected then
			return
		end
		self.Connected = false
		if handlers[remote] == self then
			remote.OnServerInvoke = nil
			handlers[remote] = nil
		end
	end
	connection.Destroy = connection.Disconnect
	handlers[remote] = connection
	return connection
end

if IS_SERVER then
	Players.PlayerRemoving:Connect(function(player)
		buckets[player] = nil
	end)
end

-- ============================================================
-- DISPATCH: existing actions, arguments and bootstrap preserved.
-- ============================================================

local SERVER_ACTIONS = table.freeze({
	Get = true, GetName = true, GetTokens = true,
	OnServer = true, Setup = true,
	FireClient = true, FireAllClients = true,
})
local CLIENT_ACTIONS = table.freeze({ Get = true, Setup = true, Fire = true })

local function dispatch(action, first, second, ...)
	expectString(action, "Acción")
	if IS_SERVER then
		if action == "Init" then
			return init()
		elseif action == "Verify" then
			if initializationState ~= "Ready" then
				init()
			end
			return verifyRegistry(registry)
		elseif action == "PrintTokens" then
			printTokens()
			return
		end
		check(SERVER_ACTIONS[action] == true, "Acción de servidor desconocida: " .. action)
		local entry, item = serverEntry(first, second)
		local remote = item.Instance

		if action == "Get" then
			return remote
		elseif action == "GetName" then
			return item.Name
		elseif action == "GetTokens" then
			return entry.Name, item.Name
		elseif action == "OnServer" or action == "Setup" then
			local callback, validator = ...
			return connectServer(remote, callback, validator)
		elseif action == "FireClient" then
			assertType(remote, "RemoteEvent", "FireClient")
			local player = select(1, ...)
			check(typeof(player) == "Instance" and player:IsA("Player"),
				"FireClient requiere un Player")
			remote:FireClient(player, select(2, ...))
			return
		elseif action == "FireAllClients" then
			assertType(remote, "RemoteEvent", "FireAllClients")
			remote:FireAllClients(...)
			return
		end
	end

	check(CLIENT_ACTIONS[action] == true, "Acción de cliente desconocida: " .. action)
	if action == "Setup" then
		check(type(select(1, ...)) == "function", "Setup requiere un callback")
	end
	local remote = clientRemote(first, second)
	if action == "Get" then
		return remote
	elseif action == "Setup" then
		assertType(remote, "RemoteEvent", "Setup en cliente")
		local callback = select(1, ...)
		return remote.OnClientEvent:Connect(callback)
	elseif action == "Fire" then
		if remote:IsA("RemoteEvent") then
			remote:FireServer(...)
			return
		end
		return remote:InvokeServer(...)
	end
end

if IS_SERVER then
	init()
	if CONFIG.PrintTokensInStudio and IS_STUDIO then
		printTokens()
	end
end

-- Bootstrap parameters remain accepted and are not credentials.
return function(...)
	return dispatch
end
