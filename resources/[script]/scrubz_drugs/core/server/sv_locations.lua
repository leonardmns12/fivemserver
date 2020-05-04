---------------------------
-- Event Handlers --
---------------------------
RegisterServerEvent('scrubz_drugs_sv:getDoors')
AddEventHandler('scrubz_drugs_sv:getDoors', function()
	local drugLocations = {  --[[ 1 = Weed Enter, 2 = Weed Exit, 3 = Coke Enter, 4 = Coke Exit, 5 = Meth Enter, 6 = Meth Exit, 7 = Coke Gathering Door ]]
		[1] = {pos = vector3(-99.91, -1783.16, 28.29), teleport = vector3(1066.41, -3183.51, -39.98), id = 'weedEnter', enter = true, text = 'Press ~r~[E]~w~ to enter'},
		[2] = {pos = vector3(1066.41, -3183.51, -39.98), teleport = vector3(-99.91, -1783.16, 28.29), id = 'weedExit', enter = false,  text = 'Press ~r~[E]~w~ to exit'},
		[3] = {pos = vector3(-85.98, -1794.88, 27.66), teleport = vector3(1088.65, -3187.46, -39.92), id = 'cokeEnter', enter = true, text = 'Press ~r~[E]~w~ to enter'},
		[4] = {pos = vector3(1088.65, -3187.46, -39.92), teleport = vector3(-85.98, -1794.88, 27.66), id = 'cokeExit', enter = false,  text = 'Press ~r~[E]~w~ to exit'},
		[5] = {pos = vector3(-93.73, -1788.34, 28.09), teleport = vector3(996.81, -3200.67, -37.22), id = 'methEnter', enter = true, text = 'Press ~r~[E]~w~ to enter'},
		[6] = {pos = vector3(996.81, -3200.67, -37.22), teleport = vector3(-93.73, -1788.34, 28.09), id = 'methExit', enter = false,  text = 'Press ~r~[E]~w~ to exit'},
		[7] = {pos = vector3(-74.91, -1803.15, 27.88), teleport = nil, id = 'cokeTheft', enter = nil,  text = 'Press ~r~[E]~w~ steal some coke'},
	}
	local drugPackaging = {  --[[ 1 = Coke Packaging, 2 = Meth Packaging, 3 = Crack Packaging, 4 = Meth Cooking, 5 = Crack Cooking ]]
		[1] = {pos = vector3(1092.45, -3196.61, -39.98), id = 'pCoke', text = 'Press ~r~[E]~w~ to bag up some coke'},
		[2] = {pos = vector3(1013.34, -3194.89, -39.78), id = 'pMeth', text = 'Press ~r~[E]~w~ to bag up some meth'},
		[3] = {pos = vector3(1101.71, -3193.77, -39.81), id = 'pCrack', text = 'Press ~r~[E]~w~ to bag up some crack'},
		[4] = {pos = vector3(1005.74, -3200.37, -39.35), id = 'cMeth', text = 'Press ~r~[E]~w~ to cook some meth'},
		[5] = {pos = vector3(1100.81, -3198.83, -39.81), id = 'cCrack', text = 'Press ~r~[E]~w~ to cook some crack'},
	}
	local mRaidWarning = vector3(245.13, -1373.29, 29.12)
	local mRaidMarker = vector3(243.02, -1376.61, 39.53)
	local mPoliceInfo = {  --[[ 1 = Police Entry 1, 2 = Police Rappel Entry, 3 = Police Exit 1 ]]
		[1] = {pos = vector3(241.21, -1378.93, 33.74), teleport = vector3(275.84, -1361.57, 24.54), enter = true, text = 'Press ~r~[E]~w~ to enter the bottom floor'},
		[2] = {pos = vector3(251.36, -1390.34, 30.56), teleport = vector3(246.29, -1384.86, 39.53), enter = true,  text = 'Press ~r~[E]~w~ to rappel to the third floor'},
		[3] = {pos = vector3(275.84, -1361.57, 24.54), teleport = vector3(241.21, -1378.93, 33.74), enter = false,  text = 'Press ~r~[E]~w~ to exit the building'},
		--[4] = {pos = vector3(246.29, -1384.86, 39.53), teleport = vector3(251.36, -1390.34, 30.56), enter = false,  text = 'Press ~r~[E]~w~ to rappel down'}
	}
	local mCriminalInfo = {  --[[ 1 = Criminal Entry, 2 = Criminal Entry Exit, 3 = Window Exit, 4 = Police Exit 1 ]]
		[1] = {pos = vector3(232.41, -1361.07, 28.85), teleport = vector3(234.63, -1373.72, 21.98), enter = true,  text = 'Press ~r~[E]~w~ to lockpick the door'},
		[2] = {pos = vector3(234.63, -1373.72, 21.98), teleport = vector3(232.41, -1361.07, 28.85), enter = false,  text = 'Press ~r~[E]~w~ to exit the building'},
		[3] = {pos = vector3(234.44, -1374.89, 39.53), teleport = nil, enter = false,  text = 'Press ~r~[E]~w~ to risk exiting via the window'},
		[4] = {pos = vector3(275.84, -1361.57, 24.54), teleport = vector3(241.21, -1378.93, 33.74), enter = false,  text = 'Press ~r~[E]~w~ to exit the building'}
	}
	local mZones = {  -- Searching Zones
		{ pos = vector3(243.57, -1371.10, 39.53), isSearched = false},
		{ pos = vector3(248.88, -1375.42, 39.53), isSearched = false},
		{ pos = vector3(246.73, -1377.56, 39.53), isSearched = false},
		{ pos = vector3(241.37, -1373.27, 39.53), isSearched = false},
		{ pos = vector3(238.44, -1359.04, 39.53), isSearched = false},
		{ pos = vector3(234.88, -1363.31, 39.53), isSearched = false},
		{ pos = vector3(237.37, -1359.26, 39.53), isSearched = false},
		{ pos = vector3(244.16, -1383.09, 39.53), isSearched = false},
		{ pos = vector3(242.51, -1382.21, 39.53), isSearched = false},
		{ pos = vector3(248.92, -1386.32, 39.53), isSearched = false},
		{ pos = vector3(249.91, -1372.96, 39.53), isSearched = false},
		{ pos = vector3(245.03, -1369.34, 39.53), isSearched = false}
	}
	TriggerClientEvent('scrubz_drugs_cl:assignVectors', source, drugLocations, drugPackaging)
	TriggerClientEvent('scrubz_drugs_cl:setRaidLocations', source, mPoliceInfo, mCriminalInfo, mZones, mRaidWarning, mRaidMarker)
end)

