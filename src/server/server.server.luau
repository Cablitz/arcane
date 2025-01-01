local ReplicatedStorage = game:GetService("ReplicatedStorage")
local start = require("@common/start")

start({
    script.Parent:WaitForChild("systems"),
    ReplicatedStorage.common.systems,
})
