fx_version 'adamant'

game 'gta5'

description 'Ley tattoes'

version '1.1.0'

client_scripts {
	'client/main.lua'
}

server_scripts {
	'server/main.lua',
	'@mysql-async/lib/MySQL.lua'
}