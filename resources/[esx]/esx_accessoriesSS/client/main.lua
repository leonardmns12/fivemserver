local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX								= nil
local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local isDead					= false



  local PlayerData                = {}
  local wear = true
  local component = 0
  local type = 0
  local firstjoin = true
  local clothe = 0
  local maska = true
  local ubieranie = false
  local second = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_accessories:st-wear')
AddEventHandler('esx_accessories:st-wear', function()
TriggerEvent('esx_ciuchy:wear')
firstjoin = false
Citizen.Wait(100)
			SetNuiFocus( true, true )
			SendNUIMessage({
				ativa = true
			})
		end)

function OpenShopMenu(accessory)
	local _accessory = string.lower(accessory)
	local restrict = {}

	restrict = { _accessory .. '_1', _accessory .. '_2' }
	
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm',
		{
			title = _U('valid_purchase'),
			align = 'center',
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes', ESX.Math.GroupDigits(Config.Price)), value = 'yes'}
			}
		}, function(data, menu)
			menu.close()
			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_accessories:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerServerEvent('esx_accessories:pay')
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_accessories:save', skin, accessory)
						end)
					else
						TriggerEvent('esx_skin:getLastSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)
						--ESX.ShowNotification(_U('not_enough_money'))
						exports['mythic_notify']:DoHudText('error', 'Kamu tidak punya cukup uang!')
					end
				end)
			end

			if data.current.value == 'no' then
				local player = PlayerPedId()
				TriggerEvent('esx_skin:getLastSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
				if accessory == "Ears" then
					ClearPedProp(player, 2)
				elseif accessory == "Mask" then
					SetPedComponentVariation(player, 1, 0 ,0, 2)
				elseif accessory == "Helmet" then
					ClearPedProp(player, 0)
				elseif accessory == "Glasses" then
					SetPedPropIndex(player, 1, -1, 0, 0)
				end
			end
			CurrentAction     = 'shop_menu'
			--CurrentActionMsg  = _U('press_access')
			CurrentActionData = {}
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'shop_menu'
			--CurrentActionMsg  = _U('press_access')
			CurrentActionData = {}

		end)
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'shop_menu'
		--CurrentActionMsg  = _U('press_access')
		CurrentActionData = {}
	end, restrict)
end

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('esx_accessories:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	--CurrentActionMsg  = _U('press_access')
	CurrentActionData = { accessory = zone }
end)

AddEventHandler('esx_accessories:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create Blips --
Citizen.CreateThread(function()
	for k,v in pairs(Config.ShopsBlips) do
		if v.Pos ~= nil then
			for i=1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)

				SetBlipSprite (blip, v.Blip.sprite)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 1.0)
				SetBlipColour (blip, v.Blip.color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('shop', _U(string.lower(k))))
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)


-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 5 then
				local Dziala = {
					["x"] = v.Pos[i].x,
					["y"] = v.Pos[i].y,
					["z"] = v.Pos[i].z + 0.4
				}
				ESX.Game.Utils.DrawText3D(Dziala, v.Tekst, 0.6)
				end
			end
		end
	end
end)




Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil
		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x then
					isInMarker  = true
					currentZone = k
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_accessories:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_accessories:hasExitedMarker', LastZone)
		end

	end
end)


-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) and CurrentActionData.accessory then
				OpenShopMenu(CurrentActionData.accessory)
				CurrentAction = nil
			end
		elseif CurrentAction == nil and not Config.EnableControls then
			Citizen.Wait(500)
		end

		if Config.EnableControls then
			if GetLastInputMethod(2) and not isDead then
		if IsControlJustReleased(0, Keys['K']) and not firstjoin then
						SetNuiFocus( true, true )
			SendNUIMessage({
				ativa = true
			})
elseif IsControlJustReleased(0, Keys['K']) and firstjoin then
TriggerEvent('esx_ciuchy:wear')

firstjoin = false
Citizen.Wait(100)
			SetNuiFocus( true, true )
			SendNUIMessage({
				ativa = true
			})


		end
			end
		end

	end
end)




