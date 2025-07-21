-- Universal Roblox Script con Fly y Super Velocidad
-- Menú toggle con tecla "M"

-- Variables
local uis = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local fly = false
local speedBoost = false
local flySpeed = 100
local walkSpeed = 100

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.05,0,0.2,0)
Frame.Size = UDim2.new(0, 220, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Visible = false
Frame.BorderSizePixel = 0

local flyButton = Instance.new("TextButton", Frame)
flyButton.Text = "Fly: OFF"
flyButton.Position = UDim2.new(0.05, 0, 0.1, 0)
flyButton.Size = UDim2.new(0.9, 0, 0.2, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local speedButton = Instance.new("TextButton", Frame)
speedButton.Text = "Speed: OFF"
speedButton.Position = UDim2.new(0.05, 0, 0.4, 0)
speedButton.Size = UDim2.new(0.9, 0, 0.2, 0)
speedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local flySlider = Instance.new("TextBox", Frame)
flySlider.PlaceholderText = "Fly Speed (ej: 100)"
flySlider.Position = UDim2.new(0.05, 0, 0.65, 0)
flySlider.Size = UDim2.new(0.9, 0, 0.1, 0)
flySlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
flySlider.TextColor3 = Color3.new(1,1,1)

local walkSlider = Instance.new("TextBox", Frame)
walkSlider.PlaceholderText = "Walk Speed (ej: 100)"
walkSlider.Position = UDim2.new(0.05, 0, 0.8, 0)
walkSlider.Size = UDim2.new(0.9, 0, 0.1, 0)
walkSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
walkSlider.TextColor3 = Color3.new(1,1,1)

-- Fly Logic
local bv, bg, con
function startFly()
    fly = true
    hum.PlatformStand = true

    bv = Instance.new("BodyVelocity", hrp)
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1, 1, 1) * math.huge

    bg = Instance.new("BodyGyro", hrp)
    bg.CFrame = hrp.CFrame
    bg.MaxTorque = Vector3.new(1, 1, 1) * math.huge

    con = game:GetService("RunService").RenderStepped:Connect(function()
        local camCF = workspace.CurrentCamera.CFrame
        local move = Vector3.new()

        if uis:IsKeyDown(Enum.KeyCode.W) then move = move + camCF.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move = move - camCF.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move = move - camCF.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move = move + camCF.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + camCF.UpVector end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - camCF.UpVector end

        bv.Velocity = move.Unit * flySpeed
        bg.CFrame = camCF
    end)
end

function stopFly()
    fly = false
    hum.PlatformStand = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    if con then con:Disconnect() end
end

-- Speed Logic
local speedCon
function startSpeed()
    speedBoost = true
    hum.WalkSpeed = walkSpeed
end

function stopSpeed()
    speedBoost = false
    hum.WalkSpeed = 16
end

-- Botones
flyButton.MouseButton1Click:Connect(function()
    if not fly then
        startFly()
        flyButton.Text = "Fly: ON"
    else
        stopFly()
        flyButton.Text = "Fly: OFF"
    end
end)

speedButton.MouseButton1Click:Connect(function()
    if not speedBoost then
        startSpeed()
        speedButton.Text = "Speed: ON"
    else
        stopSpeed()
        speedButton.Text = "Speed: OFF"
    end
end)

flySlider.FocusLost:Connect(function()
    local val = tonumber(flySlider.Text)
    if val then flySpeed = val end
end)

walkSlider.FocusLost:Connect(function()
    local val = tonumber(walkSlider.Text)
    if val then walkSpeed = val
        if speedBoost then hum.WalkSpeed = val end
    end
end)

-- Toggle con tecla "M"
uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.M then
        Frame.Visible = not Frame.Visible
    end
end)
