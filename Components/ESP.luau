local BaseUrl = "https://raw.githubusercontent.com/MolniaF1x777/F1xWare/refs/heads/main/"

local ESP = {
    BaseUrl = BaseUrl,
    Enabled = false,
    Boxes = false,
    Tracers = false,
    Names = false,
    Distance = false,
    Items = {},
    Drawings = {},
    Color = Color3.fromRGB(215, 35, 35)
}

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

function ESP:Add(object, text, color)
    if self.Items[object] then return end

    local drawing = Drawing.new("Text")
    drawing.Visible = false
    drawing.Center = true
    drawing.Outline = true
    drawing.Font = 2
    drawing.Size = 13
    drawing.Color = color or self.Color
    drawing.Text = text or object.Name

    self.Items[object] = {
        Drawing = drawing,
        Object = object,
        Text = text or object.Name
    }
end

function ESP:Remove(object)
    if self.Items[object] then
        if self.Items[object].Drawing then
            self.Items[object].Drawing:Remove()
        end
        self.Items[object] = nil
    end
end

RunService.RenderStepped:Connect(function()
    for obj, data in pairs(ESP.Items) do
        if not obj or not obj.Parent then
            ESP:Remove(obj)
        else
            local pos = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position or obj:GetPivot().Position) or (obj:IsA("BasePart") and obj.Position)
            if pos then
                local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
                if onScreen and ESP.Enabled then
                    data.Drawing.Position = Vector2.new(screenPos.X, screenPos.Y)
                    data.Drawing.Visible = true
                else
                    data.Drawing.Visible = false
                end
            else
                data.Drawing.Visible = false
            end
        end
    end
end)

getgenv().ESP = ESP
return ESP
