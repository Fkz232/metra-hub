local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimbotSystem = {
    Active = false,
    LockedTarget = nil,
    Settings = {
        FOVRadius = 180,
        SmoothFactor = 0.15,
        PredictionStrength = 0.165,
        MaxLockDistance = 350,
        TargetPart = "Head",
        WallPenetration = false,
        TeamDetection = true,
        VisibilityRequired = true,
        AutoLockMode = false,
        StabilizationPower = 0.88,
        HeadshotBias = 1.2,
        MovementCompensation = true,
        ReactionDelay = 0.05,
        LockPersistence = 2.5
    },
    Performance = {
        UpdateRate = 60,
        LastUpdate = 0,
        OptimizationMode = true
    }
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotHubPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local function ProtectGui()
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    else
        ScreenGui.Parent = game.CoreGui
    end
end

ProtectGui()

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainHub"
MainFrame.Size = UDim2.new(0, 420, 0, 580)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 65)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 20)
TopFix.Position = UDim2.new(0, 0, 1, -20)
TopFix.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -120, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "AIMBOT HUB PRO"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 12, 0, 12)
StatusDot.Position = UDim2.new(1, -90, 0.5, -6)
StatusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = TopBar

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0, 60, 1, 0)
StatusText.Position = UDim2.new(1, -70, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "OFF"
StatusText.Font = Enum.Font.GothamBold
StatusText.TextSize = 14
StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusText.TextXAlignment = Enum.TextXAlignment.Right
StatusText.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 45, 0, 45)
CloseButton.Position = UDim2.new(1, -55, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 70)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -30, 1, -85)
ScrollFrame.Position = UDim2.new(0, 15, 0, 75)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1200)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

local RainbowActive = false
local RainbowHue = 0

local function CreateSection(name, order)
    local Section = Instance.new("Frame")
    Section.Name = name
    Section.Size = UDim2.new(1, 0, 0, 60)
    Section.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Section.BorderSizePixel = 0
    Section.LayoutOrder = order
    Section.Parent = ScrollFrame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 12)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -20, 0, 30)
    SectionTitle.Position = UDim2.new(0, 15, 0, 5)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = name
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextSize = 16
    SectionTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    return Section
end

local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -30, 0, 50)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -80, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextSize = 15
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 55, 0, 30)
    ToggleButton.Position = UDim2.new(1, -65, 0.5, -15)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    ToggleButton.Text = ""
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = ToggleButton
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0, 24, 0, 24)
    ToggleIndicator.Position = UDim2.new(0, 3, 0.5, -12)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleButton
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = ToggleIndicator
    
    local toggled = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        local targetPos = toggled and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
        local targetColor = toggled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(180, 180, 180)
        local buttonColor = toggled and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(50, 50, 65)
        
        TweenService:Create(ToggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = buttonColor}):Play()
        
        if callback then callback(toggled) end
    end)
    
    parent.Size = UDim2.new(1, 0, 0, parent.Size.Y.Offset + 60)
    return ToggleFrame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -30, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -30, 0, 25)
    SliderLabel.Position = UDim2.new(0, 15, 0, 8)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextSize = 14
    SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60, 0, 25)
    ValueLabel.Position = UDim2.new(1, -75, 0, 8)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 14
    ValueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -30, 0, 8)
    SliderBack.Position = UDim2.new(0, 15, 1, -20)
    SliderBack.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = SliderFrame
    
    local SliderBackCorner = Instance.new("UICorner")
    SliderBackCorner.CornerRadius = UDim.new(1, 0)
    SliderBackCorner.Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBack
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderBack
    
    local dragging = false
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    SliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local position = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * position)
            
            SliderFill.Size = UDim2.new(position, 0, 1, 0)
            ValueLabel.Text = tostring(value)
            
            if callback then callback(value) end
        end
    end)
    
    parent.Size = UDim2.new(1, 0, 0, parent.Size.Y.Offset + 80)
    return SliderFrame
end

local function CreateDropdown(parent, text, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, -30, 0, 50)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = parent
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 10)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(1, -140, 1, 0)
    DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = text
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.TextSize = 15
    DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0, 120, 0, 35)
    DropdownButton.Position = UDim2.new(1, -130, 0.5, -17.5)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    DropdownButton.Text = options[1]
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.TextSize = 13
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Parent = DropdownFrame
    
    local DropdownButtonCorner = Instance.new("UICorner")
    DropdownButtonCorner.CornerRadius = UDim.new(0, 8)
    DropdownButtonCorner.Parent = DropdownButton
    
    local optionIndex = 1
    
    DropdownButton.MouseButton1Click:Connect(function()
        optionIndex = optionIndex % #options + 1
        DropdownButton.Text = options[optionIndex]
        if callback then callback(options[optionIndex]) end
    end)
    
    parent.Size = UDim2.new(1, 0, 0, parent.Size.Y.Offset + 60)
    return DropdownFrame
end

local Section1 = CreateSection("CONTROLE PRINCIPAL", 1)
CreateToggle(Section1, "Ativar Sistema", function(value)
    AimbotSystem.Active = value
    StatusDot.BackgroundColor3 = value and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50)
    StatusText.Text = value and "ON" or "OFF"
end)

local Section2 = CreateSection("MIRA AVANÇADA", 2)
CreateSlider(Section2, "Raio FOV", 50, 400, 180, function(value)
    AimbotSystem.Settings.FOVRadius = value
end)
CreateSlider(Section2, "Suavização", 1, 100, 15, function(value)
    AimbotSystem.Settings.SmoothFactor = value / 100
end)
CreateSlider(Section2, "Predição", 0, 50, 16, function(value)
    AimbotSystem.Settings.PredictionStrength = value / 100
end)

