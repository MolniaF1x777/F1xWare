local getgenv = getgenv or function() return _G end

local F1xWare = getgenv().F1xWare
local Interface = F1xWare and (F1xWare.UILibrary or F1xWare.Interface)

if Interface and Interface.Window then
    local InfoTab = Interface.Window:AddTab("Info")
    local InfoBox = InfoTab:AddLeftGroupbox("Information")

    InfoBox:AddLabel("Project: F1xWare")
    InfoBox:AddLabel("Version: 1.0.0")
    InfoBox:AddLabel("Status: Active")
end
