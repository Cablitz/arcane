local jecs = require("@packages/jecs")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local std = require("@common/std")
local world = std.world

local cts = require("@common/cts")
local Character = cts.Character
local Client = cts.Client
local Attack = cts.Attack
local Cooldown = cts.Cooldown
local Active = cts.Active
local Animation = cts.Animation

local clientState = require("@common/constants/client-state")
type ClientState = clientState.ClientState

local function canAttack(characterEntity)
    return not world:has(characterEntity, pair(Cooldown, Attack)) and not world:has(characterEntity, pair(Active, Attack))
end

local function charactersAttack(state: ClientState)
    for characterEntity, character in world:query(Character):with(Client):iter() do
        if canAttack(characterEntity) and state.input.actions:justPressed("attack") then
            local attackEntity = world:entity()
            world:add(attackEntity, Attack)
            world:set(attackEntity, pair(ChildOf, characterEntity))

            -- Initilization of attack by spawning parts, animations, components, etc
            local animation = world:get(characterEntity, pair(Animation, Attack))
            animation:Play()

            world:add(characterEntity, pair(Active, Attack))
            world:set(characterEntity, pair(Cooldown, Attack), 0.5)
        end
    end
end

return {
    system = charactersAttack,
}
