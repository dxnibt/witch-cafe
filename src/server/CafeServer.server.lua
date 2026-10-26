
-- Script principal del servidor


local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local coins = Instance.new("IntValue")
    coins.Name = "Monedas"
    coins.Value = 0
    coins.Parent = leaderstats

    print(player.Name .. " ha entrado en Witch Cafe.")
end)

print("Witch Cafe: servidor iniciado correctamente.")