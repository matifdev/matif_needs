fx_version 'adamant'
games { 'gta5' }

shared_script {
	'config.lua',
}

client_scripts {
	'client.lua',
	'chatsuggestions.lua',
}

server_script 'server.lua'

ui_page 'html/index.html'

files {
	"html/script.js",
	"html/jquery.min.js",
	"html/jquery-ui.min.js",
	"html/styles.css",
	"html/index.html",
}
