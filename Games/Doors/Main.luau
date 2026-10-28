local LoadStart = tick()
F1xWare.SavePath = "Doors/Game"

local Library = F1xWare.Interface.Library
local SaveManager = F1xWare.Interface.SaveManager
local ThemeManager = F1xWare.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

local function CloneReference(Object)
	if F1xWare and F1xWare.Environment.cloneref then
		return F1xWare.Environment.cloneref(Object)
	end
	return Object
end

local Services = setmetatable({}, {
	__index = function(Self, Name)
		return CloneReference(game:GetService(Name))
	end
})

local Globals = {}
local Connections = {}
local ESPConnections = {}
local Groupboxes = {}
local FakePrompts = {}
local Functions = {}
local PartProperties = {}

local Objects = {
	Prompts = {},
	Objectives = {},
	Doors = {},
	HidingSpots = {},
	Entities = {},
	SeekObstructions = {},
	Items = {},
	Chests = {},
	Currency = {},
	Ladders = {},
	Obstructions = {},
	EventTriggers = {},
	JumpscareModules = {},
	SeekHighlights = {},
	EyestalkHighlights = {},
	SeekNodes = {},
	SeekDuckBoards = {},
	SeekBridges = {},
	PathLights = {}
}

Globals.IncompatibleMessage = "Your executor doesn't support this feature."

Functions.CheckCompatability = function(Array)
	for _, Name in Array do
		if not F1xWare.Environment[Name] then
			return false
		end
	end
	return true
end

local Entities = {
	["RushMoving"] = { Alias = "Rush", NotifyMessage = { Title = "Entity 'Rush' has spawned.", Body = "Find a hiding spot." } },
	["AmbushMoving"] = { Alias = "Ambush", NotifyMessage = { Title = "Entity 'Ambush' has spawned.", Body = "Find a hiding spot." } },
	["Eyes"] = { Alias = "Eyes", NotifyMessage = { Title = "Entity 'Eyes' has spawned.", Body = "Avoid looking at it." } },
	["Lookman"] = { Alias = "Eyes", NotifyMessage = { Title = "Entity 'Eyes' has spawned.", Body = "Avoid looking at it." } },
	["BackdoorRush"] = { Alias = "Blitz", NotifyMessage = { Title = "Entity 'Blitz' has spawned.", Body = "Find a hiding spot." } },
	["BackdoorLookman"] = { Alias = "Lookman", NotifyMessage = { Title = "Entity 'Lookman' has spawned.", Body = "Avoid looking at its eyes." } },
	["Groundskeeper"] = { Alias = "Groundskeeper", NotifyMessage = { Title = "Entity 'Groundskeeper' has spawned.", Body = "Avoid stepping on the grass." } },
	["A60"] = { Alias = "A-60", NotifyMessage = { Title = "Entity 'A-60' has spawned.", Body = "Find a hiding spot." } },
	["A120"] = { Alias = "A-120", NotifyMessage = { Title = "Entity 'A-120' has spawned.", Body = "Find a hiding spot." } },
	["GloombatSwarm"] = { Alias = "Gloombat Swarm", NotifyMessage = { Title = "Entity 'Gloombat Swarm' has spawned.", Body = "Keep all light sources turned off." } },
	["GlitchRush"] = { Alias = "RNIUSHCG==", NotifyMessage = { Title = "Entity 'RNIUSHCG==' has spawned.", Body = "Find a hiding spot." } },
	["GlitchAmbush"] = { Alias = "AR0xMBUSH", NotifyMessage = { Title = "Entity 'AR0xMBUSH' has spawned.", Body = "Find a hiding spot." } },
	["MonumentEntity"] = { Alias = "Monument", NotifyMessage = { Title = "Entity 'Monument' has spawned.", Body = "It can't move while you are looking at it." } },
	["JeffTheKiller"] = { Alias = "Jeff the Killer", NotifyMessage = { Title = "Entity 'Jeff the Killer' has spawned.", Body = "Avoid touching him." } },
	["CustomEntity"] = { Alias = "Custom Entity", NotifyMessage = { Title = "Entity 'Custom Entity' has spawned.", Body = "Find a hiding spot." } },
	["FrozenAmbush"] = { Alias = "Frozen Ambush", NotifyMessage = { Title = "Entity 'Frozen Ambush' has spawned.", Body = "Find a hiding spot." } },
	["SallyMoving"] = { Alias = "Sally", NotifyMessage = { Title = "Entity 'Sally' has spawned.", Body = "Drop an item for her." } }
}

local EntityIcons = {
	["RushMoving"] = "rbxassetid://10716032262", ["AmbushMoving"] = "rbxassetid://10110576663", ["A60"] = "rbxassetid://12571092295", ["A120"] = "rbxassetid://12711591665", ["BackdoorRush"] = "rbxassetid://16602023490", ["Eyes"] = "rbxassetid://10183704772", ["Lookman"] = "rbxassetid://10183704772", ["BackdoorLookman"] = "rbxassetid://16764872677", ["GloombatSwarm"] = "rbxassetid://79221203116470", ["Halt"] = "rbxassetid://11331795398", ["JeffTheKiller"] = "rbxassetid://94479432156278", ["GlitchRush"] = "rbxassetid://73859273102919", ["GlitchAmbush"] = "rbxassetid://88369678433359", ["SallyMoving"] = "rbxassetid://10840888070", ["MonumentEntity"] = "rbxassetid://88933556873017", ["Groundskeeper"] = "rbxassetid://114991380115557"
}

local ItemNames = {
	["Lighter"] = "Lighter", ["Flashlight"] = "Flashlight", ["Lockpick"] = "Lockpicks", ["Vitamins"] = "Vitamins", ["Bandage"] = "Bandage", ["StarVial"] = "Starlight Vial", ["StarBottle"] = "Starlight Bottle", ["StarJug"] = "Starlight Barrel", ["Shakelight"] = "Gummy Flashlight", ["Straplight"] = "Straplight", ["Bulklight"] = "Spotlight", ["Battery"] = "Battery", ["Candle"] = "Candle", ["Crucifix"] = "Crucifix", ["CrucifixWall"] = "Crucifix", ["Glowsticks"] = "Glowstick", ["SkeletonKey"] = "Skeleton Key", ["Candy"] = "Candy", ["ShieldMini"] = "Mini Shield Potion", ["ShieldBig"] = "Big Shield Potion", ["BandagePack"] = "Bandage Pack", ["BatteryPack"] = "Battery Pack", ["RiftCandle"] = "Moonlight Candle", ["LaserPointer"] = "Laser Pointer", ["HolyGrenade"] = "Holy Hand Grenade", ["Shears"] = "Shears", ["Smoothie"] = "Smoothie", ["Cheese"] = "Cheese", ["Bread"] = "Bread", ["AlarmClock"] = "Alarm Clock", ["RiftSmoothie"] = "Moonlight Smoothie", ["GweenSoda"] = "Gween Soda", ["GlitchCube"] = "Glitch Fragment", ["Scanner"] = "Tablet", ["Bomb"] = "Bomb", ["Knockbomb"] = "Knockbomb", ["Nanner"] = "Nanner", ["BigBomb"] = "Big Bomb", ["SnakeBox"] = "Hiding Box", ["GoldGun"] = "Golden Gun", ["StopSign"] = "Stop Sign", ["TipJar"] = "Tip Jar", ["Lantern"] = "Lantern", ["IronKey"] = "Iron Key", ["LotusPetal"] = "Lotus Petal", ["Compass"] = "Compass", ["LotusPetalPickup"] = "Lotus Petal", ["LanternLitItem"] = "Lantern", ["KeyIron"] = "Iron Key", ["IronKeyForCrypt"] = "Iron Key", ["LotusHolder"] = "Lotus Petal", ["Multitool"] = "Multitool", ["RiftJar"] = "Rift Jar", ["AloeVera"] = "Aloe Vera", ["Donut"] = "Donut", ["Lotus"] = "Lotus", ["BoxingGloves"] = "Boxing Gloves"
}

local CutsceneNames = { "Figure", "FigureEnd", "FigureHotelEnd", "FigureHotelFire", "SeekIntroFools", "SeekIntroHotel", "SeekIntroMines", "SeekIntroMines2", "SerewSeekDrain", "SewerSeekLower", "GrumbleNestEnd", "EyestalkIntro" }

