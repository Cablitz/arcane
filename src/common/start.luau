local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local planck = require("@packages/planck")
local jabby = require("@packages/jabby")
local PlanckJabby = require("@packages/planck-jabby")
local matterHooks = require("@packages/matter-hooks")

local world = require("@std/world")

local jabbyPlugin = PlanckJabby.new()
local hooksPlugin = matterHooks.Plugin.new(ReplicatedStorage.packages._Index["matter-ecs_matter@0.8.5"])

local function start(containers: {Instance}, state)
    local scheduler = planck.Scheduler.new(state)
        :addPlugin(jabbyPlugin)
        :addPlugin(hooksPlugin)

    jabby.register({
        applet = jabby.applets.world,
        name = "world",
        configuration = {
            world = world,
        }
    })

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