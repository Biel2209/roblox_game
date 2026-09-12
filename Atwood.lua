-- ReplicatedStorage/Abilities/Atwood.lua
-- FÍSICA: Máquina de Atwood - Sistema de Polias
-- a = (m1 - m2) / (m1 + m2) × g (Aceleração diferenciada)
-- T = 2 × m1 × m2 / (m1 + m2) × g (Tensão na corda)
-- Sistema de massas diferentes: alguns sobem, outros descem!

local Atwood = {}

Atwood.Radius = 32
Atwood.Duration = 4
Atwood.PullForce = 40
Atwood.Gravity = 9.8
Atwood.Damage = 20
Atwood.ContinuousDamage = 8

local function getRoot(model)
	return model:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(model)
	return model:FindFirstChildOfClass("Humanoid")
end

-- Simula duas massas diferentes em um sistema de polia
-- m1 desce, m2 sobe (ou vice versa)
-- a = (m1 - m2) / (m1 + m2) × g
local function calculateAttwoodAcceleration(m1, m2, gravity)
	if (m1 + m2) == 0 then return 0 end
	return ((m1 - m2) / (m1 + m2)) * gravity
end

-- Calcula tensão na corda
-- T = 2 × m1 × m2 / (m1 + m2) × g
local function calculateTension(m1, m2, gravity)
	if (m1 + m2) == 0 then return 0 end
	return (2 * m1 * m2 / (m1 + m2)) * gravity
end

function Atwood.Cast(caster, position)
	if not position then
		return
	end

	local affectedTargets = {}
	local startTime = os.clock()
	local targetMasses = {} -- Massas "simuladas" para cada alvo
	local targetDirs = {} -- Direções (up ou down)
	
	-- Primeira varredura: registra alvos e atribui "massas"
	local allTargets = {}
	for _, object in ipairs(workspace:GetChildren()) do
		if object:IsA("Model") and object ~= caster then
			local humanoid = getHumanoid(object)
			local root = getRoot(object)
			
			if humanoid and root and humanoid.Health > 0 then
				local distance = (root.Position - position).Magnitude
				
				if distance <= Atwood.Radius then
					table.insert(allTargets, object)
				end
			end
		end
	end
	
	-- Distribui massas alternadamente (sistema de polia)
	for i, targetObject in ipairs(allTargets) do
		affectedTargets[targetObject] = true
		-- Massas alternadas: 1 e 3 (ratio 3:1)
		targetMasses[targetObject] = (i % 2 == 0) and 3 or 1
		-- Direções alternadas: up e down
		targetDirs[targetObject] = (i % 2 == 0) and 1 or -1
	end

	-- Aplica sistema de Atwood durante a duração
	while os.clock() - startTime < Atwood.Duration do
		local targetObjectsList = {}
		for targetObject, _ in pairs(affectedTargets) do
			table.insert(targetObjectsList, targetObject)
		end
		
		-- Calcula aceleração do sistema
		if #targetObjectsList >= 2 then
			local m1 = targetMasses[targetObjectsList[1]] or 1
			local m2 = targetMasses[targetObjectsList[2]] or 1
			local acceleration = calculateAttwoodAcceleration(m1, m2, Atwood.Gravity)
			local tension = calculateTension(m1, m2, Atwood.Gravity)
		end
		
		-- Aplica movimento a cada alvo
		for idx, targetObject in ipairs(targetObjectsList) do
			local humanoid = getHumanoid(targetObject)
			local root = getRoot(targetObject)

			if humanoid and root and humanoid.Health > 0 then
				local mass = targetMasses[targetObject] or 1
				local direction = targetDirs[targetObject] or 1
				
				-- Calcula aceleração individual baseada na massa
				-- Massas maiores caem mais rápido, massas menores sobem
				local accel = calculateAttwoodAcceleration(mass, 3 - mass, Atwood.Gravity)
				
				-- Aplica movimento vertical (sistema de polia)
				local verticalForce = Vector3.new(0, accel * direction, 0)
				
				-- Aplica movimento em espiral ao redor do ponto central
				local timeOffset = os.clock() - startTime
				local spiralAngle = (timeOffset + idx) * 2
				local spiralRadius = 8
				
				local horizontalForce = Vector3.new(
					math.cos(spiralAngle) * spiralRadius,
					0,
					math.sin(spiralAngle) * spiralRadius
				)
				
				-- Força total = Atwood + Movimento espiralado
				local totalForce = (verticalForce + horizontalForce) * Atwood.PullForce
				root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + (totalForce * 0.016)
				
				-- Dano contínuo por estar no sistema
				humanoid:TakeDamage(Atwood.Damage * 0.016)
				
				-- Dano adicional ao mudar de direção (pontos de tensão máxima)
				if math.abs(math.sin(spiralAngle)) > 0.9 then
					humanoid:TakeDamage(Atwood.ContinuousDamage * 0.016)
				end
			else
				affectedTargets[targetObject] = nil
			end
		end

		task.wait(0.016) -- ~60 FPS
	end
end

return Atwood
