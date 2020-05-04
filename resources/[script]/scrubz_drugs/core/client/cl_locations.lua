---------------------------
-- Locals --
---------------------------
local drugLocations = {}
local drugPackaging = {}
local insideDrugLocation = false
local disableText = false
local displayText = false

---------------------------
-- Citizen Threads --
---------------------------
-- Teleports
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local plyPed = GetPlayerPed(-1)
        local plyPos = GetEntityCoords(plyPed)
        if not insideDrugLocation then
            for k, v in pairs(drugLocations) do
                local enable = #(plyPos - v.pos)
                if enable <= 25 then
                    if not displayText then
                        displayText = true
                        return
                    end
                end
                local disable = #(plyPos - v.pos)
                if disable >= 26 then
                    if displayText then
                        displayText = false
                        return
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.UseLocationExtras then
            local plyPed = GetPlayerPed(-1)
            local plyPos = GetEntityCoords(plyPed)
            if not insideDrugLocation and displayText then
                for k, v in pairs(drugLocations) do
                    if v.enter or v.enter == nil then
                        local isNear = #(plyPos - v.pos)
                        if isNear <= 2 then
                            drawOnScreen(v.text, 0.920, 1.45, 1.0, 1.0, 0.45, 255, 255, 255, 255)
                            if IsControlJustPressed(0, 38) then  -- Key: E
                                if v.id == 'weedEnter' then
                                    teleportPly(plyPed, v.teleport)
                                    insideDrugLocation = true
                                    enableWeed = true
                                elseif v.id == 'cokeTheft' then
                                    stealCocaine()
                                else
                                    teleportPly(plyPed, v.teleport)
                                    insideDrugLocation = true
                                end
                            end
                        end
                    end
                end
            else
                for k, v in pairs(drugLocations) do
                    if not v.enter then
                        local isNear = #(plyPos - v.pos)
                        if isNear <= 2 then
                            drawOnScreen(v.text, 0.920, 1.45, 1.0, 1.0, 0.45, 255, 255, 255, 255)
                            if IsControlJustPressed(0, 38) then  -- Key: E
                                if v.id == 'weedExit' then
                                    teleportPly(plyPed, v.teleport)
                                    insideDrugLocation = false
                                    enableWeed = false
                                else
                                    teleportPly(plyPed, v.teleport)
                                    insideDrugLocation = false
                                end
                            end
                        end
                    end
                end
                for k, v in pairs(drugPackaging) do
                    if not isPlyPolice then
                        if not disableText then
                            local isNear = #(plyPos - v.pos)
                            if isNear <= 3 then
                                drawOnScreen(v.text, 0.920, 1.45, 1.0, 1.0, 0.45, 255, 255, 255, 255)
                                if IsControlJustPressed(0, 38) then  -- Key: E
                                    if v.id == 'pCoke' then
                                        TriggerServerEvent('scrubz_drugs_sv:packageCocaine')
                                        disableText = true
                                    elseif v.id == 'pMeth' then
                                        TriggerServerEvent('scrubz_drugs_sv:packageMeth')
                                        disableText = true
                                    elseif v.id == 'pCrack' then
                                        TriggerServerEvent('scrubz_drugs_sv:packageCrack')
                                        disableText = true
                                    elseif v.id == 'cMeth' then
                                        TriggerServerEvent('scrubz_drugs_sv:produceMeth')
                                        disableText = true
                                    elseif v.id == 'cCrack' then
                                        TriggerServerEvent('scrubz_drugs_sv:produceCrack')
                                        disableText = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
        Citizen.Wait(1000)
        end
    end
end)

---------------------------
-- Event Handlers --
--------------------------
-- Set Various Vectors
RegisterNetEvent('scrubz_drugs_cl:assignVectors')
AddEventHandler('scrubz_drugs_cl:assignVectors', function(table1, table2)
    drugLocations = table1
    drugPackaging = table2
end)

