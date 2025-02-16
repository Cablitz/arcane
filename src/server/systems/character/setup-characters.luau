local Players = game:GetService("Players")
local blink = require("@blink/server")
local jecs = require("@packages/jecs")
local ragdollUtils = require("@shared/utils/ragdoll-utils")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local world = require("@std/world")
local ref = require("@std/ref")

local setupRagdoll = ragdollUtils.setupRagdoll

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Setup = characterCts.Setup
local Human = characterCts.Human
local Humanoid = characterCts.Humanoid
local Animator = characterCts.Animator
local Root = characterCts.Root

local playerCts = require("@cts/player")
local CharacterRef = playerCts.CharacterRef

local function setupCharacters()
    for characterEntity, character in world:query(Character):with(Setup):iter() do
        world:set(characterEntity, Root, character:WaitForChild("HumanoidRootPart"))
        world:set(characterEntity, Humanoid, character:WaitForChild("Humanoid"))

        setupRagdoll(character)

        local player = Players:GetPlayerFromCharacter(character)
        if player then
            local playerEntity = ref(player)
            world:add(characterEntity, Human)
            world:set(characterEntity, pair(ChildOf, playerEntity))
            world:add(playerEntity, pair(CharacterRef, characterEntity))
        else
            world:set(characterEntity, Animator, character.Humanoid:WaitForChild("Animator"))
        end

        blink.SetupCharacter.FireAll(character)
        world:remove(characterEntity, Setup)
    end
end

return {
    system = setupCharacters,
}
