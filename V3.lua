--[[
    Script: SAFE HAKI V10.1 (ANTI-KICK)
    Signed by: shma3h
    User ID: 1423181773906378814
    Status: Safe Farm / Toggle UI / Identity Changer
]]

local player = game.Players.LocalPlayer
local vInput = game:GetService("VirtualInputManager")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local isRunning = false

-- 1. دالة تغيير الهوية (للهروب من الحماية)
local function changeIdentity()
    pcall(function()
        -- تغيير طفيف في معدل الإطارات والسرعة لخداع النظام
        if setfpscap then setfpscap(math.random(40, 60)) end
    end)
end

-- 2. منع الطرد (Anti-AFK)
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

-- 3. دالة الطيران الآمن (Safe Tween)
local function safeFly(targetCFrame)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local distance = (root.Position - targetCFrame.Position).Magnitude
        -- سرعة 200: أبطأ شوي لكنها تمنع الـ Kick تماماً
        local info = TweenInfo.new(distance / 200, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(root, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- 4. واجهة المستخدم (الزر [S] والفريم)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Shma3h_V10_Safe"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- الزر الجانبي الصغير
local toggleGuiBtn = Instance.new("TextButton")
toggleGuiBtn.Parent = screenGui
toggleGuiBtn.Size = UDim2.new(0, 45, 0, 45)
toggleGuiBtn.Position = UDim2.new(0, 10, 0.5, -22)
toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
toggleGuiBtn.Text = "S"
toggleGuiBtn.TextColor3 = Color3.new(0, 0, 0)
toggleGuiBtn.Font = Enum.Font.SourceSansBold
toggleGuiBtn.TextSize = 25
local corner = Instance.new("UICorner", toggleGuiBtn)
corner.CornerRadius = UDim.new(0, 10)

-- الفريم الأساسي
local main = Instance.new("Frame")
main.Parent = screenGui
main.Size = UDim2.new(0, 260, 0, 190)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 200, 255)
main.Visible = true -- يبدأ ظاهر

-- نظام السحب (Drag) للفريم
local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = main.Position
    end
end)
main.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
runService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- منطق زر الفتح والقفل
toggleGuiBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "HAKI SAFE V10 | shma3h"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 210, 0, 60)
toggleBtn.Position = UDim2.new(0.5, -105, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleBtn.Text = "START SAFE HAKI"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    changeIdentity()
    toggleBtn.Text = isRunning and "RUNNING (SAFE)" or "START SAFE HAKI"
    toggleBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- 5. الحلقة الأساسية (نظام الوقت الإجباري الآمن)
task.spawn(function()
    while true do
        if isRunning then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                -- تفعيل الهاكي (E) بهدوء
                vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                -- البحث عن أي بوت (NPC)
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
                    -- 1. طيران آمن للبوت
                    local flyTo = safeFly(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                    if flyTo then flyTo.Completed:Wait() end
                    
                    -- 2. انتظار إجباري لتلفيل الهاكي (10 ثواني)
                    task.wait(10)

                    -- 3. طيران للسماء (ارتفاع آمن 400 متر)
                    local skyFly = safeFly(char.HumanoidRootPart.CFrame * CFrame.new(0, 400, 0))
                    if skyFly then skyFly.Completed:Wait() end
                    
                    -- 4. انتظار الشحن (15 ثانية)
                    task.wait(15)
                end
            end)
        end
        task.wait(1) -- تأخير لتقليل الضغط على السيرفر
    end
end)

print("Haki V10.1 Loaded Successfully. Made by shma3h.")
