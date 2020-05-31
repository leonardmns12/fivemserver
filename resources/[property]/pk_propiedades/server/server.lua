-----------------------------------------------------------------------------
-- SCRIPT CREADO POR POKESER [ POKE ]
-- PROHIBIDO VENDER / REGALAR / ENVIAR ESTOS SCRIPTS SIN MI CONSENTIMIENTO
-----------------------------------------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local spawneados = false

RegisterServerEvent('pk_casas:checkcasa')
AddEventHandler('pk_casas:checkcasa', function(nombrecasa)
local source = source
local estadopuerta = MySQL.Sync.fetchScalar("SELECT estado FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local propietarioid = MySQL.Sync.fetchScalar("SELECT propietarioID FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local propietarionombre = MySQL.Sync.fetchScalar("SELECT propietarioNombre FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local garage = MySQL.Sync.fetchScalar("SELECT cochera FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local vehicle = MySQL.Sync.fetchScalar("SELECT vehicle FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local armas = MySQL.Sync.fetchScalar("SELECT ArmarioArmas FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local dinero = MySQL.Sync.fetchScalar("SELECT ArmarioDinero FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local items = MySQL.Sync.fetchScalar("SELECT ArmarioItems FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local venta = MySQL.Sync.fetchScalar("SELECT enventa FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})

	if propietarioid == nil then
		TriggerClientEvent('pk_casas:propietario',source, 0)
		TriggerClientEvent('pk_casas:mejoras',source, 0,0,0,0,0)
	elseif propietarioid ~= GetPlayerIdentifiers(source)[1] then 
		TriggerClientEvent('pk_casas:propietario',source, 1, propietarionombre)
		TriggerClientEvent('pk_casas:soyelpropietario',source, 0)
		TriggerClientEvent('pk_casas:mejoras',source, 0,0,0,0,venta)
		if estadopuerta == 0 then
			TriggerClientEvent('pk_casas:estado',source, 0)
		elseif estadopuerta == 1 then
			TriggerClientEvent('pk_casas:estado',source, 1)
		end
	elseif propietarioid == GetPlayerIdentifiers(source)[1] then
		TriggerClientEvent('pk_casas:propietario',source, 1, propietarionombre)
		TriggerClientEvent('pk_casas:soyelpropietario',source, 1)
		TriggerClientEvent('pk_casas:mejoras',source, dinero,armas,items,garage,venta)
		if estadopuerta == 0 then
			TriggerClientEvent('pk_casas:estado',source, 0)
		elseif estadopuerta == 1 then
			TriggerClientEvent('pk_casas:estado',source, 1)
		end
	
		
	end
end)

RegisterServerEvent('pk_casas:checkcasacomprada')
AddEventHandler('pk_casas:checkcasacomprada', function(nombrecasa)
local source = source
local estadopuerta = MySQL.Sync.fetchScalar("SELECT estado FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local propietarioid = MySQL.Sync.fetchScalar("SELECT propietarioID FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local propietarionombre = MySQL.Sync.fetchScalar("SELECT propietarioNombre FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})


	if propietarioid == nil then
		TriggerClientEvent('pk_casas:propietario',-1, 0)
	elseif propietarioid ~= GetPlayerIdentifiers(source)[1] then 
		TriggerClientEvent('pk_casas:propietario',-1, 1, propietarionombre)
		TriggerClientEvent('pk_casas:soyelpropietario',source, 0)
		if estadopuerta == 0 then
			TriggerClientEvent('pk_casas:estadopuerta',-1, 0)
		elseif estadopuerta == 1 then
			TriggerClientEvent('pk_casas:estadopuerta',-1, 1)
		end
	elseif propietarioid == GetPlayerIdentifiers(source)[1] then
		TriggerClientEvent('pk_casas:propietario',-1, 1, propietarionombre)
		TriggerClientEvent('pk_casas:soyelpropietario',-1, 1)
		if estadopuerta == 0 then
			TriggerClientEvent('pk_casas:estadopuerta',-1, 0)
		elseif estadopuerta == 1 then
			TriggerClientEvent('pk_casas:estadopuerta',-1, 1)
		end
	end
end)

RegisterServerEvent('pk_casas:puerta')
AddEventHandler('pk_casas:puerta', function(estado,nombrecasa)
	local source = source
	local propietarioid = MySQL.Sync.fetchScalar("SELECT propietarioID FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
	local puerta = estado
	if propietarioid ~= GetPlayerIdentifiers(source)[1] then 
		TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "Esta no es tu casa!.")
	elseif propietarioid == GetPlayerIdentifiers(source)[1] then
		MySQL.Sync.execute("UPDATE pk_casas SET estado = @estado WHERE propiedad = @propiedad", {['@estado'] = puerta,['@propiedad'] = nombrecasa})
			if estado == 0 then
				--TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "You closed ")

				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div class="chat-message house"><b>[House]:</b> Kamu mengunci pintu</div>',
					args = { " " }
                    })
				TriggerClientEvent('pk_casas:estadopuerta',-1, 0)
			elseif estado == 1 then
				--TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "Abriste la puerta de tu casa!")
				TriggerClientEvent('chat:addMessage', -1, {
					template = '<div class="chat-message house"><b>[House]:</b> Kamu membuka pintu</div>',
					args = { " " }})
				TriggerClientEvent('pk_casas:estadopuerta',-1, 1)
			end
	end
end)
	
RegisterServerEvent('pk_casas:comprarpropiedad')
AddEventHandler('pk_casas:comprarpropiedad', function(nombrecasa,precio)
local source = source
local xPlayer  = ESX.GetPlayerFromId(source)
local steamid = GetPlayerIdentifiers(source)[1]
local barrio = MySQL.Sync.fetchScalar("SELECT barrio FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = nombrecasa})
local vivebarrio = MySQL.Sync.fetchScalar("SELECT barrio FROM pk_casas WHERE propietarioID = @propietarioID AND barrio = @barrio" , {
	['@propietarioID'] = steamid,
	['@barrio'] = barrio}
	)
local nombreplayer = GetPlayerName(source)
local estado = 1
local canbuy = 0

	if vivebarrio == barrio then
		canbuy =  0
	elseif vivebarrio ~= barrio then
		canbuy = 1
	end

------------------------------
  local _source = source
  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = 0
  local entrega = _source
  local recive = 0
  local tipo = 'Comprar propiedad'
  local cantidad = precio
  local entreganombre = GetPlayerName(_source)
  local recivenombre = 0
------------------------------	
	
	Citizen.Wait(10)
	if canbuy == 1 then
		if sourceXPlayer.getAccount('money').money >= precio then
			sourceXPlayer.removeMoney(precio)
			MySQL.Sync.execute("UPDATE pk_casas SET estado = @estado, propietarioID = @propietarioID, propietarioNombre = @propietarioNombre WHERE propiedad = @propiedad", {
				['@estado'] = estado, 
				['@propietarioID'] = steamid,
				['@propietarioNombre'] = nombreplayer,
				['@propiedad'] = nombrecasa
			})
			TriggerEvent('pk_casas:checkcasacomprada', nombrecasa)
			--TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "Felicidades compraste "..nombrecasa.." por $"..precio)
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-message house"><b>[House]:</b> Kamu membeli rumah seharga Rp.{0}</div>',
				args = { precio }})
		else
			--TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "No tienes dinero suficiente!")
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-message house"><b>[House]:</b> Kamu tidak punya uang!</div>',
				args = { " " }})
		end
	else
		--TriggerClientEvent("chatMessage", source, "Sistema", {255, 0, 0}, "Ya cuentas con una propiedad de este tipo!")
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div class="chat-message house"><b>[House]:</b> Kamu sudah punya rumah!</div>',
			args = { " " }})
	end

