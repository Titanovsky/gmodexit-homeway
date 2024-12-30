list.Set( "PlayerOptionsModel",  "Defalt_WD", "models/mark2580/defalt_playermodel.mdl" )
player_manager.AddValidModel( "Defalt_WD", "models/mark2580/defalt_playermodel.mdl" )
player_manager.AddValidHands( "Defalt_WD", "models/mark2580/defalt_arms.mdl", 0, "00000000" ) 

local Category = "Watch Dogs"

local NPC = { 	Name = "Defalt_WD (Enemy)", 
				Class = "npc_combine_s",
				Model = "models/mark2580/defalt_combine.mdl",
				Health = "100",
				Squadname = "WD",
				Numgrenades = "4",
                                Category = Category    }

list.Set( "NPC", "Defalt_WD_combine", NPC )

local NPC = { 	Name = "Defalt_WD (Frendly)", 
				Class = "npc_citizen",
				Model = "models/mark2580/defalt_rebel.mdl",
				Health = "300",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "Defalt_WD_rebel", NPC )