local jecs = require("@packages/jecs")
local matter = require("@packages/matter")
local blink = require("@blink/server")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local world = require("@std/world")
local ref = require("@std/ref")

local playerCts = require("@cts/player")
local Player = playerCts.Player
local CharacterRef = playerCts.CharacterRef

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Humanoid = characterCts.Humanoid
local Human = characterCts.Human
local Animator = characterCts.Animator

local function addCharacters()
    for playerEntity, player in world:query(Player):iter() do
        for _, character in matter.useEvent(player, "CharacterAdded") do
            local characterEntity = ref(character)
            world:set(characterEntity, Character, character)
            world:set(characterEntity, Humanoid, character:WaitForChild("Humanoid"))
            world:set(characterEntity, pair(ChildOf, playerEntity))
            world:add(characterEntity, Human)
            world:add(playerEntity, pair(CharacterRef, characterEntity))

            blink.AddCharacter.FireAll(player, character)
        end
    end
end

local rig = workspace.rig
local rigEntity = ref(rig)
world:set(rigEntity, Character, rig)
world:set(rigEntity, Humanoid, rig:WaitForChild("Humanoid"))
world:set(rigEntity, Animator, rig.Humanoid:WaitForChild("Animator"))

return {
    system = addCharacters,
}
