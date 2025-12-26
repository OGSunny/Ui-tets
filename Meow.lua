--[[
    Stellar Hub UI Library v2.0
    Modern PVP UI Library for Roblox
    
    Features:
    - Light blue accent theme
    - All device support (PC, Mobile, Console)
    - Icon name system (no asset IDs needed)
    - Smooth animations
    - Notifications system
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Library = {ToggleKey = Enum.KeyCode.RightControl}

-- Theme
local Theme = {
    Bg = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Tertiary = Color3.fromRGB(35, 35, 50),
    Accent = Color3.fromRGB(100, 200, 255),
    AccentDark = Color3.fromRGB(70, 160, 220),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    TextMuted = Color3.fromRGB(120, 120, 120),
    Success = Color3.fromRGB(100, 255, 150),
    Error = Color3.fromRGB(255, 100, 100),
    Warning = Color3.fromRGB(255, 200, 100)
}

-- Icon Library
local Icons = {
    home = "rbxassetid://7733779610",
    user = "rbxassetid://7743871002",
    settings = "rbxassetid://7733954760",
    star = "rbxassetid://7733955511",
    shield = "rbxassetid://7734000129",
    sword = "rbxassetid://7734021700",
    target = "rbxassetid://7743871002",
    eye = "rbxassetid://7734056813",
    speed = "rbxassetid://7734042071",
    lightning = "rbxassetid://7734000129",
    check = "rbxassetid://7733954760",
    warning = "rbxassetid://7734000129",
    info = "rbxassetid://7733779610"
}

-- Device Detection
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local IsConsole = UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled

-- Utilities
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.2, Enum.EasingStyle.Quad), props):Play()
end

local function Corner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function Stroke(parent, color, thickness)
    return Create("UIStroke", {Color = color or Theme.Tertiary, Thickness = thickness or 1, Parent = parent})
end

local function GetIcon(name)
    if name:match("^rbxassetid://") then return name end
    return Icons[name:lower()] or Icons.star
end

local function GetAvatar()
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    return ok and url or ""
end

