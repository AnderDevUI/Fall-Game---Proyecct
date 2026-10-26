-- [PATH] ServerScriptService / Server / PlayerDataService @Type ModuleScript
-- Player data: load, save, and the replication PlayerDataController expects.
--
--   Remotes.Data.RequestPlayerData:InvokeServer()  -> { Data = { [field] = value } }
--   Remotes.Data.PlayerDataChanged:FireClient(player, <enum "DataValueChanged">, field, value)
--   Remotes.Data.PlayerDataChanged:FireClient(player, <enum "SettingChanged">, name, value, profile)
--
-- ClientPlayerData is a ReplicatedClass built with compression off, so field names travel as
-- plain strings; only the change type goes through EnumLibrary, whose FromEnum asserts on
-- anything it does not know.
--
-- Saving goes through ProfileStore (session lock, autosave, shutdown). The live data stays a
-- plain decoded table; profile.Data only gets its SparseCodec-packed copy right before each save.

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Modules = ReplicatedStorage:WaitForChild("Modules")
local Library = ServerScriptService:WaitForChild("Library")
local EnumLibrary = require(Library:WaitForChild("EnumLibrary"))
local SettingsLibrary = require(Library:WaitForChild("SettingsLibrary"))
local Signal = require(Library:WaitForChild("Signal"))
-- Tables with gaps in their keys (EquippedEmotes) are packed for remotes and the DataStore.
local SparseCodec = require(Library:WaitForChild("SparseCodec"))
local ProfileStore = require(ServerScriptService:WaitForChild("ServerPackages"):WaitForChild("ProfileStore"))

local DataTemplate = require(script.Parent.DataTemplate)

--local DataRemotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Data")

local STORE_NAME = "PlayerData_v2"
-- Plain SetAsync saves from before ProfileStore; read once to seed a player's new profile.
local LEGACY_STORE_NAME = "PlayerData_v1"

local PlayerDataService = {}

-- Fired with (player, data) once a player's data is in place.
PlayerDataService.Loaded = Signal.new()

local store = nil
-- Profile is nil when the session could not be started: the player keeps a blank profile
-- that is never saved, so it can't overwrite the real one.
local Profiles: { [Player]: { Data: { [string]: any }, Profile: any } } = {}

local function keyFor(player: Player): string
	return "Player_" .. player.UserId
end

local function enum(name: string): string
	EnumLibrary:WaitForEnumBuilder()
	return EnumLibrary:ToEnum(name)
end

-- ComplianceController reads data.PolicyInfo and treats a missing one as the strictest region
-- (no lootboxes, no usernames or user ids). Nothing random is paid for in this place, so
-- ArePaidRandomItemsRestricted is always false.
local function fetchPolicy(player: Player): { [string]: any }
	local ok, info = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, player)
	local policy = ok and type(info) == "table" and table.clone(info) or {
		IsSubjectToChinaPolicies = false,
		IsPaidItemTradingAllowed = true,
		AllowedExternalLinkReferences = {},
	}
	policy.ArePaidRandomItemsRestricted = false
	return policy
end

local function loadLegacy(player: Player): { [string]: any }?
	local ok, legacy = pcall(DataStoreService.GetDataStore, DataStoreService, LEGACY_STORE_NAME)
	if not ok then
		return nil
	end
	local found, saved = pcall(legacy.GetAsync, legacy, keyFor(player))
	if found and type(saved) == "table" then
		return SparseCodec.Decode(saved)
	end
	return nil
end

function PlayerDataService.Get(player: Player, field: string?): any
	local profile = Profiles[player]
	if not profile then
		return nil
	end
	if field == nil then
		return profile.Data
	end
	return profile.Data[field]
end

function PlayerDataService.IsLoaded(player: Player): boolean
	return Profiles[player] ~= nil
end

function PlayerDataService.WaitForData(player: Player, timeout: number?): { [string]: any }?
	if Profiles[player] then
		return Profiles[player].Data
	end

	local deadline = os.clock() + (timeout or 60)
	while not Profiles[player] and player.Parent == Players and os.clock() < deadline do
		task.wait(0.1)
	end

	return Profiles[player] and Profiles[player].Data
end

-- Sends a field's current value to the owner.
function PlayerDataService.Replicate(player: Player, field: string)
	local profile = Profiles[player]
	if profile then
		DataRemotes.PlayerDataChanged:FireClient(player, enum("DataValueChanged"), field, SparseCodec.Encode(profile.Data[field]))
	end
end

function PlayerDataService.Set(player: Player, field: string, value: any)
	local profile = Profiles[player]
	if not profile then
		return false
	end
	profile.Data[field] = value
	PlayerDataService.Replicate(player, field)
	return true
