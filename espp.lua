-- LocalScript (помістіть в StarterGui)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- --- UI Створення ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatingEnterGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local btn = Instance.new("TextButton")
btn.Name = "EnterButton"
btn.Parent = screenGui
btn.AnchorPoint = Vector2.new(0.5, 0.5)
btn.Position = UDim2.new(0.9, 0, 0.85, 0)   -- правий низ
btn.Size = UDim2.new(0, 72, 0, 48)          -- розмір як клавіша
btn.AutoButtonColor = true
btn.Text = "Enter"
btn.Font = Enum.Font.GothamSemibold
btn.TextSize = 18
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.BorderSizePixel = 0
btn.ZIndex = 10
btn.TextWrapped = true
btn.ClipsDescendants = true
btn.LayoutOrder = 1
btn.Modal = false

-- стиль: трохи округлень і тінь
local uicorner = Instance.new("UICorner", btn)
uicorner.CornerRadius = UDim.new(0, 10)
local uistroke = Instance.new("UIStroke", btn)
uistroke.Transparency = 0.7
uistroke.Thickness = 1

-- Optional: маленький drag handle (усвідомлено використовується вся кнопка як handle)

-- --- Drag логіка (щоб можна було пересувати кнопку) ---
local dragging = false
local dragStart = Vector2.new(0,0)
local startPos = UDim2.new()

local function updateDrag(input)
	if not dragging then return end
	local delta = input.Position - dragStart
	local newPos = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
	-- обмеження в межах екрану
	local screenW, screenH = workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y
	local btnW, btnH = btn.AbsoluteSize.X, btn.AbsoluteSize.Y
	local minX = 0
	local maxX = screenW - btnW
	local minY = 0
	local maxY = screenH - btnH

	local absX = math.clamp(newPos.X.Offset, minX, maxX)
	local absY = math.clamp(newPos.Y.Offset, minY, maxY)
	btn.Position = UDim2.new(0, absX, 0, absY)
end

btn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = btn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		updateDrag(input)
	end
end)

-- --- Обробник "Enter" ---
-- Тут ми робимо універсальну функцію, яка запускається при натисканні кнопки або при натисканні клавіші Return.
local function onEnter()
	-- 1) Локальна дія (приклад)
	print("Enter pressed (local)")

	-- 2) Якщо у ReplicatedStorage є RemoteEvent "EnterPressed", відправимо запит на сервер
	local remote = ReplicatedStorage:FindFirstChild("EnterPressed")
	if remote and remote:IsA("RemoteEvent") then
		remote:FireServer() -- сервер повинен обробити це
	end

	-- Тут можна викликати будь-яку іншу локальну логіку: відкрити чат, відправити повідомлення, підтвердити дію тощо.
end

-- Зв'язування натискання кнопки
btn.MouseButton1Click:Connect(function()
	-- трошки анімації натискання
	local goal = {Size = UDim2.new(0, 68, 0, 46)}
	local tween = TweenService:Create(btn, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
	tween:Play()
	tween.Completed:Wait()
	-- Повернути розмір
	local goal2 = {Size = UDim2.new(0, 72, 0, 48)}
	local tween2 = TweenService:Create(btn, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal2)
	tween2:Play()

	onEnter()
end)

-- Також реагуємо на фізичну клавішу Enter / Return
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
		onEnter()
	end
end)

-- --- Порада: автоскривання при відкритті екранної клавіатури (на мобілці) ---
-- (необов'язково) на мобілці можна ховати кнопку коли відкритий TextBox:
local function onTextBoxFocused()
	btn.Visible = false
end
local function onTextBoxFocusLost()
	btn.Visible = true
end

-- Пошук всіх TextBox у сцені та прив'язка (як приклад)
for _, gui in pairs(playerGui:GetDescendants()) do
	if gui:IsA("TextBox") then
		gui.Focused:Connect(onTextBoxFocused)
		gui.FocusLost:Connect(onTextBoxFocusLost)
	end
end

-- Якщо ви хочете, щоб кнопка зберігала позицію між спавнами,
-- можна зберігати btn.Position в DataStore або в локальному Storage (PlayerPrefs/Value) — за потреби допоможу додати.

