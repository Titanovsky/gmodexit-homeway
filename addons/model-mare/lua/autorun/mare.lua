player_manager.AddValidModel( "Mare", "models/cyanblue/overlord/mare/mare.mdl" );
player_manager.AddValidHands( "Mare", "models/cyanblue/overlord/mare/arms/mare.mdl", 0, "00000000" )


local Category = "Overlord"

local NPC =
{
	Name = "Mare",
	Class = "npc_citizen",
	Health = "100",
	KeyValues = { citizentype = 4 },
	Model = "models/cyanblue/overlord/mare/npc/mare.mdl",
	Category = Category
}

list.Set( "NPC", "npc_mare", NPC )

---------------------------------------------------
