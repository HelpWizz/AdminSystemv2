-- defo not the best way to code this
local getAdminScripts = script.Parent.Parent.Packages
local module = {}

local function checkValidCommand(command: string, commandTable : {table}): boolean
	for _, v in pairs(commandTable) do
		local alllowerCase = tostring(string.lower(v))
		if alllowerCase == string.lower(command) then
			return true
		else
			continue
		end
	end
	return false
end

local function runCommand(name, client, command, Type, Name, Value)
	for _, v in pairs(getAdminScripts:GetDescendants()) do
		if v:IsA("ModuleScript") and v.Parent:IsA("Folder") then
			local commandLower = string.lower(name)
			if tostring(string.lower(v.Name)) == tostring(commandLower) then
				module = require(v)
				module.Execute(client, Type, Name, Value)
				return v
			end
		end
	end
end             


function changeTableIntoString(seperator: {[string]: string}, list: {}, collection: number, listlength: number):  string
	return table.concat(list, seperator, collection, listlength)
end

module.Init = function()
	module.remotes.BindableEvent.Event:Connect(function(client, location)
		if location ~= script.Parent.Parent then return end
		
		local ClientPackage = require(client:FindFirstChildOfClass("PlayerGui").Client.Client)	
		local ClientAllowedCommands = ClientPackage.AllowedCommands
		local  CleintAdminRank = ClientPackage.Adminrank

		local Settings = module.Settings["Settings"]
		local Prefix = Settings["Prefix"]

		client.Chatted:Connect(function(message)
			if CleintAdminRank == "None" then return end
			local messagePrefix = string.sub(message, 1, 1)
			if message == nil then return end
			local MessageCommand = string.split(message, messagePrefix)[2]
			local commandlist = string.split(MessageCommand, Settings["SplitKey"])

			local command = commandlist[1]
			local argument = nil
			local value = nil

			if messagePrefix == Prefix then

				if #commandlist == 2 then
					argument = commandlist[2]

				elseif #commandlist >= 3 then 
					argument = commandlist[2] 
					value = changeTableIntoString(" ", commandlist, 3, #commandlist)
				else
					if #commandlist ~= 1 then 
						module.API.Players.notify(client, "System", "Something has gone wrong") 
					end
				end
				if checkValidCommand(command, ClientAllowedCommands) then
					runCommand(command, client, command, "command", argument, value)
				else
					if checkValidCommand(command, module.Settings["Settings"].AllCommands) then
						module.API.Players.notify(client, "System", "Invalid permissions to run this command")
					else
						return
					end
				end
			end
		end)	
	end)
end

return module