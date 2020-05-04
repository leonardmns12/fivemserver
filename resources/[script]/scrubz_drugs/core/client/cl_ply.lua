---------------------------
-- Locals --
---------------------------
ESX = nil
isPlyPolice = false
local playerData = {}
local cityPos = vector3(-157.85, -956.66, 31.08)
local plyLoaded = false
local isPlySelling = false
local pedsBought = {}

---------------------------
-- ESX --
---------------------------
Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(250)
    end
end)

---------------------------
-- Citizen Threads --
---------------------------
-- Checking for job. No naughty cops allowed ^_^
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        if playerData.job ~= nil and playerData.job.name == 'police' then
            isPlyPolice = true
        else
            isPlyPolice = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if not plyLoaded then
            TriggerServerEvent('scrubz_drugs_sv:getDoors')
            --TriggerServerEvent('scrubz_drugs_sv:getPlants')
            plyLoaded = true
        end
        if not isPlyPolice then
            local plyPed = GetPlayerPed(-1)
            local plyPos = GetEntityCoords(plyPed)
            if not IsPedInAnyVehicle(plyPed, false) then
                local isNearCity = #(plyPos - cityPos)
                if isNearCity <= 2200 then
                    for ped in enumeratePeds() do
                        if ped ~= nil then
                            local pedType = GetPedType(ped)
                            if DoesEntityExist(ped) and not IsPedDeadOrDying(ped) and not IsPedInAnyVehicle(ped, false) and not IsPedAPlayer(ped) and pedType ~= 28 then
                                local pedPos = GetEntityCoords(ped)
                                local isNearPed = #(plyPos - pedPos)
                                if isNearPed <= 2 then
                                    currentPed = ped
                                end
                            end
                        end
                    end
                end
            else
                Citizen.Wait(2000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local plyPed = GetPlayerPed(-1)
        local plyPos = GetEntityCoords(plyPed)
        local pedPos = GetEntityCoords(currentPed)
        local isNear = #(plyPos - pedPos)
        if isNear <= 2 then
            if not isPlySelling then
                local textPos = GetEntityCoords(currentPed)
                DrawText3Ds(textPos.x, textPos.y, textPos.z, 'Press ~r~[E]~w~ to sell drugs')
                if IsControlJustPressed(1, 86) then  -- Key: E
                    TriggerServerEvent('scrubz_drugs_sv:drugsCheck', currentPed)
                    isPlySelling = true
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

---------------------------
-- Event Handlers --
---------------------------
AddEventHandler('skinchanger:loadSkin', function(character)
	plyGender = character.sex
end)

RegisterCommand('locations', function(source, args, raw)
    TriggerServerEvent('scrubz_drugs_sv:getDoors')
end, false)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  playerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  playerData.job = job
end)

