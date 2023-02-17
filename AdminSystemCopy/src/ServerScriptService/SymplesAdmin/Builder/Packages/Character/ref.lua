local module = {
    Name = "Ref",
    Description = "Refresh your character",
    Location = "Player",
}
module.Execute = function(Client, Type, Attachment, value)
    if Type == "command" then
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
                if module.Settings["Settings"].SpecialAdminSettings[playerRank]["Ref"] then
                    commandDissallowedAliases = module.Settings["Settings"].SpecialAdminSettings[playerRank]["Ref"]
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

            if value ~= nil then
				module.API.Players.notify(Client, "System", string.format("You cannot run this command with a value %q", value),true)
                return false
            end

            local player = module.API.GetPlayersFromNameSelector(Client, string.lower(Attachment))
            if player == nil then
				module.API.Players.notify(Client, "System", string.format("%q is not a valid player or aliases ", Attachment),true)
                return false
            end
         
            if string.lower(Attachment) == "me" or (table.find(player, tostring(Client.Name)) and #player == 1) then
                for i, v in pairs(player) do
                    local target = v
                    local character = module.API.getCharacter(target)
                    local currentLocation = character:GetPrimaryPartCFrame()
                    if character then
                        target:LoadCharacter() 
                        character = target.Character
                        if character:FindFirstChild("ForceField") then 
                            character["ForceField"]:Destroy()
                        end
                        character:SetPrimaryPartCFrame(currentLocation)
                        module.SetWaypoint.new(Client, "ref", Attachment)
                        return true
                    else
						module.API.Players.notify(Client, "System", "Cannot find charcter",true)
                        return false
                    end
                end
            else
				module.API.Players.notify(Client, "System", "You can only run this command on yourself",true)
                return false
            end
        end
    end
end


return module