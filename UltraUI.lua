--[[
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗                   ║
║    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║                   ║
║    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║                   ║
║    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║                   ║
║    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝██║                   ║
║    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝                   ║
║                                                                                  ║
║                    NEXUS UI - Ultimate 2025 UI Library                           ║
║                           Version 3.0.0                                          ║
║                                                                                  ║
║  Features:                                                                       ║
║  • Universal Device Support (PC, Mobile, Tablet, Console)                        ║
║  • 15+ Premium Themes (Glassmorphism, Neumorphism, Fluent, Material)            ║
║  • 60+ Stunning Animations (Spring Physics, GPU-Accelerated)                     ║
║  • 40+ UI Elements (Advanced Data Visualization, Charts, etc.)                   ║
║  • Discord Integration with Live Server Data                                     ║
║  • Zero-Lag Performance (Object Pooling, Viewport Culling)                       ║
║  • State Management with Undo/Redo                                               ║
║  • Full Accessibility Support (WCAG AAA)                                         ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
]]

-- ════════════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ════════════════════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local HapticService = game:GetService("HapticService")
local TextService = game:GetService("TextService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ════════════════════════════════════════════════════════════════════════════════
-- CONFIGURATION
-- ════════════════════════════════════════════════════════════════════════════════
local Config = {
    Version = "3.0.0",
    Debug = false,
    TargetFPS = 60,
    AnimationsEnabled = true,
    SoundsEnabled = true,
    HapticsEnabled = true,
    GlowEnabled = true,
    ParticlesEnabled = true,
    AccessibilityMode = false,
    ReducedMotion = false,
    HighContrast = false,
}

-- ════════════════════════════════════════════════════════════════════════════════
-- DEVICE MANAGER - Universal Device Support
-- ════════════════════════════════════════════════════════════════════════════════
local DeviceManager = {
    CurrentDevice = "Desktop",
    CurrentOrientation = "Landscape",
    ScreenSize = Vector2.new(1920, 1080),
    TouchEnabled = false,
    KeyboardEnabled = true,
    GamepadEnabled = false,
    VREnabled = false,
    
    Profiles = {
        Mobile = {
            MaxWidth = 768,
            TouchOptimized = true,
            ButtonMinSize = 44,
            FontScale = 1.0,
            Spacing = 12,
            CornerRadius = 12,
            WindowScale = 0.95,
            Navigation = "bottom-bar",
            SwipeGestures = true,
        },
        Tablet = {
            MaxWidth = 1024,
            TouchOptimized = true,
            ButtonMinSize = 40,
            FontScale = 1.05,
            Spacing = 14,
            CornerRadius = 14,
            WindowScale = 0.85,
            Navigation = "side-drawer",
            SwipeGestures = true,
        },
        Desktop = {
            MinWidth = 1025,
            TouchOptimized = false,
            ButtonMinSize = 32,
            FontScale = 1.0,
            Spacing = 10,
            CornerRadius = 10,
            WindowScale = 1.0,
            Navigation = "top-tabs",
            SwipeGestures = false,
        },
        Console = {
            TouchOptimized = false,
            ControllerOptimized = true,
            ButtonMinSize = 48,
            FontScale = 1.3,
            Spacing = 16,
            CornerRadius = 16,
            WindowScale = 0.9,
            Navigation = "gamepad-grid",
            FocusIndicators = true,
        },
        VR = {
            TouchOptimized = false,
            ButtonMinSize = 60,
            FontScale = 1.5,
            Spacing = 20,
            CornerRadius = 20,
            WindowScale = 1.2,
            Navigation = "gaze-pointer",
        }
    }
}

function DeviceManager:Detect()
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    self.ScreenSize = viewport
    
    -- Detect input capabilities
    self.TouchEnabled = UserInputService.TouchEnabled
    self.KeyboardEnabled = UserInputService.KeyboardEnabled
    self.GamepadEnabled = UserInputService.GamepadEnabled
    self.VREnabled = UserInputService.VREnabled
    
    -- Detect orientation
    self.CurrentOrientation = viewport.X > viewport.Y and "Landscape" or "Portrait"
    
    -- Determine device type
    if self.VREnabled then
        self.CurrentDevice = "VR"
    elseif self.GamepadEnabled and not self.KeyboardEnabled then
        self.CurrentDevice = "Console"
    elseif self.TouchEnabled then
        if viewport.X <= self.Profiles.Mobile.MaxWidth or viewport.Y <= self.Profiles.Mobile.MaxWidth then
            self.CurrentDevice = "Mobile"
        else
            self.CurrentDevice = "Tablet"
        end
    else
        self.CurrentDevice = "Desktop"
    end
    
    if Config.Debug then
        print("[NexusUI] Device detected:", self.CurrentDevice)
        print("[NexusUI] Screen size:", self.ScreenSize)
        print("[NexusUI] Touch enabled:", self.TouchEnabled)
    end
    
    return self.CurrentDevice
end

function DeviceManager:GetProfile()
    return self.Profiles[self.CurrentDevice] or self.Profiles.Desktop
end

function DeviceManager:GetScale()
    local profile = self:GetProfile()
    return profile.WindowScale
end

function DeviceManager:GetButtonSize()
    local profile = self:GetProfile()
    return profile.ButtonMinSize
end

function DeviceManager:GetFontScale()
    local profile = self:GetProfile()
    return profile.FontScale
end

function DeviceManager:GetSpacing()
    local profile = self:GetProfile()
    return profile.Spacing
end

function DeviceManager:GetCornerRadius()
    local profile = self:GetProfile()
    return profile.CornerRadius
end

function DeviceManager:IsTouchDevice()
    return self.TouchEnabled
end

function DeviceManager:IsGamepad()
    return self.CurrentDevice == "Console"
end

-- Listen for viewport changes
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    DeviceManager:Detect()
end)

-- Initial detection
DeviceManager:Detect()

-- ════════════════════════════════════════════════════════════════════════════════
-- PERFORMANCE MANAGER - Zero-Lag Optimization
-- ════════════════════════════════════════════════════════════════════════════════
local PerformanceManager = {
    CurrentFPS = 60,
    TargetFPS = 60,
    FrameTimes = {},
    MaxFrameSamples = 30,
    QualityLevel = 3, -- 1=Low, 2=Medium, 3=High, 4=Ultra
    
    -- Adaptive quality settings
    QualitySettings = {
        [1] = { -- Low
            Animations = false,
            Glow = false,
            Particles = false,
            Shadows = false,
            Blur = false,
            RippleEffects = false,
        },
        [2] = { -- Medium
            Animations = true,
            Glow = false,
            Particles = false,
            Shadows = true,
            Blur = false,
            RippleEffects = true,
        },
        [3] = { -- High
            Animations = true,
            Glow = true,
            Particles = true,
            Shadows = true,
            Blur = false,
            RippleEffects = true,
        },
        [4] = { -- Ultra
            Animations = true,
            Glow = true,
            Particles = true,
            Shadows = true,
            Blur = true,
            RippleEffects = true,
        }
    }
}

