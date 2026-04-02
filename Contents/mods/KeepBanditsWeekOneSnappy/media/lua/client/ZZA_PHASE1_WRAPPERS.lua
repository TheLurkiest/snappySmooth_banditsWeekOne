-- ZZA_PHASE1_WRAPPERS.lua

last10HutIds = {}

hyperPoofDist = 15


-- I feel like the default expected number to get as maxNpcSlots for a given building should be ~ math.sqrt(building length * building width) so 10 x 10 tile building would give us a maxNpcSlots of 10 .......... But I feel like we need to set an adjustable maxSlotsMultiplier global variable that goes from 0.1 to 2 which gets multiplied times the output of the square root of the building's area ... So if multiplier were 0.5 then that same building would only have maxNpcSlots of 5. I feel like setting that multiplier at 0.3 by default would likely produce the best outcomes... That way there'd always be a fair number of NPCs spawning around big buildings, but you'd still feel the pinch pretty quickly in remote areas with only small buildings nearby as soon as people started dying. With a multiplier set like that by default that should ensure that each small home/apartment should only have around 3-5 max as their maxNpcSlots:

maxSlotsMultiplier = 0.4

-- Phase 1 — Wrapper Extraction: Move the already-working Bandits wrappers into File 1 and prove they still slow spawning, speed despawning, lower the cap, and stop buildup before touching anything else.

-- Phase 2A — Building Registration: Make saveHutNow() create/update 
    -- hutsCsv[keyId] cleanly, because every later zombie and NPC step depends on hut data existing and being trustworthy.

-- Phase 2B — Zombie Tracking: Build zedsHere as the minimal way to tell “already around” zombies apart from “just popped from this new hut” zombies, and keep it dumb unless forced to get fancier later.

-- Phase 2C — New-Building Zombie Poof: Make poofNewHutZs() despawn only the fresh inside-hut zombies during the first short window and feed part of them into totZombiesLeft, because this is the first real anti-stupid-spawn step.

-- Phase 2D — Zombie Drip Spawn: Make dripSpawnZs4Huts() slowly add those hut zombies back later, because the poof step only works if it also leads into a believable delayed return.

-- Phase 2E — Dev Read/Write Helpers: Port the csv/txt helper junk early enough that you can force data in and out while staying in-game, because that gives you a clean way to test broken links without wrestling the full chain every time.

-- Phase 3A — Save NPC Into Hut Slot: Make dudeHereHutHomer() save one eligible civilian into vipsCsv, link them to a hut slot, and add them to vipsHere, because that’s the first real proof that civilian persistence works at all.

-- Phase 3B — Clean NPC Despawn: Make dudeZap1() remove one eligible NPC and clean their vipsHere entry at the same time, because that gives you a reliable manual cleanup path before auto-logic starts making a mess.

-- Phase 3C — Overwrite One Live NPC: Make slotVipSkinWalkerFn(npc, csvIndex) manually turn one live NPC into one saved dude from vipsCsv, because overwrite needs to be proven in isolation before you trust it inside a scan loop.

-- Phase 3D — NPC Scan Loop: Make scanNpcNow() call the already-proven helper functions to decide whether nearby civilians get saved, overwritten, or poofed, because the loop itself should mostly be glue rather than mystery meat logic.

-- Phase 3E — Death Detection: Make uDeadYet() mark deadNow = true when a nearby recently-seen NPC vanishes without your code removing them first, because by this point you finally know enough to distinguish “we poofed them” from “they probably died.”

-- Phase 3F — Spawn Exact Saved Dude: Make spawnExactDude(npc_tab_in) spawn one exact saved dude from a vipsCsv sub-table and stuff the same intended data into tab4SpawnedGuy2Name, because exact spawning and exact naming need to be tied together.

-- Phase 3G — Post-Spawn Name Fixer: Make spawnedGuyNamer(tab4_in) keep checking the fresh "Companion" until fullname is right, then assign the final program name and clear the temp table so exact spawning can happen again.

-- Phase 4 — Save/Transmit Hooks: Add the save/transmit stuff only after the system itself works, because that stabilizes the finished structure instead of helping prove the little pieces.

-- A couple tiny holes I’d keep an eye on:

-- The biggest weak link is the jump from Phase 2D to 3A, because zombie logic can be “working” while your hut slot structure is still not quite shaped right for NPC use. So when you finish 2D, do one quick sanity pass on the actual hut table structure before starting civilian saving.

