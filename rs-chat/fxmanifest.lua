fx_version 'bodacious'
game 'gta5'
lua54 'yes'

author 'Rare Services'
description 'Chat System With Reply And Automessage for ESX 1.1 and Highter'

version '1.2.2'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'source/server.lua'
}

client_scripts 'source/client.lua'

shared_scripts 'config.lua'

files {
	'ui/ui.html',
	'ui/js/*.js',
	'ui/css/*.css',
	'ui/images/icons/*.png',
	'ui/css/fonts/*.ttf'
}

ui_page 'ui/ui.html'