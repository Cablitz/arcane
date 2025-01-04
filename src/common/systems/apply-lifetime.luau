local matter = require("@packages/matter")

local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Lifetime = cts.Lifetime

local function applyLifetime()
    for id, lifetime in world:query(Lifetime):iter() do
        local remainingLifetime = lifetime - matter.useDeltaTime()
        if remainingLifetime <= 0 then
            world:delete(id)
        else
            world:set(id, Lifetime, remainingLifetime)
        end
    end
end

return {
    system = applyLifetime,
}
