local ESX = nil
local robbableItems = {
 [1] = {chance = 3, id = 0, name = 'Cash', quantity = math.random(1, 900)}, -- really common
 [2] = {chance = 10, id = 'WEAPON_PISTOL', name = 'Pistol', isWeapon = true}, -- rare
 [3] = {chance = 3, id = 'batteryacid', name = 'Battery acid', quantity = math.random(1, 3)}, -- really common
 [4] = {chance = 5, id = 'weed_pooch', name = 'Bag of Weed', quantity = 1}, -- rare
 [5] = {chance = 4, id = 'ring', name = 'ring', quantity = 1}, -- rare
 [6] = {chance = 5, id = 'goldNecklace', name = 'Gold necklace', quantity = 1}, -- rare
 [7] = {chance = 6, id = 'laptop', name = 'Laptop', quantity = 1}, -- rare
 [8] = {chance = 8, id = 'samsungS10', name = 'Samsung S10', quantity = 1}, -- rare
 [9] = {chance = 8, id = 'rolex', name = 'Rolex', quantity = 1}, -- rare
 [10] = {chance = 3, id = 'camera', name = 'Kamera', quantity = 1}, -- rare
 [11] = {chance = 4, id = 'lockpick', name = 'Lockpick', quantity = 1}, -- rare
 [12] = {chance = 3, id = 'bread', name = 'Roti', quantity = 1}, -- rare
 [13] = {chance = 3, id = 'water', name = 'Air mineral', quantity = 1}, -- rare
 -- [14] = {chance = 5, id = 'samsung_s8', name = 'Samsung S8 (P)', quantity = 1}, -- rare
 -- [15] = {chance = 5, id = 'apple_iphone', name = 'Apple iPhone (P)', quantity = 1}, -- rare
 -- [16] = {chance = 4, id = 'steel', name = 'Steel', quantity = 1}, -- rare
 -- [17] = {chance = 4, id = 'screen', name = 'Screen', quantity = 1}, -- rare
 -- [18] = {chance = 5, id = 'scrap_metal', name = 'Scrap Metal', quantity = 1}, -- rare
 -- [19] = {chance = 2, id = 'rubber', name = 'Rubber', quantity = 1}, -- rare
 -- [20] = {chance = 1, id = 'rolling_paper', name = 'Rolling Paper', quantity = 1}, -- rare
 -- [21] = {chance = 3, id = 'glass', name = 'Glass', quantity = 1}, -- rare
 -- [22] = {chance = 7, id = 'fuse', name = 'Fuse', quantity = 1}, -- rare
 -- [23] = {chance = 8, id = 'clutch', name = 'Clutch', quantity = 1}, -- rare
 -- [24] = {chance = 5, id = 'battery', name = 'Battery', quantity = 1}, -- rare
 -- [25] = {chance = 2, id = 'breadboard', name = 'Breadboard (P)', quantity = 1}, -- rare
 -- [26] = {chance = 7, id = 'white_pearl', name = 'White Pearl (P)', quantity = 1}, -- rare
 -- [27] = {chance = 9, id = 'coke_pooch', name = 'Bag of Coke', quantity = 1}, -- rare
 -- [28] = {chance = 7, id = 'xtc', name = 'X', quantity = 1}, -- rare
 -- [29] = {chance = 8, id = 'electronics', name = 'Electronics (P)', quantity = 1}, -- rare
 -- [30] = {chance = 9, id = 'electronic_kit', name = 'Electronic Kit', quantity = 1}, -- rare
}

--[[chance = 1 is very common, the higher the value the less the chance]]--

TriggerEvent('esx:getSharedObject', function(obj)
 ESX = obj
end)

ESX.RegisterUsableItem('advancedlockpick', function(source) --Hammer high time to unlock but 100% call cops
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 TriggerClientEvent('houseRobberies:attempt', source, xPlayer.getInventoryItem('advancedlockpick').count)
end)

RegisterServerEvent('houseRobberies:removeLockpick')
AddEventHandler('houseRobberies:removeLockpick', function()
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 xPlayer.removeInventoryItem('advancedlockpick', 1)
 --TriggerClientEvent('chatMessage', source, '^1Your lockpick has bent out of shape')
 TriggerClientEvent('notification', source, 'The lockpick bent out of shape.', 2)
end)

RegisterServerEvent('houseRobberies:giveMoney')
AddEventHandler('houseRobberies:giveMoney', function()
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 local cash = math.random(500, 3000)
 xPlayer.addMoney(cash)
 --TriggerClientEvent('chatMessage', source, '^4You have found $'..cash)
 TriggerClientEvent('notification', source, 'You found $'..cash)
end)


RegisterServerEvent('houseRobberies:searchItem')
AddEventHandler('houseRobberies:searchItem', function()
 local source = tonumber(source)
 local item = {}
 local xPlayer = ESX.GetPlayerFromId(source)
 local gotID = {}


 for i=1, math.random(1, 2) do
  item = robbableItems[math.random(1, #robbableItems)]
  if math.random(1, 10) >= item.chance then
   if tonumber(item.id) == 0 and not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addMoney(item.quantity)
    --TriggerClientEvent('chatMessage', source, 'You found $'..item.quantity)
    TriggerClientEvent('notification', source, 'You found $'..item.quantity)
   elseif item.isWeapon and not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addWeapon(item.id, 50)
    --TriggerClientEvent('chatMessage', source, 'You found a '..item.name)
    TriggerClientEvent('notification', source, 'Item Added!', 2)
   elseif not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addInventoryItem(item.id, item.quantity)
    --TriggerClientEvent('chatMessage', source, 'You have found '..item.quantity..'x '..item.name)
    TriggerClientEvent('notification', source, 'Item Added!', 2)
   end
  end
 end
end)
