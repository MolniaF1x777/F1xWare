if getgenv().F1xWareLoaded then return end
getgenv().F1xWareLoaded = true

local BaseUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/"

local function LoadFile(path)
    local success, content = pcall(function()
        return game:HttpGet(BaseUrl .. path)
    end)
    
    if success and content then
        local func = loadstring(content)
        if func then
            return func()
        end
    else
        warn("Ошибка загрузки: " .. path)
    end
end

getgenv().Environment = LoadFile("Components/Environment.luau")
getgenv().ESPLibrary = LoadFile("Components/ESP.luau")
getgenv().Interface = LoadFile("Components/Interface.luau")

if game.PlaceId == 6516141723 then
    LoadFile("Games/Doors/Lobby.luau")
else
    LoadFile("Games/Doors/Main.luau")
end
