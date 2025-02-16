local jecs = require("@packages/jecs")

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
	Attack: Entity,
	Attacks: Entity,
	Combo: Entity<number>,
	UsingAbility: Entity,
	Cooldown: Entity,
	Duration: Entity,
} =
	{
		Attack = world:component(),
		Attacks = world:component(),
		Combo = world:component(),
		UsingAbility = world:component(),
		Cooldown = world:component(),
		Duration = world:component(),
	}

return cts
