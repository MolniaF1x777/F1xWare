if getgenv().F1xWare then
    return 
end
getgenv().F1xWare = {
    Legit = true
}

local GameList = {
  [2440500124] = "Doors"
}

local BaseUrl = "https://molniaf1x777.github.io/F1xWare/"
getgenv().F1xWare = {
    Environment = loadstring(game:HttpGet(BaseUrl .. "Components/Environment.luau"))(),
    ESPLibrary = loadstring(game:HttpGet(BaseUrl .. "Components/ESP.luau"))(),
    Legit = true,
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
        local Data = {
            TotalExecutions = 0,
            UILibrary = "Obsidian"
        }
        F1xWare.Environment.writefile("F1xWare/UserData.json", Services.HttpService:JSONEncode(Data))
    end

    local UserData = F1xWare.Environment.readfile("F1xWare/UserData.json")
    local Decoded = Services.HttpService:JSONDecode(UserData)
    if not Decoded.TotalExecutions then
        Decoded.TotalExecutions = 0    
    end

    Decoded.TotalExecutions = Decoded.TotalExecutions + 1

    if not Decoded.UILibrary then
        Decoded.UILibrary = "Obsidian"
    end

    F1xWare.TotalExecutions = Decoded.TotalExecutions
    F1xWare.UILibrary = Decoded.UILibrary

    F1xWare.Environment.writefile("F1xWare/UserData.json", Services.HttpService:JSONEncode(Decoded))
end

F1xWare.Interface = loadstring(game:HttpGet(BaseUrl .. "Components/Interface.luau"))()
F1xWare.Analytics = loadstring(game:HttpGet(BaseUrl .. "Components/Analytics.luau"))()

local CurrentGame = GameList[game.GameId]
if CurrentGame then
    loadstring(game:HttpGet(BaseUrl .. "Games/" .. CurrentGame .. "/Loader.luau"))()
else
    loadstring(game:HttpGet(BaseUrl .. "Games/Universal/Loader.luau"))()
end
