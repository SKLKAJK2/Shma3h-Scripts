--[[
    Script: Final Stable Haki V6 (Fixed Save)
    Signed by: shma3h
    User ID: 1423181773906378814
    Fix: Fly-Back Loop / High Stability
]]

local player = game.Players.LocalPlayer
local vInput = game:GetService("VirtualInputManager")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local isRunning = false

-- 1. منع الطرد (Anti-AFK)
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

-- 2. دالة الطيران السلس
local function fastFly(targetCFrame)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local distance = (root.Position - targetCFrame.Position).Magnitude
        local info = TweenInfo.new(distance / 400, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(root, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- 3. فحص العداد (2/2) بدقة
local function getDodgeCount()
    local count = 0
    pcall(function()
        local gui = player.PlayerGui:FindFirstChild("Observation") or player.PlayerGui:FindFirstChild("HakiIndicator")
        if gui then
            local label = gui:FindFirstChildWhichIsA("TextLabel", true)
            if label and label.Text ~= "" then
                local current = label.Text:match("(%d+)/")
                count = tonumber(current) or 0
            end
        end
    end)
    return count
end

-- 4. واجهة المستخدم (UI)
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_Stable_V6"
screenGui.ResetOnSpawn = false

-- إخفاء عند النقر
local hideBtn = Instance.new("TextButton", screenGui)
hideBtn.Size = UDim2.new(1, 0, 1, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = ""
hideBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 180)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 255)
main.Active = true

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 210, 0, 60)
toggleBtn.Position = UDim2.new(0.5, -105, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleBtn.Text = "START STABLE FARM"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 18

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    toggleBtn.Text = isRunning and "FARMING..." or "START STABLE FARM"
    toggleBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- 5. الحلقة الأساسية (تثبيت الهدف)
task.spawn(function()
    while true do
        if isRunning then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.01)
                vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                if getDodgeCount() > 0 then
                    local enemy = nil
                    for _, v in pairs(game.Workspace:GetDescendants()) do
                        if v:IsA("Humanoid") and v.Parent:FindFirstChild("HumanoidRootPart") and v.Health > 0 then
                            if v.Parent.Name ~= player.Name then
                                enemy = v.Parent
                                break
                            end
                        end
                    end
                    
                    if enemy then
                        fastFly(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                        repeat task.wait(0.2) until getDodgeCount() == 0 or not isRunning
                    end
                else
                    fastFly(char.HumanoidRootPart.CFrame * CFrame.new(0, 750, 0))
                    repeat task.wait(1) until getDodgeCount() >= 2 or not isRunning
                end
            end)
        end
        task.wait(0.5)
    end
end)
