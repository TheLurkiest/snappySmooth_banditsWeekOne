-- ZZB_PHASE2PLUS_ZEDS_N_NPCS.lua

-- Final Function Names:

-- saveHutNow() 

-- poofNewHutZs() dripSpawnZs4Huts() dudeHereHutHomer() dudeZap1() slotVipSkinWalkerFn(npc, csvIndex) scanNpcNow() uDeadYet() spawnExactDude(npc_tab_in) spawnedGuyNamer(tab4_in)


------------------------------------------------------------------ +

------------------------------------------------------------------ +


-- Phase 1 — Wrapper Extraction: 
    -- ✅ Move the already-working Bandits wrappers into File 1 and 
    -- prove they still slow spawning, 
    -- speed despawning, 
    -- lower the cap, 
    -- and stop buildup before touching anything else.

-- Phase 2A — Building Registration: 
    -- Make saveHutNow() 
    -- create/update hutsCsv[keyId] cleanly, because every later zombie and NPC step depends on hut data existing and being trustworthy.


local function saveHutNow()

    -- No that's not right, I'm 99% sure it's THIS that we used (pretty sure it worked real well) -- can you remind me what this would end up displaying ... I'm worried maybe this will only print out a handful of buildings on the map though, do I need to specify something broader or this all of them: 

    local hutsCsv = ModData.getOrCreate("hutsCsv")
    local vipsCsv = ModData.getOrCreate("vipsCsv")

    local zedsHere = ModData.getOrCreate("zedsHere")

    for k, v in pairs(hutsCsv) do
        print("Key:", k, "Value:", v)
    end

    local savedKeyId = nil

    local player = getPlayer(0)

    local building = player:getBuilding()
    local buildingDef
    local keyId

    local foundHut = false

    if building then
        buildingDef = building:getDef()
        keyId = buildingDef:getKeyId()


        for j = 1, (#last10HutIds) do
            if tonumber(keyId) == tonumber(last10HutIds[j]) then
                foundHut = true
                break
            end
        end

        if foundHut == false then
            table.insert(last10HutIds, keyId)
        end


        --------------------------------------------
        

        local ts = getTimestampMs()

        local player = getSpecificPlayer(0)
        local cell = player:getCell()
        local px, py = player:getX(), player:getY()
        local rooms = cell:getRoomList()

        local occupantsCnt
        local occupantsMax
        local foundHut = false

        -- the probability of spawn in a room will depend on room size and other factors
        local cursor = 0
        local roomPool = {}
        for i = 0, rooms:size() - 1 do
            local room = rooms:get(i)
            local def = room:getRoomDef()

            if def then
                local building = room:getBuilding()
                local buildingDef = building:getDef()
                
                if not BWOBuildings.IsEventBuilding(building, "home") then
                    
                    if def:getZ() >=0 and math.abs(def:getX() - player:getX()) < 100 and math.abs(def:getX2() - player:getX()) < 100 and 
                    math.abs(def:getY() - player:getY()) < 100 and math.abs(def:getY2() - player:getY()) < 100 then

                        local roomSize = BWORooms.GetRoomSize(room)
                        local popMod = 1 -- lags: BWORooms.GetRoomPopMod(room)
                        if popMod > 0 then
                            local cursorStart = cursor
                            cursor = cursor + math.floor(roomSize ^ 1.2)


                            local roomName = room:getName()

                            local occupantsCnt = BWORooms.GetRoomCurrPop(room)
                            local occupantsMax = BWORooms.GetRoomMaxPop(room)

                            -- table.insert(roomPool, {room=room, cursorStart=cursorStart, cursorEnd=cursor})

                            table.insert(roomPool, {room=room, occupantsCnt=occupantsCnt, maxNpcSlots=occupantsMax, roomName=roomName})


                        end

                    end
                    
                end
                
            end
        end


        for k, v in pairs(roomPool) do
            print("Key:", k, "Value of v.maxNpcSlots: ", v.maxNpcSlots)
        end

        


        local sumAllMaxSlots = 0

        local num1 = 0

        if not hutsCsv[keyId] then

            savedKeyId = keyId

            hutsCsv[keyId] = {totZombiesLeft=0, npcSlots={}, roomsTab={}, maxNpcSlots=0}

            -- table.insert(hutsCsv[keyId], {})

            for i = 1, (#roomPool) do

                player:Say("roomPool[i].maxNpcSlots for room named " .. tostring(roomPool[i].roomName) .. " is " .. tostring(roomPool[i].maxNpcSlots))

                num1 = 0

                if tonumber(roomPool[i].maxNpcSlots) ~= nil then
                    num1 = tonumber(roomPool[i].maxNpcSlots)
                end

                if tonumber(hutsCsv[keyId].maxNpcSlots) == nil then
                    hutsCsv[keyId].maxNpcSlots = 0
                end

                hutsCsv[keyId].maxNpcSlots = tonumber(hutsCsv[keyId].maxNpcSlots) + num1

                table.insert(hutsCsv[keyId].roomsTab, {roomName=tostring(roomPool[i].roomName), maxNpcSlots=tonumber(roomPool[i].maxNpcSlots), npcSlots={}})

            end

            player:Say("sum ALL maxNpcSlots for ALL rooms in building: " .. tostring(hutsCsv[keyId].maxNpcSlots))
            hutsCsv[keyId].maxNpcSlots = hutsCsv[keyId].maxNpcSlots

            hutsCsv[keyId].totMinutesAtFirstSeen = math.abs((getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24)))

            -- math.abs((getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24)) - R69_LAST_SPAWNED_TOT_MINUTES) < 10 

            hutsCsv[keyId].totMinutesWhenLastSeen = math.abs((getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24)))

            hutsCsv[keyId].dayLastSeen = getGameTime():getDay()

            ------------------------------------------ +

            local fakeZombie = getCell():getFakeZombieForHit()
            local zombieList = BanditZombie.GetAllZ()
            local gmd = GetBanditModData()

            local ccnt = 0
            for k, v in pairs(gmd.Queue) do
                ccnt = ccnt + 1
            end

            local cnt = 0

            for id, z in pairs(zombieList) do

            end

            ------------------------------------------ +

        end

    end

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

    local cnt = 0

    local room
    local roomName
    local building


    for i = 0, zombieList:size() - 1 do
        local zombie = zombieList:get(i)
        bx = zombie:getX()
        by = zombie:getY()

        bz = math.floor(zombie:getZ())



        dist = BanditUtils.DistTo(px, py, bx, by)

        if zombie:getVariableBoolean("Bandit") then

        else

            local square = getCell():getGridSquare(bx, by, bz);

            if square ~= nil then
                room = square:getRoom();
                roomName = "nil"

                if room ~= nil then
                    roomName = room:getName(); 
                end 

                building = square:getBuilding()

                if building then
                    buildingDef = building:getDef()
                    keyId = buildingDef:getKeyId()
                end

            end
            
            
            local foundZedId = false

            for j = 1, (#zedsHere) do
                if tonumber(zedsHere[j]) == tonumber(zombie.id) then
                    foundZedId = true
                    break
                end
            end

            local despawnThem = false
            
            local zombie = BanditZombie.GetInstanceById(zombie.id)
            -- local id = BanditUtils.GetCharacterID(zombie)
            if zombie and zombie:isAlive() and foundZedId == false then
                -- fixme: zombie:canBeDeletedUnnoticed(float)

                if tonumber(keyId) == tonumber(savedKeyId) then

                    despawnThem = true

                else

                    if not hutsCsv[keyId] then
                        
                    else

                        if math.abs((hutsCsv[keyId].totMinutesAtFirstSeen) - (getGameTime():getMinutes() + (getGameTime():getHour() * 60) + (getGameTime():getDay() * 60 * 24))) <= 3 then
                            
                            despawnThem = true

                        end
                    end

                end

                if despawnThem == true then
                    
    
                    zombie:removeFromSquare()
                    zombie:removeFromWorld()
                    args = {}
                    
                    args.id = zombie.id

                    sendClientCommand(player, 'Commands', 'BanditRemove', args)

                    cnt = cnt + 1

                    hutsCsv[keyId].totZombiesLeft = hutsCsv[keyId].totZombiesLeft + 1

                end
                

            end


        end

    end
    



    ------------------------------------------


    
    local gmd = GetBWOModData() 
    for k, v in pairs(gmd.EventBuildings) do 

        print("ID:", k) 

        for key, val in pairs(v) do
            print(" ", key, val)
        end

    end

    -- ..........also, when we use that what's it giving us; is this a Bandits Week One only kind of construction?


end

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

----------------------------------------------------

-- A couple tiny holes I’d keep an eye on:

-- The biggest weak link is the jump from Phase 2D to 3A, because zombie logic can be “working” while your hut slot structure is still not quite shaped right for NPC use. So when you finish 2D, do one quick sanity pass on the actual hut table structure before starting civilian saving.

-- The other weak link is between 3F and 3G, because tab4SpawnedGuy2Name becomes a little gatekeeper table. If it gets stuck non-empty because the name-fixer misses its target, spawnExactDude() jams up until you clear it, so you’ll want a dumb emergency reset hotkey or manual fallback there.

-- And yeah, I do think your csv/txt helper idea belongs in the plan. Not as “real feature” logic, but as test scaffolding. In this kind of build/test/fix loop, that’s not bloat — that’s a pry bar.

------------------------------------------------------------------ +

------------------------------------------------------------------ +




local function pauseThenGlobalSave12()

    local player = getPlayer(0)

    if not player then 
        do return end
    end

    local pl = getPlayer(0)

    pl:Say("[SAVING ALL NPC MOD/FILE DATA NOW!]")

    print("SAVING GAME NOW...")
    local sc = UIManager.getSpeedControls()
    -- if not sc then return nil end
    local prev = sc:getCurrentGameSpeed()
    sc:SetCurrentGameSpeed(0) -- pause

    
    local hutsCsv = ModData.getOrCreate("hutsCsv")
    local vipsCsv = ModData.getOrCreate("vipsCsv")

    ModData.transmit("hutsCsv")
    ModData.transmit("vipsCsv")

    for i = 1, (#vipsCsv) do

        local playerName = player:getDisplayName()

        local writeFileNameB = tostring(playerName) .. "_" .. tostring(i) .. "_infoB.txt"
        local writer = getModFileWriter("KeepBanditsWeekOneSnappy", writeFileNameB, true, false)
        local comboText1 = vipsCsv[i]

        if tostring(comboText1):len() >= 4 then

            writer:write(tostring(comboText1))
            writer:close()

        end

    end

end


local function onPress(key)

    local player = getPlayer(0)

    if not player then
        do return end
    end


    if key == getCore():getKey("PLACEHOLDER_Keyboard_KEY_ESCAPE") then
        pauseThenGlobalSave12()
    end



    if key == getCore():getKey("PLACEHOLDER_Keyboard_KEY_7") or key == getCore():getKey("PLACEHOLDER_Keyboard_KEY_NUMPAD7") then
        saveHutNow()
    end
    

end
Events.OnKeyPressed.Add(onPress)




local onTickZZB = function(numTicksInZZB)

    if numTicksInZZB % 2 == 0 or numTicksInZZB % 2 ~= 0 then

    end

    if numTicksInZZB % 20 == 0 then

        local hutsCsv = ModData.getOrCreate("hutsCsv")
        local vipsCsv = ModData.getOrCreate("vipsCsv")

    end
end
Events.OnTick.Add(onTickZZB)
