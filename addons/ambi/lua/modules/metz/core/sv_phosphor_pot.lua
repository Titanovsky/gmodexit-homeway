function Ambi.Metz.PotInitialize( self )
    self:SetStatus( false )
    self:SetSulfur( 0 )
    self:SetMacid( 0 )
    self:SetTime( Ambi.Metz.Config.pot_start_time )
	self:SetMaxTime( Ambi.Metz.Config.pot_start_time )
    self:SetHealth( Ambi.Metz.Config.pot_health )
end

function Ambi.Metz.PotTakeDamage( eObj, dmgInfo )
    if not Ambi.Metz.Config.pot_can_take_damage then return end

    local self = eObj

    self:SetHealth( self:Health() - dmgInfo:GetDamage() )

    if ( self:Health() <= 0 ) then 
        self:StartVisualEffect()
        self:Remove() 
    end
end

function Ambi.Metz.PotUse( self, ePly )
    if ( self:GetSulfur() <= 0 ) or ( self:GetMacid() <= 0 ) then return end
    if ( self:GetTime() > 1 ) then return end

    local amount = ( self:GetMacid() + self:GetSulfur() )

    self:EmitSound( 'ambient/levels/canals/toxic_slime_sizzle2.wav' )
    self:SetStatus( false )
    self:SetSulfur( 0 )
    self:SetMacid( 0 )
    self:SetTime( Ambi.Metz.Config.pot_start_time )
	self:SetMaxTime( Ambi.Metz.Config.pot_start_time )

    local phosphor = ents.Create( 'metz_red_phosphor' )
    phosphor:SetPos( self:GetPos() + self:GetUp() * 12 )
    phosphor:SetAngles( self:GetAngles() )
    phosphor:Spawn()
    phosphor:GetPhysicsObject():SetVelocity( self:GetUp() * 2 ) 
    phosphor:SetAmount( amount )
end