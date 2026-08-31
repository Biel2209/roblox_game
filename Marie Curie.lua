-- ReplicatedStorage/Abilities/MarieCurie.lua

local MarieCurie = {}

MarieCurie.Radius = 20
MarieCurie.Duration = 6
MarieCurie.DamagePerTick = 8
MarieCurie.TickRate = 1

function MarieCurie.Cast(caster, position)
	if not position then
		return
	end

	local affected = {}

	local startTime = os.clock()

	while os.clock() - startTime < MarieCurie.Duration do

		for _, object in ipairs(workspace:GetChildren()) do
			if object:IsA("Model") and object ~= caster then

				local humanoid =
					object:FindFirstChildOfClass("Humanoid")

				local root =
					object:FindFirstChild("HumanoidRootPart")

				if humanoid and root and humanoid.Health > 0 then

					local distance =
						(root.Position - position).Magnitude

					if distance <= MarieCurie.Radius then

						humanoid:TakeDamage(
							MarieCurie.DamagePerTick
						)

						affected[object] = true
					end
				end
			end
		end

		task.wait(MarieCurie.TickRate)
	end
end

return MarieCurie