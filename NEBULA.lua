--[[
    NEBULA HUB - Vox Seas
    Desenvolvido para Delta Executor
    Versão: 1.0.0
    Estado: Projeto funcional com documentação
]]

-- Módulo principal do NEBULA HUB
local NebulaHub = {}
NebulaHub.__index = NebulaHub

-- Configurações padrão
local Config = {
    Theme = {
        Background = Color3.fromRGB(15, 15, 35),
        Primary = Color3.fromRGB(100, 50, 200),
        Secondary = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(200, 100, 255)
    },
    Settings = {
        DarkMode = true,
        NeonEffects = true,
        CompactMode = false,
        AutoSave = true
    }
}

-- Cache de serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Função para criar interface (UI)
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NebulaHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Config.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Efeito neon
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Config.Theme.Primary
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    Title.Text = "NEBULA HUB"
    Title.TextColor3 = Config.Theme.Accent
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.BorderSizePixel = 0
    Title.Parent = MainFrame
    
    -- Botão fechar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    CloseButton.Parent = MainFrame
    
    -- Botão minimizar
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
    MinimizeButton.BackgroundColor3 = Config.Theme.Secondary
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 16
    MinimizeButton.Parent = MainFrame
    
    -- Painel lateral para abas
    local SidePanel = Instance.new("Frame")
    SidePanel.Name = "SidePanel"
    SidePanel.Size = UDim2.new(0, 120, 1, -40)
    SidePanel.Position = UDim2.new(0, 0, 0, 40)
    SidePanel.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    SidePanel.BorderSizePixel = 0
    SidePanel.Parent = MainFrame
    
    -- Container de abas
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 4
    TabContainer.Parent = SidePanel
    
    -- Container de conteúdo
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -120, 1, -40)
    ContentFrame.Position = UDim2.new(0, 120, 0, 40)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    -- Lista de abas
    local Tabs = {
        {"FARM", "Farm"},
        {"FRUIT", "Fruit"},
        {"ESP", "ESP"},
        {"COMBAT", "Combat"},
        {"TELEPORT", "Teleport"},
        {"QUEST", "Quest"},
        {"PLAYER", "Player"},
        {"SETTINGS", "Settings"}
    }
    
    -- Criar abas
    for i, tab in ipairs(Tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tab[1] .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Position = UDim2.new(0, 0, 0, (i-1) * 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        TabButton.Text = tab[1]
        TabButton.TextColor3 = Config.Theme.Text
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        -- Efeito hover
        TabButton.MouseEnter:Connect(function()
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Config.Theme.Primary}):Play()
        end)
        
        TabButton.MouseLeave:Connect(function()
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 50)}):Play()
        end)
        
        -- Função para trocar de aba
        TabButton.MouseButton1Click:Connect(function()
            -- Limpar conteúdo
            for _, child in ipairs(ContentFrame:GetChildren()) do
                if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                    child:Destroy()
                end
            end
            
            -- Criar conteúdo da aba
            if tab[2] == "Farm" then
                createFarmTab(ContentFrame)
            elseif tab[2] == "Fruit" then
                createFruitTab(ContentFrame)
            elseif tab[2] == "ESP" then
                createESPTab(ContentFrame)
            elseif tab[2] == "Combat" then
                createCombatTab(ContentFrame)
            elseif tab[2] == "Teleport" then
                createTeleportTab(ContentFrame)
            elseif tab[2] == "Quest" then
                createQuestTab(ContentFrame)
            elseif tab[2] == "Player" then
                createPlayerTab(ContentFrame)
            elseif tab[2] == "Settings" then
                createSettingsTab(ContentFrame)
            end
        end)
    end
    
    -- Funções dos botões
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            MinimizeButton.Text = "-"
        else
            MinimizeButton.Text = "+"
        end
    end)
    
    return MainFrame
end

