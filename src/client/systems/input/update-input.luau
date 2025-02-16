local planck = require("@packages/planck")

local clientState = require("@shared/constants/client-state")

type ClientState = clientState.ClientState

local function updateInput(state: ClientState)
	state.input.actions:update(state.input.state, state.input.map)
	state.input.state:clear()
end

return {
	system = updateInput,
	phase = planck.Phase.PreRender,
}
