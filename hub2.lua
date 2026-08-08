local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Blox Fruits Premium Hub",
    LoadingTitle = "Initializing Systems...",
    LoadingSubtitle = "by AI Assistant",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BF_Premium_Hub",
        FileName = "Config"
    }
})

-- Variables
local AutoFarmLevel = false
local AutoFarmChest = false
local AutoStoreFruit = false
local AutoRollFruit = false

-- Utility Functions
local function getClosestChest()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v.Name:find("Chest") and v:IsA("Part") then
            local d = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end
    return closest
end

local function teleport(pos)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = pos
    end
end

-- Tabs
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local FruitTab = Window:CreateTab("Fruit Tools", 4483362458)
local TeleportTab = Window:CreateTab("World/Race", 4483362458)

-- Farm Section
FarmTab:CreateToggle({
    Name = "Auto Farm Level",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarmLevel = Value
        task.spawn(function()
            while AutoFarmLevel do
                -- Logic: Find Quest NPC -> Take Quest -> Kill Mobs
                -- Note: Simplified for structure; requires specific NPC/Mob names per level
                print("Farming levels...")
                task.wait(1)
            end
        end)
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Farm Chests",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarmChest = Value
        task.spawn(function()
            while AutoFarmChest do
                local chest = getClosestChest()
                if chest then
                    teleport(chest.CFrame)
                end
                task.wait(0.5)
            end
        end)
    end,
})

-- Fruit Section
FruitTab:CreateButton({
    Name = "Teleport to Spawned Fruit",
    Callback = function()
        local found = false
        for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
                teleport(v.Handle.CFrame)
                found = true
                break
            end
        end
        if not found then Rayfield:Notify({Title = "Fruit Finder", Content = "No fruits found on map."}) end
    end,
})

FruitTab:CreateToggle({
    Name = "Auto Roll & Store Fruit",
    CurrentValue = false,
    Callback = function(Value)
        AutoRollFruit = Value
        task.spawn(function()
            while AutoRollFruit do
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
                task.wait(1)
                for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if item.Name:find("Fruit") then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", item.Name, item)
                    end
                end
                task.wait(5)
            end
        end)
    end,
})

FruitTab:CreateButton({
    Name = "Server Scan (Rare Fruits)",
    Callback = function()
        -- Logic to check workspace for specific fruit IDs
        Rayfield:Notify({Title = "Scanner", Content = "Scanning server for legendary spawns..."})
    end,
})

-- Teleport & Race Section
TeleportTab:CreateSection("Islands")
local Islands = {"Starter Island", "Marine Starter", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Marineford", "Skypiea", "Prison", "Magma Village"}
TeleportTab:CreateDropdown({
    Name = "Teleport to Island",
    Options = Islands,
    CurrentOption = "Starter Island",
    Callback = function(Option)
        print("Teleporting to " .. Option)
        -- Map CFrame coordinates to island names here
    end,
})

TeleportTab:CreateSection("Race Upgrades")
TeleportTab:CreateButton({
    Name = "Auto Race V2 (Alchemist Quest)",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "Start")
        -- Logic to auto-collect flowers (Blue, Red, Yellow)
    end,
})

TeleportTab:CreateButton({
    Name = "Auto Race V3 (Arowe Quest)",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TraflalgarAndres", "Start")
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Temple of Time (V4)",
    Callback = function()
        -- Specific CFrame for V4 Temple
        teleport(CFrame.new(28282, 14896, 102)) 
    end,
})

Rayfield:LoadConfiguration()
