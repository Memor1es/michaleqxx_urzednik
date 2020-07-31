resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'A Town Hall script by Michaleqxx'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'config.lua',
	'client/client.lua'
}

ui_page('html/ui.html')

files({
    'html/ui.html',
    'html/style.css',
	'html/desktop.jpg'
})

dependencies {
	'es_extended',
	'esx_addonaccount',
	'esx_addoninventory',
	'esx_datastore'
}