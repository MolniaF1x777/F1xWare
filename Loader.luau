if Abysall then
    return
end
getgenv().Abysall = {
    Legit = true
}

local RepoUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/"

local HasFS = type(writefile) == "function" and type(readfile) == "function"
    and type(isfile) == "function" and type(isfolder) == "function"
    and type(makefolder) == "function"

local CacheDir
if HasFS then
    pcall(function()
        if not isfolder("F1xWare") then makefolder("F1xWare") end

        local Version
        local Ok, Remote = pcall(game.HttpGet, game, RepoUrl .. "version.txt")
        if Ok and type(Remote) == "string" and #Remote < 20 and Remote:sub(1, 4) ~= "404:" then
            Version = (Remote:gsub("%s+", ""))
            writefile("F1xWare/version.txt", Version)
        elseif isfile("F1xWare/version.txt") then
            Version = readfile("F1xWare/version.txt")
        end

        if Version and #Version > 0 then
            CacheDir = "F1xWare/cache_" .. Version
            if not isfolder(CacheDir) then makefolder(CacheDir) end
        end
    end)
end

getgenv().F1xGet = function(Url)
    local Path
    if CacheDir then
        Path = CacheDir .. "/" .. (Url:gsub("^https?://", ""):gsub("[^%w]", "_"))
        if isfile(Path) then
            local Cached = readfile(Path)
            if #Cached > 0 then
                return Cached
            end
        end
    end

    local Source = game:HttpGet(Url)
    if Source:sub(1, 4) == "404:" or #Source == 0 then
        error("F1xWare: failed to download " .. Url)
    end
    if Path then
        pcall(writefile, Path, Source)
    end
    return Source
end

local GameList = {
    [2440500124] = "Doors"
}

local BaseUrl = RepoUrl
getgenv().Abysall = {
    Environment = loadstring(F1xGet(BaseUrl .. "Components/Environment.luau"))(),
    ESPLibrary = loadstring(F1xGet(BaseUrl .. "Components/ESP.luau"))(),

    Legit = true,
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
    if Abysall.Environment.makefolder and Abysall.Environment.isfolder
        and not Abysall.Environment.isfolder("Abysall") then
        Abysall.Environment.makefolder("Abysall")
    end

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

Abysall.Interface = loadstring(F1xGet(BaseUrl .. "Components/Interface.luau"))()
Abysall.Analytics = loadstring(F1xGet(BaseUrl .. "Components/Analytics.luau"))()

local CurrentGame = GameList[game.GameId]
if CurrentGame then
    loadstring(F1xGet(BaseUrl .. "Games/" .. CurrentGame .. "/Loader.luau"))()
else
    loadstring(F1xGet(BaseUrl .. "Games/Universal/Loader.luau"))()
end
