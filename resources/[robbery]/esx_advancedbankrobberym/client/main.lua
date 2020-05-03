ESX = nil
local robberyOngoing = false
local blipRobbery = nil
local dropoffBlip = nil
local bagBlip = nil
local hackDone = false
local keycardIn = false
local lockpicked = false
local deskItems = false
local vaultItems = false
local desk_robbed = {}
local vault_robbed = {}
local cash_robbed = {}
local desk = {}
local totalCash = 0
local cardTime = 0
local fcDoor = 0
local cardAccept = false
local sum = {}
local dyeChance = 0
local escaping = false
local dyeActivated = false
local dropoffSet = false
local dyeSet = false
local tooFar = false
local HackPosition = {}
local doorHeading = 0
local door = {}
local deskHeading = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(1)
    end

    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent("esx_advancedbankrobberym:heistBlip")
AddEventHandler("esx_advancedbankrobberym:heistBlip", function(bankId)
    local coords = BankHeists[bankId]["Hack_Pos"]
    blipRobbery = AddBlipForCoord(coords["x"], coords["y"], coords["z"])
    SetBlipSprite(blipRobbery, 161)
    SetBlipScale(blipRobbery, 1.5)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
end)

RegisterNetEvent("esx_advancedbankrobberym:delHeistBlip")
AddEventHandler("esx_advancedbankrobberym:delHeistBlip", function()
  RemoveBlip(blipRobbery)
end)

RegisterNetEvent("esx_advancedbankrobberym:startRobbery")
AddEventHandler("esx_advancedbankrobberym:startRobbery", function(bankId)
    TriggerEvent("mhacking:show")
	  TriggerEvent("mhacking:start",3,60,hacking)
    while true do
      Citizen.Wait(1000)
      if cardAccept then
        if(cardTime > 0)then
          cardTime = cardTime - 1
        else
          TriggerServerEvent("esx_advancedbankrobberym:vaultOpen", bankId)
          StartRobbery(bankId)
          hackDone = false
          keycardIn = false
          deskItems = false
          cardAccept = false
        end
      end
    end
end)

function hacking(success)
	if success then
		TriggerEvent('mhacking:hide')
    hackDone = true
	else
		TriggerEvent('mhacking:hide')
    TriggerServerEvent("esx_advancedbankrobberym:endRobbery", bankId)
	end
end

RegisterNetEvent("esx_advancedbankrobberym:cardTime")
AddEventHandler("esx_advancedbankrobberym:cardTime", function(bankId, _cardTime, _dyeChance)
    cardTime = _cardTime
    dyeChance = _dyeChance
    if cardTime == nil then
      keycardIn = false
    else
      cardAccept = true
      while keycardIn do
        Citizen.Wait(0)
        local sec = SecondsToClock(cardTime)
        ESX.Game.Utils.DrawText3D(HackPosition, _U('vault_open') .. sec, 0.35)
      end
    end
end)

RegisterNetEvent("esx_advancedbankrobberym:tooFar")
AddEventHandler("esx_advancedbankrobberym:tooFar", function(bankId)
  Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
    local pos = GetEntityCoords(PlayerPedId())
    HackPosition = BankHeists[bankId]["Hack_Pos"]
      if not tooFar then
        if(GetDistanceBetweenCoords(pos, HackPosition["x"], HackPosition["y"], HackPosition["z"], false) > 30) then
          TriggerServerEvent("esx_advancedbankrobberym:endRobbery", bankId)
          ResetDoors(bankId)
          hackDone = false
          keycardIn = false
          lockpicked = false
          tooFar = true
          if robberyOngoing then
            robberyOngoing = false
            escape(bankId)
          end
        end
      end
    end
  end)
end)

function endEscape()
  sum = {}
  HackPosition = {}
  dyeChance = 0
  vaultItems = false
  desk = {}
  totalCash = 0
  cardTime = 0
  fcDoor = 0
  dyeActivated = false
  dropoffSet = false
  dyeSet = false
end

