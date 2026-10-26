-- [PATH] ServerStorage / Modules / SheetDatabase @Type ModuleScript
-- The variable below is the ID of the script you've created, you won't need
-- to enter any information other than this.

local scriptId = "AKfycbwEIx311ZqYvVhTn_WPB6IMy521jl5nXpq-bVvnmt9mjqO0sCi2etAq2KtNf2rd79xA"

-- Touch anything below and you'll upset the script, and that's not a good thing.

local url = "https://script.google.com/macros/s/" .. scriptId .. "/exec"
local httpService = game:GetService'HttpService'
local module = {}

game:WaitForChild'NetworkServer'

function decodeJson(json)
	local jsonTab = {} pcall(function ()
	jsonTab = httpService:JSONDecode(json)
	end) return jsonTab
end

function encodeJson(data)
	local jsonString = data pcall(function ()
	jsonString = httpService:JSONEncode(data)
	end) return jsonString
end

function doGet(sheet, key)
	local json
	local success, error = pcall(function()
		json = httpService:GetAsync(url .. "?sheet=" .. sheet .. "&key=" .. key)
	end)
	if success then
		local data = decodeJson(json)
		--print(data)
		if data.result == "success" then
			return data.value
		else
			warn("Database error:", data.error)
			return
		end
	else
		warn("HttpService database error:", error)
	end
end

function doPost(sheet, key, data)
	local json
	local success, error = pcall(function()
		json = httpService:UrlEncode(encodeJson(data))
	end)
	if success then
		local retJson = httpService:PostAsync(url, "sheet=" .. sheet .. "&key=" .. key .. "&value=" .. json, 2)
		local data = decodeJson(retJson)
		--print(retJson)
		if data.result == "success" then
			return true
		else
			warn("Database error:", data.error)
			return false
		end
	else
		warn("HttpService database error:", error)
	end
end

function module:GetDatabase(sheet)
	local database = {}
	function database:PostAsync(key, value)
		return doPost(sheet, key, value)
	end
	function database:GetAsync(key)
		return doGet(sheet, key)
	end
	return database
end

return module