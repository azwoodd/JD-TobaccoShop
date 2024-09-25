--client
local QBCore = exports['qb-core']:GetCoreObject()
-- qb-target locations for the shop job

-- Redwood Till
exports['qb-target']:AddBoxZone("redwoodtill", vector3(-37.14, -1060.62, 27.61), 1, 1, {
    name="redwoodtill",
    heading=340,
    debugPoly=false,  -- Uncomment this and set to true if you need to visualize the box
    minZ=27.01,
    maxZ=27.81
  }, {
    options = {
      {
        type = "client",  -- or "server" depending on your needs
        event = "your_event_name", -- replace with your event
        icon = "fas fa-cash-register",  -- replace with the icon you want
        label = "Use Till"
      },
    },
    distance = 2.0
  })
  
  -- Redwood Craft Bench
  exports['qb-target']:AddBoxZone("redwoodcraftbench", vector3(-35.72, -1062.0, 27.61), 3.4, 1, {
    name="redwoodcraftbench",
    heading=334,
    debugPoly=false,
    minZ=27.41,
    maxZ=29.61
  }, {
    options = {
      {
        type = "client",
        event = "your_event_name",
        icon = "fas fa-toolbox",
        label = "Use Craft Bench"
      },
    },
    distance = 2.0
  })
  
  -- Redwood Give
  exports['qb-target']:AddBoxZone("redwoodgive", vector3(-37.81, -1062.36, 27.61), 2.0, 1, {
    name="redwoodgive",
    heading=340,
    debugPoly=false,
    minZ=27.21,
    maxZ=28.01
  }, {
    options = {
      {
        type = "client",
        event = "your_event_name",
        icon = "fas fa-hand-holding",
        label = "Give Items"
      },
    },
    distance = 2.0
  })
  

  -- Redwood Shop Input Stock
  exports['qb-target']:AddBoxZone("redwoodshopinput", vector3(-29.18, -1071.0, 27.61), 5.0, 1, {
    name="redwoodshopinput",
    heading=340,
    debugPoly=false,
    minZ=26.61,
    maxZ=31.21
  }, {
    options = {
      {
        type = "client",
        event = "your_event_name",
        icon = "fas fa-box",
        label = "Input Shop Items"
      },
    },
    distance = 3.0
  })
  
  -- Redwood Shop Storage
  exports['qb-target']:AddBoxZone("redwoodshopstore", vector3(-28.41, -1064.06, 27.61), 2, 2, {
    name="redwoodshopstore",
    heading=340,
    debugPoly=false,
    minZ=27.01,
    maxZ=28.21
  }, {
    options = {
      {
        type = "client",
        event = "your_event_name",
        icon = "fas fa-store",
        label = "Access Shop Storage"
      },
    },
    distance = 2.0
  })
  
  -- Clock In Redwood Shop
  exports['qb-target']:AddBoxZone("clockinredwoodshop", vector3(-36.37, -1070.25, 32.81), 3.8, 0.5, {
    name="clockinredwoodshop",
    heading=70,
    debugPoly=false,
    minZ=32.21,
    maxZ=34.01
  }, {
    options = {
      {
        type = "client",
        event = "your_event_name",
        icon = "fas fa-clock",
        label = "Clock In"
      },
    },
    distance = 2.0
  })
  





















  local QBCore = exports['qb-core']:GetCoreObject()

  -- Target zones for the shop job
  exports['qb-target']:AddBoxZone("redwoodshoppc", vector3(-34.03, -1071.11, 27.61), 1.6, 1, {
      name = "redwoodshoppc",
      heading = 65,
      debugPoly = false,
      minZ = 26.81,
      maxZ = 28.21
  }, {
      options = {
          {
              type = "client",
              event = "jd-tobaccoshop:openShopUI",
              icon = "fas fa-desktop",
              label = "Use Shop PC"
          },
      },
      distance = 2.0
  })
  
  -- Open the shop UI
  RegisterNetEvent('jd-tobaccoshop:openShopUI')
  AddEventHandler('jd-tobaccoshop:openShopUI', function()
      SetNuiFocus(true, true)
      SendNUIMessage({ action = 'openShopUI' })
      TriggerServerEvent('jd-tobaccoshop:requestShopStock')
  end)
  
  -- Update shop stock when requested
  RegisterNetEvent('jd-tobaccoshop:updateShopStock')
  AddEventHandler('jd-tobaccoshop:updateShopStock', function(stockData)
      SendNUIMessage({
          action = 'updateShopStock',
          craftingTobacco = stockData.craftingTobacco,
          cigarettes = stockData.cigarettes,
          cigars = stockData.cigars,
          vapes = stockData.vapes
      })
  end)
  

  
  -- Escape key listener
  Citizen.CreateThread(function()
      while true do
          Citizen.Wait(0)
          if IsControlJustReleased(0, 177) then  -- ESC key
              TriggerEvent('jd-tobaccoshop:closeShopUI')  -- Trigger the close event
          end
      end
  end)
  

  -- Close the shop UI when called from NUI
