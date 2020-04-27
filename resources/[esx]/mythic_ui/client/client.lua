local x = 1.000
local y = 1.000

local hunger = -1
local thrist = -1
local inCar = false
local showUi = false
local prevSpeed = 0
local currSpeed = 0.0
local cruiseSpeed = 999.0
local engineIsOn = false
local engineInput = 183
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}

local cruiseIsOn = false
local seatbeltEjectSpeed = 45               -- Speed threshold to eject player (MPH)
local seatbeltEjectAccel = 100              -- Acceleration threshold to eject player (G's)
local voice = {default = 7.0, shout = 16.0, whisper = 1.0, current = 0, level = nil}

--[[ =========================================================================================================================== ]]--
--[[ =========================================================================================================================== ]]--
--[[ =========================================================================================================================== ]]--
--[[ =========================================================================================================================== ]]--
--[[ =========================================================================================================================== ]]--

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}

    if hour <= 12 then
        obj.ampm = 'AM'
    elseif hour >= 13 then
        obj.ampm = 'PM'
        hour = hour - 12
    end
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function getCardinalDirectionFromHeading(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "NB" -- North
    elseif (heading >= 45 and heading < 135) then
        return "EB" -- East
    elseif (heading >=135 and heading < 225) then
        return "SB" -- South
    elseif (heading >= 225 and heading < 315) then
        return "WB" -- West
    end
end

AddEventHandler('onClientMapStart', function()
    if voice.current == 0 then
      NetworkSetTalkerProximity(voice.default)
    elseif voice.current == 1 then
      NetworkSetTalkerProximity(voice.shout)
    elseif voice.current == 2 then
      NetworkSetTalkerProximity(voice.whisper)
    end  
end)

function UIStuff()
    Citizen.CreateThread(function()
        while showUi do
            SendNUIMessage({
                action = 'tick',
                show = IsPauseMenuActive(),
                health = (GetEntityHealth(GetPlayerPed(-1))-100),
                armor = (GetPedArmour(GetPlayerPed(-1))),
                stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
            })
            prevSpeed = currSpeed
            currSpeed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1)))
            local speed = currSpeed * 2.237
            SendNUIMessage({
                action = 'update-speed',
                speed = math.ceil(speed)
            })

            local time = CalculateTimeToDisplay()

            SendNUIMessage({
                action = 'update-clock',
                time = time.hour .. ':' .. time.minute,
                ampm = time.ampm
            })

            if NetworkIsPlayerTalking(PlayerId(-1)) then
                SendNUIMessage({
                    action = 'voice-color',
                    isTalking = true
                })
            else
                SendNUIMessage({
                    action = 'voice-color',
                    isTalking = false
                })
            end

            local heading = getCardinalDirectionFromHeading(GetEntityHeading(GetPlayerPed(-1)))
            local pos = GetEntityCoords(PlayerPedId())
            local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

            SendNUIMessage({
                action = 'update-position',
                direction = heading,
                street1 = GetStreetNameFromHashKey(var1),
                street2 = GetStreetNameFromHashKey(var2),
                area = current_zone
            })

            Citizen.Wait(200)
        end
    end)
    
    Citizen.CreateThread(function()
        while showUi do
            Citizen.Wait(1)
            HideHudComponentThisFrame( 7 ) -- Area Name
            HideHudComponentThisFrame( 9 ) -- Street Name
            SetPedHelmet(GetPlayerPed(-1), false)

            
            if IsControlJustPressed(1, 74) and IsControlPressed(1, 21) then
                voice.current = (voice.current + 1) % 3
                if voice.current == 0 then
                    NetworkSetTalkerProximity(voice.default)
                    SendNUIMessage({
                        action = 'set-voice',
                        value = 66
                    })
                elseif voice.current == 1 then
                    NetworkSetTalkerProximity(voice.shout)
                    SendNUIMessage({
                        action = 'set-voice',
                        value = 100
                    })
                elseif voice.current == 2 then
                    NetworkSetTalkerProximity(voice.whisper)
                    SendNUIMessage({
                        action = 'set-voice',
                        value = 33
                    })
                end
            end

            if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                DisplayRadar(true)
                if not inCar then
                    SendNUIMessage({
                        action = 'showcar'
                    })
                    inCar = true
                end

                if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    if IsControlJustReleased(0, 29) then
                        local vehClass = GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1)))
                        if vehClass ~= 8 and vehClass ~= 13 and vehClass ~= 14 then
                            if seatbeltIsOn then
                                exports['mythic_notify']:DoHudText('inform', 'Seatbelt Off')
                            else
                                exports['mythic_notify']:DoHudText('inform', 'Seatbelt On')
                            end
                            seatbeltIsOn = not seatbeltIsOn
                            SendNUIMessage({
                                action = 'toggle-seatbelt'
                            })
                        elseif seatbeltIsOn then
                            SendNUIMessage({
                                action = 'set-seatbelt',
                                seatbelt = false
                            })
                            seatbeltIsOn = false
                        end
                    end
                    
                    if not seatbeltIsOn then
                        -- Eject PED when moving forward, vehicle was going over 45 MPH and acceleration over 100 G's
                        local vehIsMovingFwd = GetEntitySpeedVector(GetVehiclePedIsIn(GetPlayerPed(-1)), true).y > 1.0
                        local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                        local position = GetEntityCoords(GetPlayerPed(-1))
                        if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
                            SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z - 0.47, true, true, true)
                            SetEntityVelocity(GetPlayerPed(-1), prevVelocity.x, prevVelocity.y, prevVelocity.z)
                            Citizen.Wait(1)
                            SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
                        else
                            -- Update previous velocity for ejecting player
                            prevVelocity = GetEntityVelocity(GetVehiclePedIsIn(GetPlayerPed(-1)))
                        end
                        else
                            DisableControlAction(0, 75)
                    end

                    -- Engine toggle when ped is in vehicle
					if (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1)) then
						if IsControlJustReleased(0, engineInput) then
							engineIsOn = not engineIsOn
							toggleEngine()
						end
						if currSpeed > 10.0 then
							DisableControlAction(0, engineInput)
						end
					end
			
					function toggleEngine()
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
						if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
							SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
						end
					end
    
                    -- When player in driver seat, handle cruise control
                    if (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1)) then
                        -- Check if cruise control button pressed, toggle state and set maximum speed appropriately
                        if IsControlJustReleased(0, 137) then
                            if cruiseIsOn then
                                exports['mythic_notify']:DoHudText('inform', 'Cruise Disabled')
                            else
                                exports['mythic_notify']:DoHudText('inform', 'Cruise Activated')
                            end

                            cruiseIsOn = not cruiseIsOn
                            SendNUIMessage({
                                action = 'toggle-cruise'
                            })
                            cruiseSpeed = currSpeed
                        end
                        local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1)),"CHandlingData","fInitialDriveMaxFlatVel")
                        SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1)), maxSpeed)
                    elseif cruiseIsOn then
                        -- Reset cruise control
                            SendNUIMessage({
                                action = 'set-cruise',
                                seatbelt = false
                            })
                        cruiseIsOn = false
                    end
                end
            else
                DisplayRadar(false)

                if inCar then
                    seatbeltIsOn = false
                    cruiseIsOn = false
                    engineIsOn = false
                    SendNUIMessage({
                        action = 'hidecar'
                    })
                    inCar = false
                end
            end
        end
    end)
    
    Citizen.CreateThread(function()
        while showUi do
            Citizen.Wait(1)
            if DecorExistOn(GetPlayerPed(-1), 'player_hunger') and DecorExistOn(GetPlayerPed(-1), 'player_thirst') then
                if hunger ~= DecorGetInt(GetPlayerPed(-1), 'player_hunger') or thirst ~= DecorGetInt(GetPlayerPed(-1), 'player_thirst') then
                    hunger = DecorGetInt(GetPlayerPed(-1), 'player_hunger')
                    thirst = DecorGetInt(GetPlayerPed(-1), 'player_thirst')
                    updateStatus(hunger, thirst)
                    Citizen.Wait(50000)
                else
                    Citizen.Wait(30000)
                end
            end
        end
    end)
    
    Citizen.CreateThread(function()
        while showUi do
            Citizen.Wait(1)
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if DecorExistOn(GetVehiclePedIsIn(GetPlayerPed(-1)), '_FUEL_LEVEL') then
                    SendNUIMessage({
                        action = 'update-fuel',
                        fuel = math.ceil(round(exports['LegacyFuel']:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1)))))
                    })
                    Citizen.Wait(60000)
                end
            end
        end
    end)
end

RegisterNetEvent('mythic_ui:client:UpdateStatus')
AddEventHandler('mythic_ui:client:UpdateStatus', function(Status)
    status = Status
    SendNUIMessage({
        action = "updateStatus",
        st = Status,
    })
end)

RegisterNetEvent('mythic_ui:client:UpdateFuel')
AddEventHandler('mythic_ui:client:UpdateFuel', function(veh)
    if DecorExistOn(veh, '_FUEL_LEVEL') then
        SendNUIMessage({
            action = 'update-fuel',
            fuel = math.ceil(round(exports['LegacyFuel']:GetFuel(veh)))
        })
    end
end)

RegisterNetEvent('mythic_ui:client:DisplayUI')
AddEventHandler('mythic_ui:client:DisplayUI', function()
    SendNUIMessage({
        action = 'showui'
    })
    UIStuff()
    showUi = true
end)

RegisterNetEvent('mythic_ui:client:HideUI')
AddEventHandler('mythic_ui:client:HideUI', function()
    SendNUIMessage({
        action = 'hideui'
    })
    showUi = false
end)