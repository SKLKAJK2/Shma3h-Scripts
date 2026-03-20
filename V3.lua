--[[
    Script: PRO HUNTER HAKI TASK V3 (FINAL)
    Signed by: shma3h
    User ID: 1423181773906378814
    Logic: Precision Dodge-Detection + High Altitude Recharge
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

-- 2. دالة الطيران السريع (Tween)
local function fastFly(targetCFrame)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        local distance = (root.Position - targetCFrame.Position).Magnitude
        local info = TweenInfo.new(distance / 450, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(root, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- 3. دالة فحص عداد التفادي (الرادار)
local function getDodgeCount()
    local count = 0
    pcall(function()
        -- فحص واجهة الهاكي في بلوكس فروت
        local gui = player.PlayerGui:FindFirstChild("Observation") or player.PlayerGui:FindFirstChild("HakiIndicator")
        if gui then
            local label = gui:FindFirstChildWhichIsA("TextLabel", true)
            if label and label.Text ~= "" then
                -- يلقط الرقم الأول (مثلاً 0 من 0/2)
                local current = label.Text:match("(%d+)/")
                count = tonumber(current) or 0
            end
        end
    end)
    return count
end

-- 4. إنشاء الواجهة (UI) الاحترافية
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_Hunter_V3"
screenGui.ResetOnSpawn = false

-- إخفاء القائمة عند النقر في أي مكان (طلبك)
local hideBtn = Instance.new("TextButton", screenGui)
hideBtn.Size = UDim2.new(1, 0, 1, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = ""
hideBtn.ZIndex = 0
hideBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 180)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 0, 0) -- أحمر غامق (هيبة البونتي)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.Active = true

-- نظام التحريك السلس (Smooth Drag)
local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
main.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
runService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "HAKI TASK V3 | shma3h"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
title.Font = Enum.Font.SourceSansBold

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 210, 0, 60)
toggleBtn.Position = UDim2.new(0.5, -105, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleBtn.Text = "START HAKI TASK"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20

-- منطق الزر
toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    toggleBtn.Text = isRunning and "TASK RUNNING..." or "START HAKI TASK"
    toggleBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- 5. الحلقة الأساسية (دقة الصيد)
task.spawn(function()
    while true do
        if isRunning then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                -- محاولة تفعيل الهاكي دائماً (E)
                vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.01)
                vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                local currentDodges = getDodgeCount()

                if currentDodges > 0 then
                    -- الهاكي شغال: طر لأقرب بوت فوراً
                    local enemy = nil
                    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            enemy = v
                            break
                        end
                    end
                    if enemy then
                        fastFly(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2.8))
                    end
                else
                    -- الهاكي خلص (0 تفادي): اهرب للسماء بأقصى سرعة
                    local skyPos = char.HumanoidRootPart.CFrame * CFrame.new(0, 850, 0)
                    fastFly(skyPos)
                    
                    -- انتظر فوق لين يشحن الهاكي ويطلع رقم 1 على الأقل
                    repeat task.wait(1) until getDodgeCount() > 0 or not isRunning
                    task.wait(2) -- مهلة إضافية لضمان استقرار الشحن
                end
            end)
        end
        task.wait(0.2)
    end
end)

print("Haki Task Script for shma3h is LIVE.")
