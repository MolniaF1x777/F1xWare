local LoadStart = tick()
F1xWare.SavePath = "Doors/Lobby"

local Library = F1xWare.Interface.Library
local SaveManager = F1xWare.Interface.SaveManager
local ThemeManager = F1xWare.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

local function CloneReference(Object)
    if F1xWare and F1xWare.Environment.cloneref then
        return F1xWare.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

local Groupboxes = {}
local Globals = {}
local Connections = {}
local Functions = {}

local Languages = {
    ["English"] = {
        TabName = "General",
        BoxSelf = "Self",
        BoxAuto = "Automation",
        BoxQuick = "Quick Play",
        ToggleElevator = "Auto Join Elevator",
        ToggleElevatorDesc = "Automatically joins the selected player's elevator.",
        DropdownTarget = "Target",
        ToggleCycle = "Cycle Achievements",
        ToggleCycleDesc = "Rapidly equips a random badge.",
        SliderDelay = "Cycle Delay",
        ButtonRedeem = "Redeem All Codes",
        BtnHotel = "The Hotel",
        BtnMines = "The Mines",
        BtnBackdoor = "The Backdoor",
        BtnRooms = "The Rooms",
        BtnGarden = "The Outdoors",
        BtnParty = "Battle Mode",
        BtnRetro = "Retro Mode",
        BtnRush = "Rush Mode",
        BtnHallow = "Halloween",
        BtnOldHotel = "Hotel-",
        BtnSuperHard = "Super Hard Mode",
        BtnRoomsFree = "The Rooms [Free]",
        BtnGardenFree = "The Outdoors [Free]",
        NotifyRedeem = "Redeeming %d codes...",
        NotifyLoaded = "Successfully loaded in %s seconds.",
        NotifyPress = "Press '%s' to toggle the UI."
    },
    ["Русский"] = {
        TabName = "Главное",
        BoxSelf = "Игрок",
        BoxAuto = "Автоматизация",
        BoxQuick = "Быстрый старт",
        ToggleElevator = "Авто-вход в лифт",
        ToggleElevatorDesc = "Автоматически заходит в лифт выбранного игрока.",
        DropdownTarget = "Цель",
        ToggleCycle = "Крутить достижения",
        ToggleCycleDesc = "Быстро меняет значки достижений.",
        SliderDelay = "Задержка",
        ButtonRedeem = "Активировать все коды",
        BtnHotel = "Отель",
        BtnMines = "Шахты",
        BtnBackdoor = "Задверье",
        BtnRooms = "The Rooms",
        BtnGarden = "Улица (Garden)",
        BtnParty = "Битва (Party)",
        BtnRetro = "Ретро",
        BtnRush = "Rush Mode",
        BtnHallow = "Хэллоуин",
        BtnOldHotel = "Отель- (Старый)",
        BtnSuperHard = "Super Hard Mode",
        BtnRoomsFree = "The Rooms [Без прогресса]",
        BtnGardenFree = "The Outdoors [Без прогресса]",
        NotifyRedeem = "Активация %d кодов...",
        NotifyLoaded = "Успешно загружено за %s секунд.",
        NotifyPress = "Нажми '%s' чтобы скрыть меню."
    }
}
local CurrentLang = Languages["English"]

local LocalPlayer = Services.Players.LocalPlayer
local RemotesFolder = Services.ReplicatedStorage:WaitForChild("RemotesFolder")

while not LocalPlayer.Character do
    task.wait()
end
task.wait(1)

local Window = Library:CreateWindow({
    Title = "F1xWare",
    Footer = "F1xWare A.C  |  by MolniaF1x",
    NotifySide = "Right",
    ShowCustomCursor = false,
    AutoShow = true,
    Center = true,
	TabPadding = 4,
	MenuFadeTime = 0.15,
    CornerRadius = 6,
})

F1xWare.Interface.ApplyInfoTab(Window)
local Tabs = {
    General = Window:AddTab(CurrentLang.TabName, "house"),
}

Functions.CheckCompatability = function(Array)
    local Valid = true
    for Index, Name in pairs(Array) do
        if not F1xWare.Environment[Name] then
            Valid = false
        end
    end
    return Valid
end

local function GetHiddenContainer()
	if Functions.CheckCompatability({"gethui"}) then
		return F1xWare.Environment.gethui()
	else
		return Services.CoreGui
	end
end

local NotificationLibrary = {
	LiveNotifications = 0,
    Notifications = 1
}

