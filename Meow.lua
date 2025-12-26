--[[
    ███████╗████████╗███████╗██╗     ██╗      █████╗ ██████╗ 
    ██╔════╝╚══██╔══╝██╔════╝██║     ██║     ██╔══██╗██╔══██╗
    ███████╗   ██║   █████╗  ██║     ██║     ███████║██████╔╝
    ╚════██║   ██║   ██╔══╝  ██║     ██║     ██╔══██║██╔══██╗
    ███████║   ██║   ███████╗███████╗███████╗██║  ██║██║  ██║
    ╚══════╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
    
    Stellar Hub v6.0 - Premium UI Library
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

-- Lucide Icons (Actual working IDs from Lucide icon pack)
local Icons = {
    -- UI Controls
    ["x"] = "rbxassetid://13041085562",
    ["minus"] = "rbxassetid://13041083498",
    ["plus"] = "rbxassetid://13041084291",
    ["check"] = "rbxassetid://13041082364",
    ["chevron-down"] = "rbxassetid://13041082660",
    ["chevron-up"] = "rbxassetid://13041082824",
    ["chevron-right"] = "rbxassetid://13041082751",
    ["chevron-left"] = "rbxassetid://13041082589",
    ["menu"] = "rbxassetid://13041083389",
    ["more-horizontal"] = "rbxassetid://13041083566",
    ["more-vertical"] = "rbxassetid://13041083654",
    
    -- Navigation
    ["home"] = "rbxassetid://13041083073",
    ["settings"] = "rbxassetid://13041084581",
    ["search"] = "rbxassetid://13041084505",
    ["filter"] = "rbxassetid://13041082946",
    ["layout-grid"] = "rbxassetid://13041083253",
    ["list"] = "rbxassetid://13041083322",
    
    -- Actions
    ["play"] = "rbxassetid://13041084218",
    ["pause"] = "rbxassetid://13041084145",
    ["stop-circle"] = "rbxassetid://13041084808",
    ["refresh-cw"] = "rbxassetid://13041084364",
    ["rotate-cw"] = "rbxassetid://13041084432",
    ["download"] = "rbxassetid://13041082870",
    ["upload"] = "rbxassetid://13041085126",
    ["copy"] = "rbxassetid://13041082522",
    ["clipboard"] = "rbxassetid://13041082445",
    ["save"] = "rbxassetid://13041084503",
    ["trash"] = "rbxassetid://13041085050",
    ["edit"] = "rbxassetid://13041082900",
    ["external-link"] = "rbxassetid://13041082919",
    
    -- Status & Alerts
    ["info"] = "rbxassetid://13041083141",
    ["alert-circle"] = "rbxassetid://13041081986",
    ["alert-triangle"] = "rbxassetid://13041082044",
    ["check-circle"] = "rbxassetid://13041082395",
    ["x-circle"] = "rbxassetid://13041085194",
    ["help-circle"] = "rbxassetid://13041083013",
    ["bell"] = "rbxassetid://13041082150",
    ["bell-off"] = "rbxassetid://13041082106",
    
    -- User & People
    ["user"] = "rbxassetid://13041085165",
    ["users"] = "rbxassetid://13041085203",
    ["user-plus"] = "rbxassetid://13041085088",
    ["user-minus"] = "rbxassetid://13041085011",
    ["user-check"] = "rbxassetid://13041084973",
    
    -- Communication
    ["message-circle"] = "rbxassetid://13041083425",
    ["message-square"] = "rbxassetid://13041083463",
    ["mail"] = "rbxassetid://13041083354",
    ["send"] = "rbxassetid://13041084543",
    ["phone"] = "rbxassetid://13041084180",
    
    -- Media
    ["image"] = "rbxassetid://13041083108",
    ["video"] = "rbxassetid://13041085241",
    ["music"] = "rbxassetid://13041083728",
    ["volume-2"] = "rbxassetid://13041085318",
    ["volume-x"] = "rbxassetid://13041085356",
    ["mic"] = "rbxassetid://13041083533",
    ["mic-off"] = "rbxassetid://13041083500",
    
    -- Files & Folders
    ["file"] = "rbxassetid://13041082985",
    ["file-text"] = "rbxassetid://13041082962",
    ["folder"] = "rbxassetid://13041083007",
    ["folder-open"] = "rbxassetid://13041082975",
    ["archive"] = "rbxassetid://13041082062",
    
    -- Devices & Hardware
    ["monitor"] = "rbxassetid://13041083618",
    ["smartphone"] = "rbxassetid://13041084695",
    ["tablet"] = "rbxassetid://13041084884",
    ["laptop"] = "rbxassetid://13041083217",
    ["cpu"] = "rbxassetid://13041082550",
    ["hard-drive"] = "rbxassetid://13041082989",
    ["wifi"] = "rbxassetid://13041085394",
    ["wifi-off"] = "rbxassetid://13041085432",
    ["bluetooth"] = "rbxassetid://13041082187",
    
    -- Security
    ["lock"] = "rbxassetid://13041083286",
    ["unlock"] = "rbxassetid://13041085088",
    ["key"] = "rbxassetid://13041083181",
    ["shield"] = "rbxassetid://13041084619",
    ["shield-check"] = "rbxassetid://13041084657",
    ["eye"] = "rbxassetid://13041082938",
    ["eye-off"] = "rbxassetid://13041082927",
    
    -- Time & Date
    ["clock"] = "rbxassetid://13041082478",
    ["calendar"] = "rbxassetid://13041082254",
    ["timer"] = "rbxassetid://13041084962",
    ["hourglass"] = "rbxassetid://13041083095",
    
    -- Weather & Nature
    ["sun"] = "rbxassetid://13041084846",
    ["moon"] = "rbxassetid://13041083580",
    ["cloud"] = "rbxassetid://13041082500",
    ["zap"] = "rbxassetid://13041085470",
    ["droplet"] = "rbxassetid://13041082885",
    
    -- Arrows & Direction
    ["arrow-up"] = "rbxassetid://13041082150",
    ["arrow-down"] = "rbxassetid://13041082088",
    ["arrow-left"] = "rbxassetid://13041082106",
    ["arrow-right"] = "rbxassetid://13041082123",
    ["corner-up-right"] = "rbxassetid://13041082534",
    ["move"] = "rbxassetid://13041083690",
    
    -- Gaming & Combat
    ["target"] = "rbxassetid://13041084922",
    ["crosshair"] = "rbxassetid://13041082566",
    ["sword"] = "rbxassetid://13041084865",
    ["gamepad"] = "rbxassetid://13041083030",
    ["trophy"] = "rbxassetid://13041085012",
    
    -- Social
    ["heart"] = "rbxassetid://13041083051",
    ["star"] = "rbxassetid://13041084770",
    ["thumbs-up"] = "rbxassetid://13041084940",
    ["thumbs-down"] = "rbxassetid://13041084900",
    ["share"] = "rbxassetid://13041084600",
    ["bookmark"] = "rbxassetid://13041082210",
    
    -- Development
    ["code"] = "rbxassetid://13041082489",
    ["terminal"] = "rbxassetid://13041084960",
    ["git-branch"] = "rbxassetid://13041083042",
    ["github"] = "rbxassetid://13041083055",
    ["database"] = "rbxassetid://13041082600",
    
    -- Misc
    ["link"] = "rbxassetid://13041083265",
    ["unlink"] = "rbxassetid://13041085069",
    ["globe"] = "rbxassetid://13041083062",
    ["map"] = "rbxassetid://13041083370",
    ["map-pin"] = "rbxassetid://13041083340",
    ["compass"] = "rbxassetid://13041082511",
    ["flag"] = "rbxassetid://13041082995",
    ["gift"] = "rbxassetid://13041083048",
    ["award"] = "rbxassetid://13041082079",
    ["crown"] = "rbxassetid://13041082580",
    ["sparkles"] = "rbxassetid://13041084732",
    ["wand"] = "rbxassetid://13041085375",
    ["palette"] = "rbxassetid://13041084107",
    ["layers"] = "rbxassetid://13041083235",
    ["box"] = "rbxassetid://13041082225",
    ["package"] = "rbxassetid://13041084069",
    ["power"] = "rbxassetid://13041084253",
    ["activity"] = "rbxassetid://13041081948",
    ["trending-up"] = "rbxassetid://13041084998",
    ["trending-down"] = "rbxassetid://13041084980",
    ["bar-chart"] = "rbxassetid://13041082095",
    ["pie-chart"] = "rbxassetid://13041084195",
    ["dollar-sign"] = "rbxassetid://13041082855",
    ["percent"] = "rbxassetid://13041084160",
    ["hash"] = "rbxassetid://13041083000",
    ["at-sign"] = "rbxassetid://13041082070",
    ["sliders"] = "rbxassetid://13041084713",
    ["toggle-left"] = "rbxassetid://13041084975",
    ["toggle-right"] = "rbxassetid://13041084988"
}

-- Theme
local Theme = {
    Background = Color3.fromRGB(10, 10, 15),
    BackgroundSecondary = Color3.fromRGB(16, 16, 24),
    BackgroundTertiary = Color3.fromRGB(22, 22, 32),
    
    Surface = Color3.fromRGB(28, 28, 40),
    SurfaceHover = Color3.fromRGB(36, 36, 50),
    SurfaceActive = Color3.fromRGB(44, 44, 60),
    
    Border = Color3.fromRGB(45, 45, 60),
    BorderLight = Color3.fromRGB(55, 55, 75),
    
    Primary = Color3.fromRGB(88, 166, 255),
    PrimaryDark = Color3.fromRGB(60, 140, 230),
    PrimaryLight = Color3.fromRGB(120, 190, 255),
    
    Accent = Color3.fromRGB(168, 132, 255),
    AccentDark = Color3.fromRGB(140, 100, 235),
    
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 195),
    TextMuted = Color3.fromRGB(120, 120, 140),
    TextDisabled = Color3.fromRGB(80, 80, 100),
    
    Success = Color3.fromRGB(72, 210, 145),
    Warning = Color3.fromRGB(255, 185, 65),
    Error = Color3.fromRGB(255, 95, 105),
    Info = Color3.fromRGB(88, 166, 255),
    
    ToggleOff = Color3.fromRGB(55, 55, 70),
    ToggleOn = Color3.fromRGB(88, 166, 255),
    
    SliderTrack = Color3.fromRGB(45, 45, 60),
    SliderFill = Color3.fromRGB(88, 166, 255),
    
    Gradient1 = Color3.fromRGB(88, 166, 255),
    Gradient2 = Color3.fromRGB(168, 132, 255)
}

-- Utilities
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

local function Tween(obj, props, duration, style, direction)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function Padding(parent, top, left, right, bottom)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        Parent = parent
    })
