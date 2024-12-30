player_manager.AddValidModel( "Saul Goodman",                     "models/player/griffbo/saulgoodman.mdl" )
list.Set( "PlayerOptionsModel",  "Saul Goodman",                     "models/player/griffbo/saulgoodman.mdl" ) 
player_manager.AddValidHands( "Saul Goodman", "models/player/Griffbo/Saulgoodmanarms.mdl", 0, "00000000" )
--Add NPC
local Category = "Griffbo's NPCs"

local NPC = { 	Name = "Saul Goodman (Ally)", 
				Class = "npc_citizen",
				Model = "models/player/griffbo/SaulGoodmanNPC.mdl",
				Health = "250",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "SaulGoodmanAlly", NPC )

local Category = "Griffbo's NPCs"

local NPC = { 	Name = "Saul Goodman (Hostile)", 
				Class = "npc_combine_s",
				Model = "models/player/griffbo/SaulGoodmanNPCHostile.mdl",
				Health = "250",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "SaulGoodmanHostile", NPC )