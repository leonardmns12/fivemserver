ESX = nil

local a = nil

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function ()
    while true do
    	Citizen.Wait(0)
        local getPlayerPosition = GetEntityCoords(GetPlayerPed(-1), true)
        if ESX ~= nil then
            if GetDistanceBetweenCoords(getPlayerPosition.x, getPlayerPosition.y, getPlayerPosition.z, 455.28, -999.7, 34.50, true) < 2.5 then
           DrawText3D(455.28, -999.7, 35.93, 'Tekan [~g~E~w~] untuk membuat SIM')
                if IsControlJustReleased(0, 38) then
                OpenLicenseHarvestMenu()
                end
            end
        end
    end
end)

function OpenLicenseHarvestMenu()
    if ESX.PlayerData.job then
        local elements = {
            {label = 'Sim A',  value = 'license_A'},
            {label = 'Sim C',  value = 'license_B'}
        }

        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Cetak_SIM', {
			title    = 'Print SIM',
			align    = 'top-left',
			elements = elements
        },
            function(data, menu)
			menu.close()

            if data.current.value == 'license_A' then
                a = 1
                TriggerServerEvent('harvestSim:startHarvestLicenseA', a)
            elseif data.current.value == 'license_B' then
                a = 2
                TriggerServerEvent('harvestSim:startHarvestLicenseA', a)
            end
			
		end,
		function(data, menu)
                menu.close()
    
        end)
    end
end

DrawText3D = function(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    --DrawText(_x,_y)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    --DrawRect(_x,_y+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
    ClearDrawOrigin()
end