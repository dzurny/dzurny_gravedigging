fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'džurny'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'locales/cs.lua',
    'locales/en.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

escrow_ignore {
    'config.lua',
    'locales/*.lua'
}

dependencies {
    'es_extended',
    'ox_lib'
}