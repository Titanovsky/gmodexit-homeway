function Ambi.Metz.FinalPotInitialize( self )
    self:SetStatus( false )
    self:SetRedPhosphor( 0 )
    self:SetCrystalIodine( 0 )
    self:SetTime( Ambi.Metz.Config.final_pot_time )
	self:SetMaxTime( Ambi.Metz.Config.final_pot_time)

    self:SetMaterial( Ambi.Metz.Config.final_pot_material )
    self:SetColor( Ambi.Metz.Config.final_pot_color )
    self:SetHealth( Ambi.Metz.Config.final_pot_health )
end

function Ambi.Metz.FinalPotTakeDamage( eObj, dmgInfo )
    if not Ambi.Metz.Config.final_pot_can_take_damage then return end

    local self = eObj

    self:SetHealth( self:Health() - dmgInfo:GetDamage() )

    if ( self:Health() <= 0 ) then 
        self:Remove() 
    end
end

function Ambi.Metz.FinalPotUse( eObj, ePly )
    local self = eObj

    if ( self:GetRedPhosphor() <= 0 ) or ( self:GetCrystalIodine() <= 0 ) then return end
    if not self:GetStatus() then return end

    local amount = ( self:GetRedPhosphor() + self:GetCrystalIodine() )

    self:EmitSound( 'ambient/levels/canals/toxic_slime_sizzle2.wav' )
    self:SetRedPhosphor( 0 )
    self:SetCrystalIodine( 0 )
    self:SetStatus( false )
    self:SetTime( Ambi.Metz.Config.final_pot_time )
	self:SetMaxTime( Ambi.Metz.Config.final_pot_time )

    local phosphor = ents.Create( 'metz_metz' )
    phosphor:SetPos( self:GetPos() + self:GetUp() * 12 )
    phosphor:SetAngles( self:GetAngles() )
    phosphor:Spawn()
    phosphor:GetPhysicsObject():SetVelocity( self:GetUp() * 2 ) 
    phosphor:SetAmount( amount )
end