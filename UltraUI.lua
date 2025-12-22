--[[ 
    ZENITH V4 // THE ABSOLUTE PEAK
    Architecture: Component-Based / Event-Driven
    Visuals: Parallax, Blur, Rayfield-Search, Config System
    Author: Refactored by AI
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

--// 1. CONFIGURATION & THEME
local Zenith = {
    Version = "4.0.0",
    Open = true,
    Accent = Color3.fromRGB(115, 80, 255), -- "Zenith Purple"
    Theme = {
        Main = Color3.fromRGB(14, 14, 18),
        Sidebar = Color3.fromRGB(18, 18, 22),
        Content = Color3.fromRGB(18, 18, 22),
        Outline = Color3.fromRGB(35, 35, 40),
        Divider = Color3.fromRGB(30, 30, 35),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(140, 140, 145),
        Hover = Color3.fromRGB(28, 28, 32),
        Font = Enum.Font.GothamMedium,
        FontBold = Enum.Font.GothamBold
    },
    Assets = {
        Glow = "rbxassetid://5028857472",
        Noise = "rbxassetid://16933618667",
        Icons = {
            Home = "rbxassetid://7733960981",
            Settings = "rbxassetid://7734053495",
            Search = "rbxassetid://7733674676",
            Chevron = "rbxassetid://7733717447",
            Edit = "rbxassetid://7733799901"
        },
        Sounds = {
            Hover = "rbxassetid://6895079853",
            Click = "rbxassetid://6895079619",
            Notif = "rbxassetid://4590657391"
        }
    }
}

--// 2. UTILITY ENGINE
local Utils = {}

function Utils:Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

function Utils:Tween(obj, duration, props)
    local info = TweenInfo.new(duration, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

function Utils:Ripple(obj)
    task.spawn(function()
        local ripple = Utils:Create("ImageLabel", {
            Parent = obj, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.9, BorderSizePixel = 0,
            Image = "rbxassetid://2708891598", ImageTransparency = 0.8, Position = UDim2.new(0, Mouse.X - obj.AbsolutePosition.X, 0, Mouse.Y - obj.AbsolutePosition.Y),
            Size = UDim2.new(0,0,0,0), ZIndex = 9
        })
        Utils:Tween(ripple, 0.6, {Size = UDim2.new(0, 500, 0, 500), Position = UDim2.new(0, ripple.Position.X.Offset - 250, 0, ripple.Position.Y.Offset - 250), ImageTransparency = 1})
        task.wait(0.6); ripple:Destroy()
    end)
end

function Utils:PlaySound(id, vol)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = vol or 0.5
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

function Utils:Parallax(frame, strength)
    RunService.RenderStepped:Connect(function()
        if not frame.Visible then return end
        local mouse = UserInputService:GetMouseLocation()
        local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
        local delta = (mouse - center) / center
        Utils:Tween(frame, 0.1, {Position = UDim2.new(0.5, delta.X * strength, 0.5, delta.Y * strength)})
    end)
end

--// 3. MAIN LIBRARY
local Library = {}
Library.ActiveTab = nil

function Library:Init(options)
    local Name = options.Name or "Zenith"
    
    if CoreGui:FindFirstChild("Zenith_Main") then CoreGui.Zenith_Main:Destroy() end

    local ScreenGui = Utils:Create("ScreenGui", {Name = "Zenith_Main", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true})
    
    -- Overlay for Dropdowns
    local OverlayLayer = Utils:Create("Frame", {Name = "Overlay", Parent = ScreenGui, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), ZIndex = 200})

    -- Main Container (with Parallax Wrapper)
    local Wrapper = Utils:Create("Frame", {Parent = ScreenGui, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), ZIndex = 1})
    
    local Main = Utils:Create("Frame", {
        Name = "Main", Parent = Wrapper, BackgroundColor3 = Zenith.Theme.Main, Size = UDim2.new(0, 750, 0, 500),
        Position = UDim2.new(0.5, -375, 0.5, -250), BorderSizePixel = 0, ClipsDescendants = false
    })
    Utils:Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    
    -- Aesthetic Glow
    local Glow = Utils:Create("ImageLabel", {
        Parent = Main, Image = Zenith.Assets.Glow, ImageColor3 = Zenith.Accent, ImageTransparency = 0.8,
        Size = UDim2.new(1, 150, 1, 150), Position = UDim2.new(0, -75, 0, -75), BackgroundTransparency = 1, ZIndex = -1
    })
    
    -- Noise Texture
    local Noise = Utils:Create("ImageLabel", {
        Parent = Main, Image = Zenith.Assets.Noise, ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0,200,0,200),
        ImageTransparency = 0.97, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ZIndex = 0
    })
    Utils:Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Noise})

    -- Sidebar
    local Sidebar = Utils:Create("Frame", {
        Parent = Main, BackgroundColor3 = Zenith.Theme.Sidebar, Size = UDim2.new(0, 220, 1, 0), BorderSizePixel = 0
    })
    Utils:Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})
    Utils:Create("Frame", {Parent = Sidebar, BackgroundColor3 = Zenith.Theme.Sidebar, Size = UDim2.new(0,10,1,0), Position = UDim2.new(1,-10,0,0), BorderSizePixel = 0}) -- Square right

    -- Header
    local Logo = Utils:Create("ImageLabel", {
        Parent = Sidebar, Image = Zenith.Assets.Icons.Home, ImageColor3 = Zenith.Accent, BackgroundTransparency = 1,
        Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, 20, 0, 20)
    })
    local Title = Utils:Create("TextLabel", {
        Parent = Sidebar, Text = Name:upper(), TextColor3 = Zenith.Theme.Text, Font = Zenith.Theme.FontBold, TextSize = 16,
        BackgroundTransparency = 1, Position = UDim2.new(0, 54, 0, 20), Size = UDim2.new(0, 0, 0, 24), TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Search
    local SearchBar = Utils:Create("Frame", {
        Parent = Sidebar, BackgroundColor3 = Zenith.Theme.Main, Size = UDim2.new(1, -40, 0, 32), Position = UDim2.new(0, 20, 0, 70)
    })
    Utils:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SearchBar})
    Utils:Create("UIStroke", {Parent = SearchBar, Color = Zenith.Theme.Outline, Thickness = 1})
    Utils:Create("ImageLabel", {
        Parent = SearchBar, Image = Zenith.Assets.Icons.Search, ImageColor3 = Zenith.Theme.SubText, BackgroundTransparency = 1,
        Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 10, 0.5, -7)
    })
    local SearchBox = Utils:Create("TextBox", {
        Parent = SearchBar, BackgroundTransparency = 1, Position = UDim2.new(0, 32, 0, 0), Size = UDim2.new(1, -35, 1, 0),
        Text = "", PlaceholderText = "Search...", PlaceholderColor3 = Zenith.Theme.SubText, TextColor3 = Zenith.Theme.Text,
        Font = Zenith.Theme.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Tabs Container
    local TabContainer = Utils:Create("ScrollingFrame", {
        Parent = Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -120), Position = UDim2.new(0, 0, 0, 115),
        ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    local TabLayout = Utils:Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})

    -- Content Area
    local Content = Utils:Create("Frame", {
        Parent = Main, BackgroundTransparency = 1, Size = UDim2.new(1, -220, 1, 0), Position = UDim2.new(0, 220, 0, 0), ClipsDescendants = true
    })

    -- Dragging
    local Dragging, DragStart, StartPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true; DragStart = input.Position; StartPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = input.Position - DragStart
            Utils:Tween(Main, 0.05, {Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)})
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

    --// NOTIFICATIONS
    function Library:Notify(options)
        local Title = options.Title or "System"
        local Desc = options.Content or ""
        local Time = options.Duration or 3
        
        local Notif = Utils:Create("Frame", {
            Parent = ScreenGui, BackgroundColor3 = Zenith.Theme.Main, Size = UDim2.new(0, 280, 0, 80),
            Position = UDim2.new(1, 20, 1, -100), ZIndex = 300
        })
        Utils:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Notif})
        Utils:Create("UIStroke", {Parent = Notif, Color = Zenith.Theme.Outline, Thickness = 1})
        
        Utils:Create("TextLabel", {
            Parent = Notif, Text = Title, TextColor3 = Zenith.Accent, Font = Zenith.Theme.FontBold, TextSize = 14,
            Position = UDim2.new(0, 15, 0, 10), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        })
        Utils:Create("TextLabel", {
            Parent = Notif, Text = Desc, TextColor3 = Zenith.Theme.Text, Font = Zenith.Theme.Font, TextSize = 12,
            Position = UDim2.new(0, 15, 0, 30), Size = UDim2.new(1,-30,0,40), BackgroundTransparency = 1, 
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        })
        
        local Bar = Utils:Create("Frame", {Parent = Notif, BackgroundColor3 = Zenith.Accent, Size = UDim2.new(0,0,0,2), Position = UDim2.new(0,0,1,-2)})
        
        Utils:PlaySound(Zenith.Assets.Sounds.Notif)
        Utils:Tween(Notif, 0.5, {Position = UDim2.new(1, -300, 1, -100)})
        Utils:Tween(Bar, Time, {Size = UDim2.new(1,0,0,2)})
        
        task.delay(Time, function()
            Utils:Tween(Notif, 0.5, {Position = UDim2.new(1, 20, 1, -100)})
            task.wait(0.5); Notif:Destroy()
        end)
    end

    --// SEARCH LOGIC
    local function UpdateSearch(text)
        text = text:lower()
        for _, page in pairs(Content:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                if text == "" then
                    page.Visible = (page.Name == Library.ActiveTab)
                    for _, e in pairs(page:GetChildren()) do if e:IsA("Frame") then e.Visible = true end end
                else
                    page.Visible = false
                    local found = false
                    for _, e in pairs(page:GetChildren()) do
                        if e:IsA("Frame") and e:FindFirstChild("UID") then
                            if e.UID.Value:lower():find(text) then e.Visible = true; found = true else e.Visible = false end
                        end
                    end
                    if found then page.Visible = true end
                end
            end
        end
        if text == "" and Library.ActiveTab then Content[Library.ActiveTab].Visible = true end
    end
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function() UpdateSearch(SearchBox.Text) end)

    --// TABS
    local WindowAPI = {}
    
    function WindowAPI:Tab(options)
        local TabName = options.Name or "Tab"
        local TabIcon = options.Icon or Zenith.Assets.Icons.Home
        
        -- Button
        local Btn = Utils:Create("TextButton", {
            Parent = TabContainer, BackgroundTransparency = 1, Size = UDim2.new(1, -24, 0, 38),
            Position = UDim2.new(0, 12, 0, 0), Text = "", AutoButtonColor = false
        })
        local Icon = Utils:Create("ImageLabel", {
            Parent = Btn, Image = TabIcon, ImageColor3 = Zenith.Theme.SubText, BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 10, 0.5, -9)
        })
        local Text = Utils:Create("TextLabel", {
            Parent = Btn, Text = TabName, TextColor3 = Zenith.Theme.SubText, Font = Zenith.Theme.Font, TextSize = 13,
            BackgroundTransparency = 1, Position = UDim2.new(0, 38, 0, 0), Size = UDim2.new(0,0,1,0), TextXAlignment = Enum.TextXAlignment.Left
        })
        local Ind = Utils:Create("Frame", {
            Parent = Btn, BackgroundColor3 = Zenith.Accent, Size = UDim2.new(0, 3, 0, 14),
            Position = UDim2.new(0, 0, 0.5, -7), BackgroundTransparency = 1
        })
        Utils:Create("UICorner", {CornerRadius = UDim.new(0,2), Parent = Ind})

        -- Page
        local Page = Utils:Create("ScrollingFrame", {
            Name = TabName, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Visible = false,
            ScrollBarThickness = 2, ScrollBarImageColor3 = Zenith.Theme.Outline, CanvasSize = UDim2.new(0,0,0,0)
        })
        Utils:Create("UIPadding", {Parent = Page, PaddingTop=UDim.new(0,15), PaddingLeft=UDim.new(0,15), PaddingRight=UDim.new(0,15), PaddingBottom=UDim.new(0,15)})
        local Layout = Utils:Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0,0,0, Layout.AbsoluteContentSize.Y + 30) end)

        local function Activate()
            if Library.ActiveTab then
                -- Reset old tab
                for _, b in pairs(TabContainer:GetChildren()) do
                    if b:IsA("TextButton") then
                        Utils:Tween(b.TextLabel, 0.2, {TextColor3 = Zenith.Theme.SubText})
                        Utils:Tween(b.ImageLabel, 0.2, {ImageColor3 = Zenith.Theme.SubText})
                        Utils:Tween(b.Frame, 0.2, {BackgroundTransparency = 1})
                    end
                end
                Content[Library.ActiveTab].Visible = false
            end
            
            Library.ActiveTab = TabName
            Page.Visible = true
            
            Utils:Tween(Text, 0.2, {TextColor3 = Zenith.Theme.Text})
            Utils:Tween(Icon, 0.2, {ImageColor3 = Zenith.Theme.Text})
            Utils:Tween(Ind, 0.2, {BackgroundTransparency = 0})
            
            -- Staggered Entry
            for i,v in ipairs(Page:GetChildren()) do
                if v:IsA("Frame") then
                    v.BackgroundTransparency = 1
                    Utils:Tween(v, 0.3 + (i*0.02), {BackgroundTransparency = 0})
                end
            end
        end
        Btn.MouseButton1Click:Connect(Activate)
        if not Library.ActiveTab then Activate() end

        --// ELEMENTS API
        local Elements = {}

        function Elements:Section(name)
            Utils:Create("TextLabel", {
                Parent = Page, Text = name:upper(), TextColor3 = Zenith.Theme.SubText, Font = Zenith.Theme.FontBold,
                TextSize = 11, Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function Elements:Toggle(options)
            local Name = options.Name
            local State = options.Default or false
            local Callback = options.Callback or function() end
            
            local Cont = Utils:Create("TextButton", {
                Parent = Page, BackgroundColor3 = Zenith.Theme.Content, Size = UDim2.new(1,0,0,42), AutoButtonColor = false, Text = ""
            })
            Utils:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Cont})
            Utils:Create("UIStroke", {Parent = Cont, Color = Zenith.Theme.Outline, Thickness = 1})
            local UID = Instance.new("StringValue", Cont); UID.Name = "UID"; UID.Value = Name

            Utils:Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Zenith.Theme.Text, Font = Zenith.Theme.Font, TextSize = 13,
                Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Switch = Utils:Create("Frame", {
                Parent = Cont, BackgroundColor3 = State and Zenith.Accent or Color3.fromRGB(50,50,55),
                Size = UDim2.new(0, 36, 0, 20), Position = UDim2.new(1, -48, 0.5, -10)
            })
            Utils:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Switch})
            local Knob = Utils:Create("Frame", {
                Parent = Switch, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 16, 0, 16),
                Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            })
            Utils:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Knob})
            
            Cont.MouseEnter:Connect(function() Utils:PlaySound(Zenith.Assets.Sounds.Hover, 0.1) end)
            Cont.MouseButton1Click:Connect(function()
                State = not State
                Utils:PlaySound(Zenith.Assets.Sounds.Click)
                Utils:Ripple(Cont)
                Utils:Tween(Switch, 0.2, {BackgroundColor3 = State and Zenith.Accent or Color3.fromRGB(50,50,55)})
                Utils:Tween(Knob, 0.2, {Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                Callback(State)
            end)
        end
        
        function Elements:Slider(options)
            local Name = options.Name
            local Min, Max = options.Min or 0, options.Max or 100
            local Def = options.Default or Min
            local Callback = options.Callback or function() end
            local Value = Def
            
            local Cont = Utils:Create("Frame", {
                Parent = Page, BackgroundColor3 = Zenith.Theme.Content, Size = UDim2.new(1,0,0,54)
            })
            Utils:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Cont})
            Utils:Create("UIStroke", {Parent = Cont, Color = Zenith.Theme.Outline, Thickness = 1})
            local UID = Instance.new("StringValue", Cont); UID.Name = "UID"; UID.Value = Name
            
            Utils:Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Zenith.Theme.Text, Font = Zenith.Theme.Font, TextSize = 13,
                Position = UDim2.new(0, 12, 0, 8), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            local ValLbl = Utils:Create("TextLabel", {
                Parent = Cont, Text = tostring(Value), TextColor3 = Zenith.Theme.SubText, Font = Zenith.Theme.Font, TextSize = 12,
                Position = UDim2.new(1, -40, 0, 8), BackgroundTransparency = 1
            })
            
            local Track = Utils:Create("Frame", {
                Parent = Cont, BackgroundColor3 = Color3.fromRGB(50,50,55), Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 0, 38)
            })
            Utils:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Track})
            local Fill = Utils:Create("Frame", {
                Parent = Track, BackgroundColor3 = Zenith.Accent, Size = UDim2.new((Value-Min)/(Max-Min), 0, 1, 0)
            })
            Utils:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Fill})
            local Knob = Utils:Create("Frame", {
                Parent = Fill, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -6, 0.5, -6)
            })
            Utils:Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Knob})
            
            local Interact = Utils:Create("TextButton", {Parent = Cont, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = ""})
            local Dragging = false
            
            local function Update(input)
                local sx = Track.AbsoluteSize.X
                local px = Track.AbsolutePosition.X
                local mx = math.clamp(input.Position.X - px, 0, sx)
                local perc = mx/sx
                Value = math.floor(Min + ((Max-Min)*perc))
                ValLbl.Text = tostring(Value)
                Utils:Tween(Fill, 0.05, {Size = UDim2.new(perc, 0, 1, 0)})
                Callback(Value)
            end
            
            Interact.MouseButton1Down:Connect(function() Dragging = true; Utils:Tween(Knob, 0.1, {Size = UDim2.new(0,16,0,16), Position = UDim2.new(1,-8,0.5,-8)}) end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false; Utils:Tween(Knob, 0.1, {Size = UDim2.new(0,12,0,12), Position = UDim2.new(1,-6,0.5,-6)}) end end)
            UserInputService.InputChanged:Connect(function(input) if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
        end
        
        function Elements:Dropdown(options)
            local Name = options.Name
            local Items = options.Items or {}
            local Callback = options.Callback or function() end
            
            local Cont = Utils:Create("TextButton", {
                Parent = Page, BackgroundColor3 = Zenith.Theme.Content, Size = UDim2.new(1,0,0,42), AutoButtonColor = false, Text = ""
            })
            Utils:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Cont})
            Utils:Create("UIStroke", {Parent = Cont, Color = Zenith.Theme.Outline, Thickness = 1})
            local UID = Instance.new("StringValue", Cont); UID.Name = "UID"; UID.Value = Name
            
            Utils:Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Zenith.Theme.Text, Font = Zenith.Theme.Font, TextSize = 13,
                Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            local Chevron = Utils:Create("ImageLabel", {
                Parent = Cont, Image = Zenith.Assets.Icons.Chevron, ImageColor3 = Zenith.Theme.SubText, BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -28, 0.5, -8)
            })
            
            -- Float List
            local List = Utils:Create("Frame", {
                Parent = OverlayLayer, BackgroundColor3 = Zenith.Theme.Sidebar, Size = UDim2.new(0,0,0,0), Visible = false, ClipsDescendants = true
            })
            Utils:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = List})
            Utils:Create("UIStroke", {Parent = List, Color = Zenith.Theme.Outline, Thickness = 1})
            local Scroll = Utils:Create("ScrollingFrame", {Parent = List, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)})
            local Lay = Utils:Create("UIListLayout", {Parent = Scroll, SortOrder = Enum.SortOrder.LayoutOrder})
            Lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Scroll.CanvasSize = UDim2.new(0,0,0,Lay.AbsoluteContentSize.Y) end)
            
            local Open = false
            Cont.MouseButton1Click:Connect(function()
                Open = not Open
                if Open then
                    List.Visible = true
                    List.Position = UDim2.new(0, Cont.AbsolutePosition.X, 0, Cont.AbsolutePosition.Y + 46)
                    List.Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, 0)
                    
                    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, item in ipairs(Items) do
                        local B = Utils:Create("TextButton", {
                            Parent = Scroll, Text = "  "..item, Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1,
                            TextColor3 = Zenith.Theme.SubText, Font = Zenith.Theme.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
                        })
                        B.MouseEnter:Connect(function() Utils:Tween(B, 0.1, {TextColor3 = Zenith.Theme.Text}) end)
                        B.MouseLeave:Connect(function() Utils:Tween(B, 0.1, {TextColor3 = Zenith.Theme.SubText}) end)
                        B.MouseButton1Click:Connect(function()
                            Open = false
                            Utils:Tween(List, 0.2, {Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, 0)})
                            Utils:Tween(Chevron, 0.2, {Rotation = 0})
                            task.wait(0.2); List.Visible = false
                            Callback(item)
                        end)
                    end
                    Utils:Tween(List, 0.3, {Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, math.min(#Items * 30, 150))})
                    Utils:Tween(Chevron, 0.3, {Rotation = 180})
                else
                    Utils:Tween(List, 0.2, {Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, 0)})
                    Utils:Tween(Chevron, 0.2, {Rotation = 0})
                    task.wait(0.2); List.Visible = false
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
