local a = Instance.new("ScreenGui")
local b = Instance.new("Frame")
local c = Instance.new("TextButton")
local d = Instance.new("TextButton")
local e = Instance.new("TextButton")
local f = Instance.new("TextLabel")
local g = Instance.new("TextBox")
local h = Instance.new("TextButton")
local i = Instance.new("UICorner")
local j = Instance.new("UIStroke")
local l = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

a.Parent = LocalPlayer:WaitForChild("PlayerGui")
a.Name = "MainMenuGui"

i.CornerRadius = UDim.new(0, 12)
j.Color = Color3.new(0, 0, 0)
j.Thickness = 2

local function createButton(parent, position, size, text, bgColor, textColor)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Position = position
    button.Size = size
    button.Text = text
    button.BackgroundColor3 = bgColor
    button.TextColor3 = textColor
    button.Font = Enum.Font.SourceSans
    button.TextSize = 24
    i:Clone().Parent = button
    j:Clone().Parent = button
    return button
end

b.Parent = a
b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
b.Position = UDim2.new(0.5, -200, 0.5, -200)
b.Size = UDim2.new(0, 400, 0, 400)
b.Visible = false
b.BorderSizePixel = 0
i:Clone().Parent = b

c = createButton(a, UDim2.new(0, 0, 0, 0), UDim2.new(0, 100, 0, 50), "Menu", Color3.fromRGB(60, 60, 60), Color3.fromRGB(255, 255, 255))
d = createButton(b, UDim2.new(0.5, -50, 1, -40), UDim2.new(0, 100, 0, 30), "Close", Color3.fromRGB(220, 60, 60), Color3.fromRGB(255, 255, 255))
e = createButton(b, UDim2.new(0.5, -50, 0, 20), UDim2.new(0, 100, 0, 50), "Freeze", Color3.fromRGB(80, 80, 80), Color3.fromRGB(255, 255, 255))

f.Parent = b
f.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
f.Position = UDim2.new(0.1, 0, 0.4, 0)
f.Size = UDim2.new(0.8, 0, 0, 30)
f.Text = "Speed:"
f.TextColor3 = Color3.fromRGB(255, 255, 255)
f.Font = Enum.Font.SourceSans
f.TextSize = 24

g.Parent = b
g.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
g.Position = UDim2.new(0.1, 0, 0.5, 0)
g.Size = UDim2.new(0.8, 0, 0, 30)
g.Text = "16"
g.ClearTextOnFocus = true
g.PlaceholderText = "Enter Speed"
g.TextColor3 = Color3.fromRGB(255, 255, 255)
g.Font = Enum.Font.SourceSans
g.TextSize = 24
i:Clone().Parent = g
j:Clone().Parent = g

h.Parent = b
h.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
h.Position = UDim2.new(0.5, -100, 1, -40)
h.Size = UDim2.new(0, 200, 0, 30)
h.Text = "Version 1.2"
h.TextColor3 = Color3.fromRGB(200, 200, 200)
h.Font = Enum.Font.SourceSans
h.TextSize = 18
h.TextXAlignment = Enum.TextXAlignment.Center

local isFrozen = false
local defaultSpeed = 16
local speed = defaultSpeed
local moveConnection

local function toggleFreeze()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoidRootPart and humanoid then
        if not isFrozen then
            humanoidRootPart.Anchored = true
            moveConnection = l.RenderStepped:Connect(function()
                if isFrozen then
                    local moveDirection = humanoid.MoveDirection
                    local offset = moveDirection * speed / 60
                    humanoidRootPart.CFrame = humanoidRootPart.CFrame + offset
                end
            end)
            isFrozen = true
            e.Text = "Unfreeze"
        else
            humanoidRootPart.Anchored = false
            humanoid.WalkSpeed = defaultSpeed
            isFrozen = false
            e.Text = "Freeze"
            if moveConnection then moveConnection:Disconnect() end
        end
    end
end

local function updateSpeed()
    local newSpeed = tonumber(g.Text)
    if newSpeed and newSpeed > 0 then
        speed = newSpeed
        f.Text = "Speed: " .. tostring(speed)
    else
        g.Text = tostring(speed)
    end
end

g.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateSpeed()
    end
end)

local dragging, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    b.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

b.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = b.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

b.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

c.MouseButton1Click:Connect(function()
    b.Visible = not b.Visible
end)

d.MouseButton1Click:Connect(function()
    b.Visible = false
end)

e.MouseButton1Click:Connect(function()
    toggleFreeze()
end)

h.MouseButton1Click:Connect(function()
end)
