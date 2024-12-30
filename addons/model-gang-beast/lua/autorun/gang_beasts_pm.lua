local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	player_manager.AddValidHands( "Gang Beast", "models/risenshine/c_arms_gang_beast.mdl", 0, "00000000" )
	
end

AddPlayerModel( "Gang Beast", "models/risenshine/gang_beast.mdl" )
