local jecs = require("@packages/jecs")
local matter = require("@packages/matter")

local pair = jecs.pair
local __ = jecs.Wildcard

local world = require("@std/world")

local abilityCts = require("@cts/ability")
local Cooldown = abilityCts.Cooldown

local function applyCooldown()
	for characterEntity in world:query(pair(Cooldown, __)):iter() do
		local index = 0
		local abilityRef = world:target(characterEntity, Cooldown)

		while abilityRef and world:get(characterEntity, pair(Cooldown, abilityRef)) do
			local currentCooldown = world:get(characterEntity, pair(Cooldown, abilityRef))
			local remainingCooldown = currentCooldown - matter.useDeltaTime()

			if remainingCooldown <= 0 then
				world:remove(characterEntity, pair(Cooldown, abilityRef))
			else
				world:set(characterEntity, pair(Cooldown, abilityRef), remainingCooldown)
			end

			index += 1
			abilityRef = world:target(characterEntity, Cooldown, index)
		end
	end
end

return {
	system = applyCooldown,
}
