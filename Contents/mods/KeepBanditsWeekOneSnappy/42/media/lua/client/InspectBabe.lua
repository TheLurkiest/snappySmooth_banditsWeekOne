-- InspectBabe.lua
-- Press X to report the name and melee weapon of the nearest "Babe" NPC.

local INSPECT_KEY = Keyboard.KEY_X

-- Tell us you loaded
print("[InspectBabe] loaded; press X to inspect the room and or to exchange held items with the nearest Babe.")



local function PrintBrain(bandit)
    -- -- GLOBAL_STAYING_AS_ACTIVE_IDS_TAB
    local brain = BanditBrain.Get(bandit)
    print("-- BRAIN DUMP for bandit id=" .. brain.id .. " --")
    for key, val in pairs(brain) do
        if type(val) == "table" then
            print(key .. " = {")
            for k2, v2 in pairs(val) do
                print("   ", k2, "=", v2)
            end
            print("}")
        else
            print(key, "=", val)
        end
    end
    print(" ------------------------------------------ ")
end

local function onKeyPress(key)
    if key ~= INSPECT_KEY then return end

    local player = getPlayer(getPlayer():getPlayerNum())
    if not player then return end

    -- Find the nearest bandit with program "Babe"
    local result = BanditUtils.GetClosestBanditLocationProgram(player, {"Babe"})
    if not result.id then
        player:Say("No Babe found nearby.")
        print("[InspectBabe] No Babe found.")
        return
    end

    -- prints ENTIRE table of brain
    if result and result.id then
        local babe = BanditZombie.GetInstanceById(result.id)
        if babe then
            PrintBrain(babe)
        end
    end

    -- Grab that NPC
    local bandit = BanditZombie.GetInstanceById(result.id)
    local brain  = BanditBrain.Get(bandit)
    local name   = brain and brain.fullname or "Unknown"

    -- Get their weapons
    local weaps  = Bandit.GetWeapons(bandit)
    local melee  = weaps and weaps.melee or "None"

    -- Build the message
    local msg = string.format("Babe ► %s | Melee ► %s", name, melee)

    -- Show it in-game and in console.txt
    player:Say(msg)
    print("[InspectBabe] " .. msg)

    local bp, bs = brain.weapons.primary, brain.weapons.secondary
    for k,v in pairs(bp) do print(" primary."..k.." =", v) end; for k,v in pairs(bs) do print(" secondary."..k.." =", v) end

end

Events.OnKeyPressed.Add(onKeyPress)
