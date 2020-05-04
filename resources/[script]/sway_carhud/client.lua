-- gas filling
DecorRegister("CurrentFuel", 3)
Fuel = 0
local gasStations = {
    {179.8573, 6602.839, 31.86817,600},
}

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end




function TargetVehicle()
    playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function TargetVehicle()
    playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end




function round( n )
    return math.floor( n + 0.5 )
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local zoneNames = {
AIRP = "Los Santos International Airport",
ALAMO = "Alamo Sea",
ALTA = "Alta",
ARMYB = "Fort Zancudo",
BANHAMC = "Banham Canyon Dr",
BANNING = "Banning",
BAYTRE = "Baytree Canyon", 
BEACH = "Vespucci Beach",
BHAMCA = "Banham Canyon",
BRADP = "Braddock Pass",
BRADT = "Braddock Tunnel",
BURTON = "Burton",
CALAFB = "Calafia Bridge",
CANNY = "Raton Canyon",
CCREAK = "Cassidy Creek",
CHAMH = "Chamberlain Hills",
CHIL = "Vinewood Hills",
CHU = "Chumash",
CMSW = "Chiliad Mountain State Wilderness",
CYPRE = "Cypress Flats",
DAVIS = "Davis",
DELBE = "Del Perro Beach",
DELPE = "Del Perro",
DELSOL = "La Puerta",
DESRT = "Grand Senora Desert",
DOWNT = "Downtown",
DTVINE = "Downtown Vinewood",
EAST_V = "East Vinewood",
EBURO = "El Burro Heights",
ELGORL = "El Gordo Lighthouse",
ELYSIAN = "Elysian Island",
GALFISH = "Galilee",
GALLI = "Galileo Park",
golf = "GWC and Golfing Society",
GRAPES = "Grapeseed",
GREATC = "Great Chaparral",
HARMO = "Harmony",
HAWICK = "Hawick",
HORS = "Vinewood Racetrack",
HUMLAB = "Humane Labs and Research",
JAIL = "Bolingbroke Penitentiary",
KOREAT = "Little Seoul",
LACT = "Land Act Reservoir",
LAGO = "Lago Zancudo",
LDAM = "Land Act Dam",
LEGSQU = "Legion Square",
LMESA = "La Mesa",
LOSPUER = "La Puerta",
MIRR = "Mirror Park",
MORN = "Morningwood",
MOVIE = "Richards Majestic",
MTCHIL = "Mount Chiliad",
MTGORDO = "Mount Gordo",
MTJOSE = "Mount Josiah",
MURRI = "Murrieta Heights",
NCHU = "North Chumash",
NOOSE = "N.O.O.S.E",
OCEANA = "Pacific Ocean",
PALCOV = "Paleto Cove",
PALETO = "Paleto Bay",
PALFOR = "Paleto Forest",
PALHIGH = "Palomino Highlands",
PALMPOW = "Palmer-Taylor Power Station",
PBLUFF = "Pacific Bluffs",
PBOX = "Pillbox Hill",
PROCOB = "Procopio Beach",
RANCHO = "Rancho",
RGLEN = "Richman Glen",
RICHM = "Richman",
ROCKF = "Rockford Hills",
RTRAK = "Redwood Lights Track",
SanAnd = "San Andreas",
SANCHIA = "San Chianski Mountain Range",
SANDY = "Sandy Shores",
SKID = "Mission Row",
SLAB = "Stab City",
STAD = "Maze Bank Arena",
STRAW = "Strawberry",
TATAMO = "Tataviam Mountains",
TERMINA = "Terminal",
TEXTI = "Textile City",
TONGVAH = "Tongva Hills",
TONGVAV = "Tongva Valley",
VCANA = "Vespucci Canals",
VESP = "Vespucci",
VINE = "Vinewood",
WINDF = "Ron Alternates Wind Farm",
WVINE = "West Vinewood",
ZANCUDO = "Zancudo River",
ZP_ORT = "Port of South Los Santos",
ZQ_UAR = "Davis Quartz"
}

-- CONFIG --
local showCompass = true
-- CODE --
local compass = "Loading GPS"

local lastStreet = nil
local lastStreetName = ""
local zone = "Unknown";

function playerLocation()
    return lastStreetName
end

function playerZone()
    return zone
end

-- Thanks @marxy
function getCardinalDirectionFromHeading(heading)
    if heading >= 315 or heading < 45 then
        return "North Bound"
    elseif heading >= 45 and heading < 135 then
        return "West Bound"
    elseif heading >=135 and heading < 225 then
        return "South Bound"
    elseif heading >= 225 and heading < 315 then
        return "East Bound"
    end
end

local seatbelt = false
RegisterNetEvent("seatbelt")
AddEventHandler("seatbelt", function(belt)
    seatbelt = belt
end)

local time = "12:00"
RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(h,m)
    if h < 10 then
        h = "0"..h
    end
    if m < 10 then
        m = "0"..m
    end
    time = h .. ":" .. m
end)



local counter = 0
local Mph = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 2.236936
local Fuel = 0.0
local uiopen = false
local colorblind = false
local compass_on = false

RegisterNetEvent('option:colorblind')
AddEventHandler('option:colorblind',function()
    colorblind = not colorblind
end)

