local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'fishing_bait'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Наживка'
ENT.Author		= 'Ambi'
ENT.Category	= 'Fishing'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'Entity',
    module = 'Fishing',
    model = 'models/detonatress/worm/earthworm.mdl',
    date = '07.06.2021 14:09:50'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    ENT.RenderGroup = AMB.Ambition.Global.RENDER

    function ENT:DrawTranslucent()
        self:DrawShadow( false )
    end
    
    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, ENT.Stats.model )
    Ents.Physics( self, nil, nil, nil, true, false )
    self:SetHealth( 100 )
end

function ENT:SetBait( sBait )
    local bait = AMB.Fishing.GetBait( sBait )
    if not bait then return end

    self.bait = sBait
    self:SetModel( bait.model )
    self:SetModelScale( bait.scale )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:GetPhysicsObject():EnableMotion( true )
    self:GetPhysicsObject():Wake()
    self:SetMaterial( bait.mat )
    self:SetColor( bait.color )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:OnRemove()
    if self.hook and IsValid( self.hook ) then self.hook.occupaited = false end
    if not self.ready then return end

    timer.Remove( 'AmbFishingBait:'..tostring( self ) )
end

Ents.Register( ENT.Class, 'ents', ENT )