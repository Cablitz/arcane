local jecs = require("@packages/jecs")

local std = require("@common/std")
local world = std.world

type Entity<T = nil> = jecs.Entity<T>

local components: {
    Character: Entity<Model>,
    Player: Entity<Player>,
    Client: Entity,
    Active: Entity,
    Cooldown: Entity,
    Attack: Entity,
    Walk: Entity,
} = {
    Character = world:component(),
    Player = world:component(),
    Client = world:component(),
    Active = world:component(),
    Cooldown = world:component(),
    Attack = world:component(),
    Walk = world:component(),
}

return components