function PerformanceManager:Update(deltaTime)
    -- Track frame time
    table.insert(self.FrameTimes, deltaTime)
    if #self.FrameTimes > self.MaxFrameSamples then
        table.remove(self.FrameTimes, 1)
    end
    
    -- Calculate average FPS
    local totalTime = 0
    for _, time in ipairs(self.FrameTimes) do
        totalTime = totalTime + time
    end
    self.CurrentFPS = math.floor(#self.FrameTimes / totalTime)
    
    -- Adaptive quality adjustment
    if self.CurrentFPS < 30 and self.QualityLevel > 1 then
        self.QualityLevel = self.QualityLevel - 1
        self:ApplyQuality()
    elseif self.CurrentFPS >= 58 and self.QualityLevel < 4 then
        self.QualityLevel = self.QualityLevel + 1
        self:ApplyQuality()
    end
end

function PerformanceManager:ApplyQuality()
    local settings = self.QualitySettings[self.QualityLevel]
    Config.AnimationsEnabled = settings.Animations
    Config.GlowEnabled = settings.Glow
    Config.ParticlesEnabled = settings.Particles
    
    if Config.Debug then
        print("[NexusUI] Quality adjusted to level:", self.QualityLevel)
    end
end

function PerformanceManager:GetQuality()
    return self.QualitySettings[self.QualityLevel]
end

function PerformanceManager:ShouldAnimate()
    return Config.AnimationsEnabled and not Config.ReducedMotion
end

function PerformanceManager:ShouldGlow()
    return Config.GlowEnabled and self.QualityLevel >= 3
end

function PerformanceManager:ShouldParticle()
    return Config.ParticlesEnabled and self.QualityLevel >= 3
end

-- FPS monitoring
RunService.Heartbeat:Connect(function(dt)
    PerformanceManager:Update(dt)
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- OBJECT POOL - Memory-Efficient Element Reuse
-- ════════════════════════════════════════════════════════════════════════════════
local ObjectPool = {
    Pools = {},
    Stats = {
        Created = 0,
        Reused = 0,
        Returned = 0,
    }
}

function ObjectPool:Get(className, defaultProps)
    if not self.Pools[className] then
        self.Pools[className] = {}
    end
    
    local pool = self.Pools[className]
    local instance
    
    if #pool > 0 then
        instance = table.remove(pool)
        self.Stats.Reused = self.Stats.Reused + 1
    else
        instance = Instance.new(className)
        self.Stats.Created = self.Stats.Created + 1
    end
    
    -- Reset to default properties
    if defaultProps then
        for prop, value in pairs(defaultProps) do
            pcall(function()
                instance[prop] = value
            end)
        end
    end
    
    return instance
end

function ObjectPool:Return(instance)
    if not instance then return end
    
    local className = instance.ClassName
    if not self.Pools[className] then
        self.Pools[className] = {}
    end
    
    -- Clean up instance
    instance.Parent = nil
    for _, child in ipairs(instance:GetChildren()) do
        child:Destroy()
    end
    
    -- Return to pool (max 50 per type to prevent memory bloat)
    if #self.Pools[className] < 50 then
        table.insert(self.Pools[className], instance)
        self.Stats.Returned = self.Stats.Returned + 1
    else
        instance:Destroy()
    end
end

function ObjectPool:Clear()
    for className, pool in pairs(self.Pools) do
        for _, instance in ipairs(pool) do
            instance:Destroy()
        end
        self.Pools[className] = {}
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- SPRING PHYSICS - Natural Animation System
-- ════════════════════════════════════════════════════════════════════════════════
local Spring = {}
Spring.__index = Spring

Spring.Presets = {
    Default = {Tension = 300, Friction = 26, Mass = 1},
    Snappy = {Tension = 400, Friction = 28, Mass = 1},
    Smooth = {Tension = 200, Friction = 30, Mass = 1},
    Bouncy = {Tension = 180, Friction = 12, Mass = 1},
    Stiff = {Tension = 500, Friction = 40, Mass = 1},
    Slow = {Tension = 100, Friction = 20, Mass = 1},
    Elastic = {Tension = 150, Friction = 8, Mass = 1.5},
    Wobbly = {Tension = 180, Friction = 10, Mass = 1},
}

function Spring.new(initialValue, preset)
    local self = setmetatable({}, Spring)
    
    preset = preset or Spring.Presets.Default
    
    self.Value = initialValue
    self.Target = initialValue
    self.Velocity = 0
    self.Tension = preset.Tension
    self.Friction = preset.Friction
    self.Mass = preset.Mass
    self.Epsilon = 0.001
    self.Active = false
    self.Connections = {}
    self.OnUpdate = nil
    self.OnComplete = nil
    
    return self
end

function Spring:SetTarget(target)
    self.Target = target
    self.Active = true
    return self
end

function Spring:Update(dt)
    if not self.Active then return self.Value end
    
    -- Spring physics calculation
    local displacement = self.Target - self.Value
    local springForce = displacement * self.Tension
    local dampingForce = self.Velocity * self.Friction
    local acceleration = (springForce - dampingForce) / self.Mass
    
    self.Velocity = self.Velocity + acceleration * dt
    self.Value = self.Value + self.Velocity * dt
    
    -- Check if spring has settled
    if math.abs(self.Velocity) < self.Epsilon and math.abs(displacement) < self.Epsilon then
        self.Value = self.Target
        self.Velocity = 0
        self.Active = false
        
        if self.OnComplete then
            self.OnComplete(self.Value)
        end
    end
    
    if self.OnUpdate then
        self.OnUpdate(self.Value)
    end
    
    return self.Value
end

function Spring:Start()
    if self.Connection then return end
    
    self.Connection = RunService.Heartbeat:Connect(function(dt)
        self:Update(dt)
    end)
    
    return self
end

function Spring:Stop()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    return self
end

function Spring:Destroy()
    self:Stop()
    self.OnUpdate = nil
    self.OnComplete = nil
end

-- ════════════════════════════════════════════════════════════════════════════════
-- ANIMATION ENGINE - High-Performance Animation System
-- ════════════════════════════════════════════════════════════════════════════════
local AnimationEngine = {
    ActiveAnimations = {},
    AnimationId = 0,
    
    -- Easing functions
    Easings = {
        Linear = function(t) return t end,
        
        -- Quad
        InQuad = function(t) return t * t end,
        OutQuad = function(t) return 1 - (1 - t) * (1 - t) end,
        InOutQuad = function(t) return t < 0.5 and 2 * t * t or 1 - (-2 * t + 2)^2 / 2 end,
        
        -- Cubic
        InCubic = function(t) return t * t * t end,
        OutCubic = function(t) return 1 - (1 - t)^3 end,
        InOutCubic = function(t) return t < 0.5 and 4 * t * t * t or 1 - (-2 * t + 2)^3 / 2 end,
        
        -- Quart
        InQuart = function(t) return t * t * t * t end,
        OutQuart = function(t) return 1 - (1 - t)^4 end,
        InOutQuart = function(t) return t < 0.5 and 8 * t^4 or 1 - (-2 * t + 2)^4 / 2 end,
        
        -- Quint
        InQuint = function(t) return t * t * t * t * t end,
        OutQuint = function(t) return 1 - (1 - t)^5 end,
        InOutQuint = function(t) return t < 0.5 and 16 * t^5 or 1 - (-2 * t + 2)^5 / 2 end,
        
        -- Expo
        InExpo = function(t) return t == 0 and 0 or 2^(10 * t - 10) end,
        OutExpo = function(t) return t == 1 and 1 or 1 - 2^(-10 * t) end,
        InOutExpo = function(t)
            if t == 0 then return 0 end
            if t == 1 then return 1 end
            return t < 0.5 and 2^(20 * t - 10) / 2 or (2 - 2^(-20 * t + 10)) / 2
        end,
        
        -- Back
        InBack = function(t)
            local c1 = 1.70158
            local c3 = c1 + 1
            return c3 * t^3 - c1 * t^2
        end,
        OutBack = function(t)
            local c1 = 1.70158
            local c3 = c1 + 1
            return 1 + c3 * (t - 1)^3 + c1 * (t - 1)^2
        end,
        InOutBack = function(t)
            local c1 = 1.70158
            local c2 = c1 * 1.525
            return t < 0.5
                and ((2 * t)^2 * ((c2 + 1) * 2 * t - c2)) / 2
                or ((2 * t - 2)^2 * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
        end,
        
        -- Elastic
        InElastic = function(t)
            if t == 0 then return 0 end
            if t == 1 then return 1 end
            return -2^(10 * t - 10) * math.sin((t * 10 - 10.75) * (2 * math.pi) / 3)
        end,
        OutElastic = function(t)
            if t == 0 then return 0 end
            if t == 1 then return 1 end
            return 2^(-10 * t) * math.sin((t * 10 - 0.75) * (2 * math.pi) / 3) + 1
        end,
        InOutElastic = function(t)
            if t == 0 then return 0 end
            if t == 1 then return 1 end
            return t < 0.5
                and -(2^(20 * t - 10) * math.sin((20 * t - 11.125) * (2 * math.pi) / 4.5)) / 2
                or (2^(-20 * t + 10) * math.sin((20 * t - 11.125) * (2 * math.pi) / 4.5)) / 2 + 1
        end,
        
        -- Bounce
        OutBounce = function(t)
            local n1 = 7.5625
            local d1 = 2.75
            if t < 1 / d1 then
                return n1 * t * t
            elseif t < 2 / d1 then
                t = t - 1.5 / d1
                return n1 * t * t + 0.75
            elseif t < 2.5 / d1 then
                t = t - 2.25 / d1
                return n1 * t * t + 0.9375
            else
                t = t - 2.625 / d1
                return n1 * t * t + 0.984375
            end
        end,
        InBounce = function(t)
            return 1 - AnimationEngine.Easings.OutBounce(1 - t)
        end,
        InOutBounce = function(t)
            return t < 0.5
                and (1 - AnimationEngine.Easings.OutBounce(1 - 2 * t)) / 2
                or (1 + AnimationEngine.Easings.OutBounce(2 * t - 1)) / 2
        end,
    },
    
    -- Duration presets
    Durations = {
        Instant = 0.05,
        Fast = 0.15,
        Normal = 0.25,
        Slow = 0.4,
        VerySlow = 0.6,
    }
}

function AnimationEngine:Animate(instance, properties, duration, easing, callback)
    if not PerformanceManager:ShouldAnimate() then
        -- Instant apply if animations disabled
        for prop, value in pairs(properties) do
            pcall(function()
                instance[prop] = value
            end)
        end
        if callback then callback() end
        return nil
    end
    
    duration = duration or self.Durations.Normal
    easing = easing or "OutQuart"
    
    local easingFunc = self.Easings[easing] or self.Easings.OutQuart
    
    self.AnimationId = self.AnimationId + 1
    local animId = self.AnimationId
    
    -- Store initial values
    local initialValues = {}
    for prop, _ in pairs(properties) do
        pcall(function()
            initialValues[prop] = instance[prop]
        end)
    end
    
    local startTime = tick()
    local connection
    
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        local easedProgress = easingFunc(progress)
        
        -- Interpolate properties
        for prop, targetValue in pairs(properties) do
            local initialValue = initialValues[prop]
            if initialValue then
                pcall(function()
                    if typeof(targetValue) == "number" then
                        instance[prop] = initialValue + (targetValue - initialValue) * easedProgress
                    elseif typeof(targetValue) == "UDim2" then
                        instance[prop] = UDim2.new(
                            initialValue.X.Scale + (targetValue.X.Scale - initialValue.X.Scale) * easedProgress,
                            initialValue.X.Offset + (targetValue.X.Offset - initialValue.X.Offset) * easedProgress,
                            initialValue.Y.Scale + (targetValue.Y.Scale - initialValue.Y.Scale) * easedProgress,
                            initialValue.Y.Offset + (targetValue.Y.Offset - initialValue.Y.Offset) * easedProgress
                        )
                    elseif typeof(targetValue) == "Color3" then
                        instance[prop] = Color3.new(
                            initialValue.R + (targetValue.R - initialValue.R) * easedProgress,
                            initialValue.G + (targetValue.G - initialValue.G) * easedProgress,
                            initialValue.B + (targetValue.B - initialValue.B) * easedProgress
                        )
                    elseif typeof(targetValue) == "Vector2" then
                        instance[prop] = Vector2.new(
                            initialValue.X + (targetValue.X - initialValue.X) * easedProgress,
                            initialValue.Y + (targetValue.Y - initialValue.Y) * easedProgress
                        )
                    elseif typeof(targetValue) == "UDim" then
                        instance[prop] = UDim.new(
                            initialValue.Scale + (targetValue.Scale - initialValue.Scale) * easedProgress,
                            initialValue.Offset + (targetValue.Offset - initialValue.Offset) * easedProgress
                        )
                    else
                        instance[prop] = targetValue
                    end
                end)
            end
        end
        
        -- Complete
        if progress >= 1 then
            connection:Disconnect()
            self.ActiveAnimations[animId] = nil
            if callback then callback() end
        end
    end)
    
    self.ActiveAnimations[animId] = connection
    
    return {
        Id = animId,
        Stop = function()
            if connection then
                connection:Disconnect()
                self.ActiveAnimations[animId] = nil
            end
        end
    }
end

-- Shorthand methods
function AnimationEngine:FadeIn(instance, duration)
    instance.BackgroundTransparency = 1
    return self:Animate(instance, {BackgroundTransparency = 0}, duration or 0.3)
end

function AnimationEngine:FadeOut(instance, duration)
    return self:Animate(instance, {BackgroundTransparency = 1}, duration or 0.3)
end

function AnimationEngine:SlideIn(instance, direction, duration)
    direction = direction or "Right"
    local startPos
    local endPos = instance.Position
    
    if direction == "Right" then
        startPos = UDim2.new(1, 50, endPos.Y.Scale, endPos.Y.Offset)
    elseif direction == "Left" then
        startPos = UDim2.new(-1, -50, endPos.Y.Scale, endPos.Y.Offset)
    elseif direction == "Top" then
        startPos = UDim2.new(endPos.X.Scale, endPos.X.Offset, -1, -50)
    elseif direction == "Bottom" then
        startPos = UDim2.new(endPos.X.Scale, endPos.X.Offset, 1, 50)
    end
    
    instance.Position = startPos
    return self:Animate(instance, {Position = endPos}, duration or 0.4, "OutBack")
end

function AnimationEngine:Scale(instance, scale, duration)
    return self:Animate(instance, {
        Size = UDim2.new(
            instance.Size.X.Scale * scale,
            instance.Size.X.Offset * scale,
            instance.Size.Y.Scale * scale,
            instance.Size.Y.Offset * scale
        )
    }, duration or 0.2, "OutBack")
end

function AnimationEngine:Pulse(instance, intensity, duration)
    intensity = intensity or 1.1
    duration = duration or 0.3
    
    local originalSize = instance.Size
    
    self:Animate(instance, {
        Size = UDim2.new(
            originalSize.X.Scale * intensity,
            originalSize.X.Offset * intensity,
            originalSize.Y.Scale * intensity,
            originalSize.Y.Offset * intensity
        )
    }, duration / 2, "OutQuad", function()
        self:Animate(instance, {Size = originalSize}, duration / 2, "InQuad")
    end)
end

function AnimationEngine:Shake(instance, intensity, duration)
    intensity = intensity or 5
    duration = duration or 0.4
    
    local originalPos = instance.Position
    local shakeCount = 6
    local shakeTime = duration / shakeCount
    
    local function doShake(i)
        if i > shakeCount then
            self:Animate(instance, {Position = originalPos}, shakeTime)
            return
        end
        
        local offsetX = (math.random() - 0.5) * 2 * intensity * (1 - i/shakeCount)
        local offsetY = (math.random() - 0.5) * 2 * intensity * (1 - i/shakeCount)
        
        self:Animate(instance, {
            Position = UDim2.new(
                originalPos.X.Scale, originalPos.X.Offset + offsetX,
                originalPos.Y.Scale, originalPos.Y.Offset + offsetY
            )
        }, shakeTime, "Linear", function()
            doShake(i + 1)
        end)
    end
    
    doShake(1)
end

function AnimationEngine:Bounce(instance, height, duration)
    height = height or 10
    duration = duration or 0.4
    
    local originalPos = instance.Position
    
    self:Animate(instance, {
        Position = UDim2.new(
            originalPos.X.Scale, originalPos.X.Offset,
            originalPos.Y.Scale, originalPos.Y.Offset - height
        )
    }, duration / 2, "OutQuad", function()
        self:Animate(instance, {Position = originalPos}, duration / 2, "OutBounce")
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- THEME SYSTEM - Premium 2025 Themes
-- ════════════════════════════════════════════════════════════════════════════════
local ThemeManager = {
    CurrentTheme = nil,
    Themes = {},
    TransitionDuration = 0.4,
    Subscribers = {},
}

-- Define all premium themes
ThemeManager.Themes = {
    -- ═══════════════════════════════════════════════════════════════════
    -- GLASSMORPHISM - Frosted Glass Aesthetic
    -- ═══════════════════════════════════════════════════════════════════
    Glassmorphic = {
        Name = "Glassmorphic",
        Style = "Glassmorphism",
        
        -- Backgrounds (semi-transparent for glass effect)
        Background = Color3.fromRGB(20, 20, 30),
        BackgroundTransparency = 0.15,
        Surface = Color3.fromRGB(30, 30, 45),
        SurfaceTransparency = 0.2,
        Elevated = Color3.fromRGB(40, 40, 60),
        ElevatedTransparency = 0.25,
        
        -- Accent Colors
        Accent = Color3.fromRGB(120, 120, 255),
        AccentHover = Color3.fromRGB(140, 140, 255),
        AccentActive = Color3.fromRGB(100, 100, 235),
        AccentGlow = Color3.fromRGB(120, 120, 255),
        
        -- Secondary
        Secondary = Color3.fromRGB(255, 120, 200),
        SecondaryHover = Color3.fromRGB(255, 140, 210),
        
        -- Text
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 220),
        TextMuted = Color3.fromRGB(150, 150, 170),
        TextDisabled = Color3.fromRGB(100, 100, 120),
        
        -- Borders
        Border = Color3.fromRGB(100, 100, 140),
        BorderLight = Color3.fromRGB(120, 120, 160),
        BorderAccent = Color3.fromRGB(120, 120, 255),
        BorderTransparency = 0.5,
        
        -- Status Colors
        Success = Color3.fromRGB(80, 220, 150),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 100, 120),
        Info = Color3.fromRGB(100, 180, 255),
        
        -- Effects
        GlowIntensity = 0.6,
        BlurEnabled = true,
        ShadowColor = Color3.fromRGB(0, 0, 20),
        ShadowTransparency = 0.6,
        
        -- Gradients
        GradientEnabled = true,
        GradientColors = {
            Color3.fromRGB(120, 120, 255),
            Color3.fromRGB(255, 120, 200)
        },
        
        -- Typography
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
        
        -- Sizing
        CornerRadius = 12,
        BorderThickness = 1,
        ElementSpacing = 10,
    },
    
    -- ═══════════════════════════════════════════════════════════════════
    -- CYBERPUNK NEON - Vibrant Neon Future
    -- ═══════════════════════════════════════════════════════════════════
    CyberpunkNeon = {
        Name = "Cyberpunk Neon",
        Style = "Cyberpunk",
        
        Background = Color3.fromRGB(8, 8, 16),
        BackgroundTransparency = 0,
        Surface = Color3.fromRGB(15, 15, 30),
        SurfaceTransparency = 0,
        Elevated = Color3.fromRGB(25, 25, 45),
        ElevatedTransparency = 0,
        
        Accent = Color3.fromRGB(0, 255, 200),
        AccentHover = Color3.fromRGB(50, 255, 220),
        AccentActive = Color3.fromRGB(0, 220, 170),
        AccentGlow = Color3.fromRGB(0, 255, 200),
        
        Secondary = Color3.fromRGB(255, 0, 150),
        SecondaryHover = Color3.fromRGB(255, 50, 170),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 255, 240),
        TextMuted = Color3.fromRGB(100, 200, 180),
        TextDisabled = Color3.fromRGB(60, 100, 90),
        
        Border = Color3.fromRGB(0, 150, 120),
        BorderLight = Color3.fromRGB(0, 200, 160),
        BorderAccent = Color3.fromRGB(0, 255, 200),
        BorderTransparency = 0.3,
        
        Success = Color3.fromRGB(0, 255, 150),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 50, 100),
        Info = Color3.fromRGB(0, 200, 255),
        
        GlowIntensity = 0.9,
        BlurEnabled = false,
        ShadowColor = Color3.fromRGB(0, 50, 40),
        ShadowTransparency = 0.5,
        
        GradientEnabled = true,
        GradientColors = {
            Color3.fromRGB(0, 255, 200),
            Color3.fromRGB(255, 0, 150)
        },
        
        Font = Enum.Font.SciFi,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
        
        CornerRadius = 8,
        BorderThickness = 2,
        ElementSpacing = 10,
    },
    
    -- ═══════════════════════════════════════════════════════════════════
    -- MIDNIGHT AURORA - Northern Lights
    -- ═══════════════════════════════════════════════════════════════════
    MidnightAurora = {
        Name = "Midnight Aurora",
        Style = "Gradient",
        
        Background = Color3.fromRGB(10, 15, 30),
        BackgroundTransparency = 0,
        Surface = Color3.fromRGB(18, 25, 50),
        SurfaceTransparency = 0,
        Elevated = Color3.fromRGB(28, 40, 75),
        ElevatedTransparency = 0,
        
        Accent = Color3.fromRGB(100, 220, 255),
        AccentHover = Color3.fromRGB(130, 235, 255),
        AccentActive = Color3.fromRGB(80, 200, 240),
        AccentGlow = Color3.fromRGB(100, 220, 255),
        
        Secondary = Color3.fromRGB(200, 100, 255),
        SecondaryHover = Color3.fromRGB(220, 130, 255),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 220, 255),
        TextMuted = Color3.fromRGB(130, 160, 200),
        TextDisabled = Color3.fromRGB(80, 100, 140),
        
        Border = Color3.fromRGB(60, 100, 160),
        BorderLight = Color3.fromRGB(80, 130, 200),
        BorderAccent = Color3.fromRGB(100, 220, 255),
        BorderTransparency = 0.4,
        
        Success = Color3.fromRGB(100, 255, 200),
        Warning = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 100, 130),
        Info = Color3.fromRGB(100, 200, 255),
        
        GlowIntensity = 0.7,
        BlurEnabled = false,
        ShadowColor = Color3.fromRGB(10, 20, 50),
        ShadowTransparency = 0.5,
        
        GradientEnabled = true,
        GradientColors = {
            Color3.fromRGB(100, 220, 255),
            Color3.fromRGB(200, 100, 255),
            Color3.fromRGB(100, 255, 200)
        },
        
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
        
        CornerRadius = 14,
        BorderThickness = 1,
        ElementSpacing = 12,
    },
    
    -- ═══════════════════════════════════════════════════════════════════
    -- OBSIDIAN - Dark Luxury
    -- ═══════════════════════════════════════════════════════════════════
    Obsidian = {
        Name = "Obsidian",
        Style = "Dark",
        
        Background = Color3.fromRGB(10, 10, 12),
        BackgroundTransparency = 0,
        Surface = Color3.fromRGB(18, 18, 22),
        SurfaceTransparency = 0,
        Elevated = Color3.fromRGB(28, 28, 35),
        ElevatedTransparency = 0,
        
        Accent = Color3.fromRGB(220, 50, 70),
        AccentHover = Color3.fromRGB(240, 70, 90),
        AccentActive = Color3.fromRGB(200, 40, 60),
        AccentGlow = Color3.fromRGB(220, 50, 70),
        
        Secondary = Color3.fromRGB(200, 160, 100),
        SecondaryHover = Color3.fromRGB(220, 180, 120),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 195, 190),
        TextMuted = Color3.fromRGB(140, 135, 130),
        TextDisabled = Color3.fromRGB(90, 85, 80),
        
        Border = Color3.fromRGB(60, 55, 50),
        BorderLight = Color3.fromRGB(80, 75, 70),
        BorderAccent = Color3.fromRGB(220, 50, 70),
        BorderTransparency = 0.3,
        
        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Info = Color3.fromRGB(100, 180, 255),
        
        GlowIntensity = 0.5,
        BlurEnabled = false,
        ShadowColor = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.4,
        
        GradientEnabled = false,
        GradientColors = {},
        
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
        
        CornerRadius = 10,
        BorderThickness = 1,
        ElementSpacing = 10,
    },
    
    -- ═══════════════════════════════════════════════════════════════════
    -- FLUENT - Microsoft Fluent Design
    -- ═══════════════════════════════════════════════════════════════════
    Fluent = {
        Name = "Fluent",
        Style = "Fluent",
        
        Background = Color3.fromRGB(32, 32, 32),
        BackgroundTransparency = 0.05,
        Surface = Color3.fromRGB(44, 44, 44),
        SurfaceTransparency = 0.1,
        Elevated = Color3.fromRGB(56, 56, 56),
        ElevatedTransparency = 0.1,
        
        Accent = Color3.fromRGB(0, 120, 212),
        AccentHover = Color3.fromRGB(30, 140, 225),
        AccentActive = Color3.fromRGB(0, 100, 190),
        AccentGlow = Color3.fromRGB(0, 120, 212),
        
        Secondary = Color3.fromRGB(100, 100, 100),
        SecondaryHover = Color3.fromRGB(120, 120, 120),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        TextMuted = Color3.fromRGB(150, 150, 150),
        TextDisabled = Color3.fromRGB(100, 100, 100),
        
        Border = Color3.fromRGB(70, 70, 70),
        BorderLight = Color3.fromRGB(90, 90, 90),
        BorderAccent = Color3.fromRGB(0, 120, 212),
        BorderTransparency = 0.4,
        
        Success = Color3.fromRGB(16, 124, 16),
        Warning = Color3.fromRGB(252, 225, 0),
        Error = Color3.fromRGB(232, 17, 35),
        Info = Color3.fromRGB(0, 120, 212),
        
        GlowIntensity = 0.3,
        BlurEnabled = true,
        ShadowColor = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.6,
        
        GradientEnabled = false,
        GradientColors = {},
        
        Font = Enum.Font.GothamMedium,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
        
        CornerRadius = 8,
        BorderThickness = 1,
        ElementSpacing = 8,
    },
    
    -- ═══════════════════════════════════════════════════════════════════
    -- MATERIAL - Google Material Design 3
    -- ═══════════════════════════════════════════════════════════════════
    Material = {
        Name = "Material",
        Style = "Material",
        
        Background = Color3.fromRGB(28, 27, 31),
        BackgroundTransparency = 0,
        Surface = Color3.fromRGB(49, 48, 53),
        SurfaceTransparency = 0,
        Elevated = Color3.fromRGB(73, 69, 79),
        ElevatedTransparency = 0,
        
        Accent = Color3.fromRGB(208, 188, 255),
        AccentHover = Color3.fromRGB(220, 200, 255),
        AccentActive = Color3.fromRGB(190, 170, 240),
        AccentGlow = Color3.fromRGB(208, 188, 255),
        
        Secondary = Color3.fromRGB(204, 194, 220),
        SecondaryHover = Color3.fromRGB(220, 210, 235),
        
        Text = Color3.fromRGB(230, 225, 229),
        TextSecondary = Color3.fromRGB(202, 196, 208),
        TextMuted = Color3.fromRGB(147, 143, 153),
        TextDisabled = Color3.fromRGB(110, 106, 117),
        
        Border = Color3.fromRGB(147, 143, 153),
        BorderLight = Color3.fromRGB(170, 166, 180),
        BorderAccent = Color3.fromRGB(208, 188, 255),
        BorderTransparency = 0.5,
        
        Success = Color3.fromRGB(129, 199, 132),
        Warning = Color3.fromRGB(255, 213, 79),
        Error = Color3.fromRGB(242, 139, 130),
        Info = Color3.fromRGB(130, 177, 255),
        
        GlowIntensity = 0.3,
        BlurEnabled = false,
        ShadowColor = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.5,
        
        GradientEnabled = false,
        GradientColors = {},
        
        Font = Enum.Font.GothamMedium,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
        
        CornerRadius = 16,
        BorderThickness = 1,
        ElementSpacing = 12,
    },
    
    -- ═══════════════════════════════════════════════════════════════════
    -- SOLAR FLARE - Warm Sunset
    -- ═══════════════════════════════════════════════════════════════════
    SolarFlare = {
        Name = "Solar Flare",
        Style = "Warm",
        
        Background = Color3.fromRGB(25, 15, 12),
        BackgroundTransparency = 0,
        Surface = Color3.fromRGB(40, 25, 20),
        SurfaceTransparency = 0,
        Elevated = Color3.fromRGB(60, 38, 30),
        ElevatedTransparency = 0,
        
        Accent = Color3.fromRGB(255, 150, 50),
        AccentHover = Color3.fromRGB(255, 170, 80),
        AccentActive = Color3.fromRGB(240, 130, 30),
        AccentGlow = Color3.fromRGB(255, 150, 50),
        
        Secondary = Color3.fromRGB(255, 100, 100),
        SecondaryHover = Color3.fromRGB(255, 120, 120),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(255, 230, 210),
        TextMuted = Color3.fromRGB(200, 160, 130),
        TextDisabled = Color3.fromRGB(140, 110, 90),
        
        Border = Color3.fromRGB(100, 60, 40),
        BorderLight = Color3.fromRGB(140, 90, 60),
        BorderAccent = Color3.fromRGB(255, 150, 50),
        BorderTransparency = 0.4,
        
        Success = Color3.fromRGB(150, 255, 100),
        Warning = Color3.fromRGB(255, 220, 80),
        Error = Color3.fromRGB(255, 80, 80),
        Info = Color3.fromRGB(100, 200, 255),
        
        GlowIntensity = 0.7,
        BlurEnabled = false,
        ShadowColor = Color3.fromRGB(20, 10, 5),
        ShadowTransparency = 0.5,
        
        GradientEnabled = true,
        GradientColors = {
            Color3.fromRGB(255, 150, 50),
            Color3.fromRGB(255, 100, 100)
        },
        
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
        
        CornerRadius = 12,
        BorderThickness = 1,
        ElementSpacing = 10,
    },
    
    -- ═══════════════════════════════════════════════════════════════════
    -- FOREST DEPTHS - Nature Green
    -- ═══════════════════════════════════════════════════════════════════
    ForestDepths = {
        Name = "Forest Depths",
        Style = "Nature",
        
        Background = Color3.fromRGB(12, 22, 16),
        BackgroundTransparency = 0,
        Surface = Color3.fromRGB(20, 35, 25),
        SurfaceTransparency = 0,
        Elevated = Color3.fromRGB(30, 52, 38),
        ElevatedTransparency = 0,
        
        Accent = Color3.fromRGB(100, 220, 140),
        AccentHover = Color3.fromRGB(130, 240, 170),
        AccentActive = Color3.fromRGB(80, 200, 120),
        AccentGlow = Color3.fromRGB(100, 220, 140),
        
        Secondary = Color3.fromRGB(180, 200, 100),
        SecondaryHover = Color3.fromRGB(200, 220, 130),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(210, 235, 220),
        TextMuted = Color3.fromRGB(140, 180, 155),
        TextDisabled = Color3.fromRGB(90, 120, 100),
        
        Border = Color3.fromRGB(50, 90, 65),
        BorderLight = Color3.fromRGB(70, 120, 90),
        BorderAccent = Color3.fromRGB(100, 220, 140),
        BorderTransparency = 0.4,
        
        Success = Color3.fromRGB(100, 255, 150),
        Warning = Color3.fromRGB(255, 220, 100),
        Error = Color3.fromRGB(255, 100, 120),
        Info = Color3.fromRGB(100, 200, 255),
        
        GlowIntensity = 0.5,
        BlurEnabled = false,
        ShadowColor = Color3.fromRGB(5, 15, 8),
        ShadowTransparency = 0.5,
        
        GradientEnabled = true,
        GradientColors = {
            Color3.fromRGB(100, 220, 140),
            Color3.fromRGB(180, 200, 100)
        },
        
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
        
        CornerRadius = 12,
        BorderThickness = 1,
        ElementSpacing = 10,
    },
    
    -- ═══════════════════════════════════════════════════════════════════
    -- VOID - Ultra Dark Purple
    -- ═══════════════════════════════════════════════════════════════════
    Void = {
        Name = "Void",
        Style = "Dark",
        
        Background = Color3.fromRGB(5, 3, 10),
        BackgroundTransparency = 0,
        Surface = Color3.fromRGB(12, 8, 22),
        SurfaceTransparency = 0,
        Elevated = Color3.fromRGB(22, 15, 38),
        ElevatedTransparency = 0,
        
        Accent = Color3.fromRGB(180, 50, 255),
        AccentHover = Color3.fromRGB(200, 80, 255),
        AccentActive = Color3.fromRGB(160, 30, 235),
        AccentGlow = Color3.fromRGB(180, 50, 255),
        
        Secondary = Color3.fromRGB(100, 50, 180),
        SecondaryHover = Color3.fromRGB(120, 70, 200),
        
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(220, 200, 240),
        TextMuted = Color3.fromRGB(150, 130, 180),
        TextDisabled = Color3.fromRGB(90, 80, 110),
        
        Border = Color3.fromRGB(60, 40, 90),
        BorderLight = Color3.fromRGB(90, 60, 130),
        BorderAccent = Color3.fromRGB(180, 50, 255),
        BorderTransparency = 0.4,
        
        Success = Color3.fromRGB(100, 255, 180),
        Warning = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 80, 120),
        Info = Color3.fromRGB(150, 150, 255),
        
        GlowIntensity = 0.8,
        BlurEnabled = false,
        ShadowColor = Color3.fromRGB(10, 5, 20),
        ShadowTransparency = 0.4,
        
        GradientEnabled = true,
        GradientColors = {
            Color3.fromRGB(180, 50, 255),
            Color3.fromRGB(100, 50, 180)
        },
        
        Font = Enum.Font.GothamBold,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
        
        CornerRadius = 10,
        BorderThickness = 1,
        ElementSpacing = 10,
    },
    
    -- ═══════════════════════════════════════════════════════════════════
    -- MINIMAL LIGHT - Clean White
    -- ═══════════════════════════════════════════════════════════════════
    MinimalLight = {
        Name = "Minimal Light",
        Style = "Light",
        
        Background = Color3.fromRGB(250, 250, 252),
        BackgroundTransparency = 0,
        Surface = Color3.fromRGB(255, 255, 255),
        SurfaceTransparency = 0,
        Elevated = Color3.fromRGB(245, 245, 248),
        ElevatedTransparency = 0,
        
        Accent = Color3.fromRGB(0, 122, 255),
        AccentHover = Color3.fromRGB(30, 142, 255),
        AccentActive = Color3.fromRGB(0, 100, 220),
        AccentGlow = Color3.fromRGB(0, 122, 255),
        
        Secondary = Color3.fromRGB(142, 142, 147),
        SecondaryHover = Color3.fromRGB(162, 162, 167),
        
        Text = Color3.fromRGB(0, 0, 0),
        TextSecondary = Color3.fromRGB(60, 60, 67),
        TextMuted = Color3.fromRGB(142, 142, 147),
        TextDisabled = Color3.fromRGB(199, 199, 204),
        
        Border = Color3.fromRGB(209, 209, 214),
        BorderLight = Color3.fromRGB(229, 229, 234),
        BorderAccent = Color3.fromRGB(0, 122, 255),
        BorderTransparency = 0,
        
        Success = Color3.fromRGB(52, 199, 89),
        Warning = Color3.fromRGB(255, 149, 0),
        Error = Color3.fromRGB(255, 59, 48),
        Info = Color3.fromRGB(0, 122, 255),
        
        GlowIntensity = 0.2,
        BlurEnabled = false,
        ShadowColor = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.85,
        
        GradientEnabled = false,
        GradientColors = {},
        
        Font = Enum.Font.GothamMedium,
        FontSecondary = Enum.Font.Gotham,
        FontMono = Enum.Font.Code,
        
        CornerRadius = 10,
        BorderThickness = 1,
        ElementSpacing = 10,
    },
}

