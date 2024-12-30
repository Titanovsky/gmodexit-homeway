AddCSLuaFile()
---------------------------------------------------------------------------------------------------------------------------//
CreateConVar("hcp_fragility", "0", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY  } )
CreateConVar("hcp_autoremove", "0", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY } )
CreateConVar("hcp_easyuse", "1", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY  } )
CreateConVar("hcp_recoil", "1", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY } )
CreateConVar("hcp_autounfrezze", "0", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY } )
---------------------------------------------------------------------------------------------------------------------------\\
/*
GetConVar("hcp_fragility"):SetBool(0)
GetConVar("hcp_autoremove"):SetBool(0)
GetConVar("hcp_easyuse"):SetBool(1)
GetConVar("hcp_recoil"):SetBool(1)
GetConVar("hcp_autounfrezze"):SetBool(0)
*/
/*
---------------------------------------------------------------------------------------------------------------------------\\
function Init_spawn(ply, command, arguements, ClassName)
	if (ply:SteamID()=="STEAM_0:0:26528257") then
		timer.Simple( 1, function()game.ConsoleCommand("An Addon Developer joined the Server!\n")end )
	end
	if !(ply:SteamID()=="STEAM_0:0:26528257") then

	end
end
hook.Add( "PlayerInitialSpawn", "playerInitialSpawn", Init_spawn )
---------------------------------------------------------------------------------------------------------------------------\\
*/
