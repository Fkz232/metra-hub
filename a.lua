local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local antiFlingEnabled = false
local blackholeEnabled = false
local blackholePlayerEnabled = false
local targetPlayer = nil
local blackholeRadius = 15
local connections = {}
local originalCanCollide = {}

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

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Name = "PlayerListFrame"
PlayerListFrame.Size = UDim2.new(0, 280, 0, 300)
PlayerListFrame.Position = UDim2.new(0.5, -140, 0.5, -150)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Visible = false
PlayerListFrame.ZIndex = 10
PlayerListFrame.Parent = ScreenGui

local PlayerListCorner = Instance.new("UICorner")
PlayerListCorner.CornerRadius = UDim.new(0, 12)
PlayerListCorner.Parent = PlayerListFrame

local PlayerListTitle = Instance.new("TextLabel")
PlayerListTitle.Size = UDim2.new(1, 0, 0, 40)
PlayerListTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
PlayerListTitle.BorderSizePixel = 0
PlayerListTitle.Font = Enum.Font.GothamBold
PlayerListTitle.Text = "Selecione um Jogador"
PlayerListTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerListTitle.TextSize = 16
PlayerListTitle.Parent = PlayerListFrame

local PlayerListTitleCorner = Instance.new("UICorner")
PlayerListTitleCorner.CornerRadius = UDim.new(0, 12)
PlayerListTitleCorner.Parent = PlayerListTitle

local PlayerScrollFrame = Instance.new("ScrollingFrame")
PlayerScrollFrame.Size = UDim2.new(1, -10, 1, -50)
PlayerScrollFrame.Position = UDim2.new(0, 5, 0, 45)
PlayerScrollFrame.BackgroundTransparency = 1
PlayerScrollFrame.BorderSizePixel = 0
PlayerScrollFrame.ScrollBarThickness = 4
PlayerScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrollFrame.Parent = PlayerListFrame

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.Name
PlayerListLayout.Padding = UDim.new(0, 5)
PlayerListLayout.Parent = PlayerScrollFrame

