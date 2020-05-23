ESX = nil

local logs = "https://discordapp.com/api/webhooks/713628484043407391/vjFkwmXs_tEMbI-yAjRvXOXX5WBchmIip2xF7fcO6nm7o0u46APQaRjp9nqY2eFMa1kZ"
local communityname = "INDOFOLKS ROLEPLAY"
local communtiylogo = "https://i.imgur.com/fZZWZ5l.png" 


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'taxi', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('esx_taxijob: %s attempted to trigger success!'):format(xPlayer.identifier))
		return
	end

	math.randomseed(os.time())

	local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)
	local societyAccount

	if xPlayer.job.grade >= 3 then
		total = total * 2
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
		societyAccount = account
	end)

	if societyAccount then
		local playerMoney  = ESX.Math.Round(total / 100 * 30)
		local societyMoney = ESX.Math.Round(total / 100 * 70)

		xPlayer.addMoney(playerMoney)
		societyAccount.addMoney(societyMoney)

		--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned', societyMoney, playerMoney))
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = '- Perusahaan mendapat pemasukkan Rp ' ..societyMoney.. '\n- Kamu mendapatkan Rp ' ..playerMoney, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	else
		xPlayer.addMoney(total)
		--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned', total))
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Kamu mendapatkan Rp ' ..total, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end

end)

RegisterServerEvent('esx_taxijob:getStockItem')
AddEventHandler('esx_taxijob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local name = GetPlayerName(source)
  	local steamhex = GetPlayerIdentifier(source)
	if xPlayer.job.name ~= 'taxi' then
		print(('esx_taxijob: %s attempted to trigger getStockItem!'):format(xPlayer.identifier))
		return
	end
	
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then
		
			-- can the player carry the said amount of x item?
			if  (sourceItem.count + count) > 99999999 then
				--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_cannot_hold'))
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Inventori kamu penuh!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				local connect = {
					{
						["color"] = "14886454",
						["title"] = "Gocek mengambil barang dari kantor!",
						["description"] = "Player: **"..name.."**\nBarang: **" ..itemName.. "**\nJumblah: **"..count.."**\nSteam Hex: **"..steamhex.."**",
					  	["footer"] = {
							["text"] = communityname,
							["icon_url"] = communtiylogo,
						},
					}
				}																								
				PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Indofolks Server Logger", embeds = connect}), { ['Content-Type'] = 'application/json' })

				--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Kamu mengambil ' ..count.. ' ' ..item.label, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			end
		else
			--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Jumlah invalid', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		end
	end)
end)

ESX.RegisterServerCallback('esx_taxijob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_taxijob:putStockItems')
AddEventHandler('esx_taxijob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local name = GetPlayerName(source)
	local steamhex = GetPlayerIdentifier(source)
	if xPlayer.job.name ~= 'taxi' then
		print(('esx_taxijob: %s attempted to trigger putStockItems!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
				local connect = {
					{
						["color"] = "14886454",
						["title"] = "Gocek menyimpan barang dari kantor!",
						["description"] = "Player: **"..name.."**\nBarang: **" ..itemName.. "**\nJumblah: **"..count.."**\nSteam Hex: **"..steamhex.."**",
					  	["footer"] = {
							["text"] = communityname,
							["icon_url"] = communtiylogo,
						},
					}
				}																								
				PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Indofolks Server Logger", embeds = connect}), { ['Content-Type'] = 'application/json' })
			--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, item.label))
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Kamu menaruh '..count..' '..item.label, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		else
			--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Jumlah invalid', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		end

	end)

end)

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)