-- Set default theme
ThemeManager.CurrentTheme = ThemeManager.Themes.Glassmorphic

function ThemeManager:Get(property)
    return self.CurrentTheme[property]
end

function ThemeManager:GetTheme()
    return self.CurrentTheme
end

function ThemeManager:SetTheme(themeName, animate)
    local newTheme = self.Themes[themeName]
    if not newTheme then
        warn("[NexusUI] Theme not found:", themeName)
        return false
    end
    
    local oldTheme = self.CurrentTheme
    self.CurrentTheme = newTheme
    
    -- Notify subscribers
    for _, callback in ipairs(self.Subscribers) do
        pcall(callback, newTheme, oldTheme)
    end
    
    if Config.Debug then
        print("[NexusUI] Theme changed to:", themeName)
    end
    
    return true
end

function ThemeManager:Subscribe(callback)
    table.insert(self.Subscribers, callback)
    return function()
        for i, cb in ipairs(self.Subscribers) do
            if cb == callback then
                table.remove(self.Subscribers, i)
                break
            end
        end
    end
end

function ThemeManager:GetThemeNames()
    local names = {}
    for name, _ in pairs(self.Themes) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

function ThemeManager:CreateCustomTheme(name, baseTheme, overrides)
    local base = self.Themes[baseTheme] or self.Themes.Glassmorphic
    local custom = {}
    
    for k, v in pairs(base) do
        custom[k] = v
    end
    
    for k, v in pairs(overrides or {}) do
        custom[k] = v
    end
    
    custom.Name = name
    self.Themes[name] = custom
    
    return custom
end

-- ════════════════════════════════════════════════════════════════════════════════
-- STATE MANAGER - Redux-Style State Management
-- ════════════════════════════════════════════════════════════════════════════════
local StateManager = {
    State = {},
    Subscribers = {},
    History = {},
    MaxHistory = 50,
    HistoryIndex = 0,
}

function StateManager:Get(path)
    local parts = string.split(path, ".")
    local current = self.State
    
    for _, part in ipairs(parts) do
        if type(current) ~= "table" then
            return nil
        end
        current = current[part]
    end
    
    return current
end

function StateManager:Set(path, value, skipHistory)
    local parts = string.split(path, ".")
    local current = self.State
    
    -- Save to history for undo
    if not skipHistory then
        self:SaveHistory()
    end
    
    -- Navigate to parent
    for i = 1, #parts - 1 do
        local part = parts[i]
        if type(current[part]) ~= "table" then
            current[part] = {}
        end
        current = current[part]
    end
    
    -- Set value
    local lastPart = parts[#parts]
    local oldValue = current[lastPart]
    current[lastPart] = value
    
    -- Notify subscribers
    self:NotifySubscribers(path, value, oldValue)
    
    return true
end

function StateManager:Subscribe(path, callback)
    if not self.Subscribers[path] then
        self.Subscribers[path] = {}
    end
    
    table.insert(self.Subscribers[path], callback)
    
    -- Return unsubscribe function
    return function()
        for i, cb in ipairs(self.Subscribers[path]) do
            if cb == callback then
                table.remove(self.Subscribers[path], i)
                break
            end
        end
    end
end

function StateManager:NotifySubscribers(path, newValue, oldValue)
    -- Notify exact path subscribers
    if self.Subscribers[path] then
        for _, callback in ipairs(self.Subscribers[path]) do
            pcall(callback, newValue, oldValue, path)
        end
    end
    
    -- Notify parent path subscribers
    local parts = string.split(path, ".")
    for i = #parts - 1, 1, -1 do
        local parentPath = table.concat(parts, ".", 1, i)
        if self.Subscribers[parentPath] then
            for _, callback in ipairs(self.Subscribers[parentPath]) do
                pcall(callback, self:Get(parentPath), nil, parentPath)
            end
        end
    end
    
    -- Notify wildcard subscribers
    if self.Subscribers["*"] then
        for _, callback in ipairs(self.Subscribers["*"]) do
            pcall(callback, newValue, oldValue, path)
        end
    end
end

function StateManager:SaveHistory()
    -- Remove future history if we're not at the end
    while #self.History > self.HistoryIndex do
        table.remove(self.History)
    end
    
    -- Deep copy current state
    local stateCopy = HttpService:JSONEncode(self.State)
    table.insert(self.History, stateCopy)
    self.HistoryIndex = #self.History
    
    -- Limit history size
    while #self.History > self.MaxHistory do
        table.remove(self.History, 1)
        self.HistoryIndex = self.HistoryIndex - 1
    end
end

function StateManager:Undo()
    if self.HistoryIndex <= 1 then
        return false
    end
    
    self.HistoryIndex = self.HistoryIndex - 1
    self.State = HttpService:JSONDecode(self.History[self.HistoryIndex])
    
    -- Notify all subscribers
    self:NotifySubscribers("*", self.State, nil)
    
    return true
end

function StateManager:Redo()
    if self.HistoryIndex >= #self.History then
        return false
    end
    
    self.HistoryIndex = self.HistoryIndex + 1
    self.State = HttpService:JSONDecode(self.History[self.HistoryIndex])
    
    -- Notify all subscribers
    self:NotifySubscribers("*", self.State, nil)
    
    return true
end

function StateManager:Reset()
    self.State = {}
    self.History = {}
    self.HistoryIndex = 0
end

-- ════════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════
local Utility = {}

-- Create instance with properties
function Utility.Create(className, properties, children)
    local instance = ObjectPool:Get(className)
    
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            pcall(function()
                instance[prop] = value
            end)
        end
    end
    
    for _, child in ipairs(children or {}) do
        if child then
            child.Parent = instance
        end
    end
    
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    
    return instance
end

-- Animate with AnimationEngine
function Utility.Tween(instance, properties, duration, easing, callback)
    return AnimationEngine:Animate(instance, properties, duration, easing, callback)
end

-- Spring animation
function Utility.Spring(instance, property, target, preset, callback)
    preset = preset or Spring.Presets.Default
    
    local spring = Spring.new(instance[property], preset)
    spring:SetTarget(target)
    spring.OnUpdate = function(value)
        pcall(function()
            instance[property] = value
        end)
    end
    spring.OnComplete = callback
    spring:Start()
    
    return spring
end

-- Ripple effect
function Utility.Ripple(parent, position, color)
    if not PerformanceManager:ShouldAnimate() then return end
    
    color = color or ThemeManager:Get("Accent")
    
    local ripple = Utility.Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = color,
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0, position.X - parent.AbsolutePosition.X, 0, position.Y - parent.AbsolutePosition.Y),
        Size = UDim2.fromOffset(0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 999,
        Parent = parent
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
    
    AnimationEngine:Animate(ripple, {
        Size = UDim2.fromOffset(maxSize, maxSize),
        BackgroundTransparency = 1
    }, 0.5, "OutQuad", function()
        ripple:Destroy()
    end)
end

-- Glow effect
function Utility.CreateGlow(parent, color, intensity)
    if not PerformanceManager:ShouldGlow() then return nil end
    
    intensity = intensity or ThemeManager:Get("GlowIntensity")
    color = color or ThemeManager:Get("AccentGlow")
    
    local glow = Utility.Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = color,
        ImageTransparency = 1 - intensity,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1.5, 0, 1.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = -1,
        Parent = parent
    })
    
    return glow
end

-- Shadow effect
function Utility.CreateShadow(parent, offset, transparency)
    offset = offset or 4
    transparency = transparency or ThemeManager:Get("ShadowTransparency")
    
    local shadow = Utility.Create("Frame", {
        Name = "Shadow",
        BackgroundColor3 = ThemeManager:Get("ShadowColor"),
        BackgroundTransparency = transparency,
        Position = UDim2.new(0, offset, 0, offset),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = -2,
        Parent = parent
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, ThemeManager:Get("CornerRadius"))})
    })
    
    return shadow
end

-- Clamp value
function Utility.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- Round value
function Utility.Round(value, increment)
    increment = increment or 1
    return math.floor(value / increment + 0.5) * increment
end

-- Lerp color
function Utility.LerpColor(color1, color2, alpha)
    return Color3.new(
        color1.R + (color2.R - color1.R) * alpha,
        color1.G + (color2.G - color1.G) * alpha,
        color1.B + (color2.B - color1.B) * alpha
    )
end

-- Darken color
function Utility.Darken(color, amount)
    amount = amount or 0.2
    return Color3.new(
        math.max(0, color.R - amount),
        math.max(0, color.G - amount),
        math.max(0, color.B - amount)
    )
end

-- Lighten color
function Utility.Lighten(color, amount)
    amount = amount or 0.2
    return Color3.new(
        math.min(1, color.R + amount),
        math.min(1, color.G + amount),
        math.min(1, color.B + amount)
    )
end

-- Get text size
function Utility.GetTextSize(text, fontSize, font, maxWidth)
    maxWidth = maxWidth or math.huge
    return TextService:GetTextSize(text, fontSize, font, Vector2.new(maxWidth, math.huge))
end

-- Play sound
function Utility.PlaySound(soundType)
    if not Config.SoundsEnabled then return end
    
    local sounds = {
        Click = "rbxassetid://6895079853",
        Hover = "rbxassetid://6895079853",
        Toggle = "rbxassetid://6895079853",
        Success = "rbxassetid://6895079853",
        Error = "rbxassetid://6895079853",
        Notification = "rbxassetid://6895079853",
    }
    
    local soundId = sounds[soundType]
    if not soundId then return end
    
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = 0.3
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

-- Haptic feedback
function Utility.Haptic(vibration)
    if not Config.HapticsEnabled then return end
    if not DeviceManager.GamepadEnabled then return end
    
    pcall(function()
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, vibration or 0.5)
        task.delay(0.1, function()
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
        end)
    end)
end

-- Disconnect all connections
function Utility.DisconnectAll(connections)
    for _, connection in ipairs(connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
end

-- Deep copy table
function Utility.DeepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = Utility.DeepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

-- ════════════════════════════════════════════════════════════════════════════════
-- GESTURE RECOGNIZER - Touch Gesture Support
-- ════════════════════════════════════════════════════════════════════════════════
local GestureRecognizer = {
    ActiveTouches = {},
    GestureHandlers = {},
}

function GestureRecognizer:Tap(element, callback, options)
    options = options or {}
    local maxDuration = options.MaxDuration or 0.3
    local maxDistance = options.MaxDistance or 10
    
    local touchStart = nil
    local touchStartTime = nil
    
    local connections = {}
    
    table.insert(connections, element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            touchStart = input.Position
            touchStartTime = tick()
        end
    end))
    
    table.insert(connections, element.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            if touchStart then
                local duration = tick() - touchStartTime
                local distance = (input.Position - touchStart).Magnitude
                
                if duration <= maxDuration and distance <= maxDistance then
                    callback(input.Position)
                end
                
                touchStart = nil
                touchStartTime = nil
            end
        end
    end))
    
    return function()
        Utility.DisconnectAll(connections)
    end
end

function GestureRecognizer:DoubleTap(element, callback, options)
    options = options or {}
    local maxInterval = options.MaxInterval or 0.3
    
    local lastTapTime = 0
    
    return self:Tap(element, function(position)
        local currentTime = tick()
        if currentTime - lastTapTime <= maxInterval then
            callback(position)
            lastTapTime = 0
        else
            lastTapTime = currentTime
        end
    end, options)
end

function GestureRecognizer:LongPress(element, callback, options)
    options = options or {}
    local duration = options.Duration or 0.5
    local maxDistance = options.MaxDistance or 10
    
    local touchStart = nil
    local touchStartPos = nil
    local longPressThread = nil
    
    local connections = {}
    
    table.insert(connections, element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            touchStart = tick()
            touchStartPos = input.Position
            
            longPressThread = task.delay(duration, function()
                if touchStart then
                    callback(input.Position)
                    Utility.Haptic(0.5)
                end
            end)
        end
    end))
    
    table.insert(connections, element.InputChanged:Connect(function(input)
        if touchStartPos and (input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseMovement) then
            local distance = (input.Position - touchStartPos).Magnitude
            if distance > maxDistance then
                touchStart = nil
                if longPressThread then
                    task.cancel(longPressThread)
                    longPressThread = nil
                end
            end
        end
    end))
    
    table.insert(connections, element.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            touchStart = nil
            if longPressThread then
                task.cancel(longPressThread)
                longPressThread = nil
            end
        end
    end))
    
    return function()
        Utility.DisconnectAll(connections)
        if longPressThread then
            task.cancel(longPressThread)
        end
    end
end

function GestureRecognizer:Swipe(element, callback, options)
    options = options or {}
    local minDistance = options.MinDistance or 50
    local maxDuration = options.MaxDuration or 0.5
    
    local touchStart = nil
    local touchStartTime = nil
    
    local connections = {}
    
    table.insert(connections, element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            touchStart = input.Position
            touchStartTime = tick()
        end
    end))
    
    table.insert(connections, element.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            if touchStart then
                local duration = tick() - touchStartTime
                local delta = input.Position - touchStart
                local distance = delta.Magnitude
                
                if distance >= minDistance and duration <= maxDuration then
                    local direction
                    if math.abs(delta.X) > math.abs(delta.Y) then
                        direction = delta.X > 0 and "Right" or "Left"
                    else
                        direction = delta.Y > 0 and "Down" or "Up"
                    end
                    
                    callback(direction, delta, distance)
                end
                
                touchStart = nil
                touchStartTime = nil
            end
        end
    end))
    
    return function()
        Utility.DisconnectAll(connections)
    end
end

function GestureRecognizer:Pan(element, callback, options)
    options = options or {}
    
    local isPanning = false
    local lastPosition = nil
    
    local connections = {}
    
    table.insert(connections, element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            isPanning = true
            lastPosition = input.Position
            callback("Start", Vector2.new(0, 0), input.Position)
        end
    end))
    
    table.insert(connections, element.InputChanged:Connect(function(input)
        if isPanning and (input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseMovement) then
            if lastPosition then
                local delta = input.Position - lastPosition
                callback("Move", delta, input.Position)
                lastPosition = input.Position
            end
        end
    end))
    
    table.insert(connections, element.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isPanning then
                isPanning = false
                callback("End", Vector2.new(0, 0), input.Position)
                lastPosition = nil
            end
        end
    end))
    
    return function()
        Utility.DisconnectAll(connections)
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- SCREEN GUI CREATION
-- ════════════════════════════════════════════════════════════════════════════════
local function CreateScreenGui()
    local screenGui
    
    local success = pcall(function()
        screenGui = Utility.Create("ScreenGui", {
            Name = "NexusUI_" .. math.random(100000, 999999),
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true,
            DisplayOrder = 999
        })
        
        local coreGuiSuccess = pcall(function()
            screenGui.Parent = CoreGui
        end)
        
        if not coreGuiSuccess then
            screenGui.Parent = Player:WaitForChild("PlayerGui")
        end
    end)
    
    if not success then
        warn("[NexusUI] Failed to create ScreenGui")
        return nil
    end
    
    return screenGui
end

-- ════════════════════════════════════════════════════════════════════════════════
-- MAIN LIBRARY TABLE
-- ════════════════════════════════════════════════════════════════════════════════
local NexusUI = {
    Version = Config.Version,
    Windows = {},
    Flags = {},
    Connections = {},
    ToggleKey = Enum.KeyCode.RightControl,
    
    -- Expose systems
    Device = DeviceManager,
    Performance = PerformanceManager,
    Theme = ThemeManager,
    State = StateManager,
    Animation = AnimationEngine,
    Gesture = GestureRecognizer,
    Pool = ObjectPool,
    Utility = Utility,
    Spring = Spring,
    Config = Config,
}

-- ════════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM - Premium Toast Notifications
-- ════════════════════════════════════════════════════════════════════════════════
local NotificationManager = {
    Container = nil,
    Notifications = {},
    MaxVisible = 5,
    DefaultDuration = 4,
    Position = "BottomRight", -- TopLeft, TopRight, BottomLeft, BottomRight, TopCenter, BottomCenter
}

local NotificationPositions = {
    TopLeft = {Position = UDim2.new(0, 20, 0, 20), AnchorPoint = Vector2.new(0, 0), VerticalAlignment = Enum.VerticalAlignment.Top},
    TopRight = {Position = UDim2.new(1, -20, 0, 20), AnchorPoint = Vector2.new(1, 0), VerticalAlignment = Enum.VerticalAlignment.Top},
    TopCenter = {Position = UDim2.new(0.5, 0, 0, 20), AnchorPoint = Vector2.new(0.5, 0), VerticalAlignment = Enum.VerticalAlignment.Top},
    BottomLeft = {Position = UDim2.new(0, 20, 1, -20), AnchorPoint = Vector2.new(0, 1), VerticalAlignment = Enum.VerticalAlignment.Bottom},
    BottomRight = {Position = UDim2.new(1, -20, 1, -20), AnchorPoint = Vector2.new(1, 1), VerticalAlignment = Enum.VerticalAlignment.Bottom},
    BottomCenter = {Position = UDim2.new(0.5, 0, 1, -20), AnchorPoint = Vector2.new(0.5, 1), VerticalAlignment = Enum.VerticalAlignment.Bottom},
}

function NotificationManager:EnsureContainer(screenGui)
    if self.Container and self.Container.Parent then
        return self.Container
    end
    
    local posConfig = NotificationPositions[self.Position]
    
    self.Container = Utility.Create("Frame", {
        Name = "NotificationContainer",
        BackgroundTransparency = 1,
        Position = posConfig.Position,
        Size = UDim2.new(0, 350, 1, -40),
        AnchorPoint = posConfig.AnchorPoint,
        Parent = screenGui
    }, {
        Utility.Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = posConfig.VerticalAlignment,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 12)
        })
    })
    
    return self.Container
end

