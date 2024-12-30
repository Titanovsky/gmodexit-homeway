player_manager.AddValidModel( "Honkai Impact 3rd Aponia", "models/Aponia/honkai_impact/rstar/Aponia/Aponia.mdl" );
player_manager.AddValidHands( "Honkai Impact 3rd Aponia", "models/Aponia/honkai_impact/rstar/Aponia/arms/Aponia_arms.mdl", 0, "00000000" )

local Category = "R. Star's Models"


local NPC =
{
	Name = "Honkai Impact 3rd Aponia (Friendly)",
	Class = "npc_citizen",
	Health = "100",
	KeyValues = { citizentype = 4 },
	Model = "models/Aponia/honkai_impact/rstar/Aponia/Aponia_npc.mdl",
	Category = Category
}

list.Set( "NPC", "honkai_impact_Aponia_friendly", NPC )



local NPC =
{
	Name = "Honkai Impact 3rd Aponia (Enemy)",
	Class = "npc_combine_s",
	Health = "100",
	Numgrenades = "4",
	Model = "models/Aponia/honkai_impact/rstar/Aponia/Aponia_npc.mdl",
	Weapons = { "weapon_pistol" },
	Category = Category
}

list.Set( "NPC", "honkai_impact_Aponia_enemy", NPC )