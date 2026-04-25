local Players = game:GetService("Players")
local uis = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- Function to find a random player (that isn't you)
local function getRandomPlayer()
    local allPlayers = Players:GetPlayers()
    local targets = {}
    
    for _, p in pairs(allPlayers) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(targets, p)
        end
    end
    
    if #targets > 0 then
        return targets[math.random(1, #targets)]
    end
    return nil
end

-- Function to copy the target's appearance and gear
local function copyMoveset()
    local target = getRandomPlayer()
    if not target then 
        print("No players found to copy!")
        return 
    end
    
    local myChar = lp.Character
    local targetChar = target.Character
    
    if myChar and targetChar then
        -- 1. Copy Appearance (Clothing, Hair, etc.)
        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        
        if targetHum and myHum then
            local desc = targetHum:GetAppliedDescription()
            myHum:ApplyDescription(desc)
        end
        
        -- 2. Copy Tools/Abilities (Moveset)
        -- In Shindo Life, moves are often Tools in the Backpack or Character
        for _, item in pairs(target.Backpack:GetChildren()) do
            if item:IsA("Tool") then
                local clone = item:Clone()
                clone.Parent = lp.Backpack
            end
        end
        
        -- Also check if they are holding a tool currently
        for _, item in pairs(targetChar:GetChildren()) do
            if item:IsA("Tool") then
                local clone = item:Clone()
                clone.Parent = lp.Backpack
            end
        end
        
        print("Successfully copied moveset from: " .. target.Name)
    end
end

-- Listen for the R key
uis.InputBegan:Connect(function(input, proc)
    if proc then return end
    if input.KeyCode == Enum.KeyCode.R then
        copyMoveset()
    end
end)
