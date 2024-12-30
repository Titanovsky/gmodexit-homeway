hook.Add( 'PlayerSay', 'Ambi.Image.SendAll', function( ePly, sText ) 
	if ePly:IsSuperAdmin() and ( string.sub( sText, 1, 19 ) == 'https://i.imgur.com' ) then Ambi.Image.SendAll( sText ) return false end
end )

local net_send_all = net.AddString( 'ambi_image_send_all' )
function Ambi.Image.SendAll( sUrl )
	net.Start( net_send_all )
		net.WriteString( sUrl )
	net.Broadcast()
end