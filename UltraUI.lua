--[[ 
    TITAN UI - "GOD MODE" EDITION
    Inspired by WindUI & Neverlose.
    Engineered for Performance & Visual Fidelity.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// 1. THEME & ASSETS
local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 25),
    Element = Color3.fromRGB(25, 25, 30),
    Border = Color3.fromRGB(40, 40, 45),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(140, 140, 150),
    Accent = Color3.fromRGB(100, 120, 255), -- "Blurple"
    Hover = Color3.fromRGB(35, 35, 40),
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold
}

local Icons = {
    Search = "rbxassetid://7733674676",
    Home = "rbxassetid://7733960981",
    Settings = "rbxassetid://7734053495",
    Arrow = "rbxassetid://7733717447",
    Check = "rbxassetid://7733756680",
    Copy = "rbxassetid://7733756680"
}

--// 2. UTILITY ENGINE
local Utility = {}

function Utility:Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

function Utility:Tween(obj, duration, props)
    TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

function Utility:Shake(obj)
    local origin = obj.Position
    for i = 1, 4 do
        obj.Position = UDim2.new(origin.X.Scale, origin.X.Offset + math.random(-3,3), origin.Y.Scale, origin.Y.Offset + math.random(-3,3))
        task.wait(0.05)
    end
    obj.Position = origin
end

--// 3. MAIN LIBRARY
local Library = {
    Elements = {}, -- Search Index
    Tabs = {},
    CurrentTab = nil
}

