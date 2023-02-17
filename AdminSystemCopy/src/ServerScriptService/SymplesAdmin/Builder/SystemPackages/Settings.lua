----------------------------------------------
--- 	Scroll down for settings		   ---
--- Do not alter the three variables below ---
----------------------------------------------
local settings = {};		--// The settings table which contains all settings
local Settings = settings; 	--// For custom commands that use 'Settings' rather than the lowercase 'settings'
local descs = {};			--// Contains settings descriptions
----------------------------------------------		
settings.DataStore = "Test1"	-- DataStore the script will use for saving data; Changing this will lose any saved data
settings.LocalData = true
--> :NOTE you cannot ban yourself in studio



settings.Prefix = ":"				-- The : in :kill me		-- The ! in !donate; Mainly used for commands that any player can run; Do not make it the same as settings.Prefix
settings.SpecialPrefix = ""			-- Used for things like "all", "me" and "others" (If changed to ! you would do :kill !me)
settings.SplitKey = " "				-- The space in :kill me (eg if you change it to / :kill me would be :kill/me)
settings.BatchKey = "|"	
settings.BanMessage = "Banned"				-- Message shown to banned users upon kick
settings.LockMessage = "Server Has Been Locked"	-- Message shown to people when they are kicked while the game is :slocked

---- Admin Commands
settings.Ranks = {
	["Moderators"] = {
		Users = {
			--// Add users here
		};
	};

	["Admins"] = {
		Users = {
			--// Add users here
		};
	};

	["HeadAdmins"] = {
		Users = {
			--// Add users here
		};
	};

	["Creators"] = {
		Users = {
			--// Add users here (Also, don't forget quotations and all that)
			
		};
	};
};

settings.Permissions = {
	["Moderator"] = {
		["Priority"] = 1,
		["DisallowPrefixes"] = {
			"All",
			"Others"
		},
		["Permissions"] = {
			"Kick",
			"Message",
			"View",
			"Unview"
		}
	},
	["Admin"] = {
		["Inherits"] = "Moderator",
		["Priority"] = 2,
		["Permissions"] = {
			"Ban",
			"Shutdown",
			"Unban",
			"SystemMessage",
			"ServerLock"
		}
	},
	
	["HeadAdmin"] = {
		["Inherits"] = "Admin",
		["Priority"] = 3,
		["Permissions"] = {
			"Ban",
			"Shutdown",
			"TimeBan",
			"Unban",
			"SystemMessage",
			"ServerLock"
		}
	},
	["Creator"] = {
		["Inherits"] = "HeadAdmin",
		["Priority"] = 4,
		["Permissions"] = {
			"Ban",
			"Shutdown",
			"TimeBan",
			"Unban",
			"SystemMessage",
			"ServerLock",
			"Kick",
			"Message",
			"View",
			"Unview",
			"Bring",
		}
	}
}

return {Settings = settings}