-- Services
local P = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

-- Player
local plr = P.LocalPlayer

-- Settings
local normalSpeed = 32
local chaseSpeed = 32
local wanderRadius = 20
local detectR = 100
local execR = 6
local delay = 0.2
local running = true
local respawnPos = Vector3.new(-12, 10, -483)
iswandering = true;
messages = {"can someone fight me please 🥺"}

-- Get character
local function getChar()
    return plr.Character or plr.CharacterAdded:Wait()
end

local char = getChar()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- Initial setup
hum.WalkSpeed = normalSpeed
hrp.CFrame = CFrame.new(respawnPos)

-- Stop script input
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Equals then
        running = false
    end
end)

-- Respawn handling
local function setupRespawn(c)
    local h = c:WaitForChild("Humanoid")
    h.Died:Connect(function()
        task.wait(0.1)
        local n = getChar()
        hrp = n:WaitForChild("HumanoidRootPart")
        hum = n:WaitForChild("Humanoid")
        hrp.CFrame = CFrame.new(respawnPos)
        hum.WalkSpeed = normalSpeed
    end)
end

plr.CharacterAdded:Connect(setupRespawn)
setupRespawn(char)

-- Generate random nearby position
local function rndPos()
    return hrp.Position + Vector3.new(
        math.random(-wanderRadius, wanderRadius),
        0,
        math.random(-wanderRadius, wanderRadius)
    )
end

-- Find nearest player within range
local function nearest(maxD)
    local closestPlayer, closestDist = nil, maxD
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local h = p.Character:FindFirstChild("Humanoid")
            if h and h.Health > 0 then
                local dist = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestPlayer, closestDist = p, dist
                end
            end
        end
    end
    return closestPlayer, closestDist
end

-- Execute action on player
local function exec(p)
    if p and p.Character then
        RS:WaitForChild("Remotes"):WaitForChild("Execution"):FireServer(p.Character)
    end
end

--chat loop
task.spawn(function()
    while true do        
        task.wait(math.random(1, 5))
        if iswandering then
        
            plr = Players.LocalPlayer
            plr:Chat(messages[math.random(1, #messages)])
        end
    end
end)

-- Main loop
task.spawn(function()
    while running do
        local target, dist = nearest(detectR)
        if target then
            iswandering = false;
            hum.WalkSpeed = chaseSpeed
            hum:MoveTo(target.Character.HumanoidRootPart.Position)
            if dist <= execR then
                exec(target)
            end
        else
            --wandering
            iswandering = true;
            hum.WalkSpeed = normalSpeed
            hum:MoveTo(rndPos())
        end
        task.wait(delay)
    end
end)
