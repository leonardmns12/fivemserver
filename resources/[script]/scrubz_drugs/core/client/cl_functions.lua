---------------------------
-- Functions --
---------------------------
local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
}

local function enumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function enumeratePeds()
    return enumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end

function drawOnScreen(text, x, y, width, height, scale, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function animStart(ply, ped)
    TaskPlayAnim(ply, "mp_safehouselost@", "package_dropoff", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
    TaskPlayAnim(ped, "mp_safehouselost@", "package_dropoff", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
end

function animEnd(ply, ped)
    StopAnimTask(ply, "mp_safehouselost@", "package_dropoff", 1.0)
    StopAnimTask(ped, "mp_safehouselost@", "package_dropoff", 1.0)
    Citizen.Wait(1000)
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
end

function drawInfo(hint, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
end

function teleportPly(plyPed, location)
    FreezeEntityPosition(plyPed, true)
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    SetEntityVisible(plyPed, false)
    SetEntityCoords(plyPed, location)
    Citizen.Wait(1000)
    FreezeEntityPosition(plyPed, false)
    Citizen.Wait(500)
    SetEntityVisible(plyPed, true)
    DoScreenFadeIn(500)
    Citizen.Wait(500)
end

function infoText()
    SetTextComponentFormat("STRING")
    AddTextComponentString("Press ~INPUT_VEH_HORN~ for Class 1~n~Press ~INPUT_VEH_HEADLIGHT~ for Class 2")  -- [E] Class 1 - [H] Class 2
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function doMythicProgbar(plyPed)
    exports['mythic_progbar']:Progress({
        name = "lightheaded",
        duration = 19000,
        label = "Lightheaded...",
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
            ResetPedMovementClipset(plyPed, 0)
            ClearTimecycleModifier()
            SetPedIsDrunk(plyPed, false)
            SetPedMotionBlur(plyPed, false)
            --ResetScenarioTypesEnabled()
        end
    end)
end

function crimEgress(plyPed)
    local getfucked = math.random(1, 10)
    while not HasAnimDictLoaded("missheist_jewel") do
        RequestAnimDict("missheist_jewel")
        Citizen.Wait(0)
    end
    SetEntityHeading(plyPed, 130.17)
    TaskPlayAnim(plyPed, "missheist_jewel", "smash_case", 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(2500)
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    while not HasAnimDictLoaded("misslamar1dead_body") do
        RequestAnimDict("misslamar1dead_body")
        Citizen.Wait(0)
    end
    TaskPlayAnimAdvanced(plyPed, "misslamar1dead_body", "dead_idle", 234.25, -1356.08, 31.98, 5.0, 105.0, 100.0, 5.0, 1.0, -1, 2, 0, 0, 0, 0)
    Citizen.Wait(500)
    DoScreenFadeIn(500)
    Citizen.Wait(1500)
    ClearPedTasks(plyPed)
    if getfucked <= 1 then -- 3
        Citizen.Wait(500)
        exports['mythic_notify']:SendAlert('inform', 'You hit your head and passed out!', 3000)
        SetEntityHealth(plyPed, 0)
    elseif getfucked <= 2 then -- 7
        Citizen.Wait(500)
        exports['mythic_notify']:SendAlert('inform', 'You almost didn\'t stick your landing!', 3000)
        ApplyDamageToPed(plyPed, 20, false)
    else
        if Config.UseProgressBars then
            Citizen.Wait(500)
            while not HasAnimSetLoaded("move_injured_generic") do
                RequestAnimSet("move_injured_generic")
                Citizen.Wait(0)
            end
            SetPedMovementClipset(plyPed, "move_injured_generic", 1.0)
            SetTimecycleModifier("Drug_deadman")
            SetPedIsDrunk(plyPed, true)
            SetPedMotionBlur(plyPed, true)
            exports['mythic_notify']:SendAlert('inform', 'You hit your head and almost passed out!', 3000)
            exports['progressBars']:startUI(19000, "Lightheaded...")
            Citizen.Wait(4000)
            SetPedToRagdoll(plyPed, 3000, 3000, 0, 0, 0, 0)
            print("Ragdoll 1")
            Citizen.Wait(6000)
            SetPedToRagdoll(plyPed, 3000, 3000, 0, 0, 0, 0)
            print("Ragdoll 2")
            Citizen.Wait(6000)
            SetPedToRagdoll(plyPed, 3000, 3000, 0, 0, 0, 0)
            print("Ragdoll 3")
            Citizen.Wait(3000)
            ResetPedMovementClipset(plyPed, 0)
            ClearTimecycleModifier()
            SetPedIsDrunk(plyPed, false)
            SetPedMotionBlur(plyPed, false)
            --ResetScenarioTypesEnabled()
        elseif Config.UseMythicProgbar then
            Citizen.Wait(500)
            while not HasAnimSetLoaded("move_injured_generic") do
                RequestAnimSet("move_injured_generic")
                Citizen.Wait(0)
            end
            SetPedMovementClipset(plyPed, "move_injured_generic", 1.0)
            SetTimecycleModifier("Drug_deadman")
            SetPedIsDrunk(plyPed, true)
            SetPedMotionBlur(plyPed, true)
            exports['mythic_notify']:SendAlert('inform', 'You hit your head and almost passed out!', 3000)
            doMythicProgbar(plyPed)
            Citizen.Wait(4000)
            SetPedToRagdoll(plyPed, 3000, 3000, 0, 0, 0, 0)
            print("Ragdoll 1")
            Citizen.Wait(6000)
            SetPedToRagdoll(plyPed, 3000, 3000, 0, 0, 0, 0)
            print("Ragdoll 2")
            Citizen.Wait(6000)
            SetPedToRagdoll(plyPed, 3000, 3000, 0, 0, 0, 0)
            print("Ragdoll 3")
            Citizen.Wait(3000)
        elseif Config.UserExport then
            -- //Add Your Export Here// --
        end
    end
end

function policeAssualt(plyPed, outside, inside)
    while not HasAnimDictLoaded("missrappel") do
        RequestAnimDict("missrappel")
        Citizen.Wait(5)
    end
    while not HasAnimDictLoaded("mp_common_heist") do
        RequestAnimDict("mp_common_heist")
        Citizen.Wait(5)
    end
    SetEntityCoords(plyPed, outside.x, outside.y, outside.z - 1)
    SetEntityHeading(plyPed, 315.74)
    Citizen.Wait(500)
    FreezeEntityPosition(plyPed, true)
    local pedPos = GetEntityCoords(plyPed)
    local rope = AddRope(pedPos.x, pedPos.y - 0.1, pedPos.z + 12, 0.0, 0.0, 0.0, 20.0, 4, 20.0, 1.0 ,0.0, false, false, false, 5.0, false)
    Citizen.Wait(3000)
    SetEntityCoords(plyPed, outside)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(1500)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 1, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 1.5, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 2, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 2.5, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 3, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 3.5, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 4, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 4.5, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 5, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 5.5, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 6, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 6.5, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 7, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 7.5, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 8, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 8.5, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "missrappel", "rappel_walk", pedPos.x, pedPos.y - 0.44, pedPos.z + 9, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(700)
    TaskPlayAnimAdvanced(plyPed, "mp_common_heist", "enter_window", pedPos.x, pedPos.y - 0.44, pedPos.z + 9, 0, 0, 0, 5.0, 1.0, -1, 1, 0, 0, 0, 0)
    Citizen.Wait(1500)
    ClearPedTasks(plyPed)
    teleportPly(plyPed, inside)
    DeleteRope(rope)
end

function stealCocaine()
    local plyPed = GetPlayerPed(-1)
    FreezeEntityPosition(plyPed, true)
    TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_BUM_BIN", 0, true)
    if Config.UseProgressBars then
        exports['progressBars']:startUI(5000, "Stealing some cocaine...")
        Citizen.Wait(5000)
        ClearPedTasks(plyPed)
        Citizen.Wait(500)
        FreezeEntityPosition(plyPed, false)
        TriggerServerEvent('scrubz_drugs_sv:addCoke')
    elseif Config.UseMythicProgbar then
        exports['mythic_progbar']:Progress({
            name = "coketheft",
            duration = 5000,
            label = "Stealing some cocaine...",
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
                Citizen.Wait(500)
                FreezeEntityPosition(plyPed, false)
                TriggerServerEvent('scrubz_drugs_sv:addCoke')
            end
        end)
    elseif Config.UserExport then
        -- //Add Your Export Here// --
    end
end