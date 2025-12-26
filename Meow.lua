--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                     STELLAR HUB UI LIBRARY                    ║
    ║                    Premium • Modern • Clean                    ║
    ║                         Version 3.0                           ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local Stellar = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--// STELLAR LIGHT BLUE THEME
local THEME = {
    -- Base Colors
    Background      = Color3.fromRGB(15, 23, 42),      -- Deep Navy
    Secondary       = Color3.fromRGB(22, 33, 62),      -- Darker Navy
    Tertiary        = Color3.fromRGB(30, 41, 75),      -- Card Background
    Surface         = Color3.fromRGB(38, 50, 88),      -- Elevated Surface
    
    -- Accent Colors (Light Blue)
    Primary         = Color3.fromRGB(56, 189, 248),    -- Sky Blue
    PrimaryDark     = Color3.fromRGB(14, 165, 233),    -- Darker Sky
    PrimaryLight    = Color3.fromRGB(125, 211, 252),   -- Lighter Sky
    PrimaryGlow     = Color3.fromRGB(56, 189, 248),    -- Glow Color
    
    -- Gradient Colors
    GradientStart   = Color3.fromRGB(59, 130, 246),    -- Blue
    GradientEnd     = Color3.fromRGB(147, 51, 234),    -- Purple
    
    -- Text Colors
    TextPrimary     = Color3.fromRGB(248, 250, 252),   -- Almost White
    TextSecondary   = Color3.fromRGB(148, 163, 184),   -- Muted
    TextMuted       = Color3.fromRGB(100, 116, 139),   -- More Muted
    
    -- Status Colors
    Success         = Color3.fromRGB(34, 197, 94),     -- Green
    Warning         = Color3.fromRGB(251, 191, 36),    -- Amber
    Error           = Color3.fromRGB(239, 68, 68),     -- Red
    Info            = Color3.fromRGB(56, 189, 248),    -- Sky Blue
    
    -- Misc
    Divider         = Color3.fromRGB(51, 65, 95),
    Shadow          = Color3.fromRGB(0, 0, 0),
    Overlay         = Color3.fromRGB(15, 23, 42)
}

--// UTILITY FUNCTIONS
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    if props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function AddStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or THEME.Divider,
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        Parent = parent
    })
end

local function AddPadding(parent, top, left, right, bottom)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        Parent = parent
    })
end

local function AddGradient(parent, colors, rotation)
    local sequence = {}
    for i, color in ipairs(colors) do
        table.insert(sequence, ColorSequenceKeypoint.new((i-1)/(#colors-1), color))
    end
    return Create("UIGradient", {
        Color = ColorSequence.new(sequence),
        Rotation = rotation or 45,
        Parent = parent
    })
end

local function Tween(inst, props, duration, style, direction)
    local tween = TweenService:Create(
        inst, 
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), 
        props
    )
    tween:Play()
    return tween
end

local function CreateShadow(parent, offset, transparency)
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency or 0.5,
        Position = UDim2.new(0, -offset, 0, -offset),
        Size = UDim2.new(1, offset * 2, 1, offset * 2),
        ZIndex = -1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = parent
    })
    return shadow
end

local function CreateGlow(parent, color, size)
    local glow = Create("Frame", {
        Name = "Glow",
        BackgroundColor3 = color or THEME.Primary,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, size or 20, 1, size or 20),
        ZIndex = -1,
        Parent = parent
    })
    AddCorner(glow, 20)
    
    -- Animate glow
    task.spawn(function()
        while glow.Parent do
            Tween(glow, {BackgroundTransparency = 0.7}, 1.5)
            task.wait(1.5)
            Tween(glow, {BackgroundTransparency = 0.9}, 1.5)
            task.wait(1.5)
        end
    end)
    
    return glow
end

local function Ripple(button)
    local ripple = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = button
    })
    AddCorner(ripple, 999)
    
    local mouse = UserInputService:GetMouseLocation()
    local relativePos = Vector2.new(
        mouse.X - button.AbsolutePosition.X,
        mouse.Y - button.AbsolutePosition.Y - 36
    )
    ripple.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y)
    
    local targetSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, targetSize, 0, targetSize), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

local function MakeDraggable(topbar, main)
    local dragging, dragStart, startPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Tween(main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.08)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

--// ICONS (Using Lucide-style icons represented as text for now)
local Icons = {
    Home = "🏠",
    Settings = "⚙️",
    Combat = "⚔️",
    Visual = "👁️",
    Misc = "🔧",
    Player = "👤",
    World = "🌍",
    Star = "⭐",
    Check = "✓",
    Close = "✕",
    Menu = "☰",
    Search = "🔍",
    Copy = "📋",
    Discord = "💬"
}

