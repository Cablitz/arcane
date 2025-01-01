local blink = require("@blink/client")

local std = require("@common/std")
local ref = std.ref
local world = std.world
local cts = require("@common/cts")
local Player = cts.Player

local function addPlayers()
    for _, player in blink.AddPlayer.Iter() do
        local playerEntity = ref(player)
        world:set(playerEntity, Player, player)
    end
end

return {
    system = addPlayers,
}