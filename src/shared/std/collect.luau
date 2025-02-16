--!nonstrict

--[[
	local signal = Signal.new() :: Signal.Signal<string, string>
	local events = collect(signal)
	local function system(world)
		for id, str1, str2 in events do
			--
		end
	end
]]

type Connect<T...> = (self: SignalLike<T...>, fn: (T...) -> ()) -> any
type SignalLike<T...> = ({ connect: Connect<T...> } | { Connect: Connect<T...> }) & { [any]: any }
local function collect<T...>(event: SignalLike<T...>)
	local storage = {}
	local mt = {}
	local iter = function()
		local n = #storage
		return function()
			if n <= 0 then
				mt.__iter = nil
				return nil
			end

			n -= 1
			return n + 1, unpack(table.remove(storage, 1) :: any)
		end
	end

	local connect = event.Connect or event.connect
	assert(connect ~= nil, "Signal is missing a Connect function - is it really a signal?")
	local disconnect = connect(event, function(...)
		table.insert(storage, { ... })
		mt.__iter = iter
	end)

	setmetatable(storage, mt)
	return (storage :: any) :: () -> (number, T...), function()
		disconnect()
	end
end

return collect
