local jecs = require("@packages/jecs")
local matter = require("@packages/matter")

local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Player = cts.Player
local Character = cts.Character

local function addCharacters()
    for id, player in world:query(Player):iter() do
        for _, character in matter.useEvent(player, "CharacterAdded") do
            local characterEntity = world:entity()
            world:set(characterEntity, Character, character)
            print("Added character", character, matter.useDeltaTime())
        end
    end
end

return {
    system = addCharacters,
}
