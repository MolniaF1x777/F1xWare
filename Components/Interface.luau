local getgenv = getgenv or function() return _G end

getgenv().F1xWare = getgenv().F1xWare or {}
local F1xWare = getgenv().F1xWare

local BaseUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/"

local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

Library.Scheme = Library.Scheme or {}
Library.Scheme.BackgroundColor = Color3.fromRGB(15, 15, 15)
Library.Scheme.MainColor       = Color3.fromRGB(24, 24, 24)
Library.Scheme.AccentColor     = Color3.fromRGB(215, 35, 35)
Library.Scheme.OutlineColor    = Color3.fromRGB(42, 42, 42)
Library.Scheme.FontColor       = Color3.fromRGB(255, 255, 255)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder("F1xWare")
SaveManager:SetFolder("F1xWare")
SaveManager:IgnoreThemeSettings()

local Window = Library:CreateWindow({
    Title = "F1xWare",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Interface = {
    BaseUrl = BaseUrl,
    Library = Library,
    ThemeManager = ThemeManager,
    SaveManager = SaveManager,
    Window = Window,
    Tabs = {}
}

F1xWare.UILibrary = Interface
F1xWare.Interface = Interface
getgenv().Interface = Interface
getgenv().UILibrary = Interface

return Interface
