local module = {}
local private = {}

module.Name = "Global Ban"
module.Description = "Bans a player from the game globally"
module.Location = "Player"

function checkIsGoodEnough(Client: Player, Attaachment: Player): boolean
	local clientAdminRank = module.API.getAdminLevel(Client.UserId, Client.Name)
	local attachmentAdminRank = module.API.getAdminLevel(Attaachment.UserId, Attaachment.Name)
	
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


function module.Execute(Client: Player?, Type: string, Attachment, value)
	if Type == "command" then
		
		local playerDissallowedAliases =  module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name) 
		local commandDissallowedAliases = false
		local playerRank = module.API.getAdminLevel(Client.UserId, Client.Name)
		
		if Attachment == nil then module.API.Players.notify(Client, "System", "Invalid name given",true) return end
		Attachment = string.lower(Attachment)

		if module.Settings["Settings"].SpecialAdminSettings[playerRank] then
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Ban"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Ban"]
			end
		end

		if playerDissallowedAliases ~= false then
			for _, v in ipairs(playerDissallowedAliases) do
				if Attachment == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
					return false
				end
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
		
		--> ban command  start from here
		local possiblyUserName = module.API.Players.getPlayerByNamePartial(Attachment)
		
		
		if possiblyUserName == nil then
			module.API.Players.notify(Client, "System", string.format("%q is not a valid player", Attachment),true)
			return false
		end

		
		if not checkIsGoodEnough(Client, possiblyUserName) then
			module.API.Players.notify(Client, "System", "You cannot use this command against people with a higher admin level than you!")
			return false
		end
		
		local possiblyUserId = module.API.Players.getUserIdFromName(possiblyUserName.Name)
		if possiblyUserId == 0 then module.API.Players.notify(Client, "System", string.format("Could not get ID of player %s", possiblyUserName.Name),true) return false end
		
		
		local input = value
		if input == nil then
			module.API.Players.notify(Client, "System", "You need to add message")
			return false
		end
		
		local ok, content = module.API.Players.filterString(Client, value)
		if not ok then
			module.API.Players.hint(Client, "System", "An error occured while trying to filter string message",true)
			return false
		end
		
		local data = private.DataStore:GetAsync("data")
		if not data then data = {} end
		data[possiblyUserId] = { --> I will be using the Bear technique to store this data (yeah I made that up)
			["By"] = {Client.UserId, Client.Name},
			["End"] = "PERM",
			["At"] = os.date("%c", os.time()),
			["Reason"] = content
		}
		

		local ok, response = pcall(private.DataStore.SetAsync, private.DataStore, "data", data)
		module.API.Players.notify(Client, "System", ok and "Successfully banned player " .. possiblyUserId .. "!" or "An error occured while trying to ban player " .. possiblyUserName.Name .. "\n\nError message:\n" .. response,true)
			if ok and possiblyUserName.Name then
			possiblyUserName:Kick("Banned by ".. Client.Name.. "\n\nReason: ".. content)
			module.SetWaypoint.new(Client, "ban", Attachment)
			return true
		end
	end
end

function module.Init()
	private.DataStore = module.Services.DataStoreService:GetDataStore(module.Settings["Settings"].DataStore  or "tolu.bans")
	module.API.Players.listenToPlayerAdded(function(Player: Player)
		
		local ok, data = pcall(private.DataStore.GetAsync, private.DataStore, "data")
		if not ok then
			Player:Kick("Something went wrong while trying to fetch data, retry later")
		end
		
		if data[tostring(Player.UserId)] then
			data = data[tostring(Player.UserId)]
			if data.End == "PERM" then
				Player:Kick("Banned by ".. data.By[2].. " at " .. data.At .. "\n\nReason: " .. data.Reason)
			end
		end
	end)
end

return module