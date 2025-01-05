local jecs = require("@packages/jecs")

local pair = jecs.pair

local world = require("@std/world")

local animationCts = require("@cts/animation")
local Animation = animationCts.Animation

local characterCts = require("@cts/character")
local Animator = characterCts.Animator
local Client = characterCts.Client

local abilityCts = require("@cts/ability")
local Attack = abilityCts.Attack

local function loadAnimation(animator: Animator, animationId: number)
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animationId

    return animator:LoadAnimation(animation)
end

local function setupAnimations()
    for characterEntity, animator in world:query(Animator):with(Client):without(pair(Animation, Attack)):iter() do
        world:set(characterEntity, pair(Animation, Attack), loadAnimation(animator, 105235360671157))
    end
end

return {
    system = setupAnimations,
}