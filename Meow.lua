--[[
    ███████╗████████╗███████╗██╗     ██╗      █████╗ ██████╗ 
    ██╔════╝╚══██╔══╝██╔════╝██║     ██║     ██╔══██╗██╔══██╗
    ███████╗   ██║   █████╗  ██║     ██║     ███████║██████╔╝
    ╚════██║   ██║   ██╔══╝  ██║     ██║     ██╔══██║██╔══██╗
    ███████║   ██║   ███████╗███████╗███████╗██║  ██║██║  ██║
    ╚══════╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
    
    Stellar Hub v6.0 - Premium UI Library
    Features: Key System, Multi-Game Loader, WindUI-Style API
]]

local Stellar = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

-- Lucide-style icons (using rbxassetid)
local Icons = {
    -- Navigation & UI
    Home = "rbxassetid://7733960981",
    Settings = "rbxassetid://7734053495",
    Search = "rbxassetid://7734053179",
    Menu = "rbxassetid://7734010621",
    X = "rbxassetid://7743878857",
    Minus = "rbxassetid://7734014722",
    ChevronRight = "rbxassetid://7734010902",
    ChevronDown = "rbxassetid://7733714795",
    ChevronUp = "rbxassetid://7734010796",
    Check = "rbxassetid://7733715628",
    
    -- Features
    Target = "rbxassetid://7734056071",
    Eye = "rbxassetid://7733976782",
    EyeOff = "rbxassetid://7733976961",
    Zap = "rbxassetid://7743878969",
    Shield = "rbxassetid://7734053361",
    Sword = "rbxassetid://7734055899",
    Crosshair = "rbxassetid://7733966469",
    
    -- System
    User = "rbxassetid://7743878656",
    Users = "rbxassetid://7743878731",
    Monitor = "rbxassetid://7734014873",
    Wifi = "rbxassetid://7743878802",
    Clock = "rbxassetid://7733715400",
    Calendar = "rbxassetid://7733715178",
    
    -- Actions
    Play = "rbxassetid://7734038061",
    Pause = "rbxassetid://7734036394",
    RefreshCw = "rbxassetid://7734042917",
    Download = "rbxassetid://7733966671",
    Upload = "rbxassetid://7743878587",
    Copy = "rbxassetid://7733966279",
    Clipboard = "rbxassetid://7733715506",
    
    -- Status
    Info = "rbxassetid://7734010387",
    AlertCircle = "rbxassetid://7733714043",
    AlertTriangle = "rbxassetid://7733714177",
    CheckCircle = "rbxassetid://7733715628",
    XCircle = "rbxassetid://7743878914",
    
    -- Misc
    Star = "rbxassetid://7734054710",
    Heart = "rbxassetid://7733997981",
    Flag = "rbxassetid://7733989498",
    Folder = "rbxassetid://7733989724",
    File = "rbxassetid://7733977985",
    Code = "rbxassetid://7733966043",
    Terminal = "rbxassetid://7734056133",
    Key = "rbxassetid://7734010475",
    Lock = "rbxassetid://7734010838",
    Unlock = "rbxassetid://7743878539",
    Link = "rbxassetid://7734010671",
    ExternalLink = "rbxassetid://7733977735",
    Globe = "rbxassetid://7733993197",
    MessageCircle = "rbxassetid://7734014650",
    Send = "rbxassetid://7734053090",
    Crown = "rbxassetid://7733966361",
    Gift = "rbxassetid://7733993014",
    Sparkles = "rbxassetid://7734054355",
    Gamepad = "rbxassetid://7733989869",
    
    -- Arrows
    ArrowRight = "rbxassetid://7733714465",
    ArrowLeft = "rbxassetid://7733714329",
    ArrowUp = "rbxassetid://7733714597",
    ArrowDown = "rbxassetid://7733714261"
}

-- Theme Configuration
local Theme = {
    Background = Color3.fromRGB(12, 14, 24),
    Secondary = Color3.fromRGB(18, 22, 36),
    Tertiary = Color3.fromRGB(25, 30, 48),
    Elevated = Color3.fromRGB(35, 42, 65),
    Hover = Color3.fromRGB(45, 55, 85),
    Active = Color3.fromRGB(55, 68, 100),
    
    Primary = Color3.fromRGB(100, 180, 255),
    PrimaryDark = Color3.fromRGB(70, 150, 230),
    PrimaryLight = Color3.fromRGB(140, 200, 255),
    PrimaryGlow = Color3.fromRGB(100, 180, 255),
    
    Accent = Color3.fromRGB(130, 100, 255),
    AccentLight = Color3.fromRGB(160, 130, 255),
    
    Text = Color3.fromRGB(250, 252, 255),
    TextDark = Color3.fromRGB(180, 190, 210),
    TextMuted = Color3.fromRGB(100, 115, 145),
    
    Success = Color3.fromRGB(50, 215, 140),
    Warning = Color3.fromRGB(255, 190, 50),
    Error = Color3.fromRGB(255, 85, 95),
    
    Divider = Color3.fromRGB(50, 60, 90),
    
    KeySystem = Color3.fromRGB(100, 180, 255),
    KeyGradient1 = Color3.fromRGB(80, 160, 255),
    KeyGradient2 = Color3.fromRGB(120, 100, 255)
}

-- Utility Functions
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(obj, props, dur, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function Corner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function Padding(parent, t, l, r, b)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        PaddingBottom = UDim.new(0, b or 0),
        Parent = parent
    })
end

local function Stroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Theme.Divider,
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        Parent = parent
    })
end

local function CreateIcon(parent, iconId, size, pos, color)
    local icon = Create("ImageLabel", {
        Image = type(iconId) == "string" and (Icons[iconId] or iconId) or Icons.Folder,
        ImageColor3 = color or Theme.TextDark,
        BackgroundTransparency = 1,
        Size = size or UDim2.new(0, 18, 0, 18),
        Position = pos or UDim2.new(0, 0, 0.5, -9),
        AnchorPoint = Vector2.new(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = parent
    })
    return icon
end

local function AddGlow(parent, color, size)
    local glow = Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = color or Theme.PrimaryGlow,
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, size or 30, 1, size or 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Parent = parent
    })
    return glow
end

local function MakeDraggable(drag, target)
    local dragging, dragStart, startPos = false, nil, nil
    
    drag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
        end
    end)
    
    drag.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Tween(target, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.04)
        end
    end)
end

-- Key System Validation
local KeyDatabase = {}

local function ValidateKey(key, database)
    database = database or KeyDatabase
    local keyData = database[key]
    if not keyData then
        return false, "Invalid key"
    end
    
    if keyData.expiry == "lifetime" then
        return true, "lifetime", keyData.type or "admin"
    end
    
    if os.time() > keyData.expiry then
        return false, "Key expired"
    end
    
    local remaining = keyData.expiry - os.time()
    return true, remaining, keyData.type or "daily"
end

local function FormatTime(seconds)
    if seconds == "lifetime" then
        return "Lifetime"
    end
    
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    
    if days > 0 then
        return string.format("%dd %dh %dm", days, hours, minutes)
    elseif hours > 0 then
        return string.format("%dh %dm", hours, minutes)
    else
        return string.format("%dm", minutes)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- KEY SYSTEM / LOADER
-- ═══════════════════════════════════════════════════════════════

