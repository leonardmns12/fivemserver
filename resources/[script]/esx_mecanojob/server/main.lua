ESX                = nil
PlayersHarvesting  = {}
PlayersHarvesting2 = {}
PlayersHarvesting3 = {}
PlayersCrafting    = {}
PlayersCrafting2   = {}
PlayersCrafting3   = {}

local logs = "https://discordapp.com/api/webhooks/710035680402735144/emN96EtOFBAzjsaaCa6_s_ssaSHFhk0B6DJXK3nqpJqQRIZ-l8Mtr2o5-D9Wy_BMTJ99"

local communityname = "INDOFOLKS ROLEPLAY"
local communtiylogo = "https://i.imgur.com/fZZWZ5l.png" 


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'mecano', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'mecano', _U('mechanic_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'mecano', 'Mecano', 'society_mecano', 'society_mecano', 'society_mecano', {type = 'public'})

-------------- Récupération bouteille de gaz -------------
---- Sqlut je teste ------
local function Harvest(source)

  SetTimeout(4000, function()

    if PlayersHarvesting[source] == true then

      local xPlayer  = ESX.GetPlayerFromId(source)
      local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count
      
      if GazBottleQuantity >= 5 then
        -- TriggerClientEvent('esx:showNotification', source, _U('you_do_not_room'))
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Anda tidak dapat menambah botol gas lagi', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
      else
                xPlayer.addInventoryItem('gazbottle', 1)

        Harvest(source)
      end
    end
  end)
end

RegisterServerEvent('esx_mecanojob:startHarvest')
AddEventHandler('esx_mecanojob:startHarvest', function()
  local _source = source
  PlayersHarvesting[_source] = true
  -- TriggerClientEvent('esx:showNotification', _source, _U('recovery_gas_can'))
  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Anda sedang mengambil botol gas' , length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
  Harvest(source)
end)

RegisterServerEvent('esx_mecanojob:stopHarvest')
AddEventHandler('esx_mecanojob:stopHarvest', function()
  local _source = source
  PlayersHarvesting[_source] = false
end)
------------ Récupération Outils Réparation --------------
local function Harvest2(source)

  SetTimeout(4000, function()

    if PlayersHarvesting2[source] == true then

      local xPlayer  = ESX.GetPlayerFromId(source)
      local FixToolQuantity  = xPlayer.getInventoryItem('fixtool').count
      if FixToolQuantity >= 5 then
        -- TriggerClientEvent('esx:showNotification', source, _U('you_do_not_room'))
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Anda tidak dapat menambah alat repair lagi', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
      else
                xPlayer.addInventoryItem('fixtool', 1)

        Harvest2(source)
      end
    end
  end)
end

RegisterServerEvent('esx_mecanojob:startHarvest2')
AddEventHandler('esx_mecanojob:startHarvest2', function()
  local _source = source
  PlayersHarvesting2[_source] = true
  -- TriggerClientEvent('esx:showNotification', _source, _U('recovery_repair_tools'))
  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Anda sedang mengambil alat repair', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
  Harvest2(_source)
end)

RegisterServerEvent('esx_mecanojob:stopHarvest2')
AddEventHandler('esx_mecanojob:stopHarvest2', function()
  local _source = source
  PlayersHarvesting2[_source] = false
end)
----------------- Récupération Outils Carosserie ----------------
local function Harvest3(source)

  SetTimeout(4000, function()

    if PlayersHarvesting3[source] == true then

      local xPlayer  = ESX.GetPlayerFromId(source)
      local CaroToolQuantity  = xPlayer.getInventoryItem('carotool').count
            if CaroToolQuantity >= 5 then
        -- TriggerClientEvent('esx:showNotification', source, _U('you_do_not_room'))
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Anda tidak dapat menambah Body Part lagi', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
      else
                xPlayer.addInventoryItem('carotool', 1)

        Harvest3(source)
      end
    end
  end)
end

RegisterServerEvent('esx_mecanojob:startHarvest3')
AddEventHandler('esx_mecanojob:startHarvest3', function()
  local _source = source
  PlayersHarvesting3[_source] = true
  -- TriggerClientEvent('esx:showNotification', _source, _U('recovery_body_tools'))
  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Anda sedang mengambil Body Part', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
  Harvest3(_source)
end)

RegisterServerEvent('esx_mecanojob:stopHarvest3')
AddEventHandler('esx_mecanojob:stopHarvest3', function()
  local _source = source
  PlayersHarvesting3[_source] = false
end)
------------ Craft Chalumeau -------------------
local function Craft(source)

  SetTimeout(4000, function()

    if PlayersCrafting[source] == true then

      local xPlayer  = ESX.GetPlayerFromId(source)
      local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count

      if GazBottleQuantity <= 0 then
        -- TriggerClientEvent('esx:showNotification', source, _U('not_enough_gas_can'))
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Anda tidak memiliki cukup botol gas', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
      else
                xPlayer.removeInventoryItem('gazbottle', 1)
                xPlayer.addInventoryItem('blowtorch', 1)

        Craft(source)
      end
    end
  end)
end

RegisterServerEvent('esx_mecanojob:startCraft')
AddEventHandler('esx_mecanojob:startCraft', function()
  local _source = source
  PlayersCrafting[_source] = true
  local xPlayer = ESX.GetPlayerFromId(_source)  
  local name = GetPlayerName(source)
  local steamhex = GetPlayerIdentifier(source)

  local connect = {
    {
      ["color"] = "14886454",
      ["title"] = "Player membuat blowtorch!",
      ["description"] = "Player: **"..name.."**\n\nSteam Hex: **"..steamhex.."**",
      ["footer"] = {
        ["text"] = communityname,
        ["icon_url"] = communtiylogo,
      },
    }
  }																								
  PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Indofolks Server Logger", embeds = connect}), { ['Content-Type'] = 'application/json' })


  -- TriggerClientEvent('esx:showNotification', _source, _U('assembling_blowtorch'))
  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Anda sedang membuat Blowtorch', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
  Craft(_source)
end)

RegisterServerEvent('esx_mecanojob:stopCraft')
AddEventHandler('esx_mecanojob:stopCraft', function()
  local _source = source
  PlayersCrafting[_source] = false
end)
------------ Craft kit Réparation --------------
local function Craft2(source)

  SetTimeout(4000, function()

    if PlayersCrafting2[source] == true then

      local xPlayer  = ESX.GetPlayerFromId(source)
      local FixToolQuantity  = xPlayer.getInventoryItem('fixtool').count
      if FixToolQuantity <= 0 then
        -- TriggerClientEvent('esx:showNotification', source, _U('not_enough_repair_tools'))
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Anda tidak memiliki cukup Repair Kit', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
      else
                xPlayer.removeInventoryItem('fixtool', 1)
                xPlayer.addInventoryItem('fixkit', 1)

        Craft2(source)
      end
    end
  end)
end

RegisterServerEvent('esx_mecanojob:startCraft2')
AddEventHandler('esx_mecanojob:startCraft2', function()
  local _source = source
  PlayersCrafting2[_source] = true
  -- TriggerClientEvent('esx:showNotification', _source, _U('assembling_blowtorch'))
  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Anda sedang membuat Repair Kit', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
  Craft2(_source)
end)

RegisterServerEvent('esx_mecanojob:stopCraft2')
AddEventHandler('esx_mecanojob:stopCraft2', function()
  local _source = source
  PlayersCrafting2[_source] = false
end)
----------------- Craft kit Carosserie ----------------
local function Craft3(source)

  SetTimeout(4000, function()

    if PlayersCrafting3[source] == true then

      local xPlayer  = ESX.GetPlayerFromId(source)
      local CaroToolQuantity  = xPlayer.getInventoryItem('carotool').count
            if CaroToolQuantity <= 0 then
        -- TriggerClientEvent('esx:showNotification', source, _U('not_enough_body_tools'))
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Anda tidak memiliki Body Part', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
      else
                xPlayer.removeInventoryItem('carotool', 1)
                xPlayer.addInventoryItem('carokit', 1)

        Craft3(source)
      end
    end
  end)
end

RegisterServerEvent('esx_mecanojob:startCraft3')
AddEventHandler('esx_mecanojob:startCraft3', function()
  local _source = source
  PlayersCrafting3[_source] = true
  -- TriggerClientEvent('esx:showNotification', _source, _U('assembling_body_kit'))
  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Anda sedang membuat Body Kit', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
  Craft3(_source)
end)

RegisterServerEvent('esx_mecanojob:stopCraft3')
AddEventHandler('esx_mecanojob:stopCraft3', function()
  local _source = source
  PlayersCrafting3[_source] = false
end)

---------------------------- register usable item --------------------------------------------------
ESX.RegisterUsableItem('blowtorch', function(source)

  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)

  xPlayer.removeInventoryItem('blowpipe', 1)

  TriggerClientEvent('esx_mecanojob:onHijack', _source)
    -- TriggerClientEvent('esx:showNotification', _source, _U('you_used_blowtorch'))
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Anda telah menggunakan blowtorch', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

end)

