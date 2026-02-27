local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local FOVContainer = Drawing.new("Circle")
FOVContainer.Visible = true
FOVContainer.Thickness = 1
FOVContainer.Radius = 250
FOVContainer.Color = Color3.fromRGB(255, 0, 0)
FOVContainer.Filled = false

local function getClosestEnemy()
    local closest, dist = nil, FOVContainer.Radius
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local magnitude = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if magnitude < dist then
                        closest = head
                        dist = magnitude
                    end
                end
            end
        end
    end
    return closest
end

local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    local target = getClosestEnemy()
    if t == mouse and target then
        if k == "Hit" then return target.CFrame end
        if k == "Target" then return target end
    end
    return oldIndex(t, k)
end)
setreadonly(mt, true)

task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("Head") then
                p.Character.Head.Size = Vector3.new(5, 5, 5)
                p.Character.Head.Transparency = 0.5
                p.Character.Head.CanCollide = false
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    player.CameraMode = Enum.CameraMode.Classic
    player.CameraMaxZoomDistance = 20
    player.CameraMinZoomDistance = 5
    
    FOVContainer.Position = UserInputService:GetMouseLocation()
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(100), 0)
    end
end)