Citizen.CreateThread(function()
    ResetDoors()

    while true do
      Citizen.Wait(0)
      if not robberyOngoing then
        for bank,v in pairs(BankHeists) do
          local pos = GetEntityCoords(PlayerPedId())
          local doorPosition = v["Desk_Door"]
          local newHackPosition = v["Hack_Pos"]
          local lockDist = GetDistanceBetweenCoords(pos, doorPosition["x"], doorPosition["y"], doorPosition["z"], false)
          local hackDist = GetDistanceBetweenCoords(pos, newHackPosition["x"], newHackPosition["y"], newHackPosition["z"], false)

          if (lockDist <= 8.0) and not lockpicked then
            ESX.Game.Utils.DrawText3D(doorPosition, "[~g~E~s~] Lockpick", 0.35)
            if lockDist <= 1 then
              if IsControlJustPressed(0, 38) then
                for i = 1, 7 do
                  desk_robbed[i] = false
                end
                findDoor(bank)
                TriggerServerEvent("esx_advancedbankrobberym:lockpickDoor", bank)
              end
            end
          end

          if (hackDist <= 8.0) and not hackDone then
            ESX.Game.Utils.DrawText3D(newHackPosition, "[~g~E~s~] Hack", 0.35)
            if hackDist <= 1 then
              if IsControlJustPressed(0, 38) then
                for i = 1, #v.vault, 1 do
                  vault_robbed[i] = false
                end
                for i = 1, #v.cashPickup, 1 do
                  cash_robbed[i] = false
                end
                TriggerServerEvent("esx_advancedbankrobberym:startRobbery", bank)
              end
            end
          elseif (hackDist <= 8.0) and hackDone and not keycardIn then
            ESX.Game.Utils.DrawText3D(newHackPosition, "[~g~E~s~] Use keycard", 0.35)
            if hackDist <= 1 then
              if IsControlJustPressed(0, 38) then
                keycardIn = true
                TriggerServerEvent("esx_advancedbankrobberym:keycardCheck", bank)
              end
            end
          end
        end
      end
    end
end)

function findDoor(bank)
  local pos = GetEntityCoords(PlayerPedId())
  if bank == "PrincipalBank" then
    fcDoor = GetClosestObjectOfType(pos, 3.0, -222270721, false)
    door = (GetOffsetFromEntityInWorldCoords(fcDoor, 1.2, -0.82, 0.0))
  elseif bank == "blaineCounty" then
    fcDoor = GetClosestObjectOfType(pos, 3.0, -1184592117, false)
    door = (GetOffsetFromEntityInWorldCoords(fcDoor, -0.90, -0.85, 0.0))
  else
    fcDoor = GetClosestObjectOfType(pos, 3.0, -131754413, false)
    door = (GetOffsetFromEntityInWorldCoords(fcDoor, -0.90, -0.85, 0.0))
  end
  doorHeading = GetEntityHeading(fcDoor)
end

