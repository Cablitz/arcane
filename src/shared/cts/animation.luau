local jecs = require("@packages/jecs")

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
	Animation: Entity,
} = {
	Animation = world:component(),
}

return cts
