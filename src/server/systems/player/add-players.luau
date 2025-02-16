local Players = game:GetService("Players")

local blink = require("@blink/server")

local collect = require("@std/collect")
local ref = require("@std/ref")
local world = require("@std/world")

local playerCts = require("@cts/player")
local Player = playerCts.Player

local playersAdded = collect(Players.PlayerAdded)

local function addPlayers()
	for _, player in playersAdded do
		local playerEntity = ref(player)
		world:set(playerEntity, Player, player)
		blink.AddPlayer.FireAll(player :: Player)
	end
end

return {
	system = addPlayers,
}
