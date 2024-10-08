local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local targetColor = Color3.fromRGB(255, 85, 0) -- Define a cor alvo (laranja)

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

-- Cria uma lista para armazenar NPCs detectados
local detectedNpcs = {}

-- Percorre todos os NPCs em `workspace["Npc's"]`
for _, npc in pairs(game:GetService("Workspace")["Npc's"]:GetChildren()) do
    if checkNpcColor(npc) then
        table.insert(detectedNpcs, npc)
        print("NPC com cor laranja detectado: " .. npc.Name)
    end
end

-- Se desejar, você pode fazer algo com a lista de NPCs detectados
if #detectedNpcs > 0 then
    -- Por exemplo, exibir um aviso na interface do Orion
    OrionLib:MakeNotification({
        Name = "NPCs Detectados",
        Content = "Foram encontrados " .. #detectedNpcs .. " NPCs com a cor laranja.",
        Time = 5
    })
end
