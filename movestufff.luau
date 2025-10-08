-- Dev_MoveSelector.lua
-- LocalScript for in-Studio or testing

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

-- === Moves dataset (simplified demo) ===
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
		Shedletsky = {
			{
				Image = "rbxassetid://534533607",
				Name = "Slash",
				Uses = -1,
				Cooldown = 40,
				Key = Enum.KeyCode.Q
			},
			{
				Image = "rbxassetid://3510346051",
				Name = "Fried Chicken",
				Uses = 2,
				Cooldown = 70,
				Key = Enum.KeyCode.E
			}
		},
		JohnDoe = {
			{
				Image = "rbxassetid://28827194",
				Name = "M1 JohnDoe",
				Uses = -1,
				Cooldown = 2,
				Key = Enum.KeyCode.Q
			}
		},
		Noli = {
			{
				Image = "rbxassetid://28827194",
				Name = "M1 Noli",
				Uses = -1,
				Cooldown = 1.8,
				Key = Enum.KeyCode.Q
			}
		},
		["007n7"] = {
			{
				Image = "rbxassetid://131167660731272",
				Name = "Clone",
				Uses = -1,
				Cooldown = 20,
				Key = Enum.KeyCode.Q
			},
			{
				Image = "rbxassetid://113186932840079",
				Name = "c00lgui",
				Uses = -1,
				Cooldown = 70,
				Key = Enum.KeyCode.E
			},
			{
				Image = "rbxassetid://6187009322",
				Name = "Inject",
				Uses = -1,
				Cooldown = 0.1,
				Key = Enum.KeyCode.R
			}
		},
		TwoTime = {
			{
				Image = "rbxassetid://4811127868",
				Name = "Dagger",
				Uses = -1,
				Cooldown = 20,
				Key = Enum.KeyCode.Q
			},
			{
				Image = "rbxassetid://395945174",
				Name = "Crouch",
				Uses = -1,
				Cooldown = 40,
				Key = Enum.KeyCode.E
			},
			{
				Image = "rbxassetid://7344398363",
				Name = "Ritual",
				Uses = 1,
				Cooldown = 1,
				Key = Enum.KeyCode.R
			}
		},
		Jason = {
			{
				Image = "rbxassetid://28827194",
				Name = "M1 Jason",
				Uses = -1,
				Cooldown = 2,
				Key = Enum.KeyCode.Q
			},
			{
				Image = "rbxassetid://12163554546",
				Name = "Behead",
				Uses = -1,
				Cooldown = 15,
				Key = Enum.KeyCode.E
			},
			{
				Image = "rbxassetid://122749802408265",
				Name = "Gashing Wound",
				Uses = -1,
				Cooldown = 30,
				Key = Enum.KeyCode.R
			}
		},
		Guest1337 = {
			{
				Image = "rbxassetid://748228341",
				Name = "Block",
				Uses = -1,
				Cooldown = 20,
				Key = Enum.KeyCode.Q
			},
			{
				Image = "rbxassetid://139498278529145",
				Name = "Charge",
				Uses = -1,
				Cooldown = 40,
				Key = Enum.KeyCode.E
			},
			{
				Image = "rbxassetid://97903626702461",
				Name = "Punch",
				Uses = 0,
				Cooldown = 5,
				Key = Enum.KeyCode.R
			}
		},
		Elliot = {
			{
				Image = "rbxassetid://480037119",
				Name = "Pizza",
				Uses = -1,
				Cooldown = 30,
				Key = Enum.KeyCode.Q
			},
			{
				Image = "rbxassetid://102304717227391",
				Name = "Rush Hour",
				Uses = 1,
				Cooldown = 50,
				Key = Enum.KeyCode.E
			}
		},
		Noob = {
			{
				Image = "rbxassetid://534533607",
				Name = "BloxyCola",
				Uses = -1,
				Cooldown = 40,
				Key = Enum.KeyCode.Q
			},
			{
				Image = "rbxassetid://6684648436",
				Name = "SlateSkin",
				Uses = -1,
				Cooldown = 50,
				Key = Enum.KeyCode.E
			},
			{
				Image = "rbxassetid://6684648436",
				Name = "GhostBurger",
				Uses = -1,
				Cooldown = 60,
				Key = Enum.KeyCode.R
			}
		},
		["1x1x1x1"] = {
			{
				Image = "rbxassetid://28827194",
				Name = "M1 1x1x1x1",
				Uses = -1,
				Cooldown = 2,
				Key = Enum.KeyCode.Q
			}
		},
		["Roblox Character"] = {
			{
				Image = "rbxassetid://534533607",
				Name = "Slash",
				Uses = 4,
				Cooldown = 60,
				Key = Enum.KeyCode.Q
			},
			{
				Image = "rbxassetid://6684648436",
				Name = "Max Capacity",
				Uses = 2,
				Cooldown = 55,
				Key = Enum.KeyCode.E
			}
		},
		Chance = {
			{
				Image = "rbxassetid://16443147436",
				Name = "Coin",
				Uses = -1,
				Cooldown = 1,
				Key = Enum.KeyCode.Q
			},
			{
				Image = "rbxassetid://18818938205",
				Name = "Shoot",
				Uses = 0,
				Cooldown = 55,
				Key = Enum.KeyCode.E
			},
			{
				Image = "rbxassetid://18818938205",
				Name = "Reroll",
				Uses = 0,
				Cooldown = 30,
				Key = Enum.KeyCode.R
			},
			{
				Image = "rbxassetid://18818938205",
				Name = "HatFix",
				Uses = 0,
				Cooldown = 90,
				Key = Enum.KeyCode.T
			}
		},
		Builderman = {
			{
				Image = "rbxassetid://534533607",
				Name = "Sentry",
				Uses = -1,
				Cooldown = 40,
				Key = Enum.KeyCode.Q
			},
			{
				Image = "rbxassetid://3510346051",
				Name = "Dispenser",
				Uses = -1,
				Cooldown = 60,
				Key = Enum.KeyCode.E
			}
		},
		c00lkidd = {
			{
				Image = "rbxassetid://28827194",
				Name = "M1 c00lkidd",
				Uses = -1,
				Cooldown = 2,
				Key = Enum.KeyCode.Q
			}
		}
	}
}