RegisterServerEvent('scrubz_drugs_sv:packageCocaine')
AddEventHandler('scrubz_drugs_sv:packageCocaine', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local rawcoke = xPlayer.getInventoryItem('rawcoke').count
	local baggies = xPlayer.getInventoryItem('baggie').count
	if rawcoke >= 5 then
		if baggies >= 1 then
			xPlayer.removeInventoryItem('rawcoke', 5)
			xPlayer.removeInventoryItem('baggie', 1)
			TriggerClientEvent('scrubz_drugs_cl:packageCocaine', source, true)
			Citizen.Wait(6000)
			xPlayer.addInventoryItem('coke1g', 1)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Not enough baggies.', length = 4000 })
			TriggerClientEvent('scrubz_drugs_cl:packageCocaine', source, false)
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Not enough coke to bag up.', length = 4000 })
		TriggerClientEvent('scrubz_drugs_cl:packageCocaine', source, false)
	end
end)

RegisterServerEvent('scrubz_drugs_sv:produceMeth')
AddEventHandler('scrubz_drugs_sv:produceMeth', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local psudo = xPlayer.getInventoryItem('psuedoephedrine').count
	local batteryacid = xPlayer.getInventoryItem('batteryacid').count
	local lithium = xPlayer.getInventoryItem('lithium').count
	if psudo >= 5 then
		if batteryacid >= 1 then
			if lithium >= 2 then
				xPlayer.removeInventoryItem('psuedoephedrine', 5)
				xPlayer.removeInventoryItem('batteryacid', 1)
				xPlayer.removeInventoryItem('lithium', 2)
				TriggerClientEvent('scrubz_drugs_cl:produceMeth', source, true)
				Citizen.Wait(16000)
				xPlayer.addInventoryItem('rawmeth', 10)
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t know what you\'re doing.', length = 4000 })
				TriggerClientEvent('scrubz_drugs_cl:produceMeth', source, false)
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t know what you\'re doing.', length = 4000 })
			TriggerClientEvent('scrubz_drugs_cl:produceMeth', source, false)
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t know what you\'re doing.', length = 4000 })
		TriggerClientEvent('scrubz_drugs_cl:produceMeth', source, false)
	end