-- Função para criar aba de Farm
local function createFarmTab(parent)
    local FarmFrame = Instance.new("ScrollingFrame")
    FarmFrame.Size = UDim2.new(1, 0, 1, 0)
    FarmFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    FarmFrame.BorderSizePixel = 0
    FarmFrame.Parent = parent
    
    -- Título da seção
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 0, 30)
    SectionTitle.Position = UDim2.new(0, 0, 0, 10)
    SectionTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    SectionTitle.Text = "⚡ AUTO FARM"
    SectionTitle.TextColor3 = Config.Theme.Accent
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.Parent = FarmFrame
    
    -- Auto Farm Level toggle
    local AutoFarmLevel = createToggle(FarmFrame, "Auto Farm Level", UDim2.new(0, 10, 0, 50))
    AutoFarmLevel.ValueChanged:Connect(function(value)
        if value then
            -- Implementação do auto farm level
            startAutoFarmLevel()
        else
            stopAutoFarmLevel()
        end
    end)
    
    -- Auto Quest toggle
    local AutoQuest = createToggle(FarmFrame, "Auto Quest", UDim2.new(0, 10, 0, 90))
    AutoQuest.ValueChanged:Connect(function(value)
        if value then
            startAutoQuest()
        else
            stopAutoQuest()
        end
    end)
    
    -- Seleção de inimigos
    local EnemyLabel = Instance.new("TextLabel")
    EnemyLabel.Size = UDim2.new(0, 200, 0, 20)
    EnemyLabel.Position = UDim2.new(0, 10, 0, 130)
    EnemyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    EnemyLabel.Text = "🎯 Selecionar Inimigo:"
    EnemyLabel.TextColor3 = Config.Theme.Text
    EnemyLabel.TextSize = 12
    EnemyLabel.Parent = FarmFrame
    
    local EnemyDropdown = Instance.new("TextButton")
    EnemyDropdown.Size = UDim2.new(0, 200, 0, 25)
    EnemyDropdown.Position = UDim2.new(0, 10, 0, 155)
    EnemyDropdown.BackgroundColor3 = Config.Theme.Primary
    EnemyDropdown.Text = "Selecione..."
    EnemyDropdown.TextColor3 = Config.Theme.Text
    EnemyDropdown.TextSize = 12
    EnemyDropdown.Parent = FarmFrame
    
    -- Lista de inimigos conhecidos do Vox Seas
    local enemies = {
        "Pirata Básico",
        "Marinheiro",
        "Capitão Pirata",
        "Bandido",
        "Mercenário",
        "Guarda Real"
    }
    
    -- Criar menu dropdown
    EnemyDropdown.MouseButton1Click:Connect(function()
        -- Criar menu de seleção
        local Menu = Instance.new("Frame")
        Menu.Size = UDim2.new(0, 200, 0, 120)
        Menu.Position = UDim2.new(0, 10, 0, 185)
        Menu.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        Menu.BorderSizePixel = 1
        Menu.BorderColor3 = Config.Theme.Primary
        Menu.Parent = FarmFrame
        
        for i, enemy in ipairs(enemies) do
            local EnemyButton = Instance.new("TextButton")
            EnemyButton.Size = UDim2.new(1, 0, 0, 25)
            EnemyButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
            EnemyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
            EnemyButton.Text = enemy
            EnemyButton.TextColor3 = Config.Theme.Text
            EnemyButton.TextSize = 11
            EnemyButton.Parent = Menu
            
            EnemyButton.MouseButton1Click:Connect(function()
                EnemyDropdown.Text = enemy
                Menu:Destroy()
            end)
        end
    end)
    
    -- Configuração de distância
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Size = UDim2.new(0, 200, 0, 20)
    DistanceLabel.Position = UDim2.new(0, 10, 0, 220)
    DistanceLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    DistanceLabel.Text = "📏 Distância Máxima:"
    DistanceLabel.TextColor3 = Config.Theme.Text
    DistanceLabel.TextSize = 12
    DistanceLabel.Parent = FarmFrame
    
    local DistanceSlider = Instance.new("Frame")
    DistanceSlider.Size = UDim2.new(0, 200, 0, 20)
    DistanceSlider.Position = UDim2.new(0, 10, 0, 245)
    DistanceSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    DistanceSlider.Parent = FarmFrame
    
    local DistanceValue = Instance.new("TextLabel")
    DistanceValue.Size = UDim2.new(0, 50, 0, 20)
    DistanceValue.Position = UDim2.new(1, -55, 0, 0)
    DistanceValue.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    DistanceValue.Text = "50"
    DistanceValue.TextColor3 = Config.Theme.Text
    DistanceValue.TextSize = 12
    DistanceValue.Parent = DistanceSlider
    
    -- Pausar/Retomar
    local PauseButton = createButton(FarmFrame, "⏸ Pausar", UDim2.new(0, 10, 0, 280))
    local ResumeButton = createButton(FarmFrame, "▶ Retomar", UDim2.new(0, 110, 0, 280))
    
    return FarmFrame