-- flatten all moves into a single list
local moves = {}
for owner, list in pairs(args[3]) do
    for _, move in ipairs(list) do
        table.insert(moves, { Name = string.format("%s — %s", owner, move.Name), Data = move })
    end
end

-- Load Rayfield (with cache buster to avoid old versions)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield?t=" .. tick()))()

-- Create window
local Window = Rayfield:CreateWindow({
    Name = "Developer Move Selector",
    LoadingTitle = "Move Test Tool",
    LoadingSubtitle = "Instant load + rebind keys",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Moves")

-- Dropdown for selecting moves
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
            if v == opt then selectedIndex = i break end
        end
    end
})

-- Dynamic keybind variable
local currentKey = Enum.KeyCode.Q

Tab:CreateKeybind({
    Name = "Change Activation Key",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "ActivationKey",
    Callback = function(Key)
        currentKey = Key
        Rayfield:Notify({
            Title = "Key Changed",
            Content = "New keybind set to " .. tostring(Key),
            Duration = 3
        })
    end
})

-- Function to trigger the move
local function TriggerMove(entry)
    local remote = ReplicatedStorage:FindFirstChild("Remotes") 
        and ReplicatedStorage.Remotes:FindFirstChild("OnAbility")
    if not remote then
        Rayfield:Notify({
            Title = "Error",
            Content = "Missing remote 'OnAbility'",
            Duration = 4
        })
        return
    end

    -- Build the exact args the server expects
    local sendArgs = {
        entry.Data, -- the selected move
        0,         -- padding
        args[3]    -- full moves table
    }

    local success, err = pcall(function()
        if remote:IsA("RemoteFunction") then
            remote:InvokeServer(unpack(sendArgs))
        else
            remote:FireServer(unpack(sendArgs))
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
--hello

-- Manual button
Tab:CreateButton({
    Name = "Trigger Selected Move",
    Callback = function()
        TriggerMove(moves[selectedIndex])
    end
})

-- Listen for the selected keybind
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == currentKey then
        TriggerMove(moves[selectedIndex])
    end
end)

Rayfield:Notify({
    Title = "Ready",
    Content = "v 1 (default: Q)",
    Duration = 5
})
