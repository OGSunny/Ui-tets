--[[ 
    ULTRA UI V2 - FIXED ALL-IN-ONE
    Just copy and run. No loadstring needed.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// 1. LIBRARY INTERNALS 
local Library = {}

-- Assets & Configuration
local Assets = {
    Icons = {
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

local Theme = {
    Main = Color3.fromRGB(18, 18, 22),
    Sidebar = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(114, 137, 218), -- Blurple
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 170),
    Border = Color3.fromRGB(45, 45, 50),
    Item = Color3.fromRGB(28, 28, 32),
    FontMain = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold
}

-- Utility Functions
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
    s.Volume = 1
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

--// 2. MAIN WINDOW CREATION
function Library:Create(options)
    options = options or {}
    local Name = options.Name or "Ultra UI"
    
    -- Cleanup Old UI
    if RunService:IsStudio() then
        if LocalPlayer.PlayerGui:FindFirstChild("UltraUI") then LocalPlayer.PlayerGui.UltraUI:Destroy() end
    else
        if CoreGui:FindFirstChild("UltraUI") then CoreGui.UltraUI:Destroy() end
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "UltraUI",
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Floating Overlay Container (Fixes Dropdown clipping)
    local OverlayContainer = Create("Frame", {
        Name = "Overlays",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        ZIndex = 200
    })

    -- Main Window
    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Main,
        Size = UDim2.new(0, 700, 0, 450),
        Position = UDim2.new(0.5, -350, 0.5, -225),
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    
    -- Stroke with Mouse Spotlight
    local UIStroke = Create("UIStroke", {Parent = Main, Thickness = 2, Color = Theme.Border})
    local Gradient = Create("UIGradient", {
        Parent = UIStroke,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Border),
            ColorSequenceKeypoint.new(0.5, Theme.Accent),
            ColorSequenceKeypoint.new(1, Theme.Border)
        }
    })
    
    RunService.RenderStepped:Connect(function()
        if not Main.Visible then return end
        local mPos = UserInputService:GetMouseLocation()
        local fPos = Main.AbsolutePosition + (Main.AbsoluteSize / 2)
        local angle = math.atan2(mPos.Y - fPos.Y, mPos.X - fPos.X)
        Gradient.Rotation = math.deg(angle) + 90
    end)
    
    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 60, 1, 0),
        BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})
    local SidebarFix = Create("Frame", {
        Parent = Sidebar, BackgroundColor3 = Theme.Sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1,-10,0,0), BorderSizePixel = 0
    })
    
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,-70), Position = UDim2.new(0,0,0,60), ScrollBarThickness = 0
    })
    local TabLayout = Create("UIListLayout", {
        Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    -- Profile
    local Profile = Create("ImageLabel", {
        Parent = Sidebar,
        Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48),
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 14, 1, -45),
        BackgroundColor3 = Theme.Accent
    })
    Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Profile})

    -- Content Area
    local Content = Create("Frame", {
        Parent = Main, BackgroundTransparency = 1, Size = UDim2.new(1,-70,1,-20), Position = UDim2.new(0,70,0,10), ClipsDescendants = true
    })

    -- Draggable Logic
    local Dragging, DragInput, DragStart, StartPos
    local function Update(input)
        local delta = input.Position - DragStart
        Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true; DragStart = input.Position; StartPos = Main.Position
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then Update(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)

    --// API LOGIC
    local WindowAPI = {}
    local Tabs = {}

    function WindowAPI:Tab(name, icon)
        local TabBtn = Create("TextButton", {
            Parent = TabContainer, BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = 1, Size = UDim2.new(0, 40, 0, 40), Text = "", AutoButtonColor = false
        })
        local TabIcon = Create("ImageLabel", {
            Parent = TabBtn, Image = icon or Assets.Icons.Home, ImageColor3 = Theme.SubText, Size = UDim2.new(0,20,0,20), Position = UDim2.new(0.5,-10,0.5,-10), BackgroundTransparency = 1
        })
        local Dot = Create("Frame", {
            Parent = TabBtn, BackgroundColor3 = Theme.Accent, Size = UDim2.new(0,4,0,4), Position = UDim2.new(0,2,0.5,-2), Visible = false
        })
        Create("UICorner", {CornerRadius = UDim.new(1,0), Parent = Dot})

        local Page = Create("ScrollingFrame", {
            Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Visible = false, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)
        })
        local PLayout = Create("UIListLayout", {
            Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)
        })
        PLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0, PLayout.AbsoluteContentSize.Y + 20)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                Tween(t.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.SubText})
                t.Dot.Visible = false
                t.Page.Visible = false
            end
            Tween(TabIcon, TweenInfo.new(0.2), {ImageColor3 = Theme.Accent})
            Dot.Visible = true
            Page.Visible = true
            
            -- Cascade Animation
            for i, v in ipairs(Page:GetChildren()) do
                if v:IsA("Frame") or v:IsA("TextButton") then
                    v.BackgroundTransparency = 1
                    Tween(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, i*0.05), {BackgroundTransparency = 0})
                end
            end
        end)

        table.insert(Tabs, {Btn = TabBtn, Icon = TabIcon, Dot = Dot, Page = Page})
        if #Tabs == 1 then TabBtn.MouseButton1Click:Fire() end -- Select first tab

        -- Elements
        local Elements = {}

        function Elements:Section(text)
            Create("TextLabel", {
                Parent = Page, Text = text, TextColor3 = Theme.Accent, Font = Theme.FontBold, TextSize = 12, Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function Elements:Button(name, callback)
            local Btn = Create("TextButton", {
                Parent = Page, BackgroundColor3 = Theme.Item, Size = UDim2.new(1,0,0,40), AutoButtonColor = false, Text = ""
            })
            Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Btn})
            Create("TextLabel", {
                Parent = Btn, Text = name, TextColor3 = Theme.Text, Font = Theme.FontMain, TextSize = 14, Position = UDim2.new(0,12,0,0), Size = UDim2.new(1,-12,1,0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            Create("ImageLabel", {
                Parent = Btn, Image = Assets.Icons.Arrow, ImageColor3 = Theme.SubText, Size = UDim2.new(0,16,0,16), Position = UDim2.new(1,-28,0.5,-8), BackgroundTransparency = 1
            })
            Btn.MouseButton1Click:Connect(function() Ripple(Btn); PlaySound(Assets.Sounds.Click); callback() end)
        end

        function Elements:Toggle(name, default, callback)
            local State = default or false
            local Btn = Create("TextButton", {
                Parent = Page, BackgroundColor3 = Theme.Item, Size = UDim2.new(1,0,0,40), AutoButtonColor = false, Text = ""
            })
            Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Btn})
            Create("TextLabel", {
                Parent = Btn, Text = name, TextColor3 = Theme.Text, Font = Theme.FontMain, TextSize = 14, Position = UDim2.new(0,12,0,0), Size = UDim2.new(1,-12,1,0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            local Check = Create("Frame", {
                Parent = Btn, BackgroundColor3 = State and Theme.Accent or Color3.fromRGB(40,40,40), Size = UDim2.new(0,20,0,20), Position = UDim2.new(1,-32,0.5,-10)
            })
            Create("UICorner", {CornerRadius = UDim.new(0,4), Parent = Check})
            local Icon = Create("ImageLabel", {
                Parent = Check, Image = Assets.Icons.Check, ImageTransparency = State and 0 or 1, Size = UDim2.new(0,14,0,14), Position = UDim2.new(0.5,-7,0.5,-7), BackgroundTransparency = 1
            })
            
            Btn.MouseButton1Click:Connect(function()
                State = not State
                Ripple(Btn); PlaySound(Assets.Sounds.Click)
                Tween(Check, TweenInfo.new(0.2), {BackgroundColor3 = State and Theme.Accent or Color3.fromRGB(40,40,40)})
                Tween(Icon, TweenInfo.new(0.2), {ImageTransparency = State and 0 or 1})
                callback(State)
            end)
        end
        
        function Elements:Dropdown(name, items, callback)
            local Open = false
            local Btn = Create("TextButton", {
                Parent = Page, BackgroundColor3 = Theme.Item, Size = UDim2.new(1,0,0,40), AutoButtonColor = false, Text = ""
            })
            Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Btn})
            local Label = Create("TextLabel", {
                Parent = Btn, Text = name, TextColor3 = Theme.Text, Font = Theme.FontMain, TextSize = 14, Position = UDim2.new(0,12,0,0), Size = UDim2.new(1,-12,1,0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            local Arrow = Create("ImageLabel", {
                Parent = Btn, Image = Assets.Icons.Arrow, ImageColor3 = Theme.SubText, Size = UDim2.new(0,16,0,16), Position = UDim2.new(1,-28,0.5,-8), BackgroundTransparency = 1
            })
            
            -- Float Frame
            local Drop = Create("Frame", {
                Parent = OverlayContainer, BackgroundColor3 = Theme.Sidebar, Size = UDim2.new(0,0,0,0), Visible = false, ClipsDescendants = true
            })
            Create("UIStroke", {Parent = Drop, Color = Theme.Border, Thickness = 1})
            Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Drop})
            local Scroll = Create("ScrollingFrame", {
                Parent = Drop, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)
            })
            local List = Create("UIListLayout", {Parent = Scroll, SortOrder = Enum.SortOrder.LayoutOrder})
            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Scroll.CanvasSize = UDim2.new(0,0,0,List.AbsoluteContentSize.Y) end)
            
            Btn.MouseButton1Click:Connect(function()
                Open = not Open
                Ripple(Btn); PlaySound(Assets.Sounds.Click)
                Tween(Arrow, TweenInfo.new(0.2), {Rotation = Open and 180 or 0})
                
                if Open then
                    Drop.Visible = true
                    Drop.Position = UDim2.new(0, Btn.AbsolutePosition.X, 0, Btn.AbsolutePosition.Y + 45)
                    Drop.Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, 0)
                    
                    -- Clear & Add Items
                    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, item in ipairs(items) do
                        local IBtn = Create("TextButton", {
                            Parent = Scroll, Text = "  "..item, Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, TextColor3 = Theme.SubText, Font = Theme.FontMain, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
                        })
                        IBtn.MouseButton1Click:Connect(function()
                            Open = false
                            Label.Text = name .. ": " .. item
                            Tween(Arrow, TweenInfo.new(0.2), {Rotation = 0})
                            Tween(Drop, TweenInfo.new(0.2), {Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, 0)})
                            task.wait(0.2); Drop.Visible = false
                            callback(item)
                        end)
                    end
                    
                    Tween(Drop, TweenInfo.new(0.2), {Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, math.min(#items * 30, 150))})
                else
                    Tween(Drop, TweenInfo.new(0.2), {Size = UDim2.new(0, Btn.AbsoluteSize.X, 0, 0)})
                    task.wait(0.2); Drop.Visible = false
                end
            end)
            
            -- Close if scrolled off
            RunService.RenderStepped:Connect(function()
                if Open and Btn.Visible then
                    Drop.Position = UDim2.new(0, Btn.AbsolutePosition.X, 0, Btn.AbsolutePosition.Y + 45)
                elseif Open and not Btn.Visible then
                    Open = false; Drop.Visible = false
                end
            end)
        end

        return Elements
    end

    return WindowAPI
end
