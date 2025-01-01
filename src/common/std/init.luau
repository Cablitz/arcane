local jecs = require("@packages/jecs")

local world = require(script.world) :: jecs.World
export type World = jecs.World

local std = {
    world = world :: World,
    collect = require(script.collect),
    ref = require(script.ref),
}

return std
