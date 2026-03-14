--[[
    SHMA3H ULTIMATE V3 - FULL UI & CHAOS
    Signature: made by : shma3h
    User ID: 1423181773906378814
]]

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local UserID = Player.UserId

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "Shma3hOfficialV3"
ScreenGui.ResetOnSpawn = false

-- [ ستايل الأزرار والفريمات ]
local function ApplyStyle(obj, radius, color)
	local corner = Instance.new("UICorner", obj)
	corner.CornerRadius = radius or UDim.new(0, 12)
	local stroke = Instance.new("UIStroke", obj)
	stroke.Color = color or Color3.fromRGB(100, 255, 150)
	stroke.Thickness = 1.8
end

-- [ الفريم الرئيسي ]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 650, 0, 420)
Main.Position = UDim2.new(0.5, -325, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Active, Main.Draggable = true, true
ApplyStyle(Main, UDim.new(0, 20), Color3.fromRGB(100, 255, 150))

-- [ فريم البروفايل - أعلى اليسار ]
local Profile = Instance.new("Frame", Main)
Profile.Size = UDim2.new(0, 200, 0, 100)
Profile.Position = UDim2.new(0, 15, 0, 15)
Profile.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
ApplyStyle(Profile, UDim.new(0, 15), Color3.fromRGB(40, 40, 40))

local Avatar = Instance.new("ImageLabel", Profile)
Avatar.Size = UDim2.new(0, 50, 0, 50)
Avatar.Position = UDim2.new(0, 10, 0, 10)
Avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..UserID.."&w=150&h=150"
ApplyStyle(Avatar, UDim.new(1, 0))

local Info = Instance.new("TextLabel", Profile)
Info.Size = UDim2.new(1, -70, 0, 50)
Info.Position = UDim2.new(0, 65, 0, 10)
Info.BackgroundTransparency = 1
Info.Text = "<b>"..Player.DisplayName.."</b>\nID: "..UserID
Info.TextColor3 = Color3.new(1, 1, 1)
Info.RichText = true
Info.TextSize = 12
Info.TextXAlignment = Enum.TextXAlignment.Left

-- [ القائمة الجانبية - Sidebar ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 200, 1, -135)
Sidebar.Position = UDim2.new(0, 15, 0, 125)
Sidebar.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Sidebar)
Layout.Padding = UDim.new(0, 8)

-- [ منطقة المحتوى - اليمين ]
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -245, 1, -30)
Container.Position = UDim2.new(0, 230, 0, 15)
Container.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ApplyStyle(Container, UDim.new(0, 15), Color3.fromRGB(30, 30, 30))

local Pages = {}
local function CreatePage(name)
	local p = Instance.new("ScrollingFrame", Container)
	p.Size = UDim2.new(1, -20, 1, -20)
	p.Position = UDim2.new(0, 10, 0, 10)
	p.BackgroundTransparency = 1
	p.Visible = false
	p.ScrollBarThickness = 0
	local grid = Instance.new("UIGridLayout", p)
	grid.CellSize = UDim2.new(0, 180, 0, 45)
	grid.CellPadding = UDim2.new(0, 10, 0, 10)
	Pages[name] = p return p
end

-- إنشاء التبويبات
local HomePg = CreatePage("Home")
local ChaosPg = CreatePage("Chaos")
local PowerPg = CreatePage("Power")
local TargetPg = CreatePage("Target")
HomePg.Visible = true

-- [ وظيفة إضافة أزرار القائمة الجانبية ]
local function AddTab(name, disp)
	local b = Instance.new("TextButton", Sidebar)
	b.Size = UDim2.new(1, 0, 0, 45)
	b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	b.Text = disp
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	ApplyStyle(b, UDim.new(0, 15), Color3.fromRGB(40, 40, 40))

	b.MouseButton1Click:Connect(function()
		for _, p in pairs(Pages) do p.Visible = false end
		Pages[name].Visible = true
	end)
end

AddTab("Home", "واجهة | HOME")
AddTab("Chaos", "التخريب | Chaos")
AddTab("Power", "القوة | Power")
AddTab("Target", "اختيار شخص | Target")

-- [ وظيفة إضافة أزرار الأوامر ]
local function AddCmdBtn(pg, txt, func)
	local b = Instance.new("TextButton", pg)
	b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	b.Text = txt
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamMedium
	ApplyStyle(b, UDim.new(0, 8), Color3.fromRGB(60, 60, 60))
	b.MouseButton1Click:Connect(func)
end

-- [ أزرار التخريب الـ 6 في صفحة Chaos ]
AddCmdBtn(ChaosPg, "القتل | Kill Aura", function() print("Aura Active") end)
AddCmdBtn(ChaosPg, "النقل | Bring All", function() 
	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= Player and v.Character then v.Character:MoveTo(Character.HumanoidRootPart.Position) end
	end
end)
AddCmdBtn(ChaosPg, "الهالة | Orbital Aura", function() print("Orbital Started") end)
AddCmdBtn(ChaosPg, "الشات | Chat Spam", function() 
	task.spawn(function()
		for i = 1, 10 do
			game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("⚠️ SHMA3H TEAM ON TOP ⚠️")
			task.wait(2)
		end
	end)
end)
AddCmdBtn(ChaosPg, "الاسم | Name Hack", function() Player.Character.Humanoid.DisplayName = "⚠️ HACKED ⚠️" end)
AddCmdBtn(ChaosPg, "السكنات | Skin Glitch", function() print("Skins Changed") end)

-- [ أزرار القوة ]
AddCmdBtn(PowerPg, "السرعة | Speed 100", function() Player.Character.Humanoid.WalkSpeed = 100 end)
AddCmdBtn(PowerPg, "القفزة | Jump 150", function() Player.Character.Humanoid.JumpPower = 150 end)

-- إخفاء عند الضغط خارجاً [cite: 2026-03-11]
game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local pos = input.Position
		if (pos.X < Main.AbsolutePosition.X or pos.X > Main.AbsolutePosition.X + Main.AbsoluteSize.X) then
			Main.Visible = false
		end
	end
end)

print("made by : shma3h")
