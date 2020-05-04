---------------------------
-- Locals --
---------------------------
local onCooldown = false
local inProgress = false
local timeRemaining = 0
local displayWarning = false
local insideLocation1 = false
local isPlyLockpicking = false
local mRaidWarning = vector3(0, 0, 0)
local mRaidMarker = vector3(0, 0, 0)
local mPoliceInfo = {}
local mCriminalInfo = {}
local mZones = {}

--[[RegisterCommand('doors', function(source, args, raw)
    TriggerServerEvent('scrubz_drugs_sv:getDoors')
end, false)]]

local function lockpickAnimation(plyPed)
    Citizen.CreateThread(function()
        FreezeEntityPosition(plyPed, true)
        if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) then
            while not HasAnimDictLoaded("veh@break_in@0h@p_m_one@") do
                RequestAnimDict("veh@break_in@0h@p_m_one@")
                Citizen.Wait(0)
            end
            repeat
                if not IsEntityPlayingAnim(plyPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3) then
                    TaskPlayAnim(plyPed, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 1.0, 1200, 11, 0, 0, 0, 0)
                end
                Citizen.Wait(1)
            until not isPlyLockpicking
            FreezeEntityPosition(plyPed, false)
        end
    end)
end

local function robberyTimer(level)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            repeat
                if timeRemaining ~= 0 then
                    timeRemaining = timeRemaining - 1
                    Citizen.Wait(1000)
                else
                    inProgress = false
                end
            until not inProgress
            if timeRemaining ~= 0 then
                timeRemaining = 0
            end
            if insideLocation1 then
                TriggerServerEvent('scrubz_drugs_sv:raidReward', level)
                return
            else
                exports['mythic_notify']:SendAlert('error', 'You left the area!', 4000)
                return
            end
        end
    end)
end

