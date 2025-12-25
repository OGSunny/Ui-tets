--[[
    Stellar Hub UI Library
    A Modern PVP UI Library for Roblox
    
    Usage:
    local Library = loadstring(game:HttpGet("YOUR_URL_HERE"))()
    local Window = Library:CreateWindow({Name = "Stellar Hub", KeyTime = "Lifetime"})
    local Tab = Window:CreateTab({Name = "Main", Icon = "rbxassetid://7733779610"})
    Tab:CreateToggle({Name = "Enable Feature", CurrentValue = false, Callback = function(v) print(v) end})
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Tertiary = Color3.fromRGB(35, 35, 50),
    Accent = Color3.fromRGB(100, 255, 100),
    AccentDark = Color3.fromRGB(70, 180, 70),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    TextDisabled = Color3.fromRGB(120, 120, 120),
    Success = Color3.fromRGB(100, 255, 100),
    Error = Color3.fromRGB(255, 100, 100),
    Warning = Color3.fromRGB(255, 200, 100)
}

Library.ToggleKey = Enum.KeyCode.RightControl
Library.Notifications = {}

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
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Library.Theme.Tertiary,
        Thickness = thickness or 1,
        Parent = parent
    })
end

local function AddPadding(parent, padding)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, padding),
        PaddingBottom = UDim.new(0, padding),
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
        Parent = parent
    })
end

local function GetUserThumbnail()
    local success, result = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if success then
        return result
    end
    return "rbxassetid://0"
end

