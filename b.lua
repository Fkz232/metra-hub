local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local settings = {
    enabled = false,
    teamCheck = true,
    visibilityCheck = true,
    targetPart = "Head",
    smoothness = 0.1,
    fov = 200,
    showFOV = true,
    prediction = false,
    predictionAmount = 0.13,
    lockTarget = false,
    prioritizeClosest = true,
    ignoreWalls = false,
    autoShoot = false,
    silentAim = false,
    triggerBot = false,
    targetStrafe = false,
    strafeSpeed = 5,
    snapOnTarget = false,
    headMultiplier = 2,
    bodyMultiplier = 1.5,
    targetLimbs = false,
    shakeFOV = false,
    rainbowFOV = false,
    targetNotify = true,
    healthCheck = true,
    minHealth = 1,
    maxDistance = 5000,
    aimKey = Enum.UserInputType.MouseButton2
}

local currentTarget = nil
local lockedTarget = nil
local fovCircle = nil
local targetConnection = nil
local shootConnection = nil
local strafeAngle = 0

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 500)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.Y - MainFrame.AbsolutePosition.Y <= 60 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Text = "AIMBOT HUB PRO"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.TextSize = 22
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -80)
ScrollFrame.Position = UDim2.new(0, 10, 0, 70)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2000)
ScrollFrame.Parent = MainFrame

local currentY = 5

local function createToggle(name, text, defaultValue, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Size = UDim2.new(1, -10, 0, 50)
    ToggleFrame.Position = UDim2.new(0, 5, 0, currentY)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ScrollFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 80, 0, 30)
    ToggleButton.Position = UDim2.new(1, -90, 0.5, -15)
    ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(60, 60, 75)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = defaultValue and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    ToggleButton.Parent = ToggleFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ToggleButton
    
    local isEnabled = defaultValue
    
    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        ToggleButton.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(60, 60, 75)
        ToggleButton.Text = isEnabled and "ON" or "OFF"
        callback(isEnabled)
    end)
    
    currentY = currentY + 60
    return ToggleFrame
end

local function createSlider(name, text, minValue, maxValue, defaultValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.Position = UDim2.new(0, 5, 0, currentY)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ScrollFrame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = text .. ": " .. defaultValue
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 8)
    SliderBar.Position = UDim2.new(0, 10, 0, 40)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -10, 0.5, -10)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = SliderButton
    
    local draggingSlider = false
    local currentValue = defaultValue
    
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        currentValue = minValue + (maxValue - minValue) * relativeX
        
        if maxValue <= 2 then
            currentValue = math.floor(currentValue * 100) / 100
        else
            currentValue = math.floor(currentValue)
        end
        
        SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        SliderButton.Position = UDim2.new(relativeX, -10, 0.5, -10)
        Label.Text = text .. ": " .. currentValue
        
        callback(currentValue)
    end
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateSlider(input)
        end
    end)
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    
    currentY = currentY + 80
    return SliderFrame
end

local function createDropdown(name, text, options, defaultValue, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name
    DropdownFrame.Size = UDim2.new(1, -10, 0, 50)
    DropdownFrame.Position = UDim2.new(0, 5, 0, currentY)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = ScrollFrame
    
    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 10)
    DropCorner.Parent = DropdownFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropdownFrame
    
    local DropButton = Instance.new("TextButton")
    DropButton.Size = UDim2.new(0.5, 0, 0, 30)
    DropButton.Position = UDim2.new(0.48, 0, 0.5, -15)
    DropButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    DropButton.BorderSizePixel = 0
    DropButton.Font = Enum.Font.Gotham
    DropButton.Text = defaultValue
    DropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropButton.TextSize = 12
    DropButton.Parent = DropdownFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = DropButton
    
    local DropList = Instance.new("Frame")
    DropList.Size = UDim2.new(0.5, 0, 0, #options * 35)
    DropList.Position = UDim2.new(0.48, 0, 1, 5)
    DropList.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
    DropList.BorderSizePixel = 0
    DropList.Visible = false
    DropList.ZIndex = 10
    DropList.Parent = DropdownFrame
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 8)
    ListCorner.Parent = DropList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = DropList
    
    for _, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, -4, 0, 33)
        OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        OptionButton.BorderSizePixel = 0
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 11
        OptionButton.Parent = DropList
        
        local OptCorner = Instance.new("UICorner")
        OptCorner.CornerRadius = UDim.new(0, 6)
        OptCorner.Parent = OptionButton
        
        OptionButton.MouseButton1Click:Connect(function()
            DropButton.Text = option
            DropList.Visible = false
            callback(option)
        end)
    end
    
    DropButton.MouseButton1Click:Connect(function()
        DropList.Visible = not DropList.Visible
    end)
    
    currentY = currentY + 60
    return DropdownFrame
