local OwnedProperties, Blips, CurrentActionData, propertyAccess = {}, {}, {}, {}
local CurrentProperty, CurrentPropertyOwner, LastProperty, LastPart, CurrentAction, CurrentActionMsg
local firstSpawn, hasChest, hasAlreadyEnteredMarker = true, false, false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CreateBlips()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.TriggerServerCallback('esx_property:getProperties', function(properties)
		Config.Properties = properties
		CreateBlips()
	end)

	ESX.TriggerServerCallback('esx_property:getOwnedProperties', function(ownedProperties)
		for i=1, #ownedProperties, 1 do
			SetPropertyOwned(ownedProperties[i], true)
		end
	end)

	ESX.TriggerServerCallback('esx_property:getAccessProperties', function(accessProperties)
		propertyAccess=accessProperties
	end)
end)


RegisterNetEvent('esx_propery:loadroom')
AddEventHandler('esx_property:loadroom', function(CurrentActionData.property , CurrentActionData.owner)
	OpenRoomMenu(CurrentActionData.property , CurrentAction.owner)
end)	

-- only used when script is restarting mid-session
RegisterNetEvent('esx_property:sendProperties')
AddEventHandler('esx_property:sendProperties', function(properties)
	Config.Properties = properties
	CreateBlips()

	ESX.TriggerServerCallback('esx_property:getOwnedProperties', function(ownedProperties)
		for i=1, #ownedProperties, 1 do
			SetPropertyOwned(ownedProperties[i], true)
		end
	end)
	ESX.TriggerServerCallback('esx_property:getAccessProperties', function(accessProperties)
		propertyAccess=accessProperties
	end)
end)

RegisterNetEvent("esx_property:keysReceived")
AddEventHandler("esx_property:keysReceived",function(data)
	table.insert(propertyAccess,data)
	--ESX.ShowNotification('Otrzymałeś klucze do: ' .. data.name .. ' od ' .. data.ownerName)
	exports['mythic_notify']:DoHudText('success', 'Kamu menerima kunci ' ..data.name ' dari ' ..data.ownerName)
end)

-- RegisterNetEvent("esx_property:removeKeys")
-- AddEventHandler("esx_property:removeKeys",function(pname,owner)
-- 	for k,v in ipairs(propertyAccess) do if v.owner==owner and v.name==pname then
-- 		TriggerEvent("instance:get",function(instance) if instance~=nil and instance.data.owner==owner and instance.data.property==pname then TriggerEvent("instance:leave") end end)
-- 		table.remove(propertyAccess,k)
-- 	end end
-- end)

function DrawSub(text, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandPrint(time, 1)
end

function CreateBlips()
	for i=1, #Config.Properties, 1 do
		local property = Config.Properties[i]

		if property.entering then
			if property.blip == 0 then
				Blips[property.name] = AddBlipForCoord(property.entering.x, property.entering.y, property.entering.z)

				SetBlipSprite (Blips[property.name], 40)
				SetBlipColour (Blips[property.name], 38)
				SetBlipDisplay(Blips[property.name], 4)
				SetBlipScale  (Blips[property.name], 0.5)
				SetBlipAsShortRange(Blips[property.name], true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Mieszkanie')
				EndTextCommandSetBlipName(Blips[property.name])
			-- elseif property.blip == 1 then
			-- 	Blips[property.name] = AddBlipForCoord(property.entering.x, property.entering.y, property.entering.z)

			-- 	SetBlipSprite (Blips[property.name], 350)
			-- 	SetBlipColour (Blips[property.name], 64)
			-- 	SetBlipDisplay(Blips[property.name], 4)
			-- 	SetBlipScale  (Blips[property.name], 0.5)
			-- 	SetBlipAsShortRange(Blips[property.name], true)

			-- 	BeginTextCommandSetBlipName("STRING")
			-- 	AddTextComponentString(('Zajęte mieszkanie'))
			-- 	EndTextCommandSetBlipName(Blips[property.name])
			end
		end
	end
end

function GetProperties()
	return Config.Properties
end

function GetProperty(name)
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end

function GetGateway(property)
	for i=1, #Config.Properties, 1 do
		local property2 = Config.Properties[i]

		if property2.isGateway and property2.name == property.gateway then
			return property2
		end
	end
end

function GetGatewayProperties(property)
	local properties = {}

	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].gateway == property.name then
			table.insert(properties, Config.Properties[i])
		end
	end

	return properties
end

function EnterProperty(name, owner)
	local property       = GetProperty(name)
	local playerPed      = PlayerPedId()
	CurrentProperty      = property
	CurrentPropertyOwner = owner

	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name ~= name then
			Config.Properties[i].disabled = true
		end
	end

	TriggerServerEvent('esx_property:saveLastProperty', name)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		for i=1, #property.ipls, 1 do
			RequestIpl(property.ipls[i])

			while not IsIplActive(property.ipls[i]) do
				Citizen.Wait(0)
			end
		end

		SetEntityCoords(playerPed, property.inside.x, property.inside.y, property.inside.z)
		DoScreenFadeIn(800)
		DrawSub(property.label, 5000)
	end)