local Section3 = CreateSection("SELEÇÃO DE ALVO", 3)
CreateDropdown(Section3, "Parte do Corpo", {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"}, function(value)
    AimbotSystem.Settings.TargetPart = value
end)
CreateToggle(Section3, "Ignorar Equipe", function(value)
    AimbotSystem.Settings.TeamDetection = value
end)
CreateToggle(Section3, "Verificar Paredes", function(value)
    AimbotSystem.Settings.WallPenetration = not value
end)

local Section4 = CreateSection("SISTEMA INTELIGENTE", 4)
CreateToggle(Section4, "Travamento Automático", function(value)
    AimbotSystem.Settings.AutoLockMode = value
end)
CreateToggle(Section4, "Compensação de Movimento", function(value)
    AimbotSystem.Settings.MovementCompensation = value
end)
CreateSlider(Section4, "Estabilização", 50, 100, 88, function(value)
    AimbotSystem.Settings.StabilizationPower = value / 100
end)

local Section5 = CreateSection("PERFORMANCE", 5)
CreateSlider(Section5, "Distância Máxima", 100, 500, 350, function(value)
    AimbotSystem.Settings.MaxLockDistance = value
end)
CreateSlider(Section5, "Taxa de Atualização", 30, 120, 60, function(value)
    AimbotSystem.Performance.UpdateRate = value
end)
CreateToggle(Section5, "Modo Otimizado", function(value)
    AimbotSystem.Performance.OptimizationMode = value
end)

local Section6 = CreateSection("VISUAL", 6)
CreateToggle(Section6, "Modo Rainbow", function(value)
    RainbowActive = value
end)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2.5
FOVCircle.NumSides = 80
FOVCircle.Radius = AimbotSystem.Settings.FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Transparency = 0.85
FOVCircle.Color = Color3.fromRGB(100, 150, 255)

CreateToggle(Section6, "Mostrar Círculo FOV", function(value)
    FOVCircle.Visible = value
end)

local dragging = false
local dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local function ValidateTarget(target)
    if not target or not target.Character then return false end
    
    local character = target.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local targetPart = character:FindFirstChild(AimbotSystem.Settings.TargetPart)
    
    if not humanoid or humanoid.Health <= 0 or not targetPart then return false end
    
    if AimbotSystem.Settings.TeamDetection and target.Team == LocalPlayer.Team then return false end
    
    local distance = (targetPart.Position - Camera.CFrame.Position).Magnitude
    if distance > AimbotSystem.Settings.MaxLockDistance then return false end
    
    if not AimbotSystem.Settings.WallPenetration then
        local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * distance)
        local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
        if hit and not hit:IsDescendantOf(character) then return false end
    end
    
    return true
end

local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = AimbotSystem.Settings.FOVRadius
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and ValidateTarget(player) then
            local character = player.Character
            local targetPart = character:FindFirstChild(AimbotSystem.Settings.TargetPart)
            
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen or not AimbotSystem.Settings.VisibilityRequired then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestTarget = player
                    end
                end
            end
        end
    end
    
    return closestTarget
end

local function CalculatePrediction(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return Vector3.new(0, 0, 0) end
    
    local rootPart = character.HumanoidRootPart
    local velocity = rootPart.AssemblyLinearVelocity
    
    if AimbotSystem.Settings.MovementCompensation then
        local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
        local timeToTarget = distance / 1000
        return velocity * timeToTarget * AimbotSystem.Settings.PredictionStrength * 10
    end
    
    return velocity * AimbotSystem.Settings.PredictionStrength
end

local function SmoothAimToTarget(targetPosition)
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
    
    local smoothedCFrame = currentCFrame:Lerp(targetCFrame, AimbotSystem.Settings.SmoothFactor * AimbotSystem.Settings.StabilizationPower)
    
    Camera.CFrame = smoothedCFrame
end

RunService.RenderStepped:Connect(function()
    local currentTime = tick()
    
    if AimbotSystem.Performance.OptimizationMode then
        local updateInterval = 1 / AimbotSystem.Performance.UpdateRate
        if currentTime - AimbotSystem.Performance.LastUpdate < updateInterval then
            return
        end
        AimbotSystem.Performance.LastUpdate = currentTime
    end
    
    if FOVCircle.Visible then
        local screenSize = Camera.ViewportSize
        FOVCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
        FOVCircle.Radius = AimbotSystem.Settings.FOVRadius
        
        if RainbowActive then
            RainbowHue = (RainbowHue + 0.005) % 1
            FOVCircle.Color = Color3.fromHSV(RainbowHue, 1, 1)
        end
    end
    
    if AimbotSystem.Active then
        if not AimbotSystem.LockedTarget or not ValidateTarget(AimbotSystem.LockedTarget) then
            AimbotSystem.LockedTarget = GetClosestTarget()
        end
        
        if AimbotSystem.LockedTarget and AimbotSystem.LockedTarget.Character then
            local targetPart = AimbotSystem.LockedTarget.Character:FindFirstChild(AimbotSystem.Settings.TargetPart)
            
            if targetPart then
                local prediction = CalculatePrediction(AimbotSystem.LockedTarget.Character)
                local aimPosition = targetPart.Position + prediction
                
                if AimbotSystem.Settings.TargetPart == "Head" then
                    aimPosition = aimPosition + Vector3.new(0, 0.2 * AimbotSystem.Settings.HeadshotBias, 0)
                end
                
                task.wait(AimbotSystem.Settings.ReactionDelay)
                SmoothAimToTarget(aimPosition)
            end
        end
    else
        AimbotSystem.LockedTarget = nil
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "AIMBOT HUB PRO";
    Text = "Sistema carregado com sucesso!";
    Duration = 4;
})
