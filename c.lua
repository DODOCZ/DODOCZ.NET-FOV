Citizen.CreateThread(function()
    local ddcz_cam = nil
    local ddcz_isCameraActive = false
    local ddcz_UsePerson = false 
    local ddcz_justpressed = 0
    local ddcz_disable = 0
    local ddcz_INPUT_AIM = 0 

    local vehicleCameraSettings = {
        [0] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Compacts
        [1] = {offset = vector3(0.0, 0.1, 0.7), fov = 95.0},  -- Sedans
        [2] = {offset = vector3(0.0, 0.1, 0.8), fov = 90.0},  -- SUVs
        [3] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Coupes
        [4] = {offset = vector3(0.0, 0.1, 0.6), fov = 105.0}, -- Muscle
        [5] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Sports Classics
        [6] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Sports
        [7] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Super
        [8] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Motorcycles
        [9] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Off-road
        [10] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Industrial
        [11] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Utility
        [12] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Vans
        [13] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Cycles
        [14] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Boats
        [15] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Helicopters
        [16] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Planes
        [17] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Service
        [18] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Emergency
        [19] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Military
        [20] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Commercial
        [21] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Trains
        [22] = {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}, -- Open Wheel
    }

    local function ddcz_clamp(value, min, max)
        return math.max(min, math.min(max, value))
    end

    local function ddcz_setupCamera()
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehicleClass = GetVehicleClass(vehicle)
        local camSettings = vehicleCameraSettings[vehicleClass] or {offset = vector3(0.0, 0.1, 0.6), fov = 100.0}
        local bone = GetPedBoneIndex(ped, 12844)
        local camOffset = camSettings.offset
        local initialFov = camSettings.fov
        local maxRotationX = 30.0
        local minRotationX = -30.0
        local maxRotationZ = 90.0
        local minRotationZ = -80.0
        local currentRotX = 0.0
        local currentRotZ = 0.0

        ddcz_cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamFov(ddcz_cam, initialFov)
        SetCamNearClip(ddcz_cam, 0.09)
        RenderScriptCams(true, false, 0, true, true) 

        Citizen.CreateThread(function()
            while ddcz_isCameraActive do
                Citizen.Wait(0)
                local ped = PlayerPedId()
                local isInVehicle = IsPedInAnyVehicle(ped, false)
                local isFirstPerson = (GetFollowVehicleCamViewMode() == 4)

                if isInVehicle and isFirstPerson then
                    AttachCamToPedBone(ddcz_cam, ped, bone, camOffset.x, camOffset.y, camOffset.z, true)

                    local x = GetDisabledControlNormal(0, 1) -- X-axis mouse
                    local y = GetDisabledControlNormal(0, 2) -- Y-axis mouse

                    -- Úprava rotace kamery podle vstupů
                    currentRotX = ddcz_clamp(currentRotX - y * 5.0, -30.0, 30.0)
                    currentRotZ = ddcz_clamp(currentRotZ - x * 5.0, -80.0, 90.0)

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

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            local ped = PlayerPedId()

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
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1500)
            if IsPedArmed(PlayerPedId(), 6) then
                if ddcz_isCameraActive then
                    DisableControlAction(1, 140, true)
                    DisableControlAction(1, 141, true)
                    DisableControlAction(1, 142, true)
                end
            end
        end
    end)

    while true do
        Citizen.Wait(100)

        local ped = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(ped, false)
        local isFirstPerson = (GetFollowVehicleCamViewMode() == 4)

        if isInVehicle and isFirstPerson and not ddcz_isCameraActive then
            ddcz_isCameraActive = true
            ddcz_setupCamera()
        elseif not isInVehicle and ddcz_isCameraActive then
            ddcz_isCameraActive = false
            RenderScriptCams(false, false, 0, true, true)
            DestroyCam(ddcz_cam, false)
        end
    end
end)
