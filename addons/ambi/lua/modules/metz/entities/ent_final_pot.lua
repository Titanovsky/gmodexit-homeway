local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'metz_final_pot'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Кастрюля для MetZ'
ENT.Author		= 'Ambi'
ENT.Category	= 'Metz'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Metz',
    date = '04.07.2022 17:31'
}

function ENT:GetTime()
    return self.nw_time
end

function ENT:GetMaxTime()
    return self.nw_max_time
end

function ENT:GetStatus()
    return self.nw_status
end

function ENT:GetRedPhosphor()
    return self.nw_red_phosphor
end

function ENT:GetCrystalIodine()
    return self.nw_crystal_iodine
end

Ents.Register( ENT.Class, 'ents', ENT )

if SERVER then
    function ENT:Initialize()
        Ents.Initialize( self, Ambi.Metz.Config.final_pot_model )
        Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

        Ambi.Metz.FinalPotInitialize( self )
    end

    function ENT:OnTakeDamage( dmgInfo )
        Ambi.Metz.FinalPotTakeDamage( self, dmgInfo )
    end

    function ENT:Use( ePly )
        Ambi.Metz.FinalPotUse( self, ePly )
    end

    function ENT:SetStatus( nStatus )
        self.nw_status = nStatus
    end

    function ENT:SetTime( nTime )
        self.nw_time = nTime
    end

    function ENT:SetMaxTime( nTime )
        self.nw_max_time = nTime
    end

    function ENT:SetRedPhosphor( nCount )
        self.nw_red_phosphor = nCount
    end
    
    function ENT:SetCrystalIodine( nCount )
        self.nw_crystal_iodine = nCount
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

ENT.RenderGroup = RENDERGROUP_BOTH

local COL_WHITE_TEXT = Color( 255, 255, 255 )
local COL_BLACK = Color( 0, 0, 0, 200 )
local COLOR_RED = Color(175, 0, 0, 255)
local COLOR_SUB_BLACK = Color( 100, 100, 100, 255 )
local UI = Ambi.Packages.Out( 'ui' )

function ENT:Draw()
    self:DrawModel()
    self:DrawShadow( false )

    if not self:GetTime() then return end -- моделька рендерится быстрее, чем сервер присваивает значение этой энтити
    if not self:CheckDistance( LocalPlayer(), Ambi.Metz.Config.draw_distance ) then return end

	local pos = self:GetPos()
	local ang = self:GetAngles()

	local potTime = self:GetStatus() and 'Готово!' or 'Время: '..self:GetTime()

	ang:RotateAroundAxis( ang:Up(), 90 )
	ang:RotateAroundAxis(ang:Forward(), 90 )

    cam.Start3D2D( pos + ang:Up()*8, ang, 0.10 )
        surface.SetDrawColor( COL_BLACK )
        surface.DrawRect( -64, -38, 128, 60 )
    cam.End3D2D()

    cam.Start3D2D( pos + ang:Up() * 8, ang, 0.055 )
        draw.SimpleTextOutlined( 'Metz', UI.SafeFont( '20 Arial' ), 0, -56, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
        draw.SimpleTextOutlined( '________________________________', UI.SafeFont( '15 Arial' ), 0, -48, C.ABS_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )

        surface.SetDrawColor( COL_BLACK )
        surface.DrawRect( -104, -32, 204, 24 )
    cam.End3D2D()

    local color1 = ( self:GetRedPhosphor() == 0 ) and COLOR_SUB_BLACK or Ambi.Metz.Config.ingredient_red_phosphor_color
    local color2 = ( self:GetCrystalIodine() == 0 ) and COLOR_SUB_BLACK or Ambi.Metz.Config.ingredient_crystal_iodine_color

    cam.Start3D2D( pos + ang:Up() * 8, ang, 0.040 )
        draw.SimpleTextOutlined( "Кровавая Мэри ["..self:GetRedPhosphor().."]", UI.SafeFont( '20 Arial' ), -154, 10, color1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
        draw.SimpleTextOutlined( "Прочный Пластилин ["..self:GetCrystalIodine().."]", UI.SafeFont( '20 Arial' ), -154, 34, color2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
    cam.End3D2D()

    cam.Start3D2D( pos + ang:Up() * 8, ang, 0.035 )
        draw.SimpleTextOutlined( potTime, UI.SafeFont( '20 Arial' ), -152, -32, C.ABS_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, C.ABS_BLACK )
    cam.End3D2D()
end

Ents.Register( ENT.Class, 'ents', ENT )