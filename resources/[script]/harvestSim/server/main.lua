ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('harvestSim:startHarvestLicenseA')
AddEventHandler('harvestSim:startHarvestLicenseA', function(a)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' and xPlayer.job.grade > 0 then
    		if a == 1 then
				xPlayer.addInventoryItem('licenseA', 1)
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'item added : Sim A ', length = 3500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
   			else
				xPlayer.addInventoryItem('licensec', 1)
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'item added : Sim C', length = 3500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
   			end
	else 
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu tidak bisa mencetak sim!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end		
end)


