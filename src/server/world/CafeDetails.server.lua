local Workspace = game:GetService("Workspace")

local cafe = Workspace:WaitForChild("WitchCafe", 30)
if not cafe then
    warn("CafeDetails: no se encontro WitchCafe.")
    return
end

local old = cafe:FindFirstChild("Detalles")
if old then old:Destroy() end

local detalles = Instance.new("Folder")
detalles.Name = "Detalles"
detalles.Parent = cafe

-- Colores
local wood = Color3.fromRGB(105, 66, 49)
local darkWood = Color3.fromRGB(43, 29, 35)
local purple = Color3.fromRGB(133, 79, 190)
local deepPurple = Color3.fromRGB(70, 38, 110)
local lavender = Color3.fromRGB(207, 160, 255)
local gold = Color3.fromRGB(255, 190, 105)
local skyBlue = Color3.fromRGB(95, 70, 200)
local greens = {
    Color3.fromRGB(60, 150, 95),
    Color3.fromRGB(80, 185, 115),
    Color3.fromRGB(45, 120, 80),
}

local rng = Random.new(7) -- semilla fija

local function part(name, size, cframe, color, material, collide)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cframe
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = true
    p.CanCollide = collide or false
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = detalles
    return p
end

local function floorDisc(name, diameter, height, pos, color, material)
    local p = part(
        name,
        Vector3.new(height, diameter, diameter),
        CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90)),
        color,
        material
    )
    p.Shape = Enum.PartType.Cylinder
    return p
end

local function wallDiscZ(name, diameter, thickness, pos, color, material)
    local p = part(
        name,
        Vector3.new(thickness, diameter, diameter),
        CFrame.new(pos) * CFrame.Angles(0, math.rad(90), 0),
        color,
        material
    )
    p.Shape = Enum.PartType.Cylinder
    return p
end

local function wallDiscX(name, diameter, thickness, pos, color, material)
    local p = part(
        name,
        Vector3.new(thickness, diameter, diameter),
        CFrame.new(pos),
        color,
        material
    )
    p.Shape = Enum.PartType.Cylinder
    return p
end


-- Techo

part("Techo", Vector3.new(62, 1, 52), CFrame.new(0, 18, 0),
    darkWood, Enum.Material.WoodPlanks)

-- Pared con puerta

part("Pared frontal izquierda", Vector3.new(25.5, 18, 1),
    CFrame.new(-17.75, 8.5, 25), darkWood, Enum.Material.WoodPlanks, true)

part("Pared frontal derecha", Vector3.new(25.5, 18, 1),
    CFrame.new(17.75, 8.5, 25), darkWood, Enum.Material.WoodPlanks, true)

part("Dintel de la puerta", Vector3.new(10, 6.5, 1),
    CFrame.new(0, 14.25, 25), darkWood, Enum.Material.WoodPlanks, true)

for _, x in ipairs({-5.4, 5.4}) do
    part("Marco de puerta", Vector3.new(0.8, 11, 1.4),
        CFrame.new(x, 5.5, 24.6), wood, Enum.Material.Wood, true)
end

part("Travesano de puerta", Vector3.new(11.6, 0.8, 1.4),
    CFrame.new(0, 11.4, 24.6), wood, Enum.Material.Wood)

part("Luz de puerta", Vector3.new(10, 0.15, 0.15),
    CFrame.new(0, 10.9, 24.0), lavender, Enum.Material.Neon)

-- Spawn

local spawn = Instance.new("SpawnLocation")
spawn.Name = "WitchCafeSpawn"
spawn.Size = Vector3.new(6, 1, 6)
spawn.Position = Vector3.new(0, 0.5, 19)
spawn.Anchored = true
spawn.CanCollide = false
spawn.Transparency = 1
spawn.Neutral = true
spawn.Duration = 0
spawn.Parent = detalles

-- Ventanas

