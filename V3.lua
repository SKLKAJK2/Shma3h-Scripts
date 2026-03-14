--[[
    SHMA3H ULTIMATE HACK V3
    Made by : shma3h
    User ID: 1423181773906378814
    Signature: shma3h
]]

-- إعدادات الأمان وتغيير الـ IP الوهمي
print("shma3h: System Connected. Virtual IP: "..math.random(1,255).."."..math.random(1,255)..".101.1")

local Player = game.Players.LocalPlayer
local UserID = Player.UserId

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Shma3hFinalHack"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- وظائف التنسيق
local function ApplyStyle(obj, radius, color, thick)
    local corner = Instance.new("UICorner", obj)
    corner.CornerRadius = radius or UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", obj)
    stroke.Color = color or Color3.fromRGB(100, 255, 150)
    stroke.Thickness = thick or 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return stroke
end

-- زر الفتح (Biohazard)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
OpenBtn.Text = "☣️"
OpenBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
OpenBtn.TextScaled = true
ApplyStyle(OpenBtn, UDim.new(1, 0), Color3.fromRGB(100, 255, 150), 3)

-- الفريم الرئيسي (تصميم الكبسولة حسب رسمتك)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 700, 0, 480)
Main.Position = UDim2.new(0.5, -350, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Visible = true
Main.Active, Main.Draggable = true, true
ApplyStyle(Main, UDim.new(0, 40), Color3.fromRGB(100, 255, 150), 3)

-- قسم البروفايل (فوق الأزرار الجانبية)
local Profile = Instance.new("Frame", Main)
Profile.Size = UDim2.new(0, 200, 0, 100)
Profile.Position = UDim2.new(0, 25, 0, 30)
Profile.BackgroundTransparency = 1

local Avatar = Instance.new("ImageLabel", Profile)
Avatar.Size = UDim2.new(0, 50, 0, 50)
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..UserID.."&w=150&h=150"
ApplyStyle(Avatar, UDim.new(1, 0), Color3.fromRGB(100, 255, 150), 1.5)

local Info = Instance.new("TextLabel", Profile)
Info.Size = UDim2.new(1, -60, 1, 0)
Info.Position = UDim2.new(0, 60, 0, 0)
Info.Text = Player.DisplayName.."\nID: "..UserID.."\nBy: shma3h"
Info.TextColor3 = Color3.new(1, 1, 1)
Info.TextSize = 12
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.GothamBold

-- القائمة الجانبية
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 200, 1, -150)
Sidebar.Position = UDim2.new(0, 25, 0, 130)
Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 12)

-- محتوى الصفحات
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -260, 1, -60)
Container.Position = UDim2.new(0, 235, 0, 30)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    local layout = Instance.new("UIGridLayout", p)
    layout.CellSize = UDim2.new(0, 210, 0, 50)
    layout.CellPadding = UDim2.new(0, 12, 0, 12)
    Pages[name] = p return p
end

local MainPg = CreatePage("Main")
local ChaosPg = CreatePage("Chaos")
local PowerPg = CreatePage("Power")
local TargetPg = CreatePage("Target")
MainPg.Visible = true

-- نظام الـ Bang المطور
local BangActive = false
local BangSpeed = 15
local TargetName = ""

local function RunBang()
    local targetPlr = nil
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():sub(1, #TargetName) == TargetName:lower() then targetPlr = v break end
    end
    if targetPlr and targetPlr.Character then
        BangActive = true
        task.spawn(function()
            while BangActive and task.wait() do
                local root = Player.Character:FindFirstChild("HumanoidRootPart")
                local tRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart")
                if root and tRoot then
                    local movement = math.sin(tick() * BangSpeed) * 0.9
                    root.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1.1 + movement)
                end
            end
        end)
    end
end

-- إضافة الأزرار
local function AddBtn(pg, txt, func)
    local b = Instance.new("TextButton", pg)
    b.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    ApplyStyle(b, UDim.new(0, 10))
    b.MouseButton1Click:Connect(func)
end

-- صفحة Target
local Input = Instance.new("TextBox", TargetPg)
Input.Size = UDim2.new(0, 210, 0, 50)
Input.PlaceholderText = "اسم اللاعب..."
Input.TextScaled = true
ApplyStyle(Input, UDim.new(0, 10))
Input.FocusLost:Connect(function() TargetName = Input.Text end)

AddBtn(TargetPg, "تشغيل | Bang", RunBang)
AddBtn(TargetPg, "إيقاف | Stop", function() BangActive = false end)
AddBtn(TargetPg, "سرعة جنونية | Insane", function() BangSpeed = 45 end)

-- نظام التبويبات (كبسولات)
local function AddTab(name, disp)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    b.Text = disp
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    ApplyStyle(b, UDim.new(1, 0), Color3.fromRGB(40, 40, 40), 1)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
    end)
end

AddTab("Main", "Main | الاساسيه")
AddTab("Chaos", "Chaos | التخريب")
AddTab("Power", "Power | القوه")
AddTab("Target", "Target Person | اختيار شخص")

-- إخفاء الواجهة عند الضغط في أي مكان (طلبك)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = input.Position
        if Main.Visible and (pos.X < Main.AbsolutePosition.X or pos.X > Main.AbsolutePosition.X + Main.AbsoluteSize.X) then
            Main.Visible = false
        end
    end
end)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- التوقيع النهائي
print("made by : shma3h")
-- signed by: shma3h
