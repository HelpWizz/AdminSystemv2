local module = {
	Name = "View",
	Description = "Watches a player",
	Location = "Player",
}


function checkIsGoodEnough(Client: Player, Attaachment: Player): boolean
	local clientAdminRank = module.API.getAdminLevel(Client.UserId, Client.Name)
	local attachmentAdminRank = module.API.getAdminLevel(Attaachment.UserId, Attaachment.Name)
	print(clientAdminRank, attachmentAdminRank)
	local AdminRankList = {
		["Creator"] = 6;
		["HeadAdmin"] = 5;
		["Admin"] = 4;
		["Moderator"] = 3;
		["Trainers"] = 2;
		["None"] = 1;
	}
	
	if AdminRankList[clientAdminRank] > AdminRankList[attachmentAdminRank] then
		return true
	elseif AdminRankList[clientAdminRank] == AdminRankList[attachmentAdminRank] then
		return true
	elseif AdminRankList[clientAdminRank] < AdminRankList[attachmentAdminRank] then
		return false
	else
		return false
	end
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
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["View"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["View"]
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
				if not checkIsGoodEnough(Client, v) then
					module.API.Players.notify(Client, "System", "You cannot use this command against people with a higher admin level than you!",true)
					return false
				end
				print("Exectued")
				local char =  module.API.getCharacter(v)
				local execScript = script.Execute:Clone()
				execScript.Object.Value = char
				execScript.Parent = Client.Backpack
				execScript.Disabled = false
			end
			module.SetWaypoint.new(Client, "view", Attachment)
			return true
			
		else 
			module.API.Players.notify(Client, "System", string.format("%q is not a valid player or aliases ", Attachment),true)
		end
	elseif Type == "firstrun" then
		local object = Instance.new("ObjectValue")
		object.Name = "Object"
		object.Parent = script.Execute
	end
end

return module