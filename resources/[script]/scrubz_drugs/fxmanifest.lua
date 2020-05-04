fx_version 'adamant'
games { 'gta5' }

client_scripts {
	'_configs/cfg_general.lua',
	'core/client/cl_functions.lua',
	'core/client/cl_ply.lua',
	'core/client/cl_locations.lua',
	'core/client/cl_weed.lua',
	'core/client/cl_materials.lua'
	--'core/client/cl_plantableweed',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'_configs/cfg_general.lua',
	'core/server/sv_ply.lua',
	'core/server/sv_locations.lua'
	--'core/server/sv_plantableweed'
}
