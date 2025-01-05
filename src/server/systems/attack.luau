local matter = require("@packages/matter")
local jecs = require("@packages/jecs")
local blink = require("@blink/server")

local world = require("@std/world")
local ref = require("@std/ref")

local abilityCts = require("@cts/ability")
local Attack = abilityCts.Attack
local Duration = abilityCts.Duration
local Active = abilityCts.Active

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
        local attackerEntity = ref(attackerPlayer.Character)
        local targetEntity = ref(targetCharacter)

        if world:has(attackerEntity, pair(Active, Attack)) then
            world:set(targetEntity, Hit, { attacker = attackerEntity, damage = 15 })
        end
    end
end

return {
    system = attack,
} 