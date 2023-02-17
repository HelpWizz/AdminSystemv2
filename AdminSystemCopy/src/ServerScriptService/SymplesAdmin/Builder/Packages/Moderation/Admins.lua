local module = {
	Name = "Admins",
	Description = "Get a list of all types of admins in the game from creator to moderator",
	Location = "Player",
}

local t = {}
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
		
		
		local currentNumber = 0
		table.insert(t, currentNumber+1, "Creator")
		currentNumber = currentNumber + 1
		for i, v in ipairs(module.globalAdmins) do
			if v["AdminRank"] == "Creator" then
				if v["Type"] == "Player" then
					local Username, Id, stringTemplate: string = v["Name"], v["ID"], nil
					stringTemplate = Username.. " | " .. Id
					table.insert(t, currentNumber+1, stringTemplate)
				end
				if v["Type"] == "Group" then
					local Groupname, Id, Grouprank, stringTemplate: string = v["Name"], v["ID"], v["Rank"], nil
					if #Grouprank == 2 then 
						stringTemplate = Groupname.. " | " .. Id.. " | " ..  ( (Grouprank[1].. ":".. Grouprank[2]) )
					else
						stringTemplate = Groupname.. " | " .. Id.. " | " .. Grouprank[1]
					end
					table.insert(t, currentNumber+1, stringTemplate)
				end
				currentNumber = currentNumber + 1
			end
		end
		
		table.insert(t, currentNumber+1, "HeadAdmin")
		currentNumber = currentNumber + 1
		for i, v in ipairs(module.globalAdmins) do
			if v["AdminRank"] == "HeadAdmin" then
				if v["Type"] == "Player" then
					local Username, Id, stringTemplate: string = v["Name"], v["ID"], nil
					stringTemplate = Username.. " | " .. Id
					table.insert(t, currentNumber+1, stringTemplate)
				end
				if v["Type"] == "Group" then
					local Groupname, Id, Grouprank, stringTemplate: string = v["Name"], v["ID"], v["Rank"], nil
					if #Grouprank == 2 then 
						stringTemplate = Groupname.. " | " .. Id.. " | " ..  ( (Grouprank[1].. ":".. Grouprank[2]) )
					else
						stringTemplate = Groupname.. " | " .. Id.. " | " .. Grouprank[1]
					end
					table.insert(t, currentNumber+1, stringTemplate)
				end
				currentNumber = currentNumber + 1
			end
		end
		
		table.insert(t, currentNumber+1, "Admin")
		currentNumber = currentNumber + 1
		for i, v in ipairs(module.globalAdmins) do
			if v["AdminRank"] == "Admin" then
				if v["Type"] == "Player" then
					local Username, Id, stringTemplate: string = v["Name"], v["ID"], nil
					stringTemplate = Username.. " | " .. Id
					table.insert(t, currentNumber+1, stringTemplate)
				end
				if v["Type"] == "Group" then
					local Groupname, Id, Grouprank, stringTemplate: string = v["Name"], v["ID"], v["Rank"], nil
					if #Grouprank == 2 then 
						stringTemplate = Groupname.. " | " .. Id.. " | " ..  ( (Grouprank[1].. ":".. Grouprank[2]) )
					else
						stringTemplate = Groupname.. " | " .. Id.. " | " .. Grouprank[1]
					end
					table.insert(t, currentNumber+1, stringTemplate)
				end
				currentNumber = currentNumber + 1
			end
		end
		
		table.insert(t, currentNumber+1, "Moderator")
		currentNumber = currentNumber + 1
		for i, v in ipairs(module.globalAdmins) do
			if v["AdminRank"] == "Moderator" then
				if v["Type"] == "Player" then
					local Username, Id, stringTemplate: string = v["Name"], v["ID"], nil
					stringTemplate = Username.. " | " .. Id
					table.insert(t, currentNumber+1, stringTemplate)
				end
				if v["Type"] == "Group" then
					local Groupname, Id, Grouprank, stringTemplate: string = v["Name"], v["ID"], v["Rank"], nil
					if #Grouprank == 2 then 
						stringTemplate = Groupname.. " | " .. Id.. " | " ..  ( (Grouprank[1].. ":".. Grouprank[2]) )
					else
						stringTemplate = Groupname.. " | " .. Id.. " | " .. Grouprank[1]
					end
					table.insert(t, currentNumber+1, stringTemplate)
				end
				currentNumber = currentNumber + 1
			end
		end
		
		module.API.sendListToPlayer(Client, "AdminList","Admin List", t)
		module.SetWaypoint.new(Client, "chat logs", Attachment)
		t = {}
		return true
	end
end

return module