end

local function Stroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function CreateIcon(parent, iconName, size, position, color)
    local iconId = Icons[iconName] or Icons["help-circle"]
    
    local icon = Create("ImageLabel", {
        Name = "Icon",
        Image = iconId,
        ImageColor3 = color or Theme.TextSecondary,
        BackgroundTransparency = 1,
        Size = size or UDim2.new(0, 16, 0, 16),
        Position = position or UDim2.new(0, 0, 0.5, -8),
        AnchorPoint = Vector2.new(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = parent
    })
    
    return icon
end

local function CreateShadow(parent, transparency, size)
    return Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency or 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, size or 47, 1, size or 47),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Parent = parent
    })
end

local function CreateGlow(parent, color, size, transparency)
    return Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = color or Theme.Primary,
        ImageTransparency = transparency or 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, size or 30, 1, size or 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 0,
        Parent = parent
    })
end

local function MakeDraggable(dragElement, targetElement)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    dragElement.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetElement.Position
        end
    end)
    
    dragElement.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Tween(targetElement, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.05)
        end
    end)
end

local function RippleEffect(button, x, y)
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.8,
        Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = button
    })
    Corner(ripple, 999)
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- Config System
local ConfigSystem = {}

function ConfigSystem:Init(configName)
    self.Name = configName or "StellarConfig"
    self.Data = {}
    self.AutoSave = true
    
    self:Load()
    
    return self
end

function ConfigSystem:Set(key, value)
    self.Data[key] = value
    if self.AutoSave then
        self:Save()
    end
end

function ConfigSystem:Get(key, default)
    if self.Data[key] ~= nil then
        return self.Data[key]
    end
    return default
end

function ConfigSystem:Save()
    if writefile then
        local success, err = pcall(function()
            writefile(self.Name .. ".json", HttpService:JSONEncode(self.Data))
        end)
        return success
    end
    return false
end

function ConfigSystem:Load()
    if isfile and readfile then
        if isfile(self.Name .. ".json") then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(self.Name .. ".json"))
            end)
            if success and data then
                self.Data = data
                return true
            end
        end
    end
    return false
end

function ConfigSystem:Delete()
    if delfile and isfile then
        if isfile(self.Name .. ".json") then
            delfile(self.Name .. ".json")
            self.Data = {}
            return true
        end
    end
    return false
end

-- Key Validation
local KeyDatabase = {}

local function ValidateKey(key, database)
    database = database or KeyDatabase
    local keyData = database[key]
    
    if not keyData then
        return false, "Invalid key", nil
    end
    
    if keyData.expiry == "lifetime" then
        return true, "lifetime", keyData.type or "premium"
    end
    
    if type(keyData.expiry) == "number" and os.time() > keyData.expiry then
        return false, "Key expired", nil
    end
    
    local remaining = keyData.expiry - os.time()
    return true, remaining, keyData.type or "standard"
end

local function FormatTimeRemaining(seconds)
    if seconds == "lifetime" then
        return "Lifetime", "∞"
    end
    
    if type(seconds) ~= "number" then
        return "Unknown", "?"
    end
    
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    
    if days > 0 then
        return string.format("%d days, %d hours", days, hours), string.format("%dd", days)
    elseif hours > 0 then
        return string.format("%d hours, %d mins", hours, minutes), string.format("%dh", hours)
    else
        return string.format("%d minutes", minutes), string.format("%dm", minutes)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- KEY SYSTEM UI
-- ═══════════════════════════════════════════════════════════════════════════════