local Languages = {
    ["English"] = {
        TabGeneral = "General", TabExploits = "Exploits", TabVisuals = "Visuals", TabFloors = "Floors",
        BoxChar = "Character", BoxSelf = "Self", BoxAuto = "Automation", BoxMisc = "Miscellaneous",
        BoxBypass = "Bypass", BoxAudio = "Audio", BoxCamera = "Camera", BoxEffects = "Effects",
        BoxESP = "ESP", BoxFloors = "Floors", BoxFarming = "Farming",
        SpeedBoost = "Speed Boost", EnableSpeed = "Enable Speed Boost", Fly = "Fly", Noclip = "Noclip",
        DoorReach = "Door Reach", AutoBreaker = "Auto Breaker Box", AutoInteract = "Auto Interact",
        AutoCloset = "Auto Closet", PlayAgain = "Play Again", Lobby = "Return to Lobby",
        Revive = "Revive", Reset = "Reset Character", BypassEyes = "Bypass Eyes", BypassLookman = "Bypass Lookman",
        RemoveScreech = "Remove Screech", NoScreech = "No Screech Damage", FOV = "Field of View",
        RemoveShake = "Remove Camera Shake", RemoveFog = "Remove Fog", ThirdPerson = "Third Person",
        ObjectiveESP = "Objectives", DoorESP = "Doors", ItemESP = "Items", EntityESP = "Entities",
        AutoMinecart = "Auto Steer Minecart", AutoRooms = "Auto Rooms", KnobFarm = "Knob Farm"
    },
    ["Русский"] = {
        TabGeneral = "Главное", TabExploits = "Читы", TabVisuals = "Визуал", TabFloors = "Этажи",
        BoxChar = "Персонаж", BoxSelf = "Игрок", BoxAuto = "Автоматизация", BoxMisc = "Разное",
        BoxBypass = "Обход", BoxAudio = "Звук", BoxCamera = "Камера", BoxEffects = "Эффекты",
        BoxESP = "ESP", BoxFloors = "Этажи", BoxFarming = "Фарм",
        SpeedBoost = "Скорость", EnableSpeed = "Включить скорость", Fly = "Полёт", Noclip = "Ноклип",
        DoorReach = "Достать до двери", AutoBreaker = "Авто-рубильник", AutoInteract = "Авто-действие",
        AutoCloset = "Авто-шкаф", PlayAgain = "Играть снова", Lobby = "Вернуться в лобби",
        Revive = "Возродиться", Reset = "Убить себя", BypassEyes = "Обход Глаз", BypassLookman = "Обход Лукмена",
        RemoveScreech = "Убрать Скрича", NoScreech = "Без урона от Скрича", FOV = "Угол обзора",
        RemoveShake = "Убрать тряску", RemoveFog = "Убрать туман", ThirdPerson = "Третье лицо",
        ObjectiveESP = "Цели", DoorESP = "Двери", ItemESP = "Предметы", EntityESP = "Сущности",
        AutoMinecart = "Авто-вагонетка", AutoRooms = "Авто The Rooms", KnobFarm = "Фарм ручек"
    }
}
local CurrentLang = Languages["Русский"]

local Character
local Humanoid
local RootPart

local Collision
local CollisionClone
local CollisionPart
local CollisionPartClone

local Camera
local LocalPlayer = Services.Players.LocalPlayer

local RemotesFolder   = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
local LiveModifiers   = Services.ReplicatedStorage:FindFirstChild("LiveModifiers")
local FloorReplicated = Services.ReplicatedStorage:FindFirstChild("FloorReplicated")
local CurrentRooms    = Services.Workspace:FindFirstChild("CurrentRooms")
local Drops           = Services.Workspace:FindFirstChild("Drops")
local GameData        = Services.ReplicatedStorage:WaitForChild("GameData")
local Floor           = GameData:WaitForChild("Floor").Value
local LatestRoom      = GameData:WaitForChild("LatestRoom")
local FinishedLoadingRoom = GameData:FindFirstChild("FinishedLoadingRoom")
if FinishedLoadingRoom then FinishedLoadingRoom:Destroy() end

local function GetHiddenContainer()
	if Functions.CheckCompatability({"gethui"}) then
		return F1xWare.Environment.gethui()
	end
	return Services.CoreGui
end

local NotificationLibrary = { LiveNotifications = 0, Notifications = 1 }
local Container = Instance.new("ScreenGui")
Container.Name = F1xWare.ESPLibrary:GenerateRandomString()
Container.Parent = GetHiddenContainer()
Container.DisplayOrder = 32767
Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not Library.Scheme then
	Library.Scheme = setmetatable({}, { __index = function(Self, Name) return Library[Name] end })
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
		Title.BackgroundTransparency = 1
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
		Description.BackgroundTransparency = 1
		Description.Position = UDim2.new(0, 60, 0.483, 0)
		Description.Size = UDim2.new(0, 205, 0, 18)
		Description.Text = Desc or "..."
		Description.TextColor3 = Library.Scheme.FontColor
		Description.TextTransparency = 0.1
		Description.TextSize = 10
		Description.TextStrokeTransparency = 0.75
		Description.TextXAlignment = Enum.TextXAlignment.Left

		NotificationLibrary.LiveNotifications += 1
		NotificationLibrary.Notifications += 1

		Services.TweenService:Create(Notification, TweenInfo.new(1, Enum.EasingStyle.Exponential), { Position = UDim2.new(1, -370, 0, Notification.Position.Y.Offset) }):Play()
		task.wait(0.25)

		if typeof(Delay) == "Instance" then
			Delay.Destroying:Wait()
		else
			Services.TweenService:Create(Line, TweenInfo.new(Delay - 0.25, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 400, 0, 3) }):Play()
			task.wait(Delay - 0.25)
		end

		Notification:SetAttribute("Destroying", true)
		Services.TweenService:Create(Notification, TweenInfo.new(0.75, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), { Position = UDim2.new(1, 5, 0, Notification.Position.Y.Offset) }):Play()
		NotificationLibrary.LiveNotifications -= 1

		local NotifId = Notification:GetAttribute("ID")
		local NotifY = Notification:GetAttribute("CurrentPosition").Y.Offset

		for _, Object in Container:GetChildren() do
			if Object.Name == "Notification" and Object:GetAttribute("ID") and Object:GetAttribute("ID") > NotifId and Object:GetAttribute("Destroying") ~= true and Object.Position.Y.Offset ~= 60 then
				local NewY = Object:GetAttribute("CurrentPosition").Y.Offset - 60
				Object:SetAttribute("CurrentPosition", UDim2.new(1, -450, 0, NewY))
				Services.TweenService:Create(Object, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), { Position = UDim2.new(1, -370, 0, NewY) }):Play()
			end
		end
		task.wait(0.75)
		Notification:Destroy()
	end)
end

Globals.DoorsNotify = function(NotifyOptions)
	local function PlaySound(Parent, SoundId, Volume)
		local Sound = Instance.new("Sound")
		Sound.SoundId = SoundId
		Sound.Volume = Volume or 1
		Sound.Parent = Parent
		task.spawn(function()
			task.wait(0.1)
			Sound:Play()
			Sound.Ended:Wait()
			Sound:Destroy()
		end)
	end

	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	local UIContainer = PlayerGui:FindFirstChild("GlobalUI") or PlayerGui:FindFirstChild("MainUI")
	if not UIContainer then return end
	local AchievementsHolder = UIContainer:FindFirstChild("AchievementsHolder")
	if not AchievementsHolder then return end

	local Achievement = AchievementsHolder.Achievement:Clone()
	Achievement.Size = UDim2.new(0, 0, 0, 0)
	Achievement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
	Achievement.Name = "LiveAchievement"
	Achievement.Visible = true

	Achievement.Frame.TextLabel.Text = NotifyOptions.Style or "NOTIFICATION"
	Achievement.Frame.Details.Title.Text = NotifyOptions.Title or "Без названия"
	Achievement.Frame.Details.Desc.Text = NotifyOptions.Description or "Без описания"
	Achievement.Frame.Details.Reason.Text = NotifyOptions.Reason or ""
	Achievement.Frame.ImageLabel.Image = (NotifyOptions.Image ~= "" and NotifyOptions.Image) or "rbxassetid://6023426923"

	local Color = NotifyOptions.Color or Color3.new(1, 1, 1)
	Achievement.Frame.TextLabel.TextColor3 = Color
	Achievement.Frame.UIStroke.Color = Color
	Achievement.Frame.Glow.ImageColor3 = Color
	Achievement.Parent = AchievementsHolder

	PlaySound(AchievementsHolder, "rbxassetid://10469938989", 1)

	task.spawn(function()
		Achievement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", 0.8, true)
		task.wait(0.8)
		Achievement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)
		Services.TweenService:Create(Achievement.Frame.Glow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { ImageTransparency = 1 }):Play()

		if typeof(NotifyOptions.Time) == "Instance" then
			NotifyOptions.Time.Destroying:Wait()
		else
			task.wait(NotifyOptions.Time or 5)
		end

		Achievement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:TweenSize(UDim2.new(1, 0, -0.1, 0), "InOut", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:Destroy()
	end)
end

Globals.STX = loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Components/STX.luau"))()
Functions.Notify = function(Settings)
	local HiddenContainer = GetHiddenContainer()
	if not Settings.Body then Settings.Body = "..." end

	if not Options.NotifyStyle or Options.NotifyStyle.Value == "F1xWare" then
		local Sound = Instance.new("Sound", HiddenContainer)
		Sound.SoundId = "rbxassetid://8784885431"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()
		NotificationLibrary:Notify(Settings.Title, Settings.Body, Settings.Time or 5)
	elseif Options.NotifyStyle.Value == "Doors" then
		local IsEntity = false
		for Index, Object in pairs(Entities) do
			if Object.NotifyMessage.Title == Settings.Title or Object.NotifyMessage.Body == Settings.Body then
				IsEntity = true
			end
		end
		Globals.DoorsNotify({ Title = "F1xWare", Description = Settings.Title, Reason = Settings.Body, Style = IsEntity and "WARNING" or "NOTIFICATION", Color = IsEntity and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 222, 189), Image = Settings.Image, Time = Settings.Time })
	elseif Options.NotifyStyle.Value == "STX" then
		local Sound = Instance.new("Sound", HiddenContainer)
		Sound.SoundId = "rbxassetid://4590657391"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()

		if Settings.Image then
			Globals.STX:Notify({Title = "F1xWare", Description = Settings.Title .. "\n" .. Settings.Body}, {OutlineColor = Library.Scheme.AccentColor,Time = Settings.Time or 5, Type = "image"}, {Image = Settings.Image, ImageColor = Color3.fromRGB(255, 255, 255)})
		else
			Globals.STX:Notify({Title = "F1xWare", Description = Settings.Title .. "\n" .. Settings.Body}, {OutlineColor = Library.Scheme.AccentColor,Time = Settings.Time or 5, Type = "default"})
		end
	else
		local Sound = Instance.new("Sound", HiddenContainer)
		Sound.SoundId = "rbxassetid://4590662766"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()
		Library:OldNotify({ Title = Settings.Title, Description = Settings.Body, Time = Settings.Time })
	end
