ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function checkExistenceClothes(cid, cb)
   -- MySQL.Async.fetchall("SELECT cid FROM character_current WHERE cid = @cid LIMIT 1;", {["cid"] = cid}, function(result)
        MySQL.Async.fetchAll('SELECT cid FROM character_current WHERE cid = @cid LIMIT 1', {['@cid'] = cid}, function(result)
        local exists = result and result[1] and true or false
        cb(exists)
    end)
end




local function checkExistenceFace(cid, cb)
        MySQL.Async.fetchAll('SELECT identifier FROM users WHERE identifier = @identifier LIMIT 1', {['@identifier'] = cid}, function(result)
        local exists = result and result[1] and true or false
        cb(exists)
    end)
end


RegisterServerEvent("raid_clothes:insert_character_current")
AddEventHandler("raid_clothes:insert_character_current",function(data)
    if not data then return end
    local src = source
    local user = ESX.GetPlayerFromId(source)
    local characterId = user.identifier
    if not characterId then return end
    checkExistenceClothes(characterId, function(exists)
        local values = {
            ["identifier"] = characterId,
            ["model"] = json.encode(data.model),
            ["drawables"] = json.encode(data.drawables),
            ["props"] = json.encode(data.props),
            ["drawtextures"] = json.encode(data.drawtextures),
            ["proptextures"] = json.encode(data.proptextures),
        }

        if not exists then
            local cols = "identifier, model, drawables, props, drawtextures, proptextures"
            local vals = "@identifier, @model, @drawables, @props, @drawtextures, @proptextures"
            local set = "model = @model,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
            MySQL.Async.execute("UPDATE users SET "..set.." WHERE identifier = @identifier", values, function()
            end)
            return
        end
        print(values)
        local set = "model = @model,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
        MySQL.Async.execute("UPDATE users SET "..set.." WHERE identifier = @identifier", values)
      --  print("this is for the character")
    end)
end)

RegisterServerEvent("raid_clothes:insert_character_skin")
AddEventHandler("raid_clothes:insert_character_skin",function(data)
    if not data then return end
    local src = source
    local user = ESX.GetPlayerFromId(source)
    local characterId = user.identifier
    if not characterId then return end
    checkExistenceClothes(characterId, function(exists)
      --[[  local values = {
            ["identifier"] = characterId,
            ["skin"] = json.encode(data.model)..json.encode(data.drawables)..json.encode(data.props)..json.encode(data.drawtextures)..json.encode(data.proptextures),
        }

        local set = "model = @model,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
        MySQL.Async.execute("UPDATE users SET skin = @skin WHERE identifier = @identifier", values)
        ]]
        MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
            ['@skin'] = json.encode(data.drawables)..json.encode(data.props)..json.encode(data.drawtextures)..json.encode(data.proptextures),
            ['@identifier'] =characterId
        })

    end)
end)