end

local function createFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Transparency = 0.5
    fovCircle.Thickness = 2
    fovCircle.Color = Color3.fromRGB(0, 255, 170)
    fovCircle.NumSides = 64
    fovCircle.Radius = settings.fov
    fovCircle.Filled = false
    fovCircle.Visible = settings.showFOV
    
    RunService.RenderStepped:Connect(function()
        if fovCircle then
            fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            fovCircle.Radius = settings.fov
            fovCircle.Visible = settings.showFOV
            
            if settings.rainbowFOV then
                local hue = tick() % 5 / 5
                fovCircle.Color = Color3.fromHSV(hue, 1, 1)
            else
                fovCircle.Color = Color3.fromRGB(0, 255, 170)
            end
            
            if settings.shakeFOV then
                local shake = math.sin(tick() * 10) * 5
                fovCircle.Radius = settings.fov + shake
            end
        end
    end)
end

local function isVisible(target)
    if not settings.visibilityCheck then return true end
    
    local character = LocalPlayer.Character
    if not character then return false end
    
    local origin = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    if not origin then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    
    local direction = target.Position - origin.Position
    local result = workspace:Raycast(origin.Position, direction, raycastParams)
    
    if settings.ignoreWalls then return true end
    
    if result == nil then
        return true
    end
    
    return result.Instance == target or result.Instance:IsDescendantOf(target.Parent)
end

local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = settings.fov
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                if settings.teamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    if settings.healthCheck and humanoid.Health < settings.minHealth then
                        continue
                    end
                    
                    local targetPart = character:FindFirstChild(settings.targetPart)
                    if targetPart then
                        local distance = (targetPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        
                        if distance > settings.maxDistance then
                            continue
                        end
                        
                        if isVisible(targetPart) then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                            
                            if onScreen then
                                local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                                
                                if distanceFromCenter < shortestDistance then
                                    shortestDistance = distanceFromCenter
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAt(target)
    if not target or not target.Character then return end
    
    local character = target.Character
    local targetPart = character:FindFirstChild(settings.targetPart)
    
    if not targetPart then return end
    
    local targetPos = targetPart.Position
    
    if settings.prediction then
        local velocity = targetPart.AssemblyLinearVelocity
        targetPos = targetPos + (velocity * settings.predictionAmount)
    end
    
    if settings.targetStrafe then
        strafeAngle = strafeAngle + settings.strafeSpeed
        local offset = Vector3.new(
            math.cos(math.rad(strafeAngle)) * 2,
            0,
            math.sin(math.rad(strafeAngle)) * 2
        )
        targetPos = targetPos + offset
    end
    
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
    
    if settings.snapOnTarget then
        Camera.CFrame = targetCFrame
    else
        Camera.CFrame = currentCFrame:Lerp(targetCFrame, settings.smoothness)
    end
end

local function notifyTarget(playerName)
    if not settings.targetNotify then return end
    
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 200, 0, 40)
    notification.Position = UDim2.new(0.5, -100, 0.1, 0)
    notification.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    notification.BorderSizePixel = 0
    notification.Font = Enum.Font.GothamBold
    notification.Text = "TARGET: " .. playerName
    notification.TextColor3 = Color3.fromRGB(0, 0, 0)
    notification.TextSize = 16
    notification.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notification
    
    task.delay(2, function()
        notification:Destroy()
    end)
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == settings.aimKey then
        if settings.lockTarget and lockedTarget then
            currentTarget = lockedTarget
        else
            currentTarget = getClosestPlayerToCursor()
            
            if settings.lockTarget and currentTarget then
                lockedTarget = currentTarget
                if settings.targetNotify then
                    notifyTarget(currentTarget.Name)
                end
            end
        end
        
        if currentTarget and settings.enabled then
            if targetConnection then
                targetConnection:Disconnect()
            end
            
            targetConnection = RunService.RenderStepped:Connect(function()
                if settings.enabled and currentTarget and currentTarget.Character then
                    aimAt(currentTarget)
                    
                    if settings.autoShoot then
                        mouse1press()
                        task.wait()
                        mouse1release()
                    end
                else
                    if targetConnection then
                        targetConnection:Disconnect()
                        targetConnection = nil
                    end
                end
            end)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == settings.aimKey then
        if not settings.lockTarget then
            currentTarget = nil
            lockedTarget = nil
        end
        
        if targetConnection then
            targetConnection:Disconnect()
            targetConnection = nil
        end
    end
