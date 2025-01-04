local blink = require("@blink/server")

local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Hit = cts.Hit
local Character = cts.Character
local Damage = cts.Damage

local function applyHit()
    for targetEntity, targetCharacter, hit in world:query(Character, Hit):iter() do
        local attackerEntity = hit.attacker
        local attackerCharacter = world:get(attackerEntity, Character)
        local targetRoot = targetCharacter.PrimaryPart
        local attackerRoot = attackerCharacter.PrimaryPart

        local direction = (attackerRoot.Position - targetRoot.Position).Unit * Vector3.new(1, 0, 1)
        targetRoot.CFrame = CFrame.lookAt(targetRoot.Position, targetRoot.Position + direction, targetRoot.CFrame.UpVector)

        blink.CharacterHit.FireAll(targetCharacter)

        world:set(targetEntity, Damage, hit.damage)
        world:remove(targetEntity, Hit)
    end
end

return {
    system = applyHit,
}