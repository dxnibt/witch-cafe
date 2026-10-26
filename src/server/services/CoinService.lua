local CoinService = {}

local MAX_REWARD = 1000 -- tope por transaccion

function CoinService.setup(player)
    if player:FindFirstChild("leaderstats") then
        return
    end

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local coins = Instance.new("IntValue")
    coins.Name = "Monedas"
    coins.Value = 0
    coins.Parent = leaderstats
end

function CoinService.get(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    local coins = leaderstats and leaderstats:FindFirstChild("Monedas")
    return coins and coins.Value or 0
end

-- Suma monedas validando la cantidad
function CoinService.add(player, amount)
    if typeof(amount) ~= "number" or amount ~= amount then
        warn("CoinService: cantidad invalida.")
        return false
    end

    amount = math.floor(amount)
    if amount <= 0 or amount > MAX_REWARD then
        warn("CoinService: cantidad fuera de rango: " .. amount)
        return false
    end

    local leaderstats = player:FindFirstChild("leaderstats")
    local coins = leaderstats and leaderstats:FindFirstChild("Monedas")
    if not coins then
        return false
    end

    coins.Value += amount
    return true
end

return CoinService