ESX.RegisterUsableItem('fixkit', function(source)

  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)

  xPlayer.removeInventoryItem('fixkit', 1)

  TriggerClientEvent('esx_mecanojob:onFixkit', _source)
    -- TriggerClientEvent('esx:showNotification', _source, _U('you_used_repair_kit'))
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Anda telah menggunakan repair kit', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

end)

ESX.RegisterUsableItem('carokit', function(source)

  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)

  xPlayer.removeInventoryItem('carokit', 1)

  TriggerClientEvent('esx_mecanojob:onCarokit', _source)
    -- TriggerClientEvent('esx:showNotification', _source, _U('you_used_body_kit'))
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Anda telah menggunakan body kit', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

end)

----------------------------------
---- Ajout Gestion Stock Boss ----
----------------------------------

RegisterServerEvent('esx_mecanojob:getStockItem')
AddEventHandler('esx_mecanojob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      -- TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
      TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Jumlah invalid!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    end

    -- TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)
    TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Anda telah mengambil ' ..item.label.. ' sebanyak ' ..count, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

  end)

end)

ESX.RegisterServerCallback('esx_mecanojob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)
    cb(inventory.items)
  end)

end)

-------------
-- AJOUT 2 --
-------------

RegisterServerEvent('esx_mecanojob:putStockItems')
AddEventHandler('esx_mecanojob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mecano', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      -- TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
      TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Jumlah invalid!', length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })
    end

    -- TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)
    TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'success', text = 'Anda telah menambahkan ' ..item.label.. ' sebanyak ' ..count, length = 2500, style = { ['background-color'] = '#2f5c73f', ['color'] = '#ffffff' } })

  end)

end)

--ESX.RegisterServerCallback('esx_mecanojob:putStockItems', function(source, cb)

--  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_policestock', function(inventory)
--    cb(inventory.items)
--  end)

--end)

ESX.RegisterServerCallback('esx_mecanojob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
