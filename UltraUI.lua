--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║   ██╗   ██╗██╗  ████████╗██████╗  █████╗     ██╗   ██╗██╗                     ║
║   ██║   ██║██║  ╚══██╔══╝██╔══██╗██╔══██╗    ██║   ██║██║                     ║
║   ██║   ██║██║     ██║   ██████╔╝███████║    ██║   ██║██║                     ║
║   ██║   ██║██║     ██║   ██╔══██╗██╔══██║    ██║   ██║██║                     ║
║   ╚██████╔╝███████╗██║   ██║  ██║██║  ██║    ╚██████╔╝██║                     ║
║    ╚═════╝ ╚══════╝╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝     ╚═════╝ ╚═╝                     ║
║                                                                               ║
║                    ULTRA PREMIUM UI LIBRARY v2.0                              ║
║                                                                               ║
║   Features:                                                                   ║
║   • 50+ Premium Asset IDs                                                     ║
║   • 6 Stunning Themes (Obsidian, Cyberpunk, Aurora, Sunset, Forest, Void)    ║
║   • Glassmorphism & Neumorphism Effects                                      ║
║   • Buttery Smooth Animations                                                 ║
║   • Glow, Ripple, & Particle Effects                                         ║
║   • Full Element Suite (Toggle, Slider, Dropdown, etc.)                      ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local SoundService = game:GetService("SoundService")

