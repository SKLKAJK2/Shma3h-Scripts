--[[
    Script: ULTIMATE ENEMY HUNTER V11
    Signed by: shma3h
    User ID: 1423181773906378814
    Fix: Ignores Boat Dealers / Targets Monsters Only
]]

local player = game.Players.LocalPlayer
local vInput = game:GetService("VirtualInputManager")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local isRunning = false

-- 1. تغيير الهوية ومنع الطرد
local function changeIdentity()
    pcall(function() if setfpscap then setfpscap(math.random(45, 60)) end end)
end

local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

-- 2. دالة الطيران الآمن
local function safeFly(targetCFrame)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local distance = (root.Position - targetCFrame.Position).Magnitude
        local info = TweenInfo.new(distance / 220, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(root, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- 3. واجهة المستخدم (الزر S)
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_V11_Final"
screenGui.ResetOnSpawn = false

local toggleGuiBtn = Instance.new("TextButton", screenGui)
toggleGuiBtn.Size = UDim2.new(0, 50, 0, 50)
toggleGuiBtn.Position = UDim2.new(0, 15, 0.5, -25)
toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
toggleGuiBtn.Text = "S"
toggleGuiBtn.TextSize = 25
toggleGuiBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", toggleGuiBtn)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 180)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 120)
main.Visible = true

toggleGuiBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "MONSTER HUNT V11 | shma3h"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 200, 0, 50)
toggleBtn.Position = UDim2.new(0.5, -100, 0.5, -15)
toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
toggleBtn.Text = "START HAKI FARM"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    changeIdentity()
    toggleBtn.Text = isRunning and "HUNTING..." or "START HAKI FARM"
    toggleBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)

-- 4. حلقة البحث الذكي عن الوحوش
task.spawn(function()
    while true do
        if isRunning then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                -- تفعيل الهاكي
                vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                local enemy = nil
                
                -- أولاً: البحث في مجلد الوحوش الأساسي في بلوكس فروت
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        local name = v.Parent.Name:lower()
                        -- فلترة: لو الاسم فيه بياع أو مهمة لا تروح له
                        if not name:find("dealer") and not name:find("shop") and not name:find("quest") and not name:find("boat") and not name:find("sword") and v.Parent.Name ~= player.Name then
                            enemy = v.Parent
                            break
                        end
                    end
                end
                
                if enemy then
                    -- طيران للوحش
                    local fly = safeFly(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4))
                    if fly then fly.Completed:Wait() end
                    
                    -- تثبيت عند الوحش (12 ثانية لتخلص التفادي)
                    task.wait(12)
                    
                    -- هروب للسماء (ارتفاع آمن 500 متر)
                    safeFly(char.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0))
                    
                    -- انتظار شحن (15 ثانية)
                    task.wait(15)
                end
            end)
        end
        task.wait(1)
    end
end)
