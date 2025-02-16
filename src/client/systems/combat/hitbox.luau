local blink = require("@blink/client")

local world = require("@std/world")

local combatCts = require("@cts/combat")
local Hitbox = combatCts.Hitbox

local characterCts = require("@cts/character")
local Character = characterCts.Character

local hitboxUtils = require("@client/utils/hitbox-utils")
local createHitbox = hitboxUtils.createHitbox
local scanHitbox = hitboxUtils.scanHitbox
local findClosestCharacter = hitboxUtils.findClosestCharacter

local function hitbox()
	for abilityEntity in world:query(Hitbox):iter() do
		local characterEntity = world:parent(abilityEntity)
		local character = world:get(characterEntity, Character)

		-- Create hitbox with standard configuration
		local part = createHitbox(character, {
			hitboxSize = Vector3.new(8, 8, 6),
			hitboxOffset = Vector3.new(0, 0, -4),
			hitboxDuration = 0.25,
		})

		-- Scan for enemies and find the closest one
		local hitCharacters = scanHitbox(part, { character })
		local hitCharacter = findClosestCharacter(character, hitCharacters)

		if hitCharacter then
			blink.AttackCharacter.Fire(hitCharacter)
		end

		world:remove(abilityEntity, Hitbox)
	end
end

return {
	system = hitbox,
}
