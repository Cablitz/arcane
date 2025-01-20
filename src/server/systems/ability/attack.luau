local matter = require("@packages/matter")
local jecs = require("@packages/jecs")
local blink = require("@blink/server")

local world = require("@std/world")
local ref = require("@std/ref")

local abilityCts = require("@cts/ability")
local Attack = abilityCts.Attack
local Duration = abilityCts.Duration
local Active = abilityCts.Active

local characterCts = require("@cts/character")
local CharacterRef = characterCts.CharacterRef
local Character = characterCts.Character

local combatCts = require("@cts/combat")
local Hit = combatCts.Hit

local pair = jecs.pair

local function attack()
    for attackEntity, duration in world:query(Duration):with(Attack):iter() do
        local characterEntity = world:parent(attackEntity)
        local remainingDuration = duration - matter.useDeltaTime()

        if remainingDuration <= 0 then
            world:remove(characterEntity, pair(Active, Attack))
            world:delete(attackEntity)
        else
            world:set(attackEntity, Duration, remainingDuration)
        end
    end

    -- Handle attack hits from clients
    for _, attackerPlayer, targetCharacter in blink.AttackCharacter.Iter() do
        local attackerPlayerRef = ref(attackerPlayer)
        local attackerCharacterRef = world:get(attackerPlayerRef, CharacterRef)
        local targetCharacterRef = ref(targetCharacter)

        if not attackerCharacterRef then continue end
        if not world:has(targetCharacterRef, Character) then continue end

        if world:has(attackerCharacterRef, pair(Active, Attack)) then
            world:set(targetCharacterRef, Hit, { attacker = attackerCharacterRef, damage = 15 })
        end
    end
end

return {
    system = attack,
} 