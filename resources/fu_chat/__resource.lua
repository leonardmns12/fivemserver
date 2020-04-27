resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

name 'Mythic Framework Chat'
description 'Modified FiveM Chat Resource To Use Mythic Frameworks Permissions System'
author 'Alzar - https://github.com/Alzar'
version 'v1.0.0'
url 'https://github.com/mythicrp/base'

ui_page 'html/index.html'


client_scripts {
  'client/cl_chat.lua',
  'client/main.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/main.lua',
  'server/sv_chat.lua',
  'server/utils.lua',
  'server/commands.lua',
}



files {
  'html/index.html',
  'html/js/config.default.js',
  'html/js/config.js',
  'html/js/App.js',
  'html/js/Message.js',
  'html/js/Suggestions.js',
  'html/vendor/vue.2.3.3.min.js',
  'html/vendor/flexboxgrid.6.3.1.min.css',
  'html/vendor/animate.3.5.2.min.css',
  'html/vendor/latofonts.css',
  'html/vendor/fonts/LatoRegular.woff2',
  'html/vendor/fonts/LatoRegular2.woff2',
  'html/vendor/fonts/LatoLight2.woff2',
  'html/vendor/fonts/LatoLight.woff2',
  'html/vendor/fonts/LatoBold.woff2',
  'html/vendor/fonts/LatoBold2.woff2',
  'html/css/style.css',
}

