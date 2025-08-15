repeat
	wait()
until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function()
	return game.CoreGui
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Username = LocalPlayer.Name
local UserID = LocalPlayer.UserId
local startTime = os.time()
local currentStatus = "Initializing script..."
local request = http_request or request or syn and syn.request

repeat
	task.wait(0.1)
until game:GetService("Players").LocalPlayer:GetAttribute("Diamonds")

local olddiamond = game:GetService("Players").LocalPlayer:GetAttribute("Diamonds") or 0

local function formatTime(seconds)
	local minutes = math.floor(seconds / 60)
	local hours = math.floor(minutes / 60)
	minutes = minutes % 60
	seconds = seconds % 60
	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function updateStatus(status)
	currentStatus = status
end

local function createOverlay()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AlchemyOverlay"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 999999999

	local Background = Instance.new("Frame")
	Background.Name = "Background"
	Background.Size = UDim2.new(1, 0, 1, 0)
	Background.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	Background.BorderSizePixel = 0
	Background.ZIndex = 10
	Background.Parent = ScreenGui

	local StatusFrame = Instance.new("Frame")
	StatusFrame.Name = "StatusFrame"
	StatusFrame.Size = UDim2.new(0, 600, 0, 250)
	StatusFrame.Position = UDim2.new(0.5, -300, 0.5, -125)
	StatusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	StatusFrame.BorderSizePixel = 0
	StatusFrame.ZIndex = 11
	StatusFrame.Parent = Background

	local StatusCorner = Instance.new("UICorner")
	StatusCorner.CornerRadius = UDim.new(0, 8)
	StatusCorner.Parent = StatusFrame

	local StatusHeader = Instance.new("TextLabel")
	StatusHeader.Name = "StatusHeader"
	StatusHeader.Size = UDim2.new(1, 0, 0, 40)
	StatusHeader.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	StatusHeader.BorderSizePixel = 0
	StatusHeader.ZIndex = 12
	StatusHeader.Font = Enum.Font.GothamSemibold
	StatusHeader.RichText = true
	StatusHeader.Text = "Alchemy <font color='rgb(0, 255, 98)'>Hub</font>"
	StatusHeader.TextSize = 22
	StatusHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
	StatusHeader.Parent = StatusFrame

	local StatusHeaderCorner = Instance.new("UICorner")
	StatusHeaderCorner.CornerRadius = UDim.new(0, 8)
	StatusHeaderCorner.Parent = StatusHeader

	local StatusContent = Instance.new("TextLabel")
	StatusContent.Name = "StatusContent"
	StatusContent.Size = UDim2.new(1, -20, 0, 30)
	StatusContent.Position = UDim2.new(0, 10, 0, 50)
	StatusContent.BackgroundTransparency = 1
	StatusContent.ZIndex = 12
	StatusContent.Font = Enum.Font.Gotham
	StatusContent.Text = "Initializing..."
	StatusContent.TextSize = 18
	StatusContent.TextColor3 = Color3.fromRGB(200, 200, 200)
	StatusContent.TextXAlignment = Enum.TextXAlignment.Left
	StatusContent.Parent = StatusFrame

	local StatsContainer = Instance.new("Frame")
	StatsContainer.Name = "StatsContainer"
	StatsContainer.Size = UDim2.new(1, -40, 0, 160)
	StatsContainer.Position = UDim2.new(0, 20, 0, 80)
	StatsContainer.BackgroundTransparency = 1
	StatsContainer.ZIndex = 12
	StatsContainer.Parent = StatusFrame

	local function createStat(name, value, posY)
		local StatFrame = Instance.new("Frame")
		StatFrame.Name = name .. "Frame"
		StatFrame.Size = UDim2.new(0, 275, 0, 50)
		StatFrame.Position = UDim2.new(0, posY % 2 == 0 and 0 or 285, 0, math.floor(posY / 2) * 55)
		StatFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		StatFrame.BorderSizePixel = 0
		StatFrame.ZIndex = 13
		StatFrame.Parent = StatsContainer

		local StatCorner = Instance.new("UICorner")
		StatCorner.CornerRadius = UDim.new(0, 6)
		StatCorner.Parent = StatFrame

		local StatName = Instance.new("TextLabel")
		StatName.Name = "Name"
		StatName.Size = UDim2.new(1, 0, 0, 20)
		StatName.Position = UDim2.new(0, 10, 0, 5)
		StatName.BackgroundTransparency = 1
		StatName.ZIndex = 14
		StatName.Font = Enum.Font.GothamSemibold
		StatName.Text = name
		StatName.TextSize = 14
		StatName.TextColor3 = Color3.fromRGB(180, 180, 180)
		StatName.TextXAlignment = Enum.TextXAlignment.Left
		StatName.Parent = StatFrame

		local StatValue = Instance.new("TextLabel")
		StatValue.Name = "Value"
		StatValue.Size = UDim2.new(1, -20, 0, 20)
		StatValue.Position = UDim2.new(0, 10, 0, 25)
		StatValue.BackgroundTransparency = 1
		StatValue.ZIndex = 14
		StatValue.Font = Enum.Font.GothamBold
		StatValue.Text = value
		StatValue.TextSize = 16
		StatValue.TextColor3 = Color3.fromRGB(255, 255, 255)
		StatValue.TextXAlignment = Enum.TextXAlignment.Left
		StatValue.Parent = StatFrame

		return StatValue
	end

	local runtimeStat = createStat("Session Runtime", "00:00:00", 0)
	local diamondStat = createStat("Diamond", "0", 1)
	local earnStat = createStat("Diamond Earned", "0", 2)
    local daycount = createStat("Day Count", "0", 3)

	local function updateUI()
		runtimeStat.Text = formatTime(os.time() - startTime)
		pcall(function()
            local maindiamond = game:GetService("Players").LocalPlayer:GetAttribute("Diamonds")
			diamondStat.Text = tostring(maindiamond)
			earnStat.Text = tostring(maindiamond - olddiamond)
            daycount.Text = tostring(game:GetService("Players").LocalPlayer.leaderstats["Max Days"].Value)
		end)
		StatusContent.Text = currentStatus
	end

	task.spawn(function()
		while true do
			updateUI()
			task.wait(0.5)
		end
	end)

	return ScreenGui
