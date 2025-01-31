local jecs = require("@packages/jecs")
local animationUtils = require("@common/utils/animation-utils")

local pair = jecs.pair

local world = require("@std/world")

local animationCts = require("@cts/animation")
local Animation = animationCts.Animation

local characterCts = require("@cts/character")
local Animator = characterCts.Animator
local Human = characterCts.Human

local abilityCts = require("@cts/ability")
local Attacks = abilityCts.Attacks

local combatCts = require("@cts/combat")
local Hits = combatCts.Hits

local function setupAnimations()
    for characterEntity, animator in world:query(Animator):without(pair(Animation, Attacks), Human):iter() do
        world:set(characterEntity, pair(Animation, Attacks), {
            [1] = animationUtils.loadAnimation(animator, 105235360671157),
            [2] = animationUtils.loadAnimation(animator, 119145086727185),
            [3] = animationUtils.loadAnimation(animator, 71041733422726),
            [4] = animationUtils.loadAnimation(animator, 91528168811560),
        })
    end

    for characterEntity, animator in world:query(Animator):without(pair(Animation, Hits), Human):iter() do
        world:set(characterEntity, pair(Animation, Hits), {
            [1] = animationUtils.loadAnimation(animator, 118182550757885),
            [2] = animationUtils.loadAnimation(animator, 138697750168515),
            [3] = animationUtils.loadAnimation(animator, 118182550757885),
        })
    end
end

return {
    system = setupAnimations,
}