end)

--[[function registrarCompraCasa(entrega, entreganombre, recive, recivenombre, tipo, cantidad)
local hour = os.time()
local tiempo = os.date('%c',hour)
MySQL.Async.execute("INSERT INTO pk_transacciones (`entrega`,`entreganombre`,`recive`,`recivenombre`,`tipo`,`cantidad`,`hour`) VALUES (@entrega,@entreganombre,@recive,@recivenombre,@tipo,@cantidad,@hour)", {
entrega = entrega,
entreganombre = entreganombre,
recive = recive,
recivenombre = recivenombre,
tipo = tipo,
cantidad = cantidad,
hour = tiempo})
end]]

RegisterServerEvent('pk_casas:checkdinero')
AddEventHandler('pk_casas:checkdinero', function(nombrecasa,tipo,precio)
local source = source
local xPlayer  = ESX.GetPlayerFromId(source)
local steamid = GetPlayerIdentifiers(source)[1]
local armas = 'armas'
local garage = 'garage'
local items = 'items'
local dinero = 'dinero'
local comprado = 1


	if xPlayer.getAccount('money').money >= precio then
		xPlayer.removeMoney(precio)
		if tipo == armas then
			MySQL.Sync.execute("UPDATE pk_casas SET ArmarioArmas = @ArmarioArmas WHERE propiedad = @propiedad", {['@ArmarioArmas'] = comprado,['@propiedad'] = nombrecasa})
			--TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "Felicidades, ahora puedes guardar ARMAS en tu armario")
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-message house"><b>[House]:</b> Kamu sudah membangun armory</div>',
				args = { " " }})
		elseif tipo == items then
			MySQL.Sync.execute("UPDATE pk_casas SET ArmarioItems = @ArmarioItems WHERE propiedad = @propiedad", {['@ArmarioItems'] = comprado,['@propiedad'] = nombrecasa})
			--TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "Felicidades, ahora puedes guardar ITEMS en tu armario")
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-message house"><b>[House]:</b> Kamu dapat menyimpan item dirumah!</div>',
				args = { " " }})
		elseif tipo == dinero then
			MySQL.Sync.execute("UPDATE pk_casas SET ArmarioDinero = @ArmarioDinero WHERE propiedad = @propiedad", {['@ArmarioDinero'] = comprado,['@propiedad'] = nombrecasa})
			--TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "Felicidades, ahora puedes guardar DINERO SUCIO en tu armario")
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-message house"><b>[House]:</b> Kamu sudah membangun armory!</div>',
				args = { " " }})
		elseif tipo == garage then
			MySQL.Sync.execute("UPDATE pk_casas SET cochera = @cochera WHERE propiedad = @propiedad", {['@cochera'] = comprado,['@propiedad'] = nombrecasa})
		--	TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "Felicidades, ahora puedes guardar un vehiculo en tu garage")
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-message house"><b>[House]:</b> Kamu sudah membangun garasi!</div>',
				args = { " " }})
		end
		TriggerEvent('pk_casas:checkcasa', nombrecasa)
	else
		TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "No tienes dinero suficiente!.")
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div class="chat-message house"><b>[House]:</b> Kamu tidak punya uang</div>',
			args = { " " }})
	end
