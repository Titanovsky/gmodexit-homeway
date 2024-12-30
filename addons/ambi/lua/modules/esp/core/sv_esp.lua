local C = Ambi.General.Global.Colors
local Player = FindMetaTable( 'Player' )
local net_string = net.AddString( 'ambi_esp_set_marker' )

function Player:SetESPMarker( sHeader, vPos, sImage, cColor )
    if not sHeader then return end

    net.Start( net_string )
        net.WriteString( sHeader )
        net.WriteVector( vPos or Vector( 0, 0, 0 ) )
        net.WriteString( sImage or 'icon16/bullet_red.png' )
        net.WriteColor( cColor or C.ABS_WHITE )
    net.Send( self )
end

net.AddString( 'ambi_esp_remove_marker' )
function Player:RemoveESPMarker( sHeader )
    if not sHeader then return end

    net.Start( 'ambi_esp_remove_marker' )
        net.WriteString( sHeader )
    net.Send( self )
end