local jecs = require("@packages/jecs")

local OnRemove = jecs.OnRemove

local world = require("@std/world")

type Entity<T = nil> = jecs.Entity<T>

local cts: {
    Renderable: Entity<Model>,
    Lifetime: Entity<number>,
} = {
    Renderable = world:component(),
    Lifetime = world:component(),
}

world:set(cts.Renderable, OnRemove, function(entity)
    local renderable = world:get(entity, cts.Renderable)
    renderable:Destroy()
end)

return cts
