local jecs = require("@packages/jecs")
local blink = require("@blink/server")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local world = require("@std/world")
local ref = require("@std/ref")

local abilityCts = require("@cts/ability")
local Attack = abilityCts.Attack
local Cooldown = abilityCts.Cooldown
local Active = abilityCts.Active
local Duration = abilityCts.Duration
local Combo = abilityCts.Combo

local baseCts = require("@cts/base")
local Lifetime = baseCts.Lifetime

local attackConfig = {
    cooldown = 0.25,
    duration = 0.5,
    comboLifetime = 1,
}

local function canAttack(characterEntity)
    return not world:has(characterEntity, pair(Cooldown, Attack)) and not world:has(characterEntity, pair(Active, Attack))
end

local function attackInput()
    for _, player in blink.UseAttackAbility.Iter() do
        local characterEntity = ref(player.Character)

        if canAttack(characterEntity) then
            local attackEntity = world:entity()
            local adjustedCooldown = attackConfig.cooldown - player:GetNetworkPing()
            local adjustedDuration = attackConfig.duration - player:GetNetworkPing()

            world:add(attackEntity, Attack)
            world:set(attackEntity, pair(ChildOf, characterEntity))

            local comboEntity = world:target(characterEntity, Combo)
            if comboEntity then
                local currentCombo = world:get(comboEntity, Combo)
                world:set(comboEntity, Combo, currentCombo + 1)
                world:remove(comboEntity, Lifetime)
            else
                comboEntity = world:entity()
                world:set(comboEntity, Combo, 1)
                world:add(characterEntity, pair(Combo, comboEntity))
            end

            world:set(attackEntity, Duration, adjustedDuration)
            world:add(characterEntity, pair(Active, Attack))
            world:set(characterEntity, pair(Cooldown, Attack), adjustedCooldown)
        end
    end
end

return {
    system = attackInput,
} 