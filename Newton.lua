-- ReplicatedStorage/Abilities/Newton.lua
-- FÍSICA: Lei da Ação e Reação (3ª Lei de Newton)
-- F = m × a (Força = Massa × Aceleração)
-- p = m × v (Impulso = Massa × Velocidade)
-- Conservação do Momentum: m1×v1 + m2×v2 = constante

local Newton = {}

Newton.Radius = 28
Newton.ImpulseForce = 50
Newton.Damage = 30
Newton.Knockback = 1.5 -- Multiplier para o knockback
Newton.Duration = 0.5 -- Tempo que o impulso é aplicado

local function getRoot(model)
	return model:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(model)
	return model:FindFirstChildOfClass("Humanoid")
end

-- Calcula o impulso baseado na massa e direção
-- p = m × v
local function calculateImpulse(targetRoot, casterRoot, mass)
	local direction = (targetRoot.Position - casterRoot.Position).Unit
	local impulse = mass * Newton.ImpulseForce * Newton.Knockback
	return direction * impulse
end

function Newton.Cast(caster, position)
	if not position then
		return
	end

	local casterRoot = getRoot(caster)
	if not casterRoot then
		return
	end

	-- Encontra todos os alvos num raio
	for _, object in ipairs(workspace:GetChildren()) do
		if object:IsA("Model") and object ~= caster then
			local humanoid = getHumanoid(object)
			local root = getRoot(object)

			if humanoid and root and humanoid.Health > 0 then
				local distance = (root.Position - position).Magnitude

				if distance <= Newton.Radius then
					-- Aplica dano
					humanoid:TakeDamage(Newton.Damage)

					-- Calcula e aplica impulso (conservação do momentum)
					-- Assumindo massa 1 para o cálculo
					local impulse = calculateImpulse(root, casterRoot, 1)
					root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + impulse

					-- Toca o alvo para criar reação visual
					local touchSound = Instance.new("Sound")
					touchSound.SoundId = "rbxassetid://166423136"
					touchSound.Volume = 0.5
					touchSound.Parent = root
					touchSound:Play()
					game:GetService("Debris"):AddItem(touchSound, 0.5)
				end
			end
		end
	end
end

return Newton
