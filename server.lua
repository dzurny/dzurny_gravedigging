local ESX = exports['es_extended']:getSharedObject()

-- Jobs that count as police
Config.PoliceJobs = {
    ['police'] = true,
    ['sheriff'] = true
}

-- Player state table
local rewardReady = {}

-- Count online police
local function CountPolice()
    local count = 0
    local xPlayers = ESX.GetPlayers()

    for _, playerId in ipairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and Config.PoliceJobs[xPlayer.job.name] then
            count = count + 1
        end
    end

    return count
end

-- Check police count
RegisterNetEvent('dzurny_gravedigging:checkPolice')
AddEventHandler('dzurny_gravedigging:checkPolice', function()
    local policeCount = CountPolice()
    TriggerClientEvent('dzurny_gravedigging:policeCount', source, policeCount)
end)

-- Called when player finishes grave digging action (client triggers this after minigame etc.)
RegisterNetEvent('dzurny_gravedigging:setRewardReady')
AddEventHandler('dzurny_gravedigging:setRewardReady', function()
    local src = source
    rewardReady[src] = true
end)

-- Secure reward giving
RegisterNetEvent('dzurny_gravedigging:giveItem')
AddEventHandler('dzurny_gravedigging:giveItem', function(item, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    -- Check if player is allowed to get a reward
    if not rewardReady[src] then
        print(("⚠️ Hráč %s sa pokúsil získať odmenu bez povolenia!"):format(src))
        DropPlayer(src, "Pokus o exploitovanie systému odmien.")
        return
    end

    rewardReady[src] = nil -- Reset status (one-time reward)

    -- Sanitize item and amount
    amount = math.floor(tonumber(amount) or 1)
    if amount < 1 or amount > 5 then
        print(("⚠️ Hráč %s sa pokúsil získať neplatné množstvo itemov: %s"):format(src, amount))
        return
    end

    local allowedItems = {
        ['bone'] = true,
        ['dirty_money'] = true,
        ['shovel'] = true
    }

    if not allowedItems[item] and item ~= 'money' then
        print(("⚠️ Hráč %s sa pokúsil získať neautorizovaný item: %s"):format(src, item))
        return
    end

    -- Give reward
    if item == 'money' then
        xPlayer.addMoney(amount * 100)
    else
        xPlayer.addInventoryItem(item, amount)
    end

    print(("✅ Hráč %s dostal odmenu: %sx %s"):format(src, amount, item))
end)