end)

RegisterServerEvent('pk_casas:ponerenventa')
AddEventHandler('pk_casas:ponerenventa', function(nombrecasa,precio)
local source = source
local xPlayer  = ESX.GetPlayerFromId(source)
local steamid = GetPlayerIdentifiers(source)[1]

MySQL.Sync.execute("UPDATE pk_casas SET enventa = @enventa WHERE propiedad = @propiedad", {['@enventa'] = precio,['@propiedad'] = nombrecasa})
--TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "Acabas de poner en venta tu propiedad por $"..precio)
TriggerClientEvent('chat:addMessage', -1, {
	template = '<div class="chat-message house"><b>[House]:</b> Kamu menjual rumahmu seharga {0}</div>',
	args = { precio }})
end)

RegisterServerEvent('pk_casas:sacarenventa')
AddEventHandler('pk_casas:sacarenventa', function(nombrecasa,precio)
local source = source
local xPlayer  = ESX.GetPlayerFromId(source)
local steamid = GetPlayerIdentifiers(source)[1]

MySQL.Sync.execute("UPDATE pk_casas SET enventa = @enventa WHERE propiedad = @propiedad", {['@enventa'] = precio,['@propiedad'] = nombrecasa})
--TriggerClientEvent("chatMessage", source, "PROPIEDAD", {255, 0, 0}, "Acabas de sacar de la venta a tu propiedad")
TriggerClientEvent('chat:addMessage', -1, {
	template = '<div class="chat-message house"><b>[House]:</b> Kamu membatalkan penjualan!</div>',
	args = { " " }})
end)
------------------------------- GARAGE ------------------------------
ESX.RegisterServerCallback('pk_garage:stockv',function(source,cb, vehicleProps)
	local isFound = false
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles(xPlayer.getIdentifier())
	local plate = vehicleProps.plate

		for _,v in pairs(vehicules) do
			if(plate == v.plate)then
				local vehprop = json.encode(vehicleProps)
				isFound = true
				break
			end		
		end
		print(isFound)
		cb(isFound)
end)

