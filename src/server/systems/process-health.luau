local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Health = cts.Health
local Humanoid = cts.Humanoid

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
