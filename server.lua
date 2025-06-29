local ESX = exports['es_extended']:getSharedObject()

-- Function to count online police
local function CountPolice()
    local count = 0
    local xPlayers = ESX.GetPlayers()
    
    for i=1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if Config.PoliceJobs[xPlayer.job.name] then
            count = count + 1
        end
    end
    
    return count
end

RegisterNetEvent('dzurny_gravedigging:checkPolice')
AddEventHandler('dzurny_gravedigging:checkPolice', function(cb)
    local policeCount = CountPolice()
    TriggerClientEvent('dzurny_gravedigging:policeCount', source, policeCount)
end)

RegisterNetEvent('dzurny_gravedigging:giveItem')
AddEventHandler('dzurny_gravedigging:giveItem', function(item, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        if item == 'money' then
            xPlayer.addMoney(amount)
        else
            xPlayer.addInventoryItem(item, amount)
        end
    end
end) 