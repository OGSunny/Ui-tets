local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Library = {}
Library.ToggleKey = Enum.KeyCode.RightControl
Library.Windows = {}
Library.OpenDropdowns = {}
Library.Connections = {}
Library.ActiveAnimations = {}

-- ═══════════════════════════════════════════════════════════════
-- UPGRADED THEME (Glassmorphism + Neon)
-- ═══════════════════════════════════════════════════════════════
local Theme = {
    -- Glassmorphism backgrounds
    Primary = Color3.fromRGB(12, 12, 18),
    Secondary = Color3.fromRGB(18, 18, 28),
    Tertiary = Color3.fromRGB(28, 28, 42),
    Hover = Color3.fromRGB(38, 38, 55),
    
    -- Neon accent colors
    Accent = Color3.fromRGB(88, 166, 255),
    AccentDark = Color3.fromRGB(60, 130, 220),
    AccentGlow = Color3.fromRGB(120, 190, 255),
    AccentSecondary = Color3.fromRGB(165, 94, 234),
    
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 195),
    TextMuted = Color3.fromRGB(100, 100, 120),
    
    Success = Color3.fromRGB(85, 255, 127),
    SuccessGlow = Color3.fromRGB(120, 255, 160),
    Warning = Color3.fromRGB(255, 195, 85),
    Error = Color3.fromRGB(255, 85, 95),
    ErrorGlow = Color3.fromRGB(255, 120, 130),
    
    Online = Color3.fromRGB(85, 255, 127),
    Border = Color3.fromRGB(60, 60, 85),
    
    -- Glass effect values
    GlassTransparency = 0.25,
    GlowTransparency = 0.6
}

Library.Theme = Theme

-- ═══════════════════════════════════════════════════════════════
-- ANIMATION CONSTANTS (Enhanced)
-- ═══════════════════════════════════════════════════════════════
local Anim = {
    WindowOpen = 0.6,
    WindowClose = 0.35,
    ElementHover = 0.12,
    ElementClick = 0.08,
    SizeChange = 0.35,
    ColorChange = 0.2,
    SliderDrag = 0.06,
    GlowPulse = 1.5,
    GradientRotate = 3
}

function Library:SetTheme(newTheme)
    for key, value in pairs(newTheme) do
        if Theme[key] then
            Theme[key] = value
        end
    end
    Library.Theme = Theme
end

-- ═══════════════════════════════════════════════════════════════
-- ICON LIBRARY
-- ═══════════════════════════════════════════════════════════════
local Icons = {
    home = "rbxassetid://7733960981",
    combat = "rbxassetid://7734021700",
    sword = "rbxassetid://7734021700",
    shield = "rbxassetid://7734011509",
    eye = "rbxassetid://7734027235",
    visual = "rbxassetid://7734027235",
    settings = "rbxassetid://7734053495",
    player = "rbxassetid://7733756005",
    user = "rbxassetid://7733756005",
    target = "rbxassetid://7734076234",
    star = "rbxassetid://7733960981",
    speed = "rbxassetid://7734042071",
    teleport = "rbxassetid://7734082149",
    misc = "rbxassetid://7733717858",
    info = "rbxassetid://7733717858",
    check = "rbxassetid://7733715400",
    warning = "rbxassetid://7733990738",
    crown = "rbxassetid://7733696953",
    heart = "rbxassetid://7733715341",
    lightning = "rbxassetid://7734042071",
    magic = "rbxassetid://7733717858",
    world = "rbxassetid://7734082149",
    key = "rbxassetid://7733717858",
    time = "rbxassetid://7733717858"
}

-- ═══════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS (Enhanced)
-- ═══════════════════════════════════════════════════════════════
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            pcall(function() obj[k] = v end)
        end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function Tween(obj, props, duration, style, direction)
    duration = math.max(duration or Anim.ColorChange, 0.05)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

local function Corner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 14), Parent = parent})
end

-- Enhanced stroke with glow option
local function Stroke(parent, color, thickness, transparency, applyMode)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1.5,
        Transparency = transparency or 0.5,
        ApplyStrokeMode = applyMode or Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

-- Modern 16-20px padding
local function Padding(parent, t, b, l, r)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 16),
        PaddingBottom = UDim.new(0, b or t or 16),
        PaddingLeft = UDim.new(0, l or t or 16),
        PaddingRight = UDim.new(0, r or l or t or 16),
        Parent = parent
    })
end

local function GetIcon(name)
    if not name then return Icons.star end
    if tostring(name):match("^rbxassetid://") then return name end
    return Icons[name:lower()] or Icons.star
end

local function GetAvatar(userId)
    local success, result = pcall(function()
        return Players:GetUserThumbnailAsync(
            userId or Player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)
    return success and result or "rbxassetid://0"
end

local function SafeCallback(callback, ...)
    if callback then
        local success, err = pcall(callback, ...)
        if not success then
            warn("[Stellar UI] Callback error: " .. tostring(err))
        end
    end
end

local function CreateConnectionManager()
    local manager = {connections = {}}
    
    function manager:Add(connection)
        table.insert(self.connections, connection)
        return connection
    end
    
    function manager:Connect(signal, callback)
        local connection = signal:Connect(callback)
        table.insert(self.connections, connection)
        return connection
    end
    
    function manager:DisconnectAll()
        for _, connection in ipairs(self.connections) do
            if connection.Connected then
                connection:Disconnect()
            end
        end
        self.connections = {}
    end
    
    return manager
end

-- Enhanced ripple with glow
local function Ripple(button, x, y)
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Theme.AccentGlow,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = button
    })
    Corner(ripple, 100)
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        if ripple and ripple.Parent then
            ripple:Destroy()
        end
    end)
end

-- Enhanced shadow with glow option
local function CreateShadow(parent, offset, size, color, transparency)
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, offset or 4),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, size or 50, 1, size or 50),
        ZIndex = -1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = color or Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency or 0.55,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = parent
    })
    return shadow
end

-- Neon glow effect
local function CreateGlow(parent, color, size, transparency)
    local glow = Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, size or 40, 1, size or 40),
        ZIndex = -1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = color or Theme.Accent,
        ImageTransparency = transparency or 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = parent
    })
    return glow
end

-- Gradient creator with animation support
local function CreateGradient(parent, color1, color2, rotation)
    local gradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1 or Theme.Accent),
            ColorSequenceKeypoint.new(1, color2 or Theme.AccentSecondary)
        }),
        Rotation = rotation or 45,
        Parent = parent
    })
    return gradient
end

-- Animated gradient rotation
local function AnimateGradient(gradient, speed)
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        if gradient and gradient.Parent then
            gradient.Rotation = (gradient.Rotation + (speed or 30) * dt) % 360
        else
            connection:Disconnect()
        end
    end)
    table.insert(Library.ActiveAnimations, connection)
    return connection
end

-- Pulse glow animation
local function CreatePulseGlow(element, minTransparency, maxTransparency, speed)
    local increasing = false
    local currentTransparency = maxTransparency or 0.7
    
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        if element and element.Parent then
            local change = (speed or 0.5) * dt
            if increasing then
                currentTransparency = currentTransparency - change
                if currentTransparency <= (minTransparency or 0.3) then
                    increasing = false
                end
            else
                currentTransparency = currentTransparency + change
                if currentTransparency >= (maxTransparency or 0.7) then
                    increasing = true
                end
            end
            element.ImageTransparency = currentTransparency
        else
            connection:Disconnect()
        end
    end)
    table.insert(Library.ActiveAnimations, connection)
    return connection
end

