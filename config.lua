Config = {}

Config.Job = 'urzad'			-- Change this to your job in database

Config.DrawBlip = true			-- Change this to false if you don't want blips on map
Config.DrawMarker = false		-- Change this to true if you don't want 3d texts
Config.DrawDistance = 5.0

Config.EnablepNotify = true		-- You must have pNotify on your server if you set this to true!
Config.pNotifyTimeout = 3000	-- If you have pNotify you know how is that

Config.MarkerSettings = {
	r = 0,
	g = 120,
	b = 0,
	a = 150,
	typ = 27,
	size = 0.8
}

Config.TextScale = 0.2		-- 3D text scale

Config.ConfirmButton = 38	-- E key

-- Here You can simply change every parameter of blip
Config.Blip = {
	
	name = 'Urząd miasta',
	id = 419,
	color = 0,
	size = 0.5,
	shortRange = true,
	pos = { x = , y = , z =  }
	
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
		text = 'Naciśnij [~g~E~w~] aby się przebrać',
		pos = { x = , y = , z =  },
		action = 'cloakroom',
		params = nil
	},
	
	{
		text = 'Naciśnij [~g~E~w~] aby zalogować się do komputera',
		pos = { x = , y = , z =  },
		action = 'computer',
		params = nil
	}
	
}