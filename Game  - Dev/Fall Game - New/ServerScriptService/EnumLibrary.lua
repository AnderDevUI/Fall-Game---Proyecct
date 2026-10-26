-- [PATH] ServerScriptService / Library / EnumLibrary @Type ModuleScript
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(
	script.Parent.Signal
)

local EnumRegistry = {}
EnumRegistry.__index = EnumRegistry

type EnumRegistryData = {
	AlwaysReplicateToEveryone: {[string]: any},
	_numEnums: number,
	_toEnum: {[string]: string},
	_fromEnum: {[string]: string},
	_enumBuilderComplete: boolean,
	_enumBuilderCompleted: any,
}

type EnumRegistryObject = typeof(setmetatable({} :: EnumRegistryData, EnumRegistry))

function EnumRegistry._new(): EnumRegistryObject
	local self = setmetatable({
		AlwaysReplicateToEveryone = {},

		_numEnums = 0,
		_toEnum = {},
		_fromEnum = {},

		_enumBuilderComplete = false,
		_enumBuilderCompleted = Signal.new(),
	}, EnumRegistry)

	self:_Init()

	return self
end

function EnumRegistry:EncryptTable(data: any): string
	local encoded = string.reverse(HttpService:JSONEncode(data))
	local buffer = table.create(#encoded)

	for index = 1, #encoded do
		buffer[index] = string.char(string.byte(encoded, index) + 1)
	end

	return table.concat(buffer)
end

function EnumRegistry:DecryptTable(encoded: string): (boolean, any)
	return pcall(function()
		local buffer = table.create(#encoded)

		for index = #encoded, 1, -1 do
			buffer[#buffer + 1] = string.char(string.byte(encoded, index) - 1)
		end

		return HttpService:JSONDecode(table.concat(buffer))
	end)
end

function EnumRegistry:ToEnum(name: string?, allowMissing: boolean?): string?
	if not name then
		return nil
	end

	local value = self._toEnum[name]

	assert(allowMissing or value ~= nil, name)

	return value
end

function EnumRegistry:FromEnum(value: string?, allowMissing: boolean?): string?
	if not value then
		return nil
	end

	local name = self._fromEnum[value]

	assert(allowMissing or name ~= nil, value)

	return name
end

function EnumRegistry:AddEnum(name: string)
	if self:ToEnum(name, true) then
		return
	end

	assert(self._numEnums <= 0x10FFFF, "EnumRegistry exceeded the UTF-8 codepoint range.")

	local enumValue = utf8.char(self._numEnums)

	self._numEnums += 1
	self._toEnum[name] = enumValue
	self._fromEnum[enumValue] = name
end

function EnumRegistry:WaitForEnumBuilder()
	if not self._enumBuilderComplete then
		self._enumBuilderCompleted:Wait()
	end
end

function EnumRegistry:EnumBuilderCompleted()
	if self._enumBuilderComplete then
		return
	end

	self._enumBuilderComplete = true
	self._enumBuilderCompleted:Fire()
end

function EnumRegistry:_Init()
end

return EnumRegistry._new()