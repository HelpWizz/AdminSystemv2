local module = {
	Name = "Toggle slock",
	Description = "Toggles slock, player who is not admin will be kicked if slock is on",
	Location = "Server",
}

local status = false


module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		if value ~= nil or Attachment ~= nil then
			module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true)
			return false
		end
		
		status = not status
		module.API.Players.hint(Client, Client.Name, "Server is now " .. (status and "locked" or "unlocked"))
		module.SetWaypoint.new(Client, "slock", Attachment)
		
	elseif Type == "firstrun" then
		module.API.registerPlayerAddedEvent(function(Client)
			if status then
				local playerAdminRank = module.API.getAdminLevel(Client.UserId, Client.Name)
				if tostring(playerAdminRank) ~= "Creator" or tostring(playerAdminRank) ~= "HeadAdmin" then
					Client:Kick("\nThis server is server locked, consider joining another server!")
				end
			end
		end)
	end
end

return module
