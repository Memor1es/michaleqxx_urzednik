Config = {}

Config.Job = 'urzad'			-- Change this to your job in database

Config.DrawBlip = false			-- Change this to false if you don't want blips on map
Config.DrawMarker = false		-- Change this to true if you don't want 3d texts
Config.DrawDistance = 3.0

Config.EnablepNotify = false		-- You must have pNotify on your server if you set this to true!
Config.pNotifyTimeout = 3000	-- If you have pNotify you know how is that

Config.MarkerSettings = {
	r = 0,
	g = 120,
	b = 0,
	a = 150,
	typ = 27,
	size = 0.8
}

Config.TextScale = 0.25		-- 3D text scale

Config.ConfirmButton = 38	-- E key

-- Here You can simply change every parameter of blip
Config.Blip = {
	
	name = 'Urząd miasta',
	id = 419,
	color = 0,
	size = 0.5,
	shortRange = true,
	pos = { x = 229.34, y = -430.92, z = 48.08 }
	
}

--[[

	If you create own job action, simpy you can copy and paste one action from list, parameters you must change:
	
	action - this is name of client event
	pos - position of marker/3d text
	text - change this only, when function DrawMarker is false
	params - simply all past name of action, example TriggerEvent(Config.Markers.action, Config.Markers.params), if you don't want params set this to nil or ''
	
]]--
Config.Markers = {
	
	{
		text = 'Naciśnij [~g~E~w~] aby zalogować się do komputera',
		pos = { x = 229.34, y = -430.92, z = 48.08 },
		action = 'computer',
		params = nil
	},
	{
		text = 'Naciśnij [~g~E~w~] aby się przebrać',
		pos = { x = 216.6, y = -429.12, z = 48.08 },
		action = 'cloakroom',
		params = nil
	},
	{
		text = 'Naciśnij [~g~E~w~] aby wydrukować',
		pos = { x = 226.84, y = -429.81, z = 48.08 },
		action = 'printer',
		params = nil
	},
	{
		text = 'Naciśnij [~g~E~w~] aby zalogować się jako szef',
		pos = { x = 213.31, y = -395.92, z = 48.08 },
		action = 'boss',
		params = nil
	}
	
}

-- Clothes
Config.Ubrania = {
	first = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 50,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 33,
			['pants_1'] = 46,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['vest_1'] = 2,		['vest_2'] = 1
		},
		female = {
			['tshirt_1'] = 40,  ['tshirt_2'] = 0,
			['torso_1'] = 7,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 3,
			['pants_1'] = 7,   ['pants_2'] = 0,
			['shoes_1'] = 0,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_1'] = 0
		}
	}
}