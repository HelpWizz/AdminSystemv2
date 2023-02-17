-- refernce Command 4 api
local module = {}
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local GroupService = game:GetService("GroupService")
local PolicyService = game:GetService("PolicyService")




local API = {}
local globalAPI
local t = {}
local groupCache = {}


API.Players = {
	["Methods"] = {
		["sendListToPlayer"] = "sendList",
		["doThisToPlayers"] = "executeWithPrefix",
		["getPlayerWithName"] = "getPlayerByName",
		["GetPlayersFromNameSelector"] = "GetPlayersFromNameSelector",
		["getPlayerWithFilter"] = "getPlayerWithFilter",
		["getUserIdWithName"] = "getUserIdFromName",
		["getCharacter"] = "getCharacter",
		["filterText"] = "filterString",
		["checkHasPermission"] = "checkPermission",
		["getAdminLevel"] = "getAdminLevel",
		["getPlayerPermissions"] = "getPlayerPermissions",
		["GetPlayerByNamePartial"] = "getPlayerByNamePartial",
		["getAdmins"] = "getAdmins",
		["registerPlayerAddedEvent"] = "listenToPlayerAdded",
	}
}

local function containsDisallowed(tbl: {any})
	local allowedTypes = {"table", "function", "thread"}
	for _, value in ipairs(tbl) do
		return typeof(value) == "userdata" or allowedTypes[type(value)] ~= nil
	end
end


local function sandboxFunc(func: (any) -> (any))
	local function returnResults(success, ...)
		return success and (not containsDisallowed({...}) and ... or "API returned disallowed arguments. Vulnerability?") or "An error occured."
	end

	return function(...)
		if containsDisallowed({...}) then
			return "Disallowed input!"
		end

		return returnResults(pcall(func, ...))
	end
end

local function makeBindable(func: (any) -> (any)): BindableEvent
	local Bindable = Instance.new("BindableFunction")
	Bindable.OnInvoke = not table.find(module, func) and func or sandboxFunc(func)
	return Bindable
end