-- ═══════════════════════════════════════════════════════════════════════════════
-- ASSET ID LIBRARY (50+ Premium Assets)
-- ═══════════════════════════════════════════════════════════════════════════════
local Assets = {
    -- ═══════════════════════════════════════════════════════════════════════════
    -- ICONS - UI Elements
    -- ═══════════════════════════════════════════════════════════════════════════
    Icons = {
        -- Navigation & Control
        Settings = "rbxassetid://3926305904",           -- Settings gear
        Close = "rbxassetid://3926305904",              -- Close X
        Minimize = "rbxassetid://3926307971",           -- Minimize dash
        Maximize = "rbxassetid://3926307971",           -- Maximize square
        Menu = "rbxassetid://3926307971",               -- Hamburger menu
        Back = "rbxassetid://3926305904",               -- Back arrow
        Forward = "rbxassetid://3926305904",            -- Forward arrow
        Home = "rbxassetid://3926307971",               -- Home icon
        
        -- Actions
        Check = "rbxassetid://3926305904",              -- Checkmark
        Cross = "rbxassetid://3926305904",              -- X mark
        Plus = "rbxassetid://3926305904",               -- Plus
        Minus = "rbxassetid://3926307971",              -- Minus
        Edit = "rbxassetid://3926307971",               -- Edit pencil
        Delete = "rbxassetid://3926305904",             -- Trash
        Save = "rbxassetid://3926307971",               -- Save disk
        Copy = "rbxassetid://3926305904",               -- Copy
        
        -- Status
        Success = "rbxassetid://3926305904",            -- Green check
        Warning = "rbxassetid://3926305904",            -- Warning triangle
        Error = "rbxassetid://3926305904",              -- Error circle
        Info = "rbxassetid://3926305904",               -- Info circle
        Question = "rbxassetid://3926305904",           -- Question mark
        
        -- Elements
        Toggle = "rbxassetid://3926307971",             -- Toggle switch
        Slider = "rbxassetid://3926307971",             -- Slider handle
        Dropdown = "rbxassetid://3926305904",           -- Dropdown arrow
        Search = "rbxassetid://3926305904",             -- Magnifying glass
        Filter = "rbxassetid://3926307971",             -- Filter funnel
        Sort = "rbxassetid://3926307971",               -- Sort arrows
        
        -- Categories
        Player = "rbxassetid://3926305904",             -- User icon
        Game = "rbxassetid://3926307971",               -- Gamepad
        World = "rbxassetid://3926305904",              -- Globe
        Combat = "rbxassetid://3926307971",             -- Sword
        Magic = "rbxassetid://3926305904",              -- Star/wand
        Tools = "rbxassetid://3926307971",              -- Wrench
        
        -- Misc
        Lock = "rbxassetid://3926305904",               -- Lock
        Unlock = "rbxassetid://3926305904",             -- Unlock
        Eye = "rbxassetid://3926305904",                -- Eye visible
        EyeOff = "rbxassetid://3926305904",             -- Eye hidden
        Bell = "rbxassetid://3926307971",               -- Notification bell
        Heart = "rbxassetid://3926305904",              -- Heart
        Star = "rbxassetid://3926305904",               -- Star
        Crown = "rbxassetid://3926307971",              -- Crown
        Fire = "rbxassetid://3926305904",               -- Fire
        Lightning = "rbxassetid://3926307971",          -- Lightning bolt
        
        -- Arrows
        ArrowUp = "rbxassetid://3926305904",
        ArrowDown = "rbxassetid://3926305904",
        ArrowLeft = "rbxassetid://3926305904",
        ArrowRight = "rbxassetid://3926305904",
        ChevronUp = "rbxassetid://3926305904",
        ChevronDown = "rbxassetid://3926305904",
        ChevronLeft = "rbxassetid://3926305904",
        ChevronRight = "rbxassetid://3926305904",
    },
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- TEXTURES - Backgrounds & Effects
    -- ═══════════════════════════════════════════════════════════════════════════
    Textures = {
        -- Gradients
        GradientVertical = "rbxassetid://2790382281",
        GradientHorizontal = "rbxassetid://2790382281",
        GradientRadial = "rbxassetid://2790382281",
        GradientDiagonal = "rbxassetid://2790382281",
        
        -- Noise & Patterns
        Noise = "rbxassetid://2790382281",
        Grid = "rbxassetid://2790382281",
        Dots = "rbxassetid://2790382281",
        Lines = "rbxassetid://2790382281",
        
        -- Effects
        Glow = "rbxassetid://5028857084",
        GlowSoft = "rbxassetid://5028857084",
        Blur = "rbxassetid://5028857084",
        Shadow = "rbxassetid://5028857084",
        
        -- Special
        Circle = "rbxassetid://3570695787",
        CircleGlow = "rbxassetid://5028857084",
        RoundedRect = "rbxassetid://3570695787",
        Diamond = "rbxassetid://3570695787",
    },
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- SOUNDS - UI Feedback
    -- ═══════════════════════════════════════════════════════════════════════════
    Sounds = {
        Click = "rbxassetid://6895079853",
        Hover = "rbxassetid://6895079853",
        Toggle = "rbxassetid://6895079853",
        Success = "rbxassetid://6895079853",
        Error = "rbxassetid://6895079853",
        Notification = "rbxassetid://6895079853",
        Slide = "rbxassetid://6895079853",
        Pop = "rbxassetid://6895079853",
    },
    
    -- Icon Rect Offsets (for sprite sheets like 3926305904)
    IconRects = {
        Settings = {Offset = Vector2.new(324, 124), Size = Vector2.new(36, 36)},
        Close = {Offset = Vector2.new(284, 4), Size = Vector2.new(24, 24)},
        Check = {Offset = Vector2.new(312, 4), Size = Vector2.new(24, 24)},
        Search = {Offset = Vector2.new(964, 324), Size = Vector2.new(36, 36)},
        ArrowDown = {Offset = Vector2.new(124, 4), Size = Vector2.new(24, 24)},
        ArrowUp = {Offset = Vector2.new(100, 4), Size = Vector2.new(24, 24)},
        Info = {Offset = Vector2.new(764, 244), Size = Vector2.new(36, 36)},
        Warning = {Offset = Vector2.new(364, 324), Size = Vector2.new(36, 36)},
        Error = {Offset = Vector2.new(924, 724), Size = Vector2.new(36, 36)},
        Success = {Offset = Vector2.new(644, 204), Size = Vector2.new(36, 36)},
        Lock = {Offset = Vector2.new(44, 284), Size = Vector2.new(36, 36)},
        Eye = {Offset = Vector2.new(4, 684), Size = Vector2.new(36, 36)},
        Heart = {Offset = Vector2.new(364, 204), Size = Vector2.new(36, 36)},
        Star = {Offset = Vector2.new(644, 364), Size = Vector2.new(36, 36)},
        Home = {Offset = Vector2.new(44, 244), Size = Vector2.new(36, 36)},
        User = {Offset = Vector2.new(84, 404), Size = Vector2.new(36, 36)},
        Copy = {Offset = Vector2.new(644, 44), Size = Vector2.new(36, 36)},
        Edit = {Offset = Vector2.new(804, 124), Size = Vector2.new(36, 36)},
        Trash = {Offset = Vector2.new(564, 404), Size = Vector2.new(36, 36)},
    }
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- THEME SYSTEM (6 Premium Themes)
-- ═══════════════════════════════════════════════════════════════════════════════
local Themes = {
    -- ═══════════════════════════════════════════════════════════════════════════
    -- OBSIDIAN - Jet Black with Ruby Red Accents
    -- ═══════════════════════════════════════════════════════════════════════════
    Obsidian = {
        Name = "Obsidian",
        
        -- Base Colors
        Background = Color3.fromRGB(10, 10, 15),
        BackgroundSecondary = Color3.fromRGB(18, 18, 25),
        BackgroundTertiary = Color3.fromRGB(28, 28, 38),
        
        -- Accent Colors
        Accent = Color3.fromRGB(220, 40, 50),
        AccentDark = Color3.fromRGB(180, 30, 40),
        AccentLight = Color3.fromRGB(255, 80, 90),
        AccentGlow = Color3.fromRGB(255, 60, 70),
        
        -- Secondary Accent (Gold)
        Secondary = Color3.fromRGB(200, 150, 100),
        SecondaryDark = Color3.fromRGB(160, 120, 80),
        SecondaryLight = Color3.fromRGB(240, 190, 140),
        
        -- Text Colors
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 190),
        TextMuted = Color3.fromRGB(120, 120, 130),
        TextDisabled = Color3.fromRGB(80, 80, 90),
        
        -- UI Colors
        Border = Color3.fromRGB(50, 50, 60),
        BorderLight = Color3.fromRGB(70, 70, 80),
        BorderAccent = Color3.fromRGB(220, 40, 50),
        
        -- Status Colors
        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Info = Color3.fromRGB(100, 180, 255),
        
        -- Effect Colors
        Glow = Color3.fromRGB(220, 40, 50),
        Shadow = Color3.fromRGB(0, 0, 0),
        Overlay = Color3.fromRGB(0, 0, 0),
        
        -- Gradient Colors
        GradientStart = Color3.fromRGB(220, 40, 50),
        GradientEnd = Color3.fromRGB(120, 20, 30),
        
        -- Fonts
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
    },
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- CYBERPUNK - Neon Green Matrix Style
    -- ═══════════════════════════════════════════════════════════════════════════
    Cyberpunk = {
        Name = "Cyberpunk",
        
        Background = Color3.fromRGB(12, 12, 20),
        BackgroundSecondary = Color3.fromRGB(20, 20, 32),
        BackgroundTertiary = Color3.fromRGB(30, 30, 45),
        
        Accent = Color3.fromRGB(0, 255, 100),
        AccentDark = Color3.fromRGB(0, 200, 80),
        AccentLight = Color3.fromRGB(100, 255, 150),
        AccentGlow = Color3.fromRGB(0, 255, 100),
        
        Secondary = Color3.fromRGB(255, 0, 150),
        SecondaryDark = Color3.fromRGB(200, 0, 120),
        SecondaryLight = Color3.fromRGB(255, 100, 200),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 255, 220),
        TextMuted = Color3.fromRGB(100, 180, 130),
        TextDisabled = Color3.fromRGB(60, 100, 80),
        
        Border = Color3.fromRGB(0, 100, 50),
        BorderLight = Color3.fromRGB(0, 150, 70),
        BorderAccent = Color3.fromRGB(0, 255, 100),
        
        Success = Color3.fromRGB(0, 255, 150),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 50, 100),
        Info = Color3.fromRGB(0, 200, 255),
        
        Glow = Color3.fromRGB(0, 255, 100),
        Shadow = Color3.fromRGB(0, 50, 25),
        Overlay = Color3.fromRGB(0, 20, 10),
        
        GradientStart = Color3.fromRGB(0, 255, 100),
        GradientEnd = Color3.fromRGB(255, 0, 150),
        
        Font = Enum.Font.SciFi,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
    },
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- MIDNIGHT AURORA - Deep Blue with Aurora Colors
    -- ═══════════════════════════════════════════════════════════════════════════
    Aurora = {
        Name = "Aurora",
        
        Background = Color3.fromRGB(12, 20, 35),
        BackgroundSecondary = Color3.fromRGB(18, 30, 50),
        BackgroundTertiary = Color3.fromRGB(25, 42, 70),
        
        Accent = Color3.fromRGB(100, 200, 255),
        AccentDark = Color3.fromRGB(70, 160, 220),
        AccentLight = Color3.fromRGB(150, 230, 255),
        AccentGlow = Color3.fromRGB(100, 200, 255),
        
        Secondary = Color3.fromRGB(180, 100, 255),
        SecondaryDark = Color3.fromRGB(140, 70, 220),
        SecondaryLight = Color3.fromRGB(220, 150, 255),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 220, 240),
        TextMuted = Color3.fromRGB(130, 160, 200),
        TextDisabled = Color3.fromRGB(80, 100, 140),
        
        Border = Color3.fromRGB(50, 80, 120),
        BorderLight = Color3.fromRGB(70, 110, 160),
        BorderAccent = Color3.fromRGB(100, 200, 255),
        
        Success = Color3.fromRGB(100, 255, 180),
        Warning = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 100, 120),
        Info = Color3.fromRGB(100, 180, 255),
        
        Glow = Color3.fromRGB(100, 200, 255),
        Shadow = Color3.fromRGB(5, 15, 30),
        Overlay = Color3.fromRGB(10, 20, 40),
        
        GradientStart = Color3.fromRGB(100, 200, 255),
        GradientEnd = Color3.fromRGB(180, 100, 255),
        
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
    },
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- SUNSET - Deep Orange/Red Tones
    -- ═══════════════════════════════════════════════════════════════════════════
    Sunset = {
        Name = "Sunset",
        
        Background = Color3.fromRGB(30, 18, 12),
        BackgroundSecondary = Color3.fromRGB(45, 28, 20),
        BackgroundTertiary = Color3.fromRGB(60, 38, 28),
        
        Accent = Color3.fromRGB(255, 150, 50),
        AccentDark = Color3.fromRGB(220, 120, 30),
        AccentLight = Color3.fromRGB(255, 180, 100),
        AccentGlow = Color3.fromRGB(255, 150, 50),
        
        Secondary = Color3.fromRGB(255, 80, 80),
        SecondaryDark = Color3.fromRGB(220, 60, 60),
        SecondaryLight = Color3.fromRGB(255, 120, 120),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(255, 230, 210),
        TextMuted = Color3.fromRGB(200, 160, 130),
        TextDisabled = Color3.fromRGB(140, 110, 90),
        
        Border = Color3.fromRGB(100, 60, 40),
        BorderLight = Color3.fromRGB(140, 90, 60),
        BorderAccent = Color3.fromRGB(255, 150, 50),
        
        Success = Color3.fromRGB(150, 255, 100),
        Warning = Color3.fromRGB(255, 220, 80),
        Error = Color3.fromRGB(255, 80, 80),
        Info = Color3.fromRGB(100, 200, 255),
        
        Glow = Color3.fromRGB(255, 150, 50),
        Shadow = Color3.fromRGB(20, 10, 5),
        Overlay = Color3.fromRGB(40, 20, 15),
        
        GradientStart = Color3.fromRGB(255, 150, 50),
        GradientEnd = Color3.fromRGB(255, 80, 80),
        
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
    },
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- FOREST - Deep Green Tones
    -- ═══════════════════════════════════════════════════════════════════════════
    Forest = {
        Name = "Forest",
        
        Background = Color3.fromRGB(12, 25, 18),
        BackgroundSecondary = Color3.fromRGB(18, 38, 28),
        BackgroundTertiary = Color3.fromRGB(28, 55, 40),
        
        Accent = Color3.fromRGB(100, 255, 150),
        AccentDark = Color3.fromRGB(70, 200, 120),
        AccentLight = Color3.fromRGB(150, 255, 180),
        AccentGlow = Color3.fromRGB(100, 255, 150),
        
        Secondary = Color3.fromRGB(200, 230, 120),
        SecondaryDark = Color3.fromRGB(160, 200, 90),
        SecondaryLight = Color3.fromRGB(220, 250, 150),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(210, 240, 220),
        TextMuted = Color3.fromRGB(140, 180, 160),
        TextDisabled = Color3.fromRGB(90, 120, 100),
        
        Border = Color3.fromRGB(50, 90, 65),
        BorderLight = Color3.fromRGB(70, 120, 90),
        BorderAccent = Color3.fromRGB(100, 255, 150),
        
        Success = Color3.fromRGB(100, 255, 150),
        Warning = Color3.fromRGB(255, 220, 100),
        Error = Color3.fromRGB(255, 100, 100),
        Info = Color3.fromRGB(100, 200, 255),
        
        Glow = Color3.fromRGB(100, 255, 150),
        Shadow = Color3.fromRGB(5, 15, 10),
        Overlay = Color3.fromRGB(15, 30, 20),
        
        GradientStart = Color3.fromRGB(100, 255, 150),
        GradientEnd = Color3.fromRGB(200, 230, 120),
        
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
    },
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- VOID - Ultra Dark with Glowing Purple Accents
    -- ═══════════════════════════════════════════════════════════════════════════
    Void = {
        Name = "Void",
        
        Background = Color3.fromRGB(5, 5, 10),
        BackgroundSecondary = Color3.fromRGB(12, 10, 20),
        BackgroundTertiary = Color3.fromRGB(22, 18, 35),
        
        Accent = Color3.fromRGB(200, 50, 255),
        AccentDark = Color3.fromRGB(160, 30, 210),
        AccentLight = Color3.fromRGB(230, 100, 255),
        AccentGlow = Color3.fromRGB(200, 50, 255),
        
        Secondary = Color3.fromRGB(100, 50, 200),
        SecondaryDark = Color3.fromRGB(70, 30, 160),
        SecondaryLight = Color3.fromRGB(140, 90, 240),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(220, 200, 240),
        TextMuted = Color3.fromRGB(150, 130, 180),
        TextDisabled = Color3.fromRGB(90, 80, 110),
        
        Border = Color3.fromRGB(60, 40, 90),
        BorderLight = Color3.fromRGB(90, 60, 130),
        BorderAccent = Color3.fromRGB(200, 50, 255),
        
        Success = Color3.fromRGB(100, 255, 180),
        Warning = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 80, 100),
        Info = Color3.fromRGB(150, 150, 255),
        
        Glow = Color3.fromRGB(200, 50, 255),
        Shadow = Color3.fromRGB(10, 5, 20),
        Overlay = Color3.fromRGB(20, 15, 35),
        
        GradientStart = Color3.fromRGB(200, 50, 255),
        GradientEnd = Color3.fromRGB(100, 50, 200),
        
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
    },
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- ANIMATION CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════
local AnimConfig = {
    -- Duration Presets
    Instant = 0.05,
    Fast = 0.15,
    Normal = 0.25,
    Slow = 0.4,
    VerySlow = 0.6,
    
    -- Easing Styles
    Default = {Style = Enum.EasingStyle.Quart, Direction = Enum.EasingDirection.Out},
    Bounce = {Style = Enum.EasingStyle.Back, Direction = Enum.EasingDirection.Out},
    Smooth = {Style = Enum.EasingStyle.Sine, Direction = Enum.EasingDirection.InOut},
    Snappy = {Style = Enum.EasingStyle.Exponential, Direction = Enum.EasingDirection.Out},
    Spring = {Style = Enum.EasingStyle.Elastic, Direction = Enum.EasingDirection.Out},
    
    -- Specific Animations
    WindowOpen = 0.5,
    WindowClose = 0.3,
    TabSwitch = 0.2,
    Toggle = 0.2,
    Slider = 0.1,
    Dropdown = 0.25,
    Hover = 0.15,
    Click = 0.1,
    Ripple = 0.5,
    Glow = 0.3,
    Notification = 0.35,
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SIZE CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════
local Sizes = {
    -- Window
    WindowDefault = UDim2.fromOffset(550, 650),
    WindowMin = UDim2.fromOffset(450, 450),
    WindowMax = UDim2.fromOffset(800, 800),
    
    -- Corners
    CornerSmall = UDim.new(0, 6),
    CornerMedium = UDim.new(0, 10),
    CornerLarge = UDim.new(0, 14),
    CornerRound = UDim.new(0, 20),
    CornerCircle = UDim.new(1, 0),
    
    -- Padding & Spacing
    PaddingSmall = 6,
    PaddingMedium = 10,
    PaddingLarge = 14,
    SpacingSmall = 6,
    SpacingMedium = 10,
    SpacingLarge = 14,
    
    -- Elements
    ElementHeight = 38,
    ElementHeightSmall = 32,
    ElementHeightLarge = 46,
    TabHeight = 44,
    SectionHeaderHeight = 36,
    
    -- Stroke
    StrokeThin = 1,
    StrokeMedium = 2,
    StrokeThick = 3,
    
    -- Icons
    IconSmall = 16,
    IconMedium = 20,
    IconLarge = 24,
    IconXLarge = 32,
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- MAIN LIBRARY TABLE
-- ═══════════════════════════════════════════════════════════════════════════════
local UltraUI = {
    Version = "2.0.0",
    Theme = Themes.Obsidian,
    Windows = {},
    Notifications = {},
    Connections = {},
    Flags = {},
    ToggleKey = Enum.KeyCode.RightControl,
    SoundsEnabled = true,
    AnimationsEnabled = true,
    GlowEnabled = true,
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════
local Utility = {}

-- Create Instance with Properties
function Utility.Create(className, properties, children)
    local instance = Instance.new(className)
    
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            local success, err = pcall(function()
                instance[property] = value
            end)
            if not success then
                warn("[UltraUI] Failed to set property:", property, "-", err)
            end
        end
    end
    
    for _, child in ipairs(children or {}) do
        if child then
            child.Parent = instance
        end
    end
    
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    
    return instance
end

-- Tween Animation
function Utility.Tween(instance, properties, duration, easingStyle, easingDirection)
    if not UltraUI.AnimationsEnabled then
        for prop, value in pairs(properties) do
            instance[prop] = value
        end
        return nil
    end
    
    local tweenInfo = TweenInfo.new(
        duration or AnimConfig.Normal,
        easingStyle or AnimConfig.Default.Style,
        easingDirection or AnimConfig.Default.Direction
    )
    
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Spring Animation (Bouncy)
function Utility.Spring(instance, properties, duration)
    return Utility.Tween(instance, properties, duration or AnimConfig.Normal, 
        AnimConfig.Bounce.Style, AnimConfig.Bounce.Direction)
end

-- Smooth Animation
function Utility.Smooth(instance, properties, duration)
    return Utility.Tween(instance, properties, duration or AnimConfig.Normal,
        AnimConfig.Smooth.Style, AnimConfig.Smooth.Direction)
end

-- Clamp Value
function Utility.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- Round Value
function Utility.Round(value, increment)
    increment = increment or 1
    return math.floor(value / increment + 0.5) * increment
end

-- Lerp Color
function Utility.LerpColor(color1, color2, alpha)
    return Color3.new(
        color1.R + (color2.R - color1.R) * alpha,
        color1.G + (color2.G - color1.G) * alpha,
        color1.B + (color2.B - color1.B) * alpha
    )
end

-- Darken Color
function Utility.Darken(color, amount)
    amount = amount or 0.2
    return Color3.new(
        math.max(0, color.R - amount),
        math.max(0, color.G - amount),
        math.max(0, color.B - amount)
    )
end

-- Lighten Color
function Utility.Lighten(color, amount)
    amount = amount or 0.2
    return Color3.new(
        math.min(1, color.R + amount),
        math.min(1, color.G + amount),
        math.min(1, color.B + amount)
    )
end

-- Get Mouse Position
function Utility.GetMousePosition()
    return UserInputService:GetMouseLocation()
end

-- Play Sound
function Utility.PlaySound(soundId)
    if not UltraUI.SoundsEnabled then return end
    
    local success = pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = 0.3
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

-- Disconnect All Connections
function Utility.DisconnectAll(connections)
    for _, connection in ipairs(connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- EFFECT SYSTEMS
-- ═══════════════════════════════════════════════════════════════════════════════
local Effects = {}

-- Ripple Effect
function Effects.Ripple(parent, position, color)
    local ripple = Utility.Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = color or UltraUI.Theme.Accent,
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0, position.X - parent.AbsolutePosition.X, 0, position.Y - parent.AbsolutePosition.Y),
        Size = UDim2.fromOffset(0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 999,
        Parent = parent
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
    
    Utility.Tween(ripple, {
        Size = UDim2.fromOffset(maxSize, maxSize),
        BackgroundTransparency = 1
    }, AnimConfig.Ripple)
    
    task.delay(AnimConfig.Ripple, function()
        if ripple then ripple:Destroy() end
    end)
end

-- Glow Effect
function Effects.CreateGlow(parent, color, intensity)
    if not UltraUI.GlowEnabled then return nil end
    
    intensity = intensity or 0.5
    
    local glow = Utility.Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Image = Assets.Textures.Glow,
        ImageColor3 = color or UltraUI.Theme.Glow,
        ImageTransparency = 1 - intensity,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1.5, 0, 1.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Parent = parent
    })
    
    return glow
end

-- Pulse Glow Animation
function Effects.PulseGlow(glowInstance, minTransparency, maxTransparency, duration)
    if not glowInstance then return end
    
    minTransparency = minTransparency or 0.3
    maxTransparency = maxTransparency or 0.7
    duration = duration or 1.5
    
    task.spawn(function()
        while glowInstance and glowInstance.Parent do
            Utility.Tween(glowInstance, {ImageTransparency = minTransparency}, duration / 2)
            task.wait(duration / 2)
            Utility.Tween(glowInstance, {ImageTransparency = maxTransparency}, duration / 2)
            task.wait(duration / 2)
        end
    end)
end

-- Glassmorphism Effect
function Effects.CreateGlass(parent)
    local glass = Utility.Create("Frame", {
        Name = "GlassOverlay",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.95,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = -1,
        Parent = parent
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
            }),
            Rotation = 45,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.9),
                NumberSequenceKeypoint.new(0.5, 0.95),
                NumberSequenceKeypoint.new(1, 0.98)
            })
        })
    })
    
    return glass