RegisterNetEvent('scrubz_drugs_cl:packageCocaine')
AddEventHandler('scrubz_drugs_cl:packageCocaine', function(package)
    if package then
        local plyPed = GetPlayerPed(-1)
        while not HasAnimDictLoaded("mp_safehouselost@") do
            RequestAnimDict("mp_safehouselost@")
            Citizen.Wait(5)
        end
        FreezeEntityPosition(plyPed, true)
        TaskPlayAnim(plyPed, "mp_safehouselost@", "package_dropoff", 5.0, 1.0, -1, 48, 0, 0, 0, 0)
        if Config.UseProgressBars then
            exports['progressBars']:startUI(5000, "Bagging up some coke...")
            Citizen.Wait(5000)
            StopAnimTask(plyPed, "mp_safehouselost@", "package_dropoff", 1.0)
            Citizen.Wait(1000)
            FreezeEntityPosition(plyPed, false)
            disableText = false
            exports['mythic_notify']:SendAlert('success', '1g of Coke Bagged!', 3500)
        elseif Config.UseMythicProgbar then
            exports['mythic_progbar']:Progress({
                name = "packaging_coke",
                duration = 5000,
                label = "Bagging up some coke...",
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
                    StopAnimTask(plyPed, "mp_safehouselost@", "package_dropoff", 1.0)
                    Citizen.Wait(1000)
                    FreezeEntityPosition(plyPed, false)
                    disableText = false
                    exports['mythic_notify']:SendAlert('success', '1g of Coke Bagged!', 3500)
                end
            end)
        elseif Config.UserExport then
            -- //Add Your Export Here// --
        end
    else
        disableText = false
    end
end)

RegisterNetEvent('scrubz_drugs_cl:produceMeth')
AddEventHandler('scrubz_drugs_cl:produceMeth', function(produce)
    if produce then
        local plyPed = GetPlayerPed(-1)
        FreezeEntityPosition(plyPed, true)
        TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_BUM_BIN", 0, true)
        if Config.UseProgressBars then
            exports['progressBars']:startUI(15000, "Cooking up some meth...")
            Citizen.Wait(15000)
            ClearPedTasks(plyPed)
            Citizen.Wait(1000)
            FreezeEntityPosition(plyPed, false)
            disableText = false
            exports['mythic_notify']:SendAlert('success', 'Raw Meth Produced!', 3500)
        elseif Config.UseMythicProgbar then
            exports['mythic_progbar']:Progress({
                name = "packaging_coke",
                duration = 5000,
                label = "Bagging up some coke...",
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
                    ClearPedTasks(plyPed)
                    Citizen.Wait(1000)
                    FreezeEntityPosition(plyPed, false)
                    disableText = false
                    exports['mythic_notify']:SendAlert('success', 'Raw Meth Produced!', 3500)
                end
            end)
        elseif Config.UserExport then
            -- //Add Your Export Here// --
        end
    else
        disableText = false
    end
end)

RegisterNetEvent('scrubz_drugs_cl:packageMeth')
AddEventHandler('scrubz_drugs_cl:packageMeth', function(package)
    if package then
        local plyPed = GetPlayerPed(-1)
        FreezeEntityPosition(plyPed, true)
        while not HasAnimDictLoaded("mp_safehouselost@") do
            RequestAnimDict("mp_safehouselost@")
            Citizen.Wait(5)
        end
        TaskPlayAnim(plyPed, "mp_safehouselost@", "package_dropoff", 5.0, 1.0, -1, 48, 0, 0, 0, 0)
        if Config.UseProgressBars then
            exports['progressBars']:startUI(5000, "Bagging up some meth...")
            Citizen.Wait(5000)
            StopAnimTask(plyPed, "mp_safehouselost@", "package_dropoff", 1.0)
            Citizen.Wait(1000)
            FreezeEntityPosition(plyPed, false)
            disableText = false
            exports['mythic_notify']:SendAlert('success', '1g of Meth Bagged!', 3500)
        elseif Config.UseMythicProgbar then
            exports['mythic_progbar']:Progress({
                name = "packaging_coke",
                duration = 5000,
                label = "Bagging up some coke...",
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
                    StopAnimTask(plyPed, "mp_safehouselost@", "package_dropoff", 1.0)
                    Citizen.Wait(1000)
                    FreezeEntityPosition(plyPed, false)
                    disableText = false
                    exports['mythic_notify']:SendAlert('success', '1g of Meth Bagged!', 3500)
                end
            end)
        elseif Config.UserExport then
            -- //Add Your Export Here// --
        end
    else
        disableText = false
    end
end)

RegisterNetEvent('scrubz_drugs_cl:produceCrack')
AddEventHandler('scrubz_drugs_cl:produceCrack', function(produce)
    if produce then
        local plyPed = GetPlayerPed(-1)
        FreezeEntityPosition(plyPed, true)
        TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_BUM_BIN", 0, true)
        if Config.UseProgressBars then
            exports['progressBars']:startUI(15000, "Cooking up some crack...")
            Citizen.Wait(15000)
            ClearPedTasks(plyPed)
            Citizen.Wait(1000)
            FreezeEntityPosition(plyPed, false)
            exports['mythic_notify']:SendAlert('success', 'Raw Crack Produced!', 3500)
            disableText = false
        elseif Config.UseMythicProgbar then
            exports['mythic_progbar']:Progress({
                name = "packaging_coke",
                duration = 5000,
                label = "Bagging up some coke...",
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
                    ClearPedTasks(plyPed)
                    Citizen.Wait(1000)
                    FreezeEntityPosition(plyPed, false)
                    exports['mythic_notify']:SendAlert('success', 'Raw Crack Produced!', 3500)
                    disableText = false
                end
            end)
        elseif Config.UserExport then
            -- //Add Your Export Here// --
        end
    else
        disableText = false
    end
end)

RegisterNetEvent('scrubz_drugs_cl:packageCrack')
AddEventHandler('scrubz_drugs_cl:packageCrack', function(package)
    if package then
        local plyPed = GetPlayerPed(-1)
        FreezeEntityPosition(plyPed, true)
        while not HasAnimDictLoaded("mp_safehouselost@") do
            RequestAnimDict("mp_safehouselost@")
            Citizen.Wait(5)
        end
        TaskPlayAnim(plyPed, "mp_safehouselost@", "package_dropoff", 5.0, 1.0, -1, 48, 0, 0, 0, 0)
        if Config.UseProgressBars then
            exports['progressBars']:startUI(5000, "Bagging up some crack...")
            Citizen.Wait(5000)
            StopAnimTask(plyPed, "mp_safehouselost@", "package_dropoff", 1.0)
            Citizen.Wait(1000)
            FreezeEntityPosition(plyPed, false)
            disableText = false
            exports['mythic_notify']:SendAlert('success', '1g of Crack Bagged!', 3500)
        elseif Config.UseMythicProgbar then
            exports['mythic_progbar']:Progress({
                name = "packaging_coke",
                duration = 5000,
                label = "Bagging up some coke...",
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
                    StopAnimTask(plyPed, "mp_safehouselost@", "package_dropoff", 1.0)
                    Citizen.Wait(1000)
                    FreezeEntityPosition(plyPed, false)
                    disableText = false
                    exports['mythic_notify']:SendAlert('success', '1g of Crack Bagged!', 3500)
                end
            end)
        elseif Config.UserExport then
            -- //Add Your Export Here// --
        end
    else
        disableText = false
    end
end)