RegisterNetEvent("esx_advancedbankrobberym:desks")
AddEventHandler("esx_advancedbankrobberym:desks", function(bankId)
  Citizen.CreateThread(function()
    lockpicked = true
    local ped = PlayerPedId()
    TaskGoStraightToCoord(ped, door.x, door.y, door.z, 0.025, 5000, doorHeading, 0.1)
    Citizen.Wait(1500)
    TriggerEvent("mythic_progbar:client:progress", {
      name = "lockpicking",
      duration = 30000,
      label = "Lockpicking door..",
      useWhileDead = false,
      canCancel = false,
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      },
      animation = {
          animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
          anim = "machinic_loop_mechandplayer",
          flags = 49,
      },
}, function(status)
    if not status then
      if bankId ~= "PrincipalBank" then
        desk[1] = (GetOffsetFromEntityInWorldCoords(fcDoor, -1.0, 1.0, -0.1))
        desk[2] = (GetOffsetFromEntityInWorldCoords(fcDoor, -1.0, 2.5, -0.1))
        desk[3] = (GetOffsetFromEntityInWorldCoords(fcDoor, -1.0, 4.0, -0.1))
        desk[4] = (GetOffsetFromEntityInWorldCoords(fcDoor, -1.0, 5.4, -0.1))
        for i = 1, 4 do
          deskHeading[i] = doorHeading + 90
        end
      else
        desk[1] = (GetOffsetFromEntityInWorldCoords(fcDoor, -3.74, 0.92, -0.3))
        deskHeading[1] = 165.0
        desk[2] = (GetOffsetFromEntityInWorldCoords(fcDoor, -9.2, 0.92, -0.3))
        deskHeading[2] = 165.0
        desk[3] = (GetOffsetFromEntityInWorldCoords(fcDoor, -14.67, 0.92, -0.3))
        deskHeading[3] = 165.0
        desk[4] = (GetOffsetFromEntityInWorldCoords(fcDoor, -7.55, 5.27, -0.3))
        deskHeading[4] = 75.0
        desk[5] = (GetOffsetFromEntityInWorldCoords(fcDoor, -10.10, 3.84, -0.3))
        deskHeading[5] = 251.5
        desk[6] = (GetOffsetFromEntityInWorldCoords(fcDoor, -12.55, 5.27, -0.3))
        deskHeading[6] = 75.0
        desk[7] = (GetOffsetFromEntityInWorldCoords(fcDoor, -15.20, 3.84, -0.3))
        deskHeading[7] = 251.5
     end
      TriggerServerEvent("esx_advancedbankrobberym:deskOpen", bankId)
    end
  end)

    while true do
      Citizen.Wait(0)
      local pos = GetEntityCoords(PlayerPedId())
      for i = 1, #desk, 1 do
        if(GetDistanceBetweenCoords(pos, desk[i].x, desk[i].y, desk[i].z, false) <= 8) then
          if (desk_robbed[i] == false) then
          ESX.Game.Utils.DrawText3D({x = desk[i].x, y = desk[i].y, z = desk[i].z}, "[~g~E~s~] Search desk", 0.35)
            if(GetDistanceBetweenCoords(pos, desk[i].x, desk[i].y, desk[i].z, false) <= 0.5) then
              if IsControlJustPressed(0, 38) then
                local ped = PlayerPedId()
                TaskGoStraightToCoord(ped, desk[i].x, desk[i].y, desk[i].z, 0.025, 5000, deskHeading[i], 0.1)
                print(deskHeading[i])
                Citizen.Wait(1000)
                deskItems = true
                desk_robbed[i] = true

                TriggerEvent("mythic_progbar:client:progress", {
                    name = "searching",
                    duration = 10000,
                    label = "Searching desk..",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                      disableMovement = true,
                      disableCarMovement = true,
                      disableMouse = false,
                      disableCombat = true,
                    },
                    animation = {
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        anim = "machinic_loop_mechandplayer",
                        flags = 49,
                    },
                }, function(status)
                    if not status then
                      randomItem()
                    end
                end)
              end
            end
          end
        end
      end
    end
  end)
end)

