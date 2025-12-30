if not Key or not ScriptReward or not KeyLink then return end

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local KEY_DURATION = 86400
local SAVE_FILE = "AppleKeySystem.json"

local function save(data)
    if writefile then
        writefile(SAVE_FILE, game:GetService("HttpService"):JSONEncode(data))
    end
end

local function load()
    if readfile and isfile and isfile(SAVE_FILE) then
        return game:GetService("HttpService"):JSONDecode(readfile(SAVE_FILE))
    end
end

pcall(function()
    if CoreGui:FindFirstChild("AppleKeySystem") then CoreGui.AppleKeySystem:Destroy() end
    if Lighting:FindFirstChild("AppleKeyBlur") then Lighting.AppleKeyBlur:Destroy() end
end)

local Blur = Instance.new("BlurEffect")
Blur.Name = "AppleKeyBlur"
Blur.Size = 20
Blur.Parent = Lighting

local data = load()
local verified = false
local expiry = 0
if data and data.expiry and os.time() < data.expiry then
    verified = true
    expiry = data.expiry
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "AppleKeySystem"
Gui.ResetOnSpawn = false
Gui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromScale(0.35,0.4) -- slightly bigger
Main.Position = UDim2.fromScale(0.325,0.3)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25) -- dark mode
Main.BorderSizePixel = 0
Main.Parent = Gui
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,16)

local Gradient = Instance.new("UIGradient",Main)
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35,35,35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,20))
}

local Close = Instance.new("TextButton")
Close.Text = "×"
Close.Font = Enum.Font.GothamMedium
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
Title.Font = Enum.Font.Gotham
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(240,240,240)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,-40,0,50)
Title.Position = UDim2.new(0,20,0,0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Status = Instance.new("TextLabel")
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.TextColor3 = Color3.fromRGB(0,150,0)
Status.BackgroundTransparency = 1
Status.Size = UDim2.new(1,0,0,40)
Status.Position = UDim2.fromScale(0,0.45)
Status.Parent = Main

if verified then
    local function formatTime(sec)
        local h = math.floor(sec/3600)
        local m = math.floor((sec%3600)/60)
        local s = sec%60
        return string.format("%02d:%02d:%02d",h,m,s)
    end
    Status.Text = "Verified ✓"
    task.spawn(function()
        while Gui.Parent do
            local remaining = expiry - os.time()
            if remaining <= 0 then cleanup() break end
            Status.Text = "Expires in "..formatTime(remaining)
            task.wait(1)
        end
    end)
    if type(ScriptReward)=="function" then
        pcall(ScriptReward)
    elseif type(ScriptReward)=="string" then
        pcall(loadstring(ScriptReward))
    end
else
    local Input = Instance.new("TextBox")
    Input.PlaceholderText = "Enter key"
    Input.ClearTextOnFocus = false
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 14
    Input.TextColor3 = Color3.fromRGB(240,240,240)
    Input.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Input.Size = UDim2.new(0.85,0,0,40)
    Input.Position = UDim2.fromScale(0.075,0.38) -- moved down a little
    Input.Parent = Main
    Instance.new("UICorner",Input).CornerRadius = UDim.new(0,10)

    local Copy = Instance.new("TextButton")
    Copy.Text = "Copy Key Link"
    Copy.Font = Enum.Font.Gotham
    Copy.TextSize = 13
    Copy.TextColor3 = Color3.fromRGB(0,122,255)
    Copy.BackgroundTransparency = 1
    Copy.Size = UDim2.new(1,0,0,25)
    Copy.Position = UDim2.fromScale(0,0.52)
    Copy.Parent = Main
    Copy.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(KeyLink)
            Status.TextColor3 = Color3.fromRGB(0,150,0)
            Status.Text = "Link copied!"
        end
    end)

    local Verify = Instance.new("TextButton")
    Verify.Text = "Verify Key"
    Verify.Font = Enum.Font.GothamMedium
    Verify.TextSize = 14
    Verify.TextColor3 = Color3.fromRGB(255,255,255)
    Verify.BackgroundColor3 = Color3.fromRGB(0,122,255)
    Verify.Size = UDim2.new(0.85,0,0,40)
    Verify.Position = UDim2.fromScale(0.075,0.7) -- moved down more
    Verify.Parent = Main
    Instance.new("UICorner",Verify).CornerRadius = UDim.new(0,10)
    Verify.MouseButton1Click:Connect(function()
        if Input.Text == Key then
            local exp = os.time()+KEY_DURATION
            save({expiry=exp})
            Status.TextColor3 = Color3.fromRGB(0,150,0)
            Status.Text = "Key verified!"
            task.wait(0.3)
            cleanup()
            if type(ScriptReward)=="function" then pcall(ScriptReward)
            elseif type(ScriptReward)=="string" then pcall(loadstring(ScriptReward)) end
        else
            Status.TextColor3 = Color3.fromRGB(200,0,0)
            Status.Text = "Invalid key."
        end
    end)
end

local dragging, startPos, startFrame
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
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
