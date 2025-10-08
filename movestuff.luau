-- Dev_MoveSelector.lua  (LocalScript; StarterPlayerScripts)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

-- Only allow in Studio or for these admin userids (safety)
local ADMIN_USERIDS = {
    [localPlayer.UserId] = true, -- you
    --[12345678] = true, -- add other dev ids if needed
}

local function isAllowed()
    if RunService:IsStudio() then return true end
    return ADMIN_USERIDS[localPlayer.UserId] == true
end

if not isAllowed() then
    StarterGui:SetCore("SendNotification", {
        Title = "Dev Move Selector",
        Text = "Not allowed (not Studio or not admin).",
        Duration = 5
    })
    return
end

-- === Paste your args table here (exactly as provided) ===
local args = {
	{
		Image = "rbxassetid://139498278529145",
		Name = "Charge",
		Uses = -1,
		Cooldown = 40,
		Key = Enum.KeyCode.E
	},
	0,
	{
		Shedletsky = {
			{ Image = "rbxassetid://534533607", Name = "Slash", Uses = -1, Cooldown = 40, Key = Enum.KeyCode.Q },
			{ Image = "rbxassetid://3510346051", Name = "Fried Chicken", Uses = 2, Cooldown = 70, Key = Enum.KeyCode.E }
		},
		JohnDoe = {
			{ Image = "rbxassetid://28827194", Name = "M1 JohnDoe", Uses = -1, Cooldown = 2, Key = Enum.KeyCode.Q }
		},
        -- ... (snipped here for brevity in this message; keep your full mapping in the script)
	}
}
-- ======================================================

-- For convenience, re-add the full mapping (ensure the full object you earlier pasted is present).
-- If you cut the mapping above for brevity, put the full object there.

-- flatten the moves into a list of {displayName, moveTable, owner}
local moves = {} -- array of { Name = ..., Data = <moveTable>, Owner = <string or nil> }

-- first element (args[1]) if it looks like a single move record
if type(args[1]) == "table" and args[1].Name then
    table.insert(moves, { Name = args[1].Name, Data = args[1], Owner = nil })
end

-- args[3] is a mapping owner -> list
local map = args[3]
if type(map) == "table" then
    for owner, list in pairs(map) do
        if type(list) == "table" then
            for _, move in ipairs(list) do
                if type(move) == "table" and move.Name then
                    table.insert(moves, { Name = (owner .. " — " .. tostring(move.Name)), Data = move, Owner = owner })
                end
            end
        end
    end
end

-- fallback: if no moves found, notify and abort
if #moves == 0 then
    StarterGui:SetCore("SendNotification", {
        Title = "Dev Move Selector",
        Text = "No moves parsed from args. Check args table.",
        Duration = 6
    })
    return
end

-- Try to load Rayfield quickly (dev convenience)
local ok, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not ok or not Rayfield then
    StarterGui:SetCore("SendNotification", {
        Title = "Dev Move Selector",
        Text = "Failed to load Rayfield UI. Check internet or URL.",
        Duration = 6
    })
    return
end

-- Build UI
local Window = Rayfield:CreateWindow({
    Name = "Dev Move Selector",
    LoadingTitle = "Dev Tools",
    LoadingSubtitle = "Select a move and press Q to use it",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Moves")
local currentIndex = 1

-- build options list for dropdown
local options = {}
for i,entry in ipairs(moves) do
    options[i] = entry.Name
end

Tab:CreateDropdown({
    Name = "Select Move",
    Options = options,
    CurrentOption = options[1],
    Flag = "SelectedMove",
    Callback = function(opt)
        -- find index
        for i,v in ipairs(options) do
            if v == opt then currentIndex = i; break end
        end
    end
})

Tab:CreateLabel({Title = "Hotkey", Content = "Press Q to trigger the selected move (dev only)."})
Tab:CreateButton({
    Name = "Trigger Selected Move Now",
    Callback = function()
        local entry = moves[currentIndex]
        if entry then
            TriggerMove(entry)
        end
    end
})

-- helper that sends the move to server
local function TriggerMove(entry)
    local remotePath = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("OnAbility")
    if not remotePath then
        Rayfield:Notify({ Title = "Error", Content = "Remotes.OnAbility not found in ReplicatedStorage", Duration = 4 })
        return
    end

    local payload = entry.Data
    -- If the server expects a different wrapper shape, adjust here.
    -- Best-effort: send the move table as the single argument.
    local suc, err = pcall(function()
        if remotePath:IsA("RemoteFunction") then
            remotePath:InvokeServer(payload)
        else
            remotePath:FireServer(payload)
        end
    end)
    if suc then
        Rayfield:Notify({ Title = "Sent", Content = "Triggered move: "..tostring(entry.Name), Duration = 3 })
    else
        Rayfield:Notify({ Title = "Error", Content = "Failed to send: "..tostring(err), Duration = 4 })
    end
end

-- bind Q hotkey
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Q then
        local entry = moves[currentIndex]
        if entry then
            TriggerMove(entry)
        end
    end
end)

-- convenience notify
Rayfield:Notify({ Title = "Dev Move Selector", Content = "Ready — select a move and press Q", Duration = 4 })