-- Notification System
function Library:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local icon = config.Icon
    local duration = config.Time or 5
    
    local gui = CoreGui:FindFirstChild("StellarNotifs") or Create("ScreenGui", {
        Name = "StellarNotifs", ResetOnSpawn = false, Parent = CoreGui
    })
    
    local container = gui:FindFirstChild("Container") or Create("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -15, 1, -15),
        Size = UDim2.new(0, 280, 1, -30),
        Parent = gui
    })
    
    if not container:FindFirstChild("UIListLayout") then
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 8),
            Parent = container
        })
    end
    
    local notif = Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundTransparency = 1,
        Parent = container
    })
    Corner(notif, 10)
    Stroke(notif, Theme.Accent, 1)
    
    Create("UIPadding", {PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,10), PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12), Parent = notif})
    
    if icon then
        Create("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 0, 0, 0),
            Image = GetIcon(icon),
            ImageColor3 = Theme.Accent,
            Parent = notif
        })
    end
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, icon and 26 or 0, 0, 0),
        Size = UDim2.new(1, icon and -26 or 0, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.Accent,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 22),
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = Theme.TextDark,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    local progressBg = Create("Frame", {
        BackgroundColor3 = Theme.Bg,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3),
        Parent = notif
    })
    Corner(progressBg, 2)
    
    local progress = Create("Frame", {BackgroundColor3 = Theme.Accent, Size = UDim2.new(1, 0, 1, 0), Parent = progressBg})
    Corner(progress, 2)
    
    Tween(notif, {BackgroundTransparency = 0}, 0.3)
    Tween(progress, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    task.delay(duration, function()
        Tween(notif, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- Main Window
function Library:CreateWindow(config)
    local windowName = config.Name or "Stellar Hub"
    local keyTime = config.KeyTime or "Lifetime"
    
    local Window = {Tabs = {}, ActiveTab = nil, Minimized = false, Open = true}
    
    local gui = Create("ScreenGui", {Name = "StellarHub", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui})
    
    local mainSize = IsMobile and UDim2.new(0, 360, 0, 420) or UDim2.new(0, 700, 0, 450)
    
    local main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Theme.Bg,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = mainSize,
        Parent = gui
    })
    Corner(main, 12)
    Stroke(main, Theme.Tertiary, 1)
    
    Window.Main = main
    Window.Gui = gui
    
    -- Top Bar
    local topBar = Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 45),
        Parent = main
    })
    Corner(topBar, 12)
    Create("Frame", {BackgroundColor3 = Theme.Secondary, Position = UDim2.new(0, 0, 1, -12), Size = UDim2.new(1, 0, 0, 12), BorderSizePixel = 0, Parent = topBar})
    
    -- Title
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 150, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "✦ " .. windowName,
        TextColor3 = Theme.Accent,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    -- Right Controls
    local controls = Create("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 0), Size = UDim2.new(0, 300, 1, 0), Parent = topBar})
    
    -- Close
    local closeBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Error,
        BackgroundTransparency = 0.8,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 28, 0, 28),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Theme.Error,
        TextSize = 20,
        Parent = controls
    })
    Corner(closeBtn, 6)
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
    
    -- Minimize
    local minBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Warning,
        BackgroundTransparency = 0.8,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -36, 0.5, 0),
        Size = UDim2.new(0, 28, 0, 28),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Theme.Warning,
        TextSize = 20,
        Parent = controls
    })
    Corner(minBtn, 6)
    minBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        Tween(main, {Size = Window.Minimized and UDim2.new(mainSize.X.Scale, mainSize.X.Offset, 0, 45) or mainSize}, 0.25)
    end)
    
    -- Key Badge
    local keyBadge = Create("TextLabel", {
        BackgroundColor3 = Theme.Tertiary,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -72, 0.5, 0),
        Size = UDim2.new(0, 80, 0, 24),
        Font = Enum.Font.GothamMedium,
        Text = "⏱ " .. keyTime,
        TextColor3 = Theme.Accent,
        TextSize = 10,
        Parent = controls
    })
    Corner(keyBadge, 6)
    
    -- Username
    Create("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -160, 0.5, 0),
        Size = UDim2.new(0, 80, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = Player.Name,
        TextColor3 = Theme.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = controls
    })
    
    -- Avatar
    local avatarFrame = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -248, 0.5, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Parent = controls
    })
    Corner(avatarFrame, 15)
    local avatar = Create("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 28, 0, 28),
        Image = GetAvatar(),
        Parent = avatarFrame
    })
    Corner(avatar, 14)
    
    -- Sidebar
    local sidebarWidth = IsMobile and 50 or 180
    local sidebar = Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(0, sidebarWidth, 1, -45),
        Parent = main
    })
    Corner(sidebar, 12)
    Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 12), BorderSizePixel = 0, Parent = sidebar})
    Create("Frame", {BackgroundColor3 = Theme.Secondary, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 12, 1, 0), BorderSizePixel = 0, Parent = sidebar})
    
    local tabList = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 15),
        Size = UDim2.new(1, -16, 1, -80),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = tabList})
    
    -- Profile Section at Bottom of Sidebar
    local profile = Create("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 8, 1, -8),
        Size = UDim2.new(1, -16, 0, 55),
        Parent = sidebar
    })
    Corner(profile, 8)
    
    local profAvatar = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 38, 0, 38),
        Image = GetAvatar(),
        Parent = profile
    })
    Corner(profAvatar, 19)
    
    if not IsMobile then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 52, 0, 10),
            Size = UDim2.new(1, -60, 0, 16),
            Font = Enum.Font.GothamBold,
            Text = Player.DisplayName,
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = profile
        })
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 52, 0, 28),
            Size = UDim2.new(1, -60, 0, 14),
            Font = Enum.Font.Gotham,
            Text = "@" .. Player.Name,
            TextColor3 = Theme.TextMuted,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = profile
        })
        -- Online indicator
        local online = Create("Frame", {BackgroundColor3 = Theme.Success, Position = UDim2.new(0, 38, 0, 38), Size = UDim2.new(0, 10, 0, 10), Parent = profile})
        Corner(online, 5)
        Stroke(online, Theme.Tertiary, 2)
    end
    
    -- Content Area
    local content = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, sidebarWidth, 0, 45),
        Size = UDim2.new(1, -sidebarWidth, 1, -45),
        Parent = main
    })
    
    -- Dragging
    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    topBar.InputEnded:Connect(function() dragging = false end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Toggle Keybind
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Library.ToggleKey then
            Window.Open = not Window.Open
            gui.Enabled = Window.Open
        end
    end)
    
    -- Mobile Toggle Button
    if IsMobile then
        local mobileBtn = Create("TextButton", {
            BackgroundColor3 = Theme.Accent,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -15, 1, -15),
            Size = UDim2.new(0, 50, 0, 50),
            Font = Enum.Font.GothamBold,
            Text = "✦",
            TextColor3 = Theme.Bg,
            TextSize = 24,
            Parent = gui
        })
        Corner(mobileBtn, 25)
        mobileBtn.MouseButton1Click:Connect(function()
            Window.Open = not Window.Open
            main.Visible = Window.Open
        end)
    end
    
    -- Create Tab
    function Window:CreateTab(config)
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon
        
        local Tab = {Elements = {}}
        
        local btn = Create("TextButton", {
            BackgroundColor3 = Theme.Tertiary,
            Size = UDim2.new(1, 0, 0, IsMobile and 40 or 36),
            Text = "",
            AutoButtonColor = false,
            Parent = tabList
        })
        Corner(btn, 8)
        
        if tabIcon then
            Create("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, IsMobile and 10 or 12, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 18, 0, 18),
                Image = GetIcon(tabIcon),
                ImageColor3 = Theme.TextDark,
                Name = "Icon",
                Parent = btn
            })
        end
        
        if not IsMobile then
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, tabIcon and 38 or 12, 0, 0),
                Size = UDim2.new(1, tabIcon and -46 or -20, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = tabName,
                TextColor3 = Theme.TextDark,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Name = "Label",
                Parent = btn
            })
        end
        
        local page = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 12),
            Size = UDim2.new(1, -24, 1, -24),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = content
        })
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = page})
        
        Tab.Button = btn
        Tab.Page = page
        
        local function select()
            for _, t in pairs(Window.Tabs) do
                Tween(t.Button, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                if t.Button:FindFirstChild("Label") then t.Button.Label.TextColor3 = Theme.TextDark end
                if t.Button:FindFirstChild("Icon") then t.Button.Icon.ImageColor3 = Theme.TextDark end
                t.Page.Visible = false
            end
            Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.2)
            if btn:FindFirstChild("Label") then btn.Label.TextColor3 = Theme.Bg end
            if btn:FindFirstChild("Icon") then btn.Icon.ImageColor3 = Theme.Bg end
            page.Visible = true
            Window.ActiveTab = Tab
        end
        
        btn.MouseButton1Click:Connect(select)
        btn.MouseEnter:Connect(function() if Window.ActiveTab ~= Tab then Tween(btn, {BackgroundColor3 = Theme.Secondary}, 0.15) end end)
        btn.MouseLeave:Connect(function() if Window.ActiveTab ~= Tab then Tween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.15) end end)
        
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then select() end
        
        -- Section
        function Tab:CreateSection(config)
            local frame = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25), Parent = page})
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = "— " .. (config.Name or "Section"),
                TextColor3 = Theme.Accent,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
        end
        
        -- Toggle
        function Tab:CreateToggle(config)
            local Toggle = {Value = config.CurrentValue or false}
            local callback = config.Callback or function() end
            
            local frame = Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 42), Parent = page})
            Corner(frame, 8)
            
            Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -70, 1, 0), Font = Enum.Font.GothamMedium, Text = config.Name or "Toggle", TextColor3 = Theme.Text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            
            local switch = Create("Frame", {BackgroundColor3 = Theme.Tertiary, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 40, 0, 22), Parent = frame})
            Corner(switch, 11)
            
            local circle = Create("Frame", {BackgroundColor3 = Theme.TextDark, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.new(0, 16, 0, 16), Parent = switch})
            Corner(circle, 8)
            
            local function update()
                if Toggle.Value then
                    Tween(switch, {BackgroundColor3 = Theme.Accent}, 0.2)
                    Tween(circle, {Position = UDim2.new(1, -19, 0.5, 0), BackgroundColor3 = Theme.Bg}, 0.2)
                else
                    Tween(switch, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                    Tween(circle, {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = Theme.TextDark}, 0.2)
                end
            end
            update()
            
            local btn = Create("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", Parent = frame})
            btn.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                update()
                callback(Toggle.Value)
            end)
            
            function Toggle:Set(v) Toggle.Value = v update() callback(v) end
            return Toggle
        end
        
        -- Slider
        function Tab:CreateSlider(config)
            local range = config.Range or {0, 100}
            local increment = config.Increment or 1
            local Slider = {Value = config.CurrentValue or range[1]}
            local callback = config.Callback or function() end
            
            local frame = Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 55), Parent = page})
            Corner(frame, 8)
            
            Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(0.6, 0, 0, 18), Font = Enum.Font.GothamMedium, Text = config.Name or "Slider", TextColor3 = Theme.Text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            
            local valueLabel = Create("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 8), Size = UDim2.new(0.3, 0, 0, 18), Font = Enum.Font.GothamBold, Text = tostring(Slider.Value), TextColor3 = Theme.Accent, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = frame})
            
            local bar = Create("Frame", {BackgroundColor3 = Theme.Tertiary, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -12), Size = UDim2.new(1, -24, 0, 6), Parent = frame})
            Corner(bar, 3)
            
            local fill = Create("Frame", {BackgroundColor3 = Theme.Accent, Size = UDim2.new((Slider.Value - range[1]) / (range[2] - range[1]), 0, 1, 0), Parent = bar})
            Corner(fill, 3)
            
            local knob = Create("Frame", {BackgroundColor3 = Theme.Text, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new((Slider.Value - range[1]) / (range[2] - range[1]), 0, 0.5, 0), Size = UDim2.new(0, 14, 0, 14), Parent = bar})
            Corner(knob, 7)
            Stroke(knob, Theme.Accent, 2)
            
            local function set(v)
                v = math.clamp(v, range[1], range[2])
                v = math.floor(v / increment + 0.5) * increment
                Slider.Value = v
                local pct = (v - range[1]) / (range[2] - range[1])
                Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
                Tween(knob, {Position = UDim2.new(pct, 0, 0.5, 0)}, 0.1)
                valueLabel.Text = tostring(v)
                callback(v)
            end
            
            local dragging = false
            bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; set(range[1] + (range[2] - range[1]) * math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then set(range[1] + (range[2] - range[1]) * math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)) end end)
            
            function Slider:Set(v) set(v) end
            return Slider
        end
        
        -- Button
        function Tab:CreateButton(config)
            local btn = Create("TextButton", {BackgroundColor3 = Theme.Accent, Size = UDim2.new(1, 0, 0, 38), Font = Enum.Font.GothamBold, Text = config.Name or "Button", TextColor3 = Theme.Bg, TextSize = 13, AutoButtonColor = false, Parent = page})
            Corner(btn, 8)
            btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = Theme.AccentDark}, 0.15) end)
            btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.15) end)
            btn.MouseButton1Click:Connect(function() Tween(btn, {Size = UDim2.new(1, -4, 0, 36)}, 0.1); task.wait(0.1); Tween(btn, {Size = UDim2.new(1, 0, 0, 38)}, 0.1); (config.Callback or function() end)() end)
        end
        
        -- Dropdown
        function Tab:CreateDropdown(config)
            local options = config.Options or {}
            local Dropdown = {Value = config.CurrentOption or options[1] or "", Open = false}
            local callback = config.Callback or function() end
            
            local frame = Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 42), ClipsDescendants = true, Parent = page})
            Corner(frame, 8)
            
            Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0.45, 0, 0, 42), Font = Enum.Font.GothamMedium, Text = config.Name or "Dropdown", TextColor3 = Theme.Text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            
            local selected = Create("TextButton", {BackgroundColor3 = Theme.Tertiary, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0, 21), Size = UDim2.new(0.5, -20, 0, 28), Font = Enum.Font.GothamMedium, Text = Dropdown.Value .. " ▼", TextColor3 = Theme.Text, TextSize = 11, AutoButtonColor = false, Parent = frame})
            Corner(selected, 6)
            
            local optContainer = Create("Frame", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 48), Size = UDim2.new(1, -24, 0, #options * 30), Parent = frame})
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = optContainer})
            
            for _, opt in ipairs(options) do
                local optBtn = Create("TextButton", {BackgroundColor3 = Theme.Tertiary, Size = UDim2.new(1, 0, 0, 26), Font = Enum.Font.Gotham, Text = opt, TextColor3 = Theme.Text, TextSize = 11, AutoButtonColor = false, Parent = optContainer})
                Corner(optBtn, 6)
                optBtn.MouseEnter:Connect(function() Tween(optBtn, {BackgroundColor3 = Theme.Accent}, 0.15); optBtn.TextColor3 = Theme.Bg end)
                optBtn.MouseLeave:Connect(function() Tween(optBtn, {BackgroundColor3 = Theme.Tertiary}, 0.15); optBtn.TextColor3 = Theme.Text end)
                optBtn.MouseButton1Click:Connect(function()
                    Dropdown.Value = opt
                    selected.Text = opt .. " ▼"
                    Dropdown.Open = false
                    Tween(frame, {Size = UDim2.new(1, 0, 0, 42)}, 0.2)
                    callback(opt)
                end)
            end
            
            selected.MouseButton1Click:Connect(function()
                Dropdown.Open = not Dropdown.Open
                Tween(frame, {Size = UDim2.new(1, 0, 0, Dropdown.Open and (52 + #options * 30) or 42)}, 0.2)
                selected.Text = Dropdown.Value .. (Dropdown.Open and " ▲" or " ▼")
            end)
            
            function Dropdown:Set(v) Dropdown.Value = v; selected.Text = v .. " ▼"; callback(v) end
            return Dropdown
        end
        
        -- Input
        function Tab:CreateInput(config)
            local Input = {Value = ""}
            local callback = config.Callback or function() end
            
            local frame = Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 42), Parent = page})
            Corner(frame, 8)
            
            Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0.35, 0, 1, 0), Font = Enum.Font.GothamMedium, Text = config.Name or "Input", TextColor3 = Theme.Text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            
            local box = Create("TextBox", {BackgroundColor3 = Theme.Tertiary, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0.6, -20, 0, 28), Font = Enum.Font.Gotham, PlaceholderText = config.PlaceholderText or "Enter...", PlaceholderColor3 = Theme.TextMuted, Text = "", TextColor3 = Theme.Text, TextSize = 11, ClearTextOnFocus = false, Parent = frame})
            Corner(box, 6)
            
            box.FocusLost:Connect(function(enter) Input.Value = box.Text; if enter then callback(box.Text) end end)
            function Input:Set(t) box.Text = t; Input.Value = t end
            return Input
        end
        
        -- Keybind
        function Tab:CreateKeybind(config)
            local Keybind = {Value = config.CurrentKeybind or "None", Listening = false}
            local callback = config.Callback or function() end
            
            local frame = Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 42), Parent = page})
            Corner(frame, 8)
            
            Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0.6, 0, 1, 0), Font = Enum.Font.GothamMedium, Text = config.Name or "Keybind", TextColor3 = Theme.Text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            
            local btn = Create("TextButton", {BackgroundColor3 = Theme.Tertiary, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 70, 0, 26), Font = Enum.Font.GothamMedium, Text = Keybind.Value, TextColor3 = Theme.Accent, TextSize = 11, AutoButtonColor = false, Parent = frame})
            Corner(btn, 6)
            
            btn.MouseButton1Click:Connect(function()
                Keybind.Listening = true
                btn.Text = "..."
                Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.15)
                btn.TextColor3 = Theme.Bg
            end)
            
            UserInputService.InputBegan:Connect(function(i, gpe)
                if Keybind.Listening and i.UserInputType == Enum.UserInputType.Keyboard then
                    Keybind.Value = i.KeyCode.Name
                    btn.Text = i.KeyCode.Name
                    Keybind.Listening = false
                    Tween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
                    btn.TextColor3 = Theme.Accent
                elseif not gpe and i.KeyCode.Name == Keybind.Value then
                    callback(Keybind.Value)
                end
            end)
            
            function Keybind:Set(k) Keybind.Value = k; btn.Text = k end
            return Keybind
        end
        
        -- Label
        function Tab:CreateLabel(config)
            local lbl = Create("TextLabel", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 32), Font = Enum.Font.GothamMedium, Text = config.Name or "Label", TextColor3 = Theme.TextDark, TextSize = 12, Parent = page})
            Corner(lbl, 8)
            local Label = {}
            function Label:Set(t) lbl.Text = t end
            return Label
        end
        
        -- Paragraph
        function Tab:CreateParagraph(config)
            local frame = Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = page})
            Corner(frame, 8)
            Create("UIPadding", {PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,10), PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12), Parent = frame})
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = frame})
            
            local title = Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Font = Enum.Font.GothamBold, Text = config.Title or "Title", TextColor3 = Theme.Accent, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, Parent = frame})
            local content = Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Font = Enum.Font.Gotham, Text = config.Content or "", TextColor3 = Theme.TextDark, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 2, Parent = frame})
            
            local Para = {}
            function Para:Set(t, c) title.Text = t or title.Text; content.Text = c or content.Text end
            return Para
        end
        
        -- ColorPicker
        function Tab:CreateColorPicker(config)
            local CP = {Value = config.Color or Color3.fromRGB(255,255,255), Open = false}
            local callback = config.Callback or function() end
            
            local frame = Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 42), ClipsDescendants = true, Parent = page})
            Corner(frame, 8)
            
            Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0.6, 0, 0, 42), Font = Enum.Font.GothamMedium, Text = config.Name or "Color", TextColor3 = Theme.Text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
            
            local preview = Create("TextButton", {BackgroundColor3 = CP.Value, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0, 21), Size = UDim2.new(0, 32, 0, 24), Text = "", AutoButtonColor = false, Parent = frame})
            Corner(preview, 6)
            Stroke(preview, Theme.Text, 2)
            
            local sliders = Create("Frame", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 48), Size = UDim2.new(1, -24, 0, 90), Parent = frame})
            
            local r, g, b = math.floor(CP.Value.R*255), math.floor(CP.Value.G*255), math.floor(CP.Value.B*255)
            
            local function makeSlider(name, col, y, val)
                local bar = Create("Frame", {BackgroundColor3 = Theme.Tertiary, Position = UDim2.new(0, 0, 0, y), Size = UDim2.new(1, -40, 0, 18), Parent = sliders})
                Corner(bar, 4)
                local fill = Create("Frame", {BackgroundColor3 = col, Size = UDim2.new(val/255, 0, 1, 0), Parent = bar})
                Corner(fill, 4)
                Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(0, 16, 1, 0), Position = UDim2.new(0, 4, 0, 0), Font = Enum.Font.GothamBold, Text = name, TextColor3 = Theme.Text, TextSize = 10, ZIndex = 2, Parent = bar})
                local lbl = Create("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, y), Size = UDim2.new(0, 35, 0, 18), Font = Enum.Font.GothamMedium, Text = tostring(val), TextColor3 = col, TextSize = 11, Parent = sliders})
                return bar, fill, lbl
            end
            
            local rBar, rFill, rLbl = makeSlider("R", Color3.fromRGB(255,100,100), 0, r)
            local gBar, gFill, gLbl = makeSlider("G", Color3.fromRGB(100,255,100), 30, g)
            local bBar, bFill, bLbl = makeSlider("B", Color3.fromRGB(100,100,255), 60, b)
            
            local function updateColor()
                preview.BackgroundColor3 = CP.Value
                rFill.Size = UDim2.new(math.floor(CP.Value.R*255)/255, 0, 1, 0)
                gFill.Size = UDim2.new(math.floor(CP.Value.G*255)/255, 0, 1, 0)
                bFill.Size = UDim2.new(math.floor(CP.Value.B*255)/255, 0, 1, 0)
                rLbl.Text = tostring(math.floor(CP.Value.R*255))
                gLbl.Text = tostring(math.floor(CP.Value.G*255))
                bLbl.Text = tostring(math.floor(CP.Value.B*255))
                callback(CP.Value)
            end
            
            local function setupDrag(bar, comp)
                local drag = false
                bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
                UserInputService.InputChanged:Connect(function(i)
                    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local pct = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                        local val = math.floor(pct * 255)
                        local rv, gv, bv = CP.Value.R*255, CP.Value.G*255, CP.Value.B*255
                        if comp == "R" then rv = val elseif comp == "G" then gv = val else bv = val end
                        CP.Value = Color3.fromRGB(rv, gv, bv)
                        updateColor()
                    end
                end)
            end
            setupDrag(rBar, "R"); setupDrag(gBar, "G"); setupDrag(bBar, "B")
            
            preview.MouseButton1Click:Connect(function()
                CP.Open = not CP.Open
                Tween(frame, {Size = UDim2.new(1, 0, 0, CP.Open and 145 or 42)}, 0.2)
            end)
            
            function CP:Set(c) CP.Value = c; updateColor() end
            return CP
        end
        
        return Tab
    end
    
    -- Welcome notification
    task.spawn(function()
        task.wait(0.5)
        Library:Notify({Title = "Welcome!", Content = "Press RightCtrl to toggle UI", Icon = "star", Time = 4})
    end)
    
    return Window
end

return Library
