-- StarterPlayer > StarterCharacterScripts > CombatHandler.lua
-- Sistema de combate que detecta inputs e ativa habilidades

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Carrega as habilidades
local Newton = require(ReplicatedStorage:WaitForChild("Abilities"):WaitForChild("Newton"))
local Galileu = require(ReplicatedStorage:WaitForChild("Abilities"):WaitForChild("Galileu"))
local Hooke = require(ReplicatedStorage:WaitForChild("Abilities"):WaitForChild("Hooke"))
local Atwood = require(ReplicatedStorage:WaitForChild("Abilities"):WaitForChild("Atwood"))

-- Stats do jogador
local playerStats = {
	MaxMana = 100,
	Mana = 100,
	ManaRegenRate = 15, -- por segundo
	Level = 1,
	Experience = 0,
}

-- Habilidades disponíveis
local abilities = {
	[Enum.KeyCode.Q] = {
		name = "Newton",
		manaCost = 20,
		cooldown = 2,
		isOnCooldown = false,
		ability = Newton,
	},
	[Enum.KeyCode.E] = {
		name = "Galileu",
		manaCost = 25,
		cooldown = 3,
		isOnCooldown = false,
		ability = Galileu,
	},
	[Enum.KeyCode.R] = {
		name = "Hooke",
		manaCost = 22,
		cooldown = 2.5,
		isOnCooldown = false,
		ability = Hooke,
	},
	[Enum.KeyCode.T] = {
		name = "Atwood",
		manaCost = 30,
		cooldown = 3.5,
		isOnCooldown = false,
		ability = Atwood,
	},
}

-- Regenera mana continuamente
local manaRegenConnection
manaRegenConnection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
	if playerStats.Mana < playerStats.MaxMana then
		playerStats.Mana = math.min(
			playerStats.MaxMana,
			playerStats.Mana + (playerStats.ManaRegenRate * deltaTime)
		)
	end
end)

-- Função para ativar uma habilidade
local function castAbility(abilityData)
	-- Verifica se tem mana suficiente
	if playerStats.Mana < abilityData.manaCost then
		print("❌ Mana insuficiente! Precisa de " .. abilityData.manaCost .. " de mana")
		return
	end
	
	-- Verifica se está em cooldown
	if abilityData.isOnCooldown then
		print("⏳ Habilidade " .. abilityData.name .. " está em cooldown!")
		return
	end
	
	-- Gasta mana
	playerStats.Mana = math.max(0, playerStats.Mana - abilityData.manaCost)
	
	-- Executa a habilidade
	print("⚡ Ativando " .. abilityData.name .. "! Custo de mana: " .. abilityData.manaCost)
	abilityData.ability.Cast(character, rootPart.Position)
	
	-- Inicia cooldown
	abilityData.isOnCooldown = true
	task.wait(abilityData.cooldown)
	abilityData.isOnCooldown = false
	print("✅ " .. abilityData.name .. " pronto!")
end

-- Detecta input do jogador
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	local abilityData = abilities[input.KeyCode]
	if abilityData then
		castAbility(abilityData)
	end
end)

-- Atualiza UI de mana (opcional)
task.spawn(function()
	while humanoid.Health > 0 do
		-- Aqui você pode atualizar uma GUI com os stats
		-- print(string.format("Mana: %.1f / %.1f", playerStats.Mana, playerStats.MaxMana))
		task.wait(0.1)
	end
end)

-- Limpa conexão ao morrer
humanoid.Died:Connect(function()
	manaRegenConnection:Disconnect()
end)

print("🎮 Combat Handler carregado!")
