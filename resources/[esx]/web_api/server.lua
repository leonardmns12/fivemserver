TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterCommand("webconnect", function(source, args)
    local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    print(xplayer.identifier)

    local argsString = table.concat( args," " )
    local result = MySQL.Sync.fetchAll("SELECT * FROM loginlauncher_users WHERE identifier = @identifier ", {['@identifier'] = identifier})
    if(result[1] ~= nil) then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Akun sudah pernah terhubung', length = 4500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    else
        local get = MySQL.Sync.fetchAll("SELECT * FROM loginlaunceher_users WHERE username = @username AND password = @pwd" , {['@username'] = args[1] , ['@pwd'] = args[2]})
        if(get ~= nil) then
        local insert = MySQL.Sync.fetchAll("UPDATE loginlauncher_users set identifier = @identifier where username = @username" , {['@username'] = args[1] , ['@identifier'] = identifier})
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Akun Berhasil Terhubung!', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })     
        else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Username atau password salah!', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })      
        end
        -- MySQL.Sync.fetchAll("UPDATE loginlauncher_users set identifier = @identifier where username = @username AND PASSWORD = @pwd ", {['@identifier'] = identifier , ['@username'] = args[1] , ['@pwd'] = args[2]})
        -- TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu berhasil terhubung ke website', length = 4500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    end
end,false)