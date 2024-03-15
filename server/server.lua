--[[


 /$$$$$$$$                                  /$$              
| $$_____/                                 | $$              
| $$       /$$    /$$  /$$$$$$  /$$$$$$$  /$$$$$$    /$$$$$$$
| $$$$$   |  $$  /$$/ /$$__  $$| $$__  $$|_  $$_/   /$$_____/
| $$__/    \  $$/$$/ | $$$$$$$$| $$  \ $$  | $$    |  $$$$$$ 
| $$        \  $$$/  | $$_____/| $$  | $$  | $$ /$$ \____  $$
| $$$$$$$$   \  $/   |  $$$$$$$| $$  | $$  |  $$$$/ /$$$$$$$/
|________/    \_/     \_______/|__/  |__/   \___/  |_______/ 
                                                             
                                                             
                                                             
--]]

-- Event triggered when a player joins the server
AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local source = source -- Player's server ID

    -- Get the player's license identifier
    local licenseIdentifier = GetPlayerIdentifierByType(source, 'license')

    if not licenseIdentifier then
        Debug("Failed to get license identifier for player.")
        return
    end

    Debug("Player joining with license: "..licenseIdentifier)

    -- Check if the license identifier exists in the table
    local query = string.format("SELECT * FROM Domas_RPXP WHERE identifier = '%s'", licenseIdentifier)

    ExecuteSql(query, function(result)
        if result and #result == 0 then
            -- If the identifier doesn't exist, add it to the table
            local insertQuery = string.format("INSERT INTO Domas_RPXP (identifier, xp) VALUES ('%s', 0)", licenseIdentifier)
            ExecuteSql(insertQuery, function()
                Debug("Player added to the Domas_RPXP table.")

                -- Trigger a client event to set the player's XP
                TriggerClientEvent('Domas_RPXP:SetPlayerXP', source, 0)
            end)
        else
            -- If the identifier already exists, retrieve the XP and trigger the client event
            local xpQuery = string.format("SELECT xp FROM Domas_RPXP WHERE identifier = '%s'", licenseIdentifier)
            ExecuteSql(xpQuery, function(xpResult)
                if xpResult and #xpResult > 0 then
                    local xp = xpResult[1].xp
                    TriggerClientEvent('Domas_RPXP:SetPlayerXP', source, xp)
                end
            end)
        end
    end)
end)


-- Passive XP system
if Config.PassiveXP then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.PassiveCooldown)

            for _, player in ipairs(GetPlayers()) do
                local licenseIdentifier = GetPlayerIdentifierByType(player, 'license')

                if licenseIdentifier then
                    local query = string.format("UPDATE Domas_RPXP SET xp = xp + %d WHERE identifier = '%s'", Config.PassiveAmount, licenseIdentifier)
                    ExecuteSql(query, function()
                        Debug("Added passive XP to player " .. player)
                    end)
                end
            end
        end
    end)
end

RegisterNetEvent('Domas_RPXP:RemovePlayerXP')
AddEventHandler('Domas_RPXP:RemovePlayerXP', function(playerId, xpToRemove)
    exports["Domas_RPXP"]:RemovePlayerXP(playerId, xpToRemove)
end)

RegisterNetEvent('Domas_RPXP:SetPlayerXP')
AddEventHandler('Domas_RPXP:SetPlayerXP', function(playerId, newXp)
    exports["Domas_RPXP"]:SetPlayerXP(playerId, newXp)
end)

RegisterNetEvent('Domas_RPXP:AddPlayerXP')
AddEventHandler('Domas_RPXP:AddPlayerXP', function(playerId, xpToAdd)
    exports["Domas_RPXP"]:AddPlayerXP(playerId, xpToAdd)
end)

--[[
    

$$$$$$$$\                                           $$\               
$$  _____|                                          $$ |              
$$ |      $$\   $$\  $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$\    $$$$$$$\ 
$$$$$\    \$$\ $$  |$$  __$$\ $$  __$$\ $$  __$$\ \_$$  _|  $$  _____|
$$  __|    \$$$$  / $$ /  $$ |$$ /  $$ |$$ |  \__|  $$ |    \$$$$$$\  
$$ |       $$  $$<  $$ |  $$ |$$ |  $$ |$$ |        $$ |$$\  \____$$\ 
$$$$$$$$\ $$  /\$$\ $$$$$$$  |\$$$$$$  |$$ |        \$$$$  |$$$$$$$  |
\________|\__/  \__|$$  ____/  \______/ \__|         \____/ \_______/ 
                    $$ |                                              
                    $$ |                                              
                    \__|                                              
                                                                   
--]]

-- Server Side:
-- Usage to add: exports["Domas_RPXP"]:AddPlayerXP(playerId, xpToAdd)
-- Usage to remove: exports["Domas_RPXP"]:RemovePlayerXP(playerId, xpToRemove)
-- Usage to set: exports["Domas_RPXP"]:SetPlayerXP(playerId, newXp)
-- Usage to get: exports["Domas_RPXP"]:GetPlayerXP(player)

-- Client side:
-- exports["Domas_RPXP"]:GetPlayerXPClient(player)


-- Export function to get player's XP
exports("GetPlayerXP", function(source)
    local player = tonumber(source)
    local licenseIdentifier = GetPlayerIdentifierByType(player, 'license')

    if not licenseIdentifier then
        Debug("Failed to get license identifier for player.")
        return 0
    end

    local query = string.format("SELECT xp FROM Domas_RPXP WHERE identifier = '%s'", licenseIdentifier)

    local xp = nil
    ExecuteSql(query, function(result)
        if result and #result > 0 then
            xp = result[1].xp
            TriggerClientEvent('Domas_RPXP:SetPlayerXP', source, xp)
        end
    end)

    while xp == nil do
        Citizen.Wait(0)
    end

    return xp or 0
end)

