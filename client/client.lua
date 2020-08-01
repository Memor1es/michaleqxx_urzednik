ESX = nil
PlayerData = {}
local computer = false

-- Player data checks
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'close'})
	
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local playerC = GetEntityCoords(PlayerPedId())
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2500)
		playerC = GetEntityCoords(PlayerPedId())
	end
end)

-- Markers and 3d texts
Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(0)
		if PlayerData.job ~= nil then
			if PlayerData.job.name == 'urzad' then
				if Config.DrawMarker == false then
					for i=1, #Config.Markers do
						local marker = Config.Markers[i]
						local distance = GetDistanceBetweenCoords(marker.pos.x, marker.pos.y, marker.pos.z, playerC, true)

						if distance < Config.DrawDistance then
							Draw3DText(marker.pos.x, marker.pos.y, marker.pos.z, marker.text)
							if IsControlJustReleased(0, Config.ConfirmButton) and distance < 1.25 then
								if marker.params == nil or marker.params == '' then
									TriggerEvent(marker.action)
								else
									TriggerEvent(marker.action, marker.params)
								end
							end
						end
					end
				elseif Config.DrawMarker == true then
					for i=1, #Config.Markers do
						local marker = Config.Markers[i]
						local distance = GetDistanceBetweenCoords(marker.pos.x, marker.pos.y, marker.pos.z, playerC, true)

						if distance < Config.DrawDistance then
							DrawMarker(Config.MarkerSettings.typ, marker.Pos.x, marker.Pos.y, marker.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSettings.size, Config.MarkerSettings.size, Config.MarkerSettings.size, Config.MarkerSettings.r, Config.MarkerSettings.g, Config.MarkerSettings.b, Config.MarkerSettings.a, false, true, 2, false, false, false, false)
							if IsControlJustReleased(0, Config.ConfirmButton) and distance < 1.25 then
								if marker.params == nil or marker.params == '' then
									TriggerEvent(marker.action)
								else
									TriggerEvent(marker.action, marker.params)
								end
							end
						end
					end
				end
			end
		elseif PlayerData.job == nil then
			Citizen.Wait(2500)
		end
	end
end)

-- Blips
Citizen.CreateThread(function() 
	if Config.Blip == true then
		local urzad = AddBlipForCoord(Config.Blip.pos.x, Config.Blip.pos.y, Config.Blip.pos.z)
		
		SetBlipSprite (urzad, Config.Blip.id)
		SetBlipScale  (urzad, Config.Blip.size)
		SetBlipColour (urzad, Config.Blip.color)
		SetBlipAsShortRange(urzad, Config.Blip.shortRange)
		
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(Config.Blip.name)
		EndTextCommandSetBlipName(urzad)
	end
end)

function Draw3DText(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = tonumber(Config.TextScale)
   
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(1, 1, 0, 0, 255)
        SetTextEdge(0, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(2)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

-- 3D for animations
function DrawText3D(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

  SetTextScale(scale, scale)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 255)
  SetTextOutline()

  AddTextComponentString(text)
  DrawText(_x, _y)

  local factor = (string.len(text)) / 270
  DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

function DrawNotification(text)
	if Config.EnablepNotify == true then
		exports["pNotify"]:SendNotification({text = tostring(text), type = 'info', timeout = Config.pNotifyTimeout})
	elseif Config.EnablepNotify == false then
		ESX.ShowNotification(text)
	end
end

-- NUI fragment

function openComputer()
	if not computer then
		SetNuiFocus(true, true)
		SendNUIMessage({type = 'open'})
		computer = true
	end
end

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
	computer = false
end)

RegisterNUICallback('bossMenu', function(data, cb)
	if PlayerData ~= nil and PlayerData.job.name == Config.Job then
		OpenBossMenu()
	end	
end)

RegisterNUICallback('checkVehicle', function(data, cb)
	if PlayerData ~= nil and PlayerData.job == Config.Job then
		local length = string.len(data.rej)
		if not data.rej or length < 2 or length > 8 then
			DrawNotification('Baza danych: '..tostring(data.rej)..'\njest niepoprawna bądź nie istnieje!')
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
				DrawNotification('Rejestracja: '..retrivedInfo.plate..'\nWłaściciel: '..retrivedInfo.owner)
			end, data.rej)
		end
	end	
end)

-- Events (Marker actions)

AddEventHandler('computer', function()
	if PlayerData.job.name == Config.Job then
		openComputer()
	end
end)

AddEventHandler('cloakroom', function()
	if PlayerData.job.name == Config.Job then
		Cloakroom()
	end
end)

