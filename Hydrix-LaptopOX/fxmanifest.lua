--[[ FX Information ]]--
fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'Hydrix-LaptopOX'
version      '0.1.0'
description  'NP Inspired Practice Laptop By </Hydrix_Scripts>'
license      'GPL 3.0'
author       '</Hydrix_Scripts>'
repository   'https://github.com/imtorchedbud/Hydrix-LaptopOX'

--[[ Manifest ]]--
shared_scripts {
	'@ox_lib/init.lua',
    'shared/init.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

ui_page 'web/build/index.html'
