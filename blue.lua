-- Define the sfx function if not already defined
local function sfx(soundId, parent, is3D)
	local sound = Instance.new("Sound")
	sound.SoundId = soundId:match("rbxassetid://") and soundId or "rbxassetid://" .. soundId
	sound.Parent = parent
	sound.RollOffMode = Enum.RollOffMode.Linear
	sound.EmitterSize = is3D and 10 or 0
	sound.RollOffMaxDistance = is3D and 100 or 0
	sound.PlayOnRemove = false
	sound.Looped = false
	return sound
end

task.spawn(function()
	-- Forceful air
	local forceful = sfx("122261039674349", workspace, true)
	forceful.Volume = 5
	forceful.TimePosition = 0
	forceful:Play()

	-- Boowoowoo
	local boowoowoo = sfx("7652527370", workspace, true)
	boowoowoo.Volume = 1
	boowoowoo:Play()

	-- Fastpull (from your comment)
	local fastpull = sfx("127117086239111", workspace, true)
	fastpull.Volume = 2
	fastpull:Play()

	-- KJ sound
	local kj = sfx("76786040776528", workspace, true)
	kj.Volume = 3
	kj:Play()

	-- Gunchopper
	local gunchopper = sfx("8737379396", workspace, true)
	gunchopper.Volume = 0.5
	gunchopper:Play()

	-- Glitch sound
	local glitch = sfx("3276835551", workspace, true)
	glitch.Volume = 1
	glitch:Play()

	wait(0.5)

	-- Voiceline
	local voiceline = sfx("0", workspace, true)
	voiceline.Volume = 4
	voiceline:Play()

	-- Boom
	local boom = sfx("7390331288", workspace, true)
	boom.Volume = 2
	boom:Play()
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local fadeTime, tweenTime = 0.5, 0.5
local imageId = "rbxassetid://133329932870887"

local function createBillboard(offset, text)
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	local bb = Instance.new("BillboardGui")
	bb.Adornee = hrp
	bb.Size = UDim2.fromScale(5, 5)
	bb.StudsOffset = offset
	bb.AlwaysOnTop = true
	bb.Parent = character

	local img = Instance.new("ImageLabel")
	img.Size = UDim2.fromScale(0.77, 0.77)
	img.Position = UDim2.fromScale(0.115, 0.115)
	img.Image = imageId
	img.BackgroundTransparency = 1
	img.Parent = bb

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.fromScale(0.59, 0.59)
	txt.Position = UDim2.fromScale(0.205, 0.205)
	txt.BackgroundTransparency = 1
	txt.TextScaled = true
	txt.Font = Enum.Font.SpecialElite -- MANGA-LIKE FONT
	txt.TextColor3 = Color3.new()
	txt.TextStrokeTransparency = 1
	txt.Text = text
	txt.Parent = img

	task.spawn(function()
		task.wait(3)
		TweenService:Create(bb, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad), {
			StudsOffset = bb.StudsOffset + Vector3.new((offset.X > 0 and 1 or -1) * 16, 0, 0)
		}):Play()

		for i = 0, 1, 1 / (fadeTime * 60) do
			img.ImageTransparency = i
			txt.TextTransparency = i
			task.wait(0.5 / 60)
		end

		bb:Destroy()
	end)
end

local function triggerBillboards()
	createBillboard(Vector3.new(-5, 0, 0), "... cursed technique amplification.       ...")
	createBillboard(Vector3.new(5, 0, 0), "... Blue.")
end

if player.Character then
	triggerBillboards()
else
	player.CharacterAdded:Once(triggerBillboards)
end


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://93693205"

local animationTrack = humanoid:LoadAnimation(animation)

local fadeTime = 0.5
animationTrack:Play(fadeTime)
animationTrack.TimePosition = 0.5
animationTrack:AdjustSpeed(0)

