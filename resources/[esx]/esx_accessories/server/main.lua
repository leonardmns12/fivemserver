ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_accessories:pay')
AddEventHandler('esx_accessories:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(Config.Price)
	--TriggerClientEvent('esx:showNotification', _source, _U('you_paid', Config.Price))
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu membayar Rp ' ..Config.Price, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

end)

RegisterServerEvent('esx_accessories:save')
AddEventHandler('esx_accessories:save', function(skin, accessory)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerEvent('esx_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.identifier, function(store)
		
		store.set('has' .. accessory, true)

		local itemSkin = {}
		local item1 = string.lower(accessory) .. '_1'
		local item2 = string.lower(accessory) .. '_2'
		itemSkin[item1] = skin[item1]
		itemSkin[item2] = skin[item2]
		store.set('skin', itemSkin)

	end)

end)

ESX.RegisterServerCallback('esx_accessories:get', function(source, cb, accessory)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'user_' .. string.lower(accessory), xPlayer.identifier, function(store)
		
		local hasAccessory = (store.get('has' .. accessory) and store.get('has' .. accessory) or false)
		local skin = (store.get('skin') and store.get('skin') or {})

		cb(hasAccessory, skin)

	end)

end)

ESX.RegisterServerCallback('esx_accessories:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		cb(true)
	else
		cb(false)
	end

end)










