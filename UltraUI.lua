--[[ 
    TITAN UI - SOURCE ENGINE
    Version: 2.0 (God Mode)
    Style: WindUI / Neverlose Hybrid
    Features: Rayfield Search, Floating Physics, Stacked Notifications
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {
    Version = "2.0",
    Open = true,
    Theme = {
        Background = Color3.fromRGB(18, 18, 22),
        Sidebar = Color3.fromRGB(23, 23, 28),
        Element = Color3.fromRGB(30, 30, 35),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 170),
        Accent = Color3.fromRGB(100, 115, 255), -- Premium Blurple
        Outline = Color3.fromRGB(45, 45, 50),
        Font = Enum.Font.GothamMedium,
        FontBold = Enum.Font.GothamBold
    },
    Icons = {
        Logo = "rbxassetid://7733960981",
        Search = "rbxassetid://7733674676",
        Home = "rbxassetid://7733960981",
        Settings = "rbxassetid://7734053495",
        Arrow = "rbxassetid://7733717447",
        Check = "rbxassetid://7733756680"
    }
}

--// UTILITY //--
local function Create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    return obj
end

local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local function Ripple(btn)
    task.spawn(function()
        local ripple = Create("ImageLabel", {
            Parent = btn, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.9, BorderSizePixel = 0,
            Image = "rbxassetid://2708891598", ImageTransparency = 0.8, Position = UDim2.new(0, Mouse.X - btn.AbsolutePosition.X, 0, Mouse.Y - btn.AbsolutePosition.Y),
            Size = UDim2.new(0,0,0,0), ZIndex = 5
        })
        Tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 400, 0, 400), Position = UDim2.new(0, ripple.Position.X.Offset - 200, 0, ripple.Position.Y.Offset - 200), ImageTransparency = 1})
        task.wait(0.5); ripple:Destroy()
    end)
end

