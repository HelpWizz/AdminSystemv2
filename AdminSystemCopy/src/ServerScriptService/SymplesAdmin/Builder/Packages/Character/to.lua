local module = {
	Name = "To",
	Description = "go to a player",
	Location = "Player",
}


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
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["To"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["To"]
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
		
		
		local players = module.API.GetPlayersFromNameSelector(Client, string.lower(Attachment))
		if players ~= nil then
			for i, v in pairs(players) do
				local char =  module.API.getCharacter(v)
				local playerCharacter = module.API.getCharacter(Client)
				local primaryPart, primaryPart2 = char and char.PrimaryPart, Client.Character and Client.Character.PrimaryPart
				if primaryPart and primaryPart2 then
					playerCharacter:SetPrimaryPartCFrame(primaryPart.CFrame:ToWorldSpace(CFrame.new(Vector3.new(0, 0, 5), primaryPart.Position)))
				end
			end
			module.SetWaypoint.new(Client, "to", Attachment)
			return true
		else
			module.API.Players.notify(Client, "System", string.format("%q is not a valid player or aliases ", Attachment),true)
			return false
		end
	end
end

return module
