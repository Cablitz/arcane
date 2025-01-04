local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require("@packages/jecs")
local blink = require("@blink/client")

local pair = jecs.pair
local ChildOf = jecs.ChildOf
local std = require("@common/std")
local world = std.world
local ref = std.ref

local cts = require("@common/cts")
local Particle = cts.Particle
local Lifetime = cts.Lifetime
local Renderable = cts.Renderable
local Highlight = cts.Highlight

local particleUtils = require("@client/utils/particle-utils")

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
    for _, targetCharacter in blink.CharacterHit.Iter() do
        local targetEntity = ref(targetCharacter)
        local bloodParticle = particleUtils.createParticle(particles.blood, targetCharacter)
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

        particleUtils.emitParticle(bloodParticle)
    end
end

return {
    system = applyHit,
}
