local module = {
	Name = "Kick",
	Description = "Kicks a player",
	Location = "Player",
}

module.Execute = function(Client: Player, Type: string, Attachment: string, value: string)
	if Type == "command" then
		Attachment = string.lower(Attachment)
		local playerDissallowedAliases =  module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name) 
		local commandDissallowedAliases = false
		local playerRank = module.API.getAdminLevel(Client.UserId, Client.Name)
		
		
		if module.Settings["Settings"].SpecialAdminSettings[playerRank] then
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Kick"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Kick"]
			end
		end
		
		if playerDissallowedAliases ~= false then
			for _, v in ipairs(playerDissallowedAliases) do
				if Attachment == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
					return false
				end
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
		if value == nil then
			module.API.Players.notify(Client, "System", "You need to add message",true)
			return false
		end
		
		local players = module.API.GetPlayersFromNameSelector(Client, string.lower(Attachment),true)
		if players ~= nil then
			local kickMessage = module.API.filterText(Client, value)
			
			if kickMessage then
				for i, v: Player in pairs(players) do
					v:Kick(value)
				end
				module.SetWaypoint.new(Client, "kick", Attachment)
				return true
			else
				module.API.Players.notify(Client, "System", "Message you chose is not allowed by roblox, try again", Attachment,true)
			end
			
		else
			module.API.Players.notify(Client, "System", string.format("%q is not a valid player or aliases ", Attachment),true)
			return false
		end
	end
end

return module