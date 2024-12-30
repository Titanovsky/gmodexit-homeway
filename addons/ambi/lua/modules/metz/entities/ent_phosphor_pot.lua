local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'metz_phosphor_pot'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Кастрюля для Мэри'
ENT.Author		= 'Ambi'
ENT.Category	= 'Metz'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Metz',
    date = '04.07.2022 08:36'
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

function ENT:GetSulfur()
    return self.nw_sulfur
end

function ENT:GetMacid()
    return self.nw_macid
end

Ents.Register( ENT.Class, 'ents', ENT )

if SERVER then
    function ENT:Initialize()
        Ents.Initialize( self, Ambi.Metz.Config.pot_model )
        Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

        Ambi.Metz.PotInitialize( self )
    end

    function ENT:OnTakeDamage( dmgInfo )
        Ambi.Metz.PotTakeDamage( self, dmgInfo )
    end

    function ENT:Use( ePly )
        Ambi.Metz.PotUse( self, ePly )
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

    function ENT:SetSulfur( nSulfur )
        self.nw_sulfur = nSulfur
    end

    function ENT:SetMacid( nMacid )
        self.nw_macid = nMacid
    end

    function ENT:StartVisualEffect()
        local pos = self:GetPos()

        local effectData = EffectData()
        effectData:SetStart( pos )
        effectData:SetOrigin( pos )
        effectData:SetScale( 8 )
        util.Effect( 'GlassImpact', effectData, true, true )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end

ENT.RenderGroup = RENDERGROUP_BOTH

local COL_WHITE_TEXT = Color( 255, 255, 255 )
local COL_BLACK = Color( 0, 0, 0, 200 )
local macidColor = Color(160, 221, 99, 255)
local sulfurColor = Color(243, 213, 19, 255)
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

	local potTime = self:GetStatus() and 'Готово!' or 'Время: '..tostring( self:GetTime() )

	ang:RotateAroundAxis( ang:Up(), 90 )
	ang:RotateAroundAxis( ang:Forward(), 90 )

    cam.Start3D2D( pos + ang:Up() * 4.64, ang, 0.10 )
        surface.SetDrawColor( COL_BLACK )
        surface.DrawRect( 0, -38, 90, 64 )
    cam.End3D2D()

    local color1 = ( self:GetMacid() == 0 ) and COLOR_SUB_BLACK or macidColor
    local color2 = ( self:GetSulfur() == 0 ) and COLOR_SUB_BLACK or sulfurColor

    cam.Start3D2D( pos + ang:Up() * 4.64, ang, 0.055 )
        draw.SimpleTextOutlined( 'Кровавая Мэри', UI.SafeFont( '15 Ambi' ), 80, -56, COLOR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, COL_BLACK )
        draw.SimpleTextOutlined( '__________________________', UI.SafeFont( '15 Ambi' ), 80, -45, COL_WHITE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, COL_BLACK )

        surface.SetDrawColor( COL_BLACK )
        surface.DrawRect( 20, -32, 124, 24 )
        surface.SetDrawColor( COLOR_RED )
        surface.DrawRect( 22, -30, 124 - 6, 20 )

        draw.SimpleTextOutlined( 'Спрайт ['..self:GetMacid()..']', UI.SafeFont( '18 Ambi' ), 4, 10, color1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, COL_BLACK )
        draw.SimpleTextOutlined( 'Мёд ['..self:GetSulfur()..']', UI.SafeFont( '18 Ambi' ), 4, 30, color2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, COL_BLACK )
    cam.End3D2D()

    cam.Start3D2D( pos + ang:Up() * 4.60, ang, 0.035 )
        draw.SimpleTextOutlined( potTime, UI.SafeFont( '20 Ambi' ), 40, -32, COL_WHITE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, COL_BLACK )
    cam.End3D2D()
end

Ents.Register( ENT.Class, 'ents', ENT )