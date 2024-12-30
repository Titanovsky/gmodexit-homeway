local ToSteamID = util.SteamIDFrom64

hook.Add( 'CheckPassword', 'Ambi.Whitelist.Check', function( sSteamID64 ) 
    if Ambi.Whitelist.Config.enable and not Ambi.Whitelist.Config.access[ ToSteamID( sSteamID64 ) ] then return false, '[Whitelist] Access Denied!\n\n'..Ambi.Whitelist.Config.text end
end )