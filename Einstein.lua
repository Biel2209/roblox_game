-- ReplicatedStorage/Abilities/Einstein.lua

local Einstein = {}

Einstein.Radius = 25
Einstein.Duration = 3
Einstein.PullForce = 35
Einstein.Damage = 10

function Einstein.Cast(caster, position)
	if not position then
		return
	end

	local startTime = os.clock()

	while os.clock() - startTime < Einstein.Duration do

		for _, object in ipairs(workspace:GetChildren()) do
			if object:IsA("Model") and object ~= caster then

				local humanoid =
					object:FindFirstChildOfClass("Humanoid")

				local root =
					object:FindFirstChild("HumanoidRootPart")

				if humanoid and root and humanoid.Health > 0 then

					local offset = position - root.Position
					local distance = offset.Magnitude

					if distance <= Einstein.Radius
						and distance > 1 then

						local direction =
							offset.Unit

						root.AssemblyLinearVelocity =
							direction * Einstein.PullForce

						humanoid:TakeDamage(
							Einstein.Damage * 0.1
						)
					end
				end
			end
		end

		task.wait(0.1)
	end
end

return Einstein