hook.Add( 'PlayerSpawn', 'Ambi.Homeway.Hospital', function( ePly ) 
    -- if not ePly.after_death then return end
    -- ePly.after_death = false

    -- local tab = Ambi.Homeway.Config.hospital
    -- if not tab.enable then return end

    -- local point = table.Random( tab.points )

    -- timer.Simple( 0.1, function()
    --     if not IsValid( ePly ) then return end

    --     ePly:SetHealth( tab.spawn_hp )
    --     ePly:SetPos( point )
    -- end )
end )

hook.Add( 'PlayerDeath', 'Ambi.Homeway.Hospital', function( ePly ) 
    -- if ePly:IsArrested() then return end 
    -- if ePly:IsJail() then return end 
    
    -- ePly.after_death = true
end )