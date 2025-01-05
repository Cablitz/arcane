local world = require("@std/world")

local cts = require("@common/cts")
local Renderable = cts.Renderable
local Highlight = cts.Highlight
local Lifetime = cts.Lifetime

function fadeHighlights()
    for highlightEntity, lifetime, renderable in world:query(Lifetime, Renderable):with(Highlight):iter() do
        -- Calculate fade based on lifetime
        -- Starting at 0.6, ending at 1.0, over 0.25 seconds
        local startTransparency = 0.6
        local endTransparency = 1
        local totalChange = endTransparency - startTransparency
        local progress = 1 - (lifetime / 0.25)
        
        renderable.FillTransparency = startTransparency + (totalChange * progress)
    end
end

return {
    system = fadeHighlights,
}
