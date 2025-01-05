local world = require("@std/world")

local characterCts = require("@cts/character")
local Humanoid = characterCts.Humanoid

local combatCts = require("@cts/combat")
local Health = combatCts.Health

local function processHealth()
    for characterEntity, humanoid in world:query(Humanoid):without(Health):iter() do
        world:set(characterEntity, Health, humanoid.Health)
    end

    for characterEntity, humanoid, health in world:query(Humanoid, Health):iter() do
        humanoid.Health = health
    end
end

return {
    system = processHealth,
}
