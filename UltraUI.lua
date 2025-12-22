--[[ 
    ULTRA UI V2 - "GOD MODE"
    Architecture: Vertical Sidebar, Floating Overlays, Acrylic Texture, Ripple Physics
    Author: Refactored by AI (Premium)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// ASSETS & CONFIG
local Assets = {
    Gradient = "rbxassetid://16933618667", -- Soft radial glow
    Noise = "rbxassetid://16933618667", -- Used for frost effect (Placeholder ID, usually a noise texture)
    Icons = {
        Home = "rbxassetid://7733960981",
        Settings = "rbxassetid://7734053495",
        Search = "rbxassetid://7733674676",
        Arrow = "rbxassetid://7733717447",
        Check = "rbxassetid://7733756680",
        Close = "rbxassetid://7743878857",
        User = "rbxassetid://7743875962",
        Palette = "rbxassetid://7733954760"
    },
    Sounds = {
        Hover = "rbxassetid://6895079853",
        Click = "rbxassetid://6895079619",
        Notification = "rbxassetid://4590657391"
    }
}

local Theme = {
    Main = Color3.fromRGB(18, 18, 22),
    Sidebar = Color3.fromRGB(22, 22, 26),
    Accent = Color3.fromRGB(114, 137, 218), -- Blurple/Modern
    AccentGlow = Color3.fromRGB(114, 137, 218),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(160, 160, 170),
    Border = Color3.fromRGB(45, 45, 50),
    Item = Color3.fromRGB(28, 28, 32),
    Hover = Color3.fromRGB(35, 35, 40),
    Success = Color3.fromRGB(80, 200, 120),
    FontMain = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold
}

--// UTILITY FUNCTIONS
local Utility = {}

function Utility:Create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    return obj
end

function Utility:Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

function Utility:Ripple(btn)
    task.spawn(function()
        local ripple = Utility:Create("ImageLabel", {
            Parent = btn,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.8,
            BorderSizePixel = 0,
            Image = "rbxassetid://2708891598", -- Circle
            ImageColor3 = Color3.fromRGB(255,255,255),
            ImageTransparency = 0.8,
            Position = UDim2.new(0, Mouse.X - btn.AbsolutePosition.X, 0, Mouse.Y - btn.AbsolutePosition.Y),
            Size = UDim2.new(0,0,0,0),
            ZIndex = 10
        })
        
        -- Expand and fade
        Utility:Tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 300, 0, 300),
            Position = UDim2.new(0, ripple.Position.X.Offset - 150, 0, ripple.Position.Y.Offset - 150),
            ImageTransparency = 1
        })
        
        task.wait(0.5)
        ripple:Destroy()
    end)
end

function Utility:PlaySound(id, vol)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = vol or 1
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

--// MAIN LIBRARY
local Library = {
    Open = true,
    Windows = {},
    Connections = {}
}

