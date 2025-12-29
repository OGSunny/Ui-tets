--[[
    Ostrapic UI Library
    A modern, customizable UI library for Roblox
    
    Usage:
    local Ostrapic = loadstring(game:HttpGet("YOUR_URL_HERE"))()
    local Window = Ostrapic:CreateWindow({ Title = "My Hub" })
    local Tab = Window:Tab({ Title = "Main" })
    Tab:Toggle({ Title = "My Toggle", Callback = function(v) print(v) end })
]]

local Ostrapic = {
    Version = "1.0.0",
    Windows = {},
    Theme = {
        Primary = Color3.fromRGB(88, 101, 242),
        Secondary = Color3.fromRGB(35, 35, 45),
        Background = Color3.fromRGB(25, 25, 35),
        Surface = Color3.fromRGB(40, 40, 55),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 190),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(237, 66, 69),
        Accent = Color3.fromRGB(114, 137, 218),
    }
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Utility Functions
local function Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

local function Tween(instance, properties, duration, style, direction)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = radius or UDim.new(0, 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Ostrapic.Theme.Primary,
        Thickness = thickness or 1,
        Parent = parent
    })
end

local function AddPadding(parent, padding)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, padding or 8),
        PaddingBottom = UDim.new(0, padding or 8),
        PaddingLeft = UDim.new(0, padding or 8),
        PaddingRight = UDim.new(0, padding or 8),
        Parent = parent
    })
end

