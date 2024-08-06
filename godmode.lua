local a = Instance.new("ScreenGui")
local b = Instance.new("Frame")
local f = Instance.new("TextLabel")
local g = Instance.new("TextBox")
local l = game:GetService("RunService")
local players = game:GetService("Players")
local LocalPlayer = players.LocalPlayer

if not LocalPlayer then return end

a.Parent = LocalPlayer:WaitForChild("PlayerGui")
a.Name = "MainMenuGui"

local createUDim = UDim.new
local createUDim2 = UDim2.new
local createColor3 = Color3.fromRGB
local sourceSans = Enum.Font.SourceSans
local textCenter = Enum.TextXAlignment.Center

local function createCorner(parent)
    local i = Instance.new("UICorner")
    i.CornerRadius = createUDim(0, 12)
    i.Parent = parent
end

local function createStroke(parent)
    local j = Instance.new("UIStroke")
    j.Color = Color3.new(0, 0, 0)
    j.Thickness = 2
    j.Parent = parent
end

local function createButton(parent, position, size, text, bgColor, textColor)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Position = position
    button.Size = size
    button.Text = text
    button.BackgroundColor3 = bgColor
    button.TextColor3 = textColor
    button.Font = sourceSans
    button.TextSize = 24
    createCorner(button)
    createStroke(button)
    return button
end

b.Parent = a
b.BackgroundColor3 = createColor3(30, 30, 30)
b.Position = createUDim2(0.5, -200, 0.5, -200)
b.Size = createUDim2(0, 400, 0, 400)
b.Visible = false
b.BorderSizePixel = 0
createCorner(b)

local c = createButton(a, createUDim2(0, 0, 0, 0), createUDim2(0, 100, 0, 50), "Menu", createColor3(60, 60, 60), createColor3(255, 255, 255))
local d = createButton(b, createUDim2(0.5, -50, 1, -40), createUDim2(0, 100, 0, 30), "Close", createColor3(220, 60, 60), createColor3(255, 255, 255))
local e = createButton(b, createUDim2(0.5, -50, 0, 20), createUDim2(0, 100, 0, 50), "Freeze", createColor3(80, 80, 80), createColor3(255, 255, 255))

f.Parent = b
f.BackgroundColor3 = createColor3(40, 40, 40)
f.Position = createUDim2(0.1, 0, 0.4, 0)
f.Size = createUDim2(0.8, 0, 0, 30)
f.Text = "Speed:"
f.TextColor3 = createColor3(255, 255, 255)
f.Font = sourceSans
f.TextSize = 24

g.Parent = b
g.BackgroundColor3 = createColor3(70, 70, 70)
g.Position = createUDim2(0.1, 0, 0.5, 0)
g.Size = createUDim2(0.8, 0, 0, 30)
g.Text = "16"
g.ClearTextOnFocus = true
g.PlaceholderText = "Enter Speed"
g.TextColor3 = createColor3(255, 255, 255)
g.Font = sourceSans
g.TextSize = 24
createCorner(g)
createStroke(g)

local isFrozen = false
local defaultSpeed = 16
local speed = defaultSpeed
local moveConnection

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChildOfClass("Humanoid")

local function toggleFreeze()
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
local dragConnection, changeConnection

local function updateDrag(input)
    local delta = input.Position - dragStart
    b.Position = createUDim2(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

b.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = b.Position

        changeConnection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if changeConnection then changeConnection:Disconnect() end
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
    print("Menu button clicked")  -- Отладочная информация
    b.Visible = not b.Visible
    print("Menu visibility:", b.Visible)  -- Отладочная информация
end)

d.MouseButton1Click:Connect(function()
    b.Visible = false
end)

e.MouseButton1Click:Connect(function()
    toggleFreeze()
end)
