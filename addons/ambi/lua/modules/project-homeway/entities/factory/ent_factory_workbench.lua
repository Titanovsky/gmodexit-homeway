local RegEntity, C = Ambi.Packages.Out( 'regentity, colors' )
local ENT = {}

ENT.Class       = 'factory_workbench'
ENT.Type	    = 'anim'

ENT.PrintName	= 'Workbench'
ENT.Author		= 'Ambi'
ENT.Category	= 'Homeway.Factory'
ENT.Spawnable   =  true

ENT.Stats = {
    type = 'Entity',
    module = 'Homeway',
    model = 'models/props_wasteland/controlroom_desk001b.mdl',
    date = '19.07.2024 21:07'
}

RegEntity.Register( ENT.Class, 'ents', ENT )

if CLIENT then
    local C, GUI, Draw, UI, CL = Ambi.Packages.Out( '@d, ContentLoader' )
    local W, H = ScrW(), ScrH()
    local DISTANCE = 600 * 600
    
    ENT.RenderGroup = RENDERGROUP_BOTH

    function ENT:DrawTranslucent()
        self:DrawShadow( false )

        if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > DISTANCE ) then return end

        local _,max = self:GetRotatedAABB(self:OBBMins(), self:OBBMaxs() )
        local rot = (self:GetPos() - EyePos()):Angle().yaw - 90
        local sin = math.sin(CurTime() * 8 + self:EntIndex()) / 3 + .5 -- EntIndex дает разницу в движении
        local center = self:LocalToWorld(self:OBBCenter())

        cam.Start3D2D(center + Vector(0, 0, math.abs(max.z / 2) + 24 + sin), Angle(0, rot, 90), 0.1)
            Draw.Box( 200, 54, -100, -20, C.HOMEWAY_BLACK, 6 )
            Draw.Box( 200 - 8, 54 - 8, -100 + 4, -20 + 4, C.HOMEWAY_BLUE_DARK, 8 )
            Draw.SimpleText( 4, 4, 'Верстак', UI.SafeFont( '40 Montserrat Medium' ), C.HOMEWAY_BLUE, 'center', 1, C.BLACK )
            Draw.Material( 64, 64, -30, -120, CL.Material( 'nav_icon8' ), C.HOMEWAY_BLUE )
        cam.End3D2D()
    end

    return RegEntity.Register( ENT.Class, 'ents', ENT )
end 

function ENT:Initialize()
    RegEntity.Initialize( self, self.Stats.model )
    RegEntity.Physics( self, MOVETYPE_VPHYSICS, SOLID_VPHYSICS, nil, true, true )
end

function ENT:Use( ePly )
    if not ePly:IsPlayer() then return end
    if self.reload then ePly:Notify( 'Верстак на подготовке к следующему оружию', 5, NOTIFY_ERROR ) return end
    if ePly.factory_weapon then ePly:Notify( 'Отнеси оружие на склад', 4, NOTIFY_ERROR ) return end
    if not ePly.factory_prefab then ePly:Notify( 'Сначала сделай заготовку', 4, NOTIFY_ERROR ) return end

    local info = Ambi.Homeway.Config.factory_items[ ePly.factory_prefab ]

    self:EmitSound( 'physics/metal/metal_box_impact_soft1.wav' )

    ePly:SendLua( 'Ambi.Homeway.LoadingMenu('..Ambi.Homeway.Config.factory_workbench_delay..')' )

    local ed = EffectData()
    ed:SetEntity( self )
    util.Effect( "entity_remove", ed, true, true )

    timer.Simple( Ambi.Homeway.Config.factory_workbench_delay, function()
        if not IsValid( ePly ) then return end
        if not ePly:Alive() then return end

        ePly.factory_weapon = ePly.factory_prefab
        ePly.factory_prefab = nil

        ePly:Notify( 'Ты скрафтил оружие, отнеси на склад', 6, 2 )
        ePly:EmitSound( 'physics/metal/metal_box_impact_soft3.wav' )
    end )

    self:StartReload()
end

function ENT:Reload()
    self.reload = false
    self:SetColor( C.ABS_WHITE )
end

function ENT:StartReload()
    self.reload = true
    self:SetColor( C.FLAT_RED )

    timer.Simple( Ambi.Homeway.Config.factory_workbench_delay, function()
        if IsValid( self ) then self:Reload() end
    end )
end

RegEntity.Register( ENT.Class, 'ents', ENT )