local Category = "Colgate"

local NPC = { 	Name = "Colgate Friendly", 
		Class = "npc_citizen",
		Model = "models/models/dizze/colgate.mdl",
		Health = "300",
		KeyValues = { citizentype = 4 },
		Category = Category	}


list.Set( "NPC", "colgate_friendly", NPC )

local Category = "Colgate"

local NPC = {  Name = "Colgate Hostile",
               Class = "npc_combine",
	       Model = "models/models/dizze/colgate.mdl",
	       Health =  "300",
	       KeyValues = { citizentype = 4 },
	       Category = Category     }

list.Set( "NPC", "colgate_hostile", NPC )