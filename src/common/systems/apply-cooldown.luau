local jecs = require("@packages/jecs")
local matter = require("@packages/matter")

local pair = jecs.pair
local __ = jecs.Wildcard

local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Cooldown = cts.Cooldown

local function applyCooldown()
    for characterEntity in world:query(pair(Cooldown, __)) do
        local index = 0

        while true do
            local abilityEntity = world:target(characterEntity, Cooldown, index)
            if abilityEntity == nil then
                break
            end
            index += 1

            local currentCooldown = world:get(characterEntity, pair(Cooldown, abilityEntity))
            local remainingCooldown = currentCooldown - matter.useDeltaTime()

            if remainingCooldown <= 0 then
                world:remove(characterEntity, pair(Cooldown, abilityEntity))
            else
                world:set(characterEntity, pair(Cooldown, abilityEntity), remainingCooldown)
            end
        end
    end
end

return {
    system = applyCooldown,
}