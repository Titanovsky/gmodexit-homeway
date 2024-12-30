local buildings = {
    [ 'build_industry' ] = true,
    [ 'build' ] = true,
    [ 'build_hospital' ] = true,
}

hook.Add( 'PhysgunPickup', 'Ambi.Homeway.Restrict', function( ePly, eObj ) 
    if ( eObj:GetClass() == 'prop_dynamic' ) and Ambi.Homeway.Config.block_buildings[ eObj:GetModel() ] then return false end
    if buildings[ eObj:GetClass() ] then return false end
end )

hook.Add( 'OnPhysgunReload', 'Ambi.Homeway.Restrict', function() return false end )