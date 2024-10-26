local a1 = Instance.new("ScreenGui")
local b1 = Instance.new("Frame")
local c1 = Instance.new("TextLabel")
local d1 = Instance.new("TextBox")
local e1 = Instance.new("TextButton")
local f1 = Instance.new("UICorner")
local g1 = Instance.new("UIStroke")
local h1 = game:GetService("RunService")
local i1 = game:GetService("Players").LocalPlayer
a1.Parent = i1:WaitForChild("PlayerGui")
a1.Name = "XgYkH"
f1.CornerRadius = UDim.new(0, 12)
g1.Color = Color3.new(0, 0, 0)
g1.Thickness = 2
local function j1(k1, l1, m1, n1, o1, p1)
    local q1 = Instance.new("TextButton")
    q1.Parent = k1
    q1.Position = l1
    q1.Size = m1
    q1.Text = n1
    q1.BackgroundColor3 = o1
    q1.TextColor3 = p1
    q1.Font = Enum.Font.SourceSans
    q1.TextSize = 24
    f1:Clone().Parent = q1
    g1:Clone().Parent = q1
    return q1
end
b1.Parent = a1
b1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
b1.Position = UDim2.new(0.5, -200, 0.5, -200)
b1.Size = UDim2.new(0, 400, 0, 400)
b1.Visible = false
b1.BorderSizePixel = 0
f1:Clone().Parent = b1
local r1 = j1(a1, UDim2.new(0, 0, 0, 0), UDim2.new(0, 100, 0, 50), "Menu", Color3.fromRGB(60, 60, 60), Color3.fromRGB(255, 255, 255))
local s1 = j1(b1, UDim2.new(0.5, -50, 1, -40), UDim2.new(0, 100, 0, 30), "Close", Color3.fromRGB(220, 60, 60), Color3.fromRGB(255, 255, 255))
local t1 = j1(b1, UDim2.new(0.5, -50, 0, 20), UDim2.new(0, 100, 0, 50), "Freeze", Color3.fromRGB(80, 80, 80), Color3.fromRGB(255, 255, 255))
c1.Parent = b1
c1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
c1.Position = UDim2.new(0.1, 0, 0.4, 0)
c1.Size = UDim2.new(0.8, 0, 0, 30)
c1.Text = "Speed:"
c1.TextColor3 = Color3.fromRGB(255, 255, 255)
c1.Font = Enum.Font.SourceSans
c1.TextSize = 24
d1.Parent = b1
d1.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
d1.Position = UDim2.new(0.1, 0, 0.5, 0)
d1.Size = UDim2.new(0.8, 0, 0, 30)
d1.Text = "16"
d1.ClearTextOnFocus = true
d1.PlaceholderText = "Enter Speed"
d1.TextColor3 = Color3.fromRGB(255, 255, 255)
d1.Font = Enum.Font.SourceSans
d1.TextSize = 24
f1:Clone().Parent = d1
g1:Clone().Parent = d1
e1.Parent = b1
e1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
e1.Position = UDim2.new(0.5, -100, 1, -40)
e1.Size = UDim2.new(0, 200, 0, 30)
e1.Text = "Version 1.2"
e1.TextColor3 = Color3.fromRGB(200, 200, 200)
e1.Font = Enum.Font.SourceSans
e1.TextSize = 18
e1.TextXAlignment = Enum.TextXAlignment.Center
local u1 = false
local v1 = 16
local w1 = v1
local x1
local function y1()
    local z1 = i1.Character
    if not z1 then return end
    local aa1 = z1:FindFirstChild("HumanoidRootPart")
    local ab1 = z1:FindFirstChildOfClass("Humanoid")
    if aa1 and ab1 then
        if not u1 then
            aa1.Anchored = true
            x1 = h1.RenderStepped:Connect(function()
                if u1 then
                    aa1.CFrame = aa1.CFrame + (ab1.MoveDirection * w1 / 60)
                end
            end)
            u1 = true
            t1.Text = "Unfreeze"
        else
            aa1.Anchored = false
            ab1.WalkSpeed = v1
            u1 = false
            t1.Text = "Freeze"
            if x1 then x1:Disconnect() end
        end
    end
end

local function ac1()
    local ad1 = tonumber(d1.Text)
    if ad1 and ad1 > 0 then
        w1 = ad1
        c1.Text = "Speed: " .. tostring(w1)
    else
        d1.Text = tostring(w1)
    end
end

d1.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        ac1()
    end
end)

local ae1, af1, ag1
local ah1, ai1

local function aj1(input)
    local ak1 = input.Position - af1
    b1.Position = UDim2.new(ag1.X.Scale, ag1.X.Offset + ak1.X, ag1.Y.Scale, ag1.Y.Offset + ak1.Y)
end

b1.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ae1 = true
        af1 = input.Position
        ag1 = b1.Position

        ai1 = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                ae1 = false
                if ai1 then ai1:Disconnect() end
            end
        end)
    end
end)

b1.InputChanged:Connect(function(input)
    if ae1 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        aj1(input)
    end
end)

r1.MouseButton1Click:Connect(function()
    b1.Visible = not b1.Visible
end)

s1.MouseButton1Click:Connect(function()
    b1.Visible = false
end)

t1.MouseButton1Click:Connect(function()
    y1()
end)

e1.MouseButton1Click:Connect(function()
end)