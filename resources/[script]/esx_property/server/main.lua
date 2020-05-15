ESX = nil
local hasSqlRun = false
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetProperty(name)
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end


-- extremely useful when restarting script mid-game
Citizen.CreateThread(function()
	Citizen.Wait(5000) -- hopefully enough for connection to the SQL server

	if not hasSqlRun then
		LoadSql()
		hasSqlRun = true
	end
end)

AddEventHandler('onMySQLReady', function()
	hasSqlRun = true
	LoadSql()
end)


ESX.RegisterServerCallback('property:getItemAmount', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local qtty = xPlayer.getInventoryItem(item).count
    cb(qtty)
end)

function SetPropertyOwned(name, price, rented, owner)
	MySQL.Async.execute('UPDATE properties SET free = 1 WHERE name = @name', {
		['@name'] = name,
		['@free']   = 1
	})
	MySQL.Async.execute('INSERT INTO owned_properties (name, price, rented, owner) VALUES (@name, @price, @rented, @owner)', {
		['@name']   = name,
		['@price']  = price,
		['@rented'] = (rented and 1 or 0),
		['@owner']  = owner
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)

		if xPlayer then
			TriggerClientEvent('esx_property:setBlipOwned', -1, name)
			Citizen.Wait(100)
			TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, name, true)

			if rented then
				--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('rented_for', ESX.Math.GroupDigits(price)))
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Kamu menyewa properti ini seharga ' ..ESX.Math.GroupDigits(price), length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('purchased_for', ESX.Math.GroupDigits(price)))
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Kamu membeli properti ini seharga ' ..ESX.Math.GroupDigits(price), length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			end
		end
	end)
end

-- function setPropertyLocked(name, source)
-- 	MySQL.Async.execute('UPDATE properties SET free = 1 WHERE name = @name', {
-- 		['@name'] = name,
-- 		['@free']   = 1
-- 	})
-- end

function RemoveOwnedProperty1(name, owner)
	MySQL.Async.execute('DELETE FROM owned_properties WHERE name = @name AND owner = @owner', {
		['@name']  = name,
		['@owner'] = owner
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)

		if xPlayer then
			TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, name, false)
			--TriggerClientEvent('esx:showNotification', xPlayer.source, ('Sprzedałeś mieszkanie'))
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Kamu telah menjual apartemen', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		end
	end)
end

function RemoveOwnedProperty(name, owner)
	MySQL.Async.execute('UPDATE properties SET free = 0 WHERE name = @name', {
		['@name'] = name,
		['@free']   = 0
	})
	MySQL.Async.fetchAll("SELECT * FROM owned_properties WHERE name = @name AND owner = @owner",{["@name"]=name,["@owner"]=owner},function(data)
		if data[1]~=nil and data[1]["shared"]~=nil then
			local xTarget = ESX.GetPlayerFromIdentifier(data[1]["shared"])
			if xTarget then TriggerClientEvent("esx_property:removeKeys",xTarget.source,name,owner) end
		end
	end)
	MySQL.Async.execute('DELETE FROM owned_properties WHERE name = @name AND owner = @owner', {
		['@name']  = name,
		['@owner'] = owner
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)

		if xPlayer then
			local money = 0
			local result = MySQL.Sync.fetchAll('SELECT * FROM properties WHERE name = @name',
			{
				['@name'] = name
			})
			if result[1] ~= nil and result[1].price > 0 then
				money = tonumber(result[1].price / 2)
				Citizen.Wait(10)
				xPlayer.addMoney(money)
				--TriggerClientEvent('esx:showNotification', xPlayer.source, ('Sprzedałeś mieszkanie za ~g~' .. money .. '$'))
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Kamu menjual properti seharga Rp ' ..money, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('made_property'))
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Kamu telah membuat sebuah properti', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			end
			TriggerClientEvent('esx_property:setBlipOwned1', -1, name)
			TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, name, false)
		end
	end)
end

function LoadSql()
	MySQL.Async.fetchAll('SELECT * FROM properties', {}, function(properties)
		for i=1, #properties, 1 do

			local entering  = nil
			local exit      = nil
			local inside    = nil
			local outside   = nil
			local isSingle  = nil
			local isRoom    = nil
			local isGateway = nil
      		local roomMenu  = nil

			if properties[i].entering ~= nil then
				entering = json.decode(properties[i].entering)
			end

			if properties[i].exit ~= nil then
				exit = json.decode(properties[i].exit)
			end

			if properties[i].inside ~= nil then
				inside = json.decode(properties[i].inside)
			end

			if properties[i].outside ~= nil then
				outside = json.decode(properties[i].outside)
			end

			if properties[i].is_single == 0 then
				isSingle = false
			else
				isSingle = true
			end

			if properties[i].is_room == 0 then
				isRoom = false
			else
				isRoom = true
			end

			if properties[i].is_gateway == 0 then
				isGateway = false
			else
				isGateway = true
      end

			if properties[i].room_menu ~= nil then
				roomMenu = json.decode(properties[i].room_menu)
			end

			table.insert(Config.Properties, {
				name      = properties[i].name,
				label     = properties[i].label,
				entering  = entering,
				exit      = exit,
				inside    = inside,
				outside   = outside,
				ipls      = json.decode(properties[i].ipls),
				gateway   = properties[i].gateway,
				isSingle  = isSingle,
				isRoom    = isRoom,
				isGateway = isGateway,
				roomMenu  = roomMenu,
				blip = properties[i].free,
				price     = properties[i].price
			})
		end

		TriggerClientEvent('esx_property:sendProperties', -1, Config.Properties)
	end)
