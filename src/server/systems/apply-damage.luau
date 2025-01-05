local world = require("@std/world")

local cts = require("@common/cts")
local Damage = cts.Damage
local Health = cts.Health

local function applyDamage()
    for characterEntity, health, damage in world:query(Health, Damage):iter() do
        world:set(characterEntity, Health, health - damage)

        world:remove(characterEntity, Damage)
    end 
end

return {
    system = applyDamage,
}