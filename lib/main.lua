--[[
    Premium Roblox UI Library - Versão Estável
    Funcionalidades: Resizable, Tabs Fixas, Custom Float Button, Key System Opcional.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(config)
    local title = config.Title or "Janela"
    local subtitle = config.Subtitle or "Subtitulo"
    local keySystem = config.KeySystem or false
    local keyCallback = config.KeyCallback or function() return true end
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    
    -- Configurações do Botão Flutuante (Novo)
    local floatIcon = config.FloatIcon or "rbxassetid://6031280225"
    local floatRounding = config.FloatRounding or 8

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local function StartMain()
        Library:InitMain(ScreenGui, title, subtitle, toggleKey, floatIcon, floatRounding)
    end

    if keySystem then
        local KeyUI = Instance.new("Frame")
        KeyUI.Size = UDim2.new(0, 300, 0, 150)
        KeyUI.Position = UDim2.new(0.5, -150, 0.5, -75)
        KeyUI.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        KeyUI.BorderSizePixel = 0
        KeyUI.Parent = ScreenGui
        KeyUI.ZIndex = 100

        Instance.new("UICorner", KeyUI).CornerRadius = UDim.new(0, 8)

        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Size = UDim2.new(1, 0, 0, 40)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Text = "Key System"
        KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyTitle.TextSize = 18
        KeyTitle.Font = Enum.Font.GothamBold
        KeyTitle.Parent = KeyUI

        local KeyInput = Instance.new("TextBox")
        KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
        KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
        KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyInput.PlaceholderText = "Insira a Key aqui..."
        KeyInput.Text = ""
        KeyInput.Parent = KeyUI
        Instance.new("UICorner", KeyInput)

        local CheckBtn = Instance.new("TextButton")
        CheckBtn.Size = UDim2.new(0.8, 0, 0, 30)
        CheckBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
        CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        CheckBtn.Text = "Verificar"
        CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CheckBtn.Parent = KeyUI
        Instance.new("UICorner", CheckBtn)

        CheckBtn.MouseButton1Click:Connect(function()
            if keyCallback(KeyInput.Text) then
                KeyUI:Destroy()
                StartMain()
            else
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Key Incorreta!"
            end
        end)
    else
        StartMain()
    end
end

function Library:InitMain(ScreenGui, title, subtitle, toggleKey, floatIcon, floatRounding)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 5

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    TopBar.ZIndex = 6

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 250, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = TopBar
    TitleLabel.ZIndex = 7

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(0, 250, 0, 15)
    SubLabel.Position = UDim2.new(0, 15, 0, 28)
    SubLabel.Text = subtitle
    SubLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextSize = 12
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.BackgroundTransparency = 1
    SubLabel.Parent = TopBar
    SubLabel.ZIndex = 7

    -- Drag System
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Botões de Controle
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 10)
    CloseBtn.Text = "X"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Parent = TopBar
    CloseBtn.ZIndex = 8
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 10)
    MinBtn.Text = "-"
    MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Parent = TopBar
    MinBtn.ZIndex = 8
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

    -- Resizable
    local ResizeBtn = Instance.new("ImageButton")
    ResizeBtn.Size = UDim2.new(0, 15, 0, 15)
    ResizeBtn.Position = UDim2.new(1, -15, 1, -15)
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Image = "rbxassetid://12720110362"
    ResizeBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)
    ResizeBtn.Parent = MainFrame
    ResizeBtn.ZIndex = 20

    local resizing = false
    local resStart, resSize
    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resStart = input.Position
            resSize = MainFrame.AbsoluteSize
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resStart
            MainFrame.Size = UDim2.new(0, math.max(400, resSize.X + delta.X), 0, math.max(200, resSize.Y + delta.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
    end)

    -- Floating Button (Customizado)
    local FloatBtn = Instance.new("ImageButton")
    FloatBtn.Size = UDim2.new(0, 50, 0, 50)
    FloatBtn.Position = UDim2.new(0, 20, 0.5, -25)
    FloatBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    FloatBtn.Image = floatIcon
    FloatBtn.Visible = false
    FloatBtn.Parent = ScreenGui
    FloatBtn.ZIndex = 50
    Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, floatRounding)
    
    -- Draggable Float Button
    local fDragging, fStart, fStartPos
    FloatBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            fDragging = true fStart = i.Position fStartPos = FloatBtn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if fDragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - fStart
            FloatBtn.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + d.X, fStartPos.Y.Scale, fStartPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then fDragging = false end end)

    local function ToggleUI()
        MainFrame.Visible = not MainFrame.Visible
        FloatBtn.Visible = not MainFrame.Visible
    end

    CloseBtn.MouseButton1Click:Connect(ToggleUI)
    FloatBtn.MouseButton1Click:Connect(ToggleUI)
    
    UserInputService.InputBegan:Connect(function(i) if i.KeyCode == toggleKey then ToggleUI() end end)

    local isMin = false
    local oldSize = MainFrame.Size
    MinBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        if isMin then oldSize = MainFrame.Size end
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = isMin and UDim2.new(0, MainFrame.Size.X.Offset, 0, 50) or oldSize}):Play()
    end)

    -- Sidebar e Container
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 130, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = MainFrame
    Sidebar.ZIndex = 6

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -135, 1, -55)
    Container.Position = UDim2.new(0, 135, 0, 55)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame
    Container.ZIndex = 6

    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

    local Tabs = {}
    local first = true

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Parent = Sidebar
        TabBtn.ZIndex = 7
        Instance.new("UICorner", TabBtn)

        local Content = Instance.new("ScrollingFrame")
        Content.Size = UDim2.new(1, 0, 1, 0)
        Content.BackgroundTransparency = 1
        Content.Visible = false
        Content.ScrollBarThickness = 2
        Content.BorderSizePixel = 0
        Content.Parent = Container
        Content.ZIndex = 7
        
        local Layout = Instance.new("UIListLayout", Content)
        Layout.Padding = UDim.new(0, 8)
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(200, 200, 200) end end
            Content.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        if first then
            Content.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            first = false
        end

        local Elems = {}

        function Elems:CreateButton(t, cb)
            local B = Instance.new("TextButton")
            B.Size = UDim2.new(0.95, 0, 0, 35)
            B.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            B.Text = t
            B.TextColor3 = Color3.fromRGB(255, 255, 255)
            B.Font = Enum.Font.Gotham
            B.Parent = Content
            B.ZIndex = 8
            Instance.new("UICorner", B)
            B.MouseButton1Click:Connect(cb)
            return { SetText = function(nt) B.Text = nt end }
        end

        function Elems:CreateToggle(t, cb)
            local T = Instance.new("TextButton")
            T.Size = UDim2.new(0.95, 0, 0, 35)
            T.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            T.Text = "  " .. t
            T.TextXAlignment = Enum.TextXAlignment.Left
            T.TextColor3 = Color3.fromRGB(255, 255, 255)
            T.Font = Enum.Font.Gotham
            T.Parent = Content
            T.ZIndex = 8
            Instance.new("UICorner", T)

            local I = Instance.new("Frame")
            I.Size = UDim2.new(0, 18, 0, 18)
            I.Position = UDim2.new(1, -28, 0.5, -9)
            I.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            I.Parent = T
            I.ZIndex = 9
            Instance.new("UICorner", I).CornerRadius = UDim.new(1, 0)

            local s = false
            T.MouseButton1Click:Connect(function()
                s = not s
                I.BackgroundColor3 = s and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 80)
                cb(s)
            end)
        end

        function Elems:CreateSlider(t, min, max, cb)
            local S = Instance.new("Frame")
            S.Size = UDim2.new(0.95, 0, 0, 45)
            S.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            S.Parent = Content
            S.ZIndex = 8
            Instance.new("UICorner", S)

            local L = Instance.new("TextLabel")
            L.Size = UDim2.new(1, -20, 0, 20)
            L.Position = UDim2.new(0, 10, 0, 5)
            L.Text = t .. ": " .. min
            L.TextColor3 = Color3.fromRGB(255, 255, 255)
            L.BackgroundTransparency = 1
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Parent = S
            L.ZIndex = 9

            local B = Instance.new("TextButton")
            B.Size = UDim2.new(0.9, 0, 0, 6)
            B.Position = UDim2.new(0.05, 0, 0.7, 0)
            B.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            B.Text = ""
            B.Parent = S
            B.ZIndex = 9
            Instance.new("UICorner", B)

            local F = Instance.new("Frame")
            F.Size = UDim2.new(0, 0, 1, 0)
            F.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            F.Parent = B
            F.ZIndex = 10
            Instance.new("UICorner", F)

            local function U()
                local m = math.clamp((UserInputService:GetMouseLocation().X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
                F.Size = UDim2.new(m, 0, 1, 0)
                local v = math.floor(min + (max - min) * m)
                L.Text = t .. ": " .. v
                cb(v)
            end

            B.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local c
                    c = UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then U() end end)
                    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then c:Disconnect() end end)
                    U()
                end
            end)
        end

        function Elems:CreateInput(p, cb)
            local I = Instance.new("TextBox")
            I.Size = UDim2.new(0.95, 0, 0, 35)
            I.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            I.PlaceholderText = p
            I.Text = ""
            I.TextColor3 = Color3.fromRGB(255, 255, 255)
            I.Parent = Content
            I.ZIndex = 8
            Instance.new("UICorner", I)
            I.FocusLost:Connect(function(e) if e then cb(I.Text) end end)
        end

        function Elems:CreateKeybind(t, d, cb)
            local KF = Instance.new("TextButton")
            KF.Size = UDim2.new(0.95, 0, 0, 35)
            KF.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            KF.Text = "  " .. t
            KF.TextXAlignment = Enum.TextXAlignment.Left
            KF.TextColor3 = Color3.fromRGB(255, 255, 255)
            KF.Parent = Content
            KF.ZIndex = 8
            Instance.new("UICorner", KF)

            local KL = Instance.new("TextLabel")
            KL.Size = UDim2.new(0, 60, 0, 20)
            KL.Position = UDim2.new(1, -70, 0.5, -10)
            KL.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            KL.Text = d.Name
            KL.TextColor3 = Color3.fromRGB(255, 255, 255)
            KL.Parent = KF
            KL.ZIndex = 9
            Instance.new("UICorner", KL)

            local k = d
            KF.MouseButton1Click:Connect(function()
                KL.Text = "..."
                local c
                c = UserInputService.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Keyboard then k = i.KeyCode KL.Text = k.Name c:Disconnect() end
                end)
            end)
            UserInputService.InputBegan:Connect(function(i) if i.KeyCode == k and not UserInputService:GetFocusedTextBox() then cb() end end)
        end

        return Elems
    end

    return Tabs
end

return Library
