dependency 'essentialmode'
dependency 'es_extended'
dependency 'mhacking'

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
  'client/main.lua',
  'client/doors.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
  'server/main.lua'
}
