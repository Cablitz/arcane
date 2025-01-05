local blink = require("@blink/client")

local ref = require("@std/ref")
local world = require("@std/world")

local playerCts = require("@cts/player")
local Player = playerCts.Player

local function addPlayers()
    for _, player in blink.AddPlayer.Iter() do
        local playerEntity = ref(player)
        world:set(playerEntity, Player, player)
    end
end

return {
    system = addPlayers,
}