--[[
RegisterServerEvent("raid_clothes:insert_character_face")
AddEventHandler("raid_clothes:insert_character_face",function(data)
    if not data then return end
    local src = source

    local user = ESX.GetPlayerFromId(source)
    local characterId = user.identifier

    if not characterId then return end

    checkExistenceFace(characterId, function(exists)
        if data.headBlend == "null" or data.headBlend == nil then
            data.headBlend = '[]'
        else
            data.headBlend = json.encode(data.headBlend)
        end
        local values = {
            ["identifier"] = characterId,
            ["hairColor"] = json.encode(data.hairColor),
            ["headBlend"] = data.headBlend,
            ["headOverlay"] = json.encode(data.headOverlay),
            ["headStructure"] = json.encode(data.headStructure),
        }

        if not exists then
            local cols = "identifier, hairColor, headBlend, headOverlay, headStructure"
            local vals = "@identifier, @hairColor, @headBlend, @headOverlay, @headStructure"

           -- MySQL.Async.fetchall("INSERT INTO character_face ("..cols..") VALUES ("..vals..")", values, function()
            MySQL.Async.execute("INSERT INTO character_face ("..cols..") VALUES ("..vals..")", values, function()
            end)
            return
        end

        local set = "hairColor = @hairColor,headBlend = @headBlend, headOverlay = @headOverlay,headStructure = @headStructure"
       -- MySQL.Async.fetchall("UPDATE character_face SET "..set.." WHERE cid = @cid", values )
        MySQL.Async.execute('UPDATE character_face hairColor = @hairColor, headBlend = @headBlend, headStructure = @headStructure, headOverlay = @headOverlay WHERE identifier = @identifier', {
            ["@identifier"] = characterId,
            ['@hairColor'] = json.encode(data.hairColor),
            ['@headBlend'] = data.headBlend,
            ['@headOverlay'] = json.encode(data.headOverlay),
            ['@headStructure'] = json.encode(data.headStructure)
        })
    end)
end)
]]
RegisterServerEvent("raid_clothes:insert_character_face")
AddEventHandler("raid_clothes:insert_character_face",function(data)
    if not data then return end
    local src = source
    local user = ESX.GetPlayerFromId(source)
    local characterId = user.identifier
    if not characterId then return end
    checkExistenceFace(characterId, function(exists)
        local values = {
            ["identifier"] = characterId,
            ["hairColor"] = json.encode(data.hairColor),
            ["headBlend"] = json.encode(data.headBlend),
            ["headOverlay"] = json.encode(data.headOverlay),
            ["headStructure"] = json.encode(data.headStructure),
      
        }
       -- print(characterId)
--print(json.encode(data.hairColor))
        if not exists then
            local cols = "identifier, hairColor, headBlend, headOverlay, headStructure"
            local vals = "@identifier, @hairColor, @headBlend, @headOverlay, @headStructure"
            local set = "hairColor = @hairColor,headBlend = @headBlend,headOverlay = @headOverlay,headStructure = @headStructure"
            MySQL.Async.execute("UPDATE users SET "..set.." WHERE identifier = @identifier", values, function()
            end)
            return
        end

        local set = "hairColor = @hairColor,headBlend = @headBlend,headOverlay = @headOverlay,headStructure = @headStructure"
        MySQL.Async.execute("UPDATE users SET "..set.." WHERE identifier = @identifier", values)
       -- print("this is for the face")
    end)
end)


RegisterServerEvent("raid_clothes:get_character_face")
AddEventHandler("raid_clothes:get_character_face",function(pSrc)
    local src = (not pSrc and source or pSrc)
    local user = ESX.GetPlayerFromId(source)
    local characterId = user.identifier

    if not characterId then return end
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {['@identifier'] = characterId}, function(result)
        local temp_data = {
            hairColor = json.decode(result[1].hairColor),
            headBlend = json.decode(result[1].headBlend),
            headOverlay = json.decode(result[1].headOverlay),
            headStructure = json.decode(result[1].headStructure),
            ---Below codes is added to fix the spawn ped.
            drawables = json.decode(result[1].drawables),
            props = json.decode(result[1].props),
            drawtextures = json.decode(result[1].drawtextures),
            proptextures = json.decode(result[1].proptextures),
            sex = result[1].sex,
        }
        local model = tonumber(result[1].model)
        if model == 1885233650 or model == -1667301416 then
            TriggerClientEvent("raid_clothes:setpedfeatures", src, temp_data)
        end
       
	end)
    --MySQL.Async.fetchall("SELECT cc.model, cf.hairColor, cf.headBlend, cf.headOverlay, cf.headStructure FROM character_face cf INNER JOIN users cc on cc.identifier = cf.identifier WHERE cf.identifier = @identifier", {['identifier'] = characterId}, function(result)
       
end)

RegisterServerEvent("raid_clothes:get_character_current")
AddEventHandler("raid_clothes:get_character_current",function(pSrc)
    local src = (not pSrc and source or pSrc)
    local user = ESX.GetPlayerFromId(source)
    local characterId = user.identifier

    if not characterId then return end

    --MySQL.Async.fetchall("SELECT * FROM character_current WHERE cid = @cid", {['cid'] = characterId}, function(result)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {['@identifier'] = characterId}, function(result)
        local temp_data = {
            model = result[1].model,
            drawables = json.decode(result[1].drawables),
            props = json.decode(result[1].props),
            drawtextures = json.decode(result[1].drawtextures),
            proptextures = json.decode(result[1].proptextures),
        }
        TriggerClientEvent("raid_clothes:setclothes", src, temp_data,0)
	end)
end)

RegisterServerEvent("raid_clothes:retrieve_tats")
AddEventHandler("raid_clothes:retrieve_tats", function(pSrc)
    local src = (not pSrc and source or pSrc)
	local user = ESX.GetPlayerFromId(source)
    --local char = user:getCurrentCharacter()
    --MySQL.Async.fetchall("SELECT * FROM playerstattoos WHERE identifier = @identifier", {['identifier'] = char.id}, function(result)
    --MySQL.Async.fetchAll('SELECT * FROM playerstattoos WHERE identifier = @identifier', {['@identifier'] = user}, function(result)
        MySQL.Async.fetchAll("SELECT * FROM playersTattoos WHERE identifier = @identifier", {['@identifier'] = user}, function(result)
        if(result and #result == 1) then
			TriggerClientEvent("raid_clothes:settattoos", src, json.decode(result[1].tattoos))
		else
			local tattooValue = "{}"
		  --MySQL.Async.fetchall("INSERT INTO playerstattoos (identifier, tattoos) VALUES (@identifier, @tattoo)", {['identifier'] = char.id, ['tattoo'] = tattooValue})
            MySQL.Async.execute("INSERT INTO playerstattoos (identifier, tattoos) VALUES  (@identifier, @tattoo)", {['@identifier'] = user, ['@tattoo'] = tattooValue})
            TriggerClientEvent("raid_clothes:settattoos", src, {})
		end
	end)
end)

RegisterServerEvent("raid_clothes:set_tats")
AddEventHandler("raid_clothes:set_tats", function(tattoosList)
	local src = source
	local user = ESX.GetPlayerFromId(source)
    --local char = getCurrentCharacter(user)
   -- print(user.identifier)
	--MySQL.Async.execute("UPDATE playerstattoos SET tattoos = @tattoos WHERE identifier = @identifier", {['@tattoos'] = json.encode(tattoosList), ['@identifier'] = user.identifier})
    MySQL.Async.execute('UPDATE playerstattoos SET tattoos = @tattoos WHERE identifier = @identifier', {
		['@tattoos'] = json.encode(tattoosList),
		['@identifier'] = user.identifier
	})

end)


RegisterServerEvent("raid_clothes:get_outfit")
AddEventHandler("raid_clothes:get_outfit",function(slot)
    if not slot then return end
    local src = source

    local user = ESX.GetPlayerFromId(source)
    local characterId = user.identifier

    if not characterId then return end

    MySQL.Async.fetchall("SELECT * FROM character_outfits WHERE cid = @cid and slot = @slot", {
        ['@cid'] = characterId,
        ['@slot'] = slot
    }, function(result)
        if result and result[1] then
            if result[1].model == nil then
                --TriggerClientEvent("DoLongHudText", src, "Can not use.",2)
              --  TriggerEvent('notification', 'Can not use')
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Can not use'})
                return
            end

            local data = {
                model = result[1].model,
                drawables = json.decode(result[1].drawables),
                props = json.decode(result[1].props),
                drawtextures = json.decode(result[1].drawtextures),
                proptextures = json.decode(result[1].proptextures),
                hairColor = json.decode(result[1].hairColor)
            }

            TriggerClientEvent("raid_clothes:setclothes", src, data,0)

            local values = {
                ["@cid"] = characterId,
                ["@model"] = data.model,
                ["@drawables"] = json.encode(data.drawables),
                ["@props"] = json.encode(data.props),
                ["@drawtextures"] = json.encode(data.drawtextures),
                ["@proptextures"] = json.encode(data.proptextures),
            }

            local set = "model = @model, drawables = @drawables, props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
            MySQL.Async.execute("UPDATE character_current SET "..set.." WHERE cid = @cid",values)
            
        else
            --TriggerClientEvent("DoLongHudText", src, "No outfit on slot " .. slot,2)
           -- TriggerEvent('notification', 'No outfit on slot' .. slot)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'No outfit on slot ' .. slot .. "."})
            return
        end
	end)
end)

RegisterServerEvent("raid_clothes:set_outfit")
AddEventHandler("raid_clothes:set_outfit",function(slot, name, data)
    if not slot then return end
    local src = source

    local user = ESX.GetPlayerFromId(source)
    local characterId = user.identifier

    if not characterId then return end

    MySQL.Async.fetchall("SELECT slot FROM character_outfits WHERE cid = @cid and slot = @slot", {
        ['@cid'] = characterId,
        ['@slot'] = slot
    }, function(result)
        if result and result[1] then
            local values = {
                ["@cid"] = characterId,
                ["@slot"] = slot,
                ["@name"] = name,
                ["@model"] = json.encode(data.model),
                ["@drawables"] = json.encode(data.drawables),
                ["@props"] = json.encode(data.props),
                ["@drawtextures"] = json.encode(data.drawtextures),
                ["@proptextures"] = json.encode(data.proptextures),
                ["@hairColor"] = json.encode(data.hairColor),
            }

            local set = "model = @model,name = @name,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures,hairColor = @hairColor"
            MySQL.Async.execute("UPDATE character_outfits SET "..set.." WHERE cid = @cid and slot = @slot",values)
        else
            local cols = "cid, model, name, slot, drawables, props, drawtextures, proptextures, hairColor"
            local vals = "@cid, @model, @name, @slot, @drawables, @props, @drawtextures, @proptextures, @hairColor"

            local values = {
                ["@cid"] = characterId,
                ["@name"] = name,
                ["@slot"] = slot,
                ["@model"] = data.model,
                ["@drawables"] = json.encode(data.drawables),
                ["@props"] = json.encode(data.props),
                ["@drawtextures"] = json.encode(data.drawtextures),
                ["@proptextures"] = json.encode(data.proptextures),
                ["@hairColor"] = json.encode(data.hairColor)
            }

            MySQL.Async.execute("INSERT INTO character_outfits ("..cols..") VALUES ("..vals..")", values, function()
               -- TriggerClientEvent("DoLongHudText", src, name .. " stored in slot " .. slot,1)
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = name.. ' stored in slot ' .. slot .. "."})
            end)
        end
	end)
end)

