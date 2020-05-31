-------------------------------------
------- Created by T1GER#9080 -------
------- Cracked by R32#2445 ---------
------------------------------------- 

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'T1GER Car Dealer'

author 'T1GER#9080'

ui_page 'html/index.html'

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/client.lua',
	'client/utils.lua'
}

files {
	'html/index.html',
	'html/assets/css/*.css',
	'html/assets/js/*.js',
	'html/assets/images/*.png'
}
