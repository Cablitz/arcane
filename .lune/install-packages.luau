local fs = require("@lune/fs")

local logger = require("./lib/logger").new(4)
local executeCommand = require("./lib/executeCommand")

if fs.isDir("roblox_packages") then
	fs.removeDir("roblox_packages")
end

local status = executeCommand("pesde", {
	"install",
}, {
	stdio = "inherit",
}, true)

if not status.ok then
	logger:error("Failed to install packages!")
	return
end

if not fs.isDir("roblox_packages") then
	fs.writeDir("roblox_packages")
end

-- do this so the project file doesn't refer to files that don't exist and cause rojo to fail
if fs.isFile("network.blink") then
	executeCommand("blink", { "network.blink" })
end

executeCommand("rojo", {
	"sourcemap",
	fs.isFile("sourcemap.project.json") and "sourcemap.project.json" or "default.project.json",
	"-o",
	"sourcemap.json",
})

logger:info("Installed packages!")