-- Export function to add XP for a player by ID
exports("AddPlayerXP", function(playerId, xpToAdd)
    local player = tonumber(playerId)

    local licenseIdentifier = GetPlayerIdentifierByType(player, 'license')

    if not licenseIdentifier then
        Debug("Failed to get license identifier for player.")
        return
    end

    local query = string.format("UPDATE Domas_RPXP SET xp = xp + %d WHERE identifier = '%s'", xpToAdd, licenseIdentifier)
    ExecuteSql(query, function()
        Debug("Added XP to player " .. player)
    end)
    exports["Domas_RPXP"]:GetPlayerXP(player)
end)

-- Export function to remove XP from a player by ID
exports("RemovePlayerXP", function(playerId, xpToRemove)
    local player = tonumber(playerId)

    local licenseIdentifier = GetPlayerIdentifierByType(player, 'license')

    if not licenseIdentifier then
        Debug("Failed to get license identifier for player.")
        return
    end

    local query = string.format("UPDATE Domas_RPXP SET xp = GREATEST(0, xp - %d) WHERE identifier = '%s'", xpToRemove, licenseIdentifier)
    ExecuteSql(query, function()
        Debug("Removed XP from player " .. player)
    end)
    exports["Domas_RPXP"]:GetPlayerXP(player)
end)

-- Export function to set XP for a player by ID
exports("SetPlayerXP", function(playerId, newXp)
    local player = tonumber(playerId)

    local licenseIdentifier = GetPlayerIdentifierByType(player, 'license')

    if not licenseIdentifier then
        Debug("Failed to get license identifier for player.")
        return
    end

    local query = string.format("UPDATE Domas_RPXP SET xp = %d WHERE identifier = '%s'", newXp, licenseIdentifier)
    ExecuteSql(query, function()
        Debug("Set XP for player " .. player)
    end)
    exports["Domas_RPXP"]:GetPlayerXP(player)
end)

--[[


  /$$$$$$                                                                  /$$          
 /$$__  $$                                                                | $$          
| $$  \__/  /$$$$$$  /$$$$$$/$$$$  /$$$$$$/$$$$   /$$$$$$  /$$$$$$$   /$$$$$$$  /$$$$$$$
| $$       /$$__  $$| $$_  $$_  $$| $$_  $$_  $$ |____  $$| $$__  $$ /$$__  $$ /$$_____/
| $$      | $$  \ $$| $$ \ $$ \ $$| $$ \ $$ \ $$  /$$$$$$$| $$  \ $$| $$  | $$|  $$$$$$ 
| $$    $$| $$  | $$| $$ | $$ | $$| $$ | $$ | $$ /$$__  $$| $$  | $$| $$  | $$ \____  $$
|  $$$$$$/|  $$$$$$/| $$ | $$ | $$| $$ | $$ | $$|  $$$$$$$| $$  | $$|  $$$$$$$ /$$$$$$$/
 \______/  \______/ |__/ |__/ |__/|__/ |__/ |__/ \_______/|__/  |__/ \_______/|_______/ 
                                                                                        
                                                                                        
                                                                                        
--]]

if Config.UseXPCheckCommand then
-- Register a command to check player XP
    RegisterCommand(Config.CheckXPCommand, function(source, args, rawCommand)
        local player = tonumber(source)
        local playerXP = exports["Domas_RPXP"]:GetPlayerXP(player)
        Notify(string.format("Player XP: %d", playerXP), source)
    end, false)
end


--[[

Perms:

For all admins:
add_ace group.admin domas_setxp allow
add_ace group.admin domas_addxp allow
add_ace group.admin domas_removexp allow
add_ace group.admin domas_admincheck allow

For only one player:
add_principal identifier.license:ea1c7297d532a3abfe63492878a3871cbf82a47a group.admin

]]

RegisterCommand(Config.AddXpCommand, function(source, args, rawCommand)
    local player = tonumber(args[1])
    local xpToAdd = tonumber(args[2]) or 0

    if IsPlayerAceAllowed(source, "domas_addxp") then
        exports["Domas_RPXP"]:AddPlayerXP(player, xpToAdd)
        Notify(string.format("Added XP to player %s", player), source)
    else
        Notify("Insufficient permissions to use /addxp command.", source)
    end
end, false)

RegisterCommand(Config.RemoveXpCommand, function(source, args, rawCommand)
    local player = tonumber(args[1])
    local xpToRemove = tonumber(args[2]) or 0

    if IsPlayerAceAllowed(source, "domas_removexp") then 
        exports["Domas_RPXP"]:RemovePlayerXP(player, xpToRemove)
        Notify(string.format("Removed XP from player %s", player), source)
    else
        Notify("Insufficient permissions to use /removexp command.", source)
    end
end, false)

RegisterCommand(Config.SetXpCommand, function(source, args, rawCommand)
    local player = tonumber(args[1])
    local newXp = tonumber(args[2]) or 0

    if IsPlayerAceAllowed(source, "domas_setxp") then
        exports["Domas_RPXP"]:SetPlayerXP(player, newXp)
        Notify(string.format("Set XP for player %s", player), source)
    else
        Notify("Insufficient permissions to use /setxp command.", source)
    end
end, false)

if Config.AdminCanCheckOther then
    RegisterCommand(Config.AdminCheckCommand, function(source, args, rawCommand)
        local player = tonumber(args[1])

        if IsPlayerAceAllowed(source, "domas_admincheck") then
            local playerXP = exports["Domas_RPXP"]:GetPlayerXP(player)
            Notify(string.format("Player %s XP: %d", player, playerXP), source)
        else
            Notify("Insufficient permissions to use /checkxp command.", source)
        end
    end, false)
end
