--[[
    Script: ULTIMATE MONSTER HUNTER V13 (FINAL)
    Signed by: shma3h
    User ID: 1423181773906378814
    Fix: Ignores ALL non-damaging NPCs (Teachers, Dealers, etc.)
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

-- 2. دالة الطيران الآمن (Safe Tween)
local function safeFly(targetCFrame)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local distance = (root.Position - targetCFrame.Position).Magnitude
        local info = TweenInfo.new(distance / 210, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(root, info, {CFrame = targetCFrame})
        tween:Play()
        return tween
    end
end

-- 3. واجهة المستخدم (الزر [S])
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "Shma3h_V13_Pro"
screenGui.ResetOnSpawn = false

local toggleGuiBtn = Instance.new("TextButton", screenGui)
toggleGuiBtn.Size = UDim2.new(0, 50, 0, 50)
toggleGuiBtn.Position = UDim2.new(0, 15, 0.5, -25)
toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
toggleGuiBtn.Text = "S"
toggleGuiBtn.Font = Enum.Font.SourceSansBold
toggleGuiBtn.TextSize = 25
Instance.new("UICorner", toggleGuiBtn)

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 260, 0, 180)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 120)
main.Visible = true

toggleGuiBtn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(0, 200, 0, 50)
toggleBtn.Position = UDim2.new(0.5, -100, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
toggleBtn.Text = "START HAKI FARM"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold

toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    toggleBtn.Text = isRunning and "HUNTING MONSTERS..." or "START HAKI FARM"
    toggleBtn.BackgroundColor3 = isRunning and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)

-- 4. حلقة البحث الذكي (تجاهل المدربين والبياعين)
task.spawn(function()
    while true do
        if isRunning then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                -- تفعيل الهاكي (E)
                vInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                vInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                local enemy = nil
                
                -- البحث عن وحش حقيقي (NPC ليس مدرباً ولا بياعاً)
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Health > 0 and v.Parent:FindFirstChild("HumanoidRootPart") then
                        local n = v.Parent.Name:lower()
                        -- قائمة الكلمات الممنوعة (تجاهل المدربين والبياعين)
                        local isBlacklisted = n:find("teacher") or n:find("dealer") or n:find("shop") or n:find("quest") or n:find("expert") or n:find("master") or n:find("trainer") or n:find("boat")
                        
                        -- شرط إضافي: تجاهل لو فيه Interact (زي اللي بالصورة)
                        local hasInteract = v.Parent:FindFirstChild("Interaction") or v.Parent:FindFirstChild("Interact") or v.Parent:FindFirstChild("Talk")

                        if not isBlacklisted and not hasInteract and v.Parent.Name ~= player.Name then
                            enemy = v.Parent
                            break
                        end
                    end
                end
                
                if enemy then
                    -- طيران للوحش الحقيقي
                    local fly = safeFly(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4))
                    if fly then fly.Completed:Wait() end
                    
                    -- ابقَ عند الوحش 12 ثانية (حتى يخلص التفادي 2/2)
                    task.wait(12)
                    
                    -- طيران للسماء (ارتفاع آمن للشحن)
                    safeFly(char.HumanoidRootPart.CFrame * CFrame.new(0, 500, 0))
                    
                    -- انتظار الشحن 15 ثانية
                    task.wait(15)
                end
            end)
        end
        task.wait(1)
    end
end)
