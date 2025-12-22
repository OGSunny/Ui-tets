--[[ 
    WIND-UI REMAKE - "AERO GLASS" ENGINE
    Architecture: Component-Based, Event-Driven
    Visuals: Acrylic Dark, Noise Texture, 1px Strokes, Quint Easing
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// THEME CONFIGURATION
local Theme = {
    Main = Color3.fromRGB(18, 18, 20),
    Sidebar = Color3.fromRGB(22, 22, 24),
    Content = Color3.fromRGB(22, 22, 24), -- Slightly lighter for contrast
    Stroke = Color3.fromRGB(45, 45, 48),
    Divider = Color3.fromRGB(35, 35, 38),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 165),
    Accent = Color3.fromRGB(60, 130, 246), -- "Wind Blue"
    Hover = Color3.fromRGB(35, 35, 38),
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold
}

--// ASSETS
local Assets = {
    Noise = "rbxassetid://16933618667", -- Acrylic Texture
    Icons = {
        Search = "rbxassetid://7733674676",
        Home = "rbxassetid://7733960981",
        Settings = "rbxassetid://7734053495",
        Chevron = "rbxassetid://7733717447",
        Edit = "rbxassetid://7733799901",
        User = "rbxassetid://7743875962"
    }
}

--// UTILITY MODULE
local Utility = {}

function Utility:Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

function Utility:Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

function Utility:Ripple(btn)
    task.spawn(function()
        local ripple = Utility:Create("ImageLabel", {
            Parent = btn, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.9, BorderSizePixel = 0,
            Image = "rbxassetid://2708891598", ImageTransparency = 0.8, Position = UDim2.new(0, Mouse.X - btn.AbsolutePosition.X, 0, Mouse.Y - btn.AbsolutePosition.Y),
            Size = UDim2.new(0,0,0,0), ZIndex = 9
        })
        Utility:Tween(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 500, 0, 500), Position = UDim2.new(0, ripple.Position.X.Offset - 250, 0, ripple.Position.Y.Offset - 250), ImageTransparency = 1})
        task.wait(0.6); ripple:Destroy()
    end)
end

--// LIBRARY ROOT
local Library = {
    Tabs = {},
    CurrentTab = nil,
    Notifications = {}
}