end



RegisterServerEvent('esx_property:requestSell')
AddEventHandler('esx_property:requestSell', function(playerId, propertyName, ammount)
	local _source = source
	TriggerClientEvent('esx_property:sprzedaj', playerId, _source, propertyName, ammount)
end)
RegisterServerEvent('esx_property:acceptSell')
AddEventHandler('esx_property:acceptSell', function(playerId, propertyName, ammount)
	-- TriggerClientEvent('esx:showNotification', -1, ('spejson to pies ' .. playerId))
	-- TriggerClientEvent('esx:showNotification', -1, ('spejson to pies ' .. ammount))
	-- TriggerClientEvent('esx:showNotification', -1, ('spejson to pies ' .. propertyName))
	-- print(playerId)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayer2 = ESX.GetPlayerFromId(playerId)
	local property = GetProperty(propertyName)
	if xPlayer.getMoney() >= ammount then
		xPlayer.removeMoney(ammount)
		-- TriggerClientEvent('esx:showNotification', -1, ('spejson to pies ' .. ammount))
		RemoveOwnedProperty1(propertyName, xPlayer2.identifier)
		Citizen.Wait(1000)
		-- TriggerClientEvent('esx:showNotification', -1, ('spejson to pies ' .. playerId))
		SetPropertyOwned(propertyName, property.price, false, xPlayer.identifier)
		-- setPropertyLocked(propertyName, _source)
	else
		--TriggerClientEvent('esx:showNotification', _source, ('Nie masz pieniedzy aby zakupic to mieszkanie'))
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Need atleast one police to farm', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		--TriggerClientEvent('esx:showNotification', playerId, ('Kupiec ostatecznie nie zakupil domu'))
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu tidak punya cukup uang', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end
	-- print(xPlayer.getMoney())
	-- TriggerClientEvent('esx:showNotification', -1, ('spejson to pies ' .. xPlayer2.identifier))

end)

ESX.RegisterServerCallback('esx_property:getOwnedProperties4', function(source, cb, propertyName)
	local xPlayer = ESX.GetPlayerFromId(source)
	-- print(propertyName)

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE name = @name', {
	['@name'] = propertyName
	}, function(ownedProperties)
		-- local properties = {}
		-- for i=1, #ownedProperties, 1 do
		-- 	table.insert(properties, ownedProperties[i].name)
		-- end
		if ownedProperties[1].shared == xPlayer.identifier then
			cb(true)
			-- print('1')
		else
			cb(false)
			-- print('2')
		end
		-- cb(properties)
	end)
end)



ESX.RegisterServerCallback('esx_property:getOwnedProperties2', function(source, cb, propertyName)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE name = @name', {
	['@name'] = propertyName
	}, function(ownedProperties)
		if ownedProperties[1] ~= nil then
			if ownedProperties[1].shared == xPlayer.identifier then
				cb(true)
				return
			else
				cb(false)
				return
			end
		else
			cb(false)
		end
		-- cb(properties)
	end)
end)


ESX.RegisterServerCallback('esx_property:getOwnedProperties6', function(source, cb, propertyName)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM properties WHERE name = @name', {
	['@name'] = propertyName
	}, function(ownedProperties)
		if ownedProperties[1].free == 1 then
			cb(true)
		else
			cb(false)
		end
	end)
end)


ESX.RegisterServerCallback('esx_property:getOwnedProperties3', function(source, cb, propertyName)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE name = @name', {
	['@name'] = propertyName
	}, function(ownedProperties)
		cb(ownedProperties[1].owner)
	end)
end)




ESX.RegisterServerCallback('esx_property:getProperties', function(source, cb)
	cb(Config.Properties)
end)

AddEventHandler('esx_ownedproperty:getOwnedProperties', function(cb)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties', {}, function(result)
		local properties = {}

		for i=1, #result, 1 do
			table.insert(properties, {
				id     = result[i].id,
				name   = result[i].name,
				label  = GetProperty(result[i].name).label,
				price  = result[i].price,
				rented = (result[i].rented == 1 and true or false),
				owner  = result[i].owner
			})
		end

		cb(properties)
	end)
