RegisterCommand('resetpos', function(source, args, rawCommand)
    local ped = PlayerPedId()
    local currentPos = GetEntityCoords(ped)
    print(currentPos)

    SetEntityCoords(ped, -285.48, -889.52, 31.08, false, false, false, true)

    currentPos = GetEntityCoords(ped)
    print(currentPos) -- changed!
end, false)
