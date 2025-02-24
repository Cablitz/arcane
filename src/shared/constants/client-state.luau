local matter = require("@packages/matter")
local spark = require("@packages/spark")

local InputState = spark.InputState
local Actions = spark.Actions
local InputMap = spark.InputMap
local VirtualAxis2d = spark.VirtualAxis2d

local clientState = {
	input = {
		state = InputState.new(),
		actions = Actions.new({ "walk", "jump", "attack" }) :: typeof(Actions.new(...)) & {
			justPressed: (self: typeof(Actions.new(...)), action: string) -> boolean,
			justReleased: (self: typeof(Actions.new(...)), action: string) -> boolean,
		},
		map = InputMap.new()
			:insert("jump", Enum.KeyCode.Space, Enum.KeyCode.ButtonA)
			:insert("attack", Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR1)
			:insert("walk", VirtualAxis2d.wasd(), Enum.KeyCode.Thumbstick1),
	},
}

export type ClientState = typeof(clientState)

function clientState.input.actions:justPressed(action: string): boolean
	local signal = self:justPressedSignal(action)
	local iterator = matter.useEvent(action, signal)

	return iterator() ~= nil
end

function clientState.input.actions:justReleased(action: string): boolean
	local signal = self:justReleasedSignal(action)
	local iterator = matter.useEvent(action, signal)

	return iterator() ~= nil
end

return clientState
