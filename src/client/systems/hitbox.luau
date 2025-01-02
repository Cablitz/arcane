local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Hitbox = cts.Hitbox
local Character = cts.Character

local hitboxUtils = require("@client/utils/hitbox-utils")

local function hitbox()
    for abilityEntity in world:query(Hitbox):iter() do
        local characterEntity = world:parent(abilityEntity)
        local character = world:get(characterEntity, Character)

        -- Create hitbox with standard configuration
        local part = hitboxUtils.createHitbox(character, {
            hitboxSize = Vector3.new(8, 8, 6),
            hitboxOffset = Vector3.new(0, 0, -4),
            hitboxDuration = 0.25,
        })

        -- Scan for enemies and find the closest one
        local hitCharacters = hitboxUtils.scanHitbox(part, {character})
        local hitCharacter = hitboxUtils.findClosestCharacter(character, hitCharacters)

        if hitCharacter then
            print("hit enemy")
        end

        world:remove(abilityEntity, Hitbox)
    end
end

return {
    system = hitbox,
}
