local blink = require("@blink/server")
local jecs = require("@packages/jecs")

local pair = jecs.pair

local world = require("@std/world")

local combatCts = require("@cts/combat")
local Hit = combatCts.Hit
local Hits = combatCts.Hits
local Damage = combatCts.Damage

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Human = characterCts.Human

local animationCts = require("@cts/animation")
local Animation = animationCts.Animation

local function applyHit()
    for targetEntity, targetCharacter, hit in world:query(Character, Hit):iter() do
        blink.CharacterHit.FireAll(targetCharacter)

        if not world:has(targetEntity, Human) then
            local hitAnimations = world:get(targetEntity, pair(Animation, Hits)) :: {AnimationTrack}
            hitAnimations[math.random(1, 3)]:Play()
        end

        world:set(targetEntity, Damage, hit.damage)
        world:remove(targetEntity, Hit)
    end
end

return {
    system = applyHit,
}