ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-- This Code Was changed to fix error With player spawner as default --
-- Link to the post with the error fix --
-- https://forum.fivem.net/t/release-esx-kashacters-multi-character/251613/316?u=xxfri3ndlyxx --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            Citizen.Wait(500)
           -- TriggerServerEvent("kashactersS:SetupCharacters")
			TriggerEvent("kashactersC:WelcomePage")
            TriggerEvent("kashactersC:SetupCharacters")
            return -- break the loop
        end
    end
end)

local IsChoosing = true
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        if IsChoosing then
            DisplayHud(false)
            DisplayRadar(false)
        end
    end
end)
local cam = nil
local cam2 = nil
RegisterNetEvent('kashactersC:SetupCharacters')
AddEventHandler('kashactersC:SetupCharacters', function()
    SetTimecycleModifier('hud_def_blur')
    FreezeEntityPosition(GetPlayerPed(-1), true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 256.32,-1055.71,369.89, 300.00,0.00,0.00, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end)

RegisterNetEvent('kashactersC:WelcomePage')
AddEventHandler('kashactersC:WelcomePage', function()
    SetNuiFocus(true, true)
	SendNUIMessage({
        action = "openwelcome"
    })
end)

RegisterNetEvent('kashactersC:SetupUI')
AddEventHandler('kashactersC:SetupUI', function(Characters)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openui",
        characters = Characters,
    })
end)

RegisterNetEvent('kashactersC:SpawnCharacter')
AddEventHandler('kashactersC:SpawnCharacter', function(spawn, isnew)
    TriggerServerEvent('es:firstJoinProper')
    TriggerEvent('es:allowedToSpawn')
    --TriggerEvent('esx_ambulancejob:multicharacter')
    TriggerEvent("spawnselect:setNui")


    SetTimecycleModifier('default')
    local pos = spawn
    exports['pogressBar']:drawBar(9000, 'Loading Map!')
    Citizen.Wait(9000)
    exports['pogressBar']:drawBar(9000, 'Loading Housing!')
    Citizen.Wait(9000)
    exports['pogressBar']:drawBar(10000, 'Loading Characters!')
    Citizen.Wait(10000)
    exports['mythic_notify']:SendAlert('success', 'Character Loaded Welcome To SilentRP!', 7000)
    exports['mythic_notify']:SendAlert('inform', "Make sure you follow all rules!", 7000,{ ['background-color'] = '#FF0000', ['color'] = '#FFFFFF' })
    exports['mythic_notify']:SendAlert('inform', "Current Tax is 15%", 7000)

    SetEntityCoords(GetPlayerPed(-1), -206.674, -1015.1, 30.1381)
    DoScreenFadeIn(0)
    Citizen.Wait(0)
    exports.spawnmanager:setAutoSpawn(false)
 if isnew then
        TriggerEvent('esx_identity:showRegisterIdentity')
        FreezeEntityPosition(GetPlayerPed(-1), false)
 end
    Citizen.Wait(0)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    IsChoosing = false
    DisplayHud(true)
	FreezeEntityPosition(GetPlayerPed(-1), false)
end)

RegisterNetEvent('kashactersC:ReloadCharacters')
AddEventHandler('kashactersC:ReloadCharacters', function()
    TriggerServerEvent("kashactersS:SetupCharacters")
    TriggerEvent("kashactersC:SetupCharacters")
end)

RegisterNUICallback("CharacterChosen", function(data, cb)
    SetNuiFocus(false,false)
    TriggerServerEvent('kashactersS:CharacterChosen', data.charid, data.ischar, data.spawnid or "1")
    cb("ok")
end)
RegisterNUICallback("DeleteCharacter", function(data, cb)
    SetNuiFocus(false,false)
    TriggerServerEvent('kashactersS:DeleteCharacter', data.charid)
    cb("ok")
end)
RegisterNUICallback("ShowSelection", function(data, cb)
	TriggerServerEvent("kashactersS:SetupCharacters")
end)