end

function ExitProperty(name)
	local property  = GetProperty(name)
	local playerPed = PlayerPedId()
	local outside   = nil
	CurrentProperty = nil

	if property.isSingle then
		outside = property.outside
	else
		outside = GetGateway(property).outside
	end

	TriggerServerEvent('esx_property:deleteLastProperty')

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		SetEntityCoords(playerPed, outside.x, outside.y, outside.z)

		for i=1, #property.ipls, 1 do
			RemoveIpl(property.ipls[i])
		end

		for i=1, #Config.Properties, 1 do
			Config.Properties[i].disabled = false
		end

		DoScreenFadeIn(800)
	end)
end


function SetBlipLocked1(name)
	local property     = GetProperty(name)
	local entering     = nil
	local enteringName = nil
	entering     = property.entering
	enteringName = property.name
	RemoveBlip(Blips[enteringName])

	Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)
	SetBlipSprite (Blips[enteringName], 350)
	SetBlipColour (Blips[enteringName], 64)
	SetBlipDisplay(Blips[enteringName], 4)
	SetBlipScale  (Blips[enteringName], 0.5)
	SetBlipAsShortRange(Blips[enteringName], true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('free_prop'))
	EndTextCommandSetBlipName(Blips[enteringName])
end

function SetBlipLocked(name)
	local property     = GetProperty(name)
	local entering     = nil
	local enteringName = nil
	entering     = property.entering
	enteringName = property.name
	RemoveBlip(Blips[enteringName])

	-- Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)
	-- SetBlipSprite (Blips[enteringName], 350)
	-- SetBlipColour (Blips[enteringName], 64)
	-- SetBlipDisplay(Blips[enteringName], 4)
	-- SetBlipScale  (Blips[enteringName], 0.5)
	-- SetBlipAsShortRange(Blips[enteringName], true)

	-- BeginTextCommandSetBlipName("STRING")
	-- AddTextComponentString(('Zajęte mieszkanie'))
	-- EndTextCommandSetBlipName(Blips[enteringName])
end

RegisterNetEvent('esx_property:setBlipOwned')
AddEventHandler('esx_property:setBlipOwned', function(name)
	SetBlipLocked(name)
end)

RegisterNetEvent('esx_property:setBlipOwned1')
AddEventHandler('esx_property:setBlipOwned1', function(name)
	SetBlipLocked1(name)
end)

function SetPropertyOwned(name, owned)
	local property     = GetProperty(name)
	local entering     = nil
	local enteringName = nil

	if property.isSingle then
		entering     = property.entering
		enteringName = property.name
	else
		local gateway = GetGateway(property)
		entering      = gateway.entering
		enteringName  = gateway.name
	end

	if owned then
		OwnedProperties[name] = true
		RemoveBlip(Blips[enteringName])

		Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)
		SetBlipSprite(Blips[enteringName], 492)
		SetBlipScale  (Blips[property.name], 0.5)
		SetBlipAsShortRange(Blips[enteringName], true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(_U('property'))
		EndTextCommandSetBlipName(Blips[enteringName])
	else
		OwnedProperties[name] = nil
		local found = false

		for k,v in pairs(OwnedProperties) do
			local _property = GetProperty(k)
			local _gateway  = GetGateway(_property)

			if _gateway then
				if _gateway.name == enteringName then
					found = true
					break
				end
			end
		end

		if not found then
			RemoveBlip(Blips[enteringName])

			Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)
			SetBlipSprite(Blips[enteringName], 369)
			SetBlipAsShortRange(Blips[enteringName], true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(_U('free_prop'))
			EndTextCommandSetBlipName(Blips[enteringName])
		end
	end
end

function PropertyIsOwned(property)
	return OwnedProperties[property.name] == true
end

RegisterNetEvent('esx_property:sprzedaj')
AddEventHandler('esx_property:sprzedaj', function(playerId, property, amount)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_ack_sell', {
		title    = 'Obywatel [' .. playerId .. '] chce Ci sprzedać posiadłość',
		align    = 'center',
		elements = {
			{ label = 'Zaakceptuj ofertę - <span style="color:red;">$' .. amount .. '</span>', value = true },
			{ label = 'Odrzuć ofertę', value = false }
		}
	}, function(data, menu)
		menu.close()
		if data.current.value then
			local player = GetPlayerFromServerId(playerId)
			if player and player ~= 0 then
				TriggerServerEvent('esx_property:acceptSell', playerId, property, amount)
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end)