function StartRobbery(bankId)
  Citizen.CreateThread(function()
    robberyOngoing = true
    tooFar = false
    local ped = PlayerPedId()
    SetPedComponentVariation(ped, 5, 40, 0, 1)

    while robberyOngoing do
      Citizen.Wait(0)
      local pos = GetEntityCoords(PlayerPedId())
      for bank,v in pairs(BankHeists) do
        for i = 1, #v.vault, 1 do
          if(GetDistanceBetweenCoords(pos, v.vault[i].x, v.vault[i].y, v.vault[i].z, true) <= 40) then
            if (vault_robbed[i] == false) then
              ESX.Game.Utils.DrawText3D({x = v.vault[i].x, y = v.vault[i].y, z = v.vault[i].z}, "[~g~E~s~] Open deposit box", 0.35)
              if(GetDistanceBetweenCoords(pos, v.vault[i].x, v.vault[i].y, v.vault[i].z, true) <= 0.5) then
                if IsControlJustReleased(1, 51) then
                  local ped = PlayerPedId()
                  TaskGoStraightToCoord(ped, v.vault[i].x, v.vault[i].y, v.vault[i].z, 0.025, 5000, v.vault[i].h, 0.05)
                  Citizen.Wait(1500)
                  vaultItems = true
                  vault_robbed[i] = true

                  TriggerEvent("mythic_progbar:client:progress", {
                		  name = "blowtorching",
                		  duration = 30000,
                		  label = "Opening deposit box..",
                		  useWhileDead = false,
                		  canCancel = true,
                		  controlDisables = {
                		    disableMovement = true,
                		    disableCarMovement = true,
                		    disableMouse = false,
                		    disableCombat = true,
                		  },
                		    animation = {
                		    task = "WORLD_HUMAN_WELDING"
                		  },
                		}, function(status)
                		    if not status then
                		      randomItem()
                          table.insert(sum, BankHeists[bankId]["reward"])
                          ESX.ShowNotification("~g~$" .. BankHeists[bankId]["reward"] .. _U('cash_to_bag'))
                		    end
                	  end)
                end
              end
            end
          end
        end

        for i = 1, #v.cashPickup, 1 do
          if(GetDistanceBetweenCoords(pos, v.cashPickup[i].x, v.cashPickup[i].y, v.cashPickup[i].z, true) <= 30) then
            if cash_robbed[i] == false then
              ESX.Game.Utils.DrawText3D({x = v.cashPickup[i].x, y = v.cashPickup[i].y, z = v.cashPickup[i].z}, "[~g~E~s~] Pickup cash", 0.35)
              if(GetDistanceBetweenCoords(pos, v.cashPickup[i].x, v.cashPickup[i].y, v.cashPickup[i].z, true) <= 2.0) then
                if IsControlJustReleased(1, 51) then
                  while true do
                    Citizen.Wait(3000)
                    table.insert(sum, BankHeists[bankId]["reward"])
                    ESX.ShowNotification("~g~$" .. BankHeists[bankId]["reward"] .. _U('cash_to_bag'))
                  end
                  Citizen.CreateThread(function()
                    local animDict = "anim@heists@ornate_bank@grab_cash"
              			RequestAnimDict(animDict)
              			RequestModel("hei_p_m_bag_var22_arm_s")
              			RequestModel("hei_prop_hei_cash_trolly_01")

              			while not HasAnimDictLoaded(animDict) or
              				not HasModelLoaded("hei_p_m_bag_var22_arm_s") or
              				not HasModelLoaded("hei_prop_hei_cash_trolly_01") do
              				Citizen.Wait(100)
              			end

              			local ped = PlayerPedId()
              			local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))
              			local animPos = GetAnimInitialOffsetPosition(animDict, "grab", targetPosition, targetRotation, 0, 2)

              			FreezeEntityPosition(ped, true)
              			local netScene = NetworkCreateSynchronisedScene(targetPosition, targetRotation, 2, false, false, 1065353216, 0, 1.3)
              			NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "grab", 1.5, -4.0, 1, 16, 1148846080, 0)

              		  local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), targetPosition, 1, 1, 0)
                		NetworkAddEntityToSynchronisedScene(bag, netScene, animDict, "bag_grab", 4.0, -8.0, 1)

                		local trolly = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), v.cashPickup[i].x, v.cashPickup[i].y, v.cashPickup[i].z, 1, 1, 0)
                    PlaceObjectOnGroundProperly(trolly)
                		NetworkAddEntityToSynchronisedScene(trolly, netScene, animDict, "cart_cash_dissapear", 4.0, -8.0, 1)

              			NetworkStartSynchronisedScene(netScene)
              			Citizen.Wait(GetAnimDuration(animDict, "grab") * 1000) -- 47.93 secs

              			NetworkStopSynchronisedScene(netScene)
              			DeleteObject(bag)
              			DeleteObject(trolly)
              			FreezeEntityPosition(ped, false)
                  end)
                end
              end
            end
          end
        end
      end
    end
  end)
end

