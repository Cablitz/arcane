local blink = require("@blink/server")

local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Hit = cts.Hit
local Character = cts.Character
local Damage = cts.Damage

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