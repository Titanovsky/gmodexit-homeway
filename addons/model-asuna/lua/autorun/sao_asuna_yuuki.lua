player_manager.AddValidModel( "Sword Art Online Asuna Yuuki", "models/Asuna_Yuuki/Sword_Art_Online/rstar/Asuna_Yuuki/Asuna_Yuuki.mdl" );
player_manager.AddValidHands( "Sword Art Online Asuna Yuuki", "models/Asuna_Yuuki/Sword_Art_Online/rstar/Asuna_Yuuki/arms/Asuna_Yuuki_arms.mdl", 0, "00000000" )

local Category = "R. Star's Models"


local NPC =
{
	Name = "Sword Art Online Asuna Yuuki (Friendly)",
	Class = "npc_citizen",
	Health = "100",
	KeyValues = { citizentype = 4 },
	Model = "models/Asuna_Yuuki/Sword_Art_Online/rstar/Asuna_Yuuki/Asuna_Yuuki_npc.mdl",
	Category = Category
}

list.Set( "NPC", "Sword_Art_Online_Asuna_Yuuki_friendly", NPC )



local NPC =
{
	Name = "Sword Art Online Asuna Yuuki (Enemy)",
	Class = "npc_combine_s",
	Health = "100",
	Numgrenades = "4",
	Model = "models/Asuna_Yuuki/Sword_Art_Online/rstar/Asuna_Yuuki/Asuna_Yuuki_npc.mdl",
	Weapons = { "weapon_pistol" },
	Category = Category
}

list.Set( "NPC", "Sword_Art_Online_Asuna_Yuuki_enemy", NPC )