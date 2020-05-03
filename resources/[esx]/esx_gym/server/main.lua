ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_gym:hireBmx')
AddEventHandler('esx_gym:hireBmx', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 5000) then
		xPlayer.removeMoney(5000)
			
		--notification("Kamu telah menyewa sepeda ~g~BMX")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu telah menyewa sepeda BMX', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	else
		--notification("Kamu mencuri sepeda karena kamu tidak punya cukup ~r~uang, berhati-hatilah!")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu mencuri sepeda karena kamu tidak punya cukup uang, berhati-hatilah!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end	
end)

RegisterServerEvent('esx_gym:hireCruiser')
AddEventHandler('esx_gym:hireCruiser', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 2500) then
		xPlayer.removeMoney(2500)
			
		--notification("Kamu telah menyewa sepeda ~g~Cruiser")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu telah menyewa sepeda Cruiser', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	else
		--notification("Kamu mencuri sepeda karena kamu tidak punya cukup ~r~uang, berhati-hatilah!")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu mencuri sepeda karena kamu tidak punya cukup uang, berhati-hatilah!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end	
end)

RegisterServerEvent('esx_gym:hireFixter')
AddEventHandler('esx_gym:hireFixter', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 7500) then
		xPlayer.removeMoney(7500)
			
		--notification("Kamu telah menyewa sepeda ~g~Fixter")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu telah menyewa sepeda Fixter', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	else
		--notification("Kamu mencuri sepeda karena kamu tidak punya cukup ~r~uang, berhati-hatilah!")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu mencuri sepeda karena kamu tidak punya cukup uang, berhati-hatilah!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end	
end)

RegisterServerEvent('esx_gym:hireScorcher')
AddEventHandler('esx_gym:hireScorcher', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 10000) then
		xPlayer.removeMoney(10000)
			
		--notification("Kamu telah menyewa sepeda ~g~Scorcher")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu telah menyewa sepeda Scorcher', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	else
		--notification("Kamu mencuri sepeda karena kamu tidak punya cukup ~r~uang, berhati-hatilah!")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu mencuri sepeda karena kamu tidak punya cukup uang, berhati-hatilah!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end	
end)

RegisterServerEvent('esx_gym:checkChip')
AddEventHandler('esx_gym:checkChip', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local oneQuantity = xPlayer.getInventoryItem('gym_membership').count
	
	if oneQuantity > 0 then
		TriggerClientEvent('esx_gym:trueMembership', source) -- true
	else
		TriggerClientEvent('esx_gym:falseMembership', source) -- false
	end
end)

-- ESX.RegisterUsableItem('gym_bandage', function(source)
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(source)

-- 	xPlayer.removeInventoryItem('gym_bandage', 1)	
	
-- 	TriggerClientEvent('esx_gym:useBandage', source)
-- end)

-- RegisterServerEvent('esx_gym:buyBandage')
-- AddEventHandler('esx_gym:buyBandage', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 50) then
-- 		xPlayer.removeMoney(50)
		
-- 		xPlayer.addInventoryItem('gym_bandage', 1)		
-- 		--notification("Kamu telah membeli ~g~perban")
-- 		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu telah membeli perban', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
-- 	else
-- 		--notification("Kamu tidak punya cukup ~r~uang")
-- 		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu tidak punya cukup uang', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
-- 	end	
-- end)

RegisterServerEvent('esx_gym:buyMembership')
AddEventHandler('esx_gym:buyMembership', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 80000) then
		xPlayer.removeMoney(80000)
		
		xPlayer.addInventoryItem('gym_membership', 1)		
		--notification("Kamu berhasil membeli ~g~membership")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu berhasil membeli gym membership', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		
		TriggerClientEvent('esx_gym:trueMembership', source) -- true
	else
		--notification("You do not have enough ~r~money")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu tidak punya cukup uang', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end	
end)


-- RegisterServerEvent('esx_gym:buyProteinshake')
-- AddEventHandler('esx_gym:buyProteinshake', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 6) then
-- 		xPlayer.removeMoney(6)
		
-- 		xPlayer.addInventoryItem('protein_shake', 1)
		
-- 		notification("You purchased a ~g~protein shake")
-- 	else
-- 		notification("You do not have enough ~r~money")
-- 	end	
-- end)

-- ESX.RegisterUsableItem('protein_shake', function(source)

-- 	local xPlayer = ESX.GetPlayerFromId(source)

-- 	xPlayer.removeInventoryItem('protein_shake', 1)

-- 	TriggerClientEvent('esx_status:add', source, 'thirst', 350000)
-- 	TriggerClientEvent('esx_basicneeds:onDrink', source)
-- 	TriggerClientEvent('esx:showNotification', source, 'You drank a ~g~protein shake')

-- end)

RegisterServerEvent('esx_gym:buyWater')
AddEventHandler('esx_gym:buyWater', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 10000) then
		xPlayer.removeMoney(10000)
		
		xPlayer.addInventoryItem('water', 1)
		
		--notification("You purchased a ~g~water")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu telah membeli air minum', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	else
		--notification("You do not have enough ~r~money")
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu tidak punya cukup uang', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	end		
end)

-- RegisterServerEvent('esx_gym:buySportlunch')
-- AddEventHandler('esx_gym:buySportlunch', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 2) then
-- 		xPlayer.removeMoney(2)
		
-- 		xPlayer.addInventoryItem('sportlunch', 1)
		
-- 		notification("You purchased a ~g~sportlunch")
-- 	else
-- 		notification("You do not have enough ~r~money")
-- 	end		
-- end)

-- ESX.RegisterUsableItem('sportlunch', function(source)

-- 	local xPlayer = ESX.GetPlayerFromId(source)

-- 	xPlayer.removeInventoryItem('sportlunch', 1)

-- 	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
-- 	TriggerClientEvent('esx_basicneeds:onEat', source)
-- 	TriggerClientEvent('esx:showNotification', source, 'You ate a ~g~sportlunch')

-- end)

-- RegisterServerEvent('esx_gym:buyPowerade')
-- AddEventHandler('esx_gym:buyPowerade', function()
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
	
-- 	if(xPlayer.getMoney() >= 4) then
-- 		xPlayer.removeMoney(4)
		
-- 		xPlayer.addInventoryItem('powerade', 1)
		
-- 		notification("You purchased a ~g~powerade")
-- 	else
-- 		notification("You do not have enough ~r~money")
-- 	end		
-- end)

-- ESX.RegisterUsableItem('powerade', function(source)

-- 	local xPlayer = ESX.GetPlayerFromId(source)

-- 	xPlayer.removeInventoryItem('powerade', 1)

-- 	TriggerClientEvent('esx_status:add', source, 'thirst', 700000)
-- 	TriggerClientEvent('esx_basicneeds:onDrink', source)
-- 	TriggerClientEvent('esx:showNotification', source, 'You drank a ~g~powerade')

-- end)

-- FUNCTIONS IN THE FUTURE (COMING SOON...)

--RegisterServerEvent('esx_gym:trainArms')
--AddEventHandler('esx_gym:trainArms', function()
	
--end)

--RegisterServerEvent('esx_gym:trainChins')
--AddEventHandler('esx_gym:trainArms', function()
	
--end)

--RegisterServerEvent('esx_gym:trainPushups')
--AddEventHandler('esx_gym:trainPushups', function()
	
--end)

--RegisterServerEvent('esx_gym:trainYoga')
--AddEventHandler('esx_gym:trainYoga', function()
	
--end)

--RegisterServerEvent('esx_gym:trainSitups')
--AddEventHandler('esx_gym:trainSitups', function()
	
--end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end