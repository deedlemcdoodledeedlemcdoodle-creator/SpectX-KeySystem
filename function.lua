if not Key or not ScriptReward or not KeyLink then return end

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

pcall(function()
    if CoreGui:FindFirstChild("AppleKeySystem") then
        CoreGui.AppleKeySystem:Destroy()
    end
    if Lighting:FindFirstChild("AppleKeyBlur") then
        Lighting.AppleKeyBlur:Destroy()
    end
end)

local Blur = Instance.new("BlurEffect")
Blur.Name = "AppleKeyBlur"
Blur.Size = 18
Blur.Parent = Lighting

local Gui = Instance.new("ScreenGui")
Gui.Name = "AppleKeySystem"
Gui.ResetOnSpawn = false
Gui.Parent = CoreGui

local Main = Instance.new("ImageLabel")
Main.Name = "Main"
Main.Size = UDim2.fromScale(0.34,0.47)
Main.Position = UDim2.fromScale(0.33,0.25)
Main.Image = "rbxassetid://112819182253577"
Main.ScaleType = Enum.ScaleType.Stretch
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.Parent = Gui
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,18)

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(42,42,42)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18,18,18))
}
Gradient.Rotation = 90
Gradient.Parent = Main

local Close = Instance.new("TextButton")
Close.Text = "×"
Close.Font = Enum.Font.Arial
Close.TextSize = 24
Close.TextColor3 = Color3.fromRGB(200,200,200)
Close.BackgroundTransparency = 1
Close.Size = UDim2.new(0,40,0,40)
Close.Position = UDim2.new(1,-45,0,5)
Close.Parent = Main

local function cleanup()
    Gui:Destroy()
    Blur:Destroy()
end

Close.MouseButton1Click:Connect(cleanup)

local Title = Instance.new("TextLabel")
Title.Text = "Key System"
Title.Font = Enum.Font.Arial
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(240,240,240)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,-60,0,50)
Title.Position = UDim2.new(0,20,0,0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.fromScale(1,0.72)
Scroll.Position = UDim2.fromScale(0,0.18)
Scroll.CanvasSize = UDim2.new(0,0,0,320)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.Parent = Main

local Input = Instance.new("TextBox")
Input.PlaceholderText = "Enter key"
Input.ClearTextOnFocus = false
Input.Font = Enum.Font.Arial
Input.TextSize = 14
Input.TextColor3 = Color3.fromRGB(240,240,240)
Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
Input.Size = UDim2.new(0.85,0,0,42)
Input.Position = UDim2.fromScale(0.075,0.05)
Input.Parent = Scroll
Instance.new("UICorner",Input).CornerRadius = UDim.new(0,10)

local Copy = Instance.new("TextButton")
Copy.Text = "Copy Key Link"
Copy.Font = Enum.Font.Arial
Copy.TextSize = 13
Copy.TextColor3 = Color3.fromRGB(0,122,255)
Copy.BackgroundTransparency = 1
Copy.Size = UDim2.new(0.85,0,0,28)
Copy.Position = UDim2.fromScale(0.075,0.25)
Copy.Parent = Scroll

local Verify = Instance.new("TextButton")
Verify.Text = "Verify Key"
Verify.Font = Enum.Font.Arial
Verify.TextSize = 15
Verify.TextColor3 = Color3.fromRGB(255,255,255)
Verify.BackgroundColor3 = Color3.fromRGB(0,122,255)
Verify.Size = UDim2.new(0.85,0,0,44)
Verify.Position = UDim2.fromScale(0.075,0.42)
Verify.Parent = Scroll
Instance.new("UICorner",Verify).CornerRadius = UDim.new(0,12)

local Status = Instance.new("TextLabel")
Status.Text = ""
Status.Font = Enum.Font.Arial
Status.TextSize = 13
Status.TextColor3 = Color3.fromRGB(200,200,200)
Status.BackgroundTransparency = 1
Status.Size = UDim2.new(1,0,0,24)
Status.Position = UDim2.fromScale(0,0.6)
Status.TextXAlignment = Enum.TextXAlignment.Center
Status.Parent = Scroll

local Credits = Instance.new("TextLabel")
Credits.Text = "Scripted by SpectravaxISBACK"
Credits.Font = Enum.Font.Arial
Credits.TextSize = 13
Credits.TextColor3 = Color3.fromRGB(160,160,160)
Credits.BackgroundTransparency = 1
Credits.Size = UDim2.new(1,0,0,30)
Credits.Position = UDim2.new(0,0,1,-30)
Credits.TextXAlignment = Enum.TextXAlignment.Center
Credits.Parent = Scroll

Copy.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(KeyLink)
        Status.Text = "Link copied"
    end
end)

Verify.MouseButton1Click:Connect(function()
    if Input.Text == Key then
        Status.Text = "Key verified"
        task.wait(0.25)
        cleanup()
        if type(ScriptReward) == "function" then
            pcall(ScriptReward)
        elseif type(ScriptReward) == "string" then
            pcall(loadstring(ScriptReward))
        end
    else
        Status.Text = "Invalid key"
    end
end)

local dragging,startPos,startFrame
Main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        startPos = i.Position
        startFrame = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - startPos
        Main.Position = UDim2.new(
            startFrame.X.Scale,
            startFrame.X.Offset + d.X,
            startFrame.Y.Scale,
            startFrame.Y.Offset + d.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ANIMATIONS
Main.Size = UDim2.fromScale(0.34,0.47)
Main.ImageTransparency = 1
TweenService:Create(
    Main,
    TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    {Size = UDim2.fromScale(0.36,0.5), ImageTransparency = 0}
):Play()

task.spawn(function()
    while Main.Parent do
        TweenService:Create(
            Main,
            TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Position = Main.Position + UDim2.fromOffset(0, -6)}
        ):Play()
        task.wait(2.5)
        TweenService:Create(
            Main,
            TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Position = Main.Position + UDim2.fromOffset(0, 6)}
        ):Play()
        task.wait(2.5)
    end
end)

-- PARTICLES
local ParticleFolder = Instance.new("Folder", Main)
ParticleFolder.Name = "Particles"

local function spawnCube()
    local cube = Instance.new("Frame")
    cube.Size = UDim2.fromOffset(math.random(4,7), math.random(4,7))
    cube.Position = UDim2.new(math.random(),0,1.1,0)
    cube.BackgroundColor3 = Color3.fromRGB(0,122,255)
    cube.BackgroundTransparency = 0.2
    cube.BorderSizePixel = 0
    cube.Parent = ParticleFolder
    Instance.new("UICorner", cube).CornerRadius = UDim.new(0,2)

    local rise = TweenService:Create(
        cube,
        TweenInfo.new(math.random(4,7), Enum.EasingStyle.Linear),
        {Position = UDim2.new(cube.Position.X.Scale,0,-0.2,0), BackgroundTransparency = 1}
    )
    rise:Play()
    rise.Completed:Once(function()
        cube:Destroy()
    end)
end

task.spawn(function()
    while Main.Parent do
        spawnCube()
        task.wait(0.15)
    end
end)
