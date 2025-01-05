local matter = require("@packages/matter")

local world = require("@std/world")

local baseCts = require("@cts/base")
local Lifetime = baseCts.Lifetime

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
