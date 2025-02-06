local blink = require("@blink/server")
local jecs = require("@packages/jecs")

local pair = jecs.pair
local ChildOf = jecs.ChildOf
local world = require("@std/world")

local combatCts = require("@cts/combat")
local Hit = combatCts.Hit
local Hits = combatCts.Hits
local Damage = combatCts.Damage

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Human = characterCts.Human
local Ragdoll = characterCts.Ragdoll

local abilityCts = require("@cts/ability")
local Combo = abilityCts.Combo

local animationCts = require("@cts/animation")
local Animation = animationCts.Animation

local baseCts = require("@cts/base")
local Target = baseCts.Target
local Source = baseCts.Source
local Lifetime = baseCts.Lifetime

local function applyHit()
    for hitEntity, hit in world:query(Hit):iter() do
        local attackerRef = world:target(hitEntity, ChildOf)
        local targetRef = world:target(hitEntity, Target)
        local targetCharacter = world:get(targetRef, Character)

        blink.CharacterHit.FireAll(targetCharacter)

        if not world:has(targetRef, Human) then
            local hitAnimations = world:get(targetRef, pair(Animation, Hits)) :: {AnimationTrack}
            hitAnimations[math.random(1, 3)]:Play()
        end

        local damageEntity = world:entity()
        world:add(damageEntity, pair(Target, targetRef))
        world:add(damageEntity, pair(Source, attackerRef))
        world:set(damageEntity, Damage, hit)

        if world:get(attackerRef, Combo) == 4 then
            world:add(targetRef, Ragdoll)
            world:set(targetRef, pair(Lifetime, Ragdoll), 3)
        end

        world:delete(hitEntity)
    end
end

return {
    system = applyHit,
}