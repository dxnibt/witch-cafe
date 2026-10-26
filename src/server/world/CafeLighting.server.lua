local Lighting = game:GetService("Lighting")

local function getOrCreate(className, name)
    local obj = Lighting:FindFirstChild(name)
    if not obj then
        obj = Instance.new(className)
        obj.Name = name
        obj.Parent = Lighting
    end
    return obj
end

-- Noche 
Lighting.ClockTime = 18.3
Lighting.Ambient = Color3.fromRGB(70, 45, 100)
Lighting.OutdoorAmbient = Color3.fromRGB(60, 40, 90)
Lighting.ExposureCompensation = 0.3
Lighting.EnvironmentDiffuseScale = 0.4
Lighting.EnvironmentSpecularScale = 0.3

-- Neblina morada
local atmosphere = getOrCreate("Atmosphere", "WitchCafeAtmosphere")
atmosphere.Density = 0.22
atmosphere.Offset = 0.1
atmosphere.Color = Color3.fromRGB(190, 165, 220)
atmosphere.Decay = Color3.fromRGB(90, 65, 115)
atmosphere.Glare = 0.15
atmosphere.Haze = 0.7

-- Brillo objetos
local bloom = getOrCreate("BloomEffect", "WitchCafeBloom")
bloom.Intensity = 0.7
bloom.Size = 30
bloom.Threshold = 1

local color = getOrCreate("ColorCorrectionEffect", "WitchCafeColor")
color.Saturation = 0.2
color.Contrast = 0.1
color.TintColor = Color3.fromRGB(255, 238, 255)

-- Estrellas
local sky = getOrCreate("Sky", "WitchCafeSky")
sky.StarCount = 3000

print("CafeLighting: ambiente aplicado.")