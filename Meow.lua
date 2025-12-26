--[[
    Stellar Hub UI Library (V2 - Enhanced)
    Inspired by the professional design of Zvios Hub.
    Theme: Light Blue Accent (RGB 40, 190, 207)
    Author: [Your Name]
]]

local StellarHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = game.Players.LocalPlayer

-- Constants & Theme
local THEME = {
    Accent = Color3.fromRGB(40, 190, 207), -- Light Blue
    Background = Color3.fromRGB(20, 20, 20), -- Main Window Background
    Sidebar = Color3.fromRGB(30, 30, 30),
    Content = Color3.fromRGB(25, 25, 25),
    ElementBg = Color3.fromRGB(35, 35, 35),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180)
}

-- Utility: Create Rounded Corners
local function AddCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

-- Utility: Add Padding (UIPadding)
local function AddPadding(instance, padding)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, padding or 10)
    pad.PaddingBottom = UDim.new(0, padding or 10)
    pad.PaddingLeft = UDim.new(0, padding or 10)
    pad.PaddingRight = UDim.new(0, padding or 10)
    pad.Parent = instance
    return pad
end

-- Main Window Constructor
function StellarHub:CreateWindow()
    local Library = {}
    local currentTab = nil
    local uiHidden = true

    -- 1. Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StellarHub_UI"
    ScreenGui.Parent = CoreGui
    
    -- 2. Main Frame (The whole window)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = THEME.Background
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    MainFrame.Size = UDim2.new(0, 700, 0, 450)
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, 10)
    
    -- Hide UI by default (smooth entry)
    MainFrame.Visible = false
    
    -- Function to toggle UI visibility
    local function ToggleUI(visible)
        local targetPosition = visible and UDim2.new(0.5, -350, 0.5, -225) or UDim2.new(0.5, -350, 2, 0)
        local targetTransparency = visible and 0 or 1
        local easing = visible and Enum.EasingStyle.Quart or Enum.EasingStyle.Quart

        if visible then
            MainFrame.Visible = true
        end

        TweenService:Create(MainFrame, TweenInfo.new(0.5, easing), {
            Position = targetPosition,
            BackgroundTransparency = targetTransparency
        }):Play()

        if not visible then
            -- Wait for animation to finish before hiding
            task.wait(0.5)
            MainFrame.Visible = false
        end
        uiHidden = not visible
    end

    -- 3. Sidebar (Left Panel)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = THEME.Sidebar
    Sidebar.Size = UDim2.new(0, 200, 1, 0)
    Sidebar.Parent = MainFrame
    AddCorner(Sidebar, 10)
    -- Fix corners on the right side of the sidebar
    local SidebarFix = Instance.new("Frame")
    SidebarFix.BackgroundColor3 = THEME.Sidebar
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Position = UDim2.new(1, -5, 0, 0)
    SidebarFix.Size = UDim2.new(0, 5, 1, 0)
    SidebarFix.Parent = Sidebar

    -- Header (Top Bar for Logo & User Info)
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "Header"
    HeaderFrame.BackgroundColor3 = THEME.Background
    HeaderFrame.Size = UDim2.new(1, 0, 0, 55)
    HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
    HeaderFrame.Parent = MainFrame

    -- Stellar Hub Title (On the sidebar)
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = "Stellar Hub"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = THEME.Accent
    TitleLabel.TextSize = 22
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Sidebar

    -- Content Title (e.g., "Main")
    local ContentTitle = Instance.new("TextLabel")
    ContentTitle.Name = "ContentTitle"
    ContentTitle.Text = "Main"
    ContentTitle.Font = Enum.Font.GothamBold
    ContentTitle.TextColor3 = THEME.TextPrimary
    ContentTitle.TextSize = 24
    ContentTitle.BackgroundTransparency = 1
    ContentTitle.Size = UDim2.new(1, -40, 0, 40)
    ContentTitle.Position = UDim2.new(0, 20, 0, 10)
    ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
    ContentTitle.Parent = HeaderFrame
    
    -- User Profile Frame (Top Right)
    local UserFrame = Instance.new("Frame")
    UserFrame.Name = "UserProfile"
    UserFrame.BackgroundTransparency = 1
    UserFrame.Size = UDim2.new(0, 150, 1, 0)
    UserFrame.Position = UDim2.new(1, -170, 0, 0)
    UserFrame.Parent = HeaderFrame

    local UsernameLabel = Instance.new("TextLabel")
    UsernameLabel.Text = LocalPlayer.Name -- Display Username
    UsernameLabel.Font = Enum.Font.GothamBold
    UsernameLabel.TextColor3 = THEME.TextPrimary
    UsernameLabel.TextSize = 14
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Position = UDim2.new(0, 0, 0.5, -10)
    UsernameLabel.Size = UDim2.new(1, -50, 0, 20)
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Right
    UsernameLabel.Parent = UserFrame
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Text = "Online" -- Status
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextColor3 = THEME.Accent
    StatusLabel.TextSize = 12
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 0, 0.5, 10)
    StatusLabel.Size = UDim2.new(1, -50, 0, 20)
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
    StatusLabel.Parent = UserFrame
    
    local AvatarImage = Instance.new("ImageLabel")
    AvatarImage.Size = UDim2.new(0, 40, 0, 40)
    AvatarImage.Position = UDim2.new(1, -45, 0.5, -20)
    AvatarImage.BackgroundTransparency = 1
    AvatarImage.Image = LocalPlayer:GetUserAvatarThumbnailAsync(LocalPlayer.UserId, "HeadShot", "48x48").Image -- Get Avatar Image
    AvatarImage.Parent = UserFrame
    AddCorner(AvatarImage, 20) -- Perfect Circle

    -- Tab Container (In Sidebar)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 70)
    TabContainer.Size = UDim2.new(1, -20, 1, -80)
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabContainer

    -- Content Area (Right Panel)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 200, 0, 0)
    ContentArea.Size = UDim2.new(1, -200, 1, 0)
    ContentArea.Parent = MainFrame

    -- Pages Container
    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.BackgroundTransparency = 1
    Pages.Position = UDim2.new(0, 0, 0, 55) -- Adjusted for header
    Pages.Size = UDim2.new(1, 0, 1, -55)
    Pages.Parent = ContentArea

    -- Function to create a Tab
    function Library:CreateTab(tabName, iconId)
        local Tab = {}
        
        -- Tab Button in Sidebar
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName .. "Tab"
        TabBtn.BackgroundColor3 = THEME.ElementBg
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabContainer
        
        -- Accent Indicator Bar
        local AccentBar = Instance.new("Frame")
        AccentBar.Name = "Accent"
        AccentBar.BackgroundColor3 = THEME.Accent
        AccentBar.Size = UDim2.new(0, 4, 1, 0)
        AccentBar.Position = UDim2.new(0, 0, 0, 0)
        AccentBar.Visible = false
        AccentBar.Parent = TabBtn

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Image = iconId or "rbxassetid://7733960981"
        TabIcon.ImageColor3 = THEME.TextSecondary
        TabIcon.Parent = TabBtn

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Text = tabName
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.TextColor3 = THEME.TextSecondary
        TabLabel.TextSize = 14
        TabLabel.BackgroundTransparency = 1
        TabLabel.Size = UDim2.new(1, -40, 1, 0)
        TabLabel.Position = UDim2.new(0, 40, 0, 0)
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn
        
        -- The Page for this Tab
        local Page = Instance.new("ScrollingFrame")
        Page.Name = tabName .. "Page"
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 4
        Page.Visible = false
        Page.Parent = Pages
        AddPadding(Page, 20)
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page

        -- Tab Click Logic
        TabBtn.MouseButton1Click:Connect(function()
            -- Deactivate old tab
            if currentTab then
                currentTab.Page.Visible = false
                currentTab.AccentBar.Visible = false
                TweenService:Create(currentTab.Icon, TweenInfo.new(0.2), {ImageColor3 = THEME.TextSecondary}):Play()
                TweenService:Create(currentTab.Label, TweenInfo.new(0.2), {TextColor3 = THEME.TextSecondary}):Play()
                TweenService:Create(currentTab.Btn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Sidebar, BackgroundTransparency = 1}):Play()
            end
            
            -- Activate new tab
            AccentBar.Visible = true
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = THEME.TextPrimary}):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextColor3 = THEME.TextPrimary}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ElementBg, BackgroundTransparency = 0}):Play()
            Page.Visible = true
            ContentTitle.Text = tabName
            
            currentTab = {Btn = TabBtn, Icon = TabIcon, Label = TabLabel, Page = Page, AccentBar = AccentBar}
        end)
        
        -- Activate first tab by default
        if currentTab == nil then
            AccentBar.Visible = true
            TabIcon.ImageColor3 = THEME.TextPrimary
            TabLabel.TextColor3 = THEME.TextPrimary
            TabBtn.BackgroundColor3 = THEME.ElementBg
            Page.Visible = true
            ContentTitle.Text = tabName
            currentTab = {Btn = TabBtn, Icon = TabIcon, Label = TabLabel, Page = Page, AccentBar = AccentBar}
        end

        -- Create Section Header (e.g., "Combat")
        function Tab:CreateSection(sectionName)
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Text = sectionName
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextColor3 = THEME.TextPrimary
            SectionLabel.TextSize = 16
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Size = UDim2.new(1, 0, 0, 30)
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = Page
        end

        -- Create Toggle (Like "Auto Farm")
        function Tab:CreateToggle(title, description, default, callback)
            local toggled = default or false
            callback = callback or function() end

            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Name = title .. "Toggle"
            ToggleFrame.BackgroundColor3 = THEME.ElementBg
            ToggleFrame.Size = UDim2.new(1, 0, 0, 60)
            ToggleFrame.Text = ""
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.Parent = Page
            AddCorner(ToggleFrame, 8)
            
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Text = title
            TitleLabel.Font = Enum.Font.GothamSemibold
            TitleLabel.TextColor3 = THEME.TextPrimary
            TitleLabel.TextSize = 14
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 15, 0, 10)
            TitleLabel.Size = UDim2.new(0.7, 0, 0, 20)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Parent = ToggleFrame
            
            local DescLabel = Instance.new("TextLabel")
            DescLabel.Text = description
            DescLabel.Font = Enum.Font.Gotham
            DescLabel.TextColor3 = THEME.TextSecondary
            DescLabel.TextSize = 12
            DescLabel.BackgroundTransparency = 1
            DescLabel.Position = UDim2.new(0, 15, 0, 30)
            DescLabel.Size = UDim2.new(0.7, 0, 0, 20)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.TextWrapped = true
            DescLabel.Parent = ToggleFrame

            -- Toggle Switch UI
            local SwitchBg = Instance.new("Frame")
            SwitchBg.Size = UDim2.new(0, 40, 0, 20)
            SwitchBg.Position = UDim2.new(1, -55, 0.5, -10)
            SwitchBg.BackgroundColor3 = toggled and THEME.Accent or Color3.fromRGB(60, 60, 60)
            SwitchBg.Parent = ToggleFrame
            AddCorner(SwitchBg, 10)
            
            local SwitchKnob = Instance.new("Frame")
            SwitchKnob.Size = UDim2.new(0, 16, 0, 16)
            SwitchKnob.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            SwitchKnob.BackgroundColor3 = THEME.TextPrimary
            SwitchKnob.Parent = SwitchBg
            AddCorner(SwitchKnob, 8)

            ToggleFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                local targetColor = toggled and THEME.Accent or Color3.fromRGB(60, 60, 60)
                local targetPos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = targetPos}):Play()
                
                pcall(callback, toggled)
            end)
        end
        
        -- Create Slider (Like "Attack Speed")
        function Tab:CreateSlider(title, description, min, max, default, callback)
            local value = default or min
            local dragging = false

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = title .. "Slider"
            SliderFrame.BackgroundColor3 = THEME.ElementBg
            SliderFrame.Size = UDim2.new(1, 0, 0, 70)
            SliderFrame.Parent = Page
            AddCorner(SliderFrame, 8)

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Text = title
            TitleLabel.Font = Enum.Font.GothamSemibold
            TitleLabel.TextColor3 = THEME.TextPrimary
            TitleLabel.TextSize = 14
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 15, 0, 10)
            TitleLabel.Size = UDim2.new(0.7, 0, 0, 20)
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Parent = SliderFrame

            local DescLabel = Instance.new("TextLabel")
            DescLabel.Text = description
            DescLabel.Font = Enum.Font.Gotham
            DescLabel.TextColor3 = THEME.TextSecondary
            DescLabel.TextSize = 12
            DescLabel.BackgroundTransparency = 1
            DescLabel.Position = UDim2.new(0, 15, 0, 30)
            DescLabel.Size = UDim2.new(0.6, 0, 0, 30)
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescLabel.TextWrapped = true
            DescLabel.TextYAlignment = Enum.TextYAlignment.Top
            DescLabel.Parent = SliderFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Text = tostring(value)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextColor3 = THEME.TextPrimary
            ValueLabel.TextSize = 14
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -55, 0, 10)
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame

            -- Slider Bar
            local SlideBarBg = Instance.new("TextButton")
            SlideBarBg.Text = ""
            SlideBarBg.AutoButtonColor = false
            SlideBarBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SlideBarBg.Position = UDim2.new(0.65, 0, 0.5, 5)
            SlideBarBg.Size = UDim2.new(0.3, 0, 0, 6)
            SlideBarBg.Parent = SliderFrame
            AddCorner(SlideBarBg, 3)

            local Fill = Instance.new("Frame")
            Fill.BackgroundColor3 = THEME.Accent
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Fill.Parent = SlideBarBg
            AddCorner(Fill, 3)
            
            local Knob = Instance.new("Frame")
            Knob.BackgroundColor3 = THEME.Accent
            Knob.Size = UDim2.new(0, 12, 0, 12)
            Knob.Position = UDim2.new(1, -6, 0.5, -6)
            Knob.Parent = Fill
            AddCorner(Knob, 6)

            -- Update Function
            local function Update(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SlideBarBg.AbsolutePosition.X) / SlideBarBg.AbsoluteSize.X, 0, 1), 0, 1, 0)
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = pos}):Play()
                
                local sVal = math.floor(min + ((max - min) * pos.X.Scale))
                ValueLabel.Text = tostring(sVal)
                pcall(callback, sVal)
            end

            SlideBarBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Update(input)
                end
            end)
            
            SlideBarBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
        end

        return Tab
    end
    
    -- Notification Function (EasingStyle fixed)
    function Library:Notify(title, text, duration)
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Name = "Notification"
        NotifyFrame.BackgroundColor3 = THEME.Background
        NotifyFrame.Position = UDim2.new(1, 20, 1, -70)
        NotifyFrame.Size = UDim2.new(0, 250, 0, 60)
        NotifyFrame.Parent = ScreenGui
        AddCorner(NotifyFrame, 8)
        
        local AccentBar = Instance.new("Frame")
        AccentBar.BackgroundColor3 = THEME.Accent
        AccentBar.Size = UDim2.new(0, 4, 1, 0)
        AccentBar.Parent = NotifyFrame
        AddCorner(AccentBar, 2)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Text = title
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextColor3 = THEME.Accent
        TitleLabel.TextSize = 14
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, 15, 0, 5)
        TitleLabel.Size = UDim2.new(1, -20, 0, 20)
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = NotifyFrame
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Text = text
        TextLabel.Font = Enum.Font.Gotham
        TextLabel.TextColor3 = THEME.TextPrimary
        TextLabel.TextSize = 12
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0, 15, 0, 25)
        TextLabel.Size = UDim2.new(1, -20, 0, 30)
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextWrapped = true
        TextLabel.TextYAlignment = Enum.TextYAlignment.Top
        TextLabel.Parent = NotifyFrame

        -- Animation (Fixed EasingStyle to Quad)
        TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -270, 1, -70)}):Play()
        task.wait(duration or 3)
        TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 1, -70)}):Play()
        task.wait(0.5)
        NotifyFrame:Destroy()
    end
    
    -- UI Toggle Listener (Key: LeftControl)
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.LeftControl and not gameProcessedEvent then
            ToggleUI(uiHidden)
        end
    end)
    
    -- Initial Fade-in/Display (Optional, you can remove this if you only want the keybind)
    ToggleUI(true)

    return Library
end

return StellarHub
