local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'img'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Img'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Imgs'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/hunter/plates/plate2x2.mdl',
    date = '28.08.2024 10:36'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 1200

    CL.DownloadMaterial( 'hw_news', 'homeway/f4menu/hw_news.png', Ambi.Homeway.Config.news.preview_url )
    
    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

    function ENT:DrawTranslucent( nFlags )
        if ( LocalPlayer():GetPos():Distance( self:GetPos() ) > DISTANCE ) then return end

        self:Draw( nFlags )
        --self:DestroyShadow()

        local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
        local center = self:LocalToWorld(self:OBBCenter())

        local pos = self:GetPos()
        local ang = self:GetAngles()
        ang:RotateAroundAxis( ang:Up(), 90)

        cam.Start3D2D( pos + ang:Up() * 6, ang, 0.11 )
            Draw.Material( 1920, 1160, 0, 0, CL.Material( 'hw_news' ) )
        cam.End3D2D()
    end

    function ENT:Initialize()
        self:SetMaterial("models/effects/vol_light001")
        self:SetRenderMode(RENDERMODE_NONE)
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_NONE, SOLID_VPHYSICS, COLLISION_GROUP_WEAPON, true, true )

    self:SetMaterial( 'models/effects/vol_light001' )
    self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:DrawShadow(false)
end

Ents.Register( ENT.Class, 'ents', ENT )