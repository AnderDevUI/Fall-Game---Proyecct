-- [PATH] ServerScriptService / Server / PlayerService @Type ModuleScript
-- ModuleScript: ServerScriptService.Server.PlayerService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

Players.CharacterAutoLoads = false

local Modules = ReplicatedStorage:WaitForChild("Modules")
local Library = ServerScriptService:WaitForChild("Library")

local CONSTANTS = require(Library:WaitForChild("CONSTANTS"))
local Asset = require(Modules:WaitForChild("AssetContainer"))()

local PlayerDataService = require(script.Parent.PlayerDataService)

local RESPAWN_SECONDS = 3

local PlayerService = {}

local started = false
local ready: { [Player]: boolean } = {}
local sessions = {}

-- DuelService puede reemplazar esta función.
-- true impide el respawn automático después de morir.
PlayerService.HoldRespawn = function(_player: Player): boolean
	return false
end

-- =========================================================
-- UTILIDADES
-- =========================================================

local function isFiniteNumber(value)
	return type(value) == "number"
		and value == value
		and value > -math.huge
		and value < math.huge
end

local function isCurrentSession(player, session)
	return player.Parent == Players
		and sessions[player] == session
end

local function hasLivingCharacter(player)
	local character = player.Character

	if not character or not character.Parent then
		return false
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	return humanoid ~= nil and humanoid.Health > 0
end

-- Prioridad:
-- 1. Un BasePart llamado HubSpawn.
-- 2. El primer SpawnLocation habilitado.
local function hubSpawn(): BasePart?
	local explicitSpawn = workspace:FindFirstChild("HubSpawn", true)

	if explicitSpawn and explicitSpawn:IsA("BasePart") then
		return explicitSpawn
	end

	for _, instance in workspace:GetDescendants() do
		if instance:IsA("SpawnLocation") and instance.Enabled then
			return instance
		end
	end

	return nil
end

-- =========================================================
-- CARGA MANUAL DEL PERSONAJE
-- =========================================================

function PlayerService.LoadCharacter(player: Player)
	local session = sessions[player]

	if not session
		or not isCurrentSession(player, session)
		or not ready[player]
		or session.Loading then
		return nil
	end

	session.Loading = true

	local ok, result = xpcall(function()
		-- Sin descripción personalizada.
		player:LoadCharacterAsync()

		if not isCurrentSession(player, session) then
			return nil
		end

		return player.Character
	end, debug.traceback)

	session.Loading = false

	if not ok then
		warn(
			("[PlayerService] No se pudo crear el personaje de %s:\n%s")
				:format(player.Name, tostring(result))
		)

		return nil
	end

	return result
end

function PlayerService.Spawn(player: Player)
	local session = sessions[player]

	if not session
		or not isCurrentSession(player, session)
		or not ready[player]
		or session.Loading then
		return nil
	end

	local character = PlayerService.LoadCharacter(player)

	if not character
		or not isCurrentSession(player, session)
		or player.Character ~= character
		or not character.Parent then
		return nil
	end

	local spawnPart = hubSpawn()

	if spawnPart then
		local offset = CFrame.new(
			math.random(-6, 6),
			spawnPart.Size.Y / 2 + 4,
			math.random(-6, 6)
		)

		character:PivotTo(spawnPart.CFrame * offset)
	end

	return character
end

-- =========================================================
-- PRIMER SPAWN: DATOS + PANTALLA DE CARGA
-- =========================================================

local function tryInitialSpawn(player, session)
	if not isCurrentSession(player, session)
		or not session.DataLoaded
		or not session.PreloadComplete
		or session.InitialSpawnRequested then
		return
	end

	session.InitialSpawnRequested = true
	ready[player] = true

	task.spawn(function()
		if not isCurrentSession(player, session) then
			return
		end

		if hasLivingCharacter(player) then
			return
		end

		local character = PlayerService.Spawn(player)

		if not character and isCurrentSession(player, session) then
			-- Permite otro intento si llega una nueva señal válida.
			session.InitialSpawnRequested = false
		end
	end)
end

-- =========================================================
-- CICLO DE VIDA DEL PERSONAJE
-- =========================================================

