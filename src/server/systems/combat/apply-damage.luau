local world = require("@std/world")

local combatCts = require("@cts/combat")
local Damage = combatCts.Damage
local Health = combatCts.Health

local function applyDamage()
    for characterEntity, health, damage in world:query(Health, Damage):iter() do
        world:set(characterEntity, Health, health - damage)

        world:remove(characterEntity, Damage)
    end 
end

return {
    system = applyDamage,
}