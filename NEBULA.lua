local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local parentGui = LocalPlayer:WaitForChild("PlayerGui")

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

local State = { Enemy = "Todos", Paused = false, Distance = 300 }
local StatusLabel

local function setStatus(text)
    if StatusLabel then StatusLabel.Text = "IA: " .. text end
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ===== Utilidades =====
local function getChar()
    local ch = LocalPlayer.Character
    if not ch then return end
    local root = ch:FindFirstChild("HumanoidRootPart")
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if root and hum then return ch, root, hum end
end

local function rootOf(m)
    return m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
end

-- ===== ESP genérico =====
local function createESP(detect, color)
    local tracked, conn, active = {}, nil, false

    local function remove(k)
        local t = tracked[k]
        if t then
            if t.hl then t.hl:Destroy() end
            if t.bb then t.bb:Destroy() end
            tracked[k] = nil
        end
    end

    local function add(inst)
        local model, root = detect(inst)
        if not model or not root or tracked[model] then return end

        local hl = Instance.new("Highlight")
        hl.FillColor = color
        hl.OutlineColor = color
        hl.FillTransparency = 0.6
        hl.Adornee = model:IsA("Tool") and root or model
        hl.Parent = root

        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 140, 0, 30)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = root
        bb.Parent = root

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = model.Name
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.TextSize = 13
        label.Font = Enum.Font.GothamBold
        label.Parent = bb

        tracked[model] = { hl = hl, bb = bb, label = label, root = root }
    end

    return function(on)
        if on == active then return end
        active = on
        if on then
            for _, d in ipairs(workspace:GetDescendants()) do add(d) end
            conn = workspace.DescendantAdded:Connect(function(d)
                task.wait(0.5)
                if active then add(d) end
            end)
            task.spawn(function()
                while active do
                    local _, myRoot = getChar()
                    for model, t in pairs(tracked) do
                        if not model.Parent or not t.root.Parent then
                            remove(model)
                        elseif myRoot then
                            local dist = math.floor((t.root.Position - myRoot.Position).Magnitude)
                            t.label.Text = model.Name .. " [" .. dist .. "m]"
                        end
                    end
                    task.wait(0.3)
                end
            end)
        else
            if conn then conn:Disconnect() conn = nil end
            for k in pairs(tracked) do remove(k) end
        end
    end
end

local function detectNPC(inst)
    if not inst:IsA("Humanoid") then return end
    local m = inst.Parent
    if not m or not m:IsA("Model") or Players:GetPlayerFromCharacter(m) then return end
    return m, rootOf(m)
end

local function detectBoss(inst)
    local m, r = detectNPC(inst)
    if m and (inst.MaxHealth >= 5000 or m.Name:lower():find("boss", 1, true)) then return m, r end
end

local function detectPlayer(inst)
    if not inst:IsA("Humanoid") then return end
    local m = inst.Parent
    if not m or m == LocalPlayer.Character then return end
    if Players:GetPlayerFromCharacter(m) then return m, rootOf(m) end
end

local function detectFruit(inst)
    if not (inst:IsA("Tool") or inst:IsA("Model")) then return end
    if not inst.Name:lower():find("fruit", 1, true) then return end
    if inst:FindFirstAncestorOfClass("Backpack") then return end
    if inst.Parent and Players:GetPlayerFromCharacter(inst.Parent) then return end
    if inst:FindFirstChildOfClass("Humanoid") then return end
    local part = inst:FindFirstChild("Handle") or rootOf(inst)
    return inst, part
end

-- ===== AUTO FARM + IA =====
local Farm = { Active = false, Blacklist = {}, Retreating = false, RetreatStart = 0 }

local function holdPosition(root, on)
    local bv = root:FindFirstChild("NebulaHold")
    if on and not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "NebulaHold"
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bv.Velocity = Vector3.zero
        bv.Parent = root
    elseif not on and bv then
        bv:Destroy()
    end
end

local function attack(ch, hum)
    local tool = ch:FindFirstChildOfClass("Tool")
    if not tool then
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        local t = bp and bp:FindFirstChildOfClass("Tool")
        if t then
            pcall(function() hum:EquipTool(t) end)
            tool = t
        end
    end
    if tool then pcall(function() tool:Activate() end) end
    pcall(function()
        VirtualUser:Button1Down(Vector2.new(900, 500))
        VirtualUser:Button1Up(Vector2.new(900, 500))
    end)
end

local function pickTarget(myRoot, candidates)
    local best, bestScore
    local filter = State.Enemy:lower()
    for _, h in ipairs(candidates) do
        local m = h.Parent
        if m and h.Health > 0 and not (Farm.Blacklist[m] and Farm.Blacklist[m] > tick()) then
            local r = rootOf(m)
            if r and (filter == "todos" or m.Name:lower():find(filter, 1, true)) then
                local dist = (r.Position - myRoot.Position).Magnitude
                if dist <= State.Distance then
                    local score = dist + h.Health * 0.05 -- prefere perto e fraco
                    if no
