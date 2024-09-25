--server
local QBCore = exports['qb-core']:GetCoreObject()

-- Function to retrieve stock from the database
local function getShopStock(callback)
    exports['oxmysql']:fetch('SELECT item_name, stock FROM shop_stock', {}, function(result)
        if result then
            local stockData = {
                craftingTobacco = 0,
                cigarettes = 0,
                cigars = 0,
                vapes = 0
            }
            for _, item in ipairs(result) do
                if item.item_name == 'crafting_tobacco' then
                    stockData.craftingTobacco = item.stock
                elseif item.item_name == 'cigarettes' then
                    stockData.cigarettes = item.stock
                elseif item.item_name == 'cigars' then
                    stockData.cigars = item.stock
                elseif item.item_name == 'vapes' then
                    stockData.vapes = item.stock
                end
            end
            callback(stockData)
        else
            callback(nil)
        end
    end)
end

-- Event to send stock data to the client
RegisterNetEvent('jd-tobaccoshop:requestShopStock')
AddEventHandler('jd-tobaccoshop:requestShopStock', function()
    local src = source
    getShopStock(function(stockData)
        if stockData then
            TriggerClientEvent('jd-tobaccoshop:updateShopStock', src, stockData)
        end
    end)
end)

-- Delivery job handling logic
RegisterNetEvent('jd-tobaccoshop:startDeliveryJob')
AddEventHandler('jd-tobaccoshop:startDeliveryJob', function()
    local playerName = GetPlayerName(source)
    local deliveryTime = os.date('%Y-%m-%d %H:%M:%S')

    -- Log the delivery job
    exports['oxmysql']:insert('INSERT INTO delivery_logs (player_name, delivery_time) VALUES (?, ?)', { playerName, deliveryTime })

    -- Notify the client to close the shop UI
    TriggerClientEvent('jd-tobaccoshop:closeShopUI', source)

    -- Add any other logic related to delivery here (e.g., delivery tasks)
end)

-- Open the shop UI and request stock when the NUI is opened
RegisterNetEvent('jd-tobaccoshop:openShopUI')
AddEventHandler('jd-tobaccoshop:openShopUI', function()
    local src = source
    TriggerClientEvent('jd-tobaccoshop:openShopUI', src)
    TriggerEvent('jd-tobaccoshop:requestShopStock', src)
end)









local QBCore = exports['qb-core']:GetCoreObject()



RegisterNetEvent('hud:server:RelieveStress', function(stressAmount, playerSource)
    local Player = QBCore.Functions.GetPlayer(playerSource)
    if Player then
        -- Retrieve current stress from player metadata
        local currentStress = Player.PlayerData.metadata["stress"] or 0

        -- Calculate the new stress level, ensuring it doesn't go below 0
        local newStress = math.max(0, currentStress - stressAmount)

        -- Update the player's metadata with the new stress level
        Player.Functions.SetMetaData("stress", newStress)

        -- Send the updated stress level to the client to update the HUD
        TriggerClientEvent('hud:client:UpdateStress', playerSource, newStress)
    end
end)



-- normal smokeables




-- Make the cigarette usable

QBCore.Functions.CreateUseableItem('cigarette', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

    -- Check if the player has a cigarette in their inventory
    if Player.Functions.GetItemByName(item.name) then
        -- Directly call the server-side stress relief event (no need for TriggerServerEvent)
        local stressAmount = math.random(Config.MinStress, Config.MaxStress)
        TriggerEvent('hud:server:RelieveStress', stressAmount, source)

        -- Trigger the client-side event to handle the animation
        TriggerClientEvent('cigarette:use', source)

        -- Remove one cigarette from the player's inventory
        Player.Functions.RemoveItem('cigarette', 1)

        -- Notify the player that they used a cigarette
        TriggerClientEvent('QBCore:Notify', source, "You smoked a cigarette and feel more relaxed.", "success")
    end
end)

-- Make the cigar usable


QBCore.Functions.CreateUseableItem('cigar', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

    -- Check if the player has a cigar in their inventory
    if Player.Functions.GetItemByName(item.name) then
        -- Directly call the server-side stress relief event (no need for TriggerServerEvent)
        local stressAmount2 = math.random(Config.MinStressc, Config.MaxStressc)
        TriggerEvent('hud:server:RelieveStress', stressAmount2, source)

        -- Trigger the client-side event to handle the animation
        TriggerClientEvent('cigar:use', source)

        -- Remove one cigar from the player's inventory
        Player.Functions.RemoveItem('cigar', 1)

        -- Notify the player that they used a cigar
        TriggerClientEvent('QBCore:Notify', source, "You smoked a cigar and feel more relaxed.", "success")
    end
end)