end

Functions.Caption = function(Text, PlaySound)
	if typeof(PlaySound) ~= "boolean" then PlaySound = true end
	local CaptionValue = Instance.new("NumberValue")
	local Caption = Globals.MainUI:WaitForChild("MainFrame"):WaitForChild("Caption"):Clone()
	local CaptionSound = Globals.MainUI:WaitForChild("Initiator"):WaitForChild("Main_Game"):WaitForChild("Reminder"):WaitForChild("Caption")
	local CaptionSoundClone = CaptionSound:Clone()
	CaptionSoundClone.Parent = CaptionSound.Parent
	CaptionSoundClone.Volume = 0.1

	Caption.Destroying:Connect(function() CaptionValue:Destroy() end)
	for _, Child in Globals.MainUI:GetChildren() do
		if Child.Name == "LiveCaption" then Child:Destroy() end
	end

	Caption.Parent = Globals.MainUI
	Caption.Visible = true
	Caption.Name = "LiveCaption"
	Caption.Text = Text
	if PlaySound then CaptionSoundClone:Play() end
	Services.Debris:AddItem(CaptionSoundClone, 5)

	local HolderTween = Services.TweenService:Create(CaptionValue, TweenInfo.new(3), { Value = 100 })
	HolderTween:Play()
	HolderTween.Completed:Connect(function()
		CaptionValue:Destroy()
		Services.TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), { TextTransparency = 1 }):Play()
		Services.TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), { TextStrokeTransparency = 1 }):Play()
	end)
end

Functions.GetHasteTime = function()
	local TimeRemaining = FloorReplicated.DigitalTimer.Value
	local Minutes = math.floor(TimeRemaining / 60)
	local Seconds = TimeRemaining - (Minutes * 60)
	local MinutesText = Minutes < 10 and ("0" .. tostring(Minutes)) or tostring(Minutes)
	local SecondsText = Seconds < 10 and ("0" .. tostring(Seconds)) or tostring(Seconds)
	return MinutesText .. ":" .. SecondsText
end

Library.OldNotify = Library.Notify
Library.Notify = function(Data, Body, Time) Functions.Notify({ Title = Body, Time = Time or 5 }) end

if not LocalPlayer.Character or not CurrentRooms:FindFirstChildOfClass("Model") then
	Functions.Notify({ Title = "Ожидание загрузки игры..." })
	while not LocalPlayer.Character or not CurrentRooms:FindFirstChildOfClass("Model") do task.wait() end
	task.wait(4)
end

if not RemotesFolder then
	if Services.ReplicatedStorage:FindFirstChild("EntityInfo") then RemotesFolder = Services.ReplicatedStorage:FindFirstChild("EntityInfo")
	elseif Services.ReplicatedStorage:FindFirstChild("Bricks") then RemotesFolder = Services.ReplicatedStorage:FindFirstChild("Bricks") end
end

if Floor == "Hotel" and RemotesFolder.Name == "Bricks" then Floor = "OldHotel" end
if not LiveModifiers then LiveModifiers = Instance.new("Folder") end
if not FloorReplicated then FloorReplicated = Instance.new("Folder") end

local FakeEvents = {
	Screech = Instance.new("RemoteEvent"), Shade = Instance.new("RemoteEvent"), A90 = Instance.new("RemoteEvent"), Surge = Instance.new("RemoteEvent")
}
FakeEvents.Screech.Name  = "Screech"
FakeEvents.Shade.Name    = "ShadeResult"
FakeEvents.A90.Name      = "A90"
FakeEvents.Surge.Name    = "SurgeRemote"

FakeEvents.Screech_Real = RemotesFolder:WaitForChild("Screech")
FakeEvents.Shade_Real   = RemotesFolder:WaitForChild("ShadeResult")
FakeEvents.A90_Real     = RemotesFolder:FindFirstChild("A90")
FakeEvents.Surge_Real   = RemotesFolder:FindFirstChild("SurgeRemote")

if RemotesFolder:FindFirstChild("FootstepRemoteThatWeNeed") then
    local RealRemote = RemotesFolder:FindFirstChild("FootstepRemoteThatWeNeed")
    RealRemote:Destroy()
    local FakeRemote = Instance.new("RemoteEvent", RemotesFolder)
    FakeRemote.Name = "FootstepRemoteThatWeNeed"
end

Globals.FogInstances = {}
Globals.OldFog = Services.Lighting.FogEnd

for _, Object in Services.Lighting:GetChildren() do
	if Object:IsA("Atmosphere") then
		Object:SetAttribute("Density_Old", Object.Density)
		local AtmoConnection = Object:GetPropertyChangedSignal("Density"):Connect(function()
			if Object.Density ~= 0 then Object:SetAttribute("Density_Old", Object.Density) end
			if Toggles.RemoveCameraFog.Value then Object.Density = 0 end
		end)
		Object.Destroying:Once(function() AtmoConnection:Disconnect() end)
		table.insert(Connections, AtmoConnection)
		table.insert(Globals.FogInstances, Object)
	end
end

Globals.SeekNodesFolder = Instance.new("Folder", Services.Workspace)
Globals.SeekNodesFolder.Name = F1xWare.ESPLibrary:GenerateRandomString()

Globals.RoomsNodesFolder = Instance.new("Folder", Services.Workspace)
Globals.RoomsNodesFolder.Name = F1xWare.ESPLibrary:GenerateRandomString()

Functions.SendChat = function(Message)
	local Folder = Services.ReplicatedStorage:FindFirstChild("DefaultChatSystemEvents") or Instance.new("Folder")
	local Event = Folder:FindFirstChild("SayMessageRequest") or Instance.new("RemoteEvent")
	Event:FireServer(Message, "All")
	local Channel = (Services.TextChatService:FindFirstChild("TextChannels") and Services.TextChatService.TextChannels:FindFirstChild("RBXGeneral")) or Instance.new("TextChannel")
	Channel:SendAsync(Message)
end

Functions.IsCrouching = function()
	if Floor == "Fools" or Floor == "OldHotel" then return Character:GetAttribute("Crouching") end
	return CollisionPart.CollisionGroup == "PlayerCrouching"
end

Functions.GetInjuriesSpeed = function() return 0.075 * (Humanoid.MaxHealth - Humanoid.Health) end

Functions.GetCurrentSpeed = function()
	local Speed = 15
	Speed += Character:GetAttribute("SpeedBoost") or 0
	Speed += Character:GetAttribute("SpeedBoostBehind") or 0
	Speed += Character:GetAttribute("SpeedBoostExtra") or 0
	Speed += (Floor == "Party" and 10 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFast") and 3 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFaster") and 6 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFastest") and 20 or 0)
	Speed -= (LiveModifiers:FindFirstChild("PlayerSlow") and 3 or 0)
	Speed -= (LiveModifiers:FindFirstChild("PlayerSlowHealth") and Functions.GetInjuriesSpeed() or 0)
	if Functions.IsCrouching() then
		if LiveModifiers:FindFirstChild("PlayerCrouchSlow") then Speed -= 8
		elseif LiveModifiers:FindFirstChild("PlayerSlow") then Speed -= 8
		else Speed -= 5 end
	end
	return Speed
end

Functions.GetMousePosition = function()
	if Library.IsMobile then return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) end
	local MouseLocation = Services.UserInputService:GetMouseLocation()
	return Vector2.new(MouseLocation.X, MouseLocation.Y)
end

Functions.FormatOxygen = function(Oxygen) return "Кислород: " .. (math.floor(Oxygen * 10) / 10) .. "%" end
Functions.IsHidePersistent = function() return Floor == "Mines" or Floor == "Ripple" or Floor == "Party" or LiveModifiers:FindFirstChild("HideLevel2") ~= nil end

Functions.GetPlayerFromMouse = function(TargetPart, MaxDistance)
	local Closest, ClosestDistance = nil, math.huge
	for _, Player in Services.Players:GetPlayers() do
		local Char = Player.Character
		if Char then
			local Target = Char:FindFirstChild(TargetPart)
			if Target then
				local Result = Camera:WorldToViewportPoint(Target.Position)
				local ScreenPos = Vector2.new(Result.X, Result.Y)
				local Distance = (Functions.GetMousePosition() - ScreenPos).Magnitude
				if Player.Name ~= LocalPlayer.Name and Distance < ClosestDistance and Distance < MaxDistance then
					Closest = Target
					ClosestDistance = Distance
				end
			end
		end
	end
	return Closest
end

