local jecs = require("@packages/jecs")

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
    Attack: Entity,
    Active: Entity,
    Cooldown: Entity,
    Duration: Entity,
} = {
    Attack = world:component(),
    Active = world:component(),
    Cooldown = world:component(),
    Duration = world:component(),
}

return cts
