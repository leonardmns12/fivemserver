resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "web/index.html"

client_scripts {
  "client/client.lua"
}

files {
  "web/index.html",
  "web/img/radio.png",
  "web/scripts/listener.js",
  "web/styles/index.css",
  "web/styles/reset.css",
  "web/styles/MotorolaScreentype.woff"
}

dependencies {
    "es_extended",
    "tokovoip_script"
}