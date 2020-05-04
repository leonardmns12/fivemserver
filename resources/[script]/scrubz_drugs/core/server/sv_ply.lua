---------------------------
-- Locals --
---------------------------
ESX = nil
local copsConnected = 0

---------------------------
-- Functions --
---------------------------
function calc(max)
    if max == 1 then
        random = 1
        return random
    end
    if max <= 5 then
        random = math.random(1, max)
        return random
    end
    if max > 5 then
        random = math.random(1, 5)
        return random
    end
end


---------------------------
-- ESX --
---------------------------
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

---------------------------
-- Online Police Counter --
---------------------------
function countPolice()
    local xPlayers = ESX.GetPlayers()
    copsConnected = 0
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            copsConnected = copsConnected + 1
        end
    end
    SetTimeout(30000, countPolice)
end

countPolice()

---------------------------
-- Event Handlers --
---------------------------
RegisterServerEvent('scrubz_drugs_sv:drugsCheck')
AddEventHandler('scrubz_drugs_sv:drugsCheck', function(ped)
    local xPlayer = ESX.GetPlayerFromId(source)
    if copsConnected >= Config.PoliceRequired then
        if Config.EnableWeed then
            local weed = xPlayer.getInventoryItem(Config.WeedItemName).count
            if weed >= 1 then
                local drugType = Config.WeedItemName
                TriggerClientEvent('scrubz_drugs_cl:drugsReturn', source, ped, true, true, drugType)
                return
            end
        end
        if Config.EnableCocaine then
            local coke = xPlayer.getInventoryItem(Config.CokeItemName).count
            if coke >= 1 then
                local drugType = Config.CokeItemName
                TriggerClientEvent('scrubz_drugs_cl:drugsReturn', source, ped, true, true, drugType)
                return
            end
        end
        if Config.EnableMeth then
            local meth = xPlayer.getInventoryItem(Config.MethItemName).count
            if meth >= 1 then
                local drugType = Config.MethItemName
                TriggerClientEvent('scrubz_drugs_cl:drugsReturn', source, ped, true, true, drugType)
                return
            end
        end
        if Config.EnableCrack then
            local crack = xPlayer.getInventoryItem(Config.CrackItemName).count
            if crack >= 1 then
                local drugType = Config.CrackItemName
                TriggerClientEvent('scrubz_drugs_cl:drugsReturn', source, ped, true, true, drugType)
                return
            end
        end
        TriggerClientEvent('scrubz_drugs_cl:drugsReturn', source, ped, true, false)
    else
        TriggerClientEvent('scrubz_drugs_cl:drugsReturn', source, ped, false)
    end
end)

RegisterServerEvent('scrubz_drugs_sv:endSale')
AddEventHandler('scrubz_drugs_sv:endSale', function(drugType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plyMax = xPlayer.getInventoryItem(drugType).count
    if drugType == Config.WeedItemName then
        local price = Config.WeedItemPrice
        local amount = calc(plyMax)
        xPlayer.removeInventoryItem(drugType, amount)
        local cash = amount * price
        xPlayer.addMoney(cash)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold ' .. amount .. ' bags of weed for $' .. cash, length = 3500 })
    elseif drugType == Config.CokeItemName then
        local price = Config.CokeItemPrice
        local amount = calc(plyMax)
        xPlayer.removeInventoryItem(drugType, amount)
        local cash = amount * price
        xPlayer.addMoney(cash)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold ' .. amount .. ' grams of coke for $' .. cash, length = 3500 })
    elseif drugType == Config.MethItemName then
        local price = Config.MethItemPrice
        local amount = calc(plyMax)
        xPlayer.removeInventoryItem(drugType, amount)
        local cash = amount * price
        xPlayer.addMoney(cash)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold ' .. amount .. ' grams of meth for $' .. cash, length = 3500 })
    elseif drugType == Config.CrackItemName then
        local price = Config.CrackItemPrice
        local amount = calc(plyMax)
        xPlayer.removeInventoryItem(drugType, amount)
        local cash = amount * price
        xPlayer.addMoney(cash)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold ' .. amount .. ' bags of crack for $' .. cash, length = 3500 })
    end
end)

RegisterServerEvent('scrubz_drugs_sv:drugSale')
AddEventHandler('scrubz_drugs_sv:drugSale', function(streetName, plyGender)
	if plyGender == 0 then
		playerGender = 'Female'
	else
		plyGender = 'Male'
	end
	TriggerClientEvent('scrubz_drugs_cl:chatAlert', -1, '[911] I just saw a ' .. plyGender .. ' selling drugs at ' .. streetName ..'.')
end)

RegisterServerEvent('scrubz_drugs_sv:harvestWeed')
AddEventHandler('scrubz_drugs_sv:harvestWeed', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount = math.random(1, 6)
    xPlayer.addInventoryItem(Config.WeedBudName, amount)
end)

RegisterServerEvent('scrubz_drugs_sv:raidItemCheck')
AddEventHandler('scrubz_drugs_sv:raidItemCheck', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(Config.SpecialItemName).count
    if item >= 1 then
        xPlayer.removeInventoryItem(Config.SpecialItemName, 1)
        TriggerClientEvent('scrubz_drugs_cl:startLockpick', source)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You don\'t have anything to lockpick the door with.', length = 4500 })
    end
end)

RegisterServerEvent('scrubz_drugs_sv:startRobbery')
AddEventHandler('scrubz_drugs_sv:startRobbery', function()
    TriggerClientEvent('scrubz_drugs_cl:setStatus', -1, true)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.CooldownTimer)
            TriggerClientEvent('scrubz_drugs_cl:setStatus', -1, false)
            return
        end
    end)
end)

RegisterServerEvent('scrubz_drugs_sv:raidReward')
AddEventHandler('scrubz_drugs_sv:raidReward', function(level)
    local xPlayer = ESX.GetPlayerFromId(source)
    if level == class1 then
        local amount = math.random(15, 30)
        xPlayer.addInventoryItem(Config.Reward1, amount)
    elseif level == class2 then
        local amount = math.random(40, 70)
        xPlayer.addInventoryItem(Config.Reward1, amount)
    end
end)

RegisterServerEvent('scrubz_drugs_sv:searchReward')
AddEventHandler('scrubz_drugs_sv:searchReward', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local amount6 = math.random(1, 4)
    xPlayer.addInventoryItem(Config.Reward2, amount6)
end)
