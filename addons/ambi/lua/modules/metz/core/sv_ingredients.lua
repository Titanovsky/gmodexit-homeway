function Ambi.Metz.IngredientTakeRemove( eObj, dmgInfo )
    if not eObj then return end

    eObj:SetHealth( eObj:Health() - dmgInfo:GetDamage() )

    if ( eObj:Health() <= 0 ) then eObj:Remove() end
end

local classes = {
    [ 'metz_sulfur' ] = function( ePot, eObj ) 
        if not ( ePot:GetClass() == 'metz_phosphor_pot' ) then return end

        local amount = eObj:GetAmount()
        local sulfur = ePot:GetSulfur() 
        local max = Ambi.Metz.Config.pot_sulfur_max 
        if ( sulfur >= max ) then return end

        local new_amount = amount + sulfur
        local remains = new_amount - max
        if ( remains > 0 ) then
            ePot:SetSulfur( max ) 
            eObj:SetAmount( remains )
        else
            ePot:SetSulfur( new_amount )
            eObj:Remove()
        end

        ePot:SetTime( ePot:GetTime() + Ambi.Metz.Config.pot_sulfur_max )
        ePot:SetMaxTime( ePot:GetMaxTime() + Ambi.Metz.Config.pot_sulfur_max )
        ePot:EmitSound( 'ambient/levels/canals/toxic_slime_sizzle3.wav' )
    end,

    [ 'metz_muratic_acid' ] = function( ePot, eObj ) 
        if not ( ePot:GetClass() == 'metz_phosphor_pot' ) then return end

        local amount = eObj:GetAmount() 
        local macid = ePot:GetMacid() 
        local max = Ambi.Metz.Config.pot_macid_max 
        if ( macid >= max ) then return end

        local new_amount = amount + macid
        local remains = new_amount - max
        if ( remains > 0 ) then
            ePot:SetMacid( max ) 
            eObj:SetAmount( remains )
        else
            ePot:SetMacid( new_amount )
            eObj:Remove()
        end

        ePot:SetTime( ePot:GetTime() + Ambi.Metz.Config.pot_macid_max )
        ePot:SetMaxTime( ePot:GetMaxTime() + Ambi.Metz.Config.pot_macid_max )
        ePot:EmitSound( 'ambient/levels/canals/toxic_slime_sizzle3.wav' )
    end,

    [ 'metz_liquid_iodine' ] = function( ePot, eObj ) 
        if not ( ePot:GetClass() == 'metz_iodine_jar' ) then return end

        local amount = eObj:GetAmount() 
        local macid = ePot:GetLiquidIodine() 
        local max = Ambi.Metz.Config.iodine_jar_liquid_iodine_max
        if ( macid >= max ) then return end

        local new_amount = amount + macid
        local remains = new_amount - max
        if ( remains > 0 ) then
            ePot:SetLiquidIodine( max ) 
            eObj:SetAmount( remains )
        else
            ePot:SetLiquidIodine( new_amount )
            eObj:Remove()
        end

        ePot:EmitSound( 'physics/wood/wood_box_footstep'..math.random( 1, 4 )..'.wav' )
    end,

    [ 'metz_water' ] = function( ePot, eObj ) 
        if not ( ePot:GetClass() == 'metz_iodine_jar' ) then return end

        local amount = eObj:GetAmount() 
        local macid = ePot:GetWater() 
        local max = Ambi.Metz.Config.iodine_jar_water_max
        if ( macid >= max ) then return end

        local new_amount = amount + macid
        local remains = new_amount - max
        if ( remains > 0 ) then
            ePot:SetWater( max ) 
            eObj:SetAmount( remains )
        else
            ePot:SetWater( new_amount )
            eObj:Remove()
        end

        ePot:EmitSound( 'ambient/water/drip'..math.random( 1, 4 )..'.wav' )
    end,

    [ 'metz_red_phosphor' ] = function( ePot, eObj )
        if not ( ePot:GetClass() == 'metz_final_pot' ) then return end

        local amount = eObj:GetAmount() 
        local macid = ePot:GetRedPhosphor() 
        local max = Ambi.Metz.Config.final_pot_red_phosphorus_max 
        if ( macid >= max ) then return end

        local new_amount = amount + macid
        local remains = new_amount - max
        if ( remains > 0 ) then
            ePot:SetRedPhosphor( max ) 
            eObj:SetAmount( remains )
        else
            ePot:SetRedPhosphor( new_amount )
            eObj:Remove()
        end

        ePot:SetTime( ePot:GetTime() + Ambi.Metz.Config.final_pot_red_phosphorus_add_time )
        ePot:SetMaxTime( ePot:GetMaxTime() + Ambi.Metz.Config.final_pot_red_phosphorus_add_time )
        ePot:EmitSound( 'ambient/levels/canals/toxic_slime_sizzle3.wav' )
    end,

    [ 'metz_crystal_iodine' ] = function( ePot, eObj )
        if not ( ePot:GetClass() == 'metz_final_pot' ) then return end

        local amount = eObj:GetAmount() 
        local macid = ePot:GetCrystalIodine() 
        local max = Ambi.Metz.Config.final_pot_crystal_iodine_max 
        if ( macid >= max ) then return end

        local new_amount = amount + macid
        local remains = new_amount - max
        if ( remains > 0 ) then
            ePot:SetCrystalIodine( max ) 
            eObj:SetAmount( remains )
        else
            ePot:SetCrystalIodine( new_amount )
            eObj:Remove()
        end

        ePot:SetTime( ePot:GetTime() + Ambi.Metz.Config.final_pot_crystal_iodine_add_time )
        ePot:SetMaxTime( ePot:GetMaxTime() + Ambi.Metz.Config.final_pot_crystal_iodine_add_time )
        ePot:EmitSound( 'ambient/levels/canals/toxic_slime_sizzle3.wav' )
    end,
}

function Ambi.Metz.IngredientStartTouch( self, eObj )
    local Callback = classes[ self:GetClass() ]
    if not Callback then return end

    Callback( eObj, self )
end