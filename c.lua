Citizen.CreateThread(function()
    local ddcz_cam = nil
    local ddcz_isCameraActive = false
    local ddcz_UsePerson = false -- Přejmenováno na UsePerson
    local ddcz_justpressed = 0
    local ddcz_disable = 0
    local ddcz_INPUT_AIM = 0 -- Můžeš změnit na příslušný kontrolní vstup (např. 24 pro aiming)

    -- Pomocná funkce pro omezení hodnoty
    local function ddcz_clamp(value, min, max)
        return math.max(min, math.min(max, value))
    end

    -- Funkce pro vytvoření a nastavení kamery
    local function ddcz_setupCamera()
        local ped = PlayerPedId()
        local bone = GetPedBoneIndex(ped, 12844)
        local camOffset = vector3(0.0, 0.1, 0.6)
        local initialFov = 100.0
        local maxRotationX = 30.0
        local minRotationX = -30.0
        local maxRotationZ = 90.0
        local minRotationZ = -80.0
        local currentRotX = 0.0
        local currentRotZ = 0.0

        -- Vytvoření kamery a okamžité nastavení FOV
        ddcz_cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamFov(ddcz_cam, initialFov)
        SetCamNearClip(ddcz_cam, 0.09)
        RenderScriptCams(true, false, 0, true, true) -- Okamžitá aktivace kamery

        -- Hlavní smyčka pro správu kamery
        Citizen.CreateThread(function()
            while ddcz_isCameraActive do
                Citizen.Wait(0)
                local ped = PlayerPedId()
                local isInVehicle = IsPedInAnyVehicle(ped, false)
                local isFirstPerson = (GetFollowVehicleCamViewMode() == 4)

                if isInVehicle and isFirstPerson then
                    AttachCamToPedBone(ddcz_cam, ped, bone, 0.0, 0.1, 0.6, true)

                    local x = GetDisabledControlNormal(0, 1) -- Osa X myši
                    local y = GetDisabledControlNormal(0, 2) -- Osa Y myši

                    -- Úprava rotace kamery podle vstupů
                    currentRotX = ddcz_clamp(currentRotX - y * 5.0, -30.0, 30.0)
                    currentRotZ = ddcz_clamp(currentRotZ - x * 5.0, -80.0, 90.0)

                    local vehicle = GetVehiclePedIsIn(ped, false)
                    local vehicleHeading = GetEntityHeading(vehicle)
                    local adjustedRotZ = (currentRotZ + vehicleHeading) % 360
                    SetCamRot(ddcz_cam, vector3(currentRotX, 0.0, adjustedRotZ), 2)
                else
                    -- Deaktivace kamery, pokud hráč vystoupí z vozidla nebo přepne kameru
                    ddcz_isCameraActive = false
                    RenderScriptCams(false, false, 0, true, true)
                    DestroyCam(ddcz_cam, false)
                end
            end
        end)
    end

    -- Smyčka pro ovládání přepínání FPS kamery
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            local ped = PlayerPedId()

            -- Ovládání přepínání FPS kamery
            if IsControlPressed(0, ddcz_INPUT_AIM) then
                ddcz_justpressed = ddcz_justpressed + 1
            end

            if IsControlJustReleased(0, ddcz_INPUT_AIM) then
                if ddcz_justpressed < 15 then
                    ddcz_UsePerson = true
                end
                ddcz_justpressed = 0
            end

            if ddcz_UsePerson then
                if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
                    Citizen.Wait(1)
                    SetFollowPedCamViewMode(4)
                    SetFollowVehicleCamViewMode(4)
                else
                    Citizen.Wait(1)
                    SetFollowPedCamViewMode(0)
                    SetFollowVehicleCamViewMode(0)
                end
                ddcz_UsePerson = false
            end

            -- Ovládání deaktivace vstupů pouze pokud je kamera aktivní
            if ddcz_isCameraActive then
                if IsPedArmed(ped, 1) or not IsPedArmed(ped, 7) then
                    if IsControlJustPressed(0, 24) or IsControlJustPressed(0, 141) or IsControlJustPressed(0, 142) or IsControlJustPressed(0, 140) then
                        ddcz_disable = 50
                    end
                end

                if ddcz_disable > 0 then
                    ddcz_disable = ddcz_disable - 1
                    DisableControlAction(0, 24)
                    DisableControlAction(0, 140)
                    DisableControlAction(0, 141)
                    DisableControlAction(0, 142)
                end
            end
        end
    end)

    -- Smyčka pro kontrolu zbraní
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1500)
            if IsPedArmed(PlayerPedId(), 6) then
                -- Zkontrolujeme pouze pokud je kamera aktivní
                if ddcz_isCameraActive then
                    DisableControlAction(1, 140, true)
                    DisableControlAction(1, 141, true)
                    DisableControlAction(1, 142, true)
                end
            end
        end
    end)

    -- Hlavní smyčka pro detekci stavu hráče a aktivaci/deaktivaci kamery
    while true do
        Citizen.Wait(100) -- Zkrácení času mezi kontrolami

        local ped = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(ped, false)
        local isFirstPerson = (GetFollowVehicleCamViewMode() == 4)

        if isInVehicle and isFirstPerson and not ddcz_isCameraActive then
            ddcz_isCameraActive = true
            ddcz_setupCamera()
        elseif not isInVehicle and ddcz_isCameraActive then
            -- Deaktivace kamery, pokud hráč vystoupí z vozidla
            ddcz_isCameraActive = false
            RenderScriptCams(false, false, 0, true, true)
            DestroyCam(ddcz_cam, false)
        end
    end
end)
