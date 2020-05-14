ESX = nil
sharedInstances = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("esx_property:giveKeys",function(source, cb, property, target)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    local oldShared = MySQL.Sync.fetchAll("SELECT shared FROM owned_properties WHERE name = @name AND owner = @owner",{["@owner"]=xPlayer.identifier,["@name"]=property.name})[1]["shared"]
	MySQL.Async.execute("UPDATE owned_properties SET shared = @shared WHERE owner = @owner AND name = @name",{["@shared"]=xTarget.identifier,["@owner"]=xPlayer.identifier,["@name"]=property.name},function(rowsChanged)
		cb()
	end)
    Citizen.CreateThread(function()
        if oldShared~=nil then
            local xShared = ESX.GetPlayerFromIdentifier(oldShared)
            if xShared~=nil then TriggerClientEvent("esx_property:removeKeys",xShared.source,property.name,xPlayer.identifier) end
        end
        TriggerClientEvent("esx_property:keysReceived",target,{name=property.name,ownerName=xPlayer.getName(),owner=xPlayer.identifier,shared=xTarget.identifier})
    end)
end)

ESX.RegisterServerCallback('esx_property:getAccessProperties',function(source,cb)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE shared = @shared', {["@shared"]=ESX.GetPlayerFromId(source).identifier}, function(data)
		cbdata = {}
        for k,v in ipairs(data) do
            ownerName = MySQL.Sync.fetchAll("SELECT name FROM users WHERE identifier=@identifier",{["@identifier"]=v.owner})[1]["name"]
			table.insert(cbdata,{name=v.name,owner=v.owner,shared=v.shared,ownerName=ownerName~=nil and ownerName or "N/A"})
		end
		cb(cbdata)
	end)
end)

RegisterServerEvent("esx_property:removeKeysAll")
AddEventHandler("esx_property:removeKeysAll",function(pname)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local oldShared = MySQL.Sync.fetchAll("SELECT shared FROM owned_properties WHERE name = @name AND owner = @owner",{["@owner"]=xPlayer.identifier,["@name"]=pname})[1]["shared"]
    if oldShared~=nil then
	    local xShared = ESX.GetPlayerFromIdentifier(oldShared)
	    if xShared~=nil then TriggerClientEvent("esx_property:removeKeys",xShared.source,pname,xPlayer.identifier) end
	end
    MySQL.Async.execute("UPDATE owned_properties SET shared=NULL WHERE owner=@owner AND name=@name",{["@owner"]=xPlayer.identifier,["@name"]=pname},nil)
end)

AddEventHandler('instance:onCreate',function(instance)
    if instance.type~="property" then return end
    local player = instance.host
    if sharedInstances[instance.data.property..instance.data.owner]~=nil then
    else
        sharedInstances[instance.data.property..instance.data.owner]=instance
    end
    TriggerClientEvent("esx_property:joinShared",player,sharedInstances[instance.data.property..instance.data.owner]~=nil and sharedInstances[instance.data.property..instance.data.owner] or instance)
end)

RegisterServerEvent('instance:leave')
AddEventHandler('instance:leave', function()
    for k,v in pairs(sharedInstances) do
        if v.host==source then
            sharedInstances[k]=nil
        end
    end
end)

RegisterServerEvent('instance:enter')
AddEventHandler('instance:enter',function(instance)
    for k,v in pairs(sharedInstances) do
        if v.host==instance then
            table.insert(sharedInstances[k].players,source)
        end
    end
end)