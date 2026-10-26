-- [PATH] ServerScriptService / Server / DataTemplate @Type ModuleScript
-- A new player's data, as PlayerDataController reads it (Remotes.Data.RequestPlayerData).
--
-- The original server did not survive the dump, so every field here was read back from how
-- the client uses it: a number where it does arithmetic, a table where it iterates or
-- indexes, a boolean where it only tests. Fields the client reads through
-- PlayerDataUtility:GetStatistic can be left out; it falls back to
-- StatisticsLibrary.Info[name].DefaultValue.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Library = ServerScriptService.Library
local CONSTANTS = require(Library:WaitForChild("CONSTANTS"))
local SettingsLibrary = require(Library:WaitForChild("SettingsLibrary"))

local DataTemplate = {}

function DataTemplate.DefaultSettings(): { [string]: any }
	local settings = {}
	for name, info in SettingsLibrary.Info do
		if type(info) == "table" and info.DefaultValue ~= nil then
			settings[name] = info.DefaultValue
		end
	end
	return settings
end

function DataTemplate.NewWeapon(name: string): { [string]: any }
	return {
		Name = name,
		Level = 1,
		XP = 0,
		IsFavorited = false,
	}
end

function DataTemplate.New(): { [string]: any }
	local settings, mobileButtons = {}, {}
	local weapons = {}
	local now = os.time()

	return {
		-- Progress
		Level = 1,
		XP = 0,
		Glory = 0,
		WeaponKeys = 0,
		UnlockTokens = 0,
		SkinTickets = 0,
		EventCurrency = 0,
		WeaponInventory = weapons,
		CosmeticInventory = {},
		FavoritedCosmetics = {},
		CosmeticNotifications = {},
		EquippedEmotes = {},
		FreeWeaponUnlockCheck = {},
		FreeWeaponTrialsRemaining = {},
		FreeWeaponTrialsProgressFromVideoAds = {},
		NumFreeWeaponTrialsFromVideoAdsToday = 0,
		WeaponStatistics = {},
		MapStatistics = {},
		DuelHistory = {},
		StoredStreaks = {},
		Seasons = {},
		LoggedELOEvents = {},
		WinsFromDuelPadsToday = 0,

		-- Settings
		SettingsProfile = 1,
		Settings = settings,
		MobileButtonSettings = mobileButtons,

		-- Tasks and rewards
		Tasks = {},
		BonusTasks = {},
		EventTasks = {},
		LimitedTasks = {},
		TasksCompletedToday = {},
		BeginnerTasksCompleted = 0,
		DailyTaskStreak = 0,
		-- Day number (os.time() // 86400) of the last daily reset; see DailyService.
		LastDailyReset = 0,
		UnclaimedRewards = {},
		LoginRewardsClaimed = 0,
		ClaimedLoginRewardToday = false,
		AdventCalendarLastDayClaimed = 0,
		LastEventGiftClaimed = 0,
		EventCurrencyRushProgress = 0,
		ScavengerHunts = {},
		BirthdaysWitnessed = {},
		SpecialChallenges = {},
		WelcomeBackGiftReady = false,
		ShadyChickenMissionStarted = false,
		AprilFoolsDialogAcknowledged = -1,
		LastPatchNotesVersion = CONSTANTS.GAME_VERSION,
		PromptedNotificationPrompt = false,
		RedeemedCodes = {},
		CodesVerified = {},

		-- Social rewards
		ClaimedFavoriteReward = false,
		ClaimedGroupReward = false,
		ClaimedLikeReward = false,
		ClaimedNotificationsReward = false,

		-- Shop and monetization
		Gamepasses = {},
		GamepassBundlesClaimed = {},
		Receipts = {},
		CompressedReceipts = {},
		GiftTickets = {},
		GiftRobuxSpentProgress = 0,
		GiftRobuxSpentRewardsClaimed = 0,
		UGCPurchased = {},
		SuperStarterBundlePurchased = false,
		SuperStarterBundleStartTime = now,
		DailyShopRefreshesToday = 0,
		DailyShopSeedShift = 0,
		LastDailyShopSeen = 0,
		VideoAdRewardsClaimed = 0,
		VideoAdsWatchedBeforeClaiming = 0,
		BillboardVideoAdClaimedToday = 0,
		BillboardVideoAdProgress = 0,

		-- Moderation
		IsBadGuy = false,
		IsBadGuy2 = false,
		IsRestrictedFromCasualLeaderboards = false,
		IsRestrictedFromCompetitiveLeaderboards = false,
		ModerationWarningMessages = {},
		PermissionsRoles = {},
		SendBugRewardsCooldown = 0,
	}
end


function DataTemplate.EnsureSeason(data: { [string]: any })
 --- Soon
end

-- Fields a saved profile may be missing (added after it was first saved) get their default,
-- one level deep, without touching anything the player already has.
function DataTemplate.Reconcile(data: { [string]: any }): { [string]: any }
	for key, value in DataTemplate.New() do
		if data[key] == nil then
			data[key] = value
		end
	end
	return data
end

return DataTemplate
