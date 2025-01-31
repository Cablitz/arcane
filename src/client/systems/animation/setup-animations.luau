local jecs = require("@packages/jecs")
local animationUtils = require("@common/utils/animation-utils")

local pair = jecs.pair

local world = require("@std/world")

local animationCts = require("@cts/animation")
local Animation = animationCts.Animation

local characterCts = require("@cts/character")
local Animator = characterCts.Animator
local Client = characterCts.Client

local abilityCts = require("@cts/ability")
local Attacks = abilityCts.Attacks
local Attack = abilityCts.Attack

local function setupAnimations()
    for characterEntity, animator in world:query(Animator):with(Client):without(pair(Animation, Attack)):iter() do
        world:set(characterEntity, pair(Animation, Attacks), {
            [1] = animationUtils.loadAnimation(animator, 105235360671157),
            [2] = animationUtils.loadAnimation(animator, 119145086727185),
            [3] = animationUtils.loadAnimation(animator, 71041733422726),
            [4] = animationUtils.loadAnimation(animator, 91528168811560),
        })
    end
end

return {
    system = setupAnimations,
}