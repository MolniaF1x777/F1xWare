if getgenv().F1xWare and getgenv().F1xWare.Loaded then
    return
end

getgenv().F1xWare = {
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
            
            -- ОЧИСТКА СТАРЫХ ПАПОК КЭША
            if type(delfolder) == "function" and type(listfiles) == "function" then
                pcall(function()
                    for _, file in ipairs(listfiles("F1xWare")) do
                        if file:match("cache_") and file ~= CacheDir then
                            delfolder(file)
                        end
                    end
                end)
            end

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
getgenv().F1xWare = {
    Environment = loadstring(F1xGet(BaseUrl .. "Components/Environment.luau"))(),
    ESPLibrary = loadstring(F1xGet(BaseUrl .. "Components/ESP.luau"))(),
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
    if F1xWare.Environment.makefolder and F1xWare.Environment.isfolder
        and not F1xWare.Environment.isfolder("F1xWare") then
        F1xWare.Environment.makefolder("F1xWare")
    end

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

F1xWare.Interface = loadstring(F1xGet(BaseUrl .. "Components/Interface.luau"))()
F1xWare.Analytics = loadstring(F1xGet(BaseUrl .. "Components/Analytics.luau"))()

local CurrentGame = GameList[game.GameId]
if CurrentGame then
    loadstring(F1xGet(BaseUrl .. "Games/" .. CurrentGame .. "/Loader.luau"))()
else
    loadstring(F1xGet(BaseUrl .. "Games/Universal/Loader.luau"))()
end