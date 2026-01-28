local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local antiFlingEnabled = false
local blackholeSelfEnabled = false
local blackholePlayerEnabled = false
local antiBlizzardEnabled = false
local targetPlayer = nil

local blackholeSelfForce = 500
local blackholeSelfOrbitSpeed = 200
local blackholeSelfDistance = 100
local blackholeSelfPullDistance = 1000

local blackholePlayerForce = 500
local blackholePlayerOrbitSpeed = 200
local blackholePlayerDistance = 100
local blackholePlayerPullDistance = 1000

local connections = {}
local originalCanCollide = {}
local blizzardParts = {}

local currentTheme = {
    primary = Color3.fromRGB(25, 25, 35),
    secondary = Color3.fromRGB(35, 35, 50),
    accent = Color3.fromRGB(100, 150, 255),
    button = Color3.fromRGB(45, 45, 60),
    buttonActive = Color3.fromRGB(40, 70, 40),
    text = Color3.fromRGB(255, 255, 255),
    textOff = Color3.fromRGB(255, 85, 85),
    textOn = Color3.fromRGB(85, 255, 85)
}

local themes = {
    dark = {
        primary = Color3.fromRGB(25, 25, 35),
        secondary = Color3.fromRGB(35, 35, 50),
        accent = Color3.fromRGB(100, 150, 255),
        button = Color3.fromRGB(45, 45, 60),
        buttonActive = Color3.fromRGB(40, 70, 40),
        text = Color3.fromRGB(255, 255, 255),
        textOff = Color3.fromRGB(255, 85, 85),
        textOn = Color3.fromRGB(85, 255, 85)
    },
    blue = {
        primary = Color3.fromRGB(15, 25, 45),
        secondary = Color3.fromRGB(25, 40, 65),
        accent = Color3.fromRGB(70, 130, 255),
        button = Color3.fromRGB(35, 50, 80),
        buttonActive = Color3.fromRGB(30, 60, 100),
        text = Color3.fromRGB(255, 255, 255),
        textOff = Color3.fromRGB(255, 100, 100),
        textOn = Color3.fromRGB(100, 200, 255)
    },
    purple = {
        primary = Color3.fromRGB(30, 20, 40),
        secondary = Color3.fromRGB(45, 30, 60),
        accent = Color3.fromRGB(150, 100, 255),
        button = Color3.fromRGB(55, 40, 75),
        buttonActive = Color3.fromRGB(70, 50, 100),
        text = Color3.fromRGB(255, 255, 255),
        textOff = Color3.fromRGB(255, 120, 150),
        textOn = Color3.fromRGB(200, 150, 255)
    },
    green = {
        primary = Color3.fromRGB(20, 35, 25),
        secondary = Color3.fromRGB(30, 50, 35),
        accent = Color3.fromRGB(100, 255, 150),
        button = Color3.fromRGB(40, 60, 45),
        buttonActive = Color3.fromRGB(50, 80, 60),
        text = Color3.fromRGB(255, 255, 255),
        textOff = Color3.fromRGB(255, 100, 100),
        textOn = Color3.fromRGB(100, 255, 150)
    }
}

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NaturalDisasterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local NotificationFrame = Instance.new("Frame")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Size = UDim2.new(0, 300, 0, 0)
NotificationFrame.Position = UDim2.new(1, -310, 0, 10)
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.Parent = ScreenGui

local NotificationList = Instance.new("UIListLayout")
NotificationList.SortOrder = Enum.SortOrder.LayoutOrder
NotificationList.Padding = UDim.new(0, 10)
NotificationList.Parent = NotificationFrame

local function showNotification(text, duration)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 60)
    Notification.BackgroundColor3 = currentTheme.secondary
    Notification.BorderSizePixel = 0
    Notification.Parent = NotificationFrame
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = Notification
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Font = Enum.Font.GothamSemibold
    NotifText.Text = text
    NotifText.TextColor3 = currentTheme.text
    NotifText.TextSize = 14
    NotifText.TextWrapped = true
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.Parent = Notification
    
    Notification.BackgroundTransparency = 1
    TweenService:Create(Notification, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    
    wait(duration or 3)
    
    local tween = TweenService:Create(Notification, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        Notification:Destroy()
    end)
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, isMobile and 340 or 320, 0, isMobile and 500 or 450)
MainFrame.Position = UDim2.new(0.5, isMobile and -170 or -160, 0.5, isMobile and -250 or -225)
MainFrame.BackgroundColor3 = currentTheme.primary
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

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
        if input.Position.Y - MainFrame.AbsolutePosition.Y <= 50 then
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

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = currentTheme.secondary
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Text = "Natural Disaster Hub"
Title.TextColor3 = currentTheme.text
Title.TextSize = isMobile and 16 or 18
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Size = UDim2.new(1, -10, 0, 45)
TabFrame.Position = UDim2.new(0, 5, 0, 55)
TabFrame.BackgroundColor3 = currentTheme.secondary
TabFrame.BorderSizePixel = 0
TabFrame.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
TabCorner.Parent = TabFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabFrame

