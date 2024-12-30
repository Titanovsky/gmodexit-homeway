ENT.Type 			= "anim"
ENT.PrintName		= "SS2 Plasma Ball"
ENT.Author			= "Upset"
ENT.RenderGroup		= RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Size")
end