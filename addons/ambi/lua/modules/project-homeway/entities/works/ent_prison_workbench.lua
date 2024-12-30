local Ents, NW, C = Ambi.RegEntity, Ambi.NW, Ambi.General.Global.Colors
local ENT = {}

ENT.Class       = 'prison_workbench'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Prison Workbench'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Works'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props_c17/TrapPropeller_Engine.mdl',
    date = '09.09.2024 12:06'
}

function ENT:GetReady()
    return self.nw_Ready
end

Ents.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI = Ambi.Packages.Out( '@d' )
    local DISTANCE = 450

    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

    function ENT:DrawTranslucent( nFlags )
        self:DrawShadow( false )
        self:Draw( nFlags )

        if ( LocalPlayer():GetPos():Distance( self:GetPos() ) > DISTANCE ) then return end

        local _,max = self:GetRotatedAABB(self:OBBMins(), self:OBBMaxs() )
        local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
        local sin = math.sin(CurTime() * 4 + self:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
        local center = self:LocalToWorld(self:OBBCenter())

        cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 13 + sin), Angle(0, rot, 90), 0.1)
            Draw.SimpleText( 4, 4, 'Изготовитель', UI.SafeFont( '32 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )
        cam.End3D2D()
    end

    function ENT:Initialize()
        self:SetRenderMode( 1 )
    end

    return Ents.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    Ents.Initialize( self, ENT.Stats.model )
    Ents.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
    self:SetRenderMode( 1 )
    self:SetReady( true )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if not ePly:IsArrested() then ePly:Notify( 'Эта работа только для заключённых', 4, NOTIFY_ERROR ) return end
    if not self:GetReady() then ePly:Notify( 'Машиной ещё нельзя пользоваться', 3, NOTIFY_ERROR ) return end

    self:EmitSound( 'physics/metal/metal_box_impact_soft3.wav' )

    ePly.metal_planks = ( ePly.metal_planks or 0 ) + 1
    ePly:Notify( 'Вы обработали металл. конструкцию, отнесите на склад', 4, NOTIFY_SUCCESS )

    self:SetReady( false )

    timer.Simple( Ambi.Homeway.Config.prison_work.delay, function()
        if not IsValid( self ) then return end

        self:SetReady( true )
    end )
end

function ENT:SetReady( bReady )
    self.nw_Ready = bReady

    self:SetColor( Color( 255, 255, 255, bReady and 255 or 200 ) )
end

Ents.Register( ENT.Class, 'ents', ENT )