local function makeWindow(side, z)
    local frameX = side * 29.35
    local paneX = side * 29.2
    local starX = side * 29.12
    local barX = side * 29.1

    -- Marco
    part("Marco de ventana", Vector3.new(0.3, 8.8, 5.8),
        CFrame.new(frameX, 8.6, z), wood, Enum.Material.Wood)
    wallDiscX("Marco arco", 5.8, 0.3,
        Vector3.new(frameX, 13, z), wood, Enum.Material.Wood)

    -- Cristal luminoso
    local pane = part("Cristal de ventana", Vector3.new(0.1, 8, 5),
        CFrame.new(paneX, 9, z), skyBlue, Enum.Material.Neon)
    wallDiscX("Cristal arco", 5, 0.1,
        Vector3.new(paneX, 13, z), skyBlue, Enum.Material.Neon)

    local glow = Instance.new("PointLight")
    glow.Color = lavender
    glow.Brightness = 1.5
    glow.Range = 18
    glow.Parent = pane

    -- Estrellitas en el cristal
    for _ = 1, 4 do
        part("Estrella de ventana", Vector3.new(0.05, 0.3, 0.3),
            CFrame.new(starX, rng:NextNumber(6, 14), z + rng:NextNumber(-2, 2)),
            Color3.fromRGB(255, 240, 200), Enum.Material.Neon)
    end

    -- Barrotes
    part("Barrote vertical", Vector3.new(0.2, 10.5, 0.25),
        CFrame.new(barX, 10.25, z), darkWood, Enum.Material.Wood)
    for _, y in ipairs({8, 11.5}) do
        part("Barrote horizontal", Vector3.new(0.2, 0.25, 5.2),
            CFrame.new(barX, y, z), darkWood, Enum.Material.Wood)
    end
end

for _, side in ipairs({-1, 1}) do
    for _, z in ipairs({-15, 15}) do
        makeWindow(side, z)
    end
end

-- Menu

part("Marco de la pizarra", Vector3.new(13, 8.4, 0.35),
    CFrame.new(-20, 9.5, -24.3), wood, Enum.Material.Wood)

local board = part("Pizarra", Vector3.new(12.2, 7.6, 0.12),
    CFrame.new(-20, 9.5, -24.1), Color3.fromRGB(30, 24, 40),
    Enum.Material.SmoothPlastic)

local gui = Instance.new("SurfaceGui")
gui.Name = "MenuGui"
gui.Face = Enum.NormalId.Back
gui.CanvasSize = Vector2.new(1220, 760)
gui.LightInfluence = 0
gui.Parent = board

local title = Instance.new("TextLabel")
title.Name = "Titulo"
title.Size = UDim2.fromScale(0.9, 0.16)
title.Position = UDim2.fromScale(0.05, 0.04)
title.BackgroundTransparency = 1
title.Text = "Nuestras bebidas mágicas"
title.TextColor3 = lavender
title.Font = Enum.Font.Fantasy
title.TextScaled = true
title.Parent = gui

local drinks = {
    "Latte de luna",
    "Chocolate de dragón",
    "Poción de amor",
    "Frappé de mora encantada",
    "Té de estrellas",
}

for i, drink in ipairs(drinks) do
    local label = Instance.new("TextLabel")
    label.Name = "Bebida" .. i
    label.Size = UDim2.fromScale(0.85, 0.12)
    label.Position = UDim2.fromScale(0.08, 0.25 + (i - 1) * 0.14)
    label.BackgroundTransparency = 1
    label.Text = "✦ " .. drink
    label.TextColor3 = Color3.fromRGB(255, 235, 200)
    label.Font = Enum.Font.Fantasy
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = gui
end

-- Estandartes

