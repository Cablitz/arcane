local blink = require("@blink/server")

local world = require("@std/world")

local combatCts = require("@cts/combat")
local Hit = combatCts.Hit
local Damage = combatCts.Damage

local characterCts = require("@cts/character")
local Character = characterCts.Character

local function applyHit()
    for targetEntity, targetCharacter, hit in world:query(Character, Hit):iter() do
        blink.CharacterHit.FireAll(targetCharacter)

        world:set(targetEntity, Damage, hit.damage)
        world:remove(targetEntity, Hit)
    end
end

return {
    system = applyHit,
}