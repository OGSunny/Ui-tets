--[[
    ███████╗████████╗███████╗██╗     ██╗      █████╗ ██████╗ 
    ██╔════╝╚══██╔══╝██╔════╝██║     ██║     ██╔══██╗██╔══██╗
    ███████╗   ██║   █████╗  ██║     ██║     ███████║██████╔╝
    ╚════██║   ██║   ██╔══╝  ██║     ██║     ██╔══██║██╔══██╗
    ███████║   ██║   ███████╗███████╗███████╗██║  ██║██║  ██║
    ╚══════╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
]]

local Stellar = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer

local Icons = {
    Home = "rbxassetid://3926305904",
    Settings = "rbxassetid://3926307971",
    Combat = "rbxassetid://3926305904",
    Eye = "rbxassetid://3926305904",
    Misc = "rbxassetid://3926307971",
    Star = "rbxassetid://3926307971",
    Check = "rbxassetid://3926305904",
    Close = "rbxassetid://3926305904",
    Minimize = "rbxassetid://3926305904",
    Arrow = "rbxassetid://3926305904",
    ArrowDown = "rbxassetid://3926305904",
    Folder = "rbxassetid://3926307971",
    Clock = "rbxassetid://3926305904",
    Users = "rbxassetid://3926307971",
    Wifi = "rbxassetid://3926307971",
    Monitor = "rbxassetid://3926305904",
    Info = "rbxassetid://3926307971",
    Warning = "rbxassetid://3926305904",
    Error = "rbxassetid://3926305904",
    Success = "rbxassetid://3926305904",
    Code = "rbxassetid://3926307971",
    Discord = "rbxassetid://3926307971",
    Crown = "rbxassetid://3926307971",
    Search = "rbxassetid://3926305904"
}

local IconRects = {
    Home = Rect.new(188, 724, 232, 768),
    Settings = Rect.new(324, 124, 368, 168),
    Combat = Rect.new(804, 124, 848, 168),
    Eye = Rect.new(564, 4, 608, 48),
    Misc = Rect.new(804, 844, 848, 888),
    Star = Rect.new(44, 284, 88, 328),
    Check = Rect.new(644, 204, 688, 248),
    Close = Rect.new(284, 4, 328, 48),
    Minimize = Rect.new(124, 724, 168, 768),
    Arrow = Rect.new(764, 244, 808, 288),
    ArrowDown = Rect.new(124, 524, 168, 568),
    Folder = Rect.new(684, 844, 728, 888),
    Clock = Rect.new(684, 164, 728, 208),
    Users = Rect.new(404, 204, 448, 248),
    Wifi = Rect.new(124, 204, 168, 248),
    Monitor = Rect.new(84, 4, 128, 48),
    Info = Rect.new(764, 844, 808, 888),
    Warning = Rect.new(564, 364, 608, 408),
    Error = Rect.new(924, 724, 968, 768),
    Success = Rect.new(644, 204, 688, 248),
    Code = Rect.new(964, 724, 1008, 768),
    Discord = Rect.new(124, 44, 168, 88),
    Crown = Rect.new(564, 284, 608, 328),
    Search = Rect.new(924, 284, 968, 328)
}

local Theme = {
    Background = Color3.fromRGB(14, 18, 30),
    Secondary = Color3.fromRGB(20, 26, 42),
    Tertiary = Color3.fromRGB(28, 36, 58),
    Elevated = Color3.fromRGB(38, 48, 75),
    Hover = Color3.fromRGB(48, 60, 92),
    Active = Color3.fromRGB(55, 70, 105),
    
    Primary = Color3.fromRGB(70, 180, 255),
    PrimaryDark = Color3.fromRGB(55, 155, 235),
    PrimaryLight = Color3.fromRGB(110, 200, 255),
    
    Text = Color3.fromRGB(250, 252, 255),
    TextDark = Color3.fromRGB(180, 190, 210),
    TextMuted = Color3.fromRGB(115, 130, 160),
    
    Success = Color3.fromRGB(55, 220, 150),
    Warning = Color3.fromRGB(255, 195, 60),
    Error = Color3.fromRGB(255, 100, 110),
    
    Divider = Color3.fromRGB(55, 68, 100)
}

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
    return Create("UIPadding", {PaddingTop = UDim.new(0, t or 0), PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0), PaddingBottom = UDim.new(0, b or 0), Parent = parent})
