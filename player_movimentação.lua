local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local speed = 16

local function getMoveDirection()
    local camera = workspace.CurrentCamera
    local look = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector

    local direction = Vector3.zero

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction += look
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction -= look
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction -= right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction += right
    end

    if direction.Magnitude > 0 then
        direction = direction.Unit
    end

    return direction
end

RunService:BindToRenderStep("MoveCharacter", Enum.RenderPriority.Character.Value + 1, function()
    local dir = getMoveDirection()
    humanoid:Move(dir, true)
end)

-- Pulo
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)   
