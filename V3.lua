--[[
    Script: SMART HAKI V14 (Dodge Sensor Edition)
    Signed by: shma3h
    User ID: 1423181773906378814
    Features: Auto-Fly on 0 Dodge / Manual Stats Check / Two Buttons
]]

local player = game.Players.LocalPlayer
local vInput = game:GetService("VirtualInputManager")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local isRunning = false

-- 1. دالة الحصول على بيانات الهاكي (التنبؤ)
local function getDodgeInfo()
    local dodgeCount = 0
    local maxDodge = 0
    pcall(function()
        -- هذا المسار يتغير حسب نسخة اللعبة لكنه المعتاد في Blox Fruits
        local status = player:FindFirstChild("Data") and player.Data:FindFirstChild("Observation")
        if status then
            dodgeCount = status.Value -- عدد التفادي الحالي
            maxDodge = 8 -- القيمة الافتراضية
        else
            -- إذا لم يجد الداتا، نعتمد على واجهة المستخدم (GUI)
            local ui = player.PlayerGui:FindFirstChild("Observation")
            if ui then
                dodgeCount = tonumber(ui.Frame.TextLabel.Text:match("(%d+)")) or 0
            end
        end
    end)
    return dodgeCount
end

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

-- 3. واجهة المستخدم (V14)
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_V14_Smart"
screenGui.ResetOnSpawn = false

-- زر الفتح والقفل (S)
local toggleGuiBtn = Instance.new("TextButton", screenGui)
toggleGuiBtn.Size = UDim2.new(0, 45, 0, 45)
toggleGuiBtn.Position = UDim2.new(0, 10, 0.5, -22)
toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
toggleGuiBtn.Text = "S"
Instance.new("UICorner", toggleGuiBtn)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 220)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Visible = true

toggleGuiBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- زر تشغيل الفارم
local farmBtn = Instance.new("TextButton", main)
farmBtn.Size = UDim2.new(0, 220, 0, 50)
farmBtn.Position = UDim2.new(0.5, -110, 0.2, 0)
farmBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
farmBtn.Text = "START SMART FARM"
farmBtn.TextColor3 = Color3.new(1, 1, 1)
farmBtn.Font = Enum.Font.SourceSansBold

-- زر شيك الاستات (Stats)
local statsBtn = Instance.new("TextButton", main)
statsBtn.Size = UDim2.new(0, 220, 0, 50)
statsBtn.Position = UDim2.new(0.5, -110, 0.55, 0)
statsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
statsBtn.Text = "CHECK HAKI STATS"
statsBtn.TextColor3 = Color3.new(1, 1, 1)
statsBtn.Font = Enum.Font.SourceSansBold

farmBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    farmBtn.Text = isRunning and "FARMING... (SMART)" or "START SMART FARM"
    farmBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

statsBtn.MouseButton1Click:Connect(function()
    local d = getDodgeInfo()
    statsBtn.Text = "Dodges Left: " .. tostring(d)
    task.wait(2)
    statsBtn.Text = "CHECK HAKI STATS"
end)

-- 4. الحلقة الذكية (حسب عداد التفادي)
task.spawn(function()
    while true do
        if isRunning then
            pcall(function()
                local char = player.Character
                if not char then return end

                -- تفعيل الهاكي
                vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                -- البحث عن وحش حقيقي
                local enemy = nil
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        local n = v.Parent.Name:lower()
                        local isBad = n:find("teacher") or n:find("dealer") or n:find("shop") or n:find("quest") or v.Parent:FindFirstChild("Interaction")
                        if not isBad and v.Parent.Name ~= player.Name then
                            enemy = v.Parent
                            break
                        end
                    end
                end
                
                if enemy then
                    -- 1. انزل للوحش
                    local fly = safeFly(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4))
                    if fly then fly.Completed:Wait() end
                    
                    -- 2. راقب التفادي (Dodge)
                    -- ابقَ عند الوحش طالما الـ Dodge أكثر من 0
                    repeat
                        task.wait(0.5)
                    until getDodgeInfo() <= 0 or not isRunning or enemy.Humanoid.Health <= 0
                    
                    -- 3. إذا صار 0، طير فوق فوراً
                    print("Dodge is 0! Flying to recharge...")
                    safeFly(char.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0))
                    
                    -- 4. ابقَ فوق لين يشحن كامل (مثلاً يوصل 8 أو أكثر)
                    repeat
                        task.wait(1)
                    until getDodgeInfo() >= 7 or not isRunning -- يرجع لما يوصل 7 أو 8 تفادي
                    print("Haki Recharged! Going back...")
                end
            end)
        end
        task.wait(1)
    end
end)
