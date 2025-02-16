local jecs = require("@packages/jecs")

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
	Character: Entity<Model>,
	Humanoid: Entity<Humanoid>,
	Animator: Entity<Animator>,
	Ragdoll: Entity,
	Client: Entity,
	Human: Entity,
	Setup: Entity,
	Root: Entity<BasePart>,
} =
	{
		Character = world:component(),
		Humanoid = world:component(),
		Animator = world:component(),
		Ragdoll = world:component(),
		Client = world:component(),
		Human = world:entity(),
		Setup = world:entity(),
		Root = world:component(),
	}

return cts