function getPlayerVehicles(identifier)
	
	local vehicles = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = identifier})	
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		table.insert(vehicles, {id = v.id, plate = vehicle.plate})
	end
	return vehicles
end

function getHouseVehicles(propiedad)
	--local cochera = 1
	local vehiculos = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM pk_casas WHERE propiedad=@propiedad",{['@propiedad'] = propiedad})	
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		local cords = json.decode(v.cordsvehiculo)
		table.insert(vehiculos, {model = vehicle.model, plate = vehicle.plate, cords = cords, veh = vehicle})
	end
	return vehiculos
end

function getHouseAllVehicles()
	local cochera = 2
	local allvehiculos = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM pk_casas WHERE cochera=@cochera",{['@cochera'] = cochera})	
	for i,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		local cords = json.decode(v.cordsvehiculo)
		table.insert(allvehiculos, {model = vehicle.model, plate = vehicle.plate, cords = cords, veh = vehicle})
	end
	return allvehiculos
end



RegisterServerEvent("pk_casas:spawntodos")
AddEventHandler("pk_casas:spawntodos", function()
	if spawneados == false then
		
		local src = source
        local vehicles = getHouseAllVehicles()
		for _,v in pairs(vehicles) do
				local modelodelauto	= v.model
				local propiedades = v.veh
				local x = v.cords.x
				local y = v.cords.y
				local z = v.cords.z
				local h = v.cords.h
				Citizen.Wait(1)
				TriggerClientEvent('pk_garage:spawnautos', src,modelodelauto,propiedades, x, y, z -1, h)
		end
		spawneados = true
	else
		--print("ya spawneados")
	end
end)

function getHouseVehicles1(propiedad)
	--local cochera = 1
	local vehiculos = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM pk_casas WHERE cochera=@cochera",{['@cochera'] = 2})	
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		local cords = json.decode(v.cordsvehiculo)
		table.insert(vehiculos, {model = vehicle.model, plate = vehicle.plate, cords = cords, veh = vehicle})
	end
	return vehiculos
end

RegisterServerEvent('pk_garage:guardarvehiculo')
AddEventHandler('pk_garage:guardarvehiculo', function(vehicleProps,propiedad)
	local isFound = false
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles(xPlayer.getIdentifier())
	local plate = vehicleProps.plate
	local encasa = 1
	
	for _,v in pairs(vehicules) do
			if(plate == v.plate)then
				local idveh = v.id
				local vehprop = json.encode(vehicleProps)
				local cochera = 2
				MySQL.Sync.execute("UPDATE pk_casas SET vehicle =@vehicle WHERE propiedad=@propiedad",{['@vehicle'] = vehprop, ['@propiedad'] = propiedad})
				MySQL.Sync.execute("UPDATE pk_casas SET cochera =@cochera WHERE propiedad=@propiedad",{['@cochera'] = cochera, ['@propiedad'] = propiedad})
				isFound = true
				break
			end		
		end
end)

