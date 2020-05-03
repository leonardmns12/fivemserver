ESX = nil
heistOn = false
robbed = 0

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent("esx_advancedbankrobberym:startRobbery")
AddEventHandler("esx_advancedbankrobberym:startRobbery", function(bankId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	local Bank = BankHeists[bankId]
	local cops = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end

	if (os.time() - robbed) < Config.HeistCooldown and robbed ~= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Seluruh bank tutup, karena perampokan yang baru-baru ini terjadi di '..lastBank..'.', length = 3500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Buka kembali dalam '..(Config.HeistCooldown - (os.time() - robbed))..' detik', length = 3500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		-- TriggerClientEvent('esx:showNotification', source, _U('banks_lockdown') .. lastBank)
		-- TriggerClientEvent('esx:showNotification', source, _U('lockdown_gone') .. (Config.HeistCooldown - (os.time() - robbed)) .. _U('seconds_remaining'))
		return
	end

	if not heistOn then
		if(cops >= Config.Cops)then

			if xPlayer.getInventoryItem('raspberry').count >= 1 then
				if xPlayer.getInventoryItem('blowtorch').count >= 1 then
					xPlayer.removeInventoryItem('raspberry', 1)
					xPlayer.removeInventoryItem('blowtorch', 1)

					for i=1, #xPlayers, 1 do
						local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
						if xPlayer.job.name == 'police' then
							-- TriggerClientEvent('chatMessage', -1, '[NEWS] ', {255, 0, 0}, "- Heist in progress at: ^2" .. Bank["bankName"])

							TriggerClientEvent('chat:addMessage', -1, {
								template = '<div class="chat-message heist"><b> [POLISI] Perampokan terjadi di: {0} </b></div>',
								args = { Bank["bankName"] } 
								})

							TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer[i], { type = 'error', text = 'Perampokan terjadi di '..Bank["bankName"]..'.', length = 3000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
							-- TriggerClientEvent('esx:showNotification', xPlayers[i], _U('heist_at') .. Bank["bankName"])
						end
					end
					heistOn = true
					lastBank = Bank["bankName"]
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu memulai perampokan di '..Bank["bankName"]..'.', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Alarm berbunyi dan polisi sedang menuju ke tempat kamu!', length = 2900, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
					-- TriggerClientEvent('esx:showNotification', source, _U('started_heist') .. Bank["bankName"])
					-- TriggerClientEvent('esx:showNotification', source, _U('alarm_triggered'))
					TriggerClientEvent("esx_advancedbankrobberym:heistBlip", -1, bankId)
	    		TriggerClientEvent("esx_advancedbankrobberym:startRobbery", source, bankId)
					TriggerClientEvent("esx_advancedbankrobberym:tooFar", source, bankId)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu membutuhkan blowtorch untuk membuka brankas.', length = 3000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
					-- TriggerClientEvent('esx:showNotification', source, _U('blowtorch_needed'))
				end
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu membutuhkan Raspberry PI untuk melakukan peretasan.', length = 3000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
				-- TriggerClientEvent('esx:showNotification', source, _U('rasp_needed'))
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Minimal '..Config.Cops..' polisi.', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			-- TriggerClientEvent('esx:showNotification', source, _U('min_police')..Config.Cops)
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sedang terjadi perampokan di '..Bank["bankName"]..'.', length = 3000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		-- TriggerClientEvent('esx:showNotification', source, _U('heist_already') .. Bank["bankName"])
	end
end)

RegisterServerEvent("esx_advancedbankrobberym:keycardCheck")
AddEventHandler("esx_advancedbankrobberym:keycardCheck", function(bankId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem('keycard_gold').count >= 1 then
		local _cardTime = Config.cardTime[1] -- 1 min
		local _dyeChance = Config.dyeChance[1] -- 90%
		TriggerClientEvent("esx_advancedbankrobberym:cardTime", source, bankId, _cardTime, _dyeChance)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu telah menggunakan golden keycard.', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		-- TriggerClientEvent("esx:showNotification", source, _U('keycard_gold'))
		xPlayer.removeInventoryItem('keycard_gold', 1)

	elseif xPlayer.getInventoryItem('keycard_black').count >= 1 then
		local _cardTime = Config.cardTime[2]  -- 4 min
		local _dyeChance = Config.dyeChance[2] -- 70%
		TriggerClientEvent("esx_advancedbankrobberym:cardTime", source, bankId, _cardTime, _dyeChance)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu telah menggunakan black keycard.', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		-- TriggerClientEvent("esx:showNotification", source, _U('keycard_black'))
		xPlayer.removeInventoryItem('keycard_black', 1)

	elseif xPlayer.getInventoryItem('keycard_red').count >= 1 then
		local _cardTime = Config.cardTime[3] -- 7 min
		local _dyeChance = Config.dyeChance[3] -- 50%
		TriggerClientEvent("esx_advancedbankrobberym:cardTime", source, bankId, _cardTime, _dyeChance)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu telah menggunakan red keycard.', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		-- TriggerClientEvent("esx:showNotification", source, _U('keycard_red'))
		xPlayer.removeInventoryItem('keycard_red', 1)

	elseif xPlayer.getInventoryItem('keycard_blue').count >= 1 then
		local	_cardTime = Config.cardTime[4] --10 min
		local _dyeChance = Config.dyeChance[4] -- 30%
		TriggerClientEvent("esx_advancedbankrobberym:cardTime", source, bankId, _cardTime, _dyeChance)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu telah menggunakan blue keycard.', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		-- TriggerClientEvent("esx:showNotification", source, _U('keycard_blue'))
		xPlayer.removeInventoryItem('keycard_blue', 1)

	elseif xPlayer.getInventoryItem('keycard_green').count >= 1 then
		local _cardTime = Config.cardTime[5] --13 min
		local _dyeChance = Config.dyeChance[5] -- 10%
		TriggerClientEvent("esx_advancedbankrobberym:cardTime", source, bankId, _cardTime, _dyeChance)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu telah menggunakan green keycard.', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		-- TriggerClientEvent("esx:showNotification", source, _U('keycard_green'))
		xPlayer.removeInventoryItem('keycard_green', 1)
	else
		local _cardTime = nil
		TriggerClientEvent("esx_advancedbankrobberym:cardTime", source, bankId, _cardTime)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu tidak memiliki keycard.', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		-- TriggerClientEvent("esx:showNotification", source, _U('no_keycard'))
	end
end)

RegisterServerEvent("esx_advancedbankrobberym:lockpickDoor")
AddEventHandler("esx_advancedbankrobberym:lockpickDoor", function(bankId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem('lockpick').count >= 1 then
		xPlayer.removeInventoryItem('lockpick', 1)
		TriggerClientEvent("esx_advancedbankrobberym:desks", source, bankId)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu membutuhkan Lockpick untuk membuka pintu.', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		-- TriggerClientEvent('esx:showNotification', source, _U('lockpick_needed'))
	end
end)

RegisterServerEvent("esx_advancedbankrobberym:vaultOpen")
AddEventHandler("esx_advancedbankrobberym:vaultOpen", function(bankId)
  TriggerClientEvent("esx_advancedbankrobberym:openDoor", -1, bankId)
end)

RegisterServerEvent("esx_advancedbankrobberym:deskOpen")
AddEventHandler("esx_advancedbankrobberym:deskOpen", function(bankId)
  TriggerClientEvent("esx_advancedbankrobberym:OpenDeskDoor", -1, bankId)
end)

RegisterServerEvent("esx_advancedbankrobberym:giveCash")
AddEventHandler("esx_advancedbankrobberym:giveCash", function(bankId, totalCash)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addAccountMoney("black_money", totalCash)
  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu menerima sebanyak '..totalCash..' uang kotor.', length = 3000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
--   TriggerClientEvent("esx:showNotification", source, "~g~$" .. totalCash .. _U('dirty_cash'))
end)

RegisterServerEvent('esx_advancedbankrobberym:giveItems')
AddEventHandler('esx_advancedbankrobberym:giveItems', function(itemName)
    local source = source
		local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addInventoryItem(itemName, 1)
end)

RegisterServerEvent('esx_advancedbankrobberym:bagTracker')
AddEventHandler('esx_advancedbankrobberym:bagTracker', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx_advancedbankrobberym:bagBlip', xPlayers[i])
		end
	end
end)

RegisterServerEvent("esx_advancedbankrobberym:endRobbery")
AddEventHandler("esx_advancedbankrobberym:endRobbery", function(bankId)
	local source = source
	local xPlayers = ESX.GetPlayers()
	local Bank = BankHeists[bankId]

	heistOn = false
	robbed = os.time()

	TriggerClientEvent("esx_advancedbankrobberym:delHeistBlip", -1)

	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		 if xPlayer.job.name == 'police' then
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer[i], { type = 'inform', text = 'Perampokan di '..Bank["bankName"]..' telah dibatalkan.', length = 3000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			-- TriggerClientEvent('esx:showNotification', xPlayers[i], _U('heist_cancelled_at') .. Bank["bankName"])
		end
	end
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kamu membatalkan perampokan di '..Bank["bankName"]..'.', length = 3000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	-- TriggerClientEvent('esx:showNotification', source, _U('heist_cancelled') .. Bank["bankName"])
end)