function menux2()
	  ESX.UI.Menu.CloseAll()
  
	  ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'clothes',
	  {
		  title    = 'Menu Toko',
		  align    = 'top-left',
		  elements = {
			  {label = 'Topi/Helm',		value = 'hat'},
			  {label = 'Kacamata',		value = 'glasses'},
			  {label = 'Masker',		value = 'mask'},
			  {label = 'Chain',		value = 'chain'},
			  {label = 'Tas',		value = 'bag'},
			  {label = 'Jaket',	value = 'coat'},
			  {label = 'Celana',	value = 'legs'},
			  {label = 'Sepatu',		value = 'shoes'},
  
  
		  }
	  }, function(data, menu)
  
  --thirst15
  --legs14 1
  --torso 15
  --arms15
  --shoes34

  

					  local action = data.current.value
  if action == 'chain' and not ubieranie then
					  animkachain()
  ubieranie = true
					  Wait(1400)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
					  
  if 0 == GetPedDrawableVariation(GetPlayerPed(-1), 7) then
  TriggerServerEvent('esx_ciuchy:szalik')
  else
  SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)
  
  end
  
  elseif action == 'mask' then
  if 0 == GetPedDrawableVariation(GetPlayerPed(-1), 1) then
					animka_zakladaniemask()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  TriggerServerEvent('esx_ciuchy:maska')
  else
					animka_zdejmowaniemask()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 2)
  end
 
  
 
  elseif action == 'hat' then
  if 8 == GetPedPropIndex(GetPlayerPed(-1), 0) or 57 == GetPedPropIndex(GetPlayerPed(-1), 0) then
						animka_zakldaniegora()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  TriggerServerEvent('esx_ciuchy:czapka')
  else
						animka_zdejmowaniegora()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  TriggerEvent('skinchanger:getSkin', function(skin)
  if skin.sex == 0 then
  SetPedPropIndex(GetPlayerPed(-1), 0, 8, 0, true)
  else
  SetPedPropIndex(GetPlayerPed(-1), 0, 57, 0, true)
  end
  end)
  end

 






  

	
  elseif action == 'glasses' then
  if 0 == GetPedPropIndex(GetPlayerPed(-1), 1) or 5 ==  GetPedPropIndex(GetPlayerPed(-1), 1) then
					animka_zakldaniegora()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  TriggerServerEvent('esx_ciuchy:okulary')
  else
						animka_zdejmowaniegora()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
  if skin.sex == 0 then
   SetPedPropIndex(GetPlayerPed(-1), 1, 0, 0, true)
  else
   SetPedPropIndex(GetPlayerPed(-1), 1, 5, 0, true)
  end
  end)
  end

  
												  
					  elseif action == 'bag' and not ubieranie then
						animka_torba()
  ubieranie = true
					  Wait(1400)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
									 if 0 == GetPedDrawableVariation(GetPlayerPed(-1), 5) then
  TriggerServerEvent('esx_ciuchy:torba')
  else
  SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 2)
  
  end
  
  
  
					  elseif action == 'coat' and not ubieranie then
  
						animka_kurtka()
  ubieranie = true
					  Wait(1400)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  
	  if 15 == GetPedDrawableVariation(GetPlayerPed(-1), 8) or 15 == GetPedDrawableVariation(GetPlayerPed(-1), 11) then
  TriggerServerEvent('esx_ciuchy:kurtka')
  else
  
  
  SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)
  SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 2)
  SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)
  SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)
  end
  
  
					  
					  elseif action == 'legs' and not ubieranie then
						animka_spodnie()
  ubieranie = true
					  Wait(1400)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  
	  TriggerEvent('skinchanger:getSkin', function(skin)
	  if 14 == GetPedDrawableVariation(GetPlayerPed(-1), 4) and skin.sex == 0 or  17 == GetPedDrawableVariation(GetPlayerPed(-1), 4) and skin.sex == 1 then
  
  TriggerServerEvent('esx_ciuchy:spodnie')
  else
  
		  if skin.sex == 0 then
			  SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 0, 2)
  else
		  SetPedComponentVariation(GetPlayerPed(-1), 4, 17, 1, 2)
  end
  end
  end)
  
  
  
  
					  elseif action == 'shoes' and not ubieranie then
						animkabuty()
  ubieranie = true
					  Wait(1400)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
	  TriggerEvent('skinchanger:getSkin', function(skin)
		   if 34 == GetPedDrawableVariation(GetPlayerPed(-1), 6) and skin.sex == 0 or  35 == GetPedDrawableVariation(GetPlayerPed(-1), 6) and skin.sex == 1 then
  
  TriggerServerEvent('esx_ciuchy:buty')
  else
  if skin.sex == 0 then
  SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 2)
  else
  SetPedComponentVariation(GetPlayerPed(-1), 6, 35, 0, 2)
  end
  end
  end)
  
  
  
end
  
  
  
  
  
	  
  
end, function(data, menu)
		  menu.close()