RegisterNUICallback('closeShopUI', function(data, cb)
  SetNuiFocus(false, false)  -- Disable NUI focus
  SendNUIMessage({ action = 'closeShopUI' })  -- Send a message to hide the UI
  cb('ok')
end)

-- Close the UI when the delivery starts
RegisterNUICallback('startClientDelivery', function(data, cb)
  -- Coordinates for van spawn
  local vanCoords = vector3(-41.72, -1066.82, 27.43)

  -- Vehicle and delivery setup logic (as previously discussed)
  local vehicleModel = GetHashKey("burrito2")

  RequestModel(vehicleModel)
  while not HasModelLoaded(vehicleModel) do
      Citizen.Wait(100)
  end

  local playerPed = PlayerPedId()
  local spawnedVan = CreateVehicle(vehicleModel, vanCoords.x, vanCoords.y, vanCoords.z, 70.0, true, false)

  SetVehicleFuelLevel(spawnedVan, 100.0)
  TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(spawnedVan))
  TaskWarpPedIntoVehicle(playerPed, spawnedVan, -1)
  SetVehicleHasBeenOwnedByPlayer(spawnedVan, true)
  SetEntityAsMissionEntity(spawnedVan, true, true)

  -- qb-target options (as previously discussed)
  exports['qb-target']:AddTargetEntity(spawnedVan, {
      options = {
          {
              type = "client",
              event = "jd-tobaccoshop:loadVanDelivery",
              icon = "fas fa-box",
              label = "Load Van"
          },
          {
              type = "client",
              event = "jd-tobaccoshop:unloadVanDelivery",
              icon = "fas fa-box-open",
              label = "Unload Van"
          }
      },
      distance = 2.5
  })

  -- Notify player and close the NUI
  QBCore.Functions.Notify("Van spawned and ready for delivery!", "success")

  -- Close the shop UI after delivery is triggered
  SetNuiFocus(false, false)  -- Disable NUI focus
  SendNUIMessage({ action = 'closeShopUI' })  -- Send a message to hide the UI

  cb('ok')
end)









local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('cigarette:use', function()
    local playerPed = PlayerPedId()

    -- Play a smoking animation while allowing player movement
    RequestAnimDict("amb@world_human_smoking@male@male_a@enter")
    while not HasAnimDictLoaded("amb@world_human_smoking@male@male_a@enter") do
        Wait(100)
    end

    -- Use flag 49 to allow movement while playing the animation
    TaskPlayAnim(playerPed, "amb@world_human_smoking@male@male_a@enter", "enter", 8.0, -8.0, -1, 49, 0, false, false, false)

    -- Simulate smoking duration before ending the animation (optional)
    Wait(5000)  -- Wait for 5 seconds (adjust if needed)

    -- Optionally, you can clear the animation afterwards
    ClearPedTasks(playerPed)
end)

-- Client event for smoking animation (similar to the cigarette)
RegisterNetEvent('cigar:use', function()
  local playerPed = PlayerPedId()

  -- Play the smoking animation
  RequestAnimDict("amb@world_human_smoking@male@male_a@enter")
  while not HasAnimDictLoaded("amb@world_human_smoking@male@male_a@enter") do
      Wait(100)
  end

  TaskPlayAnim(playerPed, "amb@world_human_smoking@male@male_a@enter", "enter", 8.0, -8.0, -1, 49, 0, false, false, false)

  -- Simulate smoking duration
  Wait(5000)  -- Adjust as needed

  -- Clear the animation afterwards
  ClearPedTasks(playerPed)
end)







