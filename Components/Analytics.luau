local getgenv = getgenv or function() return _G end

getgenv().F1xWare = getgenv().F1xWare or {}
local F1xWare = getgenv().F1xWare

local BaseUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/"
local HttpService = game:GetService("HttpService")

local Analytics = {
    BaseUrl = BaseUrl,
    SessionStart = os.time(),
    Events = {}
}

function Analytics:LogEvent(eventName, payload)
    local entry = {
        Event = eventName,
        Timestamp = os.time(),
        Data = payload or {}
    }
    table.insert(self.Events, entry)

    if isfile and isfile("F1xWare/UserData.json") then
        pcall(function()
            local current = HttpService:JSONDecode(readfile("F1xWare/UserData.json"))
            current["LastEvent"] = eventName
            current["LastActive"] = os.time()
            writefile("F1xWare/UserData.json", HttpService:JSONEncode(current))
        end)
    end
end

Analytics:LogEvent("Loaded", { Game = game.PlaceId })

F1xWare.Analytics = Analytics
getgenv().Analytics = Analytics
return Analytics
