script.Parent.RemoteEvent.OnClientEvent:Connect(function(Table)
	local mod = require(script.Parent["Logs"].handler)
	mod.Remotes = Table
	mod.Init()
end)

