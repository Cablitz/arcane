local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local PlanckJabby = require("@packages/planck-jabby")
local jabby = require("@packages/jabby")
local matterHooks = require("@packages/matter-hooks")
local planck = require("@packages/planck")
local planckRunService = require("@packages/planck-runservice")

local Scheduler = planck.Scheduler
local jabbyPlugin = PlanckJabby.new()
local runServicePlugin = planckRunService.Plugin.new()
local hooksPlugin = matterHooks.Plugin.new(ReplicatedStorage.packages[".pesde"]["matter-ecs_matter@0.8.5"])

local function start(containers: { Instance }, state)
	-- stylua: ignore
	local scheduler = Scheduler.new(state)
		:addPlugin(jabbyPlugin)
		:addPlugin(runServicePlugin)
		:addPlugin(hooksPlugin)

	for _, container in containers do
		for _, module in container:GetDescendants() do
			if module:IsA("ModuleScript") then
				scheduler:addSystem(require(module))
			end
		end
	end

	jabby.set_check_function(function(player)
		return true
	end)

	if RunService:IsClient() then
		local player = Players.LocalPlayer
		local playerGui = player:WaitForChild("PlayerGui")
		local client = jabby.obtain_client()
		UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.F4 then
				local home = playerGui:FindFirstChild("Home")
				if home then
					home:Destroy()
				end
				client.spawn_app(client.apps.home)
			end
		end)
	end
end

return start