function Library:Init(options)
    local Name = options.Name or "Ultra UI"
    
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "UltraUI_Pro",
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Overlay Container (For Floating Dropdowns/Tooltips)
    local OverlayContainer = Utility:Create("Frame", {
        Name = "Overlays",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        ZIndex = 100
    })

    -- Notification Container
    local NotificationList = Utility:Create("Frame", {
        Name = "Notifications",
        Parent = ScreenGui,
        Position = UDim2.new(1, -270, 0, 20),
        Size = UDim2.new(0, 250, 1, -40),
        BackgroundTransparency = 1,
        ZIndex = 200
    })
    local NotifLayout = Utility:Create("UIListLayout", {
        Parent = NotificationList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })

    --// MAIN WINDOW FRAME
    local Main = Utility:Create("Frame", {
        Name = "MainWindow",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Main,
        Size = UDim2.new(0, 750, 0, 500),
        Position = UDim2.new(0.5, -375, 0.5, -250),
        BorderSizePixel = 0,
        ClipsDescendants = false -- Important for shadows
    })
    
    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    
    -- Aesthetic: Shadow
    local Shadow = Utility:Create("ImageLabel", {
        Parent = Main,
        Image = "rbxassetid://6015897843", -- Shadow Slice
        ImageColor3 = Color3.fromRGB(0,0,0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(47, 47, 450, 450),
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        ZIndex = -1
    })

    -- Aesthetic: Grain/Noise Overlay (The "Frosted" look)
    local Grain = Utility:Create("ImageLabel", {
        Parent = Main,
        Image = Assets.Noise, 
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 200, 0, 200),
        ImageTransparency = 0.96, -- Very subtle texture
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        ZIndex = 0
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Grain})
    
    -- Aesthetic: Spotlight Border
    local UIStroke = Utility:Create("UIStroke", {
        Parent = Main,
        Thickness = 1.2,
        Color = Theme.Border,
        Transparency = 0.2
    })
    
    local BorderGradient = Utility:Create("UIGradient", {
        Parent = UIStroke,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Border),
            ColorSequenceKeypoint.new(0.5, Theme.Accent),
            ColorSequenceKeypoint.new(1, Theme.Border)
        },
        Rotation = 45
    })
    
    -- Mouse Light Logic
    RunService.RenderStepped:Connect(function()
        if not Main.Visible then return end
        local mPos = UserInputService:GetMouseLocation()
        local fPos = Main.AbsolutePosition + (Main.AbsoluteSize/2)
        local angle = math.atan2(mPos.Y - fPos.Y, mPos.X - fPos.X)
        BorderGradient.Rotation = math.deg(angle) + 90
    end)

    -- Sidebar
    local Sidebar = Utility:Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 60, 1, 0), -- Start collapsed
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})
    
    -- Sidebar Cover to flatten right side
    local SideCover = Utility:Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -10, 0, 0)
    })

    -- Profile Section (Bottom)
    local Profile = Utility:Create("Frame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 1, -60)
    })
    
    local Avatar = Utility:Create("ImageLabel", {
        Parent = Profile,
        Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48),
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 14, 0.5, -16),
        BackgroundColor3 = Theme.Accent
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Avatar})
    
    -- Tab Container
    local TabContainer = Utility:Create("Frame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -130),
        Position = UDim2.new(0, 0, 0, 70)
    })
    local TabLayout = Utility:Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    -- Logo
    local Logo = Utility:Create("ImageLabel", {
        Parent = Sidebar,
        Image = "rbxassetid://7733960981", -- Abstract Logo
        ImageColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 18, 0, 20)
    })

    -- Content Area
    local Content = Utility:Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -70, 1, -20),
        Position = UDim2.new(0, 70, 0, 10),
        ClipsDescendants = true
    })
    
    -- Search Bar
    local SearchBar = Utility:Create("Frame", {
        Parent = Content,
        BackgroundColor3 = Theme.Item,
        Size = UDim2.new(1, -10, 0, 35),
        BorderSizePixel = 0
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SearchBar})
    
    local SearchIcon = Utility:Create("ImageLabel", {
        Parent = SearchBar,
        Image = Assets.Icons.Search,
        ImageColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 12, 0.5, -8)
    })
    
    local SearchInput = Utility:Create("TextBox", {
        Parent = SearchBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 38, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Theme.FontMain,
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Theme.SubText,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Pages Container
    local Pages = Utility:Create("Frame", {
        Parent = Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -45),
        Position = UDim2.new(0, 0, 0, 45)
    })

    --// DRAGGING
    local Dragging, DragInput, DragStart, StartPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            Utility:Tween(Main, TweenInfo.new(0.05), {
                Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            })
        end
    end)
    
    --// NOTIFICATIONS API
    function Library:Notify(options)
        local Title = options.Title or "Notification"
        local ContentText = options.Content or ""
        local Duration = options.Duration or 3
        
        local Toast = Utility:Create("Frame", {
            Parent = NotificationList,
            BackgroundColor3 = Theme.Sidebar,
            Size = UDim2.new(1, 0, 0, 60),
            Position = UDim2.new(1, 0, 0, 0), -- Start offscreen
            BackgroundTransparency = 0.1
        })
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Toast})
        Utility:Create("UIStroke", {Parent = Toast, Color = Theme.Border, Thickness = 1})
        
        local TTitle = Utility:Create("TextLabel", {
            Parent = Toast,
            Text = Title,
            TextColor3 = Theme.Accent,
            Font = Theme.FontBold,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 8),
            Size = UDim2.new(1, -20, 0, 20),
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local TContent = Utility:Create("TextLabel", {
            Parent = Toast,
            Text = ContentText,
            TextColor3 = Theme.Text,
            Font = Theme.FontMain,
            TextSize = 12,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 28),
            Size = UDim2.new(1, -20, 0, 20),
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local Bar = Utility:Create("Frame", {
            Parent = Toast,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
            BorderSizePixel = 0
        })

        Utility:PlaySound(Assets.Sounds.Notification, 0.5)
        
        -- Animation In
        -- Since UIListLayout controls position, we can animate transparency/size or use padding
        -- But for simplicity in ListLayout, we just parent it.
        
        Utility:Tween(Bar, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,0,2)})
        
        task.delay(Duration, function()
            Utility:Tween(Toast, TweenInfo.new(0.5), {BackgroundTransparency = 1})
            Utility:Tween(TTitle, TweenInfo.new(0.5), {TextTransparency = 1})
            Utility:Tween(TContent, TweenInfo.new(0.5), {TextTransparency = 1})
            Utility:Tween(Bar, TweenInfo.new(0.5), {BackgroundTransparency = 1})
            task.wait(0.5)
            Toast:Destroy()
        end)
    end

    --// TABS LOGIC
    local Tabs = {}
    local First = true
    
    local WindowAPI = {}

    function WindowAPI:Tab(name, iconId)
        local TabBtn = Utility:Create("TextButton", {
            Parent = TabContainer,
            BackgroundColor3 = Theme.Sidebar,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 40, 0, 40),
            Text = "",
            AutoButtonColor = false
        })
        
        local TabIcon = Utility:Create("ImageLabel", {
            Parent = TabBtn,
            Image = iconId or Assets.Icons.Home,
            ImageColor3 = Theme.SubText,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0.5, -10, 0.5, -10),
            BackgroundTransparency = 1
        })
        
        -- Active Indicator Dot
        local Dot = Utility:Create("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 4, 0, 4),
            Position = UDim2.new(0, 2, 0.5, -2),
            Visible = false
        })
        Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Dot})

        -- Page
        local Page = Utility:Create("ScrollingFrame", {
            Parent = Pages,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 1, 0),
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0,0,0,0)
        })
        local PLayout = Utility:Create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        PLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0, PLayout.AbsoluteContentSize.Y + 20)
        end)

        local function Activate()
            for _, t in pairs(Tabs) do
                Utility:Tween(t.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.SubText})
                t.Dot.Visible = false
                t.Page.Visible = false
            end
            Utility:Tween(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Theme.Accent})
            Dot.Visible = true
            Page.Visible = true
            
            -- Staggered Entry
            for i, v in ipairs(Page:GetChildren()) do
                if v:IsA("Frame") then
                    v.BackgroundTransparency = 1
                    local t = Utility:Tween(v, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, i*0.03), {BackgroundTransparency = 0})
                end
            end
        end

        TabBtn.MouseButton1Click:Connect(Activate)
        
        -- Hover
        TabBtn.MouseEnter:Connect(function()
            if not Dot.Visible then Utility:Tween(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Theme.Text}) end
            Utility:PlaySound(Assets.Sounds.Hover, 0.2)
        end)
        TabBtn.MouseLeave:Connect(function()
            if not Dot.Visible then Utility:Tween(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Theme.SubText}) end
        end)

        if First then
            First = false
            Activate()
        end
        
        table.insert(Tabs, {Btn = TabBtn, Icon = TabIcon, Dot = Dot, Page = Page})

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
            local Name = options.Name or "Toggle"
            local Callback = options.Callback or function() end
            local State = options.Default or false

            local Frame = Utility:Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = Theme.Item,
                Size = UDim2.new(1, 0, 0, 42),
                AutoButtonColor = false,
                Text = ""
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Frame})
            
            local Text = Utility:Create("TextLabel", {
                Parent = Frame,
                Text = Name,
                TextColor3 = Theme.Text,
                Font = Theme.FontMain,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Checkbox = Utility:Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = State and Theme.Accent or Color3.fromRGB(40,40,40),
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -32, 0.5, -10)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Checkbox})
            
            local CheckIcon = Utility:Create("ImageLabel", {
                Parent = Checkbox,
                Image = Assets.Icons.Check,
                ImageColor3 = Color3.new(1,1,1),
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0.5, -7, 0.5, -7),
                BackgroundTransparency = 1,
                ImageTransparency = State and 0 or 1
            })

            local function Toggle()
                State = not State
                Utility:PlaySound(Assets.Sounds.Click)
                Utility:Ripple(Frame)
                
                local targetColor = State and Theme.Accent or Color3.fromRGB(40,40,40)
                Utility:Tween(Checkbox, TweenInfo.new(0.2), {BackgroundColor3 = targetColor})
                Utility:Tween(CheckIcon, TweenInfo.new(0.2), {ImageTransparency = State and 0 or 1})
                
                Callback(State)
            end

            Frame.MouseButton1Click:Connect(Toggle)
        end
        
        function Elements:Slider(options)
            local Name = options.Name or "Slider"
            local Min, Max = options.Min or 0, options.Max or 100
            local Default = options.Default or Min
            local Callback = options.Callback or function() end
            
            local Value = Default
            
            local Frame = Utility:Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.Item,
                Size = UDim2.new(1, 0, 0, 55)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Frame})
            
            local Text = Utility:Create("TextLabel", {
                Parent = Frame,
                Text = Name,
                TextColor3 = Theme.Text,
                Font = Theme.FontMain,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValText = Utility:Create("TextLabel", {
                Parent = Frame,
                Text = tostring(Value),
                TextColor3 = Theme.SubText,
                Font = Theme.FontMain,
                TextSize = 12,
                Position = UDim2.new(1, -50, 0, 8),
                Size = UDim2.new(0, 40, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local BarBack = Utility:Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = Color3.fromRGB(40,40,40),
                Size = UDim2.new(1, -24, 0, 4),
                Position = UDim2.new(0, 12, 0, 36)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = BarBack})
            
            local Fill = Utility:Create("Frame", {
                Parent = BarBack,
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((Value-Min)/(Max-Min), 0, 1, 0)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Fill})
            
            local Knob = Utility:Create("Frame", {
                Parent = Fill,
                BackgroundColor3 = Color3.new(1,1,1),
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(1, -6, 0.5, -6)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Knob})
            
            local DragBtn = Utility:Create("TextButton", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                Text = ""
            })
            
            local Dragging = false
            
            local function Update(input)
                local SizeX = BarBack.AbsoluteSize.X
                local PosX = BarBack.AbsolutePosition.X
                local MouseX = math.clamp(input.Position.X - PosX, 0, SizeX)
                local Percent = MouseX / SizeX
                Value = math.floor(Min + ((Max - Min) * Percent))
                
                ValText.Text = tostring(Value)
                Utility:Tween(Fill, TweenInfo.new(0.05), {Size = UDim2.new(Percent, 0, 1, 0)})
                Callback(Value)
            end
            
            DragBtn.MouseButton1Down:Connect(function() 
                Dragging = true 
                Utility:Tween(Knob, TweenInfo.new(0.1), {Size = UDim2.new(0,16,0,16), Position = UDim2.new(1,-8,0.5,-8)})
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                    Dragging = false 
                    Utility:Tween(Knob, TweenInfo.new(0.1), {Size = UDim2.new(0,12,0,12), Position = UDim2.new(1,-6,0.5,-6)})
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
        end

        function Elements:Dropdown(options)
            local Name = options.Name or "Dropdown"
            local Items = options.Items or {}
            local Callback = options.Callback or function() end
            
            local Frame = Utility:Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = Theme.Item,
                Size = UDim2.new(1, 0, 0, 42),
                AutoButtonColor = false,
                Text = ""
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Frame})
            
            local Text = Utility:Create("TextLabel", {
                Parent = Frame,
                Text = Name .. ": " .. (Items[1] or "None"),
                TextColor3 = Theme.Text,
                Font = Theme.FontMain,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Arrow = Utility:Create("ImageLabel", {
                Parent = Frame,
                Image = Assets.Icons.Arrow,
                ImageColor3 = Theme.SubText,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -28, 0.5, -8),
                BackgroundTransparency = 1
            })

            -- THE FLOATING OVERLAY LOGIC
            local Open = false
            
            -- This DropFrame lives in OverlayContainer, NOT inside the scroll frame
            local DropFrame = Utility:Create("Frame", {
                Parent = OverlayContainer,
                BackgroundColor3 = Theme.Sidebar,
                Size = UDim2.new(0, 0, 0, 0), -- Animated later
                Visible = false,
                ClipsDescendants = true,
                ZIndex = 105
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropFrame})
            Utility:Create("UIStroke", {Parent = DropFrame, Color = Theme.Border, Thickness = 1})
            
            local DropScroll = Utility:Create("ScrollingFrame", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                CanvasSize = UDim2.new(0,0,0,0),
                ScrollBarThickness = 2
            })
            local DropLayout = Utility:Create("UIListLayout", {
                Parent = DropScroll,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2)
            })
            
            DropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropScroll.CanvasSize = UDim2.new(0,0,0, DropLayout.AbsoluteContentSize.Y)
            end)

            local function RefreshItems()
                for _, v in pairs(DropScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                
                for _, item in pairs(Items) do
                    local ItemBtn = Utility:Create("TextButton", {
                        Parent = DropScroll,
                        BackgroundColor3 = Theme.Item,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 30),
                        Text = "  " .. item,
                        TextColor3 = Theme.SubText,
                        Font = Theme.FontMain,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = false
                    })
                    
                    ItemBtn.MouseEnter:Connect(function()
                        Utility:Tween(ItemBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text, BackgroundTransparency = 0.8})
                    end)
                    ItemBtn.MouseLeave:Connect(function()
                        Utility:Tween(ItemBtn, TweenInfo.new(0.2), {TextColor3 = Theme.SubText, BackgroundTransparency = 1})
                    end)
                    
                    ItemBtn.MouseButton1Click:Connect(function()
                        Text.Text = Name .. ": " .. item
                        Callback(item)
                        -- Close dropdown
                        Open = false
                        Utility:Tween(Arrow, TweenInfo.new(0.3), {Rotation = 0})
                        Utility:Tween(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, Frame.AbsoluteSize.X, 0, 0)})
                        task.wait(0.2)
                        DropFrame.Visible = false
                    end)
                end
            end

            Frame.MouseButton1Click:Connect(function()
                Open = not Open
                Utility:Ripple(Frame)
                RefreshItems()
                
                if Open then
                    DropFrame.Visible = true
                    DropFrame.Position = UDim2.new(0, Frame.AbsolutePosition.X, 0, Frame.AbsolutePosition.Y + 45)
                    DropFrame.Size = UDim2.new(0, Frame.AbsoluteSize.X, 0, 0)
                    
                    Utility:Tween(Arrow, TweenInfo.new(0.3), {Rotation = 180})
                    Utility:Tween(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, Frame.AbsoluteSize.X, 0, math.min(#Items * 32, 150))
                    })
                else
                    Utility:Tween(Arrow, TweenInfo.new(0.3), {Rotation = 0})
                    Utility:Tween(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, Frame.AbsoluteSize.X, 0, 0)})
                    task.wait(0.2)
                    DropFrame.Visible = false
                end
            end)
            
            -- Update position if scrolling
            RunService.RenderStepped:Connect(function()
                if Open and Frame.Visible then
                    DropFrame.Position = UDim2.new(0, Frame.AbsolutePosition.X, 0, Frame.AbsolutePosition.Y + 45)
                elseif Open and not Frame.Visible then
                    -- Hide if scrolled out of view
                    DropFrame.Visible = false
                    Open = false
                end
            end)
        end
        
        function Elements:ColorPicker(options)
             -- Basic implementation for structure
             -- Color pickers are large, so keeping this minimal for the "God Mode" script size limit
             -- It creates a button that opens a modal color picker
             local Name = options.Name or "Color"
             local Default = options.Default or Color3.new(1,1,1)
             local Callback = options.Callback or function() end
             
             local Frame = Utility:Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = Theme.Item,
                Size = UDim2.new(1, 0, 0, 42),
                AutoButtonColor = false,
                Text = ""
             })
             Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Frame})
             
             local Text = Utility:Create("TextLabel", {
                Parent = Frame,
                Text = Name,
                TextColor3 = Theme.Text,
                Font = Theme.FontMain,
                TextSize = 14,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Preview = Utility:Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = Default,
                Size = UDim2.new(0, 24, 0, 24),
                Position = UDim2.new(1, -36, 0.5, -12)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Preview})
            
            Frame.MouseButton1Click:Connect(function()
                Library:Notify({Title = "Color Picker", Content = "Feature placeholder for concise code.", Duration = 2})
                Callback(Default) -- Just triggers callback for now
            end)
        end

        return Elements
    end
    
    return WindowAPI
end

return Library
