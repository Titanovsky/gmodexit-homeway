local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'ent_pc'
ENT.Type	    = 'anim'

ENT.PrintName	= 'PC'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props/cs_office/computer.mdl',
    date = '16.08.2024 10:29'
}

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 800 * 800
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) <= DISTANCE ) then
            local _,max = self:GetRotatedAABB(self:OBBMins(), self:OBBMaxs() )
            local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
            local sin = math.sin(CurTime() * 4 + self:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
            local center = self:LocalToWorld(self:OBBCenter())

            cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 6 + sin), Angle(0, rot, 90), 0.1)
                Draw.SimpleText( -25, 4, 'Компьютер #'..self:EntIndex(), UI.SafeFont( '32 Montserrat SemiBold' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )
            cam.End3D2D()
        end
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, self.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not Ambi.ComputerClub.GetCurrentGame() then ePly:Notify( 'Подождите '..math.floor( timer.TimeLeft( 'Ambi.Homeway.StartGame' ) / 60 )..' минут!', 6, NOTIFY_ERROR ) return end

    --ePly:SendLua( 'Ambi.Homeway.ShowPCMenu()' ) -- todo

    Ambi.ComputerClub.PrepareStartPlayer( ePly )
end

Ents.Register( ENT.Class, 'ents', ENT )