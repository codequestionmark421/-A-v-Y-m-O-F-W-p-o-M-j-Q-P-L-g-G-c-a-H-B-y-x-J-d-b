-- Dev_MoveSelector.lua
-- Run as a LocalScript inside StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

-- your full move dataset
local args = {
	{
		Image = "rbxassetid://6684648436",
		Name = "Max Capacity",
		Uses = 2,
		Cooldown = 55,
		Key = Enum.KeyCode.E
	},
	0,
	{
		-- (keep your big table here unchanged)
	}
}

-- flatten all moves
local moves = {}
local map = args[3]
for owner, list in pairs(map) do
	for _, move in ipairs(list) do
		table.insert(moves, {
			Name = string.format("%s — %s", owner, move.Name),
			Data = move
		})
	end
end

-- load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
	Name = "Developer Move Selector",
	LoadingTitle = "Move Selector",
	LoadingSubtitle = "Testing Utility",
	ConfigurationSaving = { Enabled = false }
})
local Tab = Window:CreateTab("Moves")

local options = {}
for _, entry in ipairs(moves) do
	table.insert(options, entry.Name)
end

local selectedIndex = 1
Tab:CreateDropdown({
	Name = "Select Move",
	Options = options,
	CurrentOption = options[1],
	Flag = "SelectedMove",
	Callback = function(opt)
		for i, v in ipairs(options) do
			if v == opt then
				selectedIndex = i
				break
			end
		end
	end
})

-- This function updates args[1] before firing
local function TriggerMove(entry)
	local remote = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("OnAbility")
	if not remote then
		Rayfield:Notify({
			Title = "Error",
			Content = "Missing remote 'OnAbility'",
			Duration = 4
		})
		return
	end

	-- Update first argument to selected move
	args[1] = entry.Data

	local success, err = pcall(function()
		if remote:IsA("RemoteFunction") then
			remote:InvokeServer(unpack(args))
		else
			remote:FireServer(unpack(args))
		end
	end)

	if success then
		Rayfield:Notify({
			Title = "Triggered",
			Content = "Move: " .. entry.Name,
			Duration = 3
		})
	else
		Rayfield:Notify({
			Title = "Error",
			Content = tostring(err),
			Duration = 4
		})
	end
end

Tab:CreateButton({
	Name = "Trigger Selected Move",
	Callback = function()
		TriggerMove(moves[selectedIndex])
	end
})

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Q then
		TriggerMove(moves[selectedIndex])
	end
end)

Rayfield:Notify({
	Title = "Ready",
	Content = "Select a move and press Q to activate it.",
	Duration = 5
})
