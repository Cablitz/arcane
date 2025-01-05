local jecs = require("@packages/jecs")
local blink = require("@blink/server")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local world = require("@std/world")
local ref = require("@std/ref")

local cts = require("@common/cts")
local Attack = cts.Attack
local Cooldown = cts.Cooldown
local Active = cts.Active
local Duration = cts.Duration

local attackConfig = {
    cooldown = 0.5,
    duration = 0.75,
}

local function canAttack(characterEntity)
    return not world:has(characterEntity, pair(Cooldown, Attack)) and not world:has(characterEntity, pair(Active, Attack))
end

local function handleAttackInput()
    for _, player in blink.UseAttackAbility.Iter() do
        local characterEntity = ref(player.Character)

        if canAttack(characterEntity) then
            local attackEntity = world:entity()
            local adjustedCooldown = attackConfig.cooldown - player:GetNetworkPing()
            local adjustedDuration = attackConfig.duration - player:GetNetworkPing()

            world:add(attackEntity, Attack)
            world:set(attackEntity, pair(ChildOf, characterEntity))

            world:set(attackEntity, Duration, adjustedDuration)
            world:add(characterEntity, pair(Active, Attack))
            world:set(characterEntity, pair(Cooldown, Attack), adjustedCooldown)
        end
    end
end

return {
    system = handleAttackInput,
} 