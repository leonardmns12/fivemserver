RegisterNetEvent("esx_advancedbankrobberym:openDoor")
AddEventHandler("esx_advancedbankrobberym:openDoor", function(bankId)
    OpenDoor(bankId)
end)

RegisterNetEvent("esx_advancedbankrobberym:OpenDeskDoor")
AddEventHandler("esx_advancedbankrobberym:OpenDeskDoor", function(bankId)
    OpenDeskDoor(bankId)
end)

function ResetDoor(bankId)
    local Bank = BankHeists[bankId]
    local door = GetClosestObjectOfType(Bank['Bank_Vault']['x'], Bank['Bank_Vault']['y'], Bank['Bank_Vault']['z'], 3.0, Bank['Bank_Vault']['model'])
    SetEntityRotation(door, 0.0, 0.0, Bank["Bank_Vault"]["hStart"], 0.0)

    local deskDoor = GetClosestObjectOfType(Bank['Desk_Door']['x'], Bank['Desk_Door']['y'], Bank['Desk_Door']['z'], 3.0, Bank['Desk_Door']['model'])
    SetEntityRotation(deskDoor, 0.0, 0.0, Bank["Desk_Door"]["hStart"], 0.0)
end

function ResetDoors()
    for bank, values in pairs(BankHeists) do
        local door = GetClosestObjectOfType(values['Bank_Vault']['x'], values['Bank_Vault']['y'], values['Bank_Vault']['z'], 3.0, values['Bank_Vault']['model'])
        SetEntityRotation(door, 0.0, 0.0, values["Bank_Vault"]["hStart"], 0.0)
        FreezeEntityPosition(door, true)

        local deskDoor = GetClosestObjectOfType(values['Desk_Door']['x'], values['Desk_Door']['y'], values['Desk_Door']['z'], 3.0, values['Desk_Door']['model'])
        SetEntityRotation(deskDoor, 0.0, 0.0, values["Desk_Door"]["hStart"], 0.0)
        FreezeEntityPosition(deskDoor, true)
    end
end

function OpenDoor(bankId)
    ResetDoor(bankId)

    local Bank = BankHeists[bankId]

    local door = GetClosestObjectOfType(Bank['Bank_Vault']['x'], Bank['Bank_Vault']['y'], Bank['Bank_Vault']['z'], 3.0, Bank['Bank_Vault']['model'])
    local rotation = GetEntityRotation(door)["z"]

	Citizen.CreateThread(function()
		FreezeEntityPosition(door, false)

        while rotation >= Bank["Bank_Vault"]["hEnd"] do
            Citizen.Wait(1)

            rotation = rotation - 0.25

            SetEntityRotation(door, 0.0, 0.0, rotation)
        end

        while rotation <= Bank["Bank_Vault"]["hEnd"] do
            Citizen.Wait(1)

            rotation = rotation + 0.25

            SetEntityRotation(door, 0.0, 0.0, rotation)
        end

		FreezeEntityPosition(door, true)
    end)

end

function OpenDeskDoor(bankId)
    ResetDoor(bankId)

    local Bank = BankHeists[bankId]

    local deskDoor = GetClosestObjectOfType(Bank['Desk_Door']['x'], Bank['Desk_Door']['y'], Bank['Desk_Door']['z'], 1.5, Bank['Desk_Door']['model'])
    local rotation = GetEntityRotation(deskDoor)["z"]

	Citizen.CreateThread(function()
		FreezeEntityPosition(deskDoor, false)

        while rotation <= Bank["Desk_Door"]["hEnd"] do
            Citizen.Wait(1)

            rotation = rotation + 0.25

            SetEntityRotation(deskDoor, 0.0, 0.0, rotation)
        end

        while rotation >= Bank["Desk_Door"]["hEnd"] do
            Citizen.Wait(1)

            rotation = rotation - 0.25

            SetEntityRotation(deskDoor, 0.0, 0.0, rotation)
        end

		FreezeEntityPosition(deskDoor, true)
    end)

end

