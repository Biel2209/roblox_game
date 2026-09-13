-- StarterGui > CombatUI.lua
-- Interface visual de combate mostrando Mana, Habilidades e Cooldowns

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cria ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ==================== MANA BAR ====================
local manaContainer = Instance.new("Frame")
manaContainer.Name = "ManaContainer"
manaContainer.Size = UDim2.new(0, 300, 0, 50)
manaContainer.Position = UDim2.new(0.5, -150, 1, -70)
manaContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
manaContainer.BorderSizePixel = 0
manaContainer.Parent = screenGui

local manaLabel = Instance.new("TextLabel")
manaLabel.Name = "ManaLabel"
manaLabel.Size = UDim2.new(1, 0, 0, 25)
manaLabel.BackgroundTransparency = 1
manaLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
manaLabel.TextSize = 16
manaLabel.Font = Enum.Font.GothamBold
manaLabel.Text = "MANA"
manaLabel.Parent = manaContainer

local manaBar = Instance.new("Frame")
manaBar.Name = "ManaBar"
manaBar.Size = UDim2.new(1, 0, 0, 20)
manaBar.Position = UDim2.new(0, 0, 0, 25)
manaBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
manaBar.BorderSizePixel = 0
manaBar.Parent = manaContainer

local manaFill = Instance.new("Frame")
manaFill.Name = "ManaFill"
manaFill.Size = UDim2.new(1, 0, 1, 0)
manaFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
manaFill.BorderSizePixel = 0
manaFill.Parent = manaBar

-- ==================== HABILIDADES ====================
local abilitiesContainer = Instance.new("Frame")
abilitiesContainer.Name = "AbilitiesContainer"
abilitiesContainer.Size = UDim2.new(0, 400, 0, 120)
abilitiesContainer.Position = UDim2.new(0.5, -200, 1, -210)
abilitiesContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
abilitiesContainer.BorderSizePixel = 0
abilitiesContainer.Parent = screenGui

local abilitiesLabel = Instance.new("TextLabel")
abilitiesLabel.Name = "AbilitiesLabel"
abilitiesLabel.Size = UDim2.new(1, 0, 0, 20)
abilitiesLabel.BackgroundTransparency = 1
abilitiesLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
abilitiesLabel.TextSize = 14
abilitiesLabel.Font = Enum.Font.GothamBold
abilitiesLabel.Text = "HABILIDADES (Pressione Q, E, R, T)"
abilitiesLabel.Parent = abilitiesContainer

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = abilitiesContainer
listLayout.Padding = UDim.new(0, 5)
listLayout.FillDirection = Enum.FillDirection.Horizontal

-- Dados das habilidades
local abilityData = {
	{
		key = "Q",
		name = "NEWTON",
		mana = 20,
		cooldown = 2,
		color = Color3.fromRGB(255, 100, 100),
		description = "Impulso e Reação"
	},
	{
		key = "E",
		name = "GALILEU",
		mana = 25,
		cooldown = 3,
		color = Color3.fromRGB(100, 255, 100),
		description = "Queda Livre"
	},
	{
		key = "R",
		name = "HOOKE",
		mana = 22,
		cooldown = 2.5,
		color = Color3.fromRGB(100, 100, 255),
		description = "Oscilação Elástica"
	},
	{
		key = "T",
		name = "ATWOOD",
		mana = 30,
		cooldown = 3.5,
		color = Color3.fromRGB(255, 100, 255),
		description = "Sistema de Polias"
	},
}

