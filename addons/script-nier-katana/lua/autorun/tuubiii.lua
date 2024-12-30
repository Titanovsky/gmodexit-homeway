local function AddValidHands( name, model )

	player_manager.AddValidHands( name, model, 0, "0000000" )

end

list.Set( "PlayerOptionsModel", "No. 2 Type-B", "models/player/Tuubiii.mdl" )
player_manager.AddValidModel( "No. 2 Type-B", "models/player/Tuubiii.mdl" )
AddValidHands( "No. 2 Type-B", "models/player/tuubiii_hands.mdl" )