local function makeBanner(x)
    part("Asta del estandarte", Vector3.new(4.2, 0.25, 0.25),
        CFrame.new(x, 15.2, -24.3), gold, Enum.Material.Metal)

    part("Estandarte", Vector3.new(3.4, 8, 0.12),
        CFrame.new(x, 11, -24.35), purple, Enum.Material.Fabric)

    part("Borde del estandarte", Vector3.new(3.4, 0.2, 0.14),
        CFrame.new(x, 7.1, -24.34), gold, Enum.Material.Metal)

    -- Luna creciente: disco dorado + disco morado desplazado
    wallDiscZ("Luna del estandarte", 2, 0.1,
        Vector3.new(x, 11.5, -24.26), gold, Enum.Material.Neon)
    wallDiscZ("Recorte de luna", 1.7, 0.1,
        Vector3.new(x + 0.45, 11.7, -24.24), purple, Enum.Material.Fabric)

    for _, offset in ipairs({
        Vector3.new(-0.9, 9.3, 0),
        Vector3.new(0.7, 8.6, 0),
        Vector3.new(0.1, 9.9, 0),
    }) do
        part("Estrella del estandarte", Vector3.new(0.3, 0.3, 0.05),
            CFrame.new(x + offset.X, offset.Y, -24.27), gold, Enum.Material.Neon)
    end
end

makeBanner(19)
makeBanner(25)

-- Alfombra

local rugCenter = Vector3.new(0, 0, 16)

floorDisc("Alfombra borde", 16, 0.08,
    rugCenter + Vector3.new(0, 0.04, 0), lavender, Enum.Material.Fabric)
floorDisc("Alfombra base", 15.2, 0.1,
    rugCenter + Vector3.new(0, 0.05, 0), deepPurple, Enum.Material.Fabric)
floorDisc("Alfombra anillo", 12, 0.12,
    rugCenter + Vector3.new(0, 0.06, 0), lavender, Enum.Material.Fabric)
floorDisc("Alfombra centro", 11.4, 0.14,
    rugCenter + Vector3.new(0, 0.07, 0), deepPurple, Enum.Material.Fabric)

floorDisc("Luna de alfombra", 5, 0.16,
    rugCenter + Vector3.new(0, 0.08, 0), gold, Enum.Material.Neon)
floorDisc("Recorte de luna de alfombra", 4.4, 0.18,
    rugCenter + Vector3.new(1.1, 0.09, 0.3), deepPurple, Enum.Material.Fabric)

for i = 1, 8 do
    local angle = math.rad(i * 45)
    floorDisc("Estrella de alfombra", 0.4, 0.2,
        rugCenter + Vector3.new(math.cos(angle) * 5.3, 0.1, math.sin(angle) * 5.3),
        gold, Enum.Material.Neon)
end

-- Lianas

local function makeVine(x, z)
    local length = rng:NextNumber(3, 8)

    part("Liana", Vector3.new(0.12, length, 0.12),
        CFrame.new(x, 17.5 - length / 2, z), greens[3], Enum.Material.SmoothPlastic)

    local leaves = math.floor(length * 1.2)
    for _ = 1, leaves do
        local size = rng:NextNumber(0.5, 0.9)
        local leaf = part("Hoja", Vector3.new(size, size, size),
            CFrame.new(
                x + rng:NextNumber(-0.35, 0.35),
                17.5 - rng:NextNumber(0.3, length),
                z + rng:NextNumber(-0.35, 0.35)
            ),
            greens[rng:NextInteger(1, #greens)], Enum.Material.Grass)
        leaf.Shape = Enum.PartType.Ball
        leaf.CastShadow = false
    end
end

-- Pared trasera 
for x = -26, 26, 4 do
    if math.abs(x) >= 14 then
        makeVine(x, -23.8)
    end
end

-- Paredes laterales
for z = -20, 20, 5 do
    makeVine(-28.8, z)
    makeVine(28.8, z)
end

for _, pos in ipairs({
    Vector3.new(-8, -12, 0), Vector3.new(9, -10, 0),
    Vector3.new(-10, 10, 0), Vector3.new(11, 14, 0),
    Vector3.new(0, 20, 0), Vector3.new(-14, 2, 0),
}) do
    makeVine(pos.X, pos.Y)
end

print("CafeDetails: detalles creados correctamente.")