-- Notification System
function Library:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local image = config.Image
    local duration = config.Time or 5
    
    -- Find or create notification container
    local screenGui = CoreGui:FindFirstChild("StellarHubNotifications")
    if not screenGui then
        screenGui = Create("ScreenGui", {
            Name = "StellarHubNotifications",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = CoreGui
        })
        
        Create("Frame", {
            Name = "Container",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -20, 1, -20),
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 300, 1, -40),
            Parent = screenGui
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 10),
            Parent = screenGui.Container
        })
    end
    
    local container = screenGui.Container
    
    -- Create notification
    local notification = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Library.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = container
    })
    AddCorner(notification, 10)
    AddStroke(notification, Library.Theme.Accent, 2)
    
    local contentFrame = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = notification
    })
    AddPadding(contentFrame, 12)
    
    local layout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = contentFrame
    })
    
    -- Header with icon
    local header = Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        LayoutOrder = 1,
        Parent = contentFrame
    })
    
    if image then
        Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = image,
            ImageColor3 = Library.Theme.Accent,
            Parent = header
        })
    end
    
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, image and 28 or 0, 0, 0),
        Size = UDim2.new(1, image and -28 or 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Library.Theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    Create("TextLabel", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = Library.Theme.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 2,
        Parent = contentFrame
    })
    
    -- Progress bar
    local progressBg = Create("Frame", {
        Name = "ProgressBg",
        BackgroundColor3 = Library.Theme.Background,
        Size = UDim2.new(1, 0, 0, 3),
        LayoutOrder = 3,
        Parent = contentFrame
    })
    AddCorner(progressBg, 2)
    
    local progressBar = Create("Frame", {
        Name = "Progress",
        BackgroundColor3 = Library.Theme.Accent,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = progressBg
    })
    AddCorner(progressBar, 2)
    
    -- Animate in
    notification.BackgroundTransparency = 1
    Tween(notification, {BackgroundTransparency = 0}, 0.3)
    
    -- Progress animation
    Tween(progressBar, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    -- Auto-remove
    task.delay(duration, function()
        Tween(notification, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        notification:Destroy()
    end)
    
    return notification
end

-- Main Window Creation
function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Name or "Stellar Hub"
    local keyTime = config.KeyTime or "Lifetime"
    
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Minimized = false
    
    -- Create ScreenGui
    local screenGui = Create("ScreenGui", {
        Name = "StellarHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })
    
    Window.ScreenGui = screenGui
    
    -- Main Container with shadow
    local shadowContainer = Create("Frame", {
        Name = "ShadowContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 860, 0, 520),
        Parent = screenGui
    })
    
    -- Drop Shadow
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 40, 1, 40),
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = shadowContainer
    })
    
    -- Main Frame
    local mainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Library.Theme.Background,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 840, 0, 500),
        ClipsDescendants = true,
        Parent = shadowContainer
    })
    AddCorner(mainFrame, 12)
    
    Window.MainFrame = mainFrame
    
    -- Top Bar (50px)
    local topBar = Create("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Library.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 50),
        Parent = mainFrame
    })
    AddCorner(topBar, 12)
    
    -- Fix corner overlap
    Create("Frame", {
        Name = "CornerFix",
        BackgroundColor3 = Library.Theme.Secondary,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        Parent = topBar
    })
    
    -- Window Title (Left side - Green)
    local titleContainer = Create("Frame", {
        Name = "TitleContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Parent = topBar
    })
    
    Create("ImageLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 28, 0, 28),
        Image = "rbxassetid://7733955511", -- Star icon
        ImageColor3 = Library.Theme.Accent,
        Parent = titleContainer
    })
    
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 38, 0, 0),
        Size = UDim2.new(1, -38, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = windowTitle,
        TextColor3 = Library.Theme.Accent,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleContainer
    })
    
    -- Right Side Container (User info, buttons)
    local rightContainer = Create("Frame", {
        Name = "RightContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -15, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(0, 400, 1, 0),
        Parent = topBar
    })
    
    -- Close Button
    local closeBtn = Create("TextButton", {
        Name = "CloseButton",
        BackgroundColor3 = Library.Theme.Error,
        BackgroundTransparency = 0.8,
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 32, 0, 32),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Library.Theme.Error,
        TextSize = 24,
        Parent = rightContainer
    })
    AddCorner(closeBtn, 8)
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.5}, 0.2)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundTransparency = 0.8}, 0.2)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Minimize Button
    local minimizeBtn = Create("TextButton", {
        Name = "MinimizeButton",
        BackgroundColor3 = Library.Theme.Warning,
        BackgroundTransparency = 0.8,
        Position = UDim2.new(1, -42, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 32, 0, 32),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Library.Theme.Warning,
        TextSize = 24,
        Parent = rightContainer
    })
    AddCorner(minimizeBtn, 8)
    
    minimizeBtn.MouseEnter:Connect(function()
        Tween(minimizeBtn, {BackgroundTransparency = 0.5}, 0.2)
    end)
    minimizeBtn.MouseLeave:Connect(function()
        Tween(minimizeBtn, {BackgroundTransparency = 0.8}, 0.2)
    end)
    minimizeBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(mainFrame, {Size = UDim2.new(0, 840, 0, 50)}, 0.3)
            Tween(shadowContainer, {Size = UDim2.new(0, 860, 0, 70)}, 0.3)
        else
            Tween(mainFrame, {Size = UDim2.new(0, 840, 0, 500)}, 0.3)
            Tween(shadowContainer, {Size = UDim2.new(0, 860, 0, 520)}, 0.3)
        end
    end)
    
    -- Key Time Display
    local keyTimeLabel = Create("TextLabel", {
        Name = "KeyTime",
        BackgroundColor3 = Library.Theme.Tertiary,
        Position = UDim2.new(1, -84, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 100, 0, 28),
        Font = Enum.Font.GothamMedium,
        Text = "⏱ " .. keyTime,
        TextColor3 = Library.Theme.Accent,
        TextSize = 11,
        Parent = rightContainer
    })
    AddCorner(keyTimeLabel, 6)
    
    -- Username
    local usernameLabel = Create("TextLabel", {
        Name = "Username",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -194, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 120, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = LocalPlayer.Name,
        TextColor3 = Library.Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = rightContainer
    })
    
    -- User Avatar
    local avatarFrame = Create("Frame", {
        Name = "AvatarFrame",
        BackgroundColor3 = Library.Theme.Accent,
        Position = UDim2.new(1, -230, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 34, 0, 34),
        Parent = rightContainer
    })
    AddCorner(avatarFrame, 17)
    
    local avatar = Create("ImageLabel", {
        Name = "Avatar",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 32, 0, 32),
        Image = GetUserThumbnail(),
        Parent = avatarFrame
    })
    AddCorner(avatar, 16)
    
    -- Sidebar (240px)
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Library.Theme.Secondary,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(0, 240, 1, -50),
        Parent = mainFrame
    })
    
    -- Fix sidebar corners
    Create("Frame", {
        Name = "CornerFix",
        BackgroundColor3 = Library.Theme.Secondary,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 12),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    Create("Frame", {
        Name = "CornerFixRight",
        BackgroundColor3 = Library.Theme.Secondary,
        Position = UDim2.new(1, -12, 0, 0),
        Size = UDim2.new(0, 12, 1, 0),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    AddCorner(sidebar, 12)
    
    -- Sidebar Header
    local sidebarHeader = Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 0, 40),
        Parent = sidebar
    })
    
    Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -15, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "⚔ PVP MODULES",
        TextColor3 = Library.Theme.TextDark,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sidebarHeader
    })
    
    -- Tab Container
    local tabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 55),
        Size = UDim2.new(1, -20, 1, -65),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Library.Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = tabContainer
    })
    
    Window.TabContainer = tabContainer
    
    -- Content Area
    local contentArea = Create("Frame", {
        Name = "ContentArea",
        BackgroundColor3 = Library.Theme.Background,
        Position = UDim2.new(0, 240, 0, 50),
        Size = UDim2.new(1, -240, 1, -50),
        Parent = mainFrame
    })
    
    Window.ContentArea = contentArea
    
    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = shadowContainer.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            shadowContainer.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Toggle UI with keybind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Library.ToggleKey then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)
    
    -- Create Tab Method
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon
        
        local Tab = {}
        Tab.Elements = {}
        
        -- Tab Button
        local tabButton = Create("TextButton", {
            Name = tabName .. "Tab",
            BackgroundColor3 = Library.Theme.Tertiary,
            Size = UDim2.new(1, 0, 0, 42),
            Font = Enum.Font.Gotham,
            Text = "",
            AutoButtonColor = false,
            Parent = tabContainer
        })
        AddCorner(tabButton, 8)
        
        -- Icon
        if tabIcon then
            Create("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 20, 0, 20),
                Image = tabIcon,
                ImageColor3 = Library.Theme.TextDark,
                Parent = tabButton
            })
        end
        
        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, tabIcon and 42 or 12, 0, 0),
            Size = UDim2.new(1, tabIcon and -52 or -22, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = tabName,
            TextColor3 = Library.Theme.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabButton
        })
        
        Tab.Button = tabButton
        
        -- Content Frame
        local contentFrame = Create("ScrollingFrame", {
            Name = tabName .. "Content",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 15),
            Size = UDim2.new(1, -30, 1, -30),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Library.Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = contentArea
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = contentFrame
        })
        
        Tab.Content = contentFrame
        
        -- Tab selection
        local function selectTab()
            -- Deselect all tabs
            for _, otherTab in pairs(Window.Tabs) do
                Tween(otherTab.Button, {BackgroundColor3 = Library.Theme.Tertiary}, 0.2)
                otherTab.Button:FindFirstChild("Label").TextColor3 = Library.Theme.TextDark
                if otherTab.Button:FindFirstChild("Icon") then
                    otherTab.Button.Icon.ImageColor3 = Library.Theme.TextDark
                end
                otherTab.Content.Visible = false
            end
            
            -- Select this tab
            Tween(tabButton, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
            tabButton:FindFirstChild("Label").TextColor3 = Library.Theme.Background
            if tabButton:FindFirstChild("Icon") then
                tabButton.Icon.ImageColor3 = Library.Theme.Background
            end
            contentFrame.Visible = true
            Window.ActiveTab = Tab
        end
        
        tabButton.MouseButton1Click:Connect(selectTab)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabButton, {BackgroundColor3 = Library.Theme.Secondary}, 0.2)
            end
        end)
        tabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(tabButton, {BackgroundColor3 = Library.Theme.Tertiary}, 0.2)
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            selectTab()
        end
        
        -- SECTION
        function Tab:CreateSection(config)
            config = config or {}
            local sectionName = config.Name or "Section"
            local sectionDesc = config.Description
            
            local sectionFrame = Create("Frame", {
                Name = "Section",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, sectionDesc and 50 or 30),
                Parent = contentFrame
            })
            
            Create("Frame", {
                Name = "Line",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(0, 30, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(1, -30, 0, 2),
                Parent = sectionFrame
            })
            
            Create("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, sectionDesc and 5 or 0),
                Size = UDim2.new(0, 20, 0, 20),
                Image = "rbxassetid://7734000129", -- Shield icon
                ImageColor3 = Library.Theme.Accent,
                Parent = sectionFrame
            })
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 30, 0, sectionDesc and 2 or 0),
                Size = UDim2.new(1, -30, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = "  " .. sectionName .. "  ",
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundColor3 = Library.Theme.Background,
                Parent = sectionFrame
            })
            
            if sectionDesc then
                Create("TextLabel", {
                    Name = "Description",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 30, 0, 24),
                    Size = UDim2.new(1, -30, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = sectionDesc,
                    TextColor3 = Library.Theme.TextDark,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sectionFrame
                })
            end
            
            return sectionFrame
        end
        
        -- TOGGLE
        function Tab:CreateToggle(config)
            config = config or {}
            local toggleName = config.Name or "Toggle"
            local toggleDesc = config.Description
            local currentValue = config.CurrentValue or false
            local callback = config.Callback or function() end
            
            local Toggle = {}
            Toggle.Value = currentValue
            
            local toggleFrame = Create("Frame", {
                Name = "Toggle",
                BackgroundColor3 = Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, toggleDesc and 60 or 45),
                Parent = contentFrame
            })
            AddCorner(toggleFrame, 8)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, toggleDesc and 10 or 0),
                Size = UDim2.new(1, -80, 0, toggleDesc and 22 or 45),
                Font = Enum.Font.GothamMedium,
                Text = toggleName,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleFrame
            })
            
            if toggleDesc then
                Create("TextLabel", {
                    Name = "Description",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 32),
                    Size = UDim2.new(1, -80, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = toggleDesc,
                    TextColor3 = Library.Theme.TextDark,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleFrame
                })
            end
            
            -- Toggle Switch
            local switchBg = Create("Frame", {
                Name = "SwitchBg",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(1, -60, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 45, 0, 24),
                Parent = toggleFrame
            })
            AddCorner(switchBg, 12)
            
            local switchCircle = Create("Frame", {
                Name = "Circle",
                BackgroundColor3 = Library.Theme.TextDark,
                Position = UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 18, 0, 18),
                Parent = switchBg
            })
            AddCorner(switchCircle, 9)
            
            local function updateToggle()
                if Toggle.Value then
                    Tween(switchBg, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                    Tween(switchCircle, {Position = UDim2.new(1, -21, 0.5, 0), BackgroundColor3 = Library.Theme.Background}, 0.2)
                else
                    Tween(switchBg, {BackgroundColor3 = Library.Theme.Tertiary}, 0.2)
                    Tween(switchCircle, {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = Library.Theme.TextDark}, 0.2)
                end
            end
            
            -- Initialize
            updateToggle()
            
            local toggleButton = Create("TextButton", {
                Name = "ToggleButton",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = toggleFrame
            })
            
            toggleButton.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                updateToggle()
                callback(Toggle.Value)
            end)
            
            function Toggle:Set(value)
                Toggle.Value = value
                updateToggle()
                callback(Toggle.Value)
            end
            
            table.insert(Tab.Elements, Toggle)
            return Toggle
        end
        
        -- SLIDER
        function Tab:CreateSlider(config)
            config = config or {}
            local sliderName = config.Name or "Slider"
            local sliderDesc = config.Description
            local range = config.Range or {0, 100}
            local increment = config.Increment or 1
            local currentValue = config.CurrentValue or range[1]
            local callback = config.Callback or function() end
            
            local Slider = {}
            Slider.Value = currentValue
            
            local sliderFrame = Create("Frame", {
                Name = "Slider",
                BackgroundColor3 = Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, sliderDesc and 75 or 60),
                Parent = contentFrame
            })
            AddCorner(sliderFrame, 8)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 10),
                Size = UDim2.new(0.7, -15, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = sliderName,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sliderFrame
            })
            
            local valueLabel = Create("TextLabel", {
                Name = "Value",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -15, 0, 10),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0.3, 0, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = tostring(currentValue),
                TextColor3 = Library.Theme.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = sliderFrame
            })
            
            if sliderDesc then
                Create("TextLabel", {
                    Name = "Description",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 28),
                    Size = UDim2.new(1, -30, 0, 16),
                    Font = Enum.Font.Gotham,
                    Text = sliderDesc,
                    TextColor3 = Library.Theme.TextDark,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sliderFrame
                })
            end
            
            local sliderBg = Create("Frame", {
                Name = "SliderBg",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(0, 15, 1, -20),
                AnchorPoint = Vector2.new(0, 1),
                Size = UDim2.new(1, -30, 0, 8),
                Parent = sliderFrame
            })
            AddCorner(sliderBg, 4)
            
            local sliderFill = Create("Frame", {
                Name = "Fill",
                BackgroundColor3 = Library.Theme.Accent,
                Size = UDim2.new((currentValue - range[1]) / (range[2] - range[1]), 0, 1, 0),
                Parent = sliderBg
            })
            AddCorner(sliderFill, 4)
            
            local sliderKnob = Create("Frame", {
                Name = "Knob",
                BackgroundColor3 = Library.Theme.Text,
                Position = UDim2.new((currentValue - range[1]) / (range[2] - range[1]), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0, 16, 0, 16),
                Parent = sliderBg
            })
            AddCorner(sliderKnob, 8)
            AddStroke(sliderKnob, Library.Theme.Accent, 2)
            
            local function updateSlider(value)
                value = math.clamp(value, range[1], range[2])
                value = math.floor(value / increment + 0.5) * increment
                Slider.Value = value
                
                local percent = (value - range[1]) / (range[2] - range[1])
                Tween(sliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                Tween(sliderKnob, {Position = UDim2.new(percent, 0, 0.5, 0)}, 0.1)
                valueLabel.Text = tostring(value)
                callback(value)
            end
            
            local dragging = false
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    local percent = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local value = range[1] + (range[2] - range[1]) * percent
                    updateSlider(value)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local percent = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local value = range[1] + (range[2] - range[1]) * percent
                    updateSlider(value)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            function Slider:Set(value)
                updateSlider(value)
            end
            
            table.insert(Tab.Elements, Slider)
            return Slider
        end
        
        -- BUTTON
        function Tab:CreateButton(config)
            config = config or {}
            local buttonName = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local Button = {}
            
            local buttonFrame = Create("TextButton", {
                Name = "Button",
                BackgroundColor3 = Library.Theme.Accent,
                Size = UDim2.new(1, 0, 0, 40),
                Font = Enum.Font.GothamBold,
                Text = buttonName,
                TextColor3 = Library.Theme.Background,
                TextSize = 14,
                AutoButtonColor = false,
                Parent = contentFrame
            })
            AddCorner(buttonFrame, 8)
            
            buttonFrame.MouseEnter:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Library.Theme.AccentDark}, 0.2)
            end)
            buttonFrame.MouseLeave:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
            end)
            
            buttonFrame.MouseButton1Click:Connect(function()
                -- Click animation
                Tween(buttonFrame, {Size = UDim2.new(1, -4, 0, 38)}, 0.1)
                task.wait(0.1)
                Tween(buttonFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.1)
                callback()
            end)
            
            table.insert(Tab.Elements, Button)
            return Button
        end
        
        -- DROPDOWN
        function Tab:CreateDropdown(config)
            config = config or {}
            local dropdownName = config.Name or "Dropdown"
            local options = config.Options or {}
            local currentOption = config.CurrentOption or options[1] or ""
            local callback = config.Callback or function() end
            
            local Dropdown = {}
            Dropdown.Value = currentOption
            Dropdown.Open = false
            
            local dropdownFrame = Create("Frame", {
                Name = "Dropdown",
                BackgroundColor3 = Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 45),
                ClipsDescendants = true,
                Parent = contentFrame
            })
            AddCorner(dropdownFrame, 8)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.5, -15, 0, 45),
                Font = Enum.Font.GothamMedium,
                Text = dropdownName,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dropdownFrame
            })
            
            local selectedBtn = Create("TextButton", {
                Name = "Selected",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(0.5, 5, 0, 8),
                Size = UDim2.new(0.5, -20, 0, 30),
                Font = Enum.Font.GothamMedium,
                Text = currentOption .. " ▼",
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                AutoButtonColor = false,
                Parent = dropdownFrame
            })
            AddCorner(selectedBtn, 6)
            
            local optionsContainer = Create("Frame", {
                Name = "Options",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 50),
                Size = UDim2.new(1, -30, 0, #options * 32),
                Parent = dropdownFrame
            })
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4),
                Parent = optionsContainer
            })
            
            for i, option in ipairs(options) do
                local optionBtn = Create("TextButton", {
                    Name = option,
                    BackgroundColor3 = Library.Theme.Tertiary,
                    Size = UDim2.new(1, 0, 0, 28),
                    Font = Enum.Font.Gotham,
                    Text = option,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 12,
                    AutoButtonColor = false,
                    Parent = optionsContainer
                })
                AddCorner(optionBtn, 6)
                
                optionBtn.MouseEnter:Connect(function()
                    Tween(optionBtn, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                    optionBtn.TextColor3 = Library.Theme.Background
                end)
                optionBtn.MouseLeave:Connect(function()
                    Tween(optionBtn, {BackgroundColor3 = Library.Theme.Tertiary}, 0.2)
                    optionBtn.TextColor3 = Library.Theme.Text
                end)
                
                optionBtn.MouseButton1Click:Connect(function()
                    Dropdown.Value = option
                    selectedBtn.Text = option .. " ▼"
                    Dropdown.Open = false
                    Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.2)
                    callback(option)
                end)
            end
            
            selectedBtn.MouseButton1Click:Connect(function()
                Dropdown.Open = not Dropdown.Open
                if Dropdown.Open then
                    Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 55 + #options * 32)}, 0.2)
                    selectedBtn.Text = currentOption .. " ▲"
                else
                    Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.2)
                    selectedBtn.Text = Dropdown.Value .. " ▼"
                end
            end)
            
            function Dropdown:Set(option)
                Dropdown.Value = option
                selectedBtn.Text = option .. " ▼"
                callback(option)
            end
            
            table.insert(Tab.Elements, Dropdown)
            return Dropdown
        end
        
        -- INPUT
        function Tab:CreateInput(config)
            config = config or {}
            local inputName = config.Name or "Input"
            local placeholder = config.PlaceholderText or "Enter text..."
            local callback = config.Callback or function() end
            
            local Input = {}
            Input.Value = ""
            
            local inputFrame = Create("Frame", {
                Name = "Input",
                BackgroundColor3 = Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 45),
                Parent = contentFrame
            })
            AddCorner(inputFrame, 8)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.4, -15, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = inputName,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = inputFrame
            })
            
            local textBox = Create("TextBox", {
                Name = "TextBox",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(0.4, 5, 0, 8),
                Size = UDim2.new(0.6, -20, 0, 30),
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder,
                PlaceholderColor3 = Library.Theme.TextDisabled,
                Text = "",
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                ClearTextOnFocus = false,
                Parent = inputFrame
            })
            AddCorner(textBox, 6)
            
            textBox.Focused:Connect(function()
                Tween(textBox, {BackgroundColor3 = Library.Theme.Secondary}, 0.2)
                AddStroke(textBox, Library.Theme.Accent, 2)
            end)
            
            textBox.FocusLost:Connect(function(enterPressed)
                Tween(textBox, {BackgroundColor3 = Library.Theme.Tertiary}, 0.2)
                for _, child in pairs(textBox:GetChildren()) do
                    if child:IsA("UIStroke") then
                        child:Destroy()
                    end
                end
                Input.Value = textBox.Text
                if enterPressed then
                    callback(textBox.Text)
                end
            end)
            
            function Input:Set(text)
                textBox.Text = text
                Input.Value = text
            end
            
            table.insert(Tab.Elements, Input)
            return Input
        end
        
        -- COLOR PICKER
        function Tab:CreateColorPicker(config)
            config = config or {}
            local pickerName = config.Name or "Color Picker"
            local currentColor = config.Color or Color3.fromRGB(255, 255, 255)
            local callback = config.Callback or function() end
            
            local ColorPicker = {}
            ColorPicker.Value = currentColor
            ColorPicker.Open = false
            
            local pickerFrame = Create("Frame", {
                Name = "ColorPicker",
                BackgroundColor3 = Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 45),
                ClipsDescendants = true,
                Parent = contentFrame
            })
            AddCorner(pickerFrame, 8)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.7, -15, 0, 45),
                Font = Enum.Font.GothamMedium,
                Text = pickerName,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = pickerFrame
            })
            
            local colorPreview = Create("TextButton", {
                Name = "Preview",
                BackgroundColor3 = currentColor,
                Position = UDim2.new(1, -50, 0, 10),
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.new(0, 35, 0, 25),
                Text = "",
                AutoButtonColor = false,
                Parent = pickerFrame
            })
            AddCorner(colorPreview, 6)
            AddStroke(colorPreview, Library.Theme.Text, 2)
            
            -- RGB Sliders container
            local slidersContainer = Create("Frame", {
                Name = "Sliders",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 50),
                Size = UDim2.new(1, -30, 0, 100),
                Parent = pickerFrame
            })
            
            local function createColorSlider(name, color, yPos, initialValue)
                local sliderBg = Create("Frame", {
                    Name = name,
                    BackgroundColor3 = Library.Theme.Tertiary,
                    Position = UDim2.new(0, 0, 0, yPos),
                    Size = UDim2.new(1, -50, 0, 20),
                    Parent = slidersContainer
                })
                AddCorner(sliderBg, 4)
                
                local sliderFill = Create("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = color,
                    Size = UDim2.new(initialValue / 255, 0, 1, 0),
                    Parent = sliderBg
                })
                AddCorner(sliderFill, 4)
                
                local valueLabel = Create("TextLabel", {
                    Name = "Value",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 10, 0, yPos),
                    Size = UDim2.new(0, 40, 0, 20),
                    Font = Enum.Font.GothamMedium,
                    Text = tostring(math.floor(initialValue)),
                    TextColor3 = color,
                    TextSize = 12,
                    Parent = slidersContainer
                })
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0, 0),
                    Size = UDim2.new(0, 20, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = Library.Theme.Text,
                    TextSize = 10,
                    ZIndex = 2,
                    Parent = sliderBg
                })
                
                return sliderBg, sliderFill, valueLabel
            end
            
            local rSlider, rFill, rValue = createColorSlider("R", Color3.fromRGB(255, 100, 100), 0, currentColor.R * 255)
            local gSlider, gFill, gValue = createColorSlider("G", Color3.fromRGB(100, 255, 100), 35, currentColor.G * 255)
            local bSlider, bFill, bValue = createColorSlider("B", Color3.fromRGB(100, 100, 255), 70, currentColor.B * 255)
            
            local function updateColor()
                local r = math.floor(ColorPicker.Value.R * 255)
                local g = math.floor(ColorPicker.Value.G * 255)
                local b = math.floor(ColorPicker.Value.B * 255)
                colorPreview.BackgroundColor3 = ColorPicker.Value
                rFill.Size = UDim2.new(r / 255, 0, 1, 0)
                gFill.Size = UDim2.new(g / 255, 0, 1, 0)
                bFill.Size = UDim2.new(b / 255, 0, 1, 0)
                rValue.Text = tostring(r)
                gValue.Text = tostring(g)
                bValue.Text = tostring(b)
                callback(ColorPicker.Value)
            end
            
            local function setupSliderDrag(slider, fill, valueLabel, component)
                local dragging = false
                
                slider.InputBegan:Connect(function(input)
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
                        local percent = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        local value = math.floor(percent * 255)
                        
                        local r = ColorPicker.Value.R * 255
                        local g = ColorPicker.Value.G * 255
                        local b = ColorPicker.Value.B * 255
                        
                        if component == "R" then r = value
                        elseif component == "G" then g = value
                        else b = value end
                        
                        ColorPicker.Value = Color3.fromRGB(r, g, b)
                        updateColor()
                    end
                end)
            end
            
            setupSliderDrag(rSlider, rFill, rValue, "R")
            setupSliderDrag(gSlider, gFill, gValue, "G")
            setupSliderDrag(bSlider, bFill, bValue, "B")
            
            colorPreview.MouseButton1Click:Connect(function()
                ColorPicker.Open = not ColorPicker.Open
                if ColorPicker.Open then
                    Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 160)}, 0.2)
                else
                    Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.2)
                end
            end)
            
            function ColorPicker:Set(color)
                ColorPicker.Value = color
                updateColor()
            end
            
            table.insert(Tab.Elements, ColorPicker)
            return ColorPicker
        end
        
        -- LABEL
        function Tab:CreateLabel(config)
            config = config or {}
            local labelText = config.Name or "Label"
            
            local Label = {}
            
            local labelFrame = Create("TextLabel", {
                Name = "Label",
                BackgroundColor3 = Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 35),
                Font = Enum.Font.GothamMedium,
                Text = labelText,
                TextColor3 = Library.Theme.TextDark,
                TextSize = 13,
                Parent = contentFrame
            })
            AddCorner(labelFrame, 8)
            
            function Label:Set(text)
                labelFrame.Text = text
            end
            
            table.insert(Tab.Elements, Label)
            return Label
        end
        
        -- PARAGRAPH
        function Tab:CreateParagraph(config)
            config = config or {}
            local title = config.Title or "Title"
            local content = config.Content or "Content"
            
            local Paragraph = {}
            
            local paragraphFrame = Create("Frame", {
                Name = "Paragraph",
                BackgroundColor3 = Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = contentFrame
            })
            AddCorner(paragraphFrame, 8)
            AddPadding(paragraphFrame, 12)
            
            local layout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6),
                Parent = paragraphFrame
            })
            
            local titleLabel = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = title,
                TextColor3 = Library.Theme.Accent,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 1,
                Parent = paragraphFrame
            })
            
            local contentLabel = Create("TextLabel", {
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Font = Enum.Font.Gotham,
                Text = content,
                TextColor3 = Library.Theme.TextDark,
                TextSize = 12,
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
        
        -- KEYBIND
        function Tab:CreateKeybind(config)
            config = config or {}
            local keybindName = config.Name or "Keybind"
            local currentKeybind = config.CurrentKeybind or "None"
            local callback = config.Callback or function() end
            
            local Keybind = {}
            Keybind.Value = currentKeybind
            Keybind.Listening = false
            
            local keybindFrame = Create("Frame", {
                Name = "Keybind",
                BackgroundColor3 = Library.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 45),
                Parent = contentFrame
            })
            AddCorner(keybindFrame, 8)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.6, -15, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = keybindName,
                TextColor3 = Library.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = keybindFrame
            })
            
            local keybindBtn = Create("TextButton", {
                Name = "KeybindButton",
                BackgroundColor3 = Library.Theme.Tertiary,
                Position = UDim2.new(1, -90, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Size = UDim2.new(0, 75, 0, 28),
                Font = Enum.Font.GothamMedium,
                Text = currentKeybind,
                TextColor3 = Library.Theme.Accent,
                TextSize = 12,
                AutoButtonColor = false,
                Parent = keybindFrame
            })
            AddCorner(keybindBtn, 6)
            
            keybindBtn.MouseButton1Click:Connect(function()
                Keybind.Listening = true
                keybindBtn.Text = "..."
                Tween(keybindBtn, {BackgroundColor3 = Library.Theme.Accent}, 0.2)
                keybindBtn.TextColor3 = Library.Theme.Background
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if Keybind.Listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind.Value = input.KeyCode.Name
                        keybindBtn.Text = input.KeyCode.Name
                        Keybind.Listening = false
                        Tween(keybindBtn, {BackgroundColor3 = Library.Theme.Tertiary}, 0.2)
                        keybindBtn.TextColor3 = Library.Theme.Accent
                    end
                elseif not gameProcessed then
                    if input.KeyCode.Name == Keybind.Value then
                        callback(Keybind.Value)
                    end
                end
            end)
            
            function Keybind:Set(key)
                Keybind.Value = key
                keybindBtn.Text = key
            end
            
            table.insert(Tab.Elements, Keybind)
            return Keybind
        end
        
        return Tab
    end
    
    -- Show welcome notification
    task.spawn(function()
        task.wait(0.5)
        Library:Notify({
            Title = "Welcome to Stellar Hub",
            Content = "Press RightCtrl to toggle the UI. Enjoy your PVP experience!",
            Image = "rbxassetid://7733955511",
            Time = 5
        })
    end)
    
    return Window
end

return Library
