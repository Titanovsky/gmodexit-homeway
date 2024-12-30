player_manager.AddValidModel( "Hazmat",                     "models/player/Hazmat/Hazmat.mdl" )
list.Set( "PlayerOptionsModel",  "Hazmat",                     "models/player/Hazmat/Hazmat.mdl" ) 

--Add NPC
local Category = "Spike's NPCs"

local NPC = { 	Name = "Hazmat", 
				Class = "npc_citizen",
				Model = "models/player/Hazmat/Hazmat.mdl",
				Health = "300",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "Hazmat", NPC )

local Category = "Spike's NPCs"

local NPC = { 	Name = "Hazmat Hostile", 
				Class = "npc_combine",
				Model = "models/player/Hazmat/Hazmat.mdl",
				Health = "300",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "Hazmat Hostile", NPC )