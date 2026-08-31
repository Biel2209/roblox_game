local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local WALK_SPEED = 16
local SPRINT_SPEED = 25

local DASH_SPEED = 75
local DASH_TIME = 0.15
local DASH_COOLDOWN = 1

local STAMINA_MAX = 100
local STAMINA = STAMINA_MAX
local SPRINT_COST = 15
local DASH_COST = 25

local sprinting = false
local canDash = true

local character
local humanoid
local rootPart

local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	rootPart = char:WaitForChild("HumanoidRootPart")

	humanoid.WalkSpeed = WALK_SPEED
end

setupCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupCharacter)

-- SPRINT
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end

	if input.KeyCode == Enum.KeyCode.LeftControl then
		sprinting = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftControl then
		sprinting = false
		if humanoid then
			humanoid.WalkSpeed = WALK_SPEED
		end
	end
end)

-- DASH
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end

	if input.KeyCode == Enum.KeyCode.Q and canDash and STAMINA >= DASH_COST then
		canDash = false
		STAMINA -= DASH_COST

		local direction = humanoid.MoveDirection

		if direction.Magnitude == 0 then
			direction = rootPart.CFrame.LookVector
		end

		-- Dá o impulso
		rootPart.AssemblyLinearVelocity = Vector3.new(
			direction.X * DASH_SPEED,
			rootPart.AssemblyLinearVelocity.Y,
			direction.Z * DASH_SPEED
		)

		task.wait(DASH_TIME)

		-- Remove o impulso
		rootPart.AssemblyLinearVelocity = Vector3.new(
			0,
			rootPart.AssemblyLinearVelocity.Y,
			0
		)

		task.wait(DASH_COOLDOWN)
		canDash = true
	end
end)

-- STAMINA
task.spawn(function()
	while true do
		task.wait(0.1)

		if sprinting and humanoid and humanoid.MoveDirection.Magnitude > 0 then
			STAMINA -= SPRINT_COST * 0.1

			if STAMINA <= 0 then
				STAMINA = 0
				sprinting = false
			end
		else
			STAMINA += 10 * 0.1
		end

		STAMINA = math.clamp(STAMINA, 0, STAMINA_MAX)

		if humanoid then
			if sprinting and STAMINA > 0 then
				humanoid.WalkSpeed = SPRINT_SPEED
			else
				humanoid.WalkSpeed = WALK_SPEED
			end
		end
	end
end)
