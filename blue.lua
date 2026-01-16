----- speed
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

humanoid.WalkSpeed = 0


-------[ sfx ] -------
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
	forceful.Volume = 1
	forceful.TimePosition = 0
	forceful:Play()

	-- Boowoowoo
	local boowoowoo = sfx("0", workspace, true)
	boowoowoo.Volume = 1
	boowoowoo:Play()

	-- Fastpull (from your comment)
	local fastpull = sfx("0", workspace, true)
	fastpull.Volume = 2
	fastpull:Play()

	-- KJ sound
	local kj = sfx("0", workspace, true)
	kj.Volume = 3
	kj:Play()

	-- Gunchopper
	local gunchopper = sfx("0", workspace, true)
	gunchopper.Volume = 0.5
	gunchopper:Play()

	-- Glitch sound
	local glitch = sfx("3276835551", workspace, true)
	glitch.Volume = 4
	glitch:Play()

	wait(0.5)

	-- Voiceline
	local voiceline = sfx("0", workspace, true)
	voiceline.Volume = 1
	voiceline:Play()

	-- Boom
	local boom = sfx("7390331288", workspace, true)
	boom.Volume = 1
	boom:Play()
end)



--- bring
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer

local FREEZE_START_DISTANCE = 30
local TARGET_DISTANCE = 12
local FLING_SPEED = 500
local PULL_FORCE = 90000
local PULL_DURATION = 6
local HEIGHT_OFFSET = 3.2

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

local function pullThenFling()
	local character = player.Character
	if not character then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local parts = getNearbyUnanchoredParts(hrp.Position, FREEZE_START_DISTANCE)
	local tracking = {}

	for _, part in ipairs(parts) do
		local pull = Instance.new("BodyPosition")
		pull.Name = "PullPosition"
		pull.MaxForce = Vector3.new(PULL_FORCE, PULL_FORCE, PULL_FORCE)
		pull.P = 7000
		pull.D = 500
		pull.Parent = part

		tracking[part] = pull
	end

	local startTime = tick()

	local updateConnection
	updateConnection = RunService.Heartbeat:Connect(function()
		local now = tick()
		local elapsed = now - startTime

		if elapsed >= PULL_DURATION then
			updateConnection:Disconnect()

			for part, pull in pairs(tracking) do
				if pull and pull.Parent then
					pull:Destroy()
				end

				if part and part.Parent then
					local fling = Instance.new("BodyVelocity")
					fling.Velocity = hrp.CFrame.LookVector * FLING_SPEED
					fling.MaxForce = Vector3.new(1e5, 1e5, 1e5)
					fling.P = 10000
					fling.Parent = part
					Debris:AddItem(fling, 0.5)

					-- Kill after 0.3 seconds using Humanoid health
					task.delay(0.3, function()
						local model = part:FindFirstAncestorOfClass("Model")
						if model then
							local humanoid = model:FindFirstChildOfClass("Humanoid")
							if humanoid then
								humanoid.Health = 0
							end
						end
					end)
				end
			end
		else
			local frontPos = hrp.Position + hrp.CFrame.LookVector * TARGET_DISTANCE + Vector3.new(0, HEIGHT_OFFSET, 0)
			for part, pull in pairs(tracking) do
				if pull and part then
					pull.Position = frontPos
				end
			end
		end
	end)
end

-- Run once
pullThenFling()

-- divergent fist blue fire
-----------------------[[ blue glowing effect fire 1 ]]----------------------
-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rightArm = character:WaitForChild("Right Arm") -- R6 only

-- Remove existing fire if any
if rightArm:FindFirstChild("CyanFire") then
	rightArm.CyanFire:Destroy()
end

-- Create attachment 1 stud below the arm
local attachment = Instance.new("Attachment")
attachment.Name = "CyanFire"
attachment.Position = Vector3.new(0, -1, 0)
attachment.Parent = rightArm

-- Create the particle emitter
local particle = Instance.new("ParticleEmitter")
particle.Name = "FireEffect"
particle.Texture = "rbxassetid://284205403"
particle.Parent = attachment
particle.Rate = 60
particle.Lifetime = NumberRange.new(0.5, 0.7)
particle.Speed = NumberRange.new(1, 2)
particle.Rotation = NumberRange.new(0, 360)
particle.RotSpeed = NumberRange.new(-90, 90)

-- Doubled size
particle.Size = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 1),      -- originally 0.5
	NumberSequenceKeypoint.new(0.3, 1.5),    -- originally 1
	NumberSequenceKeypoint.new(1, 0)
}

particle.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.1),
	NumberSequenceKeypoint.new(0.6, 0.3),
	NumberSequenceKeypoint.new(1, 1)
}

particle.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 180))
}

particle.LightEmission = 0.6
particle.LightInfluence = 0.3
particle.Enabled = true

-- Auto remove after 1 second
task.delay(1.8, function()
	if attachment and attachment.Parent then
		attachment:Destroy()
	end
end)
-----------------------[[ animation charge up ]]-----------------------
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local fadeTime = 0.5

-- Animation 1
local anim1 = Instance.new("Animation")
anim1.AnimationId = "rbxassetid://243662996"
local track1 = humanoid:LoadAnimation(anim1)
track1:Play(fadeTime)
track1.TimePosition = 0.8
track1:AdjustSpeed(0)
task.delay(1, function()
    track1:Stop(fadeTime)
end)

-- Animation 2
local anim2 = Instance.new("Animation")
anim2.AnimationId = "rbxassetid://243653141"
local track2 = humanoid:LoadAnimation(anim2)
track2:Play(fadeTime)
track2.TimePosition = 0.5
track2:AdjustSpeed(0.5)
task.delay(1, function()
    track2:Stop(fadeTime)
end)