---------------------------
-- Citizen Threads --
---------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local plyPed = GetPlayerPed(-1)
        local plyPos = GetEntityCoords(plyPed)
        local warning = #(plyPos - mRaidWarning)
        if warning <= 32 or insideLocation1 then
            if not displayWarning then
                displayWarning = true
            end
        else
            if displayWarning then
                displayWarning = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if displayWarning then
            drawOnScreen("~r~[Restricted Area] ~w~ Use of Deadly Force Authorized", 0.897, 1.45, 1.0, 1.0, 0.45, 255, 255, 255, 255)
            if inProgress then
                drawOnScreen("~r~[In Progress] ~w~Time Remaining: " .. timeRemaining .." seconds.", 0.908, 1.42, 1.0, 1.0, 0.45, 255, 255, 255, 255)
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plyPed = GetPlayerPed(-1)
        local plyPos = GetEntityCoords(plyPed)
        if not insideLocation1 then
            if isPlyPolice then
                if displayWarning then
                    for k, v in pairs(mPoliceInfo) do
                        if v.enter then
                            local isNear = #(plyPos - v.pos)
                            if isNear <= 25 then
                                DrawMarker(20, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 255, true, false, 2, true, nil, nil, false)
                                if isNear <= 2 then
                                    DrawText3Ds(v.pos.x, v.pos.y, v.pos.z, v.text)
                                    if IsControlJustPressed(1, 86) then  -- Key: E
                                        if k == 2 then
                                            insideLocation1 = true
                                            policeAssualt(plyPed, v.pos, v.teleport)
                                        else
                                            insideLocation1 = true
                                            teleportPly(plyPed, v.teleport)
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    Citizen.Wait(500)
                end
            else
                -- Not police
                if displayWarning then
                    for k, v in pairs(mCriminalInfo) do
                        if v.enter then
                            local isNear = #(plyPos - v.pos)
                            if isNear <= 25 then
                                DrawMarker(20, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 255, true, false, 2, true, nil, nil, false)
                                if isNear <= 2 then
                                    DrawText3Ds(v.pos.x, v.pos.y, v.pos.z, v.text)
                                    if IsControlJustPressed(1, 86) then  -- Key: E
                                        if Config.UseSpecialItem then
                                            TriggerServerEvent('scrubz_drugs_sv:raidItemCheck')
                                        else
                                            isPlyLockpicking = true
                                            if Config.UseProgressBars then
                                                insideLocation1 = true
                                                exports['progressBars']:startUI(5000, "Lockpicking the Door...")
                                                lockpickAnimation(plyPed)
                                                Citizen.Wait(5000)
                                                isPlyLockpicking = false
                                                Citizen.Wait(500)
                                                teleportPly(plyPed, v.teleport)
                                            elseif Config.UseMythicProgbar then
                                                insideLocation1 = true
                                                lockpickAnimation(plyPed)
                                                exports['mythic_progbar']:Progress({
                                                    name = "lockpicking",
                                                    duration = 5000,
                                                    label = "Lockpicking the Door...",
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
                                                        isPlyLockpicking = false
                                                        Citizen.Wait(500)
                                                        teleportPly(plyPed, v.teleport)
                                                    end
                                                end)
                                            elseif Config.UserExport then
                                                -- //Add Your Export Here// --
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    Citizen.Wait(500)
                end
            end
        else
            -- Inside
            if isPlyPolice then
                for k, v in pairs(mPoliceInfo) do
                    if not v.enter then
                        local isNear = #(plyPos - v.pos)
                        if isNear <= 15 then
                            DrawMarker(20, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 255, true, false, 2, true, nil, nil, false)
                            if isNear <= 2 then
                                DrawText3Ds(v.pos.x, v.pos.y, v.pos.z, v.text)
                                if IsControlJustPressed(1, 86) then  -- Key: E
                                    insideLocation1 = false
                                    teleportPly(plyPed, v.teleport)
                                end
                            end
                        end
                    end
                end
            else
                -- Not police
                for k, v in pairs(mCriminalInfo) do
                    if not v.enter then
                        local isNear = #(plyPos - v.pos)
                        if isNear <= 15 then
                            DrawMarker(20, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 255, true, false, 2, true, nil, nil, false)
                            if isNear <= 2 then
                                DrawText3Ds(v.pos.x, v.pos.y, v.pos.z, v.text)
                                if IsControlJustPressed(1, 86) then  -- Key: E
                                    if v.teleport == nil then
                                        crimEgress(plyPed)
                                        insideLocation1 = false
                                        inProgress = false
                                    else
                                        teleportPly(plyPed, v.teleport)
                                        insideLocation1 = false
                                        inProgress = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plyPed = GetPlayerPed(-1)
        local plyPos = GetEntityCoords(plyPed)
        if not isPlyPolice then
            if not onCooldown then
                if insideLocation1 then
                    local drawMarker = #(plyPos - mRaidMarker)
                    if drawMarker <= 10 then
                        DrawMarker(29, mRaidMarker.x, mRaidMarker.y, mRaidMarker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, false, false, 2, true, nil, nil, false)
                        if drawMarker <= 2 then
                            infoText()
                            if IsControlJustPressed(1, 86) then  -- Key: E
                                exports['mythic_notify']:SendAlert('success', 'Class 1 Selected!', 6000)
                                exports['mythic_notify']:SendAlert('inform', 'Don\'t leave the building until the raid is over!', 6000)
                                TriggerServerEvent('scrubz_drugs_sv:startRobbery')
                                inProgress = true
                                robberyTimer(class1)
                                timeRemaining = Config.RaidTimer
                            elseif IsControlJustPressed(1, 74) then  -- Key: H
                                exports['mythic_notify']:SendAlert('success', 'Class 2 Selected!', 6000)
                                exports['mythic_notify']:SendAlert('inform', 'Don\'t leave the building until the raid is over!', 6000)
                                TriggerServerEvent('scrubz_drugs_sv:startRobbery')
                                inProgress = true
                                robberyTimer(class2)
                                timeRemaining = Config.RaidTimer
                            end
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                if insideLocation1 then
                    for k, v in pairs(mZones) do
                        local dist = #(plyPos - v.pos)
                        if inProgress then
                            if not v.isSearched then
                                if dist <= 10 then
                                    DrawMarker(27, v.pos.x, v.pos.y, v.pos.z - 0.95 , 0, 0, 0, 0, 0, 0, 0.351, 0.3501, 0.5001, 0, 200, 0, 255, 0, 0, 0, 0)
                                    if dist <= 2 then
                                        DrawText3Ds(v.pos.x, v.pos.y, v.pos.z, 'Press ~g~[E]~s~ Search')
                                        if IsControlJustPressed(1, 86) then
                                            FreezeEntityPosition(plyPed, true)
                                            RequestAnimDict("mini@repair")
                                            while not HasAnimDictLoaded("mini@repair") do
                                                Citizen.Wait(1)
                                            end
                                            TaskPlayAnim(plyPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 49, 0, 0, 0, 0)
                                            if Config.UseProgressBars then
                                                exports['progressBars']:startUI(4500, "Searching...")
                                                Citizen.Wait(4500)
                                                FreezeEntityPosition(plyPed, false)
                                                v.isSearched = true
                                                ClearPedTasks(plyPed)
                                                TriggerServerEvent('scrubz_drugs_sv:searchReward')
                                            elseif Config.UseMythicProgbar then
                                                exports['mythic_progbar']:Progress({
                                                    name = "searching",
                                                    duration = 4500,
                                                    label = "Searching...",
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
                                                        v.isSearched = true
                                                        FreezeEntityPosition(plyPed, false)
                                                        ClearPedTasks(plyPed)
                                                        TriggerServerEvent('scrubz_drugs_sv:searchReward')
                                                    end
                                                end)
                                            elseif Config.UserExport then
                                                -- //Add Your Export Here// --
                                            end
                                        end
                                    end
                                end
                            else
                                if dist <= 10 then
                                    DrawMarker(27, v.pos.x, v.pos.y, v.pos.z - 0.95 , 0, 0, 0, 0, 0, 0, 0.351, 0.3501, 0.5001, 200, 0, 0, 255, 0, 0, 0, 0)
                                    if dist <= 2 then
                                        DrawText3Ds(v.pos.x, v.pos.y, v.pos.z, '~r~Empty~s~')
                                    end
                                end
                            end
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

---------------------------
-- Event Handlers --
---------------------------
RegisterNetEvent('scrubz_drugs_cl:setRaidLocations')
AddEventHandler('scrubz_drugs_cl:setRaidLocations', function(table1, table2, table3, location1, location2)
    mPoliceInfo = table1
    mCriminalInfo = table2
    mZones = table3
    mRaidWarning = location1
    mRaidMarker = location2
end)

RegisterNetEvent('scrubz_drugs_cl:startLockpick')
AddEventHandler('scrubz_drugs_cl:startLockpick', function()
    local plyPed = GetPlayerPed(-1)
    if Config.UseProgressBars then
        isPlyLockpicking = true
        exports['progressBars']:startUI(15000, "Lockpicking the Door...")
        lockpickAnimation(plyPed)
        Citizen.Wait(15000)
        isPlyLockpicking = false
        for k, v in pairs(mCriminalInfo) do
            if v.enter then
                teleportPly(plyPed, v.teleport)
                insideLocation1 = true
            end
        end
    elseif Config.UseMythicProgbar then
        isPlyLockpicking = true
        lockpickAnimation(plyPed)
        exports['mythic_progbar']:Progress({
            name = "lockpicking",
            duration = 15000,
            label = "Lockpicking the Door...",
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
                isPlyLockpicking = false
                for k, v in pairs(mCriminalInfo) do
                    if v.enter then
                        teleportPly(plyPed, v.teleport)
                        insideLocation1 = true
                    end
                end
            end
        end)
    elseif Config.UserExport then
        -- //Add Your Export Here// --
    end
end)

RegisterNetEvent('scrubz_drugs_cl:setStatus')
AddEventHandler('scrubz_drugs_cl:setStatus', function(cooldown)
    if cooldown then
        onCooldown = true
        local msg = '[ALERT] Morgue Robbery In Progress'
        if isPlyPolice then
            if Config.UseVisualDispatch then
                exports['scrubz_visualdispatch']:setDispatch('morgueAlert', false, true, false, false)
            elseif Config.UseChatAlert then
                -- Chat Message Alert Example
                TriggerEvent('chat:addMessage', {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(48, 145, 255, 0.616); border-radius: 10px;">{0}</div>',
                    args = { msg }
                })
            elseif Config.CustomAlert then
                -- //Add Your Alert Here// --
            end
        end
    else
        onCooldown = false
        for k, v in pairs(mZones) do
            if v.isSearched then
                v.isSearched = false
            end
        end
    end
end)