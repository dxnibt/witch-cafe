
local Workspace = game:GetService("Workspace")

local existingCafe = Workspace:FindFirstChild("WitchCafe")
if existingCafe then
    existingCafe:Destroy()
end

local cafe = Instance.new("Folder")
cafe.Name = "WitchCafe"
cafe.Parent = Workspace

-- Colores 
local wood = Color3.fromRGB(91, 55, 43)
local darkWood = Color3.fromRGB(43, 29, 35)
local purple = Color3.fromRGB(135, 78, 190)
local lavender = Color3.fromRGB(202, 153, 255)
local green = Color3.fromRGB(83, 205, 139)
local gold = Color3.fromRGB(245, 190, 105)
local black = Color3.fromRGB(30, 25, 36)


local function makePart(name, size, position, color, material)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.Position = position
    part.Color = color
    part.Material = material or Enum.Material.SmoothPlastic
    part.Anchored = true
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = cafe
    return part
end

local function makeNeon(name, size, position, color)
    return makePart(name, size, position, color, Enum.Material.Neon)
end

-- Piso
makePart(
    "Suelo de madera",
    Vector3.new(60, 1, 50),
    Vector3.new(0, -0.5, 0),
    wood,
    Enum.Material.WoodPlanks
)

-- Pared trasera y paredes laterales
makePart("Pared trasera", Vector3.new(60, 18, 1),
    Vector3.new(0, 8.5, -25), darkWood, Enum.Material.WoodPlanks)

makePart("Pared izquierda", Vector3.new(1, 18, 50),
    Vector3.new(-30, 8.5, 0), darkWood, Enum.Material.WoodPlanks)

makePart("Pared derecha", Vector3.new(1, 18, 50),
    Vector3.new(30, 8.5, 0), darkWood, Enum.Material.WoodPlanks)

-- Pared trasera.
makeNeon("Luz morada superior", Vector3.new(50, 0.18, 0.18),
    Vector3.new(0, 16, -24.35), purple)

makeNeon("Luz verde superior", Vector3.new(16, 0.12, 0.12),
    Vector3.new(0, 15.5, -24.25), green)

-- Mostrador principal.
makePart("Base del mostrador", Vector3.new(24, 4, 3),
    Vector3.new(0, 2, 8), darkWood, Enum.Material.WoodPlanks)

makePart("Cubierta del mostrador", Vector3.new(25, 0.6, 4),
    Vector3.new(0, 4.3, 8), wood, Enum.Material.Wood)

makeNeon("Franja mágica del mostrador", Vector3.new(20, 0.15, 0.12),
    Vector3.new(0, 2.5, 6.47), lavender)

-- Estación para preparar bebidas.
makePart("Mesa de pociones", Vector3.new(12, 3, 4),
    Vector3.new(0, 1.5, -5), wood, Enum.Material.WoodPlanks)

makePart("Cubierta de pociones", Vector3.new(13, 0.5, 4.5),
    Vector3.new(0, 3.25, -5), darkWood, Enum.Material.Wood)

-- Caldero
local cauldron = makePart("Caldero magico",
    Vector3.new(3, 2, 3),
    Vector3.new(0, 4.5, -5), black, Enum.Material.Metal)

cauldron.Shape = Enum.PartType.Ball

makeNeon("Pocion brillante", Vector3.new(1.5, 0.25, 1.5),
    Vector3.new(0, 5.25, -5), green)

-- Estantes traseros
for _, y in ipairs({5, 9}) do
    makePart("Estante de madera", Vector3.new(22, 0.5, 2),
        Vector3.new(0, y, -22), wood, Enum.Material.Wood)
end

-- Frascos de pociones
local potionColors = {purple, green, lavender, gold}

for shelfIndex, y in ipairs({6, 10}) do
    for i = 1, 9 do
        local x = -9 + (i - 1) * 2.25
        local color = potionColors[((i + shelfIndex - 2) % #potionColors) + 1]

        makePart(
            "Frasco de pocion",
            Vector3.new(0.8, 1.2, 0.8),
            Vector3.new(x, y, -22),
            color,
            Enum.Material.Glass
        )

        makePart(
            "Tapon del frasco",
            Vector3.new(0.4, 0.25, 0.4),
            Vector3.new(x, y + 0.7, -22),
            gold,
            Enum.Material.Metal
        )
    end
end

-- Columnas decorativas 
for _, x in ipairs({-10, 10}) do
    makePart("Columna decorativa", Vector3.new(0.4, 5, 0.4),
        Vector3.new(x, 2.5, 5.8), purple)
end

-- Iluminacion 
local lightPart = makeNeon(
    "Lampara magica",
    Vector3.new(2, 0.3, 2),
    Vector3.new(0, 13, 0),
    lavender
)

local light = Instance.new("PointLight")
light.Color = lavender
light.Brightness = 2
light.Range = 24
light.Parent = lightPart

print("cafeteria construida correctamente.")
