local module = {}
local private = {}

module.Name = "Unban"
module.Description = "Unbans a player from the game globally"
module.Location = "Player"

function module.Execute(Client: Player?, Type: string, Attachment, value)
	if Type == "command" then

		local playerDissallowedAliases =  module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name) 
		local commandDissallowedAliases = false
		local playerRank = module.API.getAdminLevel(Client.UserId, Client.Name)

		if Attachment == nil then module.API.Players.notify(Client, "System", "Invalid name given",true) return end
		

		if module.Settings["Settings"].SpecialAdminSettings[playerRank] then
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Unban"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Unban"]
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
		
		if value ~= nil then
			module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true)
			return false
		end
		
		--> Unban commands start here
		local data = private.DataStore:GetAsync("data")
		if not data then data = {} end
		
		Attachment = tonumber(Attachment)
		local possiblyUserId = Attachment
		if possiblyUserId == 0 or type(Attachment) ~= "number" then module.API.Players.notify(Client, "System", "Could not get ID of player",true) return false end
		
		local possiblyUserName = module.API.Players.getUserNameFromId(possiblyUserId)
		if not possiblyUserName then module.API.Players.notify(Client, "System", "Could not find player with id %q", Attachment,true) end
		
		if data[tostring(possiblyUserId)] then
			data[tostring(possiblyUserId)] = nil
			
			local ok, response  = pcall(private.DataStore.SetAsync, private.DataStore, "data", data)
			module.API.Players.notify(Client, "System", ok and "Successfully unbanned player " .. possiblyUserName  or "An error occured while trying to unban player " .. possiblyUserName .. "\n\nError message:\n" .. response,true)
			module.SetWaypoint.new(Client, "unban", possiblyUserName)
			return true
		else
			module.API.Players.notify(Client, "System", string.format("Could not find player %s in ban data", possiblyUserName),true)
			return false
		end
	end
end

function module.Init()
	private.DataStore = module.Services.DataStoreService:GetDataStore(module.Settings["Settings"].DataStore or "tolu.bans")
end

return module