end)

AddEventHandler('esx_property:setPropertyOwned', function(name, price, rented, owner)
	SetPropertyOwned(name, price, rented, owner)
end)

AddEventHandler('esx_property:removeOwnedProperty', function(name, owner)
	RemoveOwnedProperty(name, owner)
end)

RegisterServerEvent('esx_property:rentProperty')
AddEventHandler('esx_property:rentProperty', function(propertyName)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local property = GetProperty(propertyName)
	local rent     = ESX.Math.Round(property.price / 200)

	SetPropertyOwned(propertyName, rent, true, xPlayer.identifier)
end)

RegisterServerEvent('esx_property:buyProperty')
AddEventHandler('esx_property:buyProperty', function(propertyName)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local property = GetProperty(propertyName)

	if property.price <= xPlayer.getMoney() then
		xPlayer.removeMoney(property.price)
		SetPropertyOwned(propertyName, property.price, false, xPlayer.identifier)
	else
		--TriggerClientEvent('esx:showNotification', source, _U('not_enough'))
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu tidak punya cukup uang', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end
end)

RegisterServerEvent('esx_property:removeOwnedProperty')
AddEventHandler('esx_property:removeOwnedProperty', function(propertyName)
	local xPlayer = ESX.GetPlayerFromId(source)
	RemoveOwnedProperty(propertyName, xPlayer.identifier)
end)

AddEventHandler('esx_property:removeOwnedPropertyIdentifier', function(propertyName, identifier)
	RemoveOwnedProperty(propertyName, identifier)
end)

