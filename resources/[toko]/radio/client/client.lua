ESX = nil

-- TODO: Copied from TokoVoip config currently. Make it dynamic.
Channels = {
  {id = 1, name = "Off", jobs = {}},
  {id = 2, name = "Polisi channel 1", jobs = {"offambulance", "offpolice", "police", "ambulance"}},
  {id = 3, name = "Polisi Channel 2", jobs = {"offambulance", "offpolice", "police", "ambulance"}},
  {id = 4, name = "Medis Channel 1", jobs = {"offambulance", "offpolice", "police", "ambulance"}},
  {id = 5, name = "Medis Channel 2", jobs = {"offambulance", "offpolice", "police", "ambulance"}},
  {id = 6, name = "Polisi/Medis Radio 1", jobs = {}},
  {id = 7, name = "Polisi/Medis Radio 1", jobs = {}},
  {id = 8, name = "Darurat 1", jobs = {}},
  {id = 9, name = "Taxi", jobs = {"taxi"}},
  {id = 10, name = "Mechanic", jobs = {"mechanic"}}
}

local isRadioShowing = true
local currentChannel = Channels[1]
local playerData     = {}

function CanUseChannel(channel)
  if (#channel["jobs"] == 0) then return true end

  for i = 1, #channel["jobs"] do
    if (playerData.job ~= nil and playerData.job.name == channel["jobs"][i]) then
      return true
    end
  end

  return false
end

function GetNextChannel()
  for i = currentChannel["id"] + 1, #Channels do
    if (CanUseChannel(Channels[i])) then
      return Channels[i]
    end
  end

  return nil
end

function GetPreviousChannel()
  for i = currentChannel["id"] - 1, 1, -1 do
    if (CanUseChannel(Channels[i])) then
      return Channels[i]
    end
  end

  return nil
end

function ToggleRadio()
  isRadioShowing = not isRadioShowing;
  SendNUIMessage({type = "pixelated.radio", display = isRadioShowing})

  if (isRadioShowing) then
    SendNUIMessage({type = "pixelated.radio", text = currentChannel["name"]})

    Citizen.CreateThread(function()
      while (isRadioShowing) do
        Citizen.Wait(5)

        local newChannel

        if (IsControlJustPressed(0, 174)) then
          newChannel = GetPreviousChannel()
        elseif (IsControlJustPressed(0, 175)) then
          newChannel = GetNextChannel()
        end

        if (newChannel ~= nil and newChannel ~= currentChannel) then
          if (newChannel["id"] ~= 1) then 
            exports.tokovoip_script:addPlayerToRadio(newChannel["id"] - 1)
          end

          currentChannel = newChannel

          Unsubscribe()

          SendNUIMessage({type = "pixelated.radio", text = newChannel["name"]})
          PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
        end
      end
    end)
  end
end

function Unsubscribe(all)
  all = all or false

  for i = 2, #Channels do
    if (all or currentChannel ~= Channels[i]) then 
      if (exports.tokovoip_script:isPlayerInChannel(Channels[i].id - 1)) then
        exports.tokovoip_script:removePlayerFromRadio(Channels[i].id - 1)
      end
    end
  end
end

AddEventHandler('onClientResourceStart', function (resourceName)
  if(GetCurrentResourceName() ~= resourceName) then return end
  Unsubscribe(true)
end)

AddEventHandler('onClientResourceStop', function (resourceName)
  if(GetCurrentResourceName() ~= resourceName) then return end
  Unsubscribe(true)
end)

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(5)
  end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	playerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  playerData.job = job
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)

      if IsControlPressed(0, 21) and IsControlJustPressed(0, 246) then -- shift + f1
          ToggleRadio()
      end
    end
end)

-- Periodically clean up radio subscriptions
Citizen.CreateThread(function()
  Citizen.Wait(30000)
  Unsubscribe()
end)