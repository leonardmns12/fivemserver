ESX = nil
local IsAnimated = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx_getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

end)

Citizen.CreateThread(function()
    while true do
    	Citizen.Wait(0)
    	-- print('ea')
        --if ESX ~= nil then
        	-- print('ea')
            local pos = GetEntityCoords(GetPlayerPed(-1) , true)
                    if GetDistanceBetweenCoords(pos.x , pos.y , pos.z, 437.33 , -978.9, 30.90 , true) < 2.5 then
                        DrawText3D(437.33 , -978.9, 30.90 , "[~g~E~w~] untuk minum")
                        if IsControlJustReleased(0 , 38) then
                            openWater(source)
                        end
                    end
        --end
    end
end)




function openWater(source)

	TriggerServerEvent('ifk_water:drinkSuccess')
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