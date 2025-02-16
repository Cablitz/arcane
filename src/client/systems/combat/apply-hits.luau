local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require("@packages/jecs")
local blink = require("@blink/client")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local ref = require("@std/ref")
local world = require("@std/world")

local baseCts = require("@cts/base")
local Renderable = baseCts.Renderable
local Lifetime = baseCts.Lifetime

local effectCts = require("@cts/effect")
local Particle = effectCts.Particle
local Highlight = effectCts.Highlight

local characterCts = require("@cts/character")
local Client = characterCts.Client
local Root = characterCts.Root

local physicsCts = require("@cts/physics")
local Velocity = physicsCts.Velocity

local particleUtils = require("@client/utils/particle-utils")
local createParticle = particleUtils.createParticle
local emitParticle = particleUtils.emitParticle

local particles = ReplicatedStorage.particles

local function createHitHighlight(character: Model)
	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(255, 0, 0)
	highlight.FillTransparency = 0.6
	highlight.OutlineTransparency = 1
	highlight.Parent = character

	return highlight
end

local function applyHit()
	for _, targetCharacter in blink.HitCharacter.Iter() do
		local targetEntity = ref(targetCharacter)
		local bloodParticle = createParticle(particles.blood, targetCharacter)
		local hitHighlight = createHitHighlight(targetCharacter)

		local particleEntity = world:entity()
		world:add(particleEntity, Particle)
		world:set(particleEntity, Lifetime, 1)
		world:set(particleEntity, Renderable, bloodParticle)
		world:set(particleEntity, pair(ChildOf, targetEntity))

		local highlightEntity = world:entity()
		world:add(highlightEntity, Highlight)
		world:set(highlightEntity, Lifetime, 0.25)
		world:set(highlightEntity, Renderable, hitHighlight)
		world:set(highlightEntity, pair(ChildOf, targetEntity))

		emitParticle(bloodParticle)
	end
end

return {
	system = applyHit,
}
