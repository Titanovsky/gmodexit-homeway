local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'ent_rainbow_kit_repair'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Kit Repair'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.RainbowPrinters'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props_lab/box01a.mdl',
    date = '16.08.2024 21:05'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 400 * 400
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) <= DISTANCE ) then return end

        self:DrawShadow( false )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( 50 )
    self:SetColor( Color(242,242,41) )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
end

function ENT:StartTouch( eObj )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    
    if ( self:Health() <= 0 ) then self:Remove() return end
end

Ents.Register( ENT.Class, 'ents', ENT )