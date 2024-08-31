Citizen.CreateThread(function()
    -- Reading configuration values from server.cfg
    local ddcz_camOffsetX = tonumber(GetConvar("profile_camOffsetX", "0.0"))
    local ddcz_camOffsetY = tonumber(GetConvar("profile_camOffsetY", "-0.5")) 
    local ddcz_camOffsetZ = tonumber(GetConvar("profile_camOffsetZ", "0.6"))
    local ddcz_initialFov = tonumber(GetConvar("profile_fpsFieldOfView", "70.0")) 

    
    local ddcz_camOffset = vector3(ddcz_camOffsetX, ddcz_camOffsetY, ddcz_camOffsetZ)

    
    local ddcz_INPUT_AIM = 0
    local ddcz_INPUT_RIGHT_MOUSE = 25 
    local ddcz_Person = false
    local ddcz_justpressed = 0
    local ddcz_disable = 0
    local ddcz_isFirstPerson = false 

    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)

            
            if IsControlPressed(0, ddcz_INPUT_AIM) then
                ddcz_justpressed = ddcz_justpressed + 1
            end

            if IsControlJustReleased(0, ddcz_INPUT_AIM) then
                if ddcz_justpressed < 15 then
                    ddcz_Person = true
                end
                ddcz_justpressed = 0
            end

            
            if GetFollowPedCamViewMode() == 1 or GetFollowVehicleCamViewMode() == 1 then
                Citizen.Wait(1)
                SetFollowPedCamViewMode(0)
                SetFollowVehicleCamViewMode(0)
            end

            
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

            
            local playerPed = PlayerPedId()
            local isInVehicle = IsPedInAnyVehicle(playerPed, false)
            local isInFirstPerson = (GetFollowPedCamViewMode() == 4) or (GetFollowVehicleCamViewMode() == 4)

            if not isInVehicle then
                
                if IsControlPressed(0, ddcz_INPUT_RIGHT_MOUSE) then
                    if not ddcz_isFirstPerson and not isInFirstPerson then
                        ddcz_isFirstPerson = true
                        SetFollowPedCamViewMode(4)
                        SetFollowVehicleCamViewMode(4)
                    end
                else
                    if ddcz_isFirstPerson then
                        ddcz_isFirstPerson = false
                        SetFollowPedCamViewMode(0)
                        SetFollowVehicleCamViewMode(0)
                    end
                end
            else
                
                if ddcz_isFirstPerson then
                    ddcz_isFirstPerson = false
                    SetFollowPedCamViewMode(0)
                    SetFollowVehicleCamViewMode(0)
                end
            end

            
            if IsPedArmed(playerPed, 1) or not IsPedArmed(playerPed, 7) then
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