end

local overlay = createOverlay()
overlay.Parent = game:GetService("CoreGui")

TeleportService = game:GetService("TeleportService")
repeat task.wait(1) until game:IsLoaded() and game:GetService("Players").LocalPlayer

task.wait(5)
if game.PlaceId ~= 126509999114328 then
    TeleportService:Teleport(126509999114328)
return end

function serverhop()
    local PlaceId = game.PlaceId
    TeleportService:Teleport(PlaceId)
end

repeat task.wait(1) until game.Players.LocalPlayer
hrp = game.Players.LocalPlayer

maxfindhrpattempt = 10
findhrpattempt = 0
repeat
    findhrpattempt = findhrpattempt + 1
    if findhrpattempt >= maxfindhrpattempt then
        game.Players.LocalPlayer:Kick("Failed to find HumanoidRootPart")
        serverhop()
        task.wait(1)
    end
until game.Players.LocalPlayer

if not (hrp and hrp.Character and hrp.Character:FindFirstChild("HumanoidRootPart")) then
    game.Players.LocalPlayer:Kick("Character Dead")
    while true do
        serverhop()
        task.wait(1)
    end
end

task.spawn(function()
while true do
    local alldiamond = workspace.Items
    for _, diamond in pairs(alldiamond:GetDescendants()) do
        if diamond:IsA("Model") and string.find(diamond.Name, "Diamond") then
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestTakeDiamonds"):FireServer(diamond)
        end
    end
    wait(0.1)
end
end)

maxAttempts = 5
attempts = 0
foundchest = false

task.spawn(function()
while true do
    local chestFoundThisRound = false
    allchest = workspace.Items
    for _, chest in pairs(allchest:GetChildren()) do
        if string.find(chest.Name, "Chest") and not string.find(chest.Name, "Lid") and not string.find(chest.Name, "Snow") then
            foundchest = true
            if hrp and hrp.Character and hrp.Character.HumanoidRootPart then
                hrp.Character.Humanoid.Sit = true
                hrp.Character.HumanoidRootPart.CFrame = chest.WorldPivot*CFrame.new(0,3,0)
            end
            for _, main1 in pairs(chest:GetChildren()) do
                if main1:IsA("BasePart") and main1.Name == "Main" then
                    for _, prompt in pairs(main1:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled == true then
                            prompt.HoldDuration = 0
                            prompt.RequiresLineOfSight = false
                            if hrp and hrp.Character and hrp.Character.HumanoidRootPart then
                                hrp.Character.Humanoid.Sit = true
                                hrp.Character.HumanoidRootPart.CFrame = main1.CFrame*CFrame.new(0,5,0)*CFrame.Angles(0,math.rad(math.random(0,360)),0)
                                hrp.Character.HumanoidRootPart.Anchored = true
                            end
                            task.wait(0.2)
                            fireproximityprompt(prompt)
                            attempts = 0
                            task.wait(0.1)
                            chestFoundThisRound = true
                        end
                    end
                end
            end
        end
    end
    if not chestFoundThisRound then
        attempts = attempts + 1
    end
    task.wait(1)
end
end)

task.spawn(function()
while true do
    task.wait(5)
    if not foundchest then
        game.Players.LocalPlayer:Kick("Not Found Chest")
        serverhop()
    end
    task.wait(2)
end
end)

local webhookUrl = getgenv().webhookUrl
if not webhookUrl then
    warn("Please set getgenv().webhookUrl before running the script!")
    return
end

task.spawn(function()
    while true do
        if attempts >= maxAttempts then
            foundchest = false

            local maindiamond = game:GetService("Players").LocalPlayer:GetAttribute("Diamonds") or 0
            local earned = maindiamond - olddiamond

            if typeof(request) == "function" then
                pcall(function()
                    local data = {
                        content = nil,
                        embeds = { {
                            title = "Alchemy Hub.",
                            color = 5630976,
                            fields = {
                                { name = "⚠️  Name :", value = "|| " .. LocalPlayer.Name .. " ||" },
                                { name = "💎  Earned :", value = "|| " .. tostring(earned) .. " ||" }
                            },
                            footer = { text = "This webhook system make by discord.gg/alchemyhub" },
                            thumbnail = {
                                url = "https://cdn.discordapp.com/attachments/1393668256753254402/1405855945245982832/AlchemyNeta.png?ex=68a058e0&is=689f0760&hm=6ba3a9cec57b3e269f53d78e838beefb569af9265d3fe1ae92e6715bdcde5967"
                            }
                        } },
                        attachments = {}
                    }
                    request({
                        Url = webhookUrl,
                        Method = "POST",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body = HttpService:JSONEncode(data)
                    })
                end)
            end

            game.Players.LocalPlayer:Kick("Got All Chest")
            serverhop()
        end
        task.wait(2)
    end
end)


Toolong = false
task.spawn(function()
while true do
    if not Toolong then
        task.wait(30)
        game.Players.LocalPlayer:Kick("Chest Timeout")
        Toolong = true
    else
        TeleportService:Teleport(126509999114328)
        task.wait(2)
    end
    task.wait(2)
end
end)
