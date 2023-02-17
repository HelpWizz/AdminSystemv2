local module = {
	Name = "Join logs",
	Description = "Shows a list of who joined",
	Location = "Server",
}
local t = {}

module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		if value ~= nil or Attachment ~= nil then
			module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true)
			return false
		end
		
		module.API.sendListToPlayer(Client, "JoinLogs", "Join logs", t)
		module.SetWaypoint.new(Client, "join logs", Attachment)
		return true
	elseif Type == "firstrun" then
		module.API.registerPlayerAddedEvent(function(Client)
			t[#t + 1] = os.date("%X", os.time()) .. ": " .. Client.Name
		end)
	end
end

return module