Citizen.CreateThread(function()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
    currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    zone = tostring(GetNameOfZone(x, y, z))
    playerStreetsLocation = zoneNames[tostring(zone)]

    if not zone then
        zone = "UNKNOWN"
        zoneNames['UNKNOWN'] = zone
    elseif not zoneNames[tostring(zone)] then
        local undefinedZone = zone .. " " .. x .. " " .. y .. " " .. z
        zoneNames[tostring(zone)] = "Undefined Zone"
    end

    if intersectStreetName ~= nil and intersectStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. zoneNames[tostring(zone)] .. "]"
    elseif currentStreetName ~= nil and currentStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | [" .. zoneNames[tostring(zone)] .. "]"
    else
        playerStreetsLocation = "[" .. zoneNames[tostring(zone)] .. "]"
    end

    while true do
        Citizen.Wait(500)
        local player = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(player, true))
        local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
        currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
        intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
        zone = tostring(GetNameOfZone(x, y, z))
        playerStreetsLocation = zoneNames[tostring(zone)]

        if not zone then
            zone = "UNKNOWN"
            zoneNames['UNKNOWN'] = zone
        elseif not zoneNames[tostring(zone)] then
            local undefinedZone = zone .. " " .. x .. " " .. y .. " " .. z
            zoneNames[tostring(zone)] = "Undefined Zone"
        end

        if intersectStreetName ~= nil and intersectStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. zoneNames[tostring(zone)] .. "]"
        elseif currentStreetName ~= nil and currentStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | [" .. zoneNames[tostring(zone)] .. "]"
        else
            playerStreetsLocation = "[".. zoneNames[tostring(zone)] .. "]"
        end
        -- compass = getCardinalDirectionFromHeading(math.floor(GetEntityHeading(player) + 0.5))
        -- street = compass .. " | " .. playerStreetsLocation
        street = playerStreetsLocation
 
        if IsVehicleEngineOn(GetVehiclePedIsIn(player, false)) then          

            if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                }) 
            end
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            Fuel = 100 * GetVehicleFuelLevel(vehicle) / GetVehicleHandlingFloat(vehicle,"CHandlingData","fPetrolTankVolume")
           -- print(Fuel)
            Mph = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(player, false)) * 2.236936)
            local hours = GetClockHours()
            if string.len(tostring(hours)) == 1 then
                trash = '0'..hours
            else
                trash = hours
            end
    
            local mins = GetClockMinutes()
            if string.len(tostring(mins)) == 1 then
                mins = '0'..mins
            else
                mins = mins
            end


            SendNUIMessage({
              open = 2,
              mph = Mph,
              fuel = math.ceil(Fuel),
              street = street,
              belt = seatbelt,
              time = hours .. ':' .. mins,
              colorblind = colorblind
            }) 

        else

            if uiopen and not compass_on then
                SendNUIMessage({
                  open = 3,
                }) 

                uiopen = false
            end

            compass_on = false
        end


RegisterNetEvent('carHud:compass')
AddEventHandler('carHud:compass', function(table)
        compass_on = not compass_on
    end)
    RegisterNetEvent('carHud:compassoff')
AddEventHandler('carHud:compassoff', function(table)
        compass_on = false
    end)
local IsPedInVehicle = false
if IsPedInVehicle ~= false then
TriggerClientEvent('carHud:compassoff')
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local player = PlayerPedId()
        if IsVehicleEngineOn(GetVehiclePedIsIn(player, false)) then
            -- in vehicle
            SendNUIMessage({
                open = 2,
                direction = math.floor(calcHeading(-GetEntityHeading(player) % 360)),
            })
        elseif compass_on == true then
            -- has compass toggled
            if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                })
            end

            SendNUIMessage({
                open = 4,
                time = time,
                direction = math.floor(calcHeading(-GetEntityHeading(player) % 360)),
            })
            
        else
            Citizen.Wait(1000)
        end
    end
end)

Controlkey = {["generalUse"] = {38,"E"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
    Controlkey["generalUse"] = table["generalUse"]
end)




---------------------------------
-- Compass shit
---------------------------------

--[[
    Heavy Math Calcs
 ]]--

 local imageWidth = 100 -- leave this variable, related to pixel size of the directions
 local containerWidth = 100 -- width of the image container
 
 -- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed
 local width =  0;
 local south = (-imageWidth) + width
 local west = (-imageWidth * 2) + width
 local north = (-imageWidth * 3) + width
 local east = (-imageWidth * 4) + width
 local south2 = (-imageWidth * 5) + width
 
 function calcHeading(direction)
     if (direction < 90) then
         return lerp(north, east, direction / 90)
     elseif (direction < 180) then
         return lerp(east, south2, rangePercent(90, 180, direction))
     elseif (direction < 270) then
         return lerp(south, west, rangePercent(180, 270, direction))
     elseif (direction <= 360) then
         return lerp(west, north, rangePercent(270, 360, direction))
     end
 end
 
 
 function rangePercent(min, max, amt)
     return (((amt - min) * 100) / (max - min)) / 100
 end
 
 function lerp(min, max, amt)
     return (1 - amt) * min + amt * max
 end


-- FUEL ALARM--

alarmset = false

RegisterNetEvent("CarFuelAlarm")
AddEventHandler("CarFuelAlarm",function()
    if not alarmset then
        alarmset = true
        local i = 5
        TriggerEvent("DoLongHudText", "Low fuel.",1)
        while i > 0 do
            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            i = i - 1
            Citizen.Wait(300)
        end
        Citizen.Wait(60000)
        alarmset = false
    end
end)



Citizen.CreateThread(function()

    while true do

        Citizen.Wait(250)
        local player = PlayerPedId()

        if (IsPedInAnyVehicle(player, false)) then

            local veh = GetVehiclePedIsIn(player,false)

                if Fuel < 20 then
                  --  print(Fuel)
                    if not IsThisModelABike(GetEntityModel(veh)) then
                        TriggerEvent("CarFuelAlarm")
                    end
                else
                            if Fuel < 10 then
                                --print(Fuel)
                                if not IsThisModelABike(GetEntityModel(veh)) then
                                    TriggerEvent("CarFuelAlarm")
                                end
                    end
                end
            end
        end
    end)