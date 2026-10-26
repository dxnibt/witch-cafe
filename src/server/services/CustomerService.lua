local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local CustomerService = {}

-- Configuracion
local ORDER = { name = "Latte de luna", price = 10 }
local DOOR_SPOT = Vector3.new(0, 4, 22)     -- por donde entra y sale
local WAIT_SPOT = Vector3.new(0, 4, 12.5)   -- donde espera frente al mostrador
local TIME_BETWEEN_CUSTOMERS = 4            -- segundos entre clientes

local current = nil -- cliente que espera ahora mismo

-- Crea un humanoide basico con colores morados
local function createModel()
    local desc = Instance.new("HumanoidDescription")
    desc.HeadColor = Color3.fromRGB(255, 224, 235)
    desc.TorsoColor = Color3.fromRGB(180, 130, 230)
    desc.LeftArmColor = Color3.fromRGB(255, 224, 235)
    desc.RightArmColor = Color3.fromRGB(255, 224, 235)
    desc.LeftLegColor = Color3.fromRGB(70, 38, 110)
    desc.RightLegColor = Color3.fromRGB(70, 38, 110)

    local ok, model = pcall(function()
        return Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
    end)

    if not ok or not model then
        warn("CustomerService: no se pudo crear el cliente: " .. tostring(model))
        return nil
    end

    return model
end

-- Burbuja de texto sobre la cabeza
local function makeBubble(model, text)
    local head = model:WaitForChild("Head", 5)
    if not head then
        return nil
    end

    local gui = Instance.new("BillboardGui")
    gui.Name = "Pedido"
    gui.Size = UDim2.fromOffset(220, 55)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.AlwaysOnTop = true
    gui.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundColor3 = Color3.fromRGB(43, 29, 55)
    label.BackgroundTransparency = 0.1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 200, 255)
    label.Font = Enum.Font.FredokaOne
    label.TextScaled = true
    label.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = label

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 6)
    padding.Parent = label

    return label
end

local function walkTo(humanoid, point)
    humanoid:MoveTo(point)
    humanoid.MoveToFinished:Wait()
end

-- Ciclo completo de un cliente
local function runCustomer()
    local model = createModel()
    if not model then
        return
    end

    model.Name = "Cliente"
    model:PivotTo(CFrame.lookAt(DOOR_SPOT, WAIT_SPOT))
    model.Parent = Workspace

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then
        model:Destroy()
        return
    end

    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

    local label = makeBubble(model, "Quiero: " .. ORDER.name)
    local customer = { order = ORDER, waiting = false, served = false }

    -- Entra y se coloca frente al mostrador
    walkTo(humanoid, WAIT_SPOT)
    if not model.Parent then
        return
    end

    local pos = root.Position
    model:PivotTo(CFrame.lookAt(pos, Vector3.new(pos.X, pos.Y, 0)))

    customer.waiting = true
    current = customer

    -- Espera a que lo atiendan
    while not customer.served and model.Parent do
        task.wait(0.25)
    end

    current = nil

    -- Se despide y se va
    if model.Parent then
        if label then
            label.Text = "¡Gracias!"
        end
        task.wait(2)
        walkTo(humanoid, DOOR_SPOT)
        model:Destroy()
    end
end

-- Lo llama la estacion del mostrador al entregar una bebida
-- Devuelve el pago si hay un cliente esperando esa bebida; si no, nil
function CustomerService.serve(drinkName)
    local customer = current

    if not customer or not customer.waiting or customer.served then
        return nil
    end

    if drinkName ~= customer.order.name then
        return nil
    end

    customer.served = true
    customer.waiting = false
    return customer.order.price
end

local started = false

function CustomerService.start()
    if started then
        return
    end
    started = true

    task.spawn(function()
        while true do
            if #Players:GetPlayers() == 0 then
                task.wait(1)
            else
                local ok, err = pcall(runCustomer)
                if not ok then
                    warn("CustomerService: " .. tostring(err))
                    task.wait(5)
                end
                task.wait(TIME_BETWEEN_CUSTOMERS)
            end
        end
    end)
end

return CustomerService