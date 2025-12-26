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

-- ═══════════════════════════════════════════════════════════════
-- REFINED THEME (Better contrast)
-- ═══════════════════════════════════════════════════════════════
local Theme = {
    -- FIX: Better background contrast
    Primary = Color3.fromRGB(15, 15, 22),
    Secondary = Color3.fromRGB(25, 25, 35),
    Tertiary = Color3.fromRGB(35, 35, 48),
    Hover = Color3.fromRGB(45, 45, 60),
    
    Accent = Color3.fromRGB(100, 200, 255),
    AccentDark = Color3.fromRGB(70, 160, 220),
    AccentGlow = Color3.fromRGB(130, 220, 255),
    
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(175, 175, 185),
    TextMuted = Color3.fromRGB(110, 110, 125),
    
    Success = Color3.fromRGB(85, 255, 127),
    Warning = Color3.fromRGB(255, 195, 85),
    Error = Color3.fromRGB(255, 85, 95),
    
    Online = Color3.fromRGB(85, 255, 127),
    -- FIX: Subtle border color
    Border = Color3.fromRGB(55, 55, 75)
}

Library.Theme = Theme

-- ═══════════════════════════════════════════════════════════════
-- ANIMATION CONSTANTS (Refined timing)
-- ═══════════════════════════════════════════════════════════════
local Anim = {
    -- FIX: Proper animation durations
    WindowOpen = 0.5,
    WindowClose = 0.3,
    ElementHover = 0.15,
    ElementClick = 0.1,
    SizeChange = 0.3,
    ColorChange = 0.2,
    SliderDrag = 0.08
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
-- UTILITY FUNCTIONS
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

-- FIX: Refined Tween function with proper easing
local function Tween(obj, props, duration, style, direction)
    duration = math.max(duration or Anim.ColorChange, 0.1)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

local function Corner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

-- FIX: Subtle stroke with proper transparency
local function Stroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0.3, -- FIX: Default 0.3 transparency
        Parent = parent
    })
end

-- FIX: Consistent 12px padding
local function Padding(parent, t, b, l, r)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 12),
        PaddingBottom = UDim.new(0, b or t or 12),
        PaddingLeft = UDim.new(0, l or t or 12),
        PaddingRight = UDim.new(0, r or l or t or 12),
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

local function Ripple(button, x, y)
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.9, -- FIX: More subtle ripple
        Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = button
    })
    Corner(ripple, 100)
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.4)
    
    task.delay(0.4, function()
        if ripple and ripple.Parent then
            ripple:Destroy()
        end
    end)
end