local EntityDistances = { ["RushMoving"] = 85, ["AmbushMoving"] = 150, ["A60"] = 125, ["A120"] = 85, ["GlitchRush"] = 90, ["GlitchAmbush"] = 175, ["BackdoorRush"] = 85, ["CustomEntity"] = 85 }

Functions.GetNearestEntity = function(CheckDisabled, List, UseRaycasting)
	local Nearest = { Distance = math.huge, Object = nil }
	for _, Entity in Services.Workspace:GetChildren() do
		if Entity and EntityDistances[Entity.Name] and Entity.PrimaryPart then
			local EntityData = Entities[Entity.Name]
			if not (List and List[EntityData.Alias]) then
				local Distance = LocalPlayer:DistanceFromCharacter(Entity.PrimaryPart.Position)
				if Distance < EntityDistances[Entity.Name] and Distance < Nearest.Distance then
					if not CheckDisabled or Entity:GetAttribute("Inactive") ~= true then
						Nearest.Distance = Distance
						Nearest.Object = Entity
					end
				end
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestFigure = function()
	local Nearest = { Distance = math.huge, Object = nil }
	local FigureNames = { FigureRig = true, FigureRagdoll = true, Figure = true }
	for _, Object in Objects.Entities do
		if Object:IsA("Model") and Object.PrimaryPart and FigureNames[Object.Name] then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Nearest.Distance and Distance < 25 then
				Nearest.Distance = Distance
				Nearest.Object = Object
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestHidingSpot = function()
	local Nearest = { Distance = math.huge, Object = nil }
	local LastHideSpot = Character:FindFirstChild("LastHideSpot")
	for _, Object in Objects.HidingSpots do
		if Object.PrimaryPart and Object:FindFirstChild("HidePrompt") then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Object.HidePrompt.MaxActivationDistance and Distance < Nearest.Distance then
				local Persistent = Functions.IsHidePersistent()
				if not Persistent or (LastHideSpot and LastHideSpot.Value ~= Object) or not LastHideSpot then
					Nearest.Distance = Distance
					Nearest.Object = Object
				end
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestTurnNode = function()
	local Nearest = { Distance = math.huge, Object = nil }
	for _, Node in Objects.SeekNodes do
		local Distance = LocalPlayer:DistanceFromCharacter(Node.Position)
		if Distance < Options.AutoSteerMinecartTurnDistance.Value and Distance < Nearest.Distance then
			Nearest.Distance = Distance
			Nearest.Object = Node
		end
	end
	return Nearest.Object
end

Functions.GetNearestDuckBoard = function()
	local Nearest = { Distance = math.huge, Object = nil }
	for _, Board in Objects.SeekDuckBoards do
		if Board.PrimaryPart then
			local Distance = LocalPlayer:DistanceFromCharacter(Board.PrimaryPart.Position)
			if Distance < Options.AutoSteerMinecartDuckDistance.Value and Distance < Nearest.Distance then
				Nearest.Distance = Distance
				Nearest.Object = Board
			end
		end
	end
	return Nearest.Object
end

Functions.GetCurrentAnchor = function()
	local AnchorCode = Globals.MainUI.AnchorHintFrame.AnchorCode.Text
	for _, Anchor in Objects.Objectives do
		if Anchor.Name == "MinesAnchor" and Anchor:FindFirstChild("Sign") then
			if Anchor.Sign.TextLabel.Text == AnchorCode then return Anchor end
		end
	end
end

Functions.GetMinecart = function() return Camera:FindFirstChild("MinecartRig") ~= nil end

Functions.HasItem = function(Name, OnlyCharacter)
	if not OnlyCharacter and LocalPlayer.Backpack:FindFirstChild(Name) then return LocalPlayer.Backpack:FindFirstChild(Name)
	elseif Character:FindFirstChild(Name) then return Character:FindFirstChild(Name) end
end

Functions.GetFlyVelocity = function()
	if Humanoid.MoveDirection == Vector3.zero then return Humanoid.MoveDirection end
	local LookFlat = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
	local FlatFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + LookFlat)
	local Velocity = (Camera.CFrame * CFrame.new(FlatFrame:VectorToObjectSpace(Humanoid.MoveDirection))).Position - Camera.CFrame.Position
	if Velocity == Vector3.zero then return Velocity end
	return Velocity.Unit
end

Globals.PromptContainer = Instance.new("Folder")
Globals.PromptContainer.Name = "PromptContainer"
Globals.PromptContainer.Parent = GetHiddenContainer()

local ESPBlacklist = {}

Functions.AddESP = function(ESPOptions, RoomBased)
	local Object = ESPOptions.Object
	if table.find(ESPBlacklist, Object) then return end

	if RoomBased then
		local CurrentRoom = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
		local ObjectRoom = tonumber(Object:GetAttribute("ParentRoom"))
		if ObjectRoom == CurrentRoom or (table.find(Objects.Doors, Object) and ObjectRoom == CurrentRoom + 1) then
			F1xWare.ESPLibrary:AddESP(ESPOptions)
		end

		local RoomConnection = LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
			if F1xWare.ESPLibrary.ColorTable[Object] then ESPOptions.Color = F1xWare.ESPLibrary.ColorTable[Object] end
			local NewCurrentRoom = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
			local ObjRoom = tonumber(Object:GetAttribute("ParentRoom"))
			if ObjRoom == NewCurrentRoom or (table.find(Objects.Doors, Object) and ObjRoom == NewCurrentRoom + 1) then
				F1xWare.ESPLibrary:AddESP(ESPOptions)
			else
				F1xWare.ESPLibrary:RemoveESP(Object)
			end
		end)
		table.insert(Connections, RoomConnection)
		ESPConnections[Object] = RoomConnection

		Object.Destroying:Once(function()
			RoomConnection:Disconnect()
			if F1xWare then F1xWare.ESPLibrary:RemoveESP(Object) end
			local Pos = table.find(Connections, RoomConnection)
			if Pos then table.remove(Connections, Pos) end
		end)
	else
		F1xWare.ESPLibrary:AddESP(ESPOptions)
	end
end

Functions.RemoveESP = function(Object)
	local Conn = ESPConnections[Object]
	if Conn then
		Conn:Disconnect()
		ESPConnections[Object] = nil
		local Pos = table.find(Connections, Conn)
		if Pos then table.remove(Connections, Pos) end
	end
	F1xWare.ESPLibrary:RemoveESP(Object)
end

Functions.BlacklistESP = function(Object) table.insert(ESPBlacklist, Object) end

Functions.GetDoorNumber = function(Object)
	local DoorNumber = tonumber(Object.Parent.Name) or tonumber(Object.Parent.Parent.Name)
	if DoorNumber then DoorNumber = DoorNumber + 1 end
	if Floor == "Mines" then DoorNumber = DoorNumber + 100 end
	if Floor == "Backdoor" then DoorNumber = DoorNumber - 50 end
	return tostring(DoorNumber)
end

Functions.GetLibraryCode = function()
	local Paper = Character:FindFirstChild("LibraryHintPaper") or Character:FindFirstChild("LibraryHintPaperHard") or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper") or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard")
	if Paper and Paper:FindFirstChild("UI") then
		local Code = {}
		local CodeLength = Floor == "Fools" and 10 or 5
		for I = 1, CodeLength do Code[I] = "_" end
		local HintChildren = LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()
		local UIChildren = Paper.UI:GetChildren()
		for _, Hint in HintChildren do
			for _, UIChild in UIChildren do
				if Hint:IsA("ImageLabel") and UIChild:IsA("ImageLabel") and Hint.ImageRectOffset == UIChild.ImageRectOffset and Code[tonumber(UIChild.Name)] then
					Code[tonumber(UIChild.Name)] = Hint.TextLabel.Text
				end
			end
		end
		return table.concat(Code)
	end
	return Floor == "Fools" and "__________" or "_____"
end

Globals.UsedRandomCodes = {}
Functions.GetRandomCode = function()
    local CodeTemplate = Functions.GetLibraryCode()
    if not CodeTemplate then return nil end
    local NewCode
    local Tries = 0
    repeat
        NewCode = CodeTemplate:gsub("_", function() return tostring(math.random(0, 9)) end)
        Tries = Tries + 1
    until not Globals.UsedRandomCodes[NewCode] or Tries >= 10
    Globals.UsedRandomCodes[NewCode] = true
    return NewCode
end

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
	General  = Window:AddTab(CurrentLang.TabGeneral, "house"),
	Exploits = Window:AddTab(CurrentLang.TabExploits, "shield"),
	Visuals  = Window:AddTab(CurrentLang.TabVisuals, "eye"),
	Floors   = Window:AddTab(CurrentLang.TabFloors, "earth"),
}

