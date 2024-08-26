Citizen.CreateThread(function()
    local ddcz_cam = nil
    local ddcz_rearCam = nil
    local ddcz_isCameraActive = false
    local ddcz_isRearCamActive = false
    local ddcz_UsePerson = false
    local ddcz_justpressed = 0
    local ddcz_disable = 0
    local ddcz_INPUT_AIM = 0
    local ddcz_INPUT_REAR_VIEW = 26 -- Keyboard button C

    local camOffset = vector3(0.0, 0.1, 0.6) -- Setting the camera position
    local initialFov = 100.0 -- Initial FOV

    local function ddcz_clamp(value, min, max)
        return math.max(min, math.min(max, value))
    end

    local function ddcz_setupCamera()
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local maxRotationX = 30.0
        local minRotationX = -30.0
        local maxRotationZ = 90.0
        local minRotationZ = -80.0

        
        local currentRotX = 0.0
        local currentRotZ = 0.0

        
        ddcz_cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamFov(ddcz_cam, initialFov) -- Nastavení FOV
        SetCamNearClip(ddcz_cam, 0.09)
        RenderScriptCams(true, false, 0, true, true)

        Citizen.CreateThread(function()
            while ddcz_isCameraActive do
                Citizen.Wait(0)
                local ped = PlayerPedId()
                local isInVehicle = IsPedInAnyVehicle(ped, false)
                local isFirstPerson = (GetFollowVehicleCamViewMode() == 4)

                if isInVehicle and isFirstPerson then
                    AttachCamToPedBone(ddcz_cam, ped, GetPedBoneIndex(ped, 12844), camOffset.x, camOffset.y, camOffset.z, true)

                    local x = GetDisabledControlNormal(0, 1) -- X-axis mouse
                    local y = GetDisabledControlNormal(0, 2) -- Y-axis mouse

                    
                    currentRotX = ddcz_clamp(currentRotX - y * 5.0, minRotationX, maxRotationX)
                    currentRotZ = ddcz_clamp(currentRotZ - x * 5.0, minRotationZ, maxRotationZ)

                    local vehicle = GetVehiclePedIsIn(ped, false)
                    local vehicleHeading = GetEntityHeading(vehicle)
                    local adjustedRotZ = (currentRotZ + vehicleHeading) % 360
                    SetCamRot(ddcz_cam, vector3(currentRotX, 0.0, adjustedRotZ), 2)
                else
                    ddcz_isCameraActive = false
                    RenderScriptCams(false, false, 0, true, true)
                    DestroyCam(ddcz_cam, false)
                end
            end
        end)
    end

    local function ddcz_toggleRearCamera()
        if ddcz_isRearCamActive then
            ddcz_isRearCamActive = false
            RenderScriptCams(false, false, 0, true, true)
            DestroyCam(ddcz_rearCam, false)
            
            SetFollowVehicleCamViewMode(4)
        else
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            local rearCamOffset = vector3(0.0, -0.3, 0.6) -- Nastavení pozice kamery za vozidlem
            local initialFov = 100.0

            
            SetFollowVehicleCamViewMode(0)

            ddcz_rearCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamFov(ddcz_rearCam, initialFov)
            SetCamNearClip(ddcz_rearCam, 0.09)
            RenderScriptCams(true, false, 0, true, true)

            Citizen.CreateThread(function()
                while ddcz_isRearCamActive do
                    Citizen.Wait(0)
                    local ped = PlayerPedId()
                    local isInVehicle = IsPedInAnyVehicle(ped, false)
                    local isThirdPerson = (GetFollowVehicleCamViewMode() ~= 4)

                    if isInVehicle and isThirdPerson then
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        local vehiclePos = GetEntityCoords(vehicle)
                        local vehicleHeading = GetEntityHeading(vehicle)

                        local offset = GetOffsetFromEntityInWorldCoords(vehicle, rearCamOffset.x, rearCamOffset.y, rearCamOffset.z)
                        SetCamCoord(ddcz_rearCam, offset.x, offset.y, offset.z)

                        local adjustedRotZ = (vehicleHeading + 180.0) % 360
                        SetCamRot(ddcz_rearCam, 0.0, 0.0, adjustedRotZ, 2)
                    else
                        ddcz_isRearCamActive = false
                        RenderScriptCams(false, false, 0, true, true)
                        DestroyCam(ddcz_rearCam, false)
                        -- Návrat do první osoby
                        SetFollowVehicleCamViewMode(4)
                    end
                end
            end)
            ddcz_isRearCamActive = true
        end
    end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            local ped = PlayerPedId()
            local isInVehicle = IsPedInAnyVehicle(ped, false)
            local isFirstPerson = (GetFollowVehicleCamViewMode() == 4)
            local vehicle = GetVehiclePedIsIn(ped, false)

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

            if ddcz_isRearCamActive then
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

            
            if IsControlPressed(0, ddcz_INPUT_REAR_VIEW) and isInVehicle then
                if not ddcz_isRearCamActive then
                    ddcz_toggleRearCamera()
                end
            elseif not IsControlPressed(0, ddcz_INPUT_REAR_VIEW) and ddcz_isRearCamActive then
                ddcz_toggleRearCamera()
                
                SetFollowVehicleCamViewMode(4)
            end

            
            if isInVehicle and isFirstPerson and not ddcz_isCameraActive then
                ddcz_isCameraActive = true
                ddcz_setupCamera()
            end
        end
    end)
end)
