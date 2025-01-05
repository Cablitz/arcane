local jecs = require("@packages/jecs")

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
    Character: Entity<Model>,
    Humanoid: Entity<Humanoid>,
    Animator: Entity<Animator>,
    Client: Entity,
} = {
    Character = world:component(),
    Humanoid = world:component(),
    Animator = world:component(),
    Client = world:component(),
}

return cts