-- Cria cards de habilidades
local abilityCards = {}
for _, ability in ipairs(abilityData) do
	local card = Instance.new("Frame")
	card.Name = ability.name
	card.Size = UDim2.new(0, 85, 0, 95)
	card.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	card.BorderSizePixel = 1
	card.BorderColor3 = ability.color
	card.Parent = abilitiesContainer
	
	-- Tecla
	local keyLabel = Instance.new("TextLabel")
	keyLabel.Size = UDim2.new(1, 0, 0, 20)
	keyLabel.BackgroundColor3 = ability.color
	keyLabel.BorderSizePixel = 0
	keyLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	keyLabel.TextSize = 14
	keyLabel.Font = Enum.Font.GothamBold
	keyLabel.Text = ability.key
	keyLabel.Parent = card
	
	-- Nome
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0, 20)
	nameLabel.Position = UDim2.new(0, 0, 0, 20)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = ability.color
	nameLabel.TextSize = 10
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Text = ability.name
	nameLabel.TextWrapped = true
	nameLabel.Parent = card
	
	-- Mana Cost
	local manaLabel = Instance.new("TextLabel")
	manaLabel.Size = UDim2.new(1, 0, 0, 15)
	manaLabel.Position = UDim2.new(0, 0, 0, 40)
	manaLabel.BackgroundTransparency = 1
	manaLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
	manaLabel.TextSize = 9
	manaLabel.Font = Enum.Font.Gotham
	manaLabel.Text = "Mana: " .. ability.mana
	manaLabel.Parent = card
	
	-- Cooldown
	local cooldownLabel = Instance.new("TextLabel")
	cooldownLabel.Name = "CooldownLabel"
	cooldownLabel.Size = UDim2.new(1, 0, 0, 15)
	cooldownLabel.Position = UDim2.new(0, 0, 0, 55)
	cooldownLabel.BackgroundTransparency = 1
	cooldownLabel.TextColor3 = Color3.fromRGB(200, 100, 100)
	cooldownLabel.TextSize = 9
	cooldownLabel.Font = Enum.Font.Gotham
	cooldownLabel.Text = "Cooldown: " .. ability.cooldown .. "s"
	cooldownLabel.Parent = card
	
	-- Status (Ready/Cooldown)
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(1, 0, 0, 15)
	statusLabel.Position = UDim2.new(0, 0, 0, 70)
	statusLabel.BackgroundTransparency = 1
	statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	statusLabel.TextSize = 10
	statusLabel.Font = Enum.Font.GothamBold
	statusLabel.Text = "✓ PRONTO"
	statusLabel.Parent = card
	
	table.insert(abilityCards, {
		card = card,
		statusLabel = statusLabel,
		ability = ability,
		onCooldown = false,
		cooldownRemaining = 0
	})
end

-- ==================== ATUALIZAÇÃO DA UI ====================
RunService.Heartbeat:Connect(function()
	local character = player.Character
	if not character then return end
	
	-- Atualiza barra de mana (você precisará passar os dados do CombatHandler)
	-- Por enquanto, simulamos
	local manaPercent = 0.75 -- Simular 75% de mana
	manaFill.Size = UDim2.new(manaPercent, 0, 1, 0)
	manaLabel.Text = string.format("MANA: %.0f / 100", manaPercent * 100)
	
	-- Atualiza status de cooldown
	for _, cardData in ipairs(abilityCards) do
		if cardData.onCooldown then
			cardData.cooldownRemaining = math.max(0, cardData.cooldownRemaining - (1/60))
			if cardData.cooldownRemaining <= 0 then
				cardData.onCooldown = false
				cardData.statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
				cardData.statusLabel.Text = "✓ PRONTO"
			else
				cardData.statusLabel.TextColor3 = Color3.fromRGB(200, 100, 100)
				cardData.statusLabel.Text = string.format("%.1f s", cardData.cooldownRemaining)
			end
		end
	end
end)

-- ==================== SIMULAÇÃO DE COOLDOWN ====================
-- (Conectar com o CombatHandler real para sincronizar)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	for _, cardData in ipairs(abilityCards) do
		if input.KeyCode == Enum.KeyCode[cardData.ability.key] then
			if not cardData.onCooldown then
				cardData.onCooldown = true
				cardData.cooldownRemaining = cardData.ability.cooldown
			end
		end
	end
end)

print("🎮 Combat UI carregado!")
