local jecs = require("@packages/jecs")

local pair = jecs.pair
local Previous = jecs.Rest

local world = require("@std/world")

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Ragdoll = characterCts.Ragdoll

local function ragdoll()
    for characterEntity, character in world:query(Character):with(Ragdoll):without(pair(Previous, Ragdoll)):iter() do
        print("Ragdoll added")

        world:add(characterEntity, pair(Previous, Ragdoll))
    end
end

return {
    system = ragdoll,
}