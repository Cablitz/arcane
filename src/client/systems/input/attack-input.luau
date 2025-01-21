local jecs = require("@packages/jecs")
local blink = require("@blink/client")

local pair = jecs.pair
local ChildOf = jecs.ChildOf

local world = require("@std/world")

local characterCts = require("@cts/character")
local Character = characterCts.Character
local Client = characterCts.Client

local baseCts = require("@cts/base")
local Lifetime = baseCts.Lifetime

local abilityCts = require("@cts/ability")
local Attack = abilityCts.Attack
local Cooldown = abilityCts.Cooldown
local Active = abilityCts.Active
local Duration = abilityCts.Duration
local Combo = abilityCts.Combo

local animationCts = require("@cts/animation")
local Animation = animationCts.Animation

local clientState = require("@common/constants/client-state")
type ClientState = clientState.ClientState

local attackConfig = {
    cooldown = 0.5,
    duration = 0.75,
    comboLifetime = 1,
}

local function canAttack(characterEntity)
    return not world:has(characterEntity, pair(Cooldown, Attack)) and not world:has(characterEntity, pair(Active, Attack))
end

local function attackInput(state: ClientState)
    for characterEntity, character in world:query(Character):with(Client):iter() do
        if canAttack(characterEntity) and state.input.actions:justPressed("attack") then
            local attackEntity = world:entity()
            local attackAnimation = world:get(characterEntity, pair(Animation, Attack)) :: AnimationTrack
            
            world:add(attackEntity, Attack)
            world:set(attackEntity, pair(ChildOf, characterEntity))

            -- Initilization of attack by spawning parts, animations, components, etc
            attackAnimation:Play()

            world:set(attackEntity, Duration, attackConfig.duration)
            world:add(characterEntity, pair(Active, Attack))
            world:set(characterEntity, pair(Cooldown, Attack), attackConfig.cooldown)

            local comboEntity = world:target(characterEntity, Combo)
            if comboEntity then
                local currentCombo = world:get(comboEntity, Combo)
                world:set(comboEntity, Combo, currentCombo + 1)
                world:remove(comboEntity, Lifetime)
            else
                comboEntity = world:entity()
                world:set(comboEntity, Combo, 1)
                world:set(characterEntity, pair(Combo, comboEntity))
            end
            print("Current combo number ", world:get(comboEntity, Combo))

            blink.UseAttackAbility.Fire()
        end
    end
end

return {
    system = attackInput,
}