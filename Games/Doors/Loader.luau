local BaseUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/"
if game.PlaceId ~= 6516141723 then
    loadstring(F1xGet(BaseUrl .. "Games/Doors/Main.luau"))()
else
    loadstring(F1xGet(BaseUrl .. "Games/Doors/Lobby.luau"))()
end
