ESX = nil
local logs = "https://discordapp.com/api/webhooks/627033104032464906/l-pA_1oZ6SAAji0LB6yzw5TksU67ShG4kBcqp_KUIYrpJoO3rpMPriXCJM4clbEOEFPO"
local communityname = "IN YOUR DREAM"
local communtiylogo = "https://i.imgur.com/JvMPlGh.png" 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Vehicles = nil

RegisterServerEvent('esx_lscustom:buyMod')
AddEventHandler('esx_lscustom:buyMod', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	price = tonumber(price)

	if Config.IsMechanicJobOnly then
		local name = GetPlayerName(source)
  		local ip = GetPlayerEndpoint(source)
  		local ping = GetPlayerPing(source)
  		local steamhex = GetPlayerIdentifier(source)	
		local societyAccount = nil
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
			societyAccount = account
		end)
		if price < societyAccount.money then
			local connect = {
        {
            ["color"] = "8663711",
            ["title"] = "Player Menggunakan Uang Perusahaan untuk Modif",
            ["description"] = "Player: **"..name.."**\nJumlah: **"..price.."**\nSteam Hex: **"..steamhex.."**",
          ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
            },
        }
    }
			TriggerClientEvent('esx_lscustom:installMod', _source)
			societyAccount.removeMoney(price)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
	
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "In Your Dream Server Logger", embeds = connect}), { ['Content-Type'] = 'application/json' })    
			
		else
			TriggerClientEvent('esx_lscustom:cancelInstallMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
		end

	else

		if price < xPlayer.getMoney() then
			TriggerClientEvent('esx_lscustom:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('esx_lscustom:cancelInstallMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
		end

	end
end)

RegisterServerEvent('esx_lscustom:refreshOwnedVehicle')
AddEventHandler('esx_lscustom:refreshOwnedVehicle', function(myCar)
	MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)

ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
	if Vehicles == nil then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)