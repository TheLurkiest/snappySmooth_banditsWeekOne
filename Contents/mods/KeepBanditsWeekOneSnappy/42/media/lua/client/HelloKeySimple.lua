-- HelloKeySimple.lua
-- A *super* basic key‐press test.  Press H in-game and you should see both:
--   • A chat bubble ("Hello world!")  
--   • A console.txt print ("[HelloKeySimple] Hello world!")

-- which key to watch for:
-- local getCore():getKey("PLACEHOLDER_Keyboard_KEY_H") = Keyboard.KEY_H

-- fire once at load so you know the script is there
-- print("[HelloKeySimple] loaded, getCore():getKey("PLACEHOLDER_Keyboard_KEY_H") =", getCore():getKey("PLACEHOLDER_Keyboard_KEY_H"))

-- now watch for the H key
local function onPress(key)
    if key == getCore():getKey("PLACEHOLDER_Keyboard_KEY_H") then
        local pl = getPlayer(getPlayer():getPlayerNum())
        if pl then
            local msg = "Hello world test 3 baby!!  Does lua reset work?"
            pl:Say(msg)                    -- in-game speech bubble
            print("[HelloKeySimple] " .. msg)  -- console.txt
        end
    end
end
Events.OnKeyPressed.Add(onPress)
