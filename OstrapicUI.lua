--[[
    SimpleUI Library
    A lightweight UI library for Roblox
]]

local UILibrary = {}
UILibrary.Version = "1.0.0"

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Theme
local Theme = {
    Accent = Color3.fromHex("#30FF6A"),
    Background = Color3.fromHex("#0A0A0A"),
    Secondary = Color3.fromHex("#141414"),
    Tertiary = Color3.fromHex("#1A1A1A"),
    Text = Color3.fromHex("#FFFFFF"),
    SubText = Color3.fromHex("#B0B0B0"),
    Border = Color3.fromHex("#2A2A2A"),
}

-- Utility Functions
local function Tween(instance, properties, duration)
    TweenService:Create(instance, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad), properties):Play()
end

local function Create(class, properties)
    local obj = Instance.new(class)
    for i,v in pairs(properties) do
        if i ~= "Parent" then
            obj[i] = v
        end
    end
    obj.Parent = properties.Parent
    return obj
end

-- Main Window
function UILibrary:CreateWindow(config)
    local Window = {
        Tabs = {},
        Flags = {},
        ConfigManager = {},
    }
    
    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "UILibrary",
        Parent = PlayerGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })
    
    -- Main Frame
    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = config.Size or UDim2.new(0, 700, 0, 500),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
    })
    
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Color = Theme.Border, Thickness = 1})
    
    -- Topbar
    local Topbar = Create("Frame", {
        Name = "Topbar",
        Parent = Main,
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
    })
    
    Create("UICorner", {Parent = Topbar, CornerRadius = UDim.new(0, 10)})
    
    Create("TextLabel", {
        Parent = Topbar,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -100, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "UI Library",
        TextColor3 = Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Parent = Topbar,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 24, 0, 24),
        BackgroundColor3 = Color3.fromHex("#FF4444"),
        Text = "×",
        TextColor3 = Color3.fromHex("#FFFFFF"),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
    })
    
    Create("UICorner", {Parent = CloseBtn, CornerRadius = UDim.new(1, 0)})
    CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)
    
    -- Tab Container
    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Main,
        Position = UDim2.new(0, 10, 0, 54),
        Size = UDim2.new(0, 180, 1, -64),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
    })
    
    Create("UICorner", {Parent = TabContainer, CornerRadius = UDim.new(0, 8)})
    Create("UIListLayout", {Parent = TabContainer, Padding = UDim.new(0, 5)})
    
    -- Content Container
    local ContentContainer = Create("Frame", {
        Name = "Content",
        Parent = Main,
        Position = UDim2.new(0, 200, 0, 54),
        Size = UDim2.new(1, -210, 1, -64),
        BackgroundTransparency = 1,
    })
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Tab Function
    function Window:Tab(tabConfig)
        local Tab = {Elements = {}}
        
        local TabButton = Create("TextButton", {
            Parent = TabContainer,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Theme.Tertiary,
            Text = "",
            AutoButtonColor = false,
            BorderSizePixel = 0,
        })
        
        Create("UICorner", {Parent = TabButton, CornerRadius = UDim.new(0, 6)})
        
        local TabTitle = Create("TextLabel", {
            Parent = TabButton,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -20, 1, 0),
            BackgroundTransparency = 1,
            Text = tabConfig.Title or "Tab",
            TextColor3 = Theme.SubText,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        
        local TabContent = Create("ScrollingFrame", {
            Parent = ContentContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Accent,
            Visible = false,
        })
        
        local Layout = Create("UIListLayout", {Parent = TabContent, Padding = UDim.new(0, 8)})
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Theme.Tertiary
                tab.Title.TextColor3 = Theme.SubText
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Theme.Accent
            TabTitle.TextColor3 = Theme.Text
        end)
        
        if #Window.Tabs == 0 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Theme.Accent
            TabTitle.TextColor3 = Theme.Text
        end
        
        table.insert(Window.Tabs, {Button = TabButton, Title = TabTitle, Content = TabContent})
        
        -- Elements
        function Tab:Section(cfg)
            Create("TextLabel", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Text = cfg.Title or "Section",
                TextColor3 = Theme.Text,
                TextSize = cfg.TextSize or 18,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
        end
        
        function Tab:Button(cfg)
            local BtnFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = cfg.Color or Theme.Secondary,
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = BtnFrame, CornerRadius = UDim.new(0, 6)})
            
            local Btn = Create("TextButton", {
                Parent = BtnFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = cfg.Title or "Button",
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
            })
            
            Btn.MouseButton1Click:Connect(function()
                if cfg.Callback then cfg.Callback() end
            end)
            
            return Btn
        end
        
        function Tab:Toggle(cfg)
            local value = cfg.Value or false
            local Frame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            
            Create("TextLabel", {
                Parent = Frame,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                Text = cfg.Title or "Toggle",
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local ToggleBtn = Create("TextButton", {
                Parent = Frame,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 40, 0, 20),
                BackgroundColor3 = Theme.Tertiary,
                Text = "",
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = ToggleBtn, CornerRadius = UDim.new(1, 0)})
            
            local Indicator = Create("Frame", {
                Parent = ToggleBtn,
                Position = UDim2.new(0, 2, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundColor3 = Theme.SubText,
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1, 0)})
            
            local function Update()
                if value then
                    Tween(ToggleBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
                    Tween(Indicator, {Position = UDim2.new(1, -2, 0.5, 0), BackgroundColor3 = Theme.Text}, 0.2)
                else
                    Tween(ToggleBtn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                    Tween(Indicator, {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = Theme.SubText}, 0.2)
                end
                if cfg.Callback then cfg.Callback(value) end
                if cfg.Flag then Window.Flags[cfg.Flag] = value end
            end
            
            ToggleBtn.MouseButton1Click:Connect(function()
                value = not value
                Update()
            end)
            
            Update()
            return {Set = function(self, v) value = v Update() end}
        end
        
        function Tab:Slider(cfg)
            local value = cfg.Value.Default or cfg.Value.Min
            local Frame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, cfg.Title and 60 or 40),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            
            if cfg.Title then
                Create("TextLabel", {
                    Parent = Frame,
                    Position = UDim2.new(0, 10, 0, 5),
                    Size = UDim2.new(1, -20, 0, 20),
                    BackgroundTransparency = 1,
                    Text = cfg.Title,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
            end
            
            local Bar = Create("Frame", {
                Parent = Frame,
                Position = cfg.Title and UDim2.new(0, 10, 0, 30) or UDim2.new(0, 10, 0.5, -2),
                Size = UDim2.new(1, -80, 0, 4),
                BackgroundColor3 = Theme.Tertiary,
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(1, 0)})
            
            local Fill = Create("Frame", {
                Parent = Bar,
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
            
            local ValueLabel = Create("TextLabel", {
                Parent = Frame,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = cfg.Title and UDim2.new(1, -10, 0, 32) or UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 50, 0, 20),
                BackgroundTransparency = 1,
                Text = tostring(value),
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Right,
            })
            
            local dragging = false
            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                value = math.floor(cfg.Value.Min + (cfg.Value.Max - cfg.Value.Min) * pos)
                if cfg.Step then value = math.floor(value / cfg.Step) * cfg.Step end
                ValueLabel.Text = tostring(value)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                if cfg.Callback then cfg.Callback(value) end
                if cfg.Flag then Window.Flags[cfg.Flag] = value end
            end
            
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
            end)
            
            local initialPos = (value - cfg.Value.Min) / (cfg.Value.Max - cfg.Value.Min)
            Fill.Size = UDim2.new(initialPos, 0, 1, 0)
            
            return {Set = function(self, v) value = v ValueLabel.Text = tostring(v) end}
        end
        
        function Tab:Input(cfg)
            local Frame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, cfg.Title and 70 or 40),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            
            if cfg.Title then
                Create("TextLabel", {
                    Parent = Frame,
                    Position = UDim2.new(0, 10, 0, 5),
                    Size = UDim2.new(1, -20, 0, 20),
                    BackgroundTransparency = 1,
                    Text = cfg.Title,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
            end
            
            local Box = Create("TextBox", {
                Parent = Frame,
                Position = cfg.Title and UDim2.new(0, 10, 0, 30) or UDim2.new(0, 10, 0, 5),
                Size = cfg.Title and UDim2.new(1, -20, 0, 30) or UDim2.new(1, -20, 1, -10),
                BackgroundColor3 = Theme.Tertiary,
                Text = cfg.Value or "",
                PlaceholderText = cfg.Placeholder or "Enter text...",
                TextColor3 = Theme.Text,
                PlaceholderColor3 = Theme.SubText,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
            Create("UIPadding", {Parent = Box, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})
            
            Box.FocusLost:Connect(function()
                if cfg.Callback then cfg.Callback(Box.Text) end
                if cfg.Flag then Window.Flags[cfg.Flag] = Box.Text end
            end)
            
            return {Set = function(self, text) Box.Text = text end}
        end
        
        function Tab:Dropdown(cfg)
            local selected = cfg.Value or cfg.Values[1]
            local Frame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, cfg.Title and 70 or 40),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
                ClipsDescendants = false,
            })
            
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            
            if cfg.Title then
                Create("TextLabel", {
                    Parent = Frame,
                    Position = UDim2.new(0, 10, 0, 5),
                    Size = UDim2.new(1, -20, 0, 20),
                    BackgroundTransparency = 1,
                    Text = cfg.Title,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
            end
            
            local Btn = Create("TextButton", {
                Parent = Frame,
                Position = cfg.Title and UDim2.new(0, 10, 0, 30) or UDim2.new(0, 10, 0, 5),
                Size = cfg.Title and UDim2.new(1, -20, 0, 30) or UDim2.new(1, -20, 1, -10),
                BackgroundColor3 = Theme.Tertiary,
                Text = "",
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
            
            local Label = Create("TextLabel", {
                Parent = Btn,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -30, 1, 0),
                BackgroundTransparency = 1,
                Text = tostring(selected),
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            Create("TextLabel", {
                Parent = Btn,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = Theme.SubText,
                TextSize = 10,
            })
            
            local List = Create("Frame", {
                Parent = Frame,
                Position = cfg.Title and UDim2.new(0, 10, 0, 65) or UDim2.new(0, 10, 1, 5),
                Size = UDim2.new(1, -20, 0, 0),
                BackgroundColor3 = Theme.Tertiary,
                Visible = false,
                ZIndex = 10,
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = List, CornerRadius = UDim.new(0, 4)})
            Create("UIListLayout", {Parent = List, Padding = UDim.new(0, 2)})
            
            local opened = false
            Btn.MouseButton1Click:Connect(function()
                opened = not opened
                if opened then
                    List.Visible = true
                    Tween(List, {Size = UDim2.new(1, -20, 0, math.min(#cfg.Values * 32, 150))}, 0.2)
                else
                    Tween(List, {Size = UDim2.new(1, -20, 0, 0)}, 0.2)
                    task.wait(0.2)
                    List.Visible = false
                end
            end)
            
            for _, option in ipairs(cfg.Values) do
                local Opt = Create("TextButton", {
                    Parent = List,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = tostring(option),
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                Create("UIPadding", {Parent = Opt, PaddingLeft = UDim.new(0, 10)})
                
                Opt.MouseButton1Click:Connect(function()
                    selected = option
                    Label.Text = tostring(selected)
                    opened = false
                    Tween(List, {Size = UDim2.new(1, -20, 0, 0)}, 0.2)
                    task.wait(0.2)
                    List.Visible = false
                    if cfg.Callback then cfg.Callback(selected) end
                    if cfg.Flag then Window.Flags[cfg.Flag] = selected end
                end)
            end
            
            return {Set = function(self, v) selected = v Label.Text = tostring(v) end}
        end
        
        function Tab:Colorpicker(cfg)
            local color = cfg.Default or Color3.fromRGB(255, 255, 255)
            local Frame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            
            Create("TextLabel", {
                Parent = Frame,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                Text = cfg.Title or "Colorpicker",
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local Display = Create("TextButton", {
                Parent = Frame,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 40, 0, 24),
                BackgroundColor3 = color,
                Text = "",
                BorderSizePixel = 0,
            })
            
            Create("UICorner", {Parent = Display, CornerRadius = UDim.new(0, 4)})
            
            Display.MouseButton1Click:Connect(function()
                -- Cycle through colors
                local colors = {
                    Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0),
                    Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 0),
                    Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255),
                }
                local idx = 1
                for i, c in ipairs(colors) do
                    if c == color then idx = i break end
                end
                color = colors[(idx % #colors) + 1]
                Display.BackgroundColor3 = color
                if cfg.Callback then cfg.Callback(color) end
                if cfg.Flag then Window.Flags[cfg.Flag] = color end
            end)
            
            return {Set = function(self, c) color = c Display.BackgroundColor3 = c end}
        end
        
        function Tab:Space(cfg)
            Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, (cfg and cfg.Columns and cfg.Columns * 4) or 8),
                BackgroundTransparency = 1,
            })
        end
        
        return Tab
    end
    
    function Window:Section(cfg)
        return {Tab = self:Tab(cfg)}
    end
    
    function Window:Notify(cfg)
        local Notif = Create("Frame", {
            Parent = ScreenGui,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -20, 0, 20),
            Size = UDim2.new(0, 300, 0, 0),
            BackgroundColor3 = Theme.Secondary,
            BorderSizePixel = 0,
        })
        
        Create("UICorner", {Parent = Notif, CornerRadius = UDim.new(0, 8)})
        
        Create("TextLabel", {
            Parent = Notif,
            Position = UDim2.new(0, 15, 0, 10),
            Size = UDim2.new(1, -30, 0, 20),
            BackgroundTransparency = 1,
            Text = cfg.Title or "Notification",
            TextColor3 = Theme.Text,
            TextSize = 15,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        
        Create("TextLabel", {
            Parent = Notif,
            Position = UDim2.new(0, 15, 0, 35),
            Size = UDim2.new(1, -30, 0, 40),
            BackgroundTransparency = 1,
            Text = cfg.Content or "",
            TextColor3 = Theme.SubText,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
        })
        
        Tween(Notif, {Size = UDim2.new(0, 300, 0, 80)}, 0.3)
        task.delay(cfg.Duration or 3, function()
            Tween(Notif, {Size = UDim2.new(0, 300, 0, 0)}, 0.3)
            task.wait(0.3)
            Notif:Destroy()
        end)
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    function Window:SetToggleKey(key)
        UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.KeyCode == key then
                Main.Visible = not Main.Visible
            end
        end)
    end
    
    return Window
end

return UILibrary