function escape(bankId)
  escaping = true
  p = math.random(1,6)
  i = math.random(1,6)
  dyePct = math.random(1,100)

  if p == i then
    p = p + 1
    if p == 7 then p = 1 end
  end

  if dyePct <= dyeChance then
    dyePack()
    ESX.ShowNotification(_U('dye_explosion'))
    TriggerServerEvent('esx_advancedbankrobberym:bagTracker')
    dyeActivated = true
  end

  while escaping do
    Citizen.Wait(0)
    if dyeActivated and not dyeSet then
      dyeBlip = AddBlipForCoord(location[p].x, location[p].y, location[p].z)
      SetBlipSprite(dyeBlip, 606)
      SetBlipScale(dyeBlip, 1.0)
      SetBlipColour(dyeBlip, 1)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString('Deactivate dye pack')
      EndTextCommandSetBlipName(dyeBlip)

      RequestModel(-261389155)
      while not HasModelLoaded(-261389155) do
          Wait(1)
      end
  		dyeNpc = CreatePed(1, -261389155, location[p].x, location[p].y, location[p].z -1, location[p].h, true, true)
      SetPedCanPlayAmbientAnims(dyeNpc, true)
      FreezeEntityPosition(dyeNpc, true)
	    SetEntityInvincible(dyeNpc, true)
  		SetBlockingOfNonTemporaryEvents(dyeNpc, true)
      dyeSet = true
    elseif not dyeActivated and not dropoffSet then
      dropoffBlip = AddBlipForCoord(location[i].x, location[i].y, location[i].z)
      SetBlipSprite(dropoffBlip, 586)
      SetBlipScale(dropoffBlip, 1.0)
      SetBlipColour(dropoffBlip, 1)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString('Drop-off')
      EndTextCommandSetBlipName(dropoffBlip)

      RequestModel(1302784073)
      while not HasModelLoaded(1302784073) do
          Wait(1)
      end
  		dropoffNpc = CreatePed(1, 1302784073, location[i].x, location[i].y, location[i].z -1, location[i].h, true, true)
      SetPedCanPlayAmbientAnims(dropoffNpc, true)
      FreezeEntityPosition(dropoffNpc, true)
	    SetEntityInvincible(dropoffNpc, true)
  		SetBlockingOfNonTemporaryEvents(dropoffNpc, true)
      dropoffSet = true
    end

    if dyePct <= dyeChance and dyeActivated then
      local sec = SecondsToClock(Config.dyeTime)
      drawTxt(0.82, 1.44, 1.0, 1.0, 0.4, _U('dye_time_left') .. sec, 255, 255, 255, 255)
      if (Config.dyeTime <= 0) then
        ESX.ShowNotification(_U('cash_unusable'))
        StopParticleFxLooped(smoke)
        local ped = PlayerPedId()
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        DeleteEntity(dyeNpc)
        RemoveBlip(dyeBlip)
        escaping = false
        endEscape()
      end
    end

    if dyeActivated then
      local pos = GetEntityCoords(PlayerPedId())
      local dyeCoords = GetPedBoneCoords(dyeNpc, 24816, 0.25, 0.7, 0.0)
      local dyeDist = GetDistanceBetweenCoords(pos, dyeCoords.x, dyeCoords.y, dyeCoords.z, false)
      if dyeDist <= 15.0 then
        ESX.Game.Utils.DrawText3D({x = dyeCoords.x, y = dyeCoords.y, z = dyeCoords.z}, "[~g~E~s~] Deactivate dye pack", 0.35)
        if dyeDist <= 1 then
          if IsControlJustPressed(0, 38) then
            dyeActivated = false
            local ped = PlayerPedId()
            SetPedComponentVariation(ped, 5, 0, 0, 0)
            StopParticleFxLooped(smoke)

            TriggerEvent("mythic_progbar:client:progress", {
                name = "deactivation",
                duration = 15000,
                label = "Waiting for deactivation..",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                  disableMovement = true,
                  disableCarMovement = true,
                  disableMouse = false,
                  disableCombat = true,
                },
                animation = {
                    animDict = "amb@world_human_bum_standing@twitchy@idle_a",
                    anim = "idle_a",
                },
            }, function(status)
                if not status then
                  ESX.ShowNotification(_U('removed_dyepack'))
                  local ped = PlayerPedId()
                  SetPedComponentVariation(ped, 5, 40, 0, 2)
                  RemoveBlip(dyeBlip)
                  dyeActivated = false
                  Citizen.Wait(1000)
                  FreezeEntityPosition(dyeNpc, false)
                  TaskWanderStandard(dyeNpc)
                  Citizen.Wait(30000)
                  DeleteEntity(dyeNpc)
                end
            end)
          end
        end
      end
    else
      local pos = GetEntityCoords(PlayerPedId())
      local dropoffCoords = GetPedBoneCoords(dropoffNpc, 24816, 0.25, 0.7, 0.0)
      local dropoffDist = GetDistanceBetweenCoords(pos, dropoffCoords.x, dropoffCoords.y, dropoffCoords.z, false)
      if dropoffDist <= 15.0 then
        ESX.Game.Utils.DrawText3D({x = dropoffCoords.x, y = dropoffCoords.y, z = dropoffCoords.z}, "[~g~E~s~] Give bag to Lester", 0.35)
        if dropoffDist <= 1 then
          if IsControlJustPressed(0, 38) then
            local ped = PlayerPedId()
            SetPedComponentVariation(ped, 5, 0, 0, 0)

            TriggerEvent("mythic_progbar:client:progress", {
                name = "counting cash",
                duration = 10000,
                label = "Waiting for cash to be counted..",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                  disableMovement = true,
                  disableCarMovement = true,
                  disableMouse = false,
                  disableCombat = true,
                },
                animation = {
                    animDict = "amb@world_human_bum_standing@twitchy@idle_a",
                    anim = "idle_a",
                },
            }, function(status)
                if not status then
                  for k,v in pairs(sum) do
                    totalCash = totalCash + v
                  end
                  TriggerServerEvent('esx_advancedbankrobberym:giveCash', bankId, totalCash)

                  RemoveBlip(dropoffBlip)
                  Citizen.Wait(1000)
                  FreezeEntityPosition(dropoffNpc, false)
                  TaskWanderStandard(dropoffNpc)
                  escaping = false
                  Citizen.Wait(30000)
                  DeleteEntity(dropoffNpc)
                  endEscape()
                end
            end)
          end
        end
      end
    end
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if dyeActivated then
      if(Config.dyeTime > 0)then
        Citizen.Wait(1000)
        Config.dyeTime = Config.dyeTime - 1
      end
    end
  end