function GetAccessForProperty(property)
	local acc = {}
	for k,v in ipairs(propertyAccess) do
		if v.name==property.name then table.insert(acc,v) end
	end
	return acc
end

function OpenPropertyMenu(property)
	local elements = {}
	local can = nil
	--ESX.ShowNotification('Trwa ładowanie oferty ...')
	exports['mythic_notify']:DoHudText('inform', 'Memuat penawaran...')
	Citizen.Wait(1000)

	if PropertyIsOwned(property) then
		table.insert(elements, {label = _U('enter'), value = 'enter'})
		table.insert(elements, {label = _U('give_keys'), value = 'give_keys'})
		table.insert(elements, {label = ('Jual'), value = 'sell'})

		if not Config.EnablePlayerManagement then
			table.insert(elements, {label = _U('leave'), value = 'leave'})
		end
	else
		ESX.TriggerServerCallback('esx_property:getOwnedProperties2', function(host)
			if host then
				for k,v in ipairs(GetAccessForProperty(property)) do
					table.insert(elements,{label = _U('enter').." - "..(v.ownerName~=nil and v.ownerName or v.owner), value = 'enter_shared', owner = v.owner})
				end
				can = true
			else
				ESX.TriggerServerCallback('esx_property:getOwnedProperties6', function(host)
					if host == true then
						ESX.TriggerServerCallback('property:getItemAmount', function(qtty)
							if qtty > 0 then
								table.insert(elements, {label = ('Pintu masuk polisi'), value = 'enterPolice'})
								can = true
							else
								--ESX.ShowNotification('To mieszkanie zostało zakupione przez innego gracza')
								exports['mythic_notify']:DoHudText('error', 'Properti ini sudah dimiliki orang lain!')
								can = false
							end
						end, 'bread')
					else
						table.insert(elements, {label = _U('buy') .. ' - $' .. property.price, value = 'buy'})
						-- table.insert(elements, {label = _U('rent') .. ' - $' .. math.floor(property.price / 200), value = 'rent'})
						table.insert(elements, {label = _U('visit'), value = 'visit'})
						can = true
					end
				end, property.name)
			end

			end, property.name)
	end
	Citizen.Wait(1000)
	if can == false then
		return
	end


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property', {
		title    = property.label,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'enter' then
			TriggerEvent('instance:create', 'property', {property = property.name, owner = ESX.GetPlayerData().identifier})
		elseif data.current.value == 'sell' then
			local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId(), true), 2.5)
			if #playersInArea > 1 then
				local elements = {}
				for _, player in ipairs(playersInArea) do
					if player ~= PlayerId() then
						local sid = GetPlayerServerId(player)
						table.insert(elements, {label = sid, value = sid})
					end
				end
	
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_sell_target', {
					title    = 'Pilih Warga',
					align    = 'center',
					elements = elements
				}, function(data3, menu2)
					local player = GetPlayerFromServerId(data3.current.value)
					if player and player ~= 0 then
						menu2.close()
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'property_sell_amount', {
						  title = 'Masukkan Harga Jual'
						}, function(data4, menu3)
							local coords1 = GetEntityCoords(PlayerPedId(), true)
							local coords2 = GetEntityCoords(GetPlayerPed(player), true)
	
							menu3.close()
							if GetDistanceBetweenCoords(coords1, coords2, true) <= 2.5 then
								TriggerServerEvent('esx_property:requestSell', data3.current.value, property.name, tonumber(data4.value))
								--ESX.ShowNotification('~y~Oczekiwanie na zaakceptowanie oferty przez obywatela ')
								exports['mythic_notify']:DoHudText('inform', 'Menunggu warga untuk menerima penawaran...')
							else
								--ESX.ShowNotification('~r~Obywatel zbyt daleko')
								exports['mythic_notify']:DoHudText('error', 'Warga terlalu jauh!')
								menu2.open()
							end
						end, function(data3, menu3)
							menu3.close()
							menu2.open()
						end)
					else
						--ESX.ShowNotification('~r~Obywatel nie istnieje')
						exports['mythic_notify']:DoHudText('error', 'Tidak ada warga!')
					end
				end, function(data3, menu2)
					menu2.close()
					menu.open()
				end)
			else
				--ESX.ShowNotification('~r~Brak obywateli w pobliżu!')
				exports['mythic_notify']:DoHudText('error', 'Tidak ada warga terdekat!')
				menu.open()
			end
		elseif data.current.value == 'leave' then
			TriggerServerEvent('esx_property:removeOwnedProperty', property.name)
		elseif data.current.value == 'enterPolice' then
			ESX.TriggerServerCallback('esx_property:getOwnedProperties3', function(host)
				TriggerEvent('instance:create', 'property', GetPlayerServerId(PlayerId()), {property = property.name, owner = host})
			end, property.name)
		elseif data.current.value == 'buy' then
			TriggerServerEvent('esx_property:buyProperty', property.name)
		-- elseif data.current.value == 'rent' then
		-- 	TriggerServerEvent('esx_property:rentProperty', property.name)
		elseif data.current.value == 'visit' then
			TriggerEvent('instance:create', 'property', {property = property.name, owner = ESX.GetPlayerData().identifier})
		elseif data.current.value == 'give_keys' then
			local elems = {}
			local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId(), true), 2.5)
			-- table.insert(elems,{label=_U('take_away_keys'),value='take_away_keys'})
			for _, player in ipairs(playersInArea) do
				if player ~= PlayerId() then
					local sid = GetPlayerServerId(player)
					table.insert(elems, {label = sid, value = sid})
				end
			end
			table.insert(elems,{label="Exit",value="exit"})
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_keys', {title=_U('give_keys_menu'),align = 'top-left', elements=elems},
			function(data1,menu1)
				if data1.current.value~="exit" and data1.current.value~="take_away_keys" then
					ESX.TriggerServerCallback("esx_property:giveKeys",function()
						--ESX.ShowNotification('Dałeś klucze: ' .. data1.current.value)
						exports['mythic_notify']:DoHudText('success', 'Kamu memberikan kunci ' ..data1.current.value)
					end, property, data1.current.value)
				elseif data1.current.value=="take_away_keys" then
					--TriggerServerEvent("esx_property:removeKeysAll",property.name)
					exports['mythic_notify']:DoHudText('success', 'Kamu berhasil mengubah kunci')
					--ESX.ShowNotification('Zmieniłeś zamek')
				end
				menu1.close()
			end,function(data1,menu1) menu1.close() end)
		elseif data.current.value == 'enter_shared' then
			TriggerEvent('instance:create', 'property', {property = property.name, owner = data.current.owner})
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'property_menu'
		CurrentActionMsg  = _U('press_to_menu')
		CurrentActionData = {property = property}
	end)
