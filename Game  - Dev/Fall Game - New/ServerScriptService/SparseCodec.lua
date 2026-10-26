-- [PATH] ServerScriptService / Library / SparseCodec @Type ModuleScript
local SparseCodec = {}

SparseCodec.MARKER = "__sparse"

type DataTable = {[any]: any}

local function IsSparse(value: DataTable): boolean
	local count = 0
	local maxIndex = 0

	for key in value do
		if type(key) ~= "number"
			or key < 1
			or key % 1 ~= 0
		then
			return false
		end

		count += 1
		maxIndex = math.max(maxIndex, key)
	end

	return count > 0 and count ~= maxIndex
end

function SparseCodec.Encode(value: any): any
	if type(value) ~= "table" then
		return value
	end

	if IsSparse(value) then
		local entries = {}

		for key, item in value do
			table.insert(entries, key)
			table.insert(entries, SparseCodec.Encode(item))
		end

		return {
			[SparseCodec.MARKER] = entries,
		}
	end

	local result = {}

	for key, item in value do
		result[key] = SparseCodec.Encode(item)
	end

	return result
end

function SparseCodec.Decode(value: any): any
	if type(value) ~= "table" then
		return value
	end

	local entries = value[SparseCodec.MARKER]

	if type(entries) == "table" then
		local result = {}

		for index = 1, #entries, 2 do
			local key = entries[index]

			if key ~= nil then
				result[key] = SparseCodec.Decode(entries[index + 1])
			end
		end

		return result
	end

	for key, item in value do
		if type(item) == "table" then
			value[key] = SparseCodec.Decode(item)
		end
	end

	return value
end

return table.freeze(SparseCodec)