ESX = nil

Citizen.CreateThread(function ()
    while ESX == nil do
          TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
          Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
        local pos = GetEntityCoords(GetPlayerPed(-1) , true)
        
        if ESX ~= nil then
                    if GetDistanceBetweenCoords(pos.x , pos.y , pos.z, 324.19, -572.48, 43.80 , true) < 2.5 then
                        DrawText3D(324.19, -572.48, 43.80 , '[~g~E~w~] untuk reset tato')
                        if IsControlJustReleased(0 , 38) then
                            resetTattoes()
                            print('sss')
                        end
					end
        end
    end
end)

function resetTattoes()
   
    if ESX.PlayerData.job then
        print('sa')
        local elements = {
            {label = 'Hapus tato',  value = 'reset_tattoes'}
        }

        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Reset_Tatto', {
			title    = 'Tatto',
			align    = 'top-right',
			elements = elements
        },
            function(data, menu)
			menu.close()

            if data.current.value == 'reset_tattoes' then
                TriggerServerEvent('ley_tattoes:resettattoes')
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