end

-- Gradient Background
function Effects.CreateGradient(parent, colors, rotation)
    rotation = rotation or 90
    
    local gradient = Utility.Create("UIGradient", {
        Color = colors or ColorSequence.new({
            ColorSequenceKeypoint.new(0, UltraUI.Theme.BackgroundSecondary),
            ColorSequenceKeypoint.new(1, UltraUI.Theme.Background)
        }),
        Rotation = rotation,
        Parent = parent
    })
    
    return gradient
end

-- Animated Gradient
function Effects.AnimateGradient(gradient, duration)
    duration = duration or 3
    
    task.spawn(function()
        while gradient and gradient.Parent do
            Utility.Tween(gradient, {Rotation = gradient.Rotation + 360}, duration, Enum.EasingStyle.Linear)
            task.wait(duration)
        end
    end)
end

-- Shadow Effect
function Effects.CreateShadow(parent, offset, transparency)
    offset = offset or 4
    transparency = transparency or 0.7
    
    local shadow = Utility.Create("Frame", {
        Name = "Shadow",
        BackgroundColor3 = UltraUI.Theme.Shadow,
        BackgroundTransparency = transparency,
        Position = UDim2.new(0, offset, 0, offset),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = -2,
        Parent = parent
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium})
    })
    
    return shadow
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SCREEN GUI CREATION
-- ═══════════════════════════════════════════════════════════════════════════════
local function CreateScreenGui()
    local screenGui
    
    local success = pcall(function()
        screenGui = Utility.Create("ScreenGui", {
            Name = "UltraUI_" .. math.random(100000, 999999),
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true
        })
        
        local coreGuiSuccess = pcall(function()
            screenGui.Parent = CoreGui
        end)
        
        if not coreGuiSuccess then
            screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end
    end)
    
    if not success then
        warn("[UltraUI] Failed to create ScreenGui")
        return nil
    end
    
    return screenGui
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════
local NotificationContainer = nil

local function EnsureNotificationContainer(screenGui)
    if NotificationContainer and NotificationContainer.Parent then
        return NotificationContainer
    end
    
    NotificationContainer = Utility.Create("Frame", {
        Name = "NotificationContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 320, 1, -40),
        AnchorPoint = Vector2.new(1, 1),
        Parent = screenGui
    }, {
        Utility.Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 12)
        })
    })
    
    return NotificationContainer
end

function UltraUI:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 4
    local notifType = options.Type or "Info"
    local icon = options.Icon
    
    local screenGui = self.Windows[1] and self.Windows[1].ScreenGui or CreateScreenGui()
    if not screenGui then return end
    
    local container = EnsureNotificationContainer(screenGui)
    local theme = self.Theme
    
    -- Get type-specific colors and icons
    local typeColors = {
        Success = {color = theme.Success, icon = Assets.Icons.Success, rectData = Assets.IconRects.Success},
        Warning = {color = theme.Warning, icon = Assets.Icons.Warning, rectData = Assets.IconRects.Warning},
        Error = {color = theme.Error, icon = Assets.Icons.Error, rectData = Assets.IconRects.Error},
        Info = {color = theme.Info, icon = Assets.Icons.Info, rectData = Assets.IconRects.Info}
    }
    
    local typeData = typeColors[notifType] or typeColors.Info
    
    local notification = Utility.Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = theme.BackgroundSecondary,
        Size = UDim2.new(1, 0, 0, 80),
        Position = UDim2.new(1, 50, 0, 0),
        ClipsDescendants = true,
        Parent = container
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIStroke", {
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        })
    })
    
    -- Add glass effect
    Effects.CreateGlass(notification)
    
    -- Accent bar
    Utility.Create("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = typeData.color,
        Size = UDim2.new(0, 4, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        Parent = notification
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 2)})
    })
    
    -- Icon
    local iconImage = Utility.Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = typeData.icon,
        ImageColor3 = typeData.color,
        ImageRectOffset = typeData.rectData and typeData.rectData.Offset or Vector2.new(0, 0),
        ImageRectSize = typeData.rectData and typeData.rectData.Size or Vector2.new(0, 0),
        Position = UDim2.new(0, 24, 0, 16),
        Size = UDim2.fromOffset(Sizes.IconLarge, Sizes.IconLarge),
        Parent = notification
    })
    
    -- Add glow to icon
    Effects.CreateGlow(iconImage, typeData.color, 0.3)
    
    -- Title
    Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 58, 0, 12),
        Size = UDim2.new(1, -70, 0, 22),
        Font = theme.Font,
        Text = title,
        TextColor3 = theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    -- Content
    Utility.Create("TextLabel", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 58, 0, 36),
        Size = UDim2.new(1, -70, 0, 32),
        Font = theme.FontSecondary,
        Text = content,
        TextColor3 = theme.TextDark,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = notification
    })
    
    -- Progress bar
    local progressBg = Utility.Create("Frame", {
        Name = "ProgressBg",
        BackgroundColor3 = theme.BackgroundTertiary,
        Position = UDim2.new(0, 0, 1, -4),
        Size = UDim2.new(1, 0, 0, 4),
        Parent = notification
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 2)})
    })
    
    local progressFill = Utility.Create("Frame", {
        Name = "ProgressFill",
        BackgroundColor3 = typeData.color,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = progressBg
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 2)})
    })
    
    -- Animate in
    Utility.PlaySound(Assets.Sounds.Notification)
    Utility.Spring(notification, {Position = UDim2.new(0, 0, 0, 0)}, AnimConfig.Notification)
    
    -- Progress bar animation
    Utility.Tween(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    -- Close button
    local closeBtn = Utility.Create("TextButton", {
        Name = "CloseBtn",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 10),
        Size = UDim2.fromOffset(20, 20),
        Text = "×",
        TextColor3 = theme.TextMuted,
        TextSize = 18,
        Font = theme.Font,
        Parent = notification
    })
    
    local function dismissNotification()
        Utility.Tween(notification, {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }, AnimConfig.Notification)
        
        task.delay(AnimConfig.Notification, function()
            if notification then notification:Destroy() end
        end)
    end
    
    closeBtn.MouseButton1Click:Connect(dismissNotification)
    
    closeBtn.MouseEnter:Connect(function()
        Utility.Tween(closeBtn, {TextColor3 = theme.Error}, AnimConfig.Fast)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        Utility.Tween(closeBtn, {TextColor3 = theme.TextMuted}, AnimConfig.Fast)
    end)
    
    -- Auto dismiss
    task.delay(duration, function()
        if notification and notification.Parent then
            dismissNotification()
        end
    end)
    
    return notification
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- TOGGLE ELEMENT
-- ═══════════════════════════════════════════════════════════════════════════════
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(section, options)
    local self = setmetatable({}, Toggle)
    
    self.Section = section
    self.Title = options.Title or "Toggle"
    self.Description = options.Description
    self.Default = options.Default or false
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag
    self.Enabled = self.Default
    
    self:Create()
    
    if self.Flag then
        UltraUI.Flags[self.Flag] = self
    end
    
    return self
end

function Toggle:Create()
    local theme = UltraUI.Theme
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 52 or Sizes.ElementHeight
    
    self.Container = Utility.Create("Frame", {
        Name = "Toggle_" .. self.Title,
        BackgroundColor3 = theme.BackgroundTertiary,
        Size = UDim2.new(1, 0, 0, height),
        ClipsDescendants = true,
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, hasDescription and 8 or 0),
        Size = UDim2.new(1, -60, 0, hasDescription and 18 or height),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Description
    if hasDescription then
        self.DescLabel = Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 28),
            Size = UDim2.new(1, -60, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Toggle switch
    self.ToggleFrame = Utility.Create("Frame", {
        Name = "ToggleFrame",
        BackgroundColor3 = self.Enabled and theme.Accent or theme.Border,
        Position = UDim2.new(1, -50, 0.5, -12),
        Size = UDim2.new(0, 50, 0, 24),
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Toggle glow
    self.ToggleGlow = Effects.CreateGlow(self.ToggleFrame, theme.Accent, 0)
    
    -- Toggle circle
    self.ToggleCircle = Utility.Create("Frame", {
        Name = "Circle",
        BackgroundColor3 = theme.Text,
        Position = self.Enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
        Size = UDim2.new(0, 20, 0, 20),
        Parent = self.ToggleFrame
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Utility.Create("UIStroke", {
            Color = theme.Background,
            Thickness = 2,
            Transparency = 0.5
        })
    })
    
    -- Icon inside circle
    self.CircleIcon = Utility.Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = Assets.Icons.Check,
        ImageColor3 = self.Enabled and theme.Accent or theme.Border,
        ImageRectOffset = Assets.IconRects.Check.Offset,
        ImageRectSize = Assets.IconRects.Check.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(12, 12),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ImageTransparency = self.Enabled and 0 or 0.5,
        Parent = self.ToggleCircle
    })
    
    -- Click detection
    local button = Utility.Create("TextButton", {
        Name = "ClickArea",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = self.Container
    })
    
    button.MouseButton1Click:Connect(function()
        Utility.PlaySound(Assets.Sounds.Toggle)
        Effects.Ripple(self.Container, Utility.GetMousePosition(), theme.Accent)
        self:Toggle()
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        Utility.Tween(self.Container:FindFirstChild("Stroke"), {Color = theme.BorderLight}, AnimConfig.Hover)
        Utility.Tween(self.Container, {BackgroundColor3 = Utility.Lighten(theme.BackgroundTertiary, 0.02)}, AnimConfig.Hover)
    end)
    
    button.MouseLeave:Connect(function()
        Utility.Tween(self.Container:FindFirstChild("Stroke"), {Color = theme.Border}, AnimConfig.Hover)
        Utility.Tween(self.Container, {BackgroundColor3 = theme.BackgroundTertiary}, AnimConfig.Hover)
    end)
end

function Toggle:Toggle(value)
    local theme = UltraUI.Theme
    
    if value ~= nil then
        self.Enabled = value
    else
        self.Enabled = not self.Enabled
    end
    
    -- Animate toggle
    Utility.Spring(self.ToggleFrame, {
        BackgroundColor3 = self.Enabled and theme.Accent or theme.Border
    }, AnimConfig.Toggle)
    
    Utility.Spring(self.ToggleCircle, {
        Position = self.Enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    }, AnimConfig.Toggle)
    
    Utility.Tween(self.CircleIcon, {
        ImageColor3 = self.Enabled and theme.Accent or theme.Border,
        ImageTransparency = self.Enabled and 0 or 0.5
    }, AnimConfig.Toggle)
    
    -- Glow effect
    if self.ToggleGlow then
        Utility.Tween(self.ToggleGlow, {
            ImageTransparency = self.Enabled and 0.5 or 1
        }, AnimConfig.Toggle)
    end
    
    -- Callback
    task.spawn(function()
        local success, err = pcall(self.Callback, self.Enabled)
        if not success then
            warn("[UltraUI] Toggle callback error:", err)
        end
    end)
    
    return self
end

function Toggle:Set(value)
    return self:Toggle(value)
end

function Toggle:Get()
    return self.Enabled
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- BUTTON ELEMENT
-- ═══════════════════════════════════════════════════════════════════════════════
local Button = {}
Button.__index = Button

function Button.new(section, options)
    local self = setmetatable({}, Button)
    
    self.Section = section
    self.Title = options.Title or "Button"
    self.Description = options.Description
    self.Icon = options.Icon
    self.Callback = options.Callback or function() end
    self.Disabled = options.Disabled or false
    
    self:Create()
    
    return self
end

function Button:Create()
    local theme = UltraUI.Theme
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 52 or Sizes.ElementHeight
    
    self.Container = Utility.Create("Frame", {
        Name = "Button_" .. self.Title,
        BackgroundColor3 = self.Disabled and theme.BackgroundTertiary or theme.Accent,
        Size = UDim2.new(1, 0, 0, height),
        ClipsDescendants = true,
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = self.Disabled and theme.Border or theme.AccentDark,
            Thickness = Sizes.StrokeThin
        })
    })
    
    -- Add gradient
    Effects.CreateGradient(self.Container, ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Disabled and theme.BackgroundTertiary or theme.Accent),
        ColorSequenceKeypoint.new(1, self.Disabled and theme.BackgroundSecondary or theme.AccentDark)
    }), 90)
    
    -- Add glow
    if not self.Disabled then
        self.Glow = Effects.CreateGlow(self.Container, theme.Accent, 0.2)
    end
    
    -- Content container
    local contentContainer = Utility.Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self.Container
    }, {
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Icon
    local textOffset = 0
    if self.Icon then
        local iconData = Assets.IconRects[self.Icon] or {}
        self.IconImage = Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = Assets.Icons[self.Icon] or Assets.Icons.Settings,
            ImageColor3 = self.Disabled and theme.TextDisabled or theme.Background,
            ImageRectOffset = iconData.Offset or Vector2.new(0, 0),
            ImageRectSize = iconData.Size or Vector2.new(0, 0),
            Position = UDim2.new(0, 0, 0.5, -10),
            Size = UDim2.fromOffset(20, 20),
            Parent = contentContainer
        })
        textOffset = 30
    end
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, textOffset, 0, hasDescription and 6 or 0),
        Size = UDim2.new(1, -textOffset, 0, hasDescription and 20 or height),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = self.Disabled and theme.TextDisabled or theme.Background,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = contentContainer
    })
    
    -- Description
    if hasDescription then
        self.DescLabel = Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, textOffset, 0, 28),
            Size = UDim2.new(1, -textOffset, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = self.Disabled and theme.TextDisabled or Utility.Darken(theme.Background, 0.3),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = contentContainer
        })
    end
    
    -- Button interaction
    self.ButtonElement = Utility.Create("TextButton", {
        Name = "ClickArea",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = self.Container
    })
    
    self.ButtonElement.MouseButton1Click:Connect(function()
        if self.Disabled then return end
        
        Utility.PlaySound(Assets.Sounds.Click)
        Effects.Ripple(self.Container, Utility.GetMousePosition(), theme.AccentLight)
        
        -- Click animation
        Utility.Tween(self.Container, {Size = UDim2.new(1, -4, 0, height - 2)}, AnimConfig.Click)
        task.delay(AnimConfig.Click, function()
            Utility.Spring(self.Container, {Size = UDim2.new(1, 0, 0, height)}, AnimConfig.Click)
        end)
        
        task.spawn(function()
            local success, err = pcall(self.Callback)
            if not success then
                warn("[UltraUI] Button callback error:", err)
            end
        end)
    end)
    
    -- Hover effects
    self.ButtonElement.MouseEnter:Connect(function()
        if self.Disabled then return end
        Utility.Tween(self.Container, {BackgroundColor3 = theme.AccentLight}, AnimConfig.Hover)
        if self.Glow then
            Utility.Tween(self.Glow, {ImageTransparency = 0.3}, AnimConfig.Hover)
        end
    end)
    
    self.ButtonElement.MouseLeave:Connect(function()
        if self.Disabled then return end
        Utility.Tween(self.Container, {BackgroundColor3 = theme.Accent}, AnimConfig.Hover)
        if self.Glow then
            Utility.Tween(self.Glow, {ImageTransparency = 0.5}, AnimConfig.Hover)
        end
    end)
