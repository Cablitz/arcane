local exports = {}

function exports.emitParticle(particle: BasePart)
    for _, instance in particle:GetDescendants() do
        if not instance:IsA("ParticleEmitter") then continue end

        local emitCount = instance:GetAttribute("EmitCount")
        local emitDuration = instance:GetAttribute("EmitDuration")

        instance:Emit(emitCount)

        if emitDuration then
            instance.Enabled = true
            task.delay(emitDuration, function()
                instance.Enabled = false
            end)
        end
    end
end

function exports.createParticle(particle: BasePart, character)
    local particleInstance = particle:Clone()
    particleInstance.Position = character.PrimaryPart.Position
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = character.PrimaryPart
    weld.Part1 = particleInstance
    weld.Parent = particleInstance

    particleInstance.Parent = character

    return particleInstance
end

return exports