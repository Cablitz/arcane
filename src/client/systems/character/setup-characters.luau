local Players = game:GetService("Players")

local blink = require("@blink/client")
local jecs = require("@packages/jecs")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local ref = require("@std/ref")
local world = require("@std/world")

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Animator = characterCts.Animator
local Humanoid = characterCts.Humanoid
local Client = characterCts.Client

local function setupCharacters()
	for _, character in blink.SetupCharacter.Iter() do
		local characterEntity = ref(character)
		world:set(characterEntity, Character, character)
		world:set(characterEntity, Humanoid, character:WaitForChild("Humanoid"))
		world:set(characterEntity, Animator, character.Humanoid:WaitForChild("Animator"))

		local player = Players:GetPlayerFromCharacter(character)
		if player then
			local playerEntity = ref(player)
			world:set(characterEntity, pair(ChildOf, playerEntity))

			if player == Players.LocalPlayer then
				world:add(characterEntity, Client)
			end
		end
	end
end

return {
	system = setupCharacters,
}
