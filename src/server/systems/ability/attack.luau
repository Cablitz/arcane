local matter = require("@packages/matter")
local jecs = require("@packages/jecs")
local blink = require("@blink/server")

local world = require("@std/world")
local ref = require("@std/ref")

local abilityCts = require("@cts/ability")
local Attack = abilityCts.Attack
local Duration = abilityCts.Duration
local UsingAbility = abilityCts.UsingAbility
local Combo = abilityCts.Combo

local playerCts = require("@cts/player")
local CharacterRef = playerCts.CharacterRef

local characterCts = require("@cts/character")
local Character = characterCts.Character
local combatCts = require("@cts/combat")
local Hit = combatCts.Hit

local baseCts = require("@cts/base")
local Target = baseCts.Target
local Source = baseCts.Source
local Lifetime = baseCts.Lifetime

local pair = jecs.pair

local function attack()
	for attackEntity, duration in world:query(Duration):with(Attack):iter() do
		local characterEntity = world:parent(attackEntity)
		local remainingDuration = duration - matter.useDeltaTime()

		if remainingDuration <= 0 then
			world:remove(characterEntity, pair(UsingAbility, Attack))
			world:delete(attackEntity)

			if world:get(characterEntity, Combo) < 4 then
				world:set(characterEntity, pair(Lifetime, Combo), 0.25)
			else
				world:remove(characterEntity, Combo)
			end
		else
			world:set(attackEntity, Duration, remainingDuration)
		end
	end

	-- Handle attack hits from clients
	for _, attackerPlayer, targetCharacter in blink.AttackCharacter.Iter() do
		local attackerPlayerRef = ref(attackerPlayer)
		local attackerCharacterRef = world:target(attackerPlayerRef, CharacterRef)
		local targetCharacterRef = ref(targetCharacter)

		-- Guard clauses
		if not attackerCharacterRef then
			continue
		end
		if not world:has(targetCharacterRef, Character) then
			continue
		end
		if not world:has(attackerCharacterRef, pair(UsingAbility, Attack)) then
			continue
		end

		local hitEntity = world:entity()
		world:add(hitEntity, pair(Source, attackerCharacterRef))
		world:add(hitEntity, pair(Target, targetCharacterRef))
		world:set(hitEntity, Hit, 5)
	end
end

return {
	system = attack,
}