end)

RegisterNetEvent('esx_advancedbankrobberym:bagBlip')
AddEventHandler('esx_advancedbankrobberym:bagBlip', function()
  while true do
    Citizen.Wait(0)
    if dyeActivated then
      local pos = GetEntityCoords(PlayerPedId())
      bagBlip = AddBlipForCoord(pos.x, pos.y, pos.z)
      SetBlipSprite(bagBlip, 586)
      SetBlipScale(bagBlip, 1.0)
      SetBlipColour(bagBlip, 1)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString('Activated dye pack')
      EndTextCommandSetBlipName(bagBlip)
      Citizen.Wait(5000)
      RemoveBlip(bagBlip)
      Citizen.Wait(10000)
    end
  end
end)

function dyePack()
  if not HasNamedPtfxAssetLoaded("core") then
      RequestNamedPtfxAsset("core")
      while not HasNamedPtfxAssetLoaded("core") do
          Citizen.Wait(0)
      end
  end
  SetPtfxAssetNextCall("core")
  local ped = PlayerPedId()
  smoke = StartParticleFxLoopedOnEntityBone("proj_flare_fuse_fp", ped, 0.0, -0.25, 0.06, 20.0, 0.0, 0.0, 23553, 2.0, false, false, false)
end

function randomItem()
	Citizen.CreateThread(function()
		additems = math.random(1,100)
		if additems <= Config.itemsPct then
			randomitemcount = math.random(1,Config.itemsMax)
			for i = randomitemcount,1,-1 do
				if deskItems then
					local randomitempull = math.random(1, #Config.deskItems)
					local itemName = Config.deskItems[randomitempull]
					TriggerServerEvent('esx_advancedbankrobberym:giveItems', (itemName))
				elseif vaultItems then
					local randomitempull = math.random(1, #Config.vaultItems)
					local itemName = Config.vaultItems[randomitempull]
					TriggerServerEvent('esx_advancedbankrobberym:giveItems', (itemName))
				end
			end
		end
	end)
end

function drawTxt(x, y, width, height, scale, text, r,g,b,a, outline)
  SetTextFont(0)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  if(outline)then
    SetTextOutline()
  end
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width/2, y - height/2 + 0.005)
end

function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end