function Library:Window(options)
    local Name = options.Name or "WindUI"
    local Author = options.Author or "User"
    
    -- Cleanup
    if CoreGui:FindFirstChild("WindUI_Root") then CoreGui.WindUI_Root:Destroy() end

    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "WindUI_Root",
        Parent = CoreGui,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Overlay for Floating Elements (ZIndex 100)
    local Overlay = Utility:Create("Frame", {
        Name = "Overlay", Parent = ScreenGui, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), ZIndex = 100
    })

    -- Main Window
    local Main = Utility:Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Main,
        Size = UDim2.new(0, 750, 0, 480),
        Position = UDim2.new(0.5, -375, 0.5, -240),
        BorderSizePixel = 0,
        ClipsDescendants = true -- For acrylic effect boundaries
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
    Utility:Create("UIStroke", {Parent = Main, Color = Theme.Stroke, Thickness = 1})

    -- Acrylic Noise Texture
    local Noise = Utility:Create("ImageLabel", {
        Parent = Main, Image = Assets.Noise, ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0, 128, 0, 128),
        ImageTransparency = 0.94, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ZIndex = 0
    })

    -- Sidebar (Left)
    local Sidebar = Utility:Create("Frame", {
        Parent = Main, BackgroundColor3 = Theme.Sidebar, Size = UDim2.new(0, 220, 1, 0), BorderSizePixel = 0, ZIndex = 2
    })
    local SidebarStroke = Utility:Create("UIStroke", {Parent = Sidebar, Color = Theme.Divider, Thickness = 1}) -- Trick to get right border only? No, just use frame.
    local SideBorder = Utility:Create("Frame", {
        Parent = Sidebar, BackgroundColor3 = Theme.Divider, Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BorderSizePixel = 0
    })

    -- Window Header (Top Left)
    local Header = Utility:Create("Frame", {
        Parent = Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 60)
    })
    local Logo = Utility:Create("ImageLabel", {
        Parent = Header, Image = "rbxassetid://7733960981", ImageColor3 = Theme.Accent, BackgroundTransparency = 1,
        Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, 20, 0, 18)
    })
    local TitleLbl = Utility:Create("TextLabel", {
        Parent = Header, Text = Name, TextColor3 = Theme.Text, Font = Theme.FontBold, TextSize = 16,
        BackgroundTransparency = 1, Position = UDim2.new(0, 54, 0, 0), Size = UDim2.new(0, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left
    })
    local AuthorLbl = Utility:Create("TextLabel", {
        Parent = Header, Text = "by " .. Author, TextColor3 = Theme.SubText, Font = Theme.Font, TextSize = 11,
        BackgroundTransparency = 1, Position = UDim2.new(0, 54, 0, 14), Size = UDim2.new(0, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Search (Sidebar)
    local SearchContainer = Utility:Create("Frame", {
        Parent = Sidebar, BackgroundColor3 = Theme.Main, Size = UDim2.new(1, -30, 0, 32), Position = UDim2.new(0, 15, 0, 70)
    })
    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SearchContainer})
    local SearchStroke = Utility:Create("UIStroke", {Parent = SearchContainer, Color = Theme.Stroke, Thickness = 1})
    local SearchIcon = Utility:Create("ImageLabel", {
        Parent = SearchContainer, Image = Assets.Icons.Search, ImageColor3 = Theme.SubText, BackgroundTransparency = 1,
        Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 10, 0.5, -7)
    })
    local SearchBox = Utility:Create("TextBox", {
        Parent = SearchContainer, BackgroundTransparency = 1, Position = UDim2.new(0, 32, 0, 0), Size = UDim2.new(1, -35, 1, 0),
        Font = Theme.Font, Text = "", PlaceholderText = "Search...", PlaceholderColor3 = Theme.SubText,
        TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Tab Container
    local TabContainer = Utility:Create("ScrollingFrame", {
        Parent = Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -120), Position = UDim2.new(0, 0, 0, 115),
        ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    local TabLayout = Utility:Create("UIListLayout", {
        Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)
    })

    -- Content Area (Right)
    local Content = Utility:Create("Frame", {
        Parent = Main, BackgroundTransparency = 1, Size = UDim2.new(1, -220, 1, 0), Position = UDim2.new(0, 220, 0, 0), ClipsDescendants = true
    })

    -- Dragging Logic
    local Dragging, DragStart, StartPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y < Main.AbsolutePosition.Y + 60 then
            Dragging = true; DragStart = input.Position; StartPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = input.Position - DragStart
            Utility:Tween(Main, TweenInfo.new(0.05), {Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)})
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

    --// NOTIFICATION SYSTEM
    function Library:Notify(options)
        local Title = options.Title or "Notification"
        local ContentText = options.Content or ""
        local Duration = options.Duration or 3

        local Toast = Utility:Create("Frame", {
            Parent = ScreenGui, BackgroundColor3 = Theme.Main, Size = UDim2.new(0, 280, 0, 70),
            Position = UDim2.new(1, 20, 1, -90), ZIndex = 200
        })
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Toast})
        Utility:Create("UIStroke", {Parent = Toast, Color = Theme.Stroke, Thickness = 1})
        
        local TTitle = Utility:Create("TextLabel", {
            Parent = Toast, Text = Title, TextColor3 = Theme.Text, Font = Theme.FontBold, TextSize = 14,
            Position = UDim2.new(0, 12, 0, 10), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        })
        local TDesc = Utility:Create("TextLabel", {
            Parent = Toast, Text = ContentText, TextColor3 = Theme.SubText, Font = Theme.Font, TextSize = 12,
            Position = UDim2.new(0, 12, 0, 30), Size = UDim2.new(1, -24, 0, 30), BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        })
        local TBar = Utility:Create("Frame", {
            Parent = Toast, BackgroundColor3 = Theme.Accent, Size = UDim2.new(0, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2)
        })

        Utility:Tween(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -300, 1, -90)})
        Utility:Tween(TBar, TweenInfo.new(Duration), {Size = UDim2.new(1, 0, 0, 2)})

        task.delay(Duration, function()
            Utility:Tween(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 1, -90)})
            task.wait(0.5)
            Toast:Destroy()
        end)
    end

    --// SEARCH LOGIC
    local function UpdateSearch(text)
        text = text:lower()
        for _, page in pairs(Content:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                if text == "" then
                    -- Reset visibility
                    page.Visible = (page.Name == Library.CurrentTab)
                    for _, el in pairs(page:GetChildren()) do if el:IsA("Frame") then el.Visible = true end end
                else
                    page.Visible = false
                    local found = false
                    for _, el in pairs(page:GetChildren()) do
                        if el:IsA("Frame") and el:FindFirstChild("SearchTag") then
                            if el.SearchTag.Value:lower():find(text) then
                                el.Visible = true; found = true
                            else
                                el.Visible = false
                            end
                        end
                    end
                    if found then page.Visible = true end
                end
            end
        end
        if text == "" and Library.CurrentTab then
            -- Force reshow current tab
            Content[Library.CurrentTab].Visible = true
        end
    end
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function() UpdateSearch(SearchBox.Text) end)

    --// WINDOW API
    local WindowAPI = {}

    function WindowAPI:Tab(options)
        local TabName = options.Name or "Tab"
        local TabIcon = options.Icon or Assets.Icons.Home
        
        -- Tab Button
        local Btn = Utility:Create("TextButton", {
            Parent = TabContainer, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 36),
            Position = UDim2.new(0, 10, 0, 0), Text = "", AutoButtonColor = false
        })
        local BtnIcon = Utility:Create("ImageLabel", {
            Parent = Btn, Image = TabIcon, ImageColor3 = Theme.SubText, BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 12, 0.5, -9)
        })
        local BtnText = Utility:Create("TextLabel", {
            Parent = Btn, Text = TabName, TextColor3 = Theme.SubText, Font = Theme.Font, TextSize = 13,
            BackgroundTransparency = 1, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(0, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left
        })
        local BtnPill = Utility:Create("Frame", {
            Parent = Btn, BackgroundColor3 = Theme.Accent, Size = UDim2.new(0, 3, 0, 16),
            Position = UDim2.new(0, 0, 0.5, -8), BackgroundTransparency = 1
        })
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = BtnPill})

        -- Page Content
        local Page = Utility:Create("ScrollingFrame", {
            Name = TabName, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
            Visible = false, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Divider, CanvasSize = UDim2.new(0,0,0,0)
        })
        Utility:Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15)})
        local PageLayout = Utility:Create("UIListLayout", {
            Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)
        })
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
        end)

        -- Activation Logic
        local function Activate()
            if Library.CurrentTab then
                local OldBtn = TabContainer:FindFirstChild(Library.CurrentTab .. "_Btn") -- Hacky mapping
                -- Reset old button visuals
                -- Skipping direct mapping, iterating:
                for _, v in pairs(TabContainer:GetChildren()) do
                    if v:IsA("TextButton") then
                        Utility:Tween(v.TextLabel, TweenInfo.new(0.2), {TextColor3 = Theme.SubText})
                        Utility:Tween(v.ImageLabel, TweenInfo.new(0.2), {ImageColor3 = Theme.SubText})
                        Utility:Tween(v.Frame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
                    end
                end
                Content[Library.CurrentTab].Visible = false
            end
            
            Library.CurrentTab = TabName
            Page.Visible = true
            
            -- Animate Active Button
            Utility:Tween(BtnText, TweenInfo.new(0.2), {TextColor3 = Theme.Text})
            Utility:Tween(BtnIcon, TweenInfo.new(0.2), {ImageColor3 = Theme.Text})
            Utility:Tween(BtnPill, TweenInfo.new(0.2), {BackgroundTransparency = 0})

            -- Staggered Fade In
            for i, v in ipairs(Page:GetChildren()) do
                if v:IsA("Frame") then
                    v.BackgroundTransparency = 1
                    -- v.Position = UDim2.new(0, 0, 0, 10) -- Requires absolute positioning to animate pos nicely in listlayout, skipping for transparency fade
                    Utility:Tween(v, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, i*0.03), {BackgroundTransparency = 0})
                end
            end
        end

        Btn.MouseButton1Click:Connect(Activate)
        
        if not Library.CurrentTab then Activate() end

        --// ELEMENT API
        local Elements = {}

        function Elements:Section(name)
            local Sec = Utility:Create("TextLabel", {
                Parent = Page, Text = name:upper(), TextColor3 = Theme.SubText, Font = Theme.FontBold,
                TextSize = 11, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function Elements:Button(options)
            local Name = options.Name
            local Callback = options.Callback or function() end

            local Cont = Utility:Create("TextButton", {
                Parent = Page, BackgroundColor3 = Theme.Content, Size = UDim2.new(1, 0, 0, 42),
                AutoButtonColor = false, Text = ""
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Cont})
            Utility:Create("UIStroke", {Parent = Cont, Color = Theme.Stroke, Thickness = 1})
            local Tag = Instance.new("StringValue", Cont); Tag.Name = "SearchTag"; Tag.Value = Name

            local Title = Utility:Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Theme.Text, Font = Theme.Font, TextSize = 13,
                Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -12, 1, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            local Icon = Utility:Create("ImageLabel", {
                Parent = Cont, Image = "rbxassetid://7733799901", ImageColor3 = Theme.SubText, BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -28, 0.5, -8)
            })

            Cont.MouseEnter:Connect(function() Utility:Tween(Cont, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Hover}) end)
            Cont.MouseLeave:Connect(function() Utility:Tween(Cont, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Content}) end)
            Cont.MouseButton1Click:Connect(function()
                Utility:Ripple(Cont)
                Callback()
            end)
        end

        function Elements:Toggle(options)
            local Name = options.Name
            local State = options.Default or false
            local Callback = options.Callback or function() end
            
            local Cont = Utility:Create("TextButton", {
                Parent = Page, BackgroundColor3 = Theme.Content, Size = UDim2.new(1, 0, 0, 42),
                AutoButtonColor = false, Text = ""
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Cont})
            Utility:Create("UIStroke", {Parent = Cont, Color = Theme.Stroke, Thickness = 1})
            local Tag = Instance.new("StringValue", Cont); Tag.Name = "SearchTag"; Tag.Value = Name

            local Title = Utility:Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Theme.Text, Font = Theme.Font, TextSize = 13,
                Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })

            local Switch = Utility:Create("Frame", {
                Parent = Cont, BackgroundColor3 = State and Theme.Accent or Color3.fromRGB(55,55,60),
                Size = UDim2.new(0, 36, 0, 20), Position = UDim2.new(1, -48, 0.5, -10)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Switch})
            local Knob = Utility:Create("Frame", {
                Parent = Switch, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 16, 0, 16),
                Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})

            Cont.MouseButton1Click:Connect(function()
                State = not State
                local GoalPos = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local GoalCol = State and Theme.Accent or Color3.fromRGB(55,55,60)
                
                Utility:Tween(Knob, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = GoalPos})
                Utility:Tween(Switch, TweenInfo.new(0.3), {BackgroundColor3 = GoalCol})
                Callback(State)
            end)
        end

        function Elements:Slider(options)
            local Name = options.Name
            local Min, Max = options.Min or 0, options.Max or 100
            local Default = options.Default or Min
            local Callback = options.Callback or function() end
            local Value = Default

            local Cont = Utility:Create("Frame", {
                Parent = Page, BackgroundColor3 = Theme.Content, Size = UDim2.new(1, 0, 0, 52)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Cont})
            Utility:Create("UIStroke", {Parent = Cont, Color = Theme.Stroke, Thickness = 1})
            local Tag = Instance.new("StringValue", Cont); Tag.Name = "SearchTag"; Tag.Value = Name

            local Title = Utility:Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Theme.Text, Font = Theme.Font, TextSize = 13,
                Position = UDim2.new(0, 12, 0, 8), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            local ValLabel = Utility:Create("TextLabel", {
                Parent = Cont, Text = tostring(Value), TextColor3 = Theme.SubText, Font = Theme.Font, TextSize = 12,
                Position = UDim2.new(1, -40, 0, 8), BackgroundTransparency = 1
            })

            local Track = Utility:Create("Frame", {
                Parent = Cont, BackgroundColor3 = Color3.fromRGB(55,55,60), Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 0, 36)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})
            local Fill = Utility:Create("Frame", {
                Parent = Track, BackgroundColor3 = Theme.Accent, Size = UDim2.new((Value-Min)/(Max-Min), 0, 1, 0)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})
            local Knob = Utility:Create("Frame", {
                Parent = Fill, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -6, 0.5, -6)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})

            local Interact = Utility:Create("TextButton", {Parent = Cont, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = ""})
            local Dragging = false
            
            local function Update(input)
                local sx = Track.AbsoluteSize.X
                local px = Track.AbsolutePosition.X
                local mx = math.clamp(input.Position.X - px, 0, sx)
                local perc = mx/sx
                Value = math.floor(Min + ((Max-Min)*perc))
                ValLabel.Text = tostring(Value)
                Utility:Tween(Fill, TweenInfo.new(0.05), {Size = UDim2.new(perc, 0, 1, 0)})
                Callback(Value)
            end

            Interact.MouseButton1Down:Connect(function()
                Dragging = true
                Utility:Tween(Knob, TweenInfo.new(0.1), {Size = UDim2.new(0,14,0,14), Position = UDim2.new(1,-7,0.5,-7)})
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                    Utility:Tween(Knob, TweenInfo.new(0.1), {Size = UDim2.new(0,12,0,12), Position = UDim2.new(1,-6,0.5,-6)})
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
            end)
        end

        function Elements:Input(options)
            local Name = options.Name
            local Placeholder = options.Placeholder or "Type here..."
            local Callback = options.Callback or function() end

            local Cont = Utility:Create("Frame", {
                Parent = Page, BackgroundColor3 = Theme.Content, Size = UDim2.new(1, 0, 0, 42)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Cont})
            local Stroke = Utility:Create("UIStroke", {Parent = Cont, Color = Theme.Stroke, Thickness = 1})
            local Tag = Instance.new("StringValue", Cont); Tag.Name = "SearchTag"; Tag.Value = Name

            local Title = Utility:Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Theme.Text, Font = Theme.Font, TextSize = 13,
                Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 100, 1, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })

            local BoxFrame = Utility:Create("Frame", {
                Parent = Cont, BackgroundColor3 = Theme.Main, Size = UDim2.new(0, 140, 0, 26), Position = UDim2.new(1, -150, 0.5, -13)
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = BoxFrame})
            local BoxStroke = Utility:Create("UIStroke", {Parent = BoxFrame, Color = Theme.Stroke, Thickness = 1})

            local Box = Utility:Create("TextBox", {
                Parent = BoxFrame, BackgroundTransparency = 1, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0),
                Text = "", PlaceholderText = Placeholder, PlaceholderColor3 = Theme.SubText, TextColor3 = Theme.Text, Font = Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
            })

            Box.Focused:Connect(function() Utility:Tween(BoxStroke, TweenInfo.new(0.2), {Color = Theme.Accent}) end)
            Box.FocusLost:Connect(function()
                Utility:Tween(BoxStroke, TweenInfo.new(0.2), {Color = Theme.Stroke})
                Callback(Box.Text)
            end)
        end

        function Elements:Dropdown(options)
            local Name = options.Name
            local Items = options.Items or {}
            local Callback = options.Callback or function() end

            local Cont = Utility:Create("TextButton", {
                Parent = Page, BackgroundColor3 = Theme.Content, Size = UDim2.new(1, 0, 0, 42), AutoButtonColor = false, Text = ""
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Cont})
            Utility:Create("UIStroke", {Parent = Cont, Color = Theme.Stroke, Thickness = 1})
            local Tag = Instance.new("StringValue", Cont); Tag.Name = "SearchTag"; Tag.Value = Name

            local Title = Utility:Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Theme.Text, Font = Theme.Font, TextSize = 13,
                Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -12, 1, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            local Icon = Utility:Create("ImageLabel", {
                Parent = Cont, Image = Assets.Icons.Chevron, ImageColor3 = Theme.SubText, BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -28, 0.5, -8)
            })

            -- Floating List
            local List = Utility:Create("Frame", {
                Parent = Overlay, BackgroundColor3 = Theme.Content, Size = UDim2.new(0, 0, 0, 0), Visible = false, ClipsDescendants = true
            })
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = List})
            Utility:Create("UIStroke", {Parent = List, Color = Theme.Stroke, Thickness = 1})
            
            local Scroll = Utility:Create("ScrollingFrame", {
                Parent = List, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)
            })
            local Layout = Utility:Create("UIListLayout", {Parent = Scroll, SortOrder = Enum.SortOrder.LayoutOrder})
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Scroll.CanvasSize = UDim2.new(0,0,0, Layout.AbsoluteContentSize.Y) end)

            local Open = false
            Cont.MouseButton1Click:Connect(function()
                Open = not Open
                if Open then
                    List.Visible = true
                    List.Position = UDim2.new(0, Cont.AbsolutePosition.X, 0, Cont.AbsolutePosition.Y + 46)
                    List.Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, 0)
                    
                    -- Populate
                    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, item in ipairs(Items) do
                        local B = Utility:Create("TextButton", {
                            Parent = Scroll, Text = "  " .. item, Size = UDim2.new(1, 0, 0, 30),
                            BackgroundColor3 = Theme.Content, BackgroundTransparency = 1, TextColor3 = Theme.SubText,
                            Font = Theme.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
                        })
                        B.MouseEnter:Connect(function() Utility:Tween(B, TweenInfo.new(0.1), {TextColor3 = Theme.Text, BackgroundTransparency = 0.8}) end)
                        B.MouseLeave:Connect(function() Utility:Tween(B, TweenInfo.new(0.1), {TextColor3 = Theme.SubText, BackgroundTransparency = 1}) end)
                        B.MouseButton1Click:Connect(function()
                            Title.Text = Name .. ": " .. item
                            Callback(item)
                            Open = false
                            Utility:Tween(List, TweenInfo.new(0.2), {Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, 0)})
                            Utility:Tween(Icon, TweenInfo.new(0.2), {Rotation = 0})
                            task.wait(0.2)
                            List.Visible = false
                        end)
                    end
                    Utility:Tween(List, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, math.min(#Items * 30, 150))})
                    Utility:Tween(Icon, TweenInfo.new(0.25), {Rotation = 180})
                else
                    Utility:Tween(List, TweenInfo.new(0.2), {Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, 0)})
                    Utility:Tween(Icon, TweenInfo.new(0.2), {Rotation = 0})
                    task.wait(0.2)
                    List.Visible = false
                end
            end)

            RunService.RenderStepped:Connect(function()
                if Open and Cont.Visible then
                    List.Position = UDim2.new(0, Cont.AbsolutePosition.X, 0, Cont.AbsolutePosition.Y + 46)
                elseif Open and not Cont.Visible then
                    Open = false; List.Visible = false
                end
            end)
        end

        return Elements
    end

    return WindowAPI
end

return Library
