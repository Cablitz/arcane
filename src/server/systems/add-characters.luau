local jecs = require("@packages/jecs")
local matter = require("@packages/matter")
local blink = require("@blink/server")

local std = require("@common/std")
local world = std.world
local ref = std.ref

local cts = require("@common/cts")
local Player = cts.Player
local Character = cts.Character

local function addCharacters()
    for playerEntity, player in world:query(Player):iter() do
        for _, character in matter.useEvent(player, "CharacterAdded") do
            local characterEntity = ref(character)
            world:set(characterEntity, Character, character)
            world:set(characterEntity, jecs.pair(jecs.ChildOf, playerEntity))
            blink.AddCharacter.FireAll(player, character)
        end
    end
end

return {
    system = addCharacters,
}
