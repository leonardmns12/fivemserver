ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx-qalle-hunting:reward')
AddEventHandler('esx-qalle-hunting:reward', function(Weight)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Weight >= 1 then
        xPlayer.addInventoryItem('meat', 1)
    elseif Weight >= 9 then
        xPlayer.addInventoryItem('meat', 2)
    elseif Weight >= 15 then
        xPlayer.addInventoryItem('meat', 3)
    end

    xPlayer.addInventoryItem('leather', math.random(1, 4))
        
end)

RegisterServerEvent('esx-qalle-hunting:sell')
AddEventHandler('esx-qalle-hunting:sell', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local MeatPrice = 2500
    local LeatherPrice = 200

    local MeatQuantity = xPlayer.getInventoryItem('meat').count
    local LeatherQuantity = xPlayer.getInventoryItem('leather').count

    if MeatQuantity > 0 or LeatherQuantity > 0 then
        xPlayer.addMoney(MeatQuantity * MeatPrice)
        xPlayer.addMoney(LeatherQuantity * LeatherPrice)

        xPlayer.removeInventoryItem('meat', MeatQuantity)
        xPlayer.removeInventoryItem('leather', LeatherQuantity)
        --TriggerClientEvent('esx:showNotification', xPlayer.source, 'You sold ' .. LeatherQuantity + MeatQuantity .. ' and earned $' .. LeatherPrice * LeatherQuantity + MeatPrice * MeatQuantity)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu menjual ' ..LeatherQuantity + MeatQuantity.. 'dan mendapatkan Rp ' ..LeatherPrice * LeatherQuantity + MeatPrice * MeatQuantity, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    else
        --TriggerClientEvent('esx:showNotification', xPlayer.source, 'You don\'t have any meat or leather')
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu tidak punya meat/daging ataupun leather/kulit untuk dijual!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    end
        
end)

function sendNotification(xsource, message, messageType, messageTimeout)
    TriggerClientEvent('notification', xsource, message)
end