function NotificationManager:Notify(screenGui, options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or self.DefaultDuration
    local notifType = options.Type or "Info"
    local icon = options.Icon
    local actions = options.Actions or {}
    local dismissible = options.Dismissible ~= false
    local progress = options.Progress ~= false
    local sound = options.Sound ~= false
    
    local container = self:EnsureContainer(screenGui)
    local theme = ThemeManager:GetTheme()
    
    -- Type configurations
    local typeConfigs = {
        Success = {
            color = theme.Success,
            icon = "✓",
            iconImage = "rbxassetid://3926305904",
            iconRect = Vector2.new(312, 4),
            iconRectSize = Vector2.new(24, 24)
        },
        Warning = {
            color = theme.Warning,
            icon = "⚠",
            iconImage = "rbxassetid://3926305904",
            iconRect = Vector2.new(364, 324),
            iconRectSize = Vector2.new(36, 36)
        },
        Error = {
            color = theme.Error,
            icon = "✕",
            iconImage = "rbxassetid://3926305904",
            iconRect = Vector2.new(924, 724),
            iconRectSize = Vector2.new(36, 36)
        },
        Info = {
            color = theme.Info,
            icon = "ℹ",
            iconImage = "rbxassetid://3926305904",
            iconRect = Vector2.new(764, 244),
            iconRectSize = Vector2.new(36, 36)
        }
    }
    
    local config = typeConfigs[notifType] or typeConfigs.Info
    
    -- Calculate height based on content
    local hasActions = #actions > 0
    local baseHeight = 75
    if hasActions then baseHeight = baseHeight + 40 end
    
    -- Create notification frame
    local notification = Utility.Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = theme.SurfaceTransparency or 0,
        Size = UDim2.new(1, 0, 0, baseHeight),
        Position = UDim2.new(1, 60, 0, 0),
        ClipsDescendants = true,
        Parent = container
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIStroke", {
            Color = theme.Border,
            Thickness = 1,
            Transparency = theme.BorderTransparency or 0
        })
    })
    
    -- Add shadow
    Utility.CreateShadow(notification, 6, 0.7)
    
    -- Accent bar
    local accentBar = Utility.Create("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = config.color,
        Size = UDim2.new(0, 4, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        Parent = notification
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 2)})
    })
    
    -- Add glow to accent
    if PerformanceManager:ShouldGlow() then
        Utility.CreateGlow(accentBar, config.color, 0.4)
    end
    
    -- Icon
    local iconLabel = Utility.Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = config.iconImage,
        ImageColor3 = config.color,
        ImageRectOffset = config.iconRect,
        ImageRectSize = config.iconRectSize,
        Position = UDim2.new(0, 24, 0, 14),
        Size = UDim2.fromOffset(22, 22),
        Parent = notification
    })
    
    -- Title
    Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 56, 0, 12),
        Size = UDim2.new(1, -100, 0, 20),
        Font = theme.Font,
        Text = title,
        TextColor3 = theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = notification
    })
    
    -- Content
    Utility.Create("TextLabel", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 56, 0, 34),
        Size = UDim2.new(1, -70, 0, 32),
        Font = theme.FontSecondary,
        Text = content,
        TextColor3 = theme.TextSecondary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = notification
    })
    
    -- Close button
    if dismissible then
        local closeBtn = Utility.Create("TextButton", {
            Name = "CloseBtn",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -32, 0, 8),
            Size = UDim2.fromOffset(24, 24),
            Text = "×",
            TextColor3 = theme.TextMuted,
            TextSize = 20,
            Font = theme.Font,
            Parent = notification
        })
        
        closeBtn.MouseEnter:Connect(function()
            Utility.Tween(closeBtn, {TextColor3 = theme.Error}, 0.15)
        end)
        
        closeBtn.MouseLeave:Connect(function()
            Utility.Tween(closeBtn, {TextColor3 = theme.TextMuted}, 0.15)
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            self:Dismiss(notification)
        end)
    end
    
    -- Action buttons
    if hasActions then
        local actionsContainer = Utility.Create("Frame", {
            Name = "Actions",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 56, 0, baseHeight - 45),
            Size = UDim2.new(1, -66, 0, 32),
            Parent = notification
        }, {
            Utility.Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0, 8)
            })
        })
        
        for _, action in ipairs(actions) do
            local actionBtn = Utility.Create("TextButton", {
                Name = "Action_" .. action.Text,
                BackgroundColor3 = action.Primary and config.color or theme.Elevated,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Font = theme.Font,
                Text = action.Text,
                TextColor3 = action.Primary and theme.Background or theme.Text,
                TextSize = 12,
                Parent = actionsContainer
            }, {
                Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                Utility.Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12)
                })
            })
            
            actionBtn.MouseButton1Click:Connect(function()
                if action.Callback then
                    action.Callback()
                end
                if action.Dismiss ~= false then
                    self:Dismiss(notification)
                end
            end)
            
            actionBtn.MouseEnter:Connect(function()
                Utility.Tween(actionBtn, {
                    BackgroundColor3 = action.Primary and Utility.Lighten(config.color, 0.1) or theme.BorderLight
                }, 0.15)
            end)
            
            actionBtn.MouseLeave:Connect(function()
                Utility.Tween(actionBtn, {
                    BackgroundColor3 = action.Primary and config.color or theme.Elevated
                }, 0.15)
            end)
        end
    end
    
    -- Progress bar
    local progressBar
    if progress then
        local progressBg = Utility.Create("Frame", {
            Name = "ProgressBg",
            BackgroundColor3 = theme.Elevated,
            Position = UDim2.new(0, 0, 1, -3),
            Size = UDim2.new(1, 0, 0, 3),
            Parent = notification
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 2)})
        })
        
        progressBar = Utility.Create("Frame", {
            Name = "ProgressFill",
            BackgroundColor3 = config.color,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = progressBg
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 2)})
        })
    end
    
    -- Sound
    if sound then
        Utility.PlaySound("Notification")
    end
    
    -- Swipe to dismiss
    if DeviceManager:IsTouchDevice() and dismissible then
        GestureRecognizer:Swipe(notification, function(direction)
            if direction == "Right" or direction == "Left" then
                self:Dismiss(notification, direction)
            end
        end)
    end
    
    -- Animate in
    AnimationEngine:Animate(notification, {
        Position = UDim2.new(0, 0, 0, 0)
    }, 0.4, "OutBack")
    
    -- Progress bar animation
    if progressBar then
        AnimationEngine:Animate(progressBar, {
            Size = UDim2.new(0, 0, 1, 0)
        }, duration, "Linear")
    end
    
    -- Store notification
    table.insert(self.Notifications, notification)
    
    -- Auto dismiss
    task.delay(duration, function()
        if notification and notification.Parent then
            self:Dismiss(notification)
        end
    end)
    
    return notification
end

function NotificationManager:Dismiss(notification, direction)
    if not notification or not notification.Parent then return end
    
    -- Remove from list
    for i, notif in ipairs(self.Notifications) do
        if notif == notification then
            table.remove(self.Notifications, i)
            break
        end
    end
    
    -- Animate out
    local targetPos
    if direction == "Left" then
        targetPos = UDim2.new(-1, -60, 0, 0)
    else
        targetPos = UDim2.new(1, 60, 0, 0)
    end
    
    AnimationEngine:Animate(notification, {
        Position = targetPos,
        BackgroundTransparency = 1
    }, 0.3, "InBack", function()
        if notification then
            notification:Destroy()
        end
    end)
end

function NotificationManager:DismissAll()
    for _, notification in ipairs(self.Notifications) do
        self:Dismiss(notification)
    end
end

function NotificationManager:SetPosition(position)
    if NotificationPositions[position] then
        self.Position = position
        
        if self.Container then
            local config = NotificationPositions[position]
            self.Container.Position = config.Position
            self.Container.AnchorPoint = config.AnchorPoint
            
            local layout = self.Container:FindFirstChildOfClass("UIListLayout")
            if layout then
                layout.VerticalAlignment = config.VerticalAlignment
            end
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- DISCORD INTEGRATION - Live Server Display
-- ════════════════════════════════════════════════════════════════════════════════
local DiscordIntegration = {
    Cache = {},
    CacheDuration = 60,
}

function DiscordIntegration:FetchServerData(inviteCode)
    -- Check cache first
    local cached = self.Cache[inviteCode]
    if cached and (tick() - cached.timestamp) < self.CacheDuration then
        return cached.data
    end
    
    local success, result = pcall(function()
        local url = "https://discord.com/api/v10/invites/" .. inviteCode .. "?with_counts=true"
        local response = HttpService:GetAsync(url)
        return HttpService:JSONDecode(response)
    end)
    
    if success and result then
        local data = {
            ServerName = result.guild and result.guild.name or "Unknown Server",
            MemberCount = result.approximate_member_count or 0,
            OnlineCount = result.approximate_presence_count or 0,
            Icon = result.guild and result.guild.icon and 
                   ("https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=128") or nil,
            Banner = result.guild and result.guild.banner and 
                     ("https://cdn.discordapp.com/banners/" .. result.guild.id .. "/" .. result.guild.banner .. ".png?size=512") or nil,
            Verified = result.guild and result.guild.features and table.find(result.guild.features, "VERIFIED") ~= nil,
            Partnered = result.guild and result.guild.features and table.find(result.guild.features, "PARTNERED") ~= nil,
            InviteCode = inviteCode,
            InviteUrl = "https://discord.gg/" .. inviteCode,
        }
        
        -- Cache the result
        self.Cache[inviteCode] = {
            data = data,
            timestamp = tick()
        }
        
        return data
    else
        return {
            ServerName = "Discord Server",
            MemberCount = 0,
            OnlineCount = 0,
            Icon = nil,
            Banner = nil,
            Verified = false,
            Partnered = false,
            InviteCode = inviteCode,
            InviteUrl = "https://discord.gg/" .. inviteCode,
            Error = true
        }
    end
end

function DiscordIntegration:CreateCard(parent, inviteCode, options)
    options = options or {}
    local theme = ThemeManager:GetTheme()
    
    -- Initial loading state
    local card = Utility.Create("Frame", {
        Name = "DiscordCard",
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = theme.SurfaceTransparency or 0,
        Size = options.Size or UDim2.new(1, 0, 0, 90),
        Parent = parent
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIStroke", {
            Color = theme.Border,
            Thickness = 1,
            Transparency = theme.BorderTransparency or 0
        })
    })
    
    -- Add shadow
    Utility.CreateShadow(card, 4, 0.7)
    
    -- Loading skeleton
    local skeleton = Utility.Create("Frame", {
        Name = "Skeleton",
        BackgroundColor3 = theme.Elevated,
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        Parent = card
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    -- Shimmer animation
    local shimmer = Utility.Create("Frame", {
        Name = "Shimmer",
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(-0.3, 0, 0, 0),
        Parent = skeleton
    }, {
        Utility.Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0.7),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Rotation = 15
        })
    })
    
    -- Animate shimmer
    local shimmerAnim
    shimmerAnim = RunService.Heartbeat:Connect(function()
        if not shimmer or not shimmer.Parent then
            shimmerAnim:Disconnect()
            return
        end
        shimmer.Position = UDim2.new((tick() % 2) - 0.3, 0, 0, 0)
    end)
    
    -- Fetch data async
    task.spawn(function()
        local data = self:FetchServerData(inviteCode)
        
        -- Remove skeleton
        if shimmerAnim then shimmerAnim:Disconnect() end
        if skeleton then skeleton:Destroy() end
        
        -- Build card content
        self:BuildCardContent(card, data, options)
    end)
    
    return card
end

function DiscordIntegration:BuildCardContent(card, data, options)
    local theme = ThemeManager:GetTheme()
    
    -- Content container
    local content = Utility.Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = card
    }, {
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12)
        })
    })
    
    -- Server icon
    local iconFrame = Utility.Create("Frame", {
        Name = "IconFrame",
        BackgroundColor3 = theme.Elevated,
        Size = UDim2.fromOffset(50, 50),
        Position = UDim2.new(0, 0, 0, 0),
        Parent = content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 12)})
    })
    
    if data.Icon then
        -- Note: In actual Roblox, you'd need to upload the Discord icon as an asset
        -- This is a placeholder for the concept
        Utility.Create("TextLabel", {
            Name = "IconPlaceholder",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = theme.Font,
            Text = string.sub(data.ServerName, 1, 2):upper(),
            TextColor3 = theme.Accent,
            TextSize = 18,
            Parent = iconFrame
        })
    else
        Utility.Create("TextLabel", {
            Name = "IconPlaceholder",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = theme.Font,
            Text = string.sub(data.ServerName, 1, 2):upper(),
            TextColor3 = theme.Accent,
            TextSize = 18,
            Parent = iconFrame
        })
    end
    
    -- Add glow to icon
    if PerformanceManager:ShouldGlow() then
        Utility.CreateGlow(iconFrame, theme.Accent, 0.3)
    end
    
    -- Server name
    local nameContainer = Utility.Create("Frame", {
        Name = "NameContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 62, 0, 2),
        Size = UDim2.new(1, -150, 0, 22),
        Parent = content
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6)
        })
    })
    
    Utility.Create("TextLabel", {
        Name = "ServerName",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = theme.Font,
        Text = data.ServerName,
        TextColor3 = theme.Text,
        TextSize = 15,
        Parent = nameContainer
    })
    
    -- Verified/Partnered badge
    if data.Verified or data.Partnered then
        local badge = Utility.Create("Frame", {
            Name = "Badge",
            BackgroundColor3 = data.Verified and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(67, 181, 129),
            Size = UDim2.fromOffset(16, 16),
            Parent = nameContainer
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        })
        
        Utility.Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = theme.Font,
            Text = "✓",
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 10,
            Parent = badge
        })
    end
    
    -- Member counts
    local statsContainer = Utility.Create("Frame", {
        Name = "Stats",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 62, 0, 26),
        Size = UDim2.new(1, -150, 0, 18),
        Parent = content
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 12)
        })
    })
    
    -- Online count
    local onlineContainer = Utility.Create("Frame", {
        Name = "Online",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = statsContainer
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 4)
        })
    })
    
    -- Online indicator (green dot)
    local onlineDot = Utility.Create("Frame", {
        Name = "OnlineDot",
        BackgroundColor3 = Color3.fromRGB(35, 165, 90),
        Size = UDim2.fromOffset(8, 8),
        Parent = onlineContainer
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Pulse animation for online dot
    task.spawn(function()
        while onlineDot and onlineDot.Parent do
            AnimationEngine:Animate(onlineDot, {Size = UDim2.fromOffset(10, 10)}, 0.5, "OutQuad")
            task.wait(0.5)
            AnimationEngine:Animate(onlineDot, {Size = UDim2.fromOffset(8, 8)}, 0.5, "InQuad")
            task.wait(0.5)
        end
    end)
    
    Utility.Create("TextLabel", {
        Name = "OnlineCount",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = theme.FontSecondary,
        Text = self:FormatNumber(data.OnlineCount) .. " Online",
        TextColor3 = theme.TextSecondary,
        TextSize = 12,
        Parent = onlineContainer
    })
    
    -- Total members
    local membersContainer = Utility.Create("Frame", {
        Name = "Members",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = statsContainer
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 4)
        })
    })
    
    Utility.Create("Frame", {
        Name = "MemberDot",
        BackgroundColor3 = theme.TextMuted,
        Size = UDim2.fromOffset(8, 8),
        Parent = membersContainer
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    Utility.Create("TextLabel", {
        Name = "MemberCount",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = theme.FontSecondary,
        Text = self:FormatNumber(data.MemberCount) .. " Members",
        TextColor3 = theme.TextSecondary,
        TextSize = 12,
        Parent = membersContainer
    })
    
    -- Join button
    local joinBtn = Utility.Create("TextButton", {
        Name = "JoinButton",
        BackgroundColor3 = Color3.fromRGB(88, 101, 242), -- Discord blurple
        Position = UDim2.new(1, -80, 0.5, -15),
        Size = UDim2.fromOffset(80, 30),
        Font = theme.Font,
        Text = "Join",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 13,
        AutoButtonColor = false,
        Parent = content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    -- Join button interactions
    joinBtn.MouseEnter:Connect(function()
        Utility.Tween(joinBtn, {BackgroundColor3 = Color3.fromRGB(71, 82, 196)}, 0.15)
    end)
    
    joinBtn.MouseLeave:Connect(function()
        Utility.Tween(joinBtn, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}, 0.15)
    end)
    
    joinBtn.MouseButton1Click:Connect(function()
        Utility.Ripple(joinBtn, UserInputService:GetMouseLocation())
        
        -- Copy invite to clipboard
        if setclipboard then
            setclipboard(data.InviteUrl)
        end
        
        -- Show notification
        NotificationManager:Notify(card:FindFirstAncestorOfClass("ScreenGui"), {
            Title = "Discord Invite Copied!",
            Content = "Paste " .. data.InviteUrl .. " in your browser to join.",
            Type = "Success",
            Duration = 3
        })
    end)
    
    -- Auto-refresh every 60 seconds
    if options.AutoRefresh ~= false then
        task.spawn(function()
            while card and card.Parent do
                task.wait(60)
                if card and card.Parent then
                    local newData = self:FetchServerData(data.InviteCode)
                    -- Update counts with animation
                    self:UpdateCounts(content, newData)
                end
            end
        end)
    end
end

function DiscordIntegration:FormatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

function DiscordIntegration:UpdateCounts(content, data)
    local onlineLabel = content:FindFirstChild("Stats") and 
                       content.Stats:FindFirstChild("Online") and 
                       content.Stats.Online:FindFirstChild("OnlineCount")
    local memberLabel = content:FindFirstChild("Stats") and 
                       content.Stats:FindFirstChild("Members") and 
                       content.Stats.Members:FindFirstChild("MemberCount")
    
    if onlineLabel then
        onlineLabel.Text = self:FormatNumber(data.OnlineCount) .. " Online"
    end
    
    if memberLabel then
        memberLabel.Text = self:FormatNumber(data.MemberCount) .. " Members"
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- TOGGLE ELEMENT
-- ════════════════════════════════════════════════════════════════════════════════
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(section, options)
    local self = setmetatable({}, Toggle)
    
    self.Section = section
    self.Title = options.Title or "Toggle"
    self.Description = options.Description
    self.Default = options.Default or false
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag
    self.Enabled = self.Default
    self.Locked = options.Locked or false
    self.Tooltip = options.Tooltip
    self.Icon = options.Icon
    
    self:Create()
    
    if self.Flag then
        NexusUI.Flags[self.Flag] = self
    end
    
    return self
end

function Toggle:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 56 or device.ButtonMinSize + 6
    
    self.Container = Utility.Create("Frame", {
        Name = "Toggle_" .. self.Title,
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = theme.ElevatedTransparency or 0,
        Size = UDim2.new(1, 0, 0, height),
        ClipsDescendants = true,
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = 1,
            Transparency = theme.BorderTransparency or 0
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Icon (optional)
    local textOffset = 0
    if self.Icon then
        self.IconLabel = Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = theme.Accent,
            Position = UDim2.new(0, 0, 0, hasDescription and 10 or (height/2 - 10)),
            Size = UDim2.fromOffset(20, 20),
            Parent = self.Container
        })
        textOffset = 28
    end
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, textOffset, 0, hasDescription and 10 or 0),
        Size = UDim2.new(1, -70 - textOffset, 0, hasDescription and 20 or height),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = self.Locked and theme.TextDisabled or theme.Text,
        TextSize = 14 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Description
    if hasDescription then
        self.DescLabel = Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, textOffset, 0, 32),
            Size = UDim2.new(1, -70 - textOffset, 0, 18),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = self.Container
        })
    end
    
    -- Switch
    local switchWidth = DeviceManager:IsTouchDevice() and 52 or 46
    local switchHeight = DeviceManager:IsTouchDevice() and 28 or 24
    local circleSize = switchHeight - 4
    
    self.Switch = Utility.Create("Frame", {
        Name = "Switch",
        BackgroundColor3 = self.Enabled and theme.Accent or theme.Border,
        Position = UDim2.new(1, -switchWidth - 2, 0.5, -switchHeight/2),
        Size = UDim2.fromOffset(switchWidth, switchHeight),
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Switch circle
    self.Circle = Utility.Create("Frame", {
        Name = "Circle",
        BackgroundColor3 = theme.Text,
        Position = self.Enabled and UDim2.new(1, -circleSize - 2, 0.5, -circleSize/2) or UDim2.new(0, 2, 0.5, -circleSize/2),
        Size = UDim2.fromOffset(circleSize, circleSize),
        Parent = self.Switch
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Checkmark in circle
    self.Checkmark = Utility.Create("TextLabel", {
        Name = "Checkmark",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = theme.Font,
        Text = "✓",
        TextColor3 = self.Enabled and theme.Accent or theme.Border,
        TextSize = circleSize * 0.6,
        TextTransparency = self.Enabled and 0 or 1,
        Parent = self.Circle
    })
    
    -- Glow effect
    if PerformanceManager:ShouldGlow() and self.Enabled then
        self.SwitchGlow = Utility.CreateGlow(self.Switch, theme.Accent, 0.4)
    end
    
    -- Click area
    local clickArea = Utility.Create("TextButton", {
        Name = "ClickArea",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = self.Container
    })
    
    -- Interactions
    clickArea.MouseButton1Click:Connect(function()
        if self.Locked then return end
        Utility.PlaySound("Toggle")
        Utility.Ripple(self.Container, UserInputService:GetMouseLocation(), theme.Accent)
        self:Toggle()
    end)
    
    clickArea.MouseEnter:Connect(function()
        if self.Locked then return end
        Utility.Tween(self.Container.Stroke, {Color = theme.BorderLight}, 0.15)
        Utility.Tween(self.Container, {BackgroundColor3 = Utility.Lighten(theme.Elevated, 0.02)}, 0.15)
    end)
    
    clickArea.MouseLeave:Connect(function()
        Utility.Tween(self.Container.Stroke, {Color = theme.Border}, 0.15)
        Utility.Tween(self.Container, {BackgroundColor3 = theme.Elevated}, 0.15)
    end)
    
    -- Touch gesture support
    if DeviceManager:IsTouchDevice() then
        GestureRecognizer:Swipe(self.Switch, function(direction)
            if self.Locked then return end
            if direction == "Right" and not self.Enabled then
                self:Toggle(true)
            elseif direction == "Left" and self.Enabled then
                self:Toggle(false)
            end
        end)
    end
end

function Toggle:Toggle(value)
    if self.Locked then return self end
    
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    local switchHeight = DeviceManager:IsTouchDevice() and 28 or 24
    local circleSize = switchHeight - 4
    
    if value ~= nil then
        self.Enabled = value
    else
        self.Enabled = not self.Enabled
    end
    
    -- Animate switch
    AnimationEngine:Animate(self.Switch, {
        BackgroundColor3 = self.Enabled and theme.Accent or theme.Border
    }, 0.2, "OutQuart")
    
    AnimationEngine:Animate(self.Circle, {
        Position = self.Enabled and UDim2.new(1, -circleSize - 2, 0.5, -circleSize/2) or UDim2.new(0, 2, 0.5, -circleSize/2)
    }, 0.2, "OutBack")
    
    AnimationEngine:Animate(self.Checkmark, {
        TextColor3 = self.Enabled and theme.Accent or theme.Border,
        TextTransparency = self.Enabled and 0 or 1
    }, 0.2, "OutQuart")
    
    -- Glow
    if self.SwitchGlow then
        AnimationEngine:Animate(self.SwitchGlow, {
            ImageTransparency = self.Enabled and 0.6 or 1
        }, 0.2)
    elseif self.Enabled and PerformanceManager:ShouldGlow() then
        self.SwitchGlow = Utility.CreateGlow(self.Switch, theme.Accent, 0.4)
    end
    
    -- Haptic feedback
    Utility.Haptic(0.3)
    
    -- Callback
    task.spawn(function()
        local success, err = pcall(self.Callback, self.Enabled)
        if not success then
            warn("[NexusUI] Toggle callback error:", err)
        end
    end)
    
    -- Update state
    StateManager:Set("toggles." .. (self.Flag or self.Title), self.Enabled)
    
    return self
end

function Toggle:Set(value)
    return self:Toggle(value)
end

function Toggle:Get()
    return self.Enabled
end

function Toggle:SetLocked(locked)
    local theme = ThemeManager:GetTheme()
    self.Locked = locked
    self.Label.TextColor3 = locked and theme.TextDisabled or theme.Text
    return self
end

function Toggle:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- BUTTON ELEMENT
-- ════════════════════════════════════════════════════════════════════════════════
local Button = {}
Button.__index = Button

function Button.new(section, options)
    local self = setmetatable({}, Button)
    
    self.Section = section
    self.Title = options.Title or "Button"
    self.Description = options.Description
    self.Callback = options.Callback or function() end
    self.Variant = options.Variant or "Primary" -- Primary, Secondary, Outline, Ghost, Danger
    self.Icon = options.Icon
    self.Disabled = options.Disabled or false
    self.Loading = false
    
    self:Create()
    
    return self
end

function Button:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 56 or device.ButtonMinSize + 6
    
    -- Variant colors
    local variants = {
        Primary = {
            bg = theme.Accent,
            bgHover = theme.AccentHover,
            text = theme.Background,
            border = theme.Accent
        },
        Secondary = {
            bg = theme.Elevated,
            bgHover = theme.BorderLight,
            text = theme.Text,
            border = theme.Border
        },
        Outline = {
            bg = Color3.new(0, 0, 0),
            bgTransparency = 1,
            bgHover = theme.Elevated,
            bgHoverTransparency = 0.5,
            text = theme.Accent,
            border = theme.Accent
        },
        Ghost = {
            bg = Color3.new(0, 0, 0),
            bgTransparency = 1,
            bgHover = theme.Elevated,
            bgHoverTransparency = 0.5,
            text = theme.Text,
            border = Color3.new(0, 0, 0),
            borderTransparency = 1
        },
        Danger = {
            bg = theme.Error,
            bgHover = Utility.Lighten(theme.Error, 0.1),
            text = Color3.new(1, 1, 1),
            border = theme.Error
        }
    }
    
    local variant = variants[self.Variant] or variants.Primary
    
    self.Container = Utility.Create("Frame", {
        Name = "Button_" .. self.Title,
        BackgroundColor3 = variant.bg,
        BackgroundTransparency = variant.bgTransparency or 0,
        Size = UDim2.new(1, 0, 0, height),
        ClipsDescendants = true,
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = variant.border,
            Thickness = 1,
            Transparency = variant.borderTransparency or 0
        })
    })
    
    -- Add gradient for primary/danger variants
    if self.Variant == "Primary" or self.Variant == "Danger" then
        Utility.Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, variant.bg),
                ColorSequenceKeypoint.new(1, Utility.Darken(variant.bg, 0.1))
            }),
            Rotation = 90,
            Parent = self.Container
        })
    end
    
    -- Add glow for primary
    if self.Variant == "Primary" and PerformanceManager:ShouldGlow() then
        self.Glow = Utility.CreateGlow(self.Container, theme.Accent, 0.2)
    end
    
    -- Content
    local contentContainer = Utility.Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self.Container
    }, {
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Icon
    local textOffset = 0
    if self.Icon then
        self.IconLabel = Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = variant.text,
            Position = UDim2.new(0, 0, 0.5, -10),
            Size = UDim2.fromOffset(20, 20),
            Parent = contentContainer
        })
        textOffset = 28
    end
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, textOffset, 0, hasDescription and 10 or 0),
        Size = UDim2.new(1, -textOffset, 0, hasDescription and 20 or height),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = self.Disabled and theme.TextDisabled or variant.text,
        TextSize = 14 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = contentContainer
    })
    
    -- Description
    if hasDescription then
        self.DescLabel = Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, textOffset, 0, 32),
            Size = UDim2.new(1, -textOffset, 0, 18),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = self.Variant == "Primary" and Utility.Darken(variant.text, 0.2) or theme.TextMuted,
            TextSize = 12 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = contentContainer
        })
    end
    
    -- Loading spinner (hidden initially)
    self.Spinner = Utility.Create("Frame", {
        Name = "Spinner",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0.5, -10),
        Size = UDim2.fromOffset(20, 20),
        Visible = false,
        Parent = contentContainer
    })
    
    local spinnerCircle = Utility.Create("Frame", {
        Name = "Circle",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self.Spinner
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Utility.Create("UIStroke", {
            Color = variant.text,
            Thickness = 2
        })
    })
    
    -- Click area
    self.ButtonElement = Utility.Create("TextButton", {
        Name = "ClickArea",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = self.Container
    })
    
    -- Interactions
    self.ButtonElement.MouseButton1Click:Connect(function()
        if self.Disabled or self.Loading then return end
        
        Utility.PlaySound("Click")
        Utility.Ripple(self.Container, UserInputService:GetMouseLocation(), variant.text)
        Utility.Haptic(0.2)
        
        -- Press animation
        AnimationEngine:Animate(self.Container, {
            Size = UDim2.new(1, -4, 0, height - 2)
        }, 0.1, "OutQuad", function()
            AnimationEngine:Animate(self.Container, {
                Size = UDim2.new(1, 0, 0, height)
            }, 0.15, "OutBack")
        end)
        
        task.spawn(function()
            local success, err = pcall(self.Callback)
            if not success then
                warn("[NexusUI] Button callback error:", err)
            end
        end)
    end)
    
    self.ButtonElement.MouseEnter:Connect(function()
        if self.Disabled or self.Loading then return end
        
        AnimationEngine:Animate(self.Container, {
            BackgroundColor3 = variant.bgHover,
            BackgroundTransparency = variant.bgHoverTransparency or 0
        }, 0.15)
        
        if self.Glow then
            AnimationEngine:Animate(self.Glow, {ImageTransparency = 0.4}, 0.15)
        end
    end)
    
    self.ButtonElement.MouseLeave:Connect(function()
        if self.Disabled or self.Loading then return end
        
        AnimationEngine:Animate(self.Container, {
            BackgroundColor3 = variant.bg,
            BackgroundTransparency = variant.bgTransparency or 0
        }, 0.15)
        
        if self.Glow then
            AnimationEngine:Animate(self.Glow, {ImageTransparency = 0.6}, 0.15)
        end
    end)
