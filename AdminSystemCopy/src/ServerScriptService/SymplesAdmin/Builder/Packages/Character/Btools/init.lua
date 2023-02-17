local module = {
	Name = "Btools",
	Description = "get Btools",
	Location = "Player",
}

module.Execute = function(Client, Type, Attachment, value)
	if Type == "command" then
		local playerDissallowedAliases =  module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name) 
		local commandDissallowedAliases = false
		local playerRank = module.API.getAdminLevel(Client.UserId, Client.Name)

		if Attachment ~= nil then module.API.Players.notify(Client, "System", "no argument needed",true) return end
		

		if playerDissallowedAliases ~= false then
			for _, v in ipairs(playerDissallowedAliases) do
				if string.lower(Attachment) == string.lower(v) then
					module.API.Players.notify(Client, "System", string.format("Invalid Permission to run %q", Attachment),true)
					return false
				end
			end
		end
		
		if module.Settings["Settings"].SpecialAdminSettings[playerRank] then
			if module.Settings["Settings"].SpecialAdminSettings[playerRank]["RemoveTools"] then
				commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["RemoveTools"]
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
		
		local F3X = Instance.new("Tool") 
		F3X.GripPos = Vector3.new(0, 0, 0.4)
		F3X.CanBeDropped = false
		F3X.ManualActivationOnly = false
		F3X.ToolTip = "Building Tools by F3X"
		F3X.Name = "Building Tools"
		
		
		local clonedDeps = script:FindFirstChild("F3X Deps"):Clone()
		for _, BaseScript in clonedDeps:GetDescendants() do
			if BaseScript:IsA("BaseScript") then
				BaseScript.Disabled = false
			end
		end
		for _, Child in clonedDeps:GetChildren() do
			Child.Parent = F3X
		end
		clonedDeps:Destroy()
		
		local BackPack = Client:FindFirstChildOfClass("Backpack")
		if BackPack then
			F3X:Clone().Parent = BackPack
		else
			module.API.Players.notify(Client, "System", string.format("Could not find %q's backpack", Client.Name),true)
		end
	end
end

return module