Groupboxes.General_Character = Tabs.General:AddLeftGroupbox(CurrentLang.BoxChar)
Groupboxes.General_Character:AddSlider("SpeedBoostSlider", { Text = CurrentLang.SpeedBoost, Min = 0, Max = 100, Default = 0, Rounding = 0, Compact = true })
Groupboxes.General_Character:AddToggle("SpeedBoostToggle", { Text = CurrentLang.EnableSpeed, Default = false })
Groupboxes.General_Character:AddToggle("FlyToggle", { Text = CurrentLang.Fly, Default = false })
Toggles.FlyToggle:AddKeyPicker("FlyKeybind", { Text = CurrentLang.Fly, Default = "F", Mode = "Toggle", SyncToggleState = true })
Groupboxes.General_Character:AddSlider("FlySpeed", { Text = "Fly Speed", Min = 0, Max = 115, Default = 20, Rounding = 0, Compact = true })
Groupboxes.General_Character:AddDivider()
Groupboxes.General_Character:AddToggle("NoclipToggle", { Text = CurrentLang.Noclip, Default = false })
Toggles.NoclipToggle:AddKeyPicker("NoclipKeybind", { Text = CurrentLang.Noclip, Default = "N", Mode = "Toggle", SyncToggleState = true })
Groupboxes.General_Character:AddToggle("RemoveClosetDelay", { Text = "Remove Closet Delay", Default = false })
Groupboxes.General_Character:AddToggle("RemoveAcceleration", { Text = "Remove Acceleration", Default = false })

local CustomPhysics
Options.SpeedBoostSlider:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("Crouch") then RemotesFolder.Crouch:FireServer(Value and true or Functions.IsCrouching(), true) end
end)

Toggles.RemoveAcceleration:OnChanged(function(Value)
	for Index, Old in PartProperties do Index.CustomPhysicalProperties = Value and CustomPhysics or Old end
end)

Groupboxes.General_Character:AddDivider()
Groupboxes.General_Character:AddToggle("EnableCharacterJump", { Text = "Enable Jumping", Default = false })
Groupboxes.General_Character:AddToggle("EnableCharacterSlide", { Text = "Enable Sliding", Default = false })
Groupboxes.General_Character:AddToggle("InfiniteJumps", { Text = "Infinite Jumps", Default = false })

local OldJump = false
local OldSlide = false

Toggles.SpeedBoostToggle:OnChanged(function(Value) if Humanoid then Humanoid.WalkSpeed = Functions.GetCurrentSpeed() + (Value and Options.SpeedBoostSlider.Value or 0) end end)
Toggles.EnableCharacterJump:OnChanged(function(Value) if Character then Character:SetAttribute("CanJump", Value and true or OldJump) end end)
Toggles.EnableCharacterSlide:OnChanged(function(Value) if Character then Character:SetAttribute("CanSlide", Value and true or OldSlide) end end)

Groupboxes.General_Self = Tabs.General:AddLeftGroupbox(CurrentLang.BoxSelf)
Groupboxes.General_Self:AddToggle("DoorReachToggle", { Text = CurrentLang.DoorReach, Default = false })
Groupboxes.General_Self:AddToggle("DisableIdleKick", { Text = "Disable Idle Kick", Default = false })
Toggles.DisableIdleKick:OnChanged(function(Value)
	if Functions.CheckCompatability({"getconnections"}) then
		for _, Conn in F1xWare.Environment.getconnections(LocalPlayer.Idled) do
			if Value then Conn:Disable() else Conn:Enable() end
		end
	end
end)
LocalPlayer.Idled:Connect(function()
	if Toggles.DisableIdleKick.Value then
		Services.VirtualUser:CaptureController()
		Services.VirtualUser:ClickButton2(Vector2.new())
	end
end)

Groupboxes.General_Self:AddDivider()
Groupboxes.General_Self:AddSlider("PromptReachSlider", { Text = "Prompt Reach Multiplier", Min = 1, Max = 2, Default = 1, Rounding = 1, Compact = true })
Groupboxes.General_Self:AddToggle("InstantPrompts", { Text = "Instant Prompts", Default = false })
Groupboxes.General_Self:AddToggle("PromptClip", { Text = "Prompt Clip", Default = false })

