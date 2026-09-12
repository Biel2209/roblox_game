-- ReplicatedStorage/Abilities/Hooke.lua
-- FÍSICA: Lei de Hooke e Movimento Harmônico Simples (MHS)
-- F = -k × x (Força restauradora)
-- x(t) = A × cos(ωt + φ) (Posição em MHS)
-- ω = √(k/m) (Frequência angular)
-- Quanto mais longe o inimigo, mais forte é a força de atração!

local Hooke = {}

Hooke.Radius = 35
Hooke.Duration = 5
Hooke.SpringConstant = 45 -- k (constante elástica)
Hooke.Amplitude = 1.5 -- Amplitude da oscilação
Hooke.Damping = 0.98 -- Amortecimento (0-1, menor = mais amortecido)
Hooke.BaseDamage = 12
Hooke.OscillationDamagePerSecond = 5

local function getRoot(model)
	return model:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(model)
	return model:FindFirstChildOfClass("Humanoid")
end

-- Calcula a força restauradora baseada na lei de Hooke
-- F = -k × x (x = distância do centro)
-- Quanto mais longe, mais forte a força!
local function calculateSpringForce(targetPos, centerPos, springConstant)
	local displacement = targetPos - centerPos
	local distance = displacement.Magnitude
	
	if distance < 0.1 then
		return Vector3.new(0, 0, 0)
	end
	
	-- Força proporcional à distância (Lei de Hooke)
	local forceMagnitude = springConstant * distance
	local direction = (centerPos - targetPos).Unit
	
	return direction * forceMagnitude
end

-- Calcula oscilação harmônica
-- x(t) = A × cos(ωt + φ)
local function calculateOscillation(time, amplitude, frequency)
	return amplitude * math.cos(frequency * time)
end

function Hooke.Cast(caster, position)
	if not position then
		return
	end

	local affectedTargets = {}
	local startTime = os.clock()
	local targetStartPositions = {} -- Posições iniciais
	
	-- Primeira varredura: registra alvos
	for _, object in ipairs(workspace:GetChildren()) do
		if object:IsA("Model") and object ~= caster then
			local humanoid = getHumanoid(object)
			local root = getRoot(object)
			
			if humanoid and root and humanoid.Health > 0 then
				local distance = (root.Position - position).Magnitude
				
				if distance <= Hooke.Radius then
					affectedTargets[object] = true
					targetStartPositions[object] = root.Position
				end
			end
		end
	end

	-- Aplica força elástica e oscilação durante a duração
	while os.clock() - startTime < Hooke.Duration do
		local elapsedTime = os.clock() - startTime
		local frequency = math.sqrt(Hooke.SpringConstant) -- ω = √(k/m)
		
		for targetObject, _ in pairs(affectedTargets) do
			local humanoid = getHumanoid(targetObject)
			local root = getRoot(targetObject)

			if humanoid and root and humanoid.Health > 0 then
				-- Calcula força restauradora (Lei de Hooke)
				local springForce = calculateSpringForce(
					root.Position,
					position,
					Hooke.SpringConstant
				)
				
				-- Calcula componente de oscilação (MHS)
				local oscillation = calculateOscillation(
					elapsedTime,
					Hooke.Amplitude,
					frequency
				)
				
				-- Aplica movimento oscilatório perpendicular à força
				local perpendicularDir = Vector3.new(
					-springForce.Z,
					0,
					springForce.X
				).Unit
				
				-- Força total = Força restauradora + Oscilação
				local totalForce = springForce + (perpendicularDir * oscillation * Hooke.SpringConstant)
				
				-- Aplica amortecimento (movimento perde energia)
				root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * Hooke.Damping
				root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + (totalForce * 0.016)
				
				-- Dano contínuo por estar na zona elástica
				humanoid:TakeDamage(Hooke.BaseDamage * 0.016)
				
				-- Dano adicional quando oscila rapidamente
				if math.abs(oscillation) > Hooke.Amplitude * 0.8 then
					humanoid:TakeDamage(Hooke.OscillationDamagePerSecond * 0.016)
				end
			else
				affectedTargets[targetObject] = nil
			end
		end

		task.wait(0.016) -- ~60 FPS
	end
end

return Hooke
