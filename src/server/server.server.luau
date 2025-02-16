local ReplicatedStorage = game:GetService("ReplicatedStorage")
local start = require("@shared/start")

start({
    script.Parent:WaitForChild("systems"),
    ReplicatedStorage.shared.systems,
})
