AmbDrinks = AmbDrinks or {}

function AmbDrinks.GiveEffect( nName )

    hook.Add( 'RenderScreenspaceEffects', 'EffectAlcohol'..nName, function()

        DrawMotionBlur( 0.4, LocalPlayer():GetNWFloat( 'Alcohol' )/10, 0.06 )
        --DrawBloom( 0.65, 2, 9, 9, 1, 1, 1, 1, 1 )
        --DrawColorModify( { ["$pp_colour_brightness"] = 12 } )

    end )

end

function AmbDrinks.RemoveEffect( nName )

    hook.Remove( 'RenderScreenspaceEffects', 'EffectAlcohol'..nName )

end

net.Receive( 'amb_drinks_start_effects', function()

    local time = net.ReadUInt( 12 )
    local rand = math.random( 1, 99999 )

    AmbDrinks.GiveEffect( rand )

    timer.Simple( time, function() AmbDrinks.RemoveEffect( rand ) end )

end )