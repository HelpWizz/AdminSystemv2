----------------------------------------------
--- 	Scroll down for settings		   ---
--- Do what you want if you mess something up that's on you (Helpline: Symple#1231) ---
----------------------------------------------
local settings = {};		--// The settings table which contains all settings
local Settings = settings; 	--// For custom commands that use 'Settings' rather than the lowercase 'settings'
----------------------------------------------
settings.DataStore = "tolu.bans"	 -- DataStore the script will use for saving data; Changing this will lose any saved data
--[[ if you would like to use Mockdata please find the DataStoreService script which is SystemPackages -> Services -> DataStoreService then
     find the variable shouldUseMock and set it true
     
     currently not in service (you dont have source code)!!!!!!!!!!!!!!!!!!!!!!!!!!!
]]

settings.Prefix = ":"
settings.SplitKey = " "		-- The space in :kill me (eg if you change it to "/" :kill me would be :kill/me)

---- Admin Commands
settings.Ranks = {
	["Trainers"] = {
		Users = {
			[1] = {["Type"] = "Group", ["Name"] = "「BA」 Special Air Service",["ID"] = 14816579, ["Rank"] = "246:244"};
			[2] = {["Type"] = "Group", ["Name"] = "「BA」 Army Air Corps",["ID"] = 16296473, ["Rank"] = "248:245"};
			[3] = {["Type"] = "Group", ["Name"] = "「BA」 Grenadier Guards",["ID"] = 16271726, ["Rank"] = "11:8"};
			[4] = {["Type"] = "Group", ["Name"] = "「 BA」 Royal Military Police",["ID"] = 16240016, ["Rank"] = "10:8"};
			[5] = {["Type"] = "Group", ["Name"] = "「BA」Intelligence Corps.",["ID"] = 16529575, ["Rank"] = "244:241"};

		};
	};

	["Moderators"] = {
		Users = {
			--// Add users here
			[1] = {["Type"] = "Group", ["Name"] = "「BA」 Special Air Service",["ID"] = 14816579, ["Rank"] = "249:247"};
			[2] = {["Type"] = "Group", ["Name"] = "「BA」 Army Air Corps",["ID"] = 16296473, ["Rank"] = "250:249"};
			[3] = {["Type"] = "Group", ["Name"] = "「BA」 Grenadier Guards",["ID"] = 16271726, ["Rank"] = "14:12"};
			[4] = {["Type"] = "Group", ["Name"] = "「 BA」 Royal Military Police",["ID"] = 16240016, ["Rank"] = "15:11"};
			[5] = {["Type"] = "Group", ["Name"] = "「BA」Intelligence Corps.",["ID"] = 16529575, ["Rank"] = "247:245"};
		};
	};

	["Admins"] = {
		Users = {
			--// Add users here

			[1] = {["Type"] = "Group", ["Name"] = "「BA」 Special Air Service",["ID"] = 14816579, ["Rank"] = "251:250"};
			[2] = {["Type"] = "Group", ["Name"] = "「BA」 Army Air Corps",["ID"] = 16296473, ["Rank"] = "251"};

		};
	};

	["HeadAdmins"] = {
		Users = {
			--// Add users here
			[1] = {["Type"] = "Group", ["Name"] = "BA British Army",["ID"] = 16258437, ["Rank"] = "22:19"};
			[2] = {["Type"] = "Player",["Name"] = "CharlieH3",["ID"] = 110163237}
		};
	};

	["Creators"] = {
		Users = {
			--// Add users here
			[1] = {["Type"] = "Group", ["Name"] = "BA British Army",["ID"] = 16258437, ["Rank"] = "255:29"};
			--[2] = {["Type"] = "Group", ["Name"] = "Royal Enginneers",["ID"] = 14874177, ["Rank"] = "250"}; --> reference on how groups work
			--[1] = {["Type"] = "Player",["Name"] = "sz_Tolu",["ID"] = 3301779507};--> how to add a specific player
		};
	};
};

