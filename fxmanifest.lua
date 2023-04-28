fx_version 'cerulean'
game 'gta5'

author 'Redline Studios'
description 'rs-business | A template for creating businesses'
version '1.0.0'

shared_scripts { 'shared/*.lua' }
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    '@PolyZone/CircleZone.lua',
    'client/*.lua'
}
server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua'
}

lua54 'yes'