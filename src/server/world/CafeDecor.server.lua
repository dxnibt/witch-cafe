
local Workspace = game:GetService("Workspace")

-- Esperar a que CafeBuilder cree el escenario.
local cafe = Workspace:WaitForChild("WitchCafe", 30)

if not cafe then
    warn("CafeDecor: no se encontro WitchCafe.")
    return
end

-- Limpiar solo nuestra propia decoracion.
local oldDecor = cafe:FindFirstChild("Decoracion")
if oldDecor then
    oldDecor:Destroy()
end

local decor = Instance.new("Folder")
decor.Name = "Decoracion"
decor.Parent = cafe

local wood = Color3.fromRGB(105, 66, 49)
local dark = Color3.fromRGB(47, 31, 43)
local purple = Color3.fromRGB(133, 79, 190)
local lavender = Color3.fromRGB(207, 160, 255)
local gold = Color3.fromRGB(255, 190, 105)
local green = Color3.fromRGB(70, 170, 112)

local function part(name, size, pos, color, material, shape)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = pos
    p.Anchored = true
    p.CanCollide = false
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth

    if shape then
        p.Shape = shape
    end

    p.Parent = decor
    return p
end

local function glow(name, pos, color, brightness, range)
    local lamp = part(
        name,
        Vector3.new(0.65, 0.65, 0.65),
        pos,
        color,
        Enum.Material.Neon,
        Enum.PartType.Ball
    )

    local light = Instance.new("PointLight")
    light.Color = color
    light.Brightness = brightness
    light.Range = range
    light.Shadows = true
    light.Parent = lamp

    return lamp
end

-- Cartel principal: sobre el mostrador y delante de los estantes.
part(
    "Marco del letrero",
    Vector3.new(13, 3.5, 0.35),
    Vector3.new(0, 12.8, -20.8),
    wood,
    Enum.Material.Wood
)

part(
    "Interior del letrero",
    Vector3.new(12.4, 2.9, 0.12),
    Vector3.new(0, 12.8, -20.55),
    dark,
    Enum.Material.SmoothPlastic
)


-- Nombre de la cafeteria en el letrero.
local signPart = decor:FindFirstChild("Interior del letrero")

if signPart then
    local oldGui = signPart:FindFirstChild("NombreWitchCafe")
    if oldGui then
        oldGui:Destroy()
    end

    local surface = Instance.new("SurfaceGui")
    surface.Name = "NombreWitchCafe"
    surface.Face = Enum.NormalId.Back
    surface.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
    surface.CanvasSize = Vector2.new(1000, 240)
    surface.LightInfluence = 0
    surface.Adornee = signPart
    surface.Parent = signPart

    local title = Instance.new("TextLabel")
    title.Name = "Titulo"
    title.Size = UDim2.fromScale(1, 1)
    title.BackgroundTransparency = 1
    title.Text = "WITCH CAFÉ"
    title.TextColor3 = Color3.fromRGB(245, 205, 255)
    title.TextStrokeColor3 = Color3.fromRGB(100, 50, 150)
    title.TextStrokeTransparency = 0.25
    title.Font = Enum.Font.Fantasy
    title.TextScaled = true
    title.Parent = surface
else
    warn("CafeDecor: no se encontro el letrero.")
end

-- Luna decorativa 
part(
    "Luna magica",
    Vector3.new(1.25, 1.25, 1.25),
    Vector3.new(0, 15.3, -20.7),
    gold,
    Enum.Material.Neon,
    Enum.PartType.Ball
)

-- Luces letrero
for _, x in ipairs({-8, 8}) do
    part(
        "Soporte de farol",
        Vector3.new(0.18, 1.5, 0.18),
        Vector3.new(x, 11.5, -21),
        dark,
        Enum.Material.Wood
    )

    glow(
        "Farol dorado",
        Vector3.new(x, 10.5, -21),
        gold,
        1.3,
        12
    )
end

-- Vigas
for _, z in ipairs({-18, -6, 6, 18}) do
    part(
        "Viga del techo",
        Vector3.new(60, 0.45, 0.65),
        Vector3.new(0, 17.1, z),
        dark,
        Enum.Material.Wood
    )
end

-- Mesas clientes.
local function makeTable(x, z)
    part(
        "Tablero de mesa",
        Vector3.new(4.5, 0.35, 4.5),
        Vector3.new(x, 2.2, z),
        wood,
        Enum.Material.Wood,
        Enum.PartType.Cylinder
    )

    part(
        "Pie de mesa",
        Vector3.new(0.65, 1.9, 0.65),
        Vector3.new(x, 1.15, z),
        dark,
        Enum.Material.Wood
    )

    for _, offset in ipairs({
        Vector3.new(0, 0, -2.5),
        Vector3.new(0, 0, 2.5)
    }) do
        local seat = part(
            "Taburete",
            Vector3.new(1.5, 0.5, 1.5),
            Vector3.new(x + offset.X, 0.8, z + offset.Z),
            purple,
            Enum.Material.SmoothPlastic,
            Enum.PartType.Cylinder
        )

        seat.CanCollide = true
    end

    glow(
        "Luz de mesa",
        Vector3.new(x, 2.7, z),
        lavender,
        0.5,
        7
    )
end

makeTable(-20, 12)
makeTable(20, 12)
makeTable(-20, -8)
makeTable(20, -8)

-- Cristales mágicos en las esquinas.
for _, pos in ipairs({
    Vector3.new(-25, 1.5, -20),
    Vector3.new(25, 1.5, -20),
    Vector3.new(-25, 1.5, 20),
    Vector3.new(25, 1.5, 20)
}) do
    local crystal = part(
        "Cristal magico",
        Vector3.new(1.1, 3, 1.1),
        pos,
        lavender,
        Enum.Material.Neon
    )

    crystal.Shape = Enum.PartType.Block
    crystal.Orientation = Vector3.new(0, 0, 12)

    glow(
        "Aura del cristal",
        pos + Vector3.new(0, 1.5, 0),
        purple,
        0.8,
        10
    )
end

-- plantas
for _, pos in ipairs({
    Vector3.new(-27, 0.5, 8),
    Vector3.new(27, 0.5, 8),
    Vector3.new(-27, 0.5, -8),
    Vector3.new(27, 0.5, -8)
}) do
    part(
        "Maceta",
        Vector3.new(1.5, 1, 1.5),
        pos,
        wood,
        Enum.Material.Wood,
        Enum.PartType.Cylinder
    )

    part(
        "Planta magica",
        Vector3.new(2, 2, 2),
        pos + Vector3.new(0, 1.5, 0),
        green,
        Enum.Material.Grass,
        Enum.PartType.Ball
    )
end

print("CafeDecor: decoracion creada correctamente.")
