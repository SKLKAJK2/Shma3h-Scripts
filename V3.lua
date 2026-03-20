--[[
    Script: Ultimate Haki Farm V3 (TP to NPC + Toggle)
    Signed by: shma3h
    User ID: 1423181773906378814
]]

local player = game.Players.LocalPlayer
local vInput = game:GetService("VirtualInputManager")
local isRunning = false
local scriptURL = "https://raw.githubusercontent.com/SKLKAJK2/Shma3h-Scripts/refs/heads/main/V3.lua"

-- 1. منع الطرد (Anti-AFK)
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

-- 2. إنشاء الواجهة (UI)
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_System_V3"
screenGui.ResetOnSpawn = false

-- ميزة الخصوصية (تختفي عند الضغط في أي مكان)
local hideBtn = Instance.new("TextButton", screenGui)
hideBtn.Size = UDim2.new(1, 0, 1, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = ""
hideBtn.ZIndex = 0
hideBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

-- الفريم الرئيسي (قابل للتحريك)
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 180)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 255)
main.Active = true
main.Draggable = true -- تفعيل ميزة تحريك الفريم

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "AUTO HAKI V3 | shma3h"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Font = Enum.Font.SourceSansBold

-- زر التشغيل والإيقاف (Toggle)
local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 200, 0, 60)
toggleBtn.Position = UDim2.new(0.5, -100, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleBtn.Text = "OFF (إيقاف)"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 22

local footer = Instance.new("TextLabel", main)
footer.Size = UDim2.new(1, 0, 0, 40)
footer.Position = UDim2.new(0, 0, 0.75, 0)
footer.Text = "ID: 1423181773906378814\n(اضغط أي مكان للإخفاء)"
footer.TextColor3 = Color3.new(0.6, 0.6, 0.6)
footer.BackgroundTransparency = 1
footer.TextSize = 11

-- 3. منطق عمل الزر (تشغيل وإيقاف)
toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.Text = "ON (تشغيل)"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        -- استدعاء السكربت عبر loadstring
        pcall(function() loadstring(game:HttpGet(scriptURL))() end)
    else
        toggleBtn.Text = "OFF (إيقاف)"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    end
end)

-- 4. حلقة الانتقال للبوتات وتفعيل الهاكي
spawn(function()
    while true do
        if isRunning then
            -- تفعيل الهاكي تلقائياً
            vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            wait(0.05)
            vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- ملاحقة البوتات (الانتقال خلفهم)
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            -- الانتقال خلف البوت بمسافة بسيطة ليضربك
                            char.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            break -- يركز على بوت واحد حتى تنتهي التفاديات
                        end
                    end
                end
            end)
            wait(1.2) -- سرعة الانتقال
        else
            wait(1)
        end
    end
end)

print("Toggle Script V3 signed by: shma3h")
