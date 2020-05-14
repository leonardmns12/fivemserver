-----------------------------------------------------------------------------
-- SCRIPT DE CALLEJEROSRP
-- SCRIPT CREADO POR POKESER [ POKE ]
-- PROHIBIDO VENDER / REGALAR / ENVIAR ESTOS SCRIPTS SIN MI CONSENTIMIENTO
-----------------------------------------------------------------------------

ESX                    = nil
Items                  = {}
local DataStoresIndex  = {}
local DataStores       = {}
local SharedDataStores = {}

local listCasas = {}


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onMySQLReady', function()
  local result = MySQL.Sync.fetchAll('SELECT * FROM pk_inventariocasas')
  local data = nil
  if #result ~= 0 then
    for i=1,#result,1 do
      local propiedad = result[i].propiedad
      local propietarioID = result[i].propietarioID
      local data = (result[i].data == nil and {} or json.decode(result[i].data))
      local dataStore   = CreateDataStore(propiedad, propietarioID, data)
      SharedDataStores[propiedad] = dataStore
    end
  end
end)

RegisterServerEvent('recargaitems')
AddEventHandler('recargaitems', function()
local result = MySQL.Sync.fetchAll('SELECT * FROM pk_inventariocasas')
  local data = nil
  if #result ~= 0 then
    for i=1,#result,1 do
      local propiedad = result[i].propiedad
      local propietarioID = result[i].propietarioID
      local data = (result[i].data == nil and {} or json.decode(result[i].data))
      local dataStore   = CreateDataStore(propiedad, propietarioID, data)
      SharedDataStores[propiedad] = dataStore
    end
  end
end)

function loadInvent(propiedad)
  local result = MySQL.Sync.fetchAll('SELECT * FROM pk_inventariocasas WHERE propiedad = @propiedad',
  {
    ['@propiedad'] = propiedad,
  })
  local data = nil
  if #result ~= 0 then
    for i=1,#result,1 do
      local propiedad = result[i].propiedad
      local propietarioID = result[i].propietarioID
      local data = (result[i].data == nil and {} or json.decode(result[i].data))
      local dataStore   = CreateDataStore(propiedad, propietarioID, data)
      SharedDataStores[propiedad] = dataStore
    end
  end
end

function MakeDataStore(propiedad)
  local source = source
  local data = {}
  local propietarioID = MySQL.Sync.fetchScalar("SELECT propietarioID FROM pk_casas WHERE propiedad = @propiedad", {['@propiedad'] = propiedad})
  local dataStore   = CreateDataStore(propiedad, propietarioID, data)
  SharedDataStores[propiedad] = dataStore
  MySQL.Async.execute('INSERT INTO pk_inventariocasas(propiedad,data,propietarioID) VALUES (@propiedad,\'{}\',@propietarioID)',
  {
    ['@propiedad'] = propiedad,
    ['@propietarioID'] = propietarioID,
  }
  )
  loadInvent(propiedad)
end



function GetSharedDataStore(propiedad)
  if SharedDataStores[propiedad] == nil then
    MakeDataStore(propiedad)
  end
  return SharedDataStores[propiedad]
end

AddEventHandler('pk_casas:getSharedDataStore', function(propiedad,cb)
  cb(GetSharedDataStore(propiedad))
end)

function stringsplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

function CreateDataStore(propiedad, owned, data)

  local self = {}

  self.propiedad  = propiedad
  self.owned = owned
  self.data  = data

  local timeoutCallbacks = {}

  self.set = function(key, val)
    data[key] = val
    self.save()
  end

  self.get = function(key, i)

    local path = stringsplit(key, '.')
    local obj  = self.data

    for i=1, #path, 1 do
      obj = obj[path[i]]
    end

    if i == nil then
      return obj
    else
      return obj[i]
    end

  end

  self.count = function(key, i)

    local path = stringsplit(key, '.')
    local obj  = self.data

    for i=1, #path, 1 do
      obj = obj[path[i]]
    end

    if i ~= nil then
      obj = obj[i]
    end

    if obj == nil then
      return 0
    else
      return #obj
    end

  end

  self.save = function()

    for i=1, #timeoutCallbacks, 1 do
      ESX.ClearTimeout(timeoutCallbacks[i])
      timeoutCallbacks[i] = nil
    end

    local timeoutCallback = ESX.SetTimeout(10000, function()

        MySQL.Async.execute(
          'UPDATE pk_inventariocasas SET data = @data WHERE propiedad = @propiedad',
          {
            ['@data'] = json.encode(self.data),
            ['@propiedad'] = self.propiedad,
          }
        )

    end)

    table.insert(timeoutCallbacks, timeoutCallback)

  end

  return self

end
