--[[
    Script: Haki Leveler with Toggle UI
    Signed by: shma3h
    User ID: 1423181773906378814
]]

local player = game.Players.LocalPlayer
local vInput = game:GetService("VirtualInputManager")
local isRunning = false -- حالة السكربت الافتراضية

-- إنشاء الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Haki_shma3h_Pro"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

-- الزر الشفاف للإخفاء (عند الضغط في أي مكان)
local invisibleHide = Instance.new("TextButton")
invisibleHide.Size = UDim2.new(1, 0, 1, 0)
invisibleHide.BackgroundTransparency = 1
invisibleHide.Text = ""
invisibleHide.Parent = screenGui

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 220)
mainFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 127)
mainFrame.Parent = screenGui

-- العنوان
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Haki Leveler | shma3h"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Parent = mainFrame

-- زر التشغيل والإيقاف (Toggle Button)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 200, 0, 50)
toggleBtn.Position = UDim2.new(0.5, -100, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- أحمر في البداية (إيقاف)
toggleBtn.Text = "Status: OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Parent = mainFrame

-- معلومات الـ ID
local idInfo = Instance.new("TextLabel")
idInfo.Size = UDim2.new(1, 0, 0, 30)
idInfo.Position = UDim2.new(0, 0, 0.65, 0)
idInfo.Text = "ID: 1423181773906378814"
idInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
idInfo.BackgroundTransparency = 1
idInfo.Parent = mainFrame

local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(1, 0, 0, 30)
hint.Position = UDim2.new(0, 0, 0.85, 0)
hint.Text = "اضغط في أي مكان لإخفاء هذه القائمة"
hint.TextColor3 = Color3.new(0.7, 0.7, 0.7)
hint.TextSize = 11
hint.BackgroundTransparency = 1
hint.Parent = mainFrame

-- منطق الزر (Toggle)
toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.Text = "Status: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- أخضر عند التشغيل
    else
        toggleBtn.Text = "Status: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- أحمر عند الإيقاف
    end
end)

-- منطق إخفاء الواجهة عند النقر في أي مكان
invisibleHide.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    print("UI hidden for privacy.")
end)

-- وظيفة تلفيل الهاكي الخلفية
spawn(function()
    while true do
        if isRunning then
            -- ضغط مفتاح E لتفعيل هاكي التنبؤ
            vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            wait(0.1)
            vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            
            -- انتظار إعادة الشحن (يمكنك تقليل الوقت حسب لفل الهاكي عندك)
            wait(6) 
        end
        wait(1)
    end
end)

print("Script signed by: shma3h")
