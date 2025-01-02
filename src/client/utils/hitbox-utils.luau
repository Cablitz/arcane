local exports = {}

local Debris = game:GetService("Debris")

type HitboxConfig = {
    hitboxSize: Vector3,
    hitboxOffset: Vector3,
    hitboxDuration: number,
}

local function createHitboxHighlight(part: BasePart): SelectionBox
    local highlight = Instance.new("SelectionBox")
    highlight.Adornee = part
    highlight.LineThickness = 0.05
    highlight.SurfaceTransparency = 1
    highlight.Transparency = 0.5
    highlight.Color3 = Color3.fromRGB(166, 0, 0)
    highlight.Visible = true
    
    return highlight
end

function exports.createHitbox(character, hitboxConfig: HitboxConfig): BasePart
    local part = Instance.new("Part")
    part.Transparency = 0.65
    part.Color = Color3.fromRGB(17, 17, 17)
    part.Size = hitboxConfig.hitboxSize
    part.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(hitboxConfig.hitboxOffset)
    part.CanCollide = false
    part.Anchored = true        

    local highlight = createHitboxHighlight(part)
    highlight.Parent = part
    
    part.Parent = workspace
    Debris:AddItem(part, hitboxConfig.hitboxDuration)

    return part
end

function exports.scanHitbox(part: BasePart, excludeList: {Instance}): {Model}
    local overlapParams = OverlapParams.new()
    overlapParams.FilterDescendantsInstances = excludeList
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local hitCharacters = {}
    for _, hitPart in workspace:GetPartsInPart(part, overlapParams) do
        local character = hitPart.Parent :: Model
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")

        if humanoid and not table.find(hitCharacters, character) then
            table.insert(hitCharacters, character)
        end
    end
    
    return hitCharacters
end

function exports.findClosestCharacter(character, hitCharacters: {Model}): Model
    local closestCharacter = nil
    local closestDistance = math.huge

    for _, hitCharacter in hitCharacters do
        local distance = (character.HumanoidRootPart.Position - hitCharacter.HumanoidRootPart.Position).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestCharacter = hitCharacter
        end
    end

    return closestCharacter
end

return exports
