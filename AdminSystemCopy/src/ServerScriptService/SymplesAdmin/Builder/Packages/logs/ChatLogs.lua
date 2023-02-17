local module = {
	Name = "Chat logs",
	Description = "Shows a list of chat messages",
	Location = "Server",
}
local t = {}

module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		
		if value ~= nil or Attachment ~= nil then
			module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true)
			return false
		end
		
		module.API.sendListToPlayer(Client, "ChatLogs","Chat logs", t)
		module.SetWaypoint.new(Client, "chat logs", Attachment)
		return true
	elseif Type == "firstrun" then
		module.API.registerPlayerAddedEvent(function(Client)
			Client.Chatted:Connect(function(Message)
				t[#t + 1] = os.date("%X", os.time()) .. "| "..Client.Name .. ": " .. Message
			end)
		end)
	end
end

return module