local currentTab = "Protecao"

local function createTab(name, text, order)
    local Tab = Instance.new("TextButton")
    Tab.Name = name
    Tab.Size = UDim2.new(0, isMobile and 105 or 95, 1, -10)
    Tab.Position = UDim2.new(0, 5, 0, 5)
    Tab.BackgroundColor3 = name == currentTab and currentTheme.accent or currentTheme.button
    Tab.BorderSizePixel = 0
    Tab.Font = Enum.Font.GothamBold
    Tab.Text = text
    Tab.TextColor3 = currentTheme.text
    Tab.TextSize = isMobile and 13 or 14
    Tab.LayoutOrder = order
    Tab.Parent = TabFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = Tab
    
    return Tab
end

local ProtecaoTab = createTab("Protecao", "Protecao", 1)
local BlackholeTab = createTab("Blackhole", "Blackhole", 2)
local ExtrasTab = createTab("Extras", "Extras", 3)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -120)
ScrollFrame.Position = UDim2.new(0, 10, 0, 110)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = isMobile and 8 : 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
ScrollFrame.Parent = MainFrame

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Name = "PlayerListFrame"
PlayerListFrame.Size = UDim2.new(0, isMobile and 300 or 280, 0, isMobile and 350 or 300)
PlayerListFrame.Position = UDim2.new(0.5, isMobile and -150 or -140, 0.5, isMobile and -175 or -150)
PlayerListFrame.BackgroundColor3 = currentTheme.primary
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Visible = false
PlayerListFrame.ZIndex = 10
PlayerListFrame.Parent = ScreenGui

local PlayerListCorner = Instance.new("UICorner")
PlayerListCorner.CornerRadius = UDim.new(0, 12)
PlayerListCorner.Parent = PlayerListFrame

local PlayerListTitle = Instance.new("TextLabel")
PlayerListTitle.Size = UDim2.new(1, 0, 0, 40)
PlayerListTitle.BackgroundColor3 = currentTheme.secondary
PlayerListTitle.BorderSizePixel = 0
PlayerListTitle.Font = Enum.Font.GothamBold
PlayerListTitle.Text = "Selecione um Jogador"
PlayerListTitle.TextColor3 = currentTheme.text
PlayerListTitle.TextSize = isMobile and 15 or 16
PlayerListTitle.Parent = PlayerListFrame

local PlayerListTitleCorner = Instance.new("UICorner")
PlayerListTitleCorner.CornerRadius = UDim.new(0, 12)
PlayerListTitleCorner.Parent = PlayerListTitle

local PlayerScrollFrame = Instance.new("ScrollingFrame")
PlayerScrollFrame.Size = UDim2.new(1, -10, 1, -50)
PlayerScrollFrame.Position = UDim2.new(0, 5, 0, 45)
PlayerScrollFrame.BackgroundTransparency = 1
PlayerScrollFrame.BorderSizePixel = 0
PlayerScrollFrame.ScrollBarThickness = isMobile and 6 : 4
PlayerScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrollFrame.Parent = PlayerListFrame

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.Name
PlayerListLayout.Padding = UDim.new(0, 5)
PlayerListLayout.Parent = PlayerScrollFrame

local ThemeFrame = Instance.new("Frame")
ThemeFrame.Name = "ThemeFrame"
ThemeFrame.Size = UDim2.new(0, isMobile and 300 or 280, 0, isMobile and 250 or 220)
ThemeFrame.Position = UDim2.new(0.5, isMobile and -150 or -140, 0.5, isMobile and -125 or -110)
ThemeFrame.BackgroundColor3 = currentTheme.primary
ThemeFrame.BorderSizePixel = 0
ThemeFrame.Visible = false
ThemeFrame.ZIndex = 10
ThemeFrame.Parent = ScreenGui

local ThemeCorner = Instance.new("UICorner")
ThemeCorner.CornerRadius = UDim.new(0, 12)
ThemeCorner.Parent = ThemeFrame

