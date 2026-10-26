local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local CoinService = require(script.Parent:WaitForChild("CoinService"))
local CustomerService = require(script.Parent:WaitForChild("CustomerService"))

local DRINK_NAME = "Latte de luna"
local BREW_COOLDOWN = 3   -- segundos entre bebidas
local MAX_DISTANCE = 18  

local cafe = Workspace:WaitForChild("WitchCafe", 30)
if not cafe then
    warn("CafeStations: no se encontro WitchCafe.")
    return
end

local cauldron = cafe:WaitForChild("Caldero magico", 10)
local counter = cafe:WaitForChild("Cubierta del mostrador", 10)
if not cauldron or not counter then
    warn("CafeStations: faltan el caldero o el mostrador.")
    return
end

local lastBrew = {}

Players.PlayerRemoving:Connect(function(player)
    lastBrew[player] = nil
end)

local function isNear(player, part)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        return false
    end
    return (root.Position - part.Position).Magnitude <= MAX_DISTANCE
end

local function searchDrink(container)
    if not container then
        return nil
    end
    for _, item in ipairs(container:GetChildren()) do
        if item:IsA("Tool") and item:GetAttribute("EsBebida") then
            return item
        end
    end
    return nil
end

local function findDrink(player)
    return searchDrink(player.Character) or searchDrink(player:FindFirstChild("Backpack"))
end

local function makeDrink()
    local tool = Instance.new("Tool")
    tool.Name = DRINK_NAME
    tool.ToolTip = DRINK_NAME
    tool.CanBeDropped = false
    tool.RequiresHandle = true
    tool:SetAttribute("EsBebida", true)

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.9, 1, 0.9)
    handle.Color = Color3.fromRGB(207, 160, 255)
    handle.Material = Enum.Material.Neon
    handle.Parent = tool

    local light = Instance.new("PointLight")
    light.Color = handle.Color
    light.Range = 6
    light.Brightness = 1
    light.Parent = handle

    return tool
end

local function makePrompt(parent, name, action, object, holdTime)
    local old = parent:FindFirstChild(name)
    if old then
        old:Destroy()
    end

    local prompt = Instance.new("ProximityPrompt")
    prompt.Name = name
    prompt.ActionText = action
    prompt.ObjectText = object
    prompt.HoldDuration = holdTime
    prompt.MaxActivationDistance = 10
    prompt.RequiresLineOfSight = false
    prompt.Parent = parent
    return prompt
end

-- preparar la bebida
local brewPrompt = makePrompt(cauldron, "PromptPreparar",
    "Preparar " .. DRINK_NAME, "Caldero mágico", 1.5)

brewPrompt.Triggered:Connect(function(player)
    if not isNear(player, cauldron) then
        return
    end

    if findDrink(player) then
        return
    end

    -- Espera entre bebidas
    local now = os.clock()
    if lastBrew[player] and now - lastBrew[player] < BREW_COOLDOWN then
        return
    end
    lastBrew[player] = now

    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        makeDrink().Parent = backpack
    end
end)

local deliverPrompt = makePrompt(counter, "PromptEntregar",
    "Entregar bebida", "Mostrador", 0)

deliverPrompt.Triggered:Connect(function(player)
    if not isNear(player, counter) then
        return
    end

    local drink = findDrink(player)
    if not drink then
        return
    end

    -- El cliente decide si acepta la bebida y cuanto paga
    local reward = CustomerService.serve(drink.Name)
    if not reward then
        return
    end

    drink:Destroy()
    CoinService.add(player, reward)
end)

print("CafeStations: estaciones creadas correctamente.")

CustomerService.start()