local jecs = require("@packages/jecs")
local ragdollUtils = require("@shared/utils/ragdoll-utils")
local pair = jecs.pair
local Previous = jecs.Rest

local world = require("@std/world")

local replaceJoints = ragdollUtils.replaceJoints
local resetJoints = ragdollUtils.resetJoints
local ragdollHumanoidState = ragdollUtils.ragdollHumanoidState
local unragdollHumanoidState = ragdollUtils.unragdollHumanoidState

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Humanoid = characterCts.Humanoid
local Human = characterCts.Human
local Ragdoll = characterCts.Ragdoll

local function ragdoll()
	for characterEntity, character, humanoid in
		world:query(Character, Humanoid):with(Ragdoll):without(pair(Previous, Ragdoll)):iter()
	do
		print("Ragdoll added")

		replaceJoints(character)

		if world:has(characterEntity, Human) then
			humanoid.AutoRotate = false
		else
			ragdollHumanoidState(humanoid)
		end

		world:add(characterEntity, pair(Previous, Ragdoll))
	end

	for characterEntity, character, humanoid in
		world:query(Character, Humanoid):with(pair(Previous, Ragdoll)):without(Ragdoll):iter()
	do
		print("Ragdoll removed")

		resetJoints(character)

		if world:has(characterEntity, Human) then
			humanoid.AutoRotate = true
		else
			unragdollHumanoidState(humanoid)
		end

		world:remove(characterEntity, pair(Previous, Ragdoll))
	end
end

return {
	system = ragdoll,
}
