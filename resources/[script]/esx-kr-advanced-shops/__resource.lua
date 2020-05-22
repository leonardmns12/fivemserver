resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page('html/index.html') 

files({
  'html/index.html',
  'html/script.js',
  'html/style.css',
	'html/img/burger.png',
	'html/img/bottle.png',
  'html/font/vibes.ttf',
  'html/img/box.png',
  'html/img/phone.png',
  'html/img/bread.png',
  'html/img/bandage.png',
  'html/img/medikit.png',
  'html/img/water.png',
  'html/img/advancedlockpick.png',
  'html/img/lockpick.png',
  'html/img/beer.png',
  'html/img/bulletproof.png',
  'html/img/cigarette.png',
  'html/img/fishbait.png',
  'html/img/fishingrod.png',
  'html/img/fixkit.png',
  'html/img/weabox.png',
  'html/img/weaclip.png',
	'html/img/carticon.png',
	'html/img/turtlebait.png',
})

client_scripts {
  'config.lua',
  'client/main.lua',
  '@es_extended/locale.lua',
  'locales/en.lua',
  'locales/fr.lua',	
  'locales/sv.lua',
}

server_scripts {
  'config.lua',
  'server/main.lua',
  '@mysql-async/lib/MySQL.lua'
}
