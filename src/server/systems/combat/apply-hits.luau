local blink = require("@blink/server")
local jecs = require("@packages/jecs")

local pair = jecs.pair
local world = require("@std/world")

local combatCts = require("@cts/combat")
local Hit = combatCts.Hit
local Hits = combatCts.Hits
local Damage = combatCts.Damage

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Human = characterCts.Human
local Ragdoll = characterCts.Ragdoll
local Root = characterCts.Root

local playerCts = require("@cts/player")
local Player = playerCts.Player

local abilityCts = require("@cts/ability")
local Combo = abilityCts.Combo

local animationCts = require("@cts/animation")
local Animation = animationCts.Animation

local physicsCts = require("@cts/physics")
local Velocity = physicsCts.Velocity

local baseCts = require("@cts/base")
local Target = baseCts.Target
local Source = baseCts.Source
local Lifetime = baseCts.Lifetime

local function applyHit()
	for hitEntity, hit in world:query(Hit):iter() do
		local attackerRef = world:target(hitEntity, Source)
		local targetRef = world:target(hitEntity, Target)
		local targetCharacter = world:get(targetRef, Character)
		local targetRoot = world:get(targetRef, Root)
		local attackerRoot = world:get(attackerRef, Root)

		blink.HitCharacter.FireAll(targetCharacter)

		if not world:has(targetRef, Human) then
			local hitAnimations = world:get(targetRef, pair(Animation, Hits)) :: { AnimationTrack }
			hitAnimations[math.random(1, 3)]:Play()
		end

		local damageEntity = world:entity()
		world:add(damageEntity, pair(Target, targetRef))
		world:add(damageEntity, pair(Source, attackerRef))
		world:set(damageEntity, Damage, hit)

		if world:get(attackerRef, Combo) == 4 then
			world:add(targetRef, Ragdoll)
			world:set(targetRef, pair(Lifetime, Ragdoll), 3)

			local knockbackLookVector = (targetRoot.Position - attackerRoot.Position).Unit

			targetRoot:ApplyAngularImpulse(Vector3.new(-90, 0, 0))
			world:set(targetRef, Velocity, knockbackLookVector * 30)
			world:set(targetRef, pair(Lifetime, Velocity), 0.25)
		end

		world:delete(hitEntity)
	end
end

return {
	system = applyHit,
}