RegisterServerEvent('esx_property:saveLastProperty')
AddEventHandler('esx_property:saveLastProperty', function(property)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_property = @last_property WHERE identifier = @identifier', {
		['@last_property'] = property,
		['@identifier']    = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_property:deleteLastProperty')
AddEventHandler('esx_property:deleteLastProperty', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_property = NULL WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
end)

function DiscordHook(hook,message,color)
    local hooke = 'https://discordapp.com/api/webhooks/626447166398922752/FU0j-GpXP36OjrpFy1VZIBk9iHihNhnWDK2vfAMMeNhMm_okQnA9GEr70xI5lqKqwrpN'
    local embeds = {
                {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
				["text"] = 'GoldenGateRP'
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(hooke, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function DiscordHookwkladanie(hook,message,color)
    local hooke = 'https://discordapp.com/api/webhooks/626447032432721930/d88RcCq1LyjzBPZHN84FQQ3K9ATo0Obuy6MKyjsjS5fF2ykag-4luMCpOMlTZfuIzKe1'
    local embeds = {
                {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
				["text"] = 'GoldenGateRP'
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(hooke, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end


RegisterServerEvent('esx_property:getItem')
AddEventHandler('esx_property:getItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then

		local sourceItem = xPlayer.getInventoryItem(item)

		TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayerOwner.identifier, function(inventory)
			local inventoryItem = inventory.getItem(item)

			-- is there enough in the property?
			if count > 0 and inventoryItem.count >= count then
			
				-- can the player carry the said amount of x item?
				if  (sourceItem.count + count) > 9999999999 then
					--TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Inventory kamu penuh!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
				else
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					--TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'Kamu telah mengambil ' ..item.label.. ' sebanyak ' ..count, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
					local xPlayer = ESX.GetPlayerFromId(source)

					local steamid = xPlayer.identifier
					local name = GetPlayerName(source)
				
					wiadomosc = name.." WYJĄŁ Z SZAFKI \n[PRZEDMIOT: "..item.." | ILOSC: x"..count.."] \n[ID: "..source.." | Nazwa: "..name.." | SteamID: "..steamid.." ]" 
					DiscordHook('GoldenGateRP', wiadomosc, 11750815)
				end
			else
				--TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_property'))
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Item yang tersimpan di apartemen ~r~tidak cukup~s~!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			end
		end)

	elseif type == 'item_account' then

		TriggerEvent('esx_addonaccount:getAccount', 'property_' .. item, xPlayerOwner.identifier, function(account)
			local roomAccountMoney = account.money

			if roomAccountMoney >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
			else
				--TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Jumlah invalid', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			end
		end)

	elseif type == 'item_weapon' then

		TriggerEvent('esx_datastore:getDataStore', 'property', xPlayerOwner.identifier, function(store)
			local storeWeapons = store.get('weapons') or {}
			local weaponName   = nil
			local ammo         = nil

			for i=1, #storeWeapons, 1 do
				if storeWeapons[i].name == item then
					weaponName = storeWeapons[i].name
					ammo       = storeWeapons[i].ammo

					table.remove(storeWeapons, i)
					break
				end
			end

			store.set('weapons', storeWeapons)
			xPlayer.addWeapon(weaponName, ammo)
			local xPlayer = ESX.GetPlayerFromId(source)

					local steamid = xPlayer.identifier
					local name = GetPlayerName(source)
				
					wiadomosc = name.." WYJĄŁ Z SZAFKI \n[BRON: "..item.." | AMMO: x"..count.."] \n[ID: "..source.." | Nazwa: "..name.." | SteamID: "..steamid.." ]" 
					DiscordHook('GoldenGateRP', wiadomosc, 11750815)
		end)

	end
end)

RegisterServerEvent('esx_property:putItem')
AddEventHandler('esx_property:putItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then

		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayerOwner.identifier, function(inventory)
				xPlayer.removeInventoryItem(item, count)
				inventory.addItem(item, count)
				--TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', count, inventory.getItem(item).label))
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'Kamu telah menaruh ' ..inventory.getItem(item).label.. ' sebanyak ' ..count, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
				local xPlayer = ESX.GetPlayerFromId(source)

					local steamid = xPlayer.identifier
					local name = GetPlayerName(source)
				
					wiadomosc = name.." WSADZIŁ DO SZAFKI \n[PRZEDMIOT: "..item.." | ILOSC: x"..count.."] \n[ID: "..source.." | Nazwa: "..name.." | SteamID: "..steamid.." ]" 
					DiscordHookwkladanie('GoldenGateRP', wiadomosc, 11750815)
			end)
		else
			--TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Jumlah invalid', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		end

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)

			TriggerEvent('esx_addonaccount:getAccount', 'property_' .. item, xPlayerOwner.identifier, function(account)
				account.addMoney(count)
			end)
		else
			--TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Jumlah invalid', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		end

	elseif type == 'item_weapon' then

		TriggerEvent('esx_datastore:getDataStore', 'property', xPlayerOwner.identifier, function(store)
			local storeWeapons = store.get('weapons') or {}

			table.insert(storeWeapons, {
				name = item,
				ammo = count
			})

			store.set('weapons', storeWeapons)
			xPlayer.removeWeapon(item)
			local xPlayer = ESX.GetPlayerFromId(source)

			local steamid = xPlayer.identifier
			local name = GetPlayerName(source)
		
			wiadomosc = name.." WSADZIŁ DO SZAFKI \n[BRON: "..item.." | AMMO: x"..count.."] \n[ID: "..source.." | Nazwa: "..name.." | SteamID: "..steamid.." ]" 
			DiscordHookwkladanie('GoldenGateRP', wiadomosc, 11750815)
		end)

	end
end)

ESX.RegisterServerCallback('esx_property:getOwnedProperties', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(ownedProperties)
		local properties = {}

		for i=1, #ownedProperties, 1 do
			table.insert(properties, ownedProperties[i].name)
		end

		cb(properties)
	end)
end)

ESX.RegisterServerCallback('esx_property:getLastProperty', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT last_property FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		cb(users[1].last_property)
	end)
end)

ESX.RegisterServerCallback('esx_property:getPropertyInventory', function(source, cb, owner, propertyName)
	local _source = source
	local xPlayer2 = ESX.GetPlayerFromId(_source)
	local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE name = @name', {
		['@name'] = propertyName
		}, function(ownedProperties)
			--if ownedProperties[1].search ~= nil then
				--cb(false)
			--else
				local blackMoney = 0
				local items      = {}
				local weapons    = {}
				-- cb(false)
				-- return
				TriggerEvent('esx_addonaccount:getAccount', 'property_black_money', xPlayer.identifier, function(account)
					blackMoney = account.money
				end)
			
				TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayer.identifier, function(inventory)
					items = inventory.items
				end)
			
				TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
					weapons = store.get('weapons') or {}
				end)
			
				cb({
					blackMoney = blackMoney,
					items      = items,
					weapons    = weapons
				})
				-- print('opcja 1')
			--end
		end)
end)

ESX.RegisterServerCallback('esx_property:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		items      = items,
		weapons    = xPlayer.getLoadout()
	})
end)

ESX.RegisterServerCallback('esx_property:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('esx_property:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('esx_property:removeOutfit')
AddEventHandler('esx_property:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

function PayRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE rented = 1', {}, function (result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].owner)

			-- message player if connected
			if xPlayer then
				xPlayer.removeAccountMoney('bank', result[i].price)
				--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_rent', ESX.Math.GroupDigits(result[i].price)))
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Kamu membayar untuk sewa seharga ' ..ESX.Math.GroupDigits(result[i].price), length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else -- pay rent either way
				MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier', {
					['@bank']       = result[i].price,
					['@identifier'] = result[i].owner
				})
			end

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_realestateagent', function(account)
				account.addMoney(result[i].price)
			end)
		end
	end)
end

TriggerEvent('cron:runAt', 22, 0, PayRent)
