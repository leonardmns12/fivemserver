ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingCoke    = {}
local PlayersTransformingCoke  = {}
local PlayersSellingCoke       = {}
local PlayersHarvestingMeth    = {}
local PlayersTransformingMeth  = {}
local PlayersSellingMeth       = {}
local PlayersHarvestingWeed    = {}
local PlayersTransformingWeed  = {}
local PlayersSellingWeed       = {}
local PlayersHarvestingOpium   = {}
local PlayersTransformingOpium = {}
local PlayersSellingOpium      = {}
local PlayersHarvestingMoonshine   = {}
local PlayersTransformingMoonshine = {}
local PlayersSellingMoonshine     = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(5000, CountCops)

end

CountCops()

--coke
local function HarvestCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Need atleast one police to farm', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(5000, function()

		if PlayersHarvestingCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local coke = xPlayer.getInventoryItem('coke')

			if coke.limit ~= -1 and coke.count >= coke.limit then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_coke'))
			else
				xPlayer.addInventoryItem('coke', 1)
				HarvestCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestCoke')
AddEventHandler('esx_drugs:startHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Pickup in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	HarvestCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestCoke')
AddEventHandler('esx_drugs:stopHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = false

end)

local function TransformCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Need atleast one police', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(10000, function()

		if PlayersTransformingCoke[source] == true then

			  local _source = source
  			  local xPlayer = ESX.GetPlayerFromId(_source)

			local cokeQuantity = xPlayer.getInventoryItem('coke').count
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity > 15 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'to many bag', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			elseif cokeQuantity < 28 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'not enough coke', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.removeInventoryItem('coke', 28)
				xPlayer.addInventoryItem('coke_pooch', 1)
			
				TransformCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformCoke')
