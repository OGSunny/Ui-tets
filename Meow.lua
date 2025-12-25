--[[
    Stellar Hub UI Library v3.0
    🔥 PREMIUM EDITION - THE FIRE UI 🔥
    
    Features:
    • Stunning Light Blue/Cyan Theme
    • Glassmorphism + Premium Effects
    • Full Mobile Support + Touch Toggle
    • Player Profile Display
    • Key Status System
    • Named Icons (No Asset IDs)
    • All Device Compatible
    • Smooth 60fps Animations
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local Library = {}

-- 🔥 FIRE LIGHT BLUE THEME 🔥
Library.Theme = {
    Background = Color3.fromRGB(8, 10, 18),
    BackgroundSecondary = Color3.fromRGB(12, 15, 25),
    Card = Color3.fromRGB(16, 20, 32),
    CardHover = Color3.fromRGB(22, 28, 42),
    CardActive = Color3.fromRGB(28, 35, 52),
    
    -- 💎 Light Blue Accent
    Accent = Color3.fromRGB(100, 180, 255),
    AccentLight = Color3.fromRGB(140, 200, 255),
    AccentDark = Color3.fromRGB(60, 140, 220),
    AccentGlow = Color3.fromRGB(80, 160, 255),
    
    -- Secondary Accent (Purple tint)
    Secondary = Color3.fromRGB(140, 120, 255),
    
    -- Text
    Text = Color3.fromRGB(250, 252, 255),
    TextSecondary = Color3.fromRGB(170, 180, 200),
    TextMuted = Color3.fromRGB(100, 115, 140),
    
    -- States
    Success = Color3.fromRGB(80, 220, 160),
    Error = Color3.fromRGB(255, 90, 110),
    Warning = Color3.fromRGB(255, 190, 70),
    
    -- Borders
    Border = Color3.fromRGB(35, 45, 65),
    BorderLight = Color3.fromRGB(50, 65, 90),
    
    -- Glow
    GlowColor = Color3.fromRGB(80, 160, 255),
}

-- 📱 Icon Name Mapping (No Asset IDs needed!)
Library.Icons = {
    -- Navigation
    home = "rbxassetid://7733960981",
    settings = "rbxassetid://7734053495",
    combat = "rbxassetid://7733715400",
    player = "rbxassetid://7743878857",
    world = "rbxassetid://7734068210",
    visuals = "rbxassetid://7734068495",
    misc = "rbxassetid://7733717555",
    target = "rbxassetid://7733992453",
    aim = "rbxassetid://7733678302",
    esp = "rbxassetid://7733749693",
    teleport = "rbxassetid://7734053808",
    speed = "rbxassetid://7734049995",
    fly = "rbxassetid://7733749878",
    noclip = "rbxassetid://7733756466",
    info = "rbxassetid://7733935619",
    credits = "rbxassetid://7733658871",
    scripts = "rbxassetid://7733673367",
    executor = "rbxassetid://7733673367",
    games = "rbxassetid://7733880313",
    favorite = "rbxassetid://7733749693",
    star = "rbxassetid://7734050214",
    heart = "rbxassetid://7733880093",
    shield = "rbxassetid://7734016756",
    sword = "rbxassetid://7733992663",
    magic = "rbxassetid://7733992120",
    -- Default
    default = "rbxassetid://7733756466",
}

Library.Config = {
    CornerRadius = 8,
    SmallCorner = 6,
    AnimSpeed = 0.18,
    AnimSpeedFast = 0.1,
    AnimSpeedSlow = 0.3,
}

Library.ToggleKey = Enum.KeyCode.RightControl

-- Utility Functions
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(inst, props, dur, style, dir)
    local t = TweenService:Create(inst, TweenInfo.new(dur or Library.Config.AnimSpeed, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function Corner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or Library.Config.CornerRadius), Parent = parent})
end

local function Stroke(parent, color, thick, trans)
    return Create("UIStroke", {Color = color or Library.Theme.Border, Thickness = thick or 1, Transparency = trans or 0, Parent = parent})
end

local function Padding(parent, t, r, b, l)
    if type(t) == "number" and not r then r, b, l = t, t, t end
    return Create("UIPadding", {PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r or t), PaddingBottom = UDim.new(0, b or t), PaddingLeft = UDim.new(0, l or t), Parent = parent})
end

local function GetIcon(name)
    return Library.Icons[name:lower()] or Library.Icons.default
end

local function GetAvatar()
    local ok, result = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    return ok and result or ""
end

local function Shadow(parent, size, trans)
    return Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, size or 50, 1, size or 50),
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = trans or 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = parent
    })
end

local function Glow(parent, color, size)
    return Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, size or 40, 1, size or 40),
        Image = "rbxassetid://6014261993",
        ImageColor3 = color or Library.Theme.GlowColor,
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = parent
    })
end

-- Add gradient overlay for glass effect
local function GlassEffect(parent)
    local overlay = Create("Frame", {
        Name = "Glass",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.97,
        Size = UDim2.new(1, 0, 0.5, 0),
        BorderSizePixel = 0,
        Parent = parent
    })
    Corner(overlay, Library.Config.CornerRadius)
    Create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Rotation = 90,
        Parent = overlay
    })
    return overlay
end

-- Main Window
function Library:CreateWindow(config)
    config = config or {}
    local title = config.Name or "Stellar Hub"
    local subtitle = config.Subtitle or "Premium Edition"
    local keyTime = config.KeyTime or "Lifetime"
    local keyExpiry = config.KeyExpiry or "Never"
    local size = config.Size or Vector2.new(680, 460)
    
    local Window = {Tabs = {}, ActiveTab = nil, Visible = true, Minimized = false}
    
    -- ScreenGui
    local gui = Create("ScreenGui", {
        Name = "StellarHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    Window.Gui = gui
    
    -- Mobile Toggle Button (Bottom Right)
    local mobileToggle = Create("TextButton", {
        Name = "MobileToggle",
        BackgroundColor3 = Library.Theme.Accent,
        Position = UDim2.new(1, -70, 1, -70),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 50, 0, 50),
        Text = "☰",
        TextColor3 = Library.Theme.Background,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Visible = false,
        AutoButtonColor = false,
        Parent = gui
    })
    Corner(mobileToggle, 25)
    Shadow(mobileToggle, 30, 0.6)
    local mobileGlow = Glow(mobileToggle, Library.Theme.Accent, 30)
    
    -- Animate mobile button
    spawn(function()
        while mobileToggle and mobileToggle.Parent do
            Tween(mobileGlow, {ImageTransparency = 0.7}, 1)
            wait(1)
            Tween(mobileGlow, {ImageTransparency = 0.9}, 1)
            wait(1)
        end
    end)
    
    -- Main Container
    local container = Create("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, size.X + 60, 0, size.Y + 60),
        Parent = gui
    })
    
    -- Big Shadow
    Shadow(container, 80, 0.4)
    
    -- Main Frame
    local main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Library.Theme.Background,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, size.X, 0, size.Y),
        ClipsDescendants = true,
        Parent = container
    })
    Corner(main, 12)
    Stroke(main, Library.Theme.Border, 1)
    
    -- Accent glow at top
    local topGlow = Create("Frame", {
        Name = "TopGlow",
        BackgroundColor3 = Library.Theme.Accent,
        BackgroundTransparency = 0.92,
        Size = UDim2.new(1, 0, 0, 180),
        BorderSizePixel = 0,
        ZIndex = 0,
        Parent = main
    })
    Create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.85),
            NumberSequenceKeypoint.new(0.5, 0.95),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Rotation = 90,
        Parent = topGlow
    })
    
    -- Title Bar
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Library.Theme.BackgroundSecondary,
        BackgroundTransparency = 0.3,
        Size = UDim2.new(1, 0, 0, 50),
        BorderSizePixel = 0,
        Parent = main
    })
    
    Create("Frame", {
        Name = "Border",
        BackgroundColor3 = Library.Theme.Border,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0,
        Parent = titleBar
    })
    
    -- Logo
    local logoFrame = Create("Frame", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 200, 0, 36),
        Parent = titleBar
    })
    
    local logoIcon = Create("Frame", {
        Name = "Icon",
        BackgroundColor3 = Library.Theme.Accent,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = logoFrame
    })
    Corner(logoIcon, 8)
    Glow(logoIcon, Library.Theme.Accent, 20)
    
    Create("TextLabel", {
        Name = "Star",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "✦",
        TextColor3 = Library.Theme.Background,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = logoIcon
    })
    
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 42, 0, 0),
        Size = UDim2.new(1, -42, 0, 20),
        Text = title,
        TextColor3 = Library.Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = logoFrame
    })
    
    Create("TextLabel", {
        Name = "Subtitle",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 42, 0, 18),
        Size = UDim2.new(1, -42, 0, 16),
        Text = subtitle,
        TextColor3 = Library.Theme.TextMuted,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = logoFrame
    })
    
    -- Right Side Controls
    local rightControls = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -16, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 200, 0, 32),
        Parent = titleBar
    })
    
    -- Key Status Badge
    local keyBadge = Create("Frame", {
        Name = "KeyBadge",
        BackgroundColor3 = Library.Theme.Card,
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 110, 0, 28),
        Parent = rightControls
    })
    Corner(keyBadge, 6)
    Stroke(keyBadge, Library.Theme.Accent, 1, 0.6)
    
    Create("Frame", {
        Name = "Dot",
        BackgroundColor3 = Library.Theme.Success,
        Position = UDim2.new(0, 8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 6, 0, 6),
        Parent = keyBadge
    }):FindFirstChildOfClass("UICorner") or Corner(keyBadge:FindFirstChild("Dot"), 3)
    Corner(keyBadge:FindFirstChild("Dot"), 3)
    
    local keyLabel = Create("TextLabel", {
        Name = "KeyTime",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(1, -28, 1, 0),
        Text = "⏱ " .. keyTime,
        TextColor3 = Library.Theme.Accent,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = keyBadge
    })
    Window.KeyLabel = keyLabel
    
    -- Close Button
    local closeBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Library.Theme.Error,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 28, 0, 28),
        Text = "✕",
        TextColor3 = Library.Theme.Error,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = rightControls
    })
    Corner(closeBtn, 6)
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.4})
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.85})
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(container, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.25)
        gui:Destroy()
    end)
    
    -- Minimize Button
    local minBtn = Create("TextButton", {
        Name = "Min",
        BackgroundColor3 = Library.Theme.Warning,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(1, -36, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 28, 0, 28),
        Text = "─",
        TextColor3 = Library.Theme.Warning,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = rightControls
    })
    Corner(minBtn, 6)
    
    minBtn.MouseEnter:Connect(function() Tween(minBtn, {BackgroundTransparency = 0.4}) end)
    minBtn.MouseLeave:Connect(function() Tween(minBtn, {BackgroundTransparency = 0.85}) end)
    minBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(main, {Size = UDim2.new(0, size.X, 0, 50)}, 0.25, Enum.EasingStyle.Back)
        else
            Tween(main, {Size = UDim2.new(0, size.X, 0, size.Y)}, 0.25, Enum.EasingStyle.Back)
        end
    end)
    
    -- Sidebar
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Library.Theme.BackgroundSecondary,
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(0, 180, 1, -50),
        BorderSizePixel = 0,
        Parent = main
    })
    
    Create("Frame", {
        Name = "Border",
        BackgroundColor3 = Library.Theme.Border,
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    -- Player Profile (Below Tabs will be added after tabs)
    local profileFrame = Create("Frame", {
        Name = "Profile",
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = 0.4,
        Position = UDim2.new(0, 10, 1, -80),
        Size = UDim2.new(1, -20, 0, 70),
        Parent = sidebar
    })
    Corner(profileFrame, 8)
    Stroke(profileFrame, Library.Theme.Border, 1, 0.5)
    
    local avatarFrame = Create("Frame", {
        Name = "Avatar",
        BackgroundColor3 = Library.Theme.Accent,
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 44, 0, 44),
        Parent = profileFrame
    })
    Corner(avatarFrame, 22)
    Stroke(avatarFrame, Library.Theme.Accent, 2, 0.5)
    
    local avatar = Create("ImageLabel", {
        Name = "Image",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 40, 0, 40),
        Image = GetAvatar(),
        Parent = avatarFrame
    })
    Corner(avatar, 20)
    
    Create("TextLabel", {
        Name = "Name",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 62, 0, 12),
        Size = UDim2.new(1, -72, 0, 16),
        Text = LocalPlayer.DisplayName,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = profileFrame
    })
    
    Create("TextLabel", {
        Name = "Username",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 62, 0, 28),
        Size = UDim2.new(1, -72, 0, 14),
        Text = "@" .. LocalPlayer.Name,
        TextColor3 = Library.Theme.TextMuted,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = profileFrame
    })
    
    -- Online Status Dot
    Create("Frame", {
        Name = "Status",
        BackgroundColor3 = Library.Theme.Success,
        Position = UDim2.new(0, 62, 0, 46),
        Size = UDim2.new(0, 6, 0, 6),
        Parent = profileFrame
    }):FindFirstChildOfClass("UICorner") or Corner(profileFrame:FindFirstChild("Status"), 3)
    Corner(profileFrame:FindFirstChild("Status"), 3)
    
    Create("TextLabel", {
        Name = "StatusText",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 72, 0, 42),
        Size = UDim2.new(1, -82, 0, 14),
        Text = "Online",
        TextColor3 = Library.Theme.Success,
        TextSize = 9,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = profileFrame
    })
    
    -- Tab Container
    local tabLabel = Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 12),
        Size = UDim2.new(1, -28, 0, 14),
        Text = "NAVIGATION",
        TextColor3 = Library.Theme.TextMuted,
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sidebar
    })
    
    local tabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 32),
        Size = UDim2.new(1, -16, 1, -120),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Library.Theme.Accent,
        ScrollBarImageTransparency = 0.6,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = tabContainer
    })
    
    -- Content Area
    local contentArea = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 180, 0, 50),
        Size = UDim2.new(1, -180, 1, -50),
        Parent = main
    })
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = container.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
            container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Toggle Visibility
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Library.ToggleKey then
            Window.Visible = not Window.Visible
            gui.Enabled = Window.Visible
            mobileToggle.Visible = IsMobile and not Window.Visible
        end
    end)
    
    -- Mobile Toggle
    if IsMobile then
        mobileToggle.Visible = false
        mobileToggle.MouseButton1Click:Connect(function()
            Window.Visible = not Window.Visible
            container.Visible = Window.Visible
            mobileToggle.Text = Window.Visible and "✕" or "☰"
        end)
    end
    
    -- Update Key Status
    function Window:SetKeyStatus(time)
        keyLabel.Text = "⏱ " .. time
    end
    
    -- Tab Creation
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "default"
        
        local Tab = {Elements = {}}
        
        local tabBtn = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Library.Theme.Card,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 38),
            Text = "",
            AutoButtonColor = false,
            Parent = tabContainer
        })
        Corner(tabBtn, 8)
        
        local indicator = Create("Frame", {
            Name = "Indicator",
            BackgroundColor3 = Library.Theme.Accent,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 3, 0.5, 0),
            Parent = tabBtn
        })
        Corner(indicator, 2)
        
        local iconLabel = Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 18, 0, 18),
            Image = GetIcon(tabIcon),
            ImageColor3 = Library.Theme.TextMuted,
            Parent = tabBtn
        })
        
        local titleLabel = Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 38, 0, 0),
            Size = UDim2.new(1, -46, 1, 0),
            Text = tabName,
            TextColor3 = Library.Theme.TextMuted,
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn
        })
        
        Tab.Button = tabBtn
        Tab.Indicator = indicator
        Tab.Icon = iconLabel
        Tab.Title = titleLabel
        
        local content = Create("ScrollingFrame", {
            Name = tabName,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 16, 0, 16),
            Size = UDim2.new(1, -32, 1, -32),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.Theme.Accent,
            ScrollBarImageTransparency = 0.5,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = contentArea
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = content
        })
        
        Tab.Content = content
        
        local function selectTab()
            for _, t in pairs(Window.Tabs) do
                Tween(t.Button, {BackgroundTransparency = 1})
                Tween(t.Indicator, {BackgroundTransparency = 1})
                Tween(t.Title, {TextColor3 = Library.Theme.TextMuted})
                Tween(t.Icon, {ImageColor3 = Library.Theme.TextMuted})
                t.Content.Visible = false
            end
            
            Tween(tabBtn, {BackgroundTransparency = 0.6})
            Tween(indicator, {BackgroundTransparency = 0})
            Tween(titleLabel, {TextColor3 = Library.Theme.Text})
            Tween(iconLabel, {ImageColor3 = Library.Theme.Accent})
            content.Visible = true
            Window.ActiveTab = Tab
        end
        
        tabBtn.MouseButton1Click:Connect(selectTab)
        
        tabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 0.7})
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 1})
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then selectTab() end
        
        -- Section
        function Tab:CreateSection(config)
            config = config or {}
            local name = config.Name or "Section"
            
            local section = Create("Frame", {
                Name = "Section",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 26),
                Parent = content
            })
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Text = name:upper(),
                TextColor3 = Library.Theme.Accent,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = section
            })
            
            local line = Create("Frame", {
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
            local name = config.Name or "Toggle"
            local desc = config.Description
            local default = config.CurrentValue or false
            local callback = config.Callback or function() end
            
            local Toggle = {Value = default, Type = "Toggle"}
            local h = desc and 56 or 44
            
            local frame = Create("Frame", {
                Name = "Toggle",
                BackgroundColor3 = Library.Theme.Card,
                Size = UDim2.new(1, 0, 0, h),
                Parent = content
            })
            Corner(frame, 8)
            Stroke(frame, Library.Theme.Border, 1, 0.6)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, desc and 10 or 0),
                Size = UDim2.new(1, -70, 0, desc and 18 or h),
                Text = name,
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            if desc then
                Create("TextLabel", {
                    Name = "Desc",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 28),
                    Size = UDim2.new(1, -70, 0, 16),
                    Text = desc,
                    TextColor3 = Library.Theme.TextMuted,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame
                })
            end
            
            local switch = Create("Frame", {
                Name = "Switch",
                BackgroundColor3 = Library.Theme.CardActive,
                Position = UDim2.new(1, -56, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 42, 0, 24),
                Parent = frame
            })
            Corner(switch, 12)
            
            local knob = Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Library.Theme.TextMuted,
                Position = UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 18, 0, 18),
                Parent = switch
            })
            Corner(knob, 9)
            
            local glow = Glow(switch, Library.Theme.Accent, 20)
            glow.ImageTransparency = 1
            
            local function update(skip)
                if Toggle.Value then
                    Tween(switch, {BackgroundColor3 = Library.Theme.Accent})
                    Tween(knob, {Position = UDim2.new(1, -21, 0.5, 0), BackgroundColor3 = Library.Theme.Background})
                    Tween(glow, {ImageTransparency = 0.7})
                else
                    Tween(switch, {BackgroundColor3 = Library.Theme.CardActive})
                    Tween(knob, {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = Library.Theme.TextMuted})
                    Tween(glow, {ImageTransparency = 1})
                end
                if not skip then callback(Toggle.Value) end
            end
            
            update(true)
            
            local btn = Create("TextButton", {
                Name = "Click",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = frame
            })
            
            btn.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                update()
            end)
            
            btn.MouseEnter:Connect(function() Tween(frame, {BackgroundColor3 = Library.Theme.CardHover}) end)
            btn.MouseLeave:Connect(function() Tween(frame, {BackgroundColor3 = Library.Theme.Card}) end)
            
            function Toggle:Set(v) Toggle.Value = v update() end
            table.insert(Tab.Elements, Toggle)
            return Toggle
        end
        
        -- Slider
        function Tab:CreateSlider(config)
            config = config or {}
            local name = config.Name or "Slider"
            local range = config.Range or {0, 100}
            local inc = config.Increment or 1
            local suffix = config.Suffix or ""
            local default = config.CurrentValue or range[1]
            local callback = config.Callback or function() end
            
            local Slider = {Value = default, Type = "Slider"}
            
            local frame = Create("Frame", {
                Name = "Slider",
                BackgroundColor3 = Library.Theme.Card,
                Size = UDim2.new(1, 0, 0, 58),
                Parent = content
            })
            Corner(frame, 8)
            Stroke(frame, Library.Theme.Border, 1, 0.6)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 10),
                Size = UDim2.new(0.5, 0, 0, 16),
                Text = name,
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local valueLabel = Create("TextLabel", {
                Name = "Value",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -14, 0, 10),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0.4, 0, 0, 16),
                Text = tostring(default) .. suffix,
                TextColor3 = Library.Theme.Accent,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = frame
            })
            
            local track = Create("Frame", {
                Name = "Track",
                BackgroundColor3 = Library.Theme.CardActive,
                Position = UDim2.new(0, 14, 1, -18),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(1, -28, 0, 8),
                Parent = frame
            })
            Corner(track, 4)
            
            local fill = Create("Frame", {
                Name = "Fill",
                BackgroundColor3 = Library.Theme.Accent,
                Size = UDim2.new((default - range[1]) / (range[2] - range[1]), 0, 1, 0),
                Parent = track
            })
            Corner(fill, 4)
            
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Library.Theme.AccentDark),
                    ColorSequenceKeypoint.new(1, Library.Theme.Accent)
                }),
                Parent = fill
            })
            
            local knob = Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Library.Theme.Text,
                Position = UDim2.new((default - range[1]) / (range[2] - range[1]), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0, 16, 0, 16),
                ZIndex = 2,
                Parent = track
            })
            Corner(knob, 8)
            Stroke(knob, Library.Theme.Accent, 2)
            
            local dragging = false
            
            local function update(v, skip)
                v = math.clamp(v, range[1], range[2])
                v = math.floor(v / inc + 0.5) * inc
                Slider.Value = v
                local pct = (v - range[1]) / (range[2] - range[1])
                Tween(fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05)
                Tween(knob, {Position = UDim2.new(pct, 0, 0.5, 0)}, 0.05)
                valueLabel.Text = tostring(v) .. suffix
                if not skip then callback(v) end
            end
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    update(range[1] + (range[2] - range[1]) * pct)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    update(range[1] + (range[2] - range[1]) * pct)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            function Slider:Set(v) update(v) end
            table.insert(Tab.Elements, Slider)
            return Slider
        end
        
        -- Button
        function Tab:CreateButton(config)
            config = config or {}
            local name = config.Name or "Button"
            local desc = config.Description
            local callback = config.Callback or function() end
            
            local Button = {Type = "Button"}
            local h = desc and 54 or 42
            
            local frame = Create("TextButton", {
                Name = "Button",
                BackgroundColor3 = Library.Theme.Card,
                Size = UDim2.new(1, 0, 0, h),
                Text = "",
                AutoButtonColor = false,
                Parent = content
            })
            Corner(frame, 8)
            Stroke(frame, Library.Theme.Accent, 1, 0.7)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, desc and 10 or 0),
                Size = UDim2.new(1, -50, 0, desc and 18 or h),
                Text = name,
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            if desc then
                Create("TextLabel", {
                    Name = "Desc",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 28),
                    Size = UDim2.new(1, -50, 0, 16),
                    Text = desc,
                    TextColor3 = Library.Theme.TextMuted,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame
                })
            end
            
            Create("TextLabel", {
                Name = "Arrow",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 16, 0, 16),
                Text = "→",
                TextColor3 = Library.Theme.Accent,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                Parent = frame
            })
            
            frame.MouseEnter:Connect(function() Tween(frame, {BackgroundColor3 = Library.Theme.CardHover}) end)
            frame.MouseLeave:Connect(function() Tween(frame, {BackgroundColor3 = Library.Theme.Card}) end)
            frame.MouseButton1Click:Connect(function()
                Tween(frame, {BackgroundColor3 = Library.Theme.Accent}, 0.08)
                task.wait(0.08)
                Tween(frame, {BackgroundColor3 = Library.Theme.Card}, 0.15)
                callback()
            end)
            
            table.insert(Tab.Elements, Button)
            return Button
        end
        
        -- Dropdown
        function Tab:CreateDropdown(config)
            config = config or {}
            local name = config.Name or "Dropdown"
            local options = config.Options or {}
            local default = config.CurrentOption or (options[1] or "")
            local multi = config.MultiSelect or false
            local callback = config.Callback or function() end
            
            local Dropdown = {Value = multi and {} or default, Options = options, Open = false, Type = "Dropdown"}
            if multi and type(default) == "table" then Dropdown.Value = default end
            
            local frame = Create("Frame", {
                Name = "Dropdown",
                BackgroundColor3 = Library.Theme.Card,
                Size = UDim2.new(1, 0, 0, 44),
                ClipsDescendants = true,
                Parent = content
            })
            Corner(frame, 8)
            Stroke(frame, Library.Theme.Border, 1, 0.6)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 12),
                Size = UDim2.new(0.4, 0, 0, 20),
                Text = name,
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local function getDisplay()
                if multi then
                    if #Dropdown.Value == 0 then return "None"
                    elseif #Dropdown.Value <= 2 then return table.concat(Dropdown.Value, ", ")
                    else return #Dropdown.Value .. " selected" end
                end
                return Dropdown.Value or "Select..."
            end
            
            local selectBtn = Create("TextButton", {
                Name = "Select",
                BackgroundColor3 = Library.Theme.CardActive,
                Position = UDim2.new(1, -14, 0, 8),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0.5, -10, 0, 28),
                Text = "",
                AutoButtonColor = false,
                Parent = frame
            })
            Corner(selectBtn, 6)
            
            local selectLabel = Create("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = getDisplay(),
                TextColor3 = Library.Theme.TextSecondary,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = selectBtn
            })
            
            local arrow = Create("TextLabel", {
                Name = "Arrow",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -6, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0, 12, 0, 12),
                Text = "▼",
                TextColor3 = Library.Theme.TextMuted,
                TextSize = 8,
                Font = Enum.Font.GothamBold,
                Parent = selectBtn
            })
            
            local optionsFrame = Create("Frame", {
                Name = "Options",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 48),
                Size = UDim2.new(1, -20, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = frame
            })
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4),
                Parent = optionsFrame
            })
            
            local optBtns = {}
            
            local function refresh()
                for _, b in pairs(optBtns) do b:Destroy() end
                optBtns = {}
                
                for i, opt in ipairs(Dropdown.Options) do
                    local sel = multi and table.find(Dropdown.Value, opt) or Dropdown.Value == opt
                    
                    local optBtn = Create("TextButton", {
                        Name = opt,
                        BackgroundColor3 = sel and Library.Theme.Accent or Library.Theme.CardActive,
                        BackgroundTransparency = sel and 0.7 or 0,
                        Size = UDim2.new(1, 0, 0, 30),
                        Text = opt,
                        TextColor3 = sel and Library.Theme.Accent or Library.Theme.TextSecondary,
                        TextSize = 11,
                        Font = Enum.Font.GothamMedium,
                        AutoButtonColor = false,
                        LayoutOrder = i,
                        Parent = optionsFrame
                    })
                    Corner(optBtn, 6)
                    if sel then Stroke(optBtn, Library.Theme.Accent, 1, 0.5) end
                    
                    optBtn.MouseEnter:Connect(function()
                        if not sel then Tween(optBtn, {BackgroundColor3 = Library.Theme.CardHover}) end
                    end)
                    optBtn.MouseLeave:Connect(function()
                        if not sel then Tween(optBtn, {BackgroundColor3 = Library.Theme.CardActive}) end
                    end)
                    optBtn.MouseButton1Click:Connect(function()
                        if multi then
                            local idx = table.find(Dropdown.Value, opt)
                            if idx then table.remove(Dropdown.Value, idx) else table.insert(Dropdown.Value, opt) end
                            refresh()
                            selectLabel.Text = getDisplay()
                            callback(Dropdown.Value)
                        else
                            Dropdown.Value = opt
                            selectLabel.Text = opt
                            Dropdown.Open = false
                            Tween(frame, {Size = UDim2.new(1, 0, 0, 44)}, 0.2)
                            Tween(arrow, {Rotation = 0})
                            callback(opt)
                        end
                    end)
                    
                    table.insert(optBtns, optBtn)
                end
            end
            
            refresh()
            
            selectBtn.MouseButton1Click:Connect(function()
                Dropdown.Open = not Dropdown.Open
                if Dropdown.Open then
                    local h = 52 + (#Dropdown.Options * 34)
                    Tween(frame, {Size = UDim2.new(1, 0, 0, math.min(h, 220))}, 0.2, Enum.EasingStyle.Back)
                    Tween(arrow, {Rotation = 180})
                else
                    Tween(frame, {Size = UDim2.new(1, 0, 0, 44)}, 0.2)
                    Tween(arrow, {Rotation = 0})
                end
            end)
            
            function Dropdown:Set(v)
                Dropdown.Value = multi and (type(v) == "table" and v or {v}) or v
                selectLabel.Text = getDisplay()
                refresh()
                callback(Dropdown.Value)
            end
            
            function Dropdown:Refresh(opts)
                Dropdown.Options = opts
                refresh()
            end
            
            table.insert(Tab.Elements, Dropdown)
            return Dropdown
        end
        
        -- Input
        function Tab:CreateInput(config)
            config = config or {}
            local name = config.Name or "Input"
            local placeholder = config.PlaceholderText or "Enter..."
            local numeric = config.NumbersOnly or false
            local callback = config.Callback or function() end
            
            local Input = {Value = "", Type = "Input"}
            
            local frame = Create("Frame", {
                Name = "Input",
                BackgroundColor3 = Library.Theme.Card,
                Size = UDim2.new(1, 0, 0, 44),
                Parent = content
            })
            Corner(frame, 8)
            Stroke(frame, Library.Theme.Border, 1, 0.6)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0.35, 0, 0, 16),
                Text = name,
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local box = Create("TextBox", {
                Name = "Box",
                BackgroundColor3 = Library.Theme.CardActive,
                Position = UDim2.new(1, -14, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0.55, 0, 0, 30),
                PlaceholderText = placeholder,
                PlaceholderColor3 = Library.Theme.TextMuted,
                Text = "",
                TextColor3 = Library.Theme.Text,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                ClearTextOnFocus = false,
                Parent = frame
            })
            Corner(box, 6)
            Padding(box, 0, 10, 0, 10)
            local boxStroke = Stroke(box, Library.Theme.Border, 1, 0.5)
            
            box.Focused:Connect(function() Tween(boxStroke, {Color = Library.Theme.Accent, Transparency = 0}) end)
            box.FocusLost:Connect(function(enter)
                Tween(boxStroke, {Color = Library.Theme.Border, Transparency = 0.5})
                local v = box.Text
                if numeric then v = tonumber(v) or 0 box.Text = tostring(v) end
                Input.Value = v
                if enter then callback(v) end
            end)
            
            if numeric then
                box:GetPropertyChangedSignal("Text"):Connect(function()
                    box.Text = box.Text:gsub("[^%d%.%-]", "")
                end)
            end
            
            function Input:Set(v) box.Text = tostring(v) Input.Value = v end
            table.insert(Tab.Elements, Input)
            return Input
        end
        
        -- Keybind
        function Tab:CreateKeybind(config)
            config = config or {}
            local name = config.Name or "Keybind"
            local default = config.CurrentKeybind or "None"
            local callback = config.Callback or function() end
            
            local Keybind = {Value = default, Listening = false, Type = "Keybind"}
            
            local frame = Create("Frame", {
                Name = "Keybind",
                BackgroundColor3 = Library.Theme.Card,
                Size = UDim2.new(1, 0, 0, 44),
                Parent = content
            })
            Corner(frame, 8)
            Stroke(frame, Library.Theme.Border, 1, 0.6)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0.6, 0, 0, 16),
                Text = name,
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = frame
            })
            
            local keyBtn = Create("TextButton", {
                Name = "Key",
                BackgroundColor3 = Library.Theme.CardActive,
                Position = UDim2.new(1, -14, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0, 80, 0, 28),
                Text = default,
                TextColor3 = Library.Theme.Accent,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
                Parent = frame
            })
            Corner(keyBtn, 6)
            local keyStroke = Stroke(keyBtn, Library.Theme.Accent, 1, 0.6)
            
            keyBtn.MouseButton1Click:Connect(function()
                Keybind.Listening = true
                keyBtn.Text = "..."
                Tween(keyBtn, {BackgroundColor3 = Library.Theme.Accent})
                keyBtn.TextColor3 = Library.Theme.Background
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if Keybind.Listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind.Value = input.KeyCode.Name
                        keyBtn.Text = input.KeyCode.Name
                        Keybind.Listening = false
                        Tween(keyBtn, {BackgroundColor3 = Library.Theme.CardActive})
                        keyBtn.TextColor3 = Library.Theme.Accent
                    end
                elseif not processed and input.KeyCode.Name == Keybind.Value then
                    callback(Keybind.Value)
                end
            end)
            
            function Keybind:Set(k) Keybind.Value = k keyBtn.Text = k end
            table.insert(Tab.Elements, Keybind)
            return Keybind
        end
        
        -- Label
        function Tab:CreateLabel(config)
            config = config or {}
            local text = config.Name or "Label"
            
            local Label = {Type = "Label"}
            
            local label = Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 22),
                Text = text,
                TextColor3 = Library.Theme.TextMuted,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = content
            })
            
            function Label:Set(t) label.Text = t end
            table.insert(Tab.Elements, Label)
            return Label
        end
        
        -- Paragraph
        function Tab:CreateParagraph(config)
            config = config or {}
            local title = config.Title or "Title"
            local text = config.Content or "Content"
            
            local Paragraph = {Type = "Paragraph"}
            
            local frame = Create("Frame", {
                Name = "Paragraph",
                BackgroundColor3 = Library.Theme.Card,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = content
            })
            Corner(frame, 8)
            Stroke(frame, Library.Theme.Border, 1, 0.6)
            Padding(frame, 14)
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = frame
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                Text = title,
                TextColor3 = Library.Theme.Accent,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 1,
                Parent = frame
            })
            
            local contentLabel = Create("TextLabel", {
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Text = text,
                TextColor3 = Library.Theme.TextSecondary,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                LayoutOrder = 2,
                Parent = frame
            })
            
            function Paragraph:Set(t, c) titleLabel.Text = t or title contentLabel.Text = c or text end
            table.insert(Tab.Elements, Paragraph)
            return Paragraph
        end
        
        return Tab
    end
    
    return Window
end

return Library
