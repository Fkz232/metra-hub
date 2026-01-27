local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.9, 0, 0.85, 0)
mainFrame.Position = UDim2.new(0.05, 0, 0.075, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0.1, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MOBILE AIMBOT HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0.15, 0, 1, 0)
closeButton.Position = UDim2.new(0.85, 0, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 0.9, 0)
contentFrame.Position = UDim2.new(0, 0, 0.1, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.Name = "GridLayout"
gridLayout.CellSize = UDim2.new(0.45, 0, 0.18, 0)
gridLayout.CellPadding = UDim2.new(0.05, 0, 0.05, 0)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = contentFrame

local function createRainbowButton(name, text, func)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.Parent = contentFrame
    
    local rainbowEffect = Instance.new("UIStroke")
    rainbowEffect.Name = "RainbowStroke"
    rainbowEffect.Color = Color3.fromRGB(255, 0, 0)
    rainbowEffect.Thickness = 3
    rainbowEffect.Parent = button
    
    button.MouseButton1Click:Connect(func)
    
    coroutine.wrap(function()
        while button and button.Parent do
            for i = 0, 1, 0.01 do
                local hue = (tick() * 0.5 + i) % 1
                local color = Color3.fromHSV(hue, 1, 1)
                rainbowEffect.Color = color
                wait(0.01)
            end
        end
    end)()    
    return button
end

local aimbotEnabled = false
local silentAimEnabled = false
local aimAssistEnabled = false
local autoShootEnabled = false
local targetBone = "Head"
local aimSpeed = 0.1
local fovCircleEnabled = false
local predictionEnabled = false
local teamCheckEnabled = true
local smoothAimEnabled = false

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        print("Aimbot Activated")
    else
        print("Aimbot Deactivated")
    end
end

local function toggleSilentAim()
    silentAimEnabled = not silentAimEnabled
    if silentAimEnabled then
        print("Silent Aim Activated")
    else
        print("Silent Aim Deactivated")
    end
end

local function toggleAimAssist()
    aimAssistEnabled = not aimAssistEnabled
    if aimAssistEnabled then
        print("Aim Assist Activated")
    else
        print("Aim Assist Deactivated")
    end
end

local function toggleAutoShoot()
    autoShootEnabled = not autoShootEnabled
    if autoShootEnabled then
        print("Auto Shoot Activated")
    else
        print("Auto Shoot Deactivated")
    end
end
local function changeTargetBone()
    local bones = {"Head", "Torso", "HumanoidRootPart"}
    local currentIndex = table.find(bones, targetBone) or 1
    currentIndex = currentIndex % #bones + 1
    targetBone = bones[currentIndex]
    print("Target Bone: " .. targetBone)
end

local function adjustAimSpeed()
    aimSpeed = aimSpeed + 0.05
    if aimSpeed > 0.5 then
        aimSpeed = 0.05
    end
    print("Aim Speed: " .. string.format("%.2f", aimSpeed))
end

local function toggleFOVCircle()
    fovCircleEnabled = not fovCircleEnabled
    if fovCircleEnabled then
        print("FOV Circle Activated")
    else
        print("FOV Circle Deactivated")
    end
end

local function togglePrediction()
    predictionEnabled = not predictionEnabled
    if predictionEnabled then
        print("Prediction Activated")
    else
        print("Prediction Deactivated")
    end
end

local function toggleTeamCheck()
    teamCheckEnabled = not teamCheckEnabled
    if teamCheckEnabled then
        print("Team Check Activated")
    else
        print("Team Check Deactivated")
    end
end

local function toggleSmoothAim()
    smoothAimEnabled = not smoothAimEnabled
    if smoothAimEnabled then
        print("Smooth Aim Activated")
    else
        print("Smooth Aim Deactivated")    end
end

createRainbowButton("AimbotButton", "AIMBOT", toggleAimbot)
createRainbowButton("SilentAimButton", "SILENT AIM", toggleSilentAim)
createRainbowButton("AimAssistButton", "AIM ASSIST", toggleAimAssist)
createRainbowButton("AutoShootButton", "AUTO SHOOT", toggleAutoShoot)
createRainbowButton("TargetBoneButton", "TARGET BONE", changeTargetBone)
createRainbowButton("AimSpeedButton", "AIM SPEED", adjustAimSpeed)
createRainbowButton("FOVCircleButton", "FOV CIRCLE", toggleFOVCircle)
createRainbowButton("PredictionButton", "PREDICTION", togglePrediction)
createRainbowButton("TeamCheckButton", "TEAM CHECK", toggleTeamCheck)
createRainbowButton("SmoothAimButton", "SMOOTH AIM", toggleSmoothAim)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
        dragStart = UserInputService:GetPosition()
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input == dragInput then
        local delta = UserInputService:GetPosition() - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale + delta.X / workspace.CurrentCamera.ViewportSize.X,
            0,
            startPos.Y.Scale + delta.Y / workspace.CurrentCamera.ViewportSize.Y,
            0
        )
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input == dragInput then
        dragInput = nil
    end
end)