-- Main ScreenGui
local function CreateScreenGui()
    local gui = Create("ScreenGui", {
        Name = "OstrapicUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    pcall(function()
        gui.Parent = CoreGui
    end)
    
    if not gui.Parent then
        gui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    return gui
end

-- Notification System
function Ostrapic:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 5
    local notifyType = options.Type or "Info"
    
    local typeColors = {
        Info = self.Theme.Primary,
        Success = self.Theme.Success,
        Warning = self.Theme.Warning,
        Error = self.Theme.Error
    }
    
    local gui = self.NotificationGui or CreateScreenGui()
    self.NotificationGui = gui
    
    local container = gui:FindFirstChild("NotifyContainer") or Create("Frame", {
        Name = "NotifyContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -320, 0, 10),
        Size = UDim2.new(0, 300, 1, -20),
        Parent = gui
    }, {
        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        })
    })
    
    local notification = Create("Frame", {
        BackgroundColor3 = self.Theme.Surface,
        Size = UDim2.new(1, 0, 0, 70),
        Position = UDim2.new(1, 0, 0, 0),
        Parent = container
    })
    AddCorner(notification)
    AddStroke(notification, typeColors[notifyType], 2)
    
    local accent = Create("Frame", {
        BackgroundColor3 = typeColors[notifyType],
        Size = UDim2.new(0, 4, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        Parent = notification
    })
    AddCorner(accent, UDim.new(0, 2))
    
    Create("TextLabel", {
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 10),
        Size = UDim2.new(1, -30, 0, 20),
        Parent = notification
    })
    
    Create("TextLabel", {
        Text = content,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = self.Theme.TextDark,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 32),
        Size = UDim2.new(1, -30, 0, 30),
        Parent = notification
    })
    
    Tween(notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
    
    task.delay(duration, function()
        Tween(notification, {Position = UDim2.new(1, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        notification:Destroy()
    end)
end

-- Window Creation
function Ostrapic:CreateWindow(options)
    options = options or {}
    local window = {
        Title = options.Title or "Ostrapic UI",
        Size = options.Size or UDim2.fromOffset(650, 450),
        Tabs = {},
        CurrentTab = nil,
        Minimized = false,
        Elements = {}
    }
    
    local gui = CreateScreenGui()
    window.Gui = gui
    
    -- Main Frame
    local mainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = self.Theme.Background,
        Position = UDim2.new(0.5, -325, 0.5, -225),
        Size = window.Size,
        ClipsDescendants = true,
        Parent = gui
    })
    AddCorner(mainFrame, UDim.new(0, 12))
    AddStroke(mainFrame, self.Theme.Surface, 2)
    window.MainFrame = mainFrame
    
    -- Shadow
    local shadow = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = -1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = mainFrame
    })
    
    -- Topbar
    local topbar = Create("Frame", {
        Name = "Topbar",
        BackgroundColor3 = self.Theme.Surface,
        Size = UDim2.new(1, 0, 0, 45),
        Parent = mainFrame
    })
    AddCorner(topbar, UDim.new(0, 12))
    
    -- Cover bottom corners of topbar
    Create("Frame", {
        BackgroundColor3 = self.Theme.Surface,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        Parent = topbar
    })
    
    -- Title
    Create("TextLabel", {
        Text = window.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Parent = topbar
    })
    
    -- Window Controls
    local controls = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -90, 0, 0),
        Size = UDim2.new(0, 80, 1, 0),
        Parent = topbar
    })
    
    local function CreateControlButton(position, color, callback)
        local btn = Create("TextButton", {
            BackgroundColor3 = color,
            Position = position,
            Size = UDim2.new(0, 16, 0, 16),
            Text = "",
            Parent = controls
        })
        AddCorner(btn, UDim.new(1, 0))
        
        btn.MouseButton1Click:Connect(callback)
        btn.MouseEnter:Connect(function()
            Tween(btn, {Size = UDim2.new(0, 18, 0, 18)}, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {Size = UDim2.new(0, 16, 0, 16)}, 0.1)
        end)
        
        return btn
    end
    
    -- Minimize Button
    CreateControlButton(
        UDim2.new(0, 10, 0.5, -8),
        self.Theme.Warning,
        function()
            window.Minimized = not window.Minimized
            if window.Minimized then
                Tween(mainFrame, {Size = UDim2.new(0, window.Size.X.Offset, 0, 45)}, 0.3)
            else
                Tween(mainFrame, {Size = window.Size}, 0.3)
            end
        end
    )
    
    -- Close Button
    CreateControlButton(
        UDim2.new(0, 35, 0.5, -8),
        self.Theme.Error,
        function()
            Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
            task.wait(0.3)
            gui:Destroy()
        end
    )
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Tab Container (Sidebar)
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = self.Theme.Surface,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(0, 160, 1, -45),
        Parent = mainFrame
    })
    
    Create("Frame", {
        BackgroundColor3 = self.Theme.Surface,
        Position = UDim2.new(1, -12, 0, 0),
        Size = UDim2.new(0, 12, 1, 0),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    local tabList = Create("ScrollingFrame", {
        Name = "TabList",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -20),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = sidebar
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabList
    })
    AddPadding(tabList, 5)
    
    -- Content Container
    local contentContainer = Create("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 165, 0, 50),
        Size = UDim2.new(1, -175, 1, -60),
        ClipsDescendants = true,
        Parent = mainFrame
    })
    window.ContentContainer = contentContainer
    
    -- Tab Creation Method
    function window:Tab(tabOptions)
        tabOptions = tabOptions or {}
        local tab = {
            Title = tabOptions.Title or "Tab",
            Icon = tabOptions.Icon,
            Elements = {},
            Visible = false
        }
        
        -- Tab Button
        local tabButton = Create("TextButton", {
            Name = tab.Title,
            BackgroundColor3 = Ostrapic.Theme.Background,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 35),
            Text = "",
            Parent = tabList
        })
        AddCorner(tabButton, UDim.new(0, 6))
        
        Create("TextLabel", {
            Text = tab.Title,
            Font = Enum.Font.GothamSemibold,
            TextSize = 13,
            TextColor3 = Ostrapic.Theme.TextDark,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -15, 1, 0),
            Parent = tabButton
        })
        tab.Button = tabButton
        tab.Label = tabButton:FindFirstChildOfClass("TextLabel")
        
        -- Tab Content
        local tabContent = Create("ScrollingFrame", {
            Name = tab.Title .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Ostrapic.Theme.Primary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = contentContainer
        })
        
        local contentLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent
        })
        AddPadding(tabContent, 5)
        tab.Content = tabContent
        
        -- Auto-size canvas
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection
        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do
                t.Content.Visible = false
                t.Button.BackgroundTransparency = 1
                Tween(t.Label, {TextColor3 = Ostrapic.Theme.TextDark}, 0.2)
            end
            tab.Content.Visible = true
            Tween(tabButton, {BackgroundTransparency = 0}, 0.2)
            Tween(tab.Label, {TextColor3 = Ostrapic.Theme.Text}, 0.2)
            self.CurrentTab = tab
        end)
        
        tabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab then
                Tween(tabButton, {BackgroundTransparency = 0.5}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab then
                Tween(tabButton, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        -- Update tab list canvas size
        local listLayout = tabList:FindFirstChildOfClass("UIListLayout")
        tabList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        
        -- Element Methods
        
        -- Section
        function tab:Section(sectionOptions)
            sectionOptions = sectionOptions or {}
            local sectionFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 25),
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Text = sectionOptions.Title or "Section",
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Primary,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = sectionFrame
            })
            
            return sectionFrame
        end
        
        -- Toggle
        function tab:Toggle(toggleOptions)
            toggleOptions = toggleOptions or {}
            local toggle = {
                Value = toggleOptions.Value or toggleOptions.Default or false,
                Callback = toggleOptions.Callback or function() end,
                Flag = toggleOptions.Flag
            }
            
            local toggleFrame = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Surface,
                Size = UDim2.new(1, -10, 0, toggleOptions.Desc and 55 or 40),
                Parent = tabContent
            })
            AddCorner(toggleFrame, UDim.new(0, 8))
            
            Create("TextLabel", {
                Text = toggleOptions.Title or "Toggle",
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, toggleOptions.Desc and 8 or 0),
                Size = UDim2.new(1, -70, 0, toggleOptions.Desc and 22 or 40),
                Parent = toggleFrame
            })
            
            if toggleOptions.Desc then
                Create("TextLabel", {
                    Text = toggleOptions.Desc,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextColor3 = Ostrapic.Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 28),
                    Size = UDim2.new(1, -70, 0, 20),
                    Parent = toggleFrame
                })
            end
            
            local toggleButton = Create("Frame", {
                BackgroundColor3 = toggle.Value and Ostrapic.Theme.Primary or Ostrapic.Theme.Background,
                Position = UDim2.new(1, -55, 0.5, -12),
                Size = UDim2.new(0, 44, 0, 24),
                Parent = toggleFrame
            })
            AddCorner(toggleButton, UDim.new(1, 0))
            
            local toggleCircle = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Text,
                Position = toggle.Value and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9),
                Size = UDim2.new(0, 18, 0, 18),
                Parent = toggleButton
            })
            AddCorner(toggleCircle, UDim.new(1, 0))
            
            local function UpdateToggle()
                toggle.Value = not toggle.Value
                Tween(toggleButton, {BackgroundColor3 = toggle.Value and Ostrapic.Theme.Primary or Ostrapic.Theme.Background}, 0.2)
                Tween(toggleCircle, {Position = toggle.Value and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)}, 0.2)
                toggle.Callback(toggle.Value)
            end
            
            local clickDetector = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = toggleFrame
            })
            
            clickDetector.MouseButton1Click:Connect(UpdateToggle)
            
            function toggle:Set(value)
                if toggle.Value ~= value then
                    UpdateToggle()
                end
            end
            
            function toggle:Get()
                return toggle.Value
            end
            
            if toggle.Value then
                toggle.Callback(toggle.Value)
            end
            
            table.insert(tab.Elements, toggle)
            return toggle
        end
        
        -- Slider
        function tab:Slider(sliderOptions)
            sliderOptions = sliderOptions or {}
            local valueConfig = sliderOptions.Value or {}
            local slider = {
                Value = valueConfig.Default or valueConfig.Min or 0,
                Min = valueConfig.Min or 0,
                Max = valueConfig.Max or 100,
                Step = sliderOptions.Step or 1,
                Callback = sliderOptions.Callback or function() end,
                Flag = sliderOptions.Flag
            }
            
            local sliderFrame = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Surface,
                Size = UDim2.new(1, -10, 0, sliderOptions.Desc and 70 or 55),
                Parent = tabContent
            })
            AddCorner(sliderFrame, UDim.new(0, 8))
            
            Create("TextLabel", {
                Text = sliderOptions.Title or "Slider",
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 8),
                Size = UDim2.new(0.6, 0, 0, 20),
                Parent = sliderFrame
            })
            
            local valueLabel = Create("TextLabel", {
                Text = tostring(slider.Value),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Primary,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.6, 0, 0, 8),
                Size = UDim2.new(0.4, -15, 0, 20),
                Parent = sliderFrame
            })
            
            if sliderOptions.Desc then
                Create("TextLabel", {
                    Text = sliderOptions.Desc,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextColor3 = Ostrapic.Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 26),
                    Size = UDim2.new(1, -24, 0, 16),
                    Parent = sliderFrame
                })
            end
            
            local sliderBar = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Background,
                Position = UDim2.new(0, 12, 1, -22),
                Size = UDim2.new(1, -24, 0, 8),
                Parent = sliderFrame
            })
            AddCorner(sliderBar, UDim.new(1, 0))
            
            local sliderFill = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Primary,
                Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0),
                Parent = sliderBar
            })
            AddCorner(sliderFill, UDim.new(1, 0))
            
            local sliderKnob = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Text,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                ZIndex = 2,
                Parent = sliderBar
            })
            AddCorner(sliderKnob, UDim.new(1, 0))
            
            local dragging = false
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                local rawValue = slider.Min + (slider.Max - slider.Min) * pos
                local steppedValue = math.floor(rawValue / slider.Step + 0.5) * slider.Step
                steppedValue = math.clamp(steppedValue, slider.Min, slider.Max)
                
                if steppedValue ~= slider.Value then
                    slider.Value = steppedValue
                    local normalizedPos = (slider.Value - slider.Min) / (slider.Max - slider.Min)
                    Tween(sliderFill, {Size = UDim2.new(normalizedPos, 0, 1, 0)}, 0.05)
                    Tween(sliderKnob, {Position = UDim2.new(normalizedPos, 0, 0.5, 0)}, 0.05)
                    valueLabel.Text = tostring(slider.Value)
                    slider.Callback(slider.Value)
                end
            end
            
            local clickDetector = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                ZIndex = 3,
                Parent = sliderBar
            })
            
            clickDetector.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            clickDetector.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            function slider:Set(value)
                slider.Value = math.clamp(value, slider.Min, slider.Max)
                local normalizedPos = (slider.Value - slider.Min) / (slider.Max - slider.Min)
                Tween(sliderFill, {Size = UDim2.new(normalizedPos, 0, 1, 0)}, 0.1)
                Tween(sliderKnob, {Position = UDim2.new(normalizedPos, 0, 0.5, 0)}, 0.1)
                valueLabel.Text = tostring(slider.Value)
                slider.Callback(slider.Value)
            end
            
            function slider:Get()
                return slider.Value
            end
            
            table.insert(tab.Elements, slider)
            return slider
        end
        
        -- Button
        function tab:Button(buttonOptions)
            buttonOptions = buttonOptions or {}
            local button = {
                Callback = buttonOptions.Callback or function() end
            }
            
            local buttonFrame = Create("TextButton", {
                BackgroundColor3 = buttonOptions.Color or Ostrapic.Theme.Primary,
                Size = UDim2.new(1, -10, 0, buttonOptions.Desc and 50 or 38),
                Text = "",
                Parent = tabContent
            })
            AddCorner(buttonFrame, UDim.new(0, 8))
            
            Create("TextLabel", {
                Text = buttonOptions.Title or "Button",
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Center,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, buttonOptions.Desc and 8 or 0),
                Size = UDim2.new(1, 0, 0, buttonOptions.Desc and 22 or 38),
                Parent = buttonFrame
            })
            
            if buttonOptions.Desc then
                Create("TextLabel", {
                    Text = buttonOptions.Desc,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextColor3 = Color3.fromRGB(200, 200, 210),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 28),
                    Size = UDim2.new(1, 0, 0, 18),
                    Parent = buttonFrame
                })
            end
            
            buttonFrame.MouseButton1Click:Connect(function()
                -- Click animation
                Tween(buttonFrame, {Size = UDim2.new(1, -14, 0, buttonOptions.Desc and 48 or 36)}, 0.1)
                task.wait(0.1)
                Tween(buttonFrame, {Size = UDim2.new(1, -10, 0, buttonOptions.Desc and 50 or 38)}, 0.1)
                button.Callback()
            end)
            
            buttonFrame.MouseEnter:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = (buttonOptions.Color or Ostrapic.Theme.Primary):Lerp(Color3.new(1,1,1), 0.1)}, 0.2)
            end)
            
            buttonFrame.MouseLeave:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = buttonOptions.Color or Ostrapic.Theme.Primary}, 0.2)
            end)
            
            table.insert(tab.Elements, button)
            return button
        end
        
        -- Dropdown
        function tab:Dropdown(dropdownOptions)
            dropdownOptions = dropdownOptions or {}
            local dropdown = {
                Values = dropdownOptions.Values or {},
                Value = dropdownOptions.Value or dropdownOptions.Default,
                Multi = dropdownOptions.Multi or false,
                Selected = dropdownOptions.Multi and {} or nil,
                Callback = dropdownOptions.Callback or function() end,
                Open = false,
                Flag = dropdownOptions.Flag
            }
            
            local dropdownFrame = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Surface,
                Size = UDim2.new(1, -10, 0, 45),
                ClipsDescendants = true,
                Parent = tabContent
            })
            AddCorner(dropdownFrame, UDim.new(0, 8))
            
            Create("TextLabel", {
                Text = dropdownOptions.Title or "Dropdown",
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.5, 0, 0, 45),
                Parent = dropdownFrame
            })
            
            local selectedLabel = Create("TextLabel", {
                Text = dropdown.Value or "Select...",
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = Ostrapic.Theme.TextDark,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, -40, 0, 45),
                Parent = dropdownFrame
            })
            
            local arrow = Create("TextLabel", {
                Text = "▼",
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                TextColor3 = Ostrapic.Theme.TextDark,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0, 0),
                Size = UDim2.new(0, 20, 0, 45),
                Parent = dropdownFrame
            })
            
            local optionsContainer = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 50),
                Size = UDim2.new(1, -10, 0, 0),
                Parent = dropdownFrame
            })
            
            local optionsLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 3),
                Parent = optionsContainer
            })
            
            local function UpdateOptions()
                for _, child in pairs(optionsContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                for _, value in pairs(dropdown.Values) do
                    local optionButton = Create("TextButton", {
                        BackgroundColor3 = Ostrapic.Theme.Background,
                        Size = UDim2.new(1, 0, 0, 32),
                        Text = "",
                        Parent = optionsContainer
                    })
                    AddCorner(optionButton, UDim.new(0, 6))
                    
                    local isSelected = dropdown.Multi and dropdown.Selected[value] or dropdown.Value == value
                    
                    Create("TextLabel", {
                        Text = tostring(value),
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        TextColor3 = isSelected and Ostrapic.Theme.Primary or Ostrapic.Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, -20, 1, 0),
                        Parent = optionButton
                    })
                    
                    optionButton.MouseButton1Click:Connect(function()
                        if dropdown.Multi then
                            dropdown.Selected[value] = not dropdown.Selected[value]
                            local selectedList = {}
                            for v, selected in pairs(dropdown.Selected) do
                                if selected then
                                    table.insert(selectedList, v)
                                end
                            end
                            selectedLabel.Text = #selectedList > 0 and table.concat(selectedList, ", ") or "Select..."
                            dropdown.Callback(selectedList)
                        else
                            dropdown.Value = value
                            selectedLabel.Text = tostring(value)
                            dropdown.Callback(value)
                        end
                        UpdateOptions()
                    end)
                    
                    optionButton.MouseEnter:Connect(function()
                        Tween(optionButton, {BackgroundColor3 = Ostrapic.Theme.Surface}, 0.1)
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        Tween(optionButton, {BackgroundColor3 = Ostrapic.Theme.Background}, 0.1)
                    end)
                end
                
                optionsContainer.Size = UDim2.new(1, -10, 0, optionsLayout.AbsoluteContentSize.Y)
            end
            
            UpdateOptions()
            
            local headerButton = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45),
                Text = "",
                Parent = dropdownFrame
            })
            
            headerButton.MouseButton1Click:Connect(function()
                dropdown.Open = not dropdown.Open
                local optionCount = #dropdown.Values
                local targetHeight = dropdown.Open and (50 + (optionCount * 35) + 10) or 45
                Tween(dropdownFrame, {Size = UDim2.new(1, -10, 0, targetHeight)}, 0.2)
                Tween(arrow, {Rotation = dropdown.Open and 180 or 0}, 0.2)
            end)
            
            function dropdown:Set(value)
                if dropdown.Multi and type(value) == "table" then
                    dropdown.Selected = {}
                    for _, v in pairs(value) do
                        dropdown.Selected[v] = true
                    end
                    selectedLabel.Text = #value > 0 and table.concat(value, ", ") or "Select..."
                else
                    dropdown.Value = value
                    selectedLabel.Text = tostring(value)
                end
                UpdateOptions()
            end
            
            function dropdown:Refresh(newValues)
                dropdown.Values = newValues
                UpdateOptions()
            end
            
            function dropdown:Get()
                if dropdown.Multi then
                    local selected = {}
                    for v, s in pairs(dropdown.Selected) do
                        if s then table.insert(selected, v) end
                    end
                    return selected
                end
                return dropdown.Value
            end
            
            table.insert(tab.Elements, dropdown)
            return dropdown
        end
        
        -- Keybind
        function tab:Keybind(keybindOptions)
            keybindOptions = keybindOptions or {}
            local keybind = {
                Value = keybindOptions.Value or keybindOptions.Default or "None",
                Callback = keybindOptions.Callback or function() end,
                Listening = false,
                Flag = keybindOptions.Flag
            }
            
            local keybindFrame = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Surface,
                Size = UDim2.new(1, -10, 0, 45),
                Parent = tabContent
            })
            AddCorner(keybindFrame, UDim.new(0, 8))
            
            Create("TextLabel", {
                Text = keybindOptions.Title or "Keybind",
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                Parent = keybindFrame
            })
            
            local keybindButton = Create("TextButton", {
                BackgroundColor3 = Ostrapic.Theme.Background,
                Position = UDim2.new(1, -90, 0.5, -14),
                Size = UDim2.new(0, 80, 0, 28),
                Text = keybind.Value,
                Font = Enum.Font.GothamSemibold,
                TextSize = 12,
                TextColor3 = Ostrapic.Theme.Text,
                Parent = keybindFrame
            })
            AddCorner(keybindButton, UDim.new(0, 6))
            
            keybindButton.MouseButton1Click:Connect(function()
                keybind.Listening = true
                keybindButton.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if keybind.Listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        keybind.Value = input.KeyCode.Name
                        keybindButton.Text = keybind.Value
                        keybind.Listening = false
                        keybind.Callback(keybind.Value)
                    end
                end
            end)
            
            function keybind:Set(value)
                keybind.Value = value
                keybindButton.Text = value
            end
            
            function keybind:Get()
                return keybind.Value
            end
            
            table.insert(tab.Elements, keybind)
            return keybind
        end
        
        -- Input
        function tab:Input(inputOptions)
            inputOptions = inputOptions or {}
            local input = {
                Value = inputOptions.Value or inputOptions.Default or "",
                Callback = inputOptions.Callback or function() end,
                Flag = inputOptions.Flag
            }
            
            local inputFrame = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Surface,
                Size = UDim2.new(1, -10, 0, inputOptions.Desc and 75 or 60),
                Parent = tabContent
            })
            AddCorner(inputFrame, UDim.new(0, 8))
            
            Create("TextLabel", {
                Text = inputOptions.Title or "Input",
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 8),
                Size = UDim2.new(1, -24, 0, 20),
                Parent = inputFrame
            })
            
            if inputOptions.Desc then
                Create("TextLabel", {
                    Text = inputOptions.Desc,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextColor3 = Ostrapic.Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 26),
                    Size = UDim2.new(1, -24, 0, 16),
                    Parent = inputFrame
                })
            end
            
            local textBox = Create("TextBox", {
                BackgroundColor3 = Ostrapic.Theme.Background,
                Position = UDim2.new(0, 12, 1, -32),
                Size = UDim2.new(1, -24, 0, 26),
                Text = input.Value,
                PlaceholderText = inputOptions.Placeholder or "Enter text...",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Ostrapic.Theme.Text,
                PlaceholderColor3 = Ostrapic.Theme.TextDark,
                ClearTextOnFocus = false,
                Parent = inputFrame
            })
            AddCorner(textBox, UDim.new(0, 6))
            AddPadding(textBox, 6)
            
            textBox.FocusLost:Connect(function()
                input.Value = textBox.Text
                input.Callback(input.Value)
            end)
            
            function input:Set(value)
                input.Value = value
                textBox.Text = value
            end
            
            function input:Get()
                return input.Value
            end
            
            table.insert(tab.Elements, input)
            return input
        end
        
        -- Colorpicker
        function tab:Colorpicker(colorpickerOptions)
            colorpickerOptions = colorpickerOptions or {}
            local colorpicker = {
                Value = colorpickerOptions.Value or colorpickerOptions.Default or Color3.fromRGB(255, 255, 255),
                Callback = colorpickerOptions.Callback or function() end,
                Open = false,
                Flag = colorpickerOptions.Flag
            }
            
            local colorFrame = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Surface,
                Size = UDim2.new(1, -10, 0, 45),
                ClipsDescendants = true,
                Parent = tabContent
            })
            AddCorner(colorFrame, UDim.new(0, 8))
            
            Create("TextLabel", {
                Text = colorpickerOptions.Title or "Color",
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.6, 0, 0, 45),
                Parent = colorFrame
            })
            
            local colorPreview = Create("Frame", {
                BackgroundColor3 = colorpicker.Value,
                Position = UDim2.new(1, -50, 0.5, -12),
                Size = UDim2.new(0, 40, 0, 24),
                Parent = colorFrame
            })
            AddCorner(colorPreview, UDim.new(0, 6))
            AddStroke(colorPreview, Ostrapic.Theme.Background, 2)
            
            local pickerContainer = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 50),
                Size = UDim2.new(1, -24, 0, 120),
                Parent = colorFrame
            })
            
            -- Color gradient
            local colorGradient = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                Size = UDim2.new(1, 0, 0, 80),
                Parent = pickerContainer
            })
            AddCorner(colorGradient, UDim.new(0, 6))
            
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Parent = colorGradient
            })
            
            local darkOverlay = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = colorGradient
            })
            AddCorner(darkOverlay, UDim.new(0, 6))
            
            Create("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }),
                Parent = darkOverlay
            })
            
            -- Hue slider
            local hueSlider = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(0, 0, 0, 90),
                Size = UDim2.new(1, 0, 0, 20),
                Parent = pickerContainer
            })
            AddCorner(hueSlider, UDim.new(0, 6))
            
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
                Parent = hueSlider
            })
            
            local hue, sat, val = 0, 1, 1
            
            local function UpdateColor()
                colorpicker.Value = Color3.fromHSV(hue, sat, val)
                colorPreview.BackgroundColor3 = colorpicker.Value
                colorGradient.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                colorpicker.Callback(colorpicker.Value)
            end
            
            local colorButton = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = colorGradient
            })
            
            colorButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local dragging = true
                    local conn
                    conn = RunService.RenderStepped:Connect(function()
                        if not dragging then conn:Disconnect() return end
                        local pos = Vector2.new(Mouse.X, Mouse.Y)
                        sat = math.clamp((pos.X - colorGradient.AbsolutePosition.X) / colorGradient.AbsoluteSize.X, 0, 1)
                        val = math.clamp(1 - (pos.Y - colorGradient.AbsolutePosition.Y) / colorGradient.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end)
                    
                    UserInputService.InputEnded:Connect(function(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                end
            end)
            
            local hueButton = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = hueSlider
            })
            
            hueButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local dragging = true
                    local conn
                    conn = RunService.RenderStepped:Connect(function()
                        if not dragging then conn:Disconnect() return end
                        hue = math.clamp((Mouse.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
                        UpdateColor()
                    end)
                    
                    UserInputService.InputEnded:Connect(function(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                end
            end)
            
            local headerButton = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45),
                Text = "",
                Parent = colorFrame
            })
            
            headerButton.MouseButton1Click:Connect(function()
                colorpicker.Open = not colorpicker.Open
                Tween(colorFrame, {Size = UDim2.new(1, -10, 0, colorpicker.Open and 180 or 45)}, 0.2)
            end)
            
            function colorpicker:Set(color)
                colorpicker.Value = color
                colorPreview.BackgroundColor3 = color
                hue, sat, val = Color3.toHSV(color)
                colorGradient.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            end
            
            function colorpicker:Get()
                return colorpicker.Value
            end
            
            table.insert(tab.Elements, colorpicker)
            return colorpicker
        end
        
        -- Label
        function tab:Label(labelOptions)
            labelOptions = labelOptions or {}
            
            local labelFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 25),
                Parent = tabContent
            })
            
            local label = Create("TextLabel", {
                Text = labelOptions.Text or "Label",
                Font = Enum.Font.Gotham,
                TextSize = labelOptions.TextSize or 14,
                TextColor3 = labelOptions.Color or Ostrapic.Theme.TextDark,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = labelFrame
            })
            
            local labelObj = {Frame = labelFrame, Label = label}
            
            function labelObj:Set(text)
                label.Text = text
            end
            
            return labelObj
        end
        
        -- Paragraph
        function tab:Paragraph(paragraphOptions)
            paragraphOptions = paragraphOptions or {}
            
            local paragraphFrame = Create("Frame", {
                BackgroundColor3 = Ostrapic.Theme.Surface,
                Size = UDim2.new(1, -10, 0, 80),
                Parent = tabContent
            })
            AddCorner(paragraphFrame, UDim.new(0, 8))
            
            local title = Create("TextLabel", {
                Text = paragraphOptions.Title or "Paragraph",
                Font = Enum.Font.GothamBold,
                TextSize = 15,
                TextColor3 = Ostrapic.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 10),
                Size = UDim2.new(1, -24, 0, 22),
                Parent = paragraphFrame
            })
            
            local content = Create("TextLabel", {
                Text = paragraphOptions.Content or "",
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = Ostrapic.Theme.TextDark,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 35),
                Size = UDim2.new(1, -24, 1, -45),
                Parent = paragraphFrame
            })
            
            local paragraph = {Frame = paragraphFrame, Title = title, Content = content}
            
            function paragraph:Set(newTitle, newContent)
                title.Text = newTitle or title.Text
                content.Text = newContent or content.Text
            end
            
            return paragraph
        end
        
        table.insert(self.Tabs, tab)
        
        -- Select first tab by default
        if #self.Tabs == 1 then
            tab.Content.Visible = true
            Tween(tabButton, {BackgroundTransparency = 0}, 0.2)
            Tween(tab.Label, {TextColor3 = Ostrapic.Theme.Text}, 0.2)
            self.CurrentTab = tab
        end
        
        return tab
    end
    
    -- Window Methods
    function window:Destroy()
        gui:Destroy()
    end
    
    function window:Minimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            Tween(mainFrame, {Size = UDim2.new(0, self.Size.X.Offset, 0, 45)}, 0.3)
        else
            Tween(mainFrame, {Size = self.Size}, 0.3)
        end
    end
    
    function window:SetTitle(title)
        self.Title = title
        topbar:FindFirstChildOfClass("TextLabel").Text = title
    end
    
    table.insert(self.Windows, window)
    return window
end

-- Theme Customization
function Ostrapic:SetTheme(theme)
    for key, value in pairs(theme) do
        if self.Theme[key] then
            self.Theme[key] = value
        end
    end
end

return Ostrapic