end)

createToggle("EnableAimbot", "Ativar Aimbot", false, function(value)
    settings.enabled = value
end)

createToggle("TeamCheck", "Verificar Time", true, function(value)
    settings.teamCheck = value
end)

createToggle("VisibilityCheck", "Verificar Visibilidade", true, function(value)
    settings.visibilityCheck = value
end)

createToggle("ShowFOV", "Mostrar FOV Circle", true, function(value)
    settings.showFOV = value
end)

createSlider("FOVSize", "Tamanho FOV", 50, 500, 200, function(value)
    settings.fov = value
end)

createSlider("Smoothness", "Suavidade", 0.01, 1, 0.1, function(value)
    settings.smoothness = value
end)

createDropdown("TargetPart", "Parte do Alvo", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, "Head", function(value)
    settings.targetPart = value
end)

createToggle("Prediction", "Predicao de Movimento", false, function(value)
    settings.prediction = value
end)

createSlider("PredictionAmount", "Forca da Predicao", 0.05, 0.5, 0.13, function(value)
    settings.predictionAmount = value
end)

createToggle("LockTarget", "Travar no Alvo", false, function(value)
    settings.lockTarget = value
    if not value then
        lockedTarget = nil
    end
end)

createToggle("IgnoreWalls", "Ignorar Paredes", false, function(value)
    settings.ignoreWalls = value
end)

createToggle("AutoShoot", "Atirar Automatico", false, function(value)
    settings.autoShoot = value
end)

createToggle("SnapOnTarget", "Snap Instantaneo", false, function(value)
    settings.snapOnTarget = value
end)

createToggle("TargetStrafe", "Movimento Circular", false, function(value)
    settings.targetStrafe = value
end)

createSlider("StrafeSpeed", "Velocidade Circular", 1, 20, 5, function(value)
    settings.strafeSpeed = value
end)

createToggle("RainbowFOV", "FOV Arco-iris", false, function(value)
    settings.rainbowFOV = value
end)

createToggle("ShakeFOV", "FOV Tremendo", false, function(value)
    settings.shakeFOV = value
end)

createToggle("TargetNotify", "Notificar Alvo", true, function(value)
    settings.targetNotify = value
end)

createToggle("HealthCheck", "Verificar Vida", true, function(value)
    settings.healthCheck = value
end)

createSlider("MinHealth", "Vida Minima", 1, 100, 1, function(value)
    settings.minHealth = value
end)

createSlider("MaxDistance", "Distancia Maxima", 100, 10000, 5000, function(value)
    settings.maxDistance = value
end)

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, currentY + 10)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if fovCircle then
        fovCircle:Remove()
    end
    if targetConnection then
        targetConnection:Disconnect()
    end
end)

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 40, 0, 40)
MinButton.Position = UDim2.new(1, -90, 0, 10)
MinButton.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
MinButton.BorderSizePixel = 0
MinButton.Font = Enum.Font.GothamBold
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(0, 0, 0)
MinButton.TextSize = 24
MinButton.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 10)
MinCorner.Parent = MinButton

local isMinimized = false
MinButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 340, 0, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        MinButton.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 340, 0, 500), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        MinButton.Text = "-"
    end
end)

createFOVCircle()