function Stellar:CreateLoader(config)
    config = config or {}
    local Title = config.Title or "Stellar Hub"
    local Logo = config.Logo or "rbxassetid://18824089198"
    local GetKeyLink = config.GetKeyLink or "https://example.com/getkey"
    local Keys = config.Keys or {}
    local OnSuccess = config.OnSuccess or function() end
    local Games = config.Games or {}
    local SaveKey = config.SaveKey ~= false
    local Discord = config.Discord or "discord.gg/stellarhub"
    
    -- Merge provided keys
    for k, v in pairs(Keys) do
        KeyDatabase[k] = v
    end
    
    if CoreGui:FindFirstChild("StellarLoader") then
        CoreGui.StellarLoader:Destroy()
    end
    
    local ScreenGui = Create("ScreenGui", {
        Name = "StellarLoader",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Parent = CoreGui
    })
    
    -- Background overlay
    local Overlay = Create("Frame", {
        Name = "Overlay",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.35,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = ScreenGui
    })
    
    -- Main loader frame
    local LoaderFrame = Create("Frame", {
        Name = "Loader",
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    Corner(LoaderFrame, 16)
    
    -- Glow effect
    local LoaderGlow = AddGlow(LoaderFrame, Theme.Primary, 50)
    LoaderGlow.ImageTransparency = 0.75
    
    -- Border stroke
    local LoaderStroke = Stroke(LoaderFrame, Theme.Primary, 1.5, 0.6)
    
    -- Animate in
    Tween(LoaderFrame, {Size = UDim2.new(0, 400, 0, 480)}, 0.5, Enum.EasingStyle.Back)
    
    -- Header section with gradient
    local Header = Create("Frame", {
        Name = "Header",
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 130),
        Parent = LoaderFrame
    })
    Corner(Header, 16)
    
    -- Bottom cover for header
    Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -20),
        BorderSizePixel = 0,
        Parent = Header
    })
    
    -- Gradient overlay on header
    local HeaderGradient = Create("Frame", {
        BackgroundColor3 = Theme.Primary,
        BackgroundTransparency = 0.9,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = Header
    })
    Corner(HeaderGradient, 16)
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.KeyGradient1),
            ColorSequenceKeypoint.new(1, Theme.KeyGradient2)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(1, 0.95)
        }),
        Rotation = 45,
        Parent = HeaderGradient
    })
    
    -- Decorative circles
    local Circle1 = Create("Frame", {
        BackgroundColor3 = Theme.Primary,
        BackgroundTransparency = 0.9,
        Size = UDim2.new(0, 140, 0, 140),
        Position = UDim2.new(1, -35, 0, -35),
        Parent = Header
    })
    Corner(Circle1, 70)
    
    local Circle2 = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.92,
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0, -25, 1, -25),
        Parent = Header
    })
    Corner(Circle2, 40)
    
    -- Logo container
    local LogoContainer = Create("Frame", {
        Name = "LogoContainer",
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(0, 64, 0, 64),
        Position = UDim2.new(0.5, 0, 0, 18),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = Header
    })
    Corner(LogoContainer, 32)
    Stroke(LogoContainer, Theme.Primary, 2, 0.4)
    AddGlow(LogoContainer, Theme.Primary, 18)
    
    local LogoImage = Create("ImageLabel", {
        Image = Logo,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = LogoContainer
    })
    
    -- Title on right side
    local TitleLabel = Create("TextLabel", {
        Text = Title,
        Font = Enum.Font.GothamBlack,
        TextColor3 = Theme.Text,
        TextSize = 22,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 92),
        Size = UDim2.new(1, -40, 0, 26),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = Header
    })
    
    -- Status bar
    local StatusBar = Create("Frame", {
        Name = "Status",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, -48, 0, 42),
        Position = UDim2.new(0.5, 0, 0, 145),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = LoaderFrame
    })
    Corner(StatusBar, 10)
    
    local StatusIndicator = Create("Frame", {
        BackgroundColor3 = Theme.Warning,
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(0, 14, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = StatusBar
    })
    Corner(StatusIndicator, 4)
    
    local StatusText = Create("TextLabel", {
        Text = "Enter your license key to continue",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.TextDark,
        TextSize = 12,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 32, 0, 0),
        Size = UDim2.new(1, -100, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = StatusBar
    })
    
    local TimeRemaining = Create("TextLabel", {
        Text = "",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Primary,
        TextSize = 11,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.new(0, 80, 0, 16),
        AnchorPoint = Vector2.new(1, 0.5),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = StatusBar
    })
    
    -- Key input label
    Create("TextLabel", {
        Text = "LICENSE KEY",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 24, 0, 200),
        Size = UDim2.new(1, -48, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = LoaderFrame
    })
    
    -- Key input container
    local KeyInputContainer = Create("Frame", {
        Name = "KeyInput",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, -48, 0, 48),
        Position = UDim2.new(0.5, 0, 0, 218),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = LoaderFrame
    })
    Corner(KeyInputContainer, 10)
    local KeyInputStroke = Stroke(KeyInputContainer, Theme.Divider, 1, 0.5)
    
    local KeyIcon = CreateIcon(KeyInputContainer, "Key", UDim2.new(0, 18, 0, 18), UDim2.new(0, 14, 0.5, 0), Theme.TextMuted)
    
    local KeyInput = Create("TextBox", {
        Name = "Input",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 42, 0, 0),
        Text = "",
        PlaceholderText = "Enter your license key...",
        PlaceholderColor3 = Theme.TextMuted,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = KeyInputContainer
    })
    
    -- Focus effects
    KeyInput.Focused:Connect(function()
        Tween(KeyInputContainer, {BackgroundColor3 = Theme.Elevated}, 0.15)
        KeyInputStroke.Color = Theme.Primary
        KeyInputStroke.Transparency = 0.3
    end)
    
    KeyInput.FocusLost:Connect(function()
        Tween(KeyInputContainer, {BackgroundColor3 = Theme.Tertiary}, 0.15)
        KeyInputStroke.Color = Theme.Divider
        KeyInputStroke.Transparency = 0.5
    end)
    
    -- Validate button
    local ValidateBtn = Create("TextButton", {
        Name = "Validate",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(1, -48, 0, 46),
        Position = UDim2.new(0.5, 0, 0, 280),
        AnchorPoint = Vector2.new(0.5, 0),
        Text = "",
        AutoButtonColor = false,
        Parent = LoaderFrame
    })
    Corner(ValidateBtn, 10)
    AddGlow(ValidateBtn, Theme.Primary, 12)
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.KeyGradient1),
            ColorSequenceKeypoint.new(1, Theme.KeyGradient2)
        }),
        Rotation = 90,
        Parent = ValidateBtn
    })
    
    local ValidateIcon = CreateIcon(ValidateBtn, "Check", UDim2.new(0, 16, 0, 16), UDim2.new(0.5, -50, 0.5, 0), Theme.Text)
    
    local ValidateBtnText = Create("TextLabel", {
        Text = "VALIDATE KEY",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextSize = 13,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -28, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ValidateBtn
    })
    
    -- Get Key button
    local GetKeyBtn = Create("TextButton", {
        Name = "GetKey",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, -48, 0, 40),
        Position = UDim2.new(0.5, 0, 0, 338),
        AnchorPoint = Vector2.new(0.5, 0),
        Text = "",
        AutoButtonColor = false,
        Parent = LoaderFrame
    })
    Corner(GetKeyBtn, 10)
    Stroke(GetKeyBtn, Theme.Primary, 1, 0.6)
    
    local GetKeyIcon = CreateIcon(GetKeyBtn, "Link", UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -45, 0.5, 0), Theme.Primary)
    
    Create("TextLabel", {
        Text = "Get a Key",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Primary,
        TextSize = 12,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -22, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = GetKeyBtn
    })
    
    -- Bottom buttons row
    local BottomRow = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -48, 0, 38),
        Position = UDim2.new(0.5, 0, 0, 390),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = LoaderFrame
    })
    
    -- Discord button
    local DiscordBtn = Create("TextButton", {
        Name = "Discord",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = "",
        AutoButtonColor = false,
        Parent = BottomRow
    })
    Corner(DiscordBtn, 8)
    
    local DiscordIcon = CreateIcon(DiscordBtn, "MessageCircle", UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -40, 0.5, 0), Theme.TextDark)
    
    Create("TextLabel", {
        Text = "Discord",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.TextDark,
        TextSize = 11,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -18, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = DiscordBtn
    })
    
    -- Copy HWID button
    local HWIDBtn = Create("TextButton", {
        Name = "HWID",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0.52, 0, 0, 0),
        Text = "",
        AutoButtonColor = false,
        Parent = BottomRow
    })
    Corner(HWIDBtn, 8)
    
    local HWIDIcon = CreateIcon(HWIDBtn, "Copy", UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -45, 0.5, 0), Theme.TextDark)
    
    local HWIDText = Create("TextLabel", {
        Text = "Copy HWID",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.TextDark,
        TextSize = 11,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -23, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = HWIDBtn
    })
    
    -- Game indicator
    local currentGame = Games[game.PlaceId] or "Universal"
    local GameIndicator = Create("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, -48, 0, 32),
        Position = UDim2.new(0.5, 0, 1, -70),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = LoaderFrame
    })
    Corner(GameIndicator, 8)
    
    local GameIcon = CreateIcon(GameIndicator, "Gamepad", UDim2.new(0, 14, 0, 14), UDim2.new(0, 12, 0.5, 0), Theme.Primary)
    
    Create("TextLabel", {
        Text = currentGame,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Primary,
        TextSize = 11,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 34, 0, 0),
        Size = UDim2.new(1, -46, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = GameIndicator
    })
    
    -- Footer
    Create("TextLabel", {
        Text = "Powered by Stellar Hub • v6.0",
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 1, -28),
        Size = UDim2.new(1, 0, 0, 18),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = LoaderFrame
    })
    
    -- Button hover effects
    local function SetupHover(btn, hoverColor)
        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = hoverColor or Theme.Elevated}, 0.12)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = Theme.Tertiary}, 0.12)
        end)
    end
    
    SetupHover(GetKeyBtn, Theme.Elevated)
    SetupHover(DiscordBtn, Theme.Elevated)
    SetupHover(HWIDBtn, Theme.Elevated)
    
    ValidateBtn.MouseEnter:Connect(function()
        Tween(ValidateBtn, {Size = UDim2.new(1, -44, 0, 48)}, 0.12, Enum.EasingStyle.Back)
    end)
    ValidateBtn.MouseLeave:Connect(function()
        Tween(ValidateBtn, {Size = UDim2.new(1, -48, 0, 46)}, 0.12)
    end)
    
    -- Button actions
    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(GetKeyLink)
        end
        StatusText.Text = "Key link copied to clipboard!"
        StatusIndicator.BackgroundColor3 = Theme.Primary
        task.wait(2)
        StatusText.Text = "Enter your license key to continue"
        StatusIndicator.BackgroundColor3 = Theme.Warning
    end)
    
    HWIDBtn.MouseButton1Click:Connect(function()
        local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        if setclipboard then
            setclipboard(hwid)
        end
        HWIDText.Text = "Copied!"
        HWIDIcon.Image = Icons.Check
        HWIDIcon.ImageColor3 = Theme.Success
        task.wait(1.5)
        HWIDText.Text = "Copy HWID"
        HWIDIcon.Image = Icons.Copy
        HWIDIcon.ImageColor3 = Theme.TextDark
    end)
    
    DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(Discord)
        end
        DiscordIcon.Image = Icons.Check
        DiscordIcon.ImageColor3 = Theme.Success
        task.wait(1)
        DiscordIcon.Image = Icons.MessageCircle
        DiscordIcon.ImageColor3 = Theme.TextDark
    end)
    
    -- Validation logic
    local function ShowSuccess(timeRemaining, keyType)
        StatusIndicator.BackgroundColor3 = Theme.Success
        StatusText.Text = keyType == "admin" and "Admin Access Granted" or "Key Validated Successfully"
        TimeRemaining.Text = FormatTime(timeRemaining)
        
        ValidateBtnText.Text = "SUCCESS"
        ValidateIcon.Image = Icons.CheckCircle
        
        -- Color change
        Tween(ValidateBtn, {BackgroundColor3 = Theme.Success}, 0.2)
        
        task.wait(1)
        
        -- Animate out
        Tween(LoaderFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(Overlay, {BackgroundTransparency = 1}, 0.4)
        
        task.wait(0.5)
        ScreenGui:Destroy()
        
        OnSuccess()
    end
    
    local function ShowError(message)
        StatusIndicator.BackgroundColor3 = Theme.Error
        StatusText.Text = message
        
        -- Shake effect
        local originalPos = KeyInputContainer.Position
        for i = 1, 3 do
            Tween(KeyInputContainer, {Position = UDim2.new(0.52, 0, 0, 218)}, 0.04)
            task.wait(0.04)
            Tween(KeyInputContainer, {Position = UDim2.new(0.48, 0, 0, 218)}, 0.04)
            task.wait(0.04)
        end
        Tween(KeyInputContainer, {Position = originalPos}, 0.04)
        
        KeyInputStroke.Color = Theme.Error
        KeyInputStroke.Transparency = 0.3
        
        task.wait(1.5)
        
        KeyInputStroke.Color = Theme.Divider
        KeyInputStroke.Transparency = 0.5
        StatusIndicator.BackgroundColor3 = Theme.Warning
        StatusText.Text = "Enter your license key to continue"
    end
    
    ValidateBtn.MouseButton1Click:Connect(function()
        local key = KeyInput.Text
        
        if key == "" then
            ShowError("Please enter a key")
            return
        end
        
        ValidateBtnText.Text = "VALIDATING..."
        ValidateIcon.Image = Icons.RefreshCw
        
        -- Spin animation
        local spinning = true
        task.spawn(function()
            while spinning do
                ValidateIcon.Rotation = ValidateIcon.Rotation + 10
                task.wait()
            end
        end)
        
        task.wait(0.5)
        spinning = false
        ValidateIcon.Rotation = 0
        
        local valid, timeOrError, keyType = ValidateKey(key)
        
        if valid then
            if SaveKey and writefile then
                writefile("StellarKey.txt", key)
            end
            ShowSuccess(timeOrError, keyType)
        else
            ValidateBtnText.Text = "VALIDATE KEY"
            ValidateIcon.Image = Icons.Check
            ShowError(timeOrError)
        end
    end)
    
    -- Check for saved key
    if SaveKey and readfile and isfile and isfile("StellarKey.txt") then
        local savedKey = readfile("StellarKey.txt")
        KeyInput.Text = savedKey
        
        local valid, timeOrError, keyType = ValidateKey(savedKey)
        if valid then
            StatusText.Text = "Saved key found, validating..."
            StatusIndicator.BackgroundColor3 = Theme.Primary
            task.wait(0.5)
            ShowSuccess(timeOrError, keyType)
        end
    end
    
    return {
        SetStatus = function(text, color)
            StatusText.Text = text
            StatusIndicator.BackgroundColor3 = color or Theme.Warning
        end,
        Close = function()
            Tween(LoaderFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            Tween(Overlay, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.35)
            ScreenGui:Destroy()
        end
    }
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN WINDOW
-- ═══════════════════════════════════════════════════════════════

function Stellar:CreateWindow(config)
    config = config or {}
    local WindowTitle = config.Title or "Stellar Hub"
    local WindowSubtitle = config.Subtitle or "v6.0"
    local WindowLogo = config.Logo or "rbxassetid://18824089198"
    local WindowSize = config.Size or UDim2.new(0, 880, 0, 520)
    local ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    local SearchEnabled = config.Search ~= false
    local ShowDashboard = config.Dashboard ~= false
    
    -- Error tracking
    local Errors = {}
    local HasErrors = false
    
    if CoreGui:FindFirstChild("StellarHub") then
        CoreGui.StellarHub:Destroy()
    end
    
    local ScreenGui = Create("ScreenGui", {
        Name = "StellarHub",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Parent = CoreGui
    })
    
    local Minimized = false
    local CurrentTab = nil
    local Tabs = {}
    local Pages = {}
    local AllElements = {}
    local AllTabButtons = {}
    
    -- Main frame
    local MainFrame = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Theme.Background,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    Corner(MainFrame, 14)
    
    -- Shadow
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.45,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 55, 1, 55),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Parent = MainFrame
    })
    
    -- Animate in
    Tween(MainFrame, {Size = WindowSize}, 0.5, Enum.EasingStyle.Back)
    
    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(0, 195, 1, 0),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    Corner(Sidebar, 14)
    
    -- Fix sidebar corner
    Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(0, 16, 1, 0),
        Position = UDim2.new(1, -16, 0, 0),
        BorderSizePixel = 0,
        Parent = Sidebar
    })
    
    -- Sidebar divider
    Create("Frame", {
        BackgroundColor3 = Theme.Divider,
        BackgroundTransparency = 0.4,
        Size = UDim2.new(0, 1, 1, -28),
        Position = UDim2.new(1, 0, 0, 14),
        BorderSizePixel = 0,
        Parent = Sidebar
    })
    
    -- Header
    local Header = Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 62),
        Parent = Sidebar
    })
    MakeDraggable(Header, MainFrame)
    
    -- Logo
    local LogoContainer = Create("Frame", {
        Name = "Logo",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(0, 14, 0, 12),
        Parent = Header
    })
    Corner(LogoContainer, 10)
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.KeyGradient1),
            ColorSequenceKeypoint.new(1, Theme.KeyGradient2)
        }),
        Rotation = 45,
        Parent = LogoContainer
    })
    
    local LogoIcon = Create("ImageLabel", {
        Image = WindowLogo,
        ImageColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = LogoContainer
    })
    
    -- Title
    Create("TextLabel", {
        Text = WindowTitle,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextSize = 14,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 60, 0, 14),
        Size = UDim2.new(1, -68, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    Create("TextLabel", {
        Text = WindowSubtitle,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 60, 0, 32),
        Size = UDim2.new(1, -68, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    local SearchYOffset = 66
    local SearchContainer, SearchBox, SearchResults
    
    if SearchEnabled then
        SearchContainer = Create("Frame", {
            Name = "Search",
            BackgroundColor3 = Theme.Tertiary,
            Size = UDim2.new(1, -26, 0, 32),
            Position = UDim2.new(0, 13, 0, SearchYOffset),
            Parent = Sidebar
        })
        Corner(SearchContainer, 8)
        
        local SearchIcon = CreateIcon(SearchContainer, "Search", UDim2.new(0, 14, 0, 14), UDim2.new(0, 10, 0.5, 0), Theme.TextMuted)
        
        SearchBox = Create("TextBox", {
            Name = "SearchInput",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -35, 1, 0),
            Position = UDim2.new(0, 28, 0, 0),
            Text = "",
            PlaceholderText = "Search features...",
            PlaceholderColor3 = Theme.TextMuted,
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.Text,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            Parent = SearchContainer
        })
        
        -- Search results dropdown
        SearchResults = Create("Frame", {
            Name = "SearchResults",
            BackgroundColor3 = Theme.Tertiary,
            Size = UDim2.new(1, -26, 0, 0),
            Position = UDim2.new(0, 13, 0, SearchYOffset + 36),
            ClipsDescendants = true,
            Visible = false,
            ZIndex = 20,
            Parent = Sidebar
        })
        Corner(SearchResults, 8)
        Stroke(SearchResults, Theme.Primary, 1, 0.5)
        
        local ResultsScroll = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Primary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ZIndex = 21,
            Parent = SearchResults
        })
        Padding(ResultsScroll, 5, 5, 5, 5)
        
        local ResultsLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 3),
            Parent = ResultsScroll
        })
        
        -- No results
        local NoResults = Create("Frame", {
            Name = "NoResults",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 45),
            Visible = false,
            ZIndex = 22,
            Parent = ResultsScroll
        })
        
        local SadIcon = CreateIcon(NoResults, "AlertCircle", UDim2.new(0, 20, 0, 20), UDim2.new(0.5, -40, 0.5, 0), Theme.TextMuted)
        SadIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        
        Create("TextLabel", {
            Text = "Nothing found",
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.TextMuted,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -18, 0.5, 0),
            Size = UDim2.new(0.6, 0, 0, 16),
            AnchorPoint = Vector2.new(0, 0.5),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 23,
            Parent = NoResults
        })
        
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local searchText = string.lower(SearchBox.Text)
            
            -- Clear previous results
            for _, child in pairs(ResultsScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            if searchText == "" then
                SearchResults.Visible = false
                Tween(SearchResults, {Size = UDim2.new(1, -26, 0, 0)}, 0.15)
                return
            end
            
            local results = {}
            for _, element in pairs(AllElements) do
                if string.find(string.lower(element.Name), searchText) then
                    table.insert(results, element)
                end
            end
            
            if #results == 0 then
                NoResults.Visible = true
                SearchResults.Visible = true
                Tween(SearchResults, {Size = UDim2.new(1, -26, 0, 55)}, 0.2)
            else
                NoResults.Visible = false
                SearchResults.Visible = true
                
                local height = math.min(#results * 34 + 10, 160)
                Tween(SearchResults, {Size = UDim2.new(1, -26, 0, height)}, 0.2)
                
                for i, element in ipairs(results) do
                    if i > 5 then break end
                    
                    local ResultBtn = Create("TextButton", {
                        BackgroundColor3 = Theme.Elevated,
                        BackgroundTransparency = 0.6,
                        Size = UDim2.new(1, 0, 0, 30),
                        Text = "",
                        AutoButtonColor = false,
                        LayoutOrder = i,
                        ZIndex = 24,
                        Parent = ResultsScroll
                    })
                    Corner(ResultBtn, 6)
                    
                    Create("TextLabel", {
                        Text = element.Name,
                        Font = Enum.Font.GothamMedium,
                        TextColor3 = Theme.Text,
                        TextSize = 10,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(1, -55, 1, 0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        ZIndex = 25,
                        Parent = ResultBtn
                    })
                    
                    Create("TextLabel", {
                        Text = element.Tab,
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.Primary,
                        TextSize = 9,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -48, 0, 0),
                        Size = UDim2.new(0, 45, 1, 0),
                        TextXAlignment = Enum.TextXAlignment.Right,
                        ZIndex = 25,
                        Parent = ResultBtn
                    })
                    
                    ResultBtn.MouseEnter:Connect(function()
                        Tween(ResultBtn, {BackgroundTransparency = 0.3}, 0.1)
                    end)
                    ResultBtn.MouseLeave:Connect(function()
                        Tween(ResultBtn, {BackgroundTransparency = 0.6}, 0.1)
                    end)
                    ResultBtn.MouseButton1Click:Connect(function()
                        -- Switch to element's tab
                        if Tabs[element.Tab] then
                            for name, data in pairs(Tabs) do
                                Tween(data.Button, {BackgroundTransparency = 1}, 0.12)
                                Tween(data.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.12)
                                Tween(data.Icon, {ImageColor3 = Theme.TextMuted}, 0.12)
                                Tween(data.Label, {TextColor3 = Theme.TextDark}, 0.12)
                            end
                            
                            for _, page in pairs(Pages) do
                                page.Visible = false
                            end
                            
                            local data = Tabs[element.Tab]
                            Tween(data.Button, {BackgroundTransparency = 0.88}, 0.12)
                            Tween(data.Indicator, {Size = UDim2.new(0, 3, 0, 16)}, 0.15, Enum.EasingStyle.Back)
                            Tween(data.Icon, {ImageColor3 = Theme.Primary}, 0.12)
                            Tween(data.Label, {TextColor3 = Theme.Text}, 0.12)
                            
                            if Pages[element.Tab] then
                                Pages[element.Tab].Visible = true
                            end
                            
                            SearchBox.Text = ""
                            SearchResults.Visible = false
                        end
                    end)
                end
                
                ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, ResultsLayout.AbsoluteContentSize.Y + 10)
            end
        end)
        
        SearchYOffset = SearchYOffset + 40
    end
    
    -- Navigation label
    Create("TextLabel", {
        Text = "NAVIGATION",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMuted,
        TextSize = 9,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, SearchYOffset + 6),
        Size = UDim2.new(1, -28, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Sidebar
    })
    
    -- Tab container
    local TabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -(SearchYOffset + 78)),
        Position = UDim2.new(0, 0, 0, SearchYOffset + 22),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Sidebar
    })
    
    local TabLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = TabContainer
    })
    Padding(TabContainer, 0, 12, 12, 8)
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 16)
    end)
    
    -- User container
    local UserContainer = Create("Frame", {
        Name = "User",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, -24, 0, 40),
        Position = UDim2.new(0, 12, 1, -52),
        Parent = Sidebar
    })
    Corner(UserContainer, 8)
    
    local UserAvatar = Create("ImageLabel", {
        Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100),
        BackgroundColor3 = Theme.Elevated,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 6, 0.5, -14),
        Parent = UserContainer
    })
    Corner(UserAvatar, 14)
    
    Create("TextLabel", {
        Text = Player.DisplayName,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextSize = 11,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 40, 0, 6),
        Size = UDim2.new(1, -48, 0, 13),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = UserContainer
    })
    
    Create("TextLabel", {
        Text = "@" .. Player.Name,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextMuted,
        TextSize = 9,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 40, 0, 21),
        Size = UDim2.new(1, -48, 0, 11),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = UserContainer
    })
    
    -- Content area
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -195, 1, 0),
        Position = UDim2.new(0, 195, 0, 0),
        Parent = MainFrame
    })
    
    -- Top bar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        Parent = Content
    })
    MakeDraggable(TopBar, MainFrame)
    
    local PageTitle = Create("TextLabel", {
        Name = "PageTitle",
        Text = "Dashboard",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextSize = 16,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 13),
        Size = UDim2.new(0.5, 0, 0, 22),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    -- Window controls
    local Controls = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 68, 0, 26),
        Position = UDim2.new(1, -82, 0, 11),
        Parent = TopBar
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
        Parent = Controls
    })
    
    local MinBtn = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0, 26, 0, 26),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    Corner(MinBtn, 7)
    CreateIcon(MinBtn, "Minus", UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -7, 0.5, 0), Theme.TextDark)
    
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0, 26, 0, 26),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    Corner(CloseBtn, 7)
    CreateIcon(CloseBtn, "X", UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -7, 0.5, 0), Theme.TextDark)
    
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = Theme.Elevated}, 0.12) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = Theme.Tertiary}, 0.12) end)
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundColor3 = Theme.Error}, 0.12) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundColor3 = Theme.Tertiary}, 0.12) end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.25)
        ScreenGui:Destroy()
    end)
    
    -- Page container
    local PageContainer = Create("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -48),
        Position = UDim2.new(0, 0, 0, 48),
        ClipsDescendants = true,
        Parent = Content
    })
    
    -- Toggle button
    local ToggleBtn = Create("TextButton", {
        Name = "Toggle",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(0, 48, 0, 48),
        Position = UDim2.new(0, 18, 0.5, -42),
        Text = "",
        AutoButtonColor = false,
        Visible = false,
        Parent = ScreenGui
    })
    Corner(ToggleBtn, 14)
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.KeyGradient1),
            ColorSequenceKeypoint.new(1, Theme.KeyGradient2)
        }),
        Rotation = 45,
        Parent = ToggleBtn
    })
    
    AddGlow(ToggleBtn, Theme.Primary, 22)
    
    local ToggleIcon = Create("ImageLabel", {
        Image = WindowLogo,
        ImageColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = ToggleBtn
    })
    
    ToggleBtn.MouseEnter:Connect(function()
        Tween(ToggleBtn, {Size = UDim2.new(0, 54, 0, 54), Position = UDim2.new(0, 15, 0.5, -45)}, 0.15, Enum.EasingStyle.Back)
    end)
    ToggleBtn.MouseLeave:Connect(function()
        Tween(ToggleBtn, {Size = UDim2.new(0, 48, 0, 48), Position = UDim2.new(0, 18, 0.5, -42)}, 0.12)
    end)
    
    local function Minimize()
        Minimized = true
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.22)
        MainFrame.Visible = false
        ToggleBtn.Visible = true
        ToggleBtn.Size = UDim2.new(0, 0, 0, 0)
        Tween(ToggleBtn, {Size = UDim2.new(0, 48, 0, 48)}, 0.28, Enum.EasingStyle.Back)
    end
    
    local function Maximize()
        Minimized = false
        ToggleBtn.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Tween(MainFrame, {Size = WindowSize}, 0.35, Enum.EasingStyle.Back)
    end
    
    MinBtn.MouseButton1Click:Connect(Minimize)
    ToggleBtn.MouseButton1Click:Connect(Maximize)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == ToggleKey then
            if Minimized then Maximize() else Minimize() end
        end
    end)
    
    -- Error page
    local ErrorPage = Create("Frame", {
        Name = "ErrorPage",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
        Parent = PageContainer
    })
    
    local ErrorContainer = Create("Frame", {
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0, 380, 0, 280),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ErrorPage
    })
    Corner(ErrorContainer, 12)
    Stroke(ErrorContainer, Theme.Error, 2, 0.5)
    
    local ErrorIcon = CreateIcon(ErrorContainer, "AlertTriangle", UDim2.new(0, 50, 0, 50), UDim2.new(0.5, -25, 0, 35), Theme.Error)
    ErrorIcon.AnchorPoint = Vector2.new(0, 0)
    
    Create("TextLabel", {
        Text = "You Messed Up!",
        Font = Enum.Font.GothamBlack,
        TextColor3 = Theme.Error,
        TextSize = 20,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 95),
        Size = UDim2.new(1, -40, 0, 26),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = ErrorContainer
    })
    
    Create("TextLabel", {
        Text = "while Setting Up the UI",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.TextDark,
        TextSize = 13,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 122),
        Size = UDim2.new(1, -40, 0, 18),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = ErrorContainer
    })
    
    local ErrorList = Create("ScrollingFrame", {
        BackgroundColor3 = Theme.Elevated,
        Size = UDim2.new(1, -36, 0, 100),
        Position = UDim2.new(0.5, 0, 0, 152),
        AnchorPoint = Vector2.new(0.5, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Error,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = ErrorContainer
    })
    Corner(ErrorList, 8)
    Padding(ErrorList, 8, 8, 8, 8)
    
    local ErrorListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = ErrorList
    })
    
    local function AddError(msg)
        table.insert(Errors, msg)
    end
    
    local function ShowErrors()
        HasErrors = true
        
        for _, err in ipairs(Errors) do
            Create("TextLabel", {
                Text = "• " .. err,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextDark,
                TextSize = 10,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = ErrorList
            })
        end
        
        ErrorList.CanvasSize = UDim2.new(0, 0, 0, ErrorListLayout.AbsoluteContentSize.Y + 16)
        
        for _, page in pairs(Pages) do
            page.Visible = false
        end
        
        ErrorPage.Visible = true
        PageTitle.Text = "Error"
    end
    
    -- Dashboard
    local function CreateDashboard()
        local DashPage = Create("ScrollingFrame", {
            Name = "Dashboard",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Primary,
            ScrollBarImageTransparency = 0.5,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = true,
            Parent = PageContainer
        })
        Padding(DashPage, 6, 18, 18, 18)
        
        local DashLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = DashPage
        })
        
        DashLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            DashPage.CanvasSize = UDim2.new(0, 0, 0, DashLayout.AbsoluteContentSize.Y + 32)
        end)
        
        -- Banner
        local Banner = Create("Frame", {
            Name = "Banner",
            BackgroundColor3 = Theme.Primary,
            Size = UDim2.new(1, 0, 0, 110),
            LayoutOrder = 1,
            Parent = DashPage
        })
        Corner(Banner, 12)
        
        Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Theme.KeyGradient1),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 120, 240)),
                ColorSequenceKeypoint.new(1, Theme.KeyGradient2)
            }),
            Rotation = 20,
            Parent = Banner
        })
        
        local BannerCircle1 = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.92,
            Size = UDim2.new(0, 160, 0, 160),
            Position = UDim2.new(1, -45, 0, -45),
            Parent = Banner
        })
        Corner(BannerCircle1, 80)
        
        local BannerCircle2 = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.95,
            Size = UDim2.new(0, 90, 0, 90),
            Position = UDim2.new(1, -125, 0, 55),
            Parent = Banner
        })
        Corner(BannerCircle2, 45)
        
        local BannerAvatar = Create("ImageLabel", {
            Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150),
            BackgroundColor3 = Theme.Background,
            Size = UDim2.new(0, 72, 0, 72),
            Position = UDim2.new(0, 18, 0.5, -36),
            Parent = Banner
        })
        Corner(BannerAvatar, 36)
        Stroke(BannerAvatar, Color3.fromRGB(255, 255, 255), 3, 0.3)
        
        Create("TextLabel", {
            Text = "Welcome back,",
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextTransparency = 0.2,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 102, 0, 24),
            Size = UDim2.new(0.5, 0, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Banner
        })
        
        Create("TextLabel", {
            Text = Player.DisplayName,
            Font = Enum.Font.GothamBlack,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 22,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 102, 0, 40),
            Size = UDim2.new(0.5, 0, 0, 26),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Banner
        })
        
        Create("TextLabel", {
            Text = "Ready to dominate!",
            Font = Enum.Font.GothamMedium,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextTransparency = 0.15,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 102, 0, 70),
            Size = UDim2.new(0.5, 0, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Banner
        })
        
        -- Stats row
        local StatsRow = Create("Frame", {
            Name = "Stats",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 75),
            LayoutOrder = 2,
            Parent = DashPage
        })
        
                Create("UIGridLayout", {
            CellSize = UDim2.new(0.245, -7, 1, 0),
            CellPadding = UDim2.new(0, 10, 0, 0),
            Parent = StatsRow
        })
        
        local function CreateStatCard(iconName, title, value, color)
            local Card = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Parent = StatsRow
            })
            Corner(Card, 10)
            
            local IconBg = Create("Frame", {
                BackgroundColor3 = color,
                BackgroundTransparency = 0.85,
                Size = UDim2.new(0, 32, 0, 32),
                Position = UDim2.new(0, 10, 0, 10),
                Parent = Card
            })
            Corner(IconBg, 8)
            
            CreateIcon(IconBg, iconName, UDim2.new(0, 16, 0, 16), UDim2.new(0.5, -8, 0.5, 0), color)
            
            Create("TextLabel", {
                Text = title,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.TextMuted,
                TextSize = 9,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 1, -30),
                Size = UDim2.new(1, -16, 0, 11),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Card
            })
            
            local ValueLabel = Create("TextLabel", {
                Text = value,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Text,
                TextSize = 14,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 1, -17),
                Size = UDim2.new(1, -16, 0, 15),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Card
            })
            
            return ValueLabel
        end
        
        local PingValue = CreateStatCard("Wifi", "PING", "0ms", Theme.Primary)
        local FpsValue = CreateStatCard("Monitor", "FPS", "60", Theme.Success)
        local TimeValue = CreateStatCard("Clock", "TIME", "00:00", Theme.Warning)
        local PlayersValue = CreateStatCard("Users", "PLAYERS", "0", Theme.Error)
        
        -- Update stats
        RunService.RenderStepped:Connect(function(dt)
            local fps = math.floor(1/dt)
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            
            FpsValue.Text = tostring(fps)
            PingValue.Text = ping .. "ms"
            PingValue.TextColor3 = ping > 150 and Theme.Error or (ping > 80 and Theme.Warning or Theme.Text)
        end)
        
        task.spawn(function()
            while MainFrame.Parent do
                TimeValue.Text = os.date("%H:%M")
                PlayersValue.Text = tostring(#Players:GetPlayers())
                task.wait(1)
            end
        end)
        
        -- Info cards row
        local InfoRow = Create("Frame", {
            Name = "Info",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 100),
            LayoutOrder = 3,
            Parent = DashPage
        })
        
        Create("UIGridLayout", {
            CellSize = UDim2.new(0.49, -5, 1, 0),
            CellPadding = UDim2.new(0, 10, 0, 0),
            Parent = InfoRow
        })
        
        -- Library info card
        local LibCard = Create("Frame", {
            Name = "Library",
            BackgroundColor3 = Theme.Tertiary,
            Parent = InfoRow
        })
        Corner(LibCard, 10)
        
        CreateIcon(LibCard, "Code", UDim2.new(0, 14, 0, 14), UDim2.new(0, 12, 0, 14), Theme.Primary)
        
        Create("TextLabel", {
            Text = "Library Info",
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.Text,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 32, 0, 12),
            Size = UDim2.new(1, -40, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        Create("TextLabel", {
            Text = "Version 6.0",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextDark,
            TextSize = 10,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 34),
            Size = UDim2.new(1, -20, 0, 12),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        local StatusIcon = CreateIcon(LibCard, "CheckCircle", UDim2.new(0, 12, 0, 12), UDim2.new(0, 12, 0, 52), Theme.Success)
        StatusIcon.AnchorPoint = Vector2.new(0, 0)
        
        Create("TextLabel", {
            Text = "Undetected",
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.Success,
            TextSize = 10,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 28, 0, 50),
            Size = UDim2.new(1, -36, 0, 12),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        Create("TextLabel", {
            Text = "Updated Today",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextMuted,
            TextSize = 10,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 68),
            Size = UDim2.new(1, -20, 0, 12),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        -- Discord card
        local DiscCard = Create("Frame", {
            Name = "Discord",
            BackgroundColor3 = Theme.Tertiary,
            Parent = InfoRow
        })
        Corner(DiscCard, 10)
        
        CreateIcon(DiscCard, "MessageCircle", UDim2.new(0, 14, 0, 14), UDim2.new(0, 12, 0, 14), Theme.Primary)
        
        Create("TextLabel", {
            Text = "Community",
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.Text,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 32, 0, 12),
            Size = UDim2.new(1, -40, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DiscCard
        })
        
        Create("TextLabel", {
            Text = "Join for updates & support",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextDark,
            TextSize = 10,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 34),
            Size = UDim2.new(1, -20, 0, 12),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DiscCard
        })
        
        local CopyBtn = Create("TextButton", {
            Text = "",
            BackgroundColor3 = Theme.Primary,
            BackgroundTransparency = 0.88,
            Position = UDim2.new(0, 12, 1, -36),
            Size = UDim2.new(1, -24, 0, 26),
            AutoButtonColor = false,
            Parent = DiscCard
        })
        Corner(CopyBtn, 6)
        
        CreateIcon(CopyBtn, "Copy", UDim2.new(0, 12, 0, 12), UDim2.new(0.5, -42, 0.5, 0), Theme.Primary)
        
        Create("TextLabel", {
            Text = "Copy Invite Link",
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.Primary,
            TextSize = 10,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -28, 0, 0),
            Size = UDim2.new(0.6, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = CopyBtn
        })
        
        CopyBtn.MouseEnter:Connect(function()
            Tween(CopyBtn, {BackgroundTransparency = 0.78}, 0.1)
        end)
        CopyBtn.MouseLeave:Connect(function()
            Tween(CopyBtn, {BackgroundTransparency = 0.88}, 0.1)
        end)
        CopyBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard("discord.gg/stellarhub")
            end
        end)
        
        return DashPage
    end
    
    -- Create Dashboard if enabled
    if ShowDashboard then
        local DashboardPage = CreateDashboard()
        Pages["Dashboard"] = DashboardPage
    end
    
    -- Tab button creator
    local function CreateTabButton(name, icon, isHome)
        local Tab = Create("TextButton", {
            Name = name,
            BackgroundColor3 = isHome and Theme.Primary or Theme.Tertiary,
            BackgroundTransparency = isHome and 0.88 or 1,
            Size = UDim2.new(1, 0, 0, 36),
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = isHome and -999 or 0,
            Parent = TabContainer
        })
        Corner(Tab, 8)
        
        local Indicator = Create("Frame", {
            Name = "Indicator",
            BackgroundColor3 = Theme.Primary,
            Size = UDim2.new(0, 3, 0, isHome and 16 or 0),
            Position = UDim2.new(0, 0, 0.5, -8),
            Parent = Tab
        })
        Corner(Indicator, 2)
        
        local TabIcon = CreateIcon(Tab, icon or "Folder", UDim2.new(0, 16, 0, 16), UDim2.new(0, 12, 0.5, 0), isHome and Theme.Primary or Theme.TextMuted)
        
        local TabLabel = Create("TextLabel", {
            Name = "Label",
            Text = name,
            Font = Enum.Font.GothamMedium,
            TextColor3 = isHome and Theme.Text or Theme.TextDark,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 36, 0, 0),
            Size = UDim2.new(1, -44, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Tab
        })
        
        table.insert(AllTabButtons, {Name = name, Button = Tab})
        
        return Tab, Indicator, TabIcon, TabLabel
    end
    
    -- Switch tab function
    local function SwitchTab(tabName)
        for name, data in pairs(Tabs) do
            Tween(data.Button, {BackgroundTransparency = 1}, 0.12)
            Tween(data.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.12)
            Tween(data.Icon, {ImageColor3 = Theme.TextMuted}, 0.12)
            Tween(data.Label, {TextColor3 = Theme.TextDark}, 0.12)
        end
        
        for _, page in pairs(Pages) do
            page.Visible = false
        end
        
        local data = Tabs[tabName]
        if data then
            Tween(data.Button, {BackgroundTransparency = 0.88}, 0.12)
            Tween(data.Indicator, {Size = UDim2.new(0, 3, 0, 16)}, 0.15, Enum.EasingStyle.Back)
            Tween(data.Icon, {ImageColor3 = Theme.Primary}, 0.12)
            Tween(data.Label, {TextColor3 = Theme.Text}, 0.12)
            CurrentTab = data.Button
        end
        
        if Pages[tabName] then
            Pages[tabName].Visible = true
        end
        
        PageTitle.Text = tabName
    end
    
    -- Create Dashboard tab button if enabled
    if ShowDashboard then
        local HomeTab, HomeIndicator, HomeIcon, HomeLabel = CreateTabButton("Dashboard", "Home", true)
        Tabs["Dashboard"] = {Button = HomeTab, Indicator = HomeIndicator, Icon = HomeIcon, Label = HomeLabel}
        CurrentTab = HomeTab
        
        HomeTab.MouseButton1Click:Connect(function()
            SwitchTab("Dashboard")
        end)
        
        HomeTab.MouseEnter:Connect(function()
            if CurrentTab ~= HomeTab then
                Tween(HomeTab, {BackgroundTransparency = 0.92}, 0.1)
            end
        end)
        HomeTab.MouseLeave:Connect(function()
            if CurrentTab ~= HomeTab then
                Tween(HomeTab, {BackgroundTransparency = 1}, 0.1)
            end
        end)
    end
    
    -- Notification container
    local NotifContainer = Create("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 280, 1, -20),
        Position = UDim2.new(1, -290, 0, 10),
        Parent = ScreenGui
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = NotifContainer
    })
    
    -- ═══════════════════════════════════════════════════════════════
    -- WINDOW METHODS
    -- ═══════════════════════════════════════════════════════════════
    
    local Window = {}
    
    function Window:Notify(config)
        config = config or {}
        local Title = config.Title or "Notification"
        local Content = config.Content or config.Message or ""
        local Duration = config.Duration or 3
        local Icon = config.Icon or "Info"
        local Type = config.Type
        
        local TypeColors = {
            Info = Theme.Primary,
            Success = Theme.Success,
            Warning = Theme.Warning,
            Error = Theme.Error
        }
        
        local color = TypeColors[Type] or Theme.Primary
        
        local Notif = Create("Frame", {
            BackgroundColor3 = Theme.Tertiary,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true,
            Parent = NotifContainer
        })
        Corner(Notif, 10)
        Stroke(Notif, color, 1, 0.6)
        
        Create("Frame", {
            BackgroundColor3 = color,
            Size = UDim2.new(0, 4, 1, 0),
            BorderSizePixel = 0,
            Parent = Notif
        })
        
        CreateIcon(Notif, Icon, UDim2.new(0, 16, 0, 16), UDim2.new(0, 16, 0, 14), color)
        
        Create("TextLabel", {
            Text = Title,
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.Text,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 40, 0, 12),
            Size = UDim2.new(1, -52, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Notif
        })
        
        Create("TextLabel", {
            Text = Content,
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextDark,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 40, 0, 30),
            Size = UDim2.new(1, -52, 0, 26),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = Notif
        })
        
        Tween(Notif, {Size = UDim2.new(1, 0, 0, 62)}, 0.25, Enum.EasingStyle.Back)
        
        task.delay(Duration, function()
            Tween(Notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            task.wait(0.2)
            Notif:Destroy()
        end)
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- TAB CREATION (WindUI Style)
    -- ═══════════════════════════════════════════════════════════════
    
    function Window:Tab(config)
        config = config or {}
        local TabName = config.Title or config.Name or "Tab"
        local TabIconName = config.Icon or "Folder"
        local Locked = config.Locked or false
        
        local TabBtn, TabIndicator, TabIconImg, TabLabelText = CreateTabButton(TabName, TabIconName, false)
        Tabs[TabName] = {Button = TabBtn, Indicator = TabIndicator, Icon = TabIconImg, Label = TabLabelText}
        
        local Page = Create("ScrollingFrame", {
            Name = TabName,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Primary,
            ScrollBarImageTransparency = 0.5,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = PageContainer
        })
        Padding(Page, 6, 18, 18, 18)
        
        local PageLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = Page
        })
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 32)
        end)
        
        Pages[TabName] = Page
        
        -- Select first tab if no dashboard
        if not ShowDashboard and not CurrentTab then
            SwitchTab(TabName)
        end
        
        TabBtn.MouseButton1Click:Connect(function()
            if not Locked then
                SwitchTab(TabName)
            end
        end)
        
        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= TabBtn then
                Tween(TabBtn, {BackgroundTransparency = 0.92}, 0.1)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= TabBtn then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.1)
            end
        end)
        
        -- ═══════════════════════════════════════════════════════════════
        -- TAB METHODS
        -- ═══════════════════════════════════════════════════════════════
        
        local Tab = {}
        
        -- Section with optional box
        function Tab:Section(config)
            config = config or {}
            if type(config) == "string" then
                config = {Title = config}
            end
            
            local SectionTitle = config.Title or "Section"
            local SectionIcon = config.Icon
            local IsBox = config.Box or false
            local Opened = config.Opened ~= false
            
            if IsBox then
                -- Collapsible box section
                local SectionFrame = Create("Frame", {
                    Name = SectionTitle,
                    BackgroundColor3 = Theme.Tertiary,
                    Size = UDim2.new(1, 0, 0, 38),
                    ClipsDescendants = true,
                    Parent = Page
                })
                Corner(SectionFrame, 10)
                
                local SectionHeader = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 38),
                    Text = "",
                    Parent = SectionFrame
                })
                
                if SectionIcon then
                    CreateIcon(SectionHeader, SectionIcon, UDim2.new(0, 14, 0, 14), UDim2.new(0, 14, 0.5, 0), Theme.Primary)
                end
                
                Create("TextLabel", {
                    Text = SectionTitle,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, SectionIcon and 36 or 14, 0, 0),
                    Size = UDim2.new(1, -60, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SectionHeader
                })
                
                local Arrow = CreateIcon(SectionHeader, "ChevronDown", UDim2.new(0, 14, 0, 14), UDim2.new(1, -26, 0.5, 0), Theme.TextMuted)
                
                local SectionContent = Create("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 42),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = SectionFrame
                })
                Padding(SectionContent, 0, 10, 10, 10)
                
                local ContentLayout = Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6),
                    Parent = SectionContent
                })
                
                local function UpdateSize()
                    local contentHeight = ContentLayout.AbsoluteContentSize.Y + 20
                    local targetHeight = Opened and (38 + contentHeight) or 38
                    Tween(SectionFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.2)
                    Tween(Arrow, {Rotation = Opened and 180 or 0}, 0.2)
                end
                
                ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)
                
                SectionHeader.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    UpdateSize()
                end)
                
                -- Return section builder
                local Section = {}
                
                function Section:Button(cfg)
                    return Tab:_CreateButton(cfg, SectionContent)
                end
                
                function Section:Toggle(cfg)
                    return Tab:_CreateToggle(cfg, SectionContent)
                end
                
                function Section:Slider(cfg)
                    return Tab:_CreateSlider(cfg, SectionContent)
                end
                
                function Section:Dropdown(cfg)
                    return Tab:_CreateDropdown(cfg, SectionContent)
                end
                
                function Section:Input(cfg)
                    return Tab:_CreateInput(cfg, SectionContent)
                end
                
                function Section:Keybind(cfg)
                    return Tab:_CreateKeybind(cfg, SectionContent)
                end
                
                function Section:Paragraph(cfg)
                    return Tab:_CreateParagraph(cfg, SectionContent)
                end
                
                if Opened then
                    task.defer(UpdateSize)
                end
                
                return Section
            else
                -- Simple section divider
                local Section = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 24),
                    Parent = Page
                })
                
                if SectionIcon then
                    CreateIcon(Section, SectionIcon, UDim2.new(0, 12, 0, 12), UDim2.new(0, 0, 0.5, 0), Theme.Primary)
                end
                
                local SectionLabel = Create("TextLabel", {
                    Text = string.upper(SectionTitle),
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Primary,
                    TextSize = 10,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, SectionIcon and 18 or 0, 0.5, -6),
                    Size = UDim2.new(0, 0, 0, 12),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Parent = Section
                })
                
                local Line = Create("Frame", {
                    BackgroundColor3 = Theme.Divider,
                    BackgroundTransparency = 0.4,
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    Parent = Section
                })
                
                task.defer(function()
                    local offset = SectionLabel.AbsoluteSize.X + (SectionIcon and 26 or 8)
                    Line.Position = UDim2.new(0, offset, 0.5, 0)
                    Line.Size = UDim2.new(1, -offset, 0, 1)
                end)
            end
        end
        
        -- Internal element creators
        function Tab:_CreateButton(config, parent)
            config = config or {}
            local Name = config.Title or config.Name or "Button"
            local Callback = config.Callback or function() end
            
            -- Track for search
            table.insert(AllElements, {Name = Name, Tab = TabName, Type = "Button"})
            
            local Button = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 38),
                Text = "",
                AutoButtonColor = false,
                Parent = parent or Page
            })
            Corner(Button, 8)
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -48, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button
            })
            
            local Arrow = CreateIcon(Button, "ChevronRight", UDim2.new(0, 14, 0, 14), UDim2.new(1, -26, 0.5, 0), Theme.Primary)
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Elevated}, 0.1)
                Tween(Arrow, {Position = UDim2.new(1, -22, 0.5, -7)}, 0.1)
            end)
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Tertiary}, 0.1)
                Tween(Arrow, {Position = UDim2.new(1, -26, 0.5, -7)}, 0.1)
            end)
            Button.MouseButton1Click:Connect(function()
                pcall(Callback)
            end)
        end
        
        function Tab:_CreateToggle(config, parent)
            config = config or {}
            local Name = config.Title or config.Name or "Toggle"
            local Default = config.Default or config.Value or false
            local Callback = config.Callback or function() end
            
            table.insert(AllElements, {Name = Name, Tab = TabName, Type = "Toggle"})
            
            local Toggled = Default
            
            local ToggleFrame = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 38),
                Text = "",
                AutoButtonColor = false,
                Parent = parent or Page
            })
            Corner(ToggleFrame, 8)
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -62, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            local SwitchBg = Create("Frame", {
                BackgroundColor3 = Toggled and Theme.Primary or Theme.Elevated,
                Size = UDim2.new(0, 38, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                Parent = ToggleFrame
            })
            Corner(SwitchBg, 10)
            
            local SwitchDot = Create("Frame", {
                BackgroundColor3 = Theme.Text,
                Size = UDim2.new(0, 14, 0, 14),
                Position = Toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                Parent = SwitchBg
            })
            Corner(SwitchDot, 7)
            
            local function Update()
                if Toggled then
                    Tween(SwitchBg, {BackgroundColor3 = Theme.Primary}, 0.15)
                    Tween(SwitchDot, {Position = UDim2.new(1, -17, 0.5, -7)}, 0.15, Enum.EasingStyle.Back)
                else
                    Tween(SwitchBg, {BackgroundColor3 = Theme.Elevated}, 0.15)
                    Tween(SwitchDot, {Position = UDim2.new(0, 3, 0.5, -7)}, 0.15, Enum.EasingStyle.Back)
                end
                pcall(Callback, Toggled)
            end
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Theme.Elevated}, 0.1)
            end)
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Theme.Tertiary}, 0.1)
            end)
            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Update()
            end)
            
            return {
                Set = function(_, v) Toggled = v Update() end,
                Get = function() return Toggled end
            }
        end
        
        function Tab:_CreateSlider(config, parent)
            config = config or {}
            local Name = config.Title or config.Name or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or config.Value or Min
            local Callback = config.Callback or function() end
            
            table.insert(AllElements, {Name = Name, Tab = TabName, Type = "Slider"})
            
            local Value = Default
            
            local SliderFrame = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 52),
                Parent = parent or Page
            })
            Corner(SliderFrame, 8)
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 10),
                Size = UDim2.new(1, -65, 0, 14),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            local ValueLabel = Create("TextLabel", {
                Text = tostring(Value),
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Primary,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -48, 0, 10),
                Size = UDim2.new(0, 36, 0, 14),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame
            })
            
            local SliderBar = Create("TextButton", {
                BackgroundColor3 = Theme.Elevated,
                Size = UDim2.new(1, -28, 0, 6),
                Position = UDim2.new(0, 14, 0, 34),
                Text = "",
                AutoButtonColor = false,
                Parent = SliderFrame
            })
            Corner(SliderBar, 3)
            
            local Fill = Create("Frame", {
                BackgroundColor3 = Theme.Primary,
                Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0),
                Parent = SliderBar
            })
            Corner(Fill, 3)
            
            local Knob = Create("Frame", {
                BackgroundColor3 = Theme.Text,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new((Value - Min) / (Max - Min), -7, 0.5, -7),
                ZIndex = 2,
                Parent = SliderBar
            })
            Corner(Knob, 7)
            
            local dragging = false
            
            local function UpdateSlider(input)
                local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Value = math.floor(Min + ((Max - Min) * percent))
                
                Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.04)
                Tween(Knob, {Position = UDim2.new(percent, -7, 0.5, -7)}, 0.04)
                ValueLabel.Text = tostring(Value)
                
                pcall(Callback, Value)
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
                Set = function(_, v)
                    Value = math.clamp(v, Min, Max)
                    local percent = (Value - Min) / (Max - Min)
                    Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.15)
                    Tween(Knob, {Position = UDim2.new(percent, -7, 0.5, -7)}, 0.15)
                    ValueLabel.Text = tostring(Value)
                    pcall(Callback, Value)
                end,
                Get = function() return Value end
            }
        end
        
        function Tab:_CreateDropdown(config, parent)
            config = config or {}
            local Name = config.Title or config.Name or "Dropdown"
            local Options = config.Values or config.Options or {}
            local Default = config.Value or config.Default or Options[1]
            local Multi = config.Multi or false
            local Callback = config.Callback or function() end
            
            table.insert(AllElements, {Name = Name, Tab = TabName, Type = "Dropdown"})
            
            local Selected = Multi and {} or Default
            local Open = false
            
            if Multi and Default then
                if type(Default) == "table" then
                    Selected = Default
                end
            end
            
            local DropFrame = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 38),
                ClipsDescendants = true,
                Parent = parent or Page
            })
            Corner(DropFrame, 8)
            
            local DropBtn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 38),
                Text = "",
                Parent = DropFrame
            })
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.5, 0, 0, 38),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropBtn
            })
            
            local function GetDisplayText()
                if Multi then
                    if #Selected == 0 then
                        return "None"
                    elseif #Selected == 1 then
                        return Selected[1]
                    else
                        return #Selected .. " selected"
                    end
                else
                    return Selected or "..."
                end
            end
            
            local SelectedLabel = Create("TextLabel", {
                Text = GetDisplayText(),
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextDark,
                TextSize = 11,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, -34, 0, 38),
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = DropBtn
            })
            
            local Arrow = CreateIcon(DropBtn, "ChevronDown", UDim2.new(0, 12, 0, 12), UDim2.new(1, -22, 0.5, 0), Theme.TextMuted)
            
            local OptionsFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 42),
                Size = UDim2.new(1, 0, 0, #Options * 30 + 8),
                Parent = DropFrame
            })
            Padding(OptionsFrame, 4, 8, 8, 4)
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3),
                Parent = OptionsFrame
            })
            
            local function CreateOption(option)
                local OptionBtn = Create("TextButton", {
                    BackgroundColor3 = Theme.Elevated,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = OptionsFrame
                })
                Corner(OptionBtn, 6)
                
                local OptionLabel = Create("TextLabel", {
                    Text = option,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextDark,
                    TextSize = 11,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -36, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = OptionBtn
                })
                
                local CheckIcon = CreateIcon(OptionBtn, "Check", UDim2.new(0, 12, 0, 12), UDim2.new(1, -22, 0.5, 0), Theme.Primary)
                CheckIcon.Visible = false
                
                local function UpdateOption()
                    local isSelected = false
                    if Multi then
                        isSelected = table.find(Selected, option) ~= nil
                    else
                        isSelected = Selected == option
                    end
                    
                    CheckIcon.Visible = isSelected
                    OptionLabel.TextColor3 = isSelected and Theme.Text or Theme.TextDark
                    OptionLabel.Font = isSelected and Enum.Font.GothamMedium or Enum.Font.Gotham
                end
                
                OptionBtn.MouseEnter:Connect(function()
                    Tween(OptionBtn, {BackgroundTransparency = 0.5}, 0.08)
                end)
                OptionBtn.MouseLeave:Connect(function()
                    Tween(OptionBtn, {BackgroundTransparency = 1}, 0.08)
                end)
                OptionBtn.MouseButton1Click:Connect(function()
                    if Multi then
                        local idx = table.find(Selected, option)
                        if idx then
                            table.remove(Selected, idx)
                        else
                            table.insert(Selected, option)
                        end
                        UpdateOption()
                        SelectedLabel.Text = GetDisplayText()
                        pcall(Callback, Selected)
                    else
                        Selected = option
                        SelectedLabel.Text = option
                        Open = false
                        Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 38)}, 0.15)
                        Tween(Arrow, {Rotation = 0}, 0.15)
                        UpdateOption()
                        pcall(Callback, option)
                    end
                end)
                
                return {Update = UpdateOption}
            end
            
            local optionRefs = {}
            for _, option in ipairs(Options) do
                table.insert(optionRefs, CreateOption(option))
            end
            
            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local targetHeight = Open and (48 + #Options * 30 + 8) or 38
                Tween(DropFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.18)
                Tween(Arrow, {Rotation = Open and 180 or 0}, 0.18)
            end)
            
            return {
                Set = function(_, o)
                    if Multi then
                        Selected = type(o) == "table" and o or {o}
                    else
                        Selected = o
                    end
                    SelectedLabel.Text = GetDisplayText()
                    for _, ref in ipairs(optionRefs) do
                        ref.Update()
                    end
                    pcall(Callback, Selected)
                end,
                Get = function() return Selected end,
                Refresh = function(_, newOpts)
                    Options = newOpts
                    for _, c in pairs(OptionsFrame:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    optionRefs = {}
                    for _, option in ipairs(Options) do
                        table.insert(optionRefs, CreateOption(option))
                    end
                    OptionsFrame.Size = UDim2.new(1, 0, 0, #Options * 30 + 8)
                end
            }
        end
        
        function Tab:_CreateInput(config, parent)
            config = config or {}
            local Name = config.Title or config.Name or "Input"
            local Placeholder = config.Placeholder or "..."
            local Callback = config.Callback or function() end
            
            table.insert(AllElements, {Name = Name, Tab = TabName, Type = "Input"})
            
            local InputFrame = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 38),
                Parent = parent or Page
            })
            Corner(InputFrame, 8)
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.42, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = InputFrame
            })
            
            local InputBox = Create("TextBox", {
                BackgroundColor3 = Theme.Elevated,
                Size = UDim2.new(0.52, -16, 0, 26),
                Position = UDim2.new(0.48, 0, 0.5, -13),
                Text = "",
                PlaceholderText = Placeholder,
                PlaceholderColor3 = Theme.TextMuted,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.Text,
                TextSize = 11,
                ClearTextOnFocus = false,
                Parent = InputFrame
            })
            Corner(InputBox, 6)
            Padding(InputBox, 0, 10, 10, 0)
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundColor3 = Theme.Hover}, 0.1)
            end)
            InputBox.FocusLost:Connect(function(enter)
                Tween(InputBox, {BackgroundColor3 = Theme.Elevated}, 0.1)
                if enter then pcall(Callback, InputBox.Text) end
            end)
            
            return {
                Set = function(_, t) InputBox.Text = t end,
                Get = function() return InputBox.Text end
            }
        end
        
        function Tab:_CreateKeybind(config, parent)
            config = config or {}
            local Name = config.Title or config.Name or "Keybind"
            local Default = config.Default or config.Value or Enum.KeyCode.E
            local Callback = config.Callback or function() end
            
            table.insert(AllElements, {Name = Name, Tab = TabName, Type = "Keybind"})
            
            local CurrentKey = Default
            local Listening = false
            
            local KeybindFrame = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 38),
                Text = "",
                AutoButtonColor = false,
                Parent = parent or Page
            })
            Corner(KeybindFrame, 8)
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -90, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KeybindFrame
            })
            
            local KeyLabel = Create("TextLabel", {
                Text = CurrentKey.Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Primary,
                TextSize = 10,
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.88,
                Position = UDim2.new(1, -74, 0.5, -11),
                Size = UDim2.new(0, 62, 0, 22),
                Parent = KeybindFrame
            })
            Corner(KeyLabel, 6)
            
            KeybindFrame.MouseEnter:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = Theme.Elevated}, 0.1)
            end)
            KeybindFrame.MouseLeave:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = Theme.Tertiary}, 0.1)
            end)
            
            KeybindFrame.MouseButton1Click:Connect(function()
                Listening = true
                KeyLabel.Text = "..."
                Tween(KeyLabel, {BackgroundTransparency = 0.7}, 0.1)
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if Listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = input.KeyCode
                        KeyLabel.Text = CurrentKey.Name
                        Tween(KeyLabel, {BackgroundTransparency = 0.88}, 0.1)
                        Listening = false
                    end
                elseif not processed and input.KeyCode == CurrentKey then
                    pcall(Callback)
                end
            end)
            
            return {
                Set = function(_, k) CurrentKey = k KeyLabel.Text = k.Name end,
                Get = function() return CurrentKey end
            }
        end
        
        function Tab:_CreateParagraph(config, parent)
            config = config or {}
            local Title = config.Title or ""
            local Content = config.Content or ""
            
            local Para = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = parent or Page
            })
            Corner(Para, 8)
            Padding(Para, 12, 14, 14, 12)
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4),
                Parent = Para
            })
            
            Create("TextLabel", {
                Text = Title,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Text,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 1,
                Parent = Para
            })
            
            Create("TextLabel", {
                Text = Content,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextDark,
                TextSize = 11,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                LayoutOrder = 2,
                Parent = Para
            })
        end
        
        -- Public methods (call internal with Page as parent)
        function Tab:Button(config)
            return self:_CreateButton(config, Page)
        end
        
        function Tab:Toggle(config)
            return self:_CreateToggle(config, Page)
        end
        
        function Tab:Slider(config)
            return self:_CreateSlider(config, Page)
        end
        
        function Tab:Dropdown(config)
            return self:_CreateDropdown(config, Page)
        end
        
        function Tab:Input(config)
            return self:_CreateInput(config, Page)
        end
        
        function Tab:Keybind(config)
            return self:_CreateKeybind(config, Page)
        end
        
        function Tab:Paragraph(config)
            return self:_CreateParagraph(config, Page)
        end
        
        function Tab:Divider()
            Create("Frame", {
                BackgroundColor3 = Theme.Divider,
                BackgroundTransparency = 0.4,
                Size = UDim2.new(1, 0, 0, 1),
                BorderSizePixel = 0,
                Parent = Page
            })
        end
        
        function Tab:Label(text)
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextDark,
                TextSize = 11,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Page
            })
        end
        
        return Tab
    end
    
    return Window
end

return Stellar