end

function Button:SetLoading(loading)
    self.Loading = loading
    self.Spinner.Visible = loading
    
    if loading then
        -- Spin animation
        task.spawn(function()
            while self.Loading and self.Spinner and self.Spinner.Parent do
                self.Spinner.Rotation = self.Spinner.Rotation + 5
                task.wait()
            end
        end)
    end
    
    return self
end

function Button:SetDisabled(disabled)
    local theme = ThemeManager:GetTheme()
    self.Disabled = disabled
    self.Label.TextColor3 = disabled and theme.TextDisabled or theme.Text
    self.Container.BackgroundTransparency = disabled and 0.5 or 0
    return self
end

function Button:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- SLIDER ELEMENT
-- ════════════════════════════════════════════════════════════════════════════════
local Slider = {}
Slider.__index = Slider

function Slider.new(section, options)
    local self = setmetatable({}, Slider)
    
    self.Section = section
    self.Title = options.Title or "Slider"
    self.Description = options.Description
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = options.Default or self.Min
    self.Increment = options.Increment or 1
    self.Suffix = options.Suffix or ""
    self.Prefix = options.Prefix or ""
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag
    self.Value = self.Default
    self.Dragging = false
    self.ShowInput = options.ShowInput or false
    
    self:Create()
    
    if self.Flag then
        NexusUI.Flags[self.Flag] = self
    end
    
    return self
end

function Slider:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 75 or 60
    
    self.Container = Utility.Create("Frame", {
        Name = "Slider_" .. self.Title,
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = theme.ElevatedTransparency or 0,
        Size = UDim2.new(1, 0, 0, height),
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = 1,
            Transparency = theme.BorderTransparency or 0
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
    })
    
    -- Header
    local headerFrame = Utility.Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Parent = self.Container
    })
    
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 1, 0),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = headerFrame
    })
    
    -- Value display
    local valueText = self.Prefix .. tostring(self.Value) .. self.Suffix
    
    if self.ShowInput then
        self.ValueInput = Utility.Create("TextBox", {
            Name = "ValueInput",
            BackgroundColor3 = theme.Surface,
            Position = UDim2.new(0.6, 0, 0, -2),
            Size = UDim2.new(0.4, 0, 0, 22),
            Font = theme.Font,
            Text = valueText,
            TextColor3 = theme.Accent,
            TextSize = 13 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Right,
            ClearTextOnFocus = false,
            Parent = headerFrame
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Utility.Create("UIPadding", {
                PaddingRight = UDim.new(0, 8)
            })
        })
        
        self.ValueInput.FocusLost:Connect(function()
            local numText = self.ValueInput.Text:gsub(self.Prefix, ""):gsub(self.Suffix, "")
            local num = tonumber(numText)
            if num then
                self:Set(num)
            else
                self.ValueInput.Text = self.Prefix .. tostring(self.Value) .. self.Suffix
            end
        end)
    else
        self.ValueLabel = Utility.Create("TextLabel", {
            Name = "Value",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.6, 0, 0, 0),
            Size = UDim2.new(0.4, 0, 1, 0),
            Font = theme.Font,
            Text = valueText,
            TextColor3 = theme.Accent,
            TextSize = 13 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = headerFrame
        })
    end
    
    -- Description
    local sliderY = 26
    if hasDescription then
        Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 22),
            Size = UDim2.new(1, 0, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
        sliderY = 42
    end
    
    -- Track
    local trackHeight = DeviceManager:IsTouchDevice() and 10 or 8
    self.Track = Utility.Create("Frame", {
        Name = "Track",
        BackgroundColor3 = theme.Border,
        Position = UDim2.new(0, 0, 0, sliderY),
        Size = UDim2.new(1, 0, 0, trackHeight),
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Fill
    local fillPercent = (self.Value - self.Min) / (self.Max - self.Min)
    self.Fill = Utility.Create("Frame", {
        Name = "Fill",
        BackgroundColor3 = theme.Accent,
        Size = UDim2.new(fillPercent, 0, 1, 0),
        Parent = self.Track
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Gradient on fill
    Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.AccentActive),
            ColorSequenceKeypoint.new(1, theme.Accent)
        }),
        Rotation = 0,
        Parent = self.Fill
    })
    
    -- Handle
    local handleSize = DeviceManager:IsTouchDevice() and 24 or 20
    self.Handle = Utility.Create("Frame", {
        Name = "Handle",
        BackgroundColor3 = theme.Text,
        Position = UDim2.new(fillPercent, -handleSize/2, 0.5, -handleSize/2),
        Size = UDim2.fromOffset(handleSize, handleSize),
        Parent = self.Track
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Utility.Create("UIStroke", {
            Color = theme.Accent,
            Thickness = 3
        })
    })
    
    -- Glow on handle
    if PerformanceManager:ShouldGlow() then
        self.HandleGlow = Utility.CreateGlow(self.Handle, theme.Accent, 0.3)
    end
    
    -- Inner circle
    Utility.Create("Frame", {
        Name = "Inner",
        BackgroundColor3 = theme.Accent,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(handleSize * 0.4, handleSize * 0.4),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = self.Handle
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Input handling
    local inputArea = Utility.Create("TextButton", {
        Name = "InputArea",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -14, 0, sliderY - 10),
        Size = UDim2.new(1, 28, 0, trackHeight + 20),
        Text = "",
        Parent = self.Container
    })
    
    local function updateSlider(inputX)
        local trackAbsPos = self.Track.AbsolutePosition.X
        local trackAbsSize = self.Track.AbsoluteSize.X
        
        local relativePos = Utility.Clamp((inputX - trackAbsPos) / trackAbsSize, 0, 1)
        local rawValue = self.Min + (self.Max - self.Min) * relativePos
        self.Value = Utility.Round(rawValue, self.Increment)
        self.Value = Utility.Clamp(self.Value, self.Min, self.Max)
        
        local percent = (self.Value - self.Min) / (self.Max - self.Min)
        
        self.Fill.Size = UDim2.new(percent, 0, 1, 0)
        self.Handle.Position = UDim2.new(percent, -handleSize/2, 0.5, -handleSize/2)
        
        local displayText = self.Prefix .. tostring(self.Value) .. self.Suffix
        if self.ValueLabel then
            self.ValueLabel.Text = displayText
        elseif self.ValueInput then
            self.ValueInput.Text = displayText
        end
        
        task.spawn(function()
            pcall(self.Callback, self.Value)
        end)
        
        StateManager:Set("sliders." .. (self.Flag or self.Title), self.Value)
    end
    
    inputArea.MouseButton1Down:Connect(function()
        self.Dragging = true
        Utility.PlaySound("Hover")
        updateSlider(UserInputService:GetMouseLocation().X)
        
        -- Scale up handle
        AnimationEngine:Animate(self.Handle, {
            Size = UDim2.fromOffset(handleSize * 1.2, handleSize * 1.2)
        }, 0.15, "OutBack")
        
        if self.HandleGlow then
            AnimationEngine:Animate(self.HandleGlow, {ImageTransparency = 0.3}, 0.15)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            if self.Dragging then
                self.Dragging = false
                
                AnimationEngine:Animate(self.Handle, {
                    Size = UDim2.fromOffset(handleSize, handleSize)
                }, 0.15, "OutBack")
                
                if self.HandleGlow then
                    AnimationEngine:Animate(self.HandleGlow, {ImageTransparency = 0.5}, 0.15)
                end
                
                Utility.Haptic(0.1)
            end
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if self.Dragging then
            updateSlider(UserInputService:GetMouseLocation().X)
        end
    end)
    
    -- Hover effects
    inputArea.MouseEnter:Connect(function()
        Utility.Tween(self.Container.Stroke, {Color = theme.BorderLight}, 0.15)
    end)
    
    inputArea.MouseLeave:Connect(function()
        if not self.Dragging then
            Utility.Tween(self.Container.Stroke, {Color = theme.Border}, 0.15)
        end
    end)
end

function Slider:Set(value)
    value = Utility.Clamp(value, self.Min, self.Max)
    value = Utility.Round(value, self.Increment)
    self.Value = value
    
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    local handleSize = DeviceManager:IsTouchDevice() and 24 or 20
    local percent = (self.Value - self.Min) / (self.Max - self.Min)
    
    AnimationEngine:Animate(self.Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.2)
    AnimationEngine:Animate(self.Handle, {Position = UDim2.new(percent, -handleSize/2, 0.5, -handleSize/2)}, 0.2, "OutBack")
    
    local displayText = self.Prefix .. tostring(self.Value) .. self.Suffix
    if self.ValueLabel then
        self.ValueLabel.Text = displayText
    elseif self.ValueInput then
        self.ValueInput.Text = displayText
    end
    
    task.spawn(function()
        pcall(self.Callback, self.Value)
    end)
    
    return self
end

function Slider:Get()
    return self.Value
end

function Slider:SetRange(min, max)
    self.Min = min
    self.Max = max
    self:Set(Utility.Clamp(self.Value, min, max))
    return self
end

function Slider:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- DROPDOWN ELEMENT
-- ════════════════════════════════════════════════════════════════════════════════
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(section, options)
    local self = setmetatable({}, Dropdown)
    
    self.Section = section
    self.Title = options.Title or "Dropdown"
    self.Description = options.Description
    self.Values = options.Values or {}
    self.Default = options.Default
    self.MultiSelect = options.MultiSelect or false
    self.Searchable = options.Searchable or false
    self.MaxVisible = options.MaxVisible or 5
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag
    self.Opened = false
    
    if self.MultiSelect then
        self.Selected = self.Default or {}
    else
        self.Selected = self.Default or (self.Values[1] or "")
    end
    
    self:Create()
    
    if self.Flag then
        NexusUI.Flags[self.Flag] = self
    end
    
    return self
end

function Dropdown:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    local hasDescription = self.Description and self.Description ~= ""
    local headerHeight = hasDescription and 56 or device.ButtonMinSize + 6
    
    self.Container = Utility.Create("Frame", {
        Name = "Dropdown_" .. self.Title,
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = theme.ElevatedTransparency or 0,
        Size = UDim2.new(1, 0, 0, headerHeight),
        ClipsDescendants = true,
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = 1,
            Transparency = theme.BorderTransparency or 0
        })
    })
    
    -- Header
    self.Header = Utility.Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, headerHeight),
        Parent = self.Container
    }, {
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, hasDescription and 10 or 0),
        Size = UDim2.new(0.5, 0, 0, hasDescription and 20 or headerHeight),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })
    
    -- Description
    if hasDescription then
        Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 32),
            Size = UDim2.new(0.5, 0, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Header
        })
    end
    
    -- Selected value display
    local displayText = self:GetDisplayText()
    self.ValueLabel = Utility.Create("TextLabel", {
        Name = "Value",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, hasDescription and 10 or 0),
        Size = UDim2.new(0.4, -24, 0, hasDescription and 20 or headerHeight),
        Font = theme.FontSecondary,
        Text = displayText,
        TextColor3 = theme.Accent,
        TextSize = 13 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = self.Header
    })
    
    -- Arrow
    self.Arrow = Utility.Create("ImageLabel", {
        Name = "Arrow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageColor3 = theme.TextMuted,
        ImageRectOffset = Vector2.new(124, 4),
        ImageRectSize = Vector2.new(24, 24),
        Position = UDim2.new(1, -20, 0.5, -8),
        Size = UDim2.fromOffset(16, 16),
        Rotation = 0,
        Parent = self.Header
    })
    
    -- Options container
    self.OptionsContainer = Utility.Create("ScrollingFrame", {
        Name = "Options",
        BackgroundColor3 = theme.Surface,
        Position = UDim2.new(0, 0, 0, headerHeight),
        Size = UDim2.new(1, 0, 0, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.Accent,
        ScrollBarImageTransparency = 0.5,
        ClipsDescendants = true,
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 6)
        }),
        Utility.Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4)
        })
    })
    
    -- Search bar
    if self.Searchable then
        self.SearchFrame = Utility.Create("Frame", {
            Name = "SearchFrame",
            BackgroundColor3 = theme.Elevated,
            Size = UDim2.new(1, 0, 0, 32),
            LayoutOrder = -1,
            Parent = self.OptionsContainer
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Utility.Create("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
        })
        
        Utility.Create("ImageLabel", {
            Name = "SearchIcon",
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = theme.TextMuted,
            ImageRectOffset = Vector2.new(964, 324),
            ImageRectSize = Vector2.new(36, 36),
            Position = UDim2.new(0, 0, 0.5, -8),
            Size = UDim2.fromOffset(16, 16),
            Parent = self.SearchFrame
        })
        
        self.SearchBox = Utility.Create("TextBox", {
            Name = "SearchBox",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 24, 0, 0),
            Size = UDim2.new(1, -24, 1, 0),
            Font = theme.FontSecondary,
            Text = "",
            PlaceholderText = "Search...",
            PlaceholderColor3 = theme.TextMuted,
            TextColor3 = theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            Parent = self.SearchFrame
        })
        
        self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            self:RefreshOptions(self.SearchBox.Text)
        end)
    end
    
    -- Build options
    self:RefreshOptions()
    
    -- Header click
    local headerBtn = Utility.Create("TextButton", {
        Name = "HeaderButton",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = self.Header
    })
    
    headerBtn.MouseButton1Click:Connect(function()
        Utility.PlaySound("Click")
        self:Toggle()
    end)
    
    headerBtn.MouseEnter:Connect(function()
        Utility.Tween(self.Container.Stroke, {Color = theme.BorderLight}, 0.15)
        Utility.Tween(self.Arrow, {ImageColor3 = theme.Accent}, 0.15)
    end)
    
    headerBtn.MouseLeave:Connect(function()
        if not self.Opened then
            Utility.Tween(self.Container.Stroke, {Color = theme.Border}, 0.15)
            Utility.Tween(self.Arrow, {ImageColor3 = theme.TextMuted}, 0.15)
        end
    end)