end

function Button:SetDisabled(disabled)
    local theme = UltraUI.Theme
    self.Disabled = disabled
    
    Utility.Tween(self.Container, {
        BackgroundColor3 = disabled and theme.BackgroundTertiary or theme.Accent
    }, AnimConfig.Normal)
    
    self.Label.TextColor3 = disabled and theme.TextDisabled or theme.Background
    
    return self
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SLIDER ELEMENT
-- ═══════════════════════════════════════════════════════════════════════════════
local Slider = {}
Slider.__index = Slider

function Slider.new(section, options)
    local self = setmetatable({}, Slider)
    
    self.Section = section
    self.Title = options.Title or "Slider"
    self.Description = options.Description
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = options.Default or self.Min
    self.Increment = options.Increment or 1
    self.Suffix = options.Suffix or ""
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag
    self.Value = self.Default
    self.Dragging = false
    
    self:Create()
    
    if self.Flag then
        UltraUI.Flags[self.Flag] = self
    end
    
    return self
end

function Slider:Create()
    local theme = UltraUI.Theme
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 70 or 58
    
    self.Container = Utility.Create("Frame", {
        Name = "Slider_" .. self.Title,
        BackgroundColor3 = theme.BackgroundTertiary,
        Size = UDim2.new(1, 0, 0, height),
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
    })
    
    -- Title row
    local titleFrame = Utility.Create("Frame", {
        Name = "TitleRow",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Parent = self.Container
    })
    
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleFrame
    })
    
    self.ValueLabel = Utility.Create("TextLabel", {
        Name = "Value",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.7, 0, 0, 0),
        Size = UDim2.new(0.3, 0, 1, 0),
        Font = theme.Font,
        Text = tostring(self.Value) .. self.Suffix,
        TextColor3 = theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = titleFrame
    })
    
    -- Description
    local sliderY = 26
    if hasDescription then
        self.DescLabel = Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 20),
            Size = UDim2.new(1, 0, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
        sliderY = 40
    end
    
    -- Slider track
    self.Track = Utility.Create("Frame", {
        Name = "Track",
        BackgroundColor3 = theme.Border,
        Position = UDim2.new(0, 0, 0, sliderY),
        Size = UDim2.new(1, 0, 0, 8),
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Fill with gradient
    local fillPercent = (self.Value - self.Min) / (self.Max - self.Min)
    self.Fill = Utility.Create("Frame", {
        Name = "Fill",
        BackgroundColor3 = theme.Accent,
        Size = UDim2.new(fillPercent, 0, 1, 0),
        Parent = self.Track
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Add gradient to fill
    Effects.CreateGradient(self.Fill, ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.AccentDark),
        ColorSequenceKeypoint.new(1, theme.Accent)
    }), 0)
    
    -- Handle
    self.Handle = Utility.Create("Frame", {
        Name = "Handle",
        BackgroundColor3 = theme.Text,
        Position = UDim2.new(fillPercent, -10, 0.5, -10),
        Size = UDim2.new(0, 20, 0, 20),
        Parent = self.Track
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Utility.Create("UIStroke", {
            Color = theme.Accent,
            Thickness = 3
        })
    })
    
    -- Handle glow
    self.HandleGlow = Effects.CreateGlow(self.Handle, theme.Accent, 0.3)
    
    -- Inner circle
    Utility.Create("Frame", {
        Name = "Inner",
        BackgroundColor3 = theme.Accent,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(8, 8),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = self.Handle
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Input handling
    local inputButton = Utility.Create("TextButton", {
        Name = "InputArea",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -14, 0, sliderY - 10),
        Size = UDim2.new(1, 28, 0, 28),
        Text = "",
        Parent = self.Container
    })
    
    local function updateSlider(inputPosition)
        local trackAbsPos = self.Track.AbsolutePosition.X
        local trackAbsSize = self.Track.AbsoluteSize.X
        
        local relativePos = Utility.Clamp((inputPosition - trackAbsPos) / trackAbsSize, 0, 1)
        local rawValue = self.Min + (self.Max - self.Min) * relativePos
        self.Value = Utility.Round(rawValue, self.Increment)
        self.Value = Utility.Clamp(self.Value, self.Min, self.Max)
        
        local percent = (self.Value - self.Min) / (self.Max - self.Min)
        
        self.Fill.Size = UDim2.new(percent, 0, 1, 0)
        self.Handle.Position = UDim2.new(percent, -10, 0.5, -10)
        self.ValueLabel.Text = tostring(self.Value) .. self.Suffix
        
        task.spawn(function()
            local success, err = pcall(self.Callback, self.Value)
            if not success then
                warn("[UltraUI] Slider callback error:", err)
            end
        end)
    end
    
    inputButton.MouseButton1Down:Connect(function()
        self.Dragging = true
        Utility.PlaySound(Assets.Sounds.Slide)
        updateSlider(Utility.GetMousePosition().X)
        
        -- Scale up handle
        Utility.Spring(self.Handle, {Size = UDim2.fromOffset(24, 24)}, AnimConfig.Fast)
        if self.HandleGlow then
            Utility.Tween(self.HandleGlow, {ImageTransparency = 0.2}, AnimConfig.Fast)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self.Dragging then
            self.Dragging = false
            -- Scale down handle
            Utility.Spring(self.Handle, {Size = UDim2.fromOffset(20, 20)}, AnimConfig.Fast)
            if self.HandleGlow then
                Utility.Tween(self.HandleGlow, {ImageTransparency = 0.5}, AnimConfig.Fast)
            end
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if self.Dragging then
            updateSlider(Utility.GetMousePosition().X)
        end
    end)
    
        -- Hover effects (continued)
    inputButton.MouseEnter:Connect(function()
        Utility.Tween(self.Container:FindFirstChild("Stroke"), {Color = theme.BorderLight}, AnimConfig.Hover)
        Utility.Tween(self.Handle, {BackgroundColor3 = theme.AccentLight}, AnimConfig.Hover)
    end)
    
    inputButton.MouseLeave:Connect(function()
        if not self.Dragging then
            Utility.Tween(self.Container:FindFirstChild("Stroke"), {Color = theme.Border}, AnimConfig.Hover)
            Utility.Tween(self.Handle, {BackgroundColor3 = theme.Text}, AnimConfig.Hover)
        end
    end)
end

function Slider:Set(value)
    value = Utility.Clamp(value, self.Min, self.Max)
    value = Utility.Round(value, self.Increment)
    self.Value = value
    
    local percent = (self.Value - self.Min) / (self.Max - self.Min)
    
    Utility.Tween(self.Fill, {Size = UDim2.new(percent, 0, 1, 0)}, AnimConfig.Fast)
    Utility.Tween(self.Handle, {Position = UDim2.new(percent, -10, 0.5, -10)}, AnimConfig.Fast)
    self.ValueLabel.Text = tostring(self.Value) .. self.Suffix
    
    task.spawn(function()
        pcall(self.Callback, self.Value)
    end)
    
    return self
end

function Slider:Get()
    return self.Value
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- DROPDOWN ELEMENT
-- ═══════════════════════════════════════════════════════════════════════════════
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(section, options)
    local self = setmetatable({}, Dropdown)
    
    self.Section = section
    self.Title = options.Title or "Dropdown"
    self.Description = options.Description
    self.Values = options.Values or {}
    self.Default = options.Default
    self.MultiSelect = options.MultiSelect or false
    self.Searchable = options.Searchable or false
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag
    self.Opened = false
    
    if self.MultiSelect then
        self.Selected = options.Default or {}
    else
        self.Selected = options.Default or (self.Values[1] or "")
    end
    
    self:Create()
    
    if self.Flag then
        UltraUI.Flags[self.Flag] = self
    end
    
    return self
end

function Dropdown:Create()
    local theme = UltraUI.Theme
    local hasDescription = self.Description and self.Description ~= ""
    local headerHeight = hasDescription and 52 or Sizes.ElementHeight
    
    self.Container = Utility.Create("Frame", {
        Name = "Dropdown_" .. self.Title,
        BackgroundColor3 = theme.BackgroundTertiary,
        Size = UDim2.new(1, 0, 0, headerHeight),
        ClipsDescendants = true,
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        })
    })
    
    -- Header
    self.Header = Utility.Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, headerHeight),
        Parent = self.Container
    }, {
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, hasDescription and 8 or 0),
        Size = UDim2.new(0.5, 0, 0, hasDescription and 18 or headerHeight),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })
    
    -- Description
    if hasDescription then
        Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 28),
            Size = UDim2.new(0.5, 0, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Header
        })
    end
    
    -- Selected value display
    local displayText = self.MultiSelect and (#self.Selected > 0 and table.concat(self.Selected, ", ") or "None selected") or self.Selected
    self.ValueLabel = Utility.Create("TextLabel", {
        Name = "Value",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, hasDescription and 8 or 0),
        Size = UDim2.new(0.4, -30, 0, hasDescription and 18 or headerHeight),
        Font = theme.FontSecondary,
        Text = displayText,
        TextColor3 = theme.Accent,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = self.Header
    })
    
    -- Arrow icon
    self.Arrow = Utility.Create("ImageLabel", {
        Name = "Arrow",
        BackgroundTransparency = 1,
        Image = Assets.Icons.ArrowDown,
        ImageColor3 = theme.TextMuted,
        ImageRectOffset = Assets.IconRects.ArrowDown.Offset,
        ImageRectSize = Assets.IconRects.ArrowDown.Size,
        Position = UDim2.new(1, -20, 0.5, -8),
        Size = UDim2.fromOffset(16, 16),
        Rotation = 0,
        Parent = self.Header
    })
    
    -- Options container
    self.OptionsContainer = Utility.Create("Frame", {
        Name = "Options",
        BackgroundColor3 = theme.BackgroundSecondary,
        Position = UDim2.new(0, 0, 0, headerHeight),
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Parent = self.Container
    }, {
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 6)
        }),
        Utility.Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4)
        })
    })
    
    -- Search bar (if searchable)
    if self.Searchable then
        self.SearchFrame = Utility.Create("Frame", {
            Name = "SearchFrame",
            BackgroundColor3 = theme.BackgroundTertiary,
            Size = UDim2.new(1, 0, 0, 32),
            LayoutOrder = -1,
            Parent = self.OptionsContainer
        }, {
            Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall}),
            Utility.Create("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
        })
        
        -- Search icon
        Utility.Create("ImageLabel", {
            Name = "SearchIcon",
            BackgroundTransparency = 1,
            Image = Assets.Icons.Search,
            ImageColor3 = theme.TextMuted,
            ImageRectOffset = Assets.IconRects.Search.Offset,
            ImageRectSize = Assets.IconRects.Search.Size,
            Position = UDim2.new(0, 0, 0.5, -8),
            Size = UDim2.fromOffset(16, 16),
            Parent = self.SearchFrame
        })
        
        self.SearchBox = Utility.Create("TextBox", {
            Name = "SearchBox",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 24, 0, 0),
            Size = UDim2.new(1, -24, 1, 0),
            Font = theme.FontSecondary,
            Text = "",
            PlaceholderText = "Search...",
            PlaceholderColor3 = theme.TextMuted,
            TextColor3 = theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            Parent = self.SearchFrame
        })
        
        self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            self:FilterOptions(self.SearchBox.Text)
        end)
    end
    
    -- Create options
    self:RefreshOptions()
    
    -- Header click
    local headerButton = Utility.Create("TextButton", {
        Name = "HeaderButton",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = self.Header
    })
    
    headerButton.MouseButton1Click:Connect(function()
        Utility.PlaySound(Assets.Sounds.Click)
        self:Toggle()
    end)
    
    -- Hover effects
    headerButton.MouseEnter:Connect(function()
        Utility.Tween(self.Container:FindFirstChild("Stroke"), {Color = theme.BorderLight}, AnimConfig.Hover)
        Utility.Tween(self.Arrow, {ImageColor3 = theme.Accent}, AnimConfig.Hover)
    end)
    
    headerButton.MouseLeave:Connect(function()
        Utility.Tween(self.Container:FindFirstChild("Stroke"), {Color = theme.Border}, AnimConfig.Hover)
        Utility.Tween(self.Arrow, {ImageColor3 = theme.TextMuted}, AnimConfig.Hover)
    end)
