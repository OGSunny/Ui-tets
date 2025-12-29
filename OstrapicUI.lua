--[[
    Ostrapic UI Library v2.0
    Clean, Modern UI Library for Roblox
]]

local Ostrapic = {
    Version = "2.0.0",
    Theme = {
        Primary = Color3.fromRGB(99, 102, 241),
        Background = Color3.fromRGB(15, 15, 20),
        Card = Color3.fromRGB(22, 22, 30),
        CardLight = Color3.fromRGB(32, 32, 42),
        Border = Color3.fromRGB(45, 45, 55),
        Text = Color3.fromRGB(240, 240, 245),
        TextDark = Color3.fromRGB(140, 140, 155),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
    }
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local function Tween(obj, props, duration)
    if not obj or not obj.Parent then return end
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function AddCorner(parent, radius)
    local corner = Create("UICorner", {
        CornerRadius = radius or UDim.new(0, 8),
        Parent = parent
    })
    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = Create("UIStroke", {
        Color = color or Ostrapic.Theme.Border,
        Thickness = thickness or 1,
        Transparency = 0.5,
        Parent = parent
    })
    return stroke
end

function Ostrapic:Notify(config)
    config = config or {}
    
    local screenGui = Player:FindFirstChild("PlayerGui"):FindFirstChild("OstrapicNotify")
    if not screenGui then
        screenGui = Create("ScreenGui", {
            Name = "OstrapicNotify",
            ResetOnSpawn = false,
            Parent = Player:FindFirstChild("PlayerGui")
        })
        
        Create("Frame", {
            Name = "Container",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -310, 0, 10),
            Size = UDim2.new(0, 300, 1, -20),
            Parent = screenGui
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = screenGui.Container
        })
    end
    
    local typeColor = {
        Info = self.Theme.Primary,
        Success = self.Theme.Success,
        Warning = self.Theme.Warning,
        Error = self.Theme.Error
    }
    
    local color = typeColor[config.Type] or self.Theme.Primary
    
    local notification = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = self.Theme.Card,
        Size = UDim2.new(1, 0, 0, 65),
        Position = UDim2.new(1, 20, 0, 0),
        Parent = screenGui.Container
    })
    AddCorner(notification, UDim.new(0, 10))
    AddStroke(notification, color, 1)
    
    Create("Frame", {
        Name = "Accent",
        BackgroundColor3 = color,
        Size = UDim2.new(0, 3, 0.7, 0),
        Position = UDim2.new(0, 8, 0.15, 0),
        Parent = notification
    })
    AddCorner(notification.Accent, UDim.new(0, 2))
    
    Create("TextLabel", {
        Name = "Title",
        Text = config.Title or "Notification",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 12),
        Size = UDim2.new(1, -30, 0, 18),
        Parent = notification
    })
    
    Create("TextLabel", {
        Name = "Content",
        Text = config.Content or "",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = self.Theme.TextDark,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 32),
        Size = UDim2.new(1, -30, 0, 25),
        Parent = notification
    })
    
    Tween(notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
    
    task.delay(config.Duration or 4, function()
        Tween(notification, {Position = UDim2.new(1, 20, 0, 0)}, 0.3)
        task.wait(0.3)
        if notification and notification.Parent then
            notification:Destroy()
        end
    end)
end

function Ostrapic:CreateWindow(config)
    config = config or {}
    
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Minimized = false
    }
    
    -- ScreenGui
    local screenGui = Create("ScreenGui", {
        Name = "OstrapicUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    pcall(function()
        screenGui.Parent = game:GetService("CoreGui")
    end)
    if not screenGui.Parent then
        screenGui.Parent = Player:FindFirstChild("PlayerGui")
    end
    
    -- Main Frame
    local main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = self.Theme.Background,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        Parent = screenGui
    })
    AddCorner(main, UDim.new(0, 12))
    AddStroke(main, self.Theme.Border)
    
    -- Drop Shadow
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -20, 0, -20),
        Size = UDim2.new(1, 40, 1, 40),
        ZIndex = -1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = main
    })
    
    -- Top Bar
    local topbar = Create("Frame", {
        Name = "Topbar",
        BackgroundColor3 = self.Theme.Card,
        Size = UDim2.new(1, 0, 0, 50),
        Parent = main
    })
    AddCorner(topbar, UDim.new(0, 12))
    
    -- Fix rounded corners
    Create("Frame", {
        Name = "Fix",
        BackgroundColor3 = self.Theme.Card,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        Parent = topbar
    })
    
    -- Title
    Create("TextLabel", {
        Name = "Title",
        Text = config.Title or "Ostrapic UI",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Parent = topbar
    })
    
    MakeDraggable(main, topbar)
    
    -- Window Buttons
    local buttonContainer = Create("Frame", {
        Name = "Buttons",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0.5, -8),
        Size = UDim2.new(0, 65, 0, 16),
        Parent = topbar
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = buttonContainer
    })
    
    -- Close Button
    local closeBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = self.Theme.Error,
        Size = UDim2.new(0, 14, 0, 14),
        Text = "",
        Parent = buttonContainer
    })
    AddCorner(closeBtn, UDim.new(1, 0))
    
    closeBtn.MouseButton1Click:Connect(function()
        Tween(main, {Size = UDim2.new(0, 0, 0, 0), Position = main.Position + UDim2.new(0, 300, 0, 200)}, 0.25)
        task.wait(0.25)
        screenGui:Destroy()
    end)
    
    -- Minimize Button
    local minBtn = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = self.Theme.Warning,
        Size = UDim2.new(0, 14, 0, 14),
        Text = "",
        Parent = buttonContainer
    })
    AddCorner(minBtn, UDim.new(1, 0))
    
    minBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        Tween(main, {Size = Window.Minimized and UDim2.new(0, 600, 0, 50) or UDim2.new(0, 600, 0, 400)}, 0.3)
    end)
    
    -- Sidebar
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = self.Theme.Card,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(0, 150, 1, -50),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = main
    })
    
    -- Fix corners
    Create("Frame", {
        BackgroundColor3 = self.Theme.Card,
        Position = UDim2.new(1, -12, 0, 0),
        Size = UDim2.new(0, 12, 1, -12),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    Create("Frame", {
        BackgroundColor3 = self.Theme.Card,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(0, 12, 0, 12),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    local tabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(1, -16, 1, -16),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabContainer
    })
    
    -- Content Area
    local contentArea = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 158, 0, 58),
        Size = UDim2.new(1, -166, 1, -66),
        ClipsDescendants = true,
        Parent = main
    })
    
    -- Tab Method
    function Window:Tab(tabConfig)
        tabConfig = tabConfig or {}
        
        local Tab = {
            Elements = {},
            Visible = false
        }
        
        -- Tab Button
        local tabBtn = Create("TextButton", {
            Name = tabConfig.Title or "Tab",
            BackgroundColor3 = Ostrapic.Theme.CardLight,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 36),
            Text = "",
            AutoButtonColor = false,
            Parent = tabContainer
        })
        AddCorner(tabBtn, UDim.new(0, 8))
        
        Create("TextLabel", {
            Name = "Label",
            Text = tabConfig.Title or "Tab",
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = Ostrapic.Theme.TextDark,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -20, 1, 0),
            Parent = tabBtn
        })
        
        -- Tab Content
        local content = Create("ScrollingFrame", {
            Name = tabConfig.Title or "TabContent",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Ostrapic.Theme.Primary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = contentArea
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = content
        })
        
        Create("UIPadding", {
            PaddingRight = UDim.new(0, 8),
            Parent = content
        })
        
        Tab.Button = tabBtn
        Tab.Content = content
        Tab.Label = tabBtn.Label
        
        -- Tab Selection
        local function SelectTab()
            for _, t in pairs(Window.Tabs) do
                t.Content.Visible = false
                Tween(t.Button, {BackgroundTransparency = 1}, 0.15)
                Tween(t.Label, {TextColor3 = Ostrapic.Theme.TextDark}, 0.15)
            end
            
            Tab.Content.Visible = true
            Tween(Tab.Button, {BackgroundTransparency = 0}, 0.15)
            Tween(Tab.Label, {TextColor3 = Ostrapic.Theme.Text}, 0.15)
            Window.CurrentTab = Tab
        end
        
        tabBtn.MouseButton1Click:Connect(SelectTab)
        
        tabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 0.5}, 0.1)
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 1}, 0.1)
            end
        end)
        
        -- Elements
        
        function Tab:Section(sectionConfig)
            sectionConfig = sectionConfig or {}
            
            local section = Create("Frame", {
                Name = "Section",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                Parent = content
            })
            
            Create("TextLabel", {
                Text = sectionConfig.Title or "Section",
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = Ostrapic.Theme.Primary,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 4, 0, 8),
                Size = UDim2.new(1, -8, 0, 16),
                Parent = section
            })
            
            return section
        end
        
        function Tab:Toggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            
            local Toggle = {
                Value = toggleConfig.Default or toggleConfig.Value or false,
                Callback = toggleConfig.Callback or function() end
            }
            
            local container = Create("Frame", {
                Name = "Toggle",
                BackgroundColor3 = Ostrapic.Theme.Card,
                Size = UDim2.new(1, 0, 0, toggleConfig.Desc and 52 or 40),
                Parent = content
            })
            AddCorner(container, UDim.new(0, 10))
            
            Create("TextLabel", {
                Name = "Title",
                Text = toggleConfig.Title or "Toggle",
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, toggleConfig.Desc and 8 or 0),
                Size = UDim2.new(1, -70, 0, toggleConfig.Desc and 20 or 40),
                Parent = container
            })
            
            if toggleConfig.Desc then
                Create("TextLabel", {
                    Name = "Desc",
                    Text = toggleConfig.Desc,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextColor3 = Ostrapic.Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 28),
                    Size = UDim2.new(1, -70, 0, 16),
                    Parent = container
                })
            end
            
            local switch = Create("Frame", {
                Name = "Switch",
                BackgroundColor3 = Toggle.Value and Ostrapic.Theme.Primary or Ostrapic.Theme.CardLight,
                Position = UDim2.new(1, -56, 0.5, -11),
                Size = UDim2.new(0, 42, 0, 22),
                Parent = container
            })
            AddCorner(switch, UDim.new(1, 0))
            
            local knob = Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Ostrapic.Theme.Text,
                Position = Toggle.Value and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Parent = switch
            })
            AddCorner(knob, UDim.new(1, 0))
            
            local function UpdateToggle()
                Toggle.Value = not Toggle.Value
                Tween(switch, {BackgroundColor3 = Toggle.Value and Ostrapic.Theme.Primary or Ostrapic.Theme.CardLight}, 0.2)
                Tween(knob, {Position = Toggle.Value and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, 0.2)
                Toggle.Callback(Toggle.Value)
            end
            
            local btn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = container
            })
            btn.MouseButton1Click:Connect(UpdateToggle)
            
            function Toggle:Set(value)
                if Toggle.Value ~= value then
                    UpdateToggle()
                end
            end
            
            function Toggle:Get()
                return Toggle.Value
            end
            
            if Toggle.Value then
                Toggle.Callback(Toggle.Value)
            end
            
            table.insert(Tab.Elements, Toggle)
            return Toggle
        end
        
        function Tab:Slider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local valueConfig = sliderConfig.Value or {}
            
            local Slider = {
                Value = valueConfig.Default or valueConfig.Min or 0,
                Min = valueConfig.Min or 0,
                Max = valueConfig.Max or 100,
                Step = sliderConfig.Step or 1,
                Callback = sliderConfig.Callback or function() end
            }
            
            local container = Create("Frame", {
                Name = "Slider",
                BackgroundColor3 = Ostrapic.Theme.Card,
                Size = UDim2.new(1, 0, 0, sliderConfig.Desc and 65 or 50),
                Parent = content
            })
            AddCorner(container, UDim.new(0, 10))
            
            Create("TextLabel", {
                Name = "Title",
                Text = sliderConfig.Title or "Slider",
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 8),
                Size = UDim2.new(0.6, 0, 0, 18),
                Parent = container
            })
            
            local valueLabel = Create("TextLabel", {
                Name = "Value",
                Text = tostring(Slider.Value),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Primary,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.6, 0, 0, 8),
                Size = UDim2.new(0.4, -14, 0, 18),
                Parent = container
            })
            
            if sliderConfig.Desc then
                Create("TextLabel", {
                    Name = "Desc",
                    Text = sliderConfig.Desc,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextColor3 = Ostrapic.Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 24),
                    Size = UDim2.new(1, -28, 0, 14),
                    Parent = container
                })
            end
            
            local track = Create("Frame", {
                Name = "Track",
                BackgroundColor3 = Ostrapic.Theme.CardLight,
                Position = UDim2.new(0, 14, 1, -18),
                Size = UDim2.new(1, -28, 0, 6),
                Parent = container
            })
            AddCorner(track, UDim.new(1, 0))
            
            local fill = Create("Frame", {
                Name = "Fill",
                BackgroundColor3 = Ostrapic.Theme.Primary,
                Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0),
                Parent = track
            })
            AddCorner(fill, UDim.new(1, 0))
            
            local knob = Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Ostrapic.Theme.Text,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14),
                ZIndex = 2,
                Parent = track
            })
            AddCorner(knob, UDim.new(1, 0))
            
            local dragging = false
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local rawValue = Slider.Min + (Slider.Max - Slider.Min) * pos
                local stepped = math.floor(rawValue / Slider.Step + 0.5) * Slider.Step
                stepped = math.clamp(stepped, Slider.Min, Slider.Max)
                
                if stepped ~= Slider.Value then
                    Slider.Value = stepped
                    local norm = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
                    fill.Size = UDim2.new(norm, 0, 1, 0)
                    knob.Position = UDim2.new(norm, 0, 0.5, 0)
                    valueLabel.Text = tostring(Slider.Value)
                    Slider.Callback(Slider.Value)
                end
            end
            
            local btn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                ZIndex = 3,
                Parent = track
            })
            
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    Update(input)
                end
            end)
            
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    Update(input)
                end
            end)
            
            function Slider:Set(value)
                Slider.Value = math.clamp(value, Slider.Min, Slider.Max)
                local norm = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
                fill.Size = UDim2.new(norm, 0, 1, 0)
                knob.Position = UDim2.new(norm, 0, 0.5, 0)
                valueLabel.Text = tostring(Slider.Value)
                Slider.Callback(Slider.Value)
            end
            
            function Slider:Get()
                return Slider.Value
            end
            
            table.insert(Tab.Elements, Slider)
            return Slider
        end
        
        function Tab:Button(buttonConfig)
            buttonConfig = buttonConfig or {}
            
            local Button = {
                Callback = buttonConfig.Callback or function() end
            }
            
            local container = Create("TextButton", {
                Name = "Button",
                BackgroundColor3 = buttonConfig.Color or Ostrapic.Theme.Primary,
                Size = UDim2.new(1, 0, 0, 38),
                Text = "",
                AutoButtonColor = false,
                Parent = content
            })
            AddCorner(container, UDim.new(0, 10))
            
            Create("TextLabel", {
                Name = "Title",
                Text = buttonConfig.Title or "Button",
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = container
            })
            
            local originalColor = buttonConfig.Color or Ostrapic.Theme.Primary
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = originalColor:Lerp(Color3.new(1, 1, 1), 0.15)}, 0.1)
            end)
            
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = originalColor}, 0.1)
            end)
            
            container.MouseButton1Click:Connect(function()
                Tween(container, {BackgroundColor3 = originalColor:Lerp(Color3.new(0, 0, 0), 0.15)}, 0.05)
                task.wait(0.05)
                Tween(container, {BackgroundColor3 = originalColor}, 0.1)
                Button.Callback()
            end)
            
            table.insert(Tab.Elements, Button)
            return Button
        end
        
        function Tab:Dropdown(dropdownConfig)
            dropdownConfig = dropdownConfig or {}
            
            local Dropdown = {
                Values = dropdownConfig.Values or {},
                Value = dropdownConfig.Default or dropdownConfig.Value,
                Multi = dropdownConfig.Multi or false,
                Selected = dropdownConfig.Multi and {} or nil,
                Open = false,
                Callback = dropdownConfig.Callback or function() end
            }
            
            local container = Create("Frame", {
                Name = "Dropdown",
                BackgroundColor3 = Ostrapic.Theme.Card,
                Size = UDim2.new(1, 0, 0, 44),
                ClipsDescendants = true,
                Parent = content
            })
            AddCorner(container, UDim.new(0, 10))
            
            Create("TextLabel", {
                Name = "Title",
                Text = dropdownConfig.Title or "Dropdown",
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.5, 0, 0, 44),
                Parent = container
            })
            
            local selectedLabel = Create("TextLabel", {
                Name = "Selected",
                Text = Dropdown.Value or "Select...",
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = Ostrapic.Theme.TextDark,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, -38, 0, 44),
                Parent = container
            })
            
            local arrow = Create("TextLabel", {
                Name = "Arrow",
                Text = "▼",
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                TextColor3 = Ostrapic.Theme.TextDark,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -28, 0, 0),
                Size = UDim2.new(0, 20, 0, 44),
                Parent = container
            })
            
            local optionsFrame = Create("Frame", {
                Name = "Options",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 48),
                Size = UDim2.new(1, -16, 0, 0),
                Parent = container
            })
            
            Create("UIListLayout", {
                Padding = UDim.new(0, 4),
                Parent = optionsFrame
            })
            
            local function RefreshOptions()
                for _, c in pairs(optionsFrame:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                
                for _, val in pairs(Dropdown.Values) do
                    local opt = Create("TextButton", {
                        BackgroundColor3 = Ostrapic.Theme.CardLight,
                        Size = UDim2.new(1, 0, 0, 32),
                        Text = "",
                        AutoButtonColor = false,
                        Parent = optionsFrame
                    })
                    AddCorner(opt, UDim.new(0, 6))
                    
                    local isSelected = Dropdown.Multi and Dropdown.Selected[val] or Dropdown.Value == val
                    
                    Create("TextLabel", {
                        Text = tostring(val),
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        TextColor3 = isSelected and Ostrapic.Theme.Primary or Ostrapic.Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -24, 1, 0),
                        Parent = opt
                    })
                    
                    opt.MouseEnter:Connect(function()
                        Tween(opt, {BackgroundColor3 = Ostrapic.Theme.Card:Lerp(Color3.new(1,1,1), 0.1)}, 0.1)
                    end)
                    
                    opt.MouseLeave:Connect(function()
                        Tween(opt, {BackgroundColor3 = Ostrapic.Theme.CardLight}, 0.1)
                    end)
                    
                    opt.MouseButton1Click:Connect(function()
                        if Dropdown.Multi then
                            Dropdown.Selected[val] = not Dropdown.Selected[val]
                            local list = {}
                            for v, s in pairs(Dropdown.Selected) do
                                if s then table.insert(list, v) end
                            end
                            selectedLabel.Text = #list > 0 and table.concat(list, ", ") or "Select..."
                            Dropdown.Callback(list)
                        else
                            Dropdown.Value = val
                            selectedLabel.Text = tostring(val)
                            Dropdown.Callback(val)
                        end
                        RefreshOptions()
                    end)
                end
                
                local count = #Dropdown.Values
                optionsFrame.Size = UDim2.new(1, -16, 0, count * 36)
            end
            
            RefreshOptions()
            
            local header = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 44),
                Text = "",
                Parent = container
            })
            
            header.MouseButton1Click:Connect(function()
                Dropdown.Open = not Dropdown.Open
                local count = #Dropdown.Values
                local height = Dropdown.Open and (52 + count * 36) or 44
                Tween(container, {Size = UDim2.new(1, 0, 0, height)}, 0.25)
                Tween(arrow, {Rotation = Dropdown.Open and 180 or 0}, 0.25)
            end)
            
            function Dropdown:Set(value)
                if Dropdown.Multi and type(value) == "table" then
                    Dropdown.Selected = {}
                    for _, v in pairs(value) do
                        Dropdown.Selected[v] = true
                    end
                    selectedLabel.Text = #value > 0 and table.concat(value, ", ") or "Select..."
                else
                    Dropdown.Value = value
                    selectedLabel.Text = tostring(value)
                end
                RefreshOptions()
            end
            
            function Dropdown:Refresh(newValues)
                Dropdown.Values = newValues
                RefreshOptions()
            end
            
            function Dropdown:Get()
                if Dropdown.Multi then
                    local list = {}
                    for v, s in pairs(Dropdown.Selected) do
                        if s then table.insert(list, v) end
                    end
                    return list
                end
                return Dropdown.Value
            end
            
            table.insert(Tab.Elements, Dropdown)
            return Dropdown
        end
        
        function Tab:Input(inputConfig)
            inputConfig = inputConfig or {}
            
            local Input = {
                Value = inputConfig.Default or inputConfig.Value or "",
                Callback = inputConfig.Callback or function() end
            }
            
            local container = Create("Frame", {
                Name = "Input",
                BackgroundColor3 = Ostrapic.Theme.Card,
                Size = UDim2.new(1, 0, 0, inputConfig.Desc and 72 or 58),
                Parent = content
            })
            AddCorner(container, UDim.new(0, 10))
            
            Create("TextLabel", {
                Name = "Title",
                Text = inputConfig.Title or "Input",
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 8),
                Size = UDim2.new(1, -28, 0, 18),
                Parent = container
            })
            
            if inputConfig.Desc then
                Create("TextLabel", {
                    Name = "Desc",
                    Text = inputConfig.Desc,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextColor3 = Ostrapic.Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 24),
                    Size = UDim2.new(1, -28, 0, 14),
                    Parent = container
                })
            end
            
            local box = Create("TextBox", {
                Name = "Box",
                BackgroundColor3 = Ostrapic.Theme.CardLight,
                Position = UDim2.new(0, 14, 1, -30),
                Size = UDim2.new(1, -28, 0, 24),
                Text = Input.Value,
                PlaceholderText = inputConfig.Placeholder or "Type here...",
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = Ostrapic.Theme.Text,
                PlaceholderColor3 = Ostrapic.Theme.TextDark,
                ClearTextOnFocus = false,
                Parent = container
            })
            AddCorner(box, UDim.new(0, 6))
            
            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                Parent = box
            })
            
            box.FocusLost:Connect(function()
                Input.Value = box.Text
                Input.Callback(Input.Value)
            end)
            
            function Input:Set(value)
                Input.Value = value
                box.Text = value
            end
            
            function Input:Get()
                return Input.Value
            end
            
            table.insert(Tab.Elements, Input)
            return Input
        end
        
        function Tab:Keybind(keybindConfig)
            keybindConfig = keybindConfig or {}
            
            local Keybind = {
                Value = keybindConfig.Default or keybindConfig.Value or "None",
                Listening = false,
                Callback = keybindConfig.Callback or function() end
            }
            
            local container = Create("Frame", {
                Name = "Keybind",
                BackgroundColor3 = Ostrapic.Theme.Card,
                Size = UDim2.new(1, 0, 0, 44),
                Parent = content
            })
            AddCorner(container, UDim.new(0, 10))
            
            Create("TextLabel", {
                Name = "Title",
                Text = keybindConfig.Title or "Keybind",
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                Parent = container
            })
            
            local keyBtn = Create("TextButton", {
                Name = "Key",
                BackgroundColor3 = Ostrapic.Theme.CardLight,
                Position = UDim2.new(1, -80, 0.5, -13),
                Size = UDim2.new(0, 66, 0, 26),
                Text = Keybind.Value,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = Ostrapic.Theme.Text,
                Parent = container
            })
            AddCorner(keyBtn, UDim.new(0, 6))
            
            keyBtn.MouseButton1Click:Connect(function()
                Keybind.Listening = true
                keyBtn.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if Keybind.Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    Keybind.Value = input.KeyCode.Name
                    keyBtn.Text = Keybind.Value
                    Keybind.Listening = false
                    Keybind.Callback(Keybind.Value)
                end
            end)
            
            function Keybind:Set(value)
                Keybind.Value = value
                keyBtn.Text = value
            end
            
            function Keybind:Get()
                return Keybind.Value
            end
            
            table.insert(Tab.Elements, Keybind)
            return Keybind
        end
        
        function Tab:Colorpicker(colorConfig)
            colorConfig = colorConfig or {}
            
            local Colorpicker = {
                Value = colorConfig.Default or colorConfig.Value or Color3.fromRGB(255, 255, 255),
                Open = false,
                Callback = colorConfig.Callback or function() end
            }
            
            local container = Create("Frame", {
                Name = "Colorpicker",
                BackgroundColor3 = Ostrapic.Theme.Card,
                Size = UDim2.new(1, 0, 0, 44),
                ClipsDescendants = true,
                Parent = content
            })
            AddCorner(container, UDim.new(0, 10))
            
            Create("TextLabel", {
                Name = "Title",
                Text = colorConfig.Title or "Color",
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.6, 0, 0, 44),
                Parent = container
            })
            
            local preview = Create("Frame", {
                Name = "Preview",
                BackgroundColor3 = Colorpicker.Value,
                Position = UDim2.new(1, -50, 0.5, -11),
                Size = UDim2.new(0, 36, 0, 22),
                Parent = container
            })
            AddCorner(preview, UDim.new(0, 6))
            AddStroke(preview, Ostrapic.Theme.Border, 1)
            
            local picker = Create("Frame", {
                Name = "Picker",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 50),
                Size = UDim2.new(1, -28, 0, 110),
                Parent = container
            })
            
            local satVal = Create("Frame", {
                Name = "SatVal",
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                Size = UDim2.new(1, 0, 0, 80),
                Parent = picker
            })
            AddCorner(satVal, UDim.new(0, 8))
            
            Create("UIGradient", {
                Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Parent = satVal
            })
            
            local dark = Create("Frame", {
                BackgroundColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                Parent = satVal
            })
            AddCorner(dark, UDim.new(0, 8))
            
            Create("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }),
                Parent = dark
            })
            
            local hueBar = Create("Frame", {
                Name = "Hue",
                Position = UDim2.new(0, 0, 0, 88),
                Size = UDim2.new(1, 0, 0, 18),
                Parent = picker
            })
            AddCorner(hueBar, UDim.new(0, 6))
            
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }),
                Parent = hueBar
            })
            
            local h, s, v = Color3.toHSV(Colorpicker.Value)
            
            local function UpdateColor()
                Colorpicker.Value = Color3.fromHSV(h, s, v)
                preview.BackgroundColor3 = Colorpicker.Value
                satVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                Colorpicker.Callback(Colorpicker.Value)
            end
            
            local satBtn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = satVal
            })
            
            satBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local drag = true
                    local conn
                    conn = RunService.RenderStepped:Connect(function()
                        if not drag then conn:Disconnect() return end
                        s = math.clamp((Mouse.X - satVal.AbsolutePosition.X) / satVal.AbsoluteSize.X, 0, 1)
                        v = math.clamp(1 - (Mouse.Y - satVal.AbsolutePosition.Y) / satVal.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end)
                    UserInputService.InputEnded:Connect(function(e)
                        if e.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
                    end)
                end
            end)
            
            local hueBtn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = hueBar
            })
            
            hueBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local drag = true
                    local conn
                    conn = RunService.RenderStepped:Connect(function()
                        if not drag then conn:Disconnect() return end
                        h = math.clamp((Mouse.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                        UpdateColor()
                    end)
                    UserInputService.InputEnded:Connect(function(e)
                        if e.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
                    end)
                end
            end)
            
            local header = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 44),
                Text = "",
                Parent = container
            })
            
            header.MouseButton1Click:Connect(function()
                Colorpicker.Open = not Colorpicker.Open
                Tween(container, {Size = UDim2.new(1, 0, 0, Colorpicker.Open and 170 or 44)}, 0.25)
            end)
            
            function Colorpicker:Set(color)
                Colorpicker.Value = color
                preview.BackgroundColor3 = color
                h, s, v = Color3.toHSV(color)
                satVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            end
            
            function Colorpicker:Get()
                return Colorpicker.Value
            end
            
            table.insert(Tab.Elements, Colorpicker)
            return Colorpicker
        end
        
        function Tab:Label(labelConfig)
            labelConfig = labelConfig or {}
            
            local lbl = Create("TextLabel", {
                Name = "Label",
                Text = labelConfig.Text or "Label",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = labelConfig.Color or Ostrapic.Theme.TextDark,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 22),
                Parent = content
            })
            
            local Label = {Label = lbl}
            function Label:Set(text)
                lbl.Text = text
            end
            
            return Label
        end
        
        function Tab:Paragraph(paragraphConfig)
            paragraphConfig = paragraphConfig or {}
            
            local container = Create("Frame", {
                Name = "Paragraph",
                BackgroundColor3 = Ostrapic.Theme.Card,
                Size = UDim2.new(1, 0, 0, 75),
                Parent = content
            })
            AddCorner(container, UDim.new(0, 10))
            
            local title = Create("TextLabel", {
                Name = "Title",
                Text = paragraphConfig.Title or "Paragraph",
                Font = Enum.Font.GothamBold,
                TextSize = 15,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 10),
                Size = UDim2.new(1, -28, 0, 20),
                Parent = container
            })
            
            local desc = Create("TextLabel", {
                Name = "Content",
                Text = paragraphConfig.Content or "",
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = Ostrapic.Theme.TextDark,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 32),
                Size = UDim2.new(1, -28, 1, -42),
                Parent = container
            })
            
            local Paragraph = {Title = title, Content = desc}
            function Paragraph:Set(newTitle, newContent)
                if newTitle then title.Text = newTitle end
                if newContent then desc.Text = newContent end
            end
            
            return Paragraph
        end
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            SelectTab()
        end
        
        return Tab
    end
    
    function Window:Destroy()
        screenGui:Destroy()
    end
    
    return Window
end

function Ostrapic:SetTheme(theme)
    for k, v in pairs(theme) do
        if self.Theme[k] then
            self.Theme[k] = v
        end
    end
end

return Ostrapic
