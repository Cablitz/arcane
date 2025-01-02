local matter = require("@packages/matter")
local jecs = require("@packages/jecs")

local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Attack = cts.Attack
local Active = cts.Active
local Cooldown = cts.Cooldown
local Animation = cts.Animation

local pair = jecs.pair

local function attack()
    for attackEntity in world:query(Attack):iter() do
        local characterEntity = world:parent(attackEntity)
        local animation = world:get(characterEntity, pair(Animation, Attack))

        --[[
        world:remove(characterEntity, pair(Active, Attack))
        world:delete(attackEntity)
        ]]--
    end
end

return {
    system = attack,
}