RegisterServerEvent('pk_garage:sacarvehiculo')
AddEventHandler('pk_garage:sacarvehiculo', function(propiedad, vehicle)
	local isFound = false
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles(xPlayer.getIdentifier())
	local plate = vehicle.plate
	local encasa = 0
	
	for _,v in pairs(vehicules) do
			if(plate == v.plate)then
				local idveh = v.id
				local vehprop = 0
				local cochera = 1
				MySQL.Sync.execute("UPDATE pk_casas SET vehicle =@vehicle WHERE propiedad=@propiedad",{['@vehicle'] = vehprop, ['@propiedad'] = propiedad})
				MySQL.Sync.execute("UPDATE pk_casas SET cochera =@cochera WHERE propiedad=@propiedad",{['@cochera'] = cochera, ['@propiedad'] = propiedad})
				isFound = true
				break
			end		
		end
end)


RegisterServerEvent('pk_garage:mostrarvehiculos')
AddEventHandler('pk_garage:mostrarvehiculos', function(propiedad)
local src = source
local vehicles = getHouseVehicles(propiedad)
	
		for _,v in pairs(vehicles) do
				local modelodelauto	= v.model
				local propiedades = v.veh
				local x = v.cords.x
				local y = v.cords.y
				local z = v.cords.z
				local h = v.cords.h
				TriggerClientEvent('pk_garage:spawnautos', src,modelodelauto,propiedades, x, y, z, h)
		end
end)


ESX.RegisterServerCallback('pk_garage:obtenergarage', function(source, cb, propiedad)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local garage = {}

	MySQL.Async.fetchAll("SELECT * FROM pk_casas WHERE propiedad=@propiedad",{['@propiedad'] = propiedad}, function(data) 
		for _,v in pairs(data) do
			local cords = json.decode(v.cordsvehiculo)
			if v.vehicle == 0 then
			local vehicle = 0
			table.insert(garage, {cords = cords, cocheraestado = v.cochera, vehicle = vehicle})
			elseif v.vehicle ~= 0 then
			local vehicle = json.decode(v.vehicle)
			table.insert(garage, {cords = cords, cocheraestado = v.cochera, vehicle = vehicle})
			end
		end
		cb(garage)
	end)
end)

-------------------------------- ARMARIO ----------------------------
ESX.RegisterServerCallback('pk_casas:getInventoryV',function(source,cb,plate)
  TriggerEvent('pk_casas:getSharedDataStore',plate,function(store)
    local blackMoney = 0
     local items      = {}
     local weapons    = {}
    weapons = (store.get('weapons') or {})

    local blackAccount = (store.get('black_money')) or 0
    if blackAccount ~=0 then
      blackMoney = blackAccount[1].amount
    end

    local armario = (store.get('armario') or {})
    for i=1,#armario,1 do
      table.insert(items,{name=armario[i].name,count=armario[i].count,label=ESX.GetItemLabel(armario[i].name)})
    end

    cb({
    blackMoney = blackMoney,
    items      = items,
    weapons    = weapons,
    })
  end)
end)


ESX.RegisterServerCallback('pk_casas:getInventoryV1',function(source,cb,propiedad)
  TriggerEvent('pk_casas:getSharedDataStore1',propiedad,function(store)
    local blackMoney = 0
     local items      = {}
     local weapons    = {}
    weapons = (store.get('weapons') or {})

    local blackAccount = (store.get('black_money')) or 0
    if blackAccount ~=0 then
      blackMoney = blackAccount[1].amount
    end

    local armario = (store.get('armario') or {})
    for i=1,#armario,1 do
      table.insert(items,{name=armario[i].name,count=armario[i].count,label=ESX.GetItemLabel(armario[i].name)})
    end
  end)
end)
	