function Stellar:CreateKeySystem(config)
    config = config or {}
    
    local Title = config.Title or "Stellar Hub"
    local Subtitle = config.Subtitle or "Premium Access Required"
    local Logo = config.Logo or nil
    local Keys = config.Keys or {}
    local GetKeyLink = config.GetKeyLink or ""
    local Discord = config.Discord or ""
    local SaveKey = config.SaveKey ~= false
    local OnSuccess = config.OnSuccess or function() end
    local OnFailed = config.OnFailed or function() end
    
    -- Add keys to database
    for k, v in pairs(Keys) do
        KeyDatabase[k] = v
    end
    
    -- Cleanup
    if CoreGui:FindFirstChild("StellarKeySystem") then
        CoreGui.StellarKeySystem:Destroy()
    end
    
    local ScreenGui = Create("ScreenGui", {
        Name = "StellarKeySystem",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    -- Full screen background
    local Background = Create("Frame", {
        Name = "Background",
        BackgroundColor3 = Color3.fromRGB(5, 5, 10),
        Size = UDim2.new(1, 0, 1, 0),
        Parent = ScreenGui
    })
    
    -- Animated gradient background
    local GradientOverlay = Create("Frame", {
        Name = "GradientOverlay",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = Background
    })
    
    -- Create animated orbs
    local function CreateOrb(color, size, startPos, speed)
        local orb = Create("Frame", {
            BackgroundColor3 = color,
            BackgroundTransparency = 0.85,
            Size = UDim2.new(0, size, 0, size),
            Position = startPos,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = GradientOverlay
        })
        Corner(orb, size/2)
        
        -- Blur effect
        local blur = Create("Frame", {
            BackgroundColor3 = color,
            BackgroundTransparency = 0.92,
            Size = UDim2.new(0, size * 1.5, 0, size * 1.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = orb
        })
        Corner(blur, size * 0.75)
        
        -- Animate
        task.spawn(function()
            while orb.Parent do
                local newX = math.random(20, 80) / 100
                local newY = math.random(20, 80) / 100
                Tween(orb, {Position = UDim2.new(newX, 0, newY, 0)}, speed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(speed)
            end
        end)
        
        return orb
    end
    
    CreateOrb(Theme.Primary, 300, UDim2.new(0.2, 0, 0.3, 0), 8)
    CreateOrb(Theme.Accent, 250, UDim2.new(0.8, 0, 0.6, 0), 10)
    CreateOrb(Theme.Success, 200, UDim2.new(0.5, 0, 0.8, 0), 12)
    
    -- Main card
    local CardContainer = Create("Frame", {
        Name = "CardContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 420, 0, 540),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = Background
    })
    
    local Card = Create("Frame", {
        Name = "Card",
        BackgroundColor3 = Theme.BackgroundSecondary,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = CardContainer
    })
    Corner(Card, 20)
    Stroke(Card, Theme.Border, 1, 0.5)
    CreateShadow(Card, 0.4, 80)
    
    -- Animate card in
    Card.Size = UDim2.new(0, 0, 0, 0)
    Card.BackgroundTransparency = 1
    
    task.delay(0.1, function()
        Tween(Card, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0}, 0.5, Enum.EasingStyle.Back)
    end)
    
    -- Header with gradient
    local Header = Create("Frame", {
        Name = "Header",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(1, 0, 0, 160),
        Parent = Card
    })
    
    local HeaderCorner = Corner(Header, 20)
    
    -- Fix header bottom corners
    Create("Frame", {
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -20),
        BorderSizePixel = 0,
        Parent = Header
    })
    
    -- Header gradient
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(110, 150, 255)),
            ColorSequenceKeypoint.new(1, Theme.Accent)
        }),
        Rotation = 45,
        Parent = Header
    })
    
    -- Decorative pattern
    for i = 1, 6 do
        local circle = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.92,
            Size = UDim2.new(0, 80 + i * 20, 0, 80 + i * 20),
            Position = UDim2.new(1, -40 - i * 10, 0, -30 + i * 5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = Header
        })
        Corner(circle, 999)
    end
    
    -- Logo container
    local LogoContainer = Create("Frame", {
        Name = "LogoContainer",
        BackgroundColor3 = Theme.BackgroundSecondary,
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0.5, 0, 1, -40),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = Header
    })
    Corner(LogoContainer, 20)
    Stroke(LogoContainer, Theme.Border, 2, 0.3)
    CreateGlow(LogoContainer, Theme.Primary, 20, 0.8)
    
    if Logo then
        Create("ImageLabel", {
            Image = Logo,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 44, 0, 44),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Parent = LogoContainer
        })
    else
        CreateIcon(LogoContainer, "shield-check", UDim2.new(0, 40, 0, 40), UDim2.new(0.5, -20, 0.5, -20), Theme.Primary)
    end
    
    -- Title section
    local TitleSection = Create("Frame", {
        Name = "TitleSection",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 175),
        Parent = Card
    })
    
    Create("TextLabel", {
        Text = Title,
        Font = Enum.Font.GothamBlack,
        TextColor3 = Theme.Text,
        TextSize = 24,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 8),
        Parent = TitleSection
    })
    
    Create("TextLabel", {
        Text = Subtitle,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextMuted,
        TextSize = 13,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 38),
        Parent = TitleSection
    })
    
    -- Content section
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -48, 0, 260),
        Position = UDim2.new(0, 24, 0, 245),
        Parent = Card
    })
    
    -- Status bar
    local StatusBar = Create("Frame", {
        Name = "StatusBar",
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = Content
    })
    Corner(StatusBar, 12)
    Stroke(StatusBar, Theme.Border, 1, 0.5)
    
    local StatusDot = Create("Frame", {
        BackgroundColor3 = Theme.Warning,
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, 16, 0.5, -5),
        Parent = StatusBar
    })
    Corner(StatusDot, 5)
    
    -- Pulsing animation for status dot
    task.spawn(function()
        while StatusDot.Parent do
            Tween(StatusDot, {BackgroundTransparency = 0.5}, 0.8)
            task.wait(0.8)
            Tween(StatusDot, {BackgroundTransparency = 0}, 0.8)
            task.wait(0.8)
        end
    end)
    
    local StatusText = Create("TextLabel", {
        Text = "Waiting for license key...",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 36, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = StatusBar
    })
    
    local TimeLabel = Create("TextLabel", {
        Text = "",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Primary,
        TextSize = 11,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -70, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = StatusBar
    })
    
    -- Key input section
    Create("TextLabel", {
        Text = "LICENSE KEY",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 62),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Content
    })
    
    local KeyInputContainer = Create("Frame", {
        Name = "KeyInput",
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(1, 0, 0, 52),
        Position = UDim2.new(0, 0, 0, 80),
        Parent = Content
    })
    Corner(KeyInputContainer, 12)
    local KeyInputStroke = Stroke(KeyInputContainer, Theme.Border, 1, 0.3)
    
    local KeyIcon = CreateIcon(KeyInputContainer, "key", UDim2.new(0, 18, 0, 18), UDim2.new(0, 16, 0.5, -9), Theme.TextMuted)
    
    local KeyInput = Create("TextBox", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -54, 1, 0),
        Position = UDim2.new(0, 44, 0, 0),
        Text = "",
        PlaceholderText = "Enter your license key here...",
        PlaceholderColor3 = Theme.TextMuted,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = KeyInputContainer
    })
    
    -- Focus effects
    KeyInput.Focused:Connect(function()
        Tween(KeyInputContainer, {BackgroundColor3 = Theme.SurfaceHover}, 0.15)
        Tween(KeyInputStroke, {Color = Theme.Primary, Transparency = 0}, 0.15)
        Tween(KeyIcon, {ImageColor3 = Theme.Primary}, 0.15)
    end)
    
    KeyInput.FocusLost:Connect(function()
        Tween(KeyInputContainer, {BackgroundColor3 = Theme.Surface}, 0.15)
        Tween(KeyInputStroke, {Color = Theme.Border, Transparency = 0.3}, 0.15)
        Tween(KeyIcon, {ImageColor3 = Theme.TextMuted}, 0.15)
    end)
    
    -- Validate button
    local ValidateBtn = Create("TextButton", {
        Name = "ValidateBtn",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 145),
        Text = "",
        AutoButtonColor = false,
        Parent = Content
    })
    Corner(ValidateBtn, 12)
    CreateGlow(ValidateBtn, Theme.Primary, 15, 0.85)
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(1, Theme.Accent)
        }),
        Rotation = 90,
        Parent = ValidateBtn
    })
    
    local ValidateBtnContent = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = ValidateBtn
    })
    
    local ValidateIcon = CreateIcon(ValidateBtnContent, "check-circle", UDim2.new(0, 18, 0, 18), UDim2.new(0.5, -60, 0.5, -9), Theme.Text)
    
    local ValidateBtnText = Create("TextLabel", {
        Text = "VALIDATE KEY",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextSize = 14,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(0.5, -35, 0, 0),
        Parent = ValidateBtnContent
    })
    
    -- Hover effects
    ValidateBtn.MouseEnter:Connect(function()
        Tween(ValidateBtn, {Size = UDim2.new(1, 4, 0, 52)}, 0.15, Enum.EasingStyle.Back)
        ValidateBtn.Position = UDim2.new(0, -2, 0, 144)
    end)
    
    ValidateBtn.MouseLeave:Connect(function()
        Tween(ValidateBtn, {Size = UDim2.new(1, 0, 0, 50), Position = UDim2.new(0, 0, 0, 145)}, 0.15)
    end)
    
    -- Secondary buttons row
    local ButtonRow = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 42),
        Position = UDim2.new(0, 0, 0, 208),
        Parent = Content
    })
    
    -- Get Key button
    local GetKeyBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = "",
        AutoButtonColor = false,
        Parent = ButtonRow
    })
    Corner(GetKeyBtn, 10)
    Stroke(GetKeyBtn, Theme.Primary, 1, 0.5)
    
    CreateIcon(GetKeyBtn, "external-link", UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -42, 0.5, -7), Theme.Primary)
    
    Create("TextLabel", {
        Text = "Get a Key",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Primary,
        TextSize = 12,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0.5, -20, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = GetKeyBtn
    })
    
    GetKeyBtn.MouseEnter:Connect(function()
        Tween(GetKeyBtn, {BackgroundColor3 = Theme.SurfaceHover}, 0.12)
    end)
    GetKeyBtn.MouseLeave:Connect(function()
        Tween(GetKeyBtn, {BackgroundColor3 = Theme.Surface}, 0.12)
    end)
    
    -- Discord button
    local DiscordBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0.52, 0, 0, 0),
        Text = "",
        AutoButtonColor = false,
        Parent = ButtonRow
    })
    Corner(DiscordBtn, 10)
    Stroke(DiscordBtn, Theme.Border, 1, 0.5)
    
    CreateIcon(DiscordBtn, "message-circle", UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -38, 0.5, -7), Theme.TextSecondary)
    
    Create("TextLabel", {
        Text = "Discord",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0.5, -16, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = DiscordBtn
    })
    
    DiscordBtn.MouseEnter:Connect(function()
        Tween(DiscordBtn, {BackgroundColor3 = Theme.SurfaceHover}, 0.12)
    end)
    DiscordBtn.MouseLeave:Connect(function()
        Tween(DiscordBtn, {BackgroundColor3 = Theme.Surface}, 0.12)
    end)
    
    -- Footer
    local Footer = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -48, 0, 30),
        Position = UDim2.new(0, 24, 1, -40),
        Parent = Card
    })
    
    Create("TextLabel", {
        Text = "Powered by Stellar Hub",
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Footer
    })
    
    Create("TextLabel", {
        Text = "v6.0",
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = Footer
    })
    
    -- Button actions
    GetKeyBtn.MouseButton1Click:Connect(function()
        RippleEffect(GetKeyBtn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        if setclipboard and GetKeyLink ~= "" then
            setclipboard(GetKeyLink)
            StatusText.Text = "Key link copied to clipboard!"
            StatusDot.BackgroundColor3 = Theme.Info
            task.wait(2)
            StatusText.Text = "Waiting for license key..."
            StatusDot.BackgroundColor3 = Theme.Warning
        end
    end)
    
    DiscordBtn.MouseButton1Click:Connect(function()
        RippleEffect(DiscordBtn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        if setclipboard and Discord ~= "" then
            setclipboard(Discord)
            StatusText.Text = "Discord invite copied!"
            StatusDot.BackgroundColor3 = Theme.Info
            task.wait(2)
            StatusText.Text = "Waiting for license key..."
            StatusDot.BackgroundColor3 = Theme.Warning
        end
    end)
    
    -- Validation logic
    local function AnimateSuccess(timeRemaining, keyType)
        StatusDot.BackgroundColor3 = Theme.Success
        StatusText.Text = "Access granted!"
        local _, shortTime = FormatTimeRemaining(timeRemaining)
        TimeLabel.Text = shortTime
        
        ValidateBtnText.Text = "SUCCESS"
        ValidateIcon.Image = Icons["check"]
        
        Tween(ValidateBtn, {BackgroundColor3 = Theme.Success}, 0.2)
        
        task.wait(1)
        
        -- Animate out
        Tween(Card, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(Background, {BackgroundTransparency = 1}, 0.5)
        
        for _, child in pairs(GradientOverlay:GetChildren()) do
            Tween(child, {BackgroundTransparency = 1}, 0.3)
        end
        
        task.wait(0.5)
        ScreenGui:Destroy()
        
        OnSuccess(timeRemaining, keyType)
    end
    
    local function AnimateError(message)
        StatusDot.BackgroundColor3 = Theme.Error
        StatusText.Text = message or "Invalid or expired key"
        
        -- Shake animation
        local originalPos = KeyInputContainer.Position
        for i = 1, 4 do
            Tween(KeyInputContainer, {Position = UDim2.new(0, 8, 0, 80)}, 0.04)
            task.wait(0.04)
            Tween(KeyInputContainer, {Position = UDim2.new(0, -8, 0, 80)}, 0.04)
            task.wait(0.04)
        end
        Tween(KeyInputContainer, {Position = originalPos}, 0.04)
        
        KeyInputStroke.Color = Theme.Error
        KeyInputStroke.Transparency = 0
        
        task.wait(2)
        
        KeyInputStroke.Color = Theme.Border
        KeyInputStroke.Transparency = 0.3
        StatusDot.BackgroundColor3 = Theme.Warning
        StatusText.Text = "Waiting for license key..."
    end
    
    ValidateBtn.MouseButton1Click:Connect(function()
        RippleEffect(ValidateBtn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        
        local key = KeyInput.Text
        
        if key == "" then
            AnimateError("Please enter a key")
            return
        end
        
        ValidateBtnText.Text = "VALIDATING..."
        ValidateIcon.Image = Icons["refresh-cw"]
        
        -- Spin animation
        local spinning = true
        task.spawn(function()
            while spinning do
                ValidateIcon.Rotation = ValidateIcon.Rotation + 15
                task.wait()
            end
            ValidateIcon.Rotation = 0
        end)
        
        task.wait(0.8)
        spinning = false
        
        local valid, timeOrError, keyType = ValidateKey(key)
        
        if valid then
            if SaveKey and writefile then
                pcall(function()
                    writefile("StellarKey.txt", key)
                end)
            end
            AnimateSuccess(timeOrError, keyType)
        else
            ValidateBtnText.Text = "VALIDATE KEY"
            ValidateIcon.Image = Icons["check-circle"]
            AnimateError(timeOrError)
            OnFailed(timeOrError)
        end
    end)
    
    -- Check for saved key
    if SaveKey and isfile and readfile then
        if isfile("StellarKey.txt") then
            local savedKey = readfile("StellarKey.txt")
            if savedKey and savedKey ~= "" then
                KeyInput.Text = savedKey
                StatusText.Text = "Found saved key, validating..."
                StatusDot.BackgroundColor3 = Theme.Info
                
                task.wait(0.5)
                
                local valid, timeOrError, keyType = ValidateKey(savedKey)
                if valid then
                    AnimateSuccess(timeOrError, keyType)
                else
                    StatusDot.BackgroundColor3 = Theme.Warning
                    StatusText.Text = "Saved key expired, enter new key"
                end
            end
        end
    end
    
    return {
        SetStatus = function(text, color)
            StatusText.Text = text
            if color then StatusDot.BackgroundColor3 = color end
        end,
        Close = function()
            Tween(Card, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            Tween(Background, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.35)
            ScreenGui:Destroy()
        end
    }
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- MAIN WINDOW
-- ═══════════════════════════════════════════════════════════════════════════════

function Stellar:CreateWindow(config)
    config = config or {}
    
    local Title = config.Title or "Stellar Hub"
    local Subtitle = config.Subtitle or "v6.0"
    local Logo = config.Logo or nil
    local Size = config.Size or UDim2.new(0, 850, 0, 500)
    local ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    local SearchEnabled = config.Search ~= false
    local ConfigName = config.ConfigName or "StellarConfig"
    
    -- Initialize config
    local Config = ConfigSystem:Init(ConfigName)
    
    -- Cleanup
    if CoreGui:FindFirstChild("StellarHub") then
        CoreGui.StellarHub:Destroy()
    end
    
    local ScreenGui = Create("ScreenGui", {
        Name = "StellarHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    local Minimized = false
    local CurrentTab = nil
    local Tabs = {}
    local Pages = {}
    local AllElements = {}
    
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
    Corner(MainFrame, 12)
    CreateShadow(MainFrame, 0.4, 60)
    
    -- Animate in
    Tween(MainFrame, {Size = Size}, 0.5, Enum.EasingStyle.Back)
    
    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.BackgroundSecondary,
        Size = UDim2.new(0, 220, 1, 0),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    Corner(Sidebar, 12)
    
    -- Fix sidebar corners
    Create("Frame", {
        BackgroundColor3 = Theme.BackgroundSecondary,
        Size = UDim2.new(0, 15, 1, 0),
        Position = UDim2.new(1, -15, 0, 0),
        BorderSizePixel = 0,
        Parent = Sidebar
    })
    
    -- Sidebar border
    Create("Frame", {
        BackgroundColor3 = Theme.Border,
        Size = UDim2.new(0, 1, 1, -24),
        Position = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        BackgroundTransparency = 0.5,
        Parent = Sidebar
    })
    
    -- Header
    local Header = Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 70),
        Parent = Sidebar
    })
    MakeDraggable(Header, MainFrame)
    
    -- Logo
    local LogoFrame = Create("Frame", {
        Name = "Logo",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(0, 42, 0, 42),
        Position = UDim2.new(0, 16, 0, 14),
        Parent = Header
    })
    Corner(LogoFrame, 12)
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(1, Theme.Accent)
        }),
        Rotation = 45,
        Parent = LogoFrame
    })
    
    if Logo then
        Create("ImageLabel", {
            Image = Logo,
            ImageColor3 = Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Parent = LogoFrame
        })
    else
        CreateIcon(LogoFrame, "sparkles", UDim2.new(0, 22, 0, 22), UDim2.new(0.5, -11, 0.5, -11), Theme.Text)
    end
    
    -- Title
    Create("TextLabel", {
        Text = Title,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextSize = 16,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -76, 0, 18),
        Position = UDim2.new(0, 68, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    Create("TextLabel", {
        Text = Subtitle,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -76, 0, 14),
        Position = UDim2.new(0, 68, 0, 36),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    -- Search (optional)
    local SearchYOffset = 78
    
    if SearchEnabled then
        local SearchContainer = Create("Frame", {
            Name = "Search",
            BackgroundColor3 = Theme.Surface,
            Size = UDim2.new(1, -32, 0, 36),
            Position = UDim2.new(0, 16, 0, SearchYOffset),
            Parent = Sidebar
        })
        Corner(SearchContainer, 10)
        Stroke(SearchContainer, Theme.Border, 1, 0.5)
        
        CreateIcon(SearchContainer, "search", UDim2.new(0, 14, 0, 14), UDim2.new(0, 12, 0.5, -7), Theme.TextMuted)
        
        local SearchInput = Create("TextBox", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 32, 0, 0),
            Text = "",
            PlaceholderText = "Search features...",
            PlaceholderColor3 = Theme.TextMuted,
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            Parent = SearchContainer
        })
        
        -- Search results dropdown
        local SearchResults = Create("Frame", {
            Name = "SearchResults",
            BackgroundColor3 = Theme.Surface,
            Size = UDim2.new(1, -32, 0, 0),
            Position = UDim2.new(0, 16, 0, SearchYOffset + 40),
            ClipsDescendants = true,
            Visible = false,
            ZIndex = 50,
            Parent = Sidebar
        })
        Corner(SearchResults, 10)
        Stroke(SearchResults, Theme.Primary, 1, 0.3)
        
        local ResultsScroll = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Primary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ZIndex = 51,
            Parent = SearchResults
        })
        Padding(ResultsScroll, 6, 6, 6, 6)
        
        local ResultsLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
            Parent = ResultsScroll
        })
        
        local NoResults = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 50),
            Visible = false,
            ZIndex = 52,
            Parent = ResultsScroll
        })
        
        CreateIcon(NoResults, "alert-circle", UDim2.new(0, 20, 0, 20), UDim2.new(0.5, -50, 0.5, -10), Theme.TextMuted)
        
        Create("TextLabel", {
            Text = "Nothing found",
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.TextMuted,
            TextSize = 12,
            BackgroundTransparency = 1,
            Size = UDim2.new(0.6, 0, 0, 20),
            Position = UDim2.new(0.5, -22, 0.5, -10),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 53,
            Parent = NoResults
        })
        
        SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
            local text = string.lower(SearchInput.Text)
            
            -- Clear old results
            for _, child in pairs(ResultsScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            if text == "" then
                SearchResults.Visible = false
                Tween(SearchResults, {Size = UDim2.new(1, -32, 0, 0)}, 0.15)
                return
            end
            
            local results = {}
            for _, elem in pairs(AllElements) do
                if string.find(string.lower(elem.Name), text) then
                    table.insert(results, elem)
                end
            end
            
            if #results == 0 then
                NoResults.Visible = true
                SearchResults.Visible = true
                Tween(SearchResults, {Size = UDim2.new(1, -32, 0, 60)}, 0.2)
            else
                NoResults.Visible = false
                SearchResults.Visible = true
                
                local height = math.min(#results * 36 + 12, 180)
                Tween(SearchResults, {Size = UDim2.new(1, -32, 0, height)}, 0.2)
                
                for i, elem in ipairs(results) do
                    if i > 6 then break end
                    
                    local ResultBtn = Create("TextButton", {
                        BackgroundColor3 = Theme.SurfaceHover,
                        BackgroundTransparency = 0.7,
                        Size = UDim2.new(1, 0, 0, 32),
                        Text = "",
                        AutoButtonColor = false,
                        LayoutOrder = i,
                        ZIndex = 54,
                        Parent = ResultsScroll
                    })
                    Corner(ResultBtn, 8)
                    
                    Create("TextLabel", {
                        Text = elem.Name,
                        Font = Enum.Font.GothamMedium,
                        TextColor3 = Theme.Text,
                        TextSize = 11,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -60, 1, 0),
                        Position = UDim2.new(0, 10, 0, 0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        ZIndex = 55,
                        Parent = ResultBtn
                    })
                    
                    Create("TextLabel", {
                        Text = elem.Tab,
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.Primary,
                        TextSize = 10,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 50, 1, 0),
                        Position = UDim2.new(1, -55, 0, 0),
                        TextXAlignment = Enum.TextXAlignment.Right,
                        ZIndex = 55,
                        Parent = ResultBtn
                    })
                    
                    ResultBtn.MouseEnter:Connect(function()
                        Tween(ResultBtn, {BackgroundTransparency = 0.4}, 0.1)
                    end)
                    ResultBtn.MouseLeave:Connect(function()
                        Tween(ResultBtn, {BackgroundTransparency = 0.7}, 0.1)
                    end)
                    ResultBtn.MouseButton1Click:Connect(function()
                        if Tabs[elem.Tab] then
                            -- Switch tab
                            for name, data in pairs(Tabs) do
                                Tween(data.Button, {BackgroundTransparency = 1}, 0.12)
                                Tween(data.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.12)
                                Tween(data.Icon, {ImageColor3 = Theme.TextMuted}, 0.12)
                                Tween(data.Label, {TextColor3 = Theme.TextSecondary}, 0.12)
                            end
                            
                            for _, page in pairs(Pages) do
                                page.Visible = false
                            end
                            
                            local data = Tabs[elem.Tab]
                            Tween(data.Button, {BackgroundTransparency = 0.9}, 0.12)
                            Tween(data.Indicator, {Size = UDim2.new(0, 3, 0, 18)}, 0.15, Enum.EasingStyle.Back)
                            Tween(data.Icon, {ImageColor3 = Theme.Primary}, 0.12)
                            Tween(data.Label, {TextColor3 = Theme.Text}, 0.12)
                            
                            if Pages[elem.Tab] then
                                Pages[elem.Tab].Visible = true
                            end
                            
                            SearchInput.Text = ""
                            SearchResults.Visible = false
                        end
                    end)
                end
                
                ResultsScroll.CanvasSize = UDim2.new(0, 0, 0, ResultsLayout.AbsoluteContentSize.Y + 12)
            end
        end)
        
        SearchYOffset = SearchYOffset + 48
    end
    
    -- Navigation label
    Create("TextLabel", {
        Text = "NAVIGATION",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMuted,
        TextSize = 9,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -32, 0, 12),
        Position = UDim2.new(0, 16, 0, SearchYOffset + 8),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Sidebar
    })
    
    -- Tab container
    local TabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -(SearchYOffset + 90)),
        Position = UDim2.new(0, 0, 0, SearchYOffset + 26),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Sidebar
    })
    Padding(TabContainer, 0, 12, 12, 12)
    
    local TabLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = TabContainer
    })
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- User info
    local UserFrame = Create("Frame", {
        Name = "User",
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(1, -32, 0, 48),
        Position = UDim2.new(0, 16, 1, -60),
        Parent = Sidebar
    })
    Corner(UserFrame, 10)
    
    local Avatar = Create("ImageLabel", {
        Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100),
        BackgroundColor3 = Theme.SurfaceHover,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 8, 0.5, -16),
        Parent = UserFrame
    })
    Corner(Avatar, 16)
    
    Create("TextLabel", {
        Text = Player.DisplayName,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextSize = 12,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -56, 0, 14),
        Position = UDim2.new(0, 48, 0, 10),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = UserFrame
    })
    
    Create("TextLabel", {
        Text = "@" .. Player.Name,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -56, 0, 12),
        Position = UDim2.new(0, 48, 0, 26),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = UserFrame
    })
    
    -- Content area
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -220, 1, 0),
        Position = UDim2.new(0, 220, 0, 0),
        Parent = MainFrame
    })
    
    -- Top bar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 56),
        Parent = Content
    })
    MakeDraggable(TopBar, MainFrame)
    
    local PageTitle = Create("TextLabel", {
        Name = "PageTitle",
        Text = "Dashboard",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextSize = 18,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 0, 24),
        Position = UDim2.new(0, 20, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    -- Window controls
    local Controls = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -88, 0, 13),
        Parent = TopBar
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
        Parent = Controls
    })
    
    local MinimizeBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    Corner(MinimizeBtn, 8)
    CreateIcon(MinimizeBtn, "minus", UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -7, 0.5, -7), Theme.TextSecondary)
    
    local CloseBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    Corner(CloseBtn, 8)
    CreateIcon(CloseBtn, "x", UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -7, 0.5, -7), Theme.TextSecondary)
    
    MinimizeBtn.MouseEnter:Connect(function()
        Tween(MinimizeBtn, {BackgroundColor3 = Theme.SurfaceHover}, 0.12)
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        Tween(MinimizeBtn, {BackgroundColor3 = Theme.Surface}, 0.12)
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.Error}, 0.12)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.Surface}, 0.12)
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.25)
        ScreenGui:Destroy()
    end)
    
    -- Page container
    local PageContainer = Create("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -56),
        Position = UDim2.new(0, 0, 0, 56),
        ClipsDescendants = true,
        Parent = Content
    })
    
    -- Toggle button
    local ToggleBtn = Create("TextButton", {
        Name = "Toggle",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(0, 52, 0, 52),
        Position = UDim2.new(0, 20, 0.5, -26),
        Text = "",
        AutoButtonColor = false,
        Visible = false,
        Parent = ScreenGui
    })
    Corner(ToggleBtn, 14)
    CreateGlow(ToggleBtn, Theme.Primary, 20, 0.8)
    CreateShadow(ToggleBtn, 0.5, 30)
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(1, Theme.Accent)
        }),
        Rotation = 45,
        Parent = ToggleBtn
    })
    
    if Logo then
        Create("ImageLabel", {
            Image = Logo,
            ImageColor3 = Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 26, 0, 26),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Parent = ToggleBtn
        })
    else
        CreateIcon(ToggleBtn, "sparkles", UDim2.new(0, 24, 0, 24), UDim2.new(0.5, -12, 0.5, -12), Theme.Text)
    end
    
    ToggleBtn.MouseEnter:Connect(function()
        Tween(ToggleBtn, {Size = UDim2.new(0, 58, 0, 58), Position = UDim2.new(0, 17, 0.5, -29)}, 0.15, Enum.EasingStyle.Back)
    end)
    ToggleBtn.MouseLeave:Connect(function()
        Tween(ToggleBtn, {Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(0, 20, 0.5, -26)}, 0.12)
    end)
    
    -- Minimize/Maximize functions
    local function Minimize()
        Minimized = true
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.22)
        MainFrame.Visible = false
        ToggleBtn.Visible = true
        ToggleBtn.Size = UDim2.new(0, 0, 0, 0)
        Tween(ToggleBtn, {Size = UDim2.new(0, 52, 0, 52)}, 0.3, Enum.EasingStyle.Back)
    end
    
    local function Maximize()
        Minimized = false
        ToggleBtn.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Tween(MainFrame, {Size = Size}, 0.35, Enum.EasingStyle.Back)
    end
    
    MinimizeBtn.MouseButton1Click:Connect(Minimize)
    ToggleBtn.MouseButton1Click:Connect(Maximize)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == ToggleKey then
            if Minimized then
                Maximize()
            else
                Minimize()
            end
        end
    end)
    
    -- Notification container
    local NotifContainer = Create("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 320, 1, -40),
        Position = UDim2.new(1, -340, 0, 20),
        Parent = ScreenGui
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = NotifContainer
    })
    
    -- Switch tab function
    local function SwitchTab(tabName)
        for name, data in pairs(Tabs) do
            Tween(data.Button, {BackgroundTransparency = 1}, 0.12)
            Tween(data.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.12)
            Tween(data.Icon, {ImageColor3 = Theme.TextMuted}, 0.12)
            Tween(data.Label, {TextColor3 = Theme.TextSecondary}, 0.12)
        end
        
        for _, page in pairs(Pages) do
            page.Visible = false
        end
        
        local data = Tabs[tabName]
        if data then
            Tween(data.Button, {BackgroundTransparency = 0.9}, 0.12)
            Tween(data.Indicator, {Size = UDim2.new(0, 3, 0, 18)}, 0.15, Enum.EasingStyle.Back)
            Tween(data.Icon, {ImageColor3 = Theme.Primary}, 0.12)
            Tween(data.Label, {TextColor3 = Theme.Text}, 0.12)
            CurrentTab = data.Button
        end
        
        if Pages[tabName] then
            Pages[tabName].Visible = true
        end
        
        PageTitle.Text = tabName
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- WINDOW METHODS
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    local Window = {}
    Window.Config = Config
    
    function Window:Notify(options)
        options = options or {}
        local NotifTitle = options.Title or "Notification"
        local NotifContent = options.Content or options.Message or ""
        local NotifDuration = options.Duration or 4
        local NotifIcon = options.Icon or "info"
        local NotifType = options.Type or "Info"
        
        local TypeColors = {
            Info = Theme.Info,
            Success = Theme.Success,
            Warning = Theme.Warning,
            Error = Theme.Error
        }
        
        local color = TypeColors[NotifType] or Theme.Info
        
        local Notif = Create("Frame", {
            BackgroundColor3 = Theme.BackgroundSecondary,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true,
            Parent = NotifContainer
        })
        Corner(Notif, 12)
        Stroke(Notif, color, 1, 0.5)
        CreateShadow(Notif, 0.6, 20)
        
        -- Accent bar
        Create("Frame", {
            BackgroundColor3 = color,
            Size = UDim2.new(0, 4, 1, 0),
            BorderSizePixel = 0,
            Parent = Notif
        })
        Corner(Notif:FindFirstChild("Frame"), 2)
        
        -- Icon
        local IconBg = Create("Frame", {
            BackgroundColor3 = color,
            BackgroundTransparency = 0.9,
            Size = UDim2.new(0, 36, 0, 36),
            Position = UDim2.new(0, 16, 0, 14),
            Parent = Notif
        })
        Corner(IconBg, 10)
        CreateIcon(IconBg, NotifIcon, UDim2.new(0, 18, 0, 18), UDim2.new(0.5, -9, 0.5, -9), color)
        
        Create("TextLabel", {
            Text = NotifTitle,
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.Text,
            TextSize = 13,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -72, 0, 16),
            Position = UDim2.new(0, 62, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Notif
        })
        
        Create("TextLabel", {
            Text = NotifContent,
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextSecondary,
            TextSize = 12,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -72, 0, 30),
            Position = UDim2.new(0, 62, 0, 32),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = Notif
        })
        
        -- Progress bar
        local ProgressBar = Create("Frame", {
            BackgroundColor3 = color,
            BackgroundTransparency = 0.7,
            Size = UDim2.new(1, 0, 0, 3),
            Position = UDim2.new(0, 0, 1, -3),
            BorderSizePixel = 0,
            Parent = Notif
        })
        
        -- Animate in
        Tween(Notif, {Size = UDim2.new(1, 0, 0, 72)}, 0.3, Enum.EasingStyle.Back)
        
        -- Progress animation
        Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 3)}, NotifDuration, Enum.EasingStyle.Linear)
        
        task.delay(NotifDuration, function()
            Tween(Notif, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.25)
            task.wait(0.25)
            Notif:Destroy()
        end)
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- TAB CREATION
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function Window:Tab(options)
        options = options or {}
        local TabName = options.Title or options.Name or "Tab"
        local TabIcon = options.Icon or "folder"
        
        -- Create tab button
        local TabBtn = Create("TextButton", {
            Name = TabName,
            BackgroundColor3 = Theme.Primary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 40),
            Text = "",
            AutoButtonColor = false,
            Parent = TabContainer
        })
        Corner(TabBtn, 10)
        
        local Indicator = Create("Frame", {
            BackgroundColor3 = Theme.Primary,
            Size = UDim2.new(0, 3, 0, 0),
            Position = UDim2.new(0, 0, 0.5, -9),
            Parent = TabBtn
        })
        Corner(Indicator, 2)
        
        local Icon = CreateIcon(TabBtn, TabIcon, UDim2.new(0, 18, 0, 18), UDim2.new(0, 14, 0.5, -9), Theme.TextMuted)
        
        local Label = Create("TextLabel", {
            Text = TabName,
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 42, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabBtn
        })
        
        Tabs[TabName] = {
            Button = TabBtn,
            Indicator = Indicator,
            Icon = Icon,
            Label = Label
        }
        
        -- Create page
        local Page = Create("ScrollingFrame", {
            Name = TabName,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Primary,
            ScrollBarImageTransparency = 0.5,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = PageContainer
        })
        Padding(Page, 8, 20, 20, 20)
        
        local PageLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = Page
        })
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 40)
        end)
        
        Pages[TabName] = Page
        
        -- Select first tab
        if not CurrentTab then
            SwitchTab(TabName)
        end
        
        TabBtn.MouseButton1Click:Connect(function()
            SwitchTab(TabName)
        end)
        
        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= TabBtn then
                Tween(TabBtn, {BackgroundTransparency = 0.95}, 0.1)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= TabBtn then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.1)
            end
        end)
        
        -- ═══════════════════════════════════════════════════════════════════════════════
        -- TAB ELEMENT METHODS
        -- ═══════════════════════════════════════════════════════════════════════════════
        
        local Tab = {}
        
        -- Section
        function Tab:Section(options)
            options = options or {}
            if type(options) == "string" then
                options = {Title = options}
            end
            
            local SectionTitle = options.Title or "Section"
            local SectionIcon = options.Icon
            local IsBox = options.Box or false
            local IsOpened = options.Opened ~= false
            
            if IsBox then
                -- Collapsible section
                local SectionFrame = Create("Frame", {
                    Name = SectionTitle,
                    BackgroundColor3 = Theme.Surface,
                    Size = UDim2.new(1, 0, 0, 44),
                    ClipsDescendants = true,
                    Parent = Page
                })
                Corner(SectionFrame, 12)
                Stroke(SectionFrame, Theme.Border, 1, 0.5)
                
                local SectionHeader = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 44),
                    Text = "",
                    Parent = SectionFrame
                })
                
                if SectionIcon then
                    local IconBg = Create("Frame", {
                        BackgroundColor3 = Theme.Primary,
                        BackgroundTransparency = 0.9,
                        Size = UDim2.new(0, 28, 0, 28),
                        Position = UDim2.new(0, 12, 0.5, -14),
                        Parent = SectionHeader
                    })
                    Corner(IconBg, 8)
                    CreateIcon(IconBg, SectionIcon, UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -7, 0.5, -7), Theme.Primary)
                end
                
                Create("TextLabel", {
                    Text = SectionTitle,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -80, 1, 0),
                    Position = UDim2.new(0, SectionIcon and 50 or 16, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SectionHeader
                })
                
                local Arrow = CreateIcon(SectionHeader, "chevron-down", UDim2.new(0, 16, 0, 16), UDim2.new(1, -32, 0.5, -8), Theme.TextMuted)
                
                local SectionContent = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 48),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = SectionFrame
                })
                Padding(SectionContent, 0, 12, 12, 12)
                
                local ContentLayout = Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 8),
                    Parent = SectionContent
                })
                
                local function UpdateSectionSize()
                    local contentHeight = ContentLayout.AbsoluteContentSize.Y + 24
                    local targetHeight = IsOpened and (44 + contentHeight) or 44
                    Tween(SectionFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25)
                    Tween(Arrow, {Rotation = IsOpened and 180 or 0}, 0.25)
                end
                
                ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if IsOpened then
                        UpdateSectionSize()
                    end
                end)
                
                SectionHeader.MouseButton1Click:Connect(function()
                    IsOpened = not IsOpened
                    UpdateSectionSize()
                end)
                
                task.defer(UpdateSectionSize)
                
                -- Section element methods
                local Section = {}
                
                function Section:Button(opts)
                    return Tab:_CreateButton(opts, SectionContent)
                end
                
                function Section:Toggle(opts)
                    return Tab:_CreateToggle(opts, SectionContent)
                end
                
                function Section:Slider(opts)
                    return Tab:_CreateSlider(opts, SectionContent)
                end
                
                function Section:Dropdown(opts)
                    return Tab:_CreateDropdown(opts, SectionContent)
                end
                
                function Section:Input(opts)
                    return Tab:_CreateInput(opts, SectionContent)
                end
                
                function Section:Keybind(opts)
                    return Tab:_CreateKeybind(opts, SectionContent)
                end
                
                function Section:ColorPicker(opts)
                    return Tab:_CreateColorPicker(opts, SectionContent)
                end
                
                function Section:Paragraph(opts)
                    return Tab:_CreateParagraph(opts, SectionContent)
                end
                
                function Section:Note(opts)
                    return Tab:_CreateNote(opts, SectionContent)
                end
                
                function Section:Divider()
                    return Tab:_CreateDivider(SectionContent)
                end
                
                return Section
            else
                -- Simple divider section
                local SectionDivider = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28),
                    Parent = Page
                })
                
                if SectionIcon then
                    local IconBg = Create("Frame", {
                        BackgroundColor3 = Theme.Primary,
                        BackgroundTransparency = 0.9,
                        Size = UDim2.new(0, 22, 0, 22),
                        Position = UDim2.new(0, 0, 0.5, -11),
                        Parent = SectionDivider
                    })
                    Corner(IconBg, 6)
                    CreateIcon(IconBg, SectionIcon, UDim2.new(0, 12, 0, 12), UDim2.new(0.5, -6, 0.5, -6), Theme.Primary)
                end
                
                local SectionLabel = Create("TextLabel", {
                    Text = string.upper(SectionTitle),
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Primary,
                    TextSize = 11,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 14),
                    Position = UDim2.new(0, SectionIcon and 30 or 0, 0.5, -7),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Parent = SectionDivider
                })
                
                local Line = Create("Frame", {
                    BackgroundColor3 = Theme.Border,
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    Parent = SectionDivider
                })
                
                task.defer(function()
                    local offset = SectionLabel.AbsoluteSize.X + (SectionIcon and 40 or 10)
                    Line.Position = UDim2.new(0, offset, 0.5, 0)
                    Line.Size = UDim2.new(1, -offset, 0, 1)
                end)
            end
        end
        
        -- Button
        function Tab:_CreateButton(options, parent)
            options = options or {}
            local ButtonTitle = options.Title or options.Name or "Button"
            local ButtonDesc = options.Description or options.Desc
            local ButtonCallback = options.Callback or function() end
            
            table.insert(AllElements, {Name = ButtonTitle, Tab = TabName, Type = "Button"})
            
            local height = ButtonDesc and 52 or 40
            
            local Button = Create("TextButton", {
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, height),
                Text = "",
                AutoButtonColor = false,
                Parent = parent or Page
            })
            Corner(Button, 10)
            Stroke(Button, Theme.Border, 1, 0.6)
            
            Create("TextLabel", {
                Text = ButtonTitle,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -50, 0, 16),
                Position = UDim2.new(0, 14, 0, ButtonDesc and 10 or 12),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button
            })
            
            if ButtonDesc then
                Create("TextLabel", {
                    Text = ButtonDesc,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -50, 0, 14),
                    Position = UDim2.new(0, 14, 0, 28),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Button
                })
            end
            
            local Arrow = CreateIcon(Button, "chevron-right", UDim2.new(0, 16, 0, 16), UDim2.new(1, -30, 0.5, -8), Theme.Primary)
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.SurfaceHover}, 0.12)
                Tween(Arrow, {Position = UDim2.new(1, -26, 0.5, -8)}, 0.12)
            end)
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Surface}, 0.12)
                Tween(Arrow, {Position = UDim2.new(1, -30, 0.5, -8)}, 0.12)
            end)
            Button.MouseButton1Click:Connect(function()
                RippleEffect(Button, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                pcall(ButtonCallback)
            end)
        end
        
        -- Toggle (Improved design)
        function Tab:_CreateToggle(options, parent)
            options = options or {}
            local ToggleTitle = options.Title or options.Name or "Toggle"
            local ToggleDesc = options.Description or options.Desc
            local ToggleDefault = options.Default or options.Value or false
            local ToggleCallback = options.Callback or function() end
            local ConfigKey = options.ConfigKey
            
            table.insert(AllElements, {Name = ToggleTitle, Tab = TabName, Type = "Toggle"})
            
            -- Load from config
            if ConfigKey then
                local saved = Config:Get(ConfigKey)
                if saved ~= nil then
                    ToggleDefault = saved
                end
            end
            
            local Toggled = ToggleDefault
            local height = ToggleDesc and 56 or 44
            
            local ToggleFrame = Create("TextButton", {
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, height),
                Text = "",
                AutoButtonColor = false,
                Parent = parent or Page
            })
            Corner(ToggleFrame, 10)
            Stroke(ToggleFrame, Theme.Border, 1, 0.6)
            
            Create("TextLabel", {
                Text = ToggleTitle,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -70, 0, 16),
                Position = UDim2.new(0, 14, 0, ToggleDesc and 12 or 14),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            if ToggleDesc then
                Create("TextLabel", {
                    Text = ToggleDesc,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -70, 0, 14),
                    Position = UDim2.new(0, 14, 0, 30),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })
            end
            
            -- Toggle switch (pill design)
            local SwitchBg = Create("Frame", {
                BackgroundColor3 = Toggled and Theme.Primary or Theme.ToggleOff,
                Size = UDim2.new(0, 44, 0, 24),
                Position = UDim2.new(1, -58, 0.5, -12),
                Parent = ToggleFrame
            })
            Corner(SwitchBg, 12)
            
            local SwitchKnob = Create("Frame", {
                BackgroundColor3 = Theme.Text,
                Size = UDim2.new(0, 18, 0, 18),
                Position = Toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                Parent = SwitchBg
            })
            Corner(SwitchKnob, 9)
            CreateShadow(SwitchKnob, 0.7, 8)
            
            -- Check icon inside knob
            local CheckIcon = CreateIcon(SwitchKnob, "check", UDim2.new(0, 10, 0, 10), UDim2.new(0.5, -5, 0.5, -5), Theme.Primary)
            CheckIcon.ImageTransparency = Toggled and 0 or 1
            
            local function Update()
                if Toggled then
                    Tween(SwitchBg, {BackgroundColor3 = Theme.Primary}, 0.2)
                    Tween(SwitchKnob, {Position = UDim2.new(1, -21, 0.5, -9)}, 0.2, Enum.EasingStyle.Back)
                    Tween(CheckIcon, {ImageTransparency = 0}, 0.15)
                else
                    Tween(SwitchBg, {BackgroundColor3 = Theme.ToggleOff}, 0.2)
                    Tween(SwitchKnob, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.2, Enum.EasingStyle.Back)
                    Tween(CheckIcon, {ImageTransparency = 1}, 0.15)
                end
                
                if ConfigKey then
                    Config:Set(ConfigKey, Toggled)
                end
                
                pcall(ToggleCallback, Toggled)
            end
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Theme.SurfaceHover}, 0.12)
            end)
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Theme.Surface}, 0.12)
            end)
            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Update()
            end)
            
            -- Initial callback
            if Toggled then
                task.defer(function()
                    pcall(ToggleCallback, Toggled)
                end)
            end
            
            return {
                Set = function(_, value)
                    Toggled = value
                    Update()
                end,
                Get = function()
                    return Toggled
                end
            }
        end
        
        -- Slider (Improved design)
        function Tab:_CreateSlider(options, parent)
            options = options or {}
            local SliderTitle = options.Title or options.Name or "Slider"
            local SliderDesc = options.Description or options.Desc
            local SliderMin = options.Min or 0
            local SliderMax = options.Max or 100
            local SliderDefault = options.Default or options.Value or SliderMin
            local SliderIncrement = options.Increment or 1
            local SliderCallback = options.Callback or function() end
            local SliderSuffix = options.Suffix or ""
            local ConfigKey = options.ConfigKey
            
            table.insert(AllElements, {Name = SliderTitle, Tab = TabName, Type = "Slider"})
            
            -- Load from config
            if ConfigKey then
                local saved = Config:Get(ConfigKey)
                if saved ~= nil then
                    SliderDefault = saved
                end
            end
            
            local Value = SliderDefault
            local height = SliderDesc and 72 or 60
            
            local SliderFrame = Create("Frame", {
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, height),
                Parent = parent or Page
            })
            Corner(SliderFrame, 10)
            Stroke(SliderFrame, Theme.Border, 1, 0.6)
            
            Create("TextLabel", {
                Text = SliderTitle,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -80, 0, 16),
                Position = UDim2.new(0, 14, 0, SliderDesc and 10 or 12),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            if SliderDesc then
                Create("TextLabel", {
                    Text = SliderDesc,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -80, 0, 14),
                    Position = UDim2.new(0, 14, 0, 28),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SliderFrame
                })
            end
            
            -- Value display
            local ValueBg = Create("Frame", {
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.9,
                Size = UDim2.new(0, 50, 0, 24),
                Position = UDim2.new(1, -64, 0, SliderDesc and 10 or 10),
                Parent = SliderFrame
            })
            Corner(ValueBg, 6)
            
            local ValueLabel = Create("TextLabel", {
                Text = tostring(Value) .. SliderSuffix,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Primary,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = ValueBg
            })
            
            -- Slider track
            local SliderTrack = Create("TextButton", {
                BackgroundColor3 = Theme.SliderTrack,
                Size = UDim2.new(1, -28, 0, 8),
                Position = UDim2.new(0, 14, 1, -22),
                Text = "",
                AutoButtonColor = false,
                Parent = SliderFrame
            })
            Corner(SliderTrack, 4)
            
            -- Fill
            local Fill = Create("Frame", {
                BackgroundColor3 = Theme.Primary,
                Size = UDim2.new((Value - SliderMin) / (SliderMax - SliderMin), 0, 1, 0),
                Parent = SliderTrack
            })
            Corner(Fill, 4)
            
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Theme.Primary),
                    ColorSequenceKeypoint.new(1, Theme.PrimaryLight)
                }),
                Parent = Fill
            })
            
            -- Knob
            local Knob = Create("Frame", {
                BackgroundColor3 = Theme.Text,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new((Value - SliderMin) / (SliderMax - SliderMin), -9, 0.5, -9),
                ZIndex = 2,
                Parent = SliderTrack
            })
            Corner(Knob, 9)
            Stroke(Knob, Theme.Primary, 2, 0)
            CreateShadow(Knob, 0.6, 10)
            
            local dragging = false
            
            local function UpdateSlider(input)
                local percent = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                local rawValue = SliderMin + ((SliderMax - SliderMin) * percent)
                Value = math.floor(rawValue / SliderIncrement + 0.5) * SliderIncrement
                Value = math.clamp(Value, SliderMin, SliderMax)
                
                local displayPercent = (Value - SliderMin) / (SliderMax - SliderMin)
                
                Tween(Fill, {Size = UDim2.new(displayPercent, 0, 1, 0)}, 0.05)
                Tween(Knob, {Position = UDim2.new(displayPercent, -9, 0.5, -9)}, 0.05)
                ValueLabel.Text = tostring(Value) .. SliderSuffix
                
                if ConfigKey then
                    Config:Set(ConfigKey, Value)
                end
                
                pcall(SliderCallback, Value)
            end
            
            SliderTrack.InputBegan:Connect(function(input)
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
                    Value = math.clamp(value, SliderMin, SliderMax)
                    local percent = (Value - SliderMin) / (SliderMax - SliderMin)
                    Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.15)
                    Tween(Knob, {Position = UDim2.new(percent, -9, 0.5, -9)}, 0.15)
                    ValueLabel.Text = tostring(Value) .. SliderSuffix
                    if ConfigKey then Config:Set(ConfigKey, Value) end
                    pcall(SliderCallback, Value)
                end,
                Get = function()
                    return Value
                end
            }
        end
        
        -- Dropdown
        function Tab:_CreateDropdown(options, parent)
            options = options or {}
            local DropdownTitle = options.Title or options.Name or "Dropdown"
            local DropdownDesc = options.Description or options.Desc
            local DropdownOptions = options.Values or options.Options or {}
            local DropdownDefault = options.Default or options.Value or DropdownOptions[1]
            local DropdownMulti = options.Multi or false
            local DropdownCallback = options.Callback or function() end
            local ConfigKey = options.ConfigKey
            
            table.insert(AllElements, {Name = DropdownTitle, Tab = TabName, Type = "Dropdown"})
            
            -- Load from config
            if ConfigKey then
                local saved = Config:Get(ConfigKey)
                if saved ~= nil then
                    DropdownDefault = saved
                end
            end
            
            local Selected = DropdownMulti and (type(DropdownDefault) == "table" and DropdownDefault or {}) or DropdownDefault
            local Open = false
            local height = DropdownDesc and 56 or 44
            
            local DropdownFrame = Create("Frame", {
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, height),
                ClipsDescendants = true,
                Parent = parent or Page
            })
            Corner(DropdownFrame, 10)
            Stroke(DropdownFrame, Theme.Border, 1, 0.6)
            
            local DropdownBtn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, height),
                Text = "",
                Parent = DropdownFrame
            })
            
            Create("TextLabel", {
                Text = DropdownTitle,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, -10, 0, 16),
                Position = UDim2.new(0, 14, 0, DropdownDesc and 12 or 14),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownBtn
            })
            
            if DropdownDesc then
                Create("TextLabel", {
                    Text = DropdownDesc,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, -10, 0, 14),
                    Position = UDim2.new(0, 14, 0, 30),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownBtn
                })
            end
            
            local function GetDisplayText()
                if DropdownMulti then
                    if #Selected == 0 then return "None" end
                    if #Selected == 1 then return Selected[1] end
                    return #Selected .. " selected"
                else
                    return Selected or "Select..."
                end
            end
            
            local SelectedLabel = Create("TextLabel", {
                Text = GetDisplayText(),
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextSecondary,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.45, -30, 0, height),
                Position = UDim2.new(0.5, 0, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = DropdownBtn
            })
            
            local Arrow = CreateIcon(DropdownBtn, "chevron-down", UDim2.new(0, 14, 0, 14), UDim2.new(1, -28, 0.5, -7), Theme.TextMuted)
            
            -- Options container
            local OptionsContainer = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, #DropdownOptions * 36 + 12),
                Position = UDim2.new(0, 0, 0, height + 4),
                Parent = DropdownFrame
            })
            Padding(OptionsContainer, 6, 8, 8, 6)
            
            local OptionsLayout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4),
                Parent = OptionsContainer
            })
            
            local optionRefs = {}
            
            local function CreateOption(optionText)
                local OptionBtn = Create("TextButton", {
                    BackgroundColor3 = Theme.SurfaceHover,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = OptionsContainer
                })
                Corner(OptionBtn, 8)
                
                Create("TextLabel", {
                    Text = optionText,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 12,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -36, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = OptionBtn
                })
                
                local CheckIcon = CreateIcon(OptionBtn, "check", UDim2.new(0, 14, 0, 14), UDim2.new(1, -28, 0.5, -7), Theme.Primary)
                CheckIcon.Visible = false
                
                local function UpdateOption()
                    local isSelected = false
                    if DropdownMulti then
                        isSelected = table.find(Selected, optionText) ~= nil
                    else
                        isSelected = Selected == optionText
                    end
                    
                    CheckIcon.Visible = isSelected
                    OptionBtn:FindFirstChild("TextLabel").TextColor3 = isSelected and Theme.Text or Theme.TextSecondary
                    OptionBtn:FindFirstChild("TextLabel").Font = isSelected and Enum.Font.GothamMedium or Enum.Font.Gotham
                end
                
                OptionBtn.MouseEnter:Connect(function()
                    Tween(OptionBtn, {BackgroundTransparency = 0.6}, 0.1)
                end)
                OptionBtn.MouseLeave:Connect(function()
                    Tween(OptionBtn, {BackgroundTransparency = 1}, 0.1)
                end)
                
                OptionBtn.MouseButton1Click:Connect(function()
                    if DropdownMulti then
                        local idx = table.find(Selected, optionText)
                        if idx then
                            table.remove(Selected, idx)
                        else
                            table.insert(Selected, optionText)
                        end
                        for _, ref in pairs(optionRefs) do
                            ref.Update()
                        end
                        SelectedLabel.Text = GetDisplayText()
                        if ConfigKey then Config:Set(ConfigKey, Selected) end
                        pcall(DropdownCallback, Selected)
                    else
                        Selected = optionText
                        SelectedLabel.Text = optionText
                        Open = false
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
                        Tween(Arrow, {Rotation = 0}, 0.2)
                        for _, ref in pairs(optionRefs) do
                            ref.Update()
                        end
                        if ConfigKey then Config:Set(ConfigKey, Selected) end
                        pcall(DropdownCallback, optionText)
                    end
                end)
                
                return {Update = UpdateOption, Button = OptionBtn}
            end
            
            for _, opt in ipairs(DropdownOptions) do
                table.insert(optionRefs, CreateOption(opt))
            end
            
            -- Update initial state
            for _, ref in pairs(optionRefs) do
                ref.Update()
            end
            
            DropdownBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local targetHeight = Open and (height + 8 + #DropdownOptions * 36 + 12) or height
                Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.2)
                Tween(Arrow, {Rotation = Open and 180 or 0}, 0.2)
            end)
            
            return {
                Set = function(_, value)
                    if DropdownMulti then
                        Selected = type(value) == "table" and value or {value}
                    else
                        Selected = value
                    end
                    SelectedLabel.Text = GetDisplayText()
                    for _, ref in pairs(optionRefs) do ref.Update() end
                    if ConfigKey then Config:Set(ConfigKey, Selected) end
                    pcall(DropdownCallback, Selected)
                end,
                Get = function()
                    return Selected
                end,
                Refresh = function(_, newOptions)
                    DropdownOptions = newOptions
                    for _, ref in pairs(optionRefs) do
                        ref.Button:Destroy()
                    end
                    optionRefs = {}
                    for _, opt in ipairs(DropdownOptions) do
                        table.insert(optionRefs, CreateOption(opt))
                    end
                    OptionsContainer.Size = UDim2.new(1, 0, 0, #DropdownOptions * 36 + 12)
                end
            }
        end
        
        -- Input
        function Tab:_CreateInput(options, parent)
            options = options or {}
            local InputTitle = options.Title or options.Name or "Input"
            local InputDesc = options.Description or options.Desc
            local InputPlaceholder = options.Placeholder or "Enter text..."
            local InputCallback = options.Callback or function() end
            local ConfigKey = options.ConfigKey
            
            table.insert(AllElements, {Name = InputTitle, Tab = TabName, Type = "Input"})
            
            local height = InputDesc and 56 or 44
            
            local InputFrame = Create("Frame", {
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, height),
                Parent = parent or Page
            })
            Corner(InputFrame, 10)
            Stroke(InputFrame, Theme.Border, 1, 0.6)
            
            Create("TextLabel", {
                Text = InputTitle,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.45, 0, 0, 16),
                Position = UDim2.new(0, 14, 0, InputDesc and 12 or 14),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = InputFrame
            })
            
            if InputDesc then
                Create("TextLabel", {
                    Text = InputDesc,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.45, 0, 0, 14),
                    Position = UDim2.new(0, 14, 0, 30),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = InputFrame
                })
            end
            
            local InputBox = Create("TextBox", {
                BackgroundColor3 = Theme.SurfaceHover,
                Size = UDim2.new(0.48, -20, 0, 30),
                Position = UDim2.new(0.52, 0, 0.5, -15),
                Text = ConfigKey and Config:Get(ConfigKey, "") or "",
                PlaceholderText = InputPlaceholder,
                PlaceholderColor3 = Theme.TextMuted,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.Text,
                TextSize = 12,
                ClearTextOnFocus = false,
                Parent = InputFrame
            })
            Corner(InputBox, 8)
            Padding(InputBox, 0, 10, 10, 0)
            
            local InputStroke = Stroke(InputBox, Theme.Border, 1, 0.5)
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundColor3 = Theme.SurfaceActive}, 0.12)
                Tween(InputStroke, {Color = Theme.Primary, Transparency = 0}, 0.12)
            end)
            
            InputBox.FocusLost:Connect(function(enterPressed)
                Tween(InputBox, {BackgroundColor3 = Theme.SurfaceHover}, 0.12)
                Tween(InputStroke, {Color = Theme.Border, Transparency = 0.5}, 0.12)
                
                if enterPressed then
                    if ConfigKey then Config:Set(ConfigKey, InputBox.Text) end
                    pcall(InputCallback, InputBox.Text)
                end
            end)
            
            return {
                Set = function(_, text)
                    InputBox.Text = text
                    if ConfigKey then Config:Set(ConfigKey, text) end
                end,
                Get = function()
                    return InputBox.Text
                end
            }
        end
        
        -- Keybind
        function Tab:_CreateKeybind(options, parent)
            options = options or {}
            local KeybindTitle = options.Title or options.Name or "Keybind"
            local KeybindDesc = options.Description or options.Desc
            local KeybindDefault = options.Default or options.Value or Enum.KeyCode.E
            local KeybindCallback = options.Callback or function() end
            local ConfigKey = options.ConfigKey
            
            table.insert(AllElements, {Name = KeybindTitle, Tab = TabName, Type = "Keybind"})
            
            local CurrentKey = KeybindDefault
            local Listening = false
            local height = KeybindDesc and 56 or 44
            
            local KeybindFrame = Create("TextButton", {
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, height),
                Text = "",
                AutoButtonColor = false,
                Parent = parent or Page
            })
            Corner(KeybindFrame, 10)
            Stroke(KeybindFrame, Theme.Border, 1, 0.6)
            
            Create("TextLabel", {
                Text = KeybindTitle,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -100, 0, 16),
                Position = UDim2.new(0, 14, 0, KeybindDesc and 12 or 14),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KeybindFrame
            })
            
            if KeybindDesc then
                Create("TextLabel", {
                    Text = KeybindDesc,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 11,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -100, 0, 14),
                    Position = UDim2.new(0, 14, 0, 30),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = KeybindFrame
                })
            end
            
            local KeyDisplay = Create("Frame", {
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.9,
                Size = UDim2.new(0, 70, 0, 28),
                Position = UDim2.new(1, -84, 0.5, -14),
                Parent = KeybindFrame
            })
            Corner(KeyDisplay, 8)
            Stroke(KeyDisplay, Theme.Primary, 1, 0.5)
            
            local KeyLabel = Create("TextLabel", {
                Text = CurrentKey.Name,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Primary,
                TextSize = 11,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = KeyDisplay
            })
            
            KeybindFrame.MouseEnter:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = Theme.SurfaceHover}, 0.12)
            end)
            KeybindFrame.MouseLeave:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = Theme.Surface}, 0.12)
            end)
            
            KeybindFrame.MouseButton1Click:Connect(function()
                Listening = true
                KeyLabel.Text = "..."
                Tween(KeyDisplay, {BackgroundTransparency = 0.7}, 0.12)
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if Listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = input.KeyCode
                        KeyLabel.Text = CurrentKey.Name
                        Tween(KeyDisplay, {BackgroundTransparency = 0.9}, 0.12)
                        Listening = false
                        
                        if ConfigKey then Config:Set(ConfigKey, CurrentKey.Name) end
                    end
                elseif not processed and input.KeyCode == CurrentKey then
                    pcall(KeybindCallback)
                end
            end)
            
            return {
                Set = function(_, key)
                    CurrentKey = key
                    KeyLabel.Text = key.Name
                    if ConfigKey then Config:Set(ConfigKey, key.Name) end
                end,
                Get = function()
                    return CurrentKey
                end
            }
        end
        
        -- Paragraph
        function Tab:_CreateParagraph(options, parent)
            options = options or {}
            local ParagraphTitle = options.Title or ""
            local ParagraphContent = options.Content or ""
            
            local Paragraph = Create("Frame", {
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = parent or Page
            })
            Corner(Paragraph, 10)
            Stroke(Paragraph, Theme.Border, 1, 0.6)
            Padding(Paragraph, 14, 14, 14, 14)
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = Paragraph
            })
            
            if ParagraphTitle ~= "" then
                Create("TextLabel", {
                    Text = ParagraphTitle,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LayoutOrder = 1,
                    Parent = Paragraph
                })
            end
            
            Create("TextLabel", {
                Text = ParagraphContent,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextSecondary,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                LayoutOrder = 2,
                Parent = Paragraph
            })
            
            return {
                Set = function(_, title, content)
                    local labels = Paragraph:GetChildren()
                    for _, label in pairs(labels) do
                        if label:IsA("TextLabel") then
                            if label.LayoutOrder == 1 then
                                label.Text = title or ""
                            else
                                label.Text = content or ""
                            end
                        end
                    end
                end
            }
        end
        
        -- Note (colored info box)
        function Tab:_CreateNote(options, parent)
            options = options or {}
            local NoteContent = options.Content or options.Text or ""
            local NoteType = options.Type or "Info"
            local NoteIcon = options.Icon
            
            local TypeColors = {
                Info = Theme.Info,
                Success = Theme.Success,
                Warning = Theme.Warning,
                Error = Theme.Error
            }
            
            local color = TypeColors[NoteType] or Theme.Info
            local iconName = NoteIcon or (NoteType == "Info" and "info" or NoteType == "Success" and "check-circle" or NoteType == "Warning" and "alert-triangle" or "x-circle")
            
            local Note = Create("Frame", {
                BackgroundColor3 = color,
                BackgroundTransparency = 0.92,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = parent or Page
            })
            Corner(Note, 10)
            Stroke(Note, color, 1, 0.5)
            Padding(Note, 12, 14, 14, 12)
            
            -- Accent bar
            Create("Frame", {
                BackgroundColor3 = color,
                Size = UDim2.new(0, 4, 1, -24),
                Position = UDim2.new(0, 0, 0, 12),
                Parent = Note
            })
            
            local ContentContainer = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -24, 0, 0),
                Position = UDim2.new(0, 24, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = Note
            })
            
            CreateIcon(ContentContainer, iconName, UDim2.new(0, 16, 0, 16), UDim2.new(0, 0, 0, 0), color)
            
            Create("TextLabel", {
                Text = NoteContent,
                Font = Enum.Font.Gotham,
                TextColor3 = color,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -26, 0, 0),
                Position = UDim2.new(0, 26, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = ContentContainer
            })
        end
        
        -- Divider
        function Tab:_CreateDivider(parent)
            local Divider = Create("Frame", {
                BackgroundColor3 = Theme.Border,
                Size = UDim2.new(1, 0, 0, 1),
                Parent = parent or Page
            })
        end
        
        -- Public methods
        function Tab:Button(options)
            return self:_CreateButton(options, Page)
        end
        
        function Tab:Toggle(options)
            return self:_CreateToggle(options, Page)
        end
        
        function Tab:Slider(options)
            return self:_CreateSlider(options, Page)
        end
        
        function Tab:Dropdown(options)
            return self:_CreateDropdown(options, Page)
        end
        
        function Tab:Input(options)
            return self:_CreateInput(options, Page)
        end
        
        function Tab:Keybind(options)
            return self:_CreateKeybind(options, Page)
        end
        
        function Tab:Paragraph(options)
            return self:_CreateParagraph(options, Page)
        end
        
        function Tab:Note(options)
            return self:_CreateNote(options, Page)
        end
        
        function Tab:Divider()
            return self:_CreateDivider(Page)
        end
        
        function Tab:Label(text)
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextSecondary,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Page
            })
        end
        
        return Tab
    end
    
    return Window
end

return Stellar
