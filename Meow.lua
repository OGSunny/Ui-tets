--[[ 
    BlueLib UI Library
    Author: [Your Name]
    Theme: Light Blue (40, 190, 207)
]]

local BlueLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Constants & Theme
local THEME = {
    Accent = Color3.fromRGB(40, 190, 207), -- Your requested Light Blue
    Background = Color3.fromRGB(35, 35, 35),
    ElementInfo = Color3.fromRGB(45, 45, 45),
    Text = Color3.fromRGB(255, 255, 255)
}

-- Utility: Create Rounded Corners
local function AddCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = instance
    return corner
end

-- Constructor: Create the Main Window
function BlueLib:CreateWindow(hubName)
    local Library = {}
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlueLib_" .. hubName
    ScreenGui.Parent = CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = THEME.Background
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, 8)

    -- Header (Top Bar)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundColor3 = THEME.Accent -- Uses your Blue
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.Parent = MainFrame
    AddCorner(Header, 8)
    
    -- Fix Header Bottom Corners (to make them square so they connect to body)
    local HeaderFix = Instance.new("Frame")
    HeaderFix.BackgroundColor3 = THEME.Accent
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Position = UDim2.new(0, 0, 1, -5)
    HeaderFix.Size = UDim2.new(1, 0, 0, 5)
    HeaderFix.Parent = Header

    -- Title Text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = hubName
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    -- Container for Elements
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.ScrollBarThickness = 2
    Container.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Container

    -- 1. Create Button Function
    function Library:CreateButton(buttonText, callback)
        callback = callback or function() end
        
        local ButtonBtn = Instance.new("TextButton")
        ButtonBtn.Name = "Button"
        ButtonBtn.BackgroundColor3 = THEME.ElementInfo
        ButtonBtn.Size = UDim2.new(1, 0, 0, 35)
        ButtonBtn.Font = Enum.Font.GothamSemibold
        ButtonBtn.Text = buttonText
        ButtonBtn.TextColor3 = THEME.Text
        ButtonBtn.TextSize = 14
        ButtonBtn.AutoButtonColor = false
        ButtonBtn.Parent = Container
        AddCorner(ButtonBtn, 6)
        
        -- Click Effect
        ButtonBtn.MouseButton1Click:Connect(function()
            pcall(callback)
            -- Simple Animation
            local goal = {BackgroundColor3 = THEME.Accent} -- Flash Blue
            local tween = TweenService:Create(ButtonBtn, TweenInfo.new(0.2), goal)
            tween:Play()
            wait(0.2)
            local returnGoal = {BackgroundColor3 = THEME.ElementInfo}
            local returnTween = TweenService:Create(ButtonBtn, TweenInfo.new(0.4), returnGoal)
            returnTween:Play()
        end)
    end

    -- 2. Create Toggle Function
    function Library:CreateToggle(toggleText, default, callback)
        local toggled = default or false
        callback = callback or function() end

        local ToggleFrame = Instance.new("TextButton") -- Using TextButton for the background click
        ToggleFrame.Name = "Toggle"
        ToggleFrame.BackgroundColor3 = THEME.ElementInfo
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
        ToggleFrame.Text = ""
        ToggleFrame.AutoButtonColor = false
        ToggleFrame.Parent = Container
        AddCorner(ToggleFrame, 6)

        local Label = Instance.new("TextLabel")
        Label.Text = toggleText
        Label.Font = Enum.Font.GothamSemibold
        Label.TextColor3 = THEME.Text
        Label.TextSize = 14
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 24, 0, 24)
        Indicator.Position = UDim2.new(1, -34, 0.5, -12)
        Indicator.BackgroundColor3 = toggled and THEME.Accent or Color3.fromRGB(80, 80, 80)
        Indicator.Parent = ToggleFrame
        AddCorner(Indicator, 6)

        ToggleFrame.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            -- Animate Color Change
            local targetColor = toggled and THEME.Accent or Color3.fromRGB(80, 80, 80)
            TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            
            pcall(callback, toggled)
        end)
    end

    -- 3. Create Slider Function
    function Library:CreateSlider(text, min, max, default, callback)
        local value = default or min
        local dragging = false
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = "Slider"
        SliderFrame.BackgroundColor3 = THEME.ElementInfo
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.Parent = Container
        AddCorner(SliderFrame, 6)

        local Label = Instance.new("TextLabel")
        Label.Text = text
        Label.Font = Enum.Font.GothamSemibold
        Label.TextColor3 = THEME.Text
        Label.TextSize = 14
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 10, 0, 5)
        Label.Size = UDim2.new(1, -20, 0, 20)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Text = tostring(value)
        ValueLabel.Font = Enum.Font.Gotham
        ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        ValueLabel.TextSize = 14
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(1, -60, 0, 5)
        ValueLabel.Size = UDim2.new(0, 50, 0, 20)
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame

        local SlideBar = Instance.new("TextButton")
        SlideBar.Text = ""
        SlideBar.AutoButtonColor = false
        SlideBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        SlideBar.Position = UDim2.new(0, 10, 0, 30)
        SlideBar.Size = UDim2.new(1, -20, 0, 10)
        SlideBar.Parent = SliderFrame
        AddCorner(SlideBar, 5)

        local Fill = Instance.new("Frame")
        Fill.BackgroundColor3 = THEME.Accent
        Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        Fill.Parent = SlideBar
        AddCorner(Fill, 5)

        -- Update Function
        local function Update(input)
            local pos = UDim2.new(math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
            Fill.Size = pos
            
            local sVal = math.floor(min + ((max - min) * pos.X.Scale))
            ValueLabel.Text = tostring(sVal)
            pcall(callback, sVal)
        end

        SlideBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        SlideBar.InputEnded:Connect(function(input)
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

    return Library
end

return BlueLib
