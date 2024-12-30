local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'ent_youtubers'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Youtubers'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Pickups'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/maxofs2d/companion_doll.mdl',
    date = '09.09.2024 7:14'
}

Ents.Register( ENT.Class, 'ents', ENT )

local COLOR = Color(81, 173, 243)
local ANG = Angle(90,0,0)

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 1000 ^ 2
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:Initialize()
        self:SetAngles(ANG)
        self.OriginPos = self:GetPos()
	    self.Rotate = 0
	    self.RotateTime = RealTime()
        self.ang_pitch = math.random( -15, 15 )
    end

    function ENT:DrawTranslucent()
        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        --self:SetRenderOrigin(self.OriginPos + Vector( 0, 0, math.sin( RealTime() * 4 ) * 1.2 ) )
	    --self:SetupBones()

        self.Rotate = (RealTime() - self.RotateTime)*180 %360
	    self:SetAngles(Angle(90,-self.Rotate,0))

        local _,max = self:GetRotatedAABB(self:OBBMins(), self:OBBMaxs() )
        local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
        local sin = math.sin(CurTime() * 4 + self:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
        local center = self:LocalToWorld(self:OBBCenter())

        cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 12 + sin), Angle(0, rot, 90), 0.1)
            Draw.SimpleText( 4, 4, 'Наша Медийка', UI.SafeFont( '44 Montserrat Medium' ), C.RED, 'center', 1, C.BLACK )
        cam.End3D2D()
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, COLLISION_GROUP_WEAPON, false, true, false )
    self:SetAngles(Angle(90,0,0))
    self:SetTrigger( true )
    self:SetColor( COLOR )
end

function ENT:StartTouch( ePly )
    if not ePly:IsPlayer() then return end

    ePly:SendLua( 'local main = Ambi.Homeway.ShowF4Menu().main; Ambi.Homeway.ShowPagePromocodes( main )' )
end

Ents.Register( ENT.Class, 'ents', ENT )