local Container = Instance.new("ScreenGui")
Container.Name = F1xWare.ESPLibrary:GenerateRandomString()
Container.Parent = GetHiddenContainer()
Container.DisplayOrder = 32767
Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not Library.Scheme then
    Library.Scheme = setmetatable({}, {
        __index = function(self, Name)
            return Library[Name]
        end
    })
end

function NotificationLibrary:Notify(TitleText, Desc, Delay)
	task.spawn(function()
		local Notification = Instance.new("Frame")
		local Line = Instance.new("Frame")
		local Warning = Instance.new("ImageLabel")
		local UICorner = Instance.new("UICorner")
        local UICorner2 = Instance.new("UICorner")
		local Title = Instance.new("TextLabel")
		local Description = Instance.new("TextLabel")

		Notification.Name = "Notification"
		Notification.Parent = Container
		Notification.BackgroundColor3 = Library.Scheme.BackgroundColor
		Notification.BackgroundTransparency = 0.4
		Notification.BorderSizePixel = 0
		Notification.Position = UDim2.new(1, 5, 0, 60 + (60 * NotificationLibrary.LiveNotifications))
		Notification.Size = UDim2.new(0, 420, 0, 50)
        Notification:SetAttribute("ID", NotificationLibrary.Notifications)
        Notification:SetAttribute("CurrentPosition", Notification.Position)

		Line.Name = "Line"
		Line.Parent = Notification
		Line.BackgroundColor3 = Library.Scheme.AccentColor
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 0, 1, -3)
		Line.Size = UDim2.new(0, 0, 0, 3)

		Warning.Name = "Warning"
		Warning.Parent = Notification
		Warning.BackgroundTransparency = 1
		Warning.Position = UDim2.new(0, 10, 0, 5)
		Warning.Size = UDim2.new(0, 40, 0, 40)
		Warning.Image = "rbxassetid://3944668821"
		Warning.ImageColor3 = Library.Scheme.AccentColor
		Warning.ScaleType = Enum.ScaleType.Fit

		UICorner.CornerRadius = UDim.new(0, 20)
		UICorner.Parent = Warning

        UICorner2.CornerRadius = UDim.new(0, 4)
        UICorner2.Parent = Notification

		Title.Name = "Title"
		Title.Parent = Notification
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1.000
		Title.Position = UDim2.new(0, 60, 0.155, 0)
		Title.Size = UDim2.new(0, 205, 0, 15)
		Title.Text = TitleText or "..."
		Title.TextColor3 = Library.Scheme.FontColor
		Title.TextSize = 10
		Title.TextStrokeTransparency = 0.75
		Title.TextXAlignment = Enum.TextXAlignment.Left

		Description.Name = "Description"
		Description.Parent = Notification
		Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Description.BackgroundTransparency = 1.000
		Description.Position = UDim2.new(0, 60, 0.483, 0)
		Description.Size = UDim2.new(0, 205, 0, 18)
		Description.Text = Desc or "..."
		Description.TextColor3 = Library.Scheme.FontColor
        Description.TextTransparency = 0.1
		Description.TextSize = 10
		Description.TextStrokeTransparency = 0.75
		Description.TextXAlignment = Enum.TextXAlignment.Left
		
		NotificationLibrary.LiveNotifications = NotificationLibrary.LiveNotifications + 1
        NotificationLibrary.Notifications = NotificationLibrary.Notifications + 1
		Services.TweenService:Create(Notification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, -370, 0, Notification.Position.Y.Offset)}):Play()

		task.wait(0.25)
		Services.TweenService:Create(Line, TweenInfo.new(Delay - 0.25, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 400, 0, 3)}):Play()
		task.wait(Delay - 0.25)

        Notification:SetAttribute("Destroying", true)
		Services.TweenService:Create(Notification, TweenInfo.new(0.75, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(1, 5, 0, Notification.Position.Y.Offset)}):Play()
		NotificationLibrary.LiveNotifications = NotificationLibrary.LiveNotifications - 1
        
        for Index, Object in pairs(Container:GetChildren()) do
            if Object.Name == "Notification" and Object:GetAttribute("ID") and Object:GetAttribute("ID") > Notification:GetAttribute("ID") and Object:GetAttribute("Destroying") ~= true and Object.Position.Y.Offset ~= 60 then
                Object:SetAttribute("CurrentPosition", UDim2.new(1, -450, 0, Object:GetAttribute("CurrentPosition").Y.Offset - 60))
                Services.TweenService:Create(Object, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Position = UDim2.new(1, -370, 0, Object:GetAttribute("CurrentPosition").Y.Offset)}):Play()
            end
        end
        task.wait(0.75)
		Notification:Destroy()
	end)