RegisterNetEvent('scrubz_drugs_cl:drugsReturn')
AddEventHandler('scrubz_drugs_cl:drugsReturn', function(ped, enoughCops, hasDrugs, drugType)
    if enoughCops == true then
        if hasDrugs == true then
            local plyPed = GetPlayerPed(-1)
            local plyPos = GetEntityCoords(plyPed)
            local pedPos = GetEntityCoords(ped)
            local pedBought = false
            for k, v in pairs(pedsBought) do
                if v == ped then
                    pedBought = true
                    break
                end
            end
            if not pedBought then
                table.insert(pedsBought, ped)
                ClearPedTasks(ped)
                TaskTurnPedToFaceEntity(ped, plyPed, -1)
                Citizen.Wait(3000)
                FreezeEntityPosition(ped, true)
                local randomChance = math.random(1, 12)
                if randomChance <= 2 then
                    ClearPedTasks(ped)
                    FreezeEntityPosition(ped, false)
                    exports['mythic_notify']:SendAlert('inform', 'Nah I\'m good homie!', 3500)
                elseif randomChance <= 10 then
                    if Config.UseProgressBars then
                        exports['progressBars']:startUI(8000, "Slangin Drugs...")
                        Citizen.Wait(8000)
                        local isNearPed = #(plyPos - pedPos)
                        if isNearPed <= 3 then
                            RequestAnimDict("mp_safehouselost@")
                            while not HasAnimDictLoaded("mp_safehouselost@") do
                                Citizen.Wait(1)
                            end
                            TaskPlayAnim(plyPed, "mp_safehouselost@", "package_dropoff", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
                            TaskPlayAnim(ped, "mp_safehouselost@", "package_dropoff", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
                            TriggerServerEvent('scrubz_drugs_sv:endSale', drugType)
                            Citizen.Wait(2000)
                            StopAnimTask(plyPed, "mp_safehouselost@", "package_dropoff", 1.0)
                            StopAnimTask(ped, "mp_safehouselost@", "package_dropoff", 1.0)
                            Citizen.Wait(1000)
                            FreezeEntityPosition(ped, false)
                            ClearPedTasks(ped)
                        else
                            exports['mythic_notify']:SendAlert('error', 'You\'re too far from the buyer!')
                            FreezeEntityPosition(ped, false)
                            ClearPedTasks(ped)
                        end
                    elseif Config.UseMythicProgbar then
                        exports['mythic_progbar']:Progress({
                            name = "selling_drugs",
                            duration = 8000,
                            label = "Slangin Drugs...",
                            useWhileDead = false,
                            canCancel = false,
                            controlDisables = {
                                disableMovement = false,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = false,
                            },
                            }, function(status)
                            if not status then
                                local isNearPed = #(plyPos - pedPos)
                                if isNearPed <= 3 then
                                    RequestAnimDict("mp_safehouselost@")
                                    while not HasAnimDictLoaded("mp_safehouselost@") do
                                        Citizen.Wait(1)
                                    end
                                    TaskPlayAnim(plyPed, "mp_safehouselost@", "package_dropoff", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
                                    TaskPlayAnim(ped, "mp_safehouselost@", "package_dropoff", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
                                    TriggerServerEvent('scrubz_drugs_sv:endSale', drugType)
                                    Citizen.Wait(2000)
                                    StopAnimTask(plyPed, "mp_safehouselost@", "package_dropoff", 1.0)
                                    StopAnimTask(ped, "mp_safehouselost@", "package_dropoff", 1.0)
                                    Citizen.Wait(1000)
                                    FreezeEntityPosition(ped, false)
                                    ClearPedTasks(ped)
                                else
                                    exports['mythic_notify']:SendAlert('error', 'You\'re too far from the buyer!')
                                    FreezeEntityPosition(ped, false)
                                    ClearPedTasks(ped)
                                end
                            end
                        end)
                    elseif Config.UserExport then
                        -- //Add Your Export Here// --
                    end
                else
                    ClearPedTasks(ped)
                    FreezeEntityPosition(ped, false)
                    local fuckyou = math.random(1, 4)
                    if fuckyou == 1 then
                        exports['mythic_notify']:SendAlert('error', '[Cops Called] Get outa here fucc boi!', 4000)
                    elseif fuckyou == 2 then
                        exports['mythic_notify']:SendAlert('error', '[Cops Called] Drugs are bad mkay!!', 4000)
                    elseif fuckyou == 3 then
                        exports['mythic_notify']:SendAlert('error', '[Cops Called] Bruh take that shit elsewhere!', 4000)
                    elseif fuckyou == 4 then
                        exports['mythic_notify']:SendAlert('error', '[Cops Called] Fuck you!', 4000)
                    end
                    if Config.UseVisualDispatch then
                        exports['scrubz_visualdispatch']:setDispatch('drugAlert', false, true, false, false)
                    elseif Config.UseChatAlert then
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
                        streetName = GetStreetNameFromHashKey(streetName)
                        TriggerServerEvent('scrubz_drugs_sv:drugSale', streetName, plyGender)
                    elseif Config.CustomAlert then
                        -- //Add Your Alert Here// --
                    end
                end
            else
                exports['mythic_notify']:SendAlert('error', 'I\'ve already talked to you!', 3500)
            end
        else
            exports['mythic_notify']:SendAlert('error', 'You don\'t have any drugs!', 3500)
        end
    else
        exports['mythic_notify']:SendAlert('error', 'There aren\'t enough police online!', 3500)
    end
    isPlySelling = false
end)

RegisterNetEvent('scrubz_drugs_cl:chatAlert')
AddEventHandler('scrubz_drugs_cl:chatAlert', function(msg)
    if ESX.PlayerData.job.name == 'police' then
        -- Chat Message Alert Example
        TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(48, 145, 255, 0.616); border-radius: 10px;">{0}</div>',
			args = { msg }
		})
	end
end)
