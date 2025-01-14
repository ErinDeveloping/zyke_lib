-- This is free to change, you can see all values used if you want to change it in any way
-- Keep in mind, we will not provide support for any changes made to the snippet below
function Functions.Log(passed)
    if (type(passed) ~= "table") then return end -- Make sure the passed argument is a table to continue
    if (passed.logsEnabled == false) or (passed.logsEnabled == nil) then return end -- Make sure logs are enabled in that resource to continue

    -- Bot
    local username = "Zyke Resources' Logs"
    local avatarUrl = "https://cdn.discordapp.com/attachments/1048900415967744031/1081685770898784506/zyke.jpg"
    local webhook = passed.webhook or "" -- Insert a fallback webhook here, meaning if the resource doesn't have a webhook set, it will use this one instead

    -- Message
    local scriptName = passed.scriptName or "Unknown Script"
    local identifier = passed.identifier or "Unknown Identifier"
    local message = passed.message or "Empty Message"
    local action = passed.action or "Unknown Action"

    local field1 = {
        ["name"] = "Basic Information",
        ["value"] = "Script: " .. scriptName .. "\nIdentifier: " .. identifier .. "\nAction: " .. action,
    }

    local field2 = {
        ["name"] = "Message",
        ["value"] = message,
    }

    local field3 = passed.rawData and {
        ["name"] = "Raw Data",
        ["value"] = json.encode(passed.rawData, {indent = true}),
    } or nil

    local embeds = {
        {
            ["type"] = "rich",
            ["fields"] = {field1, field2, field3},
            ["color"] = "3447003", -- https://gist.github.com/thomasbnt/b6f455e2c7d743b796917fa3c205f812
            ["footer"]=  {
                ["icon_url"] = "https://cdn.discordapp.com/attachments/1048900415967744031/1081687600080879647/toppng.com-browser-history-clock-icon-vector-white-541x541.png",
                ["text"] = "Sent: " .. os.date(),
            },
        }
    }

    local payload = {
        embeds = embeds,
        username = username,
        avatar_url = avatarUrl,
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

function Functions.HasItem(player, item, amount)
    if (type(player) ~= "table") then
        player = Functions.GetPlayer(player)
    end

    if (not player) then return false, Functions.Debug("Player not found (CRITICAL!)") end

    if (Config.Framework == "QBCore") then
        local source = Functions.GetSource(player)
        local formatted = Functions.FormatItems(item, amount)

        local hasItem = QBCore.Functions.HasItem(source, formatted)
        return hasItem
    elseif (Config.Framework == "ESX") then
        local formatted = Functions.FormatItems(item, amount)
        local hasItems = true

        for itemIdx, itemData in pairs(formatted) do
            local hasItem = player.getInventoryItem(itemData.name)

            if ((hasItem?.count or 0) < itemData.count) then
                hasItems = false
            end
        end

        return hasItems
    end
end

-- Not used
function Functions.GetPlayerItemByName(player, item)
    if (type(player) ~= "table") then
        player = Functions.GetPlayer(player)
    end

    if (Config.Framework == "QBCore") then
        return player.Functions.GetItemByName(item)
    elseif (Config.Framework == "ESX") then
        return player.getInventoryItem(item)
    end
end

function Functions.RemoveItem(player, item, amount)
    if (type(player) ~= "table") then
        player = Functions.GetPlayer(player)
    end

    if (not player) then return false, Functions.Debug("Player not found (CRITICAL!)") end
    
    if (Config.Framework == "QBCore") then
        local formatted = Functions.FormatItems(item, amount)

        for _item, _amount in pairs(formatted) do
            player.Functions.RemoveItem(_item, _amount)
        end

        return true
    elseif (Config.Framework == "ESX") then
        local formatted = Functions.FormatItems(item, amount)

        for itemIdx, itemData in pairs(formatted) do
            player.removeInventoryItem(itemData.name, itemData.count)
        end

        return true
    end
end

function Functions.AddItem(player, item, amount)
    if (type(player) ~= "table") then
        player = Functions.GetPlayer(player)
    end

    if (not player) then return false, Functions.Debug("Player not found (CRITICAL!)") end
    
    if (Config.Framework == "QBCore") then
        local formatted = Functions.FormatItems(item, amount)

        for _item, _amount in pairs(formatted) do
            player.Functions.AddItem(_item, _amount)
        end

        return true
    elseif (Config.Framework == "ESX") then
        local formatted = Functions.FormatItems(item, amount)

        for itemIdx, itemData in pairs(formatted) do
            player.addInventoryItem(itemData.name, itemData.count)
        end

        return true
    end
end

function Functions.GetPlayersOnJob(job, onDuty)
    if (Config.Framework == "QBCore") then
        if (onDuty == true) then
            return QBCore.Functions.GetPlayersOnDuty(job)
        end
    elseif (Config.Framework == "ESX") then
        -- ESX doesn't have a default duty system, that's why we're not using it here
        -- If you do have it on your server, you can use the onDuty variable if it's needed in the script
        local players = {}

        for k, v in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(v)

            if (xPlayer.job.name == job) then
                table.insert(players, v)
            end
        end

        return players
    end
end

function Functions.EnoughWorkers(job, required)
    local players = Functions.GetPlayersOnJob(job, true)

    if (players ~= nil) then
        if (#players >= required) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function Functions.CreateUseableItem(item, passed)
    if (Config.Framework == "QBCore") then
        QBCore.Functions.CreateUseableItem(item, passed)
    elseif (Config.Framework == "ESX") then
        ESX.RegisterUsableItem(item, passed)
    end
end

function Functions.CreateCallback(name, passed)
    if (Config.Framework == "QBCore") then
        QBCore.Functions.CreateCallback(name, passed)
    elseif (Config.Framework == "ESX") then
        ESX.RegisterServerCallback(name, passed)
    end
end

function Functions.GetPlayer(source)
    if (type(source) == "string") then
        return Functions.GetPlayerFromIdentifier(source)
    end

    if (Config.Framework == "QBCore") then
        return QBCore.Functions.GetPlayer(source)
    elseif (Config.Framework == "ESX") then
        return ESX.GetPlayerFromId(source)
    end
end

function Functions.GetPlayerFromIdentifier(identifier)
    if (Config.Framework == "QBCore") then
        return QBCore.Functions.GetPlayerByCitizenId(identifier)
    elseif (Config.Framework == "ESX") then
        return ESX.GetPlayerFromIdentifier(identifier)
    end
end

function Functions.GetIdentifier(player)
    if (type(player) ~= "table") then -- If you send in a source it'll fetch the player
        player = Functions.GetPlayer(player)
    end

    if (Config.Framework == "QBCore") then
        return player?.PlayerData?.citizenid
    elseif (Config.Framework == "ESX") then
        return player?.identifier
    end
end

function Functions.AddMoney(player, moneyType, amount, details)
    if (type(player) ~= "table") then
        player = Functions.GetPlayer(player)
    end

    if (Config.Framework == "QBCore") then
        player.Functions.AddMoney(moneyType, amount, details)
    elseif (Config.Framework == "ESX") then
        moneyType = moneyType == "cash" and "money" or moneyType -- ESX uses "money" instead of "cash", so we're converting it here
        moneyType = moneyType == "dirty_cash" and "black_money" or moneyType -- ESX uses "black_money" instead of "dirty_cash", so we're converting it here
        player.addAccountMoney(moneyType, amount, details)
    end
end

function Functions.GetSource(player)
    if (type(player) ~= "table") then
        player = Functions.GetPlayer(player)
    end

    if (Config.Framework == "QBCore") then
        return player.PlayerData.source
    elseif (Config.Framework == "ESX") then
        return player.source
    end
end

function Functions.GetItem(item)
    if (Config.Framework == "QBCore") then
        return QBCore.Shared.Items[item]
    elseif (Config.Framework == "ESX") then
        return ESX.Items[item]
    end
end

function Functions.HasPermission(source, permission)
    if (type(source) == "table") then
        source = Functions.GetSource(source)
    end

    if (Config.Framework == "QBCore") then
        return QBCore.Functions.HasPermission(source, permission)
    elseif (Config.Framework == "ESX") then
        return IsPlayerAceAllowed(source, permission)
    end
end

-- Not tested and not active for any release yet, was temporarily tested for QB
function Functions.GetPlayerInventory(player)
    if (type(player) ~= "table") then
        player = Functions.GetPlayer(player)
    end

    if (Config.Framework == "QBCore") then
        return player.PlayerData.items
    elseif (Config.Framework == "ESX") then
        return player.inventory
    end
end

function Functions.GetInventory(invId)
    if (Config.Framework == "QBCore") then
        -- For some reason you can only retrieve this by a client callback, so I copied the code from the inventory
        -- If anyone knows of a better way, please feel free to make a pull request or let me know
        local items = {}
        local result = MySQL.scalar.await('SELECT items FROM stashitems WHERE stash = ?', {invId})
        if not result then return items end
    
        local stashItems = json.decode(result)
        if not stashItems then return items end
    
        for _, item in pairs(stashItems) do
            local itemInfo = QBCore.Shared.Items[item.name:lower()]
            if itemInfo then
                items[item.slot] = {
                    name = itemInfo["name"],
                    amount = tonumber(item.amount),
                    info = item.info or "",
                    label = itemInfo["label"],
                    description = itemInfo["description"] or "",
                    weight = itemInfo["weight"],
                    type = itemInfo["type"],
                    unique = itemInfo["unique"],
                    useable = itemInfo["useable"],
                    image = itemInfo["image"],
                    slot = item.slot,
                }
            end
        end

        return items
    elseif (Config.Framework == "ESX") then
        return ESX.GetInventory(invId) -- Not tested (Not in use for any active releases yet)
    end
end

function Functions.OpenInventory(invId, type)
    type = type or "stash"
    if (Config.Framework == "QBCore") then
        TriggerEvent("inventory:server:OpenInventory", type, invId)
    elseif (Config.Framework == "ESX") then
        -- return ESX.GetInventory(invId) -- Not tested (Not in use for any active releases yet)
    end
end

function Fetch()
    return Functions
end

exports("Fetch", Fetch)