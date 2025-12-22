--[[ 
    ULTRA UI REFACTORED - "PREMIUM GLASSMORPHISM"
    Architecture: Vertical Sidebar, Spring Physics, Spotlight Borders, Staggered Loading
    Author: Refactored by AI
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// 1. THEME MANAGER & CONFIGURATION
local Library = {
    Connections = {},
    Flags = {},
    Unload = function() end,
    Open = true,
    Theme = {
        Background = Color3.fromRGB(20, 20, 25),
        Sidebar = Color3.fromRGB(25, 25, 30),
        Content = Color3.fromRGB(30, 30, 35),
        Accent = Color3.fromRGB(0, 160, 255), -- "Electric Blue"
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(160, 160, 160),
        Outline = Color3.fromRGB(60, 60, 70),
        ItemBG = Color3.fromRGB(40, 40, 45),
        Transparency = 0.1, -- Glass effect intensity
        Font = Enum.Font.GothamMedium,
        CornerRadius = UDim.new(0, 8)
    },
    Icons = {
        Search = "rbxassetid://6031154871",
        Home = "rbxassetid://6031068420",
        Settings = "rbxassetid://6031280882",
        User = "rbxassetid://6031280882", -- Placeholder
        Close = "rbxassetid://6031094678",
        Arrow = "rbxassetid://6034818372"
    }
}

--// 2. UTILITY & PHYSICS MODULES

-- [Simple Spring Module for Natural Physics]
local Spring = {}
Spring.__index = Spring

function Spring.new(final, speed, damper)
    local self = setmetatable({}, Spring)
    self.Target = final
    self.Current = final
    self.Velocity = 0
    self.Speed = speed or 10
    self.Damper = damper or 0.5
    return self
end

function Spring:Update(dt)
    local d = self.Target - self.Current
    local f = d * self.Speed
    self.Velocity = (self.Velocity + f) * self.Damper
    self.Current = self.Current + (self.Velocity * dt)
    return self.Current
end

-- [Spotlight/Gradient Mouse Effect]
local function ApplySpotlight(frame, stroke)
    -- Creates a "Glow" that follows the mouse on the border
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Library.Theme.Accent),
        ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1, Library.Theme.Accent)
    }
    Gradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.5), -- Light up near cursor
        NumberSequenceKeypoint.new(0.8, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    }
    Gradient.Rotation = 45
    Gradient.Parent = stroke

    local function Update()
        if not frame.Visible then return end
        
        -- Calculate angle relative to center of frame
        local center = frame.AbsolutePosition + (frame.AbsoluteSize / 2)
        local mousePos = UserInputService:GetMouseLocation()
        local angle = math.atan2(mousePos.Y - center.Y, mousePos.X - center.X)
        local degrees = math.deg(angle)
        
        -- Smooth rotation
        Gradient.Rotation = degrees + 90 -- Offset for UIGradient rotation quirks
    end
    
    table.insert(Library.Connections, RunService.RenderStepped:Connect(Update))
end

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

local function MakeDraggable(topbar, object)
    local Dragging, DragInput, DragStart, StartPos
    
    table.insert(Library.Connections, topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end))

    table.insert(Library.Connections, topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end))

    table.insert(Library.Connections, UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            local TargetPos = UDim2.new(
                StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
            )
            
            -- Use simple Lerp for drag, Spring is too floaty for window dragging
            TweenService:Create(object, TweenInfo.new(0.05), {Position = TargetPos}):Play()
        end
    end))
end

