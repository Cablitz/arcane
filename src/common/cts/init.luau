local jecs = require("@packages/jecs")

local OnRemove = jecs.OnRemove

local std = require("@common/std")
local world = std.world

type Entity<T = nil> = jecs.Entity<T>

local cts: {
    Character: Entity<Model>,
    Player: Entity<Player>,
    Humanoid: Entity<Humanoid>,
    Animator: Entity<Animator>,
    Renderable: Entity<Model>,
    Client: Entity,
    Active: Entity,
    Duration: Entity<number>,
    Cooldown: Entity,
    Attack: Entity,
    Hitbox: Entity,
    Walk: Entity,
    Animation: Entity,
    Hit: Entity<{
        attacker: Entity,
        damage: number,
    }>,
    Damage: Entity<number>,
    Health: Entity<number>,
    Particle: Entity,
    Lifetime: Entity<number>,
    Highlight: Entity,
} = {
    Character = world:component(),
    Player = world:component(),
    Humanoid = world:component(),
    Animator = world:component(),
    Renderable = world:component(),
    Client = world:component(),
    Active = world:component(),
    Duration = world:component(),
    Cooldown = world:component(),
    Attack = world:component(),
    Hitbox = world:component(),
    Walk = world:component(),
    Animation = world:component(),
    Hit = world:component(),
    Damage = world:component(),
    Health = world:component(),
    Particle = world:component(),
    Lifetime = world:component(),
    Highlight = world:component(),
}

world:set(cts.Renderable, OnRemove, function(entity)
    local renderable = world:get(entity, cts.Renderable)
    renderable:Destroy()
end)

return cts
