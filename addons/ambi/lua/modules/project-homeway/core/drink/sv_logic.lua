AmbDrinks = AmbDrinks or {}

util.AddNetworkString( 'amb_drinks_start_effects' )

function AmbDrinks.AddDrunk( ePly, fAlcohol, nTimeRemove )

    local alcohol_in_blood = ePly:GetNWFloat( 'Alcohol' )

    if ( alcohol_in_blood >= 20 ) then

        ePly:EmitSound( 'ambient/creatures/town_child_scream1.wav' )
        ePly:Kill()

        return

    end

    ePly:SetNWFloat( 'Alcohol', alcohol_in_blood + fAlcohol )

    timer.Simple( nTimeRemove, function()

      if ( alcohol_in_blood > fAlcohol ) then ePly:SetNWFloat( 'Alcohol', alcohol_in_blood - fAlcohol ) end
        
    end )

    net.Start( 'amb_drinks_start_effects' )
        net.WriteUInt( nTimeRemove, 12 )
    net.Send( ePly )

end
