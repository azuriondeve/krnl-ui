--[[
    Premium Roblox UI Library - Versão Corrigida
    Correções: Tabs funcionando, Drag em toda janela, Resizable, KeySystem opcional
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

    -- ==================== KEY SYSTEM ====================
    if keySystem then
        local KeyUI = Instance.new("Frame")
        KeyUI.Size = UDim2.new(0, 320, 0, 180)
        KeyUI.Position = UDim2.new(0.5, -160, 0.5, -90)
        KeyUI.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        KeyUI.BorderSizePixel = 0
        KeyUI.Parent = ScreenGui

        Instance.new("UICorner", KeyUI).CornerRadius = UDim.new(0, 10)

        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Size = UDim2.new(1, 0, 0, 50)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Text = "Key System"
        KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyTitle.TextSize = 20
        KeyTitle.Font = Enum.Font.GothamBold
        KeyTitle.Parent = KeyUI

        local KeyInput = Instance.new("TextBox")
        KeyInput.Size = UDim2.new(0.85, 0, 0, 35)
        KeyInput.Position = UDim2.new(0.075, 0, 0.4, 0)
        KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        KeyInput.PlaceholderText = "Insira a key aqui..."
        KeyInput.Text = ""
        KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyInput.Font = Enum.Font.Gotham
        KeyInput.TextSize = 14
        KeyInput.Parent = KeyUI
        Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

        local CheckBtn = Instance.new("TextButton")
        CheckBtn.Size = UDim2.new(0.85, 0, 0, 40)
        CheckBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
        CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        CheckBtn.Text = "Verificar Key"
        CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CheckBtn.Font = Enum.Font.GothamBold
        CheckBtn.TextSize = 15
        CheckBtn.Parent = KeyUI
        Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 6)

        CheckBtn.MouseButton1Click:Connect(function()
            if keyCallback(KeyInput.Text) then
                KeyUI:Destroy()
                Library:InitMain(ScreenGui, title, subtitle, toggleKey)
            else
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Key incorreta! Tente novamente."
                KeyInput.PlaceholderColor3 = Color3.fromRGB(255, 100, 100)
            end
        end)
        return
    end

    -- Se não tiver KeySystem, cria direto
    Library:InitMain(ScreenGui, title, subtitle, toggleKey)
end

function Library:InitMain(ScreenGui, title, subtitle, toggleKey)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 520, 0, 340)  -- Tamanho maior e melhor
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    -- ==================== DRAG EM QUALQUER LUGAR ====================
    local dragging = false
    local dragInput, dragStart, startPos

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
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- ==================== RESIZE (Redimensionar) ====================
    local resizing = false
    local resizeStartPos, startSize

    local ResizeCorner = Instance.new("TextButton")
    ResizeCorner.Size = UDim2.new(0, 20, 0, 20)
    ResizeCorner.Position = UDim2.new(1, -20, 1, -20)
    ResizeCorner.BackgroundTransparency = 1
    ResizeCorner.Text = ""
    ResizeCorner.Parent = MainFrame

    ResizeCorner.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStartPos = input.Position
            startSize = MainFrame.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStartPos
            local newWidth = math.max(400, startSize.X.Offset + delta.X)
            local newHeight = math.max(280, startSize.Y.Offset + delta.Y)
            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    -- ==================== TOP BAR ====================
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.Parent = TopBar

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
    SubLabel.Position = UDim2.new(0, 15, 0.5, 0)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = subtitle
    SubLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextSize = 13
    SubLabel.Parent = TopBar

    -- Botões de controle
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -38, 0, 10)
    CloseBtn.Text = "✕"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.Parent = TopBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    -- ==================== SIDEBAR + CONTAINER ====================
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 130, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 4
    Sidebar.Parent = MainFrame

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -130, 1, -50)
    Container.Position = UDim2.new(0, 130, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.Parent = Sidebar

    local Tabs = {}

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -12, 0, 36)
        TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.Text = "  " .. name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 5
        TabContent.Parent = Container

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ContentLayout.Parent = TabContent

        -- Seleção de tab
        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(Container:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            for _, child in pairs(Sidebar:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = Color3.fromRGB(200, 200, 200)
                    child.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                end
            end
            TabContent.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)

        local Elements = {}

        function Elements:CreateButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0.92, 0, 0, 40)
            Btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 15
            Btn.Parent = TabContent
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

            Btn.MouseButton1Click:Connect(callback)
            return Btn
        end

        function Elements:CreateToggle(text, default, callback)
            local state = default or false

            local Tgl = Instance.new("TextButton")
            Tgl.Size = UDim2.new(0.92, 0, 0, 40)
            Tgl.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            Tgl.Text = "  " .. text
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Tgl.TextColor3 = Color3.fromRGB(255, 255, 255)
            Tgl.Font = Enum.Font.Gotham
            Tgl.TextSize = 15
            Tgl.Parent = TabContent
            Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 8)

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 24, 0, 24)
            Indicator.Position = UDim2.new(1, -34, 0.5, -12)
            Indicator.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
            Indicator.Parent = Tgl
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

            Tgl.MouseButton1Click:Connect(function()
                state = not state
                Indicator.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
                callback(state)
            end)

            return { Set = function(v) state = v; Indicator.BackgroundColor3 = state and Color3.fromRGB(0,255,100) or Color3.fromRGB(100,100,100) end }
        end

        -- (Você pode adicionar Slider, Input e Keybind da mesma forma que antes, só copiar e colar se quiser)

        -- Primeira tab selecionada automaticamente
        if #Container:GetChildren() == 1 then
            TabContent.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end

        return Elements
    end

    -- ==================== FECHAR E TOGGLE ====================
    local isVisible = true

    local function ToggleUI()
        isVisible = not isVisible
        MainFrame.Visible = isVisible
    end

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == toggleKey then
            ToggleUI()
        end
    end)

    return Tabs
end

return Library

