local module = {
	Name = "Music",
	Description = "Play any music in roblox" ,
	Location = "Server",
}
local MarketplaceService = game:GetService("MarketplaceService")
module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		local playerDissallowedAliases =  module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name) 
		local commandDissallowedAliases = false
		local playerRank = module.API.getAdminLevel(Client.UserId, Client.Name)
		if Attachment == nil then module.API.Players.notify(Client, "System", "Invalid name given") return end


		if playerDissallowedAliases ~= false then
			for _, v in ipairs(playerDissallowedAliases) do
				if string.lower(Attachment) == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
					return false
				end
			end
		end

		if module.Settings["Settings"].SpecialAdminSettings[playerRank] then
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Stop"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Stop"]
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
		--> check if id is a number
		if not tonumber(Attachment) then module.API.Players.notify(Client, "System", "ID does not exixt",true) return false end
		if not workspace.MusicIDs:FindFirstChild(Attachment) then module.API.Players.notify(Client, "System", "ID does not exixt or is not currently playing",true) return false end
		local id: Sound = workspace.MusicIDs:FindFirstChild(Attachment)
		id:Stop()
		id:Destroy()
	end
end

return module
