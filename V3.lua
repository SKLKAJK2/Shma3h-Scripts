--[[
    Script: Ultimate Safe Haki Farm V3
    Signed by: shma3h
    User ID: 1423181773906378814
    Protection: Anti-Kick, Anti-AFK, Smooth Movement
]]

local player = game.Players.LocalPlayer
local vInput = game:GetService("VirtualInputManager")
local runService = game:GetService("RunService")
local isRunning = false

-- 1. حماية Anti-AFK (تمنع طرد الخمول 20 دقيقة)
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

-- 2. إنشاء الواجهة (UI) بسلاسة عالية
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_SafeGuard_V3"
screenGui.ResetOnSpawn = false

-- ميزة الخصوصية (تختفي عند الضغط في أي مكان)
local hideBtn = Instance.new("TextButton", screenGui)
hideBtn.Size = UDim2.new(1, 0, 1, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = ""
hideBtn.ZIndex = 0
hideBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 180)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 255)
main.Active = true

-- [[ نظام تحريك الفريم السلس جداً ]]
local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
runService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "SAFE FARM V3 | shma3h"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.SourceSansBold

-- زر التشغيل والإيقاف
local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 200, 0, 55)
toggleBtn.Position = UDim2.new(0.5, -100, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleBtn.Text = "تشغيل الهاك"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20

local footer = Instance.new("TextLabel", main)
footer.Size = UDim2.new(1, 0, 0, 40)
footer.Position = UDim2.new(0, 0, 0.75, 0)
footer.Text = "ID: 1423181773906378814\nالحماية: مفعلة ومؤمنة"
footer.TextColor3 = Color3.new(0.5, 1, 0.5)
footer.BackgroundTransparency = 1
footer.TextSize = 10

-- 3. منطق التشغيل (Toggle)
toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.Text = "شغال (ON)"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        toggleBtn.Text = "متوقف (OFF)"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    end
end)

-- 4. حلقة العمل المحمية (Anti-Kick Logic)
task.spawn(function()
    while true do
        if isRunning then
            pcall(function()
                -- تفعيل الهاكي بضغطة مفتاح E سريعة وآمنة
                vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                -- البحث عن أقرب بوت والانتقال له بوضعية آمنة
                local enemies = game:GetService("Workspace").Enemies:GetChildren()
                for _, enemy in pairs(enemies) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                        -- الانتقال خلف البوت بمسافة آمنة لتجنب نظام الحماية
                        player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3.5)
                        break 
                    end
                end
            end)
            task.wait(1.5) -- تأخير زمني لمنع كشف السرعة
        end
        task.wait(0.5)
    end
end)

print("Haki Script by shma3h is now PROTECTED.")