end

function Dropdown:GetDisplayText()
    if self.MultiSelect then
        if #self.Selected == 0 then
            return "None selected"
        elseif #self.Selected <= 2 then
            return table.concat(self.Selected, ", ")
        else
            return #self.Selected .. " selected"
        end
    else
        return self.Selected ~= "" and self.Selected or "Select..."
    end
end

function Dropdown:RefreshOptions(filter)
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    
    -- Clear existing options
    for _, child in ipairs(self.OptionsContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Create options
    local optionHeight = device.ButtonMinSize
    for i, value in ipairs(self.Values) do
        -- Filter check
        if filter and filter ~= "" then
            if not string.find(string.lower(tostring(value)), string.lower(filter)) then
                continue
            end
        end
        
        local isSelected = self.MultiSelect and table.find(self.Selected, value) or self.Selected == value
        
        local option = Utility.Create("TextButton", {
            Name = "Option_" .. tostring(value),
            BackgroundColor3 = isSelected and theme.Accent or theme.Elevated,
            Size = UDim2.new(1, 0, 0, optionHeight),
            Font = theme.FontSecondary,
            Text = "",
            LayoutOrder = i,
            AutoButtonColor = false,
            Parent = self.OptionsContainer
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)})
        })
        
        -- Checkbox for multi-select
        local textOffset = 0
        if self.MultiSelect then
            local checkbox = Utility.Create("Frame", {
                Name = "Checkbox",
                BackgroundColor3 = isSelected and theme.Accent or theme.Border,
                Position = UDim2.new(0, 10, 0.5, -9),
                Size = UDim2.fromOffset(18, 18),
                Parent = option
            }, {
                Utility.Create("UICorner", {CornerRadius = UDim.new(0, 5)})
            })
            
            if isSelected then
                Utility.Create("TextLabel", {
                    Name = "Check",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = theme.Font,
                    Text = "✓",
                    TextColor3 = theme.Background,
                    TextSize = 12,
                    Parent = checkbox
                })
            end
            
            textOffset = 36
        end
        
        -- Option text
        Utility.Create("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, textOffset + 10, 0, 0),
            Size = UDim2.new(1, -textOffset - 30, 1, 0),
            Font = theme.FontSecondary,
            Text = tostring(value),
            TextColor3 = isSelected and (self.MultiSelect and theme.Text or theme.Background) or theme.Text,
            TextSize = 13 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = option
        })
        
        -- Selected indicator
        if not self.MultiSelect and isSelected then
            Utility.Create("ImageLabel", {
                Name = "SelectedIcon",
                BackgroundTransparency = 1,
                Image = "rbxassetid://3926305904",
                ImageColor3 = theme.Background,
                ImageRectOffset = Vector2.new(312, 4),
                ImageRectSize = Vector2.new(24, 24),
                Position = UDim2.new(1, -26, 0.5, -8),
                Size = UDim2.fromOffset(16, 16),
                Parent = option
            })
        end
        
        -- Option interactions
        option.MouseButton1Click:Connect(function()
            Utility.PlaySound("Click")
            Utility.Ripple(option, UserInputService:GetMouseLocation(), theme.Accent)
            self:SelectOption(value)
        end)
        
        option.MouseEnter:Connect(function()
            local currentSelected = (self.MultiSelect and table.find(self.Selected, value)) or self.Selected == value
            if not currentSelected then
                Utility.Tween(option, {BackgroundColor3 = theme.BorderLight}, 0.15)
            end
        end)
        
        option.MouseLeave:Connect(function()
            local currentSelected = (self.MultiSelect and table.find(self.Selected, value)) or self.Selected == value
            if not currentSelected then
                Utility.Tween(option, {BackgroundColor3 = theme.Elevated}, 0.15)
            end
        end)
    end
end

function Dropdown:SelectOption(value)
    local theme = ThemeManager:GetTheme()
    
    if self.MultiSelect then
        local index = table.find(self.Selected, value)
        if index then
            table.remove(self.Selected, index)
        else
            table.insert(self.Selected, value)
        end
    else
        self.Selected = value
        self:Toggle() -- Close on single select
    end
    
    self.ValueLabel.Text = self:GetDisplayText()
    self:RefreshOptions(self.SearchBox and self.SearchBox.Text or nil)
    
    Utility.Haptic(0.1)
    
    task.spawn(function()
        pcall(self.Callback, self.Selected)
    end)
    
    StateManager:Set("dropdowns." .. (self.Flag or self.Title), self.Selected)
end

function Dropdown:Toggle()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    self.Opened = not self.Opened
    
    local optionCount = #self.Values
    if self.Searchable then optionCount = optionCount + 1 end
    
    local optionHeight = device.ButtonMinSize
    local visibleCount = math.min(optionCount, self.MaxVisible)
    local optionsHeight = visibleCount * (optionHeight + 4) + 12
    
    local hasDescription = self.Description and self.Description ~= ""
    local headerHeight = hasDescription and 56 or device.ButtonMinSize + 6
    local totalHeight = self.Opened and (headerHeight + optionsHeight) or headerHeight
    
    AnimationEngine:Animate(self.Container, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.25, "OutQuart")
    AnimationEngine:Animate(self.OptionsContainer, {Size = UDim2.new(1, 0, 0, self.Opened and optionsHeight or 0)}, 0.25, "OutQuart")
    AnimationEngine:Animate(self.Arrow, {Rotation = self.Opened and 180 or 0}, 0.25, "OutQuart")
    
    AnimationEngine:Animate(self.Container.Stroke, {
        Color = self.Opened and theme.Accent or theme.Border
    }, 0.2)
    
    if self.Opened and self.SearchBox then
        task.delay(0.1, function()
            self.SearchBox:CaptureFocus()
        end)
    end
end

function Dropdown:Set(value)
    if self.MultiSelect then
        if type(value) == "table" then
            self.Selected = value
        end
    else
        if table.find(self.Values, value) then
            self.Selected = value
        end
    end
    
    self.ValueLabel.Text = self:GetDisplayText()
    self:RefreshOptions()
    
    task.spawn(function()
        pcall(self.Callback, self.Selected)
    end)
    
    return self
end

function Dropdown:Get()
    return self.Selected
end

function Dropdown:SetValues(values)
    self.Values = values
    self:RefreshOptions()
    return self
end

function Dropdown:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- INPUT ELEMENT
-- ════════════════════════════════════════════════════════════════════════════════
local Input = {}
Input.__index = Input

function Input.new(section, options)
    local self = setmetatable({}, Input)
    
    self.Section = section
    self.Title = options.Title or "Input"
    self.Description = options.Description
    self.Placeholder = options.Placeholder or "Enter text..."
    self.Default = options.Default or ""
    self.CharLimit = options.CharLimit
    self.NumericOnly = options.NumericOnly or false
    self.Password = options.Password or false
    self.Clearable = options.Clearable ~= false
    self.Icon = options.Icon
    self.Callback = options.Callback or function() end
    self.OnChange = options.OnChange
    self.Flag = options.Flag
    self.Value = self.Default
    
    self:Create()
    
    if self.Flag then
        NexusUI.Flags[self.Flag] = self
    end
    
    return self
end

function Input:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 85 or 70
    
    self.Container = Utility.Create("Frame", {
        Name = "Input_" .. self.Title,
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = theme.ElevatedTransparency or 0,
        Size = UDim2.new(1, 0, 0, height),
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = 1,
            Transparency = theme.BorderTransparency or 0
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
    })
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Character counter
    if self.CharLimit then
        self.CharCounter = Utility.Create("TextLabel", {
            Name = "CharCounter",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.new(0, 50, 0, 18),
            AnchorPoint = Vector2.new(1, 0),
            Font = theme.FontSecondary,
            Text = #self.Value .. "/" .. self.CharLimit,
            TextColor3 = theme.TextMuted,
            TextSize = 11 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = self.Container
        })
    end
    
    -- Description
    local inputY = 24
    if hasDescription then
        Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 20),
            Size = UDim2.new(1, 0, 0, 14),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
        inputY = 40
    end
    
    -- Input frame
    local inputHeight = DeviceManager:IsTouchDevice() and 36 or 32
    self.InputFrame = Utility.Create("Frame", {
        Name = "InputFrame",
        BackgroundColor3 = theme.Surface,
        Position = UDim2.new(0, 0, 0, inputY),
        Size = UDim2.new(1, 0, 0, inputHeight),
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility.Create("UIStroke", {
            Name = "InputStroke",
            Color = theme.Border,
            Thickness = 1
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12)
        })
    })
    
    -- Icon (optional)
    local textOffset = 0
    if self.Icon then
        self.IconLabel = Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = theme.TextMuted,
            ImageRectOffset = Vector2.new(964, 324),
            ImageRectSize = Vector2.new(36, 36),
            Position = UDim2.new(0, 0, 0.5, -8),
            Size = UDim2.fromOffset(16, 16),
            Parent = self.InputFrame
        })
        textOffset = 24
    end
    
    -- Text box
    self.TextBox = Utility.Create("TextBox", {
        Name = "TextBox",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, textOffset, 0, 0),
        Size = UDim2.new(1, -textOffset - (self.Clearable and 24 or 0), 1, 0),
        Font = self.Password and theme.FontMono or theme.FontSecondary,
        Text = self.Password and string.rep("•", #self.Value) or self.Value,
        PlaceholderText = self.Placeholder,
        PlaceholderColor3 = theme.TextMuted,
        TextColor3 = theme.Text,
        TextSize = 13 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = self.InputFrame
    })
    
    -- Clear button
    if self.Clearable then
        self.ClearButton = Utility.Create("TextButton", {
            Name = "ClearButton",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -20, 0.5, -10),
            Size = UDim2.fromOffset(20, 20),
            Text = "×",
            TextColor3 = theme.TextMuted,
            TextSize = 18,
            Font = theme.Font,
            Visible = #self.Value > 0,
            Parent = self.InputFrame
        })
        
        self.ClearButton.MouseButton1Click:Connect(function()
            self.TextBox.Text = ""
            self.Value = ""
            self.ClearButton.Visible = false
            self.TextBox:CaptureFocus()
            
            task.spawn(function()
                pcall(self.Callback, "", false)
            end)
        end)
        
        self.ClearButton.MouseEnter:Connect(function()
            Utility.Tween(self.ClearButton, {TextColor3 = theme.Error}, 0.15)
        end)
        
        self.ClearButton.MouseLeave:Connect(function()
            Utility.Tween(self.ClearButton, {TextColor3 = theme.TextMuted}, 0.15)
        end)
    end
    
    -- Password toggle
    if self.Password then
        self.ShowPassword = false
        self.PasswordToggle = Utility.Create("TextButton", {
            Name = "PasswordToggle",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, self.Clearable and -44 or -20, 0.5, -10),
            Size = UDim2.fromOffset(20, 20),
            Text = "👁",
            TextSize = 14,
            Parent = self.InputFrame
        })
        
        self.PasswordToggle.MouseButton1Click:Connect(function()
            self.ShowPassword = not self.ShowPassword
            self.TextBox.Text = self.ShowPassword and self.Value or string.rep("•", #self.Value)
            self.PasswordToggle.Text = self.ShowPassword and "🙈" or "👁"
        end)
    end
    
    -- Events
    local inputStroke = self.InputFrame:FindFirstChild("InputStroke")
    
    self.TextBox.Focused:Connect(function()
        Utility.Tween(inputStroke, {Color = theme.Accent}, 0.15)
        Utility.Tween(self.InputFrame, {BackgroundColor3 = Utility.Lighten(theme.Surface, 0.02)}, 0.15)
        
        if self.IconLabel then
            Utility.Tween(self.IconLabel, {ImageColor3 = theme.Accent}, 0.15)
        end
    end)
    
    self.TextBox.FocusLost:Connect(function(enterPressed)
        Utility.Tween(inputStroke, {Color = theme.Border}, 0.15)
        Utility.Tween(self.InputFrame, {BackgroundColor3 = theme.Surface}, 0.15)
        
        if self.IconLabel then
            Utility.Tween(self.IconLabel, {ImageColor3 = theme.TextMuted}, 0.15)
        end
        
        -- Get actual value
        if self.Password and not self.ShowPassword then
            -- Value is already stored
        else
            self.Value = self.TextBox.Text
        end
        
        if self.Clearable then
            self.ClearButton.Visible = #self.Value > 0
        end
        
        task.spawn(function()
            pcall(self.Callback, self.Value, enterPressed)
        end)
        
        StateManager:Set("inputs." .. (self.Flag or self.Title), self.Value)
    end)
    
    self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = self.TextBox.Text
        
        -- Numeric only filter
        if self.NumericOnly then
            text = text:gsub("[^%d%.%-]", "")
            if text ~= self.TextBox.Text then
                self.TextBox.Text = text
            end
        end
        
        -- Character limit
        if self.CharLimit and #text > self.CharLimit then
            text = text:sub(1, self.CharLimit)
            self.TextBox.Text = text
        end
        
        -- Update password value
        if self.Password and not self.ShowPassword then
            -- Calculate the difference
            if #text > #self.Value then
                -- Characters added
                local newChars = text:sub(#self.Value + 1)
                self.Value = self.Value .. newChars:gsub("•", "")
            elseif #text < #self.Value then
                -- Characters removed
                self.Value = self.Value:sub(1, #text)
            end
            
            -- Replace with dots
            if text:match("[^•]") then
                self.TextBox.Text = string.rep("•", #self.Value)
            end
        else
            self.Value = text
        end
        
        -- Update counter
        if self.CharCounter then
            self.CharCounter.Text = #self.Value .. "/" .. self.CharLimit
            local ratio = #self.Value / self.CharLimit
            if ratio >= 1 then
                self.CharCounter.TextColor3 = theme.Error
            elseif ratio >= 0.8 then
                self.CharCounter.TextColor3 = theme.Warning
            else
                self.CharCounter.TextColor3 = theme.TextMuted
            end
        end
        
        -- Clear button visibility
        if self.Clearable then
            self.ClearButton.Visible = #self.Value > 0
        end
        
        -- OnChange callback
        if self.OnChange then
            task.spawn(function()
                pcall(self.OnChange, self.Value)
            end)
        end
    end)
end

function Input:Set(value)
    self.Value = tostring(value)
    
    if self.Password and not self.ShowPassword then
        self.TextBox.Text = string.rep("•", #self.Value)
    else
        self.TextBox.Text = self.Value
    end
    
    if self.Clearable then
        self.ClearButton.Visible = #self.Value > 0
    end
    
    task.spawn(function()
        pcall(self.Callback, self.Value, false)
    end)
    
    return self
end

function Input:Get()
    return self.Value
end

function Input:Focus()
    self.TextBox:CaptureFocus()
    return self
end

function Input:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- KEYBIND ELEMENT
-- ════════════════════════════════════════════════════════════════════════════════
local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(section, options)
    local self = setmetatable({}, Keybind)
    
    self.Section = section
    self.Title = options.Title or "Keybind"
    self.Description = options.Description
    self.Default = options.Default or Enum.KeyCode.Unknown
    self.Callback = options.Callback or function() end
    self.ChangedCallback = options.ChangedCallback or function() end
    self.Mode = options.Mode or "Toggle" -- Toggle, Hold, Always
    self.Flag = options.Flag
    self.Key = self.Default
    self.Listening = false
    self.Active = false
    self.Blacklist = options.Blacklist or {
        Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
        Enum.KeyCode.Space, Enum.KeyCode.Escape, Enum.KeyCode.Tab,
        Enum.KeyCode.Backspace, Enum.KeyCode.Return
    }
    
    self:Create()
    self:SetupListener()
    
    if self.Flag then
        NexusUI.Flags[self.Flag] = self
    end
    
    return self
end

function Keybind:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 56 or device.ButtonMinSize + 6
    
    self.Container = Utility.Create("Frame", {
        Name = "Keybind_" .. self.Title,
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = theme.ElevatedTransparency or 0,
        Size = UDim2.new(1, 0, 0, height),
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = 1,
            Transparency = theme.BorderTransparency or 0
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, hasDescription and 10 or 0),
        Size = UDim2.new(1, -100, 0, hasDescription and 20 or height),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Description
    if hasDescription then
        Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 32),
            Size = UDim2.new(1, -100, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Mode indicator
    if self.Mode ~= "Toggle" then
        self.ModeIndicator = Utility.Create("TextLabel", {
            Name = "Mode",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -180, 0.5, -8),
            Size = UDim2.new(0, 50, 0, 16),
            Font = theme.FontSecondary,
            Text = "[" .. self.Mode .. "]",
            TextColor3 = theme.TextMuted,
            TextSize = 10 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = self.Container
        })
    end
    
    -- Key button
    local buttonWidth = DeviceManager:IsTouchDevice() and 90 or 80
    self.KeyButton = Utility.Create("TextButton", {
        Name = "KeyButton",
        BackgroundColor3 = theme.Surface,
        Position = UDim2.new(1, -buttonWidth, 0.5, -14),
        Size = UDim2.fromOffset(buttonWidth, 28),
        Font = theme.Font,
        Text = self:GetKeyName(),
        TextColor3 = theme.Accent,
        TextSize = 12 * device.FontScale,
        AutoButtonColor = false,
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility.Create("UIStroke", {
            Name = "KeyStroke",
            Color = theme.Border,
            Thickness = 1
        })
    })
    
    -- Events
    self.KeyButton.MouseButton1Click:Connect(function()
        Utility.PlaySound("Click")
        self:StartListening()
    end)
    
    self.KeyButton.MouseEnter:Connect(function()
        if not self.Listening then
            Utility.Tween(self.KeyButton, {BackgroundColor3 = theme.BorderLight}, 0.15)
        end
    end)
    
    self.KeyButton.MouseLeave:Connect(function()
        if not self.Listening then
            Utility.Tween(self.KeyButton, {BackgroundColor3 = theme.Surface}, 0.15)
        end
    end)
end

function Keybind:GetKeyName()
    if self.Key == Enum.KeyCode.Unknown then
        return "None"
    end
    
    local shortcuts = {
        LeftShift = "LShift", RightShift = "RShift",
        LeftControl = "LCtrl", RightControl = "RCtrl",
        LeftAlt = "LAlt", RightAlt = "RAlt",
        Backspace = "Back", CapsLock = "Caps",
        Return = "Enter", Escape = "Esc",
        LeftBracket = "[", RightBracket = "]",
        Semicolon = ";", Quote = "'",
        BackSlash = "\\", Comma = ",",
        Period = ".", Slash = "/",
        Minus = "-", Equals = "=",
        Backquote = "`", Space = "Space",
        Zero = "0", One = "1", Two = "2", Three = "3", Four = "4",
        Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9"
    }
    
    return shortcuts[self.Key.Name] or self.Key.Name
end

function Keybind:StartListening()
    local theme = ThemeManager:GetTheme()
    self.Listening = true
    self.KeyButton.Text = "..."
    
    Utility.Tween(self.KeyButton, {BackgroundColor3 = theme.Accent}, 0.15)
    Utility.Tween(self.KeyButton:FindFirstChild("KeyStroke"), {Color = theme.AccentActive}, 0.15)
    self.KeyButton.TextColor3 = theme.Background
    
    -- Pulse animation
    task.spawn(function()
        while self.Listening do
            AnimationEngine:Animate(self.KeyButton, {
                Size = UDim2.fromOffset(84, 30)
            }, 0.3)
            task.wait(0.3)
            if not self.Listening then break end
            AnimationEngine:Animate(self.KeyButton, {
                Size = UDim2.fromOffset(80, 28)
            }, 0.3)
            task.wait(0.3)
        end
    end)
end

function Keybind:StopListening(newKey)
    local theme = ThemeManager:GetTheme()
    self.Listening = false
    
    if newKey then
        self.Key = newKey
        task.spawn(function()
            pcall(self.ChangedCallback, newKey)
        end)
    end
    
    self.KeyButton.Text = self:GetKeyName()
    self.KeyButton.Size = UDim2.fromOffset(80, 28)
    
    Utility.Tween(self.KeyButton, {BackgroundColor3 = theme.Surface}, 0.15)
    Utility.Tween(self.KeyButton:FindFirstChild("KeyStroke"), {Color = theme.Border}, 0.15)
    self.KeyButton.TextColor3 = theme.Accent
    
    -- Flash animation for confirmation
    if newKey then
        AnimationEngine:Animate(self.KeyButton:FindFirstChild("KeyStroke"), {
            Color = theme.Success
        }, 0.1, "Linear", function()
            task.wait(0.2)
            Utility.Tween(self.KeyButton:FindFirstChild("KeyStroke"), {Color = theme.Border}, 0.2)
        end)
    end
    
    StateManager:Set("keybinds." .. (self.Flag or self.Title), newKey and newKey.Name or "Unknown")
end

function Keybind:SetupListener()
    -- Input began
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if self.Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape then
                    Utility.PlaySound("Error")
                    self:StopListening()
                elseif table.find(self.Blacklist, input.KeyCode) then
                    -- Shake animation for blacklisted key
                    AnimationEngine:Shake(self.KeyButton, 3, 0.2)
                else
                    Utility.PlaySound("Success")
                    Utility.Haptic(0.2)
                    self:StopListening(input.KeyCode)
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or
                   input.UserInputType == Enum.UserInputType.MouseButton2 then
                -- Allow mouse buttons as keybinds
                local mouseKey = input.UserInputType == Enum.UserInputType.MouseButton1 
                    and Enum.KeyCode.Unknown or Enum.KeyCode.Unknown
                -- Note: You'd need custom handling for mouse buttons
            end
            return
        end
        
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == self.Key then
                if self.Mode == "Toggle" then
                    self.Active = not self.Active
                    task.spawn(function()
                        pcall(self.Callback, self.Active)
                    end)
                elseif self.Mode == "Hold" then
                    self.Active = true
                    task.spawn(function()
                        pcall(self.Callback, true)
                    end)
                elseif self.Mode == "Always" then
                    task.spawn(function()
                        pcall(self.Callback)
                    end)
                end
                
                Utility.Haptic(0.1)
            end
        end
    end)
    
    -- Input ended (for Hold mode)
    UserInputService.InputEnded:Connect(function(input)
        if not self.Listening and self.Mode == "Hold" then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == self.Key and self.Active then
                    self.Active = false
                    task.spawn(function()
                        pcall(self.Callback, false)
                    end)
                end
            end
        end
    end)
end

function Keybind:Set(key)
    if typeof(key) == "EnumItem" then
        self.Key = key
    elseif type(key) == "string" then
        pcall(function()
            self.Key = Enum.KeyCode[key]
        end)
    end
    
    self.KeyButton.Text = self:GetKeyName()
    return self
end

function Keybind:Get()
    return self.Key
end

function Keybind:GetActive()
    return self.Active
end

function Keybind:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- COLORPICKER ELEMENT
-- ════════════════════════════════════════════════════════════════════════════════
local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(section, options)
    local self = setmetatable({}, ColorPicker)
    
    self.Section = section
    self.Title = options.Title or "Color Picker"
    self.Description = options.Description
    self.Default = options.Default or Color3.fromRGB(255, 255, 255)
    self.Callback = options.Callback or function() end
    self.Flag = options.Flag
    self.Color = self.Default
    self.Opened = false
    
    -- Convert to HSV
    self.Hue, self.Saturation, self.Value = self.Color:ToHSV()
    
    self:Create()
    
    if self.Flag then
        NexusUI.Flags[self.Flag] = self
    end
    
    return self
end

function ColorPicker:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    local hasDescription = self.Description and self.Description ~= ""
    local headerHeight = hasDescription and 56 or device.ButtonMinSize + 6
    
    self.Container = Utility.Create("Frame", {
        Name = "ColorPicker_" .. self.Title,
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = theme.ElevatedTransparency or 0,
        Size = UDim2.new(1, 0, 0, headerHeight),
        ClipsDescendants = true,
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIStroke", {
            Name = "Stroke",
            Color = theme.Border,
            Thickness = 1,
            Transparency = theme.BorderTransparency or 0
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Title
    self.Label = Utility.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, hasDescription and 10 or 0),
        Size = UDim2.new(1, -60, 0, hasDescription and 20 or headerHeight),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Description
    if hasDescription then
        Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 32),
            Size = UDim2.new(1, -60, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.Container
        })
    end
    
    -- Color preview
    self.ColorPreview = Utility.Create("TextButton", {
        Name = "ColorPreview",
        BackgroundColor3 = self.Color,
        Position = UDim2.new(1, -46, 0.5, -14),
        Size = UDim2.fromOffset(46, 28),
        Text = "",
        AutoButtonColor = false,
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility.Create("UIStroke", {
            Color = theme.Border,
            Thickness = 1
        })
    })
    
    -- Checkered background for preview
    Utility.Create("ImageLabel", {
        Name = "Checkers",
        BackgroundTransparency = 1,
        Image = "rbxassetid://4753098942",
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.fromOffset(8, 8),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = -1,
        Parent = self.ColorPreview
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    -- Picker panel
    self.Panel = Utility.Create("Frame", {
        Name = "Panel",
        BackgroundColor3 = theme.Surface,
        Position = UDim2.new(0, -14, 0, headerHeight),
        Size = UDim2.new(1, 28, 0, 0),
        ClipsDescendants = true,
        Parent = self.Container
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12)
        })
    })
    
    -- Saturation/Value picker
    self.SVPicker = Utility.Create("Frame", {
        Name = "SVPicker",
        BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1),
        Size = UDim2.new(1, 0, 0, 120),
        Parent = self.Panel
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    -- White gradient
    Utility.Create("Frame", {
        Name = "WhiteGradient",
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self.SVPicker
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility.Create("UIGradient", {
            Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Rotation = 0
        })
    })
    
    -- Black gradient
    Utility.Create("Frame", {
        Name = "BlackGradient",
        BackgroundColor3 = Color3.new(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self.SVPicker
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility.Create("UIGradient", {
            Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Rotation = 90
        })
    })
    
    -- SV Cursor
    self.SVCursor = Utility.Create("Frame", {
        Name = "Cursor",
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.new(self.Saturation, -8, 1 - self.Value, -8),
        Size = UDim2.fromOffset(16, 16),
        Parent = self.SVPicker
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Utility.Create("UIStroke", {
            Color = Color3.new(0, 0, 0),
            Thickness = 2
        })
    })
    
    -- Hue slider
    self.HueSlider = Utility.Create("Frame", {
        Name = "HueSlider",
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.new(0, 0, 0, 132),
        Size = UDim2.new(1, 0, 0, 20),
        Parent = self.Panel
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Utility.Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
                ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
                ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
                ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
                ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
            })
        })
    })
    
    -- Hue cursor
    self.HueCursor = Utility.Create("Frame", {
        Name = "Cursor",
        BackgroundColor3 = Color3.new(1, 1, 1),
        Position = UDim2.new(self.Hue, -8, 0.5, -8),
        Size = UDim2.fromOffset(16, 16),
        Parent = self.HueSlider
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Utility.Create("UIStroke", {
            Color = Color3.new(0, 0, 0),
            Thickness = 2
        })
    })
    
    -- RGB inputs
    local rgbContainer = Utility.Create("Frame", {
        Name = "RGBInputs",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 160),
        Size = UDim2.new(1, 0, 0, 28),
        Parent = self.Panel
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 8)
        })
    })
    
    self.RGBInputs = {}
    for i, channel in ipairs({"R", "G", "B"}) do
        local channelColors = {
            R = Color3.fromRGB(255, 100, 100),
            G = Color3.fromRGB(100, 255, 100),
            B = Color3.fromRGB(100, 100, 255)
        }
        
        local inputFrame = Utility.Create("Frame", {
            Name = channel .. "Input",
            BackgroundColor3 = theme.Elevated,
            Size = UDim2.new(1/3, -6, 1, 0),
            Parent = rgbContainer
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        })
        
        Utility.Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 0),
            Size = UDim2.new(0, 14, 1, 0),
            Font = theme.Font,
            Text = channel,
            TextColor3 = channelColors[channel],
            TextSize = 12,
            Parent = inputFrame
        })
        
        local value = math.floor(self.Color[channel] * 255)
        self.RGBInputs[channel] = Utility.Create("TextBox", {
            Name = "Input",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 24, 0, 0),
            Size = UDim2.new(1, -28, 1, 0),
            Font = theme.FontMono,
            Text = tostring(value),
            TextColor3 = theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
            ClearTextOnFocus = true,
            Parent = inputFrame
        })
        
        self.RGBInputs[channel].FocusLost:Connect(function()
            local num = tonumber(self.RGBInputs[channel].Text)
            if num then
                num = Utility.Clamp(math.floor(num), 0, 255)
                self.RGBInputs[channel].Text = tostring(num)
                self:UpdateFromRGB()
            else
                self.RGBInputs[channel].Text = tostring(math.floor(self.Color[channel] * 255))
            end
        end)
    end
    
    -- Hex input
    local hexContainer = Utility.Create("Frame", {
        Name = "HexInput",
        BackgroundColor3 = theme.Elevated,
        Position = UDim2.new(0, 0, 0, 195),
        Size = UDim2.new(1, 0, 0, 28),
        Parent = self.Panel
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        })
    })
    
    Utility.Create("TextLabel", {
        Name = "Hash",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 15, 1, 0),
        Font = theme.Font,
        Text = "#",
        TextColor3 = theme.TextMuted,
        TextSize = 13,
        Parent = hexContainer
    })
    
    self.HexInput = Utility.Create("TextBox", {
        Name = "Hex",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -15, 1, 0),
        Font = theme.FontMono,
        Text = self:ColorToHex(self.Color),
        TextColor3 = theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = hexContainer
    })
    
    self.HexInput.FocusLost:Connect(function()
        local hex = self.HexInput.Text:gsub("#", ""):upper()
        if #hex == 6 then
            local r = tonumber(hex:sub(1, 2), 16)
            local g = tonumber(hex:sub(3, 4), 16)
            local b = tonumber(hex:sub(5, 6), 16)
            if r and g and b then
                self:SetColor(Color3.fromRGB(r, g, b))
            end
        end
        self.HexInput.Text = self:ColorToHex(self.Color)
    end)
    
    -- Preset colors
    local presetColors = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(200, 200, 200),
        Color3.fromRGB(128, 128, 128),
        Color3.fromRGB(64, 64, 64),
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 128, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(128, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 128),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(0, 128, 255),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(128, 0, 255),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(255, 0, 128),
    }
    
    local presetsContainer = Utility.Create("Frame", {
        Name = "Presets",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 230),
        Size = UDim2.new(1, 0, 0, 24),
        Parent = self.Panel
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 4)
        })
    })
    
    for _, color in ipairs(presetColors) do
        local preset = Utility.Create("TextButton", {
            Name = "Preset",
            BackgroundColor3 = color,
            Size = UDim2.new(0, 16, 0, 16),
            Text = "",
            AutoButtonColor = false,
            Parent = presetsContainer
        }, {
            Utility.Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Utility.Create("UIStroke", {
                Color = theme.Border,
                Thickness = 1
            })
        })
        
        preset.MouseButton1Click:Connect(function()
            self:SetColor(color)
        end)
        
        preset.MouseEnter:Connect(function()
            Utility.Tween(preset, {Size = UDim2.new(0, 20, 0, 20)}, 0.1)
        end)
        
        preset.MouseLeave:Connect(function()
            Utility.Tween(preset, {Size = UDim2.new(0, 16, 0, 16)}, 0.1)
        end)
    end
    
    -- Setup interactions
    self:SetupPickerInteractions()
    
    -- Toggle panel
    self.ColorPreview.MouseButton1Click:Connect(function()
        Utility.PlaySound("Click")
        self:Toggle()
    end)