end

local function CreateIcon(parent, iconName, size, pos, color)
    return Create("ImageLabel", {
        Image = Icons[iconName] or Icons.Folder,
        ImageRectOffset = IconRects[iconName] and IconRects[iconName].Min or Vector2.new(684, 844),
        ImageRectSize = Vector2.new(44, 44),
        ImageColor3 = color or Theme.TextDark,
        BackgroundTransparency = 1,
        Size = size or UDim2.new(0, 18, 0, 18),
        Position = pos or UDim2.new(0, 0, 0.5, -9),
        AnchorPoint = Vector2.new(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = parent
    })
end

local function CreateCustomIcon(parent, imageId, size, pos, color)
    return Create("ImageLabel", {
        Image = imageId,
        ImageColor3 = color or Theme.Text,
        BackgroundTransparency = 1,
        Size = size or UDim2.new(0, 18, 0, 18),
        Position = pos or UDim2.new(0, 0, 0.5, -9),
        AnchorPoint = Vector2.new(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = parent
    })
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

function Stellar:CreateWindow(config)
    config = config or {}
    local WindowTitle = config.Title or "Stellar Hub"
    local WindowSubtitle = config.Subtitle or "v5.1"
    local WindowLogo = config.Logo or "rbxassetid://18824089198"
    local WindowSize = config.Size or UDim2.new(0, 920, 0, 560)
    local ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    
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
    local AllTabButtons = {}
    
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
    
    Tween(MainFrame, {Size = WindowSize}, 0.45, Enum.EasingStyle.Back)
    
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 55, 1, 55),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Parent = MainFrame
    })
    
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(0, 210, 1, 0),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    Corner(Sidebar, 12)
    
    Create("Frame", {
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(0, 14, 1, 0),
        Position = UDim2.new(1, -14, 0, 0),
        BorderSizePixel = 0,
        Parent = Sidebar
    })
    
    Create("Frame", {
        BackgroundColor3 = Theme.Divider,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 1, 1, -28),
        Position = UDim2.new(1, 0, 0, 14),
        BorderSizePixel = 0,
        Parent = Sidebar
    })
    
    local Header = Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 70),
        Parent = Sidebar
    })
    MakeDraggable(Header, MainFrame)
    
    local LogoContainer = Create("Frame", {
        Name = "Logo",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(0, 42, 0, 42),
        Position = UDim2.new(0, 16, 0, 14),
        Parent = Header
    })
    Corner(LogoContainer, 10)
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 90, 255))
        }),
        Rotation = 45,
        Parent = LogoContainer
    })
    
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
    
    Create("TextLabel", {
        Text = WindowTitle,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.Text,
        TextSize = 15,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 68, 0, 17),
        Size = UDim2.new(1, -76, 0, 17),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    Create("TextLabel", {
        Text = WindowSubtitle,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 68, 0, 36),
        Size = UDim2.new(1, -76, 0, 13),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    local SearchContainer = Create("Frame", {
        Name = "Search",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, -28, 0, 34),
        Position = UDim2.new(0, 14, 0, 72),
        Parent = Sidebar
    })
    Corner(SearchContainer, 8)
    
    CreateIcon(SearchContainer, "Search", UDim2.new(0, 14, 0, 14), UDim2.new(0, 10, 0.5, 0), Theme.TextMuted)
    
    local SearchBox = Create("TextBox", {
        Name = "SearchInput",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -36, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Theme.TextMuted,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = SearchContainer
    })
    
    Create("TextLabel", {
        Text = "NAVIGATION",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMuted,
        TextSize = 9,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 116),
        Size = UDim2.new(1, -32, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Sidebar
    })
    
    local TabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -185),
        Position = UDim2.new(0, 0, 0, 134),
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
    Padding(TabContainer, 0, 12, 12, 10)
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 18)
    end)
    
    local UserContainer = Create("Frame", {
        Name = "User",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(1, -24, 0, 44),
        Position = UDim2.new(0, 12, 1, -56),
        Parent = Sidebar
    })
    Corner(UserContainer, 8)
    
    local UserAvatar = Create("ImageLabel", {
        Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100),
        BackgroundColor3 = Theme.Elevated,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 6, 0.5, -16),
        Parent = UserContainer
    })
    Corner(UserAvatar, 16)
    
    Create("TextLabel", {
        Text = Player.DisplayName,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Theme.Text,
        TextSize = 12,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 44, 0, 7),
        Size = UDim2.new(1, -52, 0, 14),
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
        Position = UDim2.new(0, 44, 0, 23),
        Size = UDim2.new(1, -52, 0, 12),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = UserContainer
    })
    
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -210, 1, 0),
        Position = UDim2.new(0, 210, 0, 0),
        Parent = MainFrame
    })
    
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
        Position = UDim2.new(0, 22, 0, 16),
        Size = UDim2.new(0.5, 0, 0, 24),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    local Controls = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 72, 0, 30),
        Position = UDim2.new(1, -90, 0, 12),
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
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    Corner(MinBtn, 8)
    
    Create("Frame", {
        BackgroundColor3 = Theme.TextDark,
        Size = UDim2.new(0, 12, 0, 2),
        Position = UDim2.new(0.5, -6, 0.5, -1),
        BorderSizePixel = 0,
        Parent = MinBtn
    })
    
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Theme.Tertiary,
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    Corner(CloseBtn, 8)
    
    Create("TextLabel", {
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextDark,
        TextSize = 20,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -2),
        Parent = CloseBtn
    })
    
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, {BackgroundColor3 = Theme.Elevated}, 0.12)
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, {BackgroundColor3 = Theme.Tertiary}, 0.12)
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.Error}, 0.12)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.Tertiary}, 0.12)
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(Shadow, {ImageTransparency = 1}, 0.25)
        task.wait(0.25)
        ScreenGui:Destroy()
    end)
    
    local PageContainer = Create("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -55),
        Position = UDim2.new(0, 0, 0, 55),
        ClipsDescendants = true,
        Parent = Content
    })
    
    local ToggleBtn = Create("TextButton", {
        Name = "Toggle",
        BackgroundColor3 = Theme.Primary,
        Size = UDim2.new(0, 54, 0, 54),
        Position = UDim2.new(0, 22, 0.5, -50),
        Text = "",
        AutoButtonColor = false,
        Visible = false,
        Parent = ScreenGui
    })
    Corner(ToggleBtn, 14)
    
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 90, 255))
        }),
        Rotation = 45,
        Parent = ToggleBtn
    })
    
    local ToggleShadow = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(80, 100, 200),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Parent = ToggleBtn
    })
    
    local ToggleIcon = Create("ImageLabel", {
        Image = WindowLogo,
        ImageColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = ToggleBtn
    })
    
    ToggleBtn.MouseEnter:Connect(function()
        Tween(ToggleBtn, {Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0, 19, 0.5, -53)}, 0.15, Enum.EasingStyle.Back)
    end)
    ToggleBtn.MouseLeave:Connect(function()
        Tween(ToggleBtn, {Size = UDim2.new(0, 54, 0, 54), Position = UDim2.new(0, 22, 0.5, -50)}, 0.12)
    end)
    
    local function Minimize()
        Minimized = true
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(Shadow, {ImageTransparency = 1}, 0.25)
        task.wait(0.22)
        MainFrame.Visible = false
        ToggleBtn.Visible = true
        ToggleBtn.Size = UDim2.new(0, 0, 0, 0)
        Tween(ToggleBtn, {Size = UDim2.new(0, 54, 0, 54)}, 0.28, Enum.EasingStyle.Back)
    end
    
    local function Maximize()
        Minimized = false
        ToggleBtn.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Tween(MainFrame, {Size = WindowSize}, 0.35, Enum.EasingStyle.Back)
        Tween(Shadow, {ImageTransparency = 0.5}, 0.35)
    end
    
    MinBtn.MouseButton1Click:Connect(function()
        Minimize()
    end)
    
    ToggleBtn.MouseButton1Click:Connect(function()
        Maximize()
    end)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == ToggleKey then
            if Minimized then
                Maximize()
            else
                Minimize()
            end
        end
    end)
    
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = string.lower(SearchBox.Text)
        for _, tabData in pairs(AllTabButtons) do
            local tabName = string.lower(tabData.Name)
            if searchText == "" or string.find(tabName, searchText) then
                tabData.Button.Visible = true
            else
                tabData.Button.Visible = false
            end
        end
    end)
    
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
        Padding(DashPage, 10, 22, 22, 22)
        
        local DashLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 14),
            Parent = DashPage
        })
        
        DashLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            DashPage.CanvasSize = UDim2.new(0, 0, 0, DashLayout.AbsoluteContentSize.Y + 40)
        end)
        
        local Banner = Create("Frame", {
            Name = "Banner",
            BackgroundColor3 = Theme.Primary,
            Size = UDim2.new(1, 0, 0, 130),
            LayoutOrder = 1,
            Parent = DashPage
        })
        Corner(Banner, 12)
        
        Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 140, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(105, 105, 245)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 80, 235))
            }),
            Rotation = 15,
            Parent = Banner
        })
        
        local Circle1 = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.92,
            Size = UDim2.new(0, 200, 0, 200),
            Position = UDim2.new(1, -60, 0, -60),
            Parent = Banner
        })
        Corner(Circle1, 100)
        
        local Circle2 = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.95,
            Size = UDim2.new(0, 130, 0, 130),
            Position = UDim2.new(1, -160, 0, 50),
            Parent = Banner
        })
        Corner(Circle2, 65)
        
        local BannerAvatar = Create("ImageLabel", {
            Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150),
            BackgroundColor3 = Theme.Background,
            Size = UDim2.new(0, 90, 0, 90),
            Position = UDim2.new(0, 22, 0.5, -45),
            Parent = Banner
        })
        Corner(BannerAvatar, 45)
        
        Create("TextLabel", {
            Text = "Welcome back,",
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextTransparency = 0.2,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 128, 0, 30),
            Size = UDim2.new(0.5, 0, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Banner
        })
        
        Create("TextLabel", {
            Text = Player.DisplayName,
            Font = Enum.Font.GothamBlack,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 26,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 128, 0, 48),
            Size = UDim2.new(0.5, 0, 0, 30),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Banner
        })
        
        Create("TextLabel", {
            Text = "Ready to dominate!",
            Font = Enum.Font.GothamMedium,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextTransparency = 0.15,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 128, 0, 84),
            Size = UDim2.new(0.5, 0, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Banner
        })
        
        local StatsRow = Create("Frame", {
            Name = "Stats",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 90),
            LayoutOrder = 2,
            Parent = DashPage
        })
        
        Create("UIGridLayout", {
            CellSize = UDim2.new(0.245, -8, 1, 0),
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
                Size = UDim2.new(0, 38, 0, 38),
                Position = UDim2.new(0, 12, 0, 12),
                Parent = Card
            })
            Corner(IconBg, 10)
            
            local Icon = CreateIcon(Card, iconName, UDim2.new(0, 18, 0, 18), UDim2.new(0, 22, 0, 22), color)
            Icon.AnchorPoint = Vector2.new(0, 0)
            
            Create("TextLabel", {
                Text = title,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.TextMuted,
                TextSize = 10,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 1, -35),
                Size = UDim2.new(1, -20, 0, 12),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Card
            })
            
            local ValueLabel = Create("TextLabel", {
                Text = value,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Text,
                TextSize = 16,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 1, -20),
                Size = UDim2.new(1, -20, 0, 16),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Card
            })
            
            return ValueLabel
        end
        
        local PingValue = CreateStatCard("Wifi", "PING", "0ms", Theme.Primary)
        local FpsValue = CreateStatCard("Monitor", "FPS", "60", Theme.Success)
        local TimeValue = CreateStatCard("Clock", "TIME", "00:00", Theme.Warning)
        local PlayersValue = CreateStatCard("Users", "PLAYERS", "0", Theme.Error)
        
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
        
        local InfoRow = Create("Frame", {
            Name = "Info",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 115),
            LayoutOrder = 3,
            Parent = DashPage
        })
        
        Create("UIGridLayout", {
            CellSize = UDim2.new(0.49, -6, 1, 0),
            CellPadding = UDim2.new(0, 12, 0, 0),
            Parent = InfoRow
        })
        
        local LibCard = Create("Frame", {
            Name = "Library",
            BackgroundColor3 = Theme.Tertiary,
            Parent = InfoRow
        })
        Corner(LibCard, 10)
        
        CreateIcon(LibCard, "Code", UDim2.new(0, 16, 0, 16), UDim2.new(0, 14, 0, 16), Theme.Primary)
        
        Create("TextLabel", {
            Text = "Library Info",
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.Text,
            TextSize = 13,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 36, 0, 14),
            Size = UDim2.new(1, -44, 0, 15),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        Create("TextLabel", {
            Text = "Version 5.1",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextDark,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 40),
            Size = UDim2.new(1, -20, 0, 13),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        Create("TextLabel", {
            Text = "Undetected",
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.Success,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 58),
            Size = UDim2.new(1, -20, 0, 13),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        Create("TextLabel", {
            Text = "Updated Today",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextMuted,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 76),
            Size = UDim2.new(1, -20, 0, 13),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = LibCard
        })
        
        local DiscCard = Create("Frame", {
            Name = "Discord",
            BackgroundColor3 = Theme.Tertiary,
            Parent = InfoRow
        })
        Corner(DiscCard, 10)
        
        CreateIcon(DiscCard, "Discord", UDim2.new(0, 16, 0, 16), UDim2.new(0, 14, 0, 16), Theme.Primary)
        
        Create("TextLabel", {
            Text = "Community",
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.Text,
            TextSize = 13,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 36, 0, 14),
            Size = UDim2.new(1, -44, 0, 15),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DiscCard
        })
        
        Create("TextLabel", {
            Text = "Join for updates & support",
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextDark,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 40),
            Size = UDim2.new(1, -20, 0, 13),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DiscCard
        })
        
        local CopyBtn = Create("TextButton", {
            Text = "Copy Invite Link",
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.Primary,
            TextSize = 11,
            BackgroundColor3 = Theme.Primary,
            BackgroundTransparency = 0.9,
            Position = UDim2.new(0, 14, 1, -40),
            Size = UDim2.new(1, -28, 0, 28),
            AutoButtonColor = false,
            Parent = DiscCard
        })
        Corner(CopyBtn, 7)
        
        CopyBtn.MouseEnter:Connect(function()
            Tween(CopyBtn, {BackgroundTransparency = 0.8}, 0.1)
        end)
        CopyBtn.MouseLeave:Connect(function()
            Tween(CopyBtn, {BackgroundTransparency = 0.9}, 0.1)
        end)
        CopyBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard("discord.gg/stellarhub")
            end
            CopyBtn.Text = "Copied!"
            task.wait(1.2)
            CopyBtn.Text = "Copy Invite Link"
        end)
        
        return DashPage
    end
    
    local DashboardPage = CreateDashboard()
    Pages["Dashboard"] = DashboardPage
    
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
        
        local TabIcon
        if type(icon) == "string" and icon:find("rbxassetid") then
            TabIcon = CreateCustomIcon(Tab, icon, UDim2.new(0, 17, 0, 17), UDim2.new(0, 12, 0.5, 0), isHome and Theme.Primary or Theme.TextMuted)
        else
            TabIcon = CreateIcon(Tab, icon or "Folder", UDim2.new(0, 17, 0, 17), UDim2.new(0, 12, 0.5, 0), isHome and Theme.Primary or Theme.TextMuted)
        end
        
        local TabLabel = Create("TextLabel", {
            Name = "Label",
            Text = name,
            Font = Enum.Font.GothamMedium,
            TextColor3 = isHome and Theme.Text or Theme.TextDark,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 38, 0, 0),
            Size = UDim2.new(1, -46, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Tab
        })
        
        table.insert(AllTabButtons, {Name = name, Button = Tab})
        
        return Tab, Indicator, TabIcon, TabLabel
    end
    
    local HomeTab, HomeIndicator, HomeIcon, HomeLabel = CreateTabButton("Dashboard", "Home", true)
    Tabs["Dashboard"] = {Button = HomeTab, Indicator = HomeIndicator, Icon = HomeIcon, Label = HomeLabel}
    CurrentTab = HomeTab
    
    local function SwitchTab(tabName)
        for _, data in pairs(Tabs) do
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
    
    local NotifContainer = Create("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 300, 1, -24),
        Position = UDim2.new(1, -312, 0, 12),
        Parent = ScreenGui
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = NotifContainer
    })
    
    local Window = {}
    
    function Window:SetLogo(imageId)
        LogoIcon.Image = imageId
        ToggleIcon.Image = imageId
    end
    
    function Window:Notify(config)
        config = config or {}
        local Title = config.Title or "Notification"
        local Message = config.Message or ""
        local Duration = config.Duration or 3
        local Type = config.Type or "Info"
        
        local TypeData = {
            Info = Theme.Primary,
            Success = Theme.Success,
            Warning = Theme.Warning,
            Error = Theme.Error
        }
        
        local color = TypeData[Type] or TypeData.Info
        
        local Notif = Create("Frame", {
            BackgroundColor3 = Theme.Tertiary,
            Size = UDim2.new(1, 0, 0, 0),
            ClipsDescendants = true,
            Parent = NotifContainer
        })
        Corner(Notif, 10)
        
        Create("Frame", {
            BackgroundColor3 = color,
            Size = UDim2.new(0, 4, 1, 0),
            BorderSizePixel = 0,
            Parent = Notif
        })
        
        Create("TextLabel", {
            Text = Title,
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.Text,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 16, 0, 12),
            Size = UDim2.new(1, -24, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Notif
        })
        
        Create("TextLabel", {
            Text = Message,
            Font = Enum.Font.Gotham,
            TextColor3 = Theme.TextDark,
            TextSize = 11,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 16, 0, 30),
            Size = UDim2.new(1, -24, 0, 28),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = Notif
        })
        
        Tween(Notif, {Size = UDim2.new(1, 0, 0, 66)}, 0.25, Enum.EasingStyle.Back)
        
        task.delay(Duration, function()
            Tween(Notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            task.wait(0.2)
            Notif:Destroy()
        end)
    end
    
    function Window:Tab(name, icon)
        icon = icon or "Folder"
        
        local TabBtn, TabIndicator, TabIconImg, TabLabelText = CreateTabButton(name, icon, false)
        Tabs[name] = {Button = TabBtn, Indicator = TabIndicator, Icon = TabIconImg, Label = TabLabelText}
        
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
        Padding(Page, 10, 22, 22, 22)
        
        local PageLayout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 7),
            Parent = Page
        })
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 40)
        end)
        
        Pages[name] = Page
        
        TabBtn.MouseButton1Click:Connect(function()
            SwitchTab(name)
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
        
        local Tab = {}
        
        function Tab:Section(text)
            local Section = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 26),
                Parent = Page
            })
            
            local SectionLabel = Create("TextLabel", {
                Text = string.upper(text),
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Primary,
                TextSize = 10,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, -6),
                Size = UDim2.new(0, 0, 0, 12),
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.X,
                Parent = Section
            })
            
            local Line = Create("Frame", {
                BackgroundColor3 = Theme.Divider,
                BackgroundTransparency = 0.35,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 0.5, 0),
                BorderSizePixel = 0,
                Parent = Section
            })
            
            task.defer(function()
                Line.Position = UDim2.new(0, SectionLabel.AbsoluteSize.X + 12, 0.5, 0)
                Line.Size = UDim2.new(1, -(SectionLabel.AbsoluteSize.X + 12), 0, 1)
            end)
        end
        
        function Tab:Button(config)
            config = config or {}
            local Name = config.Name or "Button"
            local Callback = config.Callback or function() end
            
            local Button = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 40),
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
            
            local Arrow = Create("TextLabel", {
                Text = "›",
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Primary,
                TextSize = 20,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -28, 0, -1),
                Size = UDim2.new(0, 18, 1, 0),
                Parent = Button
            })
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Elevated}, 0.1)
                Tween(Arrow, {Position = UDim2.new(1, -24, 0, -1)}, 0.1)
            end)
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Tertiary}, 0.1)
                Tween(Arrow, {Position = UDim2.new(1, -28, 0, -1)}, 0.1)
            end)
            Button.MouseButton1Click:Connect(function()
                pcall(Callback)
            end)
        end
        
        function Tab:Toggle(config)
            config = config or {}
            local Name = config.Name or "Toggle"
            local Default = config.Default or false
            local Callback = config.Callback or function() end
            
            local Toggled = Default
            
            local ToggleFrame = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 40),
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
                Size = UDim2.new(1, -65, 1, 0),
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
                    Tween(SwitchBg, {BackgroundColor3 = Theme.Primary}, 0.15)
                    Tween(SwitchDot, {Position = UDim2.new(1, -19, 0.5, -8)}, 0.15, Enum.EasingStyle.Back)
                else
                    Tween(SwitchBg, {BackgroundColor3 = Theme.Elevated}, 0.15)
                    Tween(SwitchDot, {Position = UDim2.new(0, 3, 0.5, -8)}, 0.15, Enum.EasingStyle.Back)
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
                Size = UDim2.new(1, 0, 0, 54),
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
                Size = UDim2.new(0, 38, 0, 16),
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
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true,
                Parent = Page
            })
            Corner(DropFrame, 8)
            
            local DropBtn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
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
                Size = UDim2.new(0.5, 0, 0, 40),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropBtn
            })
            
            local SelectedLabel = Create("TextLabel", {
                Text = Selected or "...",
                Font = Enum.Font.Gotham,
                TextColor3 = Theme.TextDark,
                TextSize = 12,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, -36, 0, 40),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = DropBtn
            })
            
            local Arrow = Create("TextLabel", {
                Text = "›",
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.TextMuted,
                TextSize = 16,
                Rotation = 90,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -24, 0, 0),
                Size = UDim2.new(0, 14, 0, 40),
                Parent = DropBtn
            })
            
            local OptionsFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 44),
                Size = UDim2.new(1, 0, 0, #Options * 32 + 8),
                Parent = DropFrame
            })
            Padding(OptionsFrame, 4, 8, 8, 4)
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3),
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
                    Tween(OptionBtn, {BackgroundTransparency = 0.5, TextColor3 = Theme.Text}, 0.08)
                end)
                OptionBtn.MouseLeave:Connect(function()
                    Tween(OptionBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDark}, 0.08)
                end)
                OptionBtn.MouseButton1Click:Connect(function()
                    Selected = option
                    SelectedLabel.Text = option
                    Open = false
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.15)
                    Tween(Arrow, {Rotation = 90}, 0.15)
                    pcall(Callback, option)
                end)
            end
            
            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                local targetHeight = Open and (52 + #Options * 32 + 8) or 40
                Tween(DropFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.18)
                Tween(Arrow, {Rotation = Open and 270 or 90}, 0.18)
            end)
            
            return {
                Set = function(_, o) Selected = o SelectedLabel.Text = o pcall(Callback, o) end,
                Get = function() return Selected end,
                Refresh = function(_, newOpts)
                    Options = newOpts
                    for _, c in pairs(OptionsFrame:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
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
                        OptionBtn.MouseEnter:Connect(function() Tween(OptionBtn, {BackgroundTransparency = 0.5, TextColor3 = Theme.Text}, 0.08) end)
                        OptionBtn.MouseLeave:Connect(function() Tween(OptionBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDark}, 0.08) end)
                        OptionBtn.MouseButton1Click:Connect(function()
                            Selected = option SelectedLabel.Text = option Open = false
                            Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.15)
                            Tween(Arrow, {Rotation = 90}, 0.15)
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
            local Placeholder = config.Placeholder or "..."
            local Callback = config.Callback or function() end
            
            local InputFrame = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 40),
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
                Size = UDim2.new(0.42, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = InputFrame
            })
            
            local InputBox = Create("TextBox", {
                BackgroundColor3 = Theme.Elevated,
                Size = UDim2.new(0.52, -18, 0, 28),
                Position = UDim2.new(0.48, 0, 0.5, -14),
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
        
        function Tab:Keybind(config)
            config = config or {}
            local Name = config.Name or "Keybind"
            local Default = config.Default or Enum.KeyCode.E
            local Callback = config.Callback or function() end
            
            local CurrentKey = Default
            local Listening = false
            
            local KeybindFrame = Create("TextButton", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 40),
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
                Size = UDim2.new(1, -95, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KeybindFrame
            })
            
            local KeyLabel = Create("TextLabel", {
                Text = CurrentKey.Name,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Theme.Primary,
                TextSize = 11,
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.88,
                Position = UDim2.new(1, -78, 0.5, -12),
                Size = UDim2.new(0, 66, 0, 24),
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
        
        function Tab:Paragraph(config)
            config = config or {}
            local Title = config.Title or ""
            local Content = config.Content or ""
            
            local Para = Create("Frame", {
                BackgroundColor3 = Theme.Tertiary,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = Page
            })
            Corner(Para, 8)
            Padding(Para, 14, 14, 14, 14)
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
                Parent = Para
            })
            
            Create("TextLabel", {
                Text = Title,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Text,
                TextSize = 13,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 15),
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
