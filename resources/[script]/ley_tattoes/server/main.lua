ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ley_tattoes:resettattoes')
AddEventHandler('ley_tattoes:resettattoes', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    identifier = xPlayer.identifier
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Tato direset, Perubahan saat relog!', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) 
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Biaya Rp.10000', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) 
    MySQL.Sync.fetchAll("UPDATE users set tattoos = @tattoos where identifier = @identifier" , {['@tattoss'] = '' , ['@identifier'] = identifier})
    xPlayer.removeAccountMoney('bank', 10000)

end)