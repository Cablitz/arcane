local start = require("@common/start")
local state = require("@common/constants/client-state")

start(script.Parent:WaitForChild("systems"):GetChildren(), state)