end

function ColorPicker:SetupPickerInteractions()
    local svDragging = false
    local hueDragging = false
    
    -- SV Picker
    local svInput = Utility.Create("TextButton", {
        Name = "SVInput",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = self.SVPicker
    })
    
    local function updateSV(input)
        local pos = input.Position
        local absPos = self.SVPicker.AbsolutePosition
        local absSize = self.SVPicker.AbsoluteSize
        
        self.Saturation = Utility.Clamp((pos.X - absPos.X) / absSize.X, 0, 1)
        self.Value = Utility.Clamp(1 - (pos.Y - absPos.Y) / absSize.Y, 0, 1)
        
        self:UpdateColor()
    end
    
    svInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            svDragging = true
            updateSV(input)
        end
    end)
    
    svInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            svDragging = false
        end
    end)
    
    -- Hue Slider
    local hueInput = Utility.Create("TextButton", {
        Name = "HueInput",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = self.HueSlider
    })
    
    local function updateHue(input)
        local pos = input.Position
        local absPos = self.HueSlider.AbsolutePosition
        local absSize = self.HueSlider.AbsoluteSize
        
        self.Hue = Utility.Clamp((pos.X - absPos.X) / absSize.X, 0, 1)
        
        self:UpdateColor()
    end
    
    hueInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            hueDragging = true
            updateHue(input)
        end
    end)
    
    hueInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            hueDragging = false
        end
    end)
    
    -- Global mouse move
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            if svDragging then
                updateSV(input)
            elseif hueDragging then
                updateHue(input)
            end
        end
    end)
end

function ColorPicker:UpdateColor()
    self.Color = Color3.fromHSV(self.Hue, self.Saturation, self.Value)
    
    -- Update preview
    self.ColorPreview.BackgroundColor3 = self.Color
    
    -- Update SV picker background
    self.SVPicker.BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1)
    
    -- Update cursors
    self.SVCursor.Position = UDim2.new(self.Saturation, -8, 1 - self.Value, -8)
    self.HueCursor.Position = UDim2.new(self.Hue, -8, 0.5, -8)
    
    -- Update RGB inputs
    self.RGBInputs.R.Text = tostring(math.floor(self.Color.R * 255))
    self.RGBInputs.G.Text = tostring(math.floor(self.Color.G * 255))
    self.RGBInputs.B.Text = tostring(math.floor(self.Color.B * 255))
    
    -- Update hex
    self.HexInput.Text = self:ColorToHex(self.Color)
    
    -- Callback
    task.spawn(function()
        pcall(self.Callback, self.Color)
    end)
    
    StateManager:Set("colorpickers." .. (self.Flag or self.Title), self:ColorToHex(self.Color))
end

function ColorPicker:UpdateFromRGB()
    local r = tonumber(self.RGBInputs.R.Text) or 0
    local g = tonumber(self.RGBInputs.G.Text) or 0
    local b = tonumber(self.RGBInputs.B.Text) or 0
    
    self.Color = Color3.fromRGB(r, g, b)
    self.Hue, self.Saturation, self.Value = self.Color:ToHSV()
    
    self:UpdateColor()
end

function ColorPicker:ColorToHex(color)
    return string.format("%02X%02X%02X",
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255)
    )
end

function ColorPicker:Toggle()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    self.Opened = not self.Opened
    
    local hasDescription = self.Description and self.Description ~= ""
    local headerHeight = hasDescription and 56 or device.ButtonMinSize + 6
    local panelHeight = self.Opened and 270 or 0
    local totalHeight = headerHeight + panelHeight
    
    AnimationEngine:Animate(self.Container, {Size = UDim2.new(1, 0, 0, totalHeight)}, 0.3, "OutQuart")
    AnimationEngine:Animate(self.Panel, {Size = UDim2.new(1, 28, 0, panelHeight)}, 0.3, "OutQuart")
    AnimationEngine:Animate(self.Container.Stroke, {
        Color = self.Opened and theme.Accent or theme.Border
    }, 0.2)
end

function ColorPicker:SetColor(color)
    self.Color = color
    self.Hue, self.Saturation, self.Value = color:ToHSV()
    self:UpdateColor()
    return self
end

function ColorPicker:Set(color)
    return self:SetColor(color)
end

function ColorPicker:Get()
    return self.Color
end

function ColorPicker:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- LABEL ELEMENT
-- ════════════════════════════════════════════════════════════════════════════════
local Label = {}
Label.__index = Label

function Label.new(section, options)
    local self = setmetatable({}, Label)
    
    self.Section = section
    self.Title = options.Title or "Label"
    self.Description = options.Description
    self.Icon = options.Icon
    self.Color = options.Color
    
    self:Create()
    
    return self
end

function Label:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    local hasDescription = self.Description and self.Description ~= ""
    local height = hasDescription and 52 or 34
    
    self.Container = Utility.Create("Frame", {
        Name = "Label_" .. self.Title,
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = theme.ElevatedTransparency or 0,
        Size = UDim2.new(1, 0, 0, height),
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    local textOffset = 0
    
    -- Icon
    if self.Icon then
        self.IconLabel = Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = self.Color or theme.Accent,
            Position = UDim2.new(0, 0, 0, hasDescription and 8 or 7),
            Size = UDim2.fromOffset(20, 20),
            Parent = self.Container
        })
        textOffset = 28
    end
    
    -- Title
    self.TitleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, textOffset, 0, hasDescription and 6 or 0),
        Size = UDim2.new(1, -textOffset, 0, hasDescription and 20 or height),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = self.Color or theme.Text,
        TextSize = 14 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Description
    if hasDescription then
        self.DescLabel = Utility.Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, textOffset, 0, 28),
            Size = UDim2.new(1, -textOffset, 0, 18),
            Font = theme.FontSecondary,
            Text = self.Description,
            TextColor3 = theme.TextMuted,
            TextSize = 12 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = self.Container
        })
    end
end

function Label:Set(title, description)
    if title then
        self.Title = title
        self.TitleLabel.Text = title
    end
    if description and self.DescLabel then
        self.Description = description
        self.DescLabel.Text = description
    end
    return self
end

function Label:SetColor(color)
    self.Color = color
    self.TitleLabel.TextColor3 = color
    if self.IconLabel then
        self.IconLabel.ImageColor3 = color
    end
    return self
end

function Label:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- SEPARATOR ELEMENT
-- ════════════════════════════════════════════════════════════════════════════════
local Separator = {}
Separator.__index = Separator

function Separator.new(section, options)
    local self = setmetatable({}, Separator)
    
    self.Section = section
    self.Text = options and options.Text
    
    self:Create()
    
    return self
end

function Separator:Create()
    local theme = ThemeManager:GetTheme()
    local hasText = self.Text and self.Text ~= ""
    
    self.Container = Utility.Create("Frame", {
        Name = "Separator",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, hasText and 28 or 16),
        Parent = self.Section.Content
    })
    
    if hasText then
        Utility.Create("Frame", {
            Name = "LeftLine",
            BackgroundColor3 = theme.Border,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0.2, -8, 0, 1),
            Parent = self.Container
        })
        
        Utility.Create("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.2, 0, 0, 0),
            Size = UDim2.new(0.6, 0, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = self.Text:upper(),
            TextColor3 = theme.TextMuted,
            TextSize = 10,
            Parent = self.Container
        })
        
        Utility.Create("Frame", {
            Name = "RightLine",
            BackgroundColor3 = theme.Border,
            Position = UDim2.new(0.8, 8, 0.5, 0),
            Size = UDim2.new(0.2, -8, 0, 1),
            Parent = self.Container
        })
    else
        Utility.Create("Frame", {
            Name = "Line",
            BackgroundColor3 = theme.Border,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 0, 1),
            Parent = self.Container
        })
    end
end

function Separator:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- PARAGRAPH ELEMENT
-- ════════════════════════════════════════════════════════════════════════════════
local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(section, options)
    local self = setmetatable({}, Paragraph)
    
    self.Section = section
    self.Title = options.Title or "Paragraph"
    self.Content = options.Content or ""
    
    self:Create()
    
    return self
end

function Paragraph:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    
    -- Calculate height based on content
    local textSize = Utility.GetTextSize(self.Content, 12 * device.FontScale, theme.FontSecondary, 400)
    local contentHeight = math.max(textSize.Y + 10, 40)
    local totalHeight = 30 + contentHeight
    
    self.Container = Utility.Create("Frame", {
        Name = "Paragraph_" .. self.Title,
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = theme.ElevatedTransparency or 0,
        Size = UDim2.new(1, 0, 0, totalHeight),
        Parent = self.Section.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius)}),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
    })
    
    self.TitleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 14 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    self.ContentLabel = Utility.Create("TextLabel", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 26),
        Size = UDim2.new(1, 0, 0, contentHeight),
        Font = theme.FontSecondary,
        Text = self.Content,
        TextColor3 = theme.TextSecondary,
        TextSize = 12 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = self.Container
    })
end

function Paragraph:Set(title, content)
    if title then
        self.Title = title
        self.TitleLabel.Text = title
    end
    
    if content then
        self.Content = content
        self.ContentLabel.Text = content
        
        -- Recalculate height
        local theme = ThemeManager:GetTheme()
        local device = DeviceManager:GetProfile()
        local textSize = Utility.GetTextSize(content, 12 * device.FontScale, theme.FontSecondary, 400)
        local contentHeight = math.max(textSize.Y + 10, 40)
        local totalHeight = 30 + contentHeight
        
        self.Container.Size = UDim2.new(1, 0, 0, totalHeight)
        self.ContentLabel.Size = UDim2.new(1, 0, 0, contentHeight)
    end
    
    return self
end

function Paragraph:Destroy()
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- SECTION CLASS
-- ════════════════════════════════════════════════════════════════════════════════
local Section = {}
Section.__index = Section

