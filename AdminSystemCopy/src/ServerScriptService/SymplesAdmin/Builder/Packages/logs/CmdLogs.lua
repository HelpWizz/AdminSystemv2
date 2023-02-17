local module = {
	Name = "Command Logs",
	Description = "Shows a list of commands that have been run",
	Location = "Server",
}
module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		
		if value ~= nil then
			module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true)
			return false
		end
		
		local logs = module.fetchLogs:Invoke()
		for i,v in pairs(logs) do
			local logmsg = os.date("%x %H:%M", tonumber(v.Timestamp)) .. " | " .. tostring(v.Client) .. "; " .. tostring(v.Action) .. "("
			if v.Attachments and #v.Attachments >= 1 then
				logmsg = logmsg .. tostring(v.Attachments) .. ")"
			else
				logmsg = logmsg .. "n/a)"
			end
			logs[i] = logmsg
		end
		module.SetWaypoint.new(Client, "command logs", Attachment)
		module.API.sendListToPlayer(Client, "CommandLogs","Command logs", logs)
		return true
	end
end
return module