--// MAIN LIBRARY LOGIC //--
function Library:Window(options)
    local Name = options.Name or "Titan UI"
    
    -- Cleanup
    if CoreGui:FindFirstChild("TitanUI_Main") then CoreGui.TitanUI_Main:Destroy() end
    
    local ScreenGui = Create("ScreenGui", {Name = "TitanUI_Main", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true})
    
    -- Overlay Container (Fixes Dropdown clipping)
    local Overlay = Create("Frame", {Name = "Overlay", Parent = ScreenGui, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), ZIndex = 100})
    
    -- Notification Container
    local NotifContainer = Create("Frame", {Parent = ScreenGui, BackgroundTransparency = 1, Size = UDim2.new(0, 300, 1, -20), Position = UDim2.new(1, -310, 0, 10), ZIndex = 200})
    local NotifLayout = Create("UIListLayout", {Parent = NotifContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Bottom})

    -- Main Window
    local Main = Create("Frame", {
        Parent = ScreenGui, BackgroundColor3 = Library.Theme.Background, Size = UDim2.new(0, 750, 0, 500), Position = UDim2.new(0.5, -375, 0.5, -250), BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    Create("UIStroke", {Parent = Main, Color = Library.Theme.Outline, Thickness = 1.5})

    -- Shadow
    local Shadow = Create("ImageLabel", {
        Parent = Main, Image = "rbxassetid://6015897843", ImageColor3 = Color3.fromRGB(0,0,0), ImageTransparency = 0.5,
        Size = UDim2.new(1, 40, 1, 40), Position = UDim2.new(0, -20, 0, -20), BackgroundTransparency = 1, ZIndex = -1,
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(47, 47, 450, 450)
    })

    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = Main, BackgroundColor3 = Library.Theme.Sidebar, Size = UDim2.new(0, 200, 1, 0)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})
    Create("Frame", {Parent = Sidebar, BackgroundColor3 = Library.Theme.Sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1,-10,0,0), BorderSizePixel = 0}) -- Square right side

    -- Logo
    local Logo = Create("ImageLabel", {
        Parent = Sidebar, Image = Library.Icons.Logo, ImageColor3 = Library.Theme.Accent, BackgroundTransparency = 1, Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, 20, 0, 20)
    })
    local TitleLbl = Create("TextLabel", {
        Parent = Sidebar, Text = Name, TextColor3 = Library.Theme.Text, Font = Library.Theme.FontBold, TextSize = 18, BackgroundTransparency = 1, Position = UDim2.new(0, 55, 0, 20), Size = UDim2.new(0,0,0,24), TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Search
    local SearchBar = Create("Frame", {
        Parent = Sidebar, BackgroundColor3 = Library.Theme.Element, Size = UDim2.new(1, -30, 0, 32), Position = UDim2.new(0, 15, 0, 65)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SearchBar})
    Create("UIStroke", {Parent = SearchBar, Color = Library.Theme.Outline, Thickness = 1})
    Create("ImageLabel", {Parent = SearchBar, Image = Library.Icons.Search, ImageColor3 = Library.Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(0,14,0,14), Position = UDim2.new(0,10,0.5,-7)})
    local SearchInput = Create("TextBox", {
        Parent = SearchBar, BackgroundTransparency = 1, Position = UDim2.new(0,30,0,0), Size = UDim2.new(1,-35,1,0),
        Text = "", PlaceholderText = "Search...", PlaceholderColor3 = Library.Theme.SubText, TextColor3 = Library.Theme.Text, Font = Library.Theme.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Tab Container
    local TabHolder = Create("ScrollingFrame", {
        Parent = Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,-160), Position = UDim2.new(0,0,0,110), ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    local TabLayout = Create("UIListLayout", {Parent = TabHolder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})
    
    -- User Profile
    local Profile = Create("Frame", {
        Parent = Sidebar, BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.8, Size = UDim2.new(1,-20,0,50), Position = UDim2.new(0,10,1,-60)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Profile})
    local Avatar = Create("ImageLabel", {
        Parent = Profile, Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48), BackgroundTransparency = 1, Size = UDim2.new(0,32,0,32), Position = UDim2.new(0,10,0.5,-16)
    })
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Avatar})
    Create("TextLabel", {
        Parent = Profile, Text = LocalPlayer.Name, TextColor3 = Library.Theme.Text, Font = Library.Theme.FontBold, TextSize = 12, Position = UDim2.new(0,50,0.5,-8), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
    })
    Create("TextLabel", {
        Parent = Profile, Text = "Titan User", TextColor3 = Library.Theme.Accent, Font = Library.Theme.Font, TextSize = 10, Position = UDim2.new(0,50,0.5,6), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Content Area
    local Content = Create("Frame", {
        Parent = Main, BackgroundTransparency = 1, Size = UDim2.new(1, -210, 1, -20), Position = UDim2.new(0, 210, 0, 10), ClipsDescendants = true
    })

    -- Drag Logic
    local Dragging, DragStart, StartPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true; DragStart = input.Position; StartPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - DragStart
            Tween(Main, TweenInfo.new(0.05), {Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)})
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)

    --// NOTIFICATION LOGIC //--
    function Library:Notify(options)
        local Title = options.Title or "System"
        local ContentText = options.Content or ""
        local Duration = options.Duration or 3

        local Toast = Create("Frame", {
            Parent = NotifContainer, BackgroundColor3 = Library.Theme.Sidebar, Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 0.1
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Toast})
        Create("UIStroke", {Parent = Toast, Color = Library.Theme.Outline, Thickness = 1})
        
        Create("TextLabel", {
            Parent = Toast, Text = Title, TextColor3 = Library.Theme.Accent, Font = Library.Theme.FontBold, TextSize = 14, Position = UDim2.new(0,10,0,8), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        })
        Create("TextLabel", {
            Parent = Toast, Text = ContentText, TextColor3 = Library.Theme.Text, Font = Library.Theme.Font, TextSize = 12, Position = UDim2.new(0,10,0,28), Size = UDim2.new(1,-20,0,20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        })
        
        local Bar = Create("Frame", {Parent = Toast, BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new(0,0,0,2), Position = UDim2.new(0,0,1,-2)})
        Tween(Bar, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,0,2)})
        
        task.delay(Duration, function()
            Tween(Toast, TweenInfo.new(0.5), {BackgroundTransparency = 1})
            for _,v in pairs(Toast:GetDescendants()) do if v:IsA("TextLabel") then Tween(v, TweenInfo.new(0.5), {TextTransparency = 1}) end end
            task.wait(0.5); Toast:Destroy()
        end)
    end

    --// SEARCH LOGIC //--
    local function UpdateSearch(text)
        text = text:lower()
        for _, tab in pairs(Content:GetChildren()) do
            if tab:IsA("ScrollingFrame") then
                local anyFound = false
                if text == "" then
                    tab.Visible = (tab.Name == Library.CurrentTab)
                    for _, el in pairs(tab:GetChildren()) do if el:IsA("Frame") then el.Visible = true end end
                else
                    tab.Visible = false
                    for _, el in pairs(tab:GetChildren()) do
                        if el:IsA("Frame") and el:FindFirstChild("SearchTag") then
                            if el.SearchTag.Value:lower():find(text) then
                                el.Visible = true; anyFound = true
                            else
                                el.Visible = false
                            end
                        end
                    end
                    if anyFound then tab.Visible = true end
                end
            end
        end
    end
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function() UpdateSearch(SearchInput.Text) end)

    --// TABS & ELEMENTS //--
    local WindowAPI = {}
    
    function WindowAPI:Tab(options)
        local TabName = options.Name or "Tab"
        local TabIcon = options.Icon or Library.Icons.Home
        
        -- Sidebar Button
        local Btn = Create("TextButton", {
            Parent = TabHolder, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 38), Position = UDim2.new(0, 10, 0, 0), Text = "", AutoButtonColor = false
        })
        Create("ImageLabel", {
            Parent = Btn, Image = TabIcon, ImageColor3 = Library.Theme.SubText, BackgroundTransparency = 1, Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 12, 0.5, -9)
        })
        local Txt = Create("TextLabel", {
            Parent = Btn, Text = TabName, TextColor3 = Library.Theme.SubText, Font = Library.Theme.Font, TextSize = 14, BackgroundTransparency = 1, Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(0,0,1,0), TextXAlignment = Enum.TextXAlignment.Left
        })
        local Ind = Create("Frame", {
            Parent = Btn, BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new(0,0,0,18), Position = UDim2.new(0,0,0.5,-9)
        })
        Create("UICorner", {CornerRadius = UDim.new(0,2), Parent = Ind})
        
        -- Content Page
        local Page = Create("ScrollingFrame", {
            Name = TabName, Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Visible = false, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)
        })
        local Layout = Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 20) end)

        local function Activate()
            if Library.CurrentTab then -- Hide Old
                local OldPage = Content:FindFirstChild(Library.CurrentTab)
                if OldPage then OldPage.Visible = false end
                -- Reset sidebar visuals for old button (loop through TabHolder)
            end
            
            Library.CurrentTab = TabName
            Page.Visible = true
            
            Tween(Txt, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Text})
            Tween(Ind, TweenInfo.new(0.2), {Size = UDim2.new(0,3,0,18)})
            
            -- Fade In
            for i,v in ipairs(Page:GetChildren()) do
                if v:IsA("Frame") then
                    v.BackgroundTransparency = 1
                    Tween(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, i*0.03), {BackgroundTransparency = 0})
                end
            end
        end
        Btn.MouseButton1Click:Connect(Activate)
        
        if not Library.CurrentTab then Activate() end -- First tab auto open

        -- Elements API
        local Elements = {}

        function Elements:Section(text)
            Create("TextLabel", {
                Parent = Page, Text = text, TextColor3 = Library.Theme.Accent, Font = Library.Theme.FontBold, TextSize = 12, Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function Elements:Toggle(options)
            local Name = options.Name
            local State = options.Default or false
            local Callback = options.Callback or function() end
            
            local Cont = Create("TextButton", {
                Parent = Page, BackgroundColor3 = Library.Theme.Element, Size = UDim2.new(1,0,0,42), AutoButtonColor = false, Text = ""
            })
            Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Cont})
            Create("UIStroke", {Parent = Cont, Color = Library.Theme.Outline, Thickness = 1})
            
            local Tag = Instance.new("StringValue", Cont); Tag.Name = "SearchTag"; Tag.Value = Name -- For Search
            
            Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Library.Theme.Text, Font = Library.Theme.Font, TextSize = 14, Position = UDim2.new(0,12,0,0), Size = UDim2.new(1,-60,1,0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Switch = Create("Frame", {
                Parent = Cont, BackgroundColor3 = State and Library.Theme.Accent or Color3.fromRGB(50,50,55), Size = UDim2.new(0,40,0,20), Position = UDim2.new(1,-52,0.5,-10)
            })
            Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Switch})
            local Dot = Create("Frame", {
                Parent = Switch, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0,16,0,16), Position = State and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
            })
            Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Dot})
            
            Cont.MouseButton1Click:Connect(function()
                State = not State
                Tween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = State and Library.Theme.Accent or Color3.fromRGB(50,50,55)})
                Tween(Dot, TweenInfo.new(0.2), {Position = State and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)})
                Callback(State)
            end)
        end

        function Elements:Slider(options)
            local Name = options.Name
            local Min, Max = options.Min or 0, options.Max or 100
            local Def = options.Default or Min
            local Callback = options.Callback or function() end
            local Value = Def
            
            local Cont = Create("Frame", {
                Parent = Page, BackgroundColor3 = Library.Theme.Element, Size = UDim2.new(1,0,0,50)
            })
            Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Cont})
            Create("UIStroke", {Parent = Cont, Color = Library.Theme.Outline, Thickness = 1})
            local Tag = Instance.new("StringValue", Cont); Tag.Name = "SearchTag"; Tag.Value = Name

            Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Library.Theme.Text, Font = Library.Theme.Font, TextSize = 14, Position = UDim2.new(0,12,0,8), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            local ValLbl = Create("TextLabel", {
                Parent = Cont, Text = tostring(Value), TextColor3 = Library.Theme.SubText, Font = Library.Theme.Font, TextSize = 12, Position = UDim2.new(1,-40,0,8), BackgroundTransparency = 1
            })
            
            local Bar = Create("Frame", {
                Parent = Cont, BackgroundColor3 = Color3.fromRGB(50,50,55), Size = UDim2.new(1,-24,0,4), Position = UDim2.new(0,12,0,35)
            })
            Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Bar})
            local Fill = Create("Frame", {
                Parent = Bar, BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new((Value-Min)/(Max-Min), 0, 1, 0)
            })
            Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Fill})
            
            local Click = Create("TextButton", {Parent = Cont, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = ""})
            
            local Dragging = false
            local function Update(input)
                local sizeX = Bar.AbsoluteSize.X
                local posX = Bar.AbsolutePosition.X
                local mouseX = math.clamp(input.Position.X - posX, 0, sizeX)
                local perc = mouseX/sizeX
                Value = math.floor(Min + ((Max-Min)*perc))
                ValLbl.Text = tostring(Value)
                Tween(Fill, TweenInfo.new(0.05), {Size = UDim2.new(perc, 0, 1, 0)})
                Callback(Value)
            end
            Click.MouseButton1Down:Connect(function() Dragging = true end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end end)
        end
        
        function Elements:Dropdown(options)
            local Name = options.Name
            local Items = options.Items or {}
            local Callback = options.Callback or function() end
            
            local Cont = Create("TextButton", {
                Parent = Page, BackgroundColor3 = Library.Theme.Element, Size = UDim2.new(1,0,0,42), AutoButtonColor = false, Text = ""
            })
            Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Cont})
            Create("UIStroke", {Parent = Cont, Color = Library.Theme.Outline, Thickness = 1})
            local Tag = Instance.new("StringValue", Cont); Tag.Name = "SearchTag"; Tag.Value = Name

            local Title = Create("TextLabel", {
                Parent = Cont, Text = Name, TextColor3 = Library.Theme.Text, Font = Library.Theme.Font, TextSize = 14, Position = UDim2.new(0,12,0,0), Size = UDim2.new(1,-40,1,0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            local Arrow = Create("ImageLabel", {
                Parent = Cont, Image = Library.Icons.Arrow, Size = UDim2.new(0,16,0,16), Position = UDim2.new(1,-28,0.5,-8), BackgroundTransparency = 1
            })
            
            -- Float
            local List = Create("Frame", {
                Parent = Overlay, BackgroundColor3 = Library.Theme.Sidebar, Size = UDim2.new(0,0,0,0), Visible = false, ClipsDescendants = true
            })
            Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = List})
            Create("UIStroke", {Parent = List, Color = Library.Theme.Outline, Thickness = 1})
            local Scroll = Create("ScrollingFrame", {Parent = List, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)})
            local Lay = Create("UIListLayout", {Parent = Scroll, SortOrder = Enum.SortOrder.LayoutOrder})
            Lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Scroll.CanvasSize = UDim2.new(0,0,0,Lay.AbsoluteContentSize.Y) end)
            
            local Open = false
            Cont.MouseButton1Click:Connect(function()
                Open = not Open
                if Open then
                    List.Visible = true
                    List.Position = UDim2.new(0, Cont.AbsolutePosition.X, 0, Cont.AbsolutePosition.Y + 45)
                    List.Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, 0)
                    
                    for _,v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, item in ipairs(Items) do
                        local B = Create("TextButton", {
                            Parent = Scroll, Text = "  "..item, Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, TextColor3 = Library.Theme.SubText, Font = Library.Theme.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
                        })
                        B.MouseButton1Click:Connect(function()
                            Title.Text = Name..": "..item
                            Callback(item)
                            Open = false
                            Tween(List, TweenInfo.new(0.2), {Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, 0)})
                            Tween(Arrow, TweenInfo.new(0.2), {Rotation = 0})
                            task.wait(0.2); List.Visible = false
                        end)
                    end
                    Tween(List, TweenInfo.new(0.2), {Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, math.min(#Items*30, 150))})
                    Tween(Arrow, TweenInfo.new(0.2), {Rotation = 180})
                else
                    Tween(List, TweenInfo.new(0.2), {Size = UDim2.new(0, Cont.AbsoluteSize.X, 0, 0)})
                    Tween(Arrow, TweenInfo.new(0.2), {Rotation = 0})
                    task.wait(0.2); List.Visible = false
                end
            end)
            
            RunService.RenderStepped:Connect(function()
                if Open and Cont.Visible then
                    List.Position = UDim2.new(0, Cont.AbsolutePosition.X, 0, Cont.AbsolutePosition.Y + 45)
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
