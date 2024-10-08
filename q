-- Inicializa o Orion Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Cria uma nova janela
local Window = OrionLib:MakeWindow({Name = "Contador de NPCs", HidePremium = false})

-- Função para contar NPCs com a cor especificada
local function countNpcColor()
    local targetColor = Color3.fromRGB(255, 85, 0)
    local count = 0

    -- Função para verificar a cor de cada NPC
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

    -- Percorre todos os NPCs em `workspace["Npc's"]`
    for _, npc in pairs(game:GetService("Workspace")["Npc's"]:GetChildren()) do
        if checkNpcColor(npc) then
            count = count + 1
        end
    end

    return count
end

-- Cria um botão na janela
local Button = Window:MakeButton({
    Name = "Contar NPCs Laranja",
    Callback = function()
        local totalNpcs = countNpcColor()
        OrionLib:MakeNotification({
            Name = "Contagem de NPCs",
            Content = "Total de NPCs com a cor laranja: " .. totalNpcs,
            Time = 5
        })
    end
})

-- Exibe a interface
OrionLib:Init()

