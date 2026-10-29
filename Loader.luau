repeat task.wait() until game:IsLoaded()

local BaseUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/"

local HttpService = game:GetService("HttpService")

if not isfolder("F1xWare") then
    makefolder("F1xWare")
end

if not isfile("F1xWare/UserData.json") then
    writefile("F1xWare/UserData.json", HttpService:JSONEncode({
        ["CustomTheme"] = false,
        ["FirstLoaded"] = os.time(),
        ["TotalLoads"] = 0
    }))
end

local UserData = HttpService:JSONDecode(readfile("F1xWare/UserData.json"))
UserData["TotalLoads"] = (UserData["TotalLoads"] or 0) + 1
writefile("F1xWare/UserData.json", HttpService:JSONEncode(UserData))

loadstring(game:HttpGet(BaseUrl .. "Components/Environment.luau"))()
loadstring(game:HttpGet(BaseUrl .. "Components/ESP.luau"))()
loadstring(game:HttpGet(BaseUrl .. "Components/Interface.luau"))()
loadstring(game:HttpGet(BaseUrl .. "Components/Analytics.luau"))()

local Games = {
    [6516141723] = "Doors",
    [6839171747] = "Doors",
}

local CurrentGame = Games[game.PlaceId]
if CurrentGame then
    loadstring(game:HttpGet(BaseUrl .. "Games/" .. CurrentGame .. "/Loader.luau"))()
end
