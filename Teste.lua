local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexosZeroHitbox"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local DragBorder = Instance.new("Frame")
DragBorder.Size = UDim2.new(1, 10, 1, 10)
DragBorder.Position = UDim2.new(0, -5, 0, -5)
DragBorder.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DragBorder.BackgroundTransparency = 0.5
DragBorder.ZIndex = 2
DragBorder.Parent = MainFrame

local InnerFrame = Instance.new("Frame")
InnerFrame.Size = UDim2.new(1, -10, 1, -10)
InnerFrame.Position = UDim2.new(0, 5, 0, 5)
InnerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
InnerFrame.BorderSizePixel = 0
InnerFrame.ZIndex = 3
InnerFrame.Parent = MainFrame

local Dragging = false
local DragStart = nil
local StartPos = nil

local function UpdateDrag(input)
    if Dragging then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + delta.Y
        )
    end
end

DragBorder.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end)

DragBorder.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        UpdateDrag(input)
    end
end)

local function AnimateRGBText(element)
    while element and element.Parent do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(255, 0, 0)
        }
        for i = 1, #colors - 1 do
            local tween = TweenService:Create(element, tweenInfo, {TextColor3 = colors[i + 1]})
            tween:Play()
            tween.Completed:Wait()
        end
        wait()
    end
end

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "NexosZero Hitbox"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = InnerFrame
coroutine.wrap(function() AnimateRGBText(TitleLabel) end)()

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = InnerFrame
coroutine.wrap(function() AnimateRGBText(CloseButton) end)()

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -60, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.Text = "Ativar Hitbox"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.Parent = InnerFrame
coroutine.wrap(function() AnimateRGBText(ToggleButton) end)()

local RGBButton = Instance.new("TextButton")
RGBButton.Size = UDim2.new(0, 120, 0, 40)
RGBButton.Position = UDim2.new(0.5, -60, 0, 85)
RGBButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RGBButton.Text = "RGB Hitbox"
RGBButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RGBButton.TextSize = 16
RGBButton.Font = Enum.Font.SourceSans
RGBButton.Parent = InnerFrame
coroutine.wrap(function() AnimateRGBText(RGBButton) end)()

local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(0, 100, 0, 20)
SizeLabel.Position = UDim2.new(0.5, -50, 0, 130)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Text = "Tamanho Hitbox: 1"
SizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeLabel.TextSize = 14
SizeLabel.Font = Enum.Font.SourceSans
SizeLabel.Parent = InnerFrame
coroutine.wrap(function() AnimateRGBText(SizeLabel) end)()

local SizeSlider = Instance.new("TextButton")
SizeSlider.Size = UDim2.new(0, 200, 0, 10)
SizeSlider.Position = UDim2.new(0.5, -100, 0, 155)
SizeSlider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
SizeSlider.Text = ""
SizeSlider.Parent = InnerFrame

local SliderKnob = Instance.new("Frame")
SliderKnob.Size = UDim2.new(0, 10, 0, 20)
SliderKnob.Position = UDim2.new(0, 0, -0.5, 0)
SliderKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
SliderKnob.Parent = SizeSlider

local ColorButton = Instance.new("TextButton")
ColorButton.Size = UDim2.new(0, 120, 0, 40)
ColorButton.Position = UDim2.new(0.5, -60, 0, 175)
ColorButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ColorButton.Text = "Escolher Cor"
ColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorButton.TextSize = 16
ColorButton.Font = Enum.Font.SourceSans
ColorButton.Parent = InnerFrame
coroutine.wrap(function() AnimateRGBText(ColorButton) end)()

local HitboxEnabled = false
local RGBHitboxEnabled = false
local CurrentHitboxSize = 1
local CurrentHitboxColor = Color3.fromRGB(255, 0, 0)
local OriginalSizes = {}

local function AnimateRGBHitbox()
    while RGBHitboxEnabled do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(255, 0, 0)
        }
        for i = 1, #colors - 1 do
            if not RGBHitboxEnabled then break end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = player.Character.HumanoidRootPart
                    if HitboxEnabled then
                        rootPart.BrickColor = BrickColor.new(colors[i + 1])
                    end
                end
            end
            local tween = TweenService:Create(Instance.new("Frame"), tweenInfo, {BackgroundColor3 = colors[i + 1]})
            tween:Play()
            tween.Completed:Wait()
        end
        wait()
    end
end

local function ApplyHitbox()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            if HitboxEnabled then
                if not OriginalSizes[player] then
                    OriginalSizes[player] = rootPart.Size
                end
                rootPart.Size = Vector3.new(CurrentHitboxSize, CurrentHitboxSize, CurrentHitboxSize)
                if not RGBHitboxEnabled then
                    rootPart.BrickColor = BrickColor.new(CurrentHitboxColor)
                end
                rootPart.Transparency = 0.5
            else
                if OriginalSizes[player] then
                    rootPart.Size = OriginalSizes[player]
                    rootPart.Transparency = 0
                end
            end
        end
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    HitboxEnabled = not HitboxEnabled
    ToggleButton.Text = HitboxEnabled and "Desativar Hitbox" or "Ativar Hitbox"
    ToggleButton.BackgroundColor3 = HitboxEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    ApplyHitbox()
end)

RGBButton.MouseButton1Click:Connect(function()
    RGBHitboxEnabled = not RGBHitboxEnabled
    RGBButton.Text = RGBHitboxEnabled and "Desativar RGB" or "RGB Hitbox"
    RGBButton.BackgroundColor3 = RGBHitboxEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    if RGBHitboxEnabled and HitboxEnabled then
        coroutine.wrap(AnimateRGBHitbox)()
    else
        ApplyHitbox()
    end
end)

local function UpdateSlider(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local relativeX = math.clamp((input.Position.X - SizeSlider.AbsolutePosition.X) / SizeSlider.AbsoluteSize.X, 0, 1)
        SliderKnob.Position = UDim2.new(relativeX, -5, -0.5, 0)
        CurrentHitboxSize = 1 + (relativeX * 9)
        SizeLabel.Text = string.format("Tamanho Hitbox: %.1f", CurrentHitboxSize)
        if HitboxEnabled then
            ApplyHitbox()
        end
    end
end

SizeSlider.InputBegan:Connect(UpdateSlider)
SizeSlider.InputChanged:Connect(UpdateSlider)

ColorButton.MouseButton1Click:Connect(function()
    local colorInput = Instance.new("TextBox")
    colorInput.Size = UDim2.new(0, 100, 0, 30)
    colorInput.Position = UDim2.new(0.5, -50, 0, 220)
    colorInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    colorInput.Text = tostring(CurrentHitboxColor)
    colorInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorInput.TextSize = 14
    colorInput.Parent = InnerFrame

    colorInput.FocusLost:Connect(function()
        local r, g, b = colorInput.Text:match("(%d+), (%d+), (%d+)")
        if r and g and b then
            CurrentHitboxColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
            if HitboxEnabled and not RGBHitboxEnabled then
                ApplyHitbox()
            end
        end
        colorInput:Destroy()
    end)
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if HitboxEnabled then
            ApplyHitbox()
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    OriginalSizes[player] = nil
end)