settings.Permissions = {
	["Trainers"] = {
		["Priority"] = 1,
		["DisallowPrefixes"] = { --> you can add to any Admin rank
			"All",
			"Others"
		},
		["Permissions"] = {
			"Message",
			"View",
			"Unview",
			"Bring",
			"To",
		}
	},
	["Moderator"] = {
		["Inherits"] = "Trainers",
		["Priority"] = 2,
		["DisallowPrefixes"] = { --> you can add to any Admin rank
			"All",
			"Others"
		},
		["Permissions"] = {
			"Kick",
			"ChatLogs",
			"Admins",
			"JoinLogs",
			"Cmds",
			"CmdLogs",

		}
	},
	["Admin"] = {
		["Inherits"] = "Moderator",
		["Priority"] = 3,
		["Permissions"] = {
			"M",
			"View",
			"Unview",
			"Re",
			"Rhats",
			"Rtools",
			"Pm",
			"CD",
			"Kill",
			"Age",
			"Fly",
		}
	},

	["HeadAdmin"] = {
		["Inherits"] = "Admin",
		["Priority"] = 4,
		["Permissions"] = {

		}
	},
	["Creator"] = {
		["Inherits"] = "HeadAdmin",
		["Priority"] = 5,
		["Permissions"] = {
			"Ban",
			"Unban",
			"M",
			"Kick",
			"View",
			"Unview",
			"Bring",
			"ChatLogs",
			"JoinLogs",
			"Cmds",
			"CmdLogs",
			"To",
			"Re",
			"Rhats",
			"Rtools",
			"Pm",
			"CD",
			"slock",
			"Kill",
			"Fly",
			"Unfly",
			"Age",
			"Admins",
			"Ref",
			"Music",
			"Stop",
			"Btools"
		}
	}
}

Settings.SpecialAdminSettings = {
	["HeadAdmin"] = {
		["View"] = {"all", "others", "random"},
		["Ban"] = {"all", "others", "random", "me"},
		["Unban"] = {"all", "others", "random", "me"},
		["To"] = {"all", "others"},
		["Age"] = {"me", "others", "random", "all"},
		["Ref"] = {"all", "others", "random"},
	},

	["Creator"] = {
		["View"] = {"all", "others", "random"},
		["Ban"] = {"all", "others", "random", "me"},
		["Unban"] = {"all", "others", "random", "me"},
		["To"] = {"all", "others"},
		["Age"] = {"me", "others", "random", "all"},
		["Ref"] = {"all", "others", "random"},
		["Music"] = {"me", "others", "random", "all"},
		["Stop"] = {"me", "others", "random", "all"},
		["Btools"] = {"me", "others", "random", "all"}
	}
}
settings.AllCommands = {
	"Ban",
	"Unban",
	"M",
	"Kick",
	"View",
	"Unview",
	"Bring",
	"ChatLogs",
	"JoinLogs",
	"Cmds",
	"CmdLogs",
	"To",
	"Re",
	"Rhats",
	"Rtools",
	"Pm",
	"CD",
	"slock",
	"Kill",
	"Fly",
	"Unfly",
	"Age",
	"Admins",
	"Ref",
	"Music",
	"Stop",
	"Btools"
}

settings.Misc = {
	["Theme"] = "aphotic", -- default theme
	["DefaultThemeColor"] = Color3.fromRGB(22, 26, 29) --  default theme color
}

settings.Description = { --> This for the command list
	["Bring"] = [[Bring a player to you]],
	["Chatlogs"] = [[See what everyone has been saying and when (in your relaltive time)]],
	["Rhats"] = [[Remove all player accessories]],
	["Rtools"] = [[Remove all tools player have]],
	["To"] = [[Go to a player]],
	["Re"] = [[Respawn your character]],
	["Pm"] = [[Private message someone]],
	["Cmds"] = [[Check all commands that exist]],
	["Joinlogs"] = [[Check when people joined the server]],
	["CmdLogs"] = [[Check the commands which have been executed by players]],
	["Kill"] = [[Kill a player instantly]],
	["View"] = [[Watch a player who is the same or lower admin rank as you]],
	["Unview"] = [[Unwatch a player who is the same or lower admin rank as you]],
	["Kick"] = [[Kick a player from the server]],
	["Ban"] = [[Ban a player from the game]],
	["Unban"] = [[Unban a player using their Roblox ID]],
	["CD"] = [[Count Down from a number to 0]],
	["Slock"] = [[Lock the server so no-one can join]],
	["M"] = [[Send a message to the server (everyone can see it)]],
	["Fly"] = [[Make a player fly]],
	["Unfly"] = [[Removes a player's ability to fly]],
	["Age"] = [[Check a players account age and if they have safechat]],
	["Admins"] = [[Get a list of all types of admins in the game from creator to moderator]],
	["Ref"] = [[Refresh your character]],
	["Music"]=  [[Play any music in roblox]],
	["Stop"] = [[Stop any currently playing music in the sever]],
	["Btools"] = [[Recieve Building tools]]
}
return {["Settings"] = settings}