end

-- Função para criar toggle
local function createToggle(parent, text, position)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 200, 0, 30)
    ToggleFrame.Position = position
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    ToggleFrame.Parent = parent
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0, 150, 0, 30)
    ToggleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Config.Theme.Text
    ToggleLabel.TextSize = 12
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -45, 0, 5)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Config.Theme.Text
    ToggleButton.TextSize = 10
    ToggleButton.Parent = ToggleFrame
    
    local value = false
    ToggleButton.MouseButton1Click:Connect(function()
        value = not value
        if value then
            ToggleButton.BackgroundColor3 = Config.Theme.Primary
            ToggleButton.Text = "ON"
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            ToggleButton.Text = "OFF"
        end
        ToggleFrame.ValueChanged:Fire(value)
    end)
    
    ToggleFrame.ValueChanged = Instance.new("BindableEvent")
    ToggleFrame.Value = value
    
    return ToggleFrame
end

-- Função para criar botão
local function createButton(parent, text, position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 90, 0, 25)
    Button.Position = position
    Button.BackgroundColor3 = Config.Theme.Primary
    Button.Text = text
    Button.TextColor3 = Config.Theme.Text
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamMedium
    Button.BorderSizePixel = 0
    Button.Parent = parent
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Config.Theme.Secondary}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Config.Theme.Primary}):Play()
    end)
    
    return Button
end

-- Função para criar aba de Fruit
local function createFruitTab(parent)
    local FruitFrame = Instance.new("ScrollingFrame")
    FruitFrame.Size = UDim2.new(1, 0, 1, 0)
    FruitFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    FruitFrame.BorderSizePixel = 0
    FruitFrame.Parent = parent
    
    -- Título
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 0, 30)
    SectionTitle.Position = UDim2.new(0, 0, 0, 10)
    SectionTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    SectionTitle.Text = "🍎 FRUIT SYSTEM"
    SectionTitle.TextColor3 = Config.Theme.Accent
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.Parent = FruitFrame
    
    -- Fruit ESP toggle
    local FruitESP = createToggle(FruitFrame, "Fruit ESP", UDim2.new(0, 10, 0, 50))
    FruitESP.ValueChanged:Connect(function(value)
        if value then
            enableFruitESP()
        else
            disableFruitESP()
        end
    end)
    
    -- Auto Collect toggle
    local AutoCollect = createToggle(FruitFrame, "Auto Collect Fruit", UDim2.new(0, 10, 0, 90))
    AutoCollect.ValueChanged:Connect(function(value)
        if value then
            startAutoCollect()
        else
            stopAutoCollect()
        end
    end)
    
    -- Lista de frutas conhecidas
    local FruitLabel = Instance.new("TextLabel")
    FruitLabel.Size = UDim2.new(0, 200, 0, 20)
    FruitLabel.Position = UDim2.new(0, 10, 0, 130)
    FruitLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    FruitLabel.Text = "📜 Frutas Disponíveis:"
    FruitLabel.TextColor3 = Config.Theme.Text
    FruitLabel.TextSize = 12
    FruitLabel.Parent = FruitFrame
    
    -- Lista de frutas do Vox Seas
    local fruits = {
        {"Gomu Gomu", "Comum"},
        {"Mera Mera", "Rara"},
        {"Goro Goro", "Épica"},
        {"Yami Yami", "Lendária"},
        {"Pika Pika", "Épica"},
        {"Hie Hie", "Rara"}
    }
    
    -- Criar lista de frutas
    for i, fruit in ipairs(fruits) do
        local FruitButton = Instance.new("TextButton")
        FruitButton.Size = UDim2.new(0, 200, 0, 25)
        FruitButton.Position = UDim2.new(0, 10, 0, 155 + (i-1) * 30)
        FruitButton.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        FruitButton.Text = fruit[1] .. " [" .. fruit[2] .. "]"
        FruitButton.TextColor3 = Config.Theme.Text
        FruitButton.TextSize = 11
        FruitButton.Parent = FruitFrame
        
        -- Cor por raridade
        if fruit[2] == "Comum" then
            FruitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        elseif fruit[2] == "Rara" then
            FruitButton.TextColor3 = Color3.fromRGB(0, 150, 255)
        elseif fruit[2] == "Épica" then
            FruitButton.TextColor3 = Color3.fromRGB(200, 100, 255)
        elseif fruit[2] == "Lendária" then
            FruitButton.TextColor3 = Color3.fromRGB(255, 200, 0)
        end
    end
    
    -- Histórico de frutas
    local HistoryLabel = Instance.new("TextLabel")
    HistoryLabel.Size = UDim2.new(0, 200, 0, 20)
    HistoryLabel.Position = UDim2.new(0, 10, 0, 335)
    HistoryLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    HistoryLabel.Text = "📊 Histórico:"
    HistoryLabel.TextColor3 = Config.Theme.Text
    HistoryLabel.TextSize = 12
    HistoryLabel.Parent = FruitFrame
    
    return FruitFrame
