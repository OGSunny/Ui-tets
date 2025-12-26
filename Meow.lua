--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                    STELLAR UI LIBRARY v3.0                    ║
    ║               The Most Fire PVP UI for Roblox                 ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

local Library = {}
Library.ToggleKey = Enum.KeyCode.RightControl
Library.Windows = {}

-- ═══════════════════════════════════════════════════════════════
-- PREMIUM THEME
-- ═══════════════════════════════════════════════════════════════
local Theme = {
    Primary = Color3.fromRGB(12, 12, 18),
    Secondary = Color3.fromRGB(22, 22, 32),
    Tertiary = Color3.fromRGB(32, 32, 45),
    Hover = Color3.fromRGB(42, 42, 58),
    
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
    Border = Color3.fromRGB(55, 55, 75)
}

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
    world = "rbxassetid://7734082149"
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

local function Tween(obj, props, duration, style, direction)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

local function Corner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function Stroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
end

local function Padding(parent, t, b, l, r)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or t or 0),
        PaddingLeft = UDim.new(0, l or t or 0),
        PaddingRight = UDim.new(0, r or l or t or 0),
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

local function Ripple(button, x, y)
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = button
    })
    Corner(ripple, 100)
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

local function CreateShadow(parent, offset, size)
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, offset or 4),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, size or 35, 1, size or 35),
        ZIndex = -1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = parent
    })
    return shadow
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
    
    -- Get or create notification container
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
    
    -- Create notification
    local notif = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Theme.Secondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 80),
        ClipsDescendants = true,
        Parent = gui.Container
    })
    Corner(notif, 12)
    
    local stroke = Stroke(notif, Theme.Accent, 1, 1)
    CreateShadow(notif, 3, 20)
    
    -- Icon
    if icon then
        local iconFrame = Create("Frame", {
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 0.9,
            Position = UDim2.new(0, 14, 0, 14),
            Size = UDim2.new(0, 40, 0, 40),
            Parent = notif
        })
        Corner(iconFrame, 10)
        
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
    
    -- Close button
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
        Tween(closeBtn, {TextColor3 = Theme.Error}, 0.2)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {TextColor3 = Theme.TextMuted}, 0.2)
    end)
    
    -- Title
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
    
    -- Content
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
    
    -- Progress bar
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
    
    -- Animate in
    notif.Position = UDim2.new(1, 50, 0, 0)
    Tween(notif, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}, 0.4, Enum.EasingStyle.Back)
    Tween(stroke, {Transparency = 0}, 0.3)
    
    -- Progress animation
    Tween(progress, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    -- Close function
    local function closeNotif()
        Tween(notif, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function()
            notif:Destroy()
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
    
    -- Create ScreenGui
    local gui = Create("ScreenGui", {
        Name = "StellarUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    Window.Gui = gui
    
    -- Main Container
    local mainContainer = Create("Frame", {
        Name = "MainContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 780, 0, 480),
        Parent = gui
    })
    
    -- Main Shadow
    CreateShadow(mainContainer, 8, 60)
    
    -- Main Frame
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
    Stroke(main, Theme.Border, 1)
    
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
    
    -- Bottom corner fix
    Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        Parent = topBar
    })
    
    -- Accent line under topbar
    Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = topBar
    })
    
    -- Title with glow effect
    local titleGlow = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0.5, 1),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 200, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = "✦ " .. windowName,
        TextColor3 = Theme.Accent,
        TextSize = 17,
        TextTransparency = 0.7,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    local title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 200, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = "✦ " .. windowName,
        TextColor3 = Theme.Accent,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar
    })
    
    -- ═══════════════════════════════════════════════════════════
    -- RIGHT SIDE CONTROLS
    -- ═══════════════════════════════════════════════════════════
    
    -- Close Button
    local closeBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Error,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(1, -44, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 32, 0, 32),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Theme.Error,
        TextSize = 22,
        AutoButtonColor = false,
        Parent = topBar
    })
    Corner(closeBtn, 8)
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.5, Size = UDim2.new(0, 34, 0, 34)}, 0.2)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.85, Size = UDim2.new(0, 32, 0, 32)}, 0.2)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(mainContainer, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.3, function()
            gui:Destroy()
        end)
    end)
    
    -- Minimize Button
    local minBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Warning,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(1, -82, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 32, 0, 32),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Theme.Warning,
        TextSize = 24,
        AutoButtonColor = false,
        Parent = topBar
    })
    Corner(minBtn, 8)
    
    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, {BackgroundTransparency = 0.5, Size = UDim2.new(0, 34, 0, 34)}, 0.2)
    end)
    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, {BackgroundTransparency = 0.85, Size = UDim2.new(0, 32, 0, 32)}, 0.2)
    end)
    minBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(mainContainer, {Size = UDim2.new(0, 780, 0, 48)}, 0.3, Enum.EasingStyle.Quint)
            minBtn.Text = "+"
        else
            Tween(mainContainer, {Size = UDim2.new(0, 780, 0, 480)}, 0.3, Enum.EasingStyle.Quint)
            minBtn.Text = "−"
        end
    end)
    
    -- Key Badge
    local keyBadge = Create("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        Position = UDim2.new(1, -190, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 100, 0, 28),
        Parent = topBar
    })
    Corner(keyBadge, 14)
    Stroke(keyBadge, Theme.Accent, 1, 0.5)
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "⏱ " .. keyTime,
        TextColor3 = Theme.Accent,
        TextSize = 11,
        Parent = keyBadge
    })
    
    -- Username
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -310, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 110, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = Player.Name,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = topBar
    })
    
    -- Avatar
    local avatarContainer = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(1, -350, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 34, 0, 34),
        Parent = topBar
    })
    Corner(avatarContainer, 17)
    
    local avatar = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 30, 0, 30),
        Image = GetAvatar(),
        Parent = avatarContainer
    })
    Corner(avatar, 15)
    
    -- ═══════════════════════════════════════════════════════════
    -- SIDEBAR
    -- ═══════════════════════════════════════════════════════════
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.Secondary,
        Position = UDim2.new(0, 0, 0, 48),
        Size = UDim2.new(0, 200, 1, -48),
        Parent = main
    })
    Corner(sidebar, 12)
    
    -- Fix corners
    Create("Frame", {BackgroundColor3 = Theme.Secondary, Size = UDim2.new(1, 0, 0, 12), BorderSizePixel = 0, Parent = sidebar})
    Create("Frame", {BackgroundColor3 = Theme.Secondary, Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0, 12, 1, 0), BorderSizePixel = 0, Parent = sidebar})
    
    -- Separator line
    Create("Frame", {
        BackgroundColor3 = Theme.Border,
        Position = UDim2.new(1, -1, 0, 10),
        Size = UDim2.new(0, 1, 1, -20),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    -- Tab Header
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 12),
        Size = UDim2.new(1, -32, 0, 20),
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
        Position = UDim2.new(0, 10, 0, 40),
        Size = UDim2.new(1, -20, 1, -140),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = tabContainer
    })
    
    -- ═══════════════════════════════════════════════════════════
    -- PROFILE SECTION (Bottom of Sidebar)
    -- ═══════════════════════════════════════════════════════════
    local profileSection = Create("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        Position = UDim2.new(0, 10, 1, -90),
        Size = UDim2.new(1, -20, 0, 80),
        Parent = sidebar
    })
    Corner(profileSection, 10)
    Stroke(profileSection, Theme.Border, 1)
    
    -- Profile Avatar (Large)
    local profileAvatarBg = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0, 12, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 52, 0, 52),
        Parent = profileSection
    })
    Corner(profileAvatarBg, 26)
    
    local profileAvatar = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 48, 0, 48),
        Image = GetAvatar(),
        Parent = profileAvatarBg
    })
    Corner(profileAvatar, 24)
    
    -- Online Indicator
    local onlineIndicator = Create("Frame", {
        BackgroundColor3 = Theme.Online,
        Position = UDim2.new(1, -4, 1, -4),
        AnchorPoint = Vector2.new(1, 1),
        Size = UDim2.new(0, 14, 0, 14),
        Parent = profileAvatarBg
    })
    Corner(onlineIndicator, 7)
    Stroke(onlineIndicator, Theme.Secondary, 3)
    
    -- Display Name
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 72, 0, 18),
        Size = UDim2.new(1, -84, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = Player.DisplayName,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = profileSection
    })
    
    -- Username
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 72, 0, 38),
        Size = UDim2.new(1, -84, 0, 16),
        Font = Enum.Font.Gotham,
        Text = "@" .. Player.Name,
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = profileSection
    })
    
    -- Online Status
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 72, 0, 54),
        Size = UDim2.new(1, -84, 0, 14),
        Font = Enum.Font.GothamMedium,
        Text = "● Online",
        TextColor3 = Theme.Online,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = profileSection
    })
    
    -- ═══════════════════════════════════════════════════════════
    -- CONTENT AREA
    -- ═══════════════════════════════════════════════════════════
    local contentArea = Create("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 200, 0, 48),
        Size = UDim2.new(1, -200, 1, -48),
        Parent = main
    })
    
    Window.ContentArea = contentArea
    
    -- ═══════════════════════════════════════════════════════════
    -- DRAGGING
    -- ═══════════════════════════════════════════════════════════
    local dragging, dragStart, startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainContainer.Position
        end
    end)
    
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
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
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Library.ToggleKey then
            Window.Open = not Window.Open
            if Window.Open then
                gui.Enabled = true
                Tween(mainContainer, {Size = UDim2.new(0, 780, 0, Window.Minimized and 48 or 480)}, 0.3, Enum.EasingStyle.Back)
            else
                Tween(mainContainer, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
                task.delay(0.25, function()
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
        TextSize = 26,
        AutoButtonColor = false,
        Parent = gui
    })
    Corner(mobileBtn, 28)
    CreateShadow(mobileBtn, 4, 15)
    Stroke(mobileBtn, Theme.AccentGlow, 2, 0.5)
    
    -- Make mobile button draggable
    local mobileDragging, mobileDragStart, mobileStartPos
    
    mobileBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            mobileDragging = true
            mobileDragStart = input.Position
            mobileStartPos = mobileBtn.Position
        end
    end)
    
    mobileBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if mobileDragging then
                local delta = input.Position - mobileDragStart
                if delta.Magnitude < 10 then
                    -- It was a tap, not a drag
                    Window.Open = not Window.Open
                    main.Visible = Window.Open
                    Tween(mobileBtn, {Rotation = Window.Open and 45 or 0}, 0.3)
                end
            end
            mobileDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if mobileDragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - mobileDragStart
            mobileBtn.Position = UDim2.new(
                mobileStartPos.X.Scale, mobileStartPos.X.Offset + delta.X,
                mobileStartPos.Y.Scale, mobileStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    mobileBtn.MouseButton1Click:Connect(function()
        Window.Open = not Window.Open
        main.Visible = Window.Open
        Tween(mobileBtn, {Rotation = Window.Open and 45 or 0}, 0.3)
    end)
    
    -- ═══════════════════════════════════════════════════════════
    -- CREATE TAB FUNCTION
    -- ═══════════════════════════════════════════════════════════
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon
        
        local Tab = {}
        Tab.Elements = {}
        
        -- Tab Button
        local tabBtn = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Theme.Tertiary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 40),
            Text = "",
            AutoButtonColor = false,
            Parent = tabContainer
        })
        Corner(tabBtn, 8)
        
        -- Selection indicator
        local indicator = Create("Frame", {
            BackgroundColor3 = Theme.Accent,
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 0, 0, 24),
            Parent = tabBtn
        })
        Corner(indicator, 4)
        
        -- Icon
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
        
        -- Label
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
            ScrollBarImageTransparency = 0.3,
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
        
        -- Selection logic
        local function selectTab()
            -- Deselect all
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundTransparency = 1}, 0.2)
                if tab.Button:FindFirstChild("Label") then
                    Tween(tab.Button.Label, {TextColor3 = Theme.TextMuted}, 0.2)
                end
                if tab.Button:FindFirstChild("Icon") then
                    Tween(tab.Button.Icon, {ImageColor3 = Theme.TextMuted}, 0.2)
                end
                Tween(tab.Button:FindFirstChild("Frame"), {Size = UDim2.new(0, 0, 0, 24)}, 0.2)
                tab.Page.Visible = false
            end
            
            -- Select this tab
            Tween(tabBtn, {BackgroundTransparency = 0}, 0.2)
            Tween(tabBtn.Label, {TextColor3 = Theme.Text}, 0.2)
            if tabBtn:FindFirstChild("Icon") then
                Tween(tabBtn.Icon, {ImageColor3 = Theme.Accent}, 0.2)
            end
            Tween(indicator, {Size = UDim2.new(0, 4, 0, 24)}, 0.25, Enum.EasingStyle.Back)
            page.Visible = true
            Window.ActiveTab = Tab
        end
        
        tabBtn.MouseButton1Click:Connect(function()
            Ripple(tabBtn, Mouse.X, Mouse.Y)
            selectTab()
        end)
        
        tabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 0.5}, 0.15)
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            selectTab()
        end
        
        -- ═══════════════════════════════════════════════════════
        -- SECTION
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateSection(config)
            config = config or {}
            
            local section = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32),
                Parent = page
            })
            
            Create("Frame", {
                BackgroundColor3 = Theme.Border,
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
                TextSize = 11,
                Parent = labelBg
            })
            
            return section
        end
        
        -- ═══════════════════════════════════════════════════════
        -- TOGGLE
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateToggle(config)
            config = config or {}
            local Toggle = {Value = config.CurrentValue or false}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, config.Description and 58 or 46),
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1)
            
            -- Title
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, config.Description and 10 or 0),
                Size = UDim2.new(1, -80, 0, config.Description and 20 or 46),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Toggle",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            -- Description
            if config.Description then
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 32),
                    Size = UDim2.new(1, -80, 0, 18),
                    Font = Enum.Font.Gotham,
                    Text = config.Description,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container
                })
            end
            
            -- Switch
            local switch = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(1, -58, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 44, 0, 24),
                Parent = container
            })
            Corner(switch, 12)
            
            local circle = Create("Frame", {
                BackgroundColor3 = Theme.TextMuted,
                Position = UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 18, 0, 18),
                Parent = switch
            })
            Corner(circle, 9)
            
            local function update()
                if Toggle.Value then
                    Tween(switch, {BackgroundColor3 = Theme.Accent}, 0.25)
                    Tween(circle, {
                        Position = UDim2.new(1, -21, 0.5, 0),
                        BackgroundColor3 = Theme.Primary
                    }, 0.25, Enum.EasingStyle.Back)
                else
                    Tween(switch, {BackgroundColor3 = Theme.Tertiary}, 0.25)
                    Tween(circle, {
                        Position = UDim2.new(0, 3, 0.5, 0),
                        BackgroundColor3 = Theme.TextMuted
                    }, 0.25)
                end
            end
            
            update()
            
            local btn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = container
            })
            
            btn.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                update()
                callback(Toggle.Value)
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Hover}, 0.15)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, 0.15)
            end)
            
            function Toggle:Set(value)
                Toggle.Value = value
                update()
                callback(value)
            end
            
            return Toggle
        end
        
        -- ═══════════════════════════════════════════════════════
        -- SLIDER
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateSlider(config)
            config = config or {}
            local range = config.Range or {0, 100}
            local increment = config.Increment or 1
            local Slider = {Value = config.CurrentValue or range[1]}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 60),
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1)
            
            -- Title
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 10),
                Size = UDim2.new(0.6, 0, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Slider",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            -- Value
            local valueLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -14, 0, 10),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0.3, 0, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = tostring(Slider.Value),
                TextColor3 = Theme.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = container
            })
            
            -- Slider Track
            local track = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(0, 14, 0, 40),
                Size = UDim2.new(1, -28, 0, 8),
                Parent = container
            })
            Corner(track, 4)
            
            -- Fill
            local fill = Create("Frame", {
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((Slider.Value - range[1]) / (range[2] - range[1]), 0, 1, 0),
                Parent = track
            })
            Corner(fill, 4)
            
            -- Glow effect on fill
            local fillGlow = Create("Frame", {
                BackgroundColor3 = Theme.AccentGlow,
                BackgroundTransparency = 0.5,
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(1, 0, 2, 0),
                ZIndex = 0,
                Parent = fill
            })
            Corner(fillGlow, 6)
            
            -- Knob
            local knob = Create("Frame", {
                BackgroundColor3 = Theme.Text,
                Position = UDim2.new((Slider.Value - range[1]) / (range[2] - range[1]), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0, 18, 0, 18),
                Parent = track
            })
            Corner(knob, 9)
            Stroke(knob, Theme.Accent, 3)
            CreateShadow(knob, 2, 8)
            
            local function setValue(value)
                value = math.clamp(value, range[1], range[2])
                value = math.floor(value / increment + 0.5) * increment
                Slider.Value = value
                
                local percent = (value - range[1]) / (range[2] - range[1])
                Tween(fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                Tween(knob, {Position = UDim2.new(percent, 0, 0.5, 0)}, 0.1)
                valueLabel.Text = tostring(value)
                callback(value)
            end
            
            local dragging = false
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    setValue(range[1] + (range[2] - range[1]) * percent)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    setValue(range[1] + (range[2] - range[1]) * percent)
                end
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Hover}, 0.15)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, 0.15)
            end)
            
            function Slider:Set(value)
                setValue(value)
            end
            
            return Slider
        end
        
        -- ═══════════════════════════════════════════════════════
        -- BUTTON
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateButton(config)
            config = config or {}
            local callback = config.Callback or function() end
            
            local btn = Create("TextButton", {
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new(1, 0, 0, 42),
                Font = Enum.Font.GothamBold,
                Text = config.Name or "Button",
                TextColor3 = Theme.Primary,
                TextSize = 14,
                AutoButtonColor = false,
                Parent = page
            })
            Corner(btn, 10)
            
            -- Glow effect
            local glow = Create("Frame", {
                BackgroundColor3 = Theme.AccentGlow,
                BackgroundTransparency = 0.8,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(1, 10, 1, 10),
                ZIndex = 0,
                Parent = btn
            })
            Corner(glow, 14)
            
            btn.MouseEnter:Connect(function()
                Tween(btn, {BackgroundColor3 = Theme.AccentDark}, 0.15)
                Tween(glow, {BackgroundTransparency = 0.6, Size = UDim2.new(1, 15, 1, 15)}, 0.15)
            end)
            
            btn.MouseLeave:Connect(function()
                Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.15)
                Tween(glow, {BackgroundTransparency = 0.8, Size = UDim2.new(1, 10, 1, 10)}, 0.15)
            end)
            
            btn.MouseButton1Click:Connect(function()
                Ripple(btn, Mouse.X, Mouse.Y)
                Tween(btn, {Size = UDim2.new(1, -6, 0, 40)}, 0.1)
                task.wait(0.1)
                Tween(btn, {Size = UDim2.new(1, 0, 0, 42)}, 0.15, Enum.EasingStyle.Back)
                callback()
            end)
            
            return btn
        end
        
        -- ═══════════════════════════════════════════════════════
        -- DROPDOWN
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateDropdown(config)
            config = config or {}
            local options = config.Options or {}
            local Dropdown = {Value = config.CurrentOption or options[1] or "", Open = false}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 46),
                ClipsDescendants = true,
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1)
            
            -- Title
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.4, 0, 0, 46),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Dropdown",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            -- Selected button
            local selected = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Position = UDim2.new(0.4, 0, 0, 8),
                Size = UDim2.new(0.6, -14, 0, 30),
                Font = Enum.Font.GothamMedium,
                Text = Dropdown.Value .. "  ▼",
                TextColor3 = Theme.Text,
                TextSize = 12,
                AutoButtonColor = false,
                Parent = container
            })
            Corner(selected, 8)
            
            -- Options container
            local optContainer = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 52),
                Size = UDim2.new(1, -28, 0, #options * 34),
                Parent = container
            })
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4),
                Parent = optContainer
            })
            
            for i, opt in ipairs(options) do
                local optBtn = Create("TextButton", {
                    BackgroundColor3 = Theme.Tertiary,
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = opt,
                    TextColor3 = Theme.TextDark,
                    TextSize = 12,
                    AutoButtonColor = false,
                    Parent = optContainer
                })
                Corner(optBtn, 6)
                
                optBtn.MouseEnter:Connect(function()
                    Tween(optBtn, {BackgroundColor3 = Theme.Accent}, 0.15)
                    Tween(optBtn, {TextColor3 = Theme.Primary}, 0.15)
                end)
                
                optBtn.MouseLeave:Connect(function()
                    Tween(optBtn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
                    Tween(optBtn, {TextColor3 = Theme.TextDark}, 0.15)
                end)
                
                optBtn.MouseButton1Click:Connect(function()
                    Dropdown.Value = opt
                    selected.Text = opt .. "  ▼"
                    Dropdown.Open = false
                    Tween(container, {Size = UDim2.new(1, 0, 0, 46)}, 0.25, Enum.EasingStyle.Quint)
                    callback(opt)
                end)
            end
            
            selected.MouseButton1Click:Connect(function()
                Dropdown.Open = not Dropdown.Open
                local targetSize = Dropdown.Open and (56 + #options * 34) or 46
                Tween(container, {Size = UDim2.new(1, 0, 0, targetSize)}, 0.25, Enum.EasingStyle.Quint)
                selected.Text = Dropdown.Value .. (Dropdown.Open and "  ▲" or "  ▼")
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Hover}, 0.15)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, 0.15)
            end)
            
            function Dropdown:Set(value)
                Dropdown.Value = value
                selected.Text = value .. "  ▼"
                callback(value)
            end
            
            function Dropdown:Refresh(newOptions)
                options = newOptions
                for _, child in pairs(optContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                optContainer.Size = UDim2.new(1, -28, 0, #options * 34)
                
                for i, opt in ipairs(options) do
                    local optBtn = Create("TextButton", {
                        BackgroundColor3 = Theme.Tertiary,
                        Size = UDim2.new(1, 0, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = opt,
                        TextColor3 = Theme.TextDark,
                        TextSize = 12,
                        AutoButtonColor = false,
                        Parent = optContainer
                    })
                    Corner(optBtn, 6)
                    
                    optBtn.MouseEnter:Connect(function()
                        Tween(optBtn, {BackgroundColor3 = Theme.Accent}, 0.15)
                        Tween(optBtn, {TextColor3 = Theme.Primary}, 0.15)
                    end)
                    
                    optBtn.MouseLeave:Connect(function()
                        Tween(optBtn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
                        Tween(optBtn, {TextColor3 = Theme.TextDark}, 0.15)
                    end)
                    
                    optBtn.MouseButton1Click:Connect(function()
                        Dropdown.Value = opt
                        selected.Text = opt .. "  ▼"
                        Dropdown.Open = false
                        Tween(container, {Size = UDim2.new(1, 0, 0, 46)}, 0.25)
                        callback(opt)
                    end)
                end
            end
            
            return Dropdown
        end
        
        -- ═══════════════════════════════════════════════════════
        -- INPUT
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateInput(config)
            config = config or {}
            local Input = {Value = ""}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 46),
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1)
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
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
                Position = UDim2.new(0.35, 0, 0, 8),
                Size = UDim2.new(0.65, -14, 0, 30),
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
            
            local boxStroke = Stroke(box, Theme.Border, 1)
            
            box.Focused:Connect(function()
                Tween(boxStroke, {Color = Theme.Accent}, 0.2)
            end)
            
            box.FocusLost:Connect(function(enterPressed)
                Tween(boxStroke, {Color = Theme.Border}, 0.2)
                Input.Value = box.Text
                if enterPressed then
                    callback(box.Text)
                end
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Hover}, 0.15)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, 0.15)
            end)
            
            function Input:Set(text)
                box.Text = text
                Input.Value = text
            end
            
            return Input
        end
        
        -- ═══════════════════════════════════════════════════════
        -- KEYBIND
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateKeybind(config)
            config = config or {}
            local Keybind = {Value = config.CurrentKeybind or "None", Listening = false}
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 46),
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1)
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
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
                Position = UDim2.new(1, -90, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 76, 0, 30),
                Font = Enum.Font.GothamBold,
                Text = Keybind.Value,
                TextColor3 = Theme.Accent,
                TextSize = 12,
                AutoButtonColor = false,
                Parent = container
            })
            Corner(keyBtn, 8)
            Stroke(keyBtn, Theme.Accent, 1, 0.5)
            
            keyBtn.MouseButton1Click:Connect(function()
                Keybind.Listening = true
                keyBtn.Text = "..."
                Tween(keyBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
                keyBtn.TextColor3 = Theme.Primary
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if Keybind.Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    Keybind.Value = input.KeyCode.Name
                    keyBtn.Text = input.KeyCode.Name
                    Keybind.Listening = false
                    Tween(keyBtn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                    keyBtn.TextColor3 = Theme.Accent
                elseif not gameProcessed and not Keybind.Listening and input.KeyCode.Name == Keybind.Value then
                    callback(Keybind.Value)
                end
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Hover}, 0.15)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, 0.15)
            end)
            
            function Keybind:Set(key)
                Keybind.Value = key
                keyBtn.Text = key
            end
            
            return Keybind
        end
        
        -- ═══════════════════════════════════════════════════════
        -- LABEL
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateLabel(config)
            config = config or {}
            
            local label = Create("TextLabel", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 36),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Label",
                TextColor3 = Theme.TextDark,
                TextSize = 13,
                Parent = page
            })
            Corner(label, 8)
            
            local Label = {}
            function Label:Set(text)
                label.Text = text
            end
            
            return Label
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
            Stroke(container, Theme.Border, 1)
            Padding(container, 14, 14, 14, 14)
            
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
                TextSize = 15,
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
            
            local Paragraph = {}
            function Paragraph:Set(title, content)
                titleLabel.Text = title or titleLabel.Text
                contentLabel.Text = content or contentLabel.Text
            end
            
            return Paragraph
        end
        
        -- ═══════════════════════════════════════════════════════
        -- COLOR PICKER
        -- ═══════════════════════════════════════════════════════
        function Tab:CreateColorPicker(config)
            config = config or {}
            local ColorPicker = {
                Value = config.Color or Color3.fromRGB(255, 255, 255),
                Open = false
            }
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 46),
                ClipsDescendants = true,
                Parent = page
            })
            Corner(container, 10)
            Stroke(container, Theme.Border, 1)
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.6, 0, 0, 46),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Color",
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container
            })
            
            local preview = Create("TextButton", {
                BackgroundColor3 = ColorPicker.Value,
                Position = UDim2.new(1, -50, 0, 10),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0, 36, 0, 26),
                Text = "",
                AutoButtonColor = false,
                Parent = container
            })
            Corner(preview, 6)
            Stroke(preview, Theme.Text, 2)
            
            -- RGB Sliders
            local slidersFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 52),
                Size = UDim2.new(1, -28, 0, 100),
                Parent = container
            })
            
                        local r, g, b = math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255)
            
            local function createColorSlider(name, color, yPos, initialValue)
                local sliderBg = Create("Frame", {
                    BackgroundColor3 = Theme.Tertiary,
                    Position = UDim2.new(0, 0, 0, yPos),
                    Size = UDim2.new(1, -50, 0, 22),
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
                    Size = UDim2.new(0, 20, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = Theme.Text,
                    TextSize = 11,
                    ZIndex = 2,
                    Parent = sliderBg
                })
                
                local valueLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 8, 0, yPos),
                    Size = UDim2.new(0, 40, 0, 22),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(math.floor(initialValue)),
                    TextColor3 = color,
                    TextSize = 12,
                    Parent = slidersFrame
                })
                
                return sliderBg, sliderFill, valueLabel
            end
            
            local rSlider, rFill, rLabel = createColorSlider("R", Color3.fromRGB(255, 100, 100), 0, r)
            local gSlider, gFill, gLabel = createColorSlider("G", Color3.fromRGB(100, 255, 100), 32, g)
            local bSlider, bFill, bLabel = createColorSlider("B", Color3.fromRGB(100, 150, 255), 64, b)
            
            local function updateColor()
                local rv = math.floor(ColorPicker.Value.R * 255)
                local gv = math.floor(ColorPicker.Value.G * 255)
                local bv = math.floor(ColorPicker.Value.B * 255)
                
                preview.BackgroundColor3 = ColorPicker.Value
                
                Tween(rFill, {Size = UDim2.new(rv / 255, 0, 1, 0)}, 0.1)
                Tween(gFill, {Size = UDim2.new(gv / 255, 0, 1, 0)}, 0.1)
                Tween(bFill, {Size = UDim2.new(bv / 255, 0, 1, 0)}, 0.1)
                
                rLabel.Text = tostring(rv)
                gLabel.Text = tostring(gv)
                bLabel.Text = tostring(bv)
                
                callback(ColorPicker.Value)
            end
            
            local function setupColorSliderDrag(slider, fill, valueLabel, component)
                local dragging = false
                
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        local percent = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        local value = math.floor(percent * 255)
                        
                        local rv, gv, bv = ColorPicker.Value.R * 255, ColorPicker.Value.G * 255, ColorPicker.Value.B * 255
                        if component == "R" then rv = value
                        elseif component == "G" then gv = value
                        else bv = value end
                        
                        ColorPicker.Value = Color3.fromRGB(rv, gv, bv)
                        updateColor()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local percent = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        local value = math.floor(percent * 255)
                        
                        local rv, gv, bv = ColorPicker.Value.R * 255, ColorPicker.Value.G * 255, ColorPicker.Value.B * 255
                        if component == "R" then rv = value
                        elseif component == "G" then gv = value
                        else bv = value end
                        
                        ColorPicker.Value = Color3.fromRGB(rv, gv, bv)
                        updateColor()
                    end
                end)
            end
            
            setupColorSliderDrag(rSlider, rFill, rLabel, "R")
            setupColorSliderDrag(gSlider, gFill, gLabel, "G")
            setupColorSliderDrag(bSlider, bFill, bLabel, "B")
            
            preview.MouseButton1Click:Connect(function()
                ColorPicker.Open = not ColorPicker.Open
                if ColorPicker.Open then
                    Tween(container, {Size = UDim2.new(1, 0, 0, 160)}, 0.25, Enum.EasingStyle.Quint)
                else
                    Tween(container, {Size = UDim2.new(1, 0, 0, 46)}, 0.25, Enum.EasingStyle.Quint)
                end
            end)
            
            container.MouseEnter:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Hover}, 0.15)
            end)
            container.MouseLeave:Connect(function()
                Tween(container, {BackgroundColor3 = Theme.Secondary}, 0.15)
            end)
            
            function ColorPicker:Set(color)
                ColorPicker.Value = color
                updateColor()
            end
            
            return ColorPicker
        end
        
        return Tab
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- OPENING ANIMATION
    -- ═══════════════════════════════════════════════════════════
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    Tween(mainContainer, {Size = UDim2.new(0, 780, 0, 480)}, 0.5, Enum.EasingStyle.Back)
    
    -- Welcome notification
    task.spawn(function()
        task.wait(0.8)
        Library:Notify({
            Title = "Welcome to " .. windowName,
            Content = "Press RightCtrl to toggle the UI. Enjoy!",
            Icon = "star",
            Time = 5
        })
    end)
    
    table.insert(Library.Windows, Window)
    return Window
end

-- ═══════════════════════════════════════════════════════════════
-- DESTROY ALL
-- ═══════════════════════════════════════════════════════════════
function Library:Destroy()
    for _, window in pairs(Library.Windows) do
        if window.Gui then
            window.Gui:Destroy()
        end
    end
    
    local notifGui = CoreGui:FindFirstChild("StellarNotifications")
    if notifGui then
        notifGui:Destroy()
    end
end

return Library
