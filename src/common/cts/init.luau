local jecs = require("@packages/jecs")

local std = require("@common/std")
local world = std.world

type Entity<T = nil> = jecs.Entity<T>

local components: {
    Character: Entity<Model>,
    Player: Entity<Player>,
    Walk: Entity
} = {
    Character = world:component(),
    Player = world:component(),
    Walk = world:component(),
}

return components