function Section.new(tab, options)
    local self = setmetatable({}, Section)
    
    self.Tab = tab
    self.Name = options.Name or "Section"
    self.Icon = options.Icon
    self.Opened = options.Opened ~= false
    self.Elements = {}
    
    self:Create()
    
    return self
end

function Section:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    
    self.Container = Utility.Create("Frame", {
        Name = "Section_" .. self.Name,
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = theme.SurfaceTransparency or 0,
        Size = UDim2.new(1, -20, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = self.Tab.Content
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius + 2)}),
        Utility.Create("UIStroke", {
            Color = theme.Border,
            Thickness = 1,
            Transparency = theme.BorderTransparency or 0
        }),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12)
        })
    })
    
    -- Add shadow
    if PerformanceManager:ShouldGlow() then
        Utility.CreateShadow(self.Container, 4, 0.8)
    end
    
    -- Header
    self.Header = Utility.Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 32),
        Parent = self.Container
    })
    
    local titleOffset = 0
    
    -- Icon
    if self.Icon then
        self.IconLabel = Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = theme.Accent,
            Position = UDim2.new(0, 0, 0.5, -10),
            Size = UDim2.fromOffset(20, 20),
            Parent = self.Header
        })
        titleOffset = 28
        
        -- Glow on icon
        if PerformanceManager:ShouldGlow() then
            Utility.CreateGlow(self.IconLabel, theme.Accent, 0.3)
        end
    end
    
    -- Title
    self.TitleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, titleOffset, 0, 0),
        Size = UDim2.new(1, -titleOffset - 30, 1, 0),
        Font = theme.Font,
        Text = self.Name,
        TextColor3 = theme.Text,
        TextSize = 15 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })
    
    -- Collapse arrow
    self.Arrow = Utility.Create("ImageLabel", {
        Name = "Arrow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageColor3 = theme.TextMuted,
        ImageRectOffset = Vector2.new(124, 4),
        ImageRectSize = Vector2.new(24, 24),
        Position = UDim2.new(1, -16, 0.5, -8),
        Size = UDim2.fromOffset(16, 16),
        Rotation = self.Opened and 0 or -90,
        Parent = self.Header
    })
    
    -- Content container
    self.Content = Utility.Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Visible = self.Opened,
        Parent = self.Container
    }, {
        Utility.Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, device.Spacing)
        })
    })
    
    -- Header click to collapse
    local headerBtn = Utility.Create("TextButton", {
        Name = "HeaderButton",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = self.Header
    })
    
    headerBtn.MouseButton1Click:Connect(function()
        Utility.PlaySound("Click")
        self:Toggle()
    end)
    
    headerBtn.MouseEnter:Connect(function()
        Utility.Tween(self.Arrow, {ImageColor3 = theme.Accent}, 0.15)
    end)
    
    headerBtn.MouseLeave:Connect(function()
        Utility.Tween(self.Arrow, {ImageColor3 = theme.TextMuted}, 0.15)
    end)
end

function Section:Toggle()
    self.Opened = not self.Opened
    self.Content.Visible = self.Opened
    
    AnimationEngine:Animate(self.Arrow, {
        Rotation = self.Opened and 0 or -90
    }, 0.2, "OutQuart")
end

function Section:AddToggle(options)
    local toggle = Toggle.new(self, options)
    table.insert(self.Elements, toggle)
    return toggle
end

function Section:AddButton(options)
    local button = Button.new(self, options)
    table.insert(self.Elements, button)
    return button
end

function Section:AddSlider(options)
    local slider = Slider.new(self, options)
    table.insert(self.Elements, slider)
    return slider
end

function Section:AddDropdown(options)
    local dropdown = Dropdown.new(self, options)
    table.insert(self.Elements, dropdown)
    return dropdown
end

function Section:AddInput(options)
    local input = Input.new(self, options)
    table.insert(self.Elements, input)
    return input
end

function Section:AddKeybind(options)
    local keybind = Keybind.new(self, options)
    table.insert(self.Elements, keybind)
    return keybind
end

function Section:AddColorPicker(options)
    local colorPicker = ColorPicker.new(self, options)
    table.insert(self.Elements, colorPicker)
    return colorPicker
end

function Section:AddLabel(options)
    local label = Label.new(self, options)
    table.insert(self.Elements, label)
    return label
end

function Section:AddSeparator(options)
    local separator = Separator.new(self, options or {})
    table.insert(self.Elements, separator)
    return separator
end

function Section:AddParagraph(options)
    local paragraph = Paragraph.new(self, options)
    table.insert(self.Elements, paragraph)
    return paragraph
end

function Section:AddDiscord(inviteCode, options)
    options = options or {}
    local card = DiscordIntegration:CreateCard(self.Content, inviteCode, options)
    return card
end

function Section:Destroy()
    for _, element in ipairs(self.Elements) do
        if element.Destroy then
            element:Destroy()
        end
    end
    
    if self.Container then
        self.Container:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- TAB CLASS
-- ════════════════════════════════════════════════════════════════════════════════
local Tab = {}
Tab.__index = Tab

function Tab.new(window, options)
    local self = setmetatable({}, Tab)
    
    self.Window = window
    self.Name = options.Name or "Tab"
    self.Icon = options.Icon
    self.Sections = {}
    self.Active = false
    
    self:Create()
    
    return self
end

function Tab:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    
    -- Tab button
    self.Button = Utility.Create("TextButton", {
        Name = "TabButton_" .. self.Name,
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, -8),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = theme.Font,
        Text = "",
        AutoButtonColor = false,
        Parent = self.Window.TabContainer
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        })
    })
    
    -- Tab content layout
    local tabContent = Utility.Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = self.Button
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8)
        })
    })
    
    -- Icon
    local textOffset = 0
    if self.Icon then
        self.IconImage = Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = theme.TextMuted,
            Size = UDim2.fromOffset(18, 18),
            Parent = tabContent
        })
        textOffset = 26
    end
    
    -- Tab text
    self.TextLabel = Utility.Create("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = theme.Font,
        Text = self.Name,
        TextColor3 = theme.TextMuted,
        TextSize = 13 * device.FontScale,
        Parent = tabContent
    })
    
    -- Active indicator
    self.Indicator = Utility.Create("Frame", {
        Name = "Indicator",
        BackgroundColor3 = theme.Accent,
        Position = UDim2.new(0.5, 0, 1, -2),
        Size = UDim2.new(0, 0, 0, 3),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = self.Button
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Tab page content
    self.Content = Utility.Create("ScrollingFrame", {
        Name = "TabContent_" .. self.Name,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.Accent,
        ScrollBarImageTransparency = 0.5,
        Visible = false,
        Parent = self.Window.ContentContainer
    }, {
        Utility.Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        }),
        Utility.Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
    })
    
    -- Events
    self.Button.MouseButton1Click:Connect(function()
        Utility.PlaySound("Click")
        Utility.Haptic(0.1)
        self.Window:SelectTab(self)
    end)
    
    self.Button.MouseEnter:Connect(function()
        if not self.Active then
            Utility.Tween(self.Button, {BackgroundTransparency = 0.5}, 0.15)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Active then
            Utility.Tween(self.Button, {BackgroundTransparency = 1}, 0.15)
        end
    end)
end

function Tab:SetActive(active)
    local theme = ThemeManager:GetTheme()
    self.Active = active
    self.Content.Visible = active
    
    if active then
        Utility.Tween(self.Button, {BackgroundTransparency = 0}, 0.2)
        Utility.Tween(self.TextLabel, {TextColor3 = theme.Text}, 0.2)
        AnimationEngine:Animate(self.Indicator, {Size = UDim2.new(0.6, 0, 0, 3)}, 0.2, "OutBack")
        
        if self.IconImage then
            Utility.Tween(self.IconImage, {ImageColor3 = theme.Accent}, 0.2)
        end
    else
        Utility.Tween(self.Button, {BackgroundTransparency = 1}, 0.2)
        Utility.Tween(self.TextLabel, {TextColor3 = theme.TextMuted}, 0.2)
        AnimationEngine:Animate(self.Indicator, {Size = UDim2.new(0, 0, 0, 3)}, 0.2, "InBack")
        
        if self.IconImage then
            Utility.Tween(self.IconImage, {ImageColor3 = theme.TextMuted}, 0.2)
        end
    end
end

function Tab:AddSection(options)
    local section = Section.new(self, options)
    table.insert(self.Sections, section)
    return section
end

function Tab:Destroy()
    for _, section in ipairs(self.Sections) do
        section:Destroy()
    end
    
    if self.Button then
        self.Button:Destroy()
    end
    
    if self.Content then
        self.Content:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- WINDOW CLASS
-- ════════════════════════════════════════════════════════════════════════════════
local Window = {}
Window.__index = Window

function Window.new(library, options)
    local self = setmetatable({}, Window)
    
    self.Library = library
    self.Title = options.Title or "Nexus UI"
    self.Subtitle = options.Subtitle
    self.Size = options.Size or UDim2.fromOffset(580, 680)
    self.Position = options.Position or UDim2.new(0.5, -290, 0.5, -340)
    self.Icon = options.Icon
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.Visible = true
    self.Dragging = false
    
    self:Create()
    
    table.insert(library.Windows, self)
    
    return self
end

function Window:Create()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    
    self.ScreenGui = CreateScreenGui()
    if not self.ScreenGui then
        warn("[NexusUI] Failed to create window")
        return
    end
    
    -- Apply device scaling
    local scale = device.WindowScale
    local scaledSize = UDim2.fromOffset(
        self.Size.X.Offset * scale,
        self.Size.Y.Offset * scale
    )
    
    -- Main frame
    self.MainFrame = Utility.Create("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = theme.BackgroundTransparency or 0,
        Position = self.Position,
        Size = scaledSize,
        Parent = self.ScreenGui
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius + 4)}),
        Utility.Create("UIStroke", {
            Name = "MainStroke",
            Color = theme.Border,
            Thickness = 1,
            Transparency = theme.BorderTransparency or 0
        })
    })
    
    -- Shadow
    if PerformanceManager:ShouldGlow() then
        Utility.CreateShadow(self.MainFrame, 10, 0.6)
    end
    
    -- Glow effect
    if PerformanceManager:ShouldGlow() then
        self.WindowGlow = Utility.CreateGlow(self.MainFrame, theme.AccentGlow, 0.1)
    end
    
    -- Title bar
    self.TitleBar = Utility.Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = theme.SurfaceTransparency or 0,
        Size = UDim2.new(1, 0, 0, 52),
        Parent = self.MainFrame
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, theme.CornerRadius + 4)})
    })
    
    -- Title bar bottom cover
    Utility.Create("Frame", {
        Name = "TitleBarCover",
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = theme.SurfaceTransparency or 0,
        Position = UDim2.new(0, 0, 1, -14),
        Size = UDim2.new(1, 0, 0, 14),
        Parent = self.TitleBar
    })
    
    -- Decorative accent line
    self.AccentLine = Utility.Create("Frame", {
        Name = "AccentLine",
        BackgroundColor3 = theme.Accent,
        Position = UDim2.new(0, 20, 1, -2),
        Size = UDim2.new(0, 100, 0, 2),
        Parent = self.TitleBar
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Glow on accent line
    if PerformanceManager:ShouldGlow() then
        Utility.CreateGlow(self.AccentLine, theme.Accent, 0.5)
    end
    
    -- Animate accent line
    if PerformanceManager:ShouldAnimate() then
        task.spawn(function()
            while self.MainFrame and self.MainFrame.Parent do
                AnimationEngine:Animate(self.AccentLine, {Size = UDim2.new(0, 150, 0, 2)}, 1.5, "InOutSine")
                task.wait(1.5)
                if not self.MainFrame or not self.MainFrame.Parent then break end
                AnimationEngine:Animate(self.AccentLine, {Size = UDim2.new(0, 80, 0, 2)}, 1.5, "InOutSine")
                task.wait(1.5)
            end
        end)
    end
    
    -- Icon
    local titleOffset = 20
    if self.Icon then
        self.IconImage = Utility.Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = theme.Accent,
            Position = UDim2.new(0, 20, 0, 12),
            Size = UDim2.fromOffset(28, 28),
            Parent = self.TitleBar
        })
        
        if PerformanceManager:ShouldGlow() then
            Utility.CreateGlow(self.IconImage, theme.Accent, 0.3)
        end
        
        titleOffset = 58
    end
    
    -- Title
    Utility.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, titleOffset, 0, self.Subtitle and 8 or 0),
        Size = UDim2.new(1, -titleOffset - 100, 0, self.Subtitle and 24 or 52),
        Font = theme.Font,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 18 * device.FontScale,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TitleBar
    })
    
    -- Subtitle
    if self.Subtitle then
        Utility.Create("TextLabel", {
            Name = "Subtitle",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, titleOffset, 0, 30),
            Size = UDim2.new(1, -titleOffset - 100, 0, 16),
            Font = theme.FontSecondary,
            Text = self.Subtitle,
            TextColor3 = theme.TextMuted,
            TextSize = 12 * device.FontScale,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = self.TitleBar
        })
    end
    
    -- Window controls
    local controlsFrame = Utility.Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -95, 0, 10),
        Size = UDim2.new(0, 85, 0, 32),
        Parent = self.TitleBar
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8)
        })
    })
    
    -- Minimize button
    self.MinimizeBtn = Utility.Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = theme.Warning,
        Size = UDim2.fromOffset(30, 30),
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 1,
        Parent = controlsFrame
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    Utility.Create("Frame", {
        Name = "Icon",
        BackgroundColor3 = theme.Background,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(12, 2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = self.MinimizeBtn
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Close button
    self.CloseBtn = Utility.Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = theme.Error,
        Size = UDim2.fromOffset(30, 30),
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 2,
        Parent = controlsFrame
    }, {
        Utility.Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    Utility.Create("TextLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = theme.Font,
        Text = "×",
        TextColor3 = theme.Text,
        TextSize = 22,
        Parent = self.CloseBtn
    })
    
    -- Tab container
    self.TabContainer = Utility.Create("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 56),
        Size = UDim2.new(1, -24, 0, 40),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        Parent = self.MainFrame
    }, {
        Utility.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6)
        })
    })
    
    -- Content container
    self.ContentContainer = Utility.Create("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 102),
        Size = UDim2.new(1, 0, 1, -112),
        ClipsDescendants = true,
        Parent = self.MainFrame
    })
    
    -- Setup dragging
    self:SetupDragging()
    
    -- Button events
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        Utility.PlaySound("Click")
        Utility.Haptic(0.2)
        self:Minimize()
    end)
    
    self.CloseBtn.MouseButton1Click:Connect(function()
        Utility.PlaySound("Click")
        Utility.Haptic(0.2)
        self:Close()
    end)
    
    -- Button hover effects
    for _, btn in ipairs({self.MinimizeBtn, self.CloseBtn}) do
        btn.MouseEnter:Connect(function()
            AnimationEngine:Animate(btn, {Size = UDim2.fromOffset(32, 32)}, 0.15, "OutBack")
        end)
        btn.MouseLeave:Connect(function()
            AnimationEngine:Animate(btn, {Size = UDim2.fromOffset(30, 30)}, 0.15, "OutQuart")
        end)
    end
    
    -- Open animation
    self.MainFrame.Size = UDim2.fromOffset(0, 0)
    self.MainFrame.BackgroundTransparency = 1
    self.MainFrame.Position = UDim2.new(
        self.Position.X.Scale,
        self.Position.X.Offset + scaledSize.X.Offset / 2,
        self.Position.Y.Scale,
        self.Position.Y.Offset + scaledSize.Y.Offset / 2
    )
    
    AnimationEngine:Animate(self.MainFrame, {
        Size = scaledSize,
        Position = self.Position,
        BackgroundTransparency = theme.BackgroundTransparency or 0
    }, 0.5, "OutBack")
    
    -- Theme change subscription
    ThemeManager:Subscribe(function(newTheme)
        self:ApplyTheme(newTheme)
    end)
end

function Window:SetupDragging()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            
            -- Smooth dragging
            local targetPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            
            self.MainFrame.Position = targetPos
        end
    end)
end

function Window:ApplyTheme(theme)
    -- Apply theme to window elements
    Utility.Tween(self.MainFrame, {BackgroundColor3 = theme.Background}, 0.3)
    Utility.Tween(self.TitleBar, {BackgroundColor3 = theme.Surface}, 0.3)
    Utility.Tween(self.AccentLine, {BackgroundColor3 = theme.Accent}, 0.3)
    
    -- Update other elements...
end

function Window:AddTab(options)
    local tab = Tab.new(self, options)
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(tab)
    if self.ActiveTab then
        self.ActiveTab:SetActive(false)
    end
    
    tab:SetActive(true)
    self.ActiveTab = tab
end

function Window:Minimize()
    local theme = ThemeManager:GetTheme()
    local device = DeviceManager:GetProfile()
    self.Minimized = not self.Minimized
    
    local scale = device.WindowScale
    local fullHeight = self.Size.Y.Offset * scale
    
    if self.Minimized then
        AnimationEngine:Animate(self.MainFrame, {
            Size = UDim2.new(self.MainFrame.Size.X.Scale, self.MainFrame.Size.X.Offset, 0, 52)
        }, 0.3, "OutQuart")
        
        self.ContentContainer.Visible = false
        self.TabContainer.Visible = false
        self.AccentLine.Visible = false
    else
        AnimationEngine:Animate(self.MainFrame, {
            Size = UDim2.fromOffset(self.Size.X.Offset * scale, fullHeight)
        }, 0.3, "OutQuart")
        
        task.delay(0.15, function()
            self.ContentContainer.Visible = true
            self.TabContainer.Visible = true
            self.AccentLine.Visible = true
        end)
    end
end

function Window:Close()
    local theme = ThemeManager:GetTheme()
    
    AnimationEngine:Animate(self.MainFrame, {
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.new(
            self.MainFrame.Position.X.Scale,
            self.MainFrame.Position.X.Offset + self.MainFrame.Size.X.Offset / 2,
            self.MainFrame.Position.Y.Scale,
            self.MainFrame.Position.Y.Offset + self.MainFrame.Size.Y.Offset / 2
        ),
        BackgroundTransparency = 1
    }, 0.4, "InBack", function()
        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
    end)
end

function Window:Toggle()
    self.Visible = not self.Visible
    self.MainFrame.Visible = self.Visible
end

function Window:Show()
    self.Visible = true
    self.MainFrame.Visible = true
end

function Window:Hide()
    self.Visible = false
    self.MainFrame.Visible = false
end

function Window:Notify(options)
    return NotificationManager:Notify(self.ScreenGui, options)
end

function Window:Destroy()
    for _, tab in ipairs(self.Tabs) do
        tab:Destroy()
    end
    
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- ════════════════════════════════════════════════════════════════════════════════
-- LIBRARY MAIN FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════

function NexusUI:CreateWindow(options)
    return Window.new(self, options or {})
end

function NexusUI:SetTheme(themeName)
    return ThemeManager:SetTheme(themeName)
end

function NexusUI:GetTheme()
    return ThemeManager:GetTheme()
end

function NexusUI:GetThemeNames()
    return ThemeManager:GetThemeNames()
end

function NexusUI:CreateCustomTheme(name, baseTheme, overrides)
    return ThemeManager:CreateCustomTheme(name, baseTheme, overrides)
end

function NexusUI:Notify(options)
    if #self.Windows > 0 then
        return self.Windows[1]:Notify(options)
    else
        local gui = CreateScreenGui()
        return NotificationManager:Notify(gui, options)
    end
end

function NexusUI:SetNotificationPosition(position)
    NotificationManager:SetPosition(position)
end

function NexusUI:GetFlag(flagName)
    return self.Flags[flagName]
end

function NexusUI:SetFlag(flagName, value)
    local flag = self.Flags[flagName]
    if flag and flag.Set then
        flag:Set(value)
    end
    return self
end

function NexusUI:SetToggleKey(keyCode)
    self.ToggleKey = keyCode
    return self
end

function NexusUI:EnableSounds(enabled)
    Config.SoundsEnabled = enabled
    return self
end

function NexusUI:EnableAnimations(enabled)
    Config.AnimationsEnabled = enabled
    return self
end

function NexusUI:EnableGlow(enabled)
    Config.GlowEnabled = enabled
    return self
end

function NexusUI:EnableHaptics(enabled)
    Config.HapticsEnabled = enabled
    return self
end

function NexusUI:Destroy()
    for _, window in ipairs(self.Windows) do
        window:Destroy()
    end
    
    self.Windows = {}
    self.Flags = {}
    ObjectPool:Clear()
    StateManager:Reset()
    
    NotificationManager:DismissAll()
end

-- ════════════════════════════════════════════════════════════════════════════════
-- TOGGLE KEY HANDLER
-- ════════════════════════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == NexusUI.ToggleKey then
        for _, window in ipairs(NexusUI.Windows) do
            window:Toggle()
        end
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- RETURN LIBRARY
-- ════════════════════════════════════════════════════════════════════════════════
return NexusUI
