--[[ 
    ULTRA UI LIBRARY - SOURCE CODE
    Visual Style: Premium Glassmorphism + Spotlight Borders + Floating Overlays
    Author: Refactored by AI
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {
    Open = true,
    Theme = {
        Background = Color3.fromRGB(18, 18, 22),
        Sidebar = Color3.fromRGB(23, 23, 28),
        Content = Color3.fromRGB(25, 25, 30),
        Accent = Color3.fromRGB(88, 101, 242), -- Blurple
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 170),
        Outline = Color3.fromRGB(45, 45, 50),
        Item = Color3.fromRGB(30, 30, 35),
        Hover = Color3.fromRGB(40, 40, 45),
        Font = Enum.Font.GothamMedium,
        FontBold = Enum.Font.GothamBold
    },
    Assets = {
        Icons = {
            Logo = "rbxassetid://7733960981",
            Home = "rbxassetid://7733960981",
            Settings = "rbxassetid://7734053495",
            Search = "rbxassetid://7733674676",
            Arrow = "rbxassetid://7733717447",
            Check = "rbxassetid://7733756680",
            Close = "rbxassetid://7743878857"
        },
        Sounds = {
            Hover = "rbxassetid://6895079853",
            Click = "rbxassetid://6895079619",
            Notification = "rbxassetid://4590657391"
        }
    }
}

--// UTILITY FUNCTIONS
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function PlaySound(id)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = 0.5
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local function Ripple(btn)
    task.spawn(function()
        local ripple = Create("ImageLabel", {
            Parent = btn,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.9,
            BorderSizePixel = 0,
            Image = "rbxassetid://2708891598",
            ImageColor3 = Color3.fromRGB(255,255,255),
            ImageTransparency = 0.8,
            Position = UDim2.new(0, Mouse.X - btn.AbsolutePosition.X, 0, Mouse.Y - btn.AbsolutePosition.Y),
            Size = UDim2.new(0,0,0,0),
            ZIndex = 10
        })
        Tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 300, 0, 300),
            Position = UDim2.new(0, ripple.Position.X.Offset - 150, 0, ripple.Position.Y.Offset - 150),
            ImageTransparency = 1
        })
        task.wait(0.5)
        ripple:Destroy()
    end)
end

