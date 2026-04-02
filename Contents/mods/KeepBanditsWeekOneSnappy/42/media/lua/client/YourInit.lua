local function initPlayerRnd(player)
    -- give the player a rnd[1..5] table just like the Bandits do
    player.rnd = {}
    for i = 1, 5 do
        -- ZombRand(100)/100 gives you a float from 0.00 up to 0.99
        player.rnd[i] = ZombRand(100) / 100
    end
end

-- runs once when your character is created in the world
Events.OnCreatePlayer.Add(initPlayerRnd)
