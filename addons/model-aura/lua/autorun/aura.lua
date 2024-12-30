player_manager.AddValidModel( "Aura", "models/cyanblue/overlord/aura/aura.mdl" );
player_manager.AddValidHands( "Aura", "models/cyanblue/overlord/aura/arms/aura.mdl", 0, "00000000" )


local Category = "Overlord"

local NPC =
{
	Name = "Aura",
	Class = "npc_citizen",
	Health = "100",
	KeyValues = { citizentype = 4 },
	Model = "models/cyanblue/overlord/aura/npc/aura.mdl",
	Category = Category
}

list.Set( "NPC", "npc_aura", NPC )

---------------------------------------------------