--// MAIN WINDOW FUNCTION
function Library:Window(options)
    local WindowName = options.Name or "Ultra UI"
    
    -- UI Protection / Parent Logic
    local ParentTarget = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui
    if ParentTarget:FindFirstChild("UltraUI_Lib") then
        ParentTarget.UltraUI_Lib:Destroy()
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "UltraUI_Lib",
        Parent = ParentTarget,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })

    -- Overlay Layer (For Floating Dropdowns/Tooltips)
    local OverlayLayer = Create("Frame", {
        Name = "Overlays",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 100 -- Always on top
    })

    -- Background Blocker (Click off to close dropdowns)
    local OverlayBlocker = Create("TextButton", {
        Parent = OverlayLayer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        Text = "",
        Visible = false
    })

    -- Main Container
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Library.Theme.Background,
        Position = UDim2.new(0.5, -350, 0.5, -225),
        Size = UDim2.new(0, 700, 0, 450),
        BorderSizePixel = 0,
        ClipsDescendants = false
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = MainFrame})

    -- Spotlight Border
    local UIStroke = Create("UIStroke", {
        Parent = MainFrame,
        Thickness = 1.5,
        Color = Library.Theme.Outline
    })
    local StrokeGradient = Create("UIGradient", {
        Parent = UIStroke,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Library.Theme.Outline),
            ColorSequenceKeypoint.new(0.5, Library.Theme.Accent),
            ColorSequenceKeypoint.new(1, Library.Theme.Outline)
        }
    })

    -- Mouse Lighting Logic
    RunService.RenderStepped:Connect(function()
        if MainFrame.Visible then
            local center = MainFrame.AbsolutePosition + (MainFrame.AbsoluteSize / 2)
            local mouse = UserInputService:GetMouseLocation()
            local angle = math.atan2(mouse.Y - center.Y, mouse.X - center.X)
            StrokeGradient.Rotation = math.deg(angle) + 90
        end
    end)

    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Library.Theme.Sidebar,
        Size = UDim2.new(0, 200, 1, 0),
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})
    
    -- Sidebar Flatten Right Side
    local SideCover = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Library.Theme.Sidebar,
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -10, 0, 0),
        BorderSizePixel = 0
    })

    -- Logo Area
    local LogoIcon = Create("ImageLabel", {
        Parent = Sidebar,
        Image = Library.Assets.Icons.Logo,
        ImageColor3 = Library.Theme.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 20, 0, 20)
    })
    local LogoText = Create("TextLabel", {
        Parent = Sidebar,
        Text = WindowName,
        TextColor3 = Library.Theme.Text,
        Font = Library.Theme.FontBold,
        TextSize = 16,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 55, 0, 32),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Search Bar
    local SearchFrame = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Library.Theme.Item,
        Size = UDim2.new(1, -30, 0, 32),
        Position = UDim2.new(0, 15, 0, 65)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SearchFrame})
    Create("UIStroke", {Parent = SearchFrame, Color = Library.Theme.Outline, Thickness = 1})
    
    local SearchIcon = Create("ImageLabel", {
        Parent = SearchFrame,
        Image = Library.Assets.Icons.Search,
        ImageColor3 = Library.Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 10, 0.5, -7)
    })
    
    local SearchBox = Create("TextBox", {
        Parent = SearchFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(1, -35, 1, 0),
        Font = Library.Theme.Font,
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Library.Theme.SubText,
        TextColor3 = Library.Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Tab Container
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -160),
        Position = UDim2.new(0, 0, 0, 110),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0)
    })
    local TabList = Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    -- Selection Pill
    local Pill = Create("Frame", {
        Parent = TabContainer,
        BackgroundColor3 = Library.Theme.Accent,
        Size = UDim2.new(0, 3, 0, 20),
        Visible = false
    })
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Pill})

    -- User Profile
    local ProfileFrame = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.8,
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 1, -60)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ProfileFrame})
    
    local Avatar = Create("ImageLabel", {
        Parent = ProfileFrame,
        Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 10, 0.5, -16)
    })
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Avatar})
    
    local UserName = Create("TextLabel", {
        Parent = ProfileFrame,
        Text = LocalPlayer.Name,
        TextColor3 = Library.Theme.Text,
        Font = Library.Theme.FontBold,
        TextSize = 12,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 50, 0.5, -8),
        Size = UDim2.new(0, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local UserRank = Create("TextLabel", {
        Parent = ProfileFrame,
        Text = "Premium User",
        TextColor3 = Library.Theme.SubText,
        Font = Library.Theme.Font,
        TextSize = 10,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 50, 0.5, 6),
        Size = UDim2.new(0, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Content Area
    local ContentArea = Create("Frame", {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -200, 1, 0),
        Position = UDim2.new(0, 200, 0, 0),
        ClipsDescendants = true
    })

    -- Dragging Logic
    local Dragging, DragInput, DragStart, StartPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            local target = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
            Tween(MainFrame, TweenInfo.new(0.05), {Position = target})
        end
    end)
    
    -- Toggle UI Keybind
    UserInputService.InputBegan:Connect(function(input, gpe)
        if input.KeyCode == Enum.KeyCode.RightControl and not gpe then
            Library.Open = not Library.Open
            MainFrame.Visible = Library.Open
        end
    end)

    -- Search Logic
    local function FilterTabs(text)
        text = text:lower()
        for _, tab in pairs(ContentArea:GetChildren()) do
            if tab:IsA("ScrollingFrame") and tab.Visible then
                for _, el in pairs(tab:GetChildren()) do
                    if el:IsA("Frame") or el:IsA("TextButton") then
                        -- Assuming elements have a 'Title' textlabel
                        local title = el:FindFirstChild("Title")
                        if title and title:IsA("TextLabel") then
                            if text == "" or title.Text:lower():find(text) then
                                el.Visible = true
                            else
                                el.Visible = false
                            end
                        end
                    end
                end
                -- Reset canvas position
                tab.CanvasPosition = Vector2.new(0,0)
            end
        end
    end
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        FilterTabs(SearchBox.Text)
    end)

    --// WINDOW API
    local Tabs = {}
    local FirstTab = true
    local WindowAPI = {}

    function WindowAPI:Tab(name, icon)
        -- Button
        local TabBtn = Create("TextButton", {
            Parent = TabContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 35),
            Position = UDim2.new(0, 10, 0, 0),
            Text = "",
            AutoButtonColor = false
        })
        
        local BtnIcon = Create("ImageLabel", {
            Parent = TabBtn,
            Image = icon or Library.Assets.Icons.Home,
            ImageColor3 = Library.Theme.SubText,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 15, 0.5, -9)
        })
        
        local BtnText = Create("TextLabel", {
            Parent = TabBtn,
            Text = name,
            TextColor3 = Library.Theme.SubText,
            Font = Library.Theme.Font,
            TextSize = 14,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        -- Page
        local TabPage = Create("ScrollingFrame", {
            Parent = ContentArea,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            Visible = false,
            CanvasSize = UDim2.new(0,0,0,0)
        })
        local PageList = Create("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0,0,0, PageList.AbsoluteContentSize.Y + 20)
        end)

        local function Activate()
            -- Deactivate all
            for _, t in pairs(Tabs) do
                Tween(t.Text, TweenInfo.new(0.2), {TextColor3 = Library.Theme.SubText})
                Tween(t.Icon, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.SubText})
                t.Page.Visible = false
            end
            
            -- Activate this
            Tween(BtnText, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text})
            Tween(BtnIcon, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.Accent})
            TabPage.Visible = true
            
            -- Pill Animation
            Pill.Visible = true
            Tween(Pill, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, TabBtn.LayoutOrder * 40 + 8) -- Rough calc based on padding+size
            })

            -- Staggered Entry
            for i, child in ipairs(TabPage:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    child.BackgroundTransparency = 1
                    Tween(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, i*0.04), {BackgroundTransparency = 0})
                end
            end
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        if FirstTab then
            FirstTab = false
            Activate()
        end

        table.insert(Tabs, {Btn = TabBtn, Text = BtnText, Icon = BtnIcon, Page = TabPage})

        --// ELEMENT API
        local Elements = {}

        function Elements:Section(text)
            local Sec = Create("TextLabel", {
                Parent = TabPage,
                Text = text,
                TextColor3 = Library.Theme.Accent,
                Font = Library.Theme.FontBold,
                TextSize = 12,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function Elements:Button(options)
            local Name = options.Name or "Button"
            local Callback = options.Callback or function() end
            
            local Btn = Create("TextButton", {
                Parent = TabPage,
                BackgroundColor3 = Library.Theme.Item,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Text = ""
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})
            Create("UIStroke", {Parent = Btn, Color = Library.Theme.Outline, Thickness = 1})
            
            local Title = Create("TextLabel", {
                Name = "Title",
                Parent = Btn,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                Font = Library.Theme.Font,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Icon = Create("ImageLabel", {
                Parent = Btn,
                Image = Library.Assets.Icons.Arrow,
                ImageColor3 = Library.Theme.SubText,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -28, 0.5, -8)
            })
            
            Btn.MouseEnter:Connect(function()
                Tween(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Hover})
                Tween(Icon, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.Text})
                PlaySound(Library.Assets.Sounds.Hover)
            end)
            
            Btn.MouseLeave:Connect(function()
                Tween(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Item})
                Tween(Icon, TweenInfo.new(0.2), {ImageColor3 = Library.Theme.SubText})
            end)
            
            Btn.MouseButton1Click:Connect(function()
                Ripple(Btn)
                PlaySound(Library.Assets.Sounds.Click)
                Callback()
            end)
        end

        function Elements:Toggle(options)
            local Name = options.Name or "Toggle"
            local State = options.Default or false
            local Callback = options.Callback or function() end
            
            local Btn = Create("TextButton", {
                Parent = TabPage,
                BackgroundColor3 = Library.Theme.Item,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Text = ""
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})
            Create("UIStroke", {Parent = Btn, Color = Library.Theme.Outline, Thickness = 1})
            
            local Title = Create("TextLabel", {
                Name = "Title",
                Parent = Btn,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                Font = Library.Theme.Font,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local CheckBG = Create("Frame", {
                Parent = Btn,
                BackgroundColor3 = State and Library.Theme.Accent or Color3.fromRGB(40,40,40),
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -32, 0.5, -10)
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = CheckBG})
            
            local CheckIcon = Create("ImageLabel", {
                Parent = CheckBG,
                Image = Library.Assets.Icons.Check,
                BackgroundTransparency = 1,
                ImageColor3 = Color3.fromRGB(255,255,255),
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0.5, -7, 0.5, -7),
                ImageTransparency = State and 0 or 1
            })
            
            local function Update()
                local TargetColor = State and Library.Theme.Accent or Color3.fromRGB(40,40,40)
                Tween(CheckBG, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor})
                Tween(CheckIcon, TweenInfo.new(0.2), {ImageTransparency = State and 0 or 1})
                Callback(State)
            end
            
            Btn.MouseButton1Click:Connect(function()
                State = not State
                Ripple(Btn)
                PlaySound(Library.Assets.Sounds.Click)
                Update()
            end)
        end

        function Elements:Slider(options)
            local Name = options.Name or "Slider"
            local Min = options.Min or 0
            local Max = options.Max or 100
            local Default = options.Default or Min
            local Callback = options.Callback or function() end
            
            local Value = Default
            
            local Frame = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = Library.Theme.Item,
                Size = UDim2.new(1, 0, 0, 50)
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Frame})
            Create("UIStroke", {Parent = Frame, Color = Library.Theme.Outline, Thickness = 1})
            
            local Title = Create("TextLabel", {
                Name = "Title",
                Parent = Frame,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                Font = Library.Theme.Font,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 8),
                Size = UDim2.new(1, -60, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValLabel = Create("TextLabel", {
                Parent = Frame,
                Text = tostring(Value),
                TextColor3 = Library.Theme.SubText,
                Font = Library.Theme.Font,
                TextSize = 12,
                Position = UDim2.new(1, -40, 0, 8),
                Size = UDim2.new(0, 30, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local BarBack = Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = Color3.fromRGB(40,40,40),
                Size = UDim2.new(1, -24, 0, 4),
                Position = UDim2.new(0, 12, 0, 34)
            })
            Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = BarBack})
            
            local BarFill = Create("Frame", {
                Parent = BarBack,
                BackgroundColor3 = Library.Theme.Accent,
                Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            })
            Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = BarFill})
            
            local DragBtn = Create("TextButton", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                Text = ""
            })
            
            local IsDragging = false
            
            local function UpdateSlide(input)
                local SizeX = BarBack.AbsoluteSize.X
                local PosX = BarBack.AbsolutePosition.X
                local MouseX = math.clamp(input.Position.X - PosX, 0, SizeX)
                local Percent = MouseX / SizeX
                Value = math.floor(Min + ((Max - Min) * Percent))
                
                ValLabel.Text = tostring(Value)
                Tween(BarFill, TweenInfo.new(0.05), {Size = UDim2.new(Percent, 0, 1, 0)})
                Callback(Value)
            end
            
            DragBtn.MouseButton1Down:Connect(function() IsDragging = true end)
            UserInputService.InputEnded:Connect(function(input) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 then IsDragging = false end 
            end)
            UserInputService.InputChanged:Connect(function(input)
                if IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlide(input) end
            end)
        end

        function Elements:Dropdown(options)
            local Name = options.Name or "Dropdown"
            local Items = options.Items or {}
            local Callback = options.Callback or function() end
            
            local IsOpen = false
            
            local Btn = Create("TextButton", {
                Parent = TabPage,
                BackgroundColor3 = Library.Theme.Item,
                Size = UDim2.new(1, 0, 0, 40),
                AutoButtonColor = false,
                Text = ""
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})
            Create("UIStroke", {Parent = Btn, Color = Library.Theme.Outline, Thickness = 1})
            
            local Title = Create("TextLabel", {
                Name = "Title",
                Parent = Btn,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                Font = Library.Theme.Font,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Arrow = Create("ImageLabel", {
                Parent = Btn,
                Image = Library.Assets.Icons.Arrow,
                ImageColor3 = Library.Theme.SubText,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -28, 0.5, -8)
            })
            
            -- FLOATING DROPDOWN LIST (Parented to OverlayLayer)
            local DropFrame = Create("Frame", {
                Parent = OverlayLayer,
                BackgroundColor3 = Library.Theme.Sidebar,
                Size = UDim2.new(0, 0, 0, 0), -- Initial size 0
                Visible = false,
                ClipsDescendants = true,
                ZIndex = 105
            })
            Create("UIStroke", {Parent = DropFrame, Color = Library.Theme.Outline, Thickness = 1})
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropFrame})
            
            local DropScroll = Create("ScrollingFrame", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                CanvasSize = UDim2.new(0,0,0,0),
                ScrollBarThickness = 2
            })
            local DropList = Create("UIListLayout", {
                Parent = DropScroll,
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            DropList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropScroll.CanvasSize = UDim2.new(0,0,0, DropList.AbsoluteContentSize.Y)
            end)
            
            local function Close()
                IsOpen = false
                OverlayBlocker.Visible = false
                Tween(Arrow, TweenInfo.new(0.2), {Rotation = 0})
                Tween(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, 0)})
                task.wait(0.2)
                DropFrame.Visible = false
            end
            
            local function Open()
                IsOpen = true
                OverlayBlocker.Visible = true
                DropFrame.Visible = true
                -- Calculate Position
                DropFrame.Position = UDim2.new(0, Btn.AbsolutePosition.X, 0, Btn.AbsolutePosition.Y + 45)
                DropFrame.Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, 0)
                
                -- Refresh Items
                for _, child in pairs(DropScroll:GetChildren()) do 
                    if child:IsA("TextButton") then child:Destroy() end 
                end
                
                for _, item in ipairs(Items) do
                    local ItemBtn = Create("TextButton", {
                        Parent = DropScroll,
                        Text = "  " .. item,
                        TextColor3 = Library.Theme.SubText,
                        Font = Library.Theme.Font,
                        TextSize = 13,
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                    ItemBtn.MouseButton1Click:Connect(function()
                        Title.Text = Name .. ": " .. item
                        Callback(item)
                        Close()
                    end)
                end
                
                Tween(Arrow, TweenInfo.new(0.2), {Rotation = 180})
                Tween(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, math.min(#Items * 30, 150))})
            end
            
            Btn.MouseButton1Click:Connect(function()
                if IsOpen then Close() else Open() end
            end)
            
            -- Close if overlay blocker clicked
            OverlayBlocker.MouseButton1Click:Connect(function()
                if IsOpen then Close() end
            end)
            
            -- Update position loop
            RunService.RenderStepped:Connect(function()
                if IsOpen and Btn.Visible then
                    DropFrame.Position = UDim2.new(0, Btn.AbsolutePosition.X, 0, Btn.AbsolutePosition.Y + 45)
                elseif IsOpen and not Btn.Visible then
                    Close()
                end
            end)
        end

        return Elements
    end

    return WindowAPI
end

return Library
