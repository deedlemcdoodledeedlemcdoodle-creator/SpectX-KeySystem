local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local dim = Instance.new("Frame")
dim.Size = UDim2.fromScale(1,1)
dim.BackgroundColor3 = Color3.new(0,0,0)
dim.BackgroundTransparency = 0.35
dim.ZIndex = 3
dim.Parent = gui

local main = Instance.new("Frame")
main.Size = UDim2.fromScale(0.42,0.48)
main.Position = UDim2.fromScale(0.29,0.26)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BorderSizePixel = 0
main.ZIndex = 10
main.Parent = gui

local scale = Instance.new("UIScale")
scale.Parent = main

Instance.new("UICorner", main).CornerRadius = UDim.new(0,18)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90,90,90)
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,0.1,0)
title.Position = UDim2.new(0,20,0,10)
title.BackgroundTransparency = 1
title.Text = WINDOW_TITLE
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Left
title.ZIndex = 12
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromScale(0.06,0.08)
close.Position = UDim2.fromScale(0.92,0.04)
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.TextColor3 = Color3.fromRGB(220,80,80)
close.BackgroundTransparency = 1
close.ZIndex = 15
close.Parent = main

close.Activated:Connect(function()
	gui:Destroy()
end)

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.fromScale(0.7,0.45)
keyFrame.Position = UDim2.fromScale(0.15,0.3)
keyFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
keyFrame.ZIndex = 18
keyFrame.Parent = main

Instance.new("UICorner", keyFrame)

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = Color3.fromRGB(80,80,80)
keyStroke.Parent = keyFrame

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.fromScale(1,0.22)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "Enter Key"
keyTitle.TextColor3 = Color3.new(1,1,1)
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextScaled = true
keyTitle.ZIndex = 19
keyTitle.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.fromScale(0.85,0.22)
keyBox.Position = UDim2.fromScale(0.075,0.3)
keyBox.PlaceholderText = "XXXX-XXXX"
keyBox.ClearTextOnFocus = false
keyBox.Font = Enum.Font.Gotham
keyBox.TextScaled = true
keyBox.TextColor3 = Color3.new(1,1,1)
keyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyBox.ZIndex = 19
keyBox.Parent = keyFrame

Instance.new("UICorner", keyBox)

local verify = Instance.new("TextButton")
verify.Size = UDim2.fromScale(0.5,0.18)
verify.Position = UDim2.fromScale(0.25,0.58)
verify.Text = "Verify"
verify.Font = Enum.Font.GothamBold
verify.TextScaled = true
verify.TextColor3 = Color3.new(1,1,1)
verify.BackgroundColor3 = Color3.fromRGB(70,120,255)
verify.ZIndex = 19
verify.Parent = keyFrame

Instance.new("UICorner", verify)

local copy = Instance.new("TextButton")
copy.Size = UDim2.fromScale(0.5,0.14)
copy.Position = UDim2.fromScale(0.25,0.78)
copy.Text = "Copy Link"
copy.Font = Enum.Font.Gotham
copy.TextScaled = true
copy.TextColor3 = Color3.new(1,1,1)
copy.BackgroundColor3 = Color3.fromRGB(40,40,40)
copy.ZIndex = 19
copy.Parent = keyFrame

Instance.new("UICorner", copy)

copy.Activated:Connect(function()
	if setclipboard then
		setclipboard(COPY_LINK)
	end
	copy.Text = "Copied"
end)

verify.Activated:Connect(function()
	if VALID_KEYS[keyBox.Text] then
		keyFrame:Destroy()
	else
		verify.Text = "Invalid"
	end
end)

local idle = TweenService:Create(
	main,
	TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{Position = main.Position + UDim2.new(0,0,0,-0.01)}
)
idle:Play()
