/*
	Addon by Voikanaa	
*/

local Category = "Santa Claus"

local NPC = {	Name = "Santa",
				Class = "npc_citizen",
				Model = "models/player/christmas/santa_npc.mdl",
				Health = "100",
				KeyValues = { citizentype = 4 },
				Weapons = { "weapon_smg1" },
				Category = Category }

list.Set( "NPC", "npc_santa", NPC )


// ----------------------- ENEMY --------------------------


local Category = "Santa Claus"

local NPC = {	Name = "Santa Naughty",
				Class = "npc_combine_s",
				Model = "models/player/christmas/santa_npc.mdl",
				Health = "100",
				Weapons = { "weapon_smg1" },
				Category = Category }

list.Set( "NPC", "npc_santaenemy", NPC )