end

function OpenGatewayMenu(property)
	if Config.EnablePlayerManagement then
		OpenGatewayOwnedPropertiesMenu(gatewayProperties)
	else

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway', {
			title    = property.name,
			align    = 'top-left',
			elements = {
				{label = _U('owned_properties'),    value = 'owned_properties'},
				{label = _U('available_properties'), value = 'available_properties'}
		}}, function(data, menu)
			if data.current.value == 'owned_properties' then
				OpenGatewayOwnedPropertiesMenu(property)
			elseif data.current.value == 'available_properties' then
				OpenGatewayAvailablePropertiesMenu(property)
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'gateway_menu'
			CurrentActionMsg  = _U('press_to_menu')
			CurrentActionData = {property = property}
		end)
	end
end

function OpenGatewayOwnedPropertiesMenu(property)
	local gatewayProperties = GetGatewayProperties(property)
	local elements          = {}

	for i=1, #gatewayProperties, 1 do
		if PropertyIsOwned(gatewayProperties[i]) then
			table.insert(elements, {
				label = gatewayProperties[i].label,
				value = gatewayProperties[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_owned_properties', {
		title    = property.name .. ' - ' .. _U('owned_properties'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		local elements = {
			{label = _U('enter'), value = 'enter'}
		}

		if not Config.EnablePlayerManagement then
			table.insert(elements, {label = _U('leave'), value = 'leave'})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_owned_properties_actions', {
			title    = data.current.label,
			align    = 'top-left',
			elements = elements
		}, function(data2, menu2)
			menu2.close()

			if data2.current.value == 'enter' then
				TriggerEvent('instance:create', 'property', {property = data.current.value, owner = ESX.GetPlayerData().identifier})
				ESX.UI.Menu.CloseAll()
			elseif data2.current.value == 'leave' then
				TriggerServerEvent('esx_property:removeOwnedProperty', data.current.value)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGatewayAvailablePropertiesMenu(property)
	local gatewayProperties = GetGatewayProperties(property)
	local elements          = {}

	for i=1, #gatewayProperties, 1 do
		if not PropertyIsOwned(gatewayProperties[i]) then
			table.insert(elements, {
				label = gatewayProperties[i].label .. ' $' .. ESX.Math.GroupDigits(gatewayProperties[i].price),
				value = gatewayProperties[i].name,
				price = gatewayProperties[i].price
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_available_properties', {
		title    = property.name .. ' - ' .. _U('available_properties'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_available_properties_actions', {
			title    = property.label .. ' - ' .. _U('available_properties'),
			align    = 'top-left',
			elements = {
				{label = _U('buy'), value = 'buy'},
				-- {label = _U('rent'), value = 'rent'},
				{label = _U('visit'), value = 'visit'}
		}}, function(data2, menu2)
			menu2.close()

			if data2.current.value == 'buy' then
				TriggerServerEvent('esx_property:buyProperty', data.current.value)
			-- elseif data2.current.value == 'rent' then
			-- 	TriggerServerEvent('esx_property:rentProperty', data.current.value)
			elseif data2.current.value == 'visit' then
				TriggerEvent('instance:create', 'property', {property = data.current.value, owner = ESX.GetPlayerData().identifier})
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenRoomMenu(property, owner)
	local entering = nil
	local elements = {{label = _U('invite_player'),  value = 'invite_player'}}

	if property.isSingle then
		entering = property.entering
	else
		entering = GetGateway(property).entering
	end

	if CurrentPropertyOwner == owner then
		table.insert(elements, {label = _U('player_clothes'), value = 'player_dressing'})
		table.insert(elements, {label = _U('remove_cloth'), value = 'remove_cloth'})
	end

	table.insert(elements, {label = "Property inventory", value = "property_inventory"})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room', {
		title    = property.label,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'invite_player' then

			local playersInArea = ESX.Game.GetPlayersInArea(entering, 10.0)
			local elements      = {}

			for i=1, #playersInArea, 1 do
				if playersInArea[i] ~= PlayerId() then
					table.insert(elements, {label = GetPlayerName(playersInArea[i]), value = playersInArea[i]})
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_invite', {
				title    = property.label .. ' - ' .. _U('invite'),
				align    = 'top-left',
				elements = elements,
			}, function(data2, menu2)
				TriggerEvent('instance:invite', 'property', GetPlayerServerId(data2.current.value), {property = property.name, owner = owner})
				--ESX.ShowNotification(_U('you_invited', GetPlayerName(data2.current.value)))
				exports['mythic_notify']:DoHudText('success', 'Kamu mengundang ' ..GetPlayerName(data2.current.value).. ' masuk')
			end, function(data2, menu2)
				menu2.close()
			end)

		elseif data.current.value == 'player_dressing' then

			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = property.label .. ' - ' .. _U('player_clothes'),
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'remove_cloth' then

			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = property.label .. ' - ' .. _U('remove_cloth'),
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('esx_property:removeOutfit', data2.current.value)
					--ESX.ShowNotification(_U('removed_cloth'))
					exports['mythic_notify']:DoHudText('inform', 'Pakaian ini telah dihapus')
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == "property_inventory" then
			menu.close()
			OpenPropertyInventoryMenu(property, owner)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'room_menu'
		CurrentActionMsg  = _U('press_to_menu')
		CurrentActionData = {property = property, owner = owner}
	end)
end

function OpenPropertyInventoryMenu(property, owner)
	ESX.TriggerServerCallback("esx_property:getPropertyInventory", function(inventory)
		TriggerEvent("esx_inventoryhud:openPropertyInventory", inventory)
	end, owner)
end

function OpenRoomInventoryMenu(property, owner)

	ESX.TriggerServerCallback('esx_property:getPropertyInventory', function(inventory)
		if inventory then
			-- ESX.ShowNotification('~r~Aktualnie inny obywatel przegląda tą szafkę')
			exports['mythic_notify']:DoHudText('error', 'Ada orang yang sedang melihat kabinet ini!')
		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = _U('dirty_money', ESX.Math.GroupDigits(inventory.blackMoney)),
				type = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ']',
				type  = 'item_weapon',
				value = weapon.name,
				ammo  = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_inventory',
		{
			title    = property.label .. ' - ' .. _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.type == 'item_weapon' then

				menu.close()

				TriggerServerEvent('esx_property:getItem', owner, data.current.type, data.current.value, data.current.ammo)
				ESX.SetTimeout(300, function()
					OpenRoomInventoryMenu(property, owner)
				end)

			else

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_item_count', {
					title = _U('amount')
				}, function(data2, menu)

					local quantity = tonumber(data2.value)
					if quantity == nil then
						--ESX.ShowNotification(_U('amount_invalid'))
						exports['mythic_notify']:DoHudText('error', 'Jumlah invalid')
					else
						menu.close()

						TriggerServerEvent('esx_property:getItem', owner, data.current.type, data.current.value, quantity)
						ESX.SetTimeout(300, function()
							OpenRoomInventoryMenu(property, owner)
						end)
					end

				end, function(data2,menu)
					menu.close()
				end)

			end

		end, function(data, menu)
			TriggerServerEvent('clearHouse', property.name)
			menu.close()
		end)
	elseif inventory == false then
		--ESX.ShowNotification('~r~Aktualnie inny obywatel przegląda tą szafkę')
		exports['mythic_notify']:DoHudText('inform', 'Ada orang yang sedang melihat kabiner ini!')
	end
	end, owner, property.name)

