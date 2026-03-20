--[[
    Script: Ultimate Balanced Haki V3 (Final)
    Signed by: shma3h
    User ID: 1423181773906378814
    Logic: Smart Eye-Detect + Smooth Fly + Sky Recharge
]]

local player = game.Players.LocalPlayer
local vInput = game:GetService("VirtualInputManager")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local isRunning = false

-- 1. منع الطرد للخمول (Anti-AFK)
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

-- 2. دالة الطيران السريع (Fast Fly Tween)
local function fastFly(targetCFrame)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        local distance = (root.Position - targetCFrame.Position).Magnitude
        local speed = 380 
        local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(root, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- 3. دالة فحص حالة الهاكي (التنبؤ)
local function isHakiActive()
    local char = player.Character
    if char and (char:FindFirstChild("ObservationHakiActivated") or char:FindFirstChild("HakiPower")) then
        return true
    end
    return false
end

-- 4. إنشاء الواجهة (UI) والزر
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_Final_V3"
screenGui.ResetOnSpawn = false

-- ميزة الاختفاء عند النقر في أي مكان
local hideBtn = Instance.new("TextButton", screenGui)
hideBtn.Size = UDim2.new(1, 0, 1, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = ""
hideBtn.ZIndex = 0
hideBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 190)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 255)
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
title.Text = "ULTIMATE HAKI | shma3h"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.SourceSansBold

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 210, 0, 60)
toggleBtn.Position = UDim2.new(0.5, -105, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleBtn.Text = "START (إيقاف)"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20

-- منطق الزر
toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    toggleBtn.Text = isRunning and "RUNNING (تشغيل)" or "START (إيقاف)"
    toggleBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
end)

local footer = Instance.new("TextLabel", main)
footer.Size = UDim2.new(1, 0, 0, 40)
footer.Position = UDim2.new(0, 0, 0.78, 0)
footer.Text = "ID: 1423181773906378814\nطيران ذكي للسماء"
footer.TextColor3 = Color3.new(0.8, 0.8, 0.8)
footer.BackgroundTransparency = 1
footer.TextSize = 10

-- 5. الحلقة الذكية (Logic)
task.spawn(function()
    local skyWait = false
    while true do
        if isRunning then
            pcall(function()
                local char = player.Character
                if not char then return end

                -- تفعيل الهاكي (E)
                vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.01)
                vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                if isHakiActive() then
                    skyWait = false
                    -- الهاكي شغال: طر لأقرب بوت
                    local enemy = nil
                    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            enemy = v
                            break
                        end
                    end
                    if enemy then
                        fastFly(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    end
                else
                    -- الهاكي طافي: انتظر 1.5 ثانية للتأكيد قبل الطيران للسماء
                    if not skyWait then
                        task.wait(1.5) 
                        skyWait = true
                    end
                    
                    if not isHakiActive() then
                        local skyPos = char.HumanoidRootPart.CFrame * CFrame.new(0, 700, 0)
                        fastFly(skyPos)
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

print("Full V3 Script signed by: shma3h")
