-- LocalScript у StarterGui

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "FloatingEnterButton"
gui.Parent = player:WaitForChild("PlayerGui")

-- створюємо кнопку
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 80, 0, 50)
button.Position = UDim2.new(0.8, 0, 0.8, 0)
button.Text = "Enter"
button.Parent = gui

-- коли натискаєш кнопку
button.MouseButton1Click:Connect(function()
	-- емулюємо клавішу Enter (Return)
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end)

loadstring(game:HttpGet"https://raw.githubusercontent.com/NukeVsCity/hackscript123/main/gui")()
--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
loadstring(game:HttpGet("https://raw.githubusercontent.com/zakater5/LuaRepo/main/YBA/v3.lua"))()
