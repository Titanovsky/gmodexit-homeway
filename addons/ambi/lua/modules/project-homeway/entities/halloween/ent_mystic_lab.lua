local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'mysticrp_lab'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Лаборатория'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Halloween'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props_lab/servers.mdl',
    date = '25.07.2022 19:41'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local UI = Ambi.Packages.Out( 'ui' )

    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        local pos = self:GetPos()
        local ang = self:GetAngles()
        ang:RotateAroundAxis( ang:Up(), 90 )

        if self:GetPos():Distance( LocalPlayer():GetPos() ) < 400 then
            cam.Start3D2D( pos + ang:Up() * 109 + ang:Right() * 12 + ang:Forward() * -21, ang + Angle( 0, 0, 90 ), 0.15 )
                draw.RoundedBox( 4, 0, 0, 280, 64, C.AMBI_RED )
                draw.SimpleText( 'Лаборатория Вирусов', UI.SafeFont( '32 Ambi' ), 6, 28, C.ABS_BLACK, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            cam.End3D2D()
        end
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, ENT.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )

    self:SetHealth( 150 )
    self:SetMaxHealth( 150 )

    self.open = true
end

function ENT:Use( ePly )
    if ( ePly:Job() != 'j_scientist' ) then ePly:ChatPrint( 'Вы не учёный!' ) return end
    if not self.open then ePly:ChatPrint( 'Подождите 2 минуты!' ) return end

    self.open = false

    local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis( ang:Up(), 90 )

    pos = pos + ang:Up() * 44 + ang:Right() * 24 + ang:Forward() * -4

    local virus = ents.Create( 'mysticrp_virus' )
    virus:Spawn()
    virus:SetPos( pos )

    timer.Simple( 120, function() 
        if IsValid( self ) then self.open = true end
    end )
end

function ENT:OnTakeDamage( damageInfo )
    self:SetHealth( self:Health() - damageInfo:GetDamage() )
    if ( self:Health() <= 0 ) then self:Remove() return end
end

Ents.Register( ENT.Class, 'ents', ENT )