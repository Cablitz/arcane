local world = require("@std/world")

local baseCts = require("@cts/base")
local Renderable = baseCts.Renderable
local Lifetime = baseCts.Lifetime

local effectCts = require("@cts/effect")
local Highlight = effectCts.Highlight

local function fadeHighlights()
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
