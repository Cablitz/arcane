local matter = require("@packages/matter")
local jecs = require("@packages/jecs")

local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Attack = cts.Attack
local Active = cts.Active

local pair = jecs.pair

local function attack()
    for attackEntity in world:query(Attack):iter() do
        if matter.useThrottle(3) then
            local characterEntity = world:parent(attackEntity)
            world:remove(characterEntity, pair(Active, Attack))
            world:delete(attackEntity)
        end
    end
end

return {
    system = attack,
}
