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

    table.insert(jabby.public, {
        class_name = "World",
        name = "MyWorld",
        world = world,
        debug = "Main",
        entities = {},
    })

    jabby.public.updated = true

    for _, container in containers do
        for _, module: ModuleScript in container:GetChildren() do
            scheduler:addSystem(require(module))
        end
    end

    jabby.set_check_function(function(player)
        return true
    end)

    if RunService:IsClient() then
        local player = Players.LocalPlayer
        local playergui = player:WaitForChild("PlayerGui")
        local client = jabby.obtain_client()
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.F4 then
                local home = playergui:FindFirstChild("Home")
                if home then
                    home:Destroy()
                end
                client.spawn_app(client.apps.home)
            end
        end)
    end
end

return start