ESX = nil

Citizen.CreateThread(function ()
    while ESX == nil do
          TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
          Citizen.Wait(0)
    end
end)

-- Citizen.CreateThread(function ()
--     while ESX == nil do
--         TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--         Citizen.Wait(0)
--     end
-- end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1) , true)
		if ESX ~= nil and Water.location ~= nil then
			    for i=1, #Water.location , 1 do
                    if GetDistanceBetweenCoords(pos.x , pos.y , pos.z, Water.location[i].x, Water.location[i].y, Water.location[i].z , true) < 2.5 then
                        DrawText3D(Water.location[i].x, Water.location[i].y, Water.location[i].z , '[~g~E~w~] untuk minum')
                        if IsControlJustReleased(0 , 38) then
                            openWater(source)
                        end
					end
				end	
				for i=1, #Water.location2 , 1 do
                    if GetDistanceBetweenCoords(pos.x , pos.y , pos.z, Water.location2[i].x, Water.location2[i].y, Water.location2[i].z , true) < 2.5 then
                        DrawText3D(Water.location2[i].x, Water.location2[i].y, Water.location2[i].z , '[~g~E~w~] untuk makan')
                        if IsControlJustReleased(0 , 38) then
                            openWater2(source)
                        end
					end
				end	
        end
    end
end)




function openWater(source)

	TriggerServerEvent('ifk_water:drinkSuccess')
end


function openWater2(source)

	TriggerServerEvent('ifk_water:eatSuccess')
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