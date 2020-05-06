Citizen.CreateThread(function()
    for k,v in pairs(Config.Zones) do
    local blip = AddBlipForRadius(v.x, v.y, v.z , 100.0) -- you can use a higher number for a bigger zone
    
        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, 1)
        SetBlipAlpha (blip, 128)
    
    local blip = AddBlipForCoord(v.x, v.y, v.z)
    
        SetBlipSprite (blip, v.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.9)
        SetBlipColour (blip, v.color)
        SetBlipAsShortRange(blip, true)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.name)
        EndTextCommandSetBlipName(blip)
    end
    end)

    
    Citizen.CreateThread(function()
        for k,v in pairs(Config.Zones2) do
        local blip = AddBlipForRadius(v.x, v.y, v.z , 100.0) -- you can use a higher number for a bigger zone
        
            SetBlipHighDetail(blip, true)
            SetBlipColour(blip, 2)
            SetBlipAlpha (blip, 128)
        
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        
            SetBlipSprite (blip, v.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 0.9)
            SetBlipColour (blip, v.color)
            SetBlipAsShortRange(blip, true)
        
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.name)
            EndTextCommandSetBlipName(blip)
        end
        end)


Citizen.CreateThread(function()
	
	for i=1, #Config.Blips, 1 do
		
		
		
		local blip = AddBlipForCoord(Config.Blips[i].x, Config.Blips[i].y, Config.Blips[i].z)
		SetBlipSprite (blip, Config.Blips[i].id)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, Config.Blips[i].scale)
		SetBlipColour (blip, Config.Blips[i].color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Blips[i].name)
		EndTextCommandSetBlipName(blip)
	end

end)

