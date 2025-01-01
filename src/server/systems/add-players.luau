local Players = game:GetService("Players")

local std = require("@common/std")
local collect = std.collect
local ref = std.ref
local world = std.world

local cts = require("@common/cts")
local Player = cts.Player

local playersAdded = collect(Players.PlayerAdded)

local function addPlayers()
    for _, player in playersAdded do
        local playerEntity = ref(player)
        world:set(playerEntity, Player, player)
        print("Added player", player)
    end
end

return {
    system = addPlayers,
}