function item(source)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
	local result = MySQL.Sync.fetchAll("SELECT * FROM kaiser_ciuchy WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local itemy = result[1]

		return {
			bag = itemy['bag'],
			bag2 = itemy['bag2'],
			tshirt = itemy['tshirt'],
			tshirt2 = itemy['tshirt2'],
			torso = itemy['torso'],
			torso2 = itemy['torso2'],
			legs = itemy['legs'],
			legs2 = itemy['legs2'],
			shoes = itemy['shoes'],
                       shoes2 = itemy['shoes2'],
                       arms = itemy['arms'],
			chain = itemy['chain'],
                       chain2 = itemy['chain2'],
			mask = itemy['mask'],
			mask2 = itemy['mask2'],
			decals = itemy['decals'],
			decals2 = itemy['decals2'],
			hat = itemy['hat'],
			hat2 = itemy['hat2'],
			glasses = itemy['glasses'],
			glasses2 = itemy['glasses2']

                        
		}
	else
		return nil
	end
end

RegisterServerEvent('esx_ciuchy:szalik')
AddEventHandler('esx_ciuchy:szalik', function()
	local _source = source
       local name = item(source)
local id1 = name.chain
local id2 = name.chain2
  TriggerClientEvent('esx_ciuchy:ubierz', _source, id1 ,id2, 7)
end)

RegisterServerEvent('esx_ciuchy:maska')
AddEventHandler('esx_ciuchy:maska', function()
	local _source = source
    local name = item(source)
local id1 = name.mask
local id2 = name.mask2
  TriggerClientEvent('esx_ciuchy:ubierz', _source, id1 ,id2, 1)
end)

RegisterServerEvent('esx_ciuchy:torba')
AddEventHandler('esx_ciuchy:torba', function()
	local _source = source
       local name = item(source)
local id1 = name.bag
local id2 = name.bag2
  TriggerClientEvent('esx_ciuchy:ubierz', _source, id1 ,id2, 5)
end)
RegisterServerEvent('esx_ciuchy:kurtka')
AddEventHandler('esx_ciuchy:kurtka', function()
	local _source = source
       local name = item(source)
local id1 = name.tshirt
local id2 = name.tshirt2
local id3 = name.torso
local id4 = name.torso2
local id5 = name.arms
local id6 = name.decals
local id7 = name.decals2

  TriggerClientEvent('esx_ciuchy:ubierz', _source, id1 ,id2, 8)
  TriggerClientEvent('esx_ciuchy:ubierz', _source, id3 ,id4, 11)
             TriggerClientEvent('esx_ciuchy:ubierz', _source, id5 ,0, 3)
  TriggerClientEvent('esx_ciuchy:ubierz', _source, id6 ,id7, 10)

end)
RegisterServerEvent('esx_ciuchy:spodnie')
AddEventHandler('esx_ciuchy:spodnie', function()
	local _source = source
       local name = item(source)
local id1 = name.legs
local id2 = name.legs2
  TriggerClientEvent('esx_ciuchy:ubierz', _source, id1 ,id2, 4)
end)
RegisterServerEvent('esx_ciuchy:buty')
AddEventHandler('esx_ciuchy:buty', function()
	local _source = source
       local name = item(source)
local id1 = name.shoes
local id2 = name.shoes2
  TriggerClientEvent('esx_ciuchy:ubierz', _source, id1 ,id2, 6)
end)
RegisterServerEvent('esx_ciuchy:czapka')
AddEventHandler('esx_ciuchy:czapka', function()
	local _source = source
       local name = item(source)
local id1 = name.hat
local id2 = name.hat2
  TriggerClientEvent('esx_ciuchy:prop', _source, id1 ,id2, 0)
end)
RegisterServerEvent('esx_ciuchy:okulary')
AddEventHandler('esx_ciuchy:okulary', function()
	local _source = source
       local name = item(source)
local id1 = name.glasses
local id2 = name.glasses2
  TriggerClientEvent('esx_ciuchy:prop', _source, id1 ,id2, 1)
end)


RegisterServerEvent('esx_ciuchy:dodaj')
AddEventHandler('esx_ciuchy:dodaj', function(bag, bag2,tshirt, tshirt2, torso, torso2, legs, legs2, shoes, shoes2, arms, chain, chain2,mask,mask2,decals,decals2,hat,hat2,glasses,glasses2)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    

	MySQL.Async.fetchAll('SELECT * FROM kaiser_ciuchy WHERE identifier=@id', {['@id'] = identifier}, function(result)
		if result[1] ~= nil then
--MySQL.Async.execute('DELETE FROM kaiser_ciuchy WHERE identifier = @id', {['@id'] = identifier})
MySQL.Async.execute("UPDATE kaiser_ciuchy SET bag=@bag, bag2=@bag2, tshirt=@tshirt , tshirt2=@tshirt2, torso=@torso, torso2=@torso2, legs=@legs, legs2=@legs2, shoes=@shoes, shoes2=@shoes2, arms=@arms, chain=@chain, chain2=@chain2,mask=@mask,mask2=@mask2,decals=@decals,decals2=@decals2,hat=@hat,hat2=@hat2,glasses=@glasses,glasses2=@glasses2 WHERE identifier=@identifier", {['@identifier'] = identifier, ['@bag'] = bag, ['@bag2'] = bag2, ['@tshirt'] = tshirt, ['@tshirt2'] = tshirt2, ['@torso'] = torso, ['@torso2'] = torso2, ['@legs'] = legs, ['@legs2'] = legs2, ['@shoes'] = shoes, ['@shoes2'] = shoes2,['@arms'] = arms, ['@chain'] = chain, ['@chain2'] = chain2, ['@mask'] = mask, ['@mask2'] = mask2, ['@decals'] = decals, ['@decals2'] = decals2, ['@hat'] = hat, ['@hat2'] = hat2, ['@glasses'] = glasses, ['@glasses2'] = glasses2})
 print(identifier)
 else
MySQL.Async.execute("INSERT INTO kaiser_ciuchy (identifier, bag, bag2, tshirt , tshirt2, torso, torso2, legs, legs2, shoes, shoes2, arms, chain, chain2,mask,mask2,decals,decals2,hat,hat2,glasses,glasses2) VALUES (@identifier,@bag,@bag2,@tshirt,@tshirt2,@torso,@torso2,@legs,@legs2,@shoes,@shoes2,@arms,@chain,@chain2,@mask,@mask2,@decals,@decals2,@hat,@hat2,@glasses,@glasses2)", {['@identifier'] = identifier, ['@bag'] = bag, ['@bag2'] = bag2, ['@tshirt'] = tshirt, ['@tshirt2'] = tshirt2, ['@torso'] = torso, ['@torso2'] = torso2, ['@legs'] = legs, ['@legs2'] = legs2, ['@shoes'] = shoes, ['@shoes2'] = shoes2,['@arms'] = arms, ['@chain'] = chain, ['@chain2'] = chain2, ['@mask'] = mask, ['@mask2'] = mask2, ['@decals'] = decals, ['@decals2'] = decals2, ['@hat'] = hat, ['@hat2'] = hat2, ['@glasses'] = glasses, ['@glasses2'] = glasses2})


MySQL.Async.fetchAll('SELECT * FROM kaiser_ciuchy WHERE identifier=@id', {['@id'] = identifier}, function(result)

if result[1] == nil then

MySQL.Async.execute("INSERT INTO kaiser_ciuchy (identifier, bag, bag2, tshirt , tshirt2, torso, torso2, legs, legs2, shoes, shoes2, arms, chain, chain2,mask,mask2,decals,decals2,hat,hat2,glasses,glasses2) VALUES (@identifier,@bag,@bag2,@tshirt,@tshirt2,@torso,@torso2,@legs,@legs2,@shoes,@shoes2,@arms,@chain,@chain2,@mask,@mask2,@decals,@decals2,@hat,@hat2,@glasses,@glasses2)", {['@identifier'] = identifier, ['@bag'] = bag, ['@bag2'] = bag2, ['@tshirt'] = tshirt, ['@tshirt2'] = tshirt2, ['@torso'] = torso, ['@torso2'] = torso2, ['@legs'] = legs, ['@legs2'] = legs2, ['@shoes'] = shoes, ['@shoes2'] = shoes2,['@arms'] = arms, ['@chain'] = chain, ['@chain2'] = chain2, ['@mask'] = mask, ['@mask2'] = mask2, ['@decals'] = decals, ['@decals2'] = decals2, ['@hat'] = hat, ['@hat2'] = hat2, ['@glasses'] = glasses, ['@glasses2'] = glasses2})
end

end)

		end
	end)
	

end)

