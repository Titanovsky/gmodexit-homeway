hook.Add( '[Ambi.InfoHUD.CanShow]', 'Ambi.Homeway.DontShow', function( eObj )
    if not eObj:CPPIGetOwner() then return false end
end )