ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'urzad', 'Urzad', 'society_'..Config.Job, 'society_'..Config.Job, 'society_'..Config.Job, {type = 'public'})

TriggerEvent('esx_phone:registerNumber', 'urzad', 'Urząd miasta', true, true)