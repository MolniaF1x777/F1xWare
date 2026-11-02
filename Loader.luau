if Abysall then
    return 
end

local RepoUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/"
local CacheDir = "F1xWare/cache"

local FileApi = type(writefile) == "function" and type(readfile) == "function"
    and type(isfile) == "function" and type(isfolder) == "function" and type(makefolder) == "function"

if FileApi then
    if not isfolder("F1xWare") then makefolder("F1xWare") end

    local Ok, Remote = pcall(game.HttpGet, game, RepoUrl .. "version.txt")
    local LocalVersion = isfile("F1xWare/version.txt") and readfile("F1xWare/version.txt") or nil

    if Ok then
        Remote = Remote:gsub("%s+", "")
        if #Remote < 20 and Remote ~= LocalVersion then
            if isfolder(CacheDir) and type(delfolder) == "function" then delfolder(CacheDir) end
            writefile("F1xWare/version.txt", Remote)
        end
    end

    if not isfolder(CacheDir) then makefolder(CacheDir) end
end

getgenv().F1xGet = function(Url)
    if not FileApi then return game:HttpGet(Url) end

    local Path = CacheDir .. "/" .. (Url:gsub("^https?://", ""):gsub("[^%w]", "_"))
    if isfile(Path) then
        local Cached = readfile(Path)
        if #Cached > 0 then return Cached end
    end

    local Source = game:HttpGet(Url)
    if Source:sub(1, 3) ~= "404" then
        pcall(writefile, Path, Source)
    end
    return Source
end

getgenv().Abysall = {
    Legit = true
}

local GameList = {
  [2440500124] = "Doors"
}

local BaseUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/"
getgenv().Abysall = {
    Environment = loadstring(game:HttpGet(BaseUrl .. "Components/Environment.luau"))(),
    ESPLibrary = loadstring(game:HttpGet(BaseUrl .. "Components/ESP.luau"))(),

    Legit = true, -- pog
}

local function CloneReference(Object)
    if Abysall and Abysall.Environment.cloneref then
        return Abysall.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

if Abysall.Environment.writefile and Abysall.Environment.readfile then
    if not Abysall.Environment.isfile("Abysall/UserData.json") then
        local Data = {
            TotalExecutions = 0,
            UILibrary = "Obsidian"
        }
        Abysall.Environment.writefile("Abysall/UserData.json", Services.HttpService:JSONEncode(Data))
    end

    local UserData = Abysall.Environment.readfile("Abysall/UserData.json")
    local Decoded = Services.HttpService:JSONDecode(UserData)
    if not Decoded.TotalExecutions then
        Decoded.TotalExecutions = 0    
    end

    Decoded.TotalExecutions = Decoded.TotalExecutions + 1

    if not Decoded.UILibrary then
        Decoded.UILibrary = "Obsidian"
    end

    Abysall.TotalExecutions = Decoded.TotalExecutions
    Abysall.UILibrary = Decoded.UILibrary

    Abysall.Environment.writefile("Abysall/UserData.json", Services.HttpService:JSONEncode(Decoded))
end

Abysall.Interface = loadstring(game:HttpGet(BaseUrl .. "Components/Interface.luau"))()
Abysall.Analytics = loadstring(game:HttpGet(BaseUrl .. "Components/Analytics.luau"))()

local CurrentGame = GameList[game.GameId]
if CurrentGame then
    loadstring(game:HttpGet(BaseUrl .. "Games/" .. CurrentGame .. "/Loader.luau"))()
else
    loadstring(game:HttpGet(BaseUrl .. "Games/Universal/Loader.luau"))()
end
