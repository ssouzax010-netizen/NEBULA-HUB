--[[
    NEBULA HUB - Vox Seas (versão corrigida)
    Menu funcional: abre, troca de abas, liga/desliga toggles.
    As funções reais ficam na tabela Hooks (preencha depois).
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function getParent()
    local ok, ui = pcall(function() return gethui and gethui() end)
    if ok and ui then return ui end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local parentGui = getParent()
local old = parentGui:FindFirstChild("NebulaHub")
if old then old:Destroy() end

local Theme = {
    Background = Color3.fromRGB(15, 15, 35),
    Panel = Color3.fromRGB(20, 20, 40),
    Content = Color3.fromRGB(25, 25, 45),
    Item = Color3.fromRGB(30, 30, 50),
    Primary = Color3.fromRGB(100, 50, 200),
    Secondary = Color3.fromRGB(0, 150, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(200, 100, 255),
    Off = Color3.fromRGB(100, 100, 100),
}

local State = { Enemy = "Pirata Básico", Paused = false }
local Hooks = {
    AutoFarm = function(on) end,
    AutoQuest = function(on) end,
    AutoCollect = function(on) end,
    NPCEsp = function(on) end,
    FruitEsp = function(on) end,
    BossEsp = function(on) end,
    PlayerEsp = function(on) end,
}

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = obj
end

local function createLabel(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -10, 0, 28)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Theme.Text
    l.TextSize = size or 13
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function createButton(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 32)
    b.BackgroundColor3 = Theme.Primary
    b.Text = text
    b.TextColor3 = Theme.Text
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = false
    b.Parent = parent
    corner(b)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Primary}):Play()
    end)
    if callback then b.MouseButton1Click:Connect(function() callback(b) end) end
    return b
end

local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.BackgroundColor3 = Theme.Item
    frame.Parent = parent
    corner(frame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 22)
    btn.Position = UDim2.new(1, -58, 0.5, -11)
    btn.BackgroundColor3 = Theme.Off
    btn.Text = "OFF"
    btn.TextColor3 = Theme.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = frame
    corner(btn, 11)

    local value = false
    btn.MouseButton1Click:Connect(function()
        value = not value
        btn.Text = value and "ON" or "OFF"
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = value and Theme.Primary or Theme.Off
        }):Play()
        if callback then
            local ok, err = pcall(callback, value)
            if not ok then warn("[NEBULA] erro em '" .. text .. "': " .. tostring(err)) end
        end
    end)
    return frame
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
corner(Main, 10)

local stroke = Instance.new("UIStroke")
stroke.Color = Theme.Primary
stroke.Thickness = 2
stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Theme.Panel
Title.BorderSizePixel = 0
Title.Text = "NEBULA HUB"
Title.TextColor3 = Theme.Accent
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
Close.Text = "X"
Close.TextColor3 = Theme.Text
Close.TextSize = 14
Close.Font = Enum.Font.GothamBold
Close.Parent = Main
corner(Close)

local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0, 30, 0, 30)
Mini.Position = UDim2.new(1, -70, 0, 5)
Mini.BackgroundColor3 = Theme.Secondary
Mini.Text = "-"
Mini.TextColor3 = Theme.Text
Mini.TextSize = 16
Mini.Font = Enum.Font.GothamBold
Mini.Parent = Main
corner(Mini)

local Side = Instance.new("ScrollingFrame")
Side.Size = UDim2.new(0, 110, 1, -40)
Side.Position = UDim2.new(0, 0, 0, 40)
Side.BackgroundColor3 = Theme.Panel
Side.BorderSizePixel = 0
Side.ScrollBarThickness = 3
Side.AutomaticCanvasSize = Enum.AutomaticSize.Y
Side.CanvasSize = UDim2.new(0, 0, 0, 0)
Side.Parent = Main

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 5)
sideLayout.Parent = Side
local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 5)
sidePad.PaddingLeft = UDim.new(0, 5)
sidePad.PaddingRight = UDim.new(0, 5)
sidePad.Parent = Side

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -110, 1, -40)
Content.Position = UDim2.new(0, 110, 0, 40)
Content.BackgroundColor3 = Theme.Content
Content.BorderSizePixel = 0
Content.Parent = Main

