resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Trew NOTIFY'

ui_page 'html/ui.html'


files {
	'html/ui.html',
	'html/main.css',
	'html/app.js',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'config.lua',
	'client/client.lua',
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'config.lua',
	'server/server.lua',
}

dependencies {
	'es_extended'
}