end

function OpenPlayerInventoryMenu(property, owner)
	ESX.TriggerServerCallback('esx_property:getPlayerInventory', function(inventory)
		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = _U('dirty_money', ESX.Math.GroupDigits(inventory.blackMoney)),
				type  = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = weapon.label .. ' [' .. weapon.ammo .. ']',
				type  = 'item_weapon',
				value = weapon.name,
				ammo  = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_inventory', {
			title    = property.label .. ' - ' .. _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.type == 'item_weapon' then
				menu.close()
				TriggerServerEvent('esx_property:putItem', owner, data.current.type, data.current.value, data.current.ammo)

				ESX.SetTimeout(300, function()
					OpenPlayerInventoryMenu(property, owner)
				end)
			else
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
					title = _U('amount')
				}, function(data2, menu2)
					local quantity = tonumber(data2.value)

					if quantity == nil then
						--ESX.ShowNotification(_U('amount_invalid'))
						exports['mythic_notify']:DoHudText('error', 'Jumlah invalid')
					else
						menu2.close()

						TriggerServerEvent('esx_property:putItem', owner, data.current.type, data.current.value, tonumber(data2.value))
						ESX.SetTimeout(300, function()
							OpenPlayerInventoryMenu(property, owner)
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

AddEventHandler('instance:loaded', function()
	TriggerEvent('instance:registerType', 'property', function(instance)
		EnterProperty(instance.data.property, instance.data.owner)
	end, function(instance)
		ExitProperty(instance.data.property)
	end)
end)

AddEventHandler('playerSpawned', function()
	if firstSpawn then
		Citizen.CreateThread(function()
			while not ESX.IsPlayerLoaded() do
				Citizen.Wait(0)
			end

			ESX.TriggerServerCallback('esx_property:getLastProperty', function(propertyName)
				if propertyName then
					if propertyName ~= '' then
						local property = GetProperty(propertyName)

						for i=1, #property.ipls, 1 do
							RequestIpl(property.ipls[i])
				
							while not IsIplActive(property.ipls[i]) do
								Citizen.Wait(0)
							end
						end

						TriggerEvent('instance:create', 'property', {property = propertyName, owner = ESX.GetPlayerData().identifier})
					end
				end
			end)
		end)

		firstSpawn = false
	end
end)

AddEventHandler('esx_property:getProperties', function(cb)
	cb(GetProperties())
end)

AddEventHandler('esx_property:getProperty', function(name, cb)
	cb(GetProperty(name))
end)

AddEventHandler('esx_property:getGateway', function(property, cb)
	cb(GetGateway(property))
end)

RegisterNetEvent('esx_property:setPropertyOwned')
AddEventHandler('esx_property:setPropertyOwned', function(name, owned)
	SetPropertyOwned(name, owned)
end)

-- RegisterNetEvent('instance:onCreate')
-- AddEventHandler('instance:onCreate', function(instance)
-- 	if instance.type == 'property' then
-- 		TriggerEvent('instance:enter', instance)
-- 	end
-- end)

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(instance)
	if instance.type == 'property' then
		local property = GetProperty(instance.data.property)
		local isHost   = GetPlayerFromServerId(instance.host) == PlayerId()
		local isOwned  = false

		if PropertyIsOwned(property) == true then
			isOwned = true
		end

		if isOwned or not isHost then
			hasChest = true
		elseif isHost then
			hasChest = true
		else
			hasChest = false
		end
	end
end)

