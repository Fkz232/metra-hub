local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0.5, -75, 0.8, -25)
Button.Text = "Atirar"
Button.TextSize = 24
Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Button.Parent = ScreenGui

local dragging = false
local dragInput, dragStart, startPos

Button.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Button.Position
    end
end)

Button.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function equipSecondItem()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack
    local inventory = backpack:GetChildren()

    if #inventory > 1 then
        local secondItem = inventory[2]
        secondItem.Parent = character
    end
end

local function shootAtClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    local characterPosition = PlayerCharacter.HumanoidRootPart.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Team ~= LocalPlayer.Team then
                local distance = (player.Character.HumanoidRootPart.Position - characterPosition).Magnitude
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end

    if closestPlayer then
        local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
        local direction = (targetPosition - characterPosition).unit
        
        local screenPosition = Camera:WorldToScreenPoint(targetPosition + direction * 5)
        
        local touchInput = Instance.new("InputObject")
        touchInput.UserInputType = Enum.UserInputType.Touch
        touchInput.Position = Vector2.new(screenPosition.X, screenPosition.Y)
        UserInputService.InputBegan:Fire(touchInput)
    end
end

Button.MouseButton1Click:Connect(function()
    equipSecondItem()
    wait(0.5)
    shootAtClosestPlayer()
end)
