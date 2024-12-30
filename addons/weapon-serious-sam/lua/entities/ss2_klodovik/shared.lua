ENT.Type 			= "anim"
ENT.Base			= "ss2_proj_base"
ENT.PrintName		= "SS2 Klodovik"
ENT.Author			= "Upset"

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "HasTarget")
	self:NetworkVar("Angle", 0, "NewAngle")
end