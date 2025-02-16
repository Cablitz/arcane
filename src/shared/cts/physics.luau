local jecs = require("@packages/jecs")

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
	Velocity: Entity<Vector3>,
} = {
	Velocity = world:component(),
}

return cts
