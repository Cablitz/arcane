local ReplicatedStorage = game:GetService("ReplicatedStorage")
local start = require("@shared/start")
local state = require("@shared/constants/client-state")

start({
	script.Parent:WaitForChild("systems"),
	ReplicatedStorage.shared.systems,
}, state)
