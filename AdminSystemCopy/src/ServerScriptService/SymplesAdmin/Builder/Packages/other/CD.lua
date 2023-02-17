local module = {
	Name = "Count Down",
	Description = "Count Down from a specific number to 0" ,
	Location = "Server",
}

module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		local playerDissallowedAliases =  module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name) 
		local commandDissallowedAliases = false
		local playerRank = module.API.getAdminLevel(Client.UserId, Client.Name)
		
		

		if playerDissallowedAliases ~= false then
			for _, v in ipairs(playerDissallowedAliases) do
				if string.lower(Attachment) == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
					return false
				end
			end
		end

		if module.Settings["Settings"].SpecialAdminSettings[playerRank] then
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Countdown"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Countdown"]
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
		
		value = Attachment
		
		
		if tonumber(value) == false or tonumber(value) == nil then
			module.API.Players.notify(Client, "System", "Value has to be a number")
			return false
		end
		
		if tonumber(value) < 5 then
			module.API.Players.notify(Client, "System", "Value must be greater or equal to 5")
			return false
		end
		
		module.API.Players.countDown(Client, value)
		module.SetWaypoint.new(Client, "CD", Attachment)
		
	end
end

return module