-- Animation 3
local anim3 = Instance.new("Animation")
anim3.AnimationId = "rbxassetid://54456096"
local track3 = humanoid:LoadAnimation(anim3)
track3:Play(fadeTime)
track3.TimePosition = 0.9
track3:AdjustSpeed(0)
task.delay(1, function()
    track3:Stop(fadeTime)
end)

-- Animation 4
local anim4 = Instance.new("Animation")
anim4.AnimationId = "rbxassetid://85836966"
local track4 = humanoid:LoadAnimation(anim4)
track4:Play(fadeTime)
track4.TimePosition = 0.5
track4:AdjustSpeed(0)
task.delay(1, function()
    track4:Stop(fadeTime)
end)

-- Animation 5
local anim5 = Instance.new("Animation")
anim5.AnimationId = "rbxassetid://243656287"
local track5 = humanoid:LoadAnimation(anim5)
track5:Play(fadeTime)
track5.TimePosition = 0.5
track5:AdjustSpeed(1)
task.delay(1, function()
    track5:Stop(fadeTime)
end)
-- [[animation ends, and starts up wait and leap ]] --
Wait(1)
-- leap
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local leapDistance = 30
local leapHeight = 0
local function leapForward()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = rootPart.CFrame.lookVector * leapDistance + Vector3.new(0, leapHeight, 0)
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000) -- Adjust as needed
    bodyVelocity.P = 5000 -- Adjust the power of the force
    bodyVelocity.Parent = rootPart
    game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
end
leapForward()
-- leap ends
-------------- [ charge up animation ] ---------
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://243662996"

local animationTrack = humanoid:LoadAnimation(animation)

local fadeTime = 0.5
animationTrack:Play(fadeTime)
animationTrack.TimePosition = 0.5
animationTrack:AdjustSpeed(0)

task.delay(1, function()
    animationTrack:Stop(fadeTime)
end)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://93107107"

local animationTrack = humanoid:LoadAnimation(animation)

local fadeTime = 0.5
animationTrack:Play(fadeTime)
animationTrack.TimePosition = 0.5
animationTrack:AdjustSpeed(0)

task.delay(1, function()
    animationTrack:Stop(fadeTime)
end)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://203929952"

local animationTrack = humanoid:LoadAnimation(animation)

local fadeTime = 0.5
animationTrack:Play(fadeTime)
animationTrack.TimePosition = 0.1
animationTrack:AdjustSpeed(0)

task.delay(1, function()
    animationTrack:Stop(fadeTime)
end)
--[-------------------[ black flash model ]--------------------]--
wait(0.5)
-------------------[your model id here.]-------------------
local assetId = "rbxassetid://70681471980871" -- test model

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humRootPart = character:WaitForChild("HumanoidRootPart")

--------------[setting]--------------
local MoveRight = 0
local MoveLeft = -1.5
local MoveUp = 0
local MoveDown = 18
local MoveForward = 0
local MoveBackward = -5
local DestroyDelay = 1.5

-- Position offset relative to look direction
local Offset = Vector3.new(
	MoveRight - MoveLeft,
	MoveUp - MoveDown,
	MoveForward - MoveBackward
)

---[don't touch anything here if you don't know what you're doing.]---

local objects = game:GetObjects(assetId)
if #objects > 0 then
	local model = objects[1]
	model.Parent = workspace
	if model:IsA("Model") then
		if not model.PrimaryPart then
			local primary = model:FindFirstChildWhichIsA("BasePart")
			if primary then
				model.PrimaryPart = primary
			end
		end
		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
				part.Massless = true
			end
		end
		if model.PrimaryPart then
			local rootCFrame = humRootPart.CFrame
			local lookVector = rootCFrame.LookVector
			local spawnCFrame = rootCFrame + rootCFrame:VectorToWorldSpace(Offset)
			local facingRotation = CFrame.new(Vector3.zero, lookVector)	model:SetPrimaryPartCFrame(CFrame.new(spawnCFrame.Position) * facingRotation)
		end

		-- Auto destroy
		task.delay(DestroyDelay, function()
			if model then
				model:Destroy()
			end
		end)
	end
end
-- test--
----------[[ final punch ]]--------
wait(0.7)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://218504594"

local animationTrack = humanoid:LoadAnimation(animation)

local fadeTime = 0.5
animationTrack:Play(fadeTime)
animationTrack.TimePosition = 1
animationTrack:AdjustSpeed(-0.6)

task.delay(1, function()
    animationTrack:Stop(fadeTime)
end)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://204062532"

local animationTrack = humanoid:LoadAnimation(animation)

local fadeTime = 0.5
animationTrack:Play(fadeTime)
animationTrack.TimePosition = 1
animationTrack:AdjustSpeed(0)

task.delay(1, function()
    animationTrack:Stop(fadeTime)
end)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://218508052"

local animationTrack = humanoid:LoadAnimation(animation)

local fadeTime = 0.5
animationTrack:Play(fadeTime)
animationTrack.TimePosition = 0.6
animationTrack:AdjustSpeed(0.6)

task.delay(1, function()
    animationTrack:Stop(fadeTime)
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
	createBillboard(Vector3.new(-5, 0, 0), "... BLACK.       ...")
	createBillboard(Vector3.new(5, 0, 0), "... FLASH!!.")
end

if player.Character then
	triggerBillboards()
else
	player.CharacterAdded:Once(triggerBillboards)
end
Wait(0.9)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

humanoid.WalkSpeed = 16
