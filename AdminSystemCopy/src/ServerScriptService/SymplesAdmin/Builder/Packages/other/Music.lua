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
		if Attachment == nil then module.API.Players.notify(Client, "System", "Invalid name given",true) return end


		if playerDissallowedAliases ~= false then
			for _, v in ipairs(playerDissallowedAliases) do
				if string.lower(Attachment) == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
					return false
				end
			end
		end

		if module.Settings["Settings"].SpecialAdminSettings[playerRank] then
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Music"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Music"]
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
			module.API.Players.notify(Client, "System", "missing value")
			return false
		end
		--> Check if Id exist
		if not tonumber(Attachment) then module.API.Players.notify(Client, "System", "ID does not exixt",true) return false end
		Attachment = tonumber(Attachment)
		value = string.lower(value)
		local Success, Response = pcall(MarketplaceService.GetProductInfo, MarketplaceService, Attachment)
		
		if Success then
			if Response.AssetTypeId == Enum.AssetType.Audio.Value then --> asset exists
				if value == "false" then
					local musicInstance = Instance.new("Sound", workspace.MusicIDs)
					musicInstance.Name = Attachment
					musicInstance.SoundId = Attachment
					musicInstance.Volume = 1
					musicInstance.Looped = false
					musicInstance:Play()
				end
				if value == "true" then
					local musicInstance = Instance.new("Sound", workspace.MusicIDs)
					musicInstance.Name = Attachment
					musicInstance.SoundId = Attachment
					musicInstance.Volume = 1
					musicInstance.Looped = true
					musicInstance:Play()
				end
				module.SetWaypoint.new(Client, "Music", Attachment)
				return true
			else
				module.API.Players.notify(Client, "System", "ID does not exist",true)
				return false
			end
		end
	end
end

return module
