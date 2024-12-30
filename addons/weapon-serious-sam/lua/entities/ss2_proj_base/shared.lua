ENT.Type			= "anim"
ENT.PrintName		= "SS2 Projectile Base"
ENT.Author			= "Upset"

function ENT:IsCreature(ent)
	return ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()
end