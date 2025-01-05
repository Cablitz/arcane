local jecs = require("@packages/jecs")

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
    Player: Entity,
} = {
    Player = world:component(),
}

return cts
