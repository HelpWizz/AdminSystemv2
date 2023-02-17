local module = {
	Name = "UnFly",
	Description = "Removes a player's ability to fly",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		local playerDissallowedAliases =  module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name) 
		local commandDissallowedAliases = false
		local playerRank = module.API.getAdminLevel(Client.UserId, Client.Name)

		if Attachment == nil then module.API.Players.notify(Client, "System", "Invalid name given",true) return end
		Attachment = string.lower(Attachment)

		if playerDissallowedAliases ~= false then
			for _, v in ipairs(playerDissallowedAliases) do
				if string.lower(Attachment) == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
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
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
					return false
				end
			end
		end

		if value ~= nil then
			module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true)
			return false
		end

		local player = module.API.GetPlayersFromNameSelector(Client, string.lower(Attachment))
		if player == nil then
			module.API.Players.notify(Client, "System", string.format("%q is not a valid player or aliases ", Attachment),true)
			return false
		end
		if string.lower(Attachment) == "me" or (table.find(player, tostring(Client.Name)) and #player == 1) then
			for _, v in pairs(player) do
				local target = v
				local char = module.API.getCharacter(target)
				if char then
					local part = char:FindFirstChild("HumanoidRootPart")
					if part then
						local oldp = part:FindFirstChild("toluFlight_POSITION")
						local oldg = part:FindFirstChild("toluFlight_GYRO")
						local olds = part:FindFirstChild("toluFlight")
						if oldp then oldp:Destroy() end
						if oldg then oldg:Destroy() end
						if olds then olds:Destroy() end
					end
					char.Humanoid.PlatformStand = false
				end
			end
			module.SetWaypoint.new(Client, "unfly", Attachment)
			return true
		else
			
			module.API.Players.notify(Client, "System", "You can only run this command on yourself")
			return false
		end
	end
end	

return module
