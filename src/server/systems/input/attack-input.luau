local blink = require("@blink/server")
local jecs = require("@packages/jecs")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local ref = require("@std/ref")
local world = require("@std/world")

local abilityCts = require("@cts/ability")
local Attack = abilityCts.Attack
local Cooldown = abilityCts.Cooldown
local UsingAbility = abilityCts.UsingAbility
local Duration = abilityCts.Duration
local Combo = abilityCts.Combo

local baseCts = require("@cts/base")
local Lifetime = baseCts.Lifetime

local attackConfig = {
	cooldown = 0.25,
	duration = 0.5,
	comboLifetime = 1,
}

local function canAttack(characterEntity)
	return not world:has(characterEntity, pair(Cooldown, Attack))
		and not world:has(characterEntity, pair(UsingAbility, Attack))
end

local function attackInput()
	for _, player in blink.UseAttackAbility.Iter() do
		local characterEntity = ref(player.Character)

		if canAttack(characterEntity) then
			local attackEntity = world:entity()
			local adjustedCooldown = attackConfig.cooldown - player:GetNetworkPing()
			local adjustedDuration = attackConfig.duration - player:GetNetworkPing()

			world:add(attackEntity, Attack)
			world:set(attackEntity, pair(ChildOf, characterEntity))

			if world:has(characterEntity, Combo) then
				world:set(characterEntity, Combo, (world:get(characterEntity, Combo) :: number) + 1)
				world:remove(characterEntity, pair(Lifetime, Combo))
			else
				world:set(characterEntity, Combo, 1)
			end

			world:set(attackEntity, Duration, adjustedDuration)
			world:add(characterEntity, pair(UsingAbility, Attack))
			world:set(characterEntity, pair(Cooldown, Attack), adjustedCooldown)
		end
	end
end

return {
	system = attackInput,
}
