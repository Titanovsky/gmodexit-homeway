local function IsExpectionStopPlayer( ePly )
    return ePly:IsSeniorStaff() or ePly:HasPurchase( 'ability_disable_antibhop' )
end

local CONST = .44
hook.Add( 'OnPlayerHitGround', 'Ambi.Homeway.AntiBHOP', function( ePly )
    if IsExpectionStopPlayer( ePly ) then return end

    local vel = ePly:GetVelocity()
    ePly:SetVelocity( Vector( - ( vel.x * CONST ), - ( vel.y * CONST ), 0 ) )
end )

hook.Add( 'OnPlayerJump', 'Ambi.Homeway.AntiBHOP', function( ePly )
    if IsExpectionStopPlayer( ePly ) then return end
    if timer.Exists( 'Ambi.Homeway.AntiBHOP:'..ePly:SteamID() ) then return end

    ePly.old_jummpower_antibhop = ePly:GetJumpPower()
    ePly:SetJumpPower( 0 )

    timer.Create( 'Ambi.Homeway.AntiBHOP:'..ePly:SteamID(), 1, 1, function() 
        if not IsValid( ePly ) then return end

        ePly:SetJumpPower( ePly.old_jummpower_antibhop or 100 )
    end )
end )