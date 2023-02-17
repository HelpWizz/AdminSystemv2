local module = {
	Name = "Kill",
	Description = "Kills a player with the Humanoid method",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		if value ~= nil then
			module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true)
			return false
		end
		
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
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Kill"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Kill"]
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
		
		local players = module.API.GetPlayersFromNameSelector(Client, string.lower(Attachment),true)
		if players ~= nil then
			for i, v in pairs(players) do
				local char =  module.API.getCharacter(v)
				if char then
					char.Humanoid.Health  = 0
				end
			end
			module.SetWaypoint.new(Client, "kill", Attachment)
			return true
			
		else
			module.API.Players.notify(Client, "System", string.format("%q is not a valid player or aliases ", Attachment),true)
			return false
		end
	end
end

return module
