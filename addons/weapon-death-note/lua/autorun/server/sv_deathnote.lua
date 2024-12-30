

resource.AddFile( "resource/fonts/deathnotefont.ttf" ) -- Not needed for TTT used for the death_mark_ent which pulls from sandbox entity base
local folder = "modules/deathnote/"
DN_DeathTypes = {} -- Table for deathtypes
DN_DeathLocks = {} -- Table for locking deathtypes
DN_DeathNoteUse = {} -- Table for players useing deathnote
DN_CanUseEntity = {} -- Table for players that used the entity based version
DN_TTT_Bypass = {} -- Table for people in ttt with the chance system
DN_ULX_Premissions	= {} -- Table for the ULX admins
TTT_DN_Chance	= {} -- Table for the deathnote chance system

if SERVER then
	util.AddNetworkString( "deathnote_gui" )
	util.AddNetworkString( "deathnote_pen" )
	
	for _, File in SortedPairs(file.Find(folder .. "/*.lua", "LUA"), true) do
		local RemoveLua = string.Split( string.lower(File), "." )
		DN_DeathTypes[RemoveLua[1]] = RemoveLua[1]
		if GetConVar("DeathNote_Debug"):GetBool() then
			print("[Death Note Debug] Module Loaded: "..RemoveLua[1]..".") -- Prints loaded module's i only use to make sure module where loaded    
		end
		AddCSLuaFile(folder .. "/" .. File)
		include(folder .. "/" .. File)
	end

	net.Receive( "deathnote_pen", function( len, ply )
		local plyName = tonumber(net.ReadString())
		local TheDeathType = net.ReadString()
		if TheDeathType == "3nt.F1x" then
			DN_CanUseEntity[ply] = nil
			if GetConVar("DeathNote_Debug"):GetBool() then
				print("[Death Note Debug] Server received from "..ply:Nick()..", A dummy message to reset the entity variable on themself")
			end
			return
		end
		local target = ents.GetByIndex(plyName)
		if GetConVar("DeathNote_Debug"):GetBool() then
			local DN_PlayerNPC_Fix = target:GetClass()
			if target:IsPlayer() then DN_PlayerNPC_Fix = target:Nick() end
			print("[Death Note Debug] Server received from "..ply:Nick()..", Target "..DN_PlayerNPC_Fix..", With the death of "..TheDeathType)
		end
		DeathNote_Function(ply,target,TheDeathType)
	end )
		
	function DeathNote_Function(ply,target,TheDeathType)
		if IsValid( target ) and target:IsNPC() and Ambi.Homeway.Config.block_npc[ target:GetClass() ] then return end
		
		if GetConVar("DeathNote_Debug"):GetBool() then
			print("[Death Note Debug] "..ply:Nick().." Has DN? "..tostring(ply:HasWeapon("death_note"))..", TTT DN? "..tostring(ply:HasWeapon("death_note_ttt"))..", Ent? "..tostring(DN_CanUseEntity[ply]))
		end
		if not ply:HasWeapon("death_note") and not ply:HasWeapon("death_note_ttt") and not DN_CanUseEntity[ply] then -- Let's Do our Death Note Validation check to stop people from opening up a gui and sending the message
			ply:PrintMessage(HUD_PRINTTALK,"Death Note: I am sorry, I'm not allowed to do that for you, please grab my weapon and try again.")
			DeathNote_AdminMessegeExploit(ply,target)
			return -- Lets Stop the code function here
		end
		DeathNote_HA_Fallback = GetConVar("DeathNote_Heart_Attack_Fallback"):GetBool()
		DN_CanUseEntity[ply] = nil
		if gmod.GetGamemode().FolderName != "terrortown" then -- If it's not Terror Town Do the sandbox function
			DeathNote_Timer = GetConVar("DeathNote_DeathTime"):GetInt()
			if not DN_DeathNoteUse[ply] then
				if IsValid( target ) then
					DN_DeathNoteUse[ply] = true
					timer.Simple( DeathNote_Timer, function()
						DN_DeathNoteUse[ply] = nil
						if target:IsPlayer() then
							if not target:Alive() then
								ply:PrintMessage(HUD_PRINTTALK,"Death Note: That Person Is Already Dead")
								DeathNote_FailAdminMessege(ply,target)
								return
							end
						end
						if not IsValid( target ) then
							ply:PrintMessage(HUD_PRINTTALK,"Death Note: That NPC Is Already Dead")
							DeathNote_FailAdminMessege(ply,target)
							return
						end
							if not DN_DeathLocks[TheDeathType] then
								DeathNote_AdminMessege(ply,target,TheDeathType)
								hook.Run( "dn_module_"..TheDeathType, ply,target ) 
								return
							else
								if DeathNote_HA_Fallback then
									ply:PrintMessage(HUD_PRINTTALK,"Death Note: That death is currently in use, swapping to heart attack.")
									TheDeathType = "heartattack" -- So we can use an admin message
									DeathNote_AdminMessege(ply,target,TheDeathType)
									hook.Run( "dn_module_"..TheDeathType, ply,target )
									return
								else
									ply:PrintMessage(HUD_PRINTTALK,"Death Note: That death is currently in use, please try again later.")
									return
								end
							end
					end)
				else
					ply:PrintMessage(HUD_PRINTTALK,"Death Note: That Person Is Already Dead")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK,"Death Note: Is on cooldown.")
			end
		else -- else if it's terror town lets do that instead
			DN_TTT_DeathTime = GetConVar("DeathNote_TTT_DeathTime"):GetInt()
			DN_TTT_AlwaysDie = GetConVar("DeathNote_TTT_AlwaysDies"):GetBool()
			DN_TTT_LoseDN = GetConVar("DeathNote_TTT_LoseDNOnFail"):GetBool()
			DN_TTT_LockOut = GetConVar("DeathNote_TTT_DNLockOut"):GetInt()
			if not target:IsPlayer() then
				ply:PrintMessage(HUD_PRINTTALK,"Death Note: That is not a Player please try again.")
				return
			end
			if not DN_DeathNoteUse[ply] then
				if (target:Alive() and target:IsTerror()) then
					ply:StripWeapon("death_note_ttt")
					DN_DeathNoteUse[ply] = true
					timer.Simple( DN_TTT_DeathTime, function()
						if DN_TTT_AlwaysDie or DN_TTT_Bypass[ply] then -- Always Die
							DN_DeathNoteUse[ply] = nil
							if (target:Alive() and target:IsTerror()) then
								if DN_TTT_Bypass[ply] then
									ply:PrintMessage(HUD_PRINTTALK,"Death Note: Chance system bypassed, due to failed previous attempt.")
								end
								DN_TTT_Bypass[ply] = nil
								DN_TTT_Hook_Run(ply,target,TheDeathType)
							else
								ply:PrintMessage(HUD_PRINTTALK,"Death Note: That Person already dead, Choose a new target.")
								DN_TTT_Regive_DN(ply,DN_TTT_LockOut)
							end
						else
							rolled = math.random(1,10)
							Chance = 11-GetConVar("DeathNote_TTT_Chance"):GetInt() -- 11 so that 9 can still fail if it was 10 it can
							if rolled >= Chance then
								ply:PrintMessage(HUD_PRINTTALK, "DeathNote: You rolled a " .. rolled)
								if (target:Alive() and target:IsTerror()) then
									DN_TTT_Hook_Run(ply,target,TheDeathType)
								else
									ply:PrintMessage(HUD_PRINTTALK,"Death Note: That Person Is Already Dead, You did not lose the Death Note")
									DN_TTT_Regive_DN(ply,DN_TTT_LockOut)
								end
							else
								if not DN_TTT_LoseDN then
									 DN_TTT_Regive_DN(ply,DN_TTT_LockOut)
								end
								ply:PrintMessage(HUD_PRINTTALK, "Death Note: You rolled a " .. rolled .. " And needed to roll a "..Chance.." or above" )
							end	
							DN_DeathNoteUse[ply] = nil
						end
					end)
				else
					ply:PrintMessage(HUD_PRINTTALK,"Death Note: That Person Is Already Dead")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK,"Death Note: The Death Note is in cooldown.")
			end
		end
	end
	
	function DN_TTT_Hook_Run(ply,target,TheDeathType)
		if not DN_DeathLocks[TheDeathType] then
			hook.Run( "dn_module_"..TheDeathType, ply,target ) 
			return
		else
			if DeathNote_HA_Fallback then
				ply:PrintMessage(HUD_PRINTTALK,"Death Note: That death is in use going to heart attack.")
				TheDeathType = "heartattack" -- incase of admin message
				hook.Run( "dn_module_"..TheDeathType, ply,target )
				return
			else
				if GetConVar("DeathNote_TTT_BypassChance"):GetBool() then
					ply:PrintMessage(HUD_PRINTTALK,"Death Note: That death is in use, please try again, You have a free kill to claim.")
					DN_TTT_Bypass[ply] = true
				else
					ply:PrintMessage(HUD_PRINTTALK,"Death Note: That death is in use, please try your luck again.")
				end
				return
			end
		end
	end
	
	function DN_TTT_Regive_DN(ply,DN_TTT_LockOut)
	if not ply:Alive() then return end -- If there dead they can't really get the dn back can't they.
	ply:PrintMessage(HUD_PRINTTALK,"Death Note: You have lost the Death Note, it will return in "..DN_TTT_LockOut.." seconds.")
	timer.Simple( DN_TTT_LockOut, function()
		if (ply:Alive() and ply:IsTerror()) then
			ply:Give( "death_note_ttt" )
			ply:PrintMessage(HUD_PRINTTALK,"Death Note: The Death Note has returned to your red bloody hands.")
		end
	end )
	end
	
	function dn_messages(ply,target,TTTDeath)
		if gmod.GetGamemode().FolderName != "terrortown" then -- SANDBOX
			if !IsValid(target) then return end
			if target:IsPlayer() then
				target:PrintMessage(HUD_PRINTTALK,"Death Note: Died via the Death Note killed by '"..ply:Nick().."'")
			end
			return
		else -- TTT
			DN_TTT_TellKillerVar = "Death Note: Died via the Death Note killed by '"..ply:Nick().."'"
			if not GetConVar("DeathNote_TTT_ShowKiller"):GetBool() then
				DN_TTT_TellKillerVar = "Death Note: Died via the Death Note"
			end
			target:PrintMessage(HUD_PRINTTALK,DN_TTT_TellKillerVar)
			if GetConVar("DeathNote_TTT_MessageAboutDeath"):GetBool() then
				PrintMessage(HUD_PRINTTALK,"Death Note: "..target:Nick().." "..TTTDeath)
			end
		end
	end
	
	function dn_reset_debug(ply) -- This get's called with weapon reload's bot SandBox and TTT
		if GetConVar("DeathNote_Debug"):GetBool() and !ply.PreventDNDebugSpam then
			ply.PreventDNDebugSpam = true
			timer.Simple( 3, function() 
				ply.PreventDNDebugSpam = false
			end)
			if DeathNote_AdminCheck(ply) then
				ply:PrintMessage(HUD_PRINTTALK,"Death Note Admin: You Reset Everyone's Death Note")
				PrintMessage(HUD_PRINTTALK,"Death Note Admin: "..ply:Nick().." Has Reset Everyone's Death Note")
				dn_reset_tables()
			end
		end
	end

	function dn_reset_tables()
		table.Empty(DN_DeathNoteUse)
		table.Empty(DN_DeathLocks)
		table.Empty(DN_TTT_Bypass)
		table.Empty(DN_CanUseEntity)
	end
		
	function DeathNoteDeathInUse(DeathTypeToLockOut,Lock) -- let's change the deathtype if it's locked or not
		DN_DeathLocks[DeathTypeToLockOut] = Lock
		if GetConVar("DeathNote_Debug"):GetBool() then
			print("-----[Death Note Debug]-----")
			print("Death's In Use Update")
			PrintTable(DN_DeathLocks)
			print("----------------------------")
		end
	end
		
	function DeathNote_RemoveEntity(ply,target) -- The function that is called
		RemoveEntity = GetConVar("DeathNote_RemoveUnkillableEntity"):GetBool() -- Lets grab the console command
		if GetConVar("DeathNote_Debug"):GetBool() then
				print("[Death Note Debug] Should be removing entities: "..tostring(RemoveEntity))
		end
		if not IsValid(target) then return end
		if target:IsPlayer() then return end
		if not RemoveEntity then
			ply:PrintMessage(HUD_PRINTTALK,"Death Note: "..target:GetClass().." was unkillable and command not enabled to remove unkillable NPCs/Next Bots.") 
		else
			if target:Health() >= 1 then -- since npc's around for a little bit after there death if there health is above zero that means they survived and need a fake ragdoll
				ply:PrintMessage(HUD_PRINTTALK,"Death Note: "..target:GetClass().." was unkillable by the Death Note and has been removed.") 
				DeathNote_AdminRemoveEntity(ply,target)
				local DNTargetModel = target:GetModel()
				DeathNote_Create_Ragdoll(DNTargetModel,target) -- Not doing physcics proply for ragdoll and making shovel move
				target:Remove() -- lets remove the entity
			end
		end
	end
	
	function DeathNote_Create_Ragdoll(DNTargetModel,target) -- Createing a ragdoll if remove entity is aviable (can be in the remove entity part but got a new function for my simple sake)
		local DN_Ragdoll = ents.Create( "prop_ragdoll" )
		if ( !IsValid( DN_Ragdoll ) ) then return end 
		if not IsValid(DN_Ragdoll) then return nil end
		DN_Ragdoll:SetPos( target:GetPos() )
		DN_Ragdoll:SetAngles( target:GetAngles() )
		DN_Ragdoll:SetOwner(ply)
		DN_Ragdoll:SetModel(target:GetModel())
		DN_Ragdoll:Spawn()
		DN_Ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		local bones = DN_Ragdoll:GetPhysicsObjectCount()-1
		local velocity = target:GetVelocity()
		for i=0, bones do
			local bone = DN_Ragdoll:GetPhysicsObjectNum(i)
			if IsValid(bone) then
				local bp, ba = target:GetBonePosition(DN_Ragdoll:TranslatePhysBoneToBone(i))
				if bp and ba then
					bone:SetPos(bp)
					bone:SetAngles(ba)
				end
			bone:SetVelocity(velocity)
			end
		end
		timer.Simple(30, function() if IsValid(DN_Ragdoll) then DN_Ragdoll:Remove() end end)
	end
	
	hook.Add( "PlayerDeath", "DeathNoteStopEntityUsage", function( ply ) -- This Hook Fixes up if you die while the Entity version was opened prevent a stored killed
		if DN_CanUseEntity[ply] then
			DN_CanUseEntity[ply] = nil
		end
	end )

	function DeathNote_TTT_Corpse_Edit(target,deathtype)
		if gmod.GetGamemode().FolderName != "terrortown" then return end
		if GetConVar("DeathNote_Debug"):GetBool() then
			print("[Death Note Debug] Is corpse editing disabled: "..tostring(GetConVar("DeathNote_TTT_DisableCorpseEditing"):GetBool()))
		end
		if GetConVar("DeathNote_TTT_DisableCorpseEditing"):GetBool() then return end
		for _, ent in ents.Iterator() do
			if ( ent:GetClass() == "prop_ragdoll" ) then
				if ent.sid64 == target:SteamID64() then
					if deathtype == "ignite" then
						if ent.dmgtype != 268435464 then return end -- 268435464 is the fre damage of the dn appartly
					end
					if deathtype == "fall" then
						if ent.dmgtype != 32 then return end
					end
					ent.dmgwep = "death_note_ttt"
				end
			end
		end		
	end

	function DN_Load_Data_Tables() -- Move to sv_deathnote.lua when made fully
		-- Deathnote Folder File Creation 
		if not file.Exists("deathnote_swep",'DATA') then
			file.CreateDir("deathnote_swep")
		end
		if not file.Exists("deathnote_swep/admin.txt",'DATA') then
			file.Write("deathnote_swep/admin.txt","superadmin,\nadmin,\noperator,\nowner")
		end
		if not file.Exists("deathnote_swep/readme.txt",'DATA') then
			file.Write("deathnote_swep/readme.txt",DN_Readme)
		end
		-- Code to read admin.txt and creeate the ULX admin table
		local DN_AdminList = string.Split( string.gsub(file.Read("deathnote_swep/admin.txt",'DATA'), "\n", ""), "," )
		for i = 1 , #DN_AdminList do 
			if DN_AdminList[i] != "" then
				DN_ULX_Premissions[DN_AdminList[i]] = true
				if GetConVar("DeathNote_Debug"):GetBool() then
					print('[Death Note Debug] Added "'..DN_AdminList[i]..'" To ULX Admin Table')
				end
			end
		end
	end
	hook.Add( "Initialize", "DN_Load_Data_Tables", DN_Load_Data_Tables )
	DN_Load_Data_Tables() -- This is here for lua refreshing purpose, to remake the tables for "DN_ULX_Premissions" and "TTT_DN_Chance"