function Library:Window(options)
    local WindowName = options.Name or "Titan UI"
    
    -- Cleanup
    if CoreGui:FindFirstChild("TitanUI") then CoreGui.TitanUI:Destroy() end

    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "TitanUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })

    -- FLOATING OVERLAY LAYER (For Dropdowns/Pickers)
    local OverlayLayer = Utility:Create("Frame", {
        Name = "OverlayLayer",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        ZIndex = 1000
    })

    -- MAIN FRAME
    local Main = Utility:Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0.5, -375, 0.5, -250),
        Size = UDim2.new(0, 750, 0, 500),
        BorderSizePixel = 0,
        ClipsDescendants = false
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    
    -- GLOW SHADOW
    local Shadow = Utility:Create("ImageLabel", {
        Parent = Main,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0,0,0),
        ImageTransparency = 0.5,
        Size = UDim2.new(1, 100, 1, 100),
        Position = UDim2.new(0, -50, 0, -50),
        BackgroundTransparency = 1,
        ZIndex = -1
    })

    -- BORDER STROKE
    local Stroke = Utility:Create("UIStroke", {
        Parent = Main,
        Color = Theme.Border,
        Thickness = 1.5,
        Transparency = 0.5
    })

    -- SIDEBAR
    local Sidebar = Utility:Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 200, 1, 0),
        BorderSizePixel = 0
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})
    local SideFix = Utility:Create("Frame", {Parent = Sidebar, BackgroundColor3 = Theme.Sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1,-10,0,0), BorderSizePixel = 0})

    -- TITLE
    local Title = Utility:Create("TextLabel", {
        Parent = Sidebar,
        Text = WindowName,
        TextColor3 = Theme.Text,
        Font = Theme.FontBold,
        TextSize = 22,
        Size = UDim2.new(1, -40, 0, 50),
        Position = UDim2.new(0, 20, 0, 10),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- SEARCH BAR
    local SearchFrame = Utility:Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Element,
        Size = UDim2.new(1, -30, 0, 32),
        Position = UDim2.new(0, 15, 0, 60)
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SearchFrame})
    Utility:Create("UIStroke", {Parent = SearchFrame, Color = Theme.Border, Thickness = 1})
    
    local SearchIcon = Utility:Create("ImageLabel", {
        Parent = SearchFrame,
        Image = Icons.Search,
        ImageColor3 = Theme.SubText,
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 10, 0.5, -7),
        BackgroundTransparency = 1
    })

    local SearchBox = Utility:Create("TextBox", {
        Parent = SearchFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 32, 0, 0),
        Size = UDim2.new(1, -35, 1, 0),
        Font = Theme.Font,
        Text = "",
        PlaceholderText = "Search features...",
        PlaceholderColor3 = Theme.SubText,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- TAB CONTAINER
    local TabContainer = Utility:Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -160),
        Position = UDim2.new(0, 0, 0, 100),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0)
    })
    local TabLayout = Utility:Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})

    -- PROFILE (Bottom)
    local Profile = Utility:Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Element,
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 1, -60)
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Profile})
    
    local PImage = Utility:Create("ImageLabel", {
        Parent = Profile,
        Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48),
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 10, 0.5, -16),
        BackgroundColor3 = Theme.Accent
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = PImage})

    local PName = Utility:Create("TextLabel", {
        Parent = Profile,
        Text = LocalPlayer.Name,
        TextColor3 = Theme.Text,
        Font = Theme.FontBold,
        TextSize = 12,
        Position = UDim2.new(0, 50, 0.5, -8),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local PRank = Utility:Create("TextLabel", {
        Parent = Profile,
        Text = "Administrator",
        TextColor3 = Theme.Accent,
        Font = Theme.Font,
        TextSize = 10,
        Position = UDim2.new(0, 50, 0.5, 6),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- CONTENT AREA
    local Content = Utility:Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -210, 1, -20),
        Position = UDim2.new(0, 210, 0, 10),
        ClipsDescendants = true
    })

    -- DRAGGING
    local Dragging, DragInput, DragStart, StartPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = Main.Position
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            Utility:Tween(Main, 0.05, {Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)})
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

    -- NOTIFICATION SYSTEM
    function Library:Notify(options)
        local NTitle = options.Title or "Notification"
        local NText = options.Content or "Details here..."
        local NTime = options.Duration or 3
        
        local NFrame = Utility:Create("Frame", {
            Parent = ScreenGui,
            BackgroundColor3 = Theme.Sidebar,
            Size = UDim2.new(0, 250, 0, 70),
            Position = UDim2.new(1, 20, 1, -90), -- Start off screen
            ZIndex = 2000
        })
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NFrame})
        Utility:Create("UIStroke", {Parent = NFrame, Color = Theme.Border, Thickness = 1})
        
        local NTitleLbl = Utility:Create("TextLabel", {
            Parent = NFrame,
            Text = NTitle,
            TextColor3 = Theme.Accent,
            Font = Theme.FontBold,
            TextSize = 14,
            Position = UDim2.new(0, 10, 0, 8),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local NTextLbl = Utility:Create("TextLabel", {
            Parent = NFrame,
            Text = NText,
            TextColor3 = Theme.Text,
            Font = Theme.Font,
            TextSize = 12,
            Position = UDim2.new(0, 10, 0, 28),
            Size = UDim2.new(1, -20, 0, 30),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        
        local NBar = Utility:Create("Frame", {
            Parent = NFrame,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2)
        })

        -- Animate In
        Utility:Tween(NFrame, 0.5, {Position = UDim2.new(1, -270, 1, -90)})
        Utility:Tween(NBar, NTime, {Size = UDim2.new(1, 0, 0, 2)})
        
        task.delay(NTime, function()
            Utility:Tween(NFrame, 0.5, {Position = UDim2.new(1, 20, 1, -90)})
            task.wait(0.5)
            NFrame:Destroy()
        end)
    end

    -- SEARCH LOGIC
    local function UpdateSearch(query)
        query = query:lower()
        for _, tab in pairs(Content:GetChildren()) do
            if tab:IsA("ScrollingFrame") then
                if query == "" then
                    -- Reset to current tab
                    tab.Visible = (tab == Library.CurrentTab)
                    for _, el in pairs(tab:GetChildren()) do
                        if el:IsA("Frame") then el.Visible = true end
                    end
                else
                    tab.Visible = false -- Hide all initially
                    local foundAny = false
                    for _, el in pairs(tab:GetChildren()) do
                        if el:IsA("Frame") and el:FindFirstChild("SearchKey") then
                            local key = el.SearchKey.Value:lower()
                            if key:find(query) then
                                el.Visible = true
                                foundAny = true
                            else
                                el.Visible = false
                            end
                        end
                    end
                    if foundAny then tab.Visible = true end
                end
            end
        end
    end
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function() UpdateSearch(SearchBox.Text) end)

    --// WINDOW API
    local WindowObj = {}
    
    function WindowObj:Tab(options)
        local TName = options.Name or "Tab"
        local TIcon = options.Icon or Icons.Home
        
        local TabBtn = Utility:Create("TextButton", {
            Parent = TabContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 38),
            Position = UDim2.new(0, 10, 0, 0),
            Text = "",
            AutoButtonColor = false
        })
        
        local TIconLbl = Utility:Create("ImageLabel", {
            Parent = TabBtn,
            Image = TIcon,
            ImageColor3 = Theme.SubText,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 12, 0.5, -9)
        })
        
        local TTextLbl = Utility:Create("TextLabel", {
            Parent = TabBtn,
            Text = TName,
            TextColor3 = Theme.SubText,
            Font = Theme.Font,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 42, 0, 0),
            Size = UDim2.new(0, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local TIndicator = Utility:Create("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 0, 0, 18), -- Animate height
            Position = UDim2.new(0, 0, 0.5, -9)
        })
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = TIndicator})

        local Page = Utility:Create("ScrollingFrame", {
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 2,
            CanvasSize = UDim2.new(0,0,0,0)
        })
        local PLayout = Utility:Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        PLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0,0,0, PLayout.AbsoluteContentSize.Y + 20) end)

        local function Activate()
            if Library.CurrentTab then
                Library.CurrentTab.Visible = false
                -- Reset previous buttons (Not implemented for brevity, but simple loop)
            end
            
            Library.CurrentTab = Page
            Page.Visible = true
            
            -- Animate Text/Icon
            Utility:Tween(TTextLbl, 0.3, {TextColor3 = Theme.Text})
            Utility:Tween(TIconLbl, 0.3, {ImageColor3 = Theme.Accent})
            Utility:Tween(TIndicator, 0.3, {Size = UDim2.new(0, 3, 0, 18)})
            
            -- Fade In Elements
            for i,v in ipairs(Page:GetChildren()) do
                if v:IsA("Frame") then
                    v.BackgroundTransparency = 1
                    Utility:Tween(v, 0.3 + (i*0.05), {BackgroundTransparency = 0})
                end
            end
        end

        TabBtn.MouseButton1Click:Connect(Activate)
        
        -- Default First Tab
        if #Library.Tabs == 0 then Activate() end
        table.insert(Library.Tabs, {Btn = TabBtn, Page = Page})

        --// ELEMENT API
        local Elements = {}

        function Elements:Section(text)
            local Sec = Utility:Create("TextLabel", {
                Parent = Page,
                Text = text,
                TextColor3 = Theme.Accent,
                Font = Theme.FontBold,
                TextSize = 12,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function Elements:Toggle(options)
            local Name = options.Name
            local State = options.Default or false
            local Callback = options.Callback or function() end
            
            local Btn = Utility:Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 42),
                AutoButtonColor = false,
                Text = ""
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})
            Utility:Create("UIStroke", {Parent = Btn, Color = Theme.Border, Thickness = 1})
            
            -- Search Key
            local Key = Instance.new("StringValue", Btn)
            Key.Name = "SearchKey"
            Key.Value = Name
            
            local Text = Utility:Create("TextLabel", {
                Parent = Btn,
                Text = Name,
                TextColor3 = Theme.Text,
                Font = Theme.Font,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Toggler = Utility:Create("Frame", {
                Parent = Btn,
                BackgroundColor3 = State and Theme.Accent or Color3.fromRGB(50,50,55),
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -52, 0.5, -10)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Toggler})
            
            local Dot = Utility:Create("Frame", {
                Parent = Toggler,
                BackgroundColor3 = Color3.new(1,1,1),
                Size = UDim2.new(0, 16, 0, 16),
                Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Dot})
            
            Btn.MouseButton1Click:Connect(function()
                State = not State
                local GoalPos = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local GoalCol = State and Theme.Accent or Color3.fromRGB(50,50,55)
                
                Utility:Tween(Dot, 0.2, {Position = GoalPos})
                Utility:Tween(Toggler, 0.2, {BackgroundColor3 = GoalCol})
                Callback(State)
            end)
        end
        
        function Elements:Slider(options)
            local Name = options.Name
            local Min, Max = options.Min or 0, options.Max or 100
            local Default = options.Default or Min
            local Callback = options.Callback or function() end
            local Value = Default

            local Frame = Utility:Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 50)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Frame})
            Utility:Create("UIStroke", {Parent = Frame, Color = Theme.Border, Thickness = 1})
            
            local Key = Instance.new("StringValue", Frame)
            Key.Name = "SearchKey"; Key.Value = Name

            local Text = Utility:Create("TextLabel", {
                Parent = Frame,
                Text = Name,
                TextColor3 = Theme.Text,
                Font = Theme.Font,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValLbl = Utility:Create("TextLabel", {
                Parent = Frame,
                Text = tostring(Value),
                TextColor3 = Theme.SubText,
                Font = Theme.Font,
                TextSize = 12,
                Position = UDim2.new(1, -40, 0, 8),
                BackgroundTransparency = 1
            })
            
            local Bar = Utility:Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = Color3.fromRGB(50,50,55),
                Size = UDim2.new(1, -24, 0, 4),
                Position = UDim2.new(0, 12, 0, 35)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Bar})
            
            local Fill = Utility:Create("Frame", {
                Parent = Bar,
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((Value-Min)/(Max-Min), 0, 1, 0)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Fill})
            
            local Trigger = Utility:Create("TextButton", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                Text = ""
            })
            
            local Dragging = false
            local function Update(input)
                local sx = Bar.AbsoluteSize.X
                local px = Bar.AbsolutePosition.X
                local mx = math.clamp(input.Position.X - px, 0, sx)
                local perc = mx/sx
                Value = math.floor(Min + ((Max-Min)*perc))
                ValLbl.Text = tostring(Value)
                Utility:Tween(Fill, 0.05, {Size = UDim2.new(perc, 0, 1, 0)})
                Callback(Value)
            end
            
            Trigger.MouseButton1Down:Connect(function() Dragging = true end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
        end
        
        function Elements:Button(options)
            local Name = options.Name
            local Callback = options.Callback or function() end
            
            local Btn = Utility:Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Text = ""
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})
            Utility:Create("UIStroke", {Parent = Btn, Color = Theme.Border, Thickness = 1})
            
            local Key = Instance.new("StringValue", Btn)
            Key.Name = "SearchKey"; Key.Value = Name
            
            local Text = Utility:Create("TextLabel", {
                Parent = Btn,
                Text = Name,
                TextColor3 = Theme.Text,
                Font = Theme.Font,
                TextSize = 14,
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1
            })
            
            Btn.MouseButton1Click:Connect(function()
                Utility:Tween(Btn, 0.1, {BackgroundColor3 = Theme.Accent})
                task.delay(0.1, function() Utility:Tween(Btn, 0.3, {BackgroundColor3 = Theme.Element}) end)
                Callback()
            end)
        end

        function Elements:Dropdown(options)
            local Name = options.Name
            local Items = options.Items or {}
            local Callback = options.Callback or function() end
            
            local Btn = Utility:Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 42),
                AutoButtonColor = false,
                Text = ""
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})
            Utility:Create("UIStroke", {Parent = Btn, Color = Theme.Border, Thickness = 1})
            local Key = Instance.new("StringValue", Btn); Key.Name = "SearchKey"; Key.Value = Name
            
            local Text = Utility:Create("TextLabel", {
                Parent = Btn,
                Text = Name,
                TextColor3 = Theme.Text,
                Font = Theme.Font,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            local Icon = Utility:Create("ImageLabel", {
                Parent = Btn,
                Image = Icons.Arrow,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -28, 0.5, -8),
                BackgroundTransparency = 1
            })

            -- FLOATING FRAME
            local List = Utility:Create("Frame", {
                Parent = OverlayLayer,
                BackgroundColor3 = Theme.Sidebar,
                Size = UDim2.new(0, 0, 0, 0),
                Visible = false,
                ClipsDescendants = true
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = List})
            Utility:Create("UIStroke", {Parent = List, Color = Theme.Border, Thickness = 1})
            local Scroll = Utility:Create("ScrollingFrame", {Parent = List, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)})
            local Layout = Utility:Create("UIListLayout", {Parent = Scroll, SortOrder = Enum.SortOrder.LayoutOrder})
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Scroll.CanvasSize = UDim2.new(0,0,0, Layout.AbsoluteContentSize.Y) end)
            
            local Open = false
            Btn.MouseButton1Click:Connect(function()
                Open = not Open
                if Open then
                    List.Visible = true
                    List.Position = UDim2.new(0, Btn.AbsolutePosition.X, 0, Btn.AbsolutePosition.Y + 45)
                    List.Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, 0)
                    
                    -- Clear
                    for _,v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    
                    -- Add
                    for _, item in ipairs(Items) do
                        local B = Utility:Create("TextButton", {
                            Parent = Scroll,
                            Text = "  " .. item,
                            Size = UDim2.new(1,0,0,30),
                            BackgroundTransparency = 1,
                            TextColor3 = Theme.SubText,
                            Font = Theme.Font,
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left
                        })
                        B.MouseButton1Click:Connect(function()
                            Text.Text = Name .. ": " .. item
                            Callback(item)
                            Open = false
                            Utility:Tween(List, 0.2, {Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, 0)})
                            task.wait(0.2); List.Visible = false
                        end)
                    end
                    Utility:Tween(List, 0.2, {Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, math.min(#Items * 30, 150))})
                    Utility:Tween(Icon, 0.2, {Rotation = 180})
                else
                    Utility:Tween(List, 0.2, {Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, 0)})
                    Utility:Tween(Icon, 0.2, {Rotation = 0})
                    task.wait(0.2); List.Visible = false
                end
            end)
            
            RunService.RenderStepped:Connect(function()
                if Open and Btn.Visible then
                    List.Position = UDim2.new(0, Btn.AbsolutePosition.X, 0, Btn.AbsolutePosition.Y + 45)
                elseif Open and not Btn.Visible then
                    Open = false; List.Visible = false
                end
            end)
        end
        
        return Elements
    end

    return WindowObj
end

return Library
