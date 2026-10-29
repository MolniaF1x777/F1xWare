local getgenv = getgenv or function() return _G end

local F1xWare = getgenv().F1xWare or {}
local STX = {}

function STX:Notify(title, desc, duration)
    local UI = F1xWare.UILibrary or F1xWare.Interface
    if UI and UI.Library and UI.Library.Notify then
        UI.Library:Notify(string.format("[%s] %s", tostring(title), tostring(desc)), duration or 5)
    end
end

F1xWare.STX = STX
getgenv().STX = STX
return STX