end)

RegisterServerEvent('scrubz_drugs_sv:packageMeth')
AddEventHandler('scrubz_drugs_sv:packageMeth', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local raw = xPlayer.getInventoryItem('rawmeth').count
	local baggies = xPlayer.getInventoryItem('baggie').count
	if raw >= 5 then
		if baggies >= 1 then
			xPlayer.removeInventoryItem('rawmeth', 5)
			xPlayer.removeInventoryItem('baggie', 1)
			TriggerClientEvent('scrubz_drugs_cl:packageMeth', source, true)
			Citizen.Wait(6000)
			xPlayer.addInventoryItem('meth1g', 1)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Not enough baggies.', length = 4000 })
			TriggerClientEvent('scrubz_drugs_cl:packageMeth', source, false)
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Not enough meth to bag up.', length = 4000 })
		TriggerClientEvent('scrubz_drugs_cl:packageMeth', source, false)
	end
end)

RegisterServerEvent('scrubz_drugs_sv:produceCrack')
AddEventHandler('scrubz_drugs_sv:produceCrack', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local pot = xPlayer.getInventoryItem('cookingpot').count
	local pyrex = xPlayer.getInventoryItem('pyrex').count
	local bsoda = xPlayer.getInventoryItem('bakingsoda').count
	local water = xPlayer.getInventoryItem('water').count
	local rawcoke = xPlayer.getInventoryItem('rawcoke').count
	if pot >= 1 then
		if pyrex >= 1 then
			if bsoda >= 5 then
				if water >= 2 then
					if rawcoke >= 20 then
						xPlayer.removeInventoryItem('rawcoke', 20)
						xPlayer.removeInventoryItem('bakingsoda', 5)
						xPlayer.removeInventoryItem('water', 2)
						TriggerClientEvent('scrubz_drugs_cl:produceCrack', source, true)
						Citizen.Wait(16000)
						local fuckyou = math.random(1, 8)
						if fuckyou <= 2 then
							xPlayer.removeInventoryItem('pyrex', 1)
							xPlayer.addInventoryItem('crackrock', 5)
							TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You\'re pyrex conainer broke. :(', length = 4000 })
							TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Raw Crack Produced!', length = 4000 })
						else
							xPlayer.addInventoryItem('crackrock', 5)
							TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Raw Crack Produced!', length = 4000 })
						end
					else
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t know what you\'re doing.', length = 4000 })
						TriggerClientEvent('scrubz_drugs_cl:produceCrack', source, false)
					end
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t know what you\'re doing.', length = 4000 })
					TriggerClientEvent('scrubz_drugs_cl:produceCrack', source, false)
				end
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t know what you\'re doing.', length = 4000 })
				TriggerClientEvent('scrubz_drugs_cl:produceCrack', source, false)
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t know what you\'re doing.', length = 4000 })
			TriggerClientEvent('scrubz_drugs_cl:produceCrack', source, false)
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t know what you\'re doing.', length = 4000 })
		TriggerClientEvent('scrubz_drugs_cl:produceCrack', source, false)
	end
end)

RegisterServerEvent('scrubz_drugs_sv:packageCrack')
AddEventHandler('scrubz_drugs_sv:packageCrack', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local raw = xPlayer.getInventoryItem('rawcrack').count
	local baggies = xPlayer.getInventoryItem('baggie').count
	if raw >= 5 then
		if baggies >= 1 then
			xPlayer.removeInventoryItem('rawcrack', 5)
			xPlayer.removeInventoryItem('baggie', 1)
			TriggerClientEvent('scrubz_drugs_cl:packageCrack', source, true)
			Citizen.Wait(6000)
			xPlayer.addInventoryItem('crack1g', 1)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Not enough baggies.', length = 4000 })
			TriggerClientEvent('scrubz_drugs_cl:packageCrack', source, false)
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Not enough crack to bag up.', length = 4000 })
		TriggerClientEvent('scrubz_drugs_cl:packageCrack', source, false)
	end
end)

RegisterServerEvent('scrubz_drugs_sv:addCoke')
AddEventHandler('scrubz_drugs_sv:addCoke', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = math.random(1, 5)
	xPlayer.addInventoryItem('rawcoke', amount)
end)