AddEventHandler('esx_drugs:startTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Packing in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
	
	TransformCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformCoke')
AddEventHandler('esx_drugs:stopTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = false

end)

local function SellCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Need one police to sell', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(7500, function()

		if PlayersSellingCoke[source] == true then

			  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'No bag to sell', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.removeInventoryItem('coke_pooch', 1)
				if CopsConnected == 1 then
                    xPlayer.addAccountMoney('black_money', 3000)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one coke', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 2 then
                    xPlayer.addAccountMoney('black_money', 3200)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one coke', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 3 then
                    xPlayer.addAccountMoney('black_money', 3400)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one coke', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected >= 4 then
                    xPlayer.addAccountMoney('black_money', 3600)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one coke', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                end
				
				SellCoke(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellCoke')
AddEventHandler('esx_drugs:startSellCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sale in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	SellCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopSellCoke')
AddEventHandler('esx_drugs:stopSellCoke', function()

	local _source = source

	PlayersSellingCoke[_source] = false

end)

--meth
local function HarvestMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end
	
	SetTimeout(5000, function()

		if PlayersHarvestingMeth[source] == true then

			  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

			local meth = xPlayer.getInventoryItem('meth')

			if meth.limit ~= -1 and meth.count >= meth.limit then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Inventory Full', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.addInventoryItem('meth', 1)
				HarvestMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestMeth')
AddEventHandler('esx_drugs:startHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Pickup in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	HarvestMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestMeth')
AddEventHandler('esx_drugs:stopHarvestMeth', function()

	local _source = source

	PlayersHarvestingMeth[_source] = false

end)

local function TransformMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = '2 Cops Required to farm', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(12000, function()

		if PlayersTransformingMeth[source] == true then

			  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

			local methQuantity = xPlayer.getInventoryItem('meth').count
			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity > 15 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'to many bag', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			elseif methQuantity < 28 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Not Enough Meth', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.removeInventoryItem('meth', 28)
				xPlayer.addInventoryItem('meth_pooch', 1)
				
				TransformMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformMeth')
AddEventHandler('esx_drugs:startTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Packing in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	TransformMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformMeth')
AddEventHandler('esx_drugs:stopTransformMeth', function()

	local _source = source

	PlayersTransformingMeth[_source] = false

end)

local function SellMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You need police to sell', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(7500, function()

		if PlayersSellingMeth[source] == true then

			  local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'No bag left', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.removeInventoryItem('meth_pooch', 1)
				if CopsConnected == 1 then
                    xPlayer.addAccountMoney('black_money', 3400)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one meth', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 2 then
                    xPlayer.addAccountMoney('black_money', 3600)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one meth', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 3 then
                    xPlayer.addAccountMoney('black_money', 3800)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one meth', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 4 then
                    xPlayer.addAccountMoney('black_money', 4000)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one meth', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected >= 5 then
                    xPlayer.addAccountMoney('black_money', 4200)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one meth', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                end
				
				SellMeth(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellMeth')
AddEventHandler('esx_drugs:startSellMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sale in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	SellMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopSellMeth')
AddEventHandler('esx_drugs:stopSellMeth', function()

	local _source = source

	PlayersSellingMeth[_source] = false

end)

--weed
local function HarvestWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Need atleast one police to farm', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(5000, function()

		if PlayersHarvestingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local weed = xPlayer.getInventoryItem('weed')

			if weed.limit ~= -1 and weed.count >= weed.limit then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Inventory Full', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.addInventoryItem('weed', 1)
				HarvestWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestWeed')
AddEventHandler('esx_drugs:startHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Pickup in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	HarvestWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestWeed')
AddEventHandler('esx_drugs:stopHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = false

end)

local function TransformWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Need atleast one police', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(7500, function()

		if PlayersTransformingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			local weedQuantity = xPlayer.getInventoryItem('weed').count
			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity > 15 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'To many bag', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			elseif weedQuantity < 28 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Not enough weed', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.removeInventoryItem('weed', 28)
				xPlayer.addInventoryItem('weed_pooch', 1)
				
				TransformWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformWeed')
AddEventHandler('esx_drugs:startTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Packing in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	TransformWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformWeed')
AddEventHandler('esx_drugs:stopTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = false

end)

local function SellWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Police required!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(7500, function()

		if PlayersSellingWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'No bag to sell', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.removeInventoryItem('weed_pooch', 1)
                if CopsConnected == 0 then
                    xPlayer.addAccountMoney('black_money', 1000)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one weed', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 1 then
                    xPlayer.addAccountMoney('black_money', 2000)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one weed', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 2 then
                    xPlayer.addAccountMoney('black_money', 2200)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one weed', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 3 then
                    xPlayer.addAccountMoney('black_money', 2400)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one weed', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected >= 4 then
                    xPlayer.addAccountMoney('black_money', 2600)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one weed', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                end
				
				SellWeed(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellWeed')
AddEventHandler('esx_drugs:startSellWeed', function()

	local _source = source

	PlayersSellingWeed[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sale in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	SellWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopSellWeed')
AddEventHandler('esx_drugs:stopSellWeed', function()

	local _source = source

	PlayersSellingWeed[_source] = false

end)


--opium

local function HarvestOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Need one police to farm', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(5000, function()

		if PlayersHarvestingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local opium = xPlayer.getInventoryItem('opium')

			if opium.limit ~= -1 and opium.count >= opium.limit then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Inventory Full', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.addInventoryItem('opium', 1)
				HarvestOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestOpium')
AddEventHandler('esx_drugs:startHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Pickup in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	HarvestOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestOpium')
AddEventHandler('esx_drugs:stopHarvestOpium', function()

	local _source = source

	PlayersHarvestingOpium[_source] = false

end)

local function TransformOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Need atleast one police to farm', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(10000, function()

		if PlayersTransformingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local opiumQuantity = xPlayer.getInventoryItem('opium').count
			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity > 15 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'to many bag', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			elseif opiumQuantity < 28 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'not enough opium', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.removeInventoryItem('opium', 28)
				xPlayer.addInventoryItem('opium_pooch', 1)
			
				TransformOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformOpium')
AddEventHandler('esx_drugs:startTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Packing in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	TransformOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformOpium')
AddEventHandler('esx_drugs:stopTransformOpium', function()

	local _source = source

	PlayersTransformingOpium[_source] = false

end)

local function SellOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'need atleast one cop to sell', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(7500, function()

		if PlayersSellingOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'no bag to sell', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.removeInventoryItem('opium_pooch', 1)
				if CopsConnected == 1 then
                    xPlayer.addAccountMoney('black_money', 1500)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one opium', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 2 then
                    xPlayer.addAccountMoney('black_money', 2500)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one opium', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 3 then
                    xPlayer.addAccountMoney('black_money', 2750)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one opium', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 4 then
                    xPlayer.addAccountMoney('black_money', 3250)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one opium', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected >= 5 then
                    xPlayer.addAccountMoney('black_money', 3500)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one opium', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                end
				
				SellOpium(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellOpium')
AddEventHandler('esx_drugs:startSellOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sale in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	SellOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopSellOpium')
AddEventHandler('esx_drugs:stopSellOpium', function()

	local _source = source

	PlayersSellingOpium[_source] = false

end)




--moonshine

local function HarvestMoonshine(source)

	if CopsConnected < Config.RequiredCopsMoonshine then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'need atleast one police to farm', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(5000, function()

		if PlayersHarvestingMoonshine[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local moonshine = xPlayer.getInventoryItem('moonshine')

			if moonshine.limit ~= -1 and moonshine.count >= moonshine.limit then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Inventory Full', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.addInventoryItem('moonshine', 1)
				HarvestMoonshine(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestMoonshine')
AddEventHandler('esx_drugs:startHarvestMoonshine', function()

	local _source = source

	PlayersHarvestingMoonshine[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Pickup in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	HarvestMoonshine(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestMoonshine')
AddEventHandler('esx_drugs:stopHarvestMoonshine', function()

	local _source = source

	PlayersHarvestingMoonshine[_source] = false

end)

local function TransformMoonshine(source)

	if CopsConnected < Config.RequiredCopsMoonshine then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Need at least one cop!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(10000, function()

		if PlayersTransformingMoonshine[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local moonshineQuantity = xPlayer.getInventoryItem('moonshine').count
			local poochQuantity = xPlayer.getInventoryItem('moonshine_pooch').count

			if poochQuantity > 15 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'To many bag', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			elseif moonshineQuantity < 28 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Not enough moonshine', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.removeInventoryItem('moonshine', 28)
				xPlayer.addInventoryItem('moonshine_pooch', 1)
			
				TransformMoonshine(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformMoonshine')
AddEventHandler('esx_drugs:startTransformMoonshine', function()

	local _source = source

	PlayersTransformingMoonshine[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Packing in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	TransformMoonshine(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformMoonshine')
AddEventHandler('esx_drugs:stopTransformMoonshine', function()

	local _source = source

	PlayersTransformingMoonshine[_source] = false

end)

local function SellMoonshine(source)

	if CopsConnected < Config.RequiredCopsMoonshine then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Need atleast one police to sell', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
		return
	end

	SetTimeout(7500, function()

		if PlayersSellingMoonshine[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)

			local poochQuantity = xPlayer.getInventoryItem('moonshine_pooch').count

			if poochQuantity == 0 then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'No bag to sell', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
			else
				xPlayer.removeInventoryItem('moonshine_pooch', 1)
				if CopsConnected == 0 then
                    xPlayer.addAccountMoney('black_money', 333)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one moonshine', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 1 then
                    xPlayer.addAccountMoney('black_money', 333)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one moonshine', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 2 then
                    xPlayer.addAccountMoney('black_money', 333)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one moonshine', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 3 then
                    xPlayer.addAccountMoney('black_money', 333)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one moonshine', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                elseif CopsConnected == 4 then
                    xPlayer.addAccountMoney('black_money', 333)
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sold one moonshine', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
                end
				
				SellMoonshine(source)
			end

		end
	end)
end

RegisterServerEvent('esx_drugs:startSellMoonshine')
AddEventHandler('esx_drugs:startSellMoonshine', function()

	local _source = source

	PlayersSellingMoonshine[_source] = true

	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Sale in progress', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

	SellMoonshine(_source)

end)

RegisterServerEvent('esx_drugs:stopSellMoonshine')
AddEventHandler('esx_drugs:stopSellMoonshine', function()

	local _source = source

	PlayersSellingMoonshine[_source] = false

end)

-- RETURN INVENTORY TO CLIENT
RegisterServerEvent('esx_drugs:GetUserInventory')
AddEventHandler('esx_drugs:GetUserInventory', function(currentZone)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx_drugs:ReturnInventory', 
    	_source, 
    	xPlayer.getInventoryItem('coke').count, 
		xPlayer.getInventoryItem('coke_pooch').count,
		xPlayer.getInventoryItem('meth').count, 
		xPlayer.getInventoryItem('meth_pooch').count, 
		xPlayer.getInventoryItem('weed').count, 
		xPlayer.getInventoryItem('weed_pooch').count, 
		xPlayer.getInventoryItem('opium').count, 
		xPlayer.getInventoryItem('opium_pooch').count,
		xPlayer.getInventoryItem('moonshine').count, 
		xPlayer.getInventoryItem('moonshine_pooch').count,
		xPlayer.job.name, 
		currentZone
    )
end)


-- Register Usable Item
ESX.RegisterUsableItem('weed', function(source)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('weed', 1)

	TriggerClientEvent('esx_drugs:onPot', _source)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Use one weed', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

end)