end)
  end
  
  
  
  
  RegisterNetEvent('esx_ciuchy:wear')
  AddEventHandler('esx_ciuchy:wear', function()
  
  mask= GetPedDrawableVariation(GetPlayerPed(-1), 1)
  mask1 = GetPedTextureVariation(GetPlayerPed(-1), 1)
  bag = GetPedDrawableVariation(GetPlayerPed(-1), 5)
  bag1 = GetPedTextureVariation(GetPlayerPed(-1), 5)
  tshirt = GetPedDrawableVariation(GetPlayerPed(-1), 8)
  thsirt1 = GetPedTextureVariation(GetPlayerPed(-1), 8)
  torso = GetPedDrawableVariation(GetPlayerPed(-1), 11)
  torso1 = GetPedTextureVariation(GetPlayerPed(-1), 11)
  legs = GetPedDrawableVariation(GetPlayerPed(-1), 4)
  legs1 = GetPedTextureVariation(GetPlayerPed(-1), 4)
  boots = GetPedDrawableVariation(GetPlayerPed(-1), 6)
  boots1 = GetPedTextureVariation(GetPlayerPed(-1), 6)
  arms = GetPedDrawableVariation(GetPlayerPed(-1), 3)
  chain = GetPedDrawableVariation(GetPlayerPed(-1), 7)
  chain1 = GetPedTextureVariation(GetPlayerPed(-1), 7)
  mask= GetPedDrawableVariation(GetPlayerPed(-1), 1)
  mask1 = GetPedTextureVariation(GetPlayerPed(-1), 1)
  decals= GetPedDrawableVariation(GetPlayerPed(-1), 10)
  decals1 = GetPedTextureVariation(GetPlayerPed(-1), 10)
  hat = GetPedPropIndex(GetPlayerPed(-1), 0)
  hat1 = GetPedPropTextureIndex(GetPlayerPed(-1), 0)
  glasses = GetPedPropIndex(GetPlayerPed(-1), 1)
  glasses1 = GetPedPropTextureIndex(GetPlayerPed(-1), 1)
	  TriggerServerEvent('esx_ciuchy:dodaj', bag, bag1, tshirt, thsirt1, torso, torso1, legs, legs1, boots, boots1, arms, chain,chain1,mask,mask1,decals,decals1,hat,hat1,glasses,glasses1)
  
  end)
  RegisterNetEvent('esx_ciuchy:ubierz')
  AddEventHandler('esx_ciuchy:ubierz', function(id1,id2, id3)
	  local playerPed       = PlayerPedId()
  SetPedComponentVariation(GetPlayerPed(-1), id3, id1, id2, 2)
  
  end)
  RegisterNetEvent('esx_ciuchy:prop')
  AddEventHandler('esx_ciuchy:prop', function(id1,id2, id3)
	  local playerPed       = PlayerPedId()
  SetPedPropIndex(GetPlayerPed(-1), id3, id1, id2, true)
  
  end)
  

 function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait(10)
    end
end


 function animkabuty()
	local dict = "amb@medic@standing@kneel@base"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "base", 8.0, 8.0, -1, 11, 0, false, false, false)
end

  function animkachain()
	local dict = "clothingtrousers"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "check_out_a", 8.0, 8.0, -1, 50, 0, false, false, false)
end

function animka_spodnie()
	local dict = "clothingshoes"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "try_shoes_positive_a", 8.0, 8.0, -1, 50, 0, false, false, false)
end



function animka_zakladaniemask()
	local dict = "mp_masks@on_foot"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "put_on_mask", 8.0, 8.0, -1, 50, 0, false, false, false)
end

function animka_zdejmowaniemask()
	local dict = "missfbi4"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "takeoff_mask", 8.0, 8.0, -1, 50, 0, false, false, false)
end


function animka_zakldaniegora()
	local dict = "mp_masks@on_foot"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "put_on_mask", 8.0, 8.0, -1, 50, 0, false, false, false)
end


function animka_zdejmowaniegora()
	local dict = "missfbi4"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "takeoff_mask", 8.0, 8.0, -1, 50, 0, false, false, false)
end


function animka_torba()
	local dict = "clothingshirt"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "check_out_a", 8.0, 8.0, -1, 50, 0, false, false, false)
end


function animka_kurtka()
	local dict = "clothingshirt"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "check_out_c", 8.0, 8.0, -1, 50, 0, false, false, false)
end


RegisterCommand('ciuchy', function()
  TriggerEvent('otworz:visionmenu', source)
end, false)


RegisterNetEvent('otworz:visionmenu')
AddEventHandler('otworz:visionmenu', function()

			SetNuiFocus( true, true )
			SendNUIMessage({
				ativa = true
			})
		
end)





