-- ReplicatedStorage/Abilities/Galileu.lua
-- FÍSICA: Queda Livre e Movimento Retilíneo Uniformemente Variado (MRUV)
-- v² = v₀² + 2a×d (Equação de Torricelli)
-- d = v₀×t + ½×a×t² (Posição em função do tempo)
-- a = g (aceleração da gravidade = 9.8 m/s²)
-- Quanto maior a altura de queda, maior o dano!

local Galileu = {}

Galileu.Radius = 30
Galileu.Duration = 4
Galileu.GravityMultiplier = 2.5 -- Multiplica a gravidade normal (9.8)
Galileu.BaseDamage = 15
Galileu.MaxDamageFromHeight = 50 -- Dano máximo adicional por altura
Galileu.MinHeightForDamage = 5 -- Altura mínima para ganhar dano extra

local function getRoot(model)
	return model:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(model)
	return model:FindFirstChildOfClass("Humanoid")
end

-- Calcula dano baseado na altura de queda
-- Quanto mais alto cai, mais dano toma
-- Dano_extra = (altura / altura_máxima) × dano_máximo
local function calculateFallDamage(startHeight, currentHeight)
	local heightDifference = math.max(0, startHeight - currentHeight)
	
	if heightDifference < Galileu.MinHeightForDamage then
		return 0
	end
	
	-- Usa v² = 2×g×h para calcular velocidade de impacto
	local gravityAcceleration = 9.8 * Galileu.GravityMultiplier
	local impactVelocity = math.sqrt(2 * gravityAcceleration * heightDifference)
	
	-- Dano proporcional à velocidade de impacto
	local extraDamage = math.min(
		Galileu.MaxDamageFromHeight,
		(impactVelocity / 50) * Galileu.MaxDamageFromHeight
	)
	
	return extraDamage
end

function Galileu.Cast(caster, position)
	if not position then
		return
	end

	local affectedTargets = {}
	local startTime = os.clock()
	local initialHeights = {} -- Armazena altura inicial de cada alvo
	
	-- Primeira varredura: registra alturas iniciais
	for _, object in ipairs(workspace:GetChildren()) do
		if object:IsA("Model") and object ~= caster then
			local humanoid = getHumanoid(object)
			local root = getRoot(object)
			
			if humanoid and root and humanoid.Health > 0 then
				local distance = (root.Position - position).Magnitude
				
				if distance <= Galileu.Radius then
					affectedTargets[object] = true
					initialHeights[object] = root.Position.Y
				end
			end
		end
	end

	-- Aplica gravidade aumentada durante a duração
	while os.clock() - startTime < Galileu.Duration do
		for targetObject, _ in pairs(affectedTargets) do
			local humanoid = getHumanoid(targetObject)
			local root = getRoot(targetObject)

			if humanoid and root and humanoid.Health > 0 then
				-- Aumenta aceleração gravitacional
				local gravityAccel = Vector3.new(
					0,
					-9.8 * Galileu.GravityMultiplier,
					0
				)
				
				-- Aplica força adicional de queda
				root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + (gravityAccel * 0.016)
				
				-- Calcula dano por altura de queda
				local currentHeight = root.Position.Y
				local initialHeight = initialHeights[targetObject] or currentHeight
				local fallDamage = calculateFallDamage(initialHeight, currentHeight)
				
				-- Aplica dano base continuamente e dano extra por queda
				humanoid:TakeDamage(Galileu.BaseDamage * 0.016)
				
				if fallDamage > 0 then
					humanoid:TakeDamage(fallDamage * 0.016)
				end
			else
				affectedTargets[targetObject] = nil
			end
		end

		task.wait(0.016) -- ~60 FPS
	end
end

return Galileu
