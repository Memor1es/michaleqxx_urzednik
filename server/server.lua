ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'urzad', 'Urzad', 'society_'..Config.Job, 'society_'..Config.Job, 'society_'..Config.Job, {type = 'public'})

TriggerEvent('esx_phone:registerNumber', 'urzad', 'Urząd miasta', true, true)

RegisterNetEvent('michaleqxx_urzednik:drukuj')
AddEventHandler('michaleqxx_urzednik:drukuj', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.addInventoryItem(item, 1)
end)