RegisterServerEvent('pk_casas:getItem')
AddEventHandler('pk_casas:getItem', function(propiedad, type, item, count)

  local _source = source
  local xPlayer      = ESX.GetPlayerFromId(_source)
  local _target = target

  if type == 'item_standard' then
	  local itemLimit = xPlayer.getInventoryItem(item).limit
	  local sourceItemCount = xPlayer.getInventoryItem(item).count
  
    TriggerEvent('pk_casas:getSharedDataStore', propiedad, function(store)
      local armario = (store.get('armario') or {})
      for i=1, #armario,1 do
        if armario[i].name == item then
          if (armario[i].count >= count and count > 0) then
		  
		  if (sourceItemCount + count) > 100000000 then
					TriggerClientEvent('esx:showNotification', _source, "No tienes mas espacio en el inventario")
					
		  else
            xPlayer.addInventoryItem(item, count)
            if (armario[i].count - count) == 0 then
              table.remove(armario,i)
            else
              armario[i].count = armario[i].count - count
            end
            break
			end
          else
            --TriggerClientEvent('esx:showNotification', _source, '~r~Cantidad Invalida')
						TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Invalid Ammount!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
          end
        end
      end


      store.set('armario',armario)
    end)
  end

  if type == 'item_account' then

    TriggerEvent('pk_casas:getSharedDataStore', propiedad, function(store)

      local blackMoney = store.get('black_money')
      if (blackMoney[1].amount >= count and count > 0) then
        blackMoney[1].amount = blackMoney[1].amount - count
        store.set('black_money', blackMoney)
        xPlayer.addAccountMoney(item, count)
      else
				--TriggerClientEvent('esx:showNotification', _source,'Monto Invalido')
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Invalid Ammount!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
      end
    end)

  end

  if type == 'item_weapon' then

    TriggerEvent('pk_casas:getSharedDataStore',  propiedad, function(store)

      local storeWeapons = store.get('weapons')

      if storeWeapons == nil then
        storeWeapons = {}
      end

      local weaponName   = nil
      local ammo         = nil

      for i=1, #storeWeapons, 1 do
        if storeWeapons[i].name == item then

          weaponName = storeWeapons[i].name
          ammo       = storeWeapons[i].ammo

          table.remove(storeWeapons, i)

          break
        end
      end

      store.set('weapons', storeWeapons)

      xPlayer.addWeapon(weaponName, ammo)

    end)

  end

end)

RegisterServerEvent('pk_casas:putItem')
AddEventHandler('pk_casas:putItem', function(propiedad, type, item, count,max)

  local _source      = source
  local xPlayer      = ESX.GetPlayerFromId(_source)
  local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

  if type == 'item_standard' then

    local playerItemCount = xPlayer.getInventoryItem(item).count

    if (playerItemCount >= count and count > 0 )then


      TriggerEvent('pk_casas:getSharedDataStore', propiedad, function(store)
        local found = false
        local armario = (store.get('armario') or {})


        for i=1,#armario,1 do
          if armario[i].name == item then
            armario[i].count = armario[i].count + count
            found = true
          end
        end
        if not found then
          table.insert(armario, {
            name = item,
            count = count
          })
        end

          store.set('armario', armario)
          xPlayer.removeInventoryItem(item, count)
      end)

    else
			--TriggerClientEvent('esx:showNotification', _source, 'Cantidad Invalida')
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Invalid Ammount!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    end

  end

  if type == 'item_account' then

    local playerAccountMoney = xPlayer.getAccount(item).money


    if (playerAccountMoney >= count and count > 0) then


      TriggerEvent('pk_casas:getSharedDataStore', propiedad , function(store)

        local blackMoney = (store.get('black_money') or nil)
        if blackMoney ~= nil then
          blackMoney[1].amount = blackMoney[1].amount + count
        else
          blackMoney = {}
          table.insert(blackMoney,{amount=count})
        end

          xPlayer.removeAccountMoney(item, count)
          store.set('black_money', blackMoney)
      end)

    else
			--TriggerClientEvent('esx:showNotification', _source, 'Monto Invalido')
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Invalid Ammount!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    end

  end

  if type == 'item_weapon' then

    TriggerEvent('pk_casas:getSharedDataStore', propiedad, function(store)

      local storeWeapons = store.get('weapons')

      if storeWeapons == nil then
        storeWeapons = {}
      end

      table.insert(storeWeapons, {
        name = item,
        ammo = count
      })

        store.set('weapons', storeWeapons)
        xPlayer.removeWeapon(item)
    end)

  end

end)

ESX.RegisterServerCallback('pk_casas:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local blackMoney = xPlayer.getAccount('black_money').money
  local items      = xPlayer.inventory

  cb({
    blackMoney = blackMoney,
    items      = items
  })

end)

	
