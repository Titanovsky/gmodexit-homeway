local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'ent_donate'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Донат'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Pickups'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/windingduke77/icons/lighting bolt.mdl',
    date = '16.08.2024 10:40'
}

local COLOR = Color( 127, 255, 0, 255 )
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
	    self:SetAngles(Angle(90,self.Rotate,0))
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

    ePly:SendLua( 'IGS.UI()' )
end

Ents.Register( ENT.Class, 'ents', ENT )