end

Functions.Notify = function(Settings)
    local Container
    if Functions.CheckCompatability({"gethui"}) then
        Container = F1xWare.Environment.gethui()
    else
        Container = Services.CoreGui
    end

    local Sound = Instance.new("Sound", Container)
    Sound.SoundId = "rbxassetid://8784885431"
    Sound.Volume = 3
    Sound.PlayOnRemove = true
    Sound:Destroy()

    NotificationLibrary:Notify(Settings.Title, Settings.Body, Settings.Time or 5)
end

Library.Notify = function(Data, Body, Time)
    Functions.Notify({Title = Body, Time = Time or 5})
end

Functions.CheckElevators = function()
    local TargetFound = false
	if not Toggles.AutoJoinElevator.Value then
		return
	end
	local TargetCharacter
	if typeof(Options.AutoJoinElevatorTarget.Value) == "Instance" then
		TargetCharacter = Options.AutoJoinElevatorTarget.Value.Character
	elseif typeof(Options.AutoJoinElevatorTarget.Value) == "string" then
		TargetCharacter = Services.Players:FindFirstChild(Options.AutoJoinElevatorTarget.Value).Character
	end

	for Index, Elevator in pairs(Services.Workspace.Lobby.LobbyElevators:GetChildren()) do
		if TargetCharacter and Elevator and TargetCharacter:GetAttribute("InGameElevator") and Elevator:GetAttribute("ID") and Elevator:GetAttribute("ID") == TargetCharacter:GetAttribute("InGameElevator") then
			TargetFound = true
			RemotesFolder.ElevatorJoin:FireServer(Elevator)
        end
    end
	if TargetFound == false then
		RemotesFolder.ElevatorExit:FireServer()
	end
end

Globals.RedeemingCodes = false
Globals.CodesList = {
    "67", "54", "41", "CHEDDAR BALLS", "XQC", "PENGUINZ0", "KREEKCRAFT", "ISHOWSPEED",
	"DANTDM", "KUBZ SCOUTS", "FIND THE TROLLFACES", "THINKNOODLES", "W", "RAGDOLL UNIVERSE",
	"RAGDOLL MAYHEM", "BIJUU MIKE", "8BITRYAN", "SCREECHSUCKS", "LORE",
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ", "FIND THE TROLLFACES", "3rd", "LAZYDEVS",
	"RAGDOLL COMBAT", "VOCAB HAVOC", "PATHSWAP", "JUMP OVER THE BRICK"
}
Globals.UnlockedBadges = {}

Groupboxes.General_Self = Tabs.General:AddLeftGroupbox(CurrentLang.BoxSelf)

Groupboxes.General_Self:AddToggle("AutoJoinElevator", {
    Text = CurrentLang.ToggleElevator,
    Default = false,
    Tooltip = CurrentLang.ToggleElevatorDesc
})

Groupboxes.General_Self:AddDropdown("AutoJoinElevatorTarget", {
    Text = CurrentLang.DropdownTarget,
    SpecialType = "Player",
    ExcludeLocalPlayer = true,
    Searchable = true
})

Groupboxes.General_Automation = Tabs.General:AddLeftGroupbox(CurrentLang.BoxAuto)

Groupboxes.General_Automation:AddToggle("CycleAchievements", {
    Text = CurrentLang.ToggleCycle,
    Default = false,
    Tooltip = CurrentLang.ToggleCycleDesc
})

Groupboxes.General_Automation:AddSlider("CycleAchievementsDelay", {
    Text = CurrentLang.SliderDelay,
    Min = 0,
    Max = 1,
    Default = 0.1,
    Rounding = 2,
    Compact = true
})

Groupboxes.General_Automation:AddDivider()

