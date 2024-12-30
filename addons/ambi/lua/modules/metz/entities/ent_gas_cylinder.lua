local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'metz_gas_cylinder'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Газовый Балон'
ENT.Author		= 'Ambi'
ENT.Category	= 'Metz'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Metz',
    date = '02.07.2022 01:40'
}

Ents.Register( ENT.Class, 'ents', ENT )

if SERVER then
    function ENT:Initialize()
        Ents.Initialize( self, Ambi.Metz.Config.gas_model )
        Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

        Ambi.Metz.GasCylinderInitialize( self )
    end

    function ENT:OnTakeDamage( dmgInfo )
        Ambi.Metz.GasCylinderTakeDamage( self, dmgInfo )
    end

    function ENT:StartTouch( eObj )
        Ambi.Metz.GasCylinderStartTouch( self, eObj )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

ENT.RenderGroup = RENDERGROUP_BOTH

local MAT_LASER = Material( 'cable/cable' )
local COL_WHITE_TEXT = Color( 255, 255, 255 )
local COL_BLACK = Color( 0, 0, 0, 200 )
local UI = Ambi.Packages.Out( 'ui' )

function ENT:Draw()
    self:DrawModel()
    self:DrawShadow( false )

	local pos = self:GetPos()
    local up = self:GetUp()
	local ang = self:GetAngles()

    if not self:CheckDistance( LocalPlayer(), Ambi.Metz.Config.draw_distance ) then return end

	ang:RotateAroundAxis( ang:Up(), 0 )
	ang:RotateAroundAxis( ang:Forward(), 0 )
	ang:RotateAroundAxis( ang:Right(), -90 )

    render.SetMaterial( MAT_LASER )
    render.DrawBeam( pos + ( up * 28 ), pos + ( up * 42 ), 1, 1, 1, COL_WHITE_TEXT )

    cam.Start3D2D( pos + ang:Up() * 4.75, ang, 0.1 )
        surface.SetDrawColor( COL_BLACK )
        surface.DrawRect( -176, -12, 450, 24 )

        local text = self.nw_amount

        surface.SetDrawColor( Ambi.Metz.Config.gas_text_color )
        --surface.DrawRect( -173, -9, width, 18 )
        draw.SimpleTextOutlined( text, UI.SafeFont( '15 Arial' ), -170, -7, COL_WHITE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, COL_BLACK )
    cam.End3D2D()
end

Ents.Register( ENT.Class, 'ents', ENT )