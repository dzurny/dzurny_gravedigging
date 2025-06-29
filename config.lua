Config = {}

-- Locale settings
Config.Locale = 'cs' -- 'cs' for Czech, 'en' for English

-- Police settings
Config.RequiredPolice = 0 -- Number of police officers required to dig graves
Config.PoliceJobs = {
    ['police'] = true,
    ['sheriff'] = true
}
Config.AllowPoliceDigging = true -- Whether police jobs can dig graves

-- Grave locations
Config.Graves = {
    {
        coords = vector3(-1789.4203, -231.5432, 50.5379),
        heading = 305.1710,
        label = "Gravedigging 1"
    },
    {
        coords = vector3(241.2, -1362.8, 33.7),
        heading = 0.0,
        label = "Gravedigging 2"
    },
    {
        coords = vector3(244.8, -1365.4, 33.7),
        heading = 0.0,
        label = "Gravedigging 3"
    }
}

-- Items that can be found in graves
Config.PossibleItems = {
    {
        item = 'money',
        label = 'Peníze',
        chance = 10, -- 10% chance
        min = 1,
        max = 3
    },
    {
        item = 'money',
        label = 'Peníze',
        chance = 30, -- 30% chance
        min = 1,
        max = 5
    },
    {
        item = 'money',
        label = 'Peníze',
        chance = 50, -- 50% chance
        min = 1000,
        max = 5000
    }
}

-- Digging settings
Config.DigTime = 10000 -- Time in ms to dig a grave
Config.Cooldown = 5 -- Cooldown in seconds between digging 