task.delay(1.5, function()
    animationTrack:Stop(fadeTime)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Settings
local BALL_COUNT = 1
local ORBIT_RADIUS = 35
local ORBIT_SPEED = 5
local UP_DOWN_RANGE = 10
local UP_DOWN_SPEED = 2
local BALL_SIZE = 15
local FADE_TIME = 1.5 -- seconds it takes to fade
local LIFETIME = 1.5 -- seconds before fading begins
local PULL_RADIUS = 50
local PULL_VELOCITY = 500
local PULL_FORCE = 9000000

local balls = {}

-- Get nearby unanchored parts
local function getNearbyUnanchoredParts(centerPos, range)
	local region = Region3.new(centerPos - Vector3.new(range, range, range), centerPos + Vector3.new(range, range, range))
	local parts = workspace:FindPartsInRegion3WithIgnoreList(region, {player.Character}, math.huge)
	local valid = {}

	for _, part in ipairs(parts) do
		if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(player.Character) then
			table.insert(valid, part)
		end
	end
	return valid
end

-- Function to create a glowing blue ball
local function createBall()
	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(BALL_SIZE, BALL_SIZE, BALL_SIZE)
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(0, 162, 255)
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 0

	local light = Instance.new("PointLight")
	light.Color = part.Color
	light.Brightness = 2
	light.Range = 8
	light.Parent = part

	part.Parent = workspace
	return part, light
end

-- Initialize balls
for i = 1, BALL_COUNT do
	local part, light = createBall()
	local ballData = {
		part = part,
		light = light,
		angle = math.random() * math.pi * 2,
		heightOffset = math.random() * math.pi * 2,
		verticalSpeed = math.random(1, 3) / 1.5,
		baseOrbitSpeed = ORBIT_SPEED,
		baseVerticalSpeed = UP_DOWN_SPEED,
		fadeStartTime = nil,
	}
	table.insert(balls, ballData)

	-- Begin fade after lifetime
	task.delay(LIFETIME, function()
		ballData.fadeStartTime = tick()
	end)
end

-- Orbit + Pull update loop
RunService.RenderStepped:Connect(function(dt)
	local now = tick()

	for _, ball in ipairs(balls) do
		local part = ball.part
		if not part or not part.Parent then continue end

		-- Handle fading
		local alpha = 0
		if ball.fadeStartTime then
			local elapsed = now - ball.fadeStartTime
			alpha = math.clamp(elapsed / FADE_TIME, 0, 1)

			part.Transparency = alpha
			ball.light.Brightness = 2 * (1 - alpha)

			if alpha >= 1 then
				part:Destroy()
				ball.part = nil
				continue
			end
		end

		-- Slow down as it fades
		local fadeMultiplier = 1 - alpha
		local orbitSpeed = ball.baseOrbitSpeed * fadeMultiplier
		local verticalSpeed = ball.baseVerticalSpeed * fadeMultiplier

		ball.angle += orbitSpeed * dt
		ball.heightOffset += verticalSpeed * dt

		-- New position
		local x = math.cos(ball.angle) * ORBIT_RADIUS
		local z = math.sin(ball.angle) * ORBIT_RADIUS
		local y = math.sin(ball.heightOffset) * UP_DOWN_RANGE
		local currentPos = root.Position + Vector3.new(x, y + 3, z)

		part.Position = currentPos

		-- Pull unanchored parts
		local nearbyParts = getNearbyUnanchoredParts(currentPos, PULL_RADIUS)
		for _, target in ipairs(nearbyParts) do
			local direction = (currentPos - target.Position)
			if direction.Magnitude == 0 then continue end

			local bv = Instance.new("BodyVelocity")
			bv.Velocity = direction.Unit * PULL_VELOCITY
			bv.MaxForce = Vector3.new(PULL_FORCE, PULL_FORCE, PULL_FORCE)
			bv.P = PULL_FORCE
			bv.Name = "PullForce"
			bv.Parent = target

			Debris:AddItem(bv, 0.1)
		end
	end
end)
