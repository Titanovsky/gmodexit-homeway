local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'fishing_rod'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Удочка'
ENT.Author		= 'Ambi'
ENT.Category	= 'Fishing'
ENT.Spawnable   = true

ENT.Stats = {
    type = 'Entity',
    module = 'Fishing',
    model = 'models/oldprops/fishing_rod.mdl',
    date = '07.06.2021 13:51:17'
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

    self.hook = ents.Create( 'fishing_hook' )
    self.hook:SetPos( self:GetPos() + Vector( 0, 0, 55 ) )
    self.hook:Spawn()
    self.hook.rod = self

    constraint.Rope( self, self.hook, 0, 0, Vector( 5, 0, 94 ), Vector( 0.1, 0.1, 3 ), 100, 2, 0, 0.4, 'cable/cable2' )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

function ENT:OnRemove()
    if self.hook and IsValid( self.hook ) then self.hook:Remove() end
end

Ents.Register( ENT.Class, 'ents', ENT )