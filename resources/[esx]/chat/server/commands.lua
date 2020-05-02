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



