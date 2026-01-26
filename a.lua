local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local antiFlingEnabled = false
local blackholeEnabled = false
local blackholePlayerEnabled = false
local targetPlayerName = ""
local blackholeRadius = 15
local connections = {}

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NaturalDisasterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
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
                if input.UserInputState == Enum.UserInputState.End then                    dragging = false
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
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Text = "Natural Disaster Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -70)
ScrollFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
ScrollFrame.Parent = MainFrame

local function createToggleButton(name, text, position, callback)    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, -10, 0, 55)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.GothamBold
    Button.Text = text .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 85, 85)
    Button.TextSize = 16
    Button.AutoButtonColor = true
    Button.Parent = ScrollFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button
    
    local ClickEffect = Instance.new("Frame")
    ClickEffect.Size = UDim2.new(1, 0, 1, 0)
    ClickEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClickEffect.BackgroundTransparency = 1
    ClickEffect.BorderSizePixel = 0
    ClickEffect.ZIndex = 2
    ClickEffect.Parent = Button
    
    local EffectCorner = Instance.new("UICorner")
    EffectCorner.CornerRadius = UDim.new(0, 10)
    EffectCorner.Parent = ClickEffect
    
    local isEnabled = false
    
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            ClickEffect.BackgroundTransparency = 0.8
        end
    end)
    
    Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            ClickEffect.BackgroundTransparency = 1
        end
    end)
    
    Button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        if isEnabled then
            Button.Text = " " .. text .. ": ON"
            Button.TextColor3 = Color3.fromRGB(85, 255, 85)
            Button.BackgroundColor3 = Color3.fromRGB(40, 70, 40)
        else            Button.Text = " " .. text .. ": OFF"
            Button.TextColor3 = Color3.fromRGB(255, 85, 85)
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        end
        callback(isEnabled)
    end)
    
    return Button
end

local playersListFrame = nil
local selectedPlayerButton = nil
local PlayersButtonText = "Players"

local PlayersButton = Instance.new("TextButton")
PlayersButton.Name = "PlayersButton"
PlayersButton.Size = UDim2.new(1, -10, 0, 55)
PlayersButton.Position = UDim2.new(0, 5, 0, 145)
PlayersButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
PlayersButton.BorderSizePixel = 0
PlayersButton.Font = Enum.Font.GothamBold
PlayersButton.Text = PlayersButtonText
PlayersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayersButton.TextSize = 16
PlayersButton.Parent = ScrollFrame

local PlayersButtonCorner = Instance.new("UICorner")
PlayersButtonCorner.CornerRadius = UDim.new(0, 10)
PlayersButtonCorner.Parent = PlayersButton

local function openPlayersList()
    if playersListFrame and playersListFrame.Parent then
        playersListFrame:Destroy()
    end

    playersListFrame = Instance.new("Frame")
    playersListFrame.Name = "PlayersList"
    playersListFrame.Size = UDim2.new(0, 280, 0, 300)
    playersListFrame.Position = UDim2.new(0.5, -140, 0.5, -150)
    playersListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    playersListFrame.BorderSizePixel = 0
    playersListFrame.Parent = ScreenGui

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = playersListFrame

    local listTitle = Instance.new("TextLabel")
    listTitle.Size = UDim2.new(1, 0, 0, 40)
    listTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)    listTitle.Text = "Select Player"
    listTitle.Font = Enum.Font.GothamBold
    listTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    listTitle.TextSize = 16
    listTitle.Parent = playersListFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = listTitle

    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Size = UDim2.new(1, -10, 1, -50)
    listScroll.Position = UDim2.new(0, 5, 0, 45)
    listScroll.BackgroundTransparency = 1
    listScroll.BorderSizePixel = 0
    listScroll.ScrollBarThickness = 4
    listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    listScroll.Parent = playersListFrame

    local function refreshPlayerList()
        for _, child in ipairs(listScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local y = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 40)
                btn.Position = UDim2.new(0, 5, 0, y)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                btn.Text = player.Name
                btn.Font = Enum.Font.GothamSemibold
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextSize = 14
                btn.Parent = listScroll

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btn

                btn.MouseButton1Click:Connect(function()
                    targetPlayerName = player.Name
                    PlayersButton.Text = "Selected: " .. targetPlayerName
                    if playersListFrame then
                        playersListFrame:Destroy()
                        playersListFrame = nil
                    end                end)

                y += 45
            end
        end
        listScroll.CanvasSize = UDim2.new(0, 0, 0, y)
    end

    refreshPlayerList()
    connections.playerListUpdate = RunService.Heartbeat:Connect(function()
        refreshPlayerList()
    end)

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Parent = playersListFrame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton

    closeButton.MouseButton1Click:Connect(function()
        if connections.playerListUpdate then
            connections.playerListUpdate:Disconnect()
            connections.playerListUpdate = nil
        end
        playersListFrame:Destroy()
        playersListFrame = nil
    end)
end

PlayersButton.MouseButton1Click:Connect(openPlayersList)

