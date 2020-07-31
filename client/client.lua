ESX = nil
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

	PlayerData = ESX.GetPlayerData()
end)

-- Markers and 3d texts
Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(1)
		if PlayerData.job ~= nil then
			if PlayerData.job == 'urzad' then
				if Config.DrawMarker == false then
					
					for i=1, #Config.Markers do
						local marker = Config.Markers[i]
						local distance = GetDistanceBetweenCoords(marker.Pos.x, marker.Pos.y, marker.Pos.z, playerC, true)

						if distance < Config.DrawDistance then
							Draw3DText(marker.Pos.x, marker.Pos.y, marker.Pos.z, marker.text)
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
						local distance = GetDistanceBetweenCoords(marker.Pos.x, marker.Pos.y, marker.Pos.z, playerC, true)

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

	local urzad = AddBlipForCoord(Config.Blip.pos.x, Config.Blip.pos.y, Config.Blip.pos.z)
	
	SetBlipSprite (urzad, Config.Blip.id)
	SetBlipScale  (urzad, Config.Blip.size)
	SetBlipColour (urzad, Config.Blip.color)
	SetBlipAsShortRange(urzad, Config.Blip.shortRange)
	
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(Config.Blip.Name)
	EndTextCommandSetBlipName(urzad)

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
	if PlayerData ~= nil and PlayerData.job == Config.Job then
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
	if PlayerData.job == 'urzad' then
		openComputer()
	end
end)