end

-- Função para criar aba de ESP
local function createESPTab(parent)
    local ESPFrame = Instance.new("ScrollingFrame")
    ESPFrame.Size = UDim2.new(1, 0, 1, 0)
    ESPFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    ESPFrame.BorderSizePixel = 0
    ESPFrame.Parent = parent
    
    -- Título
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 0, 30)
    SectionTitle.Position = UDim2.new(0, 0, 0, 10)
    SectionTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    SectionTitle.Text = "👁 ESP SYSTEM"
    SectionTitle.TextColor3 = Config.Theme.Accent
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.Parent = ESPFrame
    
    -- ESP toggles
    local NPCEsp = createToggle(ESPFrame, "NPC ESP", UDim2.new(0, 10, 0, 50))
    local IslandEsp = createToggle(ESPFrame, "Island ESP", UDim2.new(0, 10, 0, 90))
    local FruitEsp = createToggle(ESPFrame, "Fruit ESP", UDim2.new(0, 10, 0, 130))
    local BossEsp = createToggle(ESPFrame, "Boss ESP", UDim2.new(0, 10, 0, 170))
    local QuestEsp = createToggle(ESPFrame, "Quest ESP", UDim2.new(0, 10, 0, 210))
    local PlayerEsp = createToggle(ESPFrame, "Player ESP", UDim2.new(0, 10, 0, 250))
    
    -- Mostrar nomes
    local ShowNames = createToggle(ESPFrame, "Mostrar Nomes", UDim2.new(0, 10, 0, 290))
    
    -- Mostrar distância
    local ShowDistance = createToggle(ESPFrame, "Mostrar Distância", UDim2.new(0, 10, 0, 330))
    
    -- Personalização de cores
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Size = UDim2.new(0, 200, 0, 20)
    ColorLabel.Position = UDim2.new(0, 10, 0, 370)
    ColorLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    ColorLabel.Text = "🎨 Cores do ESP:"
    ColorLabel.TextColor3 = Config.Theme.Text
    ColorLabel.TextSize = 12
    ColorLabel.Parent = ESPFrame
    
    -- Botões de cor
    local colors = {
        {"NPC", Color3.fromRGB(255, 255, 0)},
        {"Boss", Color3.fromRGB(255, 0, 0)},
        {"Fruit", Color3.fromRGB(0, 255, 0)},
        {"Quest", Color3.fromRGB(0, 150, 255)}
    }
    
    for i, color in ipairs(colors) do
        local ColorButton = Instance.new("TextButton")
        ColorButton.Size = UDim2.new(0, 90, 0, 25)
        ColorButton.Position = UDim2.new(0, 10 + ((i-1) % 2) * 100, 0, 395 + math.floor((i-1) / 2) * 30)
        ColorButton.BackgroundColor3 = color[2]
        ColorButton.Text = color[1]
        ColorB
