ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_blackmoney:washMoney')
AddEventHandler('esx_blackmoney:washMoney', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local accountMoney = 0
	
	accountMoney = xPlayer.getAccount('black_money').money

	local ticketQuantity = xPlayer.getInventoryItem('moneywashid').count
	
	if ticketQuantity > 0 then
		if accountMoney < 20000 then
			-- notification('You do not have enough ~r~dirty money~s~ to wash')
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu tidak punya cukup uang', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		else
			xPlayer.removeAccountMoney('black_money', 20000)
			xPlayer.addMoney(18000)
			-- notification('You ~g~washed~s~ 100 ~r~dirty money')
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu mencuci uang 20000', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		end
	else
		-- notification('You do not have a ticket to use our moneywasher')
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu tidak punya akses!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end
end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end