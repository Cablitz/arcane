local jecs = require("@packages/jecs")

local OnRemove = jecs.OnRemove
local OnDeleteTarget = jecs.OnDeleteTarget
local Delete = jecs.Delete
local pair = jecs.pair

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
    Renderable: Entity<Model>,
    Lifetime: Entity<number>,
    Target: Entity,
    Source: Entity,
} = {
    Renderable = world:component(),
    Lifetime = world:component(),
    Target = world:component(),
    Source = world:component(),
}

world:set(cts.Renderable, OnRemove, function(entity)
    local renderable = world:get(entity, cts.Renderable)
    renderable:Destroy()
end)

world:add(cts.Target, pair(OnDeleteTarget, Delete))
world:add(cts.Source, pair(OnDeleteTarget, Delete))

return cts