end


--------------- ADMIN MESSEGES ---------------
function DeathNote_AdminCheck(ply)
	if GetConVar("DeathNote_ulx_installed"):GetBool() then 
		if DN_ULX_Premissions[ply:GetNWString("usergroup")] then
				return true
		end
	else
		if ply:IsAdmin() then
			return true
		end
	end
	return false
end

function DeathNote_AdminMessege(ply,target,TheDeathType)
	if GetConVar("DeathNote_Admin_Messages"):GetBool() then
		for k,v in pairs( player.GetAll() ) do
			if DeathNote_AdminCheck(v) then
				if target:IsPlayer() then
					v:PrintMessage(HUD_PRINTTALK,"Death Note Admin: "..ply:Nick().." has used the Death Note on "..target:Nick()..". ("..TheDeathType..")")
				else
					v:PrintMessage(HUD_PRINTTALK,"Death Note Admin: "..ply:Nick().." has used the Death Note on "..target:GetClass()..". ("..TheDeathType..")")
				end
			end
		end
	else return false end
end

function DeathNote_FailAdminMessege(ply,target)
	if GetConVar("DeathNote_Admin_Messages"):GetBool() then
		for k,v in pairs( player.GetAll() ) do
			if DeathNote_AdminCheck(v) then
				if target:IsPlayer() then
						v:PrintMessage(HUD_PRINTTALK,"Death Note Admin: "..ply:Nick().." tried the Death Note on "..target:Nick().." but failed")
					else
						v:PrintMessage(HUD_PRINTTALK,"Death Note Admin: "..ply:Nick().." has used the Death Note on an NPC but failed")
				end
			end
		end
	else return false end
end

function DeathNote_AdminMessegeExploit(ply,target)
	if GetConVar("DeathNote_Admin_Messages"):GetBool() then
		for k,v in pairs( player.GetAll() ) do
			if DeathNote_AdminCheck(v) then
				if target:IsPlayer() then
					v:PrintMessage(HUD_PRINTTALK,"Death Note Admin: "..ply:Nick()..", Had nearly exploited the Death Note on "..target:Nick()..". (died while useing the DN or Trying to use the function without a Death Note)")
				else
					v:PrintMessage(HUD_PRINTTALK,"Death Note Admin: "..ply:Nick()..", Had nearly exploited the Death Note on an NPC. (died while useing the DN or Trying to use the function without a Death Note)")
				end
			end
		end
	else return false end
end

function DeathNote_AdminRemoveEntity(ply,target)
	if GetConVar("DeathNote_Admin_Messages"):GetBool() then
		for k,v in pairs( player.GetAll() ) do
			if DeathNote_AdminCheck(v) then
				v:PrintMessage(HUD_PRINTTALK,"Death Note Admin: '"..target:GetClass().."' was unkillable and has been removed. Done By '"..ply:Nick().."'")
			end
		end
	else return false end
end