local function onCharacterAdded(player, session, character)
	if not isCurrentSession(player, session)
		or session.Character == character then
		return
	end

	session.Character = character

	if session.DeathConnection then
		session.DeathConnection:Disconnect()
		session.DeathConnection = nil
	end

	local humanoid = character:WaitForChild("Humanoid", 15)

	if not humanoid
		or not humanoid:IsA("Humanoid")
		or not isCurrentSession(player, session)
		or player.Character ~= character then
		return
	end

	humanoid.MaxHealth = CONSTANTS.BASE_HEALTH
	humanoid.Health = CONSTANTS.BASE_HEALTH

	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff

	local deathHandled = false

	local function onDied()
		if deathHandled then
			return
		end

		deathHandled = true

		task.delay(RESPAWN_SECONDS, function()
			if not isCurrentSession(player, session)
				or not ready[player]
				or player.Character ~= character then
				return
			end

			if PlayerService.HoldRespawn(player) then
				return
			end

			PlayerService.Spawn(player)
		end)
	end

	session.DeathConnection = humanoid.Died:Connect(onDied)

	if humanoid.Health <= 0 then
		onDied()
	end
end

-- =========================================================
-- REGISTRO DE JUGADORES
-- =========================================================

local function registerPlayer(player)
	local existing = sessions[player]

	if existing then
		return existing
	end

	if player.Parent ~= Players then
		return nil
	end

	local session = {
		DataLoaded = false,
		PreloadComplete = false,
		InitialSpawnRequested = false,
		Loading = false,

		Character = nil,
		CharacterConnection = nil,
		DeathConnection = nil,
	}

	sessions[player] = session

	session.CharacterConnection = player.CharacterAdded:Connect(function(character)
		onCharacterAdded(player, session, character)
	end)

	if player.Character then
		task.spawn(
			onCharacterAdded,
			player,
			session,
			player.Character
		)
	end

	return session
end

local function setupPlayer(player: Player, _data: { [string]: any })
	local session = registerPlayer(player)

	if not session then
		return
	end

	session.DataLoaded = true

	tryInitialSpawn(player, session)
end

local function removePlayer(player)
	local session = sessions[player]

	-- Invalida primero las tareas pendientes.
	sessions[player] = nil
	ready[player] = nil

	if not session then
		return
	end

	if session.CharacterConnection then
		session.CharacterConnection:Disconnect()
		session.CharacterConnection = nil
	end

	if session.DeathConnection then
		session.DeathConnection:Disconnect()
		session.DeathConnection = nil
	end
end

-- =========================================================
-- INICIO
-- =========================================================

function PlayerService.Start()
	if started then
		return
	end

	started = true
	Players.CharacterAutoLoads = false

	PlayerDataService.Loaded:Connect(setupPlayer)
	Players.PlayerRemoving:Connect(removePlayer)

	Asset("Setup","LoadingSystem","Preload", function(player, _clientTime, _clientClock, userId)
			local session = registerPlayer(player)

			if not session then
				return
			end

			-- La variante con UserId corresponde a una comprobación,
			-- no al cierre de la pantalla de carga.
			if userId ~= nil then
				return
			end

			session.PreloadComplete = true

			tryInitialSpawn(player, session)
		end,

		function(player, ...)
			local count = select("#", ...)

			if count ~= 2 and count ~= 3 then
				return false
			end

			local clientTime, clientClock, userId = ...

			if not isFiniteNumber(clientTime)
				or not isFiniteNumber(clientClock) then
				return false
			end

			if userId ~= nil and userId ~= player.UserId then
				return false
			end

			return true
		end
	)
	

	
	Asset("Setup","InventorySystem","GetInitialState", function(player)
		local session = registerPlayer(player)

		if not session then
			return
		end

     return {},{},{}
	end,

	function()
		return true
	end
	)

	local function onPlayerAdded(player)
		local session = registerPlayer(player)

		if not session then
			return
		end

		-- También cubre datos cargados antes de iniciar este servicio.
		local data = PlayerDataService.Get(player)

		if data ~= nil then
			setupPlayer(player, data)
		end
	end

	Players.PlayerAdded:Connect(onPlayerAdded)

	for _, player in Players:GetPlayers() do
		onPlayerAdded(player)
	end
end

return PlayerService