if not Key or not ScriptReward or not KeyLink or not NameTitle or not MainImage then return end

local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local KEY_DURATION = 86400
local SAVE_FILE = "SpectX_KeyData.json"

pcall(function()
    if CoreGui:FindFirstChild("SpectXKeySystem") then
        CoreGui.SpectXKeySystem:Destroy()
    end
    if Lighting:FindFirstChild("SpectXBlur") then
        Lighting.SpectXBlur:Destroy()
    end
end)

local function save(data)
    if writefile then
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
    end
end

local function load()
    if readfile and isfile and isfile(SAVE_FILE) then
        return HttpService:JSONDecode(readfile(SAVE_FILE))
    end
end

local blur = Instance.new("BlurEffect")
blur.Name = "SpectXBlur"
blur.Size = 20
blur.Parent = Lighting

local data = load()
local verified = false
local expiry = 0

if data and data.expiry and os.time() < data.expiry then
    verified = true
    expiry = data.expiry
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "SpectXKeySystem"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Parent = CoreGui

local Main = Instance.new("ImageLabel")
Main.Name = "Main"
Main.Size = UDim2.fromScale(0.36,0.52)
Main.Position = UDim2.fromScale(0.32,0.24)
Main.Image = MainImage
Main.ScaleType = Enum.ScaleType.Stretch
Main.BackgroundTransparency = 1
Main.ZIndex = 10
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,20)
MainCorner.Parent = Main

local Close = Instance.new("TextButton")
Close.Text = "×"
Close.Font = Enum.Font.Arial
Close.TextSize = 26
Close.TextColor3 = Color3.fromRGB(200,200,200)
Close.BackgroundTransparency = 1
Close.Size = UDim2.new(0,40,0,40)
Close.Position = UDim2.new(1,-45,0,5)
Close.ZIndex = 11
Close.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = NameTitle
Title.Font = Enum.Font.Arial
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(240,240,240)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,-60,0,50)
Title.Position = UDim2.new(0,30,0,10)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 11
Title.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,-40,1,-90)
Scroll.Position = UDim2.new(0,20,0,70)
Scroll.CanvasSize = UDim2.new(0,0,0,420)
Scroll.ScrollBarImageTransparency = 0.4
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ZIndex = 11
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,14)
Layout.Parent = Scroll

local Status = Instance.new("TextLabel")
Status.Font = Enum.Font.Arial
Status.TextSize = 14
Status.TextColor3 = Color3.fromRGB(120,180,255)
Status.BackgroundTransparency = 1
Status.Size = UDim2.new(1,0,0,30)
Status.Text = ""
Status.ZIndex = 11
Status.Parent = Scroll

if not verified then
    local Input = Instance.new("TextBox")
    Input.PlaceholderText = "Enter key"
    Input.Font = Enum.Font.Arial
    Input.TextSize = 15
    Input.TextColor3 = Color3.fromRGB(230,230,230)
    Input.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Input.Size = UDim2.new(1,0,0,42)
    Input.ClearTextOnFocus = false
    Input.ZIndex = 11
    Input.Parent = Scroll
    Instance.new("UICorner",Input).CornerRadius = UDim.new(0,10)

    local Copy = Instance.new("TextButton")
    Copy.Text = "Copy Key Link"
    Copy.Font = Enum.Font.Arial
    Copy.TextSize = 14
    Copy.TextColor3 = Color3.fromRGB(120,180,255)
    Copy.BackgroundTransparency = 1
    Copy.Size = UDim2.new(1,0,0,30)
    Copy.ZIndex = 11
    Copy.Parent = Scroll

    Copy.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(KeyLink)
            Status.Text = "Key link copied"
        end
    end)

    local Verify = Instance.new("TextButton")
    Verify.Text = "Verify Key"
    Verify.Font = Enum.Font.Arial
    Verify.TextSize = 15
    Verify.TextColor3 = Color3.fromRGB(255,255,255)
    Verify.BackgroundColor3 = Color3.fromRGB(0,120,255)
    Verify.Size = UDim2.new(1,0,0,44)
    Verify.ZIndex = 11
    Verify.Parent = Scroll
    Instance.new("UICorner",Verify).CornerRadius = UDim.new(0,10)

    Verify.MouseButton1Click:Connect(function()
        if Input.Text == Key then
            local exp = os.time() + KEY_DURATION
            save({expiry = exp})
            Status.Text = "Key verified"
            task.wait(0.3)
            Gui:Destroy()
            blur:Destroy()
            pcall(ScriptReward)
        else
            Status.Text = "Invalid key"
        end
    end)
else
    local function formatTime(sec)
        local h = math.floor(sec/3600)
        local m = math.floor((sec%3600)/60)
        local s = sec%60
        return string.format("%02d:%02d:%02d",h,m,s)
    end

    task.spawn(function()
        while Gui.Parent do
            local remaining = expiry - os.time()
            if remaining <= 0 then
                Gui:Destroy()
                blur:Destroy()
                break
            end
            Status.Text = "Expires in "..formatTime(remaining)
            task.wait(1)
        end
    end)

    pcall(ScriptReward)
end

local Credit = Instance.new("TextLabel")
Credit.Text = "Scripted by SpectravaxISBACK"
Credit.Font = Enum.Font.Arial
Credit.TextSize = 12
Credit.TextColor3 = Color3.fromRGB(150,150,150)
Credit.BackgroundTransparency = 1
Credit.Size = UDim2.new(1,0,0,30)
Credit.ZIndex = 11
Credit.Parent = Scroll

Close.MouseButton1Click:Connect(function()
    Gui:Destroy()
    blur:Destroy()
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
        Main.Position = UDim2.new(startFrame.X.Scale,startFrame.X.Offset+d.X,startFrame.Y.Scale,startFrame.Y.Offset+d.Y)
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Blue particles outside the Main ImageLabel
for i = 1,24 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0,6,0,6)
    p.BackgroundColor3 = Color3.fromRGB(0,120,255)
    p.BorderSizePixel = 0
    p.AnchorPoint = Vector2.new(0.5,0.5)
    p.Position = UDim2.fromScale(math.random(), math.random())
    p.ZIndex = 2
    p.Parent = Gui

    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(1,0)
    pc.Parent = p

    local speed = math.random(5,15)/1000

    task.spawn(function()
        while p.Parent do
            local x = math.random()
            local y = 1.1
            local offset = math.random()
            y = y + offset
            while y > -0.1 do
                y -= speed
                p.Position = UDim2.fromScale(x, y)
                task.wait()
            end
        end
    end)
end
