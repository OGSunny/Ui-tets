--[[
    Stellar Hub UI Library v2.0
    Premium PVP Interface - Handcrafted Design
    
    Features:
    • Glassmorphism effects with depth layering
    • Micro-interactions with transform animations
    • Gradient strokes and glow effects
    • Monospace values + Sans-serif titles
    • Sharp 4px corners for that crisp look
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local Library = {}

-- Premium Dark Theme
Library.Theme = {
    -- Backgrounds (Dark Navy progression)
    Background = Color3.fromRGB(10, 10, 15),      -- #0A0A0F
    BackgroundFloat = Color3.fromRGB(13, 13, 18),  -- Floating elements
    Secondary = Color3.fromRGB(18, 18, 26),        -- #12121A
    Tertiary = Color3.fromRGB(26, 26, 38),         -- #1A1A26
    Elevated = Color3.fromRGB(32, 32, 45),         -- Hover states
    
    -- Accent (Mint Green)
    Accent = Color3.fromRGB(88, 255, 156),         -- #58FF9C
    AccentDark = Color3.fromRGB(62, 180, 110),     -- Darker accent
    AccentGlow = Color3.fromRGB(88, 255, 156),     -- For glow effects
    AccentSoft = Color3.fromRGB(88, 255, 156),     -- 20% opacity accent
    
    -- Text
    Text = Color3.fromRGB(245, 245, 250),          -- Primary text
    TextSecondary = Color3.fromRGB(160, 160, 175), -- Secondary text
    TextMuted = Color3.fromRGB(100, 100, 115),     -- Muted/disabled
    TextAccent = Color3.fromRGB(88, 255, 156),     -- Accent text
    
    -- States
    Success = Color3.fromRGB(88, 255, 156),
    Error = Color3.fromRGB(255, 88, 99),
    Warning = Color3.fromRGB(255, 200, 88),
    
    -- Borders
    Border = Color3.fromRGB(40, 40, 55),
    BorderLight = Color3.fromRGB(55, 55, 72),
}

Library.Config = {
    CornerRadius = 4,           -- Sharp corners
    SmallCorner = 3,
    Padding = 12,
    ElementSpacing = 6,
    AnimationSpeed = 0.15,      -- Snappy animations
    AnimationSpeedSlow = 0.25,
    HoverOffset = 2,            -- Pixels to move on hover
}

Library.ToggleKey = Enum.KeyCode.RightControl
Library.Fonts = {
    Title = Enum.Font.GothamBold,
    Subtitle = Enum.Font.GothamMedium,
    Body = Enum.Font.Gotham,
    Mono = Enum.Font.RobotoMono,      -- For values/numbers
}

-- Utility Functions
local function Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(instance, properties, duration, style, direction)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(
            duration or Library.Config.AnimationSpeed, 
            style or Enum.EasingStyle.Quart, 
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or Library.Config.CornerRadius),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness, transparency)
    local stroke = Create("UIStroke", {
        Color = color or Library.Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
    return stroke
end

local function AddGradientStroke(parent, color1, color2, thickness)
    local stroke = Create("UIStroke", {
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1 or Library.Theme.Accent),
            ColorSequenceKeypoint.new(1, color2 or Library.Theme.AccentDark)
        }),
        Rotation = 45,
        Parent = stroke
    })
    
    return stroke
end

local function AddPadding(parent, top, right, bottom, left)
    if type(top) == "number" and not right then
        right, bottom, left = top, top, top
    end
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        Parent = parent
    })
end

-- Add glow effect (shadow with accent color)
local function AddGlow(parent, color, size)
    local glow = Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, size or 30, 1, size or 30),
        Image = "rbxassetid://5554236805",
        ImageColor3 = color or Library.Theme.Accent,
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = 0,
        Parent = parent
    })
    return glow
end

-- Add subtle inner glow/gradient overlay
local function AddGlassOverlay(parent)
    local overlay = Create("Frame", {
        Name = "GlassOverlay",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 0,
        Parent = parent
    })
    
    local gradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.96),
            NumberSequenceKeypoint.new(0.5, 0.99),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Rotation = 90,
        Parent = overlay
    })
    
    local overlayFrame = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.96,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = overlay
    })
    AddCorner(overlayFrame, Library.Config.CornerRadius)
    
    return overlay
end

local function GetUserThumbnail()
    local success, result = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    return success and result or "rbxassetid://0"
end

-- Micro-interaction: Hover with translate
local function AddHoverEffect(button, translateX, translateY, scaleUp)
    local originalPosition = button.Position
    translateX = translateX or Library.Config.HoverOffset
    translateY = translateY or 0
    
    button.MouseEnter:Connect(function()
        Tween(button, {
            Position = UDim2.new(
                originalPosition.X.Scale, 
                originalPosition.X.Offset + translateX,
                originalPosition.Y.Scale, 
                originalPosition.Y.Offset + translateY
            )
        }, Library.Config.AnimationSpeed)
    end)
    
    button.MouseLeave:Connect(function()
        Tween(button, {Position = originalPosition}, Library.Config.AnimationSpeed)
    end)
end

