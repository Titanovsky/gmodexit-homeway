local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'metz_iodine_jar'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Сосуд для Пластилина'
ENT.Author		= 'Ambi'
ENT.Category	= 'Metz'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Metz',
    date = '04.07.2022 17:05'
}

function ENT:GetWater()
    return self.nw_water
end

function ENT:GetLiquidIodine()
    return self.nw_liquid_iodine
end

Ents.Register( ENT.Class, 'ents', ENT )

if SERVER then
    function ENT:Initialize()
        Ents.Initialize( self, Ambi.Metz.Config.iodine_jar_model )
        Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

        Ambi.Metz.IodineJarInitialize( self )
    end

    function ENT:OnTakeDamage( dmgInfo )
        Ambi.Metz.IodineJarTakeDamage( self, dmgInfo )
    end

    function ENT:Use( ePly )
        Ambi.Metz.IodineJarUse( self, ePly )
    end

    function ENT:SetWater( nCount )
        self.nw_water = nCount
    end

    function ENT:SetLiquidIodine( nCount )
        self.nw_liquid_iodine = nCount
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

ENT.RenderGroup = RENDERGROUP_BOTH

local COL_WHITE_TEXT = Color( 255, 255, 255 )
local COL_BLACK = Color( 0, 0, 0, 200 )
local COLOR_SUB_BLACK = Color( 100, 100, 100, 255 )
local UI = Ambi.Packages.Out( 'ui' )

function ENT:Draw()
    self:DrawModel()
    self:DrawShadow( false )

	local pos = self:GetPos()
    local up = self:GetUp()
	local ang = self:GetAngles()

    if not self:GetWater() then return end
    if not self:CheckDistance( LocalPlayer(), Ambi.Metz.Config.draw_distance ) then return end

    ang:RotateAroundAxis( ang:Up(), 90 )
	ang:RotateAroundAxis( ang:Forward(), 90 )

	cam.Start3D2D( pos + ang:Up() * 5, ang, 0.10 )
		surface.SetDrawColor( COL_BLACK )
		surface.DrawRect( -64, -38, 128, 44 )
	cam.End3D2D()

	cam.Start3D2D(pos + ang:Up()*5, ang, 0.055)
		draw.SimpleTextOutlined( 'Банка', UI.SafeFont( '20 Arial' ), 0, -56, COL_WHITE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
		draw.SimpleTextOutlined( "_______________________________", UI.SafeFont( '15 Arial' ), 0, -48, COL_WHITE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
	cam.End3D2D()

    local color1 = ( self:GetLiquidIodine() == 0 ) and COLOR_SUB_BLACK or Ambi.Metz.Config.ingredient_liquid_iodine_color
    local color2 = ( self:GetWater() == 0 ) and COLOR_SUB_BLACK or Ambi.Metz.Config.ingredient_water_color

	cam.Start3D2D( pos + ang:Up() * 5, ang, 0.045 )
		draw.SimpleTextOutlined( "Жидкий Пластилин ["..self:GetLiquidIodine().."]", UI.SafeFont( '20 Arial' ), -130, -30, color1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
		draw.SimpleTextOutlined( "Вода ["..self:GetWater().."]", UI.SafeFont( '20 Arial' ), -130, -8, color2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
	cam.End3D2D()
end

Ents.Register( ENT.Class, 'ents', ENT )