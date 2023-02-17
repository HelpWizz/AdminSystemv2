local module = {
	Name = "Commad  List",
	Description = "Shows a list of commands",
	Location = "Server",
}
local t = {}

module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		
		if value ~= nil or Attachment ~= nil then
			module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true)
			return false
		end
		
		t  = module.Settings["Settings"].Description
		module.API.sendListToPlayer(Client, "CommandList","Command List", t)
		module.SetWaypoint.new(Client, "command list", Attachment)
	end
end

return module