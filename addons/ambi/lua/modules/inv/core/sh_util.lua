function Ambi.Inv.GetKey( anyObj )
    --todo for any entities
    if not anyObj then return end

    return anyObj:SteamID()
end

function Ambi.Inv.Log( sLog )
    if not Ambi.Inv.Config.log then return end

    print( '[Inv] '..sLog )
end