-- Notification System
function Library:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Time or 4
    local notifType = config.Type or "Info" -- Info, Success, Error, Warning
    
    local typeColors = {
        Info = Library.Theme.Accent,
        Success = Library.Theme.Success,
        Error = Library.Theme.Error,
        Warning = Library.Theme.Warning
    }
    local accentColor = typeColors[notifType] or Library.Theme.Accent
    
    local screenGui = CoreGui:FindFirstChild("StellarNotifications")
    if not screenGui then
        screenGui = Create("ScreenGui", {
            Name = "StellarNotifications",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = CoreGui
        })
        
        Create("Frame", {
            Name = "Container",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -16, 1, -16),
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 320, 1, -32),
            Parent = screenGui
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 8),
            Parent = screenGui.Container
        })
    end
    
    local container = screenGui.Container
    
    local notification = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Library.Theme.Secondary,
        BackgroundTransparency = 0.05,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = container
    })
    AddCorner(notification, Library.Config.CornerRadius)
    AddStroke(notification, accentColor, 1, 0.5)
    
    -- Left accent bar
    Create("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = accentColor,
        Size = UDim2.new(0, 3, 1, 0),
        BorderSizePixel = 0,
        Parent = notification
    })
    
    local content_frame = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = notification
    })
    AddPadding(content_frame, 12, 14, 12, 16)
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = content_frame
    })
    
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        Font = Library.Fonts.Subtitle,
        Text = title,
        TextColor3 = accentColor,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = content_frame
    })
    
    Create("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Library.Fonts.Body,
        Text = content,
        TextColor3 = Library.Theme.TextSecondary,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 2,
        Parent = content_frame
    })
    
    -- Progress bar
    local progressContainer = Create("Frame", {
        Name = "Progress",
        BackgroundColor3 = Library.Theme.Tertiary,
        Size = UDim2.new(1, 0, 0, 2),
        LayoutOrder = 3,
        Parent = content_frame
    })
    AddCorner(progressContainer, 1)
    
    local progressBar = Create("Frame", {
        Name = "Bar",
        BackgroundColor3 = accentColor,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = progressContainer
    })
    AddCorner(progressBar, 1)
    
    -- Animate in
    notification.Position = UDim2.new(1, 50, 0, 0)
    Tween(notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
    
    -- Progress drain
    Tween(progressBar, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    task.delay(duration, function()
        Tween(notification, {Position = UDim2.new(1, 50, 0, 0)}, 0.25)
        task.wait(0.25)
        notification:Destroy()
    end)
    
    return notification
end

-- Main Window Creation
function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Name or "Stellar"
    local keyTime = config.KeyTime or "∞"
    local windowSize = config.Size or Vector2.new(780, 480)
    
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Minimized = false
    Window.Visible = true
    
    -- ScreenGui
    local screenGui = Create("ScreenGui", {
        Name = "StellarHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    Window.ScreenGui = screenGui
    
    -- Main Container (for shadow)
    local mainContainer = Create("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, windowSize.X + 40, 0, windowSize.Y + 40),
        Parent = screenGui
    })
    
    -- Drop Shadow
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 0, 1, 0),
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = mainContainer
    })
    
    -- Main Window Frame
    local mainFrame = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Library.Theme.Background,
        BackgroundTransparency = 0.02,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, windowSize.X, 0, windowSize.Y),
        ClipsDescendants = true,
        Parent = mainContainer
    })
    AddCorner(mainFrame, 6)
    AddStroke(mainFrame, Library.Theme.Border, 1)
    
    Window.MainFrame = mainFrame
    
    -- Top glass gradient overlay
    local topGradient = Create("Frame", {
        Name = "TopGradient",
        BackgroundColor3 = Library.Theme.Accent,
        BackgroundTransparency = 0.95,
        Size = UDim2.new(1, 0, 0, 150),
        ZIndex = 0,
        Parent = mainFrame
    })
    
    Create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Rotation = 90,
        Parent = topGradient
    })
    
    -- Title Bar
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Library.Theme.Secondary,
        BackgroundTransparency = 0.3,
        Size = UDim2.new(1, 0, 0, 44),
        Parent = mainFrame
    })
    
    -- Title bar bottom border
    Create("Frame", {
        Name = "Border",
        BackgroundColor3 = Library.Theme.Border,
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0,
        Parent = titleBar
    })
    
    -- Logo + Title (Left)
    local logoContainer = Create("Frame", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 200, 0, 28),
        Parent = titleBar
    })
    
    -- Animated logo glow
    local logoGlow = Create("Frame", {
        Name = "LogoGlow",
        BackgroundColor3 = Library.Theme.Accent,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 24, 0, 24),
        Parent = logoContainer
    })
    AddCorner(logoGlow, 12)
    
    local logoIcon = Create("TextLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 24, 0, 24),
        Font = Library.Fonts.Title,
        Text = "✦",
        TextColor3 = Library.Theme.Accent,
        TextSize = 18,
        Parent = logoContainer
    })
    
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 32, 0, 0),
        Size = UDim2.new(1, -32, 1, 0),
        Font = Library.Fonts.Title,
        Text = windowTitle,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = logoContainer
    })
    
    -- Right Controls
    local controls = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -14, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 300, 0, 28),
        Parent = titleBar
    })
    
    -- Close Button
    local closeBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Library.Theme.Error,
        BackgroundTransparency = 0.9,
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 28, 0, 28),
        Font = Library.Fonts.Body,
        Text = "✕",
        TextColor3 = Library.Theme.Error,
        TextSize = 12,
        AutoButtonColor = false,
        Parent = controls
    })
    AddCorner(closeBtn, Library.Config.CornerRadius)
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.6, TextColor3 = Library.Theme.Text})
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.9, TextColor3 = Library.Theme.Error})
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(mainContainer, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.25)
        screenGui:Destroy()
    end)
    
    -- Minimize Button
    local minBtn = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Library.Theme.Warning,
        BackgroundTransparency = 0.9,
        Position = UDim2.new(1, -36, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 28, 0, 28),
        Font = Library.Fonts.Body,
        Text = "─",
        TextColor3 = Library.Theme.Warning,
        TextSize = 12,
        AutoButtonColor = false,
        Parent = controls
    })
    AddCorner(minBtn, Library.Config.CornerRadius)
    
    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, {BackgroundTransparency = 0.6, TextColor3 = Library.Theme.Text})
    end)
    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, {BackgroundTransparency = 0.9, TextColor3 = Library.Theme.Warning})
    end)
    minBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(mainFrame, {Size = UDim2.new(0, windowSize.X, 0, 44)}, 0.25, Enum.EasingStyle.Back)
            Tween(mainContainer, {Size = UDim2.new(0, windowSize.X + 40, 0, 84)}, 0.25, Enum.EasingStyle.Back)
        else
            Tween(mainFrame, {Size = UDim2.new(0, windowSize.X, 0, windowSize.Y)}, 0.25, Enum.EasingStyle.Back)
            Tween(mainContainer, {Size = UDim2.new(0, windowSize.X + 40, 0, windowSize.Y + 40)}, 0.25, Enum.EasingStyle.Back)
        end
    end)
    
    -- Key Time Badge
    local keyBadge = Create("Frame", {
        Name = "KeyBadge",
        BackgroundColor3 = Library.Theme.Accent,
        BackgroundTransparency = 0.88,
        Position = UDim2.new(1, -72, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 0, 0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = controls
    })
    AddCorner(keyBadge, Library.Config.SmallCorner)
    AddStroke(keyBadge, Library.Theme.Accent, 1, 0.7)
    
    Create("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Library.Fonts.Mono,
        Text = "  " .. keyTime .. "  ",
        TextColor3 = Library.Theme.Accent,
        TextSize = 10,
        Parent = keyBadge
    })
    
    -- User Info
    local userContainer = Create("Frame", {
        Name = "User",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -180, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 100, 0, 24),
        Parent = controls
    })
    
    local avatarFrame = Create("Frame", {
        Name = "Avatar",
        BackgroundColor3 = Library.Theme.Accent,
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 24, 0, 24),
        Parent = userContainer
    })
    AddCorner(avatarFrame, 12)
    
    local avatar = Create("ImageLabel", {
        Name = "Image",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 22, 0, 22),
        Image = GetUserThumbnail(),
        Parent = avatarFrame
    })
    AddCorner(avatar, 11)
    
    Create("TextLabel", {
        Name = "Username",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(0, 70, 1, 0),
        Font = Library.Fonts.Mono,
        Text = LocalPlayer.Name,
        TextColor3 = Library.Theme.TextSecondary,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = userContainer
    })
    
    -- Sidebar
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Library.Theme.Secondary,
        BackgroundTransparency = 0.4,
        Position = UDim2.new(0, 0, 0, 44),
        Size = UDim2.new(0, 200, 1, -44),
        Parent = mainFrame
    })
    
    -- Sidebar right border
    Create("Frame", {
        Name = "Border",
        BackgroundColor3 = Library.Theme.Border,
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    -- Sidebar Header
    Create("TextLabel", {
        Name = "Header",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 16),
        Size = UDim2.new(1, -28, 0, 14),
        Font = Library.Fonts.Mono,
        Text = "MODULES",
        TextColor3 = Library.Theme.TextMuted,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sidebar
    })
    
    -- Tab Container
    local tabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 40),
        Size = UDim2.new(1, -16, 1, -56),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Library.Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = tabContainer
    })
    
    Window.TabContainer = tabContainer
    
    -- Content Area
    local contentArea = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 200, 0, 44),
        Size = UDim2.new(1, -200, 1, -44),
        Parent = mainFrame
    })
    Window.ContentArea = contentArea
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainContainer.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainContainer.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Toggle visibility
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Library.ToggleKey then
            Window.Visible = not Window.Visible
            screenGui.Enabled = Window.Visible
        end
    end)
    
    -- Tab Creation
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon
        
        local Tab = {}
        Tab.Elements = {}
        
        -- Tab Button
        local tabButton = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Library.Theme.Tertiary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 36),
            Font = Library.Fonts.Body,
            Text = "",
            AutoButtonColor = false,
            Parent = tabContainer
        })
        AddCorner(tabButton, Library.Config.CornerRadius)
        
        -- Active indicator (left bar)
        local activeIndicator = Create("Frame", {
            Name = "Indicator",
            BackgroundColor3 = Library.Theme.Accent,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 3, 0.5, 0),
            Parent = tabButton
        })
        AddCorner(activeIndicator, 2)
        
        -- Icon
        local iconLabel
        if tabIcon then
            iconLabel = Create("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 16, 0, 16),
                Image = tabIcon,
                ImageColor3 = Library.Theme.TextMuted,
                Parent = tabButton
            })
        end
        
        local titleLabel = Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, tabIcon and 36 or 12, 0, 0),
            Size = UDim2.new(1, tabIcon and -44 or -20, 1, 0),
            Font = Library.Fonts.Subtitle,
            Text = tabName,
            TextColor3 = Library.Theme.TextMuted,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabButton
        })
        
        Tab.Button = tabButton
        Tab.Indicator = activeIndicator
        Tab.Icon = iconLabel
        Tab.Title = titleLabel
        
        -- Content Scroll Frame
        local contentFrame = Create("ScrollingFrame", {
            Name = tabName .. "Content",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 16, 0, 16),
            Size = UDim2.new(1, -32, 1, -32),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            ScrollBarImageTransparency = 0.5,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = contentArea
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, Library.Config.ElementSpacing),
            Parent = contentFrame
        })
        
        Tab.Content = contentFrame
        
        -- Tab Selection
        local function selectTab()
            for _, t in pairs(Window.Tabs) do
                -- Deselect
                Tween(t.Button, {BackgroundTransparency = 1})
                Tween(t.Indicator, {BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0.3, 0)})
                Tween(t.Title, {TextColor3 = Library.Theme.TextMuted})
                if t.Icon then
                    Tween(t.Icon, {ImageColor3 = Library.Theme.TextMuted})
                end
                t.Content.Visible = false
            end
            
            -- Select this tab
            Tween(tabButton, {BackgroundTransparency = 0.8})
            Tween(activeIndicator, {BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0.5, 0)})
            Tween(titleLabel, {TextColor3 = Library.Theme.Text})
            if iconLabel then
                Tween(iconLabel, {ImageColor3 = Library.Theme.Accent})
            end
            contentFrame.Visible = true
            Window.ActiveTab = Tab
        end
        
        tabButton.MouseButton1Click:Connect(selectTab)
        
        -- Hover effects with micro-interaction
        tabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabButton, {BackgroundTransparency = 0.85})
                Tween(titleLabel, {TextColor3 = Library.Theme.TextSecondary})
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabButton, {BackgroundTransparency = 1})
                Tween(titleLabel, {TextColor3 = Library.Theme.TextMuted})
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            selectTab()
        end
        
        -- =========================
        -- ELEMENT CREATION METHODS
        -- =========================
        
        -- Section Divider
        function Tab:CreateSection(config)
            config = config or {}
            local sectionName = config.Name or "Section"
            
            local section = Create("Frame", {
                Name = "Section",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                Parent = contentFrame
            })
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 0, 0, 14),
                AutomaticSize = Enum.AutomaticSize.X,
                Font = Library.Fonts.Mono,
                Text = sectionName:upper(),
                TextColor3 = Library.Theme.TextMuted,
                TextSize = 9,
                Parent = section
            })
            
            Create("Frame", {
                Name = "Line",
                BackgroundColor3 = Library.Theme.Border,
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(1, 0, 0, 1),
                ZIndex = 0,
                Parent = section
            })
            
            return section
        end
        
        -- Toggle
        function Tab:CreateToggle(config)
            config = config or {}
            local toggleName = config.Name or "Toggle"
            local toggleDesc = config.Description
            local currentValue = config.CurrentValue or false
            local flag = config.Flag
            local callback = config.Callback or function() end
            
            local Toggle = {Value = currentValue, Type = "Toggle"}
            
            local height = toggleDesc and 52 or 40
            
            local toggleFrame = Create("Frame", {
                Name = "Toggle",
                BackgroundColor3 = Library.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, height),
                Parent = contentFrame
            })
            AddCorner(toggleFrame, Library.Config.CornerRadius)
            AddStroke(toggleFrame, Library.Theme.Border, 1, 0.5)
            
            local padding = Create("Frame", {
                Name = "Padding",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = toggleFrame
            })
            AddPadding(padding, 0, 14, 0, 14)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, toggleDesc and 8 or 0),
                Size = UDim2.new(1, -56, 0, toggleDesc and 18 or height),
                Font = Library.Fonts.Subtitle,
                Text = toggleName,
                TextColor3 = Library.Theme.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = padding
            })
            
            if toggleDesc then
                Create("TextLabel", {
                    Name = "Desc",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 26),
                    Size = UDim2.new(1, -56, 0, 16),
                    Font = Library.Fonts.Body,
                    Text = toggleDesc,
                    TextColor3 = Library.Theme.TextMuted,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = padding
                })
            end
            
            -- Toggle Switch
            local switchBg = Create("Frame", {
                Name = "Switch",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0, 40, 0, 20),
                Parent = padding
            })
            AddCorner(switchBg, 10)
            AddStroke(switchBg, Library.Theme.Border, 1, 0.5)
            
            local switchKnob = Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Library.Theme.TextMuted,
                Position = UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 14, 0, 14),
                Parent = switchBg
            })
            AddCorner(switchKnob, 7)
            
            -- Glow effect when on
            local switchGlow = AddGlow(switchBg, Library.Theme.Accent, 20)
            switchGlow.ImageTransparency = 1
            switchGlow.ZIndex = 0
            
            local function updateToggle(skipCallback)
                if Toggle.Value then
                    Tween(switchBg, {BackgroundColor3 = Library.Theme.Accent})
                    Tween(switchKnob, {
                        Position = UDim2.new(1, -17, 0.5, 0),
                        BackgroundColor3 = Library.Theme.Background
                    })
                    Tween(switchGlow, {ImageTransparency = 0.7})
                    local stroke = switchBg:FindFirstChildOfClass("UIStroke")
                    if stroke then Tween(stroke, {Color = Library.Theme.Accent, Transparency = 0}) end
                else
                    Tween(switchBg, {BackgroundColor3 = Library.Theme.Tertiary})
                    Tween(switchKnob, {
                        Position = UDim2.new(0, 3, 0.5, 0),
                        BackgroundColor3 = Library.Theme.TextMuted
                    })
                    Tween(switchGlow, {ImageTransparency = 1})
                    local stroke = switchBg:FindFirstChildOfClass("UIStroke")
                    if stroke then Tween(stroke, {Color = Library.Theme.Border, Transparency = 0.5}) end
                end
                if not skipCallback then
                    callback(Toggle.Value)
                end
            end
            
            updateToggle(true)
            
            local clickButton = Create("TextButton", {
                Name = "Click",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = toggleFrame
            })
            
            clickButton.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                updateToggle()
            end)
            
            -- Hover micro-interaction
            clickButton.MouseEnter:Connect(function()
                Tween(toggleFrame, {BackgroundTransparency = 0.3})
            end)
            clickButton.MouseLeave:Connect(function()
                Tween(toggleFrame, {BackgroundTransparency = 0.5})
            end)
            
            function Toggle:Set(value)
                Toggle.Value = value
                updateToggle()
            end
            
            table.insert(Tab.Elements, Toggle)
            return Toggle
        end
        
        -- Slider
        function Tab:CreateSlider(config)
            config = config or {}
            local sliderName = config.Name or "Slider"
            local sliderDesc = config.Description
            local range = config.Range or {0, 100}
            local increment = config.Increment or 1
            local suffix = config.Suffix or ""
            local currentValue = config.CurrentValue or range[1]
            local callback = config.Callback or function() end
            
            local Slider = {Value = currentValue, Type = "Slider"}
            
            local height = sliderDesc and 64 or 52
            
            local sliderFrame = Create("Frame", {
                Name = "Slider",
                BackgroundColor3 = Library.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, height),
                Parent = contentFrame
            })
            AddCorner(sliderFrame, Library.Config.CornerRadius)
            AddStroke(sliderFrame, Library.Theme.Border, 1, 0.5)
            
            local padding = Create("Frame", {
                Name = "Padding",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = sliderFrame
            })
            AddPadding(padding, 0, 14, 0, 14)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 8),
                Size = UDim2.new(0.6, 0, 0, 16),
                Font = Library.Fonts.Subtitle,
                Text = sliderName,
                TextColor3 = Library.Theme.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = padding
            })
            
            local valueLabel = Create("TextLabel", {
                Name = "Value",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0, 8),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0.4, 0, 0, 16),
                Font = Library.Fonts.Mono,
                Text = tostring(currentValue) .. suffix,
                TextColor3 = Library.Theme.Accent,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = padding
            })
            
            if sliderDesc then
                Create("TextLabel", {
                    Name = "Desc",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 24),
                    Size = UDim2.new(1, 0, 0, 14),
                    Font = Library.Fonts.Body,
                    Text = sliderDesc,
                    TextColor3 = Library.Theme.TextMuted,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = padding
                })
            end
            
            local sliderBg = Create("Frame", {
                Name = "Track",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(0, 0, 1, -14),
                AnchorPoint = Vector2.new(0, 1),
                Size = UDim2.new(1, 0, 0, 6),
                Parent = padding
            })
            AddCorner(sliderBg, 3)
            
            local sliderFill = Create("Frame", {
                Name = "Fill",
                BackgroundColor3 = Library.Theme.Accent,
                Size = UDim2.new((currentValue - range[1]) / (range[2] - range[1]), 0, 1, 0),
                Parent = sliderBg
            })
            AddCorner(sliderFill, 3)
            
            -- Gradient on fill
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Library.Theme.AccentDark),
                    ColorSequenceKeypoint.new(1, Library.Theme.Accent)
                }),
                Parent = sliderFill
            })
            
            local sliderKnob = Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Library.Theme.Text,
                Position = UDim2.new((currentValue - range[1]) / (range[2] - range[1]), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0, 14, 0, 14),
                ZIndex = 2,
                Parent = sliderBg
            })
            AddCorner(sliderKnob, 7)
            AddStroke(sliderKnob, Library.Theme.Accent, 2)
            
            local knobGlow = AddGlow(sliderKnob, Library.Theme.Accent, 16)
            knobGlow.ImageTransparency = 0.85
            
            local function updateSlider(value, skipCallback)
                value = math.clamp(value, range[1], range[2])
                value = math.floor(value / increment + 0.5) * increment
                Slider.Value = value
                
                local percent = (value - range[1]) / (range[2] - range[1])
                Tween(sliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.08)
                Tween(sliderKnob, {Position = UDim2.new(percent, 0, 0.5, 0)}, 0.08)
                valueLabel.Text = tostring(value) .. suffix
                
                if not skipCallback then
                    callback(value)
                end
            end
            
            local dragging = false
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    Tween(sliderKnob, {Size = UDim2.new(0, 16, 0, 16)})
                    Tween(knobGlow, {ImageTransparency = 0.7})
                    local percent = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    updateSlider(range[1] + (range[2] - range[1]) * percent)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local percent = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    updateSlider(range[1] + (range[2] - range[1]) * percent)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    Tween(sliderKnob, {Size = UDim2.new(0, 14, 0, 14)})
                    Tween(knobGlow, {ImageTransparency = 0.85})
                end
            end)
            
            function Slider:Set(value)
                updateSlider(value)
            end
            
            table.insert(Tab.Elements, Slider)
            return Slider
        end
        
        -- Button
        function Tab:CreateButton(config)
            config = config or {}
            local buttonName = config.Name or "Button"
            local buttonDesc = config.Description
            local callback = config.Callback or function() end
            
            local Button = {Type = "Button"}
            
            local height = buttonDesc and 52 or 38
            
            local buttonFrame = Create("TextButton", {
                Name = "Button",
                BackgroundColor3 = Library.Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, height),
                Font = Library.Fonts.Body,
                Text = "",
                AutoButtonColor = false,
                Parent = contentFrame
            })
            AddCorner(buttonFrame, Library.Config.CornerRadius)
            AddGradientStroke(buttonFrame, Library.Theme.Accent, Library.Theme.AccentDark, 1)
            
            local padding = Create("Frame", {
                Name = "Padding",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = buttonFrame
            })
            AddPadding(padding, 0, 14, 0, 14)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, buttonDesc and 8 or 0),
                Size = UDim2.new(1, -24, 0, buttonDesc and 16 or height),
                Font = Library.Fonts.Subtitle,
                Text = buttonName,
                TextColor3 = Library.Theme.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = padding
            })
            
            if buttonDesc then
                Create("TextLabel", {
                    Name = "Desc",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 26),
                    Size = UDim2.new(1, -24, 0, 16),
                    Font = Library.Fonts.Body,
                    Text = buttonDesc,
                    TextColor3 = Library.Theme.TextMuted,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = padding
                })
            end
            
            Create("TextLabel", {
                Name = "Arrow",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0, 16, 0, 16),
                Font = Library.Fonts.Body,
                Text = "→",
                TextColor3 = Library.Theme.Accent,
                TextSize = 14,
                Parent = padding
            })
            
            local originalPos = buttonFrame.Position
            
            buttonFrame.MouseEnter:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Library.Theme.Elevated})
            end)
            
            buttonFrame.MouseLeave:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Library.Theme.Tertiary})
            end)
            
            buttonFrame.MouseButton1Click:Connect(function()
                -- Click animation
                Tween(buttonFrame, {BackgroundColor3 = Library.Theme.Accent}, 0.08)
                task.wait(0.08)
                Tween(buttonFrame, {BackgroundColor3 = Library.Theme.Tertiary}, 0.15)
                callback()
            end)
            
            table.insert(Tab.Elements, Button)
            return Button
        end
        
        -- Dropdown
        function Tab:CreateDropdown(config)
            config = config or {}
            local dropdownName = config.Name or "Dropdown"
            local options = config.Options or {}
            local currentOption = config.CurrentOption or (options[1] or "")
            local multiSelect = config.MultiSelect or false
            local callback = config.Callback or function() end
            
            local Dropdown = {
                Value = multiSelect and {} or currentOption,
                Options = options,
                Open = false,
                Type = "Dropdown"
            }
            
            if multiSelect and type(currentOption) == "table" then
                Dropdown.Value = currentOption
            elseif multiSelect then
                Dropdown.Value = {}
            end
            
            local dropdownFrame = Create("Frame", {
                Name = "Dropdown",
                BackgroundColor3 = Library.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true,
                Parent = contentFrame
            })
            AddCorner(dropdownFrame, Library.Config.CornerRadius)
            AddStroke(dropdownFrame, Library.Theme.Border, 1, 0.5)
            
            local header = Create("Frame", {
                Name = "Header",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = dropdownFrame
            })
            AddPadding(header, 0, 14, 0, 14)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0.4, 0, 0, 16),
                Font = Library.Fonts.Subtitle,
                Text = dropdownName,
                TextColor3 = Library.Theme.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = header
            })
            
            local selectedContainer = Create("TextButton", {
                Name = "Selected",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0.55, 0, 0, 28),
                Font = Library.Fonts.Body,
                Text = "",
                AutoButtonColor = false,
                Parent = header
            })
            AddCorner(selectedContainer, Library.Config.SmallCorner)
            
            local function getDisplayText()
                if multiSelect then
                    if #Dropdown.Value == 0 then
                        return "None"
                    elseif #Dropdown.Value <= 2 then
                        return table.concat(Dropdown.Value, ", ")
                    else
                        return #Dropdown.Value .. " selected"
                    end
                else
                    return Dropdown.Value or "Select..."
                end
            end
            
            local selectedLabel = Create("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Font = Library.Fonts.Mono,
                Text = getDisplayText(),
                TextColor3 = Library.Theme.TextSecondary,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = selectedContainer
            })
            
            local arrowLabel = Create("TextLabel", {
                Name = "Arrow",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -8, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0, 12, 0, 12),
                Font = Library.Fonts.Body,
                Text = "▼",
                TextColor3 = Library.Theme.TextMuted,
                TextSize = 8,
                Parent = selectedContainer
            })
            
            local optionsContainer = Create("Frame", {
                Name = "Options",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 44),
                Size = UDim2.new(1, -20, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = dropdownFrame
            })
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3),
                Parent = optionsContainer
            })
            
            local optionButtons = {}
            
            local function refreshOptions()
                for _, btn in pairs(optionButtons) do
                    btn:Destroy()
                end
                optionButtons = {}
                
                for i, option in ipairs(Dropdown.Options) do
                    local isSelected = false
                    if multiSelect then
                        isSelected = table.find(Dropdown.Value, option) ~= nil
                    else
                        isSelected = Dropdown.Value == option
                    end
                    
                    local optionBtn = Create("TextButton", {
                        Name = option,
                        BackgroundColor3 = isSelected and Library.Theme.Accent or Library.Theme.Tertiary,
                        BackgroundTransparency = isSelected and 0.7 or 0,
                        Size = UDim2.new(1, 0, 0, 28),
                        Font = Library.Fonts.Body,
                        Text = option,
                        TextColor3 = isSelected and Library.Theme.Accent or Library.Theme.TextSecondary,
                        TextSize = 10,
                        AutoButtonColor = false,
                        LayoutOrder = i,
                        Parent = optionsContainer
                    })
                    AddCorner(optionBtn, Library.Config.SmallCorner)
                    
                    if isSelected then
                        AddStroke(optionBtn, Library.Theme.Accent, 1, 0.5)
                    end
                    
                    optionBtn.MouseEnter:Connect(function()
                        if not isSelected then
                            Tween(optionBtn, {BackgroundColor3 = Library.Theme.Elevated})
                        end
                    end)
                    
                    optionBtn.MouseLeave:Connect(function()
                        if not isSelected then
                            Tween(optionBtn, {BackgroundColor3 = Library.Theme.Tertiary})
                        end
                    end)
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        if multiSelect then
                            local idx = table.find(Dropdown.Value, option)
                            if idx then
                                table.remove(Dropdown.Value, idx)
                            else
                                table.insert(Dropdown.Value, option)
                            end
                            refreshOptions()
                            selectedLabel.Text = getDisplayText()
                            callback(Dropdown.Value)
                        else
                            Dropdown.Value = option
                            selectedLabel.Text = option
                            Dropdown.Open = false
                            Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                            Tween(arrowLabel, {Rotation = 0})
                            callback(option)
                        end
                    end)
                    
                    table.insert(optionButtons, optionBtn)
                end
            end
            
            refreshOptions()
            
            selectedContainer.MouseButton1Click:Connect(function()
                Dropdown.Open = not Dropdown.Open
                if Dropdown.Open then
                    local totalHeight = 48 + (#Dropdown.Options * 31)
                    Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, math.min(totalHeight, 200))}, 0.2, Enum.EasingStyle.Back)
                    Tween(arrowLabel, {Rotation = 180})
                else
                    Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                    Tween(arrowLabel, {Rotation = 0})
                end
            end)
            
            function Dropdown:Set(value)
                if multiSelect then
                    Dropdown.Value = type(value) == "table" and value or {value}
                else
                    Dropdown.Value = value
                end
                selectedLabel.Text = getDisplayText()
                refreshOptions()
                callback(Dropdown.Value)
            end
            
            function Dropdown:Refresh(newOptions)
                Dropdown.Options = newOptions
                refreshOptions()
            end
            
            table.insert(Tab.Elements, Dropdown)
            return Dropdown
        end
        
        -- Input
        function Tab:CreateInput(config)
            config = config or {}
            local inputName = config.Name or "Input"
            local placeholder = config.PlaceholderText or "Enter value..."
            local numeric = config.NumbersOnly or false
            local callback = config.Callback or function() end
            
            local Input = {Value = "", Type = "Input"}
            
            local inputFrame = Create("Frame", {
                Name = "Input",
                BackgroundColor3 = Library.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = contentFrame
            })
            AddCorner(inputFrame, Library.Config.CornerRadius)
            AddStroke(inputFrame, Library.Theme.Border, 1, 0.5)
            
            local padding = Create("Frame", {
                Name = "Padding",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = inputFrame
            })
            AddPadding(padding, 0, 14, 0, 14)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0.35, 0, 0, 16),
                Font = Library.Fonts.Subtitle,
                Text = inputName,
                TextColor3 = Library.Theme.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = padding
            })
            
            local textBox = Create("TextBox", {
                Name = "Box",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0.6, 0, 0, 28),
                Font = Library.Fonts.Mono,
                PlaceholderText = placeholder,
                PlaceholderColor3 = Library.Theme.TextMuted,
                Text = "",
                TextColor3 = Library.Theme.Text,
                TextSize = 10,
                ClearTextOnFocus = false,
                Parent = padding
            })
            AddCorner(textBox, Library.Config.SmallCorner)
            AddPadding(textBox, 0, 10, 0, 10)
            
            local boxStroke = AddStroke(textBox, Library.Theme.Border, 1, 0.5)
            
            textBox.Focused:Connect(function()
                Tween(boxStroke, {Color = Library.Theme.Accent, Transparency = 0})
            end)
            
            textBox.FocusLost:Connect(function(enterPressed)
                Tween(boxStroke, {Color = Library.Theme.Border, Transparency = 0.5})
                local value = textBox.Text
                if numeric then
                    value = tonumber(value) or 0
                    textBox.Text = tostring(value)
                end
                Input.Value = value
                if enterPressed then
                    callback(value)
                end
            end)
            
            if numeric then
                textBox:GetPropertyChangedSignal("Text"):Connect(function()
                    textBox.Text = textBox.Text:gsub("[^%d%.%-]", "")
                end)
            end
            
            function Input:Set(value)
                textBox.Text = tostring(value)
                Input.Value = value
            end
            
            table.insert(Tab.Elements, Input)
            return Input
        end
        
        -- Keybind
        function Tab:CreateKeybind(config)
            config = config or {}
            local keybindName = config.Name or "Keybind"
            local currentKeybind = config.CurrentKeybind or "None"
            local callback = config.Callback or function() end
            
            local Keybind = {
                Value = currentKeybind,
                Listening = false,
                Type = "Keybind"
            }
            
            local keybindFrame = Create("Frame", {
                Name = "Keybind",
                BackgroundColor3 = Library.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = contentFrame
            })
            AddCorner(keybindFrame, Library.Config.CornerRadius)
            AddStroke(keybindFrame, Library.Theme.Border, 1, 0.5)
            
            local padding = Create("Frame", {
                Name = "Padding",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = keybindFrame
            })
            AddPadding(padding, 0, 14, 0, 14)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0.6, 0, 0, 16),
                Font = Library.Fonts.Subtitle,
                Text = keybindName,
                TextColor3 = Library.Theme.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = padding
            })
            
            local keyBtn = Create("TextButton", {
                Name = "Key",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0, 70, 0, 26),
                Font = Library.Fonts.Mono,
                Text = currentKeybind,
                TextColor3 = Library.Theme.Accent,
                TextSize = 10,
                AutoButtonColor = false,
                Parent = padding
            })
            AddCorner(keyBtn, Library.Config.SmallCorner)
            local keyStroke = AddStroke(keyBtn, Library.Theme.Accent, 1, 0.7)
            
            keyBtn.MouseButton1Click:Connect(function()
                Keybind.Listening = true
                keyBtn.Text = "..."
                Tween(keyBtn, {BackgroundColor3 = Library.Theme.Accent})
                Tween(keyStroke, {Transparency = 0})
                keyBtn.TextColor3 = Library.Theme.Background
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if Keybind.Listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind.Value = input.KeyCode.Name
                        keyBtn.Text = input.KeyCode.Name
                        Keybind.Listening = false
                        Tween(keyBtn, {BackgroundColor3 = Library.Theme.Tertiary})
                        Tween(keyStroke, {Transparency = 0.7})
                        keyBtn.TextColor3 = Library.Theme.Accent
                    end
                elseif not processed and input.KeyCode.Name == Keybind.Value then
                    callback(Keybind.Value)
                end
            end)
            
            function Keybind:Set(key)
                Keybind.Value = key
                keyBtn.Text = key
            end
            
            table.insert(Tab.Elements, Keybind)
            return Keybind
        end
        
        -- Color Picker
        function Tab:CreateColorPicker(config)
            config = config or {}
            local pickerName = config.Name or "Color"
            local currentColor = config.Color or Color3.fromRGB(88, 255, 156)
            local callback = config.Callback or function() end
            
            local ColorPicker = {
                Value = currentColor,
                Open = false,
                Type = "ColorPicker"
            }
            
            local pickerFrame = Create("Frame", {
                Name = "ColorPicker",
                BackgroundColor3 = Library.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true,
                Parent = contentFrame
            })
            AddCorner(pickerFrame, Library.Config.CornerRadius)
            AddStroke(pickerFrame, Library.Theme.Border, 1, 0.5)
            
            local header = Create("Frame", {
                Name = "Header",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = pickerFrame
            })
            AddPadding(header, 0, 14, 0, 14)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0.7, 0, 0, 16),
                Font = Library.Fonts.Subtitle,
                Text = pickerName,
                TextColor3 = Library.Theme.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = header
            })
            
            local previewBtn = Create("TextButton", {
                Name = "Preview",
                BackgroundColor3 = currentColor,
                Position = UDim2.new(1, 0, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0, 50, 0, 24),
                Text = "",
                AutoButtonColor = false,
                Parent = header
            })
            AddCorner(previewBtn, Library.Config.SmallCorner)
            AddStroke(previewBtn, Library.Theme.Border, 1, 0.3)
            
            -- Expanded content
            local expandedContent = Create("Frame", {
                Name = "Expanded",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 48),
                Size = UDim2.new(1, -28, 0, 100),
                Parent = pickerFrame
            })
            
            -- HSV Color wheel simulation using RGB sliders (simpler approach)
            local function createSlider(name, color, yOffset, value)
                local track = Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Library.Theme.Tertiary,
                    Position = UDim2.new(0, 22, 0, yOffset),
                    Size = UDim2.new(1, -70, 0, 8),
                    Parent = expandedContent
                })
                AddCorner(track, 4)
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, yOffset - 2),
                    Size = UDim2.new(0, 18, 0, 12),
                    Font = Library.Fonts.Mono,
                    Text = name,
                    TextColor3 = color,
                    TextSize = 10,
                    Parent = expandedContent
                })
                
                local fill = Create("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = color,
                    Size = UDim2.new(value / 255, 0, 1, 0),
                    Parent = track
                })
                AddCorner(fill, 4)
                
                local valueLabel = Create("TextLabel", {
                    Name = "Value",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 4, 0, yOffset - 2),
                    Size = UDim2.new(0, 40, 0, 12),
                    Font = Library.Fonts.Mono,
                    Text = tostring(math.floor(value)),
                    TextColor3 = Library.Theme.TextSecondary,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = expandedContent
                })
                
                return track, fill, valueLabel
            end
            
            local r, g, b = currentColor.R * 255, currentColor.G * 255, currentColor.B * 255
            local rTrack, rFill, rValue = createSlider("R", Color3.fromRGB(255, 100, 100), 10, r)
            local gTrack, gFill, gValue = createSlider("G", Color3.fromRGB(100, 255, 100), 35, g)
            local bTrack, bFill, bValue = createSlider("B", Color3.fromRGB(100, 150, 255), 60, b)
            
            -- Hex input
            local hexInput = Create("TextBox", {
                Name = "Hex",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(0, 0, 0, 80),
                Size = UDim2.new(1, 0, 0, 24),
                Font = Library.Fonts.Mono,
                PlaceholderText = "#FFFFFF",
                Text = string.format("#%02X%02X%02X", r, g, b),
                TextColor3 = Library.Theme.Text,
                TextSize = 10,
                Parent = expandedContent
            })
            AddCorner(hexInput, Library.Config.SmallCorner)
            AddPadding(hexInput, 0, 10, 0, 10)
            
            local function updateColor()
                local r = ColorPicker.Value.R * 255
                local g = ColorPicker.Value.G * 255
                local b = ColorPicker.Value.B * 255
                
                previewBtn.BackgroundColor3 = ColorPicker.Value
                rFill.Size = UDim2.new(r / 255, 0, 1, 0)
                gFill.Size = UDim2.new(g / 255, 0, 1, 0)
                bFill.Size = UDim2.new(b / 255, 0, 1, 0)
                rValue.Text = tostring(math.floor(r))
                gValue.Text = tostring(math.floor(g))
                bValue.Text = tostring(math.floor(b))
                hexInput.Text = string.format("#%02X%02X%02X", math.floor(r), math.floor(g), math.floor(b))
                
                callback(ColorPicker.Value)
            end
            
            local function setupSliderDrag(track, fill, valueLabel, component)
                local dragging = false
                
                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                        local val = math.floor(percent * 255)
                        
                        local r = ColorPicker.Value.R * 255
                        local g = ColorPicker.Value.G * 255
                        local b = ColorPicker.Value.B * 255
                        
                        if component == "R" then r = val
                        elseif component == "G" then g = val
                        else b = val end
                        
                        ColorPicker.Value = Color3.fromRGB(r, g, b)
                        updateColor()
                    end
                end)
            end
            
            setupSliderDrag(rTrack, rFill, rValue, "R")
            setupSliderDrag(gTrack, gFill, gValue, "G")
            setupSliderDrag(bTrack, bFill, bValue, "B")
            
            hexInput.FocusLost:Connect(function()
                local hex = hexInput.Text:gsub("#", "")
                if #hex == 6 then
                    local r = tonumber(hex:sub(1, 2), 16) or 255
                    local g = tonumber(hex:sub(3, 4), 16) or 255
                    local b = tonumber(hex:sub(5, 6), 16) or 255
                    ColorPicker.Value = Color3.fromRGB(r, g, b)
                    updateColor()
                end
            end)
            
            previewBtn.MouseButton1Click:Connect(function()
                ColorPicker.Open = not ColorPicker.Open
                if ColorPicker.Open then
                    Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 160)}, 0.2, Enum.EasingStyle.Back)
                else
                    Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                end
            end)
            
            function ColorPicker:Set(color)
                ColorPicker.Value = color
                updateColor()
            end
            
            table.insert(Tab.Elements, ColorPicker)
            return ColorPicker
        end
        
        -- Label
        function Tab:CreateLabel(config)
            config = config or {}
            local labelText = config.Name or "Label"
            
            local Label = {Type = "Label"}
            
            local labelFrame = Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 24),
                Font = Library.Fonts.Body,
                Text = labelText,
                TextColor3 = Library.Theme.TextMuted,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = contentFrame
            })
            
            function Label:Set(text)
                labelFrame.Text = text
            end
            
            table.insert(Tab.Elements, Label)
            return Label
        end
        
        -- Paragraph
        function Tab:CreateParagraph(config)
            config = config or {}
            local title = config.Title or "Title"
            local content = config.Content or "Content"
            
            local Paragraph = {Type = "Paragraph"}
            
            local paragraphFrame = Create("Frame", {
                Name = "Paragraph",
                BackgroundColor3 = Library.Theme.Secondary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = contentFrame
            })
            AddCorner(paragraphFrame, Library.Config.CornerRadius)
            AddStroke(paragraphFrame, Library.Theme.Border, 1, 0.5)
            AddPadding(paragraphFrame, 12, 14, 12, 14)
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = paragraphFrame
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                Font = Library.Fonts.Subtitle,
                Text = title,
                TextColor3 = Library.Theme.Accent,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 1,
                Parent = paragraphFrame
            })
            
            local contentLabel = Create("TextLabel", {
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Font = Library.Fonts.Body,
                Text = content,
                TextColor3 = Library.Theme.TextSecondary,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                LayoutOrder = 2,
                Parent = paragraphFrame
            })
            
            function Paragraph:Set(newTitle, newContent)
                titleLabel.Text = newTitle or title
                contentLabel.Text = newContent or content
            end
            
            table.insert(Tab.Elements, Paragraph)
            return Paragraph
        end
        
        return Tab
    end
    
    -- Startup notification
    task.spawn(function()
        task.wait(0.5)
        Library:Notify({
            Title = "Stellar Hub",
            Content = "Welcome! Press RightCtrl to toggle UI",
            Type = "Success",
            Time = 4
        })
    end)
    
    return Window
end

return Library
