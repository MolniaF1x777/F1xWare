local getgenv = getgenv or function() return _G end

local F1xWare = getgenv().F1xWare
local Interface = F1xWare and (F1xWare.UILibrary or F1xWare.Interface)
local Library = Interface and Interface.Library
local ThemeManager = Interface and Interface.ThemeManager
local SaveManager = Interface and Interface.SaveManager

if Interface and Interface.Window then
    local SettingsTab = Interface.Window:AddTab("Settings")
    local MenuGroup = SettingsTab:AddLeftGroupbox("Menu")

    MenuGroup:AddButton("Unload", function()
        if F1xWare.Environment and F1xWare.Environment.Unload then
            F1xWare.Environment:Unload()
        end
        if Library then
            Library:Unload()
        end
    end)

    MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
        Default = "RightShift",
        NoUI = true,
        Text = "Menu keybind"
    })

    if ThemeManager then
        ThemeManager:ApplyToTab(SettingsTab)
    end
    if SaveManager then
        SaveManager:BuildConfigSection(SettingsTab)
    end
end
