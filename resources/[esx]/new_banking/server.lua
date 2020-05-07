-- ================================================================================================--
-- ==                                VARIABLES - DO NOT EDIT                                     ==--
-- ================================================================================================--
ESX = nil

local logs = "https://discordapp.com/api/webhooks/705306638399176706/H_A7EHSlfnoQa0WhnDfSvDsbcvNT7BPcjgnH9b-F8qOTeE-5xqei_ZdUscqOOeVAsDX4"
local logs1 = "https://discordapp.com/api/webhooks/705306485328183337/ecJvmw9IiyuPDuZxAyk5PQ61X1iTHZG_Hyv68Kmw8T_VWpk8ZIejunH0KEfP0T3IzmpQ"

local communityname = "INDOFOLKS ROLEPLAY"
local communtiylogo = "https://i.imgur.com/fZZWZ5l.png" 



TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)
    if amount == nil or amount <= 0 then
        TriggerClientEvent('chatMessage', _source, _U('invalid_amount'))
    else
        if amount > xPlayer.getMoney() then
            amount = xPlayer.getMoney()
        end
        	local steamhex = GetPlayerIdentifier(source);
			local connect = {
       				 {
           				 ["color"] = "14886454",
           				 ["title"] = "Player menyimpan uang di bank!",
          				 ["description"] = "Player: **"..xPlayer.name.."**\nJumlah: **"..amount.."**\nSteam Hex: **"..steamhex.."**",
         				 ["footer"] = {
                		 ["text"] = communityname,
                		 ["icon_url"] = communtiylogo,
            		},
        }		
    }																								
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "IndoFolks Server Logger", embeds = connect}), { ['Content-Type'] = 'application/json' })

        xPlayer.removeMoney(amount)
        xPlayer.addAccountMoney('bank', tonumber(amount))
    end
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local base = 0
    amount = tonumber(amount)
    base = xPlayer.getAccount('bank').money
    if amount == nil or amount <= 0 then
        TriggerClientEvent('chatMessage', _source, _U('invalid_amount'))
    else
        if amount > base then
            amount = base
        end
        local steamhex = GetPlayerIdentifier(source);
			local connect = {
       				 {
           				 ["color"] = "8663711",
           				 ["title"] = "Player menarik uang di bank!",
          				 ["description"] = "Player: **"..xPlayer.name.."**\nJumlah: **"..amount.."**\nSteam Hex: **"..steamhex.."**",
         				 ["footer"] = {
                		 ["text"] = communityname,
                		 ["icon_url"] = communtiylogo,
            		},
        }		
    }																								
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "In Your Dream Server Logger", embeds = connect}), { ['Content-Type'] = 'application/json' })
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addMoney(amount)
    end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    balance = xPlayer.getAccount('bank').money
    TriggerClientEvent('currentbalance1', _source, balance)

end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amountt)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(to)
    local balance = 0

    if zPlayer ~= nil then
        balance = xPlayer.getAccount('bank').money
        zbalance = zPlayer.getAccount('bank').money
        if tonumber(_source) == tonumber(to) then
            -- advanced notification with bank icon
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu tidak bisa transfer ke diri sendiri', length = 2500, style = { ['background-color'] = '#E03232', ['color'] = '#ffffff' } })
        else
            if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <=
                0 then
                -- advanced notification with bank icon
                 TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Kamu tidak punya cukup uang!', length = 2500, style = { ['background-color'] = '#E03232', ['color'] = '#ffffff' } })
            else
                xPlayer.removeAccountMoney('bank', tonumber(amountt))
  
                zPlayer.addAccountMoney('bank', tonumber(amountt))
                -- advanced notification with bank icon
               	local steamhex = GetPlayerIdentifier(source);
				local connect = {
       				 {
           				 ["color"] = "8663711",
           				 ["title"] = "Bukti transfer!",
          				 ["description"] = "Pengirim: **"..xPlayer.name.."**\nPenerima: **" ..zPlayer.name.. "**\nJumlah: **"..amountt.."**\nSteam Hex: **"..steamhex.."**",
         				 ["footer"] = {
                		 ["text"] = communityname,
                		 ["icon_url"] = communtiylogo,
            		},
        }		
    }																								
    PerformHttpRequest(logs1, function(err, text, headers) end, 'POST', json.encode({username = "In Your Dream Server Logger", embeds = connect}), { ['Content-Type'] = 'application/json' })


               TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Transfer berhasil sebesar ' ..amountt.. ' ', length = 2500, style = { ['background-color'] = '#72CC72', ['color'] = '#ffffff' } })
               TriggerClientEvent('mythic_notify:client:SendAlert', to, { type = 'success', text = 'Kamu menerima transfer sebesar '..amountt.. ' ', length = 2500, style = { ['background-color'] = '#72CC72', ['color'] = '#ffffff' } })
            end

        end
    end

end)