local ThemeTitle = Instance.new("TextLabel")
ThemeTitle.Size = UDim2.new(1, 0, 0, 40)
ThemeTitle.BackgroundColor3 = currentTheme.secondary
ThemeTitle.BorderSizePixel = 0
ThemeTitle.Font = Enum.Font.GothamBold
ThemeTitle.Text = "Escolha um Tema"
ThemeTitle.TextColor3 = currentTheme.text
ThemeTitle.TextSize = isMobile and 15 or 16
ThemeTitle.Parent = ThemeFrame

local ThemeTitleCorner = Instance.new("UICorner")
ThemeTitleCorner.CornerRadius = UDim.new(0, 12)
ThemeTitleCorner.Parent = ThemeTitle

local currentYPosition = 5

local function createToggleButton(name, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, -10, 0, isMobile and 65 : 55)
    Button.Position = UDim2.new(0, 5, 0, currentYPosition)
    Button.BackgroundColor3 = currentTheme.button
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.GothamBold
    Button.Text = text .. ": OFF"
    Button.TextColor3 = currentTheme.textOff
    Button.TextSize = isMobile and 15 : 16
    Button.AutoButtonColor = false
    Button.Parent = ScrollFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button
    
    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Size = UDim2.new(0, 8, 0, 8)
    StatusIndicator.Position = UDim2.new(0, 10, 0.5, -4)
    StatusIndicator.BackgroundColor3 = currentTheme.textOff
    StatusIndicator.BorderSizePixel = 0
    StatusIndicator.Parent = Button
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = StatusIndicator
    
    local isEnabled = false
    
    Button.MouseEnter:Connect(function()
        if not isEnabled then
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(
                currentTheme.button.R * 255 + 10,
                currentTheme.button.G * 255 + 10,
                currentTheme.button.B * 255 + 10
            )}):Play()
        end
    end)
    
    Button.MouseLeave:Connect(function()
        if not isEnabled then
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.button}):Play()
        end
    end)
    
    Button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        if isEnabled then
            Button.Text = text .. ": ON"
            TweenService:Create(Button, TweenInfo.new(0.3), {
                TextColor3 = currentTheme.textOn,
                BackgroundColor3 = currentTheme.buttonActive
            }):Play()
            TweenService:Create(StatusIndicator, TweenInfo.new(0.3), {BackgroundColor3 = currentTheme.textOn}):Play()
            showNotification(text .. " ativado", 2)
        else
            Button.Text = text .. ": OFF"
            TweenService:Create(Button, TweenInfo.new(0.3), {
                TextColor3 = currentTheme.textOff,
                BackgroundColor3 = currentTheme.button
            }):Play()
            TweenService:Create(StatusIndicator, TweenInfo.new(0.3), {BackgroundColor3 = currentTheme.textOff}):Play()
            showNotification(text .. " desativado", 2)
        end
        callback(isEnabled)
    end)
    
    currentYPosition = currentYPosition + (isMobile and 75 or 65)
    return Button, StatusIndicator
end

local function createSlider(name, text, minValue, maxValue, defaultValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Size = UDim2.new(1, -10, 0, isMobile and 80 : 70)
    SliderFrame.Position = UDim2.new(0, 5, 0, currentYPosition)
    SliderFrame.BackgroundColor3 = currentTheme.secondary
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ScrollFrame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -20, 0, 25)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Font = Enum.Font.GothamSemibold
    SliderLabel.Text = text .. ": " .. defaultValue
    SliderLabel.TextColor3 = currentTheme.text
    SliderLabel.TextSize = isMobile and 13 : 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, isMobile and 10 : 8)
    SliderBar.Position = UDim2.new(0, 10, 0, isMobile and 40 : 35)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    SliderFill.BackgroundColor3 = currentTheme.accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, isMobile and 24 : 20, 0, isMobile and 24 : 20)
    SliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), isMobile and -12 : -10, 0.5, isMobile and -12 : -10)
    SliderButton.BackgroundColor3 = currentTheme.text
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = SliderButton
    
    local draggingSlider = false
    local currentValue = defaultValue
    
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(minValue + (maxValue - minValue) * relativeX)
        
        TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(relativeX, 0, 1, 0)}):Play()
        TweenService:Create(SliderButton, TweenInfo.new(0.1), {Position = UDim2.new(relativeX, isMobile and -12 : -10, 0.5, isMobile and -12 : -10)}):Play()
        SliderLabel.Text = text .. ": " .. currentValue
        
        callback(currentValue)
    end
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateSlider(input)
            TweenService:Create(SliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, isMobile and 28 : 24, 0, isMobile and 28 : 24)}):Play()
        end
    end)
    
    SliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
            TweenService:Create(SliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, isMobile and 24 : 20, 0, isMobile and 24 : 20)}):Play()
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
            TweenService:Create(SliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, isMobile and 24 : 20, 0, isMobile and 24 : 20)}):Play()
        end
    end)
    
    currentYPosition = currentYPosition + (isMobile and 90 : 80)
    return SliderFrame