-- ═══════════════════════════════════════════════════════════════
-- GLOBAL CLICK HANDLER FOR DROPDOWNS
-- ═══════════════════════════════════════════════════════════════
local function SetupGlobalClickHandler()
    local connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            task.defer(function()
                for dropdown, data in pairs(Library.OpenDropdowns) do
                    if data.Open then
                        local mousePos = UserInputService:GetMouseLocation()
                        local container = data.Container
                        
                        if container and container.Parent then
                            local absPos = container.AbsolutePosition
                            local absSize = container.AbsoluteSize
                            
                            if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
                               mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
                                data.Close()
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    table.insert(Library.Connections, connection)
end

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM (Enhanced with Glassmorphism)
-- ═══════════════════════════════════════════════════════════════
function Library:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local icon = config.Icon
    local duration = config.Time or 5
    
    local gui = CoreGui:FindFirstChild("StellarNotifications")
    if not gui then
        gui = Create("ScreenGui", {
            Name = "StellarNotifications",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = CoreGui
        })
        
        Create("Frame", {
            Name = "Container",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -24, 1, -24),
            Size = UDim2.new(0, 340, 1, -48),
            Parent = gui
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 12),
            Parent = gui.Container
        })
    end
    
    -- Glassmorphism notification
    local notif = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Theme.Secondary,
        BackgroundTransparency = Theme.GlassTransparency,
        Size = UDim2.new(1, 0, 0, 88),
        ClipsDescendants = true,
        Parent = gui.Container
    })
    Corner(notif, 14)
    
    -- Multiple strokes for glow effect
    local innerStroke = Stroke(notif, Theme.Border, 1, 0.4)
    local glowStroke = Stroke(notif, Theme.Accent, 2, 0.7)
    
    -- Neon glow shadow
    local glow = CreateGlow(notif, Theme.Accent, 50, 0.75)
    CreateShadow(notif, 4, 30)
    
    if icon then
        local iconFrame = Create("Frame", {
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 0.88,
            Position = UDim2.new(0, 16, 0, 16),
            Size = UDim2.new(0, 44, 0, 44),
            Parent = notif
        })
        Corner(iconFrame, 12)
        CreateGlow(iconFrame, Theme.Accent, 20, 0.8)
        
        Create("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 22, 0, 22),
            Image = GetIcon(icon),
            ImageColor3 = Theme.Accent,
            Parent = iconFrame
        })
    end
    
    local closeBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Error,
        BackgroundTransparency = 0.9,
        Position = UDim2.new(1, -36, 0, 10),
        Size = UDim2.new(0, 26, 0, 26),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Theme.TextMuted,
        TextSize = 18,
        AutoButtonColor = false,
        Parent = notif
    })
    Corner(closeBtn, 8)
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {TextColor3 = Theme.Error, BackgroundTransparency = 0.6}, Anim.ElementHover)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {TextColor3 = Theme.TextMuted, BackgroundTransparency = 0.9}, Anim.ElementHover)
    end)
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, icon and 72 or 18, 0, 16),
        Size = UDim2.new(1, icon and -110 or -58, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.Accent,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, icon and 72 or 18, 0, 40),
        Size = UDim2.new(1, icon and -90 or -36, 0, 32),
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = Theme.TextDark,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = notif
    })
    
    -- Gradient progress bar
    local progressBg = Create("Frame", {
        BackgroundColor3 = Theme.Primary,
        Position = UDim2.new(0, 0, 1, -4),
        Size = UDim2.new(1, 0, 0, 4),
        Parent = notif
    })
    
    local progress = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = progressBg
    })
    Corner(progress, 2)
    local progressGradient = CreateGradient(progress, Theme.Accent, Theme.AccentSecondary, 0)
    
    -- Slide in animation
    notif.Position = UDim2.new(1, 60, 0, 0)
    Tween(notif, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = Theme.GlassTransparency}, Anim.WindowOpen, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Tween(glowStroke, {Transparency = 0.4}, Anim.SizeChange)
    Tween(progress, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    local function closeNotif()
        Tween(notif, {Position = UDim2.new(1, 60, 0, 0), BackgroundTransparency = 1}, Anim.WindowClose, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(glow, {ImageTransparency = 1}, Anim.WindowClose)
        task.delay(Anim.WindowClose, function()
            if notif and notif.Parent then
                notif:Destroy()
            end
        end)
    end
    
    closeBtn.MouseButton1Click:Connect(closeNotif)
    task.delay(duration, closeNotif)
    
    return notif
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN WINDOW CREATION (Enhanced with Glassmorphism + Neon)
-- ═══════════════════════════════════════════════════════════════
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Stellar Hub"
    local keyTime = config.KeyTime or "Lifetime"
    
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Minimized = false
    Window.Open = true
    Window.Connections = CreateConnectionManager()
    
    local gui = Create("ScreenGui", {
        Name = "StellarUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    Window.Gui = gui
    
    if #Library.Connections == 0 then
        SetupGlobalClickHandler()
    end
    
    local mainContainer = Create("Frame", {
        Name = "MainContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 800, 0, 500),
        Parent = gui
    })
    
    -- Enhanced shadows
    CreateShadow(mainContainer, 8, 60, Color3.fromRGB(0, 0, 0), 0.5)
    local accentGlow = CreateGlow(mainContainer, Theme.Accent, 80, 0.85)
    
    -- Glassmorphism main frame
    local main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Theme.Primary,
        BackgroundTransparency = Theme.GlassTransparency,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
        Parent = mainContainer
    })
    Corner(main, 16)
    
    -- Layered strokes for depth
    Stroke(main, Theme.Border, 1, 0.4)
    local mainGlowStroke = Stroke(main, Theme.Accent, 2, 0.8)
    
    Window.Main = main
    Window.Container = mainContainer
    
    -- ═══════════════════════════════════════════════════════════
    -- TOP BAR (Enhanced with gradient)
    -- ═══════════════════════════════════════════════════════════
    local topBar = Create("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Theme.Secondary,
        BackgroundTransparency = 0.1,
        Size = UDim2.new(1, 0, 0, 52),
        Parent = main
    })
    Corner(topBar, 16)
    
    -- Top bar gradient
    local topGradient = CreateGradient(topBar, Color3.fromRGB(18, 18, 28), Color3.fromRGB(28, 28, 42), 90)
    
    Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Position = UDim2.new(0, 0, 1, -16),
        Size = UDim2.new(1, 0, 0, 16),
        BorderSizePixel = 0,
        Parent = topBar
    })
    
    -- Animated accent line
    local accentLine = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(0, 0, 0, 2),
        BorderSizePixel = 0,
        Parent = topBar
    })
    local accentLineGradient = CreateGradient(accentLine, Theme.Accent, Theme.AccentSecondary, 0)
    
    -- Animate line on load
    task.spawn(function()
        task.wait(0.2)
        Tween(accentLine, {Size = UDim2.new(1, 0, 0, 2)}, 1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end)
    
    -- Title with glow effect
    local titleGlow = Create("TextLabel", {
        Name = "TitleGlow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0.5, 1),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 260, 0, 28),
        Font = Enum.Font.GothamBold,
        Text = "✦ " .. windowName,
        TextColor3 = Theme.Accent,
        TextSize = 18,
        TextTransparency = 0.7,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    local title = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 260, 0, 28),
        Font = Enum.Font.GothamBold,
        Text = "✦ " .. windowName,
        TextColor3 = Theme.Accent,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    -- Close Button with glow
    local closeBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Error,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(1, -48, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 36, 0, 36),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Theme.Error,
        TextSize = 22,
        AutoButtonColor = false,
        Parent = topBar
    })
    Corner(closeBtn, 10)
    local closeBtnGlow = CreateGlow(closeBtn, Theme.Error, 20, 0.9)
    
    Window.Connections:Connect(closeBtn.MouseEnter, function()
        Tween(closeBtn, {BackgroundTransparency = 0.5, Size = UDim2.new(0, 40, 0, 40)}, Anim.ElementHover)
        Tween(closeBtnGlow, {ImageTransparency = 0.6}, Anim.ElementHover)
    end)
    Window.Connections:Connect(closeBtn.MouseLeave, function()
        Tween(closeBtn, {BackgroundTransparency = 0.85, Size = UDim2.new(0, 36, 0, 36)}, Anim.ElementHover)
        Tween(closeBtnGlow, {ImageTransparency = 0.9}, Anim.ElementHover)
    end)
    Window.Connections:Connect(closeBtn.MouseButton1Click, function()
        Window:Destroy()
    end)
    
    -- Minimize Button with glow
    local minBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Warning,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(1, -92, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 36, 0, 36),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Theme.Warning,
        TextSize = 24,
        AutoButtonColor = false,
        Parent = topBar
    })
    Corner(minBtn, 10)
    local minBtnGlow = CreateGlow(minBtn, Theme.Warning, 20, 0.9)
    
    Window.Connections:Connect(minBtn.MouseEnter, function()
        Tween(minBtn, {BackgroundTransparency = 0.5, Size = UDim2.new(0, 40, 0, 40)}, Anim.ElementHover)
        Tween(minBtnGlow, {ImageTransparency = 0.6}, Anim.ElementHover)
    end)
    Window.Connections:Connect(minBtn.MouseLeave, function()
        Tween(minBtn, {BackgroundTransparency = 0.85, Size = UDim2.new(0, 36, 0, 36)}, Anim.ElementHover)
        Tween(minBtnGlow, {ImageTransparency = 0.9}, Anim.ElementHover)
    end)
    Window.Connections:Connect(minBtn.MouseButton1Click, function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(mainContainer, {Size = UDim2.new(0, 800, 0, 52)}, Anim.SizeChange, Enum.EasingStyle.Quint)
            minBtn.Text = "+"
        else
            Tween(mainContainer, {Size = UDim2.new(0, 800, 0, 500)}, Anim.SizeChange, Enum.EasingStyle.Quint)
            minBtn.Text = "−"
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════
    -- SIDEBAR (Glassmorphism)
    -- ═══════════════════════════════════════════════════════════
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.Secondary,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(0, 0, 0, 52),
        Size = UDim2.new(0, 230, 1, -52),
        Parent = main
    })
    Corner(sidebar, 16)
    
    Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 16), BorderSizePixel = 0, Parent = sidebar})
    Create("Frame", {BackgroundColor3 = Theme.Secondary, Position = UDim2.new(1, -16, 0, 0), Size = UDim2.new(0, 16, 1, 0), BorderSizePixel = 0, Parent = sidebar})
    
    -- Glowing separator
    local separator = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.7,
        Position = UDim2.new(1, -1, 0, 12),
        Size = UDim2.new(0, 1, 1, -24),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    -- Tab Header
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 16),
        Size = UDim2.new(1, -36, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "NAVIGATION",
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sidebar
    })
    
    -- Tab Container
    local tabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 46),
        Size = UDim2.new(1, -24, 1, -210),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = tabContainer
    })
    
    -- ═══════════════════════════════════════════════════════════
    -- PROFILE SECTION (Enhanced with glow ring)
    -- ═══════════════════════════════════════════════════════════
    local profileSection = Create("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0, 12, 1, -155),
        Size = UDim2.new(1, -24, 0, 145),
        Parent = sidebar
    })
    Corner(profileSection, 14)
    Stroke(profileSection, Theme.Border, 1, 0.4)
    local profileGlow = CreateGlow(profileSection, Theme.Accent, 30, 0.85)
    
    Padding(profileSection, 12, 12, 12, 12)
    
    -- Avatar with animated ring
    local profileAvatarContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 10),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0, 62, 0, 62),
        Parent = profileSection
    })
    
    -- Rotating ring
    local avatarRing = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 8, 1, 8),
        Image = "rbxassetid://3570695787",
        ImageColor3 = Theme.Accent,
        Parent = profileAvatarContainer
    })
    
    -- Animate ring rotation
    local ringConnection = RunService.RenderStepped:Connect(function(dt)
        if avatarRing and avatarRing.Parent then
            avatarRing.Rotation = (avatarRing.Rotation + 40 * dt) % 360
        end
    end)
    Window.Connections:Add(ringConnection)
    
    local profileAvatarBg = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 56, 0, 56),
        Parent = profileAvatarContainer
    })
    Corner(profileAvatarBg, 28)
    
    local profileAvatar = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 52, 0, 52),
        Image = GetAvatar(),
        Parent = profileAvatarBg
    })
    Corner(profileAvatar, 26)
    
    -- Online Indicator with glow
    local onlineIndicator = Create("Frame", {
        BackgroundColor3 = Theme.Online,
        Position = UDim2.new(1, -4, 1, -4),
        AnchorPoint = Vector2.new(1, 1),
        Size = UDim2.new(0, 16, 0, 16),
        Parent = profileAvatarBg
    })
    Corner(onlineIndicator, 8)
    Stroke(onlineIndicator, Theme.Tertiary, 3, 0)
    local onlineGlow = CreateGlow(onlineIndicator, Theme.Online, 12, 0.7)
    CreatePulseGlow(onlineGlow, 0.5, 0.8, 0.8)
    
    -- Display Name
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 78),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = Player.DisplayName,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = profileSection
    })
    
    -- Username
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 98),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(1, -20, 0, 16),
        Font = Enum.Font.Gotham,
        Text = "@" .. Player.Name,
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = profileSection
    })
    
    -- Key Badge with gradient
    local keyBadge = Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Position = UDim2.new(0.5, 0, 0, 118),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0, 110, 0, 24),
        Parent = profileSection
    })
    Corner(keyBadge, 12)
    Stroke(keyBadge, Theme.Accent, 1.5, 0.4)
    
    local keyLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "⏱ " .. keyTime,
        TextColor3 = Theme.Accent,
        TextSize = 11,
        Parent = keyBadge
    })
    
    -- ═══════════════════════════════════════════════════════════
    -- CONTENT AREA
    -- ═══════════════════════════════════════════════════════════
    local contentArea = Create("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 230, 0, 52),
        Size = UDim2.new(1, -230, 1, -52),
        Parent = main
    })
    
    Window.ContentArea = contentArea
    
    -- ═══════════════════════════════════════════════════════════
    -- DRAGGING
    -- ═══════════════════════════════════════════════════════════
    local dragging, dragStart, startPos
    
    Window.Connections:Connect(topBar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainContainer.Position
        end
    end)
    
    Window.Connections:Connect(topBar.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    Window.Connections:Connect(UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Tween(mainContainer, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.05)
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════
    -- TOGGLE KEYBIND
    -- ═══════════════════════════════════════════════════════════
    Window.Connections:Connect(UserInputService.InputBegan, function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Library.ToggleKey then
            Window.Open = not Window.Open
            if Window.Open then
                gui.Enabled = true
                Tween(mainContainer, {Size = UDim2.new(0, 800, 0, Window.Minimized and 52 or 500)}, Anim.WindowOpen, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                Tween(accentGlow, {ImageTransparency = 0.85}, Anim.WindowOpen)
            else
                Tween(mainContainer, {Size = UDim2.new(0, 0, 0, 0)}, Anim.WindowClose, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                Tween(accentGlow, {ImageTransparency = 1}, Anim.WindowClose)
                task.delay(Anim.WindowClose, function()
                    if not Window.Open then
                        gui.Enabled = false
                    end
                end)
            end
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════
    -- MOBILE TOGGLE BUTTON (Enhanced)
    -- ═══════════════════════════════════════════════════════════
    local mobileBtn = Create("TextButton", {
        Name = "MobileToggle",
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(1, -75, 1, -75),
        Size = UDim2.new(0, 60, 0, 60),
        Font = Enum.Font.GothamBold,
        Text = "✦",
        TextColor3 = Theme.Primary,
        TextSize = 26,
        AutoButtonColor = false,
        Parent = gui
    })
    Corner(mobileBtn, 30)
    CreateShadow(mobileBtn, 4, 20)
    local mobileGlow = CreateGlow(mobileBtn, Theme.Accent, 30, 0.6)
    local mobileBtnGradient = CreateGradient(mobileBtn, Theme.Accent, Theme.AccentSecondary, 45)
    AnimateGradient(mobileBtnGradient, 60)
    CreatePulseGlow(mobileGlow, 0.4, 0.7, 0.6)
    
    local mobileDragging, mobileDragStart, mobileStartPos
    local dragThreshold = 10
    local wasDragged = false
    
    Window.Connections:Connect(mobileBtn.MouseEnter, function()
        Tween(mobileBtn, {Size = UDim2.new(0, 68, 0, 68)}, Anim.ElementHover, Enum.EasingStyle.Back)
    end)
    Window.Connections:Connect(mobileBtn.MouseLeave, function()
        Tween(mobileBtn, {Size = UDim2.new(0, 60, 0, 60)}, Anim.ElementHover)
    end)
    
    Window.Connections:Connect(mobileBtn.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            mobileDragging = true
            wasDragged = false
            mobileDragStart = input.Position
            mobileStartPos = mobileBtn.Position
        end
    end)
    
    Window.Connections:Connect(UserInputService.InputChanged, function(input)
        if mobileDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - mobileDragStart
            
            if delta.Magnitude > dragThreshold then
                wasDragged = true
            end
            
            local newX = mobileStartPos.X.Offset + delta.X
            local newY = mobileStartPos.Y.Offset + delta.Y
            
            local viewportSize = workspace.CurrentCamera.ViewportSize
            local btnSize = mobileBtn.AbsoluteSize
            
            local padding = 10
            local minX = -viewportSize.X + btnSize.X + padding
            local maxX = -padding
            local minY = -viewportSize.Y + btnSize.Y + padding
            local maxY = -padding
            
            newX = math.clamp(newX, minX, maxX)
            newY = math.clamp(newY, minY, maxY)
            
            mobileBtn.Position = UDim2.new(1, newX, 1, newY)
        end
    end)
    
    Window.Connections:Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if mobileDragging and not wasDragged then
                Window.Open = not Window.Open
                main.Visible = Window.Open
                Tween(mobileBtn, {Rotation = Window.Open and 45 or 0}, Anim.SizeChange, Enum.EasingStyle.Back)
            end
            mobileDragging = false
        end
    end)
    
    Window.Connections:Connect(mobileBtn.MouseButton1Click, function()
        if not wasDragged then
            Window.Open = not Window.Open
            main.Visible = Window.Open
            Tween(mobileBtn, {Rotation = Window.Open and 45 or 0}, Anim.SizeChange, Enum.EasingStyle.Back)
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════
    -- WINDOW DESTROY METHOD
    -- ═══════════════════════════════════════════════════════════
    function Window:Destroy()
        Window.Connections:DisconnectAll()
        
        for _, tab in pairs(Window.Tabs) do
            if tab.Connections then
                tab.Connections:DisconnectAll()
            end
            for _, element in pairs(tab.Elements) do
                if element.Connections then
                    element.Connections:DisconnectAll()
                end
            end
        end
        
        for dropdown, _ in pairs(Library.OpenDropdowns) do
            Library.OpenDropdowns[dropdown] = nil
        end
        
        -- Stop all active animations
        for _, conn in ipairs(Library.ActiveAnimations) do
            if conn.Connected then
                conn:Disconnect()
            end
        end
        
        Tween(mainContainer, {Size = UDim2.new(0, 0, 0, 0)}, Anim.WindowClose, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(accentGlow, {ImageTransparency = 1}, Anim.WindowClose)
        task.delay(Anim.WindowClose + 0.05, function()
            if gui and gui.Parent then
                gui:Destroy()
            end
        end)
        
        for i, win in ipairs(Library.Windows) do
            if win == Window then
                table.remove(Library.Windows, i)
                break
            end
        end
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- CREATE TAB FUNCTION
    -- ═══════════════════════════════════════════════════════════
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon
        
        local Tab = {}
        Tab.Elements = {}
        Tab.Connections = CreateConnectionManager()
        
        -- Tab Button with glow
        local tabBtn = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Theme.Tertiary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            Text = "",
            AutoButtonColor = false,
            Parent = tabContainer
        })
        Corner(tabBtn, 12)
        
        local tabGlow = CreateGlow(tabBtn, Theme.Accent, 20, 1)
        
        local indicator = Create("Frame", {
            BackgroundColor3 = Theme.Accent,
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 0, 0, 32),
            Parent = tabBtn
        })
        Corner(indicator, 4)
        local indicatorGradient = CreateGradient(indicator, Theme.Accent, Theme.AccentSecondary, 90)
        
        if tabIcon then
            Create("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 20, 0, 20),
                Image = GetIcon(tabIcon),
                ImageColor3 = Theme.TextMuted,
                Parent = tabBtn
            })
        end
        
        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, tabIcon and 44 or 16, 0, 0),
            Size = UDim2.new(1, tabIcon and -54 or -26, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = tabName,
            TextColor3 = Theme.TextMuted,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })
        
        Tab.Button = tabBtn
        
        -- Content Page
        local page = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 18, 0, 18),
            Size = UDim2.new(1, -36, 1, -36),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.3,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = contentArea
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = page
        })
        
        Tab.Page = page
        
        local function selectTab()
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundTransparency = 1}, Anim.ColorChange)
                if tab.Button:FindFirstChild("Label") then
                    Tween(tab.Button.Label, {TextColor3 = Theme.TextMuted}, Anim.ColorChange)
                end
                if tab.Button:FindFirstChild("Icon") then
                    Tween(tab.Button.Icon, {ImageColor3 = Theme.TextMuted}, Anim.ColorChange)
                end
                local ind = tab.Button:FindFirstChildOfClass("Frame")
                if ind then
                    Tween(ind, {Size = UDim2.new(0, 0, 0, 32)}, Anim.ColorChange)
                end
                -- Hide glow for inactive tabs
                local glow = tab.Button:FindFirstChild("Glow")
                if glow then
                    Tween(glow, {ImageTransparency = 1}, Anim.ColorChange)
                end
                tab.Page.Visible = false
            end
            
            Tween(tabBtn, {BackgroundTransparency = 0.1}, Anim.ColorChange)
            Tween(tabBtn.Label, {TextColor3 = Theme.Text}, Anim.ColorChange)
            if tabBtn:FindFirstChild("Icon") then
                Tween(tabBtn.Icon, {ImageColor3 = Theme.Accent}, Anim.ColorChange)
            end
            Tween(indicator, {Size = UDim2.new(0, 5, 0, 32)}, Anim.SizeChange, Enum.EasingStyle.Back)
            Tween(tabGlow, {ImageTransparency = 0.8}, Anim.ColorChange)
            page.Visible = true
            Window.ActiveTab = Tab
        end
        
        Tab.Connections:Connect(tabBtn.MouseButton1Click, function()
            Ripple(tabBtn, Mouse.X, Mouse.Y)
            selectTab()
        end)
        
        Tab.Connections:Connect(tabBtn.MouseEnter, function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 0.5, Size = UDim2.new(1, 4, 0, 52)}, Anim.ElementHover)
                Tween(tabGlow, {ImageTransparency = 0.9}, Anim.ElementHover)
            end
        end)
        
        Tab.Connections:Connect(tabBtn.MouseLeave, function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 48)}, Anim.ElementHover)
                Tween(tabGlow, {ImageTransparency = 1}, Anim.ElementHover)
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            selectTab()
        end
        
        -- ═══════════════════════════════════════════════════════
        -- ELEMENT BASE WITH REMOVE METHOD
        -- ═══════════════════════════════════════════════════════
        local function CreateElementBase(container)
            local element = {
                Container = container,
                Connections = CreateConnectionManager()
            }
            
            function element:Remove()
                self.Connections:DisconnectAll()
                if self.Container and self.Container.Parent then
                    Tween(self.Container, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)}, Anim.SizeChange)
                    task.delay(Anim.SizeChange + 0.05, function()
                        if self.Container and self.Container.Parent then
                            self.Container:Destroy()
                        end
                    end)
                end
                for i, el in ipairs(Tab.Elements) do
                    if el == self then
                        table.remove(Tab.Elements, i)
                        break
                    end
                end
            end
            
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- SECTION (Enhanced)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateSection(config)
            config = config or {}
            
            local section = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 38),
                Parent = page
            })
            
            Create("Frame", {
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = 0.6,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0, 1),
                Parent = section
            })
            
            local labelBg = Create("Frame", {
                BackgroundColor3 = Theme.Primary,
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 0, 0, 26),
                AutomaticSize = Enum.AutomaticSize.X,
                Parent = section
            })
            
            Padding(labelBg, 0, 0, 0, 12)
            
            Create("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = GetIcon(config.Icon or "star"),
                ImageColor3 = Theme.Accent,
                Parent = labelBg
            })
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 22, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Font = Enum.Font.GothamBold,
                Text = config.Name or "Section",
                TextColor3 = Theme.Accent,
                TextSize = 12,
                Parent = labelBg
            })
            
            local element = CreateElementBase(section)
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- TOGGLE (Enhanced with glow)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateToggle(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                BackgroundTransparency = Theme.GlassTransparency,
                Size = UDim2.new(1, 0, 0, config.Description and 68 or 54),
                Parent = page
            })
            Corner(container, 14)
            Stroke(container, Theme.Border, 1, 0.5)
            local containerGlow = CreateGlow(container, Theme.Accent, 25, 1)
            
            local element = CreateElementBase(container)
            element.Value = config.CurrentValue or false
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, config.Description and 14 or 0),
                Size = UDim2.new(1, -90, 0, config.Description and 22 or 54),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Toggle",
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            if config.Description then
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 16, 0, 38),
                    Size = UDim2.new(1, -90, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = config.Description,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
            end
            
            -- Enhanced switch
            local switch = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(1, -66, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 52, 0, 28),
                Parent = container
            })
            Corner(switch, 14)
            local switchGlow = CreateGlow(switch, Theme.Accent, 15, 1)
            
            local circle = Create("Frame", {
                BackgroundColor3 = Theme.TextMuted,
                Position = UDim2.new(0, 4, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 22, 0, 22),
                Parent = switch
            })
            Corner(circle, 11)
            CreateShadow(circle, 2, 8, nil, 0.5)
            
            local pulseConnection = nil
            
            local function update()
                if element.Value then
                    Tween(switch, {BackgroundColor3 = Theme.Accent}, Anim.SizeChange)
                    Tween(circle, {
                        Position = UDim2.new(1, -26, 0.5, 0),
                        BackgroundColor3 = Theme.Text
                    }, Anim.SizeChange, Enum.EasingStyle.Back)
                    Tween(switchGlow, {ImageTransparency = 0.6, ImageColor3 = Theme.Accent}, Anim.ColorChange)
                    Tween(containerGlow, {ImageTransparency = 0.85}, Anim.ColorChange)
                    
                    -- Add pulse when enabled
                    if pulseConnection then pulseConnection:Disconnect() end
                    pulseConnection = CreatePulseGlow(switchGlow, 0.4, 0.7, 0.8)
                else
                    Tween(switch, {BackgroundColor3 = Theme.Tertiary}, Anim.SizeChange)
                    Tween(circle, {
                        Position = UDim2.new(0, 4, 0.5, 0),
                        BackgroundColor3 = Theme.TextMuted
                    }, Anim.SizeChange)
                    Tween(switchGlow, {ImageTransparency = 1}, Anim.ColorChange)
                    Tween(containerGlow, {ImageTransparency = 1}, Anim.ColorChange)
                    
                    if pulseConnection then
                        pulseConnection:Disconnect()
                        pulseConnection = nil
                    end
                end
            end
            
            update()
            
            local btn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = container
            })
            
            element.Connections:Connect(btn.MouseButton1Click, function()
                element.Value = not element.Value
                update()
                SafeCallback(callback, element.Value)
            end)
            
            element.Connections:Connect(container.MouseEnter, function()
                Tween(container, {BackgroundColor3 = Theme.Hover, Size = UDim2.new(1, 4, 0, config.Description and 72 or 58)}, Anim.ElementHover)
            end)
            element.Connections:Connect(container.MouseLeave, function()
                Tween(container, {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, config.Description and 68 or 54)}, Anim.ElementHover)
            end)
            
            function element:Set(value)
                element.Value = value
                update()
                SafeCallback(callback, value)
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- SLIDER (Enhanced with glow trail)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateSlider(config)
            config = config or {}
            local range = config.Range or {0, 100}
            local increment = config.Increment or 1
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                BackgroundTransparency = Theme.GlassTransparency,
                Size = UDim2.new(1, 0, 0, 70),
                Parent = page
            })
            Corner(container, 14)
            Stroke(container, Theme.Border, 1, 0.5)
            
            local element = CreateElementBase(container)
            element.Value = config.CurrentValue or range[1]
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 14),
                Size = UDim2.new(0.6, 0, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Slider",
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local valueLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -16, 0, 14),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0.3, 0, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = tostring(element.Value),
                TextColor3 = Theme.Accent,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = container
            })
            
            -- Track with glow
            local track = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(0, 16, 0, 46),
                Size = UDim2.new(1, -32, 0, 12),
                Parent = container
            })
            Corner(track, 6)
            
            -- Glow trail behind fill
            local fillGlow = Create("Frame", {
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = 0.7,
                Size = UDim2.new((element.Value - range[1]) / (range[2] - range[1]), 10, 1, 6),
                Position = UDim2.new(0, -5, 0, -3),
                ZIndex = 0,
                Parent = track
            })
            Corner(fillGlow, 8)
            
            local fill = Create("Frame", {
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((element.Value - range[1]) / (range[2] - range[1]), 0, 1, 0),
                Parent = track
            })
            Corner(fill, 6)
            local fillGradient = CreateGradient(fill, Theme.Accent, Theme.AccentSecondary, 0)
            
            -- Enhanced knob with glow
            local knob = Create("Frame", {
                BackgroundColor3 = Theme.Text,
                Position = UDim2.new((element.Value - range[1]) / (range[2] - range[1]), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0, 24, 0, 24),
                Parent = track
            })
            Corner(knob, 12)
            Stroke(knob, Theme.Accent, 3, 0)
            local knobGlow = CreateGlow(knob, Theme.Accent, 20, 0.5)
            CreateShadow(knob, 2, 10, nil, 0.4)
            
            local function setValue(value)
                value = math.clamp(value, range[1], range[2])
                value = math.floor(value / increment + 0.5) * increment
                element.Value = value
                
                local percent = (value - range[1]) / (range[2] - range[1])
                Tween(fill, {Size = UDim2.new(percent, 0, 1, 0)}, Anim.SliderDrag)
                Tween(fillGlow, {Size = UDim2.new(percent, 10, 1, 6)}, Anim.SliderDrag)
                Tween(knob, {Position = UDim2.new(percent, 0, 0.5, 0)}, Anim.SliderDrag)
                valueLabel.Text = tostring(value)
                SafeCallback(callback, value)
            end
            
            local dragging = false
            
            element.Connections:Connect(track.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    Tween(knob, {Size = UDim2.new(0, 28, 0, 28)}, Anim.ElementClick)
                    Tween(knobGlow, {ImageTransparency = 0.3}, Anim.ElementClick)
                    local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    setValue(range[1] + (range[2] - range[1]) * percent)
                end
            end)
            
            element.Connections:Connect(UserInputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        dragging = false
                        Tween(knob, {Size = UDim2.new(0, 24, 0, 24)}, Anim.ColorChange, Enum.EasingStyle.Back)
                        Tween(knobGlow, {ImageTransparency = 0.5}, Anim.ColorChange)
                    end
                end
            end)
            
            element.Connections:Connect(UserInputService.InputChanged, function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    setValue(range[1] + (range[2] - range[1]) * percent)
                end
            end)
            
            element.Connections:Connect(container.MouseEnter, function()
                Tween(container, {BackgroundColor3 = Theme.Hover, Size = UDim2.new(1, 4, 0, 74)}, Anim.ElementHover)
            end)
            element.Connections:Connect(container.MouseLeave, function()
                Tween(container, {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 70)}, Anim.ElementHover)
            end)
            
            function element:Set(value)
                setValue(value)
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- BUTTON (Enhanced with gradient + glow)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateButton(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 52),
                Parent = page
            })
            
            local btn = Create("TextButton", {
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = 0.1,
                Position = UDim2.new(0, 0, 0, 2),
                Size = UDim2.new(1, 0, 1, -4),
                Font = Enum.Font.GothamBold,
                Text = config.Name or "Button",
                TextColor3 = Theme.Primary,
                TextSize = 15,
                AutoButtonColor = false,
                Parent = container
            })
            Corner(btn, 12)
            
            -- Gradient
            local btnGradient = CreateGradient(btn, Theme.Accent, Theme.AccentSecondary, 45)
            
            -- Glow stroke
            Stroke(btn, Theme.AccentGlow, 2, 0.4)
            
            -- Shadow
            CreateShadow(btn, 3, 15, Theme.Accent, 0.6)
            local btnGlow = CreateGlow(btn, Theme.Accent, 25, 0.7)
            
            local element = CreateElementBase(container)
            
            element.Connections:Connect(btn.MouseEnter, function()
                Tween(btn, {BackgroundTransparency = 0, Size = UDim2.new(1, 4, 1, 0)}, Anim.ElementHover)
                Tween(btnGlow, {ImageTransparency = 0.5}, Anim.ElementHover)
            end)
            
            element.Connections:Connect(btn.MouseLeave, function()
                Tween(btn, {BackgroundTransparency = 0.1, Size = UDim2.new(1, 0, 1, -4)}, Anim.ElementHover)
                                Tween(btnGlow, {ImageTransparency = 0.7}, Anim.ElementHover)
            end)
            
            element.Connections:Connect(btn.MouseButton1Click, function()
                Ripple(btn, Mouse.X, Mouse.Y)
                -- Click animation with elastic bounce back
                Tween(btn, {Size = UDim2.new(1, -8, 1, -12)}, Anim.ElementClick)
                task.wait(Anim.ElementClick)
                Tween(btn, {Size = UDim2.new(1, 0, 1, -4)}, 0.25, Enum.EasingStyle.Elastic)
                SafeCallback(callback)
            end)
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- DROPDOWN (Enhanced with glassmorphism)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateDropdown(config)
            config = config or {}
            local options = config.Options or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                BackgroundTransparency = Theme.GlassTransparency,
                Size = UDim2.new(1, 0, 0, 54),
                ClipsDescendants = true,
                Parent = page
            })
            Corner(container, 14)
            Stroke(container, Theme.Border, 1, 0.5)
            local containerGlow = CreateGlow(container, Theme.Accent, 25, 1)
            
            local element = CreateElementBase(container)
            element.Value = config.CurrentOption or options[1] or ""
            element.Open = false
            element.Options = options
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.4, 0, 0, 54),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Dropdown",
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local selected = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(0.4, 0, 0, 11),
                Size = UDim2.new(0.6, -16, 0, 32),
                Font = Enum.Font.GothamMedium,
                Text = element.Value .. "  ▼",
                TextColor3 = Theme.Text,
                TextSize = 13,
                AutoButtonColor = false,
                Parent = container
            })
            Corner(selected, 10)
            Stroke(selected, Theme.Border, 1, 0.5)
            
            -- Options container
            local optContainer = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 60),
                Size = UDim2.new(1, -32, 0, #options * 40),
                Parent = container
            })
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4),
                Parent = optContainer
            })
            
            local function createOptions()
                for _, child in pairs(optContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                for i, opt in ipairs(element.Options) do
                    local optBtn = Create("TextButton", {
                        BackgroundColor3 = Theme.Tertiary,
                        BackgroundTransparency = 0.3,
                        Size = UDim2.new(1, 0, 0, 38),
                        Font = Enum.Font.Gotham,
                        Text = opt,
                        TextColor3 = Theme.TextDark,
                        TextSize = 13,
                        AutoButtonColor = false,
                        Parent = optContainer
                    })
                    Corner(optBtn, 10)
                    
                    local optGlow = CreateGlow(optBtn, Theme.Accent, 15, 1)
                    
                    element.Connections:Connect(optBtn.MouseEnter, function()
                        Tween(optBtn, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0, Size = UDim2.new(1, 4, 0, 40)}, Anim.ElementHover)
                        Tween(optBtn, {TextColor3 = Theme.Primary}, Anim.ElementHover)
                        Tween(optGlow, {ImageTransparency = 0.7}, Anim.ElementHover)
                    end)
                    
                    element.Connections:Connect(optBtn.MouseLeave, function()
                        Tween(optBtn, {BackgroundColor3 = Theme.Tertiary, BackgroundTransparency = 0.3, Size = UDim2.new(1, 0, 0, 38)}, Anim.ElementHover)
                        Tween(optBtn, {TextColor3 = Theme.TextDark}, Anim.ElementHover)
                        Tween(optGlow, {ImageTransparency = 1}, Anim.ElementHover)
                    end)
                    
                    element.Connections:Connect(optBtn.MouseButton1Click, function()
                        element.Value = opt
                        selected.Text = opt .. "  ▼"
                        element.Open = false
                        Library.OpenDropdowns[element] = nil
                        Tween(container, {Size = UDim2.new(1, 0, 0, 54)}, Anim.SizeChange, Enum.EasingStyle.Quint)
                        Tween(containerGlow, {ImageTransparency = 1}, Anim.ColorChange)
                        SafeCallback(callback, opt)
                    end)
                end
            end
            
            createOptions()
            
            local function closeDropdown()
                element.Open = false
                selected.Text = element.Value .. "  ▼"
                Tween(container, {Size = UDim2.new(1, 0, 0, 54)}, Anim.SizeChange, Enum.EasingStyle.Quint)
                Tween(containerGlow, {ImageTransparency = 1}, Anim.ColorChange)
                Library.OpenDropdowns[element] = nil
            end
            
            element.Connections:Connect(selected.MouseButton1Click, function()
                element.Open = not element.Open
                local targetSize = element.Open and (66 + #element.Options * 42) or 54
                Tween(container, {Size = UDim2.new(1, 0, 0, targetSize)}, Anim.SizeChange, Enum.EasingStyle.Quint)
                selected.Text = element.Value .. (element.Open and "  ▲" or "  ▼")
                
                if element.Open then
                    Tween(containerGlow, {ImageTransparency = 0.85}, Anim.ColorChange)
                    Library.OpenDropdowns[element] = {
                        Container = container,
                        Open = true,
                        Close = closeDropdown
                    }
                else
                    Tween(containerGlow, {ImageTransparency = 1}, Anim.ColorChange)
                    Library.OpenDropdowns[element] = nil
                end
            end)
            
            element.Connections:Connect(container.MouseEnter, function()
                Tween(container, {BackgroundColor3 = Theme.Hover}, Anim.ElementHover)
            end)
            element.Connections:Connect(container.MouseLeave, function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, Anim.ElementHover)
            end)
            
            function element:Set(value)
                element.Value = value
                selected.Text = value .. "  ▼"
                SafeCallback(callback, value)
            end
            
            function element:Refresh(newOptions)
                element.Options = newOptions
                optContainer.Size = UDim2.new(1, -32, 0, #newOptions * 42)
                createOptions()
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- INPUT (Enhanced with glow on focus)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateInput(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                BackgroundTransparency = Theme.GlassTransparency,
                Size = UDim2.new(1, 0, 0, 54),
                Parent = page
            })
            Corner(container, 14)
            Stroke(container, Theme.Border, 1, 0.5)
            local containerGlow = CreateGlow(container, Theme.Accent, 25, 1)
            
            local element = CreateElementBase(container)
            element.Value = ""
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.35, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Input",
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local box = Create("TextBox", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(0.35, 0, 0, 11),
                Size = UDim2.new(0.65, -16, 0, 32),
                Font = Enum.Font.Gotham,
                PlaceholderText = config.PlaceholderText or "Enter text...",
                PlaceholderColor3 = Theme.TextMuted,
                Text = "",
                TextColor3 = Theme.Text,
                TextSize = 13,
                ClearTextOnFocus = false,
                Parent = container
            })
            Corner(box, 10)
            
            local boxStroke = Stroke(box, Theme.Border, 1.5, 0.4)
            local boxGlow = CreateGlow(box, Theme.Accent, 15, 1)
            
            element.Connections:Connect(box.Focused, function()
                Tween(boxStroke, {Color = Theme.Accent, Transparency = 0}, Anim.ColorChange)
                Tween(boxGlow, {ImageTransparency = 0.6}, Anim.ColorChange)
                Tween(containerGlow, {ImageTransparency = 0.85}, Anim.ColorChange)
            end)
            
            element.Connections:Connect(box.FocusLost, function(enterPressed)
                Tween(boxStroke, {Color = Theme.Border, Transparency = 0.4}, Anim.ColorChange)
                Tween(boxGlow, {ImageTransparency = 1}, Anim.ColorChange)
                Tween(containerGlow, {ImageTransparency = 1}, Anim.ColorChange)
                element.Value = box.Text
                if enterPressed then
                    SafeCallback(callback, box.Text)
                end
            end)
            
            element.Connections:Connect(container.MouseEnter, function()
                Tween(container, {BackgroundColor3 = Theme.Hover, Size = UDim2.new(1, 4, 0, 58)}, Anim.ElementHover)
            end)
            element.Connections:Connect(container.MouseLeave, function()
                Tween(container, {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 54)}, Anim.ElementHover)
            end)
            
            function element:Set(text)
                box.Text = text
                element.Value = text
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- KEYBIND (Enhanced with glow)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateKeybind(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                BackgroundTransparency = Theme.GlassTransparency,
                Size = UDim2.new(1, 0, 0, 54),
                Parent = page
            })
            Corner(container, 14)
            Stroke(container, Theme.Border, 1, 0.5)
            local containerGlow = CreateGlow(container, Theme.Accent, 25, 1)
            
            local element = CreateElementBase(container)
            element.Value = config.CurrentKeybind or "None"
            element.Listening = false
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Keybind",
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local keyBtn = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(1, -96, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 82, 0, 32),
                Font = Enum.Font.GothamBold,
                Text = element.Value,
                TextColor3 = Theme.Accent,
                TextSize = 13,
                AutoButtonColor = false,
                Parent = container
            })
            Corner(keyBtn, 10)
            local keyStroke = Stroke(keyBtn, Theme.Accent, 1.5, 0.4)
            local keyGlow = CreateGlow(keyBtn, Theme.Accent, 15, 0.9)
            
            element.Connections:Connect(keyBtn.MouseButton1Click, function()
                element.Listening = true
                keyBtn.Text = "..."
                Tween(keyBtn, {BackgroundColor3 = Theme.Accent}, Anim.ColorChange)
                Tween(keyGlow, {ImageTransparency = 0.5}, Anim.ColorChange)
                keyBtn.TextColor3 = Theme.Primary
            end)
            
            element.Connections:Connect(UserInputService.InputBegan, function(input, gameProcessed)
                if element.Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    element.Value = input.KeyCode.Name
                    keyBtn.Text = input.KeyCode.Name
                    element.Listening = false
                    Tween(keyBtn, {BackgroundColor3 = Theme.Tertiary}, Anim.ColorChange)
                    Tween(keyGlow, {ImageTransparency = 0.9}, Anim.ColorChange)
                    keyBtn.TextColor3 = Theme.Accent
                    
                    -- Success flash
                    Tween(keyStroke, {Color = Theme.Success, Transparency = 0}, Anim.ColorChange)
                    Tween(keyGlow, {ImageColor3 = Theme.Success, ImageTransparency = 0.5}, Anim.ColorChange)
                    task.delay(0.5, function()
                        Tween(keyStroke, {Color = Theme.Accent, Transparency = 0.4}, Anim.SizeChange)
                        Tween(keyGlow, {ImageColor3 = Theme.Accent, ImageTransparency = 0.9}, Anim.SizeChange)
                    end)
                    
                    Library:Notify({
                        Title = "Keybind Set",
                        Content = "Keybind set to: " .. input.KeyCode.Name,
                        Icon = "check",
                        Time = 2
                    })
                elseif not gameProcessed and not element.Listening and input.KeyCode.Name == element.Value then
                    SafeCallback(callback, element.Value)
                end
            end)
            
            element.Connections:Connect(container.MouseEnter, function()
                Tween(container, {BackgroundColor3 = Theme.Hover, Size = UDim2.new(1, 4, 0, 58)}, Anim.ElementHover)
                Tween(containerGlow, {ImageTransparency = 0.9}, Anim.ElementHover)
            end)
            element.Connections:Connect(container.MouseLeave, function()
                Tween(container, {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 54)}, Anim.ElementHover)
                Tween(containerGlow, {ImageTransparency = 1}, Anim.ElementHover)
            end)
            
            function element:Set(key)
                element.Value = key
                keyBtn.Text = key
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- LABEL (Enhanced)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateLabel(config)
            config = config or {}
            
            local label = Create("TextLabel", {
                BackgroundColor3 = Theme.Secondary,
                BackgroundTransparency = Theme.GlassTransparency,
                Size = UDim2.new(1, 0, 0, 42),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Label",
                TextColor3 = Theme.TextDark,
                TextSize = 14,
                Parent = page
            })
            Corner(label, 12)
            Stroke(label, Theme.Border, 1, 0.5)
            
            local element = CreateElementBase(label)
            
            function element:Set(text)
                label.Text = text
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- PARAGRAPH (Enhanced with accent)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateParagraph(config)
            config = config or {}
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                BackgroundTransparency = Theme.GlassTransparency,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = page
            })
            Corner(container, 14)
            Stroke(container, Theme.Border, 1, 0.5)
            Padding(container, 16, 16, 16, 16)
            
            -- Accent bar on left
            local accentBar = Create("Frame", {
                BackgroundColor3 = Theme.Accent,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 4, 1, 0),
                Parent = container
            })
            Corner(accentBar, 2)
            CreateGradient(accentBar, Theme.Accent, Theme.AccentSecondary, 90)
            
            local element = CreateElementBase(container)
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
                Parent = container
            })
            
            local titleLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 0),
                Size = UDim2.new(1, -8, 0, 22),
                Font = Enum.Font.GothamBold,
                Text = config.Title or "Title",
                TextColor3 = Theme.Accent,
                TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 1,
                Parent = container
            })
            
            local contentLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 0),
                Size = UDim2.new(1, -8, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Font = Enum.Font.Gotham,
                Text = config.Content or "",
                TextColor3 = Theme.TextDark,
                TextSize = 13,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 2,
                Parent = container
            })
            
            function element:Set(title, content)
                titleLabel.Text = title or titleLabel.Text
                contentLabel.Text = content or contentLabel.Text
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- COLOR PICKER (Enhanced with glow)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateColorPicker(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                BackgroundTransparency = Theme.GlassTransparency,
                Size = UDim2.new(1, 0, 0, 54),
                ClipsDescendants = true,
                Parent = page
            })
            Corner(container, 14)
            Stroke(container, Theme.Border, 1, 0.5)
            
            local element = CreateElementBase(container)
            element.Value = config.Color or Color3.fromRGB(255, 255, 255)
            element.Open = false
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.6, 0, 0, 54),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Color",
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local preview = Create("TextButton", {
                BackgroundColor3 = element.Value,
                Position = UDim2.new(1, -56, 0, 13),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0, 42, 0, 28),
                Text = "",
                AutoButtonColor = false,
                Parent = container
            })
            Corner(preview, 8)
            Stroke(preview, Theme.Text, 2, 0)
            local previewGlow = CreateGlow(preview, element.Value, 20, 0.6)
            
            -- RGB Sliders
            local slidersFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 62),
                Size = UDim2.new(1, -32, 0, 110),
                Parent = container
            })
            
            local r = element.Value.R * 255
            local g = element.Value.G * 255
            local b = element.Value.B * 255
            
            local rSlider, rFill, rLabel
            local gSlider, gFill, gLabel
            local bSlider, bFill, bLabel
            
            local function createColorSlider(name, color, yPos, initialValue)
                local sliderBg = Create("Frame", {
                    BackgroundColor3 = Theme.Tertiary,
                    Position = UDim2.new(0, 0, 0, yPos),
                    Size = UDim2.new(1, -54, 0, 28),
                    Parent = slidersFrame
                })
                Corner(sliderBg, 8)
                
                local sliderFill = Create("Frame", {
                    BackgroundColor3 = color,
                    Size = UDim2.new(initialValue / 255, 0, 1, 0),
                    Parent = sliderBg
                })
                Corner(sliderFill, 8)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0, 20, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    ZIndex = 2,
                    Parent = sliderBg
                })
                
                local valueLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 8, 0, yPos),
                    Size = UDim2.new(0, 44, 0, 28),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(math.floor(initialValue)),
                    TextColor3 = color,
                    TextSize = 13,
                    Parent = slidersFrame
                })
                
                return sliderBg, sliderFill, valueLabel
            end
            
            rSlider, rFill, rLabel = createColorSlider("R", Color3.fromRGB(255, 100, 100), 0, r)
            gSlider, gFill, gLabel = createColorSlider("G", Color3.fromRGB(100, 255, 100), 38, g)
            bSlider, bFill, bLabel = createColorSlider("B", Color3.fromRGB(100, 150, 255), 76, b)
            
            local function updateColor()
                local rv = element.Value.R * 255
                local gv = element.Value.G * 255
                local bv = element.Value.B * 255
                
                preview.BackgroundColor3 = element.Value
                previewGlow.ImageColor3 = element.Value
                
                Tween(rFill, {Size = UDim2.new(rv / 255, 0, 1, 0)}, Anim.SliderDrag)
                Tween(gFill, {Size = UDim2.new(gv / 255, 0, 1, 0)}, Anim.SliderDrag)
                Tween(bFill, {Size = UDim2.new(bv / 255, 0, 1, 0)}, Anim.SliderDrag)
                
                rLabel.Text = tostring(math.floor(rv))
                gLabel.Text = tostring(math.floor(gv))
                bLabel.Text = tostring(math.floor(bv))
                
                SafeCallback(callback, element.Value)
            end
            
            local function setupColorSliderDrag(slider, component)
                local dragging = false
                
                element.Connections:Connect(slider.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        local percent = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        local value = math.floor(percent * 255)
                        
                        local rv = element.Value.R * 255
                        local gv = element.Value.G * 255
                        local bv = element.Value.B * 255
                        
                        if component == "R" then rv = value
                        elseif component == "G" then gv = value
                        else bv = value end
                        
                        element.Value = Color3.fromRGB(rv, gv, bv)
                        updateColor()
                    end
                end)
                
                element.Connections:Connect(UserInputService.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                element.Connections:Connect(UserInputService.InputChanged, function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local percent = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        local value = math.floor(percent * 255)
                        
                        local rv = element.Value.R * 255
                        local gv = element.Value.G * 255
                        local bv = element.Value.B * 255
                        
                        if component == "R" then rv = value
                        elseif component == "G" then gv = value
                        else bv = value end
                        
                        element.Value = Color3.fromRGB(rv, gv, bv)
                        updateColor()
                    end
                end)
            end
            
            setupColorSliderDrag(rSlider, "R")
            setupColorSliderDrag(gSlider, "G")
            setupColorSliderDrag(bSlider, "B")
            
            element.Connections:Connect(preview.MouseButton1Click, function()
                element.Open = not element.Open
                if element.Open then
                    Tween(container, {Size = UDim2.new(1, 0, 0, 180)}, Anim.SizeChange, Enum.EasingStyle.Quint)
                    Tween(previewGlow, {ImageTransparency = 0.4}, Anim.ColorChange)
                else
                    Tween(container, {Size = UDim2.new(1, 0, 0, 54)}, Anim.SizeChange, Enum.EasingStyle.Quint)
                    Tween(previewGlow, {ImageTransparency = 0.6}, Anim.ColorChange)
                end
            end)
            
            element.Connections:Connect(container.MouseEnter, function()
                Tween(container, {BackgroundColor3 = Theme.Hover}, Anim.ElementHover)
            end)
            element.Connections:Connect(container.MouseLeave, function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, Anim.ElementHover)
            end)
            
            function element:Set(color)
                element.Value = color
                updateColor()
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- DIVIDER (Enhanced with gradient)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateDivider()
            local divider = Create("Frame", {
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = 0.7,
                Size = UDim2.new(1, 0, 0, 2),
                Parent = page
            })
            Corner(divider, 1)
            CreateGradient(divider, Theme.Accent, Theme.AccentSecondary, 0)
            
            local element = CreateElementBase(divider)
            table.insert(Tab.Elements, element)
            return element
        end
        
        return Tab
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- OPENING ANIMATION (Smooth Back EaseOut with glow)
    -- ═══════════════════════════════════════════════════════════
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    mainContainer.BackgroundTransparency = 1
    accentGlow.ImageTransparency = 1
    
    -- Smooth 0.6s Back EaseOut animation with glow fade in
    Tween(mainContainer, {Size = UDim2.new(0, 800, 0, 500)}, Anim.WindowOpen, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.delay(0.2, function()
        Tween(accentGlow, {ImageTransparency = 0.85}, 0.4)
        Tween(mainGlowStroke, {Transparency = 0.6}, 0.4)
    end)
    
    -- Welcome notification
    task.spawn(function()
        task.wait(0.7)
        Library:Notify({
            Title = "Welcome to " .. windowName,
            Content = "Press RightCtrl to toggle. Enjoy the new look!",
            Icon = "star",
            Time = 4
        })
    end)
    
    table.insert(Library.Windows, Window)
    return Window
end

-- ═══════════════════════════════════════════════════════════════
-- DESTROY ALL WINDOWS
-- ═══════════════════════════════════════════════════════════════
function Library:DestroyAll()
    for _, connection in ipairs(Library.Connections) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    Library.Connections = {}
    
    for _, connection in ipairs(Library.ActiveAnimations) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    Library.ActiveAnimations = {}
    
    Library.OpenDropdowns = {}
    
    for _, window in pairs(Library.Windows) do
        if window.Destroy then
            window:Destroy()
        end
    end
    Library.Windows = {}
    
    local notifGui = CoreGui:FindFirstChild("StellarNotifications")
    if notifGui then
        notifGui:Destroy()
    end
end

function Library:GetTheme()
    return Theme
end

return Library
