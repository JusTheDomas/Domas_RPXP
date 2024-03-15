local playerXP = 0

RegisterNetEvent("Domas_RPXP:Notify")
AddEventHandler("Domas_RPXP:Notify", function(text)
    exports['okokNotify']:Alert('XP System', text, 7000, 'info')
end)

RegisterNetEvent('Domas_RPXP:SetPlayerXP')
AddEventHandler('Domas_RPXP:SetPlayerXP', function(xp)
    playerXP = xp
end)


if Config.Debug then
    -- Location for the marker and blip
    local markerLocation = vector3(-14.08474, -176.7364, 67.46682)

    -- Create marker and blip
    Citizen.CreateThread(function()
        local marker = AddBlipForCoord(markerLocation.x, markerLocation.y, markerLocation.z)
        SetBlipSprite(marker, 1) -- Blip sprite (1 is a standard blip)
        SetBlipDisplay(marker, 4)
        SetBlipScale(marker, 1.0)
        SetBlipColour(marker, 3) -- Blip color (3 is yellow)
        SetBlipAsShortRange(marker, true)

        while true do
            Citizen.Wait(0)

            local playerPed = GetPlayerPed(-1)
            local playerCoords = GetEntityCoords(playerPed)

            -- Check if the player is near the marker
            if Vdist(playerCoords.x, playerCoords.y, playerCoords.z, markerLocation.x, markerLocation.y, markerLocation.z) <
                1.5 then
                -- Display help text to press 'E' to get the level
                DisplayHelpText("Press ~INPUT_CONTEXT~ to check xp.")

                -- Check for 'E' key press
                if IsControlJustReleased(0, 38) then -- 'E' key
                    local playerid = GetPlayerServerId(PlayerId())
                    print(playerid)
                    local xpp = exports["Domas_RPXP"]:GetPlayerXPClient(playerid)
                    print("Your XP is " .. xpp)
                    Wait(1000)
                    print('Removing 20x xp')
                    TriggerServerEvent('Domas_RPXP:RemovePlayerXP', playerid, 20)
                    Wait(1000)
                    local xpp = exports["Domas_RPXP"]:GetPlayerXPClient(playerid)
                    print("Your XP is " .. xpp)
                    print('Adding 20x xp')
                    TriggerServerEvent('Domas_RPXP:AddPlayerXP', playerid, 20)
                    Wait(1000)
                    local xpp = exports["Domas_RPXP"]:GetPlayerXPClient(playerid)
                    print("Your XP is " .. xpp)
                    print("Setting your xp to 500")
                    TriggerServerEvent('Domas_RPXP:SetPlayerXP', playerid, 500)
                    Wait(1000)
                    local xpp = exports["Domas_RPXP"]:GetPlayerXPClient(playerid)
                    print("Your XP is " .. xpp)
                end
            end
        end
    end)

    -- Function to display help text
    function DisplayHelpText(text)
        BeginTextCommandDisplayHelp("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayHelp(0, false, true, -1)
    end

end

exports("GetPlayerXPClient", function()
    return playerXP
end)