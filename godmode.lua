-- Создание интерфейса
local a = Instance.new("ScreenGui")
local b = Instance.new("Frame")
local c = Instance.new("TextButton")
local d = Instance.new("TextButton")
local e = Instance.new("TextButton")
local f = Instance.new("TextLabel")
local g = Instance.new("TextBox")
local h = Instance.new("TextLabel")
local i = Instance.new("UICorner")
local j = Instance.new("UIStroke")
local k = game:GetService("UserInputService")
local l = game:GetService("RunService")

a.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
a.Name = "MainMenuGui"

i.CornerRadius = UDim.new(0, 12)
j.Color = Color3.new(0, 0, 0)
j.Thickness = 2

local function m(n, o, p, q, r, s)
    local t = Instance.new("TextButton")
    t.Parent = n
    t.Position = o
    t.Size = p
    t.Text = q
    t.BackgroundColor3 = r
    t.TextColor3 = s
    t.Font = Enum.Font.SourceSans
    t.TextSize = 24
    i:Clone().Parent = t
    j:Clone().Parent = t
    return t
end

b.Parent = a
b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
b.Position = UDim2.new(0.5, -200, 0.5, -200)
b.Size = UDim2.new(0, 400, 0, 400)
b.Visible = false
b.BorderSizePixel = 0
i:Clone().Parent = b

c = m(a, UDim2.new(0, 0, 0, 0), UDim2.new(0, 100, 0, 50), "Menu", Color3.fromRGB(60, 60, 60), Color3.fromRGB(255, 255, 255))
d = m(b, UDim2.new(0.5, -50, 1, -40), UDim2.new(0, 100, 0, 30), "Close", Color3.fromRGB(220, 60, 60), Color3.fromRGB(255, 255, 255))
e = m(b, UDim2.new(0.5, -50, 0, 20), UDim2.new(0, 100, 0, 50), "Freeze", Color3.fromRGB(80, 80, 80), Color3.fromRGB(255, 255, 255))

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
g.TextColor3 = Color3.fromRGB(255, 255, 255)
g.Font = Enum.Font.SourceSans
g.TextSize = 24
i:Clone().Parent = g
j:Clone().Parent = g

h.Parent = b
h.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
h.Position = UDim2.new(0.5, -100, 1, -40)
h.Size = UDim2.new(0, 200, 0, 30)
h.Text = "Version 1.1"
h.TextColor3 = Color3.fromRGB(200, 200, 200)
h.Font = Enum.Font.SourceSans
h.TextSize = 18
h.TextXAlignment = Enum.TextXAlignment.Center

local u = false
local v = 16
local w = v
local x

local function y()
    local z = game.Players.LocalPlayer
    local aa = z.Character
    local ab = aa:FindFirstChildOfClass("Humanoid")

    if ab then
        if not u then
            aa.HumanoidRootPart.Anchored = true
            x = l.RenderStepped:Connect(function()
                if u then
                    local ac = ab.MoveDirection
                    local ad = ac * w / 60
                    aa.HumanoidRootPart.CFrame = aa.HumanoidRootPart.CFrame + ad
                end
            end)
            u = true
            e.Text = "Unfreeze"
        else
            aa.HumanoidRootPart.Anchored = false
            ab.WalkSpeed = v
            u = false
            e.Text = "Freeze"
            if x then x:Disconnect() end
        end
    end
end

local function ae()
    local af = tonumber(g.Text)
    if af and af > 0 then
        w = af
        f.Text = "Speed: " .. tostring(w)
    else
        g.Text = tostring(w)
    end
end

g.FocusLost:Connect(function(ag)
    if ag then
        ae()
    end
end)

local ah, ai, aj

local function ak(al)
    local am = al.Position - ai
    b.Position = UDim2.new(aj.X.Scale, aj.X.Offset + am.X, aj.Y.Scale, aj.Y.Offset + am.Y)
end

b.InputBegan:Connect(function(al)
    if al.UserInputType == Enum.UserInputType.MouseButton1 or al.UserInputType == Enum.UserInputType.Touch then
        ah = true
        ai = al.Position
        aj = b.Position

        al.Changed:Connect(function()
            if al.UserInputState == Enum.UserInputState.End then
                ah = false
            end
        end)
    end
end)

b.InputChanged:Connect(function(al)
    if ah and (al.UserInputType == Enum.UserInputType.MouseMovement or al.UserInputType == Enum.UserInputType.Touch) then
        ak(al)
    end
end)

c.MouseButton1Click:Connect(function()
    b.Visible = not b.Visible
end)

d.MouseButton1Click:Connect(function()
    b.Visible = false
end)

e.MouseButton1Click:Connect(function()
    y()
end)
