local matter = require("@packages/matter")
local jecs = require("@packages/jecs")
local blink = require("@blink/server")

local std = require("@common/std")
local world = std.world
local ref = std.ref

local cts = require("@common/cts")
local Attack = cts.Attack
local Duration = cts.Duration
local Active = cts.Active
local Character = cts.Character
local Hit = cts.Hit

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
            world:set(targetEntity, Hit, { attacker = attackerEntity, damage = 10 })
            print("Server received hit:", attackerEntity, "->", targetEntity)            
        end
    end
end

-- local rig = workspace.Rig <--- Rojo Syncback works with proper Intellisense!!!!!!

return {
    system = attack,
} 