Options.PromptReachSlider:OnChanged(function(Value) for _, Prompt in Objects.Prompts do Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old") * Value end end)
Toggles.InstantPrompts:OnChanged(function(Value) for _, Prompt in Objects.Prompts do Prompt.HoldDuration = Value and 0 or Prompt:GetAttribute("HoldDuration_Old") end end)
Toggles.PromptClip:OnChanged(function(Value) for _, Prompt in Objects.Prompts do Prompt.RequiresLineOfSight = Value and false or Prompt:GetAttribute("RequiresLineOfSight_Old") end end)

Groupboxes.Self_Automation = Tabs.General:AddRightGroupbox(CurrentLang.BoxAuto)
Groupboxes.Self_Automation:AddToggle("AutoBreakerBox", { Text = CurrentLang.AutoBreaker, Default = false })
Groupboxes.Self_Automation:AddToggle("AutoSolveAnchors", { Text = "Auto Solve Anchors", Default = false })
Toggles.AutoBreakerBox:OnChanged(function(Value)
	if Value and CurrentRooms:FindFirstChild("ElevatorBreaker", true) then
		if not Globals.BreakerBoxInteracted then
			if not Globals.BreakerBoxNotified then
				Functions.Notify({ Title = "Взаимодействуйте с рубильником.", Body = "Он решится автоматически." })
				Globals.BreakerBoxInteracted = true
			end
		else
			RemotesFolder.EBF:FireServer()
		end
	end
end)

Groupboxes.Self_Automation:AddToggle("AutoHeartbeatMinigame", { Text = "Auto Heartbeat Minigame", Default = false, Disabled = not Functions.CheckCompatability({"hookmetamethod", "newcclosure", "getnamecallmethod"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoUnlockPadlockToggle", { Text = "Auto Unlock Padlock", Default = false })
Groupboxes.Self_Automation:AddSlider("AutoUnlockPadlockSlider", { Text = "Unlock Distance", Min = 1, Max = 50, Default = 10, Rounding = 0, Compact = true })
Groupboxes.Self_Automation:AddToggle("AutoLibraryGuessCode", { Text = "Guess Library Code", Default = false })
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoInteractToggle", { Text = CurrentLang.AutoInteract, Default = false })
Toggles.AutoInteractToggle:AddKeyPicker("AutoInteractKeybind", { Text = CurrentLang.AutoInteract, Default = "R", Mode = Library.IsMobile and "Toggle" or "Hold", SyncToggleState = true })
Groupboxes.Self_Automation:AddDropdown("AutoInteractIgnoreList", { Text = "Ignore List", Values = { "Glitch Fragments", "Jeff Items", "Dropped Items", "Currency", "Minecarts", "Locks" }, Default = { "Glitch Fragments", "Jeff Items", "Dropped Items" }, Multi = true, AllowNull = true })
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoClosetToggle", { Text = CurrentLang.AutoCloset, Default = false })
Toggles.AutoClosetToggle:AddKeyPicker("AutoClosetKeybind", { Text = CurrentLang.AutoCloset, Default = "Q", Mode = "Toggle", SyncToggleState = true })
Groupboxes.Self_Automation:AddDropdown("AutoClosetEntityList", { Text = "Ignore List", Values = { "Rush", "Ambush", "Blitz", "A-60", "A-120", "AR0xMBUSH", "RNIUSHCG==" }, Multi = true, AllowNull = true })
Groupboxes.Self_Automation:AddToggle("SpectateEntityToggle", { Text = "Spectate Entity", Default = false })
Groupboxes.Self_Automation:AddDropdown("SpecateEntityMode", { Values = {"Player to Entity", "Entity to Player"}, Default = 1, AllowNull = true })

Groupboxes.Self_Misc = Tabs.General:AddRightGroupbox(CurrentLang.BoxMisc)
Groupboxes.Self_Misc:AddButton({ Text = CurrentLang.PlayAgain, DoubleClick = true, Func = function() RemotesFolder.PlayAgain:FireServer() end })
Groupboxes.Self_Misc:AddButton({ Text = CurrentLang.Lobby, DoubleClick = true, Func = function() RemotesFolder.Lobby:FireServer() end })
Groupboxes.Self_Misc:AddButton({ Text = CurrentLang.Revive, DoubleClick = true, Func = function() RemotesFolder.Revive:FireServer() end })
Groupboxes.Self_Misc:AddButton({ Text = CurrentLang.Reset, DoubleClick = true, Func = function()
	Globals.SelfKilled = true
	if Functions.CheckCompatability({"replicatesignal"}) then
		F1xWare.Environment.replicatesignal(LocalPlayer.Kill)
	else
		if RemotesFolder:FindFirstChild("Underwater") then RemotesFolder.Underwater:FireServer(true)
		else Humanoid.Health = 0 end
	end
end})

Groupboxes.Exploits_Bypass = Tabs.Exploits:AddLeftGroupbox(CurrentLang.BoxBypass)
Groupboxes.Exploits_Bypass:AddToggle("BypassGiggle", { Text = "Bypass Giggle", Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassDupe", { Text = "Bypass Dupe", Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassEyes", { Text = CurrentLang.BypassEyes, Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassLookman", { Text = CurrentLang.BypassLookman, Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassGloombatEggs", { Text = "Bypass Gloombat Eggs", Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassSeekObstructions", { Text = "Bypass Seek Obstructions", Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassVacuum", { Text = "Bypass Vacuum", Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassKillbricks", { Text = "Bypass Killbricks", Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassSeekingWall", { Text = "Bypass Seeking Wall", Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassSnare", { Text = "Bypass Snare", Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassBanana", { Text = "Bypass Banana", Default = false })
Groupboxes.Exploits_Bypass:AddToggle("BypassJeff", { Text = "Bypass Jeff", Default = false })

Groupboxes.Exploits_BypassRight = Tabs.Exploits:AddRightGroupbox(CurrentLang.BoxBypass)
Groupboxes.Exploits_BypassRight:AddToggle("DisableAnticheat", { Text = "Anticheat Bypass", Default = false })
Groupboxes.Exploits_BypassRight:AddToggle("VelocityManipulationToggle", { Text = "Velocity Manipulation", Default = false })
Toggles.VelocityManipulationToggle:AddKeyPicker("VelocityManipulationKeybind", { Text = "Velocity Manipulation", Default = "V", Mode = Library.IsMobile and "Toggle" or "Hold", SyncToggleState = true })
Groupboxes.Exploits_BypassRight:AddDropdown("VelocityManipulationMode", { Values = {"Velocity", "Pivot"}, Text = "Manipulation Method", Default = 1 })
Groupboxes.Exploits_BypassRight:AddDivider()
Groupboxes.Exploits_BypassRight:AddToggle("InfiniteItemsToggle", { Text = "Infinite Items", Default = false, Disabled = not Functions.CheckCompatability({"fireproximityprompt"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Exploits_BypassRight:AddDropdown("InfiniteItemsList", { Text = "Item List", Values = { "Lockpicks", "Skeleton Key", "Shears", "Multitool" }, Multi = true, AllowNull = true, Disabled = not Functions.CheckCompatability({"fireproximityprompt"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Exploits_BypassRight:AddDivider()
Groupboxes.Exploits_BypassRight:AddToggle("PositionSpoof", { Text = "Position Spoof", Default = false })
Toggles.PositionSpoof:AddKeyPicker("PositionSpoof", { Text = "Position Spoof", Default = "B", Mode = "Toggle", SyncToggleState = true })
Groupboxes.Exploits_BypassRight:AddToggle("CrouchSpoof", { Text = "Crouch Spoof", Default = false })

Groupboxes.Exploits_Remove = Tabs.Exploits:AddRightGroupbox("Remove")
Groupboxes.Exploits_Remove:AddToggle("RemoveScreech", { Text = CurrentLang.RemoveScreech, Default = false })
Groupboxes.Exploits_Remove:AddToggle("RemoveHalt",    { Text = "Remove Halt",     Default = false })
Groupboxes.Exploits_Remove:AddToggle("RemoveA90",     { Text = "Remove A-90",     Default = false })
Groupboxes.Exploits_Remove:AddToggle("RemoveDread",   { Text = "Remove Dread",    Default = false })
Groupboxes.Exploits_Remove:AddToggle("RemoveSurge",   { Text = "Remove Surge",    Default = false })
Groupboxes.Exploits_Remove:AddDivider()
Groupboxes.Exploits_Remove:AddToggle("NoScreechDamage", { Text = CurrentLang.NoScreech, Default = false })
Groupboxes.Exploits_Remove:AddToggle("NoHaltDamage",    { Text = "No Halt Damage",    Default = false })
Groupboxes.Exploits_Remove:AddToggle("NoA90Damage",     { Text = "No A-90 Damage",    Default = false })
Groupboxes.Exploits_Remove:AddToggle("NoSurgeDamage",   { Text = "No Surge Damage",   Default = false })

Groupboxes.Exploits_Audio = Tabs.Exploits:AddLeftGroupbox(CurrentLang.BoxAudio)
Globals.JamMuffle = Services.SoundService:WaitForChild("Main"):FindFirstChild("Jamming") or Instance.new("EqualizerSoundEffect")
Groupboxes.Exploits_Audio:AddToggle("RemoveFootstepSounds",    { Text = "Remove Footstep Sounds",    Default = false })
Groupboxes.Exploits_Audio:AddToggle("RemoveJamminMusic",       { Text = "Remove Jammin Music",       Default = false })
Groupboxes.Exploits_Audio:AddToggle("RemoveInteractingSounds", { Text = "Remove Interacting Sounds", Default = false })

Groupboxes.Visuals_LeftTab = Tabs.Visuals:AddLeftTabbox(CurrentLang.BoxCamera)
Groupboxes.Visuals_Camera = Groupboxes.Visuals_LeftTab:AddTab(CurrentLang.BoxCamera)
Groupboxes.Visuals_Camera:AddToggle("AmbientToggle", { Text = "Ambient", Default = false })
Groupboxes.Visuals_Camera:AddSlider("FieldOfView", { Text = CurrentLang.FOV, Min = 1, Max = 120, Default = 70, Rounding = 0 })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraShake", { Text = CurrentLang.RemoveShake, Default = false, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraBobbing", { Text = "Remove Camera Bobbing", Default = false, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddToggle("RemoveCutscenes", { Text = "Remove Cutscenes", Default = false })
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraFog", { Text = CurrentLang.RemoveFog, Default = false })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("ThirdPersonToggle", { Text = CurrentLang.ThirdPerson, Default = false })
Toggles.ThirdPersonToggle:AddKeyPicker("ThirdPersonKeybind", { Text = CurrentLang.ThirdPerson, Default = "T", Mode = "Toggle", SyncToggleState = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetX", { Text = "X Offset", Min = -10, Max = 10, Default = 1.5, Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetY", { Text = "Y Offset", Min = -10, Max = 10, Default = 1,   Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetZ", { Text = "Z Offset", Min = -10, Max = 10, Default = 5,   Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddToggle("ThirdPersonWallCheck", { Text = "Wall Check", Default = false })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("ViewmodelOffsetToggle", { Text = "Viewmodel Offset", Default = false, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetX", { Text = "X Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetY", { Text = "Y Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetZ", { Text = "Z Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })

Toggles.AmbientToggle:AddColorPicker("AmbientColor", { Text = "Ambient", Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })

local Main_Game
local ClientModules

Groupboxes.Visuals_Effects = Groupboxes.Visuals_LeftTab:AddTab(CurrentLang.BoxEffects)
Groupboxes.Visuals_Effects:AddToggle("TransparentHidingSpotsToggle", { Text = "Transparent Hiding Spots", Default = false })
Groupboxes.Visuals_Effects:AddSlider("TransparentHidingSpotsSlider", { Text = "Transparency", Min = 0, Max = 1, Default = 0.5, Rounding = 2, Compact = true })
Groupboxes.Visuals_Effects:AddDivider()
Groupboxes.Visuals_Effects:AddToggle("DisableGlitchJumpscare",   { Text = "Disable Glitch Jumpscare",   Default = false })
Groupboxes.Visuals_Effects:AddToggle("DisableTimothyJumpscare",  { Text = "Disable Timothy Jumpscare",  Default = false })
Groupboxes.Visuals_Effects:AddToggle("DisableVoidJumpscare",     { Text = "Disable Void Jumpscare",     Default = false })
Groupboxes.Visuals_Effects:AddDivider()
Groupboxes.Visuals_Effects:AddToggle("DisableHideVignette",      { Text = "Disable Hide Vignette",      Default = false })
Groupboxes.Visuals_Effects:AddToggle("DisableFiredampEffect",    { Text = "Disable Firedamp Effect",    Default = false })
Groupboxes.Visuals_Effects:AddToggle("DisableEntityJumpscares",  { Text = "Disable Entity Jumpscares",  Default = false })

Groupboxes.Visuals_RightTab     = Tabs.Visuals:AddRightTabbox("Entities / Settings")
Groupboxes.Visuals_Entities     = Groupboxes.Visuals_RightTab:AddTab("Entities")
Groupboxes.Visuals_EntitySettings = Groupboxes.Visuals_RightTab:AddTab("Settings")

Groupboxes.Visuals_Entities:AddDropdown("EntityList", { Text = "Entity List", Values = { "Rush","Ambush","Eyes","Halt","Blitz","Lookman","Gloombat Swarm","A-60","A-120","Sally","Jeff the Killer","Groundskeeper","Monument","AR0xMBUSH","RNIUSHCG==" }, Multi = true, AllowNull = true })
Groupboxes.Visuals_Entities:AddToggle("NotifyEntities",    { Text = "Notify Entities",    Default = false })
Groupboxes.Visuals_Entities:AddDivider()

local ItemsToNotify = {}
for Index, Name in pairs(ItemNames) do
	if not table.find(ItemsToNotify, Name) then table.insert(ItemsToNotify, Name) end
end

Groupboxes.Visuals_Entities:AddDropdown("NotifyItemList", { Text = "Item List", Values = ItemsToNotify, Multi = true, AllowNull = true })
Groupboxes.Visuals_Entities:AddToggle("NotifyItemsToggle",    { Text = "Notify Items",    Default = false })
Groupboxes.Visuals_Entities:AddToggle("NotifyItemsShowDistance",    { Text = "Show Distance",    Default = false })
Groupboxes.Visuals_Entities:AddDivider()
Groupboxes.Visuals_Entities:AddToggle("NotifyLibraryCode", { Text = "Notify Library Code", Default = false })
Groupboxes.Visuals_Entities:AddToggle("NotifyOxygen",      { Text = "Notify Oxygen Level", Default = false })
Groupboxes.Visuals_Entities:AddToggle("NotifyHasteTime",   { Text = "Notify Haste Time",   Default = false })

Groupboxes.Visuals_EntitySettings:AddToggle("EntityChatToggle", { Text = "Notify Chat", Default = false })
Groupboxes.Visuals_EntitySettings:AddInput("EntityChatMessage", { Text = "Message", Default = "spawned!", Numeric = false, Placeholder = "Message" })
Groupboxes.Visuals_EntitySettings:AddDivider()
Groupboxes.Visuals_EntitySettings:AddDropdown("NotifyStyle", { Text = "Notify Style", Values = { "F1xWare", "Doors", "STX", "Library" }, Default = 1 })
Groupboxes.Visuals_EntitySettings:AddSlider("NotifySoundVolume", { Text = "Sound Volume", Min = 0, Max = 10, Default = 3, Rounding = 1 })
Groupboxes.Visuals_EntitySettings:AddToggle("NotifyPlaySound", { Text = "Play Sound", Default = true })
Groupboxes.Visuals_EntitySettings:AddToggle("NotifyKeepNotifications", { Text = "Keep Notifications", Default = false })
Groupboxes.Visuals_EntitySettings:AddButton({ Text = "Test Notification", DoubleClick = false, Func = function() Functions.Notify({Title = "Это тест."}) end })

Groupboxes.Visuals_ESP          = Tabs.Visuals:AddRightTabbox(CurrentLang.BoxESP)
Groupboxes.Visuals_ESP_Toggles  = Groupboxes.Visuals_ESP:AddTab("ESP")
Groupboxes.Visuals_ESP_Settings = Groupboxes.Visuals_ESP:AddTab("Settings")

Groupboxes.Visuals_ESP_Toggles:AddToggle("ObjectiveESPToggle", { Text = CurrentLang.ObjectiveESP, Default = false })
Toggles.ObjectiveESPToggle:AddColorPicker("ObjectiveESPColor", { Text = CurrentLang.ObjectiveESP, Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })

Groupboxes.Visuals_ESP_Toggles:AddToggle("DoorESPToggle",       { Text = CurrentLang.DoorESP,        Default = false })
Groupboxes.Visuals_ESP_Toggles:AddToggle("HidingSpotESPToggle", { Text = "Hiding Spots", Default = false })
Groupboxes.Visuals_ESP_Toggles:AddToggle("PlayerESPToggle",     { Text = "Players",      Default = false })
Groupboxes.Visuals_ESP_Toggles:AddToggle("ChestESPToggle",      { Text = "Chests",       Default = false })
Groupboxes.Visuals_ESP_Toggles:AddToggle("ItemESPToggle",       { Text = CurrentLang.ItemESP,        Default = false })
Groupboxes.Visuals_ESP_Toggles:AddToggle("CurrencyESPToggle",   { Text = "Currency",     Default = false })
Groupboxes.Visuals_ESP_Toggles:AddToggle("LadderESPToggle",     { Text = "Ladders",      Default = false })
Groupboxes.Visuals_ESP_Toggles:AddDivider()
Groupboxes.Visuals_ESP_Toggles:AddDropdown("EntityESPOptions",  { Text = "Entity List", Values = { "Rush","Ambush","Eyes","Dupe","Figure","Blitz","Lookman","Snare","Giggle","Gloombat Eggs","Grumble","A-60","A-120","Sally","Jeff the Killer","Groundskeeper","Mandrake Hole","Monument","Bramble","AR0xMBUSH","RNIUSHCG==" }, Multi = true, AllowNull = true })
Groupboxes.Visuals_ESP_Toggles:AddToggle("EntityESPToggle",     { Text = CurrentLang.EntityESP,      Default = false })

Groupboxes.Visuals_ESP_Settings:AddToggle("ESPRainbow",     { Text = "Rainbow Effect", Default = false })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPShowDistance",{ Text = "Show Distance",  Default = true })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFillTransparency",        { Text = "Fill Transparency",         Min = 0, Max = 1, Default = 0.75, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPOutlineTransparency",     { Text = "Outline Transparency",      Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextTransparency",        { Text = "Text Transparency",         Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextOutlineTransparency", { Text = "Text Outline Transparency", Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFadeTime",                { Text = "Fade Time",                 Min = 0, Max = 1, Default = 0.25, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPRenderLimit",             { Text = "Render Limit",              Min = 30, Max = 240, Default = 240, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextSize",                { Text = "Text Size",                 Min = 12, Max = 24, Default = 20, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTextFont", { Text = "Text Font", Values = { "Legacy","Arial","ArialBold","SourceSans","SourceSansBold","SourceSansLight","SourceSansItalic","Bodoni","Garamond","Cartoon","Code","Highway","SciFi","Arcade","Fantasy","Antique","SourceSansSemibold","Gotham","GothamMedium","GothamBold","GothamBlack","AmaticSC","Bangers","Creepster","DenkOne","Fondamento","FredokaOne","GrenzeGotisch","IndieFlower","JosefinSans","Jura","Kalam","LuckiestGuy","Merriweather","Michroma","Nunito","Oswald","PatrickHand","PermanentMarker","Roboto","RobotoCondensed","RobotoMono","Sarpanch","SpecialElite","TitilliumWeb","Ubuntu","BuilderSans","BuilderSansMedium","BuilderSansBold","BuilderSansExtraBold","Arimo","ArimoBold" }, Default = 12 })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTracersOrigin",  { Text = "Tracer Origin", Values = { "Bottom","Center","Top","Mouse" }, Default = 1 })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTracerThickness",  { Text = "Tracer Thickness", Min = 0.5, Max = 2, Default = 0.75, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPTracersToggle",    { Text = "Enable Tracers", Default = false })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPArrowsRadius",     { Text = "Arrow Radius", Min = 100, Max = 500, Default = 250, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPArrowsToggle",     { Text = "Enable Arrows", Default = false })

F1xWare.ESPLibrary:SetRainbow(false)
F1xWare.ESPLibrary:SetShowDistance(true)
F1xWare.ESPLibrary:SetFillTransparency(0.75)
F1xWare.ESPLibrary:SetOutlineTransparency(0)
F1xWare.ESPLibrary:SetTextTransparency(0)
F1xWare.ESPLibrary:SetTextOutlineTransparency(0)
F1xWare.ESPLibrary:SetRenderLimit(240)
F1xWare.ESPLibrary:SetFadeTime(0.25)
F1xWare.ESPLibrary:SetTextSize(20)
F1xWare.ESPLibrary:SetFont(Enum.Font.Highway)
F1xWare.ESPLibrary:SetTracers(false)
F1xWare.ESPLibrary:SetTracerSize(0.75)
F1xWare.ESPLibrary:SetTracerOrigin("Bottom")
F1xWare.ESPLibrary:SetArrows(false)
F1xWare.ESPLibrary:SetArrowRadius(250)
F1xWare.ESPLibrary:SetDistanceSizeRatio(0.8)

Groupboxes.Floors_Automation = Tabs.Floors:AddRightGroupbox(CurrentLang.BoxAuto)
Groupboxes.Floors_Automation:AddToggle("AutoSteerMinecart", { Text = CurrentLang.AutoMinecart, Default = false, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Floors_Automation:AddSlider("AutoSteerMinecartTurnDistance", { Text = "Turn Distance", Min = 20, Max = 40, Default = 30, Rounding = 0, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Floors_Automation:AddSlider("AutoSteerMinecartDuckDistance", { Text = "Crouch Distance", Min = 20, Max = 40, Default = 30, Rounding = 0, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Floors_Automation:AddDivider()
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalk",             { Text = CurrentLang.AutoRooms,       Default = false })
Groupboxes.Floors_Automation:AddSlider("RoomsAutoWalkPathfindTimeout", { Text = "Pathfind Timeout", Min = 0.5, Max = 3, Default = 1, Rounding = 1 })
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalkIgnoreA60",    { Text = "Ignore A-60",      Default = false })
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalkShowPathToggle", { Text = "Show Path",       Default = false })
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalkSpoofFootsteps", { Text = "Spoof Footsteps", Default = false, Disabled = not Functions.CheckCompatability({"hookmetamethod", "newcclosure", "getnamecallmethod"}), DisabledTooltip = Globals.IncompatibleMessage })

Groupboxes.Floors_Completion = Tabs.Floors:AddRightGroupbox("Completion")
Groupboxes.Floors_Completion:AddButton({ Text = "Auto Complete Dam Seek", Func = function()
    if LatestRoom.Value < 100 or Floor ~= "Mines" then Functions.Notify({Title = "Вы должны быть в комнате 200."}); return end
	local IsCutscene = false
	local CutsceneConnection = RemotesFolder.Cutscene.OnClientEvent:Connect(function() IsCutscene = true; task.wait(7); IsCutscene = false; end)
    local function GetNextPump()
        local Highest = { Height = -69420, Object = nil }
        for _, Object in pairs(Objects.Objectives) do
            if Object.Name == "WaterPump" and Object:GetAttribute("F1xWare_Completed") ~= true then
                if Object.PrimaryPart and Object.PrimaryPart.Position.Y > Highest.Height then Highest.Object = Object; Highest.Height = Object.PrimaryPart.Position.Y end
            end
        end
        return Highest.Object
    end
    local function HandlePump(Pump)
        while task.wait(0.1) do
			if IsCutscene then continue end
            Character:PivotTo(Pump:GetPivot())
            local Prompt = Pump:FindFirstChild("ValvePrompt", true)
            if Prompt then Functions.ForceFirePrompt(Prompt) end
            if Pump:GetAttribute("F1xWare_Completed") then break end
        end
    end
    Functions.Notify({Title = "Попытка завершить клапаны.", Body = "Подождите."})
    while task.wait(0.1) do
        local Pump = GetNextPump()
        if Pump then HandlePump(Pump) else break end
    end
    Functions.Notify({Title = "Клапаны успешно завершены."})
end })

Groupboxes.Floors_Visuals = Tabs.Floors:AddLeftGroupbox(CurrentLang.BoxFloors)
Groupboxes.Floors_Visuals:AddToggle("ShowSeekPathToggle", { Text = "Show Seek Path", Default = false, Risky = Floor ~= "Mines" })
Toggles.ShowSeekPathToggle:AddColorPicker("ShowSeekPathColor", { Text = "Seek Path", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })
Groupboxes.Floors_Visuals:AddToggle("ShowEyestalkPathToggle", { Text = "Show Eyestalk Path", Default = false, Risky = Floor ~= "Garden" })
Toggles.ShowEyestalkPathToggle:AddColorPicker("ShowEyestalkPathColor", { Text = "Eyestalk Path", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })

Groupboxes.Floors_Bypass = Tabs.Floors:AddLeftGroupbox(CurrentLang.BoxBypass)
Groupboxes.Floors_Bypass:AddToggle("RemoveSeekTrigger", { Text = "Delete Seek Trigger", Default = false, Risky = not (Floor == "Fools" or Floor == "OldHotel"), Disabled = not Functions.CheckCompatability({"firetouchinterest"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Floors_Bypass:AddToggle("RemoveFigure", { Text = "Delete Figure", Default = false, Risky = not (Floor == "Fools" or Floor == "OldHotel" or Floor == "Mines"), Disabled = not Functions.CheckCompatability({"isnetworkowner"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Floors_Bypass:AddToggle("AutoRevive", { Text = "Infinite Revives", Default = false, Risky = not (Floor == "Fools" or Floor == "OldHotel") })
Groupboxes.Floors_Bypass:AddToggle("FigureGodmode", { Text = "Figure Godmode", Default = false, Risky = not (Floor == "Fools" or Floor == "OldHotel") })
Groupboxes.Floors_Bypass:AddDivider()
Groupboxes.Floors_Bypass:AddToggle("RemoveBasementGate",  { Text = "Remove Basement Gate",   Default = false, Risky = not (Floor == "Fools" or Floor == "OldHotel") })
Groupboxes.Floors_Bypass:AddToggle("RemovePaintingsDoor", { Text = "Remove Paintings Door",  Default = false, Risky = not (Floor == "Fools" or Floor == "OldHotel") })
Groupboxes.Floors_Bypass:AddToggle("RemoveSkeletonDoor",  { Text = "Remove Skeleton Door",   Default = false, Risky = Floor ~= "Fools" })

Groupboxes.Floors_Farming = Tabs.Floors:AddLeftGroupbox(CurrentLang.BoxFarming)
Groupboxes.Floors_Farming:AddToggle("KnobFarm", { Text = CurrentLang.KnobFarm, Default = false })
Groupboxes.Floors_Farming:AddButton({ Text = "Start Knob Farm", Func = function()
	if LatestRoom.Value ~= 0 then Functions.Notify({Title = "Вы должны быть в комнате 0."}); return end
	if LocalPlayer.PlayerGui:FindFirstChild("TopbarUI") then 
		local GoldCount = LocalPlayer.PlayerGui.TopbarUI.Topbar.StatsTopbarHandler.StatModules.Gold.GoldVal
		if GoldCount.Value <= 0 then Functions.Notify({Title = "Вам нужно золото."}); return end
	end
    Globals.KnobFarmStarted = true
end })

Groupboxes.Floors_Farming:AddDivider()
Groupboxes.Floors_Farming:AddButton({ Text = "Start Death Farm", DoubleClick = true, Func = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Scripts/DeathFarm.luau"))()
end, Disabled = not Functions.CheckCompatability({"fireproximityprompt", "firesignal"}), DisabledTooltip = Globals.ImcompatibleMessage })

Groupboxes.Floors_Farming:AddButton({ Text = "Copy Death Farm Loadstring", DoubleClick = false, Func = function()
	toclipboard([==[
		loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Scripts/DeathFarm.luau"))()
	]==])
	Library:Notify("Loadstring скопирован.")
end, Disabled = not Functions.CheckCompatability({"fireproximityprompt", "firesignal"}), DisabledTooltip = Globals.ImcompatibleMessage })

Library:OnUnload(function()
	for Key, Connection in Connections do
		if type(Key) == "string" then pcall(function() Connection:Disconnect() end)
		else pcall(function() Key:Disconnect() end); pcall(function() Connection:Disconnect() end) end
	end
	for _, Object in Objects.Entities do
		if Object.Name == "Snare" or Object.Name == "GiggleCeiling" then
			local Hitbox = Object:FindFirstChild("Hitbox")
			if Hitbox then Hitbox.CanTouch = true end
		end
		if Object.Name == "GloomPile" then
			for _, Part in Object:GetDescendants() do if Part:IsA("BasePart") then Part.CanTouch = true end end
		end
		if Object.Name == "FakeDoor" or Object.Name == "DoorFake" then
			local Hidden = Object:FindFirstChild("Hidden")
			if Hidden then Hidden.CanTouch = true end
			local Lock = Object:FindFirstChild("Lock")
			if Lock and Lock:FindFirstChild("UnlockPrompt") then Lock.UnlockPrompt.Enabled = true end
		end
		if Object.Name == "SideroomSpace" then
			local Coll = Object:FindFirstChild("Collision")
			if Coll then Coll.CanCollide = false Coll.CanTouch = true end
		end
	end

	for _, Object in Objects.SeekBridges do Object:Destroy() end
	for _, Fog in Globals.FogInstances do Fog.Density = Fog:GetAttribute("Density_Old") end
	Services.Lighting.FogEnd = Globals.OldFog

	local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
	if Vignette then Vignette.Image = "rbxassetid://6100076320" end

	local ModuleRestores = { Screech = "Screech", Glitch = "Glitch", Shade = "Shade", SpiderJumpscare = "SpiderJumpscare", A90 = "A90", Dread = "Dread", Void = "Void" }
	for Key, OriginalName in ModuleRestores do if Modules[Key] then Modules[Key].Name = OriginalName end end

	FakeEvents.Screech:Destroy(); FakeEvents.Screech_Real.Parent = RemotesFolder
	FakeEvents.Shade:Destroy(); FakeEvents.Shade_Real.Parent = RemotesFolder
	if FakeEvents.A90_Real then FakeEvents.A90:Destroy(); FakeEvents.A90_Real.Parent = RemotesFolder end
	if FakeEvents.Surge_Real then FakeEvents.Surge:Destroy(); FakeEvents.Surge_Real.Parent = RemotesFolder end

	Globals.SeekNodesFolder:Destroy(); Globals.RoomsNodesFolder:Destroy(); Globals.ManipulateBody:Destroy()

	local OldAmbient = CurrentRooms:FindFirstChild(tostring(LocalPlayer:GetAttribute("CurrentRoom"))):GetAttribute("Ambient")
	Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { Ambient = OldAmbient }):Play()

	for _, Prompt in Objects.Prompts do
		if FakePrompts[Prompt] then FakePrompts[Prompt].Parent = Prompt.Parent; Prompt:Destroy() end
		if Prompt.Parent then
			Prompt.HoldDuration = Prompt:GetAttribute("HoldDuration_Old") or Prompt.HoldDuration
			Prompt.RequiresLineOfSight = Prompt:GetAttribute("RequiresLineOfSight_Old") or Prompt.RequiresLineOfSight
			Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old") or Prompt.MaxActivationDistance
		end
	end

	Character:SetAttribute("CanJump",  OldJump)
	Character:SetAttribute("CanSlide", OldSlide)

	for _, Object in Services.Workspace:GetDescendants() do task.spawn(function() Functions.RemoveESP(Object) end) end

	Humanoid.WalkSpeed  = Functions.GetCurrentSpeed()
	Humanoid.JumpPower  = 5
	Humanoid.HipHeight  = 2.367

	local BaseY = 0.18
	Collision.Position          = RootPart.Position + Vector3.new(0, BaseY, 0)
	CollisionPart.Position      = RootPart.Position + Vector3.new(0, BaseY, 0)
	CollisionPartClone.Position = RootPart.Position + Vector3.new(0, BaseY, 0)

	if Character:FindFirstChild("LowerTorso") and Character.LowerTorso:FindFirstChild("Root") then Character.LowerTorso.Root.C1 = Globals.OriginalC1 end
	if Collision:FindFirstChild("CollisionCrouch") then Collision.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, -0.982, 0) end

	CollisionClone:Destroy(); CollisionPartClone:Destroy(); F1xWare.ESPLibrary:Unload()

	if Main_Game then Main_Game.fovtarget = 70; Main_Game.spring.Speed = 8; Main_Game.tooloffset = Vector3.zero end
	if Globals.OriginalGetMoveVector then local Controls = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls(); Controls.GetMoveVector = Globals.OriginalGetMoveVector end
	getgenv().F1xWare = nil
end)

while not Globals.MainUI do task.wait() end
F1xWare.Interface.ApplySettingsTab(Window)
Functions.Notify({ Title = "Успешно загружено за " .. math.floor((tick() - LoadStart) * 1000) / 1000 .. " секунд." , Body = "Нажми '" .. tostring(Options.MenuKeybind.Value) .. "' чтобы скрыть меню."})
