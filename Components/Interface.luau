local BaseUrl = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
local F1xWareUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/"
local Interface = {}

local function Fetch(Url)
	for _ = 1, 3 do
		local Success, Result = pcall(function()
			if F1xGet then
				return F1xGet(Url)
			end
			return game:HttpGet(Url)
		end)
		if Success and type(Result) == "string" and #Result > 0 and Result:sub(1, 4) ~= "404:" then
			return Result
		end
		task.wait(0.5)
	end
	return nil
end

local function Load(Url)
	local Source = Fetch(Url)
	if not Source then
		error("F1xWare: failed to download " .. Url)
	end
	local Chunk, CompileError = loadstring(Source)
	if not Chunk then
		error("F1xWare: " .. tostring(CompileError) .. " in " .. Url)
	end
	local Success, Result = pcall(Chunk)
	if not Success then
		error("F1xWare: " .. tostring(Result) .. " in " .. Url)
	end
	return Result
end

Interface.Library = Load(BaseUrl .. "Library.lua")
Interface.SaveManager = Load(BaseUrl .. "addons/SaveManager.lua")
Interface.ThemeManager = Load(BaseUrl .. "addons/ThemeManager.lua")
Interface.ApplyInfoTab = Load(F1xWareUrl .. "Components/InfoTab.luau")
Interface.ApplySettingsTab = Load(F1xWareUrl .. "Components/SettingsTab.luau")

Interface.ThemeManager.BuiltInThemes = {
	["Default"]      = { 1,  { FontColor = "ffffff", MainColor = "2b2138", AccentColor = "e5b3ff", BackgroundColor = "1a1225", OutlineColor = "3d2f52" } },
	["Classic Blue"] = { 2,  { FontColor = "ffffff", MainColor = "1c1c1c", AccentColor = "0055ff", BackgroundColor = "141414", OutlineColor = "323232" } },
	["BBot"]         = { 3,  { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414" } },
	["Fatality"]     = { 4,  { FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d" } },
	["Jester"]       = { 5,  { FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737" } },
	["Mint"]         = { 6,  { FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737" } },
	["Tokyo Night"]  = { 7,  { FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232" } },
	["Ubuntu"]       = { 8,  { FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919" } },
	["Quartz"]       = { 9,  { FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f" } },
	["Nord"]         = { 10, { FontColor = "eceff4", MainColor = "3b4252", AccentColor = "88c0d0", BackgroundColor = "2e3440", OutlineColor = "4c566a" } },
	["Dracula"]      = { 11, { FontColor = "f8f8f2", MainColor = "44475a", AccentColor = "ff79c6", BackgroundColor = "282a36", OutlineColor = "6272a4" } },
	["Monokai"]      = { 12, { FontColor = "f8f8f2", MainColor = "272822", AccentColor = "f92672", BackgroundColor = "1e1f1c", OutlineColor = "49483e" } },
	["Gruvbox"]      = { 13, { FontColor = "ebdbb2", MainColor = "3c3836", AccentColor = "fb4934", BackgroundColor = "282828", OutlineColor = "504945" } },
	["Solarized"]    = { 14, { FontColor = "839496", MainColor = "073642", AccentColor = "cb4b16", BackgroundColor = "002b36", OutlineColor = "586e75" } },
	["Catppuccin"]   = { 15, { FontColor = "d9e0ee", MainColor = "302d41", AccentColor = "f5c2e7", BackgroundColor = "1e1e2e", OutlineColor = "575268" } },
	["One Dark"]     = { 16, { FontColor = "abb2bf", MainColor = "282c34", AccentColor = "c678dd", BackgroundColor = "21252b", OutlineColor = "5c6370" } },
	["Cyberpunk"]    = { 17, { FontColor = "f9f9f9", MainColor = "262335", AccentColor = "00ff9f", BackgroundColor = "1a1a2e", OutlineColor = "413c5e" } },
	["Oceanic Next"] = { 18, { FontColor = "d8dee9", MainColor = "1b2b34", AccentColor = "6699cc", BackgroundColor = "16232a", OutlineColor = "343d46" } },
	["Material"]     = { 19, { FontColor = "eeffff", MainColor = "212121", AccentColor = "82aaff", BackgroundColor = "151515", OutlineColor = "424242" } }
}

local function Symbolize(Title)
	local Symbol = type(Title) == "string" and Interface.Symbols[Title]
	if Symbol then
		return Symbol .. "  " .. Title
	end
	return Title
end

local function WrapTabbox(Tabbox)
	if type(Tabbox) == "table" and type(Tabbox.AddTab) == "function" then
		local OldAddTab = Tabbox.AddTab
		Tabbox.AddTab = function(Self, Title, ...)
			return OldAddTab(Self, Symbolize(Title), ...)
		end
	end
	return Tabbox
end

local function WrapTab(Tab)
	if type(Tab) ~= "table" then
		return Tab
	end
	for _, Method in { "AddLeftGroupbox", "AddRightGroupbox" } do
		local Old = Tab[Method]
		if type(Old) == "function" then
			Tab[Method] = function(Self, Title, ...)
				return Old(Self, Symbolize(Title), ...)
			end
		end
	end
	for _, Method in { "AddLeftTabbox", "AddRightTabbox" } do
		local Old = Tab[Method]
		if type(Old) == "function" then
			Tab[Method] = function(Self, Title, ...)
				return WrapTabbox(Old(Self, Symbolize(Title), ...))
			end
		end
	end
	return Tab
end

pcall(function()
	local Library = Interface.Library
	local OldCreateWindow = Library.CreateWindow
	Library.CreateWindow = function(Self, ...)
		local Window = OldCreateWindow(Self, ...)
		local OldAddTab = Window.AddTab
		if type(OldAddTab) == "function" then
			Window.AddTab = function(WindowSelf, ...)
				return WrapTab(OldAddTab(WindowSelf, ...))
			end
		end
		return Window
	end
end)

return Interface