-- The other weak link is between 3F and 3G, because tab4SpawnedGuy2Name becomes a little gatekeeper table. If it gets stuck non-empty because the name-fixer misses its target, spawnExactDude() jams up until you clear it, so you’ll want a dumb emergency reset hotkey or manual fallback there.

-- And yeah, I do think your csv/txt helper idea belongs in the plan. Not as “real feature” logic, but as test scaffolding. In this kind of build/test/fix loop, that’s not bloat — that’s a pry bar.





-------------------------------------------------------------- WWW
-------------------------------------------------------------- WWW
-- WRAP -- WRAP -- WRAP -- WRAP -- WRAP -- WRAP -- WRAP -- WRAP -- 
------------------------------------ WRAP/INTERCEPT EVERY NPC PROG

local function makeFixedDespawn(removePrg)


    local tab = {}

    local cell = getCell()
    local zombieList = cell:getZombieList()

    local cnt2
    local brain

    return function(cnt)
        
        if type(cnt) ~= "number" then cnt = tonumber(cnt) or 0 end
        if cnt <= 0 then return end

        local player = getSpecificPlayer(0)
        if not player then return end

        local bx, by, bz
        local dist

        local i = 0  -- ✅ THE WHOLE BUG

        local px, py = player:getX(), player:getY()

        local pz = math.floor(player:getZ())

        local npc_id; local bandit; local brain

        local zombieObj
        local args
        local task

        local player = getPlayer(0)
        
        local px = player:getX()
        local py = player:getY()
        local pz = math.floor(player:getZ())

        local closestZombie; local closestBandit

        -- gather civ stats
        local cell = getCell()
        local zombieList = cell:getZombieList()

        for i = 0, zombieList:size() - 1 do
            local zombie = zombieList:get(i)
            bx = zombie:getX()
            by = zombie:getY()

            bz = math.floor(zombie:getZ())
            dist = BanditUtils.DistTo(px, py, bx, by)

            if zombie:getVariableBoolean("Bandit") then

                brain = BanditBrain.Get(zombie)
                npc_id = brain.id

                bandit = BanditZombie.GetInstanceById(npc_id)
                zombieObj = BanditZombie.GetInstanceById(zombie.id)

                if tostring(brain.program.name) == "Babe" or tostring(brain.program.name) == "Survivor" or tostring(brain.program.name) == "Inhabitant" or tostring(brain.program.name) == "Walker" then

                end

                closestZombie = BanditUtils.GetClosestZombieLocation(bandit)
                closestBandit = BanditUtils.GetClosestEnemyBanditLocation(bandit)


                if Bandit.HasTask(BanditZombie.GetInstanceById(npc_id)) == true then

                    task = Bandit.GetTask(bandit)

                    if tostring(task["action"]) == "Time" or tostring(task["action"]) == "SitInChair" then

                        if tostring(task["anim"]) == "ShiftWeight" or tostring(task["anim"]) == "PullAtCollar" or tostring(task["anim"]) == "ChewNails" or tostring(task["anim"]) == "Smoke" or tostring(task["anim"]) == "Sneeze" or tostring(task["anim"]) == "WipeBrow" or tostring(task["anim"]) == "WipeHead" or tostring(task["anim"]) == "Talk1" or tostring(task["anim"]) == "Talk2" or tostring(task["anim"]) == "Talk3" or tostring(task["anim"]) == "Talk4"  or tostring(task["anim"]) == "Talk5" or tostring(task["action"]) == "SitInChair" then

                            if brain.outfit == "Nurse" or brain.outfit == "Doctor" or brain.outfit == "AmbulanceDriver" or brain.outfit == "Fireman" or brain.outfit == "Police" or brain.outfit == "Police_SWAT" or brain.outfit == "ZSPoliceSpecialOps" or brain.outfit == "PoliceRiot" or brain.outfit == "PoliceState" then

                                if brain.hostile == false and dist > hyperPoofDist and tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then

                                    if closestZombie.dist > 5 and closestBandit.dist > 10 then

                                        -- despawn happens

                                        -- player:Say("Debug ZZE-3: Secondary Range Despawn triggered: Police, Medic, Fireman")

                                        zombieObj:removeFromSquare()
                                        zombieObj:removeFromWorld()

                                        args = { id = zombie.id } -- ✅ don’t leak globals
                                        sendClientCommand(player, "Commands", "BanditRemove", args)

                                        i = i + 1
                                        if i >= cnt then break end

                                    end

                                
                                end
                                    
                            end
                            
                        end
                    end
                end


            end
        end




        local zombieList = BanditUtils.GetAllBanditByProgram(removePrg)
        if not zombieList then return end

        for _, zombie in pairs(zombieList) do
            if zombie and zombie.id and zombie.x and zombie.y then
                dist = BanditUtils.DistTo(px, py, zombie.x, zombie.y)

                if dist > (hyperPoofDist + 15) then
                    zombieObj = BanditZombie.GetInstanceById(zombie.id)
                    if zombieObj then
                        zombieObj:removeFromSquare()
                        zombieObj:removeFromWorld()

                        args = { id = zombie.id } -- ✅ don’t leak globals
                        sendClientCommand(player, "Commands", "BanditRemove", args)

                        i = i + 1
                        if i >= cnt then break end
                    end
                end
            end
        end

        -- zombie.id

        local pz = math.floor(player:getZ())
        local building = player:getBuilding()
        local buildingDef
        local keyId

        local square
        local building2

        local keyId2

        local vipsTxt = ModData.getOrCreate("vipsTxt")

        local found = false
        
        local AllSurvivorTrustTabs = ModData.getOrCreate("AllSurvivorTrustTabs")


        if building then
            
            buildingDef = building:getDef()
            keyId = buildingDef:getKeyId()

        end

        local okToDespawn = false
        
        for _, zombie in pairs(zombieList) do

            found = false

            if zombie and zombie.id and zombie.x and zombie.y then
                dist = BanditUtils.DistTo(px, py, zombie.x, zombie.y)

                okToDespawn = false

                npc_id = zombie.id

                zombieObj = BanditZombie.GetInstanceById(zombie.id)

                bandit = BanditZombie.GetInstanceById(npc_id)

                if BanditZombie.GetInstanceById(npc_id) == nil then
                    
                else
    
                    brain = BanditBrain.Get(bandit)

                    bx = BanditZombie.GetInstanceById(npc_id):getX();
                    by = BanditZombie.GetInstanceById(npc_id):getY();
                    bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());

                    dist = BanditUtils.DistTo(px, py, bx, by)

                    square = getCell():getGridSquare(bx, by, bz)

                    if not square then

                    else
                        building2 = square:getBuilding()
                    end

                    if building and building2 then

                        keyId2 = building2:getDef():getKeyId()

                        if keyId == keyId2 then
                            okToDespawn = false
                        else
                            if pz == 0 and bz > 0 then
                                okToDespawn = true
                            else
                                if bz >= pz then
                                    okToDespawn = true
                                end
                            end
                        end

                    else

                        if pz == 0 and bz >= 0 then
                            okToDespawn = true
                        end

                    end


                    if dist > (hyperPoofDist + 10) and okToDespawn == true and tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" and found == false then
                        zombieObj = BanditZombie.GetInstanceById(zombie.id)
                        if zombieObj then

                            -- player:Say("Debug ZZE: Secondary Range Despawn triggered")

                            zombieObj:removeFromSquare()
                            zombieObj:removeFromWorld()

                            args = { id = zombie.id } -- ✅ don’t leak globals
                            sendClientCommand(player, "Commands", "BanditRemove", args)

                            i = i + 1
                            if i >= cnt then break end
                        end
                    else

                        if dist > (hyperPoofDist + 3) and okToDespawn == true and tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then
                            if brain.hostile == false then
                                if brain.program.name == "ArmyGuard" then

                                    -- player:Say("Debug ZZE-2: Secondary Range Despawn triggered: ArmyGuard")

                                    zombieObj:removeFromSquare()
                                    zombieObj:removeFromWorld()

                                    args = { id = zombie.id } -- ✅ don’t leak globals
                                    sendClientCommand(player, "Commands", "BanditRemove", args)

                                    i = i + 1
                                    if i >= cnt then break end
                                    
                                else
                                    if brain.program.name == "Police" or brain.program.name == "Fireman" or brain.program.name == "Medic" then

                                        if Bandit.HasTask(BanditZombie.GetInstanceById(npc_id)) == true then

                                            task = Bandit.GetTask(bandit)

                                            if tostring(task["action"]) == "Time" then

                                                if tostring(task["anim"]) == "ShiftWeight" or tostring(task["anim"]) == "PullAtCollar" or tostring(task["anim"]) == "ChewNails" or tostring(task["anim"]) == "Smoke" or tostring(task["anim"]) == "Sneeze" or tostring(task["anim"]) == "WipeBrow" or tostring(task["anim"]) == "WipeHead" or tostring(task["anim"]) == "Talk1" or tostring(task["anim"]) == "Talk2" or tostring(task["anim"]) == "Talk3" or tostring(task["anim"]) == "Talk4"  or tostring(task["anim"]) == "Talk5" then

                                                    if ZombRand(1, 100) <= 33 then
                                                        -- nothing happens
                                                    else

                                                        if ZombRand(1, 100) > 70 then
                                                            -- despawn happens

                                                            -- player:Say("Debug ZZE-3: Secondary Range Despawn triggered: Police, Medic, Fireman")

                                                            zombieObj:removeFromSquare()
                                                            zombieObj:removeFromWorld()

                                                            args = { id = zombie.id } -- ✅ don’t leak globals
                                                            sendClientCommand(player, "Commands", "BanditRemove", args)

                                                            i = i + 1
                                                            if i >= cnt then break end
                                                            

                                                        else
                                                            -- changes to Walker

                                                            if getGameTime():getDay() <= 13 then
    
                                                                -- player:Say("Debug ZZE-4: Secondary Range alt-despawn to walker triggered: Police, Medic, Fireman")

                                                                brain.program.name = "Walker"
                                                                brain.program.stage = "Main"

                                                                i = i + 1
                                                                if i >= cnt then break end
                                                            
                                                            else
                                                                -- player:Say("Debug ZZE-4: Secondary Range alt-despawn to survivor triggered: Police, Medic, Fireman")

                                                                if ZombRand(1, 100) < 10 then
                                                                    brain.program.name = "Babe"

                                                                    if ZombRand(1, 100) > 50 then
                                                                        brain.program.stage = "Guard"
                                                                    else
                                                                        brain.program.stage = "Follow"

                                                                    end

                                                                else

                                                                    if ZombRand(1, 100) > 50 then
                                                                        brain.program.name = "Walker"
                                                                        brain.program.stage = "Main"
                                                                    else
                                                                        brain.program.name = "Survivor"
                                                                        brain.program.stage = "Main"
                                                                    end

                                                                end

                                                                i = i + 1
                                                                if i >= cnt then break end

                                                            end
                                                                
                                                        end


                                                    end

                                                end

                                            end

                                        end

                                    end

                                end
                            end
                        end
                    end

                end


            end
        end



        if math.abs(cnt - i) > 3 then

            for _, zombie in pairs(zombieList) do
                if zombie and zombie.id and zombie.x and zombie.y then
                    dist = BanditUtils.DistTo(px, py, zombie.x, zombie.y)


                    npc_id = zombie.id
                    bandit = BanditZombie.GetInstanceById(npc_id)

                    if BanditZombie.GetInstanceById(npc_id) == nil then
                        
                    else



                        brain = BanditBrain.Get(bandit)

                        bx = BanditZombie.GetInstanceById(npc_id):getX();
                        by = BanditZombie.GetInstanceById(npc_id):getY();
                        bz = math.floor(BanditZombie.GetInstanceById(npc_id):getZ());


                        -- if tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then


                        if dist > hyperPoofDist and tostring(LosUtil.lineClear(getCell(), px, py, pz, bx, by, bz, false)) ~= "Clear" then

                            -- player:Say("Debug ZZE: THIRD Range Despawn triggered")

                            zombieObj = BanditZombie.GetInstanceById(zombie.id)
                            if zombieObj then


                                for j = 1, (#vipsTxt) do
                                    -- found = false
                                    if tostring(tostring(vipsTxt[j]):match("bandit.fullname=([^,]*)")) == brain.fullname then
                                        found = true
                                        break
                                    end
                                end

                                if found == false then

                                    zombieObj:removeFromSquare()
                                    zombieObj:removeFromWorld()

                                    args = { id = zombie.id } -- ✅ don’t leak globals
                                    sendClientCommand(player, "Commands", "BanditRemove", args)

                                    i = i + 1
                                    if i >= cnt then break end
                                end

                            end

                        end
                    end



                end
            end

        end

    end

end

local function capSpawn(originalSpawn, cap)
    return function(cnt, ...)
        if type(cnt) ~= "number" then return originalSpawn(cnt, ...) end
        if cnt > cap then 
            cnt = math.floor(cnt / 8)

            if type(cnt) ~= "number" then cnt = tonumber(cnt) or 0 end
            if cnt <= 0 then return end


            -- cnt = cap  -- 👈🟡 THROTTLE HERE
        end
        return originalSpawn(cnt, ...)
    end
end

local function patchOnce()
    if not BWOPopControl then return end
    if BWOPopControl.__R69_DespawnFix then return end
    BWOPopControl.__R69_DespawnFix = true

    -- despawn fixes (yours)

    BWOPopControl.InhabitantsDespawn = makeFixedDespawn({"Inhabitant", "Looter", "Bandit", "RiotPolice", "Patrol"})

    BWOPopControl.StreetsDespawn = makeFixedDespawn({"Walker", "Runner", "Postal", "Entertainer", "Janitor", "Medic", "Gardener", "Vandal", "Police", "ArmyGuard", "Fireman", "Active"})

    BWOPopControl.SurvivorsDespawn = makeFixedDespawn({"Survivor", "Looter", "Thief"})

    -- ✅ spawn throttles (NEW)
    BWOPopControl.InhabitantsSpawn = capSpawn(BWOPopControl.InhabitantsSpawn, 7) -- 👈🟢 pick your cap
    BWOPopControl.StreetsSpawn     = capSpawn(BWOPopControl.StreetsSpawn, 5)
    BWOPopControl.SurvivorsSpawn   = capSpawn(BWOPopControl.SurvivorsSpawn, 3)


end
-- Call once after everything is loaded.
Events.OnGameStart.Add(patchOnce)

------------------------------------ WRAP/INTERCEPT EVERY NPC PROG
-- WRAP -- WRAP -- WRAP -- WRAP -- WRAP -- WRAP -- WRAP -- WRAP -- 
-------------------------------------------------------------- WWW
-------------------------------------------------------------- WWW











local function onPress(key)

    local player = getPlayer(0)

    if not player then
        do return end
    end


end
Events.OnKeyPressed.Add(onPress)



local function zombieSpawnFixer()


    if BWOPopControl and not BWOPopControl.__bwgpt_zombie_hooked  then
        BWOPopControl.__bwgpt_zombie_hooked  = true

        local _oldZombie = BWOPopControl.Zombie

        BWOPopControl.Zombie = function(...)

            -- keep this one intact but maybe set it to be ZERO for first day...

            -- 
            if getGameTime():getDay() < 9 or pressedNum < 2 then
                BWOPopControl.ZombieMax = 0
            else
                BWOPopControl.ZombieMax = 350
            end

            _oldZombie(...)

        end
    end


    -- Change max zombies that can spawn to something else for those areas far from the center of the outbreak:
    if BWOPopControl and not BWOPopControl.__bwgpt_hooked then
        BWOPopControl.__bwgpt_hooked = true

        local _oldUpdateCivs = BWOPopControl.UpdateCivs
        BWOPopControl.UpdateCivs = function(...)
            local o = _oldUpdateCivs(...)
            
            -- _G.BWOPopControl__instance = o

            -- 👇 ...and then I would need to put the ENTIRETY of my code where I ALTER this to be something else into HERE right? Starting with the following line:

            if BWOScheduler.WorldAge < 128 then
                BWOPopControl.ZombieMax = 10
            end

            if getGameTime():getDay() < 9 and getGameTime():getHour() <= 10 then
                BWOPopControl.ZombieMax = 0
            else
                if BWOPopControl.ZombieMax <= 0 then
                    BWOPopControl.ZombieMax = 350
                end
            end

            if BWOPopControl.ZombieMax >= 400 then
                BWOPopControl.ZombieMax = 350
            end

            
            -- set these two global variables as 80% of what they currently are if the are using the default values for these:

            -- print(SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier); print(SandboxVars.BanditsWeekOne.StreetsPopMultiplier)


            -- SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier
            -- SandboxVars.BanditsWeekOne.StreetsPopMultiplier

            if SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier >= 1 then
                SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier = 0.8 * (SandboxVars.BanditsWeekOne.InhabitantsPopMultiplier)
            end
            
            if SandboxVars.BanditsWeekOne.StreetsPopMultiplier >= 1 then
                SandboxVars.BanditsWeekOne.StreetsPopMultiplier = 0.8 * (SandboxVars.BanditsWeekOne.StreetsPopMultiplier)
            end

            return o


        end


    end



end


local onTickZZA = function(numTicksInZZA)

    if numTicksInZZA % 2 == 0 or numTicksInZZA % 2 ~= 0 then
        zombieSpawnFixer()
    end

    if numTicksInZZA % 20 == 0 then

    end

end
Events.OnTick.Add(onTickZZA)
