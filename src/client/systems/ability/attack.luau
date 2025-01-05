local matter = require("@packages/matter")
local jecs = require("@packages/jecs")

local world = require("@std/world")

local abilityCts = require("@cts/ability")
local Attack = abilityCts.Attack
local Duration = abilityCts.Duration
local Active = abilityCts.Active

local animationCts = require("@cts/animation")
local Animation = animationCts.Animation

local combatCts = require("@cts/combat")
local Hitbox = combatCts.Hitbox

local pair = jecs.pair

local function attack()
    for attackEntity, duration in world:query(Duration):with(Attack):iter() do
        local characterEntity = world:parent(attackEntity)
        local animation = world:get(characterEntity, pair(Animation, Attack)) :: AnimationTrack

        for _ in matter.useEvent(animation, animation:GetMarkerReachedSignal("hitbox")) do
            world:add(attackEntity, Hitbox)
        end

        local remainingDuration = duration - matter.useDeltaTime()
        if remainingDuration <= 0 then
            world:remove(characterEntity, pair(Active, Attack))
            world:delete(attackEntity)
        else
            world:set(attackEntity, Duration, remainingDuration)
        end
    end
end

return {
    system = attack,
}