function setupAntiFling(enabled)
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
            
            local floatPart = Instance.new("Part")
            floatPart.Name = "FloatPart"
            floatPart.Size = Vector3.new(4, 0.2, 4)
            floatPart.Transparency = 1
            floatPart.Anchored = true
            floatPart.CanCollide = false
            floatPart.Parent = workspace
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            connections.antiFling = RunService.Heartbeat:Connect(function()
                if not antiFlingEnabled then return end
                
                local character = LocalPlayer.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                if hrp.AssemblyLinearVelocity.Magnitude > 100 then
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                end
                
                if hrp.AssemblyAngularVelocity.Magnitude > 10 then
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
                
                floatPart.Position = hrp.Position - Vector3.new(0, 3.3, 0)
                
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            
            connections.floatPart = floatPart
        end
        
        protectCharacter()
        LocalPlayer.CharacterAdded:Connect(function()
            if antiFlingEnabled then                wait(0.5)
                protectCharacter()
            end
        end)
    else
        if connections.antiFling then
            connections.antiFling:Disconnect()
            connections.antiFling = nil
        end
        
        if connections.floatPart then
            connections.floatPart:Destroy()
            connections.floatPart = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

function setupBlackhole(enabled)
    blackholeEnabled = enabled
    
    if enabled then
        connections.blackhole = RunService.Heartbeat:Connect(function()
            if not blackholeEnabled then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local playerPos = hrp.Position
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(character) and obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" and obj.Name ~= "FloatPart" then
                    if not obj.Anchored and obj.Parent and obj.Parent ~= workspace then                        local distance = (obj.Position - playerPos).Magnitude
                        
                        if distance < 150 then
                            local direction = (playerPos - obj.Position).Unit
                            local currentDistance = (obj.Position - playerPos).Magnitude
                            
                            if currentDistance > blackholeRadius then
                                obj.AssemblyLinearVelocity = direction * 200
                            else
                                local tangent = Vector3.new(-direction.Z, 0, direction.X).Unit
                                obj.AssemblyLinearVelocity = tangent * 80 + direction * 20
                            end
                        end
                    end
                end
            end
        end)
    else
        if connections.blackhole then
            connections.blackhole:Disconnect()
            connections.blackhole = nil
        end
    end
end

function setupBlackholePlayer(enabled)
    blackholePlayerEnabled = enabled
    
    if enabled then
        connections.blackholePlayer = RunService.Heartbeat:Connect(function()
            if not blackholePlayerEnabled or targetPlayerName == "" then return end
            
            local targetPlayer = Players:FindFirstChild(targetPlayerName)
            if not targetPlayer or not targetPlayer.Character then return end
            
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not targetHRP then return end
            
            local targetPos = targetHRP.Position
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(targetPlayer.Character) and not obj:IsDescendantOf(LocalPlayer.Character) and obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" and obj.Name ~= "FloatPart" then
                    if not obj.Anchored and obj.Parent and obj.Parent ~= workspace then
                        local distance = (obj.Position - targetPos).Magnitude
                        
                        if distance < 150 then
                            local direction = (targetPos - obj.Position).Unit
                            obj.AssemblyLinearVelocity = direction * 250
                        end
                    end                end
            end
        end)
    else
        if connections.blackholePlayer then
            connections.blackholePlayer:Disconnect()
            connections.blackholePlayer = nil
        end
    end
end

createToggleButton("AntiFling", "Anti-Fling", UDim2.new(0, 5, 0, 5), setupAntiFling)

local Spacer1 = Instance.new("Frame")
Spacer1.Size = UDim2.new(1, 0, 0, 10)
Spacer1.Position = UDim2.new(0, 0, 0, 65)
Spacer1.BackgroundTransparency = 1
Spacer1.Parent = ScrollFrame

createToggleButton("Blackhole", "Blackhole (Voce)", UDim2.new(0, 5, 0, 75), setupBlackhole)

local Spacer2 = Instance.new("Frame")
Spacer2.Size = UDim2.new(1, 0, 0, 10)
Spacer2.Position = UDim2.new(0, 0, 0, 135)
Spacer2.BackgroundTransparency = 1
Spacer2.Parent = ScrollFrame

local Spacer3 = Instance.new("Frame")
Spacer3.Size = UDim2.new(1, 0, 0, 10)
Spacer3.Position = UDim2.new(0, 0, 0, 205)
Spacer3.BackgroundTransparency = 1
Spacer3.Parent = ScrollFrame

createToggleButton("BlackholePlayer", "Blackhole Player", UDim2.new(0, 5, 0, 215), setupBlackholePlayer)

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 280)

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    for _, conn in pairs(connections) do
        if conn and typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        elseif conn and typeof(conn) == "Instance" then
            conn:Destroy()
        end
    end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -90, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 24
MinimizeButton.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 10)
MinCorner.Parent = MinimizeButton

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)        MinimizeButton.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 450), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        MinimizeButton.Text = "-"
    end
end)
