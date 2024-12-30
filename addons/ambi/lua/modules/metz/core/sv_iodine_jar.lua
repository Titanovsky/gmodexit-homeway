function Ambi.Metz.IodineJarInitialize( self )
    self:SetWater( 0 )
    self:SetLiquidIodine( 0 )
    self:SetHealth( Ambi.Metz.Config.iodine_jar_health )
    self:SetMaxHealth( Ambi.Metz.Config.iodine_jar_health )
    self:SetMaterial( Ambi.Metz.Config.iodine_jar_material )
    self:SetColor( Ambi.Metz.Config.iodine_jar_color )
end

function Ambi.Metz.IodineJarTakeDamage( eObj, dmgInfo )
    if not Ambi.Metz.Config.iodine_jar_can_take_damage then return end

    local self = eObj

    self:SetHealth( self:Health() - dmgInfo:GetDamage() )

    if ( self:Health() <= 0 ) then 
        self:Remove() 
    end
end

function Ambi.Metz.IodineJarUse( self, ePly )
    if ( self:GetWater() <= 0 ) or ( self:GetLiquidIodine() <= 0 ) then return end

    local amount = ( self:GetWater() + self:GetLiquidIodine() )

    self:EmitSound( 'ambient/levels/canals/toxic_slime_sizzle2.wav' )
    self:SetWater( 0 )
    self:SetLiquidIodine( 0 )

    local ent = ents.Create( 'metz_crystal_iodine' )
    ent:SetPos( self:GetPos() + self:GetUp() * 12 )
    ent:SetAngles( self:GetAngles() )
    ent:Spawn()
    ent:GetPhysicsObject():SetVelocity( self:GetUp() * 2 ) 
    ent:SetAmount( amount )

    self:Remove()
end