-- FIX: Reduced shadow intensity (0.6 transparency, 30% smaller)
local function CreateShadow(parent, offset, size)
    local adjustedSize = (size or 35) * 0.7 -- FIX: 30% smaller shadows
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, offset or 3),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, adjustedSize, 1, adjustedSize),
        ZIndex = -1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6, -- FIX: Reduced from 0.4 to 0.6
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = parent
    })
    return shadow
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
-- NOTIFICATION SYSTEM
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
            Position = UDim2.new(1, -20, 1, -20),
            Size = UDim2.new(0, 320, 1, -40),
            Parent = gui
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 10),
            Parent = gui.Container
        })
    end
    
    local notif = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Theme.Secondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 80),
        ClipsDescendants = true,
        Parent = gui.Container
    })
    Corner(notif, 10) -- FIX: Consistent corner radius
    
    local stroke = Stroke(notif, Theme.Accent, 1, 0.5) -- FIX: Subtle stroke
    CreateShadow(notif, 2, 15)
    
    if icon then
        local iconFrame = Create("Frame", {
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 0.92, -- FIX: More subtle background
            Position = UDim2.new(0, 14, 0, 14),
            Size = UDim2.new(0, 40, 0, 40),
            Parent = notif
        })
        Corner(iconFrame, 10)
        
        Create("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 20, 0, 20),
            Image = GetIcon(icon),
            ImageColor3 = Theme.Accent,
            Parent = iconFrame
        })
    end
    
    local closeBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -32, 0, 8),
        Size = UDim2.new(0, 24, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Theme.TextMuted,
        TextSize = 18,
        Parent = notif
    })
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {TextColor3 = Theme.Error}, Anim.ElementHover)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {TextColor3 = Theme.TextMuted}, Anim.ElementHover)
    end)
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, icon and 64 or 16, 0, 14),
        Size = UDim2.new(1, icon and -100 or -52, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, icon and 64 or 16, 0, 36),
        Size = UDim2.new(1, icon and -80 or -32, 0, 28),
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = Theme.TextDark,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = notif
    })
    
    local progressBg = Create("Frame", {
        BackgroundColor3 = Theme.Primary,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3),
        Parent = notif
    })
    
    local progress = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = progressBg
    })
    Corner(progress, 2)
    
    -- FIX: Smooth Back EaseOut animation
    notif.Position = UDim2.new(1, 50, 0, 0)
    Tween(notif, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}, Anim.WindowOpen, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Tween(stroke, {Transparency = 0.3}, Anim.SizeChange)
    Tween(progress, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    local function closeNotif()
        -- FIX: Proper close animation
        Tween(notif, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, Anim.WindowClose, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
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
-- MAIN WINDOW CREATION
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
        Size = UDim2.new(0, 780, 0, 480),
        Parent = gui
    })
    
    -- FIX: Reduced shadow
    CreateShadow(mainContainer, 6, 45)
    
    local main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Theme.Primary,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
        Parent = mainContainer
    })
    Corner(main, 12)
    Stroke(main, Theme.Border, 1, 0.3) -- FIX: Subtle stroke
    
    Window.Main = main
    Window.Container = mainContainer
    
    -- ═══════════════════════════════════════════════════════════
    -- TOP BAR
    -- ═══════════════════════════════════════════════════════════
    local topBar = Create("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 48),
        Parent = main
    })
    Corner(topBar, 12)
    
    Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        Parent = topBar
    })
    
    -- FIX: Subtle accent line
    Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundTransparency = 0.8, -- FIX: More subtle
        BorderSizePixel = 0,
        Parent = topBar
    })
    
    -- Title (no glow effect - FIX: removed for performance)
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 250, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = "✦ " .. windowName,
        TextColor3 = Theme.Accent,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    -- Close Button
    local closeBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Error,
        BackgroundTransparency = 0.88, -- FIX: More subtle
        Position = UDim2.new(1, -44, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 32, 0, 32),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Theme.Error,
        TextSize = 20,
        AutoButtonColor = false,
        Parent = topBar
    })
    Corner(closeBtn, 8)
    
    Window.Connections:Connect(closeBtn.MouseEnter, function()
        -- FIX: Faster, subtler hover
        Tween(closeBtn, {BackgroundTransparency = 0.6}, Anim.ElementHover)
    end)
    Window.Connections:Connect(closeBtn.MouseLeave, function()
        Tween(closeBtn, {BackgroundTransparency = 0.88}, Anim.ElementHover)
    end)
    Window.Connections:Connect(closeBtn.MouseButton1Click, function()
        Window:Destroy()
    end)
    
    -- Minimize Button
    local minBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Warning,
        BackgroundTransparency = 0.88,
        Position = UDim2.new(1, -82, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 32, 0, 32),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Theme.Warning,
        TextSize = 22,
        AutoButtonColor = false,
        Parent = topBar
    })
    Corner(minBtn, 8)
    
    Window.Connections:Connect(minBtn.MouseEnter, function()
        Tween(minBtn, {BackgroundTransparency = 0.6}, Anim.ElementHover)
    end)
    Window.Connections:Connect(minBtn.MouseLeave, function()
        Tween(minBtn, {BackgroundTransparency = 0.88}, Anim.ElementHover)
    end)
    Window.Connections:Connect(minBtn.MouseButton1Click, function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            -- FIX: Proper animation timing
            Tween(mainContainer, {Size = UDim2.new(0, 780, 0, 48)}, Anim.SizeChange, Enum.EasingStyle.Quint)
            minBtn.Text = "+"
        else
            Tween(mainContainer, {Size = UDim2.new(0, 780, 0, 480)}, Anim.SizeChange, Enum.EasingStyle.Quint)
            minBtn.Text = "−"
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════
    -- SIDEBAR
    -- ═══════════════════════════════════════════════════════════
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.Secondary,
        Position = UDim2.new(0, 0, 0, 48),
        Size = UDim2.new(0, 220, 1, -48),
        Parent = main
    })
    Corner(sidebar, 12)
    
    Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 12), BorderSizePixel = 0, Parent = sidebar})
    Create("Frame", {BackgroundColor3 = Theme.Secondary, Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0, 12, 1, 0), BorderSizePixel = 0, Parent = sidebar})
    
    -- FIX: Subtle separator
    Create("Frame", {
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.3,
        Position = UDim2.new(1, -1, 0, 10),
        Size = UDim2.new(0, 1, 1, -20),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    -- Tab Header
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 14),
        Size = UDim2.new(1, -32, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = "NAVIGATION",
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sidebar
    })
    
    -- Tab Container
    local tabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 42),
        Size = UDim2.new(1, -20, 1, -195),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.6,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6), -- FIX: Consistent spacing
        Parent = tabContainer
    })
    
    -- ═══════════════════════════════════════════════════════════
    -- PROFILE SECTION (Fixed spacing and centering)
    -- ═══════════════════════════════════════════════════════════
    local profileSection = Create("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        Position = UDim2.new(0, 10, 1, -143),
        Size = UDim2.new(1, -20, 0, 133),
        Parent = sidebar
    })
    Corner(profileSection, 10)
    Stroke(profileSection, Theme.Border, 1, 0.3)
    
    -- FIX: 8px margin around elements
    Padding(profileSection, 8, 8, 8, 8)
    
    -- FIX: Better centered avatar
    local profileAvatarBg = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0.5, 0, 0, 8),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0, 54, 0, 54),
        Parent = profileSection
    })
    Corner(profileAvatarBg, 27)
    
    local profileAvatar = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 50, 0, 50),
        Image = GetAvatar(),
        Parent = profileAvatarBg
    })
    Corner(profileAvatar, 25)
    
    -- Online Indicator
    local onlineIndicator = Create("Frame", {
        BackgroundColor3 = Theme.Online,
        Position = UDim2.new(1, -3, 1, -3),
        AnchorPoint = Vector2.new(1, 1),
        Size = UDim2.new(0, 14, 0, 14),
        Parent = profileAvatarBg
    })
    Corner(onlineIndicator, 7)
    Stroke(onlineIndicator, Theme.Tertiary, 2, 0)
    
    -- Display Name (centered)
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 68),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(1, -16, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = Player.DisplayName,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = profileSection
    })
    
    -- Username
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 86),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(1, -16, 0, 14),
        Font = Enum.Font.Gotham,
        Text = "@" .. Player.Name,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = profileSection
    })
    
    -- Key Badge
    local keyBadge = Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Position = UDim2.new(0.5, 0, 0, 106),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0, 100, 0, 22),
        Parent = profileSection
    })
    Corner(keyBadge, 11)
    Stroke(keyBadge, Theme.Accent, 1, 0.5)
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "⏱ " .. keyTime,
        TextColor3 = Theme.Accent,
        TextSize = 10,
        Parent = keyBadge
    })
    
    -- ═══════════════════════════════════════════════════════════
    -- CONTENT AREA
    -- ═══════════════════════════════════════════════════════════
    local contentArea = Create("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 220, 0, 48),
        Size = UDim2.new(1, -220, 1, -48),
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
            }, 0.06)
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
                -- FIX: Smooth Back EaseOut for opening
                Tween(mainContainer, {Size = UDim2.new(0, 780, 0, Window.Minimized and 48 or 480)}, Anim.WindowOpen, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            else
                -- FIX: Quint EaseIn for closing
                Tween(mainContainer, {Size = UDim2.new(0, 0, 0, 0)}, Anim.WindowClose, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                task.delay(Anim.WindowClose, function()
                    if not Window.Open then
                        gui.Enabled = false
                    end
                end)
            end
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════
    -- MOBILE TOGGLE BUTTON
    -- ═══════════════════════════════════════════════════════════
    local mobileBtn = Create("TextButton", {
        Name = "MobileToggle",
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(1, -70, 1, -70),
        Size = UDim2.new(0, 55, 0, 55),
        Font = Enum.Font.GothamBold,
        Text = "✦",
        TextColor3 = Theme.Primary,
        TextSize = 24,
        AutoButtonColor = false,
        Parent = gui
    })
    Corner(mobileBtn, 28)
    CreateShadow(mobileBtn, 3, 12)
    -- FIX: Glow only on hover, not always visible
    local mobileBtnStroke = Stroke(mobileBtn, Theme.AccentGlow, 2, 0.8)
    
    local mobileDragging, mobileDragStart, mobileStartPos
    local dragThreshold = 10
    local wasDragged = false
    
    -- FIX: Hover glow effect
    Window.Connections:Connect(mobileBtn.MouseEnter, function()
        Tween(mobileBtnStroke, {Transparency = 0.3}, Anim.ElementHover)
    end)
    Window.Connections:Connect(mobileBtn.MouseLeave, function()
        Tween(mobileBtnStroke, {Transparency = 0.8}, Anim.ElementHover)
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
                Tween(mobileBtn, {Rotation = Window.Open and 45 or 0}, Anim.SizeChange)
            end
            mobileDragging = false
        end
    end)
    
    Window.Connections:Connect(mobileBtn.MouseButton1Click, function()
        if not wasDragged then
            Window.Open = not Window.Open
            main.Visible = Window.Open
            Tween(mobileBtn, {Rotation = Window.Open and 45 or 0}, Anim.SizeChange)
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
        
        -- FIX: Proper close animation
        Tween(mainContainer, {Size = UDim2.new(0, 0, 0, 0)}, Anim.WindowClose, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
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
        
        -- Tab Button
        local tabBtn = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Theme.Tertiary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 44), -- FIX: Slightly larger touch target
            Text = "",
            AutoButtonColor = false,
            Parent = tabContainer
        })
        Corner(tabBtn, 8)
        
        local indicator = Create("Frame", {
            BackgroundColor3 = Theme.Accent,
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 0, 0, 28),
            Parent = tabBtn
        })
        Corner(indicator, 4)
        
        if tabIcon then
            Create("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 18, 0, 18),
                Image = GetIcon(tabIcon),
                ImageColor3 = Theme.TextMuted,
                Parent = tabBtn
            })
        end
        
        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, tabIcon and 40 or 14, 0, 0),
            Size = UDim2.new(1, tabIcon and -50 or -24, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = tabName,
            TextColor3 = Theme.TextMuted,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })
        
        Tab.Button = tabBtn
        
        -- Content Page
        local page = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 15),
            Size = UDim2.new(1, -30, 1, -30),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.4,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = contentArea
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
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
                    Tween(ind, {Size = UDim2.new(0, 0, 0, 28)}, Anim.ColorChange)
                end
                tab.Page.Visible = false
            end
            
            Tween(tabBtn, {BackgroundTransparency = 0}, Anim.ColorChange)
            Tween(tabBtn.Label, {TextColor3 = Theme.Text}, Anim.ColorChange)
            if tabBtn:FindFirstChild("Icon") then
                Tween(tabBtn.Icon, {ImageColor3 = Theme.Accent}, Anim.ColorChange)
            end
            Tween(indicator, {Size = UDim2.new(0, 4, 0, 28)}, Anim.SizeChange, Enum.EasingStyle.Back)
            page.Visible = true
            Window.ActiveTab = Tab
        end
        
        Tab.Connections:Connect(tabBtn.MouseButton1Click, function()
            Ripple(tabBtn, Mouse.X, Mouse.Y)
            selectTab()
        end)
        
        Tab.Connections:Connect(tabBtn.MouseEnter, function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 0.6}, Anim.ElementHover)
            end
        end)
        
        Tab.Connections:Connect(tabBtn.MouseLeave, function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 1}, Anim.ElementHover)
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
        -- SECTION
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateSection(config)
            config = config or {}
            
            local section = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 34),
                Parent = page
            })
            
            Create("Frame", {
                BackgroundColor3 = Theme.Border,
                BackgroundTransparency = 0.4,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0, 1),
                Parent = section
            })
            
            local labelBg = Create("Frame", {
                BackgroundColor3 = Theme.Primary,
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 0, 0, 24),
                AutomaticSize = Enum.AutomaticSize.X,
                Parent = section
            })
            
            Padding(labelBg, 0, 0, 0, 10)
            
            Create("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = GetIcon(config.Icon or "star"),
                ImageColor3 = Theme.Accent,
                Parent = labelBg
            })
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 20, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Font = Enum.Font.GothamBold,
                Text = config.Name or "Section",
                TextColor3 = Theme.Accent,
                TextSize = 11,
                Parent = labelBg
            })
            
            local element = CreateElementBase(section)
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- TOGGLE (Fixed: 26px switch height)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateToggle(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, config.Description and 60 or 48),
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1, 0.3)
            
            local element = CreateElementBase(container)
            element.Value = config.CurrentValue or false
            
            -- FIX: Consistent 12px padding
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, config.Description and 12 or 0),
                Size = UDim2.new(1, -80, 0, config.Description and 20 or 48),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Toggle",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            if config.Description then
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 34),
                    Size = UDim2.new(1, -80, 0, 18),
                    Font = Enum.Font.Gotham,
                    Text = config.Description,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
            end
            
            -- FIX: 26px switch height
            local switch = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(1, -58, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 46, 0, 26),
                Parent = container
            })
            Corner(switch, 13)
            
            local circle = Create("Frame", {
                BackgroundColor3 = Theme.TextMuted,
                Position = UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 20, 0, 20),
                Parent = switch
            })
            Corner(circle, 10)
            
            local function update()
                if element.Value then
                    Tween(switch, {BackgroundColor3 = Theme.Accent}, Anim.SizeChange)
                    Tween(circle, {
                        Position = UDim2.new(1, -23, 0.5, 0),
                        BackgroundColor3 = Theme.Primary
                    }, Anim.SizeChange, Enum.EasingStyle.Back)
                else
                    Tween(switch, {BackgroundColor3 = Theme.Tertiary}, Anim.SizeChange)
                    Tween(circle, {
                        Position = UDim2.new(0, 3, 0.5, 0),
                        BackgroundColor3 = Theme.TextMuted
                    }, Anim.SizeChange)
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
                Tween(container, {BackgroundColor3 = Theme.Hover}, Anim.ElementHover)
            end)
            element.Connections:Connect(container.MouseLeave, function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, Anim.ElementHover)
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
        -- SLIDER (Fixed: 10px track, 20px knob)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateSlider(config)
            config = config or {}
            local range = config.Range or {0, 100}
            local increment = config.Increment or 1
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 62),
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1, 0.3)
            
            local element = CreateElementBase(container)
            element.Value = config.CurrentValue or range[1]
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 12),
                Size = UDim2.new(0.6, 0, 0, 18),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Slider",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local valueLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -12, 0, 12),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0.3, 0, 0, 18),
                Font = Enum.Font.GothamBold,
                Text = tostring(element.Value),
                TextColor3 = Theme.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = container
            })
            
            -- FIX: 10px track height
            local track = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(0, 12, 0, 40),
                Size = UDim2.new(1, -24, 0, 10),
                Parent = container
            })
            Corner(track, 5)
            
            local fill = Create("Frame", {
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((element.Value - range[1]) / (range[2] - range[1]), 0, 1, 0),
                Parent = track
            })
            Corner(fill, 5)
            
            -- FIX: 20px knob
            local knob = Create("Frame", {
                BackgroundColor3 = Theme.Text,
                Position = UDim2.new((element.Value - range[1]) / (range[2] - range[1]), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0, 20, 0, 20),
                Parent = track
            })
            Corner(knob, 10)
            Stroke(knob, Theme.Accent, 3, 0)
            
            local function setValue(value)
                value = math.clamp(value, range[1], range[2])
                value = math.floor(value / increment + 0.5) * increment
                element.Value = value
                
                local percent = (value - range[1]) / (range[2] - range[1])
                Tween(fill, {Size = UDim2.new(percent, 0, 1, 0)}, Anim.SliderDrag)
                Tween(knob, {Position = UDim2.new(percent, 0, 0.5, 0)}, Anim.SliderDrag)
                valueLabel.Text = tostring(value)
                SafeCallback(callback, value)
            end
            
            local dragging = false
            
            element.Connections:Connect(track.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    setValue(range[1] + (range[2] - range[1]) * percent)
                end
            end)
            
            element.Connections:Connect(UserInputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            element.Connections:Connect(UserInputService.InputChanged, function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    setValue(range[1] + (range[2] - range[1]) * percent)
                end
            end)
            
            element.Connections:Connect(container.MouseEnter, function()
                Tween(container, {BackgroundColor3 = Theme.Hover}, Anim.ElementHover)
            end)
            element.Connections:Connect(container.MouseLeave, function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, Anim.ElementHover)
            end)
            
            function element:Set(value)
                setValue(value)
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- BUTTON (Fixed: 4px padding, 10 corner radius)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateButton(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            -- FIX: 4px internal padding via frame
            local container = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 48),
                Parent = page
            })
            
            local btn = Create("TextButton", {
                BackgroundColor3 = Theme.Accent,
                Position = UDim2.new(0, 0, 0, 2),
                Size = UDim2.new(1, 0, 1, -4),
                Font = Enum.Font.GothamBold,
                Text = config.Name or "Button",
                TextColor3 = Theme.Primary,
                TextSize = 14,
                AutoButtonColor = false,
                Parent = container
            })
            Corner(btn, 10) -- FIX: 10 corner radius
            
            local element = CreateElementBase(container)
            
            element.Connections:Connect(btn.MouseEnter, function()
                Tween(btn, {BackgroundColor3 = Theme.AccentDark}, Anim.ElementHover)
            end)
            
            element.Connections:Connect(btn.MouseLeave, function()
                Tween(btn, {BackgroundColor3 = Theme.Accent}, Anim.ElementHover)
            end)
            
            element.Connections:Connect(btn.MouseButton1Click, function()
                Ripple(btn, Mouse.X, Mouse.Y)
                Tween(btn, {Size = UDim2.new(1, -4, 1, -8)}, Anim.ElementClick)
                task.wait(Anim.ElementClick)
                Tween(btn, {Size = UDim2.new(1, 0, 1, -4)}, Anim.ColorChange, Enum.EasingStyle.Back)
                SafeCallback(callback)
            end)
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- DROPDOWN (Fixed: 2px gap, 36px option height)
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateDropdown(config)
            config = config or {}
            local options = config.Options or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 48),
                ClipsDescendants = true,
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1, 0.3)
            
            local element = CreateElementBase(container)
            element.Value = config.CurrentOption or options[1] or ""
            element.Open = false
            element.Options = options
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.4, 0, 0, 48),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Dropdown",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local selected = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(0.4, 0, 0, 9),
                Size = UDim2.new(0.6, -12, 0, 30),
                Font = Enum.Font.GothamMedium,
                Text = element.Value .. "  ▼",
                TextColor3 = Theme.Text,
                TextSize = 12,
                AutoButtonColor = false,
                Parent = container
            })
            Corner(selected, 8)
            
            -- FIX: Options with 2px gap, 36px height
            local optContainer = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 54),
                Size = UDim2.new(1, -24, 0, #options * 38), -- 36px + 2px gap
                Parent = container
            })
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2), -- FIX: 2px gap between options
                Parent = optContainer
            })
            
            local function createOptions()
                for _, child in pairs(optContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                for i, opt in ipairs(element.Options) do
                    -- FIX: 36px option height
                    local optBtn = Create("TextButton", {
                        BackgroundColor3 = Theme.Tertiary,
                        Size = UDim2.new(1, 0, 0, 36),
                        Font = Enum.Font.Gotham,
                        Text = opt,
                        TextColor3 = Theme.TextDark,
                        TextSize = 12,
                        AutoButtonColor = false,
                        Parent = optContainer
                    })
                    Corner(optBtn, 8)
                    
                    element.Connections:Connect(optBtn.MouseEnter, function()
                        Tween(optBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Primary}, Anim.ElementHover)
                    end)
                    
                    element.Connections:Connect(optBtn.MouseLeave, function()
                        Tween(optBtn, {BackgroundColor3 = Theme.Tertiary, TextColor3 = Theme.TextDark}, Anim.ElementHover)
                    end)
                    
                    element.Connections:Connect(optBtn.MouseButton1Click, function()
                        element.Value = opt
                        selected.Text = opt .. "  ▼"
                        element.Open = false
                        Library.OpenDropdowns[element] = nil
                        Tween(container, {Size = UDim2.new(1, 0, 0, 48)}, Anim.SizeChange, Enum.EasingStyle.Quint)
                        SafeCallback(callback, opt)
                    end)
                end
            end
            
            createOptions()
            
            local function closeDropdown()
                element.Open = false
                selected.Text = element.Value .. "  ▼"
                Tween(container, {Size = UDim2.new(1, 0, 0, 48)}, Anim.SizeChange, Enum.EasingStyle.Quint)
                Library.OpenDropdowns[element] = nil
            end
            
            element.Connections:Connect(selected.MouseButton1Click, function()
                element.Open = not element.Open
                -- FIX: Proper height calculation with 38px per option
                local targetSize = element.Open and (58 + #element.Options * 38) or 48
                Tween(container, {Size = UDim2.new(1, 0, 0, targetSize)}, Anim.SizeChange, Enum.EasingStyle.Quint)
                selected.Text = element.Value .. (element.Open and "  ▲" or "  ▼")
                
                if element.Open then
                    Library.OpenDropdowns[element] = {
                        Container = container,
                        Open = true,
                        Close = closeDropdown
                    }
                else
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
                optContainer.Size = UDim2.new(1, -24, 0, #newOptions * 38)
                createOptions()
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- INPUT
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateInput(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 48),
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1, 0.3)
            
            local element = CreateElementBase(container)
            element.Value = ""
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.35, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Input",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local box = Create("TextBox", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(0.35, 0, 0, 9),
                Size = UDim2.new(0.65, -12, 0, 30),
                Font = Enum.Font.Gotham,
                PlaceholderText = config.PlaceholderText or "Enter text...",
                PlaceholderColor3 = Theme.TextMuted,
                Text = "",
                TextColor3 = Theme.Text,
                TextSize = 12,
                ClearTextOnFocus = false,
                Parent = container
            })
            Corner(box, 8)
            
            local boxStroke = Stroke(box, Theme.Border, 1, 0.3)
            
            element.Connections:Connect(box.Focused, function()
                Tween(boxStroke, {Color = Theme.Accent, Transparency = 0}, Anim.ColorChange)
            end)
            
            element.Connections:Connect(box.FocusLost, function(enterPressed)
                Tween(boxStroke, {Color = Theme.Border, Transparency = 0.3}, Anim.ColorChange)
                element.Value = box.Text
                if enterPressed then
                    SafeCallback(callback, box.Text)
                end
            end)
            
            element.Connections:Connect(container.MouseEnter, function()
                Tween(container, {BackgroundColor3 = Theme.Hover}, Anim.ElementHover)
            end)
            element.Connections:Connect(container.MouseLeave, function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, Anim.ElementHover)
            end)
            
            function element:Set(text)
                box.Text = text
                element.Value = text
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- KEYBIND
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateKeybind(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 48),
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1, 0.3)
            
            local element = CreateElementBase(container)
            element.Value = config.CurrentKeybind or "None"
            element.Listening = false
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Keybind",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local keyBtn = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(1, -88, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 76, 0, 30),
                Font = Enum.Font.GothamBold,
                Text = element.Value,
                TextColor3 = Theme.Accent,
                TextSize = 12,
                AutoButtonColor = false,
                Parent = container
            })
            Corner(keyBtn, 8)
            local keyStroke = Stroke(keyBtn, Theme.Accent, 1, 0.5)
            
            element.Connections:Connect(keyBtn.MouseButton1Click, function()
                element.Listening = true
                keyBtn.Text = "..."
                Tween(keyBtn, {BackgroundColor3 = Theme.Accent}, Anim.ColorChange)
                keyBtn.TextColor3 = Theme.Primary
            end)
            
            element.Connections:Connect(UserInputService.InputBegan, function(input, gameProcessed)
                if element.Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    element.Value = input.KeyCode.Name
                    keyBtn.Text = input.KeyCode.Name
                                    element.Connections:Connect(UserInputService.InputBegan, function(input, gameProcessed)
                if element.Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    element.Value = input.KeyCode.Name
                    keyBtn.Text = input.KeyCode.Name
                    element.Listening = false
                    Tween(keyBtn, {BackgroundColor3 = Theme.Tertiary}, Anim.ColorChange)
                    keyBtn.TextColor3 = Theme.Accent
                    
                    -- Visual feedback for successful keybind
                    Tween(keyStroke, {Color = Theme.Success, Transparency = 0}, Anim.ColorChange)
                    task.delay(0.5, function()
                        Tween(keyStroke, {Color = Theme.Accent, Transparency = 0.5}, Anim.SizeChange)
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
                Tween(container, {BackgroundColor3 = Theme.Hover}, Anim.ElementHover)
            end)
            element.Connections:Connect(container.MouseLeave, function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, Anim.ElementHover)
            end)
            
            function element:Set(key)
                element.Value = key
                keyBtn.Text = key
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- LABEL
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateLabel(config)
            config = config or {}
            
            local label = Create("TextLabel", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 38),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Label",
                TextColor3 = Theme.TextDark,
                TextSize = 13,
                Parent = page
            })
            Corner(label, 8)
            Stroke(label, Theme.Border, 1, 0.3)
            
            local element = CreateElementBase(label)
            
            function element:Set(text)
                label.Text = text
            end
            
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- ═══════════════════════════════════════════════════════
        -- PARAGRAPH
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateParagraph(config)
            config = config or {}
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1, 0.3)
            Padding(container, 12, 12, 12, 12)
            
            local element = CreateElementBase(container)
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = container
            })
            
            local titleLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = config.Title or "Title",
                TextColor3 = Theme.Accent,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 1,
                Parent = container
            })
            
            local contentLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Font = Enum.Font.Gotham,
                Text = config.Content or "",
                TextColor3 = Theme.TextDark,
                TextSize = 12,
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
        -- COLOR PICKER
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateColorPicker(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 48),
                ClipsDescendants = true,
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1, 0.3)
            
            local element = CreateElementBase(container)
            element.Value = config.Color or Color3.fromRGB(255, 255, 255)
            element.Open = false
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.6, 0, 0, 48),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Color",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local preview = Create("TextButton", {
                BackgroundColor3 = element.Value,
                Position = UDim2.new(1, -48, 0, 11),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0, 36, 0, 26),
                Text = "",
                AutoButtonColor = false,
                Parent = container
            })
            Corner(preview, 6)
            Stroke(preview, Theme.Text, 2, 0)
            
            -- RGB Sliders
            local slidersFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 54),
                Size = UDim2.new(1, -24, 0, 100),
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
                    Size = UDim2.new(1, -48, 0, 24),
                    Parent = slidersFrame
                })
                Corner(sliderBg, 6)
                
                local sliderFill = Create("Frame", {
                    BackgroundColor3 = color,
                    Size = UDim2.new(initialValue / 255, 0, 1, 0),
                    Parent = sliderBg
                })
                Corner(sliderFill, 6)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 0),
                    Size = UDim2.new(0, 18, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = Theme.Text,
                    TextSize = 11,
                    ZIndex = 2,
                    Parent = sliderBg
                })
                
                local valueLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 6, 0, yPos),
                    Size = UDim2.new(0, 40, 0, 24),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(math.floor(initialValue)),
                    TextColor3 = color,
                    TextSize = 12,
                    Parent = slidersFrame
                })
                
                return sliderBg, sliderFill, valueLabel
            end
            
            rSlider, rFill, rLabel = createColorSlider("R", Color3.fromRGB(255, 100, 100), 0, r)
            gSlider, gFill, gLabel = createColorSlider("G", Color3.fromRGB(100, 255, 100), 34, g)
            bSlider, bFill, bLabel = createColorSlider("B", Color3.fromRGB(100, 150, 255), 68, b)
            
            local function updateColor()
                local rv = element.Value.R * 255
                local gv = element.Value.G * 255
                local bv = element.Value.B * 255
                
                preview.BackgroundColor3 = element.Value
                
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
                    Tween(container, {Size = UDim2.new(1, 0, 0, 162)}, Anim.SizeChange, Enum.EasingStyle.Quint)
                else
                    Tween(container, {Size = UDim2.new(1, 0, 0, 48)}, Anim.SizeChange, Enum.EasingStyle.Quint)
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
        -- DIVIDER
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateDivider()
            local divider = Create("Frame", {
                BackgroundColor3 = Theme.Border,
                BackgroundTransparency = 0.4,
                Size = UDim2.new(1, 0, 0, 1),
                Parent = page
            })
            
            local element = CreateElementBase(divider)
            table.insert(Tab.Elements, element)
            return element
        end
        
        return Tab
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- OPENING ANIMATION (Smooth Back EaseOut)
    -- ═══════════════════════════════════════════════════════════
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    mainContainer.BackgroundTransparency = 1
    
    -- FIX: Smooth 0.5s Back EaseOut animation
    Tween(mainContainer, {Size = UDim2.new(0, 780, 0, 480)}, Anim.WindowOpen, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Welcome notification
    task.spawn(function()
        task.wait(0.6)
        Library:Notify({
            Title = "Welcome to " .. windowName,
            Content = "Press RightCtrl to toggle. Enjoy!",
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
