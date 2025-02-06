local matter = require("@packages/matter")
local jecs = require("@packages/jecs")

local world = require("@std/world")

local abilityCts = require("@cts/ability")
local Attack = abilityCts.Attack
local Duration = abilityCts.Duration
local UsingAbility = abilityCts.UsingAbility
local Combo = abilityCts.Combo

local animationCts = require("@cts/animation")
local Animation = animationCts.Animation

local combatCts = require("@cts/combat")
local Hitbox = combatCts.Hitbox

local baseCts = require("@cts/base")
local Lifetime = baseCts.Lifetime

local pair = jecs.pair

local function attack()
    for attackEntity, duration in world:query(Duration):with(Attack):iter() do
        local characterEntity = world:parent(attackEntity)
        local animation = world:get(characterEntity, pair(Animation, Attack)) :: AnimationTrack

        for _ in matter.useEvent(animation, animation:GetMarkerReachedSignal("hitreg")) do
            world:add(attackEntity, Hitbox)
        end

        local remainingDuration = duration - matter.useDeltaTime()
        if remainingDuration <= 0 then
            world:remove(characterEntity, pair(UsingAbility, Attack))
            world:delete(attackEntity)

            local comboEntity = world:target(characterEntity, Combo)
            if world:get(comboEntity, Combo) < 4 then
                world:set(comboEntity, Lifetime, 0.25)
            else
                world:delete(comboEntity)
            end
        else
            world:set(attackEntity, Duration, remainingDuration)
        end
    end
end

return {
    system = attack,
}