RegisterNetEvent('instance:onPlayerLeft')
AddEventHandler('instance:onPlayerLeft', function(instance, player)
	if player == instance.host then
		TriggerEvent('instance:leave')
	end
end)

RegisterNetEvent("esx_property:joinShared")
AddEventHandler("esx_property:joinShared",function(instance)
	TriggerEvent("instance:get",function(instance) if instance~=nil then TriggerEvent("instance:leave") end end)
	TriggerEvent("instance:enter",instance)
end)

AddEventHandler('esx_property:hasEnteredMarker', function(name, part)
	local property = GetProperty(name)

	if part == 'entering' then
		if property.isSingle then
			CurrentAction     = 'property_menu'
			CurrentActionMsg  = _U('press_to_menu')
			CurrentActionData = {property = property}
		else
			CurrentAction     = 'gateway_menu'
			CurrentActionMsg  = _U('press_to_menu')
			CurrentActionData = {property = property}
		end
	elseif part == 'exit' then
		CurrentAction     = 'room_exit'
		CurrentActionMsg  = _U('press_to_exit')
		CurrentActionData = {propertyName = name}
	elseif part == 'roomMenu' then
		CurrentAction     = 'room_menu'
		CurrentActionMsg  = _U('press_to_menu')
		CurrentActionData = {property = property, owner = CurrentPropertyOwner}
	end
end)

