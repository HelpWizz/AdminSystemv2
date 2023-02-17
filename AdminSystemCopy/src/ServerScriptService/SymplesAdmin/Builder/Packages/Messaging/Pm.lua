local module = {
	Name = "Private message",
	Description = "Send a message to a specific player, others or all and allow then to reply" ,
	Location = "Player",
}

function process(From, Type, To, Content)
	local response: BindableEvent = module.API.Players.notifyWithAction(To, Type, From.Name, Content).Event:Wait()
	local status, response = module.API.filterText(From, response)
	process(To, Type, From, response)
end

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
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["PrivateMessage"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["PrivateMessage"]
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
			module.API.Players.notify(Client, "System", string.format("You need to add message", Attachment),true)
			return true
		end
		

		local Status
		Status, value = module.API.filterText(Client, value)
	
		if Status then
			local players = module.API.GetPlayersFromNameSelector(Client, string.lower(Attachment),true)
			if players ~= nil then
				for _, v in ipairs(players) do
					module.API.doThisToPlayers(Client, v.Name, function(Player)
						coroutine.wrap(function()
							process(Client, "Reply", Player, value)
						end)()
					end)
				end
				module.SetWaypoint.new(Client, "pm", Attachment)
				return true
			end
		else
			module.API.Players.notify(Client, "System", "Your message to \"" .. tostring(Attachment) .. "\" failed to deliver, please retry later",true)
		end
		return false
	end
end

return module