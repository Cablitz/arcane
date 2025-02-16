local matter = require("@packages/matter")
local jecs = require("@packages/jecs")

local pair = jecs.pair
local __ = jecs.Wildcard

local world = require("@std/world")

local baseCts = require("@cts/base")
local Lifetime = baseCts.Lifetime

local function applyLifetime()
	for id, lifetime in world:query(Lifetime):iter() do
		local remainingLifetime = lifetime - matter.useDeltaTime()
		if remainingLifetime <= 0 then
			world:delete(id)
		else
			world:set(id, Lifetime, remainingLifetime)
		end
	end

	for characterEntity in world:query(pair(Lifetime, __)):iter() do
		local index = 0
		local targetRef = world:target(characterEntity, Lifetime)

		while targetRef and world:get(characterEntity, pair(Lifetime, targetRef)) do
			local currentLifetime = world:get(characterEntity, pair(Lifetime, targetRef))
			local remainingLifetime = currentLifetime - matter.useDeltaTime()

			if remainingLifetime <= 0 then
				world:remove(characterEntity, targetRef)
				world:remove(characterEntity, pair(Lifetime, targetRef))
			else
				world:set(characterEntity, pair(Lifetime, targetRef), remainingLifetime)
			end

			index += 1
			targetRef = world:target(characterEntity, Lifetime, index)
		end
	end
end

return {
	system = applyLifetime,
}
