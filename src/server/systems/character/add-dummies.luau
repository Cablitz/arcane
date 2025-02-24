local ServerStorage = game:GetService("ServerStorage")
local planck = require("@packages/planck")

local dummies = ServerStorage.dummies

local ref = require("@std/ref")
local world = require("@std/world")

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Setup = characterCts.Setup

local function addDummies() end

for _, dummy in dummies:GetChildren() do
	local dummyInstance = dummy:Clone()
	dummyInstance.Parent = workspace

	local dummyEntity = ref(dummyInstance)
	world:set(dummyEntity, Character, dummyInstance)
	world:add(dummyEntity, Setup)
end

return {
	system = addDummies,
}
