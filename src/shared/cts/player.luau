local jecs = require("@packages/jecs")

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
	Player: Entity,
	CharacterRef: Entity<number>,
} = {
	Player = world:component(),
	CharacterRef = world:component(),
}

return cts
