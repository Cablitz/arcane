local jecs = require("@packages/jecs")

local pair = jecs.pair

local world = require("@std/world")

local combatCts = require("@cts/combat")
local Damage = combatCts.Damage
local Health = combatCts.Health

local baseCts = require("@cts/base")
local Target = baseCts.Target

local function applyDamage()
	for characterEntity, health in world:query(Health):iter() do
		local totalDamage = 0

		for damageEntity, damage in world:query(Damage):with(pair(Target, characterEntity)):iter() do
			totalDamage += damage
			world:delete(damageEntity)
		end

		world:set(characterEntity, Health, health - totalDamage)
	end
end

return {
	system = applyDamage,
}
