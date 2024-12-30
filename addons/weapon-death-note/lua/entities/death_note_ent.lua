

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:SetModel( "models/death_note/DeathNote.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
	function ENT:AcceptInput(ply, caller)
		if caller:IsPlayer() && !caller.CantUse then
			caller.CantUse = true
			DN_CanUseEntity[caller] = true
			timer.Simple(3, function()  caller.CantUse = false end)
	
			if caller:IsValid() then
				net.Start( "deathnote_gui" )
					net.WriteTable(DN_DeathTypes)
				net.Send( caller ) 
			end
		end
	end
	function ENT:Use( activator, caller )
		return
	end
	function ENT:Think()
	end
elseif CLIENT then
	function ENT:Draw()
		self:DrawModel()   
	end
end

ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"

ENT.PrintName 		= "Death Note"
ENT.Author 			= "Blue-Pentagram And TheRowan"
ENT.Spawnable 		= true
ENT.AdminOnly		= true
ENT.Category 		= "Death Note"