--[[
    Script: Ultimate Movement Haki V5
    Signed by: shma3h
    User ID: 1423181773906378814
    Fix: Fixed Anti-Movement / Global NPC Search
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

-- 2. دالة الطيران السريع (Tween) - مُعدلة لضمان الحركة
local function fastFly(targetCFrame)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local distance = (root.Position - targetCFrame.Position).Magnitude
        -- سرعة 450 عشانك لفل ماكس
        local info = TweenInfo.new(distance / 450, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(root, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- 3. دالة البحث الشامل عن البوتات (عشان ما يوقف مكانه)
local function findNearestEnemy()
    local nearest = nil
    local lastDist = math.huge
    
    -- يبحث في كل مكان باللعبة عن أي موديل فيه هيلث (دم)
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Parent:FindFirstChild("HumanoidRootPart") and v.Health > 0 then
            -- يتأكد إنه مو أنت (اللاعب)
            if v.Parent.Name ~= player.Name then
                local dist = (player.Character.HumanoidRootPart.Position - v.Parent.HumanoidRootPart.Position).Magnitude
                if dist < lastDist then
                    lastDist = dist
                    nearest = v.Parent
                end
            end
        end
    end
    return nearest
end

-- 4. فحص العداد (2/2)
local function getDodgeCount()
    local count = 0
    pcall(function()
        local gui = player.PlayerGui:FindFirstChild("Observation") or player.PlayerGui:FindFirstChild("HakiIndicator")
        if gui then
            local label = gui:FindFirstChildWhichIsA("TextLabel", true)
            if label then
                local current = label.Text:match("(%d+)/")
                count = tonumber(current) or 0
            end
        end
    end)
    return count
end

-- 5. الواجهة (UI)
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_MotionFix_V5"
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
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 150)
main.Active = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "MOTION FIXED V5 | shma3h"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 210, 0, 60)
toggleBtn.Position = UDim2.new(0.5, -105, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleBtn.Text = "START MOTION"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 20

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    toggleBtn.Text = isRunning and "RUNNING..." or "START MOTION"
    toggleBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- 6. الحلقة الأساسية (البحث والتحرك)
task.spawn(function()
    while true do
        if isRunning then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                -- تفعيل الهاكي (E)
                vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.01)
                vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                local currentDodges = getDodgeCount()

                if currentDodges > 0 then
                    -- ابحث عن أقرب بوت في كل الـ Workspace
                    local enemy = findNearestEnemy()
                    if enemy then
                        fastFly(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    end
                else
                    -- الهاكي خلص: طر فوق
                    fastFly(char.HumanoidRootPart.CFrame * CFrame.new(0, 700, 0))
                    repeat task.wait(1) until getDodgeCount() > 0 or not isRunning
                end
            end)
        end
        task.wait(0.2)
    end
end)
