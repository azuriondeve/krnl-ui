--[[
    Premium Roblox UI Library - Versão Corrigida
    Funcionalidades: Resizable, Key System Opcional, Tabs Fixas, Arraste na TopBar.
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

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Lógica para pular Key System se não for necessário
    local function StartMain()
        Library:InitMain(ScreenGui, title, subtitle, toggleKey)
    end

    if keySystem then
        local KeyUI = Instance.new("Frame")
        KeyUI.Size = UDim2.new(0, 300, 0, 150)
        KeyUI.Position = UDim2.new(0.5, -150, 0.5, -75)
        KeyUI.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        KeyUI.BorderSizePixel = 0
        KeyUI.Parent = ScreenGui
        KeyUI.ZIndex = 5

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = KeyUI

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

function Library:InitMain(ScreenGui, title, subtitle, toggleKey)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.Parent = MainFrame

    -- Top Bar (Arraste apenas aqui)
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = TopBar

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(0, 200, 0, 15)
    SubLabel.Position = UDim2.new(0, 15, 0, 28)
    SubLabel.Text = subtitle
    SubLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextSize = 12
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.BackgroundTransparency = 1
    SubLabel.Parent = TopBar

    -- Drag System Corrigido (Apenas na TopBar)
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

    -- Resizable System
    local ResizeBtn = Instance.new("ImageLabel")
    ResizeBtn.Size = UDim2.new(0, 15, 0, 15)
    ResizeBtn.Position = UDim2.new(1, -15, 1, -15)
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Image = "rbxassetid://12720110362" -- Ícone de triângulo/resize
    ResizeBtn.ImageColor3 = Color3.fromRGB(100, 100, 100)
    ResizeBtn.Parent = MainFrame
    ResizeBtn.ZIndex = 10

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
            MainFrame.Size = UDim2.new(0, math.max(300, resSize.X + delta.X), 0, math.max(150, resSize.Y + delta.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
    end)

    -- Botões de Controle
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 10)
    CloseBtn.Text = "X"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Parent = TopBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 10)
    MinBtn.Text = "-"
    MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Parent = TopBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

    -- Floating Button
    local FloatBtn = Instance.new("ImageButton")
    FloatBtn.Size = UDim2.new(0, 50, 0, 50)
    FloatBtn.Position = UDim2.new(0, 20, 0.5, -25)
    FloatBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    FloatBtn.Image = "rbxassetid://6031280225"
    FloatBtn.Visible = false
    FloatBtn.Parent = ScreenGui
    Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

    local function ToggleUI()
        MainFrame.Visible = not MainFrame.Visible
        FloatBtn.Visible = not MainFrame.Visible
    end

    CloseBtn.MouseButton1Click:Connect(ToggleUI)
    FloatBtn.MouseButton1Click:Connect(ToggleUI)
    
    UserInputService.InputBegan:Connect(function(i)
        if i.KeyCode == toggleKey then ToggleUI() end
    end)

    local minimized = false
    local originalSize = MainFrame.Size
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then originalSize = MainFrame.Size end
        local targetSize = minimized and UDim2.new(0, MainFrame.Size.X.Offset, 0, 50) or originalSize
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
    end)

    -- Estrutura de Abas
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 130, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    Sidebar.Parent = MainFrame

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -130, 1, -50)
    Container.Position = UDim2.new(0, 130, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local TabList = Instance.new("UIListLayout", Sidebar)
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Tabs = {}

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 4
        TabContent.BorderSizePixel = 0
        TabContent.Parent = Container
        
        local ContentList = Instance.new("UIListLayout", TabContent)
        ContentList.Padding = UDim.new(0, 10)
        ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do 
                if v:IsA("ScrollingFrame") then v.Visible = false end 
            end
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(200, 200, 200) 
                    v.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                end
            end
            TabContent.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)

        -- Mostrar primeira aba por padrão
        if #Sidebar:GetChildren() == 2 then -- 1 layout + 1 btn
            TabContent.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        local Elements = {}

        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0.9, 0, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.Parent = TabContent
            Instance.new("UICorner", Btn)

            Btn.MouseButton1Click:Connect(callback)
            return { SetText = function(t) Btn.Text = t end }
        end

        function Elements:CreateToggle(text, callback)
            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(0.9, 0, 0, 35)
            Tgl.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Tgl.Text = "  " .. text
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.TextColor3 = Color3.fromRGB(255, 255, 255)
            Tgl.Font = Enum.Font.Gotham
            Tgl.Parent = TabContent
            Instance.new("UICorner", Tgl)

            local Ind = Instance.new("Frame")
            Ind.Size = UDim2.new(0, 18, 0, 18)
            Ind.Position = UDim2.new(1, -28, 0.5, -9)
            Ind.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            Ind.Parent = Tgl
            Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)

            local s = false
            Tgl.MouseButton1Click:Connect(function()
                s = not s
                Ind.BackgroundColor3 = s and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 80)
                callback(s)
            end)
        end

        function Elements:CreateSlider(text, min, max, callback)
            local SFrame = Instance.new("Frame")
            SFrame.Size = UDim2.new(0.9, 0, 0, 45)
            SFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            SFrame.Parent = TabContent
            Instance.new("UICorner", SFrame)

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, -20, 0, 20)
            Lbl.Position = UDim2.new(0, 10, 0, 5)
            Lbl.Text = text .. ": " .. min
            Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            Lbl.BackgroundTransparency = 1
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = SFrame

            local Bar = Instance.new("TextButton")
            Bar.Size = UDim2.new(0.9, 0, 0, 6)
            Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Bar.Text = ""
            Bar.Parent = SFrame
            Instance.new("UICorner", Bar)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Fill.Parent = Bar
            Instance.new("UICorner", Fill)

            local function Update()
                local move = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(move, 0, 1, 0)
                local val = math.floor(min + (max - min) * move)
                Lbl.Text = text .. ": " .. val
                callback(val)
            end

            Bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local conn
                    conn = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then Update() end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end
                    end)
                    Update()
                end
            end)
        end

        function Elements:CreateInput(placeholder, callback)
            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(0.9, 0, 0, 35)
            Box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            Box.Parent = TabContent
            Instance.new("UICorner", Box)
            Box.FocusLost:Connect(function(e) if e then callback(Box.Text) end end)
        end

        function Elements:CreateKeybind(text, default, callback)
            local BFrame = Instance.new("TextButton")
            BFrame.Size = UDim2.new(0.9, 0, 0, 35)
            BFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            BFrame.Text = "  " .. text
            BFrame.TextXAlignment = Enum.TextXAlignment.Left
            BFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            BFrame.Parent = TabContent
            Instance.new("UICorner", BFrame)

            local BLbl = Instance.new("TextLabel")
            BLbl.Size = UDim2.new(0, 60, 0, 20)
            BLbl.Position = UDim2.new(1, -70, 0.5, -10)
            BLbl.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            BLbl.Text = default.Name
            BLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            BLbl.Parent = BFrame
            Instance.new("UICorner", BLbl)

            local key = default
            BFrame.MouseButton1Click:Connect(function()
                BLbl.Text = "..."
                local conn
                conn = UserInputService.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        key = i.KeyCode
                        BLbl.Text = key.Name
                        conn:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(i)
                if i.KeyCode == key and not UserInputService:GetFocusedTextBox() then callback() end
            end)
        end

        return Elements
    end

    return Tabs
end

return Library
