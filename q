-- Requer a Orion Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Configuração da interface
local Window = OrionLib:MakeWindow({
    Name = "NPC Teleport Menu",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionNPC"
})

-- Aba principal
local MainTab = Window:MakeTab({
    Name = "Teleporte NPC",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Serviço para tweening
local TweenService = game:GetService("TweenService")

-- Definindo as pastas dos NPCs
local npcFolders = {
    game:GetService("Workspace")["Npc's"],
    game:GetService("Workspace")["Npc's_2"]
}

-- Cor alvo para verificação (RGB: 255, 85, 0)
local targetColor = Color3.fromRGB(255, 85, 0)

-- Variável para contar a quantidade de NPCs com a condição desejada
local npcCount = 0
local validNPCs = {}  -- Tabela para armazenar os NPCs que atendem aos requisitos

-- Função para verificar se um NPC possui NameTitle dentro de QuestTag e a cor desejada
local function checkNameTitleWithColor(npc)
    -- Verifica se o NPC possui um objeto chamado 'Head'
    local head = npc:FindFirstChild("Head")
    if head then
        -- Verifica se 'Head' possui um objeto chamado 'QuestTag'
        local questTag = head:FindFirstChild("QuestTag")
        if questTag then
            -- Verifica se 'QuestTag' possui um objeto chamado 'NameTitle'
            local nameTitle = questTag:FindFirstChild("NameTitle")
            if nameTitle then
                -- Verifica se NameTitle possui a propriedade de cor (exemplo: TextColor3)
                if nameTitle:IsA("TextLabel") and nameTitle.TextColor3 == targetColor then
                    return true
                elseif nameTitle:IsA("Frame") and nameTitle.BackgroundColor3 == targetColor then
                    return true
                end
            end
        end
    end
    return false
end

-- Função para iterar por todos os NPCs nas pastas especificadas e atualizar o contador
local function detectNPCsAndCount()
    npcCount = 0  -- Reseta a contagem inicial
    validNPCs = {}  -- Reseta a lista de NPCs válidos

    for _, folder in pairs(npcFolders) do
        -- Verifica se a pasta existe
        if folder then
            -- Itera por cada NPC na pasta
            for _, npc in pairs(folder:GetChildren()) do
                -- Verifica se é um modelo e se possui a tag 'NameTitle' com a cor especificada
                if npc:IsA("Model") and checkNameTitleWithColor(npc) then
                    npcCount = npcCount + 1  -- Incrementa a contagem
                    table.insert(validNPCs, npc)  -- Adiciona o NPC à lista de NPCs válidos
                end
            end
        end
    end
    return npcCount
end

-- Função para teleportar suavemente para um NPC
local function smoothTeleport(player, targetPosition)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = character.HumanoidRootPart

        -- Define a propriedade de Tween (posição final)
        local tweenInfo = TweenInfo.new(
            1,  -- Duração: 1 segundo para completar o teleporte
            Enum.EasingStyle.Linear,  -- Estilo de interpolação linear
            Enum.EasingDirection.InOut,  -- Direção
            0,  -- Repetições: 0 (não repete)
            false,  -- Reverso: false (não reverte)
            0  -- Atraso: 0 segundos
        )

        -- Cria o Tween com a posição alvo
        local tweenGoal = { CFrame = CFrame.new(targetPosition) }
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

        -- Inicia o Tween
        tween:Play()
    end
end

-- Função para teleportar para cada NPC válido suavemente
local function teleportToValidNPCs()
    local player = game.Players.LocalPlayer
    for _, npc in pairs(validNPCs) do
        -- Verifica se o NPC possui um PrimaryPart para teleporte
        if npc.PrimaryPart then
            -- Calcula a posição alvo acima do NPC
            local targetPosition = npc.PrimaryPart.Position + Vector3.new(0, 5, 0)  -- Adiciona 5 unidades de altura para evitar sobreposição

            -- Realiza o teleporte suave para a posição alvo
            smoothTeleport(player, targetPosition)
            wait(1.5)  -- Espera 1,5 segundos para completar o Tween antes de mover para o próximo NPC
        end
    end
end

-- Botão para contar os NPCs válidos e mostrar a quantidade
MainTab:AddButton({
    Name = "Contar NPCs Válidos",
    Callback = function()
        -- Atualiza a contagem de NPCs válidos
        local count = detectNPCsAndCount()
        -- Exibe a contagem no console (pode ser adaptado para GUI dentro do Orion)
        print("Quantidade de NPCs com a cor desejada: " .. count)
        -- Mensagem na Orion para notificar
        OrionLib:MakeNotification({
            Name = "Contagem NPCs",
            Content = "Quantidade de NPCs válidos: " .. count,
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end    
})

-- Botão para teleportar para NPCs válidos
MainTab:AddButton({
    Name = "Teleportar para NPCs",
    Callback = function()
        -- Executa o teleporte para os NPCs válidos
        teleportToValidNPCs()
    end
})

-- Inicializa a interface
OrionLib:Init()
