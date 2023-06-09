fx_version 'bodacious'
game 'gta5'
lua54 'yes'

author 'Rare Services'
description 'Chat System With Reply And Automessage for ESX 1.1 and Highter'
version '1.3.0'

shared_scripts 'config.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'source/server.lua'
}

client_scripts  {
     'config.lua',
     'source/client.lua'
}

files {
    'ui/ui.html',
    'ui/js/*.js',
    'ui/css/*.css',
    'ui/images/icons/*.png',
    'ui/css/fonts/*.ttf'
}

ui_page 'ui/ui.html'
