local jecs = require("@packages/jecs")

local pair = jecs.pair

local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Animation = cts.Animation
local Animator = cts.Animator
local Attack = cts.Attack
local Client = cts.Client

local function loadAnimation(animator: Animator, animationId: number)
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animationId

    return animator:LoadAnimation(animation)
end

local function setupAnimations()
    for characterEntity, animator in world:query(Animator):with(Client):without(pair(Animation, Attack)) do
        world:set(characterEntity, pair(Animation, Attack), loadAnimation(animator, 105235360671157))
    end
end

return {
    system = setupAnimations,
}