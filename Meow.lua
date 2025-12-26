--[[
    ███████╗████████╗███████╗██╗     ██╗      █████╗ ██████╗ 
    ██╔════╝╚══██╔══╝██╔════╝██║     ██║     ██╔══██╗██╔══██╗
    ███████╗   ██║   █████╗  ██║     ██║     ███████║██████╔╝
    ╚════██║   ██║   ██╔══╝  ██║     ██║     ██╔══██║██╔══██╗
    ███████║   ██║   ███████╗███████╗███████╗██║  ██║██║  ██║
    ╚══════╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
    
    Stellar Hub UI Library v4.0
    Premium • Clean • Professional
]]

local Stellar = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Asset IDs for Icons
local Icons = {
    Home = "rbxassetid://7733960981",
    Settings = "rbxassetid://7734053495",
    Combat = "rbxassetid://7733714927",
    Eye = "rbxassetid://7733715057",
    Misc = "rbxassetid://7734007024",
    Player = "rbxassetid://7733756006",
    World = "rbxassetid://7734109848",
    Star = "rbxassetid://7733942620",
    Check = "rbxassetid://7733715725",
    Close = "rbxassetid://7733717221",
    Minimize = "rbxassetid://7733691322",
    Maximize = "rbxassetid://7733704254",
    Search = "rbxassetid://7733715313",
    Copy = "rbxassetid://7733717443",
    Discord = "rbxassetid://7733716244",
    Arrow = "rbxassetid://7734035818",
    ArrowDown = "rbxassetid://7734035693",
    Folder = "rbxassetid://7733715267",
    Code = "rbxassetid://7733716453",
    Heart = "rbxassetid://7733704102",
    Shield = "rbxassetid://7733942552",
    Target = "rbxassetid://7733693637",
    Zap = "rbxassetid://7734111113",
    Clock = "rbxassetid://7733716643",
    Users = "rbxassetid://7734112226",
    Wifi = "rbxassetid://7734108498",
    Monitor = "rbxassetid://7733703084",
    Info = "rbxassetid://7733716088",
    Warning = "rbxassetid://7733672508",
    Error = "rbxassetid://7733715723",
    Success = "rbxassetid://7733715725",
    Slider = "rbxassetid://7734095186",
    Toggle = "rbxassetid://7733691296",
    Dropdown = "rbxassetid://7734035693",
    Input = "rbxassetid://7733756120",
    Keybind = "rbxassetid://7733716118",
    Color = "rbxassetid://7733703103",
    Lock = "rbxassetid://7733689871",
    Unlock = "rbxassetid://7733717087",
    Refresh = "rbxassetid://7733715167",
    Plus = "rbxassetid://7733715183",
    Game = "rbxassetid://7733689845",
    Crown = "rbxassetid://7733681505"
}

-- Light Blue Theme
local Theme = {
    Background = Color3.fromRGB(12, 17, 28),
    Secondary = Color3.fromRGB(18, 24, 38),
    Tertiary = Color3.fromRGB(24, 32, 50),
    Elevated = Color3.fromRGB(32, 42, 65),
    Hover = Color3.fromRGB(38, 50, 78),
    
    Primary = Color3.fromRGB(59, 165, 255),
    PrimaryDark = Color3.fromRGB(45, 140, 225),
    PrimaryLight = Color3.fromRGB(100, 190, 255),
    
    Text = Color3.fromRGB(245, 248, 255),
    TextDark = Color3.fromRGB(180, 190, 210),
    TextMuted = Color3.fromRGB(120, 135, 160),
    
    Success = Color3.fromRGB(45, 212, 140),
    Warning = Color3.fromRGB(255, 185, 50),
    Error = Color3.fromRGB(255, 85, 95),
    
    Divider = Color3.fromRGB(45, 55, 80),
    Transparent = Color3.fromRGB(255, 255, 255)
}

-- Utility Functions
local function Create(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(object, properties, duration, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out),
        properties
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

local function CreateIcon(parent, iconId, size, position, color)
    return Create("ImageLabel", {
        Image = iconId,
        ImageColor3 = color or Theme.TextDark,
        BackgroundTransparency = 1,
        Size = size or UDim2.new(0, 18, 0, 18),
        Position = position or UDim2.new(0, 0, 0.5, -9),
        AnchorPoint = Vector2.new(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = parent
    })
end

local function MakeDraggable(dragObject, targetObject)
    local dragging = false
    local dragStart, startPos
    
    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetObject.Position
        end
    end)
    
    dragObject.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Tween(targetObject, {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }, 0.06)
        end
    end)
end

local function Ripple(button)
    local ripple = Create("Frame", {
        BackgroundColor3 = Theme.Transparent,
        BackgroundTransparency = 0.85,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = button
    })
    Corner(ripple, 100)
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.4)
    
    task.delay(0.4, function()
        if ripple then ripple:Destroy() end
    end)