--// MAIN LIBRARY FUNCTION
function Stellar:CreateWindow(options)
    local WindowTitle = options.Title or "Stellar Hub"
    local WindowSubtitle = options.Subtitle or "Premium Edition"
    local WindowSize = options.Size or UDim2.new(0, 850, 0, 550)
    local MinimizeKey = options.MinimizeKey or Enum.KeyCode.RightControl
    
    -- Cleanup existing
    if CoreGui:FindFirstChild("StellarHub_UI") then
        CoreGui.StellarHub_UI:Destroy()
    end
    
    local ScreenGui = Create("ScreenGui", {
        Name = "StellarHub_UI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Parent = CoreGui
    })
    
    -- Main Container with Shadow
    local MainContainer = Create("Frame", {
        Name = "MainContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = WindowSize,
        Parent = ScreenGui
    })
    
    -- Main Window
    local Main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = THEME.Background,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
        Parent = MainContainer
    })
    AddCorner(Main, 12)
    AddStroke(Main, THEME.Primary, 1, 0.7)
    CreateShadow(Main, 30, 0.6)
    
    -- Add subtle gradient overlay
    local GradientOverlay = Create("Frame", {
        Name = "GradientOverlay",
        BackgroundColor3 = THEME.Primary,
        BackgroundTransparency = 0.95,
        Size = UDim2.new(1, 0, 0, 150),
        ZIndex = 0,
        Parent = Main
    })
    AddCorner(GradientOverlay, 12)
    AddGradient(GradientOverlay, {THEME.Primary, THEME.Background}, 180)
    
    --// SIDEBAR
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = THEME.Secondary,
        Size = UDim2.new(0, 220, 1, 0),
        ZIndex = 2,
        Parent = Main
    })
    AddCorner(Sidebar, 12)
    
    -- Fix sidebar corners on right side
    Create("Frame", {
        BackgroundColor3 = THEME.Secondary,
        Size = UDim2.new(0, 15, 1, 0),
        Position = UDim2.new(1, -15, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Sidebar
    })
    
    -- Sidebar Right Border
    Create("Frame", {
        Name = "SidebarBorder",
        BackgroundColor3 = THEME.Divider,
        Size = UDim2.new(0, 1, 1, -20),
        Position = UDim2.new(1, 0, 0, 10),
        BorderSizePixel = 0,
        BackgroundTransparency = 0.5,
        ZIndex = 3,
        Parent = Sidebar
    })
    
    --// HEADER
    local Header = Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 80),
        ZIndex = 3,
        Parent = Sidebar
    })
    MakeDraggable(Header, MainContainer)
    
    -- Logo Container
    local LogoContainer = Create("Frame", {
        Name = "LogoContainer",
        BackgroundColor3 = THEME.Primary,
        Size = UDim2.new(0, 44, 0, 44),
        Position = UDim2.new(0, 18, 0, 18),
        ZIndex = 4,
        Parent = Header
    })
    AddCorner(LogoContainer, 10)
    AddGradient(LogoContainer, {THEME.GradientStart, THEME.GradientEnd}, 45)
    CreateGlow(LogoContainer, THEME.Primary, 15)
    
    -- Logo Icon
    local LogoIcon = Create("TextLabel", {
        Name = "LogoIcon",
        Text = "★",
        Font = Enum.Font.GothamBold,
        TextColor3 = THEME.TextPrimary,
        TextSize = 24,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 5,
        Parent = LogoContainer
    })
    
    -- Title
    local Title = Create("TextLabel", {
        Name = "Title",
        Text = WindowTitle,
        Font = Enum.Font.GothamBlack,
        TextColor3 = THEME.TextPrimary,
        TextSize = 16,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 72, 0, 20),
        Size = UDim2.new(1, -80, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = Header
    })
    
    -- Subtitle
    local Subtitle = Create("TextLabel", {
        Name = "Subtitle",
        Text = WindowSubtitle,
        Font = Enum.Font.Gotham,
        TextColor3 = THEME.TextMuted,
        TextSize = 11,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 72, 0, 42),
        Size = UDim2.new(1, -80, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = Header
    })
    
    --// NAVIGATION CONTAINER
    local NavSection = Create("TextLabel", {
        Text = "NAVIGATION",
        Font = Enum.Font.GothamBold,
        TextColor3 = THEME.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 90),
        Size = UDim2.new(1, -36, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = Sidebar
    })
    
    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 115),
        Size = UDim2.new(1, 0, 1, -170),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = THEME.Primary,
        ScrollBarImageTransparency = 0.5,
        ZIndex = 4,
        Parent = Sidebar
    })
    
    local TabLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = TabContainer
    })
    AddPadding(TabContainer, 0, 12, 12, 0)
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    --// USER INFO (Bottom of Sidebar)
    local UserInfo = Create("Frame", {
        Name = "UserInfo",
        BackgroundColor3 = THEME.Tertiary,
        Position = UDim2.new(0, 12, 1, -55),
        Size = UDim2.new(1, -24, 0, 45),
        ZIndex = 4,
        Parent = Sidebar
    })
    AddCorner(UserInfo, 8)
    AddStroke(UserInfo, THEME.Divider, 1, 0.7)
    
    -- User Avatar
    local UserAvatar = Create("ImageLabel", {
        Name = "UserAvatar",
        Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100),
        BackgroundColor3 = THEME.Surface,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 7, 0.5, -16),
        ZIndex = 5,
        Parent = UserInfo
    })
    AddCorner(UserAvatar, 16)
    
    -- User Name
    local UserName = Create("TextLabel", {
        Name = "UserName",
        Text = LocalPlayer.DisplayName,
        Font = Enum.Font.GothamBold,
        TextColor3 = THEME.TextPrimary,
        TextSize = 12,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 46, 0, 8),
        Size = UDim2.new(1, -60, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5,
        Parent = UserInfo
    })
    
    -- User Tag
    local UserTag = Create("TextLabel", {
        Name = "UserTag",
        Text = "@" .. LocalPlayer.Name,
        Font = Enum.Font.Gotham,
        TextColor3 = THEME.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 46, 0, 23),
        Size = UDim2.new(1, -60, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5,
        Parent = UserInfo
    })
    
    --// CONTENT AREA
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 220, 0, 0),
        Size = UDim2.new(1, -220, 1, 0),
        ZIndex = 2,
        Parent = Main
    })
    
    --// TOPBAR (For Content Area)
    local TopBar = Create("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60),
        ZIndex = 3,
        Parent = ContentArea
    })
    MakeDraggable(TopBar, MainContainer)
    
    local PageTitle = Create("TextLabel", {
        Name = "PageTitle",
        Text = "Dashboard",
        Font = Enum.Font.GothamBlack,
        TextColor3 = THEME.TextPrimary,
        TextSize = 20,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 25, 0, 15),
        Size = UDim2.new(0.5, 0, 0, 30),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = TopBar
    })
    
    --// WINDOW CONTROLS
    local ControlsContainer = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -100, 0, 15),
        Size = UDim2.new(0, 85, 0, 30),
        ZIndex = 4,
        Parent = TopBar
    })
    
    local ControlLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
        Parent = ControlsContainer
    })
    
    -- Minimize Button
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = THEME.Surface,
        Size = UDim2.new(0, 30, 0, 30),
        Text = "─",
        Font = Enum.Font.GothamBold,
        TextColor3 = THEME.TextSecondary,
        TextSize = 14,
        AutoButtonColor = false,
        ZIndex = 5,
        Parent = ControlsContainer
    })
    AddCorner(MinimizeBtn, 8)
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = THEME.Error,
        BackgroundTransparency = 0.8,
        Size = UDim2.new(0, 30, 0, 30),
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextColor3 = THEME.Error,
        TextSize = 12,
        AutoButtonColor = false,
        ZIndex = 5,
        Parent = ControlsContainer
    })
    AddCorner(CloseBtn, 8)
    
    -- Button Hover Effects
    MinimizeBtn.MouseEnter:Connect(function()
        Tween(MinimizeBtn, {BackgroundColor3 = THEME.Tertiary}, 0.2)
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        Tween(MinimizeBtn, {BackgroundColor3 = THEME.Surface}, 0.2)
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundTransparency = 0, TextColor3 = THEME.TextPrimary}, 0.2)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundTransparency = 0.8, TextColor3 = THEME.Error}, 0.2)
    end)
    
    -- Close Functionality
    CloseBtn.MouseButton1Click:Connect(function()
        Ripple(CloseBtn)
        Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Minimize Functionality
    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        Ripple(MinimizeBtn)
        minimized = not minimized
        if minimized then
            Tween(Main, {Size = UDim2.new(0, 220, 0, 80)}, 0.3)
        else
            Tween(Main, {Size = UDim2.new(1, 0, 1, 0)}, 0.3)
        end
    end)
    
    -- Keybind Toggle
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == MinimizeKey then
            Main.Visible = not Main.Visible
        end
    end)
    
    --// PAGES CONTAINER
    local PagesContainer = Create("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 60),
        Size = UDim2.new(1, 0, 1, -60),
        ZIndex = 2,
        Parent = ContentArea
    })
    
    -------------------------------------------------------------------------
    -- DASHBOARD PAGE (AUTO-GENERATED)
    -------------------------------------------------------------------------
    local function CreateDashboard()
        local DashboardPage = Create("ScrollingFrame", {
            Name = "Dashboard",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = THEME.Primary,
            ScrollBarImageTransparency = 0.3,
            Parent = PagesContainer,
            Visible = true
        })
        AddPadding(DashboardPage, 15, 25, 25, 25)
        
        local DashLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 15),
            Parent = DashboardPage
        })
        
        DashLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            DashboardPage.CanvasSize = UDim2.new(0, 0, 0, DashLayout.AbsoluteContentSize.Y + 50)
        end)
        
        --// WELCOME BANNER
        local WelcomeBanner = Create("Frame", {
            Name = "WelcomeBanner",
            BackgroundColor3 = THEME.Primary,
            Size = UDim2.new(1, 0, 0, 140),
            LayoutOrder = 1,
            Parent = DashboardPage
        })
        AddCorner(WelcomeBanner, 12)
        AddGradient(WelcomeBanner, {THEME.GradientStart, THEME.GradientEnd}, 45)
        
        -- Decorative Elements
        local DecorCircle1 = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.9,
            Size = UDim2.new(0, 200, 0, 200),
            Position = UDim2.new(1, -80, 0, -80),
            Parent = WelcomeBanner
        })
        AddCorner(DecorCircle1, 100)
        
        local DecorCircle2 = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.95,
            Size = UDim2.new(0, 150, 0, 150),
            Position = UDim2.new(1, -180, 0, 50),
            Parent = WelcomeBanner
        })
        AddCorner(DecorCircle2, 75)
        
        -- Avatar
        local BannerAvatar = Create("ImageLabel", {
            Name = "Avatar",
            Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150),
            BackgroundColor3 = THEME.Background,
            Size = UDim2.new(0, 100, 0, 100),
            Position = UDim2.new(0, 20, 0.5, -50),
            ZIndex = 3,
            Parent = WelcomeBanner
        })
        AddCorner(BannerAvatar, 50)
        AddStroke(BannerAvatar, Color3.fromRGB(255, 255, 255), 3, 0.3)
        
        -- Welcome Text
        Create("TextLabel", {
            Text = "Welcome back,",
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextTransparency = 0.3,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 140, 0, 35),
            Size = UDim2.new(0.5, 0, 0, 20),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = WelcomeBanner
        })
        
        Create("TextLabel", {
            Text = LocalPlayer.DisplayName .. "!",
            Font = Enum.Font.GothamBlack,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 28,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 140, 0, 55),
            Size = UDim2.new(0.5, 0, 0, 35),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = WelcomeBanner
        })
        
        Create("TextLabel", {
            Text = "Ready to dominate? Let's get started!",
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextTransparency = 0.2,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 140, 0, 95),
            Size = UDim2.new(0.5, 0, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = WelcomeBanner
        })
        
        --// STATS GRID
        local StatsContainer = Create("Frame", {
            Name = "StatsContainer",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 100),
            LayoutOrder = 2,
            Parent = DashboardPage
        })
        
        local StatsGrid = Create("UIGridLayout", {
            CellSize = UDim2.new(0.24, -8, 1, 0),
            CellPadding = UDim2.new(0, 10, 0, 0),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Parent = StatsContainer
        })
        
        local function CreateStatCard(title, value, icon, color, updateFunc)
            local Card = Create("Frame", {
                Name = title,
                BackgroundColor3 = THEME.Tertiary,
                Parent = StatsContainer
            })
            AddCorner(Card, 10)
            AddStroke(Card, THEME.Divider, 1, 0.8)
            
            -- Icon Container
            local IconBg = Create("Frame", {
                BackgroundColor3 = color,
                BackgroundTransparency = 0.85,
                Size = UDim2.new(0, 40, 0, 40),
                Position = UDim2.new(0, 15, 0, 15),
                Parent = Card
            })
            AddCorner(IconBg, 10)
            
            Create("TextLabel", {
                Text = icon,
                Font = Enum.Font.GothamBold,
                TextColor3 = color,
                TextSize = 18,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = IconBg
            })
            
            -- Title
            Create("TextLabel", {
                Text = title,
                Font = Enum.Font.Gotham,
                TextColor3 = THEME.TextMuted,
                TextSize = 11,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 1, -40),
                Size = UDim2.new(1, -20, 0, 15),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Card
            })
            
            -- Value
            local ValueLabel = Create("TextLabel", {
                Text = value,
                Font = Enum.Font.GothamBlack,
                TextColor3 = THEME.TextPrimary,
                TextSize = 18,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 1, -23),
                Size = UDim2.new(1, -20, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Card
            })
            
            return ValueLabel
        end
        
        local PingLabel = CreateStatCard("Ping", "0 ms", "📡", THEME.Primary, nil)
        local FpsLabel = CreateStatCard("FPS", "60", "🎮", THEME.Success, nil)
        local TimeLabel = CreateStatCard("Time", "00:00", "⏰", THEME.Warning, nil)
        local PlayersLabel = CreateStatCard("Players", "0", "👥", THEME.Info, nil)
        
        -- Update Stats
        RunService.RenderStepped:Connect(function(dt)
            local fps = math.floor(1/dt)
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            
            FpsLabel.Text = tostring(fps)
            PingLabel.Text = ping .. " ms"
            PingLabel.TextColor3 = ping > 150 and THEME.Error or (ping > 80 and THEME.Warning or THEME.TextPrimary)
        end)
        
        task.spawn(function()
            while MainContainer.Parent do
                TimeLabel.Text = os.date("%H:%M")
                PlayersLabel.Text = tostring(#Players:GetPlayers())
                task.wait(1)
            end
        end)
        
        --// INFO CARDS ROW
        local InfoRow = Create("Frame", {
            Name = "InfoRow",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 130),
            LayoutOrder = 3,
            Parent = DashboardPage
        })
        
        local InfoGrid = Create("UIGridLayout", {
            CellSize = UDim2.new(0.49, -5, 1, 0),
            CellPadding = UDim2.new(0, 10, 0, 0),
            Parent = InfoRow
        })
        
        -- Library Info Card
        local LibraryCard = Create("Frame", {
            Name = "LibraryInfo",
            BackgroundColor3 = THEME.Tertiary,
            Parent = InfoRow
        })
        AddCorner(LibraryCard, 10)
        AddStroke(LibraryCard, THEME.Divider, 1, 0.8)
        
        Create("TextLabel", {
            Text = "📚  Library Information",
            Font = Enum.Font.GothamBold,
            TextColor3 = THEME.TextPrimary,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 15),
            Size = UDim2.new(1, -20, 0, 20),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibraryCard
        })
        
        local infoTexts = {
            {text = "Version: 3.0 Premium", color = THEME.TextSecondary},
            {text = "Status: Undetected ✓", color = THEME.Success},
            {text = "Last Update: Today", color = THEME.TextMuted}
        }
        
        for i, info in ipairs(infoTexts) do
            Create("TextLabel", {
                Text = info.text,
                Font = Enum.Font.Gotham,
                TextColor3 = info.color,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 35 + (i * 22)),
                Size = UDim2.new(1, -20, 0, 18),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = LibraryCard
            })
        end
        
        -- Discord Card
        local DiscordCard = Create("Frame", {
            Name = "Discord",
            BackgroundColor3 = THEME.Tertiary,
            Parent = InfoRow
        })
        AddCorner(DiscordCard, 10)
        AddStroke(DiscordCard, THEME.Divider, 1, 0.8)
        
        Create("TextLabel", {
            Text = "💬  Community",
            Font = Enum.Font.GothamBold,
            TextColor3 = THEME.TextPrimary,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 15),
            Size = UDim2.new(1, -20, 0, 20),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DiscordCard
        })
        
        Create("TextLabel", {
            Text = "Join our Discord for updates,\nsupport, and exclusive features!",
            Font = Enum.Font.Gotham,
            TextColor3 = THEME.TextSecondary,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 42),
            Size = UDim2.new(1, -20, 0, 35),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = DiscordCard
        })
        
        local CopyDiscord = Create("TextButton", {
            Text = "📋  Copy Invite Link",
            Font = Enum.Font.GothamBold,
            TextColor3 = THEME.Primary,
            TextSize = 12,
            BackgroundColor3 = THEME.Primary,
            BackgroundTransparency = 0.9,
            Position = UDim2.new(0, 15, 1, -40),
            Size = UDim2.new(1, -30, 0, 28),
            AutoButtonColor = false,
            Parent = DiscordCard
        })
        AddCorner(CopyDiscord, 6)
        
        CopyDiscord.MouseEnter:Connect(function()
            Tween(CopyDiscord, {BackgroundTransparency = 0.8}, 0.2)
        end)
        CopyDiscord.MouseLeave:Connect(function()
            Tween(CopyDiscord, {BackgroundTransparency = 0.9}, 0.2)
        end)
        CopyDiscord.MouseButton1Click:Connect(function()
            Ripple(CopyDiscord)
            setclipboard("discord.gg/stellarhub")
            CopyDiscord.Text = "✓  Copied!"
            task.wait(1.5)
            CopyDiscord.Text = "📋  Copy Invite Link"
        end)
        
        return DashboardPage
    end
    
    local DashboardPage = CreateDashboard()
    
    -------------------------------------------------------------------------
    -- DASHBOARD TAB BUTTON
    -------------------------------------------------------------------------
    local function CreateTabButton(name, icon, isHome)
        local TabBtn = Create("TextButton", {
            Name = name,
            BackgroundColor3 = isHome and THEME.Primary or THEME.Tertiary,
            BackgroundTransparency = isHome and 0.85 or 1,
            Size = UDim2.new(1, 0, 0, 42),
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = isHome and -1 or 0,
            ZIndex = 5,
            Parent = TabContainer
        })
        AddCorner(TabBtn, 8)
        
        -- Active Indicator
        local ActiveBar = Create("Frame", {
            Name = "ActiveBar",
            BackgroundColor3 = THEME.Primary,
            Size = UDim2.new(0, 3, 0, isHome and 20 or 0),
            Position = UDim2.new(0, 0, 0.5, -10),
            ZIndex = 6,
            Parent = TabBtn
        })
        AddCorner(ActiveBar, 2)
        
        -- Icon
        Create("TextLabel", {
            Text = icon,
            Font = Enum.Font.GothamBold,
            TextColor3 = isHome and THEME.Primary or THEME.TextMuted,
            TextSize = 16,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 0),
            Size = UDim2.new(0, 24, 1, 0),
            ZIndex = 6,
            Parent = TabBtn
        })
        
        -- Label
        local Label = Create("TextLabel", {
            Name = "Label",
            Text = name,
            Font = Enum.Font.GothamMedium,
            TextColor3 = isHome and THEME.TextPrimary or THEME.TextSecondary,
            TextSize = 13,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 44, 0, 0),
            Size = UDim2.new(1, -50, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6,
            Parent = TabBtn
        })
        
        return TabBtn, ActiveBar, Label
    end
    
    local HomeBtn, HomeBar, HomeLabel = CreateTabButton("Dashboard", "🏠", true)
    
    --// TAB SWITCHING LOGIC
    local ActiveTab = HomeBtn
    local AllTabs = {HomeBtn}
    local AllPages = {HomeBtn = DashboardPage}
    
    local function SwitchTab(tabBtn, page, title)
        -- Deactivate all tabs
        for _, tab in pairs(AllTabs) do
            local bar = tab:FindFirstChild("ActiveBar")
            local label = tab:FindFirstChild("Label")
            local icon = tab:FindFirstChildWhichIsA("TextLabel")
            
            Tween(tab, {BackgroundTransparency = 1}, 0.2)
            if bar then Tween(bar, {Size = UDim2.new(0, 3, 0, 0)}, 0.2) end
            if label then Tween(label, {TextColor3 = THEME.TextSecondary}, 0.2) end
            if icon and icon.Name ~= "Label" then Tween(icon, {TextColor3 = THEME.TextMuted}, 0.2) end
        end
        
        -- Hide all pages
        for _, p in pairs(PagesContainer:GetChildren()) do
            if p:IsA("ScrollingFrame") or p:IsA("Frame") then
                p.Visible = false
            end
        end
        
        -- Activate clicked tab
        local bar = tabBtn:FindFirstChild("ActiveBar")
        local label = tabBtn:FindFirstChild("Label")
        local icon = tabBtn:FindFirstChildWhichIsA("TextLabel")
        
        Tween(tabBtn, {BackgroundTransparency = 0.85}, 0.2)
        if bar then Tween(bar, {Size = UDim2.new(0, 3, 0, 20)}, 0.2) end
        if label then Tween(label, {TextColor3 = THEME.TextPrimary}, 0.2) end
        if icon and icon.Name ~= "Label" then Tween(icon, {TextColor3 = THEME.Primary}, 0.2) end
        
        -- Show page
        page.Visible = true
        PageTitle.Text = title or "Dashboard"
        ActiveTab = tabBtn
    end
    
    HomeBtn.MouseButton1Click:Connect(function()
        Ripple(HomeBtn)
        SwitchTab(HomeBtn, DashboardPage, "Dashboard")
    end)
    
    -- Hover effect
    HomeBtn.MouseEnter:Connect(function()
        if ActiveTab ~= HomeBtn then
            Tween(HomeBtn, {BackgroundTransparency = 0.9}, 0.2)
        end
    end)
    HomeBtn.MouseLeave:Connect(function()
        if ActiveTab ~= HomeBtn then
            Tween(HomeBtn, {BackgroundTransparency = 1}, 0.2)
        end
    end)
    
    -------------------------------------------------------------------------
    -- WINDOW API FUNCTIONS
    -------------------------------------------------------------------------
    local WindowAPI = {}
    
    function WindowAPI:Tab(name, icon)
        icon = icon or "📁"
        
        local TabBtn, TabBar, TabLabel = CreateTabButton(name, icon, false)
        table.insert(AllTabs, TabBtn)
        
        -- Create Page
        local Page = Create("ScrollingFrame", {
            Name = name,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = THEME.Primary,
            ScrollBarImageTransparency = 0.3,
            Visible = false,
            Parent = PagesContainer
        })
        AddPadding(Page, 15, 25, 25, 25)
        
        local PageLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = Page
        })
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 50)
        end)
        
        AllPages[TabBtn] = Page
        
        -- Click handler
        TabBtn.MouseButton1Click:Connect(function()
            Ripple(TabBtn)
            SwitchTab(TabBtn, Page, name)
        end)
        
        -- Hover effect
        TabBtn.MouseEnter:Connect(function()
            if ActiveTab ~= TabBtn then
                Tween(TabBtn, {BackgroundTransparency = 0.9}, 0.2)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if ActiveTab ~= TabBtn then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        --// TAB API
        local TabAPI = {}
        
        function TabAPI:Section(text)
            local Section = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35),
                Parent = Page
            })
            
            Create("TextLabel", {
                Text = string.upper(text),
                Font = Enum.Font.GothamBold,
                TextColor3 = THEME.Primary,
                TextSize = 11,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 1, -20),
                Size = UDim2.new(1, 0, 0, 18),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section
            })
            
            -- Line
            Create("Frame", {
                BackgroundColor3 = THEME.Divider,
                Size = UDim2.new(1, -80, 0, 1),
                Position = UDim2.new(0, 80, 1, -10),
                BackgroundTransparency = 0.5,
                Parent = Section
            })
        end
        
        function TabAPI:Button(text, callback)
            local Button = Create("TextButton", {
                BackgroundColor3 = THEME.Tertiary,
                Size = UDim2.new(1, 0, 0, 45),
                Text = "",
                AutoButtonColor = false,
                Parent = Page
            })
            AddCorner(Button, 8)
            AddStroke(Button, THEME.Divider, 1, 0.8)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextColor3 = THEME.TextPrimary,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button
            })
            
            -- Arrow
            local Arrow = Create("TextLabel", {
                Text = "→",
                Font = Enum.Font.GothamBold,
                TextColor3 = THEME.Primary,
                TextSize = 16,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -40, 0, 0),
                Size = UDim2.new(0, 25, 1, 0),
                Parent = Button
            })
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = THEME.Surface}, 0.2)
                Tween(Arrow, {Position = UDim2.new(1, -35, 0, 0)}, 0.2)
            end)
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = THEME.Tertiary}, 0.2)
                Tween(Arrow, {Position = UDim2.new(1, -40, 0, 0)}, 0.2)
            end)
            Button.MouseButton1Click:Connect(function()
                Ripple(Button)
                pcall(callback)
            end)
            
            return Button
        end
        
        function TabAPI:Toggle(text, default, callback)
            local Toggled = default or false
            
            local ToggleFrame = Create("TextButton", {
                BackgroundColor3 = THEME.Tertiary,
                Size = UDim2.new(1, 0, 0, 45),
                Text = "",
                AutoButtonColor = false,
                Parent = Page
            })
            AddCorner(ToggleFrame, 8)
            AddStroke(ToggleFrame, THEME.Divider, 1, 0.8)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextColor3 = THEME.TextPrimary,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -80, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            -- Toggle Switch
            local SwitchBg = Create("Frame", {
                BackgroundColor3 = Toggled and THEME.Primary or THEME.Surface,
                Size = UDim2.new(0, 44, 0, 24),
                Position = UDim2.new(1, -58, 0.5, -12),
                Parent = ToggleFrame
            })
            AddCorner(SwitchBg, 12)
            
            local SwitchDot = Create("Frame", {
                BackgroundColor3 = THEME.TextPrimary,
                Size = UDim2.new(0, 18, 0, 18),
                Position = Toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                Parent = SwitchBg
            })
            AddCorner(SwitchDot, 9)
            
            local function UpdateToggle()
                if Toggled then
                    Tween(SwitchBg, {BackgroundColor3 = THEME.Primary}, 0.25)
                    Tween(SwitchDot, {Position = UDim2.new(1, -21, 0.5, -9)}, 0.25, Enum.EasingStyle.Back)
                else
                    Tween(SwitchBg, {BackgroundColor3 = THEME.Surface}, 0.25)
                    Tween(SwitchDot, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.25, Enum.EasingStyle.Back)
                end
                pcall(callback, Toggled)
            end
            
            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                UpdateToggle()
            end)
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = THEME.Surface}, 0.2)
            end)
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = THEME.Tertiary}, 0.2)
            end)
            
            if Toggled then UpdateToggle() end
            
            return {
                Set = function(_, value)
                    Toggled = value
                    UpdateToggle()
                end
            }
        end
        
        function TabAPI:Slider(text, min, max, default, callback)
            local Value = default or min
            
            local SliderFrame = Create("Frame", {
                BackgroundColor3 = THEME.Tertiary,
                Size = UDim2.new(1, 0, 0, 65),
                Parent = Page
            })
            AddCorner(SliderFrame, 8)
            AddStroke(SliderFrame, THEME.Divider, 1, 0.8)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextColor3 = THEME.TextPrimary,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 12),
                Size = UDim2.new(1, -80, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            local ValueLabel = Create("TextLabel", {
                Text = tostring(Value),
                Font = Enum.Font.GothamBlack,
                TextColor3 = THEME.Primary,
                TextSize = 14,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -55, 0, 12),
                Size = UDim2.new(0, 40, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame
            })
            
            -- Slider Bar
            local SliderBar = Create("TextButton", {
                BackgroundColor3 = THEME.Surface,
                Size = UDim2.new(1, -30, 0, 8),
                Position = UDim2.new(0, 15, 0, 42),
                Text = "",
                AutoButtonColor = false,
                Parent = SliderFrame
            })
            AddCorner(SliderBar, 4)
            
            local Fill = Create("Frame", {
                BackgroundColor3 = THEME.Primary,
                Size = UDim2.new((Value - min) / (max - min), 0, 1, 0),
                Parent = SliderBar
            })
            AddCorner(Fill, 4)
            AddGradient(Fill, {THEME.GradientStart, THEME.GradientEnd}, 0)
            
            -- Slider Knob
            local Knob = Create("Frame", {
                BackgroundColor3 = THEME.TextPrimary,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new((Value - min) / (max - min), -8, 0.5, -8),
                ZIndex = 2,
                Parent = SliderBar
            })
            AddCorner(Knob, 8)
            CreateShadow(Knob, 5, 0.7)
            
            local dragging = false
            
            local function UpdateSlider(input)
                local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Value = math.floor(min + ((max - min) * percent))
                
                Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.05)
                Tween(Knob, {Position = UDim2.new(percent, -8, 0.5, -8)}, 0.05)
                ValueLabel.Text = tostring(Value)
                
                pcall(callback, Value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            return {
                Set = function(_, value)
                    Value = math.clamp(value, min, max)
                    local percent = (Value - min) / (max - min)
                    Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.2)
                    Tween(Knob, {Position = UDim2.new(percent, -8, 0.5, -8)}, 0.2)
                    ValueLabel.Text = tostring(Value)
                    pcall(callback, Value)
                end
            }
        end
        
        function TabAPI:Paragraph(title, content)
            local Para = Create("Frame", {
                BackgroundColor3 = THEME.Tertiary,
                Size = UDim2.new(1, 0, 0, 0),
                Parent = Page
            })
            AddCorner(Para, 8)
            AddStroke(Para, THEME.Divider, 1, 0.8)
            
            Create("TextLabel", {
                Text = title,
                Font = Enum.Font.GothamBold,
                TextColor3 = THEME.TextPrimary,
                TextSize = 14,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 12),
                Size = UDim2.new(1, -30, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Para
            })
            
            local ContentLabel = Create("TextLabel", {
                Text = content,
                Font = Enum.Font.Gotham,
                TextColor3 = THEME.TextSecondary,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 35),
                Size = UDim2.new(1, -30, 0, 1000),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                TextYAlignment = Enum.TextYAlignment.Top,
                Parent = Para
            })
            
            task.wait()
            ContentLabel.Size = UDim2.new(1, -30, 0, ContentLabel.TextBounds.Y)
            Para.Size = UDim2.new(1, 0, 0, ContentLabel.TextBounds.Y + 50)
        end
        
        function TabAPI:Dropdown(text, options, default, callback)
            local Selected = default or options[1] or "Select..."
            local Open = false
            
            local DropFrame = Create("Frame", {
                BackgroundColor3 = THEME.Tertiary,
                Size = UDim2.new(1, 0, 0, 45),
                ClipsDescendants = true,
                Parent = Page
            })
            AddCorner(DropFrame, 8)
            AddStroke(DropFrame, THEME.Divider, 1, 0.8)
            
            local DropBtn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 45),
                Text = "",
                Parent = DropFrame
            })
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextColor3 = THEME.TextPrimary,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.5, 0, 0, 45),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropBtn
            })
            
            local SelectedLabel = Create("TextLabel", {
                Text = Selected,
                Font = Enum.Font.Gotham,
                TextColor3 = THEME.TextSecondary,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, -40, 0, 45),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = DropBtn
            })
            
            local Arrow = Create("TextLabel", {
                Text = "▼",
                Font = Enum.Font.GothamBold,
                TextColor3 = THEME.TextMuted,
                TextSize = 10,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0, 0),
                Size = UDim2.new(0, 20, 0, 45),
                Parent = DropBtn
            })
            
            local OptionsContainer = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 50),
                Size = UDim2.new(1, 0, 0, #options * 35),
                Parent = DropFrame
            })
            
            local OptionsLayout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                Parent = OptionsContainer
            })
            AddPadding(OptionsContainer, 0, 10, 10, 5)
            
            for _, option in ipairs(options) do
                local OptionBtn = Create("TextButton", {
                    BackgroundColor3 = THEME.Surface,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    Text = option,
                    Font = Enum.Font.Gotham,
                    TextColor3 = THEME.TextSecondary,
                    TextSize = 12,
                    AutoButtonColor = false,
                    Parent = OptionsContainer
                })
                AddCorner(OptionBtn, 6)
                
                OptionBtn.MouseEnter:Connect(function()
                    Tween(OptionBtn, {BackgroundTransparency = 0.5, TextColor3 = THEME.TextPrimary}, 0.15)
                end)
                OptionBtn.MouseLeave:Connect(function()
                    Tween(OptionBtn, {BackgroundTransparency = 1, TextColor3 = THEME.TextSecondary}, 0.15)
                end)
                OptionBtn.MouseButton1Click:Connect(function()
                    Selected = option
                    SelectedLabel.Text = option
                    Open = false
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.25)
                    Tween(Arrow, {Rotation = 0}, 0.25)
                    pcall(callback, option)
                end)
            end
            
            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local targetHeight = Open and (55 + #options * 35) or 45
                Tween(DropFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25)
                Tween(Arrow, {Rotation = Open and 180 or 0}, 0.25)
            end)
        end
        
        function TabAPI:Input(text, placeholder, callback)
            local InputFrame = Create("Frame", {
                BackgroundColor3 = THEME.Tertiary,
                Size = UDim2.new(1, 0, 0, 45),
                Parent = Page
            })
            AddCorner(InputFrame, 8)
            AddStroke(InputFrame, THEME.Divider, 1, 0.8)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextColor3 = THEME.TextPrimary,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.4, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = InputFrame
            })
            
            local InputBox = Create("TextBox", {
                BackgroundColor3 = THEME.Surface,
                Size = UDim2.new(0.55, -25, 0, 30),
                Position = UDim2.new(0.45, 0, 0.5, -15),
                Text = "",
                PlaceholderText = placeholder or "Enter text...",
                PlaceholderColor3 = THEME.TextMuted,
                Font = Enum.Font.Gotham,
                TextColor3 = THEME.TextPrimary,
                TextSize = 12,
                ClearTextOnFocus = false,
                Parent = InputFrame
            })
            AddCorner(InputBox, 6)
            AddPadding(InputBox, 0, 10, 10, 0)
            
            InputBox.FocusLost:Connect(function(enter)
                if enter then
                    pcall(callback, InputBox.Text)
                end
            end)
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundColor3 = THEME.Tertiary}, 0.2)
            end)
            InputBox.FocusLost:Connect(function()
                Tween(InputBox, {BackgroundColor3 = THEME.Surface}, 0.2)
            end)
        end
        
        return TabAPI
    end
    
    --// NOTIFICATION SYSTEM
    function WindowAPI:Notify(options)
        local Title = options.Title or "Notification"
        local Content = options.Content or ""
        local Duration = options.Duration or 3
        local Type = options.Type or "Info" -- Info, Success, Warning, Error
        
        local TypeColors = {
            Info = THEME.Info,
            Success = THEME.Success,
            Warning = THEME.Warning,
            Error = THEME.Error
        }
        
        local NotifContainer = ScreenGui:FindFirstChild("NotificationContainer")
        if not NotifContainer then
            NotifContainer = Create("Frame", {
                Name = "NotificationContainer",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 1, -20),
                AnchorPoint = Vector2.new(1, 1),
                Size = UDim2.new(0, 300, 0, 400),
                Parent = ScreenGui
            })
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Parent = NotifContainer
            })
        end
        
        local Notif = Create("Frame", {
            BackgroundColor3 = THEME.Tertiary,
            Size = UDim2.new(0, 280, 0, 0),
            ClipsDescendants = true,
            Parent = NotifContainer
        })
        AddCorner(Notif, 10)
        AddStroke(Notif, TypeColors[Type], 1, 0.5)
        CreateShadow(Notif, 15, 0.6)
        
        -- Color bar
        Create("Frame", {
            BackgroundColor3 = TypeColors[Type],
            Size = UDim2.new(0, 4, 1, 0),
            Parent = Notif
        })
        
        Create("TextLabel", {
            Text = Title,
            Font = Enum.Font.GothamBold,
            TextColor3 = THEME.TextPrimary,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, 12),
            Size = UDim2.new(1, -30, 0, 20),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Notif
        })
        
        Create("TextLabel", {
            Text = Content,
            Font = Enum.Font.Gotham,
            TextColor3 = THEME.TextSecondary,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, 35),
            Size = UDim2.new(1, -30, 0, 30),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = Notif
        })
        
        -- Animate in
        Tween(Notif, {Size = UDim2.new(0, 280, 0, 75)}, 0.3, Enum.EasingStyle.Back)
        
        task.delay(Duration, function()
            Tween(Notif, {Size = UDim2.new(0, 280, 0, 0), BackgroundTransparency = 1}, 0.3)
            task.wait(0.3)
            Notif:Destroy()
        end)
    end
    
    return WindowAPI
end

return Stellar