end

local function createButton(name, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, -10, 0, isMobile and 65 : 55)
    Button.Position = UDim2.new(0, 5, 0, currentYPosition)
    Button.BackgroundColor3 = currentTheme.button
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.GothamBold
    Button.Text = text
    Button.TextColor3 = currentTheme.text
    Button.TextSize = isMobile and 15 : 16
    Button.AutoButtonColor = false
    Button.Parent = ScrollFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.accent}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.button}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, -15, 0, isMobile and 60 : 50)}):Play()
        wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, isMobile and 65 : 55)}):Play()
        callback()
    end)
    
    currentYPosition = currentYPosition + (isMobile and 75 : 65)
    return Button
end

local function createSpacer(height)
    local Spacer = Instance.new("Frame")
    Spacer.Size = UDim2.new(1, 0, 0, height)
    Spacer.Position = UDim2.new(0, 0, 0, currentYPosition)
    Spacer.BackgroundTransparency = 1
    Spacer.Parent = ScrollFrame
    
    currentYPosition = currentYPosition + height
    return Spacer
end

local function createLabel(text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, isMobile and 30 : 25)
    Label.Position = UDim2.new(0, 5, 0, currentYPosition)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.Text = text
    Label.TextColor3 = currentTheme.accent
    Label.TextSize = isMobile and 15 : 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ScrollFrame
    
    currentYPosition = currentYPosition + (isMobile and 35 : 30)
    return Label
end

local function createDivider()
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 2)
    Divider.Position = UDim2.new(0, 10, 0, currentYPosition)
    Divider.BackgroundColor3 = currentTheme.accent
    Divider.BorderSizePixel = 0
    Divider.Parent = ScrollFrame
    
    local DividerGradient = Instance.new("UIGradient")
    DividerGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    DividerGradient.Parent = Divider
    
    currentYPosition = currentYPosition + 12
    return Divider
end

