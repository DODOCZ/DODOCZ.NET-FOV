Citizen.CreateThread(function()
    -- Načtení konfiguračních hodnot z server.cfg
    local ddcz_camOffsetX = tonumber(GetConvar("profile_camOffsetX", "0.0"))
    local ddcz_camOffsetY = tonumber(GetConvar("profile_camOffsetY", "-0.5")) -- Nastavení Y offsetu
    local ddcz_camOffsetZ = tonumber(GetConvar("profile_camOffsetZ", "0.6"))
    local ddcz_initialFov = tonumber(GetConvar("profile_fpsFieldOfView", "70.0")) -- Nastavení FOV (zorného úhlu)

    -- Vytvoření vektoru s hodnotami offsetu kamery
    local ddcz_camOffset = vector3(ddcz_camOffsetX, ddcz_camOffsetY, ddcz_camOffsetZ)

    -- Proměnné pro ovládání pohledu
    local ddcz_INPUT_AIM = 0
    local ddcz_Person = false
    local ddcz_justpressed = 0
    local ddcz_disable = 0

    -- Hlavní vlákno pro ovládání kamery
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)

            -- Detekce stisknutí a uvolnění tlačítka pro zaměření (AIM)
            if IsControlPressed(0, ddcz_INPUT_AIM) then
                ddcz_justpressed = ddcz_justpressed + 1
            end

            if IsControlJustReleased(0, ddcz_INPUT_AIM) then
                if ddcz_justpressed < 15 then
                    ddcz_Person = true
                end
                ddcz_justpressed = 0
            end

            -- Přepnutí do pohledu z první osoby, pokud je aktuálně jiný režim
            if GetFollowPedCamViewMode() == 1 or GetFollowVehicleCamViewMode() == 1 then
                Citizen.Wait(1)
                SetFollowPedCamViewMode(0)
                SetFollowVehicleCamViewMode(0)
            end

            -- Aktivace/deaktivace pohledu z první osoby
            if ddcz_Person then
                if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
                    Citizen.Wait(1)
                    SetFollowPedCamViewMode(4)
                    SetFollowVehicleCamViewMode(4)
                else
                    Citizen.Wait(1)
                    SetFollowPedCamViewMode(0)
                    SetFollowVehicleCamViewMode(0)
                end
                ddcz_Person = false
            end

            -- Deaktivace ovládacích prvků, pokud je hráč vyzbrojen a stiskne určité klávesy
            local ddcz_ped = PlayerPedId()
            if IsPedArmed(ddcz_ped, 1) or not IsPedArmed(ddcz_ped, 7) then
                if IsControlJustPressed(0, 24) or IsControlJustPressed(0, 141) or IsControlJustPressed(0, 142) or IsControlJustPressed(0, 140) then
                    ddcz_disable = 50
                end
            end

            if ddcz_disable > 0 then
                ddcz_disable = ddcz_disable - 1
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 142, true)
            end
        end
    end)

    -- Deaktivace určitých ovládacích prvků, pokud je hráč vyzbrojen
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if IsPedArmed(PlayerPedId(), 6) then
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
            else
                Citizen.Wait(1500)
            end
        end
    end)
end)
