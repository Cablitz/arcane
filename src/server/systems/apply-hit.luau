local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Hit = cts.Hit
local Character = cts.Character

local function applyHit()
    for characterEntity, targetCharacter, hit in world:query(Character, Hit):iter() do
        local attackerEntity = hit.attacker
        local attackerCharacter = world:get(attackerEntity, Character)
        local targetRoot = targetCharacter.PrimaryPart
        local attackerRoot = attackerCharacter.PrimaryPart

        targetRoot.CFrame = CFrame.lookAt(targetRoot.Position, attackerRoot.Position)
    end
end

return {
    system = applyHit,
}