local function setupAntiFling(enabled)
    antiFlingEnabled = enabled
    
    if enabled then
        local function protectCharacter()
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoidRootPart or not humanoid then return end
            
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    originalCanCollide[part] = part.CanCollide
                    part.CanCollide = false
                    if part:FindFirstChildOfClass("BodyVelocity") then
                        part:FindFirstChildOfClass("BodyVelocity"):Destroy()
                    end
                    if part:FindFirstChildOfClass("BodyGyro") then
                        part:FindFirstChildOfClass("BodyGyro"):Destroy()
                    end
                end
            end
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "AntiFlingVelocity"
            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = humanoidRootPart
            
            connections.antiFling = RunService.Heartbeat:Connect(function()
                if not antiFlingEnabled then return end
                
                local character = LocalPlayer.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local bv = hrp:FindFirstChild("AntiFlingVelocity")
                if bv then
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                
                if hrp.AssemblyLinearVelocity.Y > 50 or hrp.AssemblyLinearVelocity.Y < -50 then
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                end
                
                if hrp.AssemblyAngularVelocity.Magnitude > 20 then
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
                
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
        
        protectCharacter()
        
        if connections.characterAdded then
            connections.characterAdded:Disconnect()
        end
        
        connections.characterAdded = LocalPlayer.CharacterAdded:Connect(function()
            if antiFlingEnabled then
                wait(0.5)
                protectCharacter()
            end
        end)
    else
        if connections.antiFling then
            connections.antiFling:Disconnect()
            connections.antiFling = nil
        end
        
        if connections.characterAdded then
            connections.characterAdded:Disconnect()
            connections.characterAdded = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("AntiFlingVelocity")
                if bv then
                    bv:Destroy()
                end
            end
            
            for part, canCollide in pairs(originalCanCollide) do
                if part and part:IsDescendantOf(character) then
                    part.CanCollide = canCollide
                end
            end
            originalCanCollide = {}
        end
    end
end

local function setupAntiBlizzard(enabled)
    antiBlizzardEnabled = enabled
    
    if enabled then
        local function createShelter()
            local character = LocalPlayer.Character
            if not character then return end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            for _, part in pairs(blizzardParts) do
                if part then
                    part:Destroy()
                end
            end
            blizzardParts = {}
            
            local shelterSize = 15
            local wallThickness = 0.5
            
            local function createWall(name, size, position)
                local wall = Instance.new("Part")
                wall.Name = "BlizzardWall_" .. name
                wall.Size = size
                wall.Position = position
                wall.Anchored = true
                wall.CanCollide = true
                wall.Transparency = 1
                wall.Material = Enum.Material.ForceField
                wall.Parent = workspace
                table.insert(blizzardParts, wall)
                return wall
            end
            
            local floor = createWall("Floor", Vector3.new(shelterSize, wallThickness, shelterSize), hrp.Position - Vector3.new(0, 6, 0))
            local ceiling = createWall("Ceiling", Vector3.new(shelterSize, wallThickness, shelterSize), hrp.Position + Vector3.new(0, 12, 0))
            local north = createWall("North", Vector3.new(shelterSize, 18, wallThickness), hrp.Position + Vector3.new(0, 3, shelterSize/2))
            local south = createWall("South", Vector3.new(shelterSize, 18, wallThickness), hrp.Position - Vector3.new(0, -3, shelterSize/2))
            local east = createWall("East", Vector3.new(wallThickness, 18, shelterSize), hrp.Position + Vector3.new(shelterSize/2, 3, 0))
            local west = createWall("West", Vector3.new(wallThickness, 18, shelterSize), hrp.Position - Vector3.new(shelterSize/2, -3, 0))
            
            connections.antiBlizzard = RunService.Heartbeat:Connect(function()
                if not antiBlizzardEnabled then return end
                
                local character = LocalPlayer.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local centerPos = hrp.Position
                
                floor.Position = centerPos - Vector3.new(0, 6, 0)
                ceiling.Position = centerPos + Vector3.new(0, 12, 0)
                north.Position = centerPos + Vector3.new(0, 3, shelterSize/2)
                south.Position = centerPos - Vector3.new(0, -3, shelterSize/2)
                east.Position = centerPos + Vector3.new(shelterSize/2, 3, 0)
                west.Position = centerPos - Vector3.new(shelterSize/2, -3, 0)
            end)
        end
        
        createShelter()
        
        if connections.blizzardCharacterAdded then
            connections.blizzardCharacterAdded:Disconnect()
        end
        
        connections.blizzardCharacterAdded = LocalPlayer.CharacterAdded:Connect(function()
            if antiBlizzardEnabled then
                wait(0.5)
                createShelter()
            end
        end)
    else
        if connections.antiBlizzard then
            connections.antiBlizzard:Disconnect()
            connections.antiBlizzard = nil
        end
        
        if connections.blizzardCharacterAdded then
            connections.blizzardCharacterAdded:Disconnect()
            connections.blizzardCharacterAdded = nil
        end
        
        for _, part in pairs(blizzardParts) do
            if part then
                part:Destroy()
            end
        end
        blizzardParts = {}
    end
end

local function setupBlackholeSelf(enabled)
    blackholeSelfEnabled = enabled
    
    if enabled then
        connections.blackholeSelf = RunService.Heartbeat:Connect(function()
            if not blackholeSelfEnabled then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local playerPos = hrp.Position
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(character) and obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" and not obj.Name:match("BlizzardWall") then
                    if not obj.Anchored then
                        local distance = (obj.Position - playerPos).Magnitude
                        
                        if distance < blackholeSelfPullDistance then
                            local direction = (playerPos - obj.Position).Unit
                            local currentDistance = (obj.Position - playerPos).Magnitude
                            
                            if currentDistance > blackholeSelfDistance then
                                obj.AssemblyLinearVelocity = direction * blackholeSelfForce
                            else
                                local tangent = Vector3.new(-direction.Z, 0, direction.X).Unit
                                obj.AssemblyLinearVelocity = tangent * blackholeSelfOrbitSpeed + direction * (blackholeSelfForce * 0.1)
                            end
                        end
                    end
                end
            end
        end)
    else
        if connections.blackholeSelf then
            connections.blackholeSelf:Disconnect()
            connections.blackholeSelf = nil
        end
    end
end

local function setupBlackholePlayer(enabled)
    blackholePlayerEnabled = enabled
    
    if enabled then
        connections.blackholePlayer = RunService.Heartbeat:Connect(function()
            if not blackholePlayerEnabled or not targetPlayer then return end
            
            if not targetPlayer.Character then return end
            
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not targetHRP then return end
            
            local targetPos = targetHRP.Position
            
            local myCharacter = LocalPlayer.Character
            local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" and not obj.Name:match("BlizzardWall") then
                    if not obj.Anchored then
                        if not obj:IsDescendantOf(targetPlayer.Character) and not (myCharacter and obj:IsDescendantOf(myCharacter)) then
                            local distance = (obj.Position - targetPos).Magnitude
                            
                            if distance < blackholePlayerPullDistance then
                                local direction = (targetPos - obj.Position).Unit
                                local currentDistance = (obj.Position - targetPos).Magnitude
                                
                                if currentDistance > blackholePlayerDistance then
                                    obj.AssemblyLinearVelocity = direction * blackholePlayerForce
                                else
                                    local tangent = Vector3.new(-direction.Z, 0, direction.X).Unit
                                    obj.AssemblyLinearVelocity = tangent * blackholePlayerOrbitSpeed + direction * (blackholePlayerForce * 0.1)
                                end
                            end
                        end
                    end
                end
            end
            
            if myHRP and antiFlingEnabled then
                if myHRP.AssemblyLinearVelocity.Y > 50 or myHRP.AssemblyLinearVelocity.Y < -50 then
                    myHRP.AssemblyLinearVelocity = Vector3.new(myHRP.AssemblyLinearVelocity.X, 0, myHRP.AssemblyLinearVelocity.Z)
                end
                if myHRP.AssemblyAngularVelocity.Magnitude > 20 then
                    myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    else
        if connections.blackholePlayer then
            connections.blackholePlayer:Disconnect()
            connections.blackholePlayer = nil
        end
    end
end

local function updatePlayerList()
    for _, child in pairs(PlayerScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local yPos = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Size = UDim2.new(1, -5, 0, isMobile and 50 : 40)
            PlayerButton.Position = UDim2.new(0, 0, 0, yPos)
            PlayerButton.BackgroundColor3 = currentTheme.button
            PlayerButton.BorderSizePixel = 0
            PlayerButton.Font = Enum.Font.GothamSemibold
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = currentTheme.text
            PlayerButton.TextSize = isMobile and 15 : 14
            PlayerButton.AutoButtonColor = false
            PlayerButton.Parent = PlayerScrollFrame
            
            local PlayerButtonCorner = Instance.new("UICorner")
            PlayerButtonCorner.CornerRadius = UDim.new(0, 8)
            PlayerButtonCorner.Parent = PlayerButton
            
            PlayerButton.MouseEnter:Connect(function()
                TweenService:Create(PlayerButton, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.accent}):Play()
            end)
            
            PlayerButton.MouseLeave:Connect(function()
                TweenService:Create(PlayerButton, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.button}):Play()
            end)
            
            PlayerButton.MouseButton1Click:Connect(function()
                targetPlayer = player
                PlayerSelectButton.Text = player.Name
                TweenService:Create(PlayerListFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
                wait(0.3)
                PlayerListFrame.Visible = false
                PlayerListFrame.Size = UDim2.new(0, isMobile and 300 or 280, 0, isMobile and 350 or 300)
                PlayerListFrame.Position = UDim2.new(0.5, isMobile and -150 or -140, 0.5, isMobile and -175 or -150)
                showNotification("Jogador selecionado: " .. player.Name, 2)
                
                if blackholePlayerEnabled then
                    setupBlackholePlayer(false)
                    setupBlackholePlayer(true)
                end
            end)
            
            yPos = yPos + (isMobile and 55 : 45)
        end
    end
    
    PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

local contentFrames = {}

local function createTabContent(tabName)
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = tabName .. "Content"
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = tabName == currentTab
    ContentFrame.Parent = ScrollFrame
    
    contentFrames[tabName] = ContentFrame
    return ContentFrame
end

local function switchTab(tabName)
    currentTab = tabName
    
    for name, frame in pairs(contentFrames) do
        frame.Visible = name == tabName
    end
    
    for _, tab in pairs(TabFrame:GetChildren()) do
        if tab:IsA("TextButton") then
            if tab.Name == tabName then
                TweenService:Create(tab, TweenInfo.new(0.3), {BackgroundColor3 = currentTheme.accent}):Play()
            else
                TweenService:Create(tab, TweenInfo.new(0.3), {BackgroundColor3 = currentTheme.button}):Play()
            end
        end
    end
    
    currentYPosition = 5
    
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if not child:IsA("Frame") or not child.Name:match("Content") then
            child:Destroy()
        end
    end
    
    if tabName == "Protecao" then
        createLabel("Protecao")
        createDivider()
        createToggleButton("AntiFling", "Anti-Fling", setupAntiFling)
        createSpacer(5)
        createToggleButton("AntiBlizzard", "Anti-Nevasca", setupAntiBlizzard)
        createSpacer(10)
    elseif tabName == "Blackhole" then
        createLabel("Blackhole (Voce)")
        createDivider()
        createToggleButton("BlackholeSelf", "Blackhole (Voce)", setupBlackholeSelf)
        createSpacer(5)
        createSlider("BlackholeSelfForce", "Forca", 100, 1000, 500, function(value)
            blackholeSelfForce = value
        end)
        createSlider("BlackholeSelfOrbit", "Velocidade", 50, 500, 200, function(value)
            blackholeSelfOrbitSpeed = value
        end)
        createSlider("BlackholeSelfDistance", "Distancia", 20, 300, 100, function(value)
            blackholeSelfDistance = value
        end)
        createSlider("BlackholeSelfPullDistance", "Distancia Puxar", 100, 2000, 1000, function(value)
            blackholeSelfPullDistance = value
        end)
        createSpacer(10)
        createLabel("Blackhole Player")
        createDivider()
        
        PlayerSelectButton = Instance.new("TextButton")
        PlayerSelectButton.Name = "PlayerSelectButton"
        PlayerSelectButton.Size = UDim2.new(1, -10, 0, isMobile and 65 : 55)
        PlayerSelectButton.Position = UDim2.new(0, 5, 0, currentYPosition)
        PlayerSelectButton.BackgroundColor3 = currentTheme.secondary
        PlayerSelectButton.BorderSizePixel = 0
        PlayerSelectButton.Font = Enum.Font.GothamSemibold
        PlayerSelectButton.Text = "Selecionar Jogador"
        PlayerSelectButton.TextColor3 = currentTheme.text
        PlayerSelectButton.TextSize = isMobile and 15 : 15
        PlayerSelectButton.AutoButtonColor = false
        PlayerSelectButton.Parent = ScrollFrame
        
        local PlayerSelectCorner = Instance.new("UICorner")
        PlayerSelectCorner.CornerRadius = UDim.new(0, 10)
        PlayerSelectCorner.Parent = PlayerSelectButton
        
        PlayerSelectButton.MouseEnter:Connect(function()
            TweenService:Create(PlayerSelectButton, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.accent}):Play()
        end)
        
        PlayerSelectButton.MouseLeave:Connect(function()
            TweenService:Create(PlayerSelectButton, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.secondary}):Play()
        end)
        
        PlayerSelectButton.MouseButton1Click:Connect(function()
            PlayerListFrame.Visible = true
            PlayerListFrame.Size = UDim2.new(0, 0, 0, 0)
            PlayerListFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            TweenService:Create(PlayerListFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, isMobile and 300 or 280, 0, isMobile and 350 or 300),
                Position = UDim2.new(0.5, isMobile and -150 or -140, 0.5, isMobile and -175 or -150)
            }):Play()
            updatePlayerList()
        end)
        
        currentYPosition = currentYPosition + (isMobile and 75 : 65)
        createSpacer(5)
        createToggleButton("BlackholePlayer", "Blackhole Player", setupBlackholePlayer)
        createSpacer(5)
        createSlider("BlackholePlayerForce", "Forca", 100, 1000, 500, function(value)
            blackholePlayerForce = value
        end)
        createSlider("BlackholePlayerOrbit", "Velocidade", 50, 500, 200, function(value)
            blackholePlayerOrbitSpeed = value
        end)
        createSlider("BlackholePlayerDistance", "Distancia", 20, 300, 100, function(value)
            blackholePlayerDistance = value
        end)
        createSlider("BlackholePlayerPullDistance", "Distancia Puxar", 100, 2000, 1000, function(value)
            blackholePlayerPullDistance = value
        end)
        createSpacer(10)
    elseif tabName == "Extras" then
        createLabel("Utilidades")
        createDivider()
        createButton("Emotes", "Emotes", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
            showNotification("Emotes carregado", 2)
        end)
        createSpacer(5)
        createButton("ThemeButton", "Mudar Tema", function()
            ThemeFrame.Visible = true
            ThemeFrame.Size = UDim2.new(0, 0, 0, 0)
            ThemeFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            TweenService:Create(ThemeFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, isMobile and 300 or 280, 0, isMobile and 250 or 220),
                Position = UDim2.new(0.5, isMobile and -150 or -140, 0.5, isMobile and -125 or -110)
            }):Play()
        end)
        createSpacer(10)
    end
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, currentYPosition + 10)
end

