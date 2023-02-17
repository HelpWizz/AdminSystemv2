local module = {
	Name = "Age",
	Description = "Get a players account age" ,
	Location = "Player",
}
local CONSTANT_BOOLEAN = true
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
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Age"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Age"]
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
		
		if value ~= nil then module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true) return end
		
		local player = module.API.GetPlayerByNamePartial(Attachment)
		if player == false then
			module.API.Players.notify(Client, "System", "Player could not be found") 
			return false
		else
			local accountAge = module.API.Players.getPlayerInfo(player)
			if accountAge[1] == "false" then
				module.API.Players.notify(Client, "System", string.format("Cannot get account age of %q", player.Name),true)
				return false
			end
			module.API.Players.notify(Client, "Account Age", string.format("The account of %q is %s days old \n\n  Safechat: %s", player.Name, (accountAge[1]), accountAge[2]),true)
			module.SetWaypoint.new(Client, "age", Attachment)
			return true
		end
	end
end

return module