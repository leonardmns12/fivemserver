local rob = false
local robbers = {}
PlayersCrafting    = {}
local CopsConnected  = 0
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('esx_vangelico_robbery:toofar')
AddEventHandler('esx_vangelico_robbery:toofar', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayers[i], { type = 'error', text = 'Robbery cancelled at ' ..Stores[robb].nameofstore.. '!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) --
			TriggerClientEvent('esx_vangelico_robbery:killblip', xPlayers[i]) --
		end
	end
	if(robbers[source])then
		TriggerClientEvent('esx_vangelico_robbery:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Robbery cancelled at ' ..Stores[robb].nameofstore, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) --
	end
end)

RegisterServerEvent('esx_vangelico_robbery:endrob')
AddEventHandler('esx_vangelico_robbery:endrob', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayers[i], { type = 'inform', text = 'Perhiasan sudah dirampok!' , length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			TriggerClientEvent('esx_vangelico_robbery:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('esx_vangelico_robbery:robberycomplete', source)
		robbers[source] = nil
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Robbery has finished at ' ..Stores[robb].nameofstore ..'!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end
end)

RegisterServerEvent('esx_vangelico_robbery:rob')
AddEventHandler('esx_vangelico_robbery:rob', function(robb)

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	if Stores[robb] then

		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < 800 and store.lastrobbed ~= 0 then

            TriggerClientEvent('esx_vangelico_robbery:togliblip', source)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Robbery cooldown ' ..(1800 - (os.time() - store.lastrobbed)).. 'detik!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			return
		end


		local cops = 0
		for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end


		if rob == false then

			if(cops >= Config.RequiredCopsRob)then

				rob = true
				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
							TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Robbery in proggress at' .. store.nameofstore, length = 5500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
							TriggerClientEvent('esx_vangelico_robbery:setblip', xPlayers[i], Stores[robb].position)
					end
				end

				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You started jewellery at ' .. store.nameofstore , length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) --
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'The alarm has been triggered!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) --
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Run when you ready', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })  --
			    TriggerClientEvent('esx_vangelico_robbery:currentlyrobbing', source, robb)
                CancelEvent()
				Stores[robb].lastrobbed = os.time()
			else
				TriggerClientEvent('esx_vangelico_robbery:togliblip', source)
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Butuh 2 polisi untuk memulai robbery!', length = 4500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) --
			end
		else
			TriggerClientEvent('esx_vangelico_robbery:togliblip', source)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Robbery already in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })--
		end
	end
end)

RegisterServerEvent('esx_vangelico_robbery:gioielli1')
AddEventHandler('esx_vangelico_robbery:gioielli1', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addInventoryItem('jewels', math.random(5, 20))
end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

local function Craft(source)

	SetTimeout(4000, function()

		if PlayersCrafting[source] == true and CopsConnected >= Config.RequiredCopsSell then

			local xPlayer  = ESX.GetPlayerFromId(source)
			local JewelsQuantity = xPlayer.getInventoryItem('jewels').count

			if JewelsQuantity < 20 then 
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu tidak mempunyai jewel!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) --
			else   
                xPlayer.removeInventoryItem('jewels', 20)
                Citizen.Wait(4000)
				xPlayer.addMoney(4000)
				
				Craft(source)
			end
		else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Harus memiliki 2 polisi untuk menjual!', length = 4500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) --
		end
	end)
end

RegisterServerEvent('lester:vendita')
AddEventHandler('lester:vendita', function()
	local _source = source
	PlayersCrafting[_source] = true
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Sale in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	Craft(_source)
end)

RegisterServerEvent('lester:nvendita')
AddEventHandler('lester:nvendita', function()
	local _source = source
	PlayersCrafting[_source] = false
end)

