local Players = game:GetService("Players")

local blink = require("@blink/client")
local jecs = require("@packages/jecs")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local std = require("@common/std")
local ref = std.ref
local world = std.world

local cts = require("@common/cts")
local Character = cts.Character
local Client = cts.Client
local Animation = cts.Animation
local Animator = cts.Animator
local Attack = cts.Attack
local Humanoid = cts.Humanoid

local function loadAnimation(animator: Animator, animationId: number)
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animationId

    return animator:LoadAnimation(animation)
end

local function addCharacters()
    for _, player, character in blink.AddCharacter.Iter() do
        local playerEntity = ref(player)
        local characterEntity = ref(character)
        world:set(characterEntity, Character, character)
        world:set(characterEntity, Humanoid, character:WaitForChild("Humanoid"))
        world:set(characterEntity, Animator, character.Humanoid:WaitForChild("Animator"))
        world:set(characterEntity, pair(ChildOf, playerEntity))

        if player == Players.LocalPlayer then
            world:add(characterEntity, Client)
        end
    end
end

return {
    system = addCharacters,
}
