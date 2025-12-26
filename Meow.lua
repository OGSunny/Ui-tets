--[[
    APEX UI LIBRARY (SOURCE)
    - Automatically generates the Dashboard (Welcome, Stats, Time)
    - Returns functions to create Tabs, Buttons, Sliders, etc.
]]

local Apex = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

--// THEME: VOID
local THEME = {
    Main        = Color3.fromRGB(15, 15, 20),
    Sidebar     = Color3.fromRGB(10, 10, 15),
    Card        = Color3.fromRGB(20, 20, 26),
    CardHover   = Color3.fromRGB(30, 30, 40),
    TextTitle   = Color3.fromRGB(255, 255, 255),
    TextDesc    = Color3.fromRGB(140, 140, 160),
    Accent      = Color3.fromRGB(60, 100, 245), -- Blurple/Blue
    Green       = Color3.fromRGB(100, 255, 140),
    Red         = Color3.fromRGB(255, 90, 90)
}

--// UTILS
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function AddCorner(parent, radius)
    Create("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
end

local function Tween(inst, props, time)
    TweenService:Create(inst, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function MakeDraggable(topbar, main)
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Tween(main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

--// LIBRARY MAIN
function Apex:Window(options)
    local TitleName = options.Title or "Apex Hub"
    
    -- Cleanup
    if CoreGui:FindFirstChild("ApexLib_UI") then CoreGui.ApexLib_UI:Destroy() end

    local ScreenGui = Create("ScreenGui", {Name = "ApexLib_UI", Parent = CoreGui})

    -- Main Frame
    local Main = Create("Frame", {
        BackgroundColor3 = THEME.Main,
        Position = UDim2.new(0.5, -375, 0.5, -250),
        Size = UDim2.new(0, 750, 0, 500),
        Parent = ScreenGui,
        ClipsDescendants = true
    })
    AddCorner(Main, 10)
    
    -- Sidebar
    local Sidebar = Create("Frame", {
        BackgroundColor3 = THEME.Sidebar,
        Size = UDim2.new(0, 200, 1, 0),
        Parent = Main
    })
    AddCorner(Sidebar, 10)
    -- Cover rounded corner on the right side of sidebar
    Create("Frame", {BackgroundColor3 = THEME.Sidebar, Size = UDim2.new(0,10,1,0), Position = UDim2.new(1,-10,0,0), BorderSizePixel = 0, Parent = Sidebar})

    -- Title
    local TitleLbl = Create("TextLabel", {
        Text = TitleName,
        Font = Enum.Font.GothamBold,
        TextColor3 = THEME.TextTitle,
        TextSize = 18,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 25),
        Size = UDim2.new(1, -20, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Sidebar
    })

    -- Tab Container
    local TabContainer = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 80),
        Size = UDim2.new(1, 0, 1, -80),
        ScrollBarThickness = 0,
        Parent = Sidebar
    })
    local TabLayout = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = TabContainer})
    Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = TabContainer})

    -- Content Area
    local ContentArea = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 200, 0, 0),
        Size = UDim2.new(1, -200, 1, 0),
        Parent = Main
    })
    
    MakeDraggable(Sidebar, Main)

    -------------------------------------------------------------------------
    -- AUTOMATIC DASHBOARD (HOME TAB)
    -------------------------------------------------------------------------
    local HomeBtn = Create("TextButton", {
        BackgroundColor3 = THEME.Card, -- Active by default
        BackgroundTransparency = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Text = "  Dashboard",
        Font = Enum.Font.GothamBold,
        TextColor3 = THEME.TextTitle,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        Parent = TabContainer,
        LayoutOrder = -1 -- Always top
    })
    AddCorner(HomeBtn, 6)

    local DashboardPage = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = ContentArea,
        Visible = true
    })
    Create("UIPadding", {PaddingTop = UDim.new(0, 20), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), Parent = DashboardPage})

    -- Welcome Card
    local Welcome = Create("Frame", {BackgroundColor3 = THEME.Card, Size = UDim2.new(1, 0, 0, 130), Parent = DashboardPage})
    AddCorner(Welcome, 8)
    
    local Avatar = Create("ImageLabel", {
        Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 110, 0, 110),
        Position = UDim2.new(0, 10, 0.5, -55),
        Parent = Welcome
    })
    
    Create("TextLabel", {Text = "Welcome back,", Font = Enum.Font.Gotham, TextColor3 = THEME.TextDesc, TextSize = 14, BackgroundTransparency = 1, Position = UDim2.new(0, 130, 0, 30), Size = UDim2.new(0, 200, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = Welcome})
    Create("TextLabel", {Text = LocalPlayer.DisplayName, Font = Enum.Font.GothamBold, TextColor3 = THEME.TextTitle, TextSize = 24, BackgroundTransparency = 1, Position = UDim2.new(0, 130, 0, 50), Size = UDim2.new(0, 200, 0, 30), TextXAlignment = Enum.TextXAlignment.Left, Parent = Welcome})
    
    -- Real Time Clock
    local TimeLbl = Create("TextLabel", {Text = "00:00:00", Font = Enum.Font.GothamBold, TextColor3 = THEME.Accent, TextSize = 18, BackgroundTransparency = 1, Position = UDim2.new(1, -140, 0, 30), Size = UDim2.new(0, 120, 0, 20), TextXAlignment = Enum.TextXAlignment.Right, Parent = Welcome})
    local DateLbl = Create("TextLabel", {Text = "Dec 25 2024", Font = Enum.Font.Gotham, TextColor3 = THEME.TextDesc, TextSize = 12, BackgroundTransparency = 1, Position = UDim2.new(1, -140, 0, 50), Size = UDim2.new(0, 120, 0, 20), TextXAlignment = Enum.TextXAlignment.Right, Parent = Welcome})
    
    task.spawn(function()
        while Main.Parent do
            TimeLbl.Text = os.date("%H:%M:%S")
            DateLbl.Text = os.date("%b %d %Y")
            task.wait(1)
        end
    end)

    -- Info Grid
    local Grid = Create("Frame", {BackgroundTransparency = 1, Position = UDim2.new(0,0,0,150), Size = UDim2.new(1,0,1,-150), Parent = DashboardPage})
    local GLayout = Create("UIGridLayout", {CellSize = UDim2.new(0.31, 0, 0, 110), CellPadding = UDim2.new(0.03, 0, 0, 0), Parent = Grid})

    local function MakeCard(title)
        local C = Create("Frame", {BackgroundColor3 = THEME.Card, Parent = Grid})
        AddCorner(C, 8)
        Create("TextLabel", {Text = title, Font = Enum.Font.GothamBold, TextColor3 = THEME.TextTitle, TextSize = 14, Position = UDim2.new(0, 15, 0, 15), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = C})
        return C
    end

    -- Stats
    local StatCard = MakeCard("Server Stats")
    local PingLbl = Create("TextLabel", {Text = "Ping: 0 ms", Font = Enum.Font.Gotham, TextColor3 = THEME.TextDesc, TextSize = 13, Position = UDim2.new(0, 15, 0, 45), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = StatCard})
    local FpsLbl = Create("TextLabel", {Text = "FPS: 60", Font = Enum.Font.Gotham, TextColor3 = THEME.TextDesc, TextSize = 13, Position = UDim2.new(0, 15, 0, 65), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = StatCard})

    RunService.RenderStepped:Connect(function(dt)
        local fps = math.floor(1/dt)
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        FpsLbl.Text = "FPS: " .. fps
        PingLbl.Text = "Ping: " .. ping .. " ms"
        PingLbl.TextColor3 = ping > 200 and THEME.Red or THEME.TextDesc
    end)

    -- Script Info
    local InfoCard = MakeCard("Library Info")
    Create("TextLabel", {Text = "Version: 2.0 (Apex)", Font = Enum.Font.Gotham, TextColor3 = THEME.TextDesc, TextSize = 13, Position = UDim2.new(0, 15, 0, 45), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = InfoCard})
    Create("TextLabel", {Text = "Status: Undetected", Font = Enum.Font.Gotham, TextColor3 = THEME.Green, TextSize = 13, Position = UDim2.new(0, 15, 0, 65), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = InfoCard})

    -- Discord
    local DiscCard = MakeCard("Community")
    Create("TextLabel", {Text = "Join for updates.", Font = Enum.Font.Gotham, TextColor3 = THEME.TextDesc, TextSize = 13, Position = UDim2.new(0, 15, 0, 45), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = DiscCard})
    local CopyBtn = Create("TextButton", {Text = "Copy Link", Font = Enum.Font.GothamBold, TextColor3 = THEME.Accent, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 75), Size = UDim2.new(0, 100, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = DiscCard})

    -- Dashboard Home Button Logic
    local function ShowHome()
        for _, c in pairs(ContentArea:GetChildren()) do c.Visible = false end
        for _, t in pairs(TabContainer:GetChildren()) do
            if t:IsA("TextButton") then 
                Tween(t, {BackgroundTransparency = 1, TextColor3 = THEME.TextDesc}, 0.2)
            end
        end
        Tween(HomeBtn, {BackgroundTransparency = 0, TextColor3 = THEME.TextTitle}, 0.2)
        DashboardPage.Visible = true
    end
    HomeBtn.MouseButton1Click:Connect(ShowHome)

    -------------------------------------------------------------------------
    -- USER TABS LOGIC
    -------------------------------------------------------------------------
    local WindowFuncs = {}

    function WindowFuncs:Tab(name)
        -- Tab Button
        local Btn = Create("TextButton", {
            BackgroundColor3 = THEME.Card,
            BackgroundTransparency = 1, -- Inactive
            Size = UDim2.new(1, 0, 0, 40),
            Text = "  " .. name,
            Font = Enum.Font.GothamBold,
            TextColor3 = THEME.TextDesc,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            Parent = TabContainer
        })
        AddCorner(Btn, 6)

        -- Page
        local Page = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = ContentArea,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = THEME.Accent,
            Visible = false
        })
        local List = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = Page})
        Create("UIPadding", {PaddingTop = UDim.new(0, 20), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingBottom = UDim.new(0, 20), Parent = Page})
        
        List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0, List.AbsoluteContentSize.Y + 40)
        end)

        -- Switch Logic
        Btn.MouseButton1Click:Connect(function()
            for _, c in pairs(ContentArea:GetChildren()) do c.Visible = false end
            for _, t in pairs(TabContainer:GetChildren()) do
                if t:IsA("TextButton") then 
                    Tween(t, {BackgroundTransparency = 1, TextColor3 = THEME.TextDesc}, 0.2)
                end
            end
            Tween(Btn, {BackgroundTransparency = 0, TextColor3 = THEME.TextTitle}, 0.2)
            Page.Visible = true
        end)

        -- Tab Functions
        local TabFuncs = {}

        function TabFuncs:Section(text)
            local SLabel = Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamBold,
                TextColor3 = THEME.Accent,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Bottom,
                Parent = Page
            })
            Create("UIPadding", {PaddingBottom = UDim.new(0, 5), Parent = SLabel})
        end

        function TabFuncs:Paragraph(title, desc)
            local Container = Create("Frame", {BackgroundColor3 = THEME.Card, Size = UDim2.new(1, 0, 0, 0), Parent = Page}) -- Auto height
            AddCorner(Container, 6)
            local T = Create("TextLabel", {Text = title, Font = Enum.Font.GothamBold, TextColor3 = THEME.TextTitle, TextSize = 13, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1, -24, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = Container})
            local D = Create("TextLabel", {Text = desc, Font = Enum.Font.Gotham, TextColor3 = THEME.TextDesc, TextSize = 12, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 28), Size = UDim2.new(1, -24, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = Container})
            
            -- Resize based on text
            D.Size = UDim2.new(1, -24, 0, 1000)
            D.Size = UDim2.new(1, -24, 0, D.TextBounds.Y)
            Container.Size = UDim2.new(1, 0, 0, D.TextBounds.Y + 40)
        end

        function TabFuncs:Button(text, callback)
            local BtnFrame = Create("TextButton", {
                BackgroundColor3 = THEME.Card,
                Size = UDim2.new(1, 0, 0, 42),
                Text = "",
                AutoButtonColor = false,
                Parent = Page
            })
            AddCorner(BtnFrame, 6)
            
            local Lbl = Create("TextLabel", {Text = text, Font = Enum.Font.GothamMedium, TextColor3 = THEME.TextTitle, TextSize = 13, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = BtnFrame})
            
            BtnFrame.MouseEnter:Connect(function() Tween(BtnFrame, {BackgroundColor3 = THEME.CardHover}, 0.2) end)
            BtnFrame.MouseLeave:Connect(function() Tween(BtnFrame, {BackgroundColor3 = THEME.Card}, 0.2) end)
            BtnFrame.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        function TabFuncs:Toggle(text, default, callback)
            local Toggled = default or false
            local TFrame = Create("TextButton", {BackgroundColor3 = THEME.Card, Size = UDim2.new(1, 0, 0, 42), Text = "", AutoButtonColor = false, Parent = Page})
            AddCorner(TFrame, 6)
            
            Create("TextLabel", {Text = text, Font = Enum.Font.GothamMedium, TextColor3 = THEME.TextTitle, TextSize = 13, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -60, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, Parent = TFrame})
            
            local Switch = Create("Frame", {BackgroundColor3 = THEME.Main, Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -48, 0.5, -9), Parent = TFrame})
            AddCorner(Switch, 18)
            local Dot = Create("Frame", {BackgroundColor3 = THEME.TextDesc, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7), Parent = Switch})
            AddCorner(Dot, 14)

            local function Update()
                local tColor = Toggled and THEME.Accent or THEME.TextDesc
                local tPos = Toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                Tween(Dot, {Position = tPos, BackgroundColor3 = tColor}, 0.2)
                pcall(callback, Toggled)
            end
            
            TFrame.MouseButton1Click:Connect(function() Toggled = not Toggled; Update() end)
            if Toggled then Update() end
        end

        function TabFuncs:Slider(text, min, max, default, callback)
            local Val = default or min
            local SFrame = Create("Frame", {BackgroundColor3 = THEME.Card, Size = UDim2.new(1, 0, 0, 60), Parent = Page})
            AddCorner(SFrame, 6)
            
            Create("TextLabel", {Text = text, Font = Enum.Font.GothamMedium, TextColor3 = THEME.TextTitle, TextSize = 13, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 10), Size = UDim2.new(1, -50, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, Parent = SFrame})
            local ValLbl = Create("TextLabel", {Text = tostring(Val), Font = Enum.Font.GothamBold, TextColor3 = THEME.Accent, TextSize = 13, BackgroundTransparency = 1, Position = UDim2.new(1, -40, 0, 10), Size = UDim2.new(0, 30, 0, 20), TextXAlignment = Enum.TextXAlignment.Right, Parent = SFrame})
            
            local Bar = Create("TextButton", {BackgroundColor3 = THEME.Main, Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 40), AutoButtonColor = false, Text = "", Parent = SFrame})
            AddCorner(Bar, 6)
            local Fill = Create("Frame", {BackgroundColor3 = THEME.Accent, Size = UDim2.new((Val-min)/(max-min), 0, 1, 0), Parent = Bar})
            AddCorner(Fill, 6)
            
            local dragging = false
            local function Update(input)
                local p = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Val = math.floor(min + ((max - min) * p))
                Tween(Fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
                ValLbl.Text = tostring(Val)
                pcall(callback, Val)
            end
            
            Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
        end

        return TabFuncs
    end

    return WindowFuncs
end

return Apex