Groupboxes.General_Automation:AddButton(CurrentLang.ButtonRedeem, function()
    if Globals.RedeemingCodes then return end
    Functions.Notify({Title = string.format(CurrentLang.NotifyRedeem, #Globals.CodesList), Body = "..."})
    Globals.RedeemingCodes = true
    for Index, Code in pairs(Globals.CodesList) do
        RemotesFolder.ShopCode:FireServer(Code)
        task.wait(5.1)
    end
end)

for Index, Frame in pairs(LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
	if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
		table.insert(Globals.UnlockedBadges, Frame.Name)
	end
end

Connections.BadgeAddedConnection = LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List.ChildAdded:Connect(function(Frame)
	Services.RunService.Heartbeat:Wait()
	if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
		table.insert(Globals.UnlockedBadges, Frame.Name)
	end
end)

Globals.LastBadgeChange = tick()
Globals.LastElevatorCheck = tick()
Connections.MainConnection = Services.RunService.Heartbeat:Connect(function()
	if tick() - Globals.LastElevatorCheck > 0.25 then
    	Functions.CheckElevators()
		Globals.LastElevatorCheck = tick()
	end

    if Toggles.CycleAchievements.Value and tick() - Globals.LastBadgeChange > Options.CycleAchievementsDelay.Value then
        local Badge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
        if Badge == PreviousBadge then
            while task.wait() do
				local NewBadge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
				if NewBadge ~= PreviousBadge then
					Badge = NewBadge
					break
				end
			end
		end
		for Index, Frame in pairs(LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
			if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
				LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Frame.Name).Icons.Star.Visible = false
			end
		end
		RemotesFolder:WaitForChild("FlexAchievement"):FireServer(Badge)
		PreviousBadge = Badge
		LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Badge).Icons.Star.Visible = true

        Globals.LastBadgeChange = tick()
	end
end)

Groupboxes.General_QuickPlay = Tabs.General:AddRightGroupbox(CurrentLang.BoxQuick)

local function FireElevator(dest, mods)
    RemotesFolder.CreateElevator:FireServer({
        Mods = mods or {},
        Settings = {},
        Destination = dest,
        FriendsOnly = false,
        MaxPlayers = "1"
    })
end

Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnHotel, DoubleClick = false, Func = function() FireElevator("Hotel") end })
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnMines, DoubleClick = false, Func = function() FireElevator("Mines") end })
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnBackdoor, DoubleClick = false, Func = function() FireElevator("Backdoor") end })
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnRooms, DoubleClick = false, Func = function() FireElevator("Rooms") end })
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnGarden, DoubleClick = false, Func = function() FireElevator("Garden") end })
Groupboxes.General_QuickPlay:AddDivider()
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnParty, DoubleClick = false, Func = function() FireElevator("Party") end })
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnRetro, DoubleClick = false, Func = function() FireElevator("Retro") end })
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnRush, DoubleClick = false, Func = function() FireElevator("Fools26") end })
Groupboxes.General_QuickPlay:AddDivider()
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnHallow, DoubleClick = false, Func = function() FireElevator("Halloween25") end })
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnOldHotel, DoubleClick = false, Func = function() FireElevator("BeforePlus") end })
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnSuperHard, DoubleClick = false, Func = function() FireElevator("SuperHardMode") end })
Groupboxes.General_QuickPlay:AddDivider()
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnRoomsFree, DoubleClick = false, Func = function() FireElevator("Rooms", {"AdminPanel"}) end })
Groupboxes.General_QuickPlay:AddButton({ Text = CurrentLang.BtnGardenFree, DoubleClick = false, Func = function() FireElevator("Garden", {"AdminPanel"}) end })

Library:OnUnload(function()
    Connections.MainConnection:Disconnect()
	getgenv().F1xWare = nil
end)

F1xWare.Interface.ApplySettingsTab(Window)

local SettingsTab = Library.SettingsTab
if SettingsTab then
    local LangBox = SettingsTab:AddLeftGroupbox("Language / Язык")
    LangBox:AddDropdown("LanguageSelector", {
        Text = "Select Language",
        Values = {"English", "Русский"},
        Default = "English",
        Callback = function(Value)
            CurrentLang = Languages[Value]
            if Window.Root then
                for _, child in pairs(Window.Root:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        if child.Text == "General" then child.Text = CurrentLang.TabName end
                        if child.Text == "Self" then child.Text = CurrentLang.BoxSelf end
                        if child.Text == "Automation" then child.Text = CurrentLang.BoxAuto end
                        if child.Text == "Quick Play" then child.Text = CurrentLang.BoxQuick end
                    end
                end
            end
            Functions.Notify({Title = "Language changed / Язык изменен", Body = Value})
        end
    })
end

Functions.Notify({ Title = string.format(CurrentLang.NotifyLoaded, math.floor((tick() - LoadStart) * 1000) / 1000), Body = string.format(CurrentLang.NotifyPress, tostring(Options.MenuKeybind.Value))})
