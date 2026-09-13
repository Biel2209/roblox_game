# 🎮 Roblox Physics RPG - Trabalho de Física

Um jogo RPG estilo **Blox Fruits** para Roblox com **6 frutos/poderes** baseados em **conceitos de Física**.

## 📚 Conceitos de Física Implementados

### **1. Tesla** ⚡ (Condução Elétrica em Cadeia)
- **Conceito**: Transferência de energia entre objetos
- **Mecânica**: Salta de um inimigo para outro em cadeia
- **Física Aplicada**: Propagação de energia, raio de ação

### **2. Einstein** 🌌 (Gravitação Universal)
- **Conceito**: Lei da Gravitação Universal
- **Fórmula**: `F = G × (m1 × m2) / d²`
- **Mecânica**: Puxa todos os inimigos para o centro
- **Efeito**: Inimigos são atraídos continuamente durante 3 segundos

### **3. Marie Curie** ☢️ (Radiação Contínua)
- **Conceito**: Decaimento radioativo e energia contínua
- **Mecânica**: Dano-over-time em área
- **Física Aplicada**: Emissão de energia sustentada

### **4. Newton** 💥 (Lei da Ação e Reação)
- **Conceito**: 3ª Lei de Newton
- **Fórmula**: `p = m × v` (Conservação do Momentum)
- **Mecânica**: Lança inimigos com impulso proporcional à força
- **Efeito**: Quanto mais força aplica, mais velocidade o inimigo ganha

### **5. Galileu** 📉 (Queda Livre e MRUV)
- **Conceito**: Movimento Retilíneo Uniformemente Variado
- **Fórmula**: `v² = v₀² + 2a×d` (Equação de Torricelli)
- **Mecânica**: Aumenta a gravidade, inimigos caem mais rápido
- **Efeito**: Dano aumenta proporcionalmente à altura de queda

### **6. Hooke** 🔄 (Lei de Hooke e Movimento Harmônico Simples)
- **Conceito**: Elasticidade e MHS
- **Fórmula**: `F = -k × x` (Força restauradora)
- **Mecânica**: Cria zona elástica que puxa/empurra em movimento oscilatório
- **Efeito**: Inimigos ficam presos em movimento de vai-e-vem

### **7. Atwood** ⚖️ (Máquina de Atwood)
- **Conceito**: Sistema de polias com massas diferentes
- **Fórmula**: `a = (m1 - m2) / (m1 + m2) × g`
- **Mecânica**: Alguns inimigos sobem, outros descem simultaneamente
- **Efeito**: Aceleração diferenciada baseada em "massa"

---

## 🎮 Como Usar

### **Instalação**
1. Clone o repositório
2. Coloque os scripts em suas pastas corretas no Roblox Studio
3. As habilidades devem estar em `ReplicatedStorage/Abilities/`

### **Controles de Combate**
| Tecla | Habilidade | Mana | Cooldown |
|-------|-----------|------|----------|
| **Q** | Newton (Impulso) | 20 | 2s |
| **E** | Galileu (Queda Livre) | 25 | 3s |
| **R** | Hooke (Elasticidade) | 22 | 2.5s |
| **T** | Atwood (Sistema de Polias) | 30 | 3.5s |

### **Sistema de Mana**
- Mana máxima: **100**
- Regeneração: **15 por segundo**
- Cada habilidade consome mana conforme tabela acima

---

## 📁 Estrutura de Arquivos

```
roblox_game/
├── Tesla.lua                 # Habilidade de cadeia elétrica
├── Einstein.lua              # Atração gravitacional
├── Marie Curie.lua           # Dano radiativo contínuo
├── Newton.lua                # Impulso e conservação de momentum
├── Galileu.lua               # Queda livre com dano por altura
├── Hooke.lua                 # Oscilação elástica (MHS)
├── Atwood.lua                # Sistema de polias
├── CombatHandler.lua         # Sistema de combate (input + mana)
├── CombatUI.lua              # Interface visual (mana bar + abilities)
├── movimentação.lua          # Sistema de movimento do jogador
├── player_movimentação.lua   # Extensão do sistema de movimento
├── direção.lua               # Controle de direção
└── README.md                 # Este arquivo
```

---

## ⚙️ Instalação no Roblox Studio

### **Passo 1: Criar Estrutura de Pastas**
1. Em `ReplicatedStorage`, crie uma pasta `Abilities`
2. Coloque todos os scripts de habilidades lá (Tesla, Einstein, etc.)

### **Passo 2: Adicionar CombatHandler**
1. Vá para `StarterPlayer` > `StarterCharacterScripts`
2. Insira o `CombatHandler.lua` lá

### **Passo 3: Adicionar CombatUI**
1. Vá para `StarterGui`
2. Insira o `CombatUI.lua` como `LocalScript`

### **Passo 4: Testar**
1. Pressione Play no Studio
2. Use Q, E, R, T para ativar as habilidades
3. Observe a barra de mana e cooldowns na tela

---

## 📊 Fórmulas Físicas Utilizadas

| Conceito | Fórmula | Aplicação |
|----------|---------|-----------|
| **Momentum** | `p = m × v` | Newton (impulso) |
| **Cinemática** | `v² = v₀² + 2a×d` | Galileu (queda livre) |
| **Lei de Hooke** | `F = -k × x` | Hooke (elasticidade) |
| **Aceleração (Atwood)** | `a = (m1-m2)/(m1+m2) × g` | Atwood (polias) |
| **Gravitação Universal** | `F = G × (m1×m2) / d²` | Einstein (atração) |
| **MHS** | `x(t) = A × cos(ωt + φ)` | Hooke (oscilação) |

---

## 🎯 Objetivos do Projeto

✅ Implementar 4+ habilidades com física realista
✅ Sistema de mana e cooldown
✅ Interface visual de combate
✅ Movimento do jogador integrado
✅ Dano baseado em cálculos físicos
✅ Documentação completa

---

## 👥 Créditos

- **Jorge Felipe** (jorgefelipe0203u-cloud) - Desenvolvimento
- **Biel** (Biel2209) - Desenvolvimento

---

## 📝 Notas

Este é um **trabalho de física** para fins educacionais, demonstrando como conceitos reais de física podem ser aplicados em um jogo interativo.

**Divirta-se aprendendo física com combate! ⚡🌌💥**
