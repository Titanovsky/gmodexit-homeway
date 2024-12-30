local types = {
    [ 'joinleave' ] = true,
    [ 'teamchange' ] = true,
    [ 'namechange' ] = true,
    [ 'joinleave' ] = true,
}

hook.Add( 'ChatText', 'Ambi.Homeway.ChatRestrict', function( _, __, ___, sType )
	if types[ sType ] then return true end
end )