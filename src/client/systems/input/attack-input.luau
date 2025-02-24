local blink = require("@blink/client")
local jecs = require("@packages/jecs")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local world = require("@std/world")

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Client = characterCts.Client

local baseCts = require("@cts/base")
local Lifetime = baseCts.Lifetime

local abilityCts = require("@cts/ability")
local Attack = abilityCts.Attack
local Attacks = abilityCts.Attacks
local Cooldown = abilityCts.Cooldown
local UsingAbility = abilityCts.UsingAbility
local Duration = abilityCts.Duration
local Combo = abilityCts.Combo

local animationCts = require("@cts/animation")
local Animation = animationCts.Animation

local clientState = require("@shared/constants/client-state")
type ClientState = clientState.ClientState

local attackConfig = {
	cooldown = 0.25,
	duration = 0.5,
	comboLifetime = 1,
}

local function canAttack(characterEntity)
	return not world:has(characterEntity, pair(Cooldown, Attack))
		and not world:has(characterEntity, pair(UsingAbility, Attack))
end

local function attackInput(state: ClientState)
	for characterEntity, character in world:query(Character):with(Client):iter() do
		if canAttack(characterEntity) and state.input.actions:justPressed("attack") then
			local attackEntity = world:entity()

			world:add(attackEntity, Attack)
			world:set(attackEntity, pair(ChildOf, characterEntity))

			-- Initilization of attack by spawning parts, animations, components, etc
			if world:has(characterEntity, Combo) then
				world:set(characterEntity, Combo, (world:get(characterEntity, Combo) :: number) + 1)
				world:remove(characterEntity, pair(Lifetime, Combo))
			else
				world:set(characterEntity, Combo, 1)
			end

			local combo = world:get(characterEntity, Combo)
			local attackAnimation = (world:get(characterEntity, pair(Animation, Attacks)) :: { AnimationTrack })[combo]
			attackAnimation:Play()

			world:set(characterEntity, pair(Animation, Attack), attackAnimation)
			world:set(attackEntity, Duration, attackConfig.duration)
			world:add(characterEntity, pair(UsingAbility, Attack))
			world:set(characterEntity, pair(Cooldown, Attack), attackConfig.cooldown)

			blink.UseAttackAbility.Fire()
		end
	end
end

return {
	system = attackInput,
}
