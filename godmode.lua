-- Создание интерфейса
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local FreezeButton = Instance.new("TextButton")
local SpeedLabel = Instance.new("TextLabel")
local SpeedInput = Instance.new("TextBox")
local VersionLabel = Instance.new("TextLabel")
local UICornerTemplate = Instance.new("UICorner")
local UIStrokeTemplate = Instance.new("UIStroke")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "MainMenuGui"

-- Настройка шаблонов для углов и обводки
UICornerTemplate.CornerRadius = UDim.new(0, 12)
UIStrokeTemplate.Color = Color3.new(0, 0, 0)
UIStrokeTemplate.Thickness = 2

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
    UICornerTemplate:Clone().Parent = button
    UIStrokeTemplate:Clone().Parent = button
    return button
end

-- Настройка главной рамки
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
MainFrame.Size = UDim2.new(0, 400, 0, 400)
MainFrame.Visible = false
MainFrame.BorderSizePixel = 0
UICornerTemplate:Clone().Parent = MainFrame

-- Настройка кнопок
ToggleButton = createButton(ScreenGui, UDim2.new(0, 0, 0, 0), UDim2.new(0, 100, 0, 50), "Меню", Color3.fromRGB(60, 60, 60), Color3.fromRGB(255, 255, 255))
CloseButton = createButton(MainFrame, UDim2.new(0.5, -50, 1, -40), UDim2.new(0, 100, 0, 30), "Закрыть", Color3.fromRGB(220, 60, 60), Color3.fromRGB(255, 255, 255))
FreezeButton = createButton(MainFrame, UDim2.new(0.5, -50, 0, 20), UDim2.new(0, 100, 0, 50), "Остановиться", Color3.fromRGB(80, 80, 80), Color3.fromRGB(255, 255, 255))

-- Настройка метки и поля ввода скорости
SpeedLabel.Parent = MainFrame
SpeedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 30)
SpeedLabel.Text = "Скорость:"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 24

SpeedInput.Parent = MainFrame
SpeedInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedInput.Position = UDim2.new(0.1, 0, 0.5, 0)
SpeedInput.Size = UDim2.new(0.8, 0, 0, 30)
SpeedInput.Text = "16"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.Font = Enum.Font.SourceSans
SpeedInput.TextSize = 24
UICornerTemplate:Clone().Parent = SpeedInput
UIStrokeTemplate:Clone().Parent = SpeedInput

-- Настройка метки версии
VersionLabel.Parent = MainFrame
VersionLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
VersionLabel.Position = UDim2.new(0.5, -100, 1, -40)
VersionLabel.Size = UDim2.new(0, 200, 0, 30)
VersionLabel.Text = "Версия 1.1"
VersionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
VersionLabel.Font = Enum.Font.SourceSans
VersionLabel.TextSize = 18
VersionLabel.TextXAlignment = Enum.TextXAlignment.Center

local isFrozen = false
local originalWalkSpeed = 16
local currentSpeed = originalWalkSpeed
local connection

local function toggleFreeze()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        if not isFrozen then
            character.HumanoidRootPart.Anchored = true
            connection = RunService.RenderStepped:Connect(function()
                if isFrozen then
                    local moveDirection = humanoid.MoveDirection
                    local delta = moveDirection * currentSpeed / 60
                    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + delta
                end
            end)
            isFrozen = true
            FreezeButton.Text = "Разморозить"
        else
            character.HumanoidRootPart.Anchored = false
            humanoid.WalkSpeed = originalWalkSpeed
            isFrozen = false
            FreezeButton.Text = "Остановиться"
            if connection then connection:Disconnect() end
        end
    end
end

local function updateSpeedFromInput()
    local inputSpeed = tonumber(SpeedInput.Text)
    if inputSpeed and inputSpeed > 0 then
        currentSpeed = inputSpeed
        SpeedLabel.Text = "Скорость: " .. tostring(currentSpeed)
    else
        SpeedInput.Text = tostring(currentSpeed)
    end
end

SpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateSpeedFromInput()
    end
end)

local dragging, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

FreezeButton.MouseButton1Click:Connect(function()
    toggleFreeze()
end)