AddEventHandler('esx_property:hasExitedMarker', function(name, part)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Enter / Exit marker events & Draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep = false, true
		local currentProperty, currentPart

		for i=1, #Config.Properties, 1 do
			local property = Config.Properties[i]

			-- Entering
			if property.entering and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.entering.x, property.entering.y, property.entering.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.entering.x, property.entering.y, property.entering.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker      = true
					currentProperty = property.name
					currentPart     = 'entering'
				end
			end

			-- Exit
			if property.exit and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.exit.x, property.exit.y, property.exit.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.exit.x, property.exit.y, property.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker      = true
					currentProperty = property.name
					currentPart     = 'exit'
				end
			end

			-- Room menu
			if property.roomMenu and hasChest and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.RoomMenuMarkerColor.r, Config.RoomMenuMarkerColor.g, Config.RoomMenuMarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker      = true
					currentProperty = property.name
					currentPart     = 'roomMenu'
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker or (isInMarker and (LastProperty ~= currentProperty or LastPart ~= currentPart) ) then
			hasAlreadyEnteredMarker = true
			LastProperty            = currentProperty
			LastPart                = currentPart

			TriggerEvent('esx_property:hasEnteredMarker', currentProperty, currentPart)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_property:hasExitedMarker', LastProperty, LastPart)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'property_menu' then
					OpenPropertyMenu(CurrentActionData.property)
				elseif CurrentAction == 'gateway_menu' then
					if Config.EnablePlayerManagement then
						OpenGatewayOwnedPropertiesMenu(CurrentActionData.property)
					else
						OpenGatewayMenu(CurrentActionData.property)
					end
				elseif CurrentAction == 'room_menu' then
					OpenRoomMenu(CurrentActionData.property, CurrentActionData.owner)
				elseif CurrentAction == 'room_exit' then
					TriggerEvent('instance:leave')
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
