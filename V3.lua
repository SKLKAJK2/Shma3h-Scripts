--[[
    Script: ULTIMATE HAKI V15 (FIXED SENSOR)
    Signed by: shma3h
    User ID: 1423181773906378814
    Instructions: UI disappears on screen click / Reads 3/3 accurately
]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local vInput = game:GetService("VirtualInputManager")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local isRunning = false

-- 1. دالة قراءة الهاكي من الشاشة (عشان يقرأ الـ 3/3 صح)
local function getRealDodge()
    local count = 0
    pcall(function()
        -- البحث عن عداد الهاكي في واجهة اللعبة
        local label = player.PlayerGui.OnScreenUI.HakiBar.TextLabel -- مسار تقريبي لبلوكس فروت
        if label then
            local current = label.Text:match("(%d+)/")
            count = tonumber(current) or 0
        else
            -- مسار بديل إذا تغيرت الواجهة
            for _, v in pairs(player.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Text:find("/") and v.Parent.Name:find("Haki") then
                    count = tonumber(v.Text:match("(%d+)/")) or 0
                    break
                end
            end
        end
    end)
    return count
end

-- 2. دالة الطيران الآمن
local function safeFly(targetCFrame)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local distance = (root.Position - targetCFrame.Position).Magnitude
        local info = TweenInfo.new(distance / 200, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(root, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- 3. واجهة المستخدم (V15)
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_V15_Final"
screenGui.ResetOnSpawn = false

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 200)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 150)
main.Visible = true

-- ميزة إخفاء القائمة عند الضغط في أي مكان
mouse.Button1Down:Connect(function()
    if main.Visible then
        main.Visible = false
    end
end)

-- زر "S" الصغير لإعادة إظهار القائمة
local sBtn = Instance.new("TextButton", screenGui)
sBtn.Size = UDim2.new(0, 40, 0, 40)
sBtn.Position = UDim2.new(0, 10, 0.5, -20)
sBtn.Text = "S"
sBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
sBtn.MouseButton1Click:Connect(function()
    main.Visible = true
end)

local farmBtn = Instance.new("TextButton", main)
farmBtn.Size = UDim2.new(0, 220, 0, 50)
farmBtn.Position = UDim2.new(0.5, -110, 0.2, 0)
farmBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
farmBtn.Text = "START HAKI FARM"
farmBtn.TextColor3 = Color3.new(1, 1, 1)

local statsBtn = Instance.new("TextButton", main)
statsBtn.Size = UDim2.new(0, 220, 0, 50)
statsBtn.Position = UDim2.new(0.5, -110, 0.6, 0)
statsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
statsBtn.Text = "CHECK STATUS"
statsBtn.TextColor3 = Color3.new(1, 1, 1)

farmBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    farmBtn.Text = isRunning and "FARMING..." or "START HAKI FARM"
    farmBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

statsBtn.MouseButton1Click:Connect(function()
    statsBtn.Text = "Current Dodge: " .. getRealDodge()
    task.wait(2)
    statsBtn.Text = "CHECK STATUS"
end)

-- 4. حلقة التحكم الذكي (تطير لما يصير 0 وتنزل لما يشحن)
task.spawn(function()
    while true do
        if isRunning then
            pcall(function()
                local char = player.Character
                if not char then return end

                -- البحث عن وحش حقيقي (تجاهل المدربين)
                local enemy = nil
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        if not v.Parent.Name:lower():find("teacher") and v.Parent.Name ~= player.Name then
                            enemy = v.Parent
                            break
                        end
                    end
                end

                if enemy then
                    -- تفعيل الهاكي
                    vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    
                    -- انزل للوحش
                    safeFly(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4))
                    
                    -- انتظر عند الوحش لين يخلص الهاكي (يصير 0)
                    repeat
                        task.wait(1)
                    until getRealDodge() <= 0 or not isRunning
                    
                    -- إذا خلص الهاكي، طير فوق للسماء (500 متر)
                    print("Dodge empty! Recharging...")
                    safeFly(char.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0))
                    
                    -- انتظر فوق لين يشحن كامل (يوصل 3 في حالتك)
                    repeat
                        task.wait(1)
                    until getRealDodge() >= 3 or not isRunning
                    print("Recharged! Going back...")
                end
            end)
        end
        task.wait(1)
    end
end)
