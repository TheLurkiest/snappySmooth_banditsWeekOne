-- BurgerBanditModOptions.lua
-- These are the default options.
local OPTIONS = {}

-- <-------------------- put the ACTUAL lines in HERE, not at the end for local key_gata_PLACEHOLDER_Keyboard_getCore():getKey("PLACEHOLDER_Keyboard_KEY_B") = { key = Keyboard.getCore():getKey("PLACEHOLDER_Keyboard_KEY_B"), name = "PLACEHOLDER_Keyboard_getCore():getKey("PLACEHOLDER_Keyboard_KEY_B")",} ...........and the rest! FirstLines.lua goes here!

local key_gata_PLACEHOLDER_Keyboard_KEY_NUMPADCOMMA = { key = Keyboard.KEY_NUMPADCOMMA, name = "PLACEHOLDER_Keyboard_KEY_NUMPADCOMMA",}
local key_gata_PLACEHOLDER_Keyboard_KEY_3 = { key = Keyboard.KEY_3, name = "PLACEHOLDER_Keyboard_KEY_3",}
local key_gata_PLACEHOLDER_Keyboard_KEY_7 = { key = Keyboard.KEY_7, name = "PLACEHOLDER_Keyboard_KEY_7",}
local key_gata_PLACEHOLDER_Keyboard_KEY_8 = { key = Keyboard.KEY_8, name = "PLACEHOLDER_Keyboard_KEY_8",}
local key_gata_PLACEHOLDER_Keyboard_KEY_9 = { key = Keyboard.KEY_9, name = "PLACEHOLDER_Keyboard_KEY_9",}
local key_gata_PLACEHOLDER_Keyboard_KEY_ESCAPE = { key = Keyboard.KEY_ESCAPE, name = "PLACEHOLDER_Keyboard_KEY_ESCAPE",}
local key_gata_PLACEHOLDER_Keyboard_KEY_C = { key = Keyboard.KEY_C, name = "PLACEHOLDER_Keyboard_KEY_C",}
local key_gata_PLACEHOLDER_Keyboard_KEY_G = { key = Keyboard.KEY_G, name = "PLACEHOLDER_Keyboard_KEY_G",}
local key_gata_PLACEHOLDER_Keyboard_KEY_F = { key = Keyboard.KEY_F, name = "PLACEHOLDER_Keyboard_KEY_F",}
local key_gata_PLACEHOLDER_Keyboard_KEY_H = { key = Keyboard.KEY_H, name = "PLACEHOLDER_Keyboard_KEY_H",}
local key_gata_PLACEHOLDER_Keyboard_KEY_N = { key = Keyboard.KEY_N, name = "PLACEHOLDER_Keyboard_KEY_N",}
local key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD0 = { key = Keyboard.KEY_NUMPAD0, name = "PLACEHOLDER_Keyboard_KEY_NUMPAD0",}
local key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD3 = { key = Keyboard.KEY_NUMPAD3, name = "PLACEHOLDER_Keyboard_KEY_NUMPAD3",}
local key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD7 = { key = Keyboard.KEY_NUMPAD7, name = "PLACEHOLDER_Keyboard_KEY_NUMPAD7",}
local key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD8 = { key = Keyboard.KEY_NUMPAD8, name = "PLACEHOLDER_Keyboard_KEY_NUMPAD8",}
local key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD9 = { key = Keyboard.KEY_NUMPAD9, name = "PLACEHOLDER_Keyboard_KEY_NUMPAD9",}
local key_gata_PLACEHOLDER_Keyboard_KEY_Q = { key = Keyboard.KEY_Q, name = "PLACEHOLDER_Keyboard_KEY_Q",}
local key_gata_PLACEHOLDER_Keyboard_KEY_S = { key = Keyboard.KEY_S, name = "PLACEHOLDER_Keyboard_KEY_S",}
local key_gata_PLACEHOLDER_Keyboard_KEY_W = { key = Keyboard.KEY_W, name = "PLACEHOLDER_Keyboard_KEY_W",}
local key_gata_PLACEHOLDER_Keyboard_KEY_X = { key = Keyboard.KEY_X, name = "PLACEHOLDER_Keyboard_KEY_X",}

-- Connecting the options to the menu, so user can change them.
if ModOptions and ModOptions.getInstance then

    -- ModOptions:getInstance(OPTIONS, "Bandits", "Bandits")

    ModOptions:getInstance(OPTIONS, "BurgerBandits", "BurgerBandits")

    local category = "[BurgerBandits]"

    -- <--------------- and put the rest of these in here!!! SecondLines.lua goes here!

    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_NUMPADCOMMA)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_3)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_7)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_8)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_9)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_ESCAPE)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_C)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_G)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_F)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_H)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_N)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD0)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD3)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD7)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD8)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_NUMPAD9)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_Q)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_S)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_W)
    ModOptions:AddKeyBinding(category, key_gata_PLACEHOLDER_Keyboard_KEY_X)

end

local function InitModOptions()
end

-- Check actual options at game loading.
Events.OnGameStart.Add(InitModOptions)
  