local pages, tabButtons = {}, {}

local function createPage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Visible = false
    p.Parent = Content
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 6)
    l.Parent = p
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = p
    pages[name] = p
    return p
end

local function selectTab(name)
    for n, p in pairs(pages) do p.Visible = (n == name) end
    for n, b in pairs(tabButtons) do
        b.BackgroundColor3 = (n == name) and Theme.Primary or Theme.Item
    end
end

local function addTab(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = Theme.Item
    b.Text = name
    b.TextColor3 = Theme.Text
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = false
    b.Parent = Side
    corner(b)
    tabButtons[name] = b
    b.MouseButton1Click:Connect(function() selectTab(name) end)
    return createPage(name)
end

-- Aba FARM
local farm = addTab("FARM")
createLabel(farm, "⚡ AUTO FARM", 16, Theme.Accent, Enum.Font.GothamBold)
createToggle(farm, "Auto Farm Level", function(v) Hooks.AutoFarm(v) end)
createToggle(farm, "Auto Quest", function(v) Hooks.AutoQuest(v) end)

local enemies = {"Pirata Básico", "Marinheiro", "Capitão Pirata", "Bandido", "Mercenário", "Guarda Real"}
local enemyIndex = 1
createButton(farm, "🎯 Inimigo: " .. enemies[1], function(btn)
    enemyIndex = enemyIndex % #enemies + 1
    State.Enemy = enemies[enemyIndex]
    btn.Text = "🎯 Inimigo: " .. State.Enemy
end)

createToggle(farm, "Pausar farm", function(v) State.Paused = v end)

-- Aba FRUIT
local fruit = addTab("FRUIT")
createLabel(fruit, "🍎 FRUIT SYSTEM", 16, Theme.Accent, Enum.Font.GothamBold)
createToggle(fruit, "Fruit ESP", function(v) Hooks.FruitEsp(v) end)
createToggle(fruit, "Auto Collect Fruit", function(v) Hooks.AutoCollect(v) end)

createLabel(fruit, "📜 Frutas conhecidas:", 13)
local fruits = {
    {"Gomu Gomu", "Comum", Color3.fromRGB(255, 255, 255)},
    {"Mera Mera", "Rara", Color3.fromRGB(0, 150, 255)},
    {"Hie Hie", "Rara", Color3.fromRGB(0, 150, 255)},
    {"Goro Goro", "Épica", Color3.fromRGB(200, 100, 255)},
    {"Pika Pika", "Épica", Color3.fromRGB(200, 100, 255)},
    {"Yami Yami", "Lendária", Color3.fromRGB(255, 200, 0)},
}
for _, f in ipairs(fruits) do
    local l = createLabel(fruit, f[1] .. " [" .. f[2] .. "]", 12, f[3])
    l.Size = UDim2.new(1, -10, 0, 22)
end

-- Aba ESP
local esp = addTab("ESP")
createLabel(esp, "👁 ESP SYSTEM", 16, Theme.Accent, Enum.Font.GothamBold)
createToggle(esp, "NPC ESP", function(v) Hooks.NPCEsp(v) end)
createToggle(esp, "Boss ESP", function(v) Hooks.BossEsp(v) end)
createToggle(esp, "Fruit ESP", function(v) Hooks.FruitEsp(v) end)
createToggle(esp, "Player ESP", function(v) Hooks.PlayerEsp(v) end)

-- Aba SETTINGS
local settings = addTab("SETTINGS")
createLabel(settings, "⚙ CONFIGURAÇÕES", 16, Theme.Accent, Enum.Font.GothamBold)
createButton(settings, "Fechar menu", function() ScreenGui:Destroy() end)

Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local minimized = false
Mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    Side.Visible = not minimized
    Content.Visible = not minimized
    Main.Size = minimized and UDim2.new(0, 480, 0, 40) or UDim2.new(0, 480, 0, 320)
    Mini.Text = minimized and "+" or "-"
end)

selectTab("FARM")