ESX.RegisterServerCallback('raid_clothes:getPlayerData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, skin = users[0].props

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

RegisterServerEvent("raid_clothes:remove_outfit")
AddEventHandler("raid_clothes:remove_outfit",function(slot)

    local src = source
    local user = ESX.GetPlayerFromId(source)
    local cid = user.identifier
    local slot = slot

    if not cid then return end

    MySQL.Async.execute( "DELETE FROM character_outfits WHERE cid = @cid AND slot = @slot", { ['@cid'] = cid,  ["@slot"] = slot } )
    --TriggerClientEvent("DoLongHudText", src,"Removed slot " .. slot .. ".",1)
    --TriggerEvent('notification', 'Removed slot ' .. slot .. ".")
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Removed slot' .. slot .. "."})
end)

RegisterServerEvent("raid_clothes:list_outfits")
AddEventHandler("raid_clothes:list_outfits",function()
    local src = source
    local user = ESX.GetPlayerFromId(source)
    local cid = user.identifier
    local slot = slot
    local name = name

    if not cid then return end

    MySQL.Async.fetchall("SELECT slot, name FROM character_outfits WHERE cid = @cid", {['cid'] = cid}, function(skincheck)
    	TriggerClientEvent("hotel:listSKINSFORCYRTHESICKFUCK",src, skincheck)
	end)
end)


RegisterServerEvent("clothing:checkIfNew")
AddEventHandler("clothing:checkIfNew", function()
    local src = source
    local user = ESX.GetPlayerFromId(source)
    local cid = user.identifier
    local dateCreated = user:getCurrentCharacter()

    MySQL.Async.fetchall("SELECT count(rank) whitelist FROM jobs_whitelist WHERE cid = @cid LIMIT 1", {
        ['@cid'] = cid
    }, function(isWhitelisted)
        exports.ghmattimysql:scalar("SELECT count(model) FROM character_current WHERE cid = @cid LIMIT 1", {
            ['@cid'] = cid
        }, function(result)
            local isService = false;
            if(isWhitelisted[1].whitelist >= 1) then isService = true end


            if result == 0 then
                MySQL.Async.fetchall("select count(cid) assExist from (select cid  from character_current union select cid from users_clothes) a where cid =  @cid", {['@cid'] = cid}, function(clothingCheck)
                    local existsClothing = clothingCheck[1].assExist
                    TriggerClientEvent('raid_clothes:setclothes',src,{},existsClothing)
                end)
                return
            else
                TriggerEvent("raid_clothes:get_character_current", src)
            end
            TriggerClientEvent("raid_clothes:inService",src,isService)
    	end)
    end)
end)

RegisterServerEvent("clothing:checkMoney")
AddEventHandler("clothing:checkMoney", function(menu,askingPrice)
    
    local src = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= 100 then
		xPlayer.removeMoney(100)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You paid 100$'})
        TriggerClientEvent("raid_clothes:hasEnough",src,menu)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have enough money!'})
	end
end)