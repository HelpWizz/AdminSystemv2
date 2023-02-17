local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local module = {}

module.AllowedCommands = {}
module.Adminrank = nil
module.DissAllowedAliases = {}


local SystemPackage = script.Parent



function module.buildClientTable(Client)
	script.RemoteEvent:FireClient(Client, module.Remotes)
	module.Adminrank = module.API.getAdminLevel(Client.UserId, Client.Name)
	module.AllowedCommands, module.DissAllowedAliases = module.API.getPlayerPermissions(Client.UserId, Client.Name), module.API.Players.getPlayerDissallowedAliases(Client.UserId, Client.Name)
	ReplicatedStorage["sz_Tolu Remotes"].BindableEvent:Fire(Client.Name)
	script.Core.Enabled = true
end


return module
