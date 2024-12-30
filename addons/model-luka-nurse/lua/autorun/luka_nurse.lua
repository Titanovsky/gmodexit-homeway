--Add Playermodel
player_manager.AddValidModel( "TDA Luka Nurse", "models/player/luka_nurse.mdl" )
player_manager.AddValidHands( "TDA Luka Nurse", "models/arms/luka_nurse_arms.mdl", 0, "00000000" )

local Category = "Vocaloid"

local NPC =
{
	Name = "Luka Nurse (Friendly)",
	Class = "npc_citizen",
	KeyValues = { citizentype = 4 },
	Model = "models/npc/luka_nurse_npc.mdl",
	Category = Category
}

list.Set( "NPC", "luka_nurse_friendly", NPC )

local NPC =
{
	Name = "Luka Nurse (Enemy)",
	Class = "npc_combine_s",
	Numgrenades = "4",
	Model = "models/npc/luka_nurse_npc.mdl",
	Category = Category
}

list.Set( "NPC", "luka_nurse_enemy", NPC )
