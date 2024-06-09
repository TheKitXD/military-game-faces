local module = {}
module.Settings = require(script.Parent)

function module.AddActivation(player: Player)
	for i,v in pairs(player:GetChildren()) do
		if v.Name == "FacesActivate" then
			v:Destroy()
		end
	end 
	
	local Bool = Instance.new("BoolValue")
	
	Bool.Name = "FacesActivate"
	Bool.Parent = player
end

function module.RemoveActivation(player: Player)
	for i,v in pairs(player:GetChildren()) do
		if v.Name == "FacesActivate" then
			v:Destroy()
		end
	end 
end

function module.Handler(toggle, args)
	if toggle == "activate" then
		local Player = args[1]
		
		module.AddActivation(Player)
	end
end

function module.IsInWhitelist(player: Player)
	if table.find(module.Settings.Whitelist, player.Name) then
		return true
	end
end

function module.AddLoopToPlayer(player:Player)
	local function x()
		while true do
			wait(module.Settings.Delay)
			if player:FindFirstChild("FacesActivate") then
				local y = 0

				for i,v in pairs(module.Settings.Faces) do
					y += 1
				end

				local rand = math.random(1, y)

				game:GetService("Chat"):Chat(player.Character, module.Settings.Faces[rand])
			end
		end
	end
	
	coroutine.wrap(x)()
end

function module.SetupPlayer(player: Player)
	if module.IsInWhitelist(player) then
		player.Chatted:Connect(function(message: string)
			if message == module.Settings.Activation then
				if player:FindFirstChild("FacesActivate") then
					module.RemoveActivation(player)
				else
					module.AddActivation(player)
				end
			end
		end)
		
		module.AddLoopToPlayer(player)
	end
end

function module.Setup()
	for i,player in pairs(game:GetService("Players"):GetPlayers()) do
		module.SetupPlayer(player)
	end
	
	game.Players.PlayerAdded:Connect(function(player: Player)
		module.SetupPlayer(player)
	end)
end

return module
