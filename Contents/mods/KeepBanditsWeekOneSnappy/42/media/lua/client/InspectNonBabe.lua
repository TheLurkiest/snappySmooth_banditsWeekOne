-- InspectBabe.lua
-- Press X to report the name and melee weapon of the nearest "Babe" NPC.
require "ChatManager"
require "Keyboard"

require "BWOChat"    -- loads the mod’s chat utility

local INSPECT_KEY = Keyboard.KEY_C

-- Tell us you loaded
print("[InspectNonBabe] loaded; press C to inspect nearest non-allied npc.")

local function PrintBrain(bandit)
    local brain = BanditBrain.Get(bandit)
    print("── BRAIN DUMP for bandit id=" .. brain.id .. " ──")
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
    print("────────────────────────────────────")
end

local function onKeyPress(key)
    if key ~= INSPECT_KEY then return end

    local player = getPlayer(getPlayer():getPlayerNum())
    if not player then return end

    -- Find the nearest bandit with program "Babe"
    local result = BanditUtils.GetClosestBanditLocationProgram(player, {"Gardener", "Walker", "Janitor", "Entertainer", "Survivor", "Postal", "Runner", "Inhabitant", "Active", "Babe"})
    if not result.id then
        player:Say("No non-allied npc found nearby.")
        print("[InspectBabe] No non-allied npc found.")
        return
    end

    -- prints ENTIRE table of brain
    if result and result.id then
        local babe1 = BanditZombie.GetInstanceById(result.id)
        if babe1 then
            PrintBrain(babe1)
        end
    end

    -- Grab that NPC
    local babe1 = BanditZombie.GetInstanceById(result.id)
    local brain  = BanditBrain.Get(babe1)
    local name   = brain and brain.fullname or "Unknown"

    local bornX = brain.bornCoords.x
    local bornY = brain.bornCoords.y
    local antiStress1 = ((brain.health) * 7)
    local antiStress2 = ((brain.accuracyBoost) * 2)
    local antiStress3 = ((brain.enduranceBoost) * 7)
    local antiStress4 =  ((brain.strengthBoost) * 7)
    local totalStress = 100 - (antiStress1 + antiStress2 + antiStress3 + antiStress4)
    -- stress should be ~ 30 by default at start/max

    -- all of these are range from 0 to 1:
    -- local rnd2 = ((((brain.rnd[2])*10))/100)
    -- local rnd3 = ((((brain.rnd[3])*1))/100)
    -- local rnd4 = ((((brain.rnd[4])/10))/100)
    -- local rnd5 = ((((brain.rnd[5])/100))/100)
    
    -- all of these are range from 1 to 100:
    local rnd2 = ((((brain.rnd[2])*10)))
    local rnd3 = ((((brain.rnd[3])*1)))
    local rnd4 = ((((brain.rnd[4])/10)))
    local rnd5 = ((((brain.rnd[5])/100)))


    -- local bond1 = (math.abs(rnd2 - player.rnd[2]) + math.abs(rnd3 - player.rnd[3]) + math.abs(rnd4 - player.rnd[4]) + math.abs(rnd5 - player.rnd[5]))/4
    -- local name = babe1:getDisplayName()

    local msg = string.format("current stress level for %s is %s", name, tostring(totalStress))
    -- Show it in-game and in console.txt
    -- player:Say("taking a closer look at what they have in their hands...")
    player:Say(msg)
    print("[InspectBabe] " .. msg)


    Bandit.Say(babe1, "deeebug1 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.", true)


    local homeCoords = BWOBuildings.GetEventBuildingCoords("home")
    local dist = BanditUtils.DistTo(brain.bornCoords.x, brain.bornCoords.y, homeCoords.x, homeCoords.y)
    if dist < 45 then
        name = name .. "I am your neighbor."
    end

    -- Get their weapons
    local weaps  = Bandit.GetWeapons(babe1)
    local melee  = weaps and weaps.melee or "None"

    local buyCost = 10

    


    local text = "Quit eyeballing me, pal!"
    if brain.hostile or brain.hostileP then
        babe1:addLineChatElement(getText(text), 0.8, 0.1, 0.1)
    else
        babe1:addLineChatElement(getText(text), 0.1, 0.8, 0.1)
    end


    -- babe1:setPrimaryHandItem(melee)
    -- if we got a string back (e.g. "Base.Katana"), grab the real item from their inventory
-- if we got a valid weapon ID string, spawn it into their inventory and equip it
    if type(melee)=="string" and melee~="None" then
        print("debug1...........a")
        local spawned = player:getInventory():AddItem(melee)
        if spawned then
            print("debug1...........b: spawned")
            babe1:setPrimaryHandItem(spawned)


            -- grab the price the mod-makers assigned in the item’s script
            local scriptItem = spawned:getScriptItem()
            if buyCost > 1000 then
                print("deeeeeeeebug2a: got scriptItem")
                buyCost = spawned:getScriptItem():getPrice()
            else
                print("deeeeeeeebug2b: used ALTERNATE buyCost price getter method")
                local weight = spawned:getActualWeight()
                buyCost = BanditUtils.AddPriceInflation(weight * SandboxVars.BanditsWeekOne.PriceMultiplier * 10)
                if buyCost == 0 then buyCost = 1 end
            end

            player:getInventory():Remove(spawned)
        end
    end



    -- Build the message
    local msg = string.format("Looks like %s is holding %s ...current value: %s dollars", name, melee, buyCost)

    -- Show it in-game and in console.txt
    player:Say("taking a closer look at what they have in their hands...")
    player:Say(msg)
    print("[InspectBabe] " .. msg)


    if Bandit.GetProgram(babe1).name == "Babe" then
        print("approx 50 percent discount from ally")
        buyCost = math.floor(buyCost/2) + 1
        msg = string.format("...but a friend would give it to us for %s", buyCost)
        player:Say(msg)
    end

    



    Bandit.Say(babe1, "deeebug2 bbbbbbbbbbbbbbbb.", false)



    local bp, bs = brain.weapons.primary, brain.weapons.secondary
    for k,v in pairs(bp) do print(" primary."..k.." =", v) end; for k,v in pairs(bs) do print(" secondary."..k.." =", v) end







    
end

Events.OnKeyPressed.Add(onKeyPress)
