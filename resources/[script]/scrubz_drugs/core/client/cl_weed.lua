---------------------------
-- Locals --
---------------------------
enableWeed = false
local props = {
    'Prop_weed_01',
    'bkr_prop_weed_lrg_01a',
    'bkr_prop_weed_lrg_01b',
    'bkr_prop_weed_med_01a',
    'bkr_prop_weed_med_01b',
    'bkr_prop_weed_01_small_01a',
    'bkr_prop_weed_01_small_01b',
    'bkr_prop_weed_01_small_01c'
}

local plantsHarvested = {}
local harvesting = false

---------------------------
-- Citizen Thread --
---------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1800000)  -- Every 30 Minutes
        plantsHarvested = {}
    end
end)

Citizen.CreateThread(function()
    while true do
        if enableWeed then
            local wait = 1000
            local plyPed = PlayerPedId()
            local plyPos = GetEntityCoords(plyPed)
            for i = 1, #props do
                local plant = GetClosestObjectOfType(plyPos, 1.0, GetHashKey(props[i]), false, false, false)
                if DoesEntityExist(plant) then
                    wait = 6
                    local plantPos = GetEntityCoords(plant)
                    if not plantsHarvested[plant] then
                        DrawText3Ds(plantPos.x, plantPos.y, plantPos.z + 1.5, 'Press ~r~[E]~w~ to harvest.')
                        if IsControlJustReleased(0, 86) then
                            plantsHarvested[plant] = true
                            FreezeEntityPosition(plyPed, true)
                            TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_BUM_BIN", 0, true)
                            if Config.UseProgressBars then
                                exports['progressBars']:startUI(5000, "Picking Weed...")
                                Citizen.Wait(5000)
                                ClearPedTasks(plyPed)
                                FreezeEntityPosition(plyPed, false)
                                TriggerServerEvent('scrubz_drugs_sv:harvestWeed')
                                print("Inserted")
                            elseif Config.UseMythicProgbar then
                                exports['mythic_progbar']:Progress({
                                    name = "pickingweed",
                                    duration = 5000,
                                    label = "Picking Weed...",
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
                                        FreezeEntityPosition(plyPed, false)
                                        TriggerServerEvent('scrubz_drugs_sv:harvestWeed')
                                        print("Inserted")
                                    end
                                end)
                            elseif Config.UserExport then
                                -- //Add Your Export Here// --
                            end
                        end
                        break
                    end
                else
                    wait = 1000
                end
            end
            Citizen.Wait(wait)
        else
            Citizen.Wait(1000)
        end
    end
end)