end

function PlayerDataService.Increment(player: Player, field: string, amount: number): number?
	local current = tonumber(PlayerDataService.Get(player, field)) or 0
	if PlayerDataService.Set(player, field, current + amount) then
		return current + amount
	end
	return nil
end

-- Settings live in Settings[profile][name]; SettingsController only asks, the server answers.
local function setSetting(player: Player, name: any, value: any, profileIndex: any): boolean
	local profile = Profiles[player]
	if not profile or typeof(name) ~= "string" then
		return false
	end

	local info = SettingsLibrary.Info[name]
	if not info then
		return false
	end

	local checked = value
	if info.VerifyInput then
		checked = info.VerifyInput(value)
		if checked == nil then
			return false
		end
	end

	local index = tonumber(profileIndex) or profile.Data.SettingsProfile
	local settings = profile.Data.Settings[index]
	if not settings then
		return false
	end

	settings[name] = checked
	DataRemotes.PlayerDataChanged:FireClient(player, enum("SettingChanged"), name, checked, profileIndex)
	return true
end

local function onPlayerAdded(player: Player)
	local profile = store and store:StartSessionAsync(keyFor(player), {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})
	if player.Parent ~= Players then
		if profile then
			profile:EndSession()
		end
		return
	end

	local data
	if not profile then
		warn(string.format("[PlayerData] no session for %s, playing on a blank profile that won't save", player.Name))
		data = DataTemplate.New()
	elseif next(profile.Data) == nil then
		local legacy = loadLegacy(player)
		data = legacy and DataTemplate.Reconcile(legacy) or DataTemplate.New()
	else
		data = DataTemplate.Reconcile(SparseCodec.Decode(profile.Data))
	end
	DataTemplate.EnsureSeason(data)
	data.PolicyInfo = fetchPolicy(player)

	local entry = { Data = data, Profile = profile }
	if profile then
		profile:AddUserId(player.UserId)
		profile.OnSave:Connect(function()
			profile.Data = SparseCodec.Encode(entry.Data)
		end)
		profile.OnSessionEnd:Connect(function()
			if Profiles[player] == entry then
				Profiles[player] = nil
			end
			-- Another server took the session: this copy must stop being played on.
			if player.Parent == Players then
				player:Kick("Your data was loaded on another server. Please rejoin.")
			end
		end)
	end

	Profiles[player] = entry
	PlayerDataService.Loaded:Fire(player, data)
end

function PlayerDataService.Start()
	local ok, result = pcall(ProfileStore.New, STORE_NAME, {})
	if ok then
		store = result
	else
		warn("[PlayerData] no ProfileStore, nothing will be saved: " .. tostring(result))
	end

	--DataRemotes.RequestPlayerData.OnServerInvoke = function(player: Player)
	--	local data = PlayerDataService.WaitForData(player)
	--	return data and { Data = SparseCodec.Encode(data) } or nil
	--end

	--DataRemotes.ChangeSettings.OnServerEvent:Connect(function(player: Player, changes: any)
	--	if typeof(changes) ~= "table" then
	--		return
	--	end
	--	for _, change in changes do
	--		if typeof(change) == "table" then
	--			setSetting(player, change[1], change[2], change[3])
	--		end
	--	end
	--end)

	--DataRemotes.SwitchSettingsProfile.OnServerEvent:Connect(function(player: Player, index: any)
	--	index = tonumber(index)
	--	if index and index % 1 == 0 and index >= 1 and index <= SettingsLibrary.NUM_PROFILES then
	--		PlayerDataService.Set(player, "SettingsProfile", index)
	--	end
	--end)

	--DataRemotes.DefaultSettings.OnServerEvent:Connect(function(player: Player, index: any)
	--	local profile = Profiles[player]
	--	if not profile then
	--		return
	--	end
	--	local target = tonumber(index) or profile.Data.SettingsProfile
	--	if profile.Data.Settings[target] then
	--		profile.Data.Settings[target] = DataTemplate.DefaultSettings()
	--		PlayerDataService.Replicate(player, "Settings")
	--	end
	--end)

	Players.PlayerAdded:Connect(onPlayerAdded)
	for _, player in Players:GetPlayers() do
		task.spawn(onPlayerAdded, player)
	end

	-- ProfileStore saves on EndSession, on its own autosave and at shutdown.
	Players.PlayerRemoving:Connect(function(player: Player)
		local entry = Profiles[player]
		Profiles[player] = nil
		if entry and entry.Profile then
			entry.Profile:EndSession()
		end
	end)
end

return PlayerDataService
