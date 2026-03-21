--[[
    Script: ULTIMATE HAKI V8 (Toggle Button Edition)
    Signed by: shma3h
    User ID: 1423181773906378814
    Fix: Added Open/Close Button / Removed Click-to-Hide
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

-- 2. دالة الطيران السريع
local function fastFly(targetCFrame)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local distance = (root.Position - targetCFrame.Position).Magnitude
        local info = TweenInfo.new(distance / 450, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(root, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- 3. واجهة المستخدم (UI) مع زر الفتح والقفل
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_Pro_V8"
screenGui.ResetOnSpawn = false

-- [[ الزر الصغير لفتح وقفل القائمة ]]
local toggleGuiBtn = Instance.new("TextButton", screenGui)
toggleGuiBtn.Size = UDim2.new(0, 50, 0, 50)
toggleGuiBtn.Position = UDim2.new(0.02, 0, 0.4, 0) -- مكانه في يسار الشاشة
toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
toggleGuiBtn.Text = "S"
toggleGuiBtn.TextColor3 = Color3.new(0, 0, 0)
toggleGuiBtn.Font = Enum.Font.SourceSansBold
toggleGuiBtn.TextSize = 25
-- جعل الزر دائري قليلاً
local corner = Instance.new("UICorner", toggleGuiBtn)
corner.CornerRadius = ToolPoint.new(0, 25)

-- [[ الفريم الأساسي ]]
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 190)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 255)
main.Active = true
main.Visible = true -- يبدأ وهو ظاهر

-- منطق زر الفتح والقفل
toggleGuiBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- نظام السحب (Drag) للفريم
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
title.Text = "HAKI V8 | shma3h"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 210, 0, 60)
toggleBtn.Position = UDim2.new(0.5, -105, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleBtn.Text = "START HAKI FARM"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 18

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    toggleBtn.Text = isRunning and "RUNNING..." or "START HAKI FARM"
    toggleBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- 4. الحلقة الأساسية (نظام الوقت الإجباري)
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

                -- البحث عن أي بوت في الماب
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
                    -- 1. طيران للبوت
                    local flyTo = fastFly(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    if flyTo then flyTo.Completed:Wait() end
                    
                    -- 2. اجلس عند البوت 10 ثواني (غصب) لتلفيل الهاكي
                    task.wait(10)

                    -- 3. طيران للسماء (800 متر فوق)
                    local skyFly = fastFly(char.HumanoidRootPart.CFrame * CFrame.new(0, 800, 0))
                    if skyFly then skyFly.Completed:Wait() end
                    
                    -- 4. اجلس فوق 12 ثانية (شحن غصب)
                    task.wait(12)
                end
            end)
        end
        task.wait(0.5)
    end
end)
