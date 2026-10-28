if getgenv().F1xWareLoaded then return end
getgenv().F1xWareLoaded = true

local BaseUrl = "https://molniaf1x777.github.io/F1xWare/"
local HttpService = game:GetService("HttpService")

local function LoadAndObfuscate(path)
    local success, content = pcall(function()
        return game:HttpGet(BaseUrl .. path)
    end)
    
    if success and content then
        content = content:gsub("Abysall", "F1xWare")
        content = content:gsub("abysall", "f1xware")
        content = content:gsub("dsc.gg/abysallhub", "dsc.gg/f1xware")
        
        local func, err = loadstring(content)
        if func then
            return func()
        else
            warn("Error: " .. path .. " " .. tostring(err))
        end
    else
        warn("Failed: " .. path)
    end
end

getgenv().F1xWare = {
    Legit = true
}

local GameList = {
  [2440500124] = "Doors"
}

getgenv().F1xWare = {
    Environment = LoadAndObfuscate("Components/Environment.luau"),
    ESPLibrary = LoadAndObfuscate("Components/ESP.luau"),
    Legit = true
}

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

if F1xWare.Environment.writefile and F1xWare.Environment.readfile then
    if not F1xWare.Environment.isfile("F1xWare/UserData.json") then
        local Data = { TotalExecutions = 0, UILibrary = "Obsidian" }
        F1xWare.Environment.writefile("F1xWare/UserData.json", Services.HttpService:JSONEncode(Data))
    end

    local UserData = F1xWare.Environment.readfile("F1xWare/UserData.json")
    local Decoded = Services.HttpService:JSONDecode(UserData)
    
    Decoded.TotalExecutions = (Decoded.TotalExecutions or 0) + 1
    Decoded.UILibrary = Decoded.UILibrary or "Obsidian"

    F1xWare.TotalExecutions = Decoded.TotalExecutions
    F1xWare.UILibrary = Decoded.UILibrary

    F1xWare.Environment.writefile("F1xWare/UserData.json", Services.HttpService:JSONEncode(Decoded))
end

F1xWare.Interface = LoadAndObfuscate("Components/Interface.luau")
F1xWare.Analytics = LoadAndObfuscate("Components/Analytics.luau")

local CurrentGame = GameList[game.GameId]
if CurrentGame then
    LoadAndObfuscate("Games/" .. CurrentGame .. "/Loader.luau")
else
    LoadAndObfuscate("Games/Universal/Loader.luau")
end
