--[[ 
    STELLAR HUB - THE ULTIMATE PVP UI LIBRARY 
    Designed for: PC, Mobile, Console
    Theme: Deep Dark & Cyan/Light Blue
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

--// Device Detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

--// Library Setup
local Library = {}
local Elements = {}
Library.theme = {
    main = Color3.fromRGB(15, 15, 20),
    sec = Color3.fromRGB(25, 25, 35),
    stroke = Color3.fromRGB(40, 40, 50),
    accent = Color3.fromRGB(100, 200, 255), -- Light Blue
    text = Color3.fromRGB(240, 240, 240),
    textdark = Color3.fromRGB(150, 150, 150)
}

--// Icons System
local Icons = {
    sword = "rbxassetid://7734021700",
    shield = "rbxassetid://7734000129",
    user = "rbxassetid://7743871002",
    settings = "rbxassetid://7733954760",
    eye = "rbxassetid://7734056813",
    home = "rbxassetid://7733779610",
    list = "rbxassetid://7733955511",
    star = "rbxassetid://7733955511",
    check = "rbxassetid://7733919105",
    warning = "rbxassetid://7733919369",
    info = "rbxassetid://7733911828"
}

--// Utility Functions
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPos
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            TweenService:Create(object, TweenInfo.new(0.1), {Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)}):Play()
        end
    end)
end

