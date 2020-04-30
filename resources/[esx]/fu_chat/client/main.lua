function Print3DText(coords, text)
  local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)

  if onScreen then
      local px, py, pz = table.unpack(GetGameplayCamCoords())
      local dist = #(vector3(px, py, pz) - vector3(coords.x, coords.y, coords.z))    
      local scale = (1 / dist) * 20
      local fov = (1 / GetGameplayCamFov()) * 100
      local scale = scale * fov   
      SetTextScale(0.35, 0.35)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextColour(250, 250, 250, 255)		-- You can change the text color here
      SetTextDropshadow(1, 1, 1, 1, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      SetDrawOrigin(coords.x, coords.y, coords.z, 0)
      DrawText(0.0, 0.0)
      ClearDrawOrigin()
  end
end

local mes = {}
RegisterNetEvent('fu_chat:client:ReceiveMe')
AddEventHandler('fu_chat:client:ReceiveMe', function(sender, message)
  local senderClient = GetPlayerFromServerId(sender)
  local senderPos = GetEntityCoords(GetPlayerPed(senderClient))
  local dist = #(vector3(senderPos.x, senderPos.y, senderPos.z) - GetEntityCoords(PlayerId()))

  if dist < 20.0 then
    local timer = 500
    mes[sender] = message
    Citizen.CreateThread(function()
      while dist < 20.0 and mes[sender] == message and timer > 0 do
        senderPos = GetEntityCoords(GetPlayerPed(senderClient))
        Print3DText(senderPos, message)
        dist = #(vector3(senderPos.x, senderPos.y, senderPos.z) - GetEntityCoords(PlayerId()))
        timer = timer - 1
        Citizen.Wait(1)
      end
    end)
  end
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
  elseif #(vector3(GetEntityCoords(GetPlayerPed(myId))) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
    TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
  end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
  elseif #(vector3(GetEntityCoords(GetPlayerPed(myId))) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
  end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
  elseif #(vector3(GetEntityCoords(GetPlayerPed(myId))) - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
    TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
  end
end)



-- police


ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		PlayerData = ESX.GetPlayerData()
	end
end)


RegisterCommand('911', function(source, args, rawCommand)
    local playerCoords = GetEntityCoords(PlayerPedId())
		streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
        streetName = GetStreetNameFromHashKey(streetName)
	local msg = rawCommand:sub(5)
	local emergency = '911'
    TriggerServerEvent('fu_chat:911',{
        x = ESX.Math.Round(playerCoords.x, 1),
        y = ESX.Math.Round(playerCoords.y, 1),
        z = ESX.Math.Round(playerCoords.z, 1)
    }, msg, streetName, emergency)
    print('cunt')

    local src = GetPlayerServerId(source)
    local message = 'Please be calm, we have sent units your way they should be there soon! Please hold on.'
    TriggerServerEvent('fu_chat:server:sourceEmergency', src, message)
    print('usless')
end, false)

RegisterCommand('311', function(source, args, rawCommand)

    local playerCoords = GetEntityCoords(PlayerPedId())
		streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
        streetName = GetStreetNameFromHashKey(streetName)
	local msg = rawCommand:sub(5)
	local emergency = '311'
    TriggerServerEvent('fu_chat:911',{
        x = ESX.Math.Round(playerCoords.x, 1),
        y = ESX.Math.Round(playerCoords.y, 1),
        z = ESX.Math.Round(playerCoords.z, 1)
    }, msg, streetName, emergency)
end, false)


RegisterNetEvent('fu_chat:911Marker')
AddEventHandler('fu_chat:911Marker', function(targetCoords, type)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        local alpha = 150
        local call = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite (call, 458)
		SetBlipDisplay(call, 6)
		SetBlipScale  (call, 3.2)
        SetBlipAsShortRange(call, true)
        SetBlipAlpha(call, alpha)

        SetBlipHighDetail(call, true)
		SetBlipAsShortRange(call, true)

		if type == '911' or '311' then
			SetBlipColour (call, 39)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString('911 Call')
	    EndTextCommandSetBlipName(call)
		end

		while alpha ~= 0 do
			Citizen.Wait(100 * 4)
			alpha = alpha - 1
			SetBlipAlpha(call, alpha)

			if alpha == 0 then
				RemoveBlip(call)
				return
			end
        end
    end
end)



RegisterNetEvent('fu_chat:EmergencySend')
AddEventHandler('fu_chat:EmergencySend', function(messageFull)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
      TriggerServerEvent('fu_chat:server:emergency', messageFull)
      PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
      print('pussy')
    end
end)

