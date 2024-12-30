ENT.Type			= "anim"
ENT.Base			= "ss2_proj_base"
ENT.PrintName		= "SS2 Cannonball"
ENT.Author			= "Upset"

ENT.gibs = {
	"models/gibs/antlion_gib_medium_2.mdl",
	"models/gibs/Antlion_gib_Large_1.mdl",
	"models/gibs/Strider_Gib4.mdl",
	"models/gibs/HGIBS.mdl",
	"models/gibs/HGIBS_rib.mdl",
	"models/gibs/HGIBS_scapula.mdl",
	"models/gibs/HGIBS_spine.mdl"
}

for k, v in pairs(ENT.gibs) do
	util.PrecacheModel(v)
end