--// Notification System
function Library:Notify(config)
    local holder = CoreGui:FindFirstChild("StellarNotifs")
    if not holder then
        holder = Create("ScreenGui", {Name = "StellarNotifs", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
        Create("Frame", {
            Name = "Container", Parent = holder, Position = UDim2.new(1, -20, 1, -20), AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 300, 1, 0), BackgroundTransparency = 1
        })
        Create("UIListLayout", {Parent = holder.Container, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})
    end

    local notif = Create("Frame", {
        Parent = holder.Container, BackgroundColor3 = Library.theme.sec, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = notif, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = notif, Color = Library.theme.accent, Thickness = 1, Transparency = 0.5})
    
    local title = Create("TextLabel", {
        Parent = notif, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamBold, Text = config.Title or "Notification", TextColor3 = Library.theme.accent, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    Create("TextLabel", {
        Parent = notif, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 28), Size = UDim2.new(1, -20, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        Font = Enum.Font.Gotham, Text = config.Content or "Message", TextColor3 = Library.theme.text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
    })

    -- Progress Bar
    local barInfo = Create("Frame", {Parent = notif, BackgroundColor3 = Library.theme.main, Size = UDim2.new(1, -20, 0, 4), Position = UDim2.new(0, 10, 1, -10), AnchorPoint = Vector2.new(0, 1)})
    Create("UICorner", {Parent = barInfo, CornerRadius = UDim.new(1, 0)})
    local bar = Create("Frame", {Parent = barInfo, BackgroundColor3 = Library.theme.accent, Size = UDim2.new(1, 0, 1, 0)})
    Create("UICorner", {Parent = bar, CornerRadius = UDim.new(1, 0)})

    -- Animation
    Create("UIPadding", {Parent = notif, PaddingBottom = UDim.new(0, 15)})
    TweenService:Create(bar, TweenInfo.new(config.Time or 5, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
    
    -- Close Logic
    local closeBtn = Create("TextButton", {
        Parent = notif, Text = "×", BackgroundTransparency = 1, TextColor3 = Library.theme.textdark,
        Position = UDim2.new(1, -25, 0, 5), Size = UDim2.new(0, 20, 0, 20), Font = Enum.Font.GothamBold, TextSize = 18
    })
    
    local function Remove()
        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.5)
        notif:Destroy()
    end

    closeBtn.MouseButton1Click:Connect(Remove)
    task.delay(config.Time or 5, Remove)
end

--// Main Window
function Library:CreateWindow(config)
    local Window = {}
    
    -- Main Gui
    local Screen = Create("ScreenGui", {Name = "StellarUI", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    local Main = Create("Frame", {
        Name = "Main", Parent = Screen, BackgroundColor3 = Library.theme.main, 
        Size = isMobile and UDim2.new(0, 600, 0, 350) or UDim2.new(0, 750, 0, 450),
        Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5)
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Color = Library.theme.stroke, Thickness = 2})
    
    -- Responsive Scale for Mobile
    if isMobile then
        Main.Size = UDim2.new(0.85, 0, 0.75, 0)
        -- Create Mobile Toggle
        local ToggleBtn = Create("ImageButton", {
            Parent = Screen, Name = "MobileToggle", BackgroundColor3 = Library.theme.sec,
            Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0.9, -60, 0.8, 0),
            Image = Icons.list, ImageColor3 = Library.theme.accent
        })
        Create("UICorner", {Parent = ToggleBtn, CornerRadius = UDim.new(1, 0)})
        Create("UIStroke", {Parent = ToggleBtn, Color = Library.theme.accent, Thickness = 2})
        MakeDraggable(ToggleBtn, ToggleBtn)
        
        ToggleBtn.MouseButton1Click:Connect(function()
            Main.Visible = not Main.Visible
        end)
    end
    
    MakeDraggable(Main, Main)

    -- Top Bar
    local TopBar = Create("Frame", {Parent = Main, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 50)})
    Create("TextLabel", {
        Parent = TopBar, Text = config.Name or "Stellar Hub", Font = Enum.Font.GothamBold, TextSize = 18,
        TextColor3 = Library.theme.accent, Position = UDim2.new(0, 20, 0, 0), Size = UDim2.new(0, 200, 1, 0), TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Right Side Info
    local InfoContainer = Create("Frame", {Parent = TopBar, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -15, 0, 10), Size = UDim2.new(0, 300, 1, -20), BackgroundTransparency = 1})
    local InfoLayout = Create("UIListLayout", {Parent = InfoContainer, FillDirection = Enum.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 10)})
    
    -- Close Button
    local CloseBtn = Create("TextButton", {Parent = InfoContainer, Text = "×", TextSize = 25, Font = Enum.Font.Gotham, BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255,100,100), Size = UDim2.new(0, 30, 0, 30)})
    CloseBtn.MouseButton1Click:Connect(function() Screen:Destroy() end)

    -- Min Button
    local MinBtn = Create("TextButton", {Parent = InfoContainer, Text = "−", TextSize = 25, Font = Enum.Font.Gotham, BackgroundTransparency = 1, TextColor3 = Library.theme.text, Size = UDim2.new(0, 30, 0, 30)})
    local Minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        TweenService:Create(Main, TweenInfo.new(0.3), {Size = Minimized and UDim2.new(0, Main.Size.X.Offset, 0, 50) or (isMobile and UDim2.new(0.85, 0, 0.75, 0) or UDim2.new(0, 750, 0, 450))}):Play()
        Main.ClipsDescendants = Minimized
    end)

    -- Key Badge
    local KeyBadge = Create("Frame", {Parent = InfoContainer, BackgroundColor3 = Library.theme.sec, Size = UDim2.new(0, 100, 0, 30)})
    Create("UICorner", {Parent = KeyBadge, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = KeyBadge, Color = Library.theme.accent, Thickness = 1})
    Create("TextLabel", {Parent = KeyBadge, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "Key: "..(config.KeyTime or "Lifetime"), Font = Enum.Font.GothamBold, TextColor3 = Library.theme.accent, TextSize = 11})

    -- User Avatar
    local UserImg = Create("ImageLabel", {Parent = InfoContainer, Size = UDim2.new(0, 30, 0, 30), BackgroundTransparency = 1, Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)})
    Create("UICorner", {Parent = UserImg, CornerRadius = UDim.new(1, 0)})

    -- Sidebar & Content
    local Sidebar = Create("ScrollingFrame", {Parent = Main, BackgroundColor3 = Library.theme.sec, Position = UDim2.new(0, 15, 0, 60), Size = UDim2.new(0, 160, 1, -75), ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y})
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 8)})
    Create("UIListLayout", {Parent = Sidebar, Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center})
    Create("UIPadding", {Parent = Sidebar, PaddingTop = UDim.new(0, 10)})

    local Content = Create("Frame", {Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 190, 0, 60), Size = UDim2.new(1, -205, 1, -20)})

    -- Bottom Profile
    local Profile = Create("Frame", {Parent = Main, BackgroundColor3 = Library.theme.sec, Position = UDim2.new(0, 15, 1, -60), Size = UDim2.new(0, 160, 0, 45)})
    Create("UICorner", {Parent = Profile, CornerRadius = UDim.new(0, 8)})
    local ProfImg = Create("ImageLabel", {Parent = Profile, Size = UDim2.new(0, 35, 0, 35), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, Image = UserImg.Image})
    Create("UICorner", {Parent = ProfImg, CornerRadius = UDim.new(1, 0)})
    Create("TextLabel", {Parent = Profile, Position = UDim2.new(0, 45, 0, 5), Size = UDim2.new(0, 100, 0, 20), BackgroundTransparency = 1, Text = Players.LocalPlayer.DisplayName, Font = Enum.Font.GothamBold, TextColor3 = Library.theme.text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
    Create("TextLabel", {Parent = Profile, Position = UDim2.new(0, 45, 0, 22), Size = UDim2.new(0, 100, 0, 15), BackgroundTransparency = 1, Text = "@"..Players.LocalPlayer.Name, Font = Enum.Font.Gotham, TextColor3 = Library.theme.textdark, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})

    -- Tabs System
    local firstTab = true
    
    function Window:CreateTab(tConfig)
        local TabName = tConfig.Name
        local TabIcon = Icons[tConfig.Icon] or tConfig.Icon or ""
        
        -- Tab Button
        local TabBtn = Create("TextButton", {
            Parent = Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 35),
            Text = "", AutoButtonColor = false
        })
        
        local TabBtnTitle = Create("TextLabel", {
            Parent = TabBtn, BackgroundTransparency = 1, Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 30, 0, 0),
            Text = TabName, Font = Enum.Font.GothamMedium, TextColor3 = Library.theme.textdark, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local TabBtnIcon = Create("ImageLabel", {
            Parent = TabBtn, BackgroundTransparency = 1, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 5, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
            Image = TabIcon, ImageColor3 = Library.theme.textdark
        })
        
        -- Tab Content
        local TabFrame = Create("ScrollingFrame", {
            Parent = Content, Visible = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2, ScrollBarImageColor3 = Library.theme.accent, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        Create("UIListLayout", {Parent = TabFrame, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
        Create("UIPadding", {Parent = TabFrame, PaddingRight = UDim.new(0, 10)})

        -- Selection Logic
        local function Activate()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextLabel.TextColor3 = Library.theme.textdark 
                    v.ImageLabel.ImageColor3 = Library.theme.textdark
                    TweenService:Create(v.TextLabel, TweenInfo.new(0.2), {TextColor3 = Library.theme.textdark}):Play()
                end 
            end
            TweenService:Create(TabBtnTitle, TweenInfo.new(0.2), {TextColor3 = Library.theme.accent}):Play()
            TabBtnIcon.ImageColor3 = Library.theme.accent
            TabFrame.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(Activate)
        
        if firstTab then Activate(); firstTab = false end

        -- Elements
        local TabFuncs = {}
        
        function TabFuncs:CreateSection(sConfig)
            local Section = Create("Frame", {Parent = TabFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30)})
            Create("TextLabel", {
                Parent = Section, Text = sConfig.Name, Font = Enum.Font.GothamBold, TextColor3 = Library.theme.textdark,
                Size = UDim2.new(1, 0, 1, 0), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0, 5, 0, 0)
            })
        end

        function TabFuncs:CreateToggle(eConfig)
            local ToggleVal = eConfig.CurrentValue or false
            local ToggleFrame = Create("Frame", {
                Parent = TabFrame, BackgroundColor3 = Library.theme.sec, Size = UDim2.new(1, 0, 0, 40)
            })
            Create("UICorner", {Parent = ToggleFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = ToggleFrame, Color = Library.theme.stroke, Thickness = 1})
            
            Create("TextLabel", {
                Parent = ToggleFrame, Text = eConfig.Name, Font = Enum.Font.GothamMedium, TextColor3 = Library.theme.text,
                Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
            })

            local Switch = Create("Frame", {
                Parent = ToggleFrame, BackgroundColor3 = Library.theme.main, Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5)
            })
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
            
            local Circle = Create("Frame", {
                Parent = Switch, BackgroundColor3 = Library.theme.textdark, Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 2, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5)
            })
            Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1, 0)})

            local Btn = Create("TextButton", {Parent = ToggleFrame, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""})
            
            local function Update()
                local targetPos = ToggleVal and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                local targetColor = ToggleVal and Library.theme.accent or Library.theme.textdark
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
                eConfig.Callback(ToggleVal)
            end
            
            if ToggleVal then Update() end

            Btn.MouseButton1Click:Connect(function()
                ToggleVal = not ToggleVal
                Update()
            end)
        end

        function TabFuncs:CreateSlider(eConfig)
            local SliderFrame = Create("Frame", {
                Parent = TabFrame, BackgroundColor3 = Library.theme.sec, Size = UDim2.new(1, 0, 0, 55)
            })
            Create("UICorner", {Parent = SliderFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = SliderFrame, Color = Library.theme.stroke, Thickness = 1})
            
            Create("TextLabel", {
                Parent = SliderFrame, Text = eConfig.Name, Font = Enum.Font.GothamMedium, TextColor3 = Library.theme.text,
                Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 0), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame, Text = tostring(eConfig.CurrentValue or eConfig.Range[1]), Font = Enum.Font.GothamBold, TextColor3 = Library.theme.accent,
                Size = UDim2.new(0, 50, 0, 25), Position = UDim2.new(1, -60, 0, 0), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right
            })

            local Bar = Create("Frame", {
                Parent = SliderFrame, BackgroundColor3 = Library.theme.main, Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 35)
            })
            Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(1, 0)})
            
            local Fill = Create("Frame", {
                Parent = Bar, BackgroundColor3 = Library.theme.accent, Size = UDim2.new(0, 0, 1, 0)
            })
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})

            local Trigger = Create("TextButton", {Parent = Bar, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""})
            
            local function Update(Input)
                local SizeScale = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local Value = math.floor(eConfig.Range[1] + ((eConfig.Range[2] - eConfig.Range[1]) * SizeScale))
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(SizeScale, 0, 1, 0)}):Play()
                ValueLabel.Text = tostring(Value)
                eConfig.Callback(Value)
            end
            
            -- Set initial value
            local initialVal = eConfig.CurrentValue or eConfig.Range[1]
            local initialScale = (initialVal - eConfig.Range[1]) / (eConfig.Range[2] - eConfig.Range[1])
            Fill.Size = UDim2.new(initialScale, 0, 1, 0)
            ValueLabel.Text = tostring(initialVal)

            local Dragging = false
            Trigger.InputBegan:Connect(function(i) 
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
                    Dragging = true; Update(i) 
                end 
            end)
            UserInputService.InputEnded:Connect(function(i) 
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
                    Dragging = false 
                end 
            end)
            UserInputService.InputChanged:Connect(function(i) 
                if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
                    Update(i) 
                end 
            end)
        end

        function TabFuncs:CreateButton(eConfig)
            local BtnFrame = Create("TextButton", {
                Parent = TabFrame, BackgroundColor3 = Library.theme.sec, Size = UDim2.new(1, 0, 0, 35),
                Text = "", AutoButtonColor = false
            })
            Create("UICorner", {Parent = BtnFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = BtnFrame, Color = Library.theme.stroke, Thickness = 1})
            
            local BtnText = Create("TextLabel", {
                Parent = BtnFrame, Text = eConfig.Name, Font = Enum.Font.GothamBold, TextColor3 = Library.theme.text,
                Size = UDim2.new(1, 0, 1, 0), TextSize = 13, BackgroundTransparency = 1
            })
            
            BtnFrame.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Library.theme.accent}):Play()
                TweenService:Create(BtnText, TweenInfo.new(0.1), {TextColor3 = Library.theme.main}):Play()
                task.wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Library.theme.sec}):Play()
                TweenService:Create(BtnText, TweenInfo.new(0.1), {TextColor3 = Library.theme.text}):Play()
                eConfig.Callback()
            end)
        end

        function TabFuncs:CreateDropdown(eConfig)
            local DropFrame = Create("Frame", {
                Parent = TabFrame, BackgroundColor3 = Library.theme.sec, Size = UDim2.new(1, 0, 0, 40), ClipsDescendants = true
            })
            Create("UICorner", {Parent = DropFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = DropFrame, Color = Library.theme.stroke, Thickness = 1})
            
            local Label = Create("TextLabel", {
                Parent = DropFrame, Text = eConfig.Name, Font = Enum.Font.GothamMedium, TextColor3 = Library.theme.text,
                Size = UDim2.new(1, -40, 0, 40), Position = UDim2.new(0, 10, 0, 0), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Arrow = Create("TextLabel", {
                Parent = DropFrame, Text = "▼", BackgroundTransparency = 1, TextColor3 = Library.theme.textdark,
                Size = UDim2.new(0, 30, 0, 40), Position = UDim2.new(1, -30, 0, 0), TextSize = 12
            })
            
            local Open = false
            local Trigger = Create("TextButton", {Parent = DropFrame, Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1, Text = ""})
            
            local ListLayout = Create("UIListLayout", {Parent = DropFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
            
            -- Padding for list
            Create("Frame", {Parent = DropFrame, Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1, LayoutOrder = 0})

            for _, option in pairs(eConfig.Options) do
                local OptBtn = Create("TextButton", {
                    Parent = DropFrame, BackgroundColor3 = Library.theme.main, Size = UDim2.new(1, -10, 0, 30),
                    Text = option, Font = Enum.Font.Gotham, TextColor3 = Library.theme.text, TextSize = 12, LayoutOrder = 1, AutoButtonColor = false
                })
                Create("UICorner", {Parent = OptBtn, CornerRadius = UDim.new(0, 4)})
                
                OptBtn.MouseButton1Click:Connect(function()
                    Label.Text = eConfig.Name .. ": " .. option
                    eConfig.Callback(option)
                    Open = false
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                end)
            end
            
            Trigger.MouseButton1Click:Connect(function()
                Open = not Open
                local Height = Open and (45 + (#eConfig.Options * 32)) or 40
                TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, Height)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = Open and 180 or 0}):Play()
            end)
        end
        
        function TabFuncs:CreateInput(eConfig)
            local InputFrame = Create("Frame", {
                Parent = TabFrame, BackgroundColor3 = Library.theme.sec, Size = UDim2.new(1, 0, 0, 40)
            })
            Create("UICorner", {Parent = InputFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = InputFrame, Color = Library.theme.stroke, Thickness = 1})
            
            Create("TextLabel", {
                Parent = InputFrame, Text = eConfig.Name, Font = Enum.Font.GothamMedium, TextColor3 = Library.theme.text,
                Size = UDim2.new(1, -110, 0, 40), Position = UDim2.new(0, 10, 0, 0), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local BoxContainer = Create("Frame", {
                Parent = InputFrame, BackgroundColor3 = Library.theme.main, Size = UDim2.new(0, 100, 0, 30), Position = UDim2.new(1, -105, 0, 5)
            })
            Create("UICorner", {Parent = BoxContainer, CornerRadius = UDim.new(0, 4)})
            
            local TextBox = Create("TextBox", {
                Parent = BoxContainer, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0),
                BackgroundTransparency = 1, Text = "", PlaceholderText = "...", Font = Enum.Font.Gotham,
                TextColor3 = Library.theme.text, PlaceholderColor3 = Library.theme.textdark, TextSize = 12
            })
            
            TextBox.FocusLost:Connect(function(enter)
                if enter then eConfig.Callback(TextBox.Text) end
            end)
        end

        return TabFuncs
    end
    
    return Window
end

return Library