end

function Dropdown:RefreshOptions(filter)
    local theme = UltraUI.Theme
    
    -- Clear existing options (keep search frame if exists)
    for _, child in ipairs(self.OptionsContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Create options
    for i, value in ipairs(self.Values) do
        -- Filter check
        if filter and filter ~= "" then
            if not string.find(string.lower(value), string.lower(filter)) then
                continue
            end
        end
        
        local isSelected = false
        if self.MultiSelect then
            isSelected = table.find(self.Selected, value) ~= nil
        else
            isSelected = self.Selected == value
        end
        
        local option = Utility.Create("TextButton", {
            Name = "Option_" .. value,
            BackgroundColor3 = isSelected and theme.Accent or theme.BackgroundTertiary,
            Size = UDim2.new(1, 0, 0, 32),
            Font = theme.FontSecondary,
            Text = "",
            LayoutOrder = i,
            AutoButtonColor = false,
            Parent = self.OptionsContainer
        }, {
            Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall})
        })
        
        -- Option content
        local optionPadding = Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            Parent = option
        })
        
        -- Checkbox for multi-select
        if self.MultiSelect then
            local checkbox = Utility.Create("Frame", {
                Name = "Checkbox",
                BackgroundColor3 = isSelected and theme.Accent or theme.Border,
                Position = UDim2.new(0, 0, 0.5, -8),
                Size = UDim2.fromOffset(16, 16),
                Parent = option
            }, {
                Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall})
            })
            
            if isSelected then
                Utility.Create("ImageLabel", {
                    Name = "Check",
                    BackgroundTransparency = 1,
                    Image = Assets.Icons.Check,
                    ImageColor3 = theme.Background,
                    ImageRectOffset = Assets.IconRects.Check.Offset,
                    ImageRectSize = Assets.IconRects.Check.Size,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.fromOffset(12, 12),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Parent = checkbox
                })
            end
        end
        
        -- Option text
        local textOffset = self.MultiSelect and 26 or 0
        Utility.Create("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, textOffset, 0, 0),
            Size = UDim2.new(1, -textOffset - (isSelected and 20 or 0), 1, 0),
            Font = theme.FontSecondary,
            Text = value,
            TextColor3 = isSelected and (self.MultiSelect and theme.Text or theme.Background) or theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = option
        })
        
        -- Selected indicator (for single select)
        if not self.MultiSelect and isSelected then
            Utility.Create("ImageLabel", {
                Name = "SelectedIcon",
                BackgroundTransparency = 1,
                Image = Assets.Icons.Check,
                ImageColor3 = theme.Background,
                ImageRectOffset = Assets.IconRects.Check.Offset,
                ImageRectSize = Assets.IconRects.Check.Size,
                Position = UDim2.new(1, -16, 0.5, -8),
                Size = UDim2.fromOffset(16, 16),
                Parent = option
            })
        end
        
        -- Option click
        option.MouseButton1Click:Connect(function()
            Utility.PlaySound(Assets.Sounds.Click)
            self:SelectOption(value)
        end)
        
        -- Hover effects
        option.MouseEnter:Connect(function()
            local currentSelected = (self.MultiSelect and table.find(self.Selected, value)) or (not self.MultiSelect and self.Selected == value)
            if not currentSelected then
                Utility.Tween(option, {BackgroundColor3 = theme.BorderLight}, AnimConfig.Hover)
            end
        end)
        
        option.MouseLeave:Connect(function()
            local currentSelected = (self.MultiSelect and table.find(self.Selected, value)) or (not self.MultiSelect and self.Selected == value)
            if not currentSelected then
                Utility.Tween(option, {BackgroundColor3 = theme.BackgroundTertiary}, AnimConfig.Hover)
            end
        end)
    end
end

function Dropdown:FilterOptions(filter)
    self:RefreshOptions(filter)
    self:UpdateSize()
end

function Dropdown:SelectOption(value)
    local theme = UltraUI.Theme
    
    if self.MultiSelect then
        local index = table.find(self.Selected, value)
        if index then
            table.remove(self.Selected, index)
        else
            table.insert(self.Selected, value)
        end
    else
        self.Selected = value
        self:Toggle() -- Close on single select
    end
    
    -- Update display
    local displayText = self.MultiSelect and (#self.Selected > 0 and table.concat(self.Selected, ", ") or "None selected") or self.Selected
    self.ValueLabel.Text = displayText
    
    -- Refresh options
    self:RefreshOptions(self.SearchBox and self.SearchBox.Text or nil)
    
    -- Callback
    task.spawn(function()
        pcall(self.Callback, self.Selected)
    end)
end

function Dropdown:Toggle()
    local theme = UltraUI.Theme
    self.Opened = not self.Opened
    
    -- Calculate options height
    local visibleOptions = 0
    for _, child in ipairs(self.OptionsContainer:GetChildren()) do
        if child:IsA("TextButton") or (child.Name == "SearchFrame") then
            visibleOptions = visibleOptions + 1
        end
    end
    
    local optionsHeight = math.min(visibleOptions * 36 + 12, 200) -- Max height 200
    local hasDescription = self.Description and self.Description ~= ""
    local headerHeight = hasDescription and 52 or Sizes.ElementHeight
    local totalHeight = self.Opened and (headerHeight + optionsHeight) or headerHeight
    
    -- Animate
    Utility.Tween(self.Container, {Size = UDim2.new(1, 0, 0, totalHeight)}, AnimConfig.Dropdown)
    Utility.Tween(self.OptionsContainer, {Size = UDim2.new(1, 0, 0, self.Opened and optionsHeight or 0)}, AnimConfig.Dropdown)
    Utility.Tween(self.Arrow, {Rotation = self.Opened and 180 or 0}, AnimConfig.Dropdown)
    
    -- Border color
    Utility.Tween(self.Container:FindFirstChild("Stroke"), {
        Color = self.Opened and theme.Accent or theme.Border
    }, AnimConfig.Dropdown)
end

function Dropdown:UpdateSize()
    if not self.Opened then return end
    
    local visibleOptions = 0
    for _, child in ipairs(self.OptionsContainer:GetChildren()) do
        if child:IsA("TextButton") or (child.Name == "SearchFrame") then
            visibleOptions = visibleOptions + 1
        end
    end
    
    local optionsHeight = math.min(visibleOptions * 36 + 12, 200)
    local hasDescription = self.Description and self.Description ~= ""
    local headerHeight = hasDescription and 52 or Sizes.ElementHeight
    local totalHeight = headerHeight + optionsHeight
    
    Utility.Tween(self.Container, {Size = UDim2.new(1, 0, 0, totalHeight)}, AnimConfig.Fast)
    Utility.Tween(self.OptionsContainer, {Size = UDim2.new(1, 0, 0, optionsHeight)}, AnimConfig.Fast)
end

function Dropdown:Set(value)
    if self.MultiSelect then
        if type(value) == "table" then
            self.Selected = value
        end
    else
        if table.find(self.Values, value) then
            self.Selected = value
        end
    end
    
    local displayText = self.MultiSelect and (#self.Selected > 0 and table.concat(self.Selected, ", ") or "None selected") or self.Selected
    self.ValueLabel.Text = displayText
    
    self:RefreshOptions()
    task.spawn(function() pcall(self.Callback, self.Selected) end)
    
    return self
end

function Dropdown:Get()
    return self.Selected
end

function Dropdown:SetValues(values)
    self.Values = values
    self:RefreshOptions()
    return self
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- INPUT ELEMENT
-- ═══════════════════════════════════════════════════════════════════════════════
local Input = {}
Input.__index = Input

function Input.new(section, options)
    local self = setmetatable({}, Input)
    
    self.Section = section
    self.Title = options.Title or "Input"
    self.Description = options.Description
    self.Placeholder = options.Placeholder or "Enter text..."
    self.Default = options.Default or ""
    self.CharLimit = options.CharLimit
    self.NumericOnly = options.NumericOnly or false
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag
    self.Value = self.Default
    
    self:Create()
    
    if self.Flag then
        UltraUI.Flags[self.Flag] = self
    end
    
    return self
end

function Input:Create()
    local theme = UltraUI.Theme
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 80 or 68
    
    self.Container = Utility.Create("Frame", {
        Name = "Input_" .. self.Title,
        BackgroundColor3 = theme.BackgroundTertiary,
        Size = UDim2.new(1, 0, 0, height),
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
    })
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Description
    local inputY = 24
    if hasDescription then
        Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 20),
            Size = UDim2.new(1, 0, 0, 14),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
        inputY = 38
    end
    
    -- Input frame
    self.InputFrame = Utility.Create("Frame", {
        Name = "InputFrame",
        BackgroundColor3 = theme.BackgroundSecondary,
        Position = UDim2.new(0, 0, 0, inputY),
        Size = UDim2.new(1, 0, 0, 30),
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall}),
        Utility.Create("UIStroke", {
            Name = "InputStroke",
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12)
        })
    })
    
    -- Text box
    self.TextBox = Utility.Create("TextBox", {
        Name = "TextBox",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, self.CharLimit and -40 or 0, 1, 0),
        Font = theme.FontSecondary,
        Text = self.Value,
        PlaceholderText = self.Placeholder,
        PlaceholderColor3 = theme.TextMuted,
        TextColor3 = theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = self.InputFrame
    })
    
    -- Character counter
    if self.CharLimit then
        self.CharCounter = Utility.Create("TextLabel", {
            Name = "CharCounter",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -35, 0, 0),
            Size = UDim2.new(0, 35, 1, 0),
            Font = theme.FontSecondary,
            Text = #self.Value .. "/" .. self.CharLimit,
            TextColor3 = theme.TextMuted,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = self.InputFrame
        })
    end
    
    -- Clear button
    self.ClearButton = Utility.Create("TextButton", {
        Name = "ClearButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 0.5, -8),
        Size = UDim2.fromOffset(16, 16),
        Text = "×",
        TextColor3 = theme.TextMuted,
        TextSize = 16,
        Font = theme.Font,
        Visible = #self.Value > 0,
        Parent = self.InputFrame
    })
    
    -- Events
    local inputStroke = self.InputFrame:FindFirstChild("InputStroke")
    
    self.TextBox.Focused:Connect(function()
        Utility.Tween(inputStroke, {Color = theme.Accent}, AnimConfig.Fast)
        Utility.Tween(self.InputFrame, {BackgroundColor3 = Utility.Lighten(theme.BackgroundSecondary, 0.02)}, AnimConfig.Fast)
        self.ClearButton.Visible = true
    end)
    
    self.TextBox.FocusLost:Connect(function(enterPressed)
        Utility.Tween(inputStroke, {Color = theme.Border}, AnimConfig.Fast)
        Utility.Tween(self.InputFrame, {BackgroundColor3 = theme.BackgroundSecondary}, AnimConfig.Fast)
        
        self.Value = self.TextBox.Text
        self.ClearButton.Visible = #self.Value > 0
        
        task.spawn(function()
            pcall(self.Callback, self.Value, enterPressed)
        end)
    end)
    
    self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = self.TextBox.Text
        
        -- Numeric only filter
        if self.NumericOnly then
            text = text:gsub("[^%d%.%-]", "")
            self.TextBox.Text = text
        end
        
        -- Character limit
        if self.CharLimit and #text > self.CharLimit then
            self.TextBox.Text = text:sub(1, self.CharLimit)
            text = self.TextBox.Text
        end
        
        -- Update counter
        if self.CharCounter then
            self.CharCounter.Text = #text .. "/" .. self.CharLimit
            self.CharCounter.TextColor3 = #text >= self.CharLimit and theme.Error or theme.TextMuted
        end
        
        self.ClearButton.Visible = #text > 0
    end)
    
    self.ClearButton.MouseButton1Click:Connect(function()
        self.TextBox.Text = ""
        self.Value = ""
        self.TextBox:CaptureFocus()
    end)
    
    self.ClearButton.MouseEnter:Connect(function()
        Utility.Tween(self.ClearButton, {TextColor3 = theme.Error}, AnimConfig.Fast)
    end)
    
    self.ClearButton.MouseLeave:Connect(function()
        Utility.Tween(self.ClearButton, {TextColor3 = theme.TextMuted}, AnimConfig.Fast)
    end)