AddEventHandler('printer', function()
	if PlayerData.job.name == Config.Job then
		Printer()
	end
end)

-- Cloakroom

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Ubrania[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Ubrania[job].male)
			else
				--ESX.ShowNotification(_U('no_outfit'))
				DrawNotification('Nie ma takiego przebrania dla twojej płci!')
			end
		else
			if Config.Ubrania[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Ubrania[job].female)
			else
				--ESX.ShowNotification(_U('no_outfit'))
				DrawNotification('Nie ma takiego przebrania dla twojej płci!')
			end
		end
	end)
end

function Cloakroom()
	local elements = {}
	
	table.insert(elements, {label = 'Zdejmij ubrania urzędnika',     value = 'teraz'})
	table.insert(elements, {label = '<span style="font-family: bold;">Ubrania</span>', value = 'naglowek'})
	table.insert(elements, {label = 'Ubrania urzędnika',     value = '1'})
	table.insert(elements, {label = 'Ubrania własne',  value = 'wlasne'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'storage',
	{
		title    = 'Szatnia',
		align    = 'right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			setUniform('first', playerPed)
		elseif data.current.value == 'wlasne' then
			
			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
			local elements = {}

			for i=1, #dressing, 1 do
				table.insert(elements, {
					label = dressing[i],
					value = i
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
				title    = Locale.Cloakroom.ownClothes,
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				TriggerEvent('skinchanger:getSkin', function(skin)
					ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
						TriggerEvent('skinchanger:loadClothes', skin, clothes)
						TriggerEvent('esx_skin:setLastSkin', skin)

						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)
					end, data2.current.value)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end)

			
		elseif data.current.value == 'teraz' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
		
	end, function(data, menu)
		menu.close()
	end)
end

-- Printer

function Printer()
	
	local elements = {}
	
	table.insert(elements, {label = '<span style="font-family: bold;">Dla firm:</span>', value = ''})
	table.insert(elements, {label = 'Rozliczenie dochodu podatkowego',     value = 'firma'})
	table.insert(elements, {label = 'Formularz o założenie firmy',     value = 'firma1'})
	table.insert(elements, {label = 'Formularz o handlu żywnością',     value = 'firma2'})
	table.insert(elements, {label = 'Koncesja na alkohol',     value = 'firma3'})
	table.insert(elements, {label = '<span style="font-family: bold;">Dla obywatela:</span>', value = ''})
	table.insert(elements, {label = 'Formularz na prawo jazdy',  value = 'prawojazdy'})
	table.insert(elements, {label = 'Podatek za nieruchomość',  value = 'nieruchomosc'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'printer',
	{
		title    = 'Drukarka',
		align    = 'right',
		elements = elements
	}, function(data, menu)

		if data.current.value ~= '' then
			PrintAnimation()
			FreezeEntityPosition(PlayerPedId(), true)
			Percents(30)
			FreezeEntityPosition(PlayerPedId(), false)
			TriggerServerEvent('michaleqxx_urzednik:drukuj', data.current.value)
		end
		
		
	end, function(data, menu)
		menu.close()
	end)
	
end

function PrintAnimation()
	local ad = "mini@repair"
	local anim = "fixing_a_ped"
	local player = PlayerPedId()


	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, anim, 8 ) ) then
			TaskPlayAnim( player, ad, "exit", 8.0, -8.0, 0.2, 1, 0, 0, 0, 0 )
			ClearPedSecondaryTask(player)
		else
			SetCurrentPedWeapon( player, GetHashKey("WEAPON_UNARMED"), equipNow)
			Citizen.Wait(50)
			TaskPlayAnim( player, ad, anim, 8.0, -8.0, 0.2, 1, 0, 0, 0, 0 )
		end
	end
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function Percents(time)
  TriggerEvent('urzednik:procenty')
  TimeLeft = 0
  repeat
  TimeLeft = TimeLeft + 1
  Citizen.Wait(time)
  until(TimeLeft == 100)
  xd = false
end

RegisterNetEvent('urzednik:procenty')
AddEventHandler('urzednik:procenty', function()
  xd = true
    while (xd) do
      Citizen.Wait(10)
      local playerPed = PlayerPedId()
      local coords = GetEntityCoords(playerPed)
      DisableControlAction(0, 73, true)
      DrawText3D(coords.x, coords.y, coords.z+0.1,'Drukuje...' , 0.4)
      DrawText3D(coords.x, coords.y, coords.z, TimeLeft .. '~g~%', 0.4)
    end
end)


