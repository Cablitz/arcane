local jecs = require("@packages/jecs")

local pair = jecs.pair
local Previous = jecs.Rest

local world = require("@std/world")

local characterCts = require("@cts/character")
local Root = characterCts.Root

local physicsCts = require("@cts/physics")
local Velocity = physicsCts.Velocity

local baseCts = require("@cts/base")
local Renderable = baseCts.Renderable

local function applyVelocity()
	for characterEntity, root, velocity in world:query(Root, Velocity):without(pair(Previous, Velocity)):iter() do
		local linearVelocity = Instance.new("LinearVelocity")
		linearVelocity.VectorVelocity = velocity
		linearVelocity.MaxForce = math.huge
		linearVelocity.Attachment0 = root.RootAttachment
		linearVelocity.Parent = root

		world:set(characterEntity, pair(Renderable, Velocity), linearVelocity)
		world:set(characterEntity, pair(Previous, Velocity), velocity)
	end

	for characterEntity, root in world:query(Root):with(pair(Previous, Velocity)):without(Velocity):iter() do
		local linearVelocity = world:get(characterEntity, pair(Renderable, Velocity))
		linearVelocity:Destroy()

		world:remove(characterEntity, pair(Previous, Velocity))
	end
end

return applyVelocity
