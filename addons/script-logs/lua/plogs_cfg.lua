--
-- General configs
--

-- User groups that can access IP logs
plogs.cfg.IPUserGroups = {
	['superadmin']		= true,
}

-- Window width percentage, I recomend no lower then 0.75
plogs.cfg.Width = 0.75

-- Window height percentage, I recomend no lower then 0.75
plogs.cfg.Height = 0.75

-- Some logs print to your client console. Enable this to print them to your server console too
plogs.cfg.EchoServer = true

-- Allow me to use logs on your server. (Disable if you're paranoid)
plogs.cfg.DevAccess = false

-- Do you want to store IP logs and playerevents? If enabled make sure to edit plogs_mysql_cfg.lua!
plogs.cfg.EnableMySQL = false

-- The log entry limit, the higher you make this the longer the menu will take to open.
plogs.cfg.LogLimit = 200

-- Format names with steamids? If true "aStoned(STEAMID)", if false just "aStoned"
plogs.cfg.ShowSteamID = true

-- Enable/Disable log types here. Set them to true to disable
plogs.cfg.LogTypes = {
	['chat'] 		= false,
	['commands']	= false,
	['connections'] = false,
	['kills'] 		= false,
	['props'] 		= false,
	['tools'] 		= false,
	['darkrp'] 		= false,
	['ulx']			= false,
	['maestro']		= false,
	['pnlr']		= true, -- NLR Zones					|| 	https://scriptfodder.com/scripts/view/583
	['lac']			= true, -- Leys Serverside AntiCheat 	|| 	https://scriptfodder.com/scripts/view/1148
	['awarn2']		= true, -- AWarn2 						||	https://scriptfodder.com/scripts/view/629
	['hhh']			= true, -- HHH 							||	https://scriptfodder.com/scripts/view/3
	['hitmodule']	= true, -- Hitman Module				||	https://scriptfodder.com/scripts/view/1369
	['cuffs'] 		= false, -- Hand Cuffs 					||	https://scriptfodder.com/scripts/view/910
}


--
-- Specific configs, if you disabled the log type that uses one of these the config it doesn't matter
--

-- Command log blacklist, blacklist commands here that dont need to be logged
plogs.cfg.CommandBlacklist = {
	['_sendDarkRPvars']		= true,
	['_sendAllDoorData']	= true,
	['ulib_update_cvar']	= true,
	['ulib_cl_ready'] 		= true,
	['_xgui']				= true,
	['ulx']					= true,
}

-- Tool log blacklist, blacklist tools here that dont need to be logged
plogs.cfg.ToolBlacklist = {
	['myexampletool'] = true,
}