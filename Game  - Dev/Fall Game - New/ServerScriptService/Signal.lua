-- [PATH] ServerScriptService / Library / Signal @Type ModuleScript
-- Signal.lua
local Signal = {}
Signal.__index = Signal

local Connection = {}
Connection.__index = Connection

local freeRunnerThread: thread? = nil

type ConnectionData = {
	Connected: boolean,
	_next: any,
	_signal: any,
	_fn: (...any) -> (),
}

type SignalData = {
	_handlerListHead: any,
	_proxyHandler: RBXScriptConnection?,
	_yieldedThreads: { [thread]: boolean }?,
}

type ConnectionObject = typeof(setmetatable({} :: ConnectionData, Connection))
type SignalObject = typeof(setmetatable({} :: SignalData, Signal))

local function acquireRunnerThreadAndCallEventHandler(
	callback: (...any) -> (),
	...: any
)
	local runnerThread = freeRunnerThread
	freeRunnerThread = nil

	callback(...)

	freeRunnerThread = runnerThread
end

local function runEventHandlerInFreeThread(...: any)
	acquireRunnerThreadAndCallEventHandler(...)

	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

function Connection:Disconnect()
	if not self.Connected then
		return
	end

	self.Connected = false

	local signal = self._signal
	local head = signal._handlerListHead

	if head == self then
		signal._handlerListHead = self._next
		return
	end

	while head and head._next ~= self do
		head = head._next
	end

	if head then
		head._next = self._next
	end
end

Connection.Destroy = Connection.Disconnect

function Signal.new(): SignalObject
	return setmetatable({
		_handlerListHead = nil,
		_proxyHandler = nil,
		_yieldedThreads = nil,
	}, Signal)
end

function Signal.Wrap(source: RBXScriptSignal): SignalObject
	assert(
		typeof(source) == "RBXScriptSignal",
		("Argument #1 to Signal.Wrap must be a RBXScriptSignal; got %s"):format(
			typeof(source)
		)
	)

	local signal = Signal.new()

	signal._proxyHandler = source:Connect(function(...)
		signal:Fire(...)
	end)

	return signal
end

function Signal.Is(value: any): boolean
	return type(value) == "table" and getmetatable(value) == Signal
end

function Signal:Connect(callback: (...any) -> ()): ConnectionObject
	assert(type(callback) == "function", "Signal:Connect expects a function")

	local connection = setmetatable({
		Connected = true,
		_next = self._handlerListHead,
		_signal = self,
		_fn = callback,
	}, Connection)

	self._handlerListHead = connection

	return connection
end

function Signal:ConnectOnce(callback: (...any) -> ()): ConnectionObject
	return self:Once(callback)
end

function Signal:Once(callback: (...any) -> ()): ConnectionObject
	local connection: ConnectionObject?

	connection = self:Connect(function(...)
		local currentConnection = connection

		if currentConnection then
			currentConnection:Disconnect()
		end

		callback(...)
	end)

	return connection
end

function Signal:GetConnections(): { ConnectionObject }
	local connections = {}
	local current = self._handlerListHead

	while current do
		table.insert(connections, current)
		current = current._next
	end

	return connections
end

function Signal:DisconnectAll()
	local current = self._handlerListHead

	while current do
		current.Connected = false
		current = current._next
	end

	self._handlerListHead = nil

	local yieldedThreads = self._yieldedThreads

	if yieldedThreads then
		for runningThread in yieldedThreads do
			if coroutine.status(runningThread) == "suspended" then
				task.cancel(runningThread)
			end
		end

		table.clear(yieldedThreads)
	end
end

function Signal:Fire(...: any)
	local current = self._handlerListHead

	while current do
		if current.Connected then
			if not freeRunnerThread then
				freeRunnerThread = coroutine.create(runEventHandlerInFreeThread)
			end

			task.spawn(freeRunnerThread, current._fn, ...)
		end

		current = current._next
	end
end

function Signal:FireDeferred(...: any)
	local current = self._handlerListHead

	while current do
		local connection = current

		task.defer(function(...)
			if connection.Connected then
				connection._fn(...)
			end
		end, ...)

		current = current._next
	end
end

function Signal:Wait(): ...any
	local yieldedThreads = self._yieldedThreads

	if not yieldedThreads then
		yieldedThreads = {}
		self._yieldedThreads = yieldedThreads
	end

	local runningThread = coroutine.running()
	yieldedThreads[runningThread] = true

	self:Once(function(...)
		yieldedThreads[runningThread] = nil
		task.spawn(runningThread, ...)
	end)

	return coroutine.yield()
end

function Signal:Destroy()
	self:DisconnectAll()

	local proxyHandler = self._proxyHandler

	if proxyHandler then
		proxyHandler:Disconnect()
		self._proxyHandler = nil
	end
end

return table.freeze({
	new = Signal.new,
	Wrap = Signal.Wrap,
	Is = Signal.Is,
})