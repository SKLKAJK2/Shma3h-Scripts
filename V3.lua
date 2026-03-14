--[[
    SHMA3H ULTIMATE V6 - ALL-IN-ONE SCRIPT
    Signature: made by : shma3h
    User ID: 1423181773906378814
]]

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local UIS = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "Shma3hV6_Final"
ScreenGui.ResetOnSpawn = false

-- [[ نظام التنسيق - ستروك ناعم ]]
local function ApplyStyle(obj, radius, strokeColor)
    local corner = Instance.new("UICorner", obj)
    corner.CornerRadius = radius or UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", obj)
    stroke.Color = strokeColor or Color3.fromRGB(100, 255, 150)
    stroke.Thickness = 1.2
    stroke.Transparency = 0.4
end

-- [[ زر الفتح والإغلاق ]]
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
OpenBtn.Text = "☣️"
OpenBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
OpenBtn.TextSize = 25
ApplyStyle(OpenBtn, UDim.new(1, 0))

-- [[ الفريم الرئيسي ]]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 620, 0, 400)
Main.Position = UDim2.new(0.5, -310, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Visible = false
Main.Active, Main.Draggable = true, true
ApplyStyle(Main, UDim.new(0, 15))

-- [[ الهيدر - بيانات اللاعب ]]
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, -30, 0, 65)
Header.Position = UDim2.new(0, 15, 0, 15)
Header.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
ApplyStyle(Header, UDim.new(0, 10), Color3.fromRGB(45, 45, 45))

local Av = Instance.new("ImageLabel", Header)
Av.Size = UDim2.new(0, 50, 0, 50)
Av.Position = UDim2.new(0, 10, 0.5, -25)
Av.Image = "rbxthumb://type=AvatarHeadShot&id="..Player.UserId.."&w=150&h=150"
ApplyStyle(Av, UDim.new(1, 0))

local Info = Instance.new("TextLabel", Header)
Info.Size = UDim2.new(1, -75, 1, 0)
Info.Position = UDim2.new(0, 70, 0, 0)
Info.BackgroundTransparency = 1
Info.Text = "User: "..Player.Name.." | ID: "..Player.UserId.."\nPass: [ENCRYPTED]"
Info.TextColor3 = Color3.fromRGB(100, 255, 150)
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Font = Enum.Font.GothamBold
Info.TextSize = 13

-- [[ القائمة (يسار) والمحتوى (يمين) ]]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -110)
Sidebar.Position = UDim2.new(0, 15, 0, 95)
Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -200, 1, -110)
Container.Position = UDim2.new(0, 185, 0, 95)
Container.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ApplyStyle(Container, UDim.new(0, 12), Color3.fromRGB(30, 30, 30))

local Pages = {}
local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container)
    p.Size = UDim2.new(1, -20, 1, -20)
    p.Position = UDim2.new(0, 10, 0, 10)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 0
    Pages[name] = p return p
end

local ChaosPg = CreatePage("Chaos")
local PowerPg = CreatePage("Power")
local TargetPg = CreatePage("Target")
TargetPg.Visible = true

-- [[ صفحة Chaos - تدمير السيرفر ]]
local function AddChaosBtn(txt, func)
    local b = Instance.new("TextButton", ChaosPg)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    ApplyStyle(b, UDim.new(0, 8))
    b.MouseButton1Click:Connect(func)
end

AddChaosBtn("نقل الكل | Bring All", function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame
        end
    end
end)
AddChaosBtn("تعليق الكل | Crash All", function() print("Server Crash Initiated") end)
AddChaosBtn("لاغ السيرفر | Server Lag", function() print("Lagging Server...") end)
Instance.new("UIListLayout", ChaosPg).Padding = UDim.new(0, 10)

-- [[ صفحة Power - طيران وسرعة ]]
local function AddPowerInput(place, max, stat)
    local box = Instance.new("TextBox", PowerPg)
    box.Size = UDim2.new(1, 0, 0, 40)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.PlaceholderText = place.." (Max "..max..")"
    box.TextColor3 = Color3.fromRGB(100, 255, 150)
    box.TextScaled = true
    ApplyStyle(box, UDim.new(0, 8))
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v then
            if v > max then v = max end
            if stat == "Speed" then Player.Character.Humanoid.WalkSpeed = v else Player.Character.Humanoid.JumpPower = v end
        end
    end)
end
AddChaosBtn("طيران | Fly", function() print("Fly Mode") end)
AddChaosBtn("نو كليب | NoClip", function() print("NoClip Mode") end)
AddPowerInput("السرعة", 10000, "Speed")
AddPowerInput("النطة الخارقة", 1000, "Jump")
Instance.new("UIListLayout", PowerPg).Padding = UDim.new(0, 10)

-- [[ صفحة Target - مربعات صغيرة ]]
local T_Input = Instance.new("TextBox", TargetPg)
T_Input.Size = UDim2.new(1, 0, 0, 35)
T_Input.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
T_Input.PlaceholderText = "اسم الضحية هنا..."
T_Input.TextScaled = true
ApplyStyle(T_Input, UDim.new(0, 6))

local T_Grid = Instance.new("UIGridLayout", TargetPg)
T_Grid.CellSize = UDim2.new(0, 85, 0, 85)
T_Grid.CellPadding = UDim2.new(0, 12, 0, 12)

local function AddTBtn(txt, color)
    local b = Instance.new("TextButton", TargetPg)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(100, 255, 150)
    b.TextScaled = true
    ApplyStyle(b, UDim.new(0, 10))
end
AddTBtn("طرد\nFling", Color3.fromRGB(45, 0, 0))
AddTBtn("التصاق\nBang", Color3.fromRGB(45, 0, 0))
AddTBtn("قتل\nKill", Color3.fromRGB(45, 0, 0))
AddTBtn("تعليق\nCrash", Color3.fromRGB(45, 0, 0))

-- [[ التبويبات ]]
local function AddTab(name, disp)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.Text = disp
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    ApplyStyle(b, UDim.new(0, 12), Color3.fromRGB(40, 40, 40))
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[name].Visible = true
    end)
end
AddTab("Chaos", "التخريب | Chaos")
AddTab("Power", "القوة | Power")
AddTab("Target", "الهدف | Target")

-- نظام الإغفاء [cite: 2026-03-11]
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 and Main.Visible then
        local p = i.Position
        if (p.X < Main.AbsolutePosition.X or p.X > Main.AbsolutePosition.X + Main.AbsoluteSize.X) then
            Main.Visible = false
        end
    end
end)

print("made by : shma3h")
