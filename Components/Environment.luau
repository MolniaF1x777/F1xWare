local getgenv = getgenv or function() return _G end

getgenv().F1xWare = getgenv().F1xWare or {}
local F1xWare = getgenv().F1xWare

local cloneref = cloneref or function(obj) return obj end

local Environment = {
    BaseUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/",
    Connections = {},
    Instances = {},
    Hooks = {},
    Services = setmetatable({}, {
        __index = function(self, serviceName)
            local service = cloneref(game:GetService(serviceName))
            rawset(self, serviceName, service)
            return service
        end
    })
}

local Players = Environment.Services.Players
Environment.LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
Environment.Character = Environment.LocalPlayer.Character or Environment.LocalPlayer.CharacterAdded:Wait()
Environment.Humanoid = Environment.Character:WaitForChild("Humanoid", 10)
Environment.RootPart = Environment.Character:WaitForChild("HumanoidRootPart", 10)
Environment.Camera = workspace.CurrentCamera

Environment.LocalPlayer.CharacterAdded:Connect(function(char)
    Environment.Character = char
    Environment.Humanoid = char:WaitForChild("Humanoid", 10)
    Environment.RootPart = char:WaitForChild("HumanoidRootPart", 10)
end)

function Environment:AddConnection(connection)
    table.insert(self.Connections, connection)
    return connection
end

function Environment:SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[F1xWare Error]:", result)
    end
    return success, result
end

function Environment:Unload()
    for _, conn in ipairs(self.Connections) do
        if typeof(conn) == "RBXScriptConnection" and conn.Connected then
            conn:Disconnect()
        end
    end
    table.clear(self.Connections)

    for _, inst in ipairs(self.Instances) do
        if inst and inst.Parent then
            inst:Destroy()
        end
    end
    table.clear(self.Instances)

    for originalFunc, hookedFunc in pairs(self.Hooks) do
        if hookfunction and type(originalFunc) == "function" then
            hookfunction(hookedFunc, originalFunc)
        end
    end
    table.clear(self.Hooks)
end

F1xWare.Environment = Environment
getgenv().Environment = Environment
return Environment
