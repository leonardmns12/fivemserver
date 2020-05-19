
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
-- Success server event

RegisterServerEvent('ifk_water:drinkSuccess')
AddEventHandler('ifk_water:drinkSuccess', function(src)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
    TriggerClientEvent('esx_basicneeds:onDrink', source)
    
end) 

RegisterServerEvent('ifk_water:eatSuccess')
AddEventHandler('ifk_water:eatSuccess', function(src)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
    TriggerClientEvent('esx_basicneeds:onEat', source)
    
end) 