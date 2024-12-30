


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
include( 'autorun/server/sv_deathnote.lua' )

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.DN_DeathType = DN_DeathTypes["heartattack"]


if SERVER then
	function SWEP:GetRepeating()
		local ply = self.Owner
		return IsValid(ply)
	end
end

function SWEP:Reload()
	local ply = self.Owner
	dn_reset_debug(ply)
end

function SWEP:PrimaryAttack()

	local ply = self.Owner
	local eyetrace = ply:GetEyeTrace().Entity
	if IsValid( eyetrace) and eyetrace:IsNPC() and Ambi.Homeway.Config.block_npc[ eyetrace:GetClass() ] then return end
	
	if ply:KeyDown(IN_USE) then
		self.DN_DeathType = next( DN_DeathTypes,self.DN_DeathType )
		if self.DN_DeathType == nil then -- if the table is at the end it will give a nil and we will need to redo to restart the table
			self.DN_DeathType = next( DN_DeathTypes,self.DN_DeathType )
		end
		ply:PrintMessage(HUD_PRINTTALK,"Death Note: Selection "..self.DN_DeathType)
	else	
		if !DN_DeathNoteUse[ply] then
			if IsValid(eyetrace) then
				if (eyetrace:IsPlayer() or eyetrace:IsNPC() or eyetrace:IsNextBot()) then
					local entity_target = eyetrace:GetName()
					if !eyetrace:IsPlayer() then 
						entity_target = eyetrace:GetClass() 
					end
					ply:PrintMessage(HUD_PRINTTALK,"Death Note: You have selected, "..entity_target..", With "..DN_DeathTypes[self.DN_DeathType]) -- Nick no work with NPC's
					DeathNote_Function(ply,eyetrace,DN_DeathTypes[self.DN_DeathType])
				end
			end
		else
			ply:PrintMessage(HUD_PRINTTALK,"Death Note: Is on cooldown.")
		end
	end
end

function SWEP:SecondaryAttack()
	if ( SERVER ) then
		net.Start( "deathnote_gui" )
			net.WriteTable(DN_DeathTypes)
		net.Send( self.Owner ) 
	end
end