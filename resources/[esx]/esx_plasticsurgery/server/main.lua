ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_plasticsurgery:pay')
AddEventHandler('esx_plasticsurgery:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(Config.Price)
	-- TriggerClientEvent('esx:showNotification', source, _U('you_paid', ESX.Math.GroupDigits(Config.Price)))
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu membayar ' ..Config.Price.. '!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
end)

-- ESX.RegisterServerCallback('esx_plasticsurgery:checkMoney', function(source, cb)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	print(xPlayer.get('money'))
-- 	cb(xPlayer.get('money') >= Config.Price)
-- end)
