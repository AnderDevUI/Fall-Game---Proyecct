-- [PATH] ServerScriptService / Server / LogTap @Type ModuleScript
-- Keeps the Output lines worth reading.
--
-- This place loads hundreds of assets it has no permission for, and those warnings push
-- everything else out of LogService's 512-line history within seconds. This keeps the rest
-- (errors, warnings and this server's own prints) in ServerScriptService's "Log" attribute,
-- newest last, so they can be read during a test.

local LogService = game:GetService("LogService")
local ServerScriptService = game:GetService("ServerScriptService")

local MAX_LINES = 120
local MAX_LENGTH = 240
local NOISE = {
	"not authorized",
	"permiso de acceso",
	"Failed to load",
	"Cloud instance",
	"Missing description",
	"SSAI",
	"GuiInspector",
}

local LogTap = {}

local lines: { string } = {}

local function isNoise(message: string): boolean
	for _, pattern in NOISE do
		if string.find(message, pattern, 1, true) then
			return true
		end
	end
	return false
end

function LogTap.Start()
	LogService.MessageOut:Connect(function(message: string, messageType: Enum.MessageType)
		if isNoise(message) then
			return
		end

		local kind = string.sub(messageType.Name, 8)
		table.insert(lines, string.format("[%s] %s", kind, string.sub(message, 1, MAX_LENGTH)))
		while #lines > MAX_LINES do
			table.remove(lines, 1)
		end

		ServerScriptService:SetAttribute("Log", table.concat(lines, "\n"))
	end)
end

return LogTap
