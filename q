-- Carrega o script Orion
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Lolsupss/Orion-library-do-eu/main/Purplessss'))()

local Window = OrionLib:MakeWindow({
    Name = "S333 Menu",
    HidePremium = false,
    IntroText = "S333 Menu",
    SaveConfig = true,
    ConfigFolder = "S333 Menu"
})

-- Definições de cor
local targetColor = Color3.fromRGB(255, 85, 0) -- Cor alvo (laranja)

-- Função para verificar se um NPC possui o `QuestTag.NameTitle` com a cor especificada
local function checkNpcColor(npc)
    local head = npc:FindFirstChild("Head")
    if head and head:FindFirstChild("QuestTag") and head.QuestTag:FindFirstChild("NameTitle") then
        local nameTitle = head.QuestTag.NameTitle
        if nameTitle.TextColor3 == targetColor then
            return true
        end
    end
    return false
end

-- Função para detectar NPCs
local function detectNpcs()
    local detectedNpcs = {}

    -- Percorre todos os NPCs em `workspace["Npc's"]`
    for _, npc in pairs(game:GetService("Workspace")["Npc's"]:GetChildren()) do
        if checkNpcColor(npc) then
            table.insert(detectedNpcs, npc)
            print("NPC com cor laranja detectado: " .. npc.Name)
        end
    end

    -- Notificação
    if #detectedNpcs > 0 then
        OrionLib:MakeNotification({
            Name = "NPCs Detectados",
            Content = "Foram encontrados " .. #detectedNpcs .. " NPCs com a cor laranja.",
            Time = 5
        })
    else
        OrionLib:MakeNotification({
            Name = "Nenhum NPC Encontrado",
            Content = "Nenhum NPC com a cor laranja foi detectado.",
            Time = 5
        })
    end
end

-- Criação do botão para detectar NPCs
Window:MakeButton({
    Name = "Detectar NPCs Laranjas",
    Callback = function()
        detectNpcs()
    end
})

-- Inicializa a interface do Orion
OrionLib:Init()