--// 3. MAIN UI CREATION
function Library:Window(options)
    local WindowName = options.Name or "Ultra UI"
    
    local ScreenGui = Create("ScreenGui", {
        Name = "UltraUI_Refactored",
        Parent = RunService:IsStudio() and Players.LocalPlayer.PlayerGui or CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Main Container (Glass Effect)
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Library.Theme.Background,
        BackgroundTransparency = Library.Theme.Transparency,
        Position = UDim2.new(0.5, -350, 0.5, -225),
        Size = UDim2.new(0, 700, 0, 450),
        BorderSizePixel = 0,
        ClipsDescendants = false -- Needed for spotlight glow outside
    })
    
    Create("UICorner", {CornerRadius = Library.Theme.CornerRadius, Parent = MainFrame})
    
    -- Outline with Spotlight
    local MainStroke = Create("UIStroke", {
        Parent = MainFrame,
        Color = Library.Theme.Outline,
        Thickness = 1.5,
        Transparency = 0.5
    })
    ApplySpotlight(MainFrame, MainStroke)

    -- Sidebar (Left)
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Library.Theme.Sidebar,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 200, 1, 0),
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = Library.Theme.CornerRadius, Parent = Sidebar})
    
    -- Fix Sidebar Corner (Left side rounded only logic workaround: Use frame to cover right corners)
    local SidebarCover = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Library.Theme.Sidebar,
        BackgroundTransparency = 1, -- Match Sidebar
        BorderSizePixel = 0,
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -10, 0, 0),
        ZIndex = 0
    })

    -- Sidebar Content
    local TitleLabel = Create("TextLabel", {
        Parent = Sidebar,
        Text = WindowName,
        TextColor3 = Library.Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 20, 0, 10),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Search Bar
    local SearchContainer = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Library.Theme.ItemBG,
        Size = UDim2.new(1, -30, 0, 30),
        Position = UDim2.new(0, 15, 0, 60),
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SearchContainer})
    Create("UIStroke", {Parent = SearchContainer, Color = Library.Theme.Outline, Thickness = 1})

    local SearchIcon = Create("ImageLabel", {
        Parent = SearchContainer,
        Image = Library.Icons.Search,
        ImageColor3 = Library.Theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 8, 0.5, -7)
    })

    local SearchBox = Create("TextBox", {
        Parent = SearchContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(1, -35, 1, 0),
        Font = Library.Theme.Font,
        PlaceholderText = "Search...",
        PlaceholderColor3 = Library.Theme.SubText,
        Text = "",
        TextColor3 = Library.Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Tab Container (Sidebar Buttons)
    local TabButtonContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 100),
        Size = UDim2.new(1, 0, 1, -160), -- Reserve space for Profile
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0) -- Auto resize
    })
    local TabListLayout = Create("UIListLayout", {
        Parent = TabButtonContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    -- Sliding Pill (Selection Indicator)
    local Pill = Create("Frame", {
        Parent = TabButtonContainer,
        BackgroundColor3 = Library.Theme.Accent,
        Size = UDim2.new(0, 3, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        Visible = false
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Pill})

    -- User Profile (Bottom Left)
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
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 10, 0.5, -15),
        Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Avatar})
    
    local Username = Create("TextLabel", {
        Parent = ProfileFrame,
        BackgroundTransparency = 1,
        Text = LocalPlayer.Name,
        TextColor3 = Library.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 50, 0.5, -8),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local Rank = Create("TextLabel", {
        Parent = ProfileFrame,
        BackgroundTransparency = 1,
        Text = "User", -- Placeholder
        TextColor3 = Library.Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 50, 0.5, 5),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Right Content Area
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 200, 0, 0),
        Size = UDim2.new(1, -200, 1, 0),
        ClipsDescendants = true
    })

    MakeDraggable(Sidebar, MainFrame)

    -- Keybind HUD
    local KeybindHUD = Create("Frame", {
        Name = "KeybindHUD",
        Parent = ScreenGui,
        BackgroundColor3 = Library.Theme.Background,
        BackgroundTransparency = 0.3,
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.new(0, 200, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = KeybindHUD})
    Create("UIStroke", {Parent = KeybindHUD, Color = Library.Theme.Outline, Thickness = 1})
    MakeDraggable(KeybindHUD, KeybindHUD)
    
    local KHUDList = Create("UIListLayout", {
        Parent = KeybindHUD,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })
    local KHUDTitle = Create("TextLabel", {
        Parent = KeybindHUD,
        Text = "Keybinds",
        TextColor3 = Library.Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1
    })

    -- Search Functionality logic
    local function FilterElements(text)
        text = text:lower()
        for _, page in pairs(ContentArea:GetChildren()) do
            if page:IsA("ScrollingFrame") and page.Visible then
                for _, element in pairs(page:GetChildren()) do
                    if element:IsA("Frame") and element:FindFirstChild("Title") then
                        local title = element.Title.Text:lower()
                        if text == "" or title:find(text) then
                            element.Visible = true
                        else
                            element.Visible = false
                        end
                    end
                end
                page.CanvasPosition = Vector2.new(0,0)
            end
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        FilterElements(SearchBox.Text)
    end)

    --// WINDOW LOGIC
    local Tabs = {}
    local FirstTab = true

    local function ToggleUI()
        Library.Open = not Library.Open
        MainFrame.Visible = Library.Open
    end
    
    table.insert(Library.Connections, UserInputService.InputBegan:Connect(function(input, gpe)
        if input.KeyCode == Enum.KeyCode.RightControl and not gpe then
            ToggleUI()
        end
    end))

    local WindowObj = {}

    function WindowObj:Tab(options)
        local TabName = options.Name or "Tab"
        local TabIcon = options.Icon or "rbxassetid://6031068420"
        
        -- Create Tab Button
        local TabBtn = Create("TextButton", {
            Parent = TabButtonContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 35),
            Position = UDim2.new(0, 10, 0, 0),
            Text = "",
            AutoButtonColor = false
        })
        
        local BtnIcon = Create("ImageLabel", {
            Parent = TabBtn,
            Image = TabIcon,
            ImageColor3 = Library.Theme.SubText,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 15, 0.5, -10)
        })
        
        local BtnText = Create("TextLabel", {
            Parent = TabBtn,
            Text = TabName,
            TextColor3 = Library.Theme.SubText,
            Font = Library.Theme.Font,
            TextSize = 14,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        -- Content Container
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
        
        local PageLayout = Create("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Activation Logic
        local function Activate()
            -- Reset others
            for _, t in pairs(Tabs) do
                TweenService:Create(t.BtnText, TweenInfo.new(0.3), {TextColor3 = Library.Theme.SubText}):Play()
                TweenService:Create(t.BtnIcon, TweenInfo.new(0.3), {ImageColor3 = Library.Theme.SubText}):Play()
                t.Page.Visible = false
            end
            
            -- Activate Self
            TweenService:Create(BtnText, TweenInfo.new(0.3), {TextColor3 = Library.Theme.Text}):Play()
            TweenService:Create(BtnIcon, TweenInfo.new(0.3), {ImageColor3 = Library.Theme.Accent}):Play()
            TabPage.Visible = true
            
            -- Pill Animation (Spring Physics simulated with easing)
            Pill.Visible = true
            TweenService:Create(Pill, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, TabBtn.LayoutOrder * 40 + 8) -- Approx layout calculation
            }):Play()

            -- Staggered Loading of Elements
            for i, child in ipairs(TabPage:GetChildren()) do
                if child:IsA("Frame") then
                    child.BackgroundTransparency = 1
                    local originalPos = child.Position -- assumes Layout handles X, we just animate Y offset or Transparency
                    
                    -- Initial hidden state (We have to rely on visual transparency because UIListLayout enforces position)
                    child.GroupTransparency = 1 
                    
                    task.delay(i * 0.04, function()
                       local tween = TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0})
                       tween:Play()
                       -- Optional: Slight upward drift if not using Layout, but Layout makes position tweens hard.
                       -- Instead we can tween a CanvasGroup transparency if we use CanvasGroups, but that can blur text.
                       -- Simulating fade-in via property loop:
                       for _, desc in pairs(child:GetDescendants()) do
                           if desc:IsA("TextLabel") or desc:IsA("ImageLabel") or desc:IsA("UIStroke") then
                               -- This is complex to restore original transparency. 
                               -- Simplified: Use CanvasGroup for elements.
                           end
                       end
                    end)
                end
            end
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        if FirstTab then
            FirstTab = false
            Activate()
        end

        table.insert(Tabs, {Btn = TabBtn, BtnText = BtnText, BtnIcon = BtnIcon, Page = TabPage})

        --// ELEMENTS
        local TabObj = {}
        
        function TabObj:Section(text)
            local SectionLabel = Create("TextLabel", {
                Parent = TabPage,
                Text = text,
                TextColor3 = Library.Theme.Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function TabObj:Button(options)
            local Name = options.Name or "Button"
            local Callback = options.Callback or function() end

            -- Use CanvasGroup for fading effects
            local ButtonFrame = Create("CanvasGroup", {
                Parent = TabPage,
                BackgroundColor3 = Library.Theme.ItemBG,
                Size = UDim2.new(1, 0, 0, 40),
                BorderSizePixel = 0,
                Name = Name .. "_Element" -- For search
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ButtonFrame})
            
            local Stroke = Create("UIStroke", {
                Parent = ButtonFrame,
                Color = Library.Theme.Outline,
                Thickness = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })

            local Title = Create("TextLabel", {
                Name = "Title",
                Parent = ButtonFrame,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                Font = Library.Theme.Font,
                TextSize = 14,
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Icon = Create("ImageLabel", {
                Parent = ButtonFrame,
                Image = Library.Icons.Arrow,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -30, 0.5, -8),
                BackgroundTransparency = 1,
                ImageColor3 = Library.Theme.SubText
            })

            local Interact = Create("TextButton", {
                Parent = ButtonFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            Interact.MouseButton1Click:Connect(function()
                -- Spring Animation on Click
                local s = Spring.new(0.95, 20, 0.5)
                task.spawn(function()
                    for i = 1, 30 do
                        local scale = s:Update(1/60)
                        ButtonFrame.Size = UDim2.new(scale, 0, 0, 40) -- Horizontal shrink effect
                        RunService.RenderStepped:Wait()
                    end
                    s.Target = 1
                    for i = 1, 30 do
                        local scale = s:Update(1/60)
                        ButtonFrame.Size = UDim2.new(scale, 0, 0, 40)
                        RunService.RenderStepped:Wait()
                    end
                    ButtonFrame.Size = UDim2.new(1, 0, 0, 40) -- Reset
                end)
                Callback()
            end)
            
            Interact.MouseEnter:Connect(function()
                TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Library.Theme.Accent}):Play()
            end)
            Interact.MouseLeave:Connect(function()
                TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Library.Theme.Outline}):Play()
            end)
        end

        function TabObj:Toggle(options)
            local Name = options.Name or "Toggle"
            local Default = options.Default or false
            local Callback = options.Callback or function() end
            
            local State = Default

            local ToggleFrame = Create("CanvasGroup", {
                Parent = TabPage,
                BackgroundColor3 = Library.Theme.ItemBG,
                Size = UDim2.new(1, 0, 0, 40),
                BorderSizePixel = 0,
                Name = Name .. "_Element"
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ToggleFrame})
            Create("UIStroke", {Parent = ToggleFrame, Color = Library.Theme.Outline, Thickness = 1})

            local Title = Create("TextLabel", {
                Name = "Title",
                Parent = ToggleFrame,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                Font = Library.Theme.Font,
                TextSize = 14,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SwitchBG = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = State and Library.Theme.Accent or Color3.fromRGB(60,60,60),
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10)
            })
            local SwitchUIC = Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SwitchBG})
            
            local SwitchDot = Create("Frame", {
                Parent = SwitchBG,
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                Size = UDim2.new(0, 16, 0, 16),
                Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SwitchDot})

            local Interact = Create("TextButton", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })

            local function Update()
                local TargetPos = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local TargetColor = State and Library.Theme.Accent or Color3.fromRGB(60,60,60)
                
                TweenService:Create(SwitchDot, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = TargetPos}):Play()
                TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor}):Play()
                
                Callback(State)
                
                -- Update Keybind HUD if linked (Advanced logic placeholder)
            end

            Interact.MouseButton1Click:Connect(function()
                State = not State
                Update()
            end)
            
            if Default then Callback(State) end
        end

        function TabObj:Slider(options)
            local Name = options.Name or "Slider"
            local Min, Max = options.Min or 0, options.Max or 100
            local Default = options.Default or Min
            local Callback = options.Callback or function() end

            local Value = Default

            local SliderFrame = Create("CanvasGroup", {
                Parent = TabPage,
                BackgroundColor3 = Library.Theme.ItemBG,
                Size = UDim2.new(1, 0, 0, 55),
                BorderSizePixel = 0,
                Name = Name .. "_Element"
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SliderFrame})
            Create("UIStroke", {Parent = SliderFrame, Color = Library.Theme.Outline, Thickness = 1})

            local Title = Create("TextLabel", {
                Name = "Title",
                Parent = SliderFrame,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                Font = Library.Theme.Font,
                TextSize = 14,
                Size = UDim2.new(1, 0, 0, 25),
                Position = UDim2.new(0, 15, 0, 5),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame,
                Text = tostring(Value),
                TextColor3 = Library.Theme.SubText,
                Font = Library.Theme.Font,
                TextSize = 14,
                Size = UDim2.new(0, 50, 0, 25),
                Position = UDim2.new(1, -60, 0, 5),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local BarBG = Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(20,20,20),
                Size = UDim2.new(1, -30, 0, 6),
                Position = UDim2.new(0, 15, 0, 35)
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BarBG})
            
            local BarFill = Create("Frame", {
                Parent = BarBG,
                BackgroundColor3 = Library.Theme.Accent,
                Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0),
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BarFill})

            local Interact = Create("TextButton", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                ZIndex = 5
            })
            
            local Dragging = false
            
            local function Update(Input)
                local SizeX = BarBG.AbsoluteSize.X
                local PosX = BarBG.AbsolutePosition.X
                local MouseX = math.clamp(Input.Position.X - PosX, 0, SizeX)
                local Percent = MouseX / SizeX
                
                Value = math.floor(Min + ((Max - Min) * Percent))
                ValueLabel.Text = tostring(Value)
                
                TweenService:Create(BarFill, TweenInfo.new(0.05), {Size = UDim2.new(Percent, 0, 1, 0)}):Play()
                Callback(Value)
            end
            
            Interact.MouseButton1Down:Connect(function() Dragging = true end)
            UserInputService.InputEnded:Connect(function(input) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end 
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
        end
        
        function TabObj:Keybind(options)
            local Name = options.Name or "Keybind"
            local Default = options.Default or Enum.KeyCode.RightShift
            local Callback = options.Callback or function() end
            
            local CurrentKey = Default
            local Binding = false
            
            local KeyFrame = Create("CanvasGroup", {
                Parent = TabPage,
                BackgroundColor3 = Library.Theme.ItemBG,
                Size = UDim2.new(1, 0, 0, 40),
                BorderSizePixel = 0,
                Name = Name .. "_Element"
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = KeyFrame})
            Create("UIStroke", {Parent = KeyFrame, Color = Library.Theme.Outline, Thickness = 1})
            
            local Title = Create("TextLabel", {
                Name = "Title",
                Parent = KeyFrame,
                Text = Name,
                TextColor3 = Library.Theme.Text,
                Font = Library.Theme.Font,
                TextSize = 14,
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local BindBtn = Create("TextButton", {
                Parent = KeyFrame,
                BackgroundColor3 = Color3.fromRGB(30,30,30),
                Size = UDim2.new(0, 80, 0, 24),
                Position = UDim2.new(1, -90, 0.5, -12),
                Text = Default.Name,
                TextColor3 = Library.Theme.SubText,
                Font = Enum.Font.GothamBold,
                TextSize = 12
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = BindBtn})
            
            -- HUD Entry
            local HUDText = Create("TextLabel", {
                Parent = KeybindHUD,
                Text = Name .. ": [" .. Default.Name .. "]",
                TextColor3 = Library.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Visible = false -- Only show if active or always? (Request said active toggles, but keybinds usually just exist)
            })

            BindBtn.MouseButton1Click:Connect(function()
                Binding = true
                BindBtn.Text = "..."
                BindBtn.TextColor3 = Library.Theme.Accent
            end)
            
            table.insert(Library.Connections, UserInputService.InputBegan:Connect(function(input)
                if Binding then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = input.KeyCode
                        Binding = false
                        BindBtn.Text = CurrentKey.Name
                        BindBtn.TextColor3 = Library.Theme.SubText
                        HUDText.Text = Name .. ": [" .. CurrentKey.Name .. "]"
                    end
                elseif input.KeyCode == CurrentKey then
                    Callback()
                end
            end))
        end

        return TabObj
    end

    return WindowObj
end

return Library