end

function Input:Set(value)
    self.Value = tostring(value)
    self.TextBox.Text = self.Value
    task.spawn(function() pcall(self.Callback, self.Value) end)
    return self
end

function Input:Get()
    return self.Value
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- KEYBIND ELEMENT
-- ═══════════════════════════════════════════════════════════════════════════════
local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(section, options)
    local self = setmetatable({}, Keybind)
    
    self.Section = section
    self.Title = options.Title or "Keybind"
    self.Description = options.Description
    self.Default = options.Default or Enum.KeyCode.Unknown
    self.Callback = options.Callback or function() end
    self.ChangedCallback = options.ChangedCallback or function() end
    self.Flag = options.Flag
    self.Key = self.Default
    self.Listening = false
    
    self:Create()
    self:SetupListener()
    
    if self.Flag then
        UltraUI.Flags[self.Flag] = self
    end
    
    return self
end

function Keybind:Create()
    local theme = UltraUI.Theme
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 52 or Sizes.ElementHeight
    
    self.Container = Utility.Create("Frame", {
        Name = "Keybind_" .. self.Title,
        BackgroundColor3 = theme.BackgroundTertiary,
        Size = UDim2.new(1, 0, 0, height),
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, hasDescription and 8 or 0),
        Size = UDim2.new(1, -90, 0, hasDescription and 18 or height),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Description
    if hasDescription then
        Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 28),
            Size = UDim2.new(1, -90, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Key button
    self.KeyButton = Utility.Create("TextButton", {
        Name = "KeyButton",
        BackgroundColor3 = theme.BackgroundSecondary,
        Position = UDim2.new(1, -80, 0.5, -14),
        Size = UDim2.new(0, 80, 0, 28),
        Font = theme.Font,
        Text = self:GetKeyName(),
        TextColor3 = theme.Accent,
        TextSize = 12,
        AutoButtonColor = false,
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall}),
        Utility.Create("UIStroke", {
            Name = "KeyStroke",
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        })
    })
    
    -- Keyboard icon
    Utility.Create("ImageLabel", {
        Name = "KeyIcon",
        BackgroundTransparency = 1,
        Image = Assets.Icons.Settings,
        ImageColor3 = theme.TextMuted,
        ImageRectOffset = Assets.IconRects.Settings.Offset,
        ImageRectSize = Assets.IconRects.Settings.Size,
        Position = UDim2.new(0, 6, 0.5, -6),
        Size = UDim2.fromOffset(12, 12),
        Parent = self.KeyButton
    })
    
    -- Events
    self.KeyButton.MouseButton1Click:Connect(function()
        Utility.PlaySound(Assets.Sounds.Click)
        self:StartListening()
    end)
    
    self.KeyButton.MouseEnter:Connect(function()
        if not self.Listening then
            Utility.Tween(self.KeyButton, {BackgroundColor3 = theme.BorderLight}, AnimConfig.Hover)
        end
    end)
    
    self.KeyButton.MouseLeave:Connect(function()
        if not self.Listening then
            Utility.Tween(self.KeyButton, {BackgroundColor3 = theme.BackgroundSecondary}, AnimConfig.Hover)
        end
    end)
end

function Keybind:GetKeyName()
    if self.Key == Enum.KeyCode.Unknown then
        return "None"
    end
    
    local shortcuts = {
        LeftShift = "LShift", RightShift = "RShift",
        LeftControl = "LCtrl", RightControl = "RCtrl",
        LeftAlt = "LAlt", RightAlt = "RAlt",
        Backspace = "Back", CapsLock = "Caps",
        Return = "Enter", Escape = "Esc",
        LeftBracket = "[", RightBracket = "]",
        Semicolon = ";", Quote = "'",
        BackSlash = "\\", Comma = ",",
        Period = ".", Slash = "/",
        Minus = "-", Equals = "=",
        Backquote = "`", Space = "Space"
    }
    
    return shortcuts[self.Key.Name] or self.Key.Name
end

function Keybind:StartListening()
    local theme = UltraUI.Theme
    self.Listening = true
    self.KeyButton.Text = "..."
    
    Utility.Tween(self.KeyButton, {BackgroundColor3 = theme.Accent}, AnimConfig.Fast)
    Utility.Tween(self.KeyButton:FindFirstChild("KeyStroke"), {Color = theme.AccentDark}, AnimConfig.Fast)
    self.KeyButton.TextColor3 = theme.Background
end

function Keybind:StopListening(newKey)
    local theme = UltraUI.Theme
    self.Listening = false
    
    if newKey then
        self.Key = newKey
        task.spawn(function() pcall(self.ChangedCallback, newKey) end)
    end
    
    self.KeyButton.Text = self:GetKeyName()
    
    Utility.Tween(self.KeyButton, {BackgroundColor3 = theme.BackgroundSecondary}, AnimConfig.Fast)
    Utility.Tween(self.KeyButton:FindFirstChild("KeyStroke"), {Color = theme.Border}, AnimConfig.Fast)
    self.KeyButton.TextColor3 = theme.Accent
end

function Keybind:SetupListener()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if self.Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape then
                    Utility.PlaySound(Assets.Sounds.Error)
                    self:StopListening()
                else
                    Utility.PlaySound(Assets.Sounds.Success)
                    self:StopListening(input.KeyCode)
                end
            end
            return
        end
        
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == self.Key then
                task.spawn(function() pcall(self.Callback, self.Key) end)
            end
        end
    end)
end

function Keybind:Set(key)
    self.Key = key
    self.KeyButton.Text = self:GetKeyName()
    return self
end

function Keybind:Get()
    return self.Key
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COLOR PICKER ELEMENT
-- ═══════════════════════════════════════════════════════════════════════════════
local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(section, options)
    local self = setmetatable({}, ColorPicker)
    
    self.Section = section
    self.Title = options.Title or "Color Picker"
    self.Description = options.Description
    self.Default = options.Default or Color3.fromRGB(255, 255, 255)
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag
    self.Color = self.Default
    self.Opened = false
    
    self:Create()
    
    if self.Flag then
        UltraUI.Flags[self.Flag] = self
    end
    
    return self
end

function ColorPicker:Create()
    local theme = UltraUI.Theme
    local hasDescription = self.Description and self.Description ~= ""
    local headerHeight = hasDescription and 52 or Sizes.ElementHeight
    
    self.Container = Utility.Create("Frame", {
        Name = "ColorPicker_" .. self.Title,
        BackgroundColor3 = theme.BackgroundTertiary,
        Size = UDim2.new(1, 0, 0, headerHeight),
        ClipsDescendants = true,
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, hasDescription and 8 or 0),
        Size = UDim2.new(1, -50, 0, hasDescription and 18 or headerHeight),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Description
    if hasDescription then
        Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 28),
            Size = UDim2.new(1, -50, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Color preview
    self.ColorPreview = Utility.Create("TextButton", {
        Name = "ColorPreview",
        BackgroundColor3 = self.Color,
        Position = UDim2.new(1, -40, 0.5, -12),
        Size = UDim2.new(0, 40, 0, 24),
        Text = "",
        AutoButtonColor = false,
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall}),
        Utility.Create("UIStroke", {
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        })
    })
    
    -- Picker panel
    self.Panel = Utility.Create("Frame", {
        Name = "Panel",
        BackgroundColor3 = theme.BackgroundSecondary,
        Position = UDim2.new(0, -14, 0, headerHeight),
        Size = UDim2.new(1, 28, 0, 0),
        ClipsDescendants = true,
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall}),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12)
        })
    })
    
    -- RGB Sliders
    self.RGBSliders = {}
    local sliders = {
        {Name = "R", Color = Color3.fromRGB(255, 100, 100), Value = self.Color.R * 255},
        {Name = "G", Color = Color3.fromRGB(100, 255, 100), Value = self.Color.G * 255},
        {Name = "B", Color = Color3.fromRGB(100, 100, 255), Value = self.Color.B * 255}
    }
    
    for i, data in ipairs(sliders) do
        local sliderContainer = Utility.Create("Frame", {
            Name = data.Name .. "Slider",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, (i - 1) * 32),
            Size = UDim2.new(1, 0, 0, 28),
            Parent = self.Panel
        })
        
        -- Label
        Utility.Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 1, 0),
            Font = theme.Font,
            Text = data.Name,
            TextColor3 = data.Color,
            TextSize = 13,
            Parent = sliderContainer
        })
        
        -- Track
        local track = Utility.Create("Frame", {
            Name = "Track",
            BackgroundColor3 = theme.Border,
            Position = UDim2.new(0, 30, 0.5, -4),
            Size = UDim2.new(1, -90, 0, 8),
            Parent = sliderContainer
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        })
        
        -- Fill
        local fill = Utility.Create("Frame", {
            Name = "Fill",
            BackgroundColor3 = data.Color,
            Size = UDim2.new(data.Value / 255, 0, 1, 0),
            Parent = track
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        })
        
        -- Value label
        local valueLabel = Utility.Create("TextLabel", {
            Name = "Value",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -50, 0, 0),
            Size = UDim2.new(0, 50, 1, 0),
            Font = theme.Font,
            Text = tostring(math.floor(data.Value)),
            TextColor3 = theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = sliderContainer
        })
        
        self.RGBSliders[data.Name] = {
            Track = track,
            Fill = fill,
            ValueLabel = valueLabel,
            Value = data.Value,
            Color = data.Color
        }
        
        -- Slider interaction
        local dragging = false
        local inputBtn = Utility.Create("TextButton", {
            Name = "Input",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 30, 0, 0),
            Size = UDim2.new(1, -90, 1, 0),
            Text = "",
            Parent = sliderContainer
        })
        
        local function updateRGBSlider(inputX)
            local trackPos = track.AbsolutePosition.X
            local trackSize = track.AbsoluteSize.X
            local relPos = Utility.Clamp((inputX - trackPos) / trackSize, 0, 1)
            local value = math.floor(relPos * 255)
            
            self.RGBSliders[data.Name].Value = value
            fill.Size = UDim2.new(value / 255, 0, 1, 0)
            valueLabel.Text = tostring(value)
            
            self:UpdateColor()
        end
        
        inputBtn.MouseButton1Down:Connect(function()
            dragging = true
            updateRGBSlider(Utility.GetMousePosition().X)
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        RunService.RenderStepped:Connect(function()
            if dragging then
                updateRGBSlider(Utility.GetMousePosition().X)
            end
        end)
    end
    
    -- Hex input
    local hexFrame = Utility.Create("Frame", {
        Name = "HexFrame",
        BackgroundColor3 = theme.BackgroundTertiary,
        Position = UDim2.new(0, 0, 0, 100),
        Size = UDim2.new(1, 0, 0, 28),
        Parent = self.Panel
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall}),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        })
    })
    
    Utility.Create("TextLabel", {
        Name = "HashLabel",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 15, 1, 0),
        Font = theme.Font,
        Text = "#",
        TextColor3 = theme.TextMuted,
        TextSize = 13,
        Parent = hexFrame
    })
    
    self.HexInput = Utility.Create("TextBox", {
        Name = "HexInput",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -15, 1, 0),
        Font = theme.FontMono,
        Text = self:ColorToHex(self.Color),
        TextColor3 = theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = hexFrame
    })
    
    self.HexInput.FocusLost:Connect(function()
        local hex = self.HexInput.Text:gsub("#", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1, 2), 16)
            local g = tonumber(hex:sub(3, 4), 16)
            local b = tonumber(hex:sub(5, 6), 16)
            if r and g and b then
                self:Set(Color3.fromRGB(r, g, b))
            end
        end
        self.HexInput.Text = self:ColorToHex(self.Color)
    end)
    
    -- Toggle panel
    self.ColorPreview.MouseButton1Click:Connect(function()
        Utility.PlaySound(Assets.Sounds.Click)
        self:Toggle()
    end)
