--Add Playermodel
player_manager.AddValidModel( "Muffler", "models/jazzmcfly/muffler/muffler.mdl" )
player_manager.AddValidHands( "Muffler", "models/jazzmcfly/muffler/c_arms/muffler.mdl", 0, "0000000" )


--Add NPC
local NPC =
{
	Name = "Muffler",
	Class = "npc_citizen",
	KeyValues = { citizentype = 4 },
	Model = "models/jazzmcfly/muffler/npc/muffler.mdl",
	Category = "Poyo"
}

list.Set( "NPC", "npc_mcfly_muffler", NPC )

-- Send this to clients automatically so server hosts don't have to
if SERVER then
	resource.AddWorkshop("1868146924")
end
