-- StarBlazt Chat
local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


function getIdentity(source , identifier)
 -- Fix identifier
    -- local identifier = GetPlayerIdentifiers(source)[1]
    -- local xplayer = ESX.GetPlayerFromId(source)
    -- local identifier = xplayer.identifier
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			name = identity['name'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			job = identity['job'],
			group = identity['group']
		}
	else
		return nil
	end
end



AddEventHandler("chatMessage", function(source, color, message)
    local src = source
    args = stringsplit(message, " ")
    CancelEvent()
    if string.find(args[1], "/") then
        local cmd = args[1]
        table.remove(args, 1)
    end
end)

RegisterServerEvent('chat:server:ServerPSA')
AddEventHandler('chat:server:ServerPSA', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message server">SERVER: {0}</div>',
        args = { message }
    })
    CancelEvent()
end)


RegisterServerEvent('911')
AddEventHandler('911', function(source, caller, msg)
    print('id = ' .. source)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
    fal = name.firstname  .. '  ' .. name.lastname
    TriggerClientEvent('chat:EmergencySend911', -1, source, fal, msg)
end)

RegisterServerEvent('chat:resetpos')
AddEventHandler('chat:resetpos', function(source)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local results = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier AND last_property IS NOT NULL ", {['@identifier'] = identifier})
    local property = nil
    if results[1] == property then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Kamu tidak berada di apartemen', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Lokasi di reset!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
        local apt = MySQL.Sync.fetchAll("UPDATE users SET last_property = @property WHERE identifier = @identifier", {['@identifier'] = identifier , ['@property'] = property})
        TriggerClientEvent('chat:resetplayers', source)
    end
end)

RegisterServerEvent('311')
AddEventHandler('311', function(source, caller, msg)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
    fal = name.firstname  .. '  ' .. name.lastname
    TriggerClientEvent('chat:EmergencySend311', -1, source, fal, msg)
end)


RegisterServerEvent('911r')
AddEventHandler('911r', function(target, source, msg)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
    fal = name.firstname  .. '  ' .. name.lastname
    TriggerClientEvent('chat:EmergencySend911r', -1, source, fal, msg)
end)

RegisterServerEvent('311r')
AddEventHandler('311r', function(target, source, msg)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
    fal = name.firstname  .. '  ' .. name.lastname
    TriggerClientEvent('chat:EmergencySend311r', -1, source, fal, msg)
end)

RegisterServerEvent('chat:server:911source')
AddEventHandler('chat:server:911source', function(source, caller, msg)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
	fal = name.firstname .. "  " .. name.lastname
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message emergency">911 {0} ({1}): {2} </div>',
        args = { fal, caller, msg }
    })
    CancelEvent()
end)

RegisterServerEvent('chat:server:911r')
AddEventHandler('chat:server:911r', function(target, caller, msg)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
	fal = name.firstname .. "  " .. name.lastname
    TriggerClientEvent('chat:addMessage', target, {
        template = '<div class="chat-message emergency">911r {0} : {1} </div>',
        args = { fal, msg }
    })
    CancelEvent()
    TriggerClientEvent('chat:EmergencySend911', fal, caller, msg)
end)

RegisterServerEvent('chat:server:311r')
AddEventHandler('chat:server:311r', function(target, caller, msg)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
	fal = name.firstname .. "  " .. name.lastname
    TriggerClientEvent('chat:addMessage', target, {
        template = '<div class="chat-message nonemergency">311r {0}: {1} </div>',
        args = { fal, msg }
    })
    CancelEvent()
end)


RegisterServerEvent('chat:server:311source')
AddEventHandler('chat:server:311source', function(source, caller, msg)
	local xplayer = ESX.GetPlayerFromId(source)
    local identifier = xplayer.identifier
    local name = getIdentity(source,identifier)
	fal = name.firstname .. "  " .. name.lastname
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message nonemergency">311 {0} ({1}): {2} </div>',
        args = { fal, caller, msg }
    })
    CancelEvent()
end)


Citizen.CreateThread(function()
	local uptimeMinute, uptimeHour, uptime = 0, 0, ''

	while true do
		Citizen.Wait(1000 * 60) -- every minute
		uptimeMinute = uptimeMinute + 1

		if uptimeMinute == 60 then
			uptimeMinute = 0
			uptimeHour = uptimeHour + 1
		end

		uptime = string.format("%02dh %02dm", uptimeHour, uptimeMinute)
		SetConvarServerInfo('Uptime', uptime)


		TriggerClientEvent('uptime:tick', -1, uptime)
		TriggerEvent('uptime:tick', uptime)
	end
end)



function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end