ProtecaoTab.MouseButton1Click:Connect(function()
    switchTab("Protecao")
end)

BlackholeTab.MouseButton1Click:Connect(function()
    switchTab("Blackhole")
end)

ExtrasTab.MouseButton1Click:Connect(function()
    switchTab("Extras")
end)

local function createThemeButton(themeName, displayName, yPos)
    local ThemeButton = Instance.new("TextButton")
    ThemeButton.Size = UDim2.new(1, -20, 0, isMobile and 45 : 40)
    ThemeButton.Position = UDim2.new(0, 10, 0, yPos)
    ThemeButton.BackgroundColor3 = themes[themeName].accent
    ThemeButton.BorderSizePixel = 0
    ThemeButton.Font = Enum.Font.GothamBold
    ThemeButton.Text = displayName
    ThemeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ThemeButton.TextSize = isMobile and 15 : 14
    ThemeButton.AutoButtonColor = false
    ThemeButton.Parent = ThemeFrame
    
    local ThemeButtonCorner = Instance.new("UICorner")
    ThemeButtonCorner.CornerRadius = UDim.new(0, 8)
    ThemeButtonCorner.Parent = ThemeButton
    
    ThemeButton.MouseButton1Click:Connect(function()
        currentTheme = themes[themeName]
        
        MainFrame.BackgroundColor3 = currentTheme.primary
        Title.BackgroundColor3 = currentTheme.secondary
        TabFrame.BackgroundColor3 = currentTheme.secondary
        PlayerListFrame.BackgroundColor3 = currentTheme.primary
        PlayerListTitle.BackgroundColor3 = currentTheme.secondary
        ThemeFrame.BackgroundColor3 = currentTheme.primary
        ThemeTitle.BackgroundColor3 = currentTheme.secondary
        
        TweenService:Create(ThemeFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        wait(0.3)
        ThemeFrame.Visible = false
        ThemeFrame.Size = UDim2.new(0, isMobile and 300 or 280, 0, isMobile and 250 or 220)
        ThemeFrame.Position = UDim2.new(0.5, isMobile and -150 or -140, 0.5, isMobile and -125 or -110)
        
        showNotification("Tema alterado: " .. displayName, 2)
        
        switchTab(currentTab)
    end)
end

createThemeButton("dark", "Escuro", 50)
createThemeButton("blue", "Azul", isMobile and 105 : 100)
createThemeButton("purple", "Roxo", isMobile and 160 : 150)
createThemeButton("green", "Verde", isMobile and 215 : 200)

switchTab("Protecao")

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, isMobile and 45 : 40, 0, isMobile and 45 : 40)
CloseButton.Position = UDim2.new(1, isMobile and -50 : -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = isMobile and 22 : 20
CloseButton.AutoButtonColor = false
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    wait(0.3)
    ScreenGui:Destroy()
    for _, conn in pairs(connections) do
        if conn and typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif conn and typeof(conn) == "Instance" then
            conn:Destroy()
        end
    end
    
    for _, part in pairs(blizzardParts) do
        if part then
            part:Destroy()
        end
    end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChild("AntiFlingVelocity")
            if bv then
                bv:Destroy()
            end
        end
        
        for part, canCollide in pairs(originalCanCollide) do
            if part and part:IsDescendantOf(character) then
                part.CanCollide = canCollide
            end
        end
    end
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, isMobile and 45 : 40, 0, isMobile and 45 : 40)
MinimizeButton.Position = UDim2.new(1, isMobile and -100 : -90, 0, 5)
MinimizeButton.BackgroundColor3 = currentTheme.accent
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = currentTheme.text
MinimizeButton.TextSize = isMobile and 26 : 24
MinimizeButton.AutoButtonColor = false
MinimizeButton.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 10)
MinCorner.Parent = MinimizeButton

local isMinimized = false

MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(
            currentTheme.accent.R * 255 + 30,
            currentTheme.accent.G * 255 + 30,
            currentTheme.accent.B * 255 + 30
        )
    }):Play()
end)

MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.accent}):Play()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, isMobile and 340 or 320, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        MinimizeButton.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, isMobile and 340 or 320, 0, isMobile and 500 or 450), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        MinimizeButton.Text = "-"
    end
end)

showNotification("Natural Disaster Hub carregado!", 3)
