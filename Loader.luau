local fovRadius = 500
local snapSpeed = 1
local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera

local sound = Instance.new("Sound", game:GetService("SoundService"))
sound.SoundId = "rbxassetid://9114221577"
sound.Volume = 1

player.CameraMode = Enum.CameraMode.Classic 
player.CameraMinZoomDistance = 5
player.CameraMaxZoomDistance = 20
player.CameraMaxZoomDistance = 10
task.wait(0.1)
player.CameraMinZoomDistance = 0.5

RunService.RenderStepped:Connect(function()
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local target = getClosestEnemy()
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end

    local unitRay = camera:ViewportPointToRay(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000)

    if raycastResult and raycastResult.Instance then
        local model = raycastResult.Instance:FindFirstAncestorOfClass("Model")
        local humanoid = model and model:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local targetPlayer = game:GetService("Players"):GetPlayerFromCharacter(model)
            if targetPlayer and targetPlayer.Team ~= player.Team then
                if not humanoid:FindFirstChild("KillSoundTagged") then
                    local tag = Instance.new("BoolValue", humanoid)
                    tag.Name = "KillSoundTagged"
                    humanoid.Died:Connect(function()
                        sound:Play()
                    end)
                end
                
                local oldCFrame = camera.CFrame
                mouse1press()
                task.wait()
                mouse1release()
                camera.CFrame = oldCFrame
            end
        end
    end
end)

