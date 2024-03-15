function ExecuteSql(query, callback)
    Debug("Executing SQL query: " .. query)

    if Config.Database == "oxmysql" then
        if exports.oxmysql then
            exports.oxmysql:execute(query, {}, callback)
        else
            Debug("oxmysql is not exported. Make sure you have it installed.")
        end
    elseif Config.Database == "mysql-async" then
        if MySQL.Async then
            MySQL.Async.execute(query, {}, callback)
        else
            Debug("mysql-async is not available. Make sure you have it installed.")
        end
    elseif Config.Database == "ghmattimysql" then
        if exports.ghmattimysql then
            exports.ghmattimysql:execute(query, {}, callback)
        else
            Debug("ghmattimysql is not exported. Make sure you have it installed.")
        end
    else
        Debug("Invalid database option in Config.Database")
    end
end


function Debug(text)
    if Config.Debug then
        print("[DEBUG] "..text)
    end
end

function Notify(text, who)
    if Config.CheckXPType == 'print' then
        print(text)
    elseif Config.CheckXPType == 'chat' then
        TriggerClientEvent("chatMessage", who, "Server", {255, 255, 255}, text)
    elseif Config.CheckXPType == 'notify' then
        TriggerClientEvent("Domas_RPXP:Notify", who, text)
    end
end

function UpdatePlayerXPPeriodically()
    -- Check if passive XP system is enabled
    if Config.AutoUpdate then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(Config.AutoUpdateWait)

                -- Get all online players
                local players = GetPlayers()

                for _, player in ipairs(players) do
                    -- Retrieve player's current XP
                    local xp = exports["Domas_RPXP"]:GetPlayerXP(player)

                    -- Add passive XP amount to player's XP
                    xp = xp + Config.PassiveAmount

                    -- Set player's new XP
                    exports["Domas_RPXP"]:SetPlayerXP(player, xp)
                end
            end
        end)
    end
end

if Config.VersionChecker then
    local currentVersion = "1.0"  -- Set your local version here
    local githubRawUrl = "https://raw.githubusercontent.com/JusTheDomas/Domas_RPXP/main/version"

    function checkVersion(localVersion)
        PerformHttpRequest(githubRawUrl, function(statusCode, data, headers)
            if statusCode == 200 then
                local latestVersion = data:match("%s*(.-)%s*$")  -- Trim whitespace
                if localVersion == latestVersion then
                    print("^5Your script is up to date.")
                else
                    print("^1There is a newer version available:", latestVersion)
                end
            else
                print("Error fetching version:", statusCode)
            end
        end, "GET", "", { ["Content-Type"] = "application/json" })
    end

    checkVersion(currentVersion)

end