local function createToggleButton(name, text, position, callback)
    local Button = Instance.new("TextButton")
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
            Button.Text = text .. ": ON"
            Button.TextColor3 = Color3.fromRGB(85, 255, 85)
            Button.BackgroundColor3 = Color3.fromRGB(40, 70, 40)
        else
            Button.Text = text .. ": OFF"
            Button.TextColor3 = Color3.fromRGB(255, 85, 85)
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        end
        callback(isEnabled)
    end)
    
    return Button
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
            
            local floatPart = Instance.new("Part")
            floatPart.Name = "FloatPart"
            floatPart.Size = Vector3.new(5, 0.2, 5)
            floatPart.Transparency = 1
            floatPart.Anchored = true
            floatPart.CanCollide = true
            floatPart.Parent = workspace
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    originalCanCollide[part] = part.CanCollide
                    part.CanCollide = false
                end
            end
            
            local groundHeight = humanoidRootPart.Position.Y - 3
            
            connections.antiFling = RunService.Heartbeat:Connect(function()
                if not antiFlingEnabled then return end
                
                local character = LocalPlayer.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local currentPos = hrp.Position
                local targetHeight = groundHeight + 5.05
                
                local rayOrigin = Vector3.new(currentPos.X, currentPos.Y + 10, currentPos.Z)
                local rayDirection = Vector3.new(0, -100, 0)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {character, floatPart}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                
                local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                
                if rayResult then
                    groundHeight = rayResult.Position.Y
                    targetHeight = groundHeight + 5.05
                end
                
                if currentPos.Y < targetHeight - 0.1 or currentPos.Y > targetHeight + 0.1 then
                    hrp.CFrame = CFrame.new(currentPos.X, targetHeight, currentPos.Z) * CFrame.Angles(0, (hrp.CFrame - hrp.Position).LookVector.Y, 0)
                end
                
                if hrp.AssemblyLinearVelocity.Y > 5 or hrp.AssemblyLinearVelocity.Y < -5 then
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                end
                
                if hrp.AssemblyAngularVelocity.Magnitude > 10 then
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
                
                floatPart.CFrame = CFrame.new(currentPos.X, targetHeight - 2.6, currentPos.Z)
                
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part ~= floatPart then
                        part.CanCollide = false
                    end
                end
            end)
            
            connections.floatPart = floatPart
        end
        
        protectCharacter()
        LocalPlayer.CharacterAdded:Connect(function()
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
            
            for part, canCollide in pairs(originalCanCollide) do
                if part and part:IsDescendantOf(character) then
                    part.CanCollide = canCollide
                end
            end
            originalCanCollide = {}
        end
    end
end

local function setupBlackhole(enabled)
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
                    if not obj.Anchored and obj.Parent and obj.Parent ~= workspace then
                        local distance = (obj.Position - playerPos).Magnitude
                        
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
                if obj:IsA("BasePart") and not obj:IsDescendantOf(targetPlayer.Character) and not obj:IsDescendantOf(myCharacter) and obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" and obj.Name ~= "FloatPart" then
                    if not obj.Anchored and obj.Parent and obj.Parent ~= workspace then
                        local distance = (obj.Position - targetPos).Magnitude
                        
                        if distance < 150 then
                            local direction = (targetPos - obj.Position).Unit
                            obj.AssemblyLinearVelocity = direction * 300
                        end
                    end
                end
            end
            
            if myHRP and antiFlingEnabled then
                myHRP.AssemblyLinearVelocity = Vector3.new(myHRP.AssemblyLinearVelocity.X, 0, myHRP.AssemblyLinearVelocity.Z)
                myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
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
            PlayerButton.Size = UDim2.new(1, -5, 0, 40)
            PlayerButton.Position = UDim2.new(0, 0, 0, yPos)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            PlayerButton.BorderSizePixel = 0
            PlayerButton.Font = Enum.Font.GothamSemibold
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.TextSize = 14
            PlayerButton.Parent = PlayerScrollFrame
            
            local PlayerButtonCorner = Instance.new("UICorner")
            PlayerButtonCorner.CornerRadius = UDim.new(0, 8)
            PlayerButtonCorner.Parent = PlayerButton
            
            PlayerButton.MouseButton1Click:Connect(function()
                targetPlayer = player
                PlayerSelectButton.Text = player.Name
                PlayerListFrame.Visible = false
                
                if blackholePlayerEnabled then
                    setupBlackholePlayer(false)
                    setupBlackholePlayer(true)
                end
            end)
            
            yPos = yPos + 45
        end
    end
    
    PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
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

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(1, -10, 0, 25)
InputLabel.Position = UDim2.new(0, 5, 0, 145)
InputLabel.BackgroundTransparency = 1
InputLabel.Font = Enum.Font.GothamSemibold
InputLabel.Text = "Blackhole Player:"
InputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InputLabel.TextSize = 14
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = ScrollFrame

PlayerSelectButton = Instance.new("TextButton")
PlayerSelectButton.Name = "PlayerSelectButton"
PlayerSelectButton.Size = UDim2.new(1, -10, 0, 55)
PlayerSelectButton.Position = UDim2.new(0, 5, 0, 175)
PlayerSelectButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
PlayerSelectButton.BorderSizePixel = 0
PlayerSelectButton.Font = Enum.Font.GothamSemibold
PlayerSelectButton.Text = "Players"
PlayerSelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerSelectButton.TextSize = 15
PlayerSelectButton.Parent = ScrollFrame

local PlayerSelectCorner = Instance.new("UICorner")
PlayerSelectCorner.CornerRadius = UDim.new(0, 10)
PlayerSelectCorner.Parent = PlayerSelectButton

PlayerSelectButton.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then
        updatePlayerList()
    end
end)

local Spacer3 = Instance.new("Frame")
Spacer3.Size = UDim2.new(1, 0, 0, 10)
Spacer3.Position = UDim2.new(0, 0, 0, 235)
Spacer3.BackgroundTransparency = 1
Spacer3.Parent = ScrollFrame

createToggleButton("BlackholePlayer", "Blackhole Player", UDim2.new(0, 5, 0, 245), setupBlackholePlayer)

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 310)

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

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
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
        
        for part, canCollide in pairs(originalCanCollide) do
            if part and part:IsDescendantOf(character) then
                part.CanCollide = canCollide
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
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        MinimizeButton.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 450), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        MinimizeButton.Text = "-"
    end
end)
