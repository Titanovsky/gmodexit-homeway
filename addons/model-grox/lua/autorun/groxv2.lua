player_manager.AddValidModel( "GroxHD", 				"models/models/justagrox/groxv2/groxv2_pm.mdl" )
list.Set( "PlayerOptionsModel",  "GroxHD",				"models/models/justagrox/groxv2/groxv2_pm.mdl" );
player_manager.AddValidHands( "GroxHD", "models/models/justagrox/groxv2/grox_arm.mdl", 0, "main" );


local NPC = {	Name = "Friendly Grox",
				Class = "npc_citizen",
				Model = "models/models/justagrox/groxv2/groxv2_pm.mdl",
				Health = "100",
				KeyValues = { citizentype = 4 },
				Category = "Spore" }
list.Set( "NPC", "grox_f", NPC )


local NPC = {	Name = "Angry Grox",
				Class = "npc_combine",
				Model = "models/models/justagrox/groxv2/groxv2_pm.mdl",
				Health = "100",
				Category = "Spore" }
list.Set( "NPC", "grox_h", NPC )
