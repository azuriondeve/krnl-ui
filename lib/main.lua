--[[
    Premium Roblox UI Library
    Funcionalidades: Key System, Tabs, Buttons, Toggles, Sliders, Textbox, Keybinds.
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
    local keyCallback = config.KeyCallback or function() end
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Key System UI (Se habilitado)
    if keySystem then
        local KeyUI = Instance.new("Frame")
        KeyUI.Size = UDim2.new(0, 300, 0, 150)
        KeyUI.Position = UDim2.new(0.5, -150, 0.5, -75)
        KeyUI.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        KeyUI.BorderSizePixel = 0
        KeyUI.Parent = ScreenGui

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

        CheckBtn.MouseButton1Click:Connect(function()
            if keyCallback(KeyInput.Text) then
                KeyUI:Destroy()
                Library:InitMain(ScreenGui, title, subtitle, toggleKey)
            else
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Key Incorreta!"
            end
        end)
        return
    end

    Library:InitMain(ScreenGui, title, subtitle, toggleKey)
end

function Library:InitMain(ScreenGui, title, subtitle, toggleKey)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.Parent = MainFrame

    -- Drag System
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
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

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Position = UDim2.new(0, 15, 0, 5)
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.Parent = TopBar

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Position = UDim2.new(0, 15, 0, 20)
    SubLabel.Text = subtitle
    SubLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextSize = 12
    SubLabel.Parent = TopBar

    -- Botões de Controle (X e Minimizar)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.Text = "X"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Parent = TopBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 5)
    MinBtn.Text = "-"
    MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Parent = TopBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

    -- Floating Button (Para reabrir)
    local FloatBtn = Instance.new("ImageButton")
    FloatBtn.Size = UDim2.new(0, 50, 0, 50)
    FloatBtn.Position = UDim2.new(0, 20, 0.5, -25)
    FloatBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    FloatBtn.Image = "rbxassetid://6031280225" -- Exemplo de ícone
    FloatBtn.Visible = false
    FloatBtn.Parent = ScreenGui
    local FloatCorner = Instance.new("UICorner", FloatBtn)
    FloatCorner.CornerRadius = UDim.new(0, 25)

    -- Lógica de Abrir/Fechar
    local function ToggleUI()
        MainFrame.Visible = not MainFrame.Visible
        FloatBtn.Visible = not MainFrame.Visible
    end

    CloseBtn.MouseButton1Click:Connect(ToggleUI)
    FloatBtn.MouseButton1Click:Connect(ToggleUI)
    
    UserInputService.InputBegan:Connect(function(i)
        if i.KeyCode == toggleKey then ToggleUI() end
    end)

    -- Minimizar (Encolher tudo exceto a barra)
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(0, 450, 0, 40) or UDim2.new(0, 450, 0, 300)
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
    end)

    -- Sidebar para Tabs
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 120, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 2
    Sidebar.Parent = MainFrame

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -120, 1, -40)
    Container.Position = UDim2.new(0, 120, 0, 40)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local TabList = Instance.new("UIListLayout", Sidebar)
    TabList.Padding = UDim.new(0, 5)

    local Tabs = {}

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -10, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 3
        TabContent.Parent = Container
        
        local ContentList = Instance.new("UIListLayout", TabContent)
        ContentList.Padding = UDim.new(0, 8)
        ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(200, 200, 200) end
            end
            TabContent.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        local Elements = {}

        -- Botão
        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0.9, 0, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Parent = TabContent
            Instance.new("UICorner", Btn)

            Btn.MouseButton1Click:Connect(function()
                callback()
            end)
            
            return {
                SetText = function(newText) Btn.Text = newText end
            }
        end

        -- Toggle
        function Elements:CreateToggle(text, callback)
            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(0.9, 0, 0, 35)
            TglFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            TglFrame.Text = "  " .. text
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            TglFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            TglFrame.Parent = TabContent
            Instance.new("UICorner", TglFrame)

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.Position = UDim2.new(1, -30, 0.5, -10)
            Indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            Indicator.Parent = TglFrame
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

            local state = false
            TglFrame.MouseButton1Click:Connect(function()
                state = not state
                Indicator.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
                callback(state)
            end)
        end

        -- Slider
        function Elements:CreateSlider(text, min, max, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(0.9, 0, 0, 45)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SliderFrame.Parent = TabContent
            Instance.new("UICorner", SliderFrame)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = SliderFrame

            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(0.8, 0, 0, 6)
            Bar.Position = UDim2.new(0.1, 0, 0.7, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Bar.Parent = SliderFrame
            Instance.new("UICorner", Bar)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Fill.Parent = Bar
            Instance.new("UICorner", Fill)

            local function UpdateSlider()
                local mousePos = UserInputService:GetMouseLocation().X
                local barPos = Bar.AbsolutePosition.X
                local barSize = Bar.AbsoluteSize.X
                local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                local value = math.floor(min + (max - min) * percent)
                callback(value)
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local moveConn
                    moveConn = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateSlider()
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            moveConn:Disconnect()
                        end
                    end)
                    UpdateSlider()
                end
            end)
        end

        -- Textbox / Input
        function Elements:CreateInput(placeholder, callback)
            local Input = Instance.new("TextBox")
            Input.Size = UDim2.new(0.9, 0, 0, 35)
            Input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Input.PlaceholderText = placeholder
            Input.Text = ""
            Input.TextColor3 = Color3.fromRGB(255, 255, 255)
            Input.Parent = TabContent
            Instance.new("UICorner", Input)

            Input.FocusLost:Connect(function(enter)
                if enter then callback(Input.Text) end
            end)
        end

        -- Keybind
        function Elements:CreateKeybind(text, default, callback)
            local BindFrame = Instance.new("TextButton")
            BindFrame.Size = UDim2.new(0.9, 0, 0, 35)
            BindFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            BindFrame.Text = "  " .. text
            BindFrame.TextXAlignment = Enum.TextXAlignment.Left
            BindFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindFrame.Parent = TabContent
            Instance.new("UICorner", BindFrame)

            local BindLabel = Instance.new("TextLabel")
            BindLabel.Size = UDim2.new(0, 60, 0, 25)
            BindLabel.Position = UDim2.new(1, -70, 0.5, -12)
            BindLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            BindLabel.Text = default.Name
            BindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindLabel.Parent = BindFrame
            Instance.new("UICorner", BindLabel)

            local currKey = default
            local connection
            
            BindFrame.MouseButton1Click:Connect(function()
                BindLabel.Text = "..."
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currKey = input.KeyCode
                        BindLabel.Text = currKey.Name
                        connection:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == currKey and not UserInputService:GetFocusedTextBox() then
                    callback()
                end
            end)
        end

        return Elements
    end

    return Tabs
end

return Library
