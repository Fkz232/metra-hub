local player = game.Players.LocalPlayer
local playerTeam = player.Team
local gui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame")
local button = Instance.new("TextButton")
local textBox = Instance.new("TextBox")
local hitboxSize = 5

gui.Name = "RGBGui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Draggable = true
frame.Parent = gui

button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0, 50, 0, 50)
button.Text = "Executar"
button.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
button.Parent = frame

textBox.Size = UDim2.new(0, 100, 0, 40)
textBox.Position = UDim2.new(0, 50, 0, 10)
textBox.PlaceholderText = "Tamanho da Hitbox"
textBox.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
textBox.Parent = frame

local function updateRGBColor()
    while wait(0.1) do
        local time = tick() % 5
        frame.BackgroundColor3 = Color3.fromHSV(time / 5, 1, 1)
        button.TextColor3 = Color3.fromHSV(time / 5, 1, 1)
        textBox.TextColor3 = Color3.fromHSV(time / 5, 1, 1)
    end
end

local function changeHitboxSize()
    hitboxSize = tonumber(textBox.Text) or hitboxSize
end

button.MouseButton1Click:Connect(function()
    changeHitboxSize()
end)

local function createHitbox()
    local hitbox = Instance.new("Part")
    hitbox.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
    hitbox.Position = player.Character.PrimaryPart.Position
    hitbox.Anchored = true
    hitbox.CanCollide = false
    hitbox.Transparency = 1
    hitbox.Parent = game.Workspace

    if playerTeam == game.Teams.Red then
        hitbox.BrickColor = BrickColor.Red()
    else
        hitbox.BrickColor = BrickColor.Blue()
    end

    local highlight = Instance.new("Highlight")
    highlight.Parent = hitbox
    highlight.FillColor = hitbox.BrickColor.Color
    highlight.OutlineColor = hitbox.BrickColor.Color
end

local function hitboxLoop()
    while player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
        createHitbox()
        wait(1)
    end
end

spawn(hitboxLoop)

player.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart").Changed:Connect(function()
        createHitbox()
    end)
end)

updateRGBColor()