RegisterNUICallback('1', function(data, cb) --Czapka
	  if 8 == GetPedPropIndex(GetPlayerPed(-1), 0) or 57 == GetPedPropIndex(GetPlayerPed(-1), 0) then
						animka_zakldaniegora()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  TriggerServerEvent('esx_ciuchy:czapka')
  else
						animka_zdejmowaniegora()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  TriggerEvent('skinchanger:getSkin', function(skin)
  if skin.sex == 0 then
  SetPedPropIndex(GetPlayerPed(-1), 0, 8, 0, true)
  else
  SetPedPropIndex(GetPlayerPed(-1), 0, 57, 0, true)
  end
  end)
  end
  
  	print('Działa')
end)

RegisterNUICallback('2', function(data, cb) --Maska
	  if 0 == GetPedDrawableVariation(GetPlayerPed(-1), 1) then
					animka_zakladaniemask()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  TriggerServerEvent('esx_ciuchy:maska')
  else
					animka_zdejmowaniemask()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 2)
  
  end
  	print('Działa')
end)

RegisterNUICallback('3', function(data, cb) --Okulary
	  if 0 == GetPedPropIndex(GetPlayerPed(-1), 1) or 5 ==  GetPedPropIndex(GetPlayerPed(-1), 1) then
					animka_zakldaniegora()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  TriggerServerEvent('esx_ciuchy:okulary')
  else
						animka_zdejmowaniegora()
  ubieranie = true
					  Wait(1000)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
  if skin.sex == 0 then
   SetPedPropIndex(GetPlayerPed(-1), 1, 0, 0, true)
  else
   SetPedPropIndex(GetPlayerPed(-1), 1, 5, 0, true)
  end
  end)
  end
  	print('Działa')
end)

RegisterNUICallback('4', function(data, cb) --Szalik
  if not ubieranie then
					  animkachain()
  ubieranie = true
					  Wait(1400)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
					  
  if 0 == GetPedDrawableVariation(GetPlayerPed(-1), 7) then
  TriggerServerEvent('esx_ciuchy:szalik')
  else
  SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)
  
  end
  end
end)

RegisterNUICallback('5', function(data, cb) --Torba
	if not ubieranie then
						animka_torba()
  ubieranie = true
					  Wait(1400)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
									 if 0 == GetPedDrawableVariation(GetPlayerPed(-1), 5) then
  TriggerServerEvent('esx_ciuchy:torba')
  else
  SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 2)
  
  end
  end
end)

RegisterNUICallback('6', function(data, cb) --Kurtka / Koszulka i inne chujstwa
	if not ubieranie then
  
						animka_kurtka()
  ubieranie = true
					  Wait(1400)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  
	  if 15 == GetPedDrawableVariation(GetPlayerPed(-1), 8) or 15 == GetPedDrawableVariation(GetPlayerPed(-1), 11) then
  TriggerServerEvent('esx_ciuchy:kurtka')
  else
  
  
  SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)
  SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 2)
  SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)
  SetPedComponentVariation(GetPlayerPed(-1), 10, 0, 0, 2)
  end
  end
end)

RegisterNUICallback('7', function(data, cb)
					  if not ubieranie then
						animka_spodnie()
  ubieranie = true
					  Wait(1400)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
  
	  TriggerEvent('skinchanger:getSkin', function(skin)
	  if 14 == GetPedDrawableVariation(GetPlayerPed(-1), 4) and skin.sex == 0 or  17 == GetPedDrawableVariation(GetPlayerPed(-1), 4) and skin.sex == 1 then
  
  TriggerServerEvent('esx_ciuchy:spodnie')
  else
  
		  if skin.sex == 0 then
			  SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 0, 2)
  else
		  SetPedComponentVariation(GetPlayerPed(-1), 4, 17, 1, 2)
  end
  end
  end)
  end
  
  
  

end)

RegisterNUICallback('8', function(data, cb)
					  if not ubieranie then
						animkabuty()
  ubieranie = true
					  Wait(1400)
  ubieranie = false
				  ClearPedTasks(GetPlayerPed(-1))
	  TriggerEvent('skinchanger:getSkin', function(skin)
		   if 34 == GetPedDrawableVariation(GetPlayerPed(-1), 6) and skin.sex == 0 or  35 == GetPedDrawableVariation(GetPlayerPed(-1), 6) and skin.sex == 1 then
  
  TriggerServerEvent('esx_ciuchy:buty')
  else
  if skin.sex == 0 then
  SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 2)
  else
  SetPedComponentVariation(GetPlayerPed(-1), 6, 35, 0, 2)
  end
  end
  end)
  end
end)


RegisterNUICallback('9', function(data, cb)
	SetNuiFocus( false )
	SendNUIMessage({
	ativa = false
	})
end)

RegisterNUICallback('fechar', function(data, cb)
	SetNuiFocus( false )
	SendNUIMessage({
	ativa = false
	})
  	
end)	
	
	
	
	
	
	
	