function API.Players.GetPlayersFromNameSelector(Client: Player, Player: string): {Player}?
	local playerList = {}
	Player = string.lower(Player)
	local clientAdminLevel = API.Players.getAdminLevel(Client.UserId)

	if clientAdminLevel
		and module.DisableTable[clientAdminLevel]
		and module.DisableTable[clientAdminLevel][Player] == true then
		return false
	end

	local function getWithName(Player)
		local prefixes = {
			["all"] = function()
				for _, player in ipairs(Players:GetPlayers()) do
					table.insert(playerList, player)
				end
			end,

			["others"] = function()
				for _, player in ipairs(Players:GetPlayers()) do
					if player.UserId ~= Client.UserId then
						table.insert(playerList, player)
					end
				end
			end,

			["me"] = function()
				table.insert(playerList, Client)
			end,

			["random"] = function()
				table.insert(playerList, Players:GetPlayers()[math.random(1, #Players:GetPlayers())])
			end
		}

		if prefixes[tostring(Player)] then
			prefixes[tostring(Player)]()
		else
			table.insert(playerList, API.Players.getPlayerByName(Player))
		end
	end

	if string.match(Player, ",") then
		for PlayerName in string.gmatch(Player, "([^,]+)(,? ?)") do
			getWithName(PlayerName)
		end
	else
		getWithName(Player)
	end
	if #playerList == 0 then
		if API.Players.getPlayerByNamePartial(Player) ~= false then
			table.insert(playerList,API.Players.getPlayerByNamePartial(Player))
		end
	end
	return (#playerList > 0 and playerList) or nil
end

function API.Players.executeWithPrefix(Client: Player, Player: string, Callback: (player: Player) -> (any))
	Player = string.lower(Player)
	local List = API.Players.GetPlayersFromNameSelector(Client, Player)

	if List then
		for _, v in ipairs(List) do
			Callback(v)
		end
		return true
	else
		return false
	end
end

function API.Players.sendList(Player: Player, Type,Title: string, Attachment)
	module.Remotes.Event:FireClient(Player, Type, Title, Attachment)
end

function API.Players.getPlayerByName(Player: string): Player | nil
	for _, v in ipairs(Players:GetPlayers()) do
		if string.lower(v.Name) == string.lower(Player) then
			return v
		end
	end
	return nil
end

function API.Players.getPlayerByUserId(Player: number?): boolean | Player
	for _, v in ipairs(Players:GetPlayers()) do
		if v.UserId == Player then
			return v
		end
	end
	return false
end

function API.Players.getPlayerByNamePartial(Player: string): boolean | Player
	for _, v in ipairs(Players:GetPlayers()) do
		if string.lower(string.sub(v.Name, 1, #Player)) == string.lower(Player) then
			return v;
		end
	end
	return false
end

function API.Players.getPlayerInfo(Player: Player): {number | string}
	local age = "false"
	local safeChat = "true"
	if API.Players.getPlayerByName(Player.Name) ~= nil then
		age = Player.AccountAge
		local filterResult = TextService:FilterStringAsync('C7RN', Player.UserId)
		if filterResult:GetChatForUserAsync(Player.UserId) == 'C7RN' then
			safeChat = "false"
		end
	end
	return {age, safeChat}
end


function API.Players.getAdminLevel(ClientId: number, ClientName: string)
	local Mod, Admin, HeadAdmin, Owner = false, false, false, false
	local clientPlayer: Player = API.Players.getPlayerByUserId(ClientId) or  API.Players.getPlayerByName(ClientName)
	
	for i, v in pairs(module.globalAdmins) do
		if v["Type"] == "Player" then
			if v["ID"] == ClientId or v["Name"] == ClientName then
				return v["AdminRank"]
			end
		end
        
        if v["Type"] == "Group" then
            if #v["Rank"] == 2 then
                if clientPlayer:IsInGroup(v["ID"]) and ( clientPlayer:GetRankInGroup(v["ID"]) <= v["Rank"][1] 
                    and clientPlayer:GetRankInGroup(v["ID"]) >= v["Rank"][2] ) then
                    return v["AdminRank"]
                else
                    if clientPlayer:IsInGroup(v["ID"]) and ( clientPlayer:GetRankInGroup(v["ID"]) == v["Rank"] ) then
                        return v["AdminRank"]
                    end
                end
            end
			
		end
	end
	
	--< if not an admin then
	return "None"
end

function API.Players.getPlayerPermissions(ClientID: number, ClientName: string)
	local clientAdminRank = API.Players.getAdminLevel(ClientID, ClientName)
	if clientAdminRank == "None" then return {} end
	
	return module.Settings["Settings"]["Permissions"][clientAdminRank]["Permissions"]
end

function API.Players.getPlayerDissallowedAliases(ClientID: number, ClientName: string)
	local clientAdminRank = API.Players.getAdminLevel(ClientID, ClientName)
	if clientAdminRank == "None" then return false 
		
	else if module.Settings["Settings"]["Permissions"][clientAdminRank]["DisallowPrefixes"] then return module.Settings["Settings"]["Permissions"][clientAdminRank]["DisallowPrefixes"] else return false end end
end

function API.Players.getPlayerWithFilter(filter: (Instance) -> boolean): any
	for _, v in ipairs(Players:GetPlayers()) do
		if filter(v) == true then
			return v;
		end
	end
	return nil
end

function API.Players.getUserIdFromName(Player: string): number
	local user = Players:GetUserIdFromNameAsync(Player)
	return user
end

function API.Players.getUserNameFromId(Player: number): string
	local user = Players:GetNameFromUserIdAsync(Player)
	return user
end

function API.Players.listenToPlayerAdded(Function)
	table.insert(t, Function)
	for _, client in ipairs(Players:GetPlayers()) do
		pcall(Function, client)
	end 
end

function API.Players.hint(To: Player|string, From: string, Content: string, Duration: number?)
	local attachment = {["From"] = From, ["Content"] = Content, ["Duration"] = Duration}
	module.Remotes.Event:FireAllClients("newHint", "", attachment)
end

function API.Players.ServerMessage(To: Player|string, From: string, Content: string, Duration: number?)
	local attachment = {["From"] = From, ["Content"] = Content, ["Duration"] = Duration}
	module.Remotes.Event:FireAllClients("ServerMessage", "", attachment)
end

function API.Players.notifyWithAction(To: Player|string, Type, From: string, Content: string): BindableEvent
	local Bindable = Instance.new("BindableEvent")
	local GUID = HttpService:GenerateGUID()
	local attachment = {["From"] = From, ["Content"] = Content}
	Bindable.Name = GUID

	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newNotifyWithAction", {["Type"] = Type, ["GUID"] = GUID}, attachment)
	else
		module.Remotes.Event:FireClient(To, "newNotifyWithAction", {["Type"] = Type, ["GUID"] = GUID}, attachment)
	end

	Bindable.Parent = script.Parent.Parent.Bindables
	return Bindable
end

function API.Players.notify(To: Player|string, From: string, Content: string, timed: boolean?)
	local attachment = {["From"] = From, ["Content"] = Content, ["Timed"] = timed}
	if tostring(To):lower() == "all" then
		module.Remotes.Event:FireAllClients("newNotify", "", attachment)
	else
		module.Remotes.Event:FireClient(To, "newNotify", "", attachment)
	end
end

function API.Players.countDown(From: Player|string, Content: number)
	local attachment = {["From"] = From, ["Content"] = Content}
	module.Remotes.Event:FireAllClients("Countdown", "", attachment)
end

function API.Players.filterString(From: Player, Content: string): (boolean, string)
	if not utf8.len(Content) then --> --> Prevents invalid and oddly behaving UTF8 from being sent
		return false, ""
	end

	if RunService:IsStudio() then return true, Content end

	local success, result = pcall(TextService.FilterStringAsync, TextService, Content, From.UserId)
	if success and result then
		result = result:GetNonChatStringForBroadcastAsync()
	end

	return success, result
end

function API.Players.checkPermission(ClientId: number, Command: string): boolean
	local clientAdminLevel = API.Players.getAdminLevel(ClientId)

	if not clientAdminLevel or not module.PermissionTable[clientAdminLevel] then
		return false
	end

	return (module.PermissionTable[clientAdminLevel][Command] == true
		or module.PermissionTable[clientAdminLevel]["*"] == true)
end

function API.Players.getCharacter(Player: Player): Model?
	if Player and Player.Character and Player.Character.PrimaryPart and Player.Character:FindFirstChildOfClass("Humanoid") then
		return Player.Character
	end
	return nil
end

module = setmetatable({}, {
	__index = function(self, key: string)
		if API.Players.Methods[key] then
			return API.Players[API.Players.Methods[key]]
		else
			return API[key]
		end
	end,
	__metatable = "The metatable is locked"
})

globalAPI = setmetatable({
	checkHasPermission = makeBindable(sandboxFunc(module.Players.checkHasPermission)),
	checkAdmin = makeBindable(sandboxFunc(module.Players.checkAdmin)),
	getAdminLevel = makeBindable(sandboxFunc(module.Players.getAdminLevel)),
	GetPlayersFromNameSelector = makeBindable(sandboxFunc(module.Players.GetPlayersFromNameSelector)),
	getAdminStatus = makeBindable(sandboxFunc(module.Players.getAdminStatus)),
	getPlayerByNamePartial = makeBindable(sandboxFunc(module.Players.getPlayerByNamePartial)),
	getPlayerPermissions = makeBindable(sandboxFunc(module.Players.getPlayerPermissions)),
	getCharacter = makeBindable(sandboxFunc(module.Players.getCharacter)),
	getAdmins = makeBindable(function()
		local Tbl = {}
		for k, v in pairs(module.Players.getAdmins()) do
			Tbl[k] = v
		end
		return setmetatable(Tbl, {__metatable = "The metatable is locked"})
	end)
}, {
	__metatable = "The metatable is locked",
	__newindex = function() error("Attempt to modify a readonly table", 2) end
})

Players.PlayerAdded:Connect(function(Client)
	for _, callback in ipairs(t) do
		pcall(callback, Client)
	end
end)

rawset(_G, "ToluAPI", globalAPI)

return module
