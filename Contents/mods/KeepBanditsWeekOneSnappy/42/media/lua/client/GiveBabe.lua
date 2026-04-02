-- GiveBabe.lua
-- Press G to give your held item to the nearest "Babe" NPC.

local GIVE_KEY = Keyboard.KEY_G

print("[GiveBabe] loaded; press G to give your held weapon to the nearest Babe.")

local function onKeyPress(key)
    if key ~= GIVE_KEY then return end

    local player = getPlayer(getPlayer():getPlayerNum())
    if not player then return end

    -- Find the nearest Babe
    local nearestBabe = BanditUtils.GetClosestBanditLocationProgram(player, {"Gardener", "Walker", "Janitor", "Entertainer", "Survivor", "Postal", "Runner", "Inhabitant", "Active", "Babe"})

    if not nearestBabe.id then
        player:Say("No Babe found nearby.")
        print("[GiveBabe] No Babe found.")
        return
    end

    local babe1 = BanditZombie.GetInstanceById(nearestBabe.id)
    local brain = BanditBrain.Get(babe1)
    local name  = brain and brain.fullname or "Unknown"

    local takenItem = babe1:getPrimaryHandItem()

    print("babe1:getPrimaryHandItem() is " .. tostring(babe1:getPrimaryHandItem()))

    if babe1:getPrimaryHandItem() ~= nil then
        print("babe1:getPrimaryHandItem():getFullType() is " .. tostring(babe1:getPrimaryHandItem():getFullType()))
    end

    -- 
    local givenItem = player:getPrimaryHandItem()
    local givenSecondaryItem = player:getSecondaryHandItem()

    local weaponId = ""

    local buyCost = 10

    -- 1) get the item the player is holding in their primary hand
    -- What are you holding?

    -- selling:
    -- if takenItem and nearestNonBabe.id then    
    if takenItem and nearestBabe.id then
        -- money-for-weapon: if you’re holding a schoolbag, check price 20
        if givenSecondaryItem:getFullType()=="Base.Purse" or givenSecondaryItem:getFullType()=="Base.Wallet" or givenSecondaryItem:getFullType()=="Base.Wallet_Male" or givenSecondaryItem:getFullType()=="Base.Wallet_Female" or givenSecondaryItem:getFullType()=="Base.Wallet_Hide" then

            local weight = takenItem:getActualWeight()
            buyCost = BanditUtils.AddPriceInflation(weight * SandboxVars.BanditsWeekOne.PriceMultiplier * 10)
            if buyCost == 0 then buyCost = 1 end

            if Bandit.GetProgram(babe1).name == "Babe" then
                buyCost = math.floor(buyCost/2) + 1
            end


            local m = givenSecondaryItem:getInventory():getItemCount("Base.Money")
            if m < buyCost then 
                weaponId = takenItem:getModule() .. "." .. takenItem:getType()
                local msg = string.format("Price of %s is: %s", weaponId, tostring(buyCost))
                player:Say(msg)

            else
                player:Say("Good deal!") 

                for i=1, buyCost do
                    givenSecondaryItem:getInventory():RemoveOneOf("Base.Money")
                end

                weaponId = "Base.BareHands"
                babe1:setPrimaryHandItem(nil); babe1:getInventory():Remove(takenItem)
                player:getInventory():AddItem(takenItem); player:setPrimaryHandItem(takenItem)
                local ok, err = pcall(function()
                    brain.weapons.melee = weaponId
                end) 

                -- BOUGHT FROM: i fucking HATE the way this is set up... we keep repeating ourselves
                weaponId = takenItem:getModule() .. "." .. takenItem:getType()
                local msg = string.format("Bought %s from %s", weaponId, name)
                player:Say(msg)
                print("[GiveBabe] " .. msg)
            end
        end
    end

    -- if we have NOTHING to GIVE, grab the nearest Babe’s weapon (if they have one)    
    if not givenItem then
        if nearestBabe.id and takenItem and Bandit.GetProgram(babe1).name == "Babe" then
            -- if we have nothing to give, but they have something to take:
            weaponId = "Base.BareHands"
            babe1:setPrimaryHandItem(nil); babe1:getInventory():Remove(takenItem)
            player:getInventory():AddItem(takenItem); player:setPrimaryHandItem(takenItem)
            local ok, err = pcall(function()
                brain.weapons.melee = weaponId
            end) 

            -- TAKE FROM: i fucking HATE the way this is set up... we keep repeating ourselves
            weaponId = takenItem:getModule() .. "." .. takenItem:getType()
            local msg = string.format("Took %s from %s", weaponId, name)
            player:Say(msg)
            print("[GiveBabe] " .. msg)                    
            
        -- if we have nothing to give, and they don't have anything left to take:
        else
            player:Say("Hold something in your hand to give!")
            print("[GiveBabe] You tried to give nothing.")
        end
    -- else if we DO have something to GIVE, we do so here:    
    else
        -- 2) convert that InventoryItem into the mod’s “Module.ItemType” string
        -- e.g. item:getModule() => "Base", item:getType() => "Axe"
        weaponId = givenItem:getModule() .. "." .. givenItem:getType()

        -- 3) assign into the brain table
        --    wrap in pcall in case brain or brain.weapons is nil
        local ok, err = pcall(function()
            brain.weapons.melee = weaponId
        end)
        if not ok then
            print("⚠️ Failed to set brain.weapons.melee:", err)
        end

        -- Unequip from player & remove from their inventory
        player:setPrimaryHandItem(nil)
        player:getInventory():Remove(givenItem)

        -- Give to Babe and equip
        babe1:getInventory():AddItem(givenItem)
        babe1:setPrimaryHandItem(givenItem)

        local display = givenItem:getDisplayName()
        local msg = string.format("Gave %s to %s", display, name)
        player:Say(msg)
        print("[GiveBabe] " .. msg)

    end


end

Events.OnKeyPressed.Add(onKeyPress)