end

function ColorPicker:ColorToHex(color)
    return string.format("%02X%02X%02X", 
        math.floor(color.R * 255), 
        math.floor(color.G * 255), 
        math.floor(color.B * 255)
    )
end

function ColorPicker:UpdateColor()
    local r = self.RGBSliders["R"].Value
    local g = self.RGBSliders["G"].Value
    local b = self.RGBSliders["B"].Value
    
    self.Color = Color3.fromRGB(r, g, b)
    self.ColorPreview.BackgroundColor3 = self.Color
    self.HexInput.Text = self:ColorToHex(self.Color)
    
    task.spawn(function() pcall(self.Callback, self.Color) end)
end

function ColorPicker:Toggle()
    local theme = UltraUI.Theme
    self.Opened = not self.Opened
    
    local hasDescription = self.Description and self.Description ~= ""
    local headerHeight = hasDescription and 52 or Sizes.ElementHeight
    local panelHeight = self.Opened and 145 or 0
    local totalHeight = headerHeight + panelHeight
    
    Utility.Tween(self.Container, {Size = UDim2.new(1, 0, 0, totalHeight)}, AnimConfig.Dropdown)
    Utility.Tween(self.Panel, {Size = UDim2.new(1, 28, 0, panelHeight)}, AnimConfig.Dropdown)
    Utility.Tween(self.Container:FindFirstChild("Stroke"), {
        Color = self.Opened and theme.Accent or theme.Border
    }, AnimConfig.Dropdown)
end

function ColorPicker:Set(color)
    self.Color = color
    self.ColorPreview.BackgroundColor3 = color
    
    -- Update sliders
    self.RGBSliders["R"].Value = math.floor(color.R * 255)
    self.RGBSliders["G"].Value = math.floor(color.G * 255)
    self.RGBSliders["B"].Value = math.floor(color.B * 255)
    
    for name, slider in pairs(self.RGBSliders) do
        slider.Fill.Size = UDim2.new(slider.Value / 255, 0, 1, 0)
        slider.ValueLabel.Text = tostring(slider.Value)
    end
    
    self.HexInput.Text = self:ColorToHex(color)
    
    task.spawn(function() pcall(self.Callback, self.Color) end)
    return self
end

function ColorPicker:Get()
    return self.Color
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- LABEL ELEMENT
-- ═══════════════════════════════════════════════════════════════════════════════
local Label = {}
Label.__index = Label

function Label.new(section, options)
    local self = setmetatable({}, Label)
    
    self.Section = section
    self.Title = options.Title or "Label"
    self.Description = options.Description
    self.Icon = options.Icon
    
    self:Create()
    
    return self
end

function Label:Create()
    local theme = UltraUI.Theme
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 52 or 32
    
    self.Container = Utility.Create("Frame", {
        Name = "Label_" .. self.Title,
        BackgroundColor3 = theme.BackgroundTertiary,
        Size = UDim2.new(1, 0, 0, height),
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    local textOffset = 0
    
    -- Icon
    if self.Icon then
        local iconData = Assets.IconRects[self.Icon] or {}
        Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = Assets.Icons[self.Icon] or Assets.Icons.Info,
            ImageColor3 = theme.Accent,
            ImageRectOffset = iconData.Offset or Vector2.new(0, 0),
            ImageRectSize = iconData.Size or Vector2.new(0, 0),
            Position = UDim2.new(0, 0, 0, hasDescription and 8 or 6),
            Size = UDim2.fromOffset(20, 20),
            Parent = self.Container
        })
        textOffset = 30
    end
    
    -- Title
    self.TitleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, textOffset, 0, hasDescription and 6 or 0),
        Size = UDim2.new(1, -textOffset, 0, hasDescription and 18 or height),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Description
    if hasDescription then
        self.DescLabel = Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, textOffset, 0, 26),
            Size = UDim2.new(1, -textOffset, 0, 18),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = self.Container
        })
    end
end

function Label:Set(title, description)
    if title then
        self.Title = title
        self.TitleLabel.Text = title
    end
    if description and self.DescLabel then
        self.Description = description
        self.DescLabel.Text = description
    end
    return self
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SEPARATOR ELEMENT
-- ═══════════════════════════════════════════════════════════════════════════════
local Separator = {}
Separator.__index = Separator

function Separator.new(section, options)
    local self = setmetatable({}, Separator)
    
    self.Section = section
    self.Text = options.Text
    
    self:Create()
    
    return self
end

function Separator:Create()
    local theme = UltraUI.Theme
    local hasText = self.Text and self.Text ~= ""
    
    self.Container = Utility.Create("Frame", {
        Name = "Separator",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, hasText and 28 or 16),
        Parent = self.Section.Content
    })
    
    if hasText then
        Utility.Create("Frame", {
            Name = "LeftLine",
            BackgroundColor3 = theme.Border,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0.25, -10, 0, 1),
            Parent = self.Container
        })
        
        Utility.Create("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.25, 0, 0, 0),
            Size = UDim2.new(0.5, 0, 1, 0),
            Font = theme.FontSecondary,
            Text = self.Text,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            Parent = self.Container
        })
        
        Utility.Create("Frame", {
            Name = "RightLine",
            BackgroundColor3 = theme.Border,
            Position = UDim2.new(0.75, 10, 0.5, 0),
            Size = UDim2.new(0.25, -10, 0, 1),
            Parent = self.Container
        })
    else
        Utility.Create("Frame", {
            Name = "Line",
            BackgroundColor3 = theme.Border,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 0, 1),
            Parent = self.Container
        })
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SECTION CLASS
-- ═══════════════════════════════════════════════════════════════════════════════
local Section = {}
Section.__index = Section

function Section.new(tab, options)
    local self = setmetatable({}, Section)
    
    self.Tab = tab
    self.Name = options.Name or "Section"
    self.Icon = options.Icon
    self.Opened = options.Opened ~= false
    self.Elements = {}
    
    self:Create()
    
    return self
end

function Section:Create()
    local theme = UltraUI.Theme
    
    self.Container = Utility.Create("Frame", {
        Name = "Section_" .. self.Name,
        BackgroundColor3 = theme.BackgroundSecondary,
        Size = UDim2.new(1, -20, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = self.Tab.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerMedium}),
        Utility.Create("UIStroke", {
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12)
        })
    })
    
    -- Add glass effect
    Effects.CreateGlass(self.Container)
    
    -- Header
    self.Header = Utility.Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, Sizes.SectionHeaderHeight),
        Parent = self.Container
    })
    
    local titleOffset = 0
    
    -- Icon
    if self.Icon then
        local iconData = Assets.IconRects[self.Icon] or {}
        Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = Assets.Icons[self.Icon] or Assets.Icons.Settings,
            ImageColor3 = theme.Accent,
            ImageRectOffset = iconData.Offset or Vector2.new(0, 0),
            ImageRectSize = iconData.Size or Vector2.new(0, 0),
            Position = UDim2.new(0, 0, 0.5, -10),
            Size = UDim2.fromOffset(20, 20),
            Parent = self.Header
        })
        titleOffset = 28
    end
    
    -- Title
    self.TitleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, titleOffset, 0, 0),
        Size = UDim2.new(1, -titleOffset - 30, 1, 0),
        Font = theme.Font,
        Text = self.Name,
        TextColor3 = theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })
    
    -- Arrow
    self.Arrow = Utility.Create("ImageLabel", {
        Name = "Arrow",
        BackgroundTransparency = 1,
        Image = Assets.Icons.ArrowDown,
        ImageColor3 = theme.TextMuted,
        ImageRectOffset = Assets.IconRects.ArrowDown.Offset,
        ImageRectSize = Assets.IconRects.ArrowDown.Size,
        Position = UDim2.new(1, -16, 0.5, -8),
        Size = UDim2.fromOffset(16, 16),
        Rotation = self.Opened and 0 or -90,
        Parent = self.Header
    })
    
    -- Content
    self.Content = Utility.Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, Sizes.SectionHeaderHeight),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Visible = self.Opened,
        Parent = self.Container
    }, {
        Utility.Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, Sizes.SpacingMedium)
        })
    })
    
    -- Toggle section
    local headerButton = Utility.Create("TextButton", {
        Name = "HeaderButton",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = self.Header
    })
    
    headerButton.MouseButton1Click:Connect(function()
        Utility.PlaySound(Assets.Sounds.Click)
        self:Toggle()
    end)
    
    headerButton.MouseEnter:Connect(function()
        Utility.Tween(self.Arrow, {ImageColor3 = theme.Accent}, AnimConfig.Hover)
    end)
    
    headerButton.MouseLeave:Connect(function()
        Utility.Tween(self.Arrow, {ImageColor3 = theme.TextMuted}, AnimConfig.Hover)
    end)
end

function Section:Toggle()
    self.Opened = not self.Opened
    self.Content.Visible = self.Opened
    Utility.Tween(self.Arrow, {Rotation = self.Opened and 0 or -90}, AnimConfig.Normal)
end

function Section:AddToggle(options) return Toggle.new(self, options) end
function Section:AddButton(options) return Button.new(self, options) end
function Section:AddSlider(options) return Slider.new(self, options) end
function Section:AddDropdown(options) return Dropdown.new(self, options) end
function Section:AddInput(options) return Input.new(self, options) end
function Section:AddKeybind(options) return Keybind.new(self, options) end
function Section:AddColorPicker(options) return ColorPicker.new(self, options) end
function Section:AddLabel(options) return Label.new(self, options) end
function Section:AddSeparator(options) return Separator.new(self, options or {}) end

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB CLASS
-- ═══════════════════════════════════════════════════════════════════════════════
local Tab = {}
Tab.__index = Tab

function Tab.new(window, options)
    local self = setmetatable({}, Tab)
    
    self.Window = window
    self.Name = options.Name or "Tab"
    self.Icon = options.Icon
    self.Sections = {}
    self.Active = false
    
    self:Create()
    
    return self
end

