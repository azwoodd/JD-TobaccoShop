name "JD-Tobacco-Shop-Job"
author "JDSTUDIOS"
version "v1.1"
description "Tobacco Shop Job Script By JD"
fx_version "cerulean"
game "gta5"

dependency 'qb-core'

client_scripts {
	'client.lua',
}

server_scripts {
    'server.lua'
}

shared_scripts {
    'config.lua',
}

ui_page 'html/shop.html'

files {
    'html/shop.html',
}

lua54 'yes'

escrow_ignore {
	'*.lua*',
	'client/*.lua*',
	'server/*.lua*',
}
dependency '/assetpacks'