

-- StarBlazt Chat

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- function getIdentity(source)
-- 	local identifier = GetPlayerIdentifiers(source)[1]
-- 	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
-- 	if result[1] ~= nil then
-- 		local identity = result[1]

-- 		return {
-- 			identifier = identity['identifier'],
-- 			firstname = identity['firstname'],
-- 			lastname = identity['lastname'],
-- 			dateofbirth = identity['dateofbirth'],
-- 			sex = identity['sex'],
-- 			height = identity['height']
-- 		}
-- 	else
-- 		return nil
-- 	end
-- end

--[[ COMMANDS ]]--

RegisterCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)

RegisterCommand('ooc', function(source, args, rawCommand)
	local msg = rawCommand:sub(4)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
	local name = getIdentity(source,identifier)
	fal = name.firstname .. "  " .. name.lastname
        TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message"><b>[OOC] {0}:</b> {1}</div>',
        args = { fal, msg }
    })
end, false)

RegisterCommand('ems', function(source, args, rawCommand) --ijo
	local msg = rawCommand:sub(4)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
    if name.job == "ambulance" then 
        fal = name.firstname .. "  " .. name.lastname
            TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message ems"><b>[EMS] {0}:</b> {1}</div>',
            args = { fal, msg }
        })
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu bukan EMS!', length = 4500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    end
end, false)

RegisterCommand('pol', function(source, args, rawCommand) --merah
	local msg = rawCommand:sub(4)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
    if name.job == "police" then 
        fal = name.firstname .. "  " .. name.lastname
            TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message police"><b>[POLISI] {0}:</b> {1}</div>',
            args = { fal, msg }
        })
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu bukan Polisi!', length = 4500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    end
end, false)

RegisterCommand('mech', function(source, args, rawCommand) --coklat
	local msg = rawCommand:sub(5)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
    if name.job == "mecano" then
        fal = name.firstname .. "  " .. name.lastname
            TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message mecano"><b>[MECHANIC] {0}:</b> {1}</div>',
            args = { fal, msg }
        })
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu bukan Mekanik!', length = 4500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    end
end, false)

RegisterCommand('twt', function(source, args, rawCommand)
	local msg = rawCommand:sub(4)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
	local name = getIdentity(source,identifier)
	fal = name.firstname .. "  " .. name.lastname
        TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message twitter"><i class="fab fa-twitter"></i><b> Twitter @{0}:</b> {1}</div>',
        args = { fal, msg }
    })
end, false)

RegisterCommand('anontwt', function(source, args, rawCommand)
	local msg = rawCommand:sub(8)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
	local name = getIdentity(source,identifier)
	fal = "Anonymous"
        TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message twitter"><i class="fab fa-twitter"></i><b> Twitter @{0}:</b> {1}</div>',
        args = { fal, msg }
    })
end, false)

RegisterCommand('ads', function(source, args, rawCommand)
	local msg = rawCommand:sub(4)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
    if xplayer.getAccount('bank').money >= 10000 then
        xplayer.removeAccountMoney('bank', 10000)
        fal = name.firstname .. "  " .. name.lastname    
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Dana kamu di atm ditarik sebesar 10000 untuk melakukan Advertisement.', length = 4500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
            TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message advert"><i class="fas fa-ad"></i><b> Advertisement {0}:</b> {1}</div>',
            args = { fal, msg }
        })
    else 
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Dana di atm tidak mencukupi. Tidak dapat melakukan Advertisement.', length = 4500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    end
end, false)

RegisterCommand("webconnect", function(source, args)
    local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier

    local argsString = table.concat( args," " )
    local result = MySQL.Sync.fetchAll("SELECT * FROM loginlauncher_users WHERE identifier = @identifier ", {['@identifier'] = identifier})
    if(result[1] ~= nil) then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Akun sudah pernah terhubung', length = 4500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    else
        local get = MySQL.Sync.fetchAll("SELECT * FROM loginlauncher_users WHERE username = @username AND password = @pwd" , {['@username'] = args[1] , ['@pwd'] = args[2]})
        if(get[1] ~= nil) then
        local insert = MySQL.Sync.fetchAll("UPDATE loginlauncher_users set identifier = @identifier where username = @username" , {['@username'] = args[1] , ['@identifier'] = identifier})
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Akun Berhasil Terhubung!', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })     
        else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Username atau password salah!', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })      
        end
    end
end,false)

RegisterCommand("getmoney", function(source, args)
    local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local argsString = table.concat( args," " )
    local money = tonumber(args[1])

    local result = MySQL.Sync.fetchAll("SELECT * FROM loginlauncher_users WHERE identifier = @identifier ", {['@identifier'] = identifier})
    local webmoney = tonumber(result[1].cash)
    if(result[1] ~= nil) then
        if(money > webmoney) then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Jumlah invalid!', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) 
        else
            print(1)
            xplayer.addAccountMoney('bank', money)
            webmoney = webmoney - money
            MySQL.Sync.fetchAll("UPDATE loginlauncher_users set cash = @webcash where identifier = @identifier" , {['@webcash'] = webmoney , ['@identifier'] = identifier})
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Uang bank bertambah Rp' ..money..'.', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) 
        end
    else    
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'FiveM anda belum terhubung!', length = 5000, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } }) 
    end

end,false)


