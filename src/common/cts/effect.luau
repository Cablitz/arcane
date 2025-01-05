local jecs = require("@packages/jecs")

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
    Particle: Entity,
    Highlight: Entity,
} = {
    Particle = world:component(),
    Highlight = world:component(),
}

return cts