function Tab:Create()
    local theme = UltraUI.Theme
    
    -- Tab button
    self.Button = Utility.Create("TextButton", {
        Name = "TabButton_" .. self.Name,
        BackgroundColor3 = theme.BackgroundTertiary,
        Size = UDim2.new(0, 0, 1, -8),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = theme.Font,
        Text = "",
        AutoButtonColor = false,
        Parent = self.Window.TabContainer
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall}),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Icon
    local textOffset = 0
    if self.Icon then
        local iconData = Assets.IconRects[self.Icon] or {}
        self.IconImage = Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = Assets.Icons[self.Icon] or Assets.Icons.Settings,
            ImageColor3 = theme.TextMuted,
            ImageRectOffset = iconData.Offset or Vector2.new(0, 0),
            ImageRectSize = iconData.Size or Vector2.new(0, 0),
            Position = UDim2.new(0, 0, 0.5, -8),
            Size = UDim2.fromOffset(16, 16),
            Parent = self.Button
        })
        textOffset = 22
    end
    
    -- Tab text
    self.TextLabel = Utility.Create("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, textOffset, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = theme.Font,
        Text = self.Name,
        TextColor3 = theme.TextMuted,
        TextSize = 13,
        Parent = self.Button
    })
    
    -- Tab content
    self.Content = Utility.Create("ScrollingFrame", {
        Name = "TabContent_" .. self.Name,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.Accent,
        ScrollBarImageTransparency = 0.5,
        Visible = false,
        Parent = self.Window.ContentContainer
    }, {
        Utility.Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        }),
        Utility.Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
    })
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        Utility.PlaySound(Assets.Sounds.Click)
        self.Window:SelectTab(self)
    end)
    
    self.Button.MouseEnter:Connect(function()
        if not self.Active then
            Utility.Tween(self.Button, {BackgroundColor3 = theme.BorderLight}, AnimConfig.Hover)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Active then
            Utility.Tween(self.Button, {BackgroundColor3 = theme.BackgroundTertiary}, AnimConfig.Hover)
        end
    end)
end

function Tab:SetActive(active)
    local theme = UltraUI.Theme
    self.Active = active
    self.Content.Visible = active
    
    if active then
        Utility.Tween(self.Button, {BackgroundColor3 = theme.Accent}, AnimConfig.TabSwitch)
        Utility.Tween(self.TextLabel, {TextColor3 = theme.Background}, AnimConfig.TabSwitch)
        if self.IconImage then
            Utility.Tween(self.IconImage, {ImageColor3 = theme.Background}, AnimConfig.TabSwitch)
        end
    else
        Utility.Tween(self.Button, {BackgroundColor3 = theme.BackgroundTertiary}, AnimConfig.TabSwitch)
        Utility.Tween(self.TextLabel, {TextColor3 = theme.TextMuted}, AnimConfig.TabSwitch)
        if self.IconImage then
            Utility.Tween(self.IconImage, {ImageColor3 = theme.TextMuted}, AnimConfig.TabSwitch)
        end
    end
end

function Tab:AddSection(options)
    local section = Section.new(self, options)
    table.insert(self.Sections, section)
    return section
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- WINDOW CLASS
-- ═══════════════════════════════════════════════════════════════════════════════
local Window = {}
Window.__index = Window

function Window.new(library, options)
    local self = setmetatable({}, Window)
    
    self.Library = library
    self.Title = options.Title or "Ultra UI"
    self.Subtitle = options.Subtitle
    self.Size = options.Size or Sizes.WindowDefault
    self.Position = options.Position or UDim2.new(0.5, -275, 0.5, -325)
    self.Icon = options.Icon
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.Visible = true
    
    self:Create()
    
    table.insert(library.Windows, self)
    
    return self
end

function Window:Create()
    local theme = UltraUI.Theme
    
    self.ScreenGui = CreateScreenGui()
    if not self.ScreenGui then return end
    
    -- Main frame
    self.MainFrame = Utility.Create("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = theme.Background,
        Position = self.Position,
        Size = self.Size,
        Parent = self.ScreenGui
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerLarge}),
        Utility.Create("UIStroke", {
            Name = "MainStroke",
            Color = theme.Border,
            Thickness = Sizes.StrokeThin
        })
    })
    
    -- Shadow
    Effects.CreateShadow(self.MainFrame, 8, 0.6)
    
    -- Glow effect
    self.WindowGlow = Effects.CreateGlow(self.MainFrame, theme.Glow, 0.1)
    
    -- Title bar
    self.TitleBar = Utility.Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = theme.BackgroundSecondary,
        Size = UDim2.new(1, 0, 0, 50),
        Parent = self.MainFrame
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerLarge})
    })
    
    -- Title bar bottom cover
    Utility.Create("Frame", {
        Name = "TitleBarCover",
        BackgroundColor3 = theme.BackgroundSecondary,
        Position = UDim2.new(0, 0, 1, -14),
        Size = UDim2.new(1, 0, 0, 14),
        Parent = self.TitleBar
    })
    
    -- Decorative accent line
    self.AccentLine = Utility.Create("Frame", {
        Name = "AccentLine",
        BackgroundColor3 = theme.Accent,
        Position = UDim2.new(0, 20, 1, -2),
        Size = UDim2.new(0, 100, 0, 2),
        Parent = self.TitleBar
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Animate accent line
    task.spawn(function()
        while self.MainFrame and self.MainFrame.Parent do
            Utility.Tween(self.AccentLine, {Size = UDim2.new(0, 150, 0, 2)}, 1.5)
            task.wait(1.5)
            Utility.Tween(self.AccentLine, {Size = UDim2.new(0, 80, 0, 2)}, 1.5)
            task.wait(1.5)
        end
    end)
    
    -- Icon
    local titleOffset = 20
    if self.Icon then
        local iconData = Assets.IconRects[self.Icon] or {}
        self.IconImage = Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = Assets.Icons[self.Icon] or Assets.Icons.Settings,
            ImageColor3 = theme.Accent,
            ImageRectOffset = iconData.Offset or Vector2.new(0, 0),
            ImageRectSize = iconData.Size or Vector2.new(0, 0),
            Position = UDim2.new(0, 20, 0, 12),
            Size = UDim2.fromOffset(26, 26),
            Parent = self.TitleBar
        })
        
        Effects.CreateGlow(self.IconImage, theme.Accent, 0.3)
        titleOffset = 56
    end
    
    -- Title
    Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, titleOffset, 0, self.Subtitle and 8 or 0),
        Size = UDim2.new(1, -titleOffset - 100, 0, self.Subtitle and 22 or 50),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TitleBar
    })
    
                -- Subtitle (continued)
            Size = UDim2.new(1, -titleOffset - 100, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Subtitle,
            TextColor3 = theme.TextMuted,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.TitleBar
        })
    end
    
    -- Window controls
    local controlsFrame = Utility.Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -90, 0, 10),
        Size = UDim2.new(0, 80, 0, 30),
        Parent = self.TitleBar
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8)
        })
    })
    
    -- Minimize button
    self.MinimizeBtn = Utility.Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = theme.Warning,
        Size = UDim2.fromOffset(28, 28),
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 1,
        Parent = controlsFrame
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall})
    })
    
    Utility.Create("Frame", {
        Name = "MinusIcon",
        BackgroundColor3 = theme.Background,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(12, 2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = self.MinimizeBtn
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Close button
    self.CloseBtn = Utility.Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = theme.Error,
        Size = UDim2.fromOffset(28, 28),
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 2,
        Parent = controlsFrame
    }, {
        Utility.Create("UICorner", {CornerRadius = Sizes.CornerSmall})
    })
    
    Utility.Create("TextLabel", {
        Name = "XIcon",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = theme.Font,
        Text = "×",
        TextColor3 = theme.Text,
        TextSize = 20,
        Parent = self.CloseBtn
    })
    
    -- Tab container
    self.TabContainer = Utility.Create("Frame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 55),
        Size = UDim2.new(1, -24, 0, Sizes.TabHeight),
        Parent = self.MainFrame
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6)
        })
    })
    
    -- Content container
    self.ContentContainer = Utility.Create("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 105),
        Size = UDim2.new(1, 0, 1, -115),
        ClipsDescendants = true,
        Parent = self.MainFrame
    })
    
    -- Setup dragging
    self:SetupDragging()
    
    -- Button events
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        Utility.PlaySound(Assets.Sounds.Click)
        self:Minimize()
    end)
    
    self.CloseBtn.MouseButton1Click:Connect(function()
        Utility.PlaySound(Assets.Sounds.Click)
        self:Close()
    end)
    
    -- Button hover effects
    for _, btn in ipairs({self.MinimizeBtn, self.CloseBtn}) do
        btn.MouseEnter:Connect(function()
            Utility.Spring(btn, {Size = UDim2.fromOffset(30, 30)}, AnimConfig.Fast)
        end)
        btn.MouseLeave:Connect(function()
            Utility.Spring(btn, {Size = UDim2.fromOffset(28, 28)}, AnimConfig.Fast)
        end)
    end
    
    -- Open animation
    self.MainFrame.Size = UDim2.fromOffset(0, 0)
    self.MainFrame.Position = UDim2.new(
        self.Position.X.Scale,
        self.Position.X.Offset + self.Size.X.Offset / 2,
        self.Position.Y.Scale,
        self.Position.Y.Offset + self.Size.Y.Offset / 2
    )
    self.MainFrame.BackgroundTransparency = 1
    
    Utility.Tween(self.MainFrame, {
        Size = self.Size,
        Position = self.Position,
        BackgroundTransparency = 0
    }, AnimConfig.WindowOpen, AnimConfig.Bounce.Style, AnimConfig.Bounce.Direction)
end

function Window:SetupDragging()
    local dragging, dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Window:AddTab(options)
    local tab = Tab.new(self, options)
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(tab)
    if self.ActiveTab then
        self.ActiveTab:SetActive(false)
    end
    
    tab:SetActive(true)
    self.ActiveTab = tab
end

function Window:Minimize()
    local theme = UltraUI.Theme
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        Utility.Tween(self.MainFrame, {
            Size = UDim2.new(self.Size.X.Scale, self.Size.X.Offset, 0, 50)
        }, AnimConfig.Normal)
        self.ContentContainer.Visible = false
        self.TabContainer.Visible = false
    else
        Utility.Tween(self.MainFrame, {Size = self.Size}, AnimConfig.Normal)
        task.delay(AnimConfig.Normal * 0.5, function()
            self.ContentContainer.Visible = true
            self.TabContainer.Visible = true
        end)
    end
end

function Window:Close()
    local theme = UltraUI.Theme
    
    Utility.Tween(self.MainFrame, {
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.new(
            self.MainFrame.Position.X.Scale,
            self.MainFrame.Position.X.Offset + self.MainFrame.Size.X.Offset / 2,
            self.MainFrame.Position.Y.Scale,
            self.MainFrame.Position.Y.Offset + self.MainFrame.Size.Y.Offset / 2
        ),
        BackgroundTransparency = 1
    }, AnimConfig.WindowClose)
    
    task.delay(AnimConfig.WindowClose, function()
        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
    end)
end

function Window:Toggle()
    self.Visible = not self.Visible
    self.MainFrame.Visible = self.Visible
end

function Window:Show()
    self.Visible = true
    self.MainFrame.Visible = true
end

function Window:Hide()
    self.Visible = false
    self.MainFrame.Visible = false
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- LIBRARY MAIN FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function UltraUI:CreateWindow(options)
    return Window.new(self, options or {})
end

function UltraUI:SetTheme(themeName)
    if type(themeName) == "string" then
        if Themes[themeName] then
            self.Theme = Themes[themeName]
        else
            warn("[UltraUI] Theme not found:", themeName)
        end
    elseif type(themeName) == "table" then
        for key, value in pairs(themeName) do
            if self.Theme[key] ~= nil then
                self.Theme[key] = value
            end
        end
    end
    return self
end

function UltraUI:GetThemes()
    local themeNames = {}
    for name, _ in pairs(Themes) do
        table.insert(themeNames, name)
    end
    return themeNames
end

function UltraUI:SetToggleKey(keyCode)
    self.ToggleKey = keyCode
    return self
end

function UltraUI:EnableSounds(enabled)
    self.SoundsEnabled = enabled
    return self
end

function UltraUI:EnableAnimations(enabled)
    self.AnimationsEnabled = enabled
    return self
end

function UltraUI:EnableGlow(enabled)
    self.GlowEnabled = enabled
    return self
end

function UltraUI:GetFlag(flagName)
    return self.Flags[flagName]
end

function UltraUI:SetFlag(flagName, value)
    local flag = self.Flags[flagName]
    if flag and flag.Set then
        flag:Set(value)
    end
    return self
end

function UltraUI:Destroy()
    for _, window in ipairs(self.Windows) do
        if window.ScreenGui then
            window.ScreenGui:Destroy()
        end
    end
    
    self.Windows = {}
    self.Flags = {}
    Utility.DisconnectAll(self.Connections)
    self.Connections = {}
    
    if NotificationContainer then
        NotificationContainer:Destroy()
        NotificationContainer = nil
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- TOGGLE KEY HANDLER
-- ═══════════════════════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == UltraUI.ToggleKey then
        for _, window in ipairs(UltraUI.Windows) do
            window:Toggle()
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- RETURN LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════════
return UltraUI
