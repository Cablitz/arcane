local jecs = require("@packages/jecs")

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
	Damage: Entity<number>,
	Health: Entity<number>,
	Hit: Entity,
	Hits: Entity,
	Hitbox: Entity,
} = {
	Damage = world:component(),
	Health = world:component(),
	Hit = world:component(),
	Hits = world:component(),
	Hitbox = world:component(),
}

return cts
