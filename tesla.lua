-- ReplicatedStorage/Abilities/Tesla.lua

local Tesla = {}

Tesla.Damage = 25
Tesla.Radius = 22
Tesla.MaxTargets = 5

local function getRoot(model)
	return model:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(model)
	return model:FindFirstChildOfClass("Humanoid")
end

local function getNextTarget(position, alreadyHit)
	local bestTarget = nil
	local bestDistance = Tesla.Radius

	for _, object in ipairs(workspace:GetChildren()) do
		if object:IsA("Model") and not alreadyHit[object] then
			local humanoid = getHumanoid(object)
			local root = getRoot(object)

			if humanoid and root and humanoid.Health > 0 then
				local distance = (root.Position - position).Magnitude

				if distance <= bestDistance then
					bestDistance = distance
					bestTarget = object
				end
			end
		end
	end

	return bestTarget
end

function Tesla.Cast(caster, firstTarget)
	if not firstTarget then
		return
	end

	local hitTargets = {}
	local currentTarget = firstTarget

	for _ = 1, Tesla.MaxTargets do
		if not currentTarget then
			break
		end

		hitTargets[currentTarget] = true

		local humanoid = getHumanoid(currentTarget)
		local root = getRoot(currentTarget)

		if humanoid and root and humanoid.Health > 0 then
			humanoid:TakeDamage(Tesla.Damage)

			-- Efeito visual simples
			local attachment = Instance.new("Attachment")
			attachment.Parent = root

			task.delay(0.2, function()
				attachment:Destroy()
			end)
		end

		if root then
			currentTarget = getNextTarget(
				root.Position,
				hitTargets
			)
		else
			break
		end
	end
end

return Tesla