end

-- Main Library
function Stellar:CreateWindow(config)
    config = config or {}
    local WindowTitle = config.Title or "Stellar Hub"
    local WindowSubtitle = config.Subtitle or "v4.0"
    local WindowLogo = config.Logo or Icons.Star
    local WindowSize = config.Size or UDim2.new(0, 820, 0, 520)
    local ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    
    -- Cleanup
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
    
    -- Main Container
    local MainFrame = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Theme.Background,
        Size = WindowSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    Corner(MainFrame, 10)
    
    -- Shadow
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 55, 1, 55),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Parent = MainFrame
    })
    
    --[[ SIDEBAR ]]--
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(0, 200, 1, 0),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    Corner(Sidebar, 10)
    
    -- Fix right corner of sidebar
    Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(0, 12, 1, 0),
        Position = UDim2.new(1, -12, 0, 0),
        BorderSizePixel = 0,
        Parent = Sidebar
    })
    
    -- Sidebar border
    Create("Frame", {
        Name = "Border",
        BackgroundColor3 = Theme.Divider,
        Size = UDim2.new(0, 1, 1, -16),
        Position = UDim2.new(1, 0, 0, 8),
        BorderSizePixel = 0,
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
    local LogoContainer = Create("Frame", {
        Name = "Logo",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(0, 42, 0, 42),
        Position = UDim2.new(0, 16, 0, 14),
        Parent = Header
    })
    Corner(LogoContainer, 10)
    
    local LogoIcon = Create("ImageLabel", {
        Image = WindowLogo,
        ImageColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 22, 0, 22),
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
        TextSize = 15,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 68, 0, 18),
        Size = UDim2.new(1, -75, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    -- Subtitle
    Create("TextLabel", {
        Text = WindowSubtitle,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 68, 0, 38),
        Size = UDim2.new(1, -75, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    -- Nav Label
    Create("TextLabel", {
        Text = "NAVIGATION",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 78),
        Size = UDim2.new(1, -32, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Sidebar
    })
    
    -- Tab Container
    local TabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -145),
        Position = UDim2.new(0, 0, 0, 98),
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
    Padding(TabContainer, 0, 10, 10, 10)
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- User Info
    local UserContainer = Create("Frame", {
        Name = "User",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, -20, 0, 42),
        Position = UDim2.new(0, 10, 1, -52),
        Parent = Sidebar
    })
    Corner(UserContainer, 8)
    
    local UserAvatar = Create("ImageLabel", {
        Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100),
        BackgroundColor3 = Theme.Elevated,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 6, 0.5, -15),
        Parent = UserContainer
    })
    Corner(UserAvatar, 15)
    
    Create("TextLabel", {
        Text = Player.DisplayName,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextSize = 12,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 42, 0, 6),
        Size = UDim2.new(1, -50, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = UserContainer
    })
    
    Create("TextLabel", {
        Text = "@" .. Player.Name,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 42, 0, 22),
        Size = UDim2.new(1, -50, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = UserContainer
    })
    
    --[[ CONTENT AREA ]]--
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -200, 1, 0),
        Position = UDim2.new(0, 200, 0, 0),
        Parent = MainFrame
    })
    
    -- TopBar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 55),
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
        Position = UDim2.new(0, 20, 0, 15),
        Size = UDim2.new(0.5, 0, 0, 25),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    -- Window Controls
    local Controls = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 75, 0, 30),
        Position = UDim2.new(1, -90, 0, 12),
        Parent = TopBar
    })
    
    local ControlLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
        Parent = Controls
    })
    
    -- Minimize Button
    local MinBtn = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    Corner(MinBtn, 8)
    
    local MinIcon = CreateIcon(MinBtn, Icons.Minimize, UDim2.new(0, 14, 0, 14), UDim2.new(0.5, 0, 0.5, 0), Theme.TextDark)
    MinIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, {BackgroundColor3 = Theme.Elevated}, 0.15)
        Tween(MinIcon, {ImageColor3 = Theme.Text}, 0.15)
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
        Tween(MinIcon, {ImageColor3 = Theme.TextDark}, 0.15)
    end)
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    Corner(CloseBtn, 8)
    
    local CloseIcon = CreateIcon(CloseBtn, Icons.Close, UDim2.new(0, 14, 0, 14), UDim2.new(0.5, 0, 0.5, 0), Theme.TextDark)
    CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.Error}, 0.15)
        Tween(CloseIcon, {ImageColor3 = Theme.Text}, 0.15)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.Tertiary}, 0.15)
        Tween(CloseIcon, {ImageColor3 = Theme.TextDark}, 0.15)
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Ripple(CloseBtn)
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        Tween(Shadow, {ImageTransparency = 1}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Page Container
    local PageContainer = Create("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -55),
        Position = UDim2.new(0, 0, 0, 55),
        ClipsDescendants = true,
        Parent = Content
    })
    
    --[[ TOGGLE BUTTON (When Minimized) ]]--
    local ToggleBtn = Create("TextButton", {
        Name = "Toggle",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 20, 1, -70),
        Text = "",
        AutoButtonColor = false,
        Visible = false,
        Parent = ScreenGui
    })
    Corner(ToggleBtn, 25)
    
    local ToggleShadow = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Theme.Primary,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Parent = ToggleBtn
    })
    
    local ToggleIcon = CreateIcon(ToggleBtn, WindowLogo, UDim2.new(0, 24, 0, 24), UDim2.new(0.5, 0, 0.5, 0), Theme.Text)
    ToggleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    
    ToggleBtn.MouseEnter:Connect(function()
        Tween(ToggleBtn, {Size = UDim2.new(0, 55, 0, 55)}, 0.2, Enum.EasingStyle.Back)
    end)
    ToggleBtn.MouseLeave:Connect(function()
        Tween(ToggleBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.2)
    end)
    
    -- Minimize/Maximize Functions
    local function Minimize()
        Minimized = true
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(Shadow, {ImageTransparency = 1}, 0.3)
        task.wait(0.25)
        MainFrame.Visible = false
        ToggleBtn.Visible = true
        ToggleBtn.Size = UDim2.new(0, 0, 0, 0)
        Tween(ToggleBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.3, Enum.EasingStyle.Back)
    end
    
    local function Maximize()
        Minimized = false
        ToggleBtn.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Tween(MainFrame, {Size = WindowSize}, 0.35, Enum.EasingStyle.Back)
        Tween(Shadow, {ImageTransparency = 0.4}, 0.35)
    end
    
    MinBtn.MouseButton1Click:Connect(function()
        Ripple(MinBtn)
        task.wait(0.1)
        Minimize()
    end)
    
    ToggleBtn.MouseButton1Click:Connect(function()
        Maximize()
    end)
    
    -- Keybind Toggle
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == ToggleKey then
            if Minimized then
                Maximize()
            else
                Minimize()
            end
        end
    end)
    
    --[[ DASHBOARD PAGE ]]--
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
        Padding(DashPage, 10, 20, 20, 20)
        
        local DashLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12),
            Parent = DashPage
        })
        
        DashLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            DashPage.CanvasSize = UDim2.new(0, 0, 0, DashLayout.AbsoluteContentSize.Y + 40)
        end)
        
        -- Welcome Banner
        local Banner = Create("Frame", {
            Name = "Banner",
            BackgroundColor3 = Theme.Primary,
            Size = UDim2.new(1, 0, 0, 120),
            LayoutOrder = 1,
            Parent = DashPage
        })
        Corner(Banner, 10)
        
        -- Banner Gradient
        Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(59, 130, 246)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(99, 102, 241)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 92, 246))
            }),
            Rotation = 25,
            Parent = Banner
        })
        
        -- Decorative circles
        local Circle1 = Create("Frame", {
            BackgroundColor3 = Theme.Transparent,
            BackgroundTransparency = 0.92,
            Size = UDim2.new(0, 180, 0, 180),
            Position = UDim2.new(1, -50, 0, -60),
            Parent = Banner
        })
        Corner(Circle1, 90)
        
        local Circle2 = Create("Frame", {
            BackgroundColor3 = Theme.Transparent,
            BackgroundTransparency = 0.95,
            Size = UDim2.new(0, 120, 0, 120),
            Position = UDim2.new(1, -150, 0, 40),
            Parent = Banner
        })
        Corner(Circle2, 60)
        
        -- Avatar
        local BannerAvatar = Create("ImageLabel", {
            Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150),
            BackgroundColor3 = Theme.Background,
            Size = UDim2.new(0, 85, 0, 85),
            Position = UDim2.new(0, 18, 0.5, -42),
            Parent = Banner
        })
        Corner(BannerAvatar, 42)
        
        Create("TextLabel", {
            Text = "Welcome back,",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.Transparent,
            TextTransparency = 0.3,
            TextSize = 13,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 115, 0, 28),
            Size = UDim2.new(0.5, 0, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Banner
        })
        
        Create("TextLabel", {
            Text = Player.DisplayName,
            Font = Enum.Font.GothamBlack,
            TextColor3 = Theme.Transparent,
            TextSize = 24,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 115, 0, 46),
            Size = UDim2.new(0.5, 0, 0, 28),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Banner
        })
        
        Create("TextLabel", {
            Text = "Ready to dominate the game!",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.Transparent,
            TextTransparency = 0.2,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 115, 0, 78),
            Size = UDim2.new(0.5, 0, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Banner
        })
        
        -- Stats Row
        local StatsRow = Create("Frame", {
            Name = "Stats",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 85),
            LayoutOrder = 2,
            Parent = DashPage
        })
        
        local StatsGrid = Create("UIGridLayout", {
            CellSize = UDim2.new(0.245, -8, 1, 0),
            CellPadding = UDim2.new(0, 10, 0, 0),
            Parent = StatsRow
        })
        
        local function CreateStatCard(icon, title, value, color)
            local Card = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Parent = StatsRow
            })
            Corner(Card, 10)
            
            local IconBg = Create("Frame", {
                BackgroundColor3 = color,
                BackgroundTransparency = 0.85,
                Size = UDim2.new(0, 36, 0, 36),
                Position = UDim2.new(0, 12, 0, 12),
                Parent = Card
            })
            Corner(IconBg, 8)
            
            CreateIcon(IconBg, icon, UDim2.new(0, 18, 0, 18), UDim2.new(0.5, 0, 0.5, 0), color).AnchorPoint = Vector2.new(0.5, 0.5)
            
            Create("TextLabel", {
                Text = title,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextMuted,
                TextSize = 10,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 1, -32),
                Size = UDim2.new(1, -20, 0, 12),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Card
            })
            
            local ValueLabel = Create("TextLabel", {
                Text = value,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Text,
                TextSize = 15,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 1, -18),
                Size = UDim2.new(1, -20, 0, 16),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Card
            })
            
            return ValueLabel
        end
        
        local PingValue = CreateStatCard(Icons.Wifi, "PING", "0ms", Theme.Primary)
        local FpsValue = CreateStatCard(Icons.Monitor, "FPS", "60", Theme.Success)
        local TimeValue = CreateStatCard(Icons.Clock, "TIME", "00:00", Theme.Warning)
        local PlayersValue = CreateStatCard(Icons.Users, "PLAYERS", "0", Theme.Error)
        
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
        
        -- Info Row
        local InfoRow = Create("Frame", {
            Name = "Info",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 110),
            LayoutOrder = 3,
            Parent = DashPage
        })
        
        local InfoGrid = Create("UIGridLayout", {
            CellSize = UDim2.new(0.49, -5, 1, 0),
            CellPadding = UDim2.new(0, 10, 0, 0),
            Parent = InfoRow
        })
        
        -- Library Card
        local LibCard = Create("Frame", {
            Name = "Library",
            BackgroundColor3 = Theme.Tertiary,
            Parent = InfoRow
        })
        Corner(LibCard, 10)
        
        CreateIcon(LibCard, Icons.Code, UDim2.new(0, 16, 0, 16), UDim2.new(0, 14, 0, 16), Theme.Primary)
        
        Create("TextLabel", {
            Text = "Library Info",
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.Text,
            TextSize = 13,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 36, 0, 13),
            Size = UDim2.new(1, -45, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        Create("TextLabel", {
            Text = "Version: 4.0 Premium",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextDark,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 42),
            Size = UDim2.new(1, -20, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        Create("TextLabel", {
            Text = "Status: Undetected",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.Success,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 60),
            Size = UDim2.new(1, -20, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        Create("TextLabel", {
            Text = "Updated: Today",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextMuted,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 78),
            Size = UDim2.new(1, -20, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        -- Discord Card
        local DiscCard = Create("Frame", {
            Name = "Discord",
            BackgroundColor3 = Theme.Tertiary,
            Parent = InfoRow
        })
        Corner(DiscCard, 10)
        
        CreateIcon(DiscCard, Icons.Discord, UDim2.new(0, 16, 0, 16), UDim2.new(0, 14, 0, 16), Theme.Primary)
        
        Create("TextLabel", {
            Text = "Community",
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.Text,
            TextSize = 13,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 36, 0, 13),
            Size = UDim2.new(1, -45, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DiscCard
        })
        
        Create("TextLabel", {
            Text = "Join for updates & support",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextDark,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 42),
            Size = UDim2.new(1, -20, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DiscCard
        })
        
        local CopyBtn = Create("TextButton", {
            Text = "Copy Discord Link",
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.Primary,
            TextSize = 11,
            BackgroundColor3 = Theme.Primary,
            BackgroundTransparency = 0.9,
            Position = UDim2.new(0, 14, 1, -38),
            Size = UDim2.new(1, -28, 0, 28),
            AutoButtonColor = false,
            Parent = DiscCard
        })
        Corner(CopyBtn, 6)
        
        CopyBtn.MouseEnter:Connect(function()
            Tween(CopyBtn, {BackgroundTransparency = 0.8}, 0.15)
        end)
        CopyBtn.MouseLeave:Connect(function()
            Tween(CopyBtn, {BackgroundTransparency = 0.9}, 0.15)
        end)
        CopyBtn.MouseButton1Click:Connect(function()
            Ripple(CopyBtn)
            if setclipboard then
                setclipboard("discord.gg/stellarhub")
            end
            CopyBtn.Text = "Copied!"
            task.wait(1.5)
            CopyBtn.Text = "Copy Discord Link"
        end)
        
        return DashPage
    end
    
    local DashboardPage = CreateDashboard()
    Pages["Dashboard"] = DashboardPage
    
    --[[ TAB CREATION ]]--
    local function CreateTabButton(name, icon, isHome)
        local Tab = Create("TextButton", {
            Name = name,
            BackgroundColor3 = isHome and Theme.Primary or Theme.Tertiary,
            BackgroundTransparency = isHome and 0.88 or 1,
            Size = UDim2.new(1, 0, 0, 38),
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = isHome and -999 or 0,
            Parent = TabContainer
        })
        Corner(Tab, 8)
        
        local Indicator = Create("Frame", {
            Name = "Indicator",
            BackgroundColor3 = Theme.Primary,
            Size = UDim2.new(0, 3, 0, isHome and 18 or 0),
            Position = UDim2.new(0, 0, 0.5, -9),
            Parent = Tab
        })
        Corner(Indicator, 2)
        
        local TabIcon = CreateIcon(Tab, icon, UDim2.new(0, 16, 0, 16), UDim2.new(0, 12, 0.5, 0), isHome and Theme.Primary or Theme.TextMuted)
        
        local TabLabel = Create("TextLabel", {
            Name = "Label",
            Text = name,
            Font = Enum.Font.GothamMedium,
            TextColor3 = isHome and Theme.Text or Theme.TextDark,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 36, 0, 0),
            Size = UDim2.new(1, -45, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Tab
        })
        
        return Tab, Indicator, TabIcon, TabLabel
    end
    
    local HomeTab, HomeIndicator, HomeIcon, HomeLabel = CreateTabButton("Dashboard", Icons.Home, true)
    Tabs["Dashboard"] = {Button = HomeTab, Indicator = HomeIndicator, Icon = HomeIcon, Label = HomeLabel}
    CurrentTab = HomeTab
    
    local function SwitchTab(tabName)
        -- Deactivate all
        for name, data in pairs(Tabs) do
            Tween(data.Button, {BackgroundTransparency = 1}, 0.2)
            Tween(data.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
            Tween(data.Icon, {ImageColor3 = Theme.TextMuted}, 0.2)
            Tween(data.Label, {TextColor3 = Theme.TextDark}, 0.2)
        end
        
        -- Hide all pages
        for _, page in pairs(Pages) do
            page.Visible = false
        end
        
        -- Activate selected
        local data = Tabs[tabName]
        if data then
            Tween(data.Button, {BackgroundTransparency = 0.88}, 0.2)
            Tween(data.Indicator, {Size = UDim2.new(0, 3, 0, 18)}, 0.2, Enum.EasingStyle.Back)
            Tween(data.Icon, {ImageColor3 = Theme.Primary}, 0.2)
            Tween(data.Label, {TextColor3 = Theme.Text}, 0.2)
            CurrentTab = data.Button
        end
        
        if Pages[tabName] then
            Pages[tabName].Visible = true
        end
        
        PageTitle.Text = tabName
    end
    
    HomeTab.MouseButton1Click:Connect(function()
        Ripple(HomeTab)
        SwitchTab("Dashboard")
    end)
    
    HomeTab.MouseEnter:Connect(function()
        if CurrentTab ~= HomeTab then
            Tween(HomeTab, {BackgroundTransparency = 0.92}, 0.15)
        end
    end)
    HomeTab.MouseLeave:Connect(function()
        if CurrentTab ~= HomeTab then
            Tween(HomeTab, {BackgroundTransparency = 1}, 0.15)
        end
    end)
    
    --[[ NOTIFICATION SYSTEM ]]--
    local NotifContainer = Create("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 300, 1, -20),
        Position = UDim2.new(1, -310, 0, 10),
        Parent = ScreenGui
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = NotifContainer
    })
    
    --[[ WINDOW API ]]--
    local Window = {}
    
    function Window:Notify(config)
        config = config or {}
        local Title = config.Title or "Notification"
        local Message = config.Message or ""
        local Duration = config.Duration or 3
        local Type = config.Type or "Info"
        
        local TypeData = {
            Info = {Icon = Icons.Info, Color = Theme.Primary},
            Success = {Icon = Icons.Success, Color = Theme.Success},
            Warning = {Icon = Icons.Warning, Color = Theme.Warning},
            Error = {Icon = Icons.Error, Color = Theme.Error}
        }
        
        local data = TypeData[Type] or TypeData.Info
        
        local Notif = Create("Frame", {
            BackgroundColor3 = Theme.Tertiary,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true,
            Parent = NotifContainer
        })
        Corner(Notif, 8)
        
        -- Color bar
        Create("Frame", {
            BackgroundColor3 = data.Color,
            Size = UDim2.new(0, 3, 1, 0),
            Parent = Notif
        })
        
        CreateIcon(Notif, data.Icon, UDim2.new(0, 16, 0, 16), UDim2.new(0, 16, 0, 17), data.Color)
        
        Create("TextLabel", {
            Text = Title,
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.Text,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 40, 0, 12),
            Size = UDim2.new(1, -50, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Notif
        })
        
        Create("TextLabel", {
            Text = Message,
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextDark,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 40, 0, 30),
            Size = UDim2.new(1, -50, 0, 28),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = Notif
        })
        
        -- Animate in
        Tween(Notif, {Size = UDim2.new(1, 0, 0, 65)}, 0.3, Enum.EasingStyle.Back)
        
        task.delay(Duration, function()
            Tween(Notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
            task.wait(0.25)
            Notif:Destroy()
        end)
    end
    
    function Window:Tab(name, icon)
        icon = icon or Icons.Folder
        
        local TabBtn, TabIndicator, TabIconImg, TabLabelText = CreateTabButton(name, icon, false)
        Tabs[name] = {Button = TabBtn, Indicator = TabIndicator, Icon = TabIconImg, Label = TabLabelText}
        
        -- Create Page
        local Page = Create("ScrollingFrame", {
            Name = name,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Primary,
            ScrollBarImageTransparency = 0.5,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = PageContainer
        })
        Padding(Page, 10, 20, 20, 20)
        
        local PageLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = Page
        })
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 40)
        end)
        
        Pages[name] = Page
        
        TabBtn.MouseButton1Click:Connect(function()
            Ripple(TabBtn)
            SwitchTab(name)
        end)
        
        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= TabBtn then
                Tween(TabBtn, {BackgroundTransparency = 0.92}, 0.15)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= TabBtn then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        --[[ TAB API ]]--
        local Tab = {}
        
        function Tab:Section(text)
            local Section = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                Parent = Page
            })
            
            Create("TextLabel", {
                Text = string.upper(text),
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Primary,
                TextSize = 10,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 1, -16),
                Size = UDim2.new(0, 100, 0, 14),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section
            })
            
            Create("Frame", {
                BackgroundColor3 = Theme.Divider,
                Size = UDim2.new(1, -110, 0, 1),
                Position = UDim2.new(0, 105, 1, -9),
                Parent = Section
            })
        end
        
        function Tab:Button(config)
            config = config or {}
            local Name = config.Name or "Button"
            local Callback = config.Callback or function() end
            
            local Button = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 42),
                Text = "",
                AutoButtonColor = false,
                Parent = Page
            })
            Corner(Button, 8)
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button
            })
            
            local Arrow = CreateIcon(Button, Icons.Arrow, UDim2.new(0, 14, 0, 14), UDim2.new(1, -30, 0.5, 0), Theme.Primary)
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Elevated}, 0.15)
                Tween(Arrow, {Position = UDim2.new(1, -25, 0.5, 0)}, 0.15)
            end)
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Tertiary}, 0.15)
                Tween(Arrow, {Position = UDim2.new(1, -30, 0.5, 0)}, 0.15)
            end)
            Button.MouseButton1Click:Connect(function()
                Ripple(Button)
                pcall(Callback)
            end)
            
            return Button
        end
        
        function Tab:Toggle(config)
            config = config or {}
            local Name = config.Name or "Toggle"
            local Default = config.Default or false
            local Callback = config.Callback or function() end
            
            local Toggled = Default
            
            local ToggleFrame = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 42),
                Text = "",
                AutoButtonColor = false,
                Parent = Page
            })
            Corner(ToggleFrame, 8)
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            local SwitchBg = Create("Frame", {
                BackgroundColor3 = Toggled and Theme.Primary or Theme.Elevated,
                Size = UDim2.new(0, 40, 0, 22),
                Position = UDim2.new(1, -52, 0.5, -11),
                Parent = ToggleFrame
            })
            Corner(SwitchBg, 11)
            
            local SwitchDot = Create("Frame", {
                BackgroundColor3 = Theme.Text,
                Size = UDim2.new(0, 16, 0, 16),
                Position = Toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                Parent = SwitchBg
            })
            Corner(SwitchDot, 8)
            
            local function Update()
                if Toggled then
                    Tween(SwitchBg, {BackgroundColor3 = Theme.Primary}, 0.2)
                    Tween(SwitchDot, {Position = UDim2.new(1, -19, 0.5, -8)}, 0.2, Enum.EasingStyle.Back)
                else
                    Tween(SwitchBg, {BackgroundColor3 = Theme.Elevated}, 0.2)
                    Tween(SwitchDot, {Position = UDim2.new(0, 3, 0.5, -8)}, 0.2, Enum.EasingStyle.Back)
                end
                pcall(Callback, Toggled)
            end
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Theme.Elevated}, 0.15)
            end)
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Theme.Tertiary}, 0.15)
            end)
            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Update()
            end)
            
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
        
        function Tab:Slider(config)
            config = config or {}
            local Name = config.Name or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or Min
            local Callback = config.Callback or function() end
            
            local Value = Default
            
            local SliderFrame = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 55),
                Parent = Page
            })
            Corner(SliderFrame, 8)
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 10),
                Size = UDim2.new(1, -70, 0, 16),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            local ValueLabel = Create("TextLabel", {
                Text = tostring(Value),
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Primary,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -50, 0, 10),
                Size = UDim2.new(0, 36, 0, 16),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame
            })
            
            local SliderBar = Create("TextButton", {
                BackgroundColor3 = Theme.Elevated,
                Size = UDim2.new(1, -28, 0, 6),
                Position = UDim2.new(0, 14, 0, 36),
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
                
                Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.05)
                Tween(Knob, {Position = UDim2.new(percent, -7, 0.5, -7)}, 0.05)
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
                Set = function(_, value)
                    Value = math.clamp(value, Min, Max)
                    local percent = (Value - Min) / (Max - Min)
                    Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.2)
                    Tween(Knob, {Position = UDim2.new(percent, -7, 0.5, -7)}, 0.2)
                    ValueLabel.Text = tostring(Value)
                    pcall(Callback, Value)
                end,
                Get = function()
                    return Value
                end
            }
        end
        
        function Tab:Dropdown(config)
            config = config or {}
            local Name = config.Name or "Dropdown"
            local Options = config.Options or {}
            local Default = config.Default or Options[1]
            local Callback = config.Callback or function() end
            
            local Selected = Default
            local Open = false
            
            local DropFrame = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 42),
                ClipsDescendants = true,
                Parent = Page
            })
            Corner(DropFrame, 8)
            
            local DropBtn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 42),
                Text = "",
                Parent = DropFrame
            })
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.5, 0, 0, 42),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropBtn
            })
            
            local SelectedLabel = Create("TextLabel", {
                Text = Selected or "Select...",
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextDark,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, -40, 0, 42),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = DropBtn
            })
            
            local ArrowIcon = CreateIcon(DropBtn, Icons.ArrowDown, UDim2.new(0, 12, 0, 12), UDim2.new(1, -26, 0.5, 0), Theme.TextMuted)
            
            local OptionsFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 48),
                Size = UDim2.new(1, 0, 0, #Options * 32 + 8),
                Parent = DropFrame
            })
            Padding(OptionsFrame, 4, 8, 8, 4)
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                Parent = OptionsFrame
            })
            
            for _, option in ipairs(Options) do
                local OptionBtn = Create("TextButton", {
                    BackgroundColor3 = Theme.Elevated,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    Text = option,
                    Font = Enum.Font.Gotham,
                    TextColor3 = Theme.TextDark,
                    TextSize = 12,
                    AutoButtonColor = false,
                    Parent = OptionsFrame
                })
                Corner(OptionBtn, 6)
                
                OptionBtn.MouseEnter:Connect(function()
                    Tween(OptionBtn, {BackgroundTransparency = 0.5, TextColor3 = Theme.Text}, 0.1)
                end)
                OptionBtn.MouseLeave:Connect(function()
                    Tween(OptionBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDark}, 0.1)
                end)
                OptionBtn.MouseButton1Click:Connect(function()
                    Selected = option
                    SelectedLabel.Text = option
                    Open = false
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 42)}, 0.2)
                    Tween(ArrowIcon, {Rotation = 0}, 0.2)
                    pcall(Callback, option)
                end)
            end
            
            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local targetHeight = Open and (52 + #Options * 32 + 8) or 42
                Tween(DropFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25)
                Tween(ArrowIcon, {Rotation = Open and 180 or 0}, 0.25)
            end)
            
            return {
                Set = function(_, option)
                    Selected = option
                    SelectedLabel.Text = option
                    pcall(Callback, option)
                end,
                Get = function()
                    return Selected
                end,
                Refresh = function(_, newOptions)
                    Options = newOptions
                    for _, child in pairs(OptionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    for _, option in ipairs(Options) do
                        local OptionBtn = Create("TextButton", {
                            BackgroundColor3 = Theme.Elevated,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 30),
                            Text = option,
                            Font = Enum.Font.Gotham,
                            TextColor3 = Theme.TextDark,
                            TextSize = 12,
                            AutoButtonColor = false,
                            Parent = OptionsFrame
                        })
                        Corner(OptionBtn, 6)
                        
                        OptionBtn.MouseEnter:Connect(function()
                            Tween(OptionBtn, {BackgroundTransparency = 0.5, TextColor3 = Theme.Text}, 0.1)
                        end)
                        OptionBtn.MouseLeave:Connect(function()
                            Tween(OptionBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDark}, 0.1)
                        end)
                        OptionBtn.MouseButton1Click:Connect(function()
                            Selected = option
                            SelectedLabel.Text = option
                            Open = false
                            Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 42)}, 0.2)
                            Tween(ArrowIcon, {Rotation = 0}, 0.2)
                            pcall(Callback, option)
                        end)
                    end
                    OptionsFrame.Size = UDim2.new(1, 0, 0, #Options * 32 + 8)
                end
            }
        end
        
        function Tab:Input(config)
            config = config or {}
            local Name = config.Name or "Input"
            local Placeholder = config.Placeholder or "Enter text..."
            local Callback = config.Callback or function() end
            
            local InputFrame = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 42),
                Parent = Page
            })
            Corner(InputFrame, 8)
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.4, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = InputFrame
            })
            
            local InputBox = Create("TextBox", {
                BackgroundColor3 = Theme.Elevated,
                Size = UDim2.new(0.55, -20, 0, 28),
                Position = UDim2.new(0.45, 0, 0.5, -14),
                Text = "",
                PlaceholderText = Placeholder,
                PlaceholderColor3 = Theme.TextMuted,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.Text,
                TextSize = 12,
                ClearTextOnFocus = false,
                Parent = InputFrame
            })
            Corner(InputBox, 6)
            Padding(InputBox, 0, 10, 10, 0)
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundColor3 = Theme.Hover}, 0.15)
            end)
            InputBox.FocusLost:Connect(function(enter)
                Tween(InputBox, {BackgroundColor3 = Theme.Elevated}, 0.15)
                if enter then
                    pcall(Callback, InputBox.Text)
                end
            end)
            
            return {
                Set = function(_, text)
                    InputBox.Text = text
                end,
                Get = function()
                    return InputBox.Text
                end
            }
        end
        
        function Tab:Keybind(config)
            config = config or {}
            local Name = config.Name or "Keybind"
            local Default = config.Default or Enum.KeyCode.E
            local Callback = config.Callback or function() end
            
            local CurrentKey = Default
            local Listening = false
            
            local KeybindFrame = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 42),
                Text = "",
                AutoButtonColor = false,
                Parent = Page
            })
            Corner(KeybindFrame, 8)
            
            Create("TextLabel", {
                Text = Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -100, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KeybindFrame
            })
            
            local KeyLabel = Create("TextLabel", {
                Text = CurrentKey.Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Primary,
                TextSize = 11,
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.9,
                Position = UDim2.new(1, -75, 0.5, -12),
                Size = UDim2.new(0, 60, 0, 24),
                Parent = KeybindFrame
            })
            Corner(KeyLabel, 6)
            
            KeybindFrame.MouseEnter:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = Theme.Elevated}, 0.15)
            end)
            KeybindFrame.MouseLeave:Connect(function()
                Tween(KeybindFrame, {BackgroundColor3 = Theme.Tertiary}, 0.15)
            end)
            
            KeybindFrame.MouseButton1Click:Connect(function()
                Listening = true
                KeyLabel.Text = "..."
                Tween(KeyLabel, {BackgroundTransparency = 0.7}, 0.15)
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if Listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = input.KeyCode
                        KeyLabel.Text = CurrentKey.Name
                        Tween(KeyLabel, {BackgroundTransparency = 0.9}, 0.15)
                        Listening = false
                    end
                elseif not processed and input.KeyCode == CurrentKey then
                    pcall(Callback)
                end
            end)
            
            return {
                Set = function(_, key)
                    CurrentKey = key
                    KeyLabel.Text = key.Name
                end,
                Get = function()
                    return CurrentKey
                end
            }
        end
        
        function Tab:Paragraph(config)
            config = config or {}
            local Title = config.Title or "Paragraph"
            local Content = config.Content or ""
            
            local Para = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = Page
            })
            Corner(Para, 8)
            Padding(Para, 14, 14, 14, 14)
            
            local ParaLayout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = Para
            })
            
            Create("TextLabel", {
                Text = Title,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 1,
                Parent = Para
            })
            
            Create("TextLabel", {
                Text = Content,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextDark,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                LayoutOrder = 2,
                Parent = Para
            })
        end
        
        function Tab:Label(text)
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextDark,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Page
            })
        end
        
        function Tab:Divider()
            local Div = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 12),
                Parent = Page
            })
            
            Create("Frame", {
                BackgroundColor3 = Theme.Divider,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 0.5, 0),
                Parent = Div
            })
        end
        
        return Tab
    end
    
    return Window
end

return Stellar
