local matter = require("@packages/matter")
local planck = require("@packages/planck")

local clientState = require("@common/constants/client-state")

type ClientState = clientState.ClientState

local function testInput(state: ClientState)
    if state.input.actions:justPressed("walk") then
        -- print("Walk", matter.useDeltaTime())
    end

    if state.input.actions:justReleased("walk") then
        -- print("Walk released")
    end

    if state.input.actions:justPressed("jump") then
        -- print("Jump")
    end
end

return {
    system = testInput,
    phase = planck.Phase.Update,
}
