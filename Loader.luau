local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local FOVContainer = Drawing.new("Circle")
FOVContainer.Visible = true
FOVContainer.Thickness = 1
FOVContainer.Radius = 250
FOVContainer.Color = Color3.fromRGB(255, 255, 255)
FOVContainer.Filled = false
FOVContainer.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

RunService.RenderStepped:Connect(function()
    player.CameraMode = Enum.CameraMode.Classic
    player.CameraMaxZoomDistance = 20
    player.CameraMinZoomDistance = 5
    FOVContainer.Position = UserInputService:GetMouseLocation()
end)

local function getClosestEnemy()
    local closest, dist = nil, FOVContainer.Radius
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local magnitude = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if magnitude < dist then
                    closest = p.Character.HumanoidRootPart
                    dist = magnitude
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local target = getClosestEnemy()
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
    end
end)
