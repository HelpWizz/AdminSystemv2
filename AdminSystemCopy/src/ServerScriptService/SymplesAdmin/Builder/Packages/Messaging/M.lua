local module = {
	Name = "M",
	Description = "Send a server message" ,
	Location = "Server",
}
local defaultDuration = 10

module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		

		local playerDissallowedAliases =  module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name) 
		local commandDissallowedAliases = false
		local playerRank = module.API.getAdminLevel(Client.UserId, Client.Name)

		if Attachment == nil then module.API.Players.notify(Client, "System", "You need to send a message",true) return end

		if playerDissallowedAliases ~= false then
			for _, v in ipairs(playerDissallowedAliases) do
				if string.lower(Attachment) == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
					return false
				end
			end
		end

		if module.Settings["Settings"].SpecialAdminSettings[playerRank] then
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["ServerMessage"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["ServerMessage"]
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
		
		Attachment = Attachment.. " " .. (value or "")
		local input = Attachment
		local status
		
		status, input = module.API.filterText(Client, input)
		
		if status then
			module.API.Players.ServerMessage(Client, Client.Name, input , defaultDuration)
			module.SetWaypoint.new(Client, "m", Attachment)
			return true
		else
			module.API.Players.notify(Client, "System", "Your message to \"" .. tostring(Attachment) .. "\" failed to deliver, please retry later",true)
			return false
		end
	end
end	
return module
