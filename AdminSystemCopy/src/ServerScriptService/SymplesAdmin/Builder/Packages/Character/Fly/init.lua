local module = {
	Name = "Fly",
	Description = "Make a player fly",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		local playerDissallowedAliases =  module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name) 
		local commandDissallowedAliases = false
		local playerRank = module.API.getAdminLevel(Client.UserId, Client.Name)
		
		if Attachment == nil then module.API.Players.notify(Client, "System", "Invalid name given", true) return end
		Attachment = string.lower(Attachment)

		if playerDissallowedAliases ~= false then
			for _, v in ipairs(playerDissallowedAliases) do
				if string.lower(Attachment) == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment), true)
					return false
				end
			end
		end

		if module.Settings["Settings"].SpecialAdminSettings[playerRank] then
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Fly"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Fly"]
			end
		end

		if commandDissallowedAliases ~= false then
			for _, v in ipairs(commandDissallowedAliases) do
				if Attachment == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment), true)
					return false
				end
			end
		end

		if value ~= nil then
			module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value), true)
			return false
		end
		
		local player = module.API.GetPlayersFromNameSelector(Client, string.lower(Attachment))
		if player == nil then
			module.API.Players.notify(Client, "System", string.format("%q is not a valid player or aliases ", Attachment), true)
			return false
		end
		
	
			for _, v in pairs(player) do
				local target = v
				local char = module.API.getCharacter(target)
				if char then
					local scr = script.Fly:Clone()
					local sVal = Instance.new("NumberValue")
					sVal.Name = 'Speed'
					sVal.Value = 1.35
					sVal.Parent = scr

					local NoclipVal = Instance.new("BoolValue")
					NoclipVal.Name = 'Noclip'
					NoclipVal.Value = false
					NoclipVal.Parent = scr

					scr.Name = "toluFlight"

					local part = char:FindFirstChild("HumanoidRootPart")
					if part then
						local oldp = part:FindFirstChild("toluFlight_POSITION")
						local oldg = part:FindFirstChild("toluFlight_GYRO")
						local olds = part:FindFirstChild("toluFlight")
						if oldp then oldp:Destroy() end
						if oldg then oldg:Destroy() end
						if olds then olds:Destroy() end

						local new = scr:Clone()
						local flightPosition = Instance.new("BodyPosition")
						local flightGyro = Instance.new("BodyGyro")

						flightPosition.Name = "toluFlight_POSITION"
						flightPosition.MaxForce = Vector3.new(0, 0, 0)
						flightPosition.Position = part.Position
						flightPosition.Parent = part

						flightGyro.Name = "toluFlight_GYRO"
						flightGyro.MaxTorque = Vector3.new(0, 0, 0)
						flightGyro.CFrame = part.CFrame
						flightGyro.Parent = part

						new.Parent = part
						new.Disabled = false

						char.Humanoid.PlatformStand = true
						module.API.Players.notify(target, "System", "You are now flying. Press E to toggle flight.")
					end
				end
			end
			module.SetWaypoint.new(Client, "fly", Attachment)
			return true
	end
end

return module
