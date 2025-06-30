local ESX = exports['es_extended']:getSharedObject()
local isDigging = false
local cooldown = false
local cooldownGraves = {}
local currentGrave = nil

-- Function to get locale string
local function L(str, ...)
    if not Locales then return str end
    local locale = Config.Locale or 'cs'
    if not Locales[locale] then return str end
    if not Locales[locale][str] then return str end
    return string.format(Locales[locale][str], ...)
end

-- Function to check if player is police
local function IsPolice()
    local playerData = ESX.GetPlayerData()
    return Config.PoliceJobs[playerData.job.name] == true
end

-- Function to get random item from config
local function GetRandomItem()
    local totalChance = 0
    for _, item in pairs(Config.PossibleItems) do
        totalChance = totalChance + item.chance
    end
    
    local random = math.random(1, totalChance)
    local currentChance = 0
    
    for _, item in pairs(Config.PossibleItems) do
        currentChance = currentChance + item.chance
        if random <= currentChance then
            return item
        end
    end
end

-- Function to get police jobs for dispatch
local function GetPoliceJobsForDispatch()
    local jobs = {}
    for job, _ in pairs(Config.PoliceJobs) do
        table.insert(jobs, job)
    end
    return jobs
end

-- Main thread for grave interaction
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for _, grave in pairs(Config.Graves) do
            local distance = #(coords - grave.coords)
            
            if distance < 10.0 then
                sleep = 0
                if distance < 1.5 then
                    if not isDigging then
                        if cooldownGraves[grave.label] then
                            lib.showTextUI('💀 ' .. L('grave_dug'))
                        else
                            lib.showTextUI('💀 ' .. L('dig_grave'))
                            
                            if IsControlJustReleased(0, 38) then -- E key
                                if IsPolice() and not Config.AllowPoliceDigging then
                                    ESX.ShowNotification(L('police_cant_dig'))
                                else
                                    currentGrave = grave
                                    TriggerServerEvent('dzurny_gravedigging:checkPolice')
                                end
                            end
                        end
                    end
                else
                    lib.hideTextUI()
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Event handler for police count
RegisterNetEvent('dzurny_gravedigging:policeCount')
AddEventHandler('dzurny_gravedigging:policeCount', function(policeCount)
    if currentGrave then
        if policeCount >= Config.RequiredPolice then
            StartDigging(currentGrave)
        else
            ESX.ShowNotification(L('need_police', Config.RequiredPolice))
        end
        currentGrave = nil
    end
end)

-- Function to start digging
function StartDigging(grave)
    if isDigging then return end
    isDigging = true
    lib.hideTextUI()
    
    -- Animation
    RequestAnimDict("amb@world_human_gardener_plant@male@base")
    while not HasAnimDictLoaded("amb@world_human_gardener_plant@male@base") do
        Wait(10)
    end
    
    TaskPlayAnim(PlayerPedId(), "amb@world_human_gardener_plant@male@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
    
    -- Progress bar
if lib.progressBar({
    duration = Config.DigTime,
    label = L('digging'),
    useWhileDead = false,
    canCancel = true,
    disable = {
        car = true,
        move = true,
        combat = true,
    },
    anim = {
        dict = "amb@world_human_gardener_plant@male@base",
        clip = "base"
    },
}) then
    -- Úspešné kopanie
    local item = GetRandomItem()
    local amount = math.random(item.min, item.max)
    
    -- Bezpečné volanie servera
    TriggerServerEvent('dzurny_gravedigging:setRewardReady')
    Wait(100)
    TriggerServerEvent('dzurny_gravedigging:giveItem', item.item, amount)

    ESX.ShowNotification(L('found_item', amount, item.label))

    -- Dispatch pre políciu
    local data = exports['cd_dispatch']:GetPlayerInfo()
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = GetPoliceJobsForDispatch(), 
        coords = data.coords,
        title = L('dispatch_title'),
        message = L('dispatch_message', data.sex, data.street), 
        flash = 0,
        unique_id = data.unique_id,
        sound = 1,
        blip = {
            sprite = 431, 
            scale = 1.2, 
            colour = 3,
            flashes = false, 
            text = L('dispatch_blip'),
            time = 5,
            radius = 0,
        }
    })

    cooldownGraves[grave.label] = true
    SetTimeout(Config.Cooldown * 1000, function()
        cooldownGraves[grave.label] = false
    end)
else
    -- Zrušené
    ESX.ShowNotification(L('digging_cancelled'))
end
    
    ClearPedTasks(PlayerPedId())
    isDigging = false
end 