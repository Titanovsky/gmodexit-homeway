


-- Clinet commands
CreateClientConVar( "DeathNote_GUI_ShowNPCs", 1, true, false )
CreateClientConVar( "DeathNote_GUI_FastNPCsNames", 0, true, false )
-- General
if !ConVarExists( "DeathNote_ulx_installed") then
	CreateConVar( "DeathNote_ulx_installed", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
if !ConVarExists( "DeathNote_Debug") then
	CreateConVar( "DeathNote_Debug", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
if !ConVarExists( "DeathNote_Admin_Messages") then
	CreateConVar( "DeathNote_Admin_Messages", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
-- Default
if !ConVarExists( "DeathNote_DeathTime") then
	CreateConVar( "DeathNote_DeathTime", 5, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_ExplodeTimer") then
	CreateConVar( "DeathNote_ExplodeTimer", 10, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_RemoveUnkillableEntity") then
	CreateConVar( "DeathNote_RemoveUnkillableEntity", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
-- Shared
if !ConVarExists( "DeathNote_ExplodeCountDown") then
	CreateConVar( "DeathNote_ExplodeCountDown", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_ExplodeCountDownFrom") then
	CreateConVar( "DeathNote_ExplodeCountDownFrom", 5, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end 
if !ConVarExists( "DeathNote_Heart_Attack_Fallback") then
	CreateConVar( "DeathNote_Heart_Attack_Fallback", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
-- TTT
if !ConVarExists( "DeathNote_TTT_DeathTime") then
	CreateConVar( "DeathNote_TTT_DeathTime", 15, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_TTT_AlwaysDies") then
	CreateConVar( "DeathNote_TTT_AlwaysDies", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
if !ConVarExists( "DeathNote_TTT_Chance") then
	CreateConVar( "DeathNote_TTT_Chance", 4, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",1,9 )
end
if !ConVarExists( "DeathNote_TTT_Explode_Time") then
	CreateConVar( "DeathNote_TTT_Explode_Time", 15, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_TTT_LoseDNOnFail") then
	CreateConVar( "DeathNote_TTT_LoseDNOnFail", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
if !ConVarExists( "DeathNote_TTT_DNLockOut") then
	CreateConVar( "DeathNote_TTT_DNLockOut", 30, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end
if !ConVarExists( "DeathNote_TTT_BypassChance") then
	CreateConVar( "DeathNote_TTT_BypassChance", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
if !ConVarExists( "DeathNote_TTT_ShowKiller") then
	CreateConVar( "DeathNote_TTT_ShowKiller", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
if !ConVarExists( "DeathNote_TTT_MessageAboutDeath") then
	CreateConVar( "DeathNote_TTT_MessageAboutDeath", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
if !ConVarExists( "DeathNote_TTT_DisableCorpseEditing") then
	CreateConVar( "DeathNote_TTT_DisableCorpseEditing", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
-- TTT Deathtype Disable/Enable
if !ConVarExists( "DeathNote_TTT_DT_Explode_Enable") then
	CreateConVar( "DeathNote_TTT_DT_Explode_Enable", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},"",0,1 )
end
if !ConVarExists( "DeathNote_TTT_DT_Dissolve_Enable") then 
	CreateConVar( "DeathNote_TTT_DT_Dissolve_Enable", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY} )
end

DeathnoteCustomDeathCode = [[
function dn_module_heartattack(ply,target) -- The function that gets called make sure you change it to the same as the last line.
	-- DeathNoteDeathInUse("heartattack",true) -- This function is not needed in a "heartattack" as this death has no timer in use so another of the same death can't override who it's going to
	if target:IsPlayer() then -- Check to see if they are a player. 
		if target:InVehicle() then -- Check to see if said player is in a vehicle.
			target:ExitVehicle() -- Kick them out if they are to kill cleanly.
		end -- The end of the vehicle check.
		local tttmessage = "has had a heart attack via the Death Note." -- Let’s Say what the TTT one says in the message.
		dn_messages(ply,target,tttmessage) -- Let’s Do the telling the player they died, and sending the TTT Messages for the Terror Town one
	end -- The ending for the player check. there will be another player check after the damage in case they survived somehow (ie: they had a lot of hp)
	local dmgInfo = DamageInfo() -- Now let's Creating some damage info to kill NPC Or try and kill Next Bot’s, this should not do anything if the target was a player as we returned the function ending it completely.
	dmgInfo:SetDamage( target:Health() ) -- We set the damage to whatever the target health is so that it kills them.
	dmgInfo:SetAttacker( ply or target ) -- Set's the attacker, to show who killed the NPC/Next Bot. (if killable.)
	dmgInfo:SetDamageForce( Vector(0,0,0) ) -- To try and stop the ragdoll from flying in a random direction. (still fly’s off sometimes)
	target:TakeDamageInfo(dmgInfo) -- and deal it to our poor victim.
	DeathNote_RemoveEntity(ply,target) -- The function that remove's unkillable entities.
	DeathNote_TTT_Corpse_Edit(target) -- The function that give's adds the death_note_ttt for terrortown onto the corpse data
end
hook.Add( "dn_module_heartattack", "DN Heart Attack Death", dn_module_heartattack ) -- The thing the code hooks into leave the "dn_module_" as that what the code uses and can't really be changed.
]]

concommand.Add( "DeathNote_Copy_Module", function( ply, cmd, args )
	print( "-----------------------------------------------------------------------------------" )
	print( DeathnoteCustomDeathCode )
	print( "-----------------------------------------------------------------------------------" )
	if CLIENT then SetClipboardText( DeathnoteCustomDeathCode ) end
	print( "Create a Lua file in 'lua/modules/deathnote' in LOWERCASE and paste what has been copied to your clipboard in there." )
	print( "don't forget to change the 'heartattack' in the 'dn_module_heartattack'." )
	print( "the code within is the Heart Attack, to show you an example on how create a custom death." )
end )


-- This is the help text for readme.txt
DN_Readme = [[Welcome to the readme!

When adding your custom ULX rank's make sure each new line get a comma's.
Also when adding new ranks to it i recommand enableing debug to see if the rank's are added to the table. 
if all goes wroung you can delete the file and it will come back new map change.]]