--[[
    Script: Full Auto-Observation Haki (One Click)
    Signed by: shma3h
    User ID: 1423181773906378814
]]

local player = game.Players.LocalPlayer
local vInput = game:GetService("VirtualInputManager")
local isRunning = false

-- إنشاء الواجهة (UI)
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "AutoHaki_shma3h"
screenGui.ResetOnSpawn = false

-- ميزة إخفاء الواجهة (عند الضغط في أي مكان على الشاشة)
local hideBtn = Instance.new("TextButton", screenGui)
hideBtn.Size = UDim2.new(1, 0, 1, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = ""
hideBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 200)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 255)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "AUTO HAKI PRO | shma3h"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local startBtn = Instance.new("TextButton", main)
startBtn.Size = UDim2.new(0, 200, 0, 60)
startBtn.Position = UDim2.new(0.5, -100, 0.35, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
startBtn.Text = "تشغيل الكل (اضغط ونم)"
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.SourceSansBold
startBtn.TextSize = 20

local info = Instance.new("TextLabel", main)
info.Size = UDim2.new(1, 0, 0, 40)
info.Position = UDim2.new(0, 0, 0.75, 0)
info.Text = "ID: 1423181773906378814\nاضغط أي مكان للإخفاء"
info.TextColor3 = Color3.new(0.7, 0.7, 0.7)
info.BackgroundTransparency = 1
info.TextSize = 12

-- دالة التنقل التلقائي (Teleport) لمكان التلفيل
local function teleportToHakiSpot()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- إحداثيات تقريبية لمنطقة Skylands (تأكد من لفل شخصيتك)
        char.HumanoidRootPart.CFrame = CFrame.new(-4965, 300, -2825) 
    end
end

-- منطق التشغيل
startBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        startBtn.Text = "شغال الآن..."
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        teleportToHakiSpot() -- ينتقل للمكان أول ما تشغل
    else
        startBtn.Text = "تشغيل الكل (اضغط ونم)"
        startBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    end
end)

-- الحلقة التكرارية (Loop)
spawn(function()
    while true do
        if isRunning then
            -- تشغيل الهاكي تلقائياً
            vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            wait(0.1)
            vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            
            -- فحص كل ثانيتين إذا كان يحتاج إعادة تفعيل
            wait(2) 
        end
        wait(1)
    end
end)

print("Full Auto-Haki by shma3h is READY.")
