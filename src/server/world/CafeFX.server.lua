local Workspace = game:GetService("Workspace")

local cafe = Workspace:WaitForChild("WitchCafe", 30)
if not cafe then
    warn("CafeFX: no se encontro WitchCafe.")
    return
end

local decor = cafe:WaitForChild("Decoracion", 30)
if not decor then
    warn("CafeFX: no se encontro Decoracion.")
    return
end

-- Limpiar efectos anteriores
local old = cafe:FindFirstChild("Efectos")
if old then old:Destroy() end

local fx = Instance.new("Folder")
fx.Name = "Efectos"
fx.Parent = cafe

local green = Color3.fromRGB(83, 205, 139)
local gold = Color3.fromRGB(255, 205, 130)
local lavender = Color3.fromRGB(207, 160, 255)

-- Caldero
local potion = cafe:FindFirstChild("Pocion brillante")
if potion then
    local bubbles = Instance.new("ParticleEmitter")
    bubbles.Color = ColorSequence.new(green)
    bubbles.LightEmission = 1
    bubbles.Rate = 14
    bubbles.Lifetime = NumberRange.new(1.5, 2.5)
    bubbles.Speed = NumberRange.new(2, 4)
    bubbles.SpreadAngle = Vector2.new(15, 15)
    bubbles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 0),
    })
    bubbles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1),
    })
    bubbles.Parent = potion

    local glowLight = Instance.new("PointLight")
    glowLight.Color = green
    glowLight.Brightness = 3
    glowLight.Range = 14
    glowLight.Parent = potion
end

-- Polvo

local dustVolume = Instance.new("Part")
dustVolume.Name = "Volumen de polvo magico"
dustVolume.Size = Vector3.new(56, 12, 46)
dustVolume.Position = Vector3.new(0, 8, 0)
dustVolume.Anchored = true
dustVolume.CanCollide = false
dustVolume.CanQuery = false
dustVolume.CanTouch = false
dustVolume.Transparency = 1
dustVolume.Parent = fx

local dust = Instance.new("ParticleEmitter")
dust.Shape = Enum.ParticleEmitterShape.Box
dust.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
dust.Color = ColorSequence.new(gold, lavender)
dust.LightEmission = 1
dust.Rate = 8
dust.Lifetime = NumberRange.new(6, 10)
dust.Speed = NumberRange.new(0.2, 0.8)
dust.SpreadAngle = Vector2.new(180, 180)
dust.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.5, 0.25),
    NumberSequenceKeypoint.new(1, 0),
})
dust.Transparency = NumberSequence.new(0.3)
dust.Parent = dustVolume

-- Faroles parpadeo

local flickers = {}
for _, inst in ipairs(decor:GetChildren()) do
    if inst.Name == "Farol dorado" or inst.Name == "Luz de mesa" then
        local light = inst:FindFirstChildOfClass("PointLight")
        if light then
            table.insert(flickers, { light = light, base = light.Brightness })
        end
    end
end

task.spawn(function()
    while true do
        for _, f in ipairs(flickers) do
            f.light.Brightness = f.base * (0.8 + math.random() * 0.4)
        end
        task.wait(0.12)
    end
end)

print("CafeFX: efectos creados correctamente.")