local module = {
	Name = "Unview",
	Description = "Reset CameraSubject to your character",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		local playerDissallowedAliases =  module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name) 
		local commandDissallowedAliases = false
		local playerRank = module.API.getAdminLevel(Client.UserId, Client.Name)

		if Attachment ~= nil then module.API.Players.notify(Client, "System", "This command does not need an aliases",true) return end
		

		if playerDissallowedAliases ~= false then
			for _, v in ipairs(playerDissallowedAliases) do
				if string.lower(Attachment) == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
					return false
				end
			end
		end

		if module.Settings["Settings"].SpecialAdminSettings[playerRank] then
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Unview"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Unview"]
			end
		end

		if value ~= nil then
			module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true)
			return false
		end

		if commandDissallowedAliases ~= false then
			for _, v in ipairs(commandDissallowedAliases) do
				if Attachment == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
					return false
				end
			end
		end

		local char =  module.API.getCharacter(Client)
		local execScript = script.Execute:Clone()
		execScript.Object.Value = char
		execScript.Parent = Client.Backpack
		execScript.Disabled = false
		module.SetWaypoint.new(Client, "unview", Attachment)
		return true
		
	elseif Type == "firstrun" then
		local object = Instance.new("ObjectValue")
		object.Name = "Object"
		object.Parent = script.Execute
	end
end

return module