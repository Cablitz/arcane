local matter = require("@packages/matter")
local jecs = require("@packages/jecs")

local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Attack = cts.Attack
local Active = cts.Active
local Cooldown = cts.Cooldown
local Animation = cts.Animation
local Hitbox = cts.Hitbox

local pair = jecs.pair

local function attack()
    for attackEntity in world:query(Attack):iter() do
        local characterEntity = world:parent(attackEntity)
        local animation = world:get(characterEntity, pair(Animation, Attack)) :: AnimationTrack

        for _ in matter.useEvent(animation, animation:GetMarkerReachedSignal("hitbox")) do
            world:add(attackEntity, Hitbox)
        end

        for _ in matter.useEvent(animation, animation.Ended) do
            world:remove(characterEntity, pair(Active, Attack))
            world:delete(attackEntity)
        end
    end
end

return {
    system = attack,
}
