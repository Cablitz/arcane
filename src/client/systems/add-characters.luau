local blink = require("@blink/client")
local jecs = require("@packages/jecs")

local std = require("@common/std")
local ref = std.ref
local world = std.world

local cts = require("@common/cts")
local Character = cts.Character

local function addCharacters()
    for _, player, character in blink.AddCharacter.Iter() do
        local playerEntity = ref(player)
        local characterEntity = ref(character)
        world:set(characterEntity, Character, character)
        world:set(characterEntity, jecs.pair(jecs.ChildOf, playerEntity))
    end
end

return {
    system = addCharacters,
}
