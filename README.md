# dzurny_gravedigging

A FiveM ESX script that allows players to dig graves and find valuable items. The script includes features like progress bars, notifications, police dispatch integration, and localization support.

## Features

- Interactive grave digging system
- Progress bar during digging
- Random item rewards with configurable chances
- Police job integration
- Dispatch notifications for police
- Cooldown system for graves
- Localization support (Czech and English)
- Configurable grave locations
- Modern UI using lib.textUI

## Dependencies

- ESX Framework
- ox_lib
- cd_dispatch (for police notifications)

## Installation

1. Download the script
2. Place it in your server's resources folder
3. Add `ensure dzurny_gravedigging` to your server.cfg
4. Configure the script in `config.lua`
5. Restart your server

## Configuration

### Locale
```lua
Config.Locale = 'cs' -- 'cs' for Czech, 'en' for English
```

### Police Settings
```lua
Config.RequiredPolice = 0 -- Number of police officers required to dig graves
Config.PoliceJobs = {
    ['police'] = true,
    ['sheriff'] = true
}
Config.AllowPoliceDigging = true -- Whether police jobs can dig graves
```

### Grave Locations
Add or modify grave locations in the `Config.Graves` table:
```lua
Config.Graves = {
    {
        coords = vector3(-1789.4203, -231.5432, 50.5379),
        heading = 305.1710,
        label = "Gravedigging 1"
    }
}
```

### Possible Items
Configure items that can be found in graves:
```lua
Config.PossibleItems = {
    {
        item = 'money',
        label = 'Peníze',
        chance = 10, -- 10% chance
        min = 1,
        max = 3
    }
}
```

### Digging Settings
```lua
Config.DigTime = 10000 -- Time in ms to dig a grave
Config.Cooldown = 5 -- Cooldown in seconds between digging
```

## Usage

1. Approach a grave location
2. Press E to start digging
3. Wait for the progress bar to complete
4. Receive random items based on configured chances

## Localization

The script supports both Czech and English languages. To add more languages:

1. Create a new file in the `locales` folder (e.g., `fr.lua`)
2. Copy the structure from existing locale files
3. Translate the strings
4. Add the new locale to the config

## Support

For support, please create an issue on the GitHub repository.
Please note, blacklist the dzurny_gravesigging:giveitem trigger.
## License

Feel free to do whatever you want with this script.