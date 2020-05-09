ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount = ESX.Math.Round(amount)

	if amount > 0 and xTarget then
		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
			if account then
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
					['@identifier'] = xTarget.identifier,
					['@sender'] = xPlayer.identifier,
					['@target_type'] = 'society',
					['@target'] = sharedAccountName,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { type = 'inform', text = 'Kamu baru saja mendapatkan sebuah tagihan.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
					-- xTarget.showNotification(_U('received_invoice'))
				end)
			else
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
					['@identifier'] = xTarget.identifier,
					['@sender'] = xPlayer.identifier,
					['@target_type'] = 'player',
					['@target'] = xPlayer.identifier,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { type = 'inform', text = 'Kamu baru saja mendapatkan sebuah tagihan.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
					-- xTarget.showNotification(_U('received_invoice'))
				end)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT amount, id, label FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT amount, id, label FROM billing WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			cb(result)
		end)
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, billId)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT sender, target_type, target, amount FROM billing WHERE id = @id', {
		['@id'] = billId
	}, function(result)
		if result[1] then
			local amount = result[1].amount
			local xTarget = ESX.GetPlayerFromIdentifier(result[1].sender)

			if result[1].target_type == 'player' then
				if xTarget then
					if xPlayer.getMoney() >= amount then
						MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								xTarget.addMoney(amount)

								TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Kamu berhasil membayar tagihan sebanyak '..ESX.Math.GroupDigits(amount)..'.', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
								TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, { type = 'inform', text = 'Kamu menerima pembayaran sebanyak '..ESX.Math.GroupDigits(amount)..'.', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

								-- xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
								-- xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								xTarget.addAccountMoney('bank', amount)

								TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Kamu berhasil membayar tagihan sebanyak '..ESX.Math.GroupDigits(amount)..'.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
								TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, { type = 'inform', text = 'Kamu menerima pembayaran sebanyak '..ESX.Math.GroupDigits(amount)..'.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

								-- xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
								-- xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
							end

							cb()
						end)
					else

						TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, { type = 'error', text = 'Orang ini tidak memiliki cukup uang.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
						TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Kamu tidak memiliki cukup uang untuk membayar tagihan. '..ESX.Math.GroupDigits(amount)..'.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

						-- xTarget.showNotification(_U('target_no_money'))
						-- xPlayer.showNotification(_U('no_money'))
						cb()
					end
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Orang ini sedang tidak berada di dalam game.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
					-- xPlayer.showNotification(_U('player_not_online'))
					cb()
				end
			else
				TriggerEvent('esx_addonaccount:getSharedAccount', result[1].target, function(account)
					if xPlayer.getMoney() >= amount then
						MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								account.addMoney(amount)

								TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Kamu berhasil membayar tagihan sebanyak '..ESX.Math.GroupDigits(amount)..'.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

								-- xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
								if xTarget then
									TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, { type = 'inform', text = 'Kamu menerima pembayaran sebanyak '..ESX.Math.GroupDigits(amount)..'.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

									-- xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
								end
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								account.addMoney(amount)

								TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Kamu berhasil membayar tagihan sebanyak '..ESX.Math.GroupDigits(amount)..'.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

								-- xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))

								if xTarget then
									TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, { type = 'inform', text = 'Kamu menerima pembayaran sebanyak '..ESX.Math.GroupDigits(amount)..'.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

									-- xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
								end
							end

							cb()
						end)
					else
						if xTarget then
							TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, { type = 'error', text = 'Orang ini tidak memiliki cukup uang.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
						
							-- xTarget.showNotification(_U('target_no_money'))
						end

						TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Kamu tidak memiliki cukup uang untuk membayar tagihan. '..ESX.Math.GroupDigits(amount)..'.', length = 4000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

						-- xPlayer.showNotification(_U('no_money'))
						cb()
					end
				end)
			end
		end
	end)
end)
