player_manager.AddValidModel( "Yowane Haku (Christmas)", "models/player/dewobedil/vocaloid/yowane_haku/christmas_p.mdl" );
player_manager.AddValidHands( "Yowane Haku (Christmas)", "models/player/dewobedil/vocaloid/yowane_haku/c_arms/christmas_p.mdl", 0, "00000000" )

local Category = "Vocaloid"

local NPC =
{
	Name = "Yowane Haku (Christmas)(Friendly)",
	Class = "npc_citizen",
	Health = "100",
	KeyValues = { citizentype = 4 },
	Model = "models/player/dewobedil/vocaloid/yowane_haku/christmas_f.mdl",
	Category = Category
}

list.Set( "NPC", "npc_yowane_haku_christmas_f", NPC )

local NPC =
{
	Name = "Yowane Haku (Christmas)(Enemy)",
	Class = "npc_combine_s",
	Health = "100",
	Numgrenades = "4",
	Model = "models/player/dewobedil/vocaloid/yowane_haku/christmas_e.mdl",
	Category = Category
}

list.Set( "NPC", "npc_yowane_haku_christmas_e", NPC )

if SERVER then
	resource.AddWorkshop("1236087169")
end