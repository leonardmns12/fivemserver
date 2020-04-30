--[[

  ESX RP Chat

--]]
ESX = nil
function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
			
		}
	else
		return nil
	end
end

 AddEventHandler('chatMessage', function(source, name, message)
      if string.sub(message, 1, string.len("/")) ~= "/" then
          local pName = getIdentity(source)
          fal = "OOC | " .. pName.firstname .. " " .. pName.lastname
          TriggerClientEvent('chat:addMessage', -1, {
              template = '<div style="margin: 0.5vw; background-color: rgba(0, 119, 255, 0.8); border-radius: 3px 5px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
              args = { fal , message}
          })
      end
      CancelEvent()
  end)
  
  AddEventHandler("chatMessage", function(source, args, raw)
    CancelEvent()
end)
  
  -- TriggerEvent('es:addCommand', 'me', function(source, args, user)
  --    local name = getIdentity(source)
  --    TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, table.concat(args, " "))
  -- end) 



  --- TriggerEvent('es:addCommand', 'me', function(source, args, user)
  ---    local name = getIdentity(source)
  ---    TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, table.concat(args, " "))
  -- end) 
  TriggerEvent('es:addCommand', 'me', function(source, args, user)
    local name = getIdentity(source)
    table.remove(args, 2)
    TriggerClientEvent('esx-qalle-chat:me', -1, source, name.firstname, table.concat(args, " "))
end)


 RegisterCommand('twt', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
    fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 50px 50px;"><i class="fab fa-twitter"></i> @{0}:<br> {1}</div>',
        args = { fal, msg }
    })
end, false)

 RegisterCommand('anontweet', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(11)
    local name = getIdentity(source)
    fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 50px 50px;"><i class="fab fa-twitter"></i> @Anonymous:<br> {1}</div>',
        args = { fal, msg }
    })
end, false)

 RegisterCommand('ad', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(4)
    local name = getIdentity(source)
    fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="margin: 0.5vw; background-color: rgba(214, 168, 0, 1); border-radius: 50px 50px;"><i class="fas fa-ad"></i> Advertisement:<br> {1}<br></div>',
        args = { fal, msg }
    })
end, false)

RegisterCommand('pol', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
    fal = "Police | " ..name.firstname.. " "
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="margin: 0.5vw; background-color: rgba(153, 5, 5, 1); border-radius: 50px 50px;"><i class="fas fa-rss"></i> {0}:<br> {1}</div>',
        args = { fal, msg }
    })
end, false)

RegisterCommand('ems', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
    fal = "Ambulance | " ..name.firstname.. " "
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="margin: 0.5vw; background-color: rgba(105, 163, 98, 1); border-radius: 50px 50px;"><i class="fas fa-ambulance"></i> {0}:<